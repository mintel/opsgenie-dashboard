require 'curb'
require 'json'

api_url = 'https://api.opsgenie.com/v2'

api_key = ENV['OPSGENIE_APIKEY']
schedule_identifier_on_call = ENV['OPSGENIE_SCHEDULE_IDENTIFIER_ON_CALL']
schedule_identifier_on_triage = ENV['OPSGENIE_SCHEDULE_IDENTIFIER_ON_TRIAGE']
search_identifier_id = ENV['OPSGENIE_SEARCH_IDENTIFIER_ID']

=begin
Helper function to call schedule API and get recipient information
=end

def send_schedule_event(api_url, api_key, schedule_id, event_id)
  on_call_response = Curl.get("#{api_url}/schedules/#{schedule_id}/on-calls?flat=true") do |http|
    http.headers['Authorization'] = "GenieKey #{api_key}"
  end

  on_call_recipients = JSON.parse(on_call_response.body)['data']['onCallRecipients']
  
  if on_call_recipients.length == 0 
    send_event("#{event_id}", items: [{'value': 'N/A'}])
  else
    on_call_items = []
    on_call_recipients.each do |person| 
      # Remove the @mintel.com from the alias
      person_name = person.split('@')[0]
      item_entry = {'label': '', 'value': person_name}
      on_call_items.push(item_entry)
    end
    send_event("#{event_id}", items: on_call_items)
  end 
end


=begin
Poll the on-call schedule (if defined) and display the recipients
in a List widget
=end

if schedule_identifier_on_call
  SCHEDULER.every '120s', :first_in => 0 do |job|
    send_schedule_event(api_url, api_key, schedule_identifier_on_call, 'opsgenie_on_call')
  end
else
  send_event('opsgenie_on_call', items: [{'value': 'N/A'}])
end

=begin
Poll the on-triage schedule (if defined) and display the recipients
in a List widget
=end

if schedule_identifier_on_triage
  SCHEDULER.every '120s', :first_in => 0 do |job|
    send_schedule_event(api_url, api_key, schedule_identifier_on_triage, 'opsgenie_on_triage')
  end
else
  send_event('opsgenie_on_triage', items: [{'value': 'N/A'}])
end


=begin
Poll the alerts endpoint and display the following 
  - Open alerts
  - Un-Ack alerts
  - Un-Seen alerts
  - P1, P2, P3 alerts
=end

SCHEDULER.every '60s', :first_in => 0 do |job|

  if search_identifier_id
    query = "searchIdentifier=#{search_identifier_id}"
  else
    query = "query=status:open"
  end

  alerts_response = Curl.get("#{api_url}/alerts/?#{query}") do |http|
	  http.headers['Authorization'] = "GenieKey #{api_key}"
  end

  alerts = JSON.parse(alerts_response.body)['data']

  open_alerts   = 0
  unseen_alerts = 0
  unack_alerts  = 0
  p1_alerts     = 0
  p2_alerts     = 0
  p3_alerts     = 0
 
  if alerts
    alerts.each do |a|

      next if a["priority"] == "P5"

      open_alerts +=1 

      if a["isSeen"] == false
        unseen_alerts +=1
      end

      if a["acknowledged"] == false
        unack_alerts +=1
      end

      # TODO: Make this mapping configurable
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
    end

  send_event('opsgenie_open', value: open_alerts)
  send_event('opsgenie_unseen', value: unseen_alerts)
  send_event('opsgenie_unack', value: unack_alerts)
  send_event('opsgenie_p1', value: p1_alerts)
  send_event('opsgenie_p2', value: p2_alerts)
  send_event('opsgenie_p3', value: p3_alerts)
end
