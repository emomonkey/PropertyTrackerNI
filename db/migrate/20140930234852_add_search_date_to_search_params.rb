class AddSearchDateToSearchParams < ActiveRecord::Migration
  def change
    add_column :search_params, :searchdate,  :datetime
  end
end
