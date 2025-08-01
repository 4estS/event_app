import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions"]
  static values = { accessToken: String }

  timeout = null

  connect() {
    this.abortController = null
  }

  search() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      const query = this.inputTarget.value
      if (query.length < 3) return

      if (this.abortController) this.abortController.abort()
      this.abortController = new AbortController()

      fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(query)}.json?access_token=${this.accessTokenValue}&country=us&limit=5`, {
        signal: this.abortController.signal,
        headers: { "Accept": "application/json" }
      })
        .then(response => response.json())
        .then(data => {
          this.suggestionsTarget.innerHTML = data.features.map(feature => {
            return `
              <button type="button"
                      data-action="click->address-lookup#select"
                      data-location='${JSON.stringify(feature)}'>
                ${feature.place_name}
              </button>
            `
          }).join("")
        })
        .catch(() => {})
    }, 300)
  }

  select(event) {
    const feature = JSON.parse(event.currentTarget.dataset.location)
    this.inputTarget.value = feature.place_name

    const hiddenField = document.querySelector("#event_location")
    if (hiddenField) hiddenField.value = feature.place_name

    this.suggestionsTarget.innerHTML = ""
  }
}
