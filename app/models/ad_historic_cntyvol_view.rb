class AdHistoricCntyvolView <  ActiveRecord::Base


  attr_reader  :id, :county, :searchparam, :totalval

  self.primary_key = :id


  protected

  # The report_state_popularities relation is a SQL view,
  # so there is no need to try to edit its records ever.
  # Doing otherwise, will result in an exception being thrown
  # by the database connection.
  def readonly?
    true
  end


end