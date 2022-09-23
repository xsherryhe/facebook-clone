import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['toggle'];

  toggleHidden() {
    this.toggleTarget.classList.toggle('hidden');
  }
}
