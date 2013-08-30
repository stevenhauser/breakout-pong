define (require) ->

  bounds = "top right bottom left".split(" ")

  boundable = {}

  for bound in bounds
    do (bound) -> boundable["#{bound}Bound"] = ->
      if @bounds? then @bounds[bound] else @[bound]

  boundable.rightRelativeBound = ->
    @rightBound() - (@width or @get("width"))

  boundable.bottomRelativeBound = ->
    @bottomBound() - (@height or @get("height"))

  boundable
