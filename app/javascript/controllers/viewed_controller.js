import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['notification'];

  setToViewed(e) {
    e.target.classList.remove('important-link');
    const textContent = e.target.textContent,
          sliceInd = / \(\d+\)/.exec(textContent)?.index;
    e.target.textContent = textContent.slice(0, sliceInd);
    this.setNotificationsToViewed();
  }

  setNotificationsToViewed() {
    this.notificationTargets.forEach(notification => {
      notification.classList.remove('new-notification');
      notification.querySelector('.new.icon').textContent = ' ';
    })
  }
}
