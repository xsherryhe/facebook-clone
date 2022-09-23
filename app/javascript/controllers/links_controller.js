import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['linkDiv'];

  connect() {
    this.linkDivTargets.forEach(linkDiv => {
      const link = linkDiv.getElementsByTagName('a')[0];
      linkDiv.addEventListener('click', e => this.clickLink(e, link));
    })
  }

  clickLink(e, link) {
    if(e.target.tagName == 'A') return;
    link.click();
  }
}
