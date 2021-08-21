# Modified version of https://gist.github.com/mecampbellsoup/7001539

class Integer
  ROMAN_MAPPING = {
    1 => "I",
    4 => "IV",
    5 => "V",
    9 => "IX",
    10 => "X",
    40 => "XL",
    50 => "L",
    90 => "XC",
    100 => "C"
  }

  def to_roman
    integer = self
    roman = ""

    while integer > 0
      if ROMAN_MAPPING[integer]
        roman += ROMAN_MAPPING[integer]
        return roman
      end

      roman += ROMAN_MAPPING[next_roman_key(integer)] # increment the roman numeral string here
      integer -= next_roman_key(integer) # decrement the arabic integer here
    end
  end
  
  protected
  def next_roman_key(integer)
    roman_keys = ROMAN_MAPPING.keys
    next_lower_index = (roman_keys.push(integer).sort.index(integer))-1
    roman_keys[next_lower_index]
  end
end