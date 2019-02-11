class Dashing.OpsgenieAlerts extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    if data['value'] == 0
      $(@node).removeClass('none some');
      $(@node).addClass('none')
    else
      $(@node).removeClass('none some');
      $(@node).addClass('some')
