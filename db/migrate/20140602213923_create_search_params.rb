class CreateSearchParams < ActiveRecord::Migration
  def change
    create_table :search_params do |t|
      t.string :searchtitle
      t.string :searchparam

      t.timestamps
    end
  end
end
