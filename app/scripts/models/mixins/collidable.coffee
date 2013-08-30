define (require) ->

  collidable =

    isCollidingWithOnAxis: (axis, entity) ->
      o1 = @["#{axis}1"]()
      o2 = @["#{axis}2"]()
      e1 = entity["#{axis}1"]()
      e2 = entity["#{axis}2"]()
      e1 <= o1 <= e2 or e1 <= o2 <= e2

    isCollidingWith: (entity) ->
      @isCollidingWithOnX(entity) and @isCollidingWithOnY(entity)

  collidable.isCollidingWithOnX = _.partial collidable.isCollidingWithOnAxis, "x"
  collidable.isCollidingWithOnY = _.partial collidable.isCollidingWithOnAxis, "y"

  collidable
