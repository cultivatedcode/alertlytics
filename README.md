# Alertlytics [![Build Status](https://travis-ci.org/cultivatedcode/alertlytics.svg?branch=master)](https://travis-ci.org/cultivatedcode/alertlytics) [![Coverage Status](https://coveralls.io/repos/github/cultivatedcode/alertlytics/badge.svg?branch=master)](https://coveralls.io/github/cultivatedcode/alertlytics?branch=master) [![Ebert](https://ebertapp.io/github/cultivatedcode/alertlytics.svg)](https://ebertapp.io/github/cultivatedcode/alertlytics)

## Getting started

Alertlytics works with a json config file that defines the end points you would like to monitor and at what interval.  The config file looks like this:

```
{
   "channel": "#devops",
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

Alertlytics uses slack as it's notification engine.  Go to slack and create a custom bot to get your slack API token.  Now you can start the Alertlytics docker container by passing in your slack token as an environment variable and config file via a volume mapping to /etc/alertlytics/config.json.  Something like this:

`docker run -d -e SLACK_TOKEN=your-token-here -v $PWD/alertlytics-config.json:/etc/alertlytics/config.json cultivatedcode/alertlytics`

In slack you should see your bot come online.  You will receive alerts of any services that do not respond with a 200 status code in the slack channel you have defined in the config.json.  To view the status of the monitoring you can view docker logs. 