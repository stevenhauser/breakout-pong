define (require) ->

  Entities = require "collections/entities"
  Brick = require "models/brick"

  class Bricks extends Entities

    model: Brick

    initialize: (models, opts) ->
      @bounds = opts.bounds
      @buildBricks(opts.rows, opts.cols)
      @

    buildBricks: (rows, cols) ->
      rows -= 1
      cols -= 1
      bricks = []
      for i in [0..rows]
        for j in [0..cols]
          bricks.push
            row: i
            rows: rows + 1
            col: j
            cols: cols + 1
      @reset bricks, bounds: @bounds
      @
