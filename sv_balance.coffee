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
  swap_until_within_bounds_strategy: (players, cb) ->
    cb new Error "unimplemented strategy"
  
  ###
    generate random teams
    randomly swap players
    until the expected win difference is within 5%
  ###
  zombie_strategy: (players, cb) ->
    cb new Error "unimplemented strategy"

sv_balance = (strategy, cb) ->
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
    {frito_bandito: 0.20}
    {phil: 0.00}
    {chuck_norris: 0.99}
    {red_baron: 0.36}
    {priceline: 0.49}
    {violentsquirrel: 0.70}
  ]
  readyroom = new Team "readyroom", server 

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