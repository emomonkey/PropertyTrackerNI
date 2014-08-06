class CountyController < ApplicationController
  before_filter :load_view_service


  def load_view_service(service = ViewService.new)
    @view_service ||= service
  end


  def volumeview
  end

  def priceview
    vprice = @view_service.fndrecentpricechange

#    vccnt = CardCounty.new(caption: "test", arrvals:, arrdescs: )
  end

  def volumegraph
  end

  def pricevolume
  end
end
