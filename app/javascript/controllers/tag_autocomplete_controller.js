// app/javascript/controllers/tag_autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"

/**
 * @controller tag-autocomplete
 */

export default class extends Controller {
  static targets = ["input", "suggestions", "selected"]

  connect() {
    this.selectedTags = new Set()
  }

  search() {
    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.suggestionsTarget.innerHTML = ""
      return
    }

    fetch(`/tags/autocomplete?q=${encodeURIComponent(query)}`, {
      headers: { Accept: "text/vnd.turbo-stream.html" }
    })
      .then(response => response.text())
      .then(html => {
        this.suggestionsTarget.innerHTML = html
      })
  }

  select(event) {
    const tagId = event.target.dataset.tagId
    const tagName = event.target.dataset.tagName

    if (this.selectedTags.size >= 5 || this.selectedTags.has(tagId)) return

    const tagElement = document.createElement("div")
    tagElement.className = "inline-block bg-blue-100 text-blue-800 rounded px-2 py-1 m-1 text-sm"
    tagElement.innerText = tagName

    const hiddenField = document.createElement("input")
    hiddenField.type = "hidden"
    hiddenField.name = "event[tag_ids][]"
    hiddenField.value = tagId
    tagElement.appendChild(hiddenField)

    this.selectedTarget.appendChild(tagElement)
    this.selectedTags.add(tagId)

    this.inputTarget.value = ""
    this.suggestionsTarget.innerHTML = ""
  }
}
