class CreateSearchTypes < ActiveRecord::Migration
  def change
    create_table :search_types do |t|
      t.string :searchtext
      t.timestamps
    end
  end
end
