{SelectView} = require 'spark-dev-views'

$$ = null
_s = null
WifiHelper = null

module.exports =
  class SetupWifiView extends SelectView
    initialize: ->
      super

      {$$} = require 'atom-space-pen-views'
      @cp = require 'child_process'
      _s ?= require 'underscore.string'
      WifiHelper ?= require '../utils/wifi-helper'

      @prop 'id', 'iot-dev-select-wifi-view'
      @port = null

    show: =>
      console.log '----------------'
      console.log 'show'
      @listNetworks()
      super

    viewForItem: (item) ->
      security = null

      switch item.security
        when 0
          security = 'Unsecured'
        when 1
          security = 'WEP'
        when 2
          security = 'WPA'
        when 3
          security = 'WPA2'

      $$ ->
        @li class: 'two-lines', =>
          if security
            @div class: 'pull-right', =>
              @kbd class: 'key-binding pull-right', security
          @div item.ssid

    confirmed: (item) ->
      @hide()
      if item.security
        atom.sparkDev.emitter.emit 'iot-dev:enter-wifi-credentials',
          port: @port
          ssid: item.ssid
          security: item.security
      else
        atom.sparkDev.emitter.emit 'iot-dev:enter-wifi-credentials',
          port: @port

    getPlatform: ->
      process.platform

    getFilterKey: ->
      'ssid'

    setNetworks: (networks) ->
      if networks.length > 0
        @setItems(networks.concat @items)
        @removeClass 'loading'
        @focusFilterEditor()
      else
        @setLoading()

    listNetworks: ->
      @addClass 'loading'
      console.log 'loading'
      @focusFilterEditor()
      @items = [{
        ssid: 'Enter SSID manually',
        security: null,
      }]
      @setItems @items
      @setLoading 'Scaning for networks...'

      WifiHelper.listNetworks().then (networks) =>
        @setNetworks networks
