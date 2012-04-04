class LevelsController < ApplicationController

#storing level data in correct format via store_level function  
#store_level function in application_controller.rb
  def created
    obj = Level.create store_level(params)
    redirect_to "/showGames"
    #render  :action    "game_configurations/showGames"
  end

#rendring level data in xml format
#create_xml function in application_controller.rb  
  def xml
    obj = {}
    obj[params['gameName']] = Level.where(params["gameName"]+'.levelname'=>params["levelName"]).to_a[0][params['gameName']]
    if obj.length == 0
      obj[params['gameName']] = Level.where(params["gameName"]+'.levelName'=>params["levelName"]).to_a[0][params['gameName']]
    end
    out = create_xml(obj, '')
    render :text => out, :content_type => 'text/xml'
  end

#displaying all levels of a game  
  def show
    @gameName = params["gameName"]
    @levelNames = Level.where(@gameName+'.levelname'=>{"$exists"=>true}).to_a.map {|x| x[@gameName]["levelname"]}
    if @levelNames.length==0
      @levelNames = Level.where(@gameName+'.levelName'=>{"$exists"=>true}).to_a.map {|x| x[@gameName]["levelName"]}
    end
  end

#Delete a particular level 
#but first checking if any sequence already contain that level
#If not then delete it otherwise display "message"   
  def delete
    @i = []
    @gameName = params["gameName"]
    @LevelName = params["delLevelName"]
    t = Sequence.where(gameName:@gameName,"levels.level" => @LevelName).to_a.map {|x| @i<<x["sequenceName"]}    
    if t.empty?
      Level.where(@gameName+".levelname"=>@LevelName).delete_all
      render 'delete'
      return
    end
    
    render 'message'
  end
  
end

