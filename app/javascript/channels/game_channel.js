import consumer from "./consumer"
import render from "./render"


const canvas = $("screen")
// const game = render.createGame()
const game = {
  state: {
    screen: {
      width: 10,
      height: 10
    }
  }
}
// render.setupScreen(canvas, game)

consumer.subscriptions.create("GameChannel", {

  connected() {
    console.log('Connected')
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log('Disconnected')
    // Called when the subscription has been terminated by the server
  },

  received(data) {

    const msg = $('#message')
    msg.empty();
    msg.append(data.content.message)
    msg.show();
    $(".alert").fadeTo(2000, 500).slideUp(500, function () {
      $(".alert").slideUp(500);
    });
    // Called when there's incoming data on the websocket for this channel
  },

  setup(state) {
    console.log('Setup');
    console.log(state);
  }
});
