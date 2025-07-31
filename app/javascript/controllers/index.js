// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import TagLimitController from "./tag-limit_controller"
application.register("tag-limit", TagLimitController)

import GuestLocationController from "./guest_location_controller"
application.register("guest-location", GuestLocationController)

import TagAutocompleteController from "./tag_autocomplete_controller"
application.register("tag-autocomplete", TagAutocompleteController)