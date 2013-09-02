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
      mainCollisionSide = @getMainCollisionSide(paddle)
      # Ignore if the collision is off the top of the ball because
      # that should never happen.
      return @ if mainCollisionSide is "top"
      # If we're colliding on the y axis, now filtered only to the bottom,
      # adjust the ball's x velocity based on the x velocity of the paddle
      # so that players have a bit of control over it, then bounce it off
      # of the paddle (vertically).
      if @isMainCollisionAxisY(paddle)
        gt0 = (num) -> num > 0
        lt0 = (num) -> num < 0
        vxes = [@vx(), paddle.vx()]
        delta = Math.abs(vxes[1] / 7)
        delta = if _.every(vxes, gt0) or _.every(vxes, lt0) then delta else -delta
        @changeSpeedX(delta).bounceOff(paddle)
      # If we're colliding on the x axis, bounce off the paddle first to
      # ensure that the collision is still there, then depending on if
      # we're hitting the left or right side of the ball, calculate the
      # offset and set the ball's x coordinate so that it's on the soon-
      # to-be-set edge of the paddle.
      else
        @bounceOff(paddle)
        delta = if mainCollisionSide is "left" then paddle.width() else -@width()
        @x paddle.calcX() + delta
      @

    reset: ->
      @stopMoving().set
        x: @midBoundX()
        y: @midBoundY()
        dirX: @randomDirection()
        dirY: 1
        speedX: @randomSpeed()
        speedY: @randomSpeed()
      @

    delayReset: ->
      @stopMoving()
      _.delay (=> @reset()), @resetDelay

  _.extend Ball::, boundable, bouncable, collidable

  Ball
