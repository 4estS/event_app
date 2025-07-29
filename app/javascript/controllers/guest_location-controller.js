import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "form"]

  connect() {
    const savedLocation = localStorage.getItem("guestLocation")
    if (savedLocation && !this.inputTarget.value) {
      this.inputTarget.value = savedLocation
      this.formTarget?.requestSubmit()
    }
  }

  saveLocation(event) {
    const location = this.inputTarget.value.trim()
    if (location.length > 0) {
      localStorage.setItem("guestLocation", location)
      // fallback if JS is blocking submission
      this.element.requestSubmit()
    }
  }
}