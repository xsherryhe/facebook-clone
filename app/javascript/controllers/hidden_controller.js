import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['toggle', 'add'];

  toggleHidden(e) {
    if(!this.hasToggleTarget) return;
    if(!this.toggleTarget.textContent == '') 
      e.preventDefault();

    this.toggleTarget.classList.toggle('hidden');
  }

  addHidden(e) {
    if(!this.hasAddTarget) return;

    e.preventDefault();
    this.addTarget.classList.add('hidden');
  }
}
