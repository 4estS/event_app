// app/javascript/controllers/ticket_url_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ticketUrl"]

  connect() {
    this.toggle()
  }

  toggle() {
    const selectedType = this.element.querySelector("input[name='event[event_type]']:checked")?.value
    if (selectedType === "ticket_required") {
      this.ticketUrlTarget.classList.remove("hidden")
    } else {
      this.ticketUrlTarget.classList.add("hidden")
    }
  }
}
