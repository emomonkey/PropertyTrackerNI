class PopulateResults
  # SearchTypes
  # Biggest price increase
  # Biggest price decrease
  # Newest Additions
  # Just Sold

  def initialize()
    ResultsAnalysis.delete_all
  end

  def start()
    fndprice
    newestaddition
    justsold
  end


  private
  def fndprice
    #fnd all that has many > 2

 #   @vresprop =PropertySiteValue.find_by_sql("SELECT property_site_id, COUNT(property_site_id) AS cnt FROM property_site_values GROUP BY property_site_id HAVING cnt > 1")
    sSql = "SELECT sites.property_site_id, sites.title as title, psvmin.price as first_price, psvmax.price as last_price FROM (SELECT property_site_id, title, COUNT(property_site_id) AS cnt FROM property_site_values, property_sites WHERE property_sites.id = property_site_values.property_site_id GROUP BY property_site_id, title HAVING cnt > 1) sites, (SELECT property_site_id, MIN(created_at) created_at FROM property_site_values GROUP BY property_site_id) min_dates, (SELECT property_site_id, MAX(created_at) created_at FROM property_site_values GROUP BY property_site_id) max_dates, property_site_values psvmin, property_site_values psvmax  WHERE sites.property_site_id = min_dates.property_site_id  AND sites.property_site_id = max_dates.property_site_id AND max_dates.created_at = psvmax.created_at AND max_dates.property_site_id = psvmax.property_site_id AND sites.property_site_id = min_dates.property_site_id AND min_dates.created_at = psvmin.created_at AND min_dates.property_site_id = psvmin.property_site_id"
    @vresprop =PropertySiteValue.find_by_sql(sSql)
  # test for empty array
    if !@vresprop.empty?
      @vresprop.each do |props|
        if props.first_price < props.last_price
          @stypeinc = SearchType.find_by_searchtext("Biggest price increase")
          vdiff = props.first_price - props.last_price
          vresult_text = "Price Increase for %2s is £ %1s " % [props.title, vdiff.to_s]
          ResultsAnalysis.create(:property_id => props.property_site_id, :SearchTypes_id => @stypeinc.id, :result_text => vresult_text )
        end
        if props.first_price > props.last_price
          @stypeinc = SearchType.find_by_searchtext("Biggest price decrease")
          vdiff = props.last_price - props.first_price
          vresult_text = "Price Decrease for %2s is £ %1s " % [props.title, vdiff.to_s]
          ResultsAnalysis.create(:property_id => props.property_site_id, :SearchTypes_id => @stypeinc.id, :result_text => vresult_text )
        end
      end
    end

  rescue StandardError => e
    Rails.logger.debug 'Error running PropertyNewsCrawler.fndprice ' + e.message

  end



  private
  def newestaddition
    @county = SearchParams.select(:county).distinct
    @stypeinc = SearchType.find_by_searchtext("Newest Additions")
    @county.each do |pcounty|
      Rails.logger.debug ' debug ' + pcounty.county
      sSql = "SELECT ps.id,  propertytype, beds, title, searchtext FROM property_sites ps, search_params WHERE searchtext = searchparam AND county = '%1s' ORDER BY ps.created_at" % pcounty.county
      # SELECT ps.id,  propertytype, beds, title FROM property_sites ps, search_params WHERE searchtext = searchparam AND county = '?' ORDER BY ps.created_at", pcounty.county
      @newprops = PropertySite.find_by_sql(sSql).first(10)
      @newprops.each do |pnewprop|
        vresult_text = "Newest properties added  %3s in %2s %1s " % [pnewprop.title, pnewprop.searchtext, pcounty.county]
        ResultsAnalysis.create(:property_id => pnewprop.id, :SearchTypes_id => @stypeinc.id, :result_text => vresult_text )
      end
    end


    rescue StandardError => e
      Rails.logger.debug 'Error running PropertyNewsCrawler.newestaddition ' + e.message

  end

  private
  def justsold
    @stypeinc = SearchType.find_by_searchtext("Just Sold")
    # just sold will be items sold the past month 30 days
    @recentsold = PropertySite.where("solddate > ? ", 1.month.ago)
    @recentsold.each do |precent|
        vresult_text = "Recently sold properties %3s in %1s" % [precent.title, precent.searchtext]
        ResultsAnalysis.create(:property_id => precent.id, :SearchTypes_id => @stypeinc.id, :result_text => vresult_text )
    end
  rescue StandardError => e
    Rails.logger.debug 'Error running PropertyNewsCrawler.justsold ' + e.message
  end




end