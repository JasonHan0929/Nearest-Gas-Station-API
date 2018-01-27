class QueriesController < ApplicationController
  include CheckParams
  include Response
  include ResultGenerator
  include GoogleMapAPI
  include CustomedError
  include CacheConfig

  def nearest_gas
    if (!check_params params)
      # if params are invalid, return error info
      json_response invalid_params(params)
    else
      # if params are valid, return result
      begin
        process_query query_params
        result = generate_result @query
        json_response result
      rescue ParsingException => e
        json_response object: e.error_info, status_code: 400
      end
    end
  end

  private

  def query_params
    # whitelist params
    params.permit(:lat, :lng)
  end

  def process_query(geocode)
    # Suppose any two geocode whose distance is less than minimum_distance are actually in same place. This is used to improve the cache efficiency but may loss some correctness
    cache = Query.near([geocode[:lat], geocode[:lng]],minimum_distance, :units => :km)
    if (cache.any? && start_cache)
      get_cached_result cache
    else
      get_result_online geocode
    end
  end

  def get_cached_result(cache)
    query_cached = cache.first
    user_location_cached = query_cached.user_location
    gas_station_cached = nil
    if (query_cached.user_location)
      gas_station_cached = user_location_cached.gas_station
    end
    # update timestamp


    @query = query_cached
  end

  def get_result_online(geocode)
    user_location = get_urser_location geocode
    if (user_location.has_key? :error)
      user_location[:when] = 'get user_location'
      raise ParsingException.new(user_location)
    end
    gas_station = get_gas_station geocode
    if (gas_station.has_key? :error)
      usr_location[:when] = 'get gas_station'
      raise ParsingException.new(gas_station)
    end
    cache_current_request geocode, user_location:user_location, gas_station: gas_station
  end

  def cache_current_request(geocode, user_location: {}, gas_station: {})
    query = Query.new latitude: geocode[:lat], longitude: geocode[:lng]
    if (!user_location.empty?)
      # look up in database at first before create
      query.user_location = UserLocation.find_by user_location
      if (!query.user_location)
      query.user_location = UserLocation.new user_location
      end
      if (!gas_station.empty?)
        query.user_location.gas_station = GasStation.find_by gas_station
        if (!query.gas_station)
          query.user_location.gas_station = GasStation.new gas_station
        end
      end
    end
    # try to avoid cache same query, but this may still happen due to concurrency
    @query = Query.find_by latitude: geocode[:lat], longitude: geocode[:lng]
    if (!@query)
      if (start_cache)
        write_to_database query
      end
      @query = query
    end
  end

  def write_to_database(query)
      check_database Query # only check Query will be enough
      query.save
      if (query.user_location)
        query.user_location.save
        if (query.user_location.gas_station)
          query.user_location.gas_station.save
        end
      end
  end

  def check_database(database)
    if database.all.size >= maximum_records
      database.order(update_at: :desc).limit(maximum_records/4).destroy_all
    end
  end
end
