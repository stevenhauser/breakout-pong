define (require) ->

  slurpProperty: "border-color"

  spewProperty: "border-color"

  colorable: ->
    @listenTo @model, "collided", @onColorableCollided
    @

  getColorOf: (entity) ->
    entity.view.$el.css(@slurpProperty)

  slurpColorFrom: (entity) ->
    @$el.css @spewProperty, @getColorOf(entity)
    @

  slurpsFrom: (entity) ->
    @slurpFrom and @slurpFrom.length and entity.constructor.name in @slurpFrom

  clearSlurpedProperty: ->
    @$el.css @spewProperty, ""
    @

  onColorableCollided: (entity) ->
    @slurpColorFrom(entity) if @slurpsFrom(entity)
