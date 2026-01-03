import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["submit"]

    submit(event) {
        // Disable the submit button to prevent double submissions
        this.submitTarget.disabled = true;
        this.submitTarget.value = "Submitting...";
    }
}
