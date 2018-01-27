require 'rails_helper'
require 'match_json/rspec'

include CacheConfig

def generate_url geocode
  "/nearest_gas?#{geocode.to_query}"
end

RSpec.describe 'Yoshi API', type: :request do

  describe 'params contains invalid geocode' do
    before { get generate_url(lat: 'hello', lng: '')}
    it 'returns error message' do
      expect(response).to match_json(<<-JSON)
      {
        "error": "Parameters are invalid or out of range!",
        "params": {
          "latitude": "hello",
          "longitude": ""
        }
      }
      JSON
    end
  end

  describe 'params contains geocode out of range' do
    before { get generate_url(lat: -1, lng: 200)}
    it 'returns error message' do
      expect(response).to match_json(<<-JSON)
      {
        "error": "Parameters are invalid or out of range!",
        "params": {
          "latitude": -1.0,
          "longitude": 200.0
        }
      }
      JSON
    end
  end


  describe 'geocode could not be located by map API' do
    DatabaseCleaner.cleaning do
      before { get generate_url(lat:37.77801, lng:-170.0) }
      it 'returns message - "could not find colation"' do
        expect(response).to match_json(<<-JSON)
        {
          "message": "Sorry, your current geocode could not be located on a place we know.",
          "geocode": {
            "lantitude": 37.77801,
            "longitude": -170.0
          }
        }
      JSON
      end
    end
  end

  describe 'no gas station nearby' do
    DatabaseCleaner.cleaning do
      it 'returns message - "no gas station nearby"' do
        query = FactoryGirl.create(:query)
        user_location = FactoryGirl.create(:user_location, query: query)
        get generate_url(lat: query.latitude, lng: query.longitude)
        expected = {
          message: 'Sorry, no gas station nearby.',
          address: {
            streetAddress: user_location.street_address,
            city: user_location.city,
            state: user_location.state,
            postalCode: user_location.postal_code},
          geocode: {
            lantitude: query.latitude,
            longitude: query.longitude}
        }.to_json
        expect(response).to match_json expected
      end
    end
  end

  describe 'no gas station nearby' do
    DatabaseCleaner.cleaning do
      if (start_cache) # this test need enable cache
        it 'get correct result from database' do
          query = FactoryGirl.create(:query)
          user_location = FactoryGirl.create(:user_location, query: query)
          gas_station = FactoryGirl.create(:gas_station, user_location: user_location)
          get generate_url(lat: query.latitude, lng: query.longitude)
          expected = {
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
          }.to_json
          expect(response).to match_json expected
        end
      end
    end

    DatabaseCleaner.cleaning do
      it 'get cprrect resi;t online' do
        get generate_url(lat: 37.77801, lng: -122.4119076)
        expected = {
          address: {
            streetAddress: "{string}",
            city: "{string}",
            state: "{string}",
            postalCode: "{string}"},
          nearest_gas_station: {
            streetAddress: "{string}",
            city: "{string}",
            state: "{string}",
            postalCode: "{string}"}
        }.to_json
        expect(response).to match_json(expected)
      end
    end
  end

  describe 'whether cache could work well' do
    DatabaseCleaner.cleaning do
      if (start_cache)
        it 'when a query witnin minimum_distance is cached, then it will return result in cache' do
          query = FactoryGirl.create(:query, latitude: 37.77801)
          user_location = FactoryGirl.create(:user_location, query: query)
          gas_station = FactoryGirl.create(:gas_station, user_location: user_location)
          get generate_url(lat: query.latitude - 0.001, lng: query.longitude)
          query_size = Query.all.size
          gas_station_size = GasStation.all.size
          user_location_size = UserLocation.all.size
          expected = {
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
          }.to_json
          expect(response).to match_json expected
          expect(query_size).to eql(Query.all.size)
          expect(user_location_size).to eql(UserLocation.all.size)
          expect(gas_station_size).to eql(GasStation.all.size)
        end
      end
    end
  end
end