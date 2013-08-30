define (require) ->

  Base = require "models/base"

  class Entity extends Base

    # Simple boolean that can be set to force updating
    shouldUpdate: false

    constructor: ->
      super
      @on "change", @onChangeObject

    shorthand: "width height x y speedX speedY vx vy".split(" ")

    defaults: ->
      width: 0
      height: 0
      x: 0
      y: 0
      speedX: 0
      speedY: 0
      vx: 0
      vy: 0

    velocityIsPositive: (axis) ->
      @["v#{axis}"]() > 0

    constrainedCoord: (axis) ->
      newCoord = @calcCoord(axis)
      isPositive = @["v#{axis}IsPositive"]()
      bound = if axis is "y"
        if isPositive then @bottomRelativeBound() else @topBound()
      else
        if isPositive then @rightRelativeBound() else @leftBound()
      if isPositive
        newCoord = if newCoord <= bound then newCoord else bound
      else
        newCoord = if newCoord >= bound then newCoord else bound
      newCoord

    calcCoord: (axis) ->
      vector = @["speed#{axis.toUpperCase()}"]() * @["v#{axis}"]()
      @[axis]() + vector

    move: (axis, dir) ->
      axisUpper = axis.toUpperCase()
      @["v#{axis}"]( @["speed#{axisUpper}"]() * dir )
      @

    stopMoving: ->
      @stopMovingX().stopMovingY()
      @

    isMoving: ->
      @vx() isnt 0 or @vy() isnt 0

    x1: -> @x()

    x2: -> @x() + @width()

    y1: -> @y()

    y2: -> @y() + @height()

    doUpdate: ->
      return @ unless @needsToUpdate()
      @update()
      @shouldUpdate = false
      @

    # Simple method that checks the boolean or other interesting
    # methods. Meant to be overridden as needed.
    needsToUpdate: ->
      @shouldUpdate or @isMoving()

    update: ->
      @x(@constrainedX()).y(@constrainedY())
      @

    onChangeObject: ->
      @shouldUpdate = true

  Entity::vxIsPositive = _.partial Entity::velocityIsPositive, "x"
  Entity::vyIsPositive = _.partial Entity::velocityIsPositive, "y"
  Entity::constrainedX = _.partial Entity::constrainedCoord, "x"
  Entity::constrainedY = _.partial Entity::constrainedCoord, "y"
  Entity::moveX        = _.partial Entity::move, "x"
  Entity::moveY        = _.partial Entity::move, "y"
  Entity::stopMovingX  = _.partial Entity::moveX, 0
  Entity::stopMovingY  = _.partial Entity::moveY, 0
  Entity::calcX        = _.partial Entity::calcCoord, "x"
  Entity::calcY        = _.partial Entity::calcCoord, "y"

  Entity.shorthandify()

  Entity
