import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// ✅ Register your controller
import GuestLocationController from "./controllers/guest_location_controller"
application.register("guest-location", GuestLocationController)

export { application }
