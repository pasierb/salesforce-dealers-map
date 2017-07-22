# Salesforce Dealers

## Setup

Since the application imports data from Salesforce API you need to have credentials to access the API

## Tests

```
$ bundle exec rspec --tag ~type:external_api
```

Salesforce API integration
```
$ bundle exec rspec --tag type:external_api
```
