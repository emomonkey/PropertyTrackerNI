class Profilesearchparams < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :search_params, :class_name => 'SearchParams'

  validates :search_params_id, uniqueness: { scope: :user_profile_id,
                                 message: "area should be added once per profile" }
end