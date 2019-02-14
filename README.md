## Overview

An docker [OpsGenie](https://opsgenie.com) dashboard using [Smashing](https://smashing.github.io/).

This makes use of the OpsGenie Alerts and Schedules REST endpoints.

## TODO

- Support multiple environments (dev/prod/staging/etc)
- Support multiple schedules (on-call/daily-triage/etc)

## Usage

Create a `.env` file with the following:

```
OPSGENIE_APIKEY=<YOUR_OPSGENIE_APIKEY>
OPSGENIE_SCHEDULE_IDENTIFIER=<YOUR_SCHEDULE_IDENTIFIER_ID>
GEMS=curb
```

```
docker-compose up
```

Browse to http://localhost:8080

## Screen shots

![Index Page](docs/opsgenie.png)
