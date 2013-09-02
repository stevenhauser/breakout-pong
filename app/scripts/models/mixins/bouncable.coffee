define (require) ->

  bouncable =

    bouncable: ->
      @listenTo @, "collided", @onBouncableCollided
      @

    reverseDirection: (axis) ->
      dirProp = "dir#{axis.toUpperCase()}"
      @[dirProp]( @[dirProp]() * -1 )
      @

    bounce: (axis) ->
      @accelerate(axis).reverseDirection(axis)
      @

    bounceOff: (entity) ->
      @bounce @getMainCollisionAxis(entity)
      @

    onBouncableCollided: (entity) ->
      @["bounceOff#{entity.constructor.name}"]?(entity) or @bounceOff(entity)

  bouncable.reverseDirectionX  = _.partial bouncable.reverseDirection, "x"
  bouncable.reverseDirectionY  = _.partial bouncable.reverseDirection, "y"
  bouncable.increaseSpeedX     = _.partial bouncable.increaseSpeed, "x"
  bouncable.increaseSpeedY     = _.partial bouncable.increaseSpeed, "y"
  bouncable.bounceX            = _.partial bouncable.bounce, "x"
  bouncable.bounceY            = _.partial bouncable.bounce, "y"

  bouncable
