class ScheduledProcedure < ActiveRecord::Base

  def self.parsehistoric()


    self.connection.execute("SELECT ab_historic_avg();")
    self.connection.execute("SELECT ab_historic_cnt();")
    self.connection.execute("SELECT ab_historic_sld();")
    self.connection.execute("SELECT ab_historic_chg();")
    self.connection.execute("SELECT ab_historic_min();")
    self.connection.execute("SELECT ab_historic_cnt_sum();")
    self.connection.execute("SELECT ab_historic_avg_sum();")
    self.connection.execute("SELECT ab_historic_avg_ovr();")
    self.connection.execute("SELECT ab_historic_cnt_ovr();")
  rescue StandardError => e
    Rails.logger.debug 'Error running ScheduledProcedure.parsehistoric ' + e.message

  end

end