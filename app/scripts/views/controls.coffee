define (require) ->

  Base = require "views/base"
  vent = require "vent"

  keyMap =
    38: "up"
    39: "right"
    40: "down"
    37: "left"

  class Controls extends Base

    el: window

    events:
      keyup: "onKey"
      keydown: "onKey"

    onKey: (e) ->
      return unless e.which of keyMap
      vent.trigger "controls:#{e.type}", keyMap[e.which]
