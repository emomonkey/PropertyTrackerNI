class CreateMailarticles < ActiveRecord::Migration
  def change
    create_table :mailarticles do |t|
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
