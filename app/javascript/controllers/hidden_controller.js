import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['toggle'];

  toggleHidden(e) {
    if(!this.hasToggleTarget) return;
    if(e.target.classList.contains('prevent-default'))
      e.preventDefault();

    e.target.classList.add('prevent-default');
    this.toggleTarget.classList.toggle('hidden');
  }
}
