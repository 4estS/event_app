import { Controller } from "@hotwired/stimulus"

/**
 * @controller theme
 */

export default class extends Controller {
  connect() {
    const savedTheme = localStorage.getItem("theme")

    if (savedTheme) {
      // Apply stored preference
      this.setTheme(savedTheme)
    } else {
      // Detect and apply system preference
      const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches
      const defaultTheme = prefersDark ? "dark" : "light"
      this.setTheme(defaultTheme)
    }
  }

  toggle() {
    const current = document.body.dataset.theme
    const next = current === "light" ? "dark" : "light"
    this.setTheme(next)
  }

  setTheme(name) {
    document.body.dataset.theme = name
    localStorage.setItem("theme", name)
  }
}