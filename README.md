# Alertlytics

[![Build Status](https://travis-ci.org/cultivatedcode/alertlytics.svg?branch=master)](https://travis-ci.org/cultivatedcode/alertlytics)
[![Coverage Status](https://coveralls.io/repos/github/cultivatedcode/alertlytics/badge.svg?branch=master)](https://coveralls.io/github/cultivatedcode/alertlytics?branch=master)
[![SourceLevel](https://app.sourcelevel.io/github/cultivatedcode/alertlytics.svg)](https://app.sourcelevel.io/github/cultivatedcode/alertlytics)
[![Docker Build](https://img.shields.io/docker/cloud/build/cultivatedcode/alertlytics.svg)](https://hub.docker.com/repository/docker/cultivatedcode/alertlytics)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/cultivatedcode/alertlytics/blob/master/LICENSE)

## Getting started

Alertlytics works with a json config file that defines the end points you would like to monitor and at what interval.  The config file looks like this:

```
{
   "channel": "#devops",
   "services":
   [{
      "id": "myco-marketingsite",
      "type": "http",
      "name": "marketing-site",
      "test_interval_in_seconds": 10,
      "config": {
        "health_check_url": "https://www.cultivatedcode.com"
      }
   },
   {
      "id": "myco-other",
      "type": "http",
      "name": "other",
      "test_interval_in_seconds": 60,
      "config": {
        "health_check_url": "http://web"
      }
   }]
}
```

### Dashboard UI

In your browser you can navigate to `http://localhost` to view the status of all your services.  The dashboard live reloads as services are updated behind the scenes.

![Status Dashboard](docs/images/status-dashboard.png)

### Production Monitoring

Alertlytics uses slack as it's notification engine.  Go to slack and create a custom bot to get your slack API token.  Now you can start the Alertlytics docker container by passing in your slack token as an environment variable and config file via a volume mapping to /etc/alertlytics/config.json.  Something like this:

`docker run -d -e SLACK_TOKEN=your-token-here -v $PWD/alertlytics-config.json:/etc/alertlytics/config.json cultivatedcode/alertlytics`

In slack you should see your bot come online.  You will receive alerts of any services that do not respond with a 200 status code in the slack channel you have defined in the config.json.  To view the status of the monitoring you can view docker logs.

### Local Monitoring

We use Alertlytics to monitor local development environments where we have many microservices that need to communicate.  This makes it easier to see if any of the associated services in your applications are operational.

You can run Alertlytics without Slack notifications when you're running locally.  Simply don't include the slack token and now you can use the dashboard UI to monitor your services.

`docker run -d -p 80:80 -v $PWD/alertlytics-config.json:/etc/alertlytics/config.json cultivatedcode/alertlytics`

## Supported Monitors

Alertlytics includes the ability to plugin multiple types of monitors.  Currently two monitors are supported: Http and RabbitMQ.

### Http Monitor

The http monitor makes a simple GET request to the specified `health_check_url` and checks if the status code is 200 upon return.  The configuration of the Http monitor is as follows:

```
{
   "channel": "#devops",
   "services":
   [{
      "id": "myco-marketingsite",
      "type": "http",
      "name": "marketing-site",
      "test_interval_in_seconds": 10,
      "config": {
        "health_check_url": "https://www.cultivatedcode.com"
      }
   }]
}
```

### RabbitMQ Monitor

The [RabbitMQ](https://www.rabbitmq.com/) monitor uses the RabbitMQ Admin UI to check the specified `rabbit_queue_name` to see if any consumers are attached to it.  If there is 1 or more consumers then the service is considered to be live.  In order to support the feature make sure to run rabbit with the [management UI](https://www.rabbitmq.com/management.html) enabled.  You will need to also provide the `rabbit_admin_url` and `rabbit_vhost`.  THe configuration of the RabbitMQ monitor is as follows:

```
{
  "channel": "#commits",
  "services":
  [
    {
      "id": "myco-rabbitmq",
      "type": "rabbit_mq",
      "name": "rabbit_test_queue",
      "config":
      {
        "rabbit_admin_url": "http://guest:guest@rabbit:15672",
        "rabbit_vhost": "/",
        "rabbit_queue_name": "test.queue"
      },
      "test_interval_in_seconds": 10
    }
  ]
}
```

