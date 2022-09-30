import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['toggle'];

  toggleHidden(e) {
    if(!this.hasToggleTarget) return;
    if(!this.toggleTarget.textContent == '') 
      e.preventDefault();

    this.toggleTarget.classList.toggle('hidden');
  }
}
