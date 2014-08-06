class ScheduledProcedure < ActiveRecord::Base

  def self.myproc(param)
    self.connection.execute("SELECT myproc '#{param}'")
  end

end