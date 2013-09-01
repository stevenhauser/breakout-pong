define (require) ->

  Base = require "views/base"
  Entity = require "views/entity"

  class Entities extends Base

    itemView: Entity

    constructor: ->
      super
      @bindEvents().createChildViews()

    bindEvents: ->
      @listenTo @collection, "remove", @onEntitiesRemove
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

    onEntitiesRemove: (model) ->
      @removeChildView model.cid
