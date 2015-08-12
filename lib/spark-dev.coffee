CompositeDisposable = null
Emitter = null
_s = null

module.exports =

  activate: (state) ->
    @StatusView ?= require './views/status-bar-view'
    @statusView = new @StatusView()
    {CompositeDisposable, Emitter} = require 'atom'
    @disposables = new CompositeDisposable
    @emitter = new Emitter
    atom.sparkDev =
      emitter: @emitter

    @disposables.add atom.commands.add 'atom-workspace',
      'iot-dev:show-serial-monitor': => @showSerialMonitor()
      'iot-dev:setup-wifi': => @setupWifi()

    @emitter.on 'spark-dev:enter-wifi-credentials', (event) =>
      @enterWifiCredentials(event.port, event.ssid, event.security)

    url = require 'url'
    atom.workspace.addOpener (uriToOpen) =>
      console.log(uriToOpen)
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
        return

      return unless protocol is 'iot-dev:'

      try
        console.log pathname.substr(1)
        @initView pathname.substr(1)
      catch
        return

  initView: (name) ->
    _s ?= require 'underscore.string'

    name += '-view'
    className = ''
    for part in name.split '-'
      className += _s.capitalize part

    @[className] ?= require './views/' + name
    key = className.charAt(0).toLowerCase() + className.slice(1)
    console.log(className)
    @[key] ?= new @[className]()
    @[key]


  consumeStatusBar: (statusBar) ->
    @statusView.addTiles statusBar

  consumeToolBar: (toolBar) ->
    @toolBar = toolBar 'iot-dev-tool-bar'

    @toolBar.addSpacer()
    @flashButton = @toolBar.addButton
      icon: 'flash'
      callback: 'iot-dev:flash-cloud'
      tooltip: 'Compile and upload code using cloud'
      iconset: 'ion'

    @toolBar.addSpacer()

    @toolBar.addButton
      icon: 'document-text'
      callback: ->
        require('shell').openExternal('https://github.com/nodemcu/nodemcu-firmware/wiki')
      tooltip: 'Opens NodeMCU Document'
      iconset: 'ion'
    @wifiButton = @toolBar.addButton
      icon: 'wifi'
      callback: 'iot-dev:setup-wifi'
      tooltip: 'Setup NodeMCU WiFi'
      iconset: 'ion'
    @toolBar.addButton
      icon: 'usb'
      callback: 'iot-dev:show-serial-monitor'
      tooltip: 'Show serial monitor'
      iconset: 'ion'


  setupWifi: ->
    @setupWifiView = null
    @openPane 'setup-wifi'
    @setupWifiView.show()

  showSerialMonitor: ->
    @serialMonitorView = null
    @openPane 'serial-monitor'

  enterWifiCredentials: (port, ssid=null, security=null) -> @loginRequired =>
    if !port
      return

    @wifiCredentialsView = null
    @initView 'wifi-credentials'
    @wifiCredentialsView.port = port
    @wifiCredentialsView.show(ssid, security)

  openPane: (uri) ->
    uri = 'iot-dev://editor/' + uri
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
