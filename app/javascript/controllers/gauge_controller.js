import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        percentage: Number
    }

    connect() {
        this.animateGauge();
    }

    animateGauge() {
        const percentage = this.percentageValue;
        const needle = this.element.querySelector('.gauge-needle');

        // Gauge goes from -90deg (0%) to 90deg (100%)
        // So we map 0-100% to -90 to 90 degrees
        const targetAngle = -90 + (percentage * 1.8);

        // Animate from -90 (start position) to target
        let currentAngle = -90;
        const duration = 1000; // 1 second
        const startTime = performance.now();

        const animate = (currentTime) => {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);

            // Easing function for smooth animation
            const easeOutCubic = 1 - Math.pow(1 - progress, 3);

            currentAngle = -90 + (targetAngle + 90) * easeOutCubic;
            needle.style.transform = `rotate(${currentAngle}deg)`;

            if (progress < 1) {
                requestAnimationFrame(animate);
            }
        };

        requestAnimationFrame(animate);
    }
}
