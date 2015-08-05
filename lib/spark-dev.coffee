CompositeDisposable = null

module.exports =

  activate: (state) ->
    @StatusView ?= require './views/status-bar-view'
    @statusView = new @StatusView()
    {CompositeDisposable, Emitter} = require 'atom'
    @disposables = new CompositeDisposable

    @disposables.add atom.commands.add 'atom-workspace',
      'spark-dev:show-serial-monitor': => @showSerialMonitor()

  consumeStatusBar: (statusBar) ->
    @statusView.addTiles statusBar
    # @statusBarTile = statusBar.addLeftTile(item: @statusView, priority: 100)
#    @statusView.updateLoginStatus()

  consumeToolBar: (toolBar) ->
    @toolBar = toolBar 'iot-dev-tool-bar'

    @toolBar.addSpacer()
    @flashButton = @toolBar.addButton
      icon: 'flash'
      callback: 'spark-dev:flash-cloud'
      tooltip: 'Compile and upload code using cloud'
      iconset: 'ion'

    @toolBar.addSpacer()

    @toolBar.addButton
      icon: 'document-text'
      callback: ->
        require('shell').openExternal('https://github.com/nodemcu/nodemcu-firmware/wiki')
      tooltip: 'Opens NodeMCU Document'
      iconset: 'ion'
    @coreButton = @toolBar.addButton
      icon: 'pinpoint'
      callback: 'spark-dev:select-device'
      tooltip: 'Select which device you want to work on'
      iconset: 'ion'
    @wifiButton = @toolBar.addButton
      icon: 'wifi'
      callback: 'spark-dev:setup-wifi'
      tooltip: 'Setup device\'s WiFi credentials'
      iconset: 'ion'
    @toolBar.addButton
      icon: 'usb'
      callback: 'spark-dev:show-serial-monitor'
      tooltip: 'Show serial monitor'
      iconset: 'ion'

  showSerialMonitor: ->
    @serialMonitorView = null
    @openPane 'serial-monitor'

  openPane: (uri) ->
    uri = 'spark-dev://editor/' + uri
    pane = atom.workspace.paneForURI uri

    if pane?
      pane.activateItemForURI uri
    else
      if atom.workspace.getPanes().length == 1
        pane = atom.workspace.getActivePane().splitDown()
      else
        panes = atom.workspace.getPanes()
        pane = panes.pop()
        pane = pane.splitRight()

      pane.activate()
      atom.workspace.open uri, searchAllPanes: true
