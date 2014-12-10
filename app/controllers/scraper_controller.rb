class ScraperController < ApplicationController
  before_filter :load_graphing_service


  def load_graphing_service(service = GraphingService.new)
    @graphing_service ||= service
  end

  def resultarea
    @styp = SearchType.find_by_searchtext("Volume Sales")
    HistoricAnalysis.find_by_search_types_id(@styp.id)
  end


  def aboutus

  end

  def result
   volcnty = @graphing_service.fndavgprcmthyr
   vcreatedat = HistoricAnalysis.maximum(:created_at)
   smxdt = vcreatedat.strftime('%Y%m')

   @mostsalescnty = @graphing_service.fndvolbycnt(smxdt)
   @mostpricecnty = @graphing_service.fndavgprice(smxdt)
   @mostsldcnty   = @graphing_service.fndvolbysld(smxdt)

   @cntychart = @graphing_service.generate_linegraph('Average Price PropertyType', volcnty, 'Price')

    volall = @graphing_service.fndvolcntysimple
    @chart = @graphing_service.generate_bargraph('Volume Sales/Sold by PropertyType the past Year', volall, 'Volume')

   volmthcty = @graphing_service.fndvolmthyr

   @volchart = @graphing_service.generate_linegraph("Volume on Sale Over the Year", volmthcty, "Volume")


  end
end
