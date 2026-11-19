class SPVehicleController extends SPAIController
    native;

function OnAIMoveToActor(SeqAct_AIMoveToActor inAction)
{
    super.OnAIMoveToActor(inAction);
    //return;    
}

function ClearMove(optional bool bNoAIMoveToActorLatentClear)
{
    //return;    
}

state MoveToGoal
{
    function ClearMove(optional bool bNoAIMoveToActorLatentClear)
    {
        super(SPAIController).ClearMove(bNoAIMoveToActorLatentClear);
        //return;        
    }
    stop;    
}
