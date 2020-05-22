
export function setupScreen(canvas, game) {
  const { screen: { width, height } } = local_game.state
  canvas.width = width
  canvas.height = height
}

let frames = 0;
let lastTime = parseInt(new Date().getTime() / 1000)

let local_game = {
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

export function setGame(game) {
  local_game = game
}

// export default function renderScreen(screen, scoreTable, game, requestAnimationFrame, currentPlayerId) {
export function renderScreen(screen, scoreTable, game, requestAnimationFrame, currentPlayerId, framerate) {
  const context = screen.getContext('2d')
  context.fillStyle = 'white';
  context.clearRect(0, 0, 10, 10);

  for (const playerId in local_game.state.players) {
    const player = local_game.state.players[playerId]
    context.fillStyle = 'black'
    context.fillRect(player.x, player.y, 1, 1)
  }

  for (const fruitId in local_game.state.fruits) {
    const fruit = local_game.state.fruits[fruitId]
    context.fillStyle = 'green'
    context.fillRect(fruit.x, fruit.y, 1, 1)
  }

  const currentPlayer = local_game.state.players[currentPlayerId]

  if (currentPlayer) {
    context.fillStyle = '#F0DB4F'
    context.fillRect(currentPlayer.x, currentPlayer.y, 1, 1)
  }

  updateScoreTable(scoreTable, currentPlayerId)

  if (local_game.show_framerate) {
    frames++;
    const curTime = parseInt((new Date().getTime() / 1000))
    if (lastTime !== curTime) {
      framerate.innerHTML = `${frames} fps`
      frames = 0;
      lastTime = curTime
    }
  } else {
    framerate.innerHTML = "n/a"
  }

  requestAnimationFrame(() => {
    renderScreen(screen, scoreTable, game, requestAnimationFrame, currentPlayerId, framerate)
  })

}

function updateScoreTable(scoreTable, currentPlayerId) {
  const maxResults = 10

  let scoreTableInnerHTML = ''
  // let scoreTableInnerHTML = `
  //       <tr class="header">
  //           <td>Top 10 Jogadores</td>
  //           <td>Pontos</td>
  //       </tr>
  //   `

  const playersArray = []

  for (let playerId in local_game.state.players) {
    const player = local_game.state.players[playerId]
    playersArray.push({
      playerId: playerId,
      name: player.name,
      x: player.x,
      y: player.y,
      score: player.score,
    })
  }


  const playersSortedByScore = playersArray.sort((first, second) => {
    if (first.score < second.score) {
      return 1
    }

    if (first.score > second.score) {
      return -1
    }

    return 0
  })

  const topScorePlayers = playersSortedByScore.slice(0, maxResults)

  scoreTableInnerHTML = topScorePlayers.reduce((stringFormed, player) => {
    return stringFormed + `
            <tr ${player.playerId === currentPlayerId ? 'class="current-player"' : ''}>
                <td>${player.name}</td>
                <td>${player.playerId}</td>
                <td style="text-align:right">${player.score}</td>
            </tr>
        `
  }, scoreTableInnerHTML)

  const currentPlayerFromTopScore = topScorePlayers[currentPlayerId]

  if (currentPlayerFromTopScore) {
    scoreTableInnerHTML += `
            <tr class="current-player bottom">
                <td class="socket-id">${currentPlayerFromTopScore.id} EU </td>
                <td class="score-value">${currentPlayerFromTopScore.score}</td>
            </tr>
        `
  }

  scoreTable.innerHTML = scoreTableInnerHTML
}

