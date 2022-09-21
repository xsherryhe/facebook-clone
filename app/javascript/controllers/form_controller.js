import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'preview', 'submit'];

  reset(e) {
    this.element.reset();
    this.previewTarget.textContent = '';
  }

  replacePreviewLarge(e) {
    this.updatePreview(e, 0, '250');
  }

  replacePreviewSmall(e) {
    this.updatePreview(e, 0, '150');
  }

  addToPreview(e) {
    this.updatePreview(e, 1, '150');
  }

  updatePreview(e, type, height) {
    if(type == 0)
      this.previewTarget.textContent = '';
    const imageFiles = [...e.target.files];
    imageFiles.forEach(file => {
      const image = document.createElement('img');
      if(height) image.height = height;
      image.src = URL.createObjectURL(file);
      this.previewTarget.appendChild(image);
    })
  }

  setSubmit() {
    this.submitTarget.disabled = this._emptyForm();
  }

  submitOnEnter(e) {
    if(e.key != 'Enter') return;
    e.preventDefault();
    if(this._emptyForm()) return;
    console.log(e.target)
    this.element.requestSubmit();
  }

  _emptyForm() {
    return this.inputTargets.every(input => input.value == '');
  }
}
