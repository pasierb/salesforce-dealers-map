class CreateDealers < ActiveRecord::Migration[5.1]
  def change
    create_table :dealers do |t|
      t.string  :name, null: false
      t.float   :longitude
      t.float   :latitude
      t.string  :salesforce_identifier, null: false

      t.timestamps
    end
  end
end
