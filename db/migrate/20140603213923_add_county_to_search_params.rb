class AddCountyToSearchParams < ActiveRecord::Migration
  def change
    add_column :search_params, :county,  :string
  end
end

