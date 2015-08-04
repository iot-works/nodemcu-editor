module.exports =
  consumeStatusBar: (statusBar) ->
    @statusView.addTiles statusBar
    # @statusBarTile = statusBar.addLeftTile(item: @statusView, priority: 100)
    @statusView.updateLoginStatus()

  consumeToolBar: (toolBar) ->
    @toolBar = toolBar 'spark-dev-tool-bar'

    @toolBar.addSpacer()
    @flashButton = @toolBar.addButton
      icon: 'flash'
      callback: 'spark-dev:flash-cloud'
      tooltip: 'Compile and upload code using cloud'
      iconset: 'ion'
    @compileButton = @toolBar.addButton
      icon: 'checkmark-circled'
      callback: 'spark-dev:compile-cloud'
      tooltip: 'Compile and show errors if any'
      iconset: 'ion'

    @toolBar.addSpacer()

    @toolBar.addButton
      icon: 'document-text'
      callback: ->
        require('shell').openExternal('http://docs.spark.io/')
      tooltip: 'Opens reference at docs.spark.io'
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

    @updateToolbarButtons()

  # Require view's module and initialize it
  initView: (name) ->
    console.log(name)
