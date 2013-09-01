define (require) ->

  collidable =

    # Checks if `this` and `entity` are colliding in a specific side,
    # meaning that their sides are overlapping. If one object is wholly
    # within the other though, their sides are not overlapping and this
    # will return false. Contrast with `isCollidingWithOnAxis`
    isCollidingWithOnSide: (side, entity) ->
      axis = if side is "left" or side is "right" then "x" else "y"
      num  = if side is "bottom" or side is "right" then 1 else 2
      @["#{axis}1"]() <= entity["#{axis}#{num}"]() <= @["#{axis}2"]()

    # Checks if `this` and `entity` are colliding on a specific axis,
    # meaning that `this`'s coords on `axis` are between `entity`'s.
    # If `this` is anywhere within the axis, it will return true.
    # Contrast with `isCollidingWithOnSide`
    isCollidingWithOnAxis: (axis, entity) ->
      o1 = @["#{axis}1"]()
      o2 = @["#{axis}2"]()
      e1 = entity["#{axis}1"]()
      e2 = entity["#{axis}2"]()
      e1 <= o1 <= e2 or e1 <= o2 <= e2

    isCollidingWith: (entity, trigger = true) ->
      isColliding = @isCollidingWithOnX(entity) and @isCollidingWithOnY(entity)
      if isColliding and trigger
        @trigger("collided", entity)
        entity.trigger("collided", @)
      isColliding

    # Returns the amount of overlap between `this` and `entity` on `side`
    # The higher the number, the more they're overlapping
    getCollisionDistance: (side, entity) ->
      return -Infinity unless @isCollidingWithOnSide(side, entity)
      delta = switch side
        when "top"    then @y1() - entity.y2()
        when "right"  then @x2() - entity.x1()
        when "bottom" then @y2() - entity.y1()
        when "left"   then @x1() - entity.x2()
      Math.abs(delta)

    getCollisionDistances: (entity) ->
      throw "Entities #{@identifier()} and #{entity.identifier()} are not colliding" unless @isCollidingWith(entity, false)
      sides = "top right bottom left".split(" ")
      distances = sides.map (side) => @getCollisionDistance(side, entity)
      _.object sides, distances

    getMainCollisionSide: (entity) ->
      distancesObj = @getCollisionDistances(entity)
      for side, distance of distancesObj
        delete distancesObj[side] if distance is -Infinity
      _.invert(distancesObj)[_.min(distancesObj)]

    getMainCollisionAxis: (entity) ->
      side = @getMainCollisionSide(entity)
      if side is "left" or side is "right" then "x" else "y"

    isMainCollisionAxis: (axis, entity) ->
      @getMainCollisionAxis(entity) is axis

  collidable.isCollidingWithOnX      = _.partial collidable.isCollidingWithOnAxis, "x"
  collidable.isCollidingWithOnY      = _.partial collidable.isCollidingWithOnAxis, "y"
  collidable.isCollidingWithOnTop    = _.partial collidable.isCollidingWithOnSide, "top"
  collidable.isCollidingWithOnRight  = _.partial collidable.isCollidingWithOnSide, "right"
  collidable.isCollidingWithOnBottom = _.partial collidable.isCollidingWithOnSide, "bottom"
  collidable.isCollidingWithOnLeft   = _.partial collidable.isCollidingWithOnSide, "left"
  collidable.isMainCollisionAxisX    = _.partial collidable.isMainCollisionAxis, "x"
  collidable.isMainCollisionAxisY    = _.partial collidable.isMainCollisionAxis, "y"

  collidable
