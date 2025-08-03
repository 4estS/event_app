import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { maxSize: Number }
  static targets = ["input", "error", "preview"]

  validate() {
    const file = this.inputTarget.files[0]
    this.errorTarget.textContent = ""
    this.previewTarget.innerHTML = ""

    if (!file) return

    if (file.size > this.maxSizeValue) {
      this.errorTarget.textContent = `File is too large. Max size is ${this.maxSizeValue / 1024 / 1024} MB.`
      this.inputTarget.value = ""
      return
    }

    if (file.type.startsWith("image/")) {
      const reader = new FileReader()
      reader.onload = e => {
        const img = document.createElement("img")
        img.src = e.target.result
        img.className = "rounded-lg shadow mt-4 max-w-full h-auto"
        this.previewTarget.appendChild(img)
      }
      reader.readAsDataURL(file)
    }
  }
}
