require 'google_maps_service'
require 'open-uri'

module GoogleMapAPI
  # initial google map serviece client
  @@api_key = 'Yor Google API Key'
  @@gmaps = GoogleMapsService::Client.new(
    key: @@api_key,
    retry_timeout: 20,      # Timeout for retrying failed request
    queries_per_second: 10  # Limit total request per second)
  )

  def get_urser_location(geocode)
      locations = @@gmaps.reverse_geocode([geocode[:lat], geocode[:lng]], result_type: ['street_address', 'route'])
      begin
        parse_address locations[0]
      rescue
        { error: 'Error happened when parsing json package sent by google map service' }
      end
  end

  def get_gas_station(geocode)
    url_params = {location: "#{geocode[:lat]},#{geocode[:lng]}", type: 'gas_station', rankby: 'distance', key: @@api_key}
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?#{url_params.to_query}"
    location = JSON.load(open url)['results'][0]
    if (location)
      gas_station_geocode = { lat: location['geometry']['location']['lat'].to_f, lng: location['geometry']['location']['lng'].to_f }
      get_urser_location gas_station_geocode
    else
      {} # return empty address info instead of nil
    end
  end

  def parse_address(address)
    result = {}
    if (address && !address.empty?)
      pieces = address[:formatted_address].split(/,/)
      # format - "Calle Villardompardo, 106, 23650 Torredonjimeno, Jaén, Spain"
      if (pieces.size > 4)
        pieces[1] = pieces[1] + ' ' + pieces[0]
        pieces.delete_at 0
      end
      state_code = pieces[2].strip.split(/ /)
      code_city = pieces[1].strip.split(/ /)
      if (state_code.size > 1)
        # format - "277 Bedford Ave, Brooklyn, NY 11211, USA"
        result[:street_address] = pieces[0].strip
        result[:city] = pieces[1].strip
        result[:state] = state_code[0]
        result[:postal_code] = state_code[1]
      elsif (code_city.size > 1)
        # format - "A-1510, 44712 Rillo, Teruel, Spain"
        result[:street_address] = pieces[0].strip
        result[:state] = pieces[2].strip
        result[:postal_code] = code_city[0].strip
        result[:city] = code_city[1].strip
      else
        # format - "A-1510, Rillo, Teruel, Spain"
        # format - "277 Bedford Ave, Brooklyn, NY, USA"
        result[:street_address] = pieces[0].strip
        result[:state] = pieces[2].strip
        result[:city] = pieces[1].strip
      end
    end
    result
  end
end
