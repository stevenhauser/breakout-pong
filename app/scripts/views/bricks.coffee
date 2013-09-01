define (require) ->

  Entities = require "views/entities"
  Brick = require "views/brick"

  class Bricks extends Entities

    itemView: Brick
