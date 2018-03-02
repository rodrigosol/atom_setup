fs = require "fs"
RubyEditor = require "./ruby-editor"
SchemaContent = require "./schema-content"

class SchemaService
  constructor: ->
    @modelEditor = new RubyEditor(atom.workspace.getActivePaneItem())

  shouldLoadSchema: ->
    @modelEditor.ruby() && @modelEditor.mainClass()?

  canLoadSchema: ->
    @modelEditor.schemaFile()?

  schemaContent: ->
    schemaFile = @schemaFile()
    if schemaFile?
      schemaContent = new SchemaContent(
        @modelEditor.mainClass(),
        @modelEditor.superClass(),
        @modelEditor.declaredTableName()
      )
      schemaContent.fill(fs.readFileSync(schemaFile))
      schemaContent

  schemaFile: ->
    @modelEditor.schemaFile()

module.exports = SchemaService
