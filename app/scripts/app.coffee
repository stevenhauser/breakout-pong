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
      @createInstances().tick()
      @

    createInstances: ->
      @createStructures().createEntities()
      @

    createStructures: ->
      @bounds = new Bounds
      @controls = new Controls
      @

    addEntity: (name, entity, overwrite) ->
      entity = entity.model or entity.collection or entity
      @entities.set(name, entity, overwrite)
      window[name] = entity # @TODO: remove this debug global
      @

    createEntities: ->
      @addEntity "player", new Player
        el: "#player-1"
        model: new Paddle {}, { bounds: @bounds }

      @addEntity "ball", new BallView
        el: "#ball"
        model: new Ball {}, { bounds: @bounds }

      @addEntity "bricks", new BricksView
        el: "#blocks-grid"
        collection: new Bricks null, { rows: 5, cols: 10, bounds: @bounds }

      @

    update: ->
      entity.doUpdate() for name, entity of @entities.all()
      @

    render: ->
      entity.doRender() for name, entity of @entities.all()
      @

    tick: ->
      # Separate updating and rendering even though it causes two of the same
      # loops for performance reasons (groups renderings into one set of tasks).
      @update().render()
      raf => @tick()
