import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  intercept(event) {
    if(event.detail.fetchResponse.response.redirected)
      Turbo.visit(event.detail.fetchResponse.response.url);
  }
}
