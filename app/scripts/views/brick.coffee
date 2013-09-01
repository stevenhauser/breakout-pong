define (require) ->

  Entity = require "views/entity"
  utils = require "utils"

  class Brick extends Entity

    className: "block"

    # Use top/left instead of default `render` (transform + translate3d)
    # because the `.falling` class uses `transform` and the bricks only render
    # once unless the viewport is resized.
    render: ->
      @el.style.left   = utils.pixelize @model.x()
      @el.style.top    = utils.pixelize @model.y()
      @el.style.width  = utils.pixelize @model.width()
      @el.style.height = utils.pixelize @model.height()
      @

    fall: ->
      @$el.addClass("falling")
      @

    remove: ->
      @fall()
      _.delay (=> super), 1000
