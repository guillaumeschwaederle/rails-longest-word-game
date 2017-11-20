require 'open-uri'
require 'json'


class LongestwordController < ApplicationController
  def game
    @grid = generate_grid(10)
  end

  def score
    @start_time = Time.now
    @presquegrid = params[:wordgrid]
    @end_time = Time.now
    @attempt = params[:query]
    @result = run_game(@attempt, @presquegrid, @start_time, @end_time)
    @score = @result[:score]
    @message = @result[:message]
  end
end


def generate_grid(grid_size)
  # TODO: generate random grid of letters
  arr = []
  i = 0
  while i < grid_size
    arr << [*"A".."Z"].sample
    i += 1
  end
  arr
end

def english_word?(word)
  res = "https://wagon-dictionary.herokuapp.com/" + word
  hash = JSON.parse(open(res).read)
  hash["found"]
end

def lettergrid?(word, grid)
  # return false if word.size > grid.size
  word.upcase!
  bl = true
  word.each_char do |let|
    if !grid.include?(let)
      return false
    else
      grid.slice!(grid.index(let))
    end
  end
  return bl
end

def run_game1(my_hash, attempt, grid, start_time, end_time)
  my_hash[:score] = 0
  if !english_word?(attempt)
    my_hash[:message] = "This is not an english word!"
  elsif !lettergrid?(attempt, grid)
    my_hash[:message] = "This letter is not in the grid!"
  else
    my_hash[:message] = "Well Done!"
    my_hash[:score] = attempt.size * (100 - (end_time - start_time))
  end
  return my_hash
end

def run_game(attempt, grid, start_time, end_time)
  my_hash = {}
  my_hash = run_game1(my_hash, attempt, grid, start_time, end_time)
  my_hash[:time] = end_time - start_time
  return my_hash
end
