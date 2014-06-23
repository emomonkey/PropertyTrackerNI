class SearchParams < ActiveRecord::Base
  validates :searchparam, uniqueness: true, :presence => true
end
