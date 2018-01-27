module CacheConfig
  @@maximum_records = 20000
  @@minimum_distance = 0.25 # unit in km
  @@start_cache = true

  def maximum_records
    @@maximum_records
  end

  def minimum_distance
    @@minimum_distance
  end

  def start_cache
    @@start_cache
  end
end