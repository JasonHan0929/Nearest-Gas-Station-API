# ReadMe

It's a Rails API with one endpoint that accepts a request with a latitude and longitude.

```
GET localhost:3000/nearest_gas?lat=37.77801&lng=-122.4119076
```
It'll response address information associated with the geocoordinates as well as the nearest gas station. 

```
{
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021-3100"
  },
"nearest_gas_station": {
    "streetAddress": "55 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021-3100"
  }
}
```

## How to run

1. This API uses google map service to get location information so at first you should set a valid API key from google and ensure that this API key enables 'Google Places API Web Service' and 'Google Maps Geocodeing API'.
```ruby
# controllers/concerns/google_map_api.rb

  # I already set my API key here as default
  @@api_key = 'API key' 
```

2. Set the cache as you want
```ruby
# config/initializers/cache_config.rb

  # how many records you want to cache in database
  @@maximum_records = 25000
  # The minimum distance that two different places could be distinguished, unit in km 
  @@minimum_distance = 0.25
  # false will shut down cache
  @@start_cache = true
```

3. run the server
```ruby
  rails s
```

## Gems List

* To get distance between geocode, I use
```ruby
  gem 'geocoder'
```
* To coonect to Google map API, I use
```ruby
  # This gem could not connect to 'Google Places API Web Service'
  gem 'google_maps_service' 
```
* To set schedule, I use
```ruby
  gem 'whenever'
```
* For test, I use
```ruby
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'database_cleaner'
  gem 'match_json'
```

## Cache

This API will save most recently request result into local database. And this API sets a minimum distance to distinguish two different places. Every time when the server receive a query, it at first, looks up the cache to see if there is already an old geocode in cache nearest current query. If so, the server will return the query result in cache directly. It works like the server has a threshold(as default, the value is 250m), and if the distance between two places are less than this value, these two places will be seen as one. This will ensure that cache could have chance to be reused in practice.

