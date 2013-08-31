define (require) ->

  Entity = require "views/entity"
  vent = require "vent"
  utils = require "utils"

  class Ball extends Entity

    initialize: ->
      @setDimensions()
      @model.reset()
      @

    render: ->
      @el.style.left = utils.pixelize @model.x()
      @el.style.top  = utils.pixelize @model.y()
      @
