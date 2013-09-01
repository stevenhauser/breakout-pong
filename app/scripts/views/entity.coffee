define (require) ->

  Base = require "views/base"

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

    doRender: ->
      return unless @shouldRender or @needsToRender()
      @render()
      @shouldRender = false
      @

    # Override as needed when setting `shouldRender` isn't enough
    needsToRender: -> false

    onEntityChange: ->
      @shouldRender = true
