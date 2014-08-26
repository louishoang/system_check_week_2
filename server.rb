require 'sinatra'
require 'pry'
require 'sinatra/reloader'

results = [
  {
    home_team: "Patriots",
    away_team: "Broncos",
    home_score: 7,
    away_score: 3
  },
  {
    home_team: "Broncos",
    away_team: "Colts",
    home_score: 3,
    away_score: 0
  },
  {
    home_team: "Patriots",
    away_team: "Colts",
    home_score: 11,
    away_score: 7
  },
  {
    home_team: "Steelers",
    away_team: "Patriots",
    home_score: 7,
    away_score: 21
  }
]

#### Function start ####

def winning_losing # find which team won/lost the game
  @results.each do |result|
    if result[:home_score] > result[:away_score]
      result[:winning_team] = result[:home_team]
      result[:losing_team] = result[:away_team]
    else
      result[:winning_team] = result[:away_team]
      result[:losing_team] = result[:home_team]
    end
  end
end

def initialize_teams(results) #initialize the hash which store information of each team
  teams = []

  results.each do |result|
    teams << { team_name: result[:home_team], wins: 0, losses: 0, points: 0 }
    teams << { team_name: result[:away_team], wins: 0, losses: 0, points: 0 }
  end

  teams.uniq
end

def count # how many times win or lose
  @results.each do |game|
    @teams.find do |team|
      if game[:winning_team] == team[:team_name]
        team[:wins] += 1
      end
      if game[:losing_team] == team[:team_name]
        team[:losses] += 1
      end
    end
  end
end

def sort_by_point
  # assumption : a team gets 3 points if they win, and lose (-1) point
  # if they lose. I don't know whether there is a tie game in NFL or not :)

  @teams.each do |team|
    team[:points] = (team[:wins] * 3) + (team[:losses] * (-1) )
  end
  @teams.sort_by!{|team| team[:points] }
  @teams.reverse!
end

def individual_team(team_name) # find each team result
  @result_by_team = @results.find_all do |team|
    team[:home_team] == team_name
  end

  @result_by_team_away = @results.find_all do |team|
    team[:away_team] == team_name
  end
end

def individual_record(team_name) #get win/lost of each team using params
  @record = @teams.find_all do |team|
    team[:team_name] == team_name
  end
end

##### Route Start #####
get '/' do
  redirect '/leaderboard'
end

get '/leaderboard' do
  @results = results
  winning_losing
  @teams = initialize_teams(results)
  count
  sort_by_point

  erb :leaderboard
end

get '/teams/:team_name' do
  @results = results
  winning_losing
  @teams = initialize_teams(results)
  count
  sort_by_point

  individual_team(params[:team_name])
  individual_record(params[:team_name])

  erb :individual_team
end
