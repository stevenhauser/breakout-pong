define (require) ->

  Entity = require "views/entity"
  vent = require "vent"
  utils = require "utils"

  class Player extends Entity

    initialize: ->
      @bindEvents()
        .setDimensions()
        .setPaddleInitialCoords()
        .showPaddle()
      @

    bindEvents: ->
      @listenTo vent, "game:resized", @onGameResized
      @listenTo vent, "controls:keydown", @onKeydown
      @listenTo vent, "controls:keyup", @onKeyup
      @

    setPaddleInitialCoords: ->
      @model.centerX().pinToBottom()
      @

    showPaddle: ->
      @$el.removeClass("invisible")
      @

    render: ->
      @el.style.left = utils.pixelize @model.x()
      @

    isMovementKey: (key) ->
      key is "left" or key is "right"

    onGameResized: ->
      @setDimensions()
      @model.pinToBottom()

    onKeydown: (key) ->
      return if @model.isMoving() or !@isMovementKey(key)
      @model.moveX(if key is "left" then -1 else 1)

    onKeyup: (key) ->
      return unless @isMovementKey(key)
      @model.stopMovingX()
