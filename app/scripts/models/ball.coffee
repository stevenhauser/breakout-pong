define (require) ->

  Entity = require "models/entity"
  boundable = require "models/mixins/boundable"
  bouncable = require "models/mixins/bouncable"
  collidable = require "models/mixins/collidable"
  entities = require "entities"

  class Ball extends Entity

    minSpeed: 1

    maxSpeed: 4

    acceleration: 1.04

    resetDelay: 300

    initialize: (attrs, opts) ->
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
      @bounceX()         if @isOnBoundX()
      @bounceY()         if @isOnTopBound() or @isCollidingWithBricks()
      @bounceOffPlayer() if @isCollidingWith(entities.get("player"))
      @delayReset()      if @isOutsideBottomBound()
      @

    isCollidingWithBricks: ->
      isColliding = false
      entities.get("bricks").each (brick) =>
        if @isCollidingWith(brick)
          brick.trigger("collided", @)
          isColliding = true
      isColliding

    bounceOffPlayer: ->
      player = entities.get("player")
      @bounceY()
      @vx( @vx() + player.vx() / 7 )
      @

    reset: ->
      @stopMoving().set
        x: @midBoundX()
        y: @midBoundY()
        dirX: @randomDirection()
        dirY: @randomDirection()
        speedX: @randomSpeed()
        speedY: @randomSpeed()
      @calculateVelocityX().calculateVelocityY()
      @

    delayReset: ->
      @stopMoving()
      _.delay (=> @reset()), @resetDelay

  _.extend Ball::, boundable, bouncable, collidable

  Ball
