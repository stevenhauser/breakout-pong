define (require) ->

  Entity = require "models/entity"
  boundable = require "models/mixins/boundable"
  vent = require "vent"

  class Brick extends Entity

    defaults: ->
      _.extend {}, super, { height: 20 }

    initialize: (attrs, opts) ->
      @bounds = opts.bounds
      @bindEvents().calculateGeometry()

    bindEvents: ->
      @listenTo vent, "game:resized", @onGameResized
      @

    calculateGeometry: ->
      @calculateDimensions().calculateCoords()
      @

    calculateDimensions: ->
      @width @getBound("right") / @cols()
      @

    calculateCoords: ->
      @x @col() * @width()
      @y @row() * @height()
      @

    onGameResized: ->
      @calculateGeometry()

  _.extend Brick::, boundable

  Brick.shorthandify  "row rows col cols".split(" ")

  Brick
