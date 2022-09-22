import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'preview', 'submit'];
  static values = { fileFieldInd: Number };

  reset() {
    this.element.reset();
    this.previewTarget.textContent = '';
    this.setSubmit();
  }

  updateFileDisplay(e) {
    this.updatePreview(e, '150', true);
    this.replaceFileField();
  }

  replacePreviewLarge(e) {
    this.updatePreview(e, '250', false);
  }

  replacePreviewSmall(e) {
    this.updatePreview(e, '150', false);
  }

  //TO DO: Figure out how to remove images that are already in database?
  updatePreview(e, height, multiple) {
    [...e.target.files].forEach((file, i) => {
      const container = this._createContainer(i);
      container.appendChild(this._createImg(file, height));
      if(multiple) container.appendChild(this._createRemoveLink());
      multiple ? this.previewTarget.appendChild(container) : this.previewTarget.replaceChildren(container);
    })
  }

  _createContainer(imageInd) {
    const container = document.createElement('div');
    container.id = `filefield-${this.fileFieldIndValue}-image-${imageInd}`;
    return container;
  }

  _createImg(file, height) {
    const image = document.createElement('img');
    if(height) image.height = height;
    image.src = URL.createObjectURL(file);
    return image;
  }

  _createRemoveLink() {
    const link = document.createElement('a');
    link.href = '';
    link.textContent = 'Remove';
    link.setAttribute('data-action', 'form#removeFile');
    return link;
  }

  replaceFileField() {
    const oldFileField = this.element.querySelector(`#filefield-${this.fileFieldIndValue}`),
          newFileField = oldFileField.cloneNode();
    oldFileField.classList.add('hidden');
    newFileField.id = `filefield-${++this.fileFieldIndValue}`;
    newFileField.value = '';
    this.element.querySelector('.photo-upload').appendChild(newFileField);
  }

  removeFile(e) {
    e.preventDefault();
    const container = e.target.parentNode,
          [fileInd, imageInd] = container.id.split('-').filter(segment => /\d/.test(segment)).map(Number),
          fileField = this.element.querySelector(`#filefield-${fileInd}`),
          oldFiles = [...fileField.files],
          newFiles = new DataTransfer();

    oldFiles.forEach((file, i) => {
      if(i !== imageInd) newFiles.items.add(file);
    })
    fileField.files = newFiles.files;
    
    container.remove();
    for(let i = imageInd; i < oldFiles.length - 1; i++) {
      const followingContainer = this.element.querySelector(`#filefield-${fileInd}-image-${i + 1}`);
      followingContainer.id = `#filefield-${fileInd}-image-${i}`;
    }

    this.setSubmit();
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
