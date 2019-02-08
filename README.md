# Sitrep [![Build Status](https://travis-ci.org/cultivatedcode/sitrep.svg?branch=master)](https://travis-ci.org/cultivatedcode/sitrep) [![Coverage Status](https://coveralls.io/repos/github/cultivatedcode/sitrep/badge.svg?branch=master)](https://coveralls.io/github/cultivatedcode/sitrep?branch=master) [![Ebert](https://ebertapp.io/github/cultivatedcode/sitrep.svg)](https://ebertapp.io/github/cultivatedcode/sitrep)

## Getting started

Sitrep works with a json config file that defines the end points you would like to monitor and at what interval.  The config file looks like this:

```
{
   "services": 
   [{
      "type": "web",
      "name": "marketing-site",
      "health_check_url": "https://www.cultivatedcode.com",
      "test_interval_in_minutes": 10
   },
   {
      "type": "web",
      "name": "other",
      "health_check_url": "http://web",
      "test_interval_in_minutes": 50
   }
   ]
}
```

Sitrep using slack as it's notification engine.  Go to slack and create a custom bot to get your slack API token.  Now you can start the sitrep docker container by passing in your slack token and config file via a volume mapping to /etc/sitrep/config.json.  Something like this:

`docker run -d -e SLACK_TOKEN=your-token-here -v $PWD/sitrep-config.json:/etc/sitrep/config.json cultivatedcode/sitrep`

In slack you should see your bot come online.  To view the status of the monitoring you can view docker logs.