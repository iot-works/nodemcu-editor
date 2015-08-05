settingsPath = '../vendor/settings'
module.exports =
  # Set key to value
  set: (key, value) ->
    delete require.cache[require.resolve(settingsPath)]

    settings = require settingsPath
    settings.override null, key, value

  # Get local (current window's) key's value
  getLocal: (key) ->
    if window.localSettings
      return window.localSettings[key]
    null

  # Set local (current window's) key to value
  setLocal: (key, value) ->
    if !window.localSettings
      window.localSettings = {}

    window.localSettings[key] = value

  # Get key's value
  get: (key) ->
    delete require.cache[require.resolve(settingsPath)]

    settings = require settingsPath
    settings[key]
