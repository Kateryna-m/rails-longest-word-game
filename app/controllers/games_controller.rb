require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << (("A".."Z").to_a).sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @result = {}
    if english_word? == true && contained_in_grid? == true
      @result[:message] = "Well done you got it right!"
      @result[:score] = @word.length.to_i
    elsif english_word? == false
      @result[:message] = "Not an english word!"
      @result[:score] = 0
    else
      contained_in_grid? == false
      @result[:message] = "Not in the grid!"
      @result[:score] = 0
    end
    return @result
  end

  def contained_in_grid?
    condition = @word.upcase.split("").all? do |letter|
      @word.upcase.count(letter) <= @letters.count(letter)
    end

    return condition
  end

  def english_word?
    url = 'https://wagon-dictionary.herokuapp.com/' + @word
    result = open(url).read
    result_hash = JSON.parse(result)

    return result_hash["found"]
  end
end
