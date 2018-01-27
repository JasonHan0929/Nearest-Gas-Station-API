namespace :gas_stations do
  desc "empty gas_station"
  task delete_all_gas_stations_records: :environment do
    GasStation.destroy_all
    GasStation.reset_pk_sequence
  end
end
