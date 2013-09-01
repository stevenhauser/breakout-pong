define (require) ->

  bouncable =

    reverseDirection: (axis) ->
      dirProp = "dir#{axis.toUpperCase()}"
      @[dirProp]( @[dirProp]() * -1 )
      @

    increaseSpeed: (axis) ->
      axisUpper = axis.toUpperCase()
      speedProp = "speed#{axisUpper}"
      newSpeed = @[speedProp]() * @acceleration
      newSpeed = if newSpeed < @maxSpeed then newSpeed else @maxSpeed
      @[speedProp](newSpeed)
      @

    bounce: (axis) ->
      @increaseSpeed(axis).reverseDirection(axis).calculateVelocity(axis)
      @[axis](@calcCoord(axis))
      @

  bouncable.reverseDirectionX  = _.partial bouncable.reverseDirection, "x"
  bouncable.reverseDirectionY  = _.partial bouncable.reverseDirection, "y"
  bouncable.increaseSpeedX     = _.partial bouncable.increaseSpeed, "x"
  bouncable.increaseSpeedY     = _.partial bouncable.increaseSpeed, "y"
  bouncable.bounceX            = _.partial bouncable.bounce, "x"
  bouncable.bounceY            = _.partial bouncable.bounce, "y"

  bouncable
