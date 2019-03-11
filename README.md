## Overview

A dashboard for [OpsGenie](https://opsgenie.com) using [Smashing](https://smashing.github.io/).

This makes use of the OpsGenie API for probing alerts and schedules and provides live updates.

## Usage

Create a `.env` file with the following:

```
GEMS=curb

OPSGENIE_APIKEY=<YOUR_OPSGENIE_APIKEY>
OPSGENIE_SCHEDULE_IDENTIFIER_ON_CALL=<OPTIONAL_OPSGENIE_SCHEDULE_IDENTIFIER_ID>
OPSGENIE_SCHEDULE_IDENTIFIER_ON_TRIAGE=<OPTIONAL_OPSGENIE_SCHEDULE_IDENTIFIER_ID>
OPSGENIE_SEARCH_IDENTIFIER_ID=<OPTIONAL_OPSGENIE_SEARCH_IDENTIFIER_ID>
```

```
docker-compose up
```

Browse to http://localhost:8080

## Saved Searches

You can specify a single search for the dashboard using `OPSGENIE_SEARCH_IDENTIFIER_ID`

To list searches for your integration, use the following:

```
curl -H "Authorization: GenieKey <API-KEY>" https://api.opsgenie.com/v2/alerts/saved-searches/
```

## Screen shots

![Index Page](docs/opsgenie.png)
