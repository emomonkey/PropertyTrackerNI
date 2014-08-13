class CountyController < ApplicationController
  before_filter :load_view_service


  def load_view_service(service = ViewService.new)
    @view_service ||= service
  end


  def volumeview

    @arrmstpop = @view_service.CountyStats
    #continue.maximum(:resultvalue, :group => :county)

    vcntystat = AbHistoricCntyView.all
    @hshcntyst = Hash.new
    @hshcntyst = Hash[vcntystat.map { |fcnty| [fcnty['county'].to_sym, [fcnty['volpc'], fcnty['prcsold'], fcnty['percent_price']]] }]

  end

  def priceview


  end

  def volumegraph
  end

  def pricevolume
  end
end
