import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
import "@maptiler/leaflet-maptilersdk";
export default class extends Controller {
    connect() {
        const latitude = this.element.dataset.mapLatitude;
        const longitude = this.element.dataset.mapLongitude;

        this.map = L.map(this.element.querySelector('#map')).setView([latitude, longitude], 13);
        const mtLayer = new L.MaptilerLayer({
            apiKey: "vPTKvn3quFUGwtEkShs8",
            style: "85105982-deff-46dc-879f-70b866a06391"
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
