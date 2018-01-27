class CreateUserLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_locations do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.string :postal_code
      # Rails 5 does not need index: true for foreign key
      t.references :query, foreign_key: true

      t.timestamps
    end
  end
end
