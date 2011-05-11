class Currency < ActiveRecord::Base
  has_many :countries
  has_many :countries, :through => :monetizations
end
