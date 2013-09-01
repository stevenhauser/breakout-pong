define (require) ->

  Base = require "models/base"

  class Entity extends Base

    # Simple boolean that can be set to force updating
    shouldUpdate: false

    constructor: ->
      super
      @on "change", @onChangeEntity
      @on "destroy", @onDestroyEntity

    shorthand: [
      "width"
      "height"
      "x"
      "y"
      "dirX"
      "dirY"
      "speedX"
      "speedY"
      "vx"
      "vy"
    ]

    defaults: ->
      width: 0
      height: 0
      x: 0
      y: 0
      dirX: 0 # must be -1, 0, or 1
      dirY: 0 # must be -1, 0, or 1
      speedX: 0
      speedY: 0
      vx: 0
      vy: 0

    identifier: ->
      @constructor.name + "#" + @cid

    constrainedCoord: (axis) ->
      newCoord     = @calcCoord(axis)
      isPositive   = @["v#{axis}"]() > 0
      boundMethods = if axis is "y" then ["top", "bottom"] else ["left", "right"]
      bound        = boundMethods[~~isPositive] # converts boolean to integer
      boundVal     = @["#{bound}Bound"]()
      mathMethod   = if isPositive then "min" else "max"
      Math[mathMethod](newCoord, boundVal)

    calcCoord: (axis) ->
      @[axis]() + @["v#{axis}"]()

    move: (axis, dir) ->
      axisUpper = axis.toUpperCase()
      @["dir#{axisUpper}"](dir).calculateVelocity(axis)
      @

    calculateVelocity: (axis) ->
      axisUpper = axis.toUpperCase()
      @["v#{axis}"]( @["speed#{axisUpper}"]() * @["dir#{axisUpper}"]() )
      @

    stopMoving: ->
      @stopMovingX().stopMovingY()
      @

    isMoving: ->
      @vx() isnt 0 or @vy() isnt 0

    isMovingUp: -> @vy() < 0

    isMovingDown: -> @vy() > 0

    isMovingRight: -> @vx() > 0

    isMovingLeft: -> @vx() < 0

    x1: -> @x()

    x2: -> @x() + @width()

    y1: -> @y()

    y2: -> @y() + @height()

    doUpdate: ->
      return @ unless @needsToUpdate()
      @update()
      @shouldUpdate = false
      @

    doRender: ->
      @view.doRender()
      @

    # Simple method that checks the boolean or other interesting
    # methods. Meant to be overridden as needed.
    needsToUpdate: ->
      @shouldUpdate or @isMoving()

    update: ->
      @moveX(@dirX())
        .moveY(@dirY())
        .x(@constrainedX())
        .y(@constrainedY())
      @

    changeSpeed: (axis, delta) ->
      axisUpper = axis.toUpperCase()
      speedProp = "speed#{axisUpper}"
      newSpeed  = @[speedProp]() + delta
      maxAxisSpeed = @["maxSpeed#{axisUpper}"] or @maxSpeed
      minAxisSpeed = @["minSpeed#{axisUpper}"] or @minSpeed
      newSpeed = Math.min(newSpeed, maxAxisSpeed)
      newSpeed = Math.max(newSpeed, minAxisSpeed)
      @[speedProp](newSpeed)
      @

    accelerate: (axis) ->
      axisUpper = axis.toUpperCase()
      speedProp = "speed#{axisUpper}"
      delta = @[speedProp]() * @acceleration
      @changeSpeed(axis, delta)
      @

    onChangeEntity: ->
      @shouldUpdate = true

    onDestroyEntity: ->
      @shouldUpdate = false
      @view = null
      @stopListening()

  Entity::constrainedX       = _.partial Entity::constrainedCoord, "x"
  Entity::constrainedY       = _.partial Entity::constrainedCoord, "y"
  Entity::moveX              = _.partial Entity::move, "x"
  Entity::moveY              = _.partial Entity::move, "y"
  Entity::stopMovingX        = _.partial Entity::moveX, 0
  Entity::stopMovingY        = _.partial Entity::moveY, 0
  Entity::calculateVelocityX = _.partial Entity::calculateVelocity, "x"
  Entity::calculateVelocityY = _.partial Entity::calculateVelocity, "y"
  Entity::calcX              = _.partial Entity::calcCoord, "x"
  Entity::calcY              = _.partial Entity::calcCoord, "y"
  Entity::changeSpeedX       = _.partial Entity::changeSpeed, "x"
  Entity::changeSpeedY       = _.partial Entity::changeSpeed, "y"
  Entity::accelerateX        = _.partial Entity::accelerate, "x"
  Entity::accelerateY        = _.partial Entity::accelerate, "y"

  Entity.shorthandify()

  Entity
