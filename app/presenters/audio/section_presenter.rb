# frozen_string_literal: true

class Audio::SectionPresenter < BasePresenter
  def sections
    Audio::Section.all
  end
end
