// app/javascript/controllers/tag_autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions", "tokenTemplate"]

  connect() {
    this.selectedTags = new Map()

    // Initialize selected tags from existing hidden inputs
      this.element.querySelectorAll("[data-token-hidden]").forEach((input) => {
        this.selectedTags.set(input.value, true)
      })

    this.activeIndex = -1
  }

  focusInput() {
    this.inputTarget.focus()
  }

  search() {
    const query = this.inputTarget.value.trim()

    if (query.length < 1) {
      this.clearSuggestions()
      return
    }

    fetch(`/tags/autocomplete?q=${encodeURIComponent(query)}`, {
      headers: { Accept: "text/vnd.turbo-stream.html" }
    })
      .then(r => r.text())
      .then(html => {
        this.suggestionsTarget.innerHTML = html
        this.activeIndex = -1
        this.highlightActive()
      })
  }

  navigate(event) {
    const items = this.suggestionsTarget.querySelectorAll("[data-tag-id]")
    if (items.length === 0) return

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.activeIndex = (this.activeIndex + 1) % items.length
        break
      case "ArrowUp":
        event.preventDefault()
        this.activeIndex = (this.activeIndex - 1 + items.length) % items.length
        break
      case "Enter":
      case "Tab":
        if (items.length > 0) {
          event.preventDefault()
          const indexToUse = this.activeIndex === -1 ? 0 : this.activeIndex
          items[indexToUse].click()
        }
        break
    }

    this.highlightActive()
  }

  highlightActive() {
    const items = this.suggestionsTarget.querySelectorAll("[data-tag-id]")
    items.forEach((el, i) => {
      el.classList.toggle("bg-blue-100", i === this.activeIndex)
    })
  }

  select(event) {
    const tagId = event.target.dataset.tagId
    const tagName = event.target.dataset.tagName

    if (this.selectedTags.has(tagId) || this.selectedTags.size >= 5) return

    this.selectedTags.set(tagId, tagName)
    const token = this.tokenTemplateTarget.content.cloneNode(true)

    token.querySelector("[data-token-name]").textContent = tagName
    token.querySelector("[data-token-hidden]").value = tagId
    token.querySelector("[data-token-hidden]").name = "event[tag_ids][]"
    token.querySelector("button").dataset.tagId = tagId

    this.inputTarget.before(token)
    this.inputTarget.value = ""
    this.clearSuggestions()
    this.activeIndex = -1
  }

  remove(event) {
    const tagId = event.target.dataset.tagId
    this.selectedTags.delete(tagId)
    event.target.closest("div").remove()
  }

  handleBackspace(event) {
    if (event.key === "Backspace" && this.inputTarget.value === "") {
      const lastToken = this.inputTarget.previousElementSibling
      if (lastToken && lastToken.querySelector("[data-token-hidden]")) {
        const tagId = lastToken.querySelector("[data-token-hidden]").value
        this.selectedTags.delete(tagId)
        lastToken.remove()
      }
    }
  }

  clearSuggestions() {
    this.suggestionsTarget.innerHTML = ""
  }
}
