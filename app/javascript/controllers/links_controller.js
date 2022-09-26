import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['linkDiv'];

  connect() {
    this.linkDivTargets.forEach(linkDiv => {
      linkDiv.addEventListener('click', e => this.clickLink(e, linkDiv));
    })
  }

  clickLink(e, linkDiv) {
    if(e.target.tagName == 'A') return;

    [...linkDiv.querySelectorAll('*')]
    .find(element => element.tagName == 'A')
    .click();
  }
}
