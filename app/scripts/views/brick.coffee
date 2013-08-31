define (require) ->

  Entity = require "views/entity"
  utils = require "utils"

  class Brick extends Entity

    className: "block"

    render: ->
      @el.style.left   = utils.pixelize @model.x()
      @el.style.top    = utils.pixelize @model.y()
      @el.style.width  = utils.pixelize @model.width()
      @el.style.height = utils.pixelize @model.height()
      @
