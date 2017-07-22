require 'salesforce'
require 'rails_helper'

describe Salesforce::Api::Client do
  describe "authentication" do
    before :each do
      @client = Salesforce::Api::Client.new(Rails.application.secrets.salesforce_host)
    end

    it "should succed", type: :external_api do
      @client.authenticate(Rails.application.secrets.salesforce_auth)

      expect(@client.auth["access_token"])
    end

    it "should fail", type: :external_api do
      expect {
        @client.authenticate({})
      }.to raise_error(Salesforce::Api::AuthenticationError)
    end
  end

  describe "requests" do
    let (:client) {
      client = Salesforce::Api::Client.new(Rails.application.secrets.salesforce_host)
      client.authenticate(Rails.application.secrets.salesforce_auth)
    }

    it "should get versions", type: :external_api do
      res = client.get(Salesforce::Api::VERSIONS_ENDPOINT)

      expect(res.body).to be_an_instance_of(Array)
    end
  end
end

