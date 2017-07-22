require 'salesforce'

class SalesforceDealersService
  ATTRIBUTES_MAP = {
    "Id" => :salesforce_identifier,
    "Name" => :name,
    "Dealer_Latitude__c" => :latitude,
    "Dealer_Longitude__c" => :longitude
  }

  def self.import
    response = client.query(%Q(
      SELECT #{ATTRIBUTES_MAP.keys.join(", ")}
      FROM Account
      WHERE E_Shop_Dealer__c = 'Dealer and Point of Sale'
    ))

    while response
      response.body["records"].each do |record|
        save_item(record)
      end

      response = response.next
    end
  end

  def self.save_item(record)
    dealer = Dealer.find_or_initialize_by(salesforce_identifier: record["Id"])
    dealer.assign_attributes(map_attributes(record))

    dealer.save
  end

  def self.map_attributes(record)
    record.slice(*ATTRIBUTES_MAP.keys).map do |key, value|
      [ATTRIBUTES_MAP[key], value]
    end.to_h
  end

  def self.client
    client = Salesforce::Api::Client.new(Rails.application.secrets.salesforce_host)
    client.authenticate(Rails.application.secrets.salesforce_auth)

    client
  end

end
