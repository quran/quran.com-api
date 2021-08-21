# frozen_string_literal: true

class String
  DIALECTIC_CHARS_REGEXP = /\uE01B|\u06DB|\u06E8|\u06D8|\uFEFF|\u2002|\u200B|\u0621|\u0614|\u06E2|\uE022|\u06DA|\u06E4|\u06D9|\u06D6| ۖ||ۙ |\u0651|\uE01C|\u06E1|\uE01E|\u06DA|\u0615|\u06E6|\ufe80|\u06E5|\u064B|\u0670|\u0FBCx|\u0FB5x|\u0FBB6|\u0FE7x|\u0FC62|\u0FC61|\u0FC60|\u0FDF0|\u0FDF1|\u0066D|\u0061F|\u060F|\u060E|\u060D|\060C|\u060B|\u064C|\u064D|\u064E|\u064F|\u0650|\u0651|\u0652|\u0653|\u0654|\u0655|\u0656|\0657|\u0658/
  ALIF_REGEXP = /\u0671|\u0625|\u0623/

  def remove_dialectic
    simple = gsub(DIALECTIC_CHARS_REGEXP, '')
    simple.gsub(ALIF_REGEXP, 'ا').strip
  end
end
