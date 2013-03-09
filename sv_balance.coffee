fs = require 'fs'

class Team
  constructor: (@name, @players) ->
  
  toString: ->
    console.log @name
    for player in @players
      for name, score of player
        console.log name, score

  score: ->
    total_score = 0
    for player in @players
      for name, score of player
        total_score += score
    total_score / @players.length

  popPlayer: ->
    return if @players.length is 0
    @players.splice(Math.floor(Math.random() * @players.length),1)[0]

  pushPlayer: (player) ->
    @players.push player

sv_balance = (cb) ->
  server = [
    {micro: 0.56}
    {donat: 0.66}
    {solarity: 0.62}
    {wyzcrak: 0.50}
    {kormendi: 0.55}
    {risingsun: 0.50}
    {snooggums: 0.60}
    {montyp: 0.66}
    {THE_GODDAMN_BATMAN: 0.44}
    {NSPlayer: 0.32}
    {frito_bandito: 0.2}
    {phil: 0.00}
    {chuck_norris: 0.99}
    {red_baron: 0.36}
    {priceline: 0.49}
    {violentsquirrel: 0.70}
  ]
  readyroom = new Team "readyroom", server 
  alien = new Team "alien", []
  marine = new Team "marine", []

  while random_player = readyroom.popPlayer()
    if alien.players.length < marine.players.length
      team = alien
    else
      team = marine
    team.pushPlayer random_player

  cb null, { marine: marine.players, alien: alien.players }

simulate = (times = 0) ->
  i = 0
  while i++ < times
    sv_balance (err, teams) ->
      console.log teams
      fs.writeFile "simulations/#{times}.json", JSON.stringify(teams,1) , (err) ->
        throw err if err

calculate = ->
  console.log 'heya'

simulate 1