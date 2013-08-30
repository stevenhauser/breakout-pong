define (require) ->

  Base = require "views/base"

  class Entity extends Base

    shouldRender: false

    constructor: ->
      super
      @listenTo(@model, "change", @onEntityChange) if @model
      @render()

    setDimensions: ->
      @model.set
        width: @el.offsetWidth
        height: @el.offsetHeight
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
