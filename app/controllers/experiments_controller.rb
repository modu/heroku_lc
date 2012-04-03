class ExperimentsController < ApplicationController
  def create
    @gameName = params["gameName"]
    @sequenceNames = Sequence.where(gameName:@gameName).to_a.map{|x| x["sequenceName"]}
    
  end

  def created
    #for changing to correct format
    ob = store_experiment params                    #store_experiment function in application_controller
    Experiment.create ob                            #create and save
    redirect_to "/showGames"                        
  end

#For displaying xml
  def xml    
    obj = {}
    expOb = Experiment.where('experimentName' => params[:experimentName]).to_a[0]
    obj['gameName'] = expOb['gameName']
    obj['sequences'] = expOb['sequences']
    obj['experimentName'] = expOb['experimentName']
    out = create_xml(obj, '')
    r = "<hash>"+out+"</hash>\n"                  #Without main tag i.e. <hash>, error in displaying out xml
    render :xml => r
  end
  
  #rabel
  def show
    @gameName = params[:gameName]
    @experimentName = Experiment.where(gameName:@gameName).to_a.map{|x| x["experimentName"]}
  end
  
#Show Sequence's xml Randomly   
#sort_by function on array , with argument for random suffle
  def ShowSequenceRandomXml  
    @gameName = params[:gameName]
    @experimentName = params[:experimentName]
    @sequenceNames = Experiment.where(gameName:@gameName,experimentName:@experimentName).to_a.first.sequences["sequence"].sort_by{rand} 
    seqOb = Sequence.all_of('sequenceName' => @sequenceNames[0]).first
    if seqOb!=nil
      render :xml => seqOb
    end
     
  end
  
  def delete
    @gameName = params["gameName"]
    @ExperimentName = params["delExperimentName"]
    if( Experiment.where(gameName:@gameName,experimentName: @ExperimentName).to_a.empty? )
      Experiment.where(gameName:@gameName,experimentName: @ExperimentName).to_a.delete_all
      render 'delete'
      return
    end
    render 'message'
  end
  def update
    @i = []
    @gameName = params["gameName"]
    @ExperimentName = params["upExperimentName"]
    @sequenceNames = Sequence.where(gameName:@gameName).to_a.map{|x| x["sequenceName"]}
    t = Experiment.where(gameName:@gameName,experimentName:@ExperimentName).to_a.map{|t| t["sequences"]["sequence"]}
    t[0].each do |x|
      @i << x
    end
    
  end
  
  def updated
    @gameName = params[:gameName]
    @experimentName = params[:oldExperimentName]
    ob = store_experiment params
    
    t = Experiment.where(gameName:@gameName,experimentName:@experimentName).update_all(ob)
      if t==0
        return false
      end
    render 'updated'  
  end
  
end
