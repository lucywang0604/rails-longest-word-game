require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array('A'..'Z').sample(10)
  end

  def score
    # Retrieve the word and grid from the form submission
    @word = params[:word]
    @letters = params[:letters].present? ? params[:letters].split(',') : []

    # 1. Check if the word can be built from the grid
    if !can_form_word_from_grid?(@word, @letters)
      @message = "The word can't be built out of the grid."
    # 2. Check if the word is a valid English word using an API
    elsif !valid_english_word?(@word)
      @message = "The word is not a valid English word."
    else
      @message = "Congratulations, the word is valid!"
    end
  end

  private

  def can_form_word_from_grid?(word, grid)
    word_chars = word.upcase.chars
    grid_copy = grid.clone

    word_chars.each do |char|
      if grid_copy.include?(char)
        grid_copy.delete_at(grid_copy.index(char))
      else
        return false
      end
    end
    true
  end

  def valid_english_word?(word)
    # Use an external API to check if the word is a valid English word
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    result = JSON.parse(response)

    # Check if there are valid results from the API (non-empty response)
    result['found']
  rescue OpenURI::HTTPError => e
    false
  end
end
