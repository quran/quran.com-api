# frozen_string_literal: true

class RecitationsPresenter < BasePresenter
  attr_reader :finder
  FIELDS = [
    'chapter_id',
    'verse_number',
    'verse_key',
    'juz_number',
    'hizb_number',
    'rub_el_hizb_number',
    'page_number',
    'ruku_number',
    'manzil_number',
    'format',
    'url',
    'segments',
    'duration',
    'id'
  ]

  def initialize(params)
    super(params)

    @finder = V4::RecitationFinder.new(params)
  end

  delegate :total_records, to: :finder

  def audio_fields
    strong_memoize :valid_fields do
      fetch_fields.select do |field|
        FIELDS.include?(field)
      end
    end
  end

  def audio_files(filter)
    if (id = recitation_id)
      finder.load_audio(filter, id)
    else
      raise_404("Recitation not found")
    end
  end

  protected

  def recitation_id
    strong_memoize :approved_recitation do
      if params[:recitation_id]
        recitation = params[:recitation_id].to_s.strip

        approved = Recitation
                     .approved

        params[:recitation_id] = approved.where(id: recitation).first&.id
      end
    end
  end

  def fetch_fields
    if (fields = params[:fields]).presence
      fields.split(',')
    else
      []
    end
  end
end
