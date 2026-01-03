import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'

export default class extends Controller {
    connect() {
        const latitude = this.element.dataset.mapLatitude;
        const longitude = this.element.dataset.mapLongitude;

        this.map = L.map(this.element.querySelector('#map'), {
            scrollWheelZoom: false,
            dragging: true,
            tap: false
        }).setView([latitude, longitude], 14);
        this.map.options.minZoom = 6;
        this.map.options.maxZoom = 18;

        this.map.setMaxBounds(L.latLngBounds(L.latLng(50, -7.5), L.latLng(56, 2)));

        // Handle touch interactions - only allow two-finger gestures
        const mapElement = this.element.querySelector('#map');
        mapElement.addEventListener('touchstart', (e) => {
            if (e.touches.length === 1) {
                // Single finger touch - prevent map interaction to allow page scroll
                e.preventDefault();
                this.map.dragging.disable();
            } else if (e.touches.length >= 2) {
                // Two or more fingers - allow map interaction
                this.map.dragging.enable();
            }
        }, { passive: false });

        mapElement.addEventListener('touchend', (e) => {
            if (e.touches.length < 2) {
                // Less than two fingers remaining - disable dragging
                this.map.dragging.disable();
            }
        });

        mapElement.addEventListener('touchmove', (e) => {
            if (e.touches.length === 1) {
                // Single finger - allow page scroll, prevent map pan
                this.map.dragging.disable();
            }
        });

        // Stadia Alidade Smooth vector tiles
        L.tileLayer('https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png?api_key=ba014b6b-df00-4e55-934d-8a5989d21c57', {
            attribution: '&copy; <a href="https://stadiamaps.com/">Stadia Maps</a>, &copy; <a href="https://openmaptiles.org/">OpenMapTiles</a> &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors',
            maxZoom: 20
        }).addTo(this.map);

        this.userMarker = L.marker([latitude, longitude]).addTo(this.map);
    }

    showArea(event) {
        this.clearMap();
        this.currentGeojsonLayer = L.geoJSON(JSON.parse(event.currentTarget.dataset.geojson));
        this.currentGeojsonLayer.addTo(this.map);
        this.map.fitBounds(this.currentGeojsonLayer.getBounds());
    }

    showPoint(event) {
        this.clearMap();
        const [longitude, latitude] = JSON.parse(event.currentTarget.dataset.geopoint).coordinates;
        this.placeMarker = L.marker([latitude, longitude]);
        this.placeMarker.addTo(this.map);

        const latlngs = [
            [this.element.dataset.mapLatitude, this.element.dataset.mapLongitude],
            [latitude, longitude]
        ];
        this.line = L.polyline(latlngs, { color: '#B11226', dashArray: '5, 10', weight: 3 }).addTo(this.map);

        this.map.fitBounds(this.line.getBounds());
    }

    clearMap() {
        if (this.currentGeojsonLayer) {
            this.map.removeLayer(this.currentGeojsonLayer);
        }
        if (this.placeMarker) {
            this.map.removeLayer(this.placeMarker);
        }
        if (this.line) {
            this.map.removeLayer(this.line);
        }
    }
}
