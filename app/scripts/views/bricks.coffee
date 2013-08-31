define (require) ->

  Base = require "views/base"
  Brick = require "views/brick"

  class Bricks extends Base

    itemView: Brick

    initialize: ->
      @bindEvents().createChildViews()
      @

    bindEvents: ->
      @listenTo @collection, "remove", @onRemove
      @

    createChildViews: ->
      @childViews = {}
      @collection.each (model) => @addChildView(model)
      @

    addChildView: (model) ->
      view = new @itemView(model: model)
      @childViews[model.cid] = view
      @$el.append view.el
      @

    removeChildView: (modelCid) ->
      view = @childViews[modelCid]
      @childViews[modelCid] = null
      view.remove()
      @

    onRemove: (brick) ->
      @removeChildView brick.cid
