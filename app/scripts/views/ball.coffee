define (require) ->

  Entity = require "views/entity"
  vent = require "vent"

  class Ball extends Entity

    initialize: ->
      @setDimensions()
      @model.reset()
      @

    render: ->
      @el.style.left = @model.x() + "px"
      @el.style.top  = @model.y() + "px"
      @
