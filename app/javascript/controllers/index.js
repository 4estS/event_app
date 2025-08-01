// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)

import GuestLocationController from "./guest_location_controller"
application.register("guest-location", GuestLocationController)

import TagAutocompleteController from "./tag_autocomplete_controller"
application.register("tag-autocomplete", TagAutocompleteController)

import AddressLookupController from "./address_lookup_controller"
application.register("address-lookup", AddressLookupController)

import TicketUrlController from "./ticket_url_controller"
application.register("ticket-url", TicketUrlController)
