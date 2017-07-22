class DealersAddAddressFields < ActiveRecord::Migration[5.1]
  def change
    add_column :dealers, :street,   :string
    add_column :dealers, :city,     :string
    add_column :dealers, :country,  :string
    add_column :dealers, :zip,      :string
    add_column :dealers, :state,    :string
    add_column :dealers, :phone,    :string
  end
end
