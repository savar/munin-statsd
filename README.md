munin-statsd
============
A Ruby script to send Munin-node data to a StatsD instance. As written, this is designed to be run from cron.
It's checking the 'type' of each munin graph and sends either a 'counter' or 'gauge' value.

This was inspired by Tech-Corps/munin-statsd

Requirements
============

* sosedoff/munin-ruby > 0.2.4
* github/statsd-ruby maybe reinh/statsd

Configuration
=============
Set the ENV variables `SCHEMABASE`, `STATSD_HOST` and `STATSD_PORT` as appropriate for your environment (see in the code for default values).
If you're not running the script on the same host like the munin-node is running than set `MUNIN_HOST` and `MUNIN_PORT` as well.

Installation
============
1. Clone the repository
```
    cd /usr/local/bin
    git clone https://github.com/Savar/munin-statsd.git
```

2. Make sure munin-statsd.rb is executable
```
    chmod +x munin-statsd/munin-statsd.rb
```

3. Create a crontab entry that calls the script
```
    * * * * * SCHEMABASE=my_cool.base.schema STATSD_HOST=something.somewhere /usr/local/bin/munin-statsd/munin-statsd.rb
```
