import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
import "@maptiler/leaflet-maptilersdk";
export default class extends Controller {
    connect() {
        const latitude = this.element.dataset.mapLatitude;
        const longitude = this.element.dataset.mapLongitude;

        this.map = L.map(this.element.querySelector('#map')).setView([latitude, longitude], 14);
        this.map.options.minZoom = 6;
        this.map.options.maxZoom = 18;

        this.map.setMaxBounds(L.latLngBounds(L.latLng(50, -7.5), L.latLng(56, 2)));

        const mtLayer = new L.MaptilerLayer({
            apiKey: "vPTKvn3quFUGwtEkShs8",
            style: "85105982-deff-46dc-879f-70b866a06391"
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
        this.line = L.polyline(latlngs, { color: 'blue', dashArray: '5, 10' }).addTo(this.map);

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
