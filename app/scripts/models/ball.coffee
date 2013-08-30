define (require) ->

  Entity = require "models/entity"
  boundable = require "models/mixins/boundable"
  bouncable = require "models/mixins/bouncable"
  entities = require "entities"

  class Ball extends Entity

    minSpeed: 1

    maxSpeed: 4

    acceleration: 1.04

    resetDelay: 300

    initialize: (attrs, opts) ->
      @bounds = opts.bounds
      @

    randomVelocity: ->
      if Math.random() > .5 then 1 else -1

    randomSpeed: ->
      _.random(@minSpeed, @maxSpeed)

    update: ->
      newX = @calcX()
      newY = @calcY()
      if @isOutOfBoundsX(newX)
        @bounceX()
        newX = @calcX()
      if newY < @topBound()
        @bounceY()
        newY = @calcY()
      if @isCollidingWithPaddle()
        # Ensure vy is -1 so the ball doesn't jiggle
        # on the paddle and rapidly bounce up and down
        @bounceY().vy(-1)
        newY = @calcY()
      if newY > @bottomBound()
        @reset()
      @x(newX).y(newY)
      @

    isCollidingWithPaddle: ->
      p = entities.get("player")
      isCollidingOnY = @y2() > p.y1()
      return false unless isCollidingOnY
      isCollidingOnX = p.x1() < @x1() < p.x2() or p.x1() < @x2() < p.x2()
      isCollidingOnX and isCollidingOnY

    reset: ->
      @stopMoving()
      _.delay =>
        @set
          x: @rightRelativeBound() / 2
          y: @bottomRelativeBound() / 2
          vx: @randomVelocity()
          vy: @randomVelocity()
          speedX: @randomSpeed()
          speedY: @randomSpeed()
      , @resetDelay
      @

  _.extend Ball::, boundable, bouncable

  Ball
