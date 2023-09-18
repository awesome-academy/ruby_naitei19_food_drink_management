import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Connected to server successfully")
  },

  disconnected() {
    console.log("Disconnected from server")
  },

  received(data) {
    $("#notif-list").prepend(data.html)
  },
});
