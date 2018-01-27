namespace :queries do
  desc "refresh query cache every 5 hours"
  task refresh_query_cache: :environment do
    Query.where(['updated_at < ?', 5.hours.ago]).destroy_all
  end
  desc "empty queries"
  task delete_all_query_records: :environment do
    Query.destroy_all
    Query.reset_pk_sequence
  end
end
