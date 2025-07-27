import { Controller } from "@hotwired/stimulus"

/**
 * @controller theme
 */

export default class extends Controller {

  toggle() {
    const current = document.documentElement.dataset.theme || "light"
    const next = current === "light" ? "dark" : "light"
    document.documentElement.dataset.theme = next
    localStorage.setItem("theme", next)
  }

  applySavedOrSystemTheme() {
    let theme = localStorage.getItem("theme")

    if (!theme) {
      const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches
      theme = prefersDark ? "dark" : "light"
    }

    document.documentElement.dataset.theme = theme
  }
}
