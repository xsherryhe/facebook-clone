import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'submit'];

  reset() {
    this.element.reset();
    this.setSubmit();
    this.dispatch('reset');
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
