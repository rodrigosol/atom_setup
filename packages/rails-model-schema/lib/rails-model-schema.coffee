{ CompositeDisposable } = require "atom"
SchemaEditorsCollection = require "./schema-editors-collection"

module.exports = RailsModelSchema =
  subscriptions: null
  immediatelySubscription: null

  config:
    showImmediately:
      type: "boolean"
      default: true
      description: "Show the schema panel when opening a file."
    sortByAlphabeticalOrder:
      type: "boolean"
      default: false
      description: "Sort the attributes by alphabetical order."

  serialize: -> {}

  activate: ->
    @subscriptions = new CompositeDisposable
    @editors = new SchemaEditorsCollection(@subscriptions)

    @subscriptions.add atom.commands.add 'atom-text-editor[data-grammar~="ruby"]:not([mini])',
      'rails-model-schema:toggle': => @toggle()

    @subscriptions.add atom.config.observe('rails-model-schema.showImmediately', (value) =>
      if value
        @enableImmediately()
      else
        @disableImmediately()
    )

  enableImmediately: ->
    @immediatelySubscription = atom.workspace.onDidChangeActivePaneItem((pane) =>
      if pane?
        editor = @editors.findByPane(pane) || @editors.add(pane, enabled: true)
        @editors.activateEditor(editor)
      else
        @editors.deactivateCurrentEditors()
    )

  disableImmediately: ->
    @immediatelySubscription?.dispose()
    @immediatelySubscription = null

  deactivate: ->
    @disableImmediately()
    @editors.deactivateCurrentEditors()
    @subscriptions.dispose()

  toggle: ->
    pane = atom.workspace.getActivePaneItem()
    if editor = @editors.findByPane(pane)
      editor?.toggle()
    else
      editor = @editors.add(pane, enabled: true)
      @editors.activateEditor(editor)
