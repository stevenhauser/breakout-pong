define (require) ->

  Entity = require "views/entity"
  colorable = require "views/mixins/colorable"
  vent = require "vent"
  utils = require "utils"

  isDown = false

  class Player extends Entity

    slurpFrom: ["Ball"]

    initialize: ->
      @bindEvents()
        .colorable()
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

    isMovementKey: (key) ->
      key is "left" or key is "right"

    onGameResized: ->
      @setDimensions()
      @model.pinToBottom()

    onKeydown: (key) ->
      return if isDown or !@isMovementKey(key)
      @model.dirX(if key is "left" then -1 else 1)

    onKeyup: (key) ->
      return unless @isMovementKey(key)
      @model.stopMovingX()


  _.extend Player::, colorable

  Player
