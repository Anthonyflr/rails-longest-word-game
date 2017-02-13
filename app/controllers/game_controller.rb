class GameController < ApplicationController
  def game
    @grid = []
    10.times do
      @grid << ('A'..'Z').to_a.sample
    end
  end

  def score
    @end_time = Time.now
    timescore = @end_time.to_time - params[:start_time].to_date.to_time
    attempt = params[:query].underscore
    attemptscore = attempt.size * 20
    finalscore = attemptscore - timescore / 10

    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=e4d19f34-1d59-4b43-a6bc-9ceea63bc54f&input=#{attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    translation = user["outputs"][0]["output"]

    h1 = Hash.new(0)
    h2 = Hash.new(0)
    a1 = attempt.upcase.split("")
    a1.each { |key| h1[key] += 1 }
    a2 = params[:grid].upcase.split("")
    a2.each { |key| h2[key] += 1 }


    bool = true
    h1.each do |key, value|
     bool = false unless h1[key] <= h2[key]
    end

   if bool
    if translation == attempt
      message = "not an english word"
      finalscore = 0
      translation = nil
    else      
      message = "well done"     
    end
  else
    message = "not in the grid"
    finalscore = 0
  end

  @result = {
    time: timescore,
    translation: translation,
    score: finalscore,
    message: message
  }
end
end