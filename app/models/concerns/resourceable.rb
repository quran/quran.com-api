module Resourceable
  extend ActiveSupport::Concern

  included do
    belongs_to :resource_content
  end

  def resource_id
    resource_content_id
  end

  def resource_name
    read_attribute('resource_name') || resource_content.name
  end
end
