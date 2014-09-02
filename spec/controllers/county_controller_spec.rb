#require 'rails_helper'
require 'spec_helper'

RSpec.describe CountyController, :type => :controller do

  describe "GET 'volumeview'" do
    it "returns http success" do
      get 'volumeview'
      expect(response).to be_success
    end
  end

  describe "GET 'priceview'" do
    it "returns http success" do
      get 'priceview'
      expect(response).to be_success
    end
  end

  describe "GET 'volumegraph'" do
    it "returns http success" do
      get 'volumegraph'
      expect(response).to be_success
    end
  end

  describe "GET 'pricevolume'" do
    it "returns http success" do
      get 'pricevolume'
      expect(response).to be_success
    end
  end

end
