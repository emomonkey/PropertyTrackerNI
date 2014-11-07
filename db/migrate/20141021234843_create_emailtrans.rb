class CreateEmailtrans < ActiveRecord::Migration
  def change
    create_table :emailtrans do |t|
      t.string :comment

      t.timestamps
    end
  end
end
