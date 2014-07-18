class CreateTransstatuses < ActiveRecord::Migration
  def change
    create_table :transstatuses do |t|
      t.string :name
      t.string :currentparam

      t.timestamps
    end
  end
end
