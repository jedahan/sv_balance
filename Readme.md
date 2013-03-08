## sv_balance

Here are some simulations of team balance algorithms.
Inspired by [this thread][] on [TacticalGamer.com][] trying to improve the [sv_balance plugin][]. 

The goals are to minimize the standard deviation of expected team winrate
 (create balanced teams)

And to maximize the expected deviation of who plays on what teams
 (create varied teams)

#### Dependencies

  * [node.js](http://nodejs.org/)

#### Installation

  * `npm install`

#### Running

  * `npm start`

[this thread]: http://www.tacticalgamer.com/natural-selection-general-discussion/191679-sv_balance-creates-mis-numbered-teams.html
[TacticalGamer.com]: http://tacticalgamer.com
[sv_balance plugin]: https://github.com/lancehilliard/TGNS/blob/master/ns2/lua/plugins/balance.lua