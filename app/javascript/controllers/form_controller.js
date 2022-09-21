import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset(e) {
    e.target.reset();
  }
}
