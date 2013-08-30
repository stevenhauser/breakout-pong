define (require) ->

  Entity = require "views/entity"
  vent = require "vent"

  class Player extends Entity

    initialize: ->
      @bindEvents()
        .setDimensions()
        .setPaddleInitialX()
        .showPaddle()
      @

    bindEvents: ->
      @listenTo vent, "game:resized", @onGameResized
      @listenTo vent, "controls:keydown", @onKeydown
      @listenTo vent, "controls:keyup", @onKeyup
      @

    setPaddleInitialX: ->
      halfGameWidth = @model.rightBound() / 2
      halfPaddleWidth = @model.get("width") / 2
      @model.set
        x: halfGameWidth - halfPaddleWidth
      @

    showPaddle: ->
      @$el.removeClass("invisible")
      @

    render: ->
      @el.style.left = @model.get("x") + "px"
      @

    isMovementKey: (key) ->
      key is "left" or key is "right"

    onGameResized: ->
      @setDimensions()

    onKeydown: (key) ->
      return if @model.isMoving() or !@isMovementKey(key)
      @model.moveX(if key is "left" then -1 else 1)

    onKeyup: (key) ->
      return unless @isMovementKey(key)
      @model.stopMovingX()
