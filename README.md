# Salesforce Dealers Map

## Selesforce API credentials

Please, have a look at config/secrets.yml

## Importing dealers
```
$ bundle exec rails salesforce:dealers:import
```

## Tests

Complete suite:
```
$ bundle exec rspec
```

Salesforce API only:
```
$ bundle exec rspec --tag type:external_api
```
