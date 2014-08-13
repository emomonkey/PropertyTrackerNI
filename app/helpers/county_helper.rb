module CountyHelper

  def countytags(cntyres)
    Hash[cntyres.map { |fcnty| [fcnty.county.to_sym, [fcnty.volpc, prcsold, percent_price]] }]
  end

end
