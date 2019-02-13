require 'curb'
require 'json'

api_key = ENV['OPSGENIE_APIKEY']
schedule_identifier = ENV['OPSGENIE_SCHEDULE_IDENTIFIER']

=begin
Poll the on-call schedule (if defined) and display the recipients
in a List widget
=end
if schedule_identifier
  SCHEDULER.every '10s', :first_in => 0 do |job|
    on_call_response = Curl.get("https://api.opsgenie.com/v2/schedules/#{schedule_identifier}/on-calls?flat=true") do |http|
      http.headers['Authorization'] = "GenieKey #{api_key}"
    end

    on_call_recipients = JSON.parse(on_call_response.body)['data']['onCallRecipients']
    
    if on_call_recipients.length == 0 
      send_event('opsgenie_on_call', items: [{'value': 'Not Set'}])
    else
    on_call_items = []
    on_call_recipients.each do |person| 
      item_entry = {'label': '', 'value': person}
      on_call_items.push(item_entry)
    end
      send_event('opsgenie_on_call', items: on_call_items)
    end 
  end
else
  send_event('opsgenie_on_call', items: [{'value': 'Not Set'}])
end

=begin
Poll the alerts endpoint and display the following 
  - Open alerts
  - Un-Ack alerts
  - Un-Seen alerts
  - P1, P2, P3 alerts
=end

SCHEDULER.every '30s', :first_in => 0 do |job|

  alerts_response = Curl.get("https://api.opsgenie.com/v2/alerts?query=status:open") do |http|
	  http.headers['Authorization'] = "GenieKey #{api_key}"
  end

  alerts = JSON.parse(alerts_response.body)['data']
  
  open_alerts   = alerts.count
  unseen_alerts = 0
  unack_alerts  = 0
  p1_alerts     = 0
  p2_alerts     = 0
  p3_alerts     = 0
  
  alerts.each do |a|
    if a["isSeen"] == false
      unseen_alerts +=1
    end

    if a["acknowledged"] == false
      unack_alerts +=1
    end

    if a["priority"] == "P1"
      p1_alerts +=1
    end
    if a["priority"] == "P2"
      p2_alerts +=1
    end
    if a["priority"] == "P3"
      p3_alerts +=1
    end
  end

  send_event('opsgenie_open', value: open_alerts)
  send_event('opsgenie_unseen', value: unseen_alerts)
  send_event('opsgenie_unack', value: unack_alerts)
  send_event('opsgenie_p1', value: p1_alerts)
  send_event('opsgenie_p2', value: p2_alerts)
  send_event('opsgenie_p3', value: p3_alerts)

end
