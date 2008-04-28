class Label < ActiveRecord::Base
  has_many :labeled_pages
  has_many :pages, :through => :labeled_pages
end
