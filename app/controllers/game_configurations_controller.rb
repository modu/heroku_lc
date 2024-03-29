require 'game_configurations_helper'
include GameConfigurationsHelper
class GameConfigurationsController < ApplicationController
  
  
  def created
    binding.pry
    o1 = store_parse(params)
    converter(o1)    
    storing = GameConfiguration.new :gameName => o1[:gameName], :nonRepeat => @ans1, :repeat => @ans2
    storing.save
  end
  
  def createGame
    
  end
  
  def showEditGame
    @gameName = params["editGame"]
    @repeat = []
    @nonrepeat = []
    GameConfiguration.where(gameName:@gameName).to_a[0].nonRepeat.each do |t|
      @repeat << t
    end
    GameConfiguration.where(gameName:@gameName).to_a[0].repeat.each do |t|
      @nonrepeat << t
    end    
  end
  
  def editGame
    
    #delete_all params[:oldGameName]             #deleting all levels, sequence, experiment refrenced from oldGameName
    binding.pry
    o1 = store_parse(params)
    converter(o1)    
    storing = GameConfiguration.new :gameName => o1[:gameName], :nonRepeat => @ans1, :repeat => @ans2
    storing.save
    redirect_to '/showGames'
    
  end
  
  def createLevel
    query = GameConfiguration.all(:conditions => {:gameName => params["gameName"]})
    v = query.first
    @ans1 = v[:nonRepeat]
    @ans2 = v[:repeat]
    @str0 = '<form method=post action=/createdLevel/'+params['gameName']+'>'
    @str3 = script @ans2
  end
  
  def showGames
    @games = Active.find(:all).to_a.map {|x| x["gameName"]}
  end
  
  def activeGames
    @acttiveGames = Active.find(:all).to_a.map {|x| x["gameName"]}
  end
  
  def addToActiveGames
    storing = Active.new :gameName => params["AddGame"]
    storing.save
    redirect_to "/all"
  end
  
  def all
    @games = GameConfiguration.find(:all).to_a.map {|x| x["gameName"]}
  end
  
  def delete
    gameName = params[:gameName]
    Active.where("gameName" => gameName).delete_all
    redirect_to '/showGames'
  end
  
  def deleteCompletely
    @gameName = params[:delGameName]
    GameConfiguration.where(gameName:@gameName).delete_all
    Level.where(@gameName=>{"$exists"=>true}).delete_all
    Sequence.where(gameName:@gameName).delete_all
    Experiment.where(gameName:@gameName).delete_all
    redirect_to "/all"
  end
  
  def delete_all oldGameName
    GameConfiguration.where(gameName:oldGameName).delete_all
    Level.where(oldGameName=>{"$exists"=>true}).delete_all
    Sequence.where(gameName:oldGameName).delete_all
    Experiment.where(gameName:oldGameName).delete_all
    redirect_to "/showGames"    
  end
  
end
