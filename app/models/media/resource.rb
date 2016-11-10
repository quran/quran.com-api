class Media::Resource < ActiveRecord::Base
  extend Media

  has_many :content
end
