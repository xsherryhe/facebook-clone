import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['toggle'];

  toggleHidden() {
    console.log('test');
    console.log(this.toggleTarget);
    this.toggleTarget.classList.toggle('hidden');
  }
}
