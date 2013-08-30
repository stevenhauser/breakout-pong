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
      if @isOutsideBottomBound() then @reset()
      if @isCollidingWith(entities.get("player")) then @bounceY().vy(-1)
      @

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

  _.extend Ball::, boundable, bouncable, collidable

  Ball
