class ResourcePresenter < BasePresenter
  RESOURCE_FIELDS = [
    'id',
    'updated_at',
    'cardinality_type'
  ]

  def fields
    if (requested_fields = params[:fields]).presence
      requested_fields.split(',').select do |field|
        RESOURCE_FIELDS.include?(field)
      end
    else
      []
    end
  end
end