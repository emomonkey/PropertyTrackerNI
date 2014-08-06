class CardCounty
  attr_reader :caption, :arrvals, :arrdescs

  def initialize(args)
    @caption = args[:caption]
    @arrvals  = args[:arrvals]
    @arrdescs = args[:arrdescs]
  end


end