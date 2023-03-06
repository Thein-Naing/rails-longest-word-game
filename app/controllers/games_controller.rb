require 'open-uri'
require 'json'
require 'net/http'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word] # cat
    @letters = params[:letters] # "a,b,c,t"
    @included = included?(@letters, @word)

    @english_word = english_word?(@word)
    @result = if @english_word && @included
                "#{@word} is a valid English word"
              elsif !@english_word && @included
                "Sorry #{@word} does not seem to be a valid English word"
              else
                "Sorry #{@word} can not be build out of #{@letters}"
              end
  end

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = Net::HTTP.get(URI(url))
    JSON.parse(response)['found']
  end

  def included?(letters, word)
    word.upcase.chars.all? do |letter|
      word.count(letter.upcase) <= letters.count(letter.upcase)
    end
  end
end
