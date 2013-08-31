define (require) ->

  Base = require "views/base"
  Brick = require "views/brick"

  class Bricks extends Base

    itemView: Brick

    initialize: ->
      @createChildViews()
      @

    createChildViews: ->
      @childViews = {}
      @collection.each (brick) =>
        @childViews[brick.cid] = new Brick(model: brick)
      @

    render: ->
      els = _.map @childViews, (view) -> view.el
      @$el.append(els)
      @
