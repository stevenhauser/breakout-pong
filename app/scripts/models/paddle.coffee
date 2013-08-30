define (require) ->

  Entity = require "models/entity"
  boundable = require "models/mixins/boundable"

  class Paddle extends Entity

    shouldUpdate: false

    defaults: ->
      _.extend {}, super, { speedX: 4 }

    initialize: (attrs, opts) ->
      @bounds = opts.bounds
      @

    update: ->
      return @ unless @shouldUpdate
      @shouldUpdate = false
      @set
        x: @constrainedX()
      @


  _.extend Paddle::, boundable

  Paddle
