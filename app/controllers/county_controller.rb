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

    stype = SearchType.find_by searchtext: 'Volume County Summary Property Types'
    vcreatedat = HistoricAnalysis.maximum(:created_at)
    smxdt = vcreatedat.strftime('%Y%m')
    vcnty = params[:county]
#    @histvol = HistoricAnalysis.search_yyyymm(smxdt).search_restype(stype.id)
    @histvol = HistoricAnalysis.search_county(vcnty).search_restype(stype.id).search_yyyymm(smxdt).paginate(:page => params[:page], per_page: 20).order('resultvalue desc')
    t = @histvol.first
    @county = t.search_params.county
  end
end
