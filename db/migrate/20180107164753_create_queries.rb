class CreateQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :queries do |t|
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
