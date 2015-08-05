SettingsHelper = require './settings-helper'

module.exports =
  # Get root menu
  getMenu: ->
    devMenu = atom.menu.template.filter (value) ->
      value.label == 'Particle'

    devMenu[0]

  # Update menu
  update: ->
    devMenu = @getMenu()

    devMenu.submenu = devMenu.submenu.concat [{
      type: 'separator'
    },{
      label: 'Show serial monitor',
      command: 'iot-dev:show-serial-monitor'
    }]

    # Refresh UI
    atom.menu.update()

    @workspaceElement = atom.views.getView(atom.workspace)
    atom.commands.dispatch @workspaceElement, 'spark-dev:append-menu'

  append: (items) ->
    devMenu = @getMenu()
    devMenu.submenu = devMenu.submenu.concat items
    atom.menu.update()
