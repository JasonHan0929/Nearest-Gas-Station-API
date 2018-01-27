namespace :user_location do
  desc "empty user_locations"
  task delete_all_user_locations_records: :environment do
    UserLocation.destroy_all
    UserLocation.reset_pk_sequence
  end
end
