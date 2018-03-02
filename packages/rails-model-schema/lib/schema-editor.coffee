SchemaService = require "./schema-service"
SchemaView = require "./schema-view"
PathWatcher = require "pathwatcher"

class SchemaEditor
  constructor: (@pane, @enabled) ->
    @view = null
    @schemaWatcher = null

  toggle: ->
    if @view?
      @enabled = false
      @deactivate()
    else
      @tryActivation(true)

  tryActivation: (withNotifications) ->
    schemaService = new SchemaService

    if not schemaService.shouldLoadSchema()
      @_warn "Can only show model schemas inside of a ruby file with a class." if withNotifications
    else if not schemaService.canLoadSchema()
      @_warn "You need to have a schema.rb file in the top of the project." if withNotifications
    else
      @schemaWatcher ?= @_watchSchema(schemaService.schemaFile())
      content = schemaService.schemaContent()
      if not content.tableFound
        if withNotifications
          if content.superTableName
            @_warn """
              No tables \"#{content.tableName}\" or \"#{content.superTableName}\" in schema file.
            """
          else
            @_warn "No table \"#{content.tableName}\" in schema file."
      else
        @_renderView(content, schemaService.schemaFile())

  deactivate: ->
    @schemaWatcher?.close()
    @view?.destroy()
    @view = null

  _renderView: (schemaContent, schemaFile) ->
    @view = new SchemaView(schemaContent, schemaFile)
    @view.display()
    @enabled = true

  _warn: (args...) ->
    atom.notifications.addWarning.apply(atom.notifications, args)

  _watchSchema: (schemaFile) ->
    PathWatcher.watch schemaFile, (event) =>
      @tryActivation(false)

module.exports = SchemaEditor
