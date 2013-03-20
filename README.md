# Healthyr Monitor

That is the application that powers the [healthyr gem](https://github.com/elvio/healthyr) dashboard.

## Installation

1. Clone the application monitor

2. Clone the monitor

```
$ git clone https://github.com/elvio/healthyr_monitor
```

3. Install the dependencies

```
 $ bundle install
```

4. Ensure you have (mongoDB)[http://www.mongodb.org/] installed and running

5. Set the database configuration to config/mongoid.yml

6. Start the monitor application

```
$ rackup config.ru --port=4567
```

## Usage

* Access the monitor URL

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
