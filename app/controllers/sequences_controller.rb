class SequencesController < ApplicationController
  def create
    @gameName = params["gameName"]
    @levelNames = Level.where(@gameName+'.levelname'=>{"$exists"=>true}).to_a.map {|x| x[@gameName]["levelname"]}
  end

#Saving a sequence
  def created
    
    ob = store_sequence params
    Sequence.create ob
    redirect_to "/showGames"
  end


#displaying all levels in a sequence , Xml format
#main tag neccessary otherwise error during rendring xml
  def xml
    obj = {}
    seqOb = Sequence.where('sequenceName' => params[:sequenceName]).to_a[0]
    obj['gameName'] = seqOb['gameName']
    obj['levels'] = seqOb['levels']
    obj['sequenceName'] = seqOb['sequenceName']
    render :xml => "<hash>"+ create_xml(obj, '')+ "</hash>\n"
  end

  
  def show
    @gameName = params[:gameName]
    @sequenceNames = Sequence.where(gameName:@gameName).to_a.map{|x| x["sequenceName"]}
  end 
  
#Deleting Sequence  of a particular game
# deletion from Sequence Model
#first Checking if any Existing experiment contain sequence to-be-deleted
  def delete
    @i = []
    @gameName = params["gameName"]
    @SequenceName = params["delSequenceName"]
    t = Experiment.where(gameName:@gameName,"sequences.sequence" => @SequenceName).to_a.map {|x| @i<<x["experimentName"]}    
    if t.empty?
      @t = Sequence.where(gameName:@gameName,sequenceName:@SequenceName).delete_all
      render 'delete'
      return
    end
    
    render 'message'
  end
  
#Taking gameName,sequenceName to be updated
#Retrieve all levels of that sequence--for auto selecting in dropDown  
  def update
    @i = []
    @gameName = params["gameName"]
    @sequenceName = params["upSequenceName"]
    @levelNames = Level.where(@gameName+'.levelname'=>{"$exists"=>true}).to_a.map {|x| x[@gameName]["levelname"]}
    t = Sequence.where(gameName:@gameName,sequenceName:@sequenceName).to_a.map{|t| t["levels"]["level"]}
    t[0].each do |x|
      @i << x
    end
  end

#receive updated sequenceName,its levels and store them in Sequence model  
  def updated
    @gameName = params[:gameName]
    @sequenceName = params[:oldSequenceName]
    @newSequenceName = params[:sequenceName]
    binding.pry
    update_experiment @sequenceName, @newSequenceName, @gameName
    ob = store_sequence params
    Sequence.where(gameName:@gameName,sequenceName:@sequenceName).update_all(ob)
  end
  
#delete old one and add new one with same gameName , experimentName and updated sequenceName
#when request for updating a sequenceName come, This function updates all the Experiments which have that sequenceName in it.  
  def update_experiment oldSequenceName, newSequenceName, gameName
    experimentName = []
    Experiment.where(gameName:gameName,"sequences.sequence" => oldSequenceName).to_a.map{|t| experimentName.push(t["experimentName"])}
    binding.pry
    experimentName.each do |f|
      sequenceNamesArray = []
      sequenceNamesArray = Experiment.where(gameName:gameName,experimentName:f).to_a.first.sequences["sequence"]
      sequenceNamesArray.each_index do |t|
         if sequenceNamesArray[t] == oldSequenceName
           sequenceNamesArray[t] = newSequenceName
         end              
      end     #end of do
      newHash = {gameName:gameName,experimentName:f,sequences:{"sequence" => sequenceNamesArray }}
      Experiment.where(gameName:gameName,experimentName:f).delete_all
      binding.pry
      Experiment.create(newHash)
    end
          
  end        #end of function update_experiment
  
  
end
