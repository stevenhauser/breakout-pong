define (require) ->

  Base = require "collections/base"
  Entity = require "models/entity"

  class Entities extends Base

    model: Entity

    doUpdate: ->
      @invoke "doUpdate"
      @

    doRender: ->
      @invoke "doRender"
      @
