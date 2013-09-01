define (require) ->

  Base = require "views/base"
  utils = require "utils"

  class Entity extends Base

    shouldRender: false

    constructor: ->
      super
      # Set up 1-to-1 relationship with model for entities for a simpler
      # game loop and entity cache.
      @model.view = @
      @listenTo(@model, "change", @onEntityChange) if @model
      @render()

    setDimensions: ->
      @model.width(@el.offsetWidth).height(@el.offsetHeight)
      @

    updateCoords: ->
      x = utils.pixelize @model.x()
      y = utils.pixelize @model.y()
      @el.style.webkitTransform = "translate3d(#{x}, #{y}, 0)"
      @

    doRender: ->
      return unless @shouldRender or @needsToRender()
      @render()
      @shouldRender = false
      @

    render: ->
      @updateCoords()
      @

    # Override as needed when setting `shouldRender` isn't enough
    needsToRender: -> false

    onEntityChange: ->
      @shouldRender = true
