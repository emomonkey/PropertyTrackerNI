class CountyController < ApplicationController
  before_filter :load_view_service



  def load_view_service(service = ViewService.new)
    @view_service ||= service
  end


  def volumeview

    @arrmstpop = @view_service.CountyStats
    #continue.maximum(:resultvalue, :group => :county)

    vcreatedat = HistoricAnalysis.maximum(:created_at)
    vselectdat = vcreatedat.months_ago(1)
    vyear = vselectdat.strftime("%Y")
    vmonth = vselectdat.strftime("%m")
    vqdat = Date.strptime("01/" + vmonth + "/" + vyear, '%m/%d/%Y')
    vcntystat = AbHistoricCntyView.all
    @hshcntyst = Hash.new
    @hshcntyst = Hash[vcntystat.map { |fcnty| [fcnty['county'].to_sym, [fcnty['volpc'], fcnty['prcsold'], fcnty['month_price_diff']]] }]

  end

  def priceview


  end

  def volumegraph
  end

  def pricevolume


    vcreatedat = HistoricAnalysis.maximum(:created_at)
    vlastdat = vcreatedat.months_ago(12)
    vyear = vlastdat.strftime("%Y")
    vmonth = vlastdat.strftime("%m")
    vstartdat =  Date.strptime("01/" + vmonth + "/" + vyear, '%m/%d/%Y')
    vcnty = 'Co.' + params[:county]


 #   @vhistvol = AdHistoricCntyvolView.where("county = ? and year = ?  and month = ?", vcnty, vyear, vmonth).paginate(:page => params[:page], per_page: 20)
    @vhistvol = AdHistoricCntyvolView.where("county = ? and created_at >= ?" , vcnty, vstartdat).paginate(:page => params[:page], per_page: 20)
    @county = vcnty
  end

  def detail
    vcnty = params[:detail]



  end



end
