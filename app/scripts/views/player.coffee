define (require) ->

  Entity = require "views/entity"
  vent = require "vent"

  class Player extends Entity

    initialize: ->
      @bindEvents()
        .setPaddleDimensions()
        .setPaddleInitialX()
        .showPaddle()
      @

    bindEvents: ->
      @listenTo vent, "game:resized", @onGameResized
      @listenTo vent, "controls:keydown", @onKeydown
      @listenTo vent, "controls:keyup", @onKeyup
      @

    setPaddleDimensions: ->
      @model.set
        width: @el.offsetWidth
        height: @el.offsetHeight
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
      return unless @shouldRender
      @shouldRender = false
      @el.style.left = @model.get("x") + "px"
      @

    isMovementKey: (key) ->
      key is "left" or key is "right"

    onGameResized: ->
      @setPaddleDimensions()

    onKeydown: (key) ->
      return if @model.isMoving() or !@isMovementKey(key)
      @model.move(if key is "left" then -1 else 1)

    onKeyup: (key) ->
      return unless @isMovementKey(key)
      @model.stopMoving()
