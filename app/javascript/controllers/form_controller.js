import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'submit'];

  reset() {
    this.element.reset();
    this.setSubmit();
    this.dispatch('reset');
  }

  autoResize(e) {
    const area = e.target;
    area.style.height = 0;
    area.style.height = area.scrollHeight + 'px';
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
    return this.inputTargets
               .every(input => input.value.trim() == '' ||
                               (/\[_destroy\]$/.test(input.name) && input.value == 'true'));
  }
}
