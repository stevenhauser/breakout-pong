define (require) ->

  vent     = require "vent"
  Paddle   = require "models/paddle"
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

    addView: (view) ->
      @views.push(view)
      @

    addModel: (model) ->
      @models.push(model)
      @

    createModels: -> @

    createViews: ->
      player = new Player
        el: "#player-1"
        model: new Paddle {}, { bounds: @bounds }
      @addView(player)
      @addModel(player.model)
      window.player = player
      @

    update: ->
      model.update() for model in @models
      @

    render: ->
      view.render() for view in @views
      @

    tick: ->
      @update().render()
      raf => @tick()
