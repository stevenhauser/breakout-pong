define (require) ->

  Entity = require "models/entity"
  boundable = require "models/mixins/boundable"
  bouncable = require "models/mixins/bouncable"
  collidable = require "models/mixins/collidable"
  entities = require "entities"

  class Ball extends Entity

    minSpeedX: .1

    minSpeedY: 1.2

    minSpeed: 1

    maxSpeed: 4

    acceleration: .04

    resetDelay: 300

    initialize: (attrs, opts) ->
      @bouncable()
      @bounds = opts.bounds
      @

    randomDirection: ->
      if Math.random() > .5 then 1 else -1

    randomSpeed: ->
      _.random(@minSpeed, @maxSpeed)

    # y should only be constrained on the top
    constrainedY: ->
      Math.max(@calcY(), @topBound())

    update: ->
      super # constrain the coords
      hasReactedOnY = false
      # Bounce off horizontal bounds easily
      if @isOnBoundX() then @bounceX()
      # Do a bit more work to bounce off vertical
      # bound or reset; they're mutually exclusive.
      if @isOnTopBound()
        @bounceY()
        hasReactedOnY = true
      else if @isOutsideBottomBound()
        @delayReset()
        hasReactedOnY = true
      # If nothing has happened on the y axis yet, see if
      # there's been a collision with the player or the bricks, both
      # being mutually exclusive.
      hasReactedOnY = @hasCollidedWithPlayer() unless hasReactedOnY
      hasReactedOnY = @hasCollidedWithBrick() unless hasReactedOnY
      @

    hasCollidedWithPlayer: ->
      @isCollidingWith entities.get("player")

    hasCollidedWithBrick: ->
      !!entities.get("bricks").find (brick) => @isCollidingWith(brick)

    # This is perhaps one of the dumbest things I've ever written
    # but it's late and I'm burned out.
    bounceOffPaddle: (paddle) ->
      gt0 = (num) -> num > 0
      lt0 = (num) -> num < 0
      vxes = [@vx(), paddle.vx()]
      delta = Math.abs(vxes[1] / 7)
      delta = if _.every(vxes, gt0) or _.every(vxes, lt0) then delta else -delta
      @changeSpeedX(delta) if @isMainCollisionAxisY(paddle)
      @bounceOff(paddle)
      @

    reset: ->
      @stopMoving().set
        x: @midBoundX()
        y: @midBoundY()
        dirX: @randomDirection()
        dirY: 1
        speedX: @randomSpeed()
        speedY: @randomSpeed()
      @calculateVelocityX().calculateVelocityY()
      @

    delayReset: ->
      @stopMoving()
      _.delay (=> @reset()), @resetDelay

  _.extend Ball::, boundable, bouncable, collidable

  Ball
