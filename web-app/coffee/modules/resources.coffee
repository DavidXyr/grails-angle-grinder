resources = angular.module("angleGrinder.resources", ["ngResource"])

# This module defines the resource mappings required by Angular JS to map to a
# standard Grails CRUD URL scheme that uses `"/$controller/$action?/$id?"`.
resources.factory "Resource", [
  "$resource", "$document", ($resource, $document) ->
    baseUrl = $document.find("body").data("base-url")

    Resource = $resource "#{baseUrl}:action/:id", { id: "@id" },
      list:   { method: "GET",  params: { action: "list" }, isArray: true }
      get:    { method: "GET",  params: action: "get" }
      save:   { method: "POST", params: action: "save" }
      update: { method: "POST", params: action: "update" }
      delete: { method: "POST", params: action: "delete" }

    angular.extend Resource.prototype,
      # Retunrs true if the record is persisted (has an id)
      persisted: -> @id?

      # Return true if the record is not persisted
      newRecord: -> not @persisted()

      # Backbone style save() that inserts or updated the record
      # based on the presence of an id.
      save: (options) ->
        method = if not @persisted() then "save" else "update"
        Resource[method]({}, this, options.success, options.error)

      delete: (options) ->
        Resource.delete({}, this, options.success, options.error)

    Resource
]