class CreateUserProfile < ActiveRecord::Migration

  def change


    create_table :user_profiles do |t|
      t.string :name
      t.timestamps
    end

    create_table :profilesearchparams do |t|
      t.belongs_to :user_profile
      t.belongs_to :search_params
      t.datetime :appointment_date
      t.timestamps
    end
  end



end