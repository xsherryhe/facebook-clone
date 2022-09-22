import { Controller } from "@hotwired/stimulus"

const imageFileTypes = ['image/png', 'image/jpg', 'image/jpeg', 'image/svg'];

export default class extends Controller {
  static targets = ['preview', 'errors'];
  static values = { fileFieldInd: Number };

  filterImageFileType(e) {
    const inputFiles = [...e.target.files],
          filteredFiles = new DataTransfer();
    inputFiles.forEach(file => {
      if(imageFileTypes.includes(file.type)) 
        filteredFiles.items.add(file);
    })
    e.target.files = filteredFiles.files;

    this.updateFileTypeError(inputFiles);
  }

  updateFileTypeError(inputFiles) {
    this.clearErrors();

    if(inputFiles.some(file => !imageFileTypes.includes(file.type))) {
      const error = document.createElement('p');
      error.classList.add('error');
      error.textContent = 'You may only add images (PNG, JPG, JPEG, or SVG) as files.';
      this.errorsTarget.appendChild(error);
    }
  }

  clearAll() {
    this.clearPreview();
    this.clearErrors();
  }

  clearErrors() {
    this.errorsTarget.textContent = '';
  }

  clearPreview() {
    this.previewTarget.textContent = '';
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
    link.setAttribute('data-action', 'image-files#removeRawImage');
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

  removeRawImage(e) {
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
      followingContainer.id = `filefield-${fileInd}-image-${i}`;
    }

    this.registerAsInput();
  }

  removeDatabaseImage(e) {
    e.preventDefault();
    const container = e.target.parentNode,
          imageId = Number(container.id.split('-')[1]);
    
    this.element.querySelector(`#destroy-${imageId}`).value = 'true';
    container.remove();

    this.registerAsInput();
  }

  registerAsInput() {
    this.clearErrors();
    this.dispatch('input');
  }
}
