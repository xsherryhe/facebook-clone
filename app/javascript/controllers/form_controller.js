import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'preview', 'submit'];

  reset(e) {
    e.target.reset();
    this.previewTarget.textContent = '';
  }

  replacePreview(e) {
    this.updatePreview(e, 0, '250');
  }

  addToPreview(e) {
    this.updatePreview(e, 1, '150');
  }

  updatePreview(e, type, height) {
    const imageFiles = [...e.target.files];
    imageFiles.forEach(file => {
      const image = document.createElement('img');
      if(height) image.height = height;
      image.src = URL.createObjectURL(file);
      [() => this.previewTarget.replaceChildren(image),
       () => this.previewTarget.appendChild(image)][type]();
    })
  }

  setSubmit() {
    this.submitTarget.disabled = this.inputTargets.every(input => input.value == '');
  }
}
