path = require "path"
fs = require "fs"

SCHEMA_FILE = "db/schema.rb"
CLASS_REGEX = /class ([a-zA-Z0-9:]+)([\s]+<[\s]+([a-zA-Z0-9:]+))?/
DECLARED_TABLE_REGEXP = /self\.table_name[\s]+=[\s]["']+([a-zA-Z0-9:]+)["']?/

findFile = (directory, file) ->
  location = path.join(directory, file)
  if fs.existsSync(location)
    location
  else
    parentLocation = path.resolve(directory, "..")
    if directory != parentLocation
      findFile(parentLocation, file)

class RubyEditor
  constructor: (@editor) ->
    @file = @editor?.buffer?.file

  ruby: ->
    @file && @file.path && (path.extname(@file.path) == ".rb")

  declaredTableName: ->
    @_declaredTableName ?= @_getDeclaredTableName()

  mainClass: ->
    @_mainClass ?= @_getMainClass()

  superClass: ->
    @_superClass ?= @_getSuperClass()

  schemaFile: ->
    @_schemaFile ?= @_getSchemaFile()

  _getSchemaFile: ->
    @file && @file.path && findFile(path.dirname(@file.path), SCHEMA_FILE)

  _getMainClass: ->
    @_classMatch() && @_classMatch()[1]

  _getSuperClass: ->
    @_classMatch() && @_classMatch()[3]

  _classMatch: ->
    @_classMatchResult ?= @_getClassMatch()

  _getClassMatch: ->
    content = @editor.getBuffer().cachedText ? ""
    content.match(CLASS_REGEX)

  _getDeclaredTableName: ->
    content = @editor.getBuffer().cachedText ? ""
    declaredTableMatch = content.match(DECLARED_TABLE_REGEXP)
    declaredTableMatch && declaredTableMatch[1]

module.exports = RubyEditor
