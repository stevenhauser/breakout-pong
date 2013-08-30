define (require) ->

  Base = require "views/base"

  class Entity extends Base

    constructor: ->
      super
      @listenTo(@model, "change", @onEntityChange) if @model
      @shouldRender = true
      @render()
      @shouldRender = false

    render: ->
      return unless @shouldRender
      @shouldRender = false
      @

    onEntityChange: ->
      @shouldRender = true
