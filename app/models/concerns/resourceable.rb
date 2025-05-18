# frozen_string_literal: true

module Resourceable
  extend ActiveSupport::Concern

  included do
    belongs_to :resource_content
  end

  def resource_id
    resource_content_id
  end

  def get_resource_content
    if respond_to? :resource_content_id
      ResourceContent.allowed_to_share.find(resource_content_id)
    else
      resource_content
    end
  end

  def resource_name
    self['resource_name'] || get_resource_content.name
  end
end
