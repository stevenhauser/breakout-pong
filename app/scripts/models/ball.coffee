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
      @x(@calcX()).y(@calcY())
      if @isOnBoundX() then @bounceX()
      if @isOnTopBound() then @bounceY()
      if @isOutsideBottomBound() then @reset()
      if @isCollidingWithPaddle() then @bounceY().vy(-1)
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
          x: @midBoundX()
          y: @midBoundY()
          vx: @randomVelocity()
          vy: @randomVelocity()
          speedX: @randomSpeed()
          speedY: @randomSpeed()
      , @resetDelay
      @

  _.extend Ball::, boundable, bouncable

  Ball
