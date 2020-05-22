import consumer from "./consumer"
import * as render from "./render"
import createKeyboardListener from './keyboard-listener';



consumer.subscriptions.create("GameChannel", {

  connected() {
    console.log('Connected')

    const game = {
      state: {
        players: {},
        fruits: {},
        screen: {
          width: 10,
          height: 10
        }
      },
      show_framerate: false
    }

    const screen = document.getElementById('screen')
    // const game = render.createGame()

    const keyboardListener = createKeyboardListener(document);
    keyboardListener.subscribe((key) => {
      var id_test = { channel: 'GameChannel' };
      var stream_id = {
        command: 'message',
        identifier: JSON.stringify(id_test),
        data: JSON.stringify({ action: "move_player", content: key })
      }
      consumer.send(stream_id);
    })

    render.setupScreen(screen, game)

    const scoreTable = document.getElementById('score-body')
    const framerate = document.getElementById('framerate')
    const currentPlayerId = ''

    render.renderScreen(screen, scoreTable, game, requestAnimationFrame, currentPlayerId, framerate)
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log('> Disconnected')
    // Called when the subscription has been terminated by the server
  },

  received(data) {

    console.log(data)

    if (data.type) {
      const chk = document.getElementById('chk_framerate');
      // chk.addEventListener('change', () => {
      data.game.show_framerate = chk.checked;
      // })

      render.setGame(data.game)
    }

    if (data.message) {
      const msg = $('#message')
      msg.empty();
      msg.append(data.message)
      msg.show();
      $(".alert").fadeTo(2000, 500).slideUp(500, function () {
        $(".alert").slideUp(500);
      });
    }
  }
});
