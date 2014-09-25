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


  describe "GET Queries" do
    @view_service ||= ViewService.new
    it "should find Average Price Area" do

      vret =  @view_service.fndavgareaprcmthyr(varea)

    end

    it "should find Sale and Sold Area" do

    end

  end


end
