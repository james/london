# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "leaflet" # @1.9.4
pin "@maptiler/leaflet-maptilersdk", to: "@maptiler--leaflet-maptilersdk.js" # @2.0.0
pin "@maptiler/client", to: "@maptiler--client.js" # @1.8.1
pin "@maptiler/sdk", to: "@maptiler--sdk.js" # @1.2.1
pin "events" # @3.3.0
pin "js-base64" # @3.7.7
pin "maplibre-gl" # @3.6.2
pin "quick-lru" # @7.0.0
pin "uuid" # @9.0.1
