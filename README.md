## Overview

A dashboard for [OpsGenie](https://opsgenie.com) using [Smashing](https://smashing.github.io/).

This makes use of the OpsGenie API for probing alerts and schedules and provides live updates. 

## TODO

- Support multiple environments (dev/prod/staging/etc)
 - Currently we just derive from the API key that's used
- Make schedule support more flexible
  - We support 2 widgets (each points to a different schedule...should be more custom)
- Support mappings for P1/P2/P3 (i.e. some alerts might use Critical/Warning/Info)
  - We look for P1/P2/P3 etc, but should support others

## Usage

Create a `.env` file with the following:

```
GEMS=curb

OPSGENIE_APIKEY=<YOUR_OPSGENIE_APIKEY>
OPSGENIE_SCHEDULE_IDENTIFIER_ON_CALL=<OPTIONAL_OPSGENIE_SCHEDULE_IDENTIFIER_ID>
OPSGENIE_SCHEDULE_IDENTIFIER_ON_TRIAGE=<OPTIONAL_OPSGENIE_SCHEDULE_IDENTIFIER_ID>
```

```
docker-compose up
```

Browse to http://localhost:8080

## Screen shots

![Index Page](docs/opsgenie.png)
