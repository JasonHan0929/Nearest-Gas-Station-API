module ResultGenerator
  def generate_result(query)
    gas_station = nil
    user_location = query.user_location
    if(query.user_location)
      gas_station = query.user_location.gas_station
    end
    content = nil
    if (!user_location)
      content = {
        message: 'Sorry, your current geocode could not be located on a place we know.',
        geocode: {
          lantitude: query.latitude,
          longitude: query.longitude}
        }
    elsif (!gas_station)
      content = {
        message: 'Sorry, no gas station nearby.',
        address: {
          streetAddress: user_location.street_address,
          city: user_location.city,
          state: user_location.state,
          postalCode: user_location.postal_code},
        geocode: {
          lantitude: query.latitude,
          longitude: query.longitude}
      }
    else
      content = {
        address: {
          streetAddress: user_location.street_address,
          city: user_location.city,
          state: user_location.state,
          postalCode: user_location.postal_code},
        nearest_gas_station: {
          streetAddress: gas_station.street_address,
          city: gas_station.city,
          state: gas_station.state,
          postalCode: gas_station.postal_code}
        }
    end
      { object: content }
  end
end
