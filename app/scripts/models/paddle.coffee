define (require) ->

  Entity = require "models/entity"
  boundable = require "models/mixins/boundable"

  class Paddle extends Entity

    defaults: ->
      _.extend {}, super, { speedX: 5 }

    initialize: (attrs, opts) ->
      @bounds = opts.bounds
      @

    centerX: ->
      @x(@midBoundX())
      @

    pinToBottom: ->
      @y(@bottomBound())
      @


  _.extend Paddle::, boundable

  Paddle
