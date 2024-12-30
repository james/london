import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
export default class extends Controller {
    connect() {
        const latitude = this.element.dataset.mapLatitude;
        const longitude = this.element.dataset.mapLongitude;

        var map = L.map(this.element).setView([latitude, longitude], 13);

        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
        
        L.marker([latitude, longitude]).addTo(map);
    }
}
