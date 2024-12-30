import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
export default class extends Controller {
    connect() {
        const latitude = this.element.dataset.mapLatitude;
        const longitude = this.element.dataset.mapLongitude;

        this.map = L.map(this.element.querySelector('#map')).setView([latitude, longitude], 13);
        
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(this.map);
        
        L.marker([latitude, longitude]).addTo(this.map);
    }

    showArea(event) {
        if (this.currentGeojsonLayer) {
            this.map.removeLayer(this.currentGeojsonLayer);
        }

        this.currentGeojsonLayer = L.geoJSON(JSON.parse(event.currentTarget.dataset.geojson));
        this.currentGeojsonLayer.addTo(this.map);
        this.map.fitBounds(this.currentGeojsonLayer.getBounds());
    }
}
