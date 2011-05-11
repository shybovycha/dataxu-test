class Country < ActiveRecord::Base
  has_many :monetizations
  has_many :currencies, :through => :monetizations

  has_many :initiarizations
  has_many :initiaries, :through => :initiarizations
end
