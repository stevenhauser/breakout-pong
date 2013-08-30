define (require) ->

  Entity = require "models/entity"
  boundable = require "models/mixins/boundable"
  bouncable = require "models/mixins/bouncable"

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
      if newY > @bottomBound()
        @reset()
      @x(newX).y(newY)
      @

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
