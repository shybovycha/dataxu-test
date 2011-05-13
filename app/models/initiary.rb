class Initiary < ActiveRecord::Base
  has_many :initiarizations
  has_many :countries, :through => :initiarizations
end
