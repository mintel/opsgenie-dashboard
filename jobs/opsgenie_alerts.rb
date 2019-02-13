require 'curb'
require 'json'

api_key = ENV['OPSGENIE_APIKEY']

SCHEDULER.every '5s', :first_in => 0 do |job|

  response = Curl.get("https://api.opsgenie.com/v2/alerts?query=status:open") do |http|
	  http.headers['Authorization'] = "GenieKey #{api_key}"
  end

  alerts = JSON.parse(response.body)['data']

  open_alerts   = alerts.count
  unseen_alerts = 0
  unack_alerts  = 0
  p1_alerts     = 0
  p2_alerts     = 0
  p3_alerts     = 0

  alerts.each do |a|
    if a["isSeen"] == false
      puts "Got "
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

  send_event('opsgenie_open', { title: "Open", value: open_alerts })
  send_event('opsgenie_unseen', { title: "UnSeen", value: unseen_alerts })
  send_event('opsgenie_unack', { title: "UnAck", value: unack_alerts })
  send_event('opsgenie_p1', { title: "P1", value: p1_alerts })
  send_event('opsgenie_p2', { title: "P2", value: p2_alerts })
  send_event('opsgenie_p3', { title: "P3", value: p3_alerts })
end
