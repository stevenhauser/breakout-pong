define (require) ->

  vent = require "vent"
  Base = require "views/base"
  boundable = require "models/mixins/boundable"

  class Bounds extends Base

    el: window,

    top: 0

    right: null

    bottom: null

    left: 0

    events:
      resize: "onResize"

    initialize: ->
      @updateBounds()
      @

    updateBounds: ->
      @right = @el.innerWidth
      @bottom = @el.innerHeight
      bounds = _.pick(@, "top", "right", "bottom", "left")
      vent.trigger "game:resized", bounds
      @

    onResize: _.debounce ->
      @updateBounds()
    , 750

  _.extend Bounds::, boundable

  Bounds
