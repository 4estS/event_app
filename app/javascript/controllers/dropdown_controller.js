import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(e) {
    e.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  close() {
    if (!this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.add("hidden")
    }
  }

  escape(e) {
    if (e.key === "Escape") this.close()
  }
}
