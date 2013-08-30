define (require) ->

  bounds = "top right bottom left".split(" ")

  boundable = {}

  for bound in bounds
    do (bound) -> boundable["#{bound}Bound"] = ->
      if @bounds? then @bounds[bound] else @[bound]

  boundable.rightRelativeBound = ->
    @rightBound() - _.result(@, "width")

  boundable.bottomRelativeBound = ->
    @bottomBound() - _.result(@, "height")

  boundable.isOutOfBounds = (axis) ->
    isX = axis is "x"
    minBoundMethod = if isX then "leftBound" else "topBound"
    maxBoundMethod = if isX then "rightRelativeBound" else "bottomRelativeBound"
    !(@[minBoundMethod]() < @[axis]() < @[maxBoundMethod]())

  boundable.isOutOfBoundsX = _.partial boundable.isOutOfBounds, "x"
  boundable.isOutOfBoundsY = _.partial boundable.isOutOfBounds, "y"

  boundable
