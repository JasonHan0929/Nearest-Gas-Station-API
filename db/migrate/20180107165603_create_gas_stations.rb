class CreateGasStations < ActiveRecord::Migration[5.1]
  def change
    create_table :gas_stations do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.string :postal_code
      t.references :user_location, foreign_key: true

      t.timestamps
    end
  end
end
