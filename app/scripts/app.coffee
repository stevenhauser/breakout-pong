define (require) ->

  vent         = require "vent"
  entities     = require "entities"
  Paddle       = require "models/paddle"
  Ball         = require "models/ball"
  BallView     = require "views/ball"
  Player       = require "views/player"
  Bricks       = require "collections/bricks"
  BricksView   = require "views/bricks"
  Bounds       = require "views/bounds"
  Controls     = require "views/controls"

  raf      = requestAnimationFrame

  class App

    start: ->
      @entities = entities
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

    addEntity: (name, entity, overwrite) ->
      @entities.set.apply(@entities, arguments)
      @

    createModels: -> @

    createViews: ->
      player = new Player
        el: "#player-1"
        model: new Paddle {}, { bounds: @bounds }
      @addView(player).addEntity("player", player.model)
      window.player = player

      ball = new BallView
        el: "#ball"
        model: new Ball {}, { bounds: @bounds }
      @addView(ball).addEntity("ball", ball.model)
      window.ball = ball

      bricks = new BricksView
        el: "#blocks-grid"
        collection: new Bricks null, { rows: 5, cols: 10, bounds: @bounds }
      for brickCid, brickView of bricks.childViews
        @addView(brickView).addEntity("brick-#{brickCid}", brickView.model)
      bricks.render()

      @

    update: ->
      entity.doUpdate() for name, entity of @entities.all()
      @

    render: ->
      view.doRender() for view in @views
      @

    tick: ->
      @update().render()
      raf => @tick()
