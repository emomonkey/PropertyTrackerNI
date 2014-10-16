require 'rails_helper'

RSpec.describe ManageController, :type => :controller do

  describe "GET 'configemailreport'" do
    it "returns http success" do
      get 'configemailreport'
      expect(response).to be_success
    end
  end

  describe "GET 'jobs'" do
    it "returns http success" do
      get 'jobs'
      expect(response).to be_success
    end
  end

end
