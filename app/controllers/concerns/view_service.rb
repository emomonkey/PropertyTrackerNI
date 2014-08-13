class ViewService




def CountyStats

  sSql = "SELECT * FROM ac_historic_currvol_view"

  countystat = HistoricAnalysis.find_by_sql [sSql]


end


end