require 'curb'
require 'json'

SCHEDULER.every '30s', :first_in => 0 do |job|
  opsgenie_key = "..."
  raw_alerts = Curl.get("https://api.opsgenie.com/v2/alerts?query=acknowledged:false") do |http|
	  http.headers['Authorization'] = "GenieKey #{opsgenie_key}"
	
  end

  alerts = JSON.parse(raw_alerts.body_str)['data'].count
  raw_alerts = Curl.get("https://api.opsgenie.com/v2/alerts?query=status:open") do |http|
	  http.headers['Authorization'] = "GenieKey #{opsgenie_key}"
  end
  open_alerts = JSON.parse(raw_alerts.body_str)['data'].count

  send_event('opsgenie_unack', { title: "Unacknowledged<br>Alerts", value: alerts })
  send_event('opsgenie_open', { title: "Open<br>Alerts", value: open_alerts})
end
