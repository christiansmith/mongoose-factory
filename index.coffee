async = require 'async'
_ = require 'underscore'

class Factory
  constructor: (options) ->
    @model = options.model
    @documents = options.documents
    @created = {}

  build: (doc) ->
    new @model @documents[doc]

  create: (docs, done) ->
    factory = @
    docs = [docs] unless Array.isArray(docs)
    fns = _.map docs, (doc) ->
      return (callback) ->
        o = new factory.model(factory.documents[doc])
        o.save (err) ->
          factory.created[doc] = o
          callback err, o
    async.parallel fns, ->
      done(null, factory.created)

  clear: (done) ->
    @model.remove {}, done

module.exports = Factory
