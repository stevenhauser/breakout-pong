define (require) ->

  Base = require "models/base"

  class Entity extends Base

    shouldUpdate: false

    constructor: ->
      super
      @on "change", @onChangeObject

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
      @get("v#{axis}") > 0

    constrainedCoord: (axis) ->
      newCoord = @get(axis) + @get("v#{axis}")
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

    move: (dir) ->
      @set "vx", @get("speedX") * dir
      @

    isMoving: ->
      @get("vx") isnt 0 or @get("vy") isnt 0

    onChangeObject: ->
      @shouldUpdate = true

  Entity::vxIsPositive = _.partial Entity::velocityIsPositive, "x"
  Entity::vyIsPositive = _.partial Entity::velocityIsPositive, "y"
  Entity::constrainedX = _.partial Entity::constrainedCoord, "x"
  Entity::constrainedY = _.partial Entity::constrainedCoord, "y"
  Entity::stopMoving   = _.partial Entity::move, 0

  Entity
