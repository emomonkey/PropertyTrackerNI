class GraphData
  attr_accessor :series, :category, :arrseries

  def initialize

    @series = Array.new
  end



  def addseries(varrseries)
    @series << varrseries
  end

end