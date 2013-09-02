define (require) ->

  Entity = require "views/entity"
  colorable = require "views/mixins/colorable"
  vent = require "vent"
  utils = require "utils"

  class Ball extends Entity

    slurpFrom: ["Brick"]

    initialize: ->
      @bindEvents().setDimensions().colorable()
      @model.reset()
      @

    bindEvents: ->
      @listenTo @model, "reset", @onReset
      @

    onReset: ->
      @clearSlurpedProperty()


  _.extend Ball::, colorable

  Ball
