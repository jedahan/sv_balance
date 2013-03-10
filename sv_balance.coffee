async = require 'async'

class Team
  constructor: (@name, @players) ->
  
  toString: ->
    console.log @name
    for player in @players
      console.log player.name, player.score

  score: ->
    total_score = 0
    total_score += player.score for player in @players
    total_score / @players.length

  popPlayer: ->
    return if @players.length is 0
    @players.splice(Math.floor(Math.random() * @players.length),1)[0]

  pushPlayer: (player) ->
    @players.push player

strategies = 
  random: (readyroom, cb) ->
    alien = new Team "alien", []
    marine = new Team "marine", []  

    while random_player = readyroom.popPlayer()
      if alien.players.length < marine.players.length
        team = alien
      else
        team = marine
      team.pushPlayer random_player

    cb null, {alien, marine}

  ###
    generate random teams
    randomly swap stronger players from the stronger team with weaker players from the weaker team
    until the weaker team is now the stronger team
  ###
  weirdo_strategy: (players, cb) ->
    cb new Error "unimplemented strategy"

  ###
    generate random teams
    randomly swap stronger players from the stronger team with weaker players from the weaker team
    until the expected win difference is within 5%
  ###
  swap_until_within_bounds_strategy: (readyroom, cb) ->
    alien = new Team "alien", []
    marine = new Team "marine", []  

    while random_player = readyroom.popPlayer()
      if alien.players.length < marine.players.length
        team = alien
      else
        team = marine
      team.pushPlayer random_player

    while Math.abs(alien.score() - marine.score()) > 0.05
      stronger = if marine.score() > alien.score() then marine else alien
      weaker = if marine.score() < alien.score() then marine else alien
    
      random_stronger_player = stronger.players[Math.floor Math.random()*stronger.players.length]
      while random_stronger_player.score < weaker.score()
        random_stronger_player = stronger.players[Math.floor Math.random()*stronger.players.length]

      random_weaker_player = weaker.players[Math.floor Math.random()*weaker.players.length]
      while random_weaker_player.score > stronger.score()
        random_weaker_player = weaker.players[Math.floor Math.random()*weaker.players.length]

      stronger.players.splice stronger.players.indexOf(random_stronger_player), 1
      weaker.players.splice weaker.players.indexOf(random_weaker_player), 1
      weaker.players.push random_stronger_player
      stronger.players.push random_weaker_player

    cb null, {alien, marine}
  
  ###
    generate random teams until the expected win difference is within 5%
  ###
  zombie_strategy: (readyroom, cb) ->
    alien = new Team "alien", []
    marine = new Team "marine", []  

    while random_player = readyroom.popPlayer()
      if alien.players.length < marine.players.length
        team = alien
      else
        team = marine
      team.pushPlayer random_player
      if readyroom.players.length is 0
        cb null, {alien, marine}
###
    while Math.abs(alien.score() - marine.score()) > 0.05
      while alien.players.length
        readyroom.pushPlayer alien.players[0]
      while marine.players.length
        readyroom.pushPlayer marine.players[0]
      until alien.players.length is marine.players.length is 0
###

sv_balance = (strategy, cb) ->
  readyroom = new Team "readyroom", [
    {name: "micro", score: 0.56}
    {name: "donat", score: 0.66}
    {name: "solarity", score: 0.62}
    {name: "wyzcrak", score: 0.50}
    {name: "kormendi", score: 0.55}
    {name: "risingsun", score: 0.50}
    {name: "snooggums", score: 0.60}
    {name: "montyp", score: 0.66}
    {name: "THE_GODDAMN_BATMAN", score: 0.44}
    {name: "NSPlayer", score: 0.32}
    {name: "frito_bandito", score: 0.20}
    {name: "phil", score: 0.00}
    {name: "chuck_norris", score: 0.99}
    {name: "red_baron", score: 0.36}
    {name: "priceline", score: 0.49}
    {name: "violentsquirrel", score: 0.70}
  ]

  strategy readyroom, (err, teams) ->
    cb err, teams

simulate = (strategy, simulations = 0) ->
  allgames = []
  simulation = 0
  while simulation++ < simulations
    sv_balance strategy, (err, teams) ->
      unless err
        allgames.push teams
        if allgames.length is simulations
          reduce allgames

reduce = (games) ->
  skill_differences = (Math.abs(game.alien.score() - game.marine.score()) for game in games)
  mean = skill_differences.reduce((x,y)->x+y)/skill_differences.length
  variance = (Math.pow((skill_difference - mean),2) for skill_difference in skill_differences)
  deviation = variance.reduce((x,y)->x+y)/skill_differences.length
  console.log "After #{games.length} simulations\n
    the expected win rate difference is #{Math.round(mean*1000)/10} ± #{Math.round(deviation*1000)/10}%\n
  "

for name,strategy of strategies
  console.log "trying strategy #{name}"
  simulate strategy, 10000