define (require) ->

  class EntityCache

    constructor: ->
      @entities = {}
      @

    all: ->
      _.clone @entities

    get: (name) ->
      @entities[name]

    set: (name, entity, overwrite = true) ->
      if !overwrite and @entities[name]?
        throw "EntityCache::set - Already has entity with name `#{name}`"
      @entities[name] = entity
      # Only listen to destroy events on entity models, not collections
      # because they'll handle their own removal
      @listenTo(entity, "destroy", @onDestroyEntity) if entity.idAttribute?
      @

    remove: (entityOrName) ->
      key = if _.isString(entityOrName) then entityOrName
      unless key?
        _.find @entities, (v, k) ->
          isTheEntity = v is entityOrName
          key = k if isTheEntity
          isTheEntity
      entity = @entities[key]
      delete @entities[key]
      @stopListening(entity)
      @

    onDestroyEntity: (entity) ->
      @remove(entity)

  _.extend EntityCache::, Backbone.Events

  EntityCache
