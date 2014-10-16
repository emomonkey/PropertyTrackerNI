class UserProfile < ActiveRecord::Base
  has_many :profilesearchparams, :class_name => 'Profilesearchparams'
  has_many :search_paramses, through: :profilesearchparams
end