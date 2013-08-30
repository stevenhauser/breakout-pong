define (require) ->

  utils = require "utils"

  bounds = "top right bottom left".split(" ")

  getDimension = (obj, dim) ->
    _.result(obj, dim) or 0

  getCoordFromBound = (bound) ->
    if bound is "left" or bound is "right" then "x" else "y"

  half = (value) ->
    value / 2

  boundable =
    getBound: (bound) -> if @bounds? then @bounds[bound] else @[bound]
    topBound:         -> @getBound("top")
    rightBound:       -> @getBound("right") - getDimension(@, "width")
    bottomBound:      -> @getBound("bottom") - getDimension(@, "height")
    leftBound:        -> @getBound("left")

    midBoundX:        -> half @rightBound() - @leftBound()
    midBoundY:        -> half @bottomBound() - @topBound()

    isOutOfBoundsX:   -> @isOutsideLeftBound() or @isOutsideRightBound()
    isOutOfBoundsY:   -> @isOutsideTopBound() or @isOutsideBottomBound()
    isOutOfBounds:    -> @isOutOfBoundsX() or @isOutOfBoundsY()

    isOnBoundX:       -> @isOnLeftBound() or @isOnRightBound()
    isOnBoundY:       -> @isOnTopBound() or @isOnBBound()

    isOnBound: (bound) ->
      coord = getCoordFromBound(bound)
      @["#{coord}1"]() < @getBound(bound) < @["#{coord}2"]()

    isOutsideBound: (bound) ->
      coord = getCoordFromBound(bound)
      boundValue = @getBound(bound)
      switch bound
        when "top"    then @y2() < boundValue
        when "right"  then @x1() > boundValue
        when "bottom" then @y1() > boundValue
        when "left"   then @x2() < boundValue

  for bound in bounds
    do ->
      camelBound = utils.uppercaseFirst(bound)
      boundable["isOn#{camelBound}Bound"] = _.partial boundable.isOnBound, bound
      boundable["isOutside#{camelBound}Bound"] = _.partial boundable.isOutsideBound, bound

  boundable
