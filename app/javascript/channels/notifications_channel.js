import consumer from "channels/consumer"
const channel = {};
document.addEventListener('turbo:load', subscribe);

function subscribe() {
  if(channel.message) consumer.subscriptions.remove(channel.message);
  channel.message = consumer.subscriptions.create(
    { channel: 'NotificationsChannel', 
      id: +document.querySelector('#user-id').textContent } , {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received() {
      // Called when there's incoming data on the websocket for this channel
      const notificationsLink = document.querySelector('.notifications-link'),
            notificationsNum = +(notificationsLink.textContent.match(/\((\d+)\)/) || '00')[1] + 1;
      notificationsLink.textContent = `Notifications (${notificationsNum})`;
      notificationsLink.classList.add('important-link');
      notificationsLink.classList.remove('prevent-default');
    },
  })
}
