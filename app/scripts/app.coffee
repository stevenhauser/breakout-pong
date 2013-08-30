define (require) ->

  vent     = require "vent"
  Paddle   = require "models/paddle"
  Ball     = require "models/ball"
  BallView = require "views/ball"
  Player   = require "views/player"
  Bounds   = require "views/bounds"
  Controls = require "views/controls"

  raf      = requestAnimationFrame

  class App

    start: ->
      @models = []
      @views = []
      @createInstances().tick()
      @

    createInstances: ->
      @createStructures().createModels().createViews()
      @

    createStructures: ->
      @bounds = new Bounds
      @controls = new Controls
      @

    addView: (view, addModel) ->
      @views.push(view)
      @addModel(view.model) if addModel
      @

    addModel: (model) ->
      @models.push(model)
      @

    createModels: -> @

    createViews: ->
      player = new Player
        el: "#player-1"
        model: new Paddle {}, { bounds: @bounds }
      @addView(player, true)
      window.player = player
      ball = new BallView
        el: "#ball"
        model: new Ball {}, { bounds: @bounds }
      @addView(ball, true)
      window.ball = ball
      @

    update: ->
      model.doUpdate() for model in @models
      @

    render: ->
      view.doRender() for view in @views
      @

    tick: ->
      @update().render()
      raf => @tick()
