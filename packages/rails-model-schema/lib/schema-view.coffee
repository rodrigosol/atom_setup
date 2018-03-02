{$, jQuery, View} = require "atom-space-pen-views"

class SchemaView extends View
  events:
    copyAttributeName: ({target}) ->
      attributeName = $(target).data("attribute")
      atom.clipboard.write(attributeName)
      atom.notifications.addInfo("Copied: \"#{attributeName}\".")

    goToSchemaLine: ({target}) ->
      file = $(target).data("file")
      line = $(target).data("line")
      atom.workspace.open(file, initialLine: line)

  initialize: ->
    @rightPanel = null
    @on "click", ".copy-name", (event) => @events.copyAttributeName.call(this, event)
    @on "click", ".go-to-schema-line", (event) => @events.goToSchemaLine.call(this, event)

  @content: (schemaContent, schemaFile) ->
    @div class: "rails-model-schema", =>
      @table =>
        @thead =>
          @tr =>
            @th "Name"
            @th "Type"
            @th ""
        @tbody =>
          for {name, type, line} in schemaContent.getAttributes()
            @tr class: "attribute-row", =>
              @td =>
                @span class: "attribute-name", title: name, name
              @td type
              @td =>
                @span
                  class: "copy-name octicon octicon-clippy"
                  title: "copy name"
                  "data-attribute": name
                @span
                  class: "go-to-schema-line octicon octicon-link-external"
                  title: "go to schema.rb definition"
                  "data-file": schemaFile
                  "data-line": line
      @div class: "instructions", =>
        @ul =>
          @li =>
            @p =>
              @span class: "octicon octicon-clippy inline-icon"
              @span " will copy the attribute name."
          @li =>
            @p =>
              @span class: "octicon octicon-link-external inline-icon"
              @span " will open the schema.rb definition."

  display: ->
    @rightPanel = atom.workspace.addRightPanel(item: @element)

  destroy: ->
    @element.remove()
    @rightPanel?.destroy()

module.exports = SchemaView
