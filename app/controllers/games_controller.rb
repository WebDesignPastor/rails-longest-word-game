require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @letters
  end

  def score
    @word = params[:input].upcase
    @letters = params[:letters].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    if good_word(@word, @letters) && user['found']
      @score = "Congratulations #{@word} is a valid English word!"
      @tag = 1
    elsif good_word(@word, @letters) && user['found'] == false
      @score = "Sorry, but #{@word} does not seem to be a valid English word"
      @tag = 2
    else
      @score = "Sorry, we can't build out of #{@letters}"
      @tag = 3
    end
    @score
    @tag
  end

  private

  def good_word(word, letters)
    word.split('').all? do |letter|
      letters.include?(letter)
    end
  end
end
