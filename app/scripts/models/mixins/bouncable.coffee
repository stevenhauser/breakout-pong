define (require) ->

  bouncable =

    reverseVelocity: (axis) ->
      velProp = "v#{axis}"
      @[velProp]( @[velProp]() * -1 )
      @

    increaseSpeed: (axis) ->
      axisUpper = axis.toUpperCase()
      speedProp = "speed#{axisUpper}"
      newSpeed = @[speedProp]() * @acceleration
      newSpeed = if newSpeed < @maxSpeed then newSpeed else @maxSpeed
      @[speedProp](newSpeed)
      @

    bounce: (axis) ->
      @increaseSpeed(axis).reverseVelocity(axis)
      @

  bouncable.reverseVelocityX  = _.partial bouncable.reverseVelocity, "x"
  bouncable.reverseVelocityY  = _.partial bouncable.reverseVelocity, "y"
  bouncable.increaseSpeedX = _.partial bouncable.increaseSpeed, "x"
  bouncable.increaseSpeedY = _.partial bouncable.increaseSpeed, "y"
  bouncable.bounceX           = _.partial bouncable.bounce, "x"
  bouncable.bounceY           = _.partial bouncable.bounce, "y"

  bouncable
