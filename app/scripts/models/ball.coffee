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

    randomVelocity: ->
      if Math.random() > .5 then 1 else -1

    randomSpeed: ->
      _.random(@minSpeed, @maxSpeed)

    update: ->
      @x(@calcX()).y(@calcY())
      if @isOnBoundX() then @bounceX()

      if @isOnTopBound() then @bounceY()
      else if @isOutsideBottomBound() then @delayReset()

      if @isCollidingWith(entities.get("player")) then @bounceY().vy(-1)
      else if @isCollidingWithBricks() then @bounceY()
      @

    isCollidingWithBricks: ->
      bricks = _.filter entities.all(), (entity, name) -> name.indexOf("brick") > -1
      for brickName, brick of bricks
        if @isCollidingWith(brick)
          brick.trigger("collided", @)
          return true
      false

    reset: ->
      @stopMoving()
      @set
        x: @midBoundX()
        y: @midBoundY()
        vx: @randomVelocity()
        vy: @randomVelocity()
        speedX: @randomSpeed()
        speedY: @randomSpeed()
      @

    delayReset: ->
      @stopMoving()
      _.delay (=> @reset()), @resetDelay

  _.extend Ball::, boundable, bouncable, collidable

  Ball
