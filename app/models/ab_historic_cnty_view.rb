class AbHistoricCntyView <  ActiveRecord::Base
  attr_reader :id, :county, :year, :month, :volpc, :prcsold, :percent_price
  self.primary_key = :id

  def self.current_month
      currmonth = DateTime.now - 1.month
      AbHistoricCntyView.where(year: currmonth.year, month: currmonth.month)
  end

  def self.last_month
    lastmonth = DateTime.now - 1.month
    AbHistoricCntyView.where(year: lastmonth.year, month: lastmonth.month)
  end

  protected

  # The report_state_popularities relation is a SQL view,
  # so there is no need to try to edit its records ever.
  # Doing otherwise, will result in an exception being thrown
  # by the database connection.
  def readonly?
    true
  end


end