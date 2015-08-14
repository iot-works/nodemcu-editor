{View} = require('atom-space-pen-views')
CompositeDisposable = null
shell = null
$ = null
SettingsHelper = null
spark = null
ESP = null

module.exports =
  class StatusBarView extends View
    @content: ->
      @div =>
        @div id: 'spark-icon', class: 'inline-block', outlet: 'logoTile', =>
          @img src: 'atom://spark-dev/images/spark.png'

    initialize: (serializeState) ->
      {$} = require('atom-space-pen-views')
      {CompositeDisposable} = require 'atom'
      ESP = require('esptoolpy-js');

      @disposables = new CompositeDisposable
      @workspaceElement = atom.views.getView(atom.workspace)

      @getAttributesPromise = null
      @interval = null
      ESP.read_mac '/dev/cu.SLAB_USBtoUART', (result) ->
        console.log result.toString()
        return

    destroy: ->

    addTiles: (statusBar) ->
      statusBar.addLeftTile(item: @logoTile, priority: 100)

    clear: ->
      @logTile.fadeOut =>
        @setStatus ''
        @logTile.show()

    clearAfter: (delay) ->
      setTimeout =>
        @clear()
      , delay
