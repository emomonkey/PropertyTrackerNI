class ViewService

def test
  sSql = "SELECT a.year, a.month, a.county, AVG(resultvalue) as avgv FROM search_params a, historic_analyses h LEFT JOIN (SELECT DISTINCT year, month, search_types_id, search_params_id FROM historic_analyses WHERE search_types_id = "/
      sSql = sSql + vhghprc.to_s +  ") myear ON m.year = a.year AND m.month = a.month AND m.search_params_id = a.search_params_id WHERE "/
          sSql = sSql +  " m.year IS NULL AND search_params_id = a.id AND search_types_id = #{savgprice_type.id} AND h.created_at >  DATE_SUB(CURDATE(), INTERVAL 2 month) GROUP BY   county, year, month ORDER BY county, YEAR, MONTH"

end


end