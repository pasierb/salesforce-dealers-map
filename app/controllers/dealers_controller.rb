class DealersController < ApplicationController
  before_action :get_dealers, only: :index

  def index
    respond_to do |format|
      format.json
      format.html {
        @dealers = get_dealers.page(params[:page]).order(:name)
      }
    end
  end

  private

  def get_dealers
    @dealers ||= Dealer.filter(params.slice(:coordinates))
  end

end
