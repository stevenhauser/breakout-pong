define (require) ->

  uppercaseFirst: (str) ->
    str.charAt(0).toUpperCase() + str.slice(1)

  pixelize: (val) ->
    val + "px"
