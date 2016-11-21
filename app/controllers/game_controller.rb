require 'open-uri'
require 'json'
require 'time'


class GameController < ApplicationController
  def grid
    @start_time = Time.now
    @random_grid = 9.times.map{ ('A'..'Z').to_a.sample}.join(" ")

  end

  def score
    @end_time = Time.now
    @start_time = Time.parse(params[:start])
    @answer = params[:query].upcase
    @grid = params[:grid].gsub(/\s+/, "")

    @result = run_game
  end
private

    def grid_check(attempt, grid)
      count = 0
      new_attempt = attempt.split("")
      new_attempt.each do |x|
        if grid.include? x
          count += 1
        end
      end
      if
        count == attempt.length
        return true
      else
        return false
      end
    end

    def run_game

      if grid_check(@answer, @grid) == true
        total_time = @end_time - @start_time
        result = {time: total_time}

        url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=64a07d5c-f770-4030-87d9-9158b89049d4&input=#{@answer}"
        user_serialized = open(url).read
        user = JSON.parse(user_serialized)
        result[:translation] = user["outputs"][0]["output"]
        result[:score] = (@answer.length.to_f/total_time.to_f).round(3)
        if result[:score] > 1
          result[:message] = "Good catch!"
        else
          result[:message] = "Well done!"
        end
        result

      else
        result = {message: "Try again"}
      end

    end

end
