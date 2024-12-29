import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
export default class extends Controller {
    connect() {
        var map = L.map(this.element).setView([51.505, -0.09], 13);

        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
        
        L.marker([51.5, -0.09]).addTo(map)
    }
}
