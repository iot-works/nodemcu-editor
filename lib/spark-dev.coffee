module.exports =

  activate: (state) ->
    @StatusView ?= require './views/status-bar-view'
    @statusView = new @StatusView()

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
