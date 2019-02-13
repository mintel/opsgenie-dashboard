## Overview

A *Smashing* dashboard app. with OpsGenie integration.

## TODO

- Support multiple environments
- Support on-call visibility (who is on call)
- Update colour for P3 alerts (or remove if not required)

## Usage

Create a `.env` file with the following:

```
OPSGENIE_APIKEY=<YOUR_OPSGENIE_APIKEY>
GEMS=curb
```

```
docker-compose up
```

Browse to http://localhost:8080

## Screen shots

![Index Page](docs/opsgenie.png)
