class ResultsAnalysis < ActiveRecord::Base
  belongs_to :SearchTypes



  def fndCounty(cnt)
    sSql = "SELECT FROM results_analyses RA, property_sites ps, search_params WHERE "
    ResultsAnalysis.find_by_sql(sSql)
  end

end
