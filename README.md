## Overview

A *Smashing* dashboard app. with OpsGenie integration.

## TODO

- Support multiple environments
- Support multiple schedules (on-call + daily-triage)

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
