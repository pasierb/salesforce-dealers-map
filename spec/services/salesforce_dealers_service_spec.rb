require 'rails_helper'

describe SalesforceDealersService do
  describe "import" do
    before :each do
      Dealer.delete_all
      @client = double("Api client")
      expect(SalesforceDealersService).to receive(:client).and_return(@client)
      expect(@client).to receive(:query).with(any_args).and_return(query_result)
    end

    let :query_result {
      res = double
      allow(res).to receive(:body).and_return({
        "records" => [
          { "Id" => "abc1", "Name" => "Account1" },
          { "Id" => "abc2", "Name" => "Account2" },
          { "Id" => "abc3", "Name" => "Account3" }
        ]
      })
      allow(res).to receive(:next).and_return(nil)

      res
    }

    describe "initialize" do
      it "should create entries" do
        expect{
          SalesforceDealersService.import
        }.to change{ Dealer.count }.by(3)
      end
    end

    describe "synchronize" do
      before :each do
        @existing_dealer = Dealer.create(salesforce_identifier: "abc1", name: "Bob")
      end

      it "should not create entries if already exist" do
        expect{
          SalesforceDealersService.import
        }.to change{ Dealer.count }.by(2)
      end

      it "should update attributes on existing entry" do
        expect{
          SalesforceDealersService.import
        }.to change{ @existing_dealer.reload.name }.from("Bob").to("Account1")
      end
    end
  end
end
