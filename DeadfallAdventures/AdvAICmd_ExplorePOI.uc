class AdvAICmd_ExplorePOI extends AdvAICommand within AdvAIController;

var array<AdvNavPOI> PointsOfInterest;
var bool bFinishWhenReady;
var AdvNavPOI CurrentPointOfInterest;
var int PointOfInterestIndex;

static function bool ExecuteExplore(AdvAIController AI, array<AdvNavPOI> POIs, bool ChooseRandom, SeqAct_AIExplorePOI SeqAct)
{
    local AdvAICmd_ExplorePOI Cmd;

    // End:0xF0
    if((AI != none) && AI.MyEvilPawn != none)
    {
        AI.ChangeBehaviorMode(1);
        Cmd = new (AI) Class'AdvAICmd_ExplorePOI';
        Cmd.PointsOfInterest = POIs;
        AI.ExploreCommand = Cmd;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super(EvilAICommand).Pushed();
    // End:0x6C
    if(!Outer.bExploreOrderReady)
    {
        FillIndexes(Outer.ExploreAction.bRandomOrder);
    }
    GotoState('SwitchPoint');
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    Outer.ExploreAction.StopAction();
    //return;    
}

function FillIndexes(bool bRandomOrder)
{
    local int Index, LastPointIndex;
    local array<int> IndexesToDraw;
    local int DrawnIndex;
    local bool bHasLastPoint;

    Outer.POIExploreOrder.Remove(0, Outer.POIExploreOrder.Length);    
    IndexesToDraw.Remove(0, IndexesToDraw.Length);    
    Index = 0;
    J0x61:

    // End:0x16E [Loop If]
    if(Index < PointsOfInterest.Length)
    {
        // End:0x134
        if(!PointsOfInterest[Index].bStayAtPoint || Outer.ExploreAction.bLoopExploring)
        {
            // End:0x106
            if(bRandomOrder)
            {
                IndexesToDraw.AddItem(Index);                                
            }
            else
            {
                Outer.POIExploreOrder.AddItem(Index);                
            }            
        }
        else
        {
            // End:0x141
            if(bHasLastPoint)
            {
            }
            LastPointIndex = Index;
            bHasLastPoint = true;
        }
        ++Index;
        // [Loop Continue]
        goto J0x61;
    }
    // End:0x1EE
    if(bRandomOrder)
    {
        J0x17B:

        // End:0x1EE [Loop If]
        if(IndexesToDraw.Length > 0)
        {
            DrawnIndex = Rand(IndexesToDraw.Length);
            Outer.POIExploreOrder.AddItem(IndexesToDraw[DrawnIndex]);            
            IndexesToDraw.Remove(DrawnIndex, 1);            
            // [Loop Continue]
            goto J0x17B;
        }
    }
    // End:0x226
    if(bHasLastPoint)
    {
        Outer.POIExploreOrder.AddItem(LastPointIndex);        
    }
    Outer.ElementInExploreOrder = 0;
    //return;    
}

function FinishWhenReady()
{
    bFinishWhenReady = true;
    //return;    
}

function ExitWithSuccess()
{
    // End:0x44
    if(bFinishWhenReady)
    {
        Outer.ExploreAction.StopAction();        
    }
    else
    {
        Outer.ExploreAction.FinishAction();
    }
    super(EvilAICommand).ExitWithSuccess();
    //return;    
}

state SwitchPoint
{Begin:

    // End:0xE0
    if((Outer.ElementInExploreOrder >= Outer.POIExploreOrder.Length) && Outer.ExploreAction.bLoopExploring)
    {
        // End:0xC0
        if(Outer.ExploreAction.bRandomOrder)
        {
            FillIndexes(true);            
        }
        else
        {
            Outer.ElementInExploreOrder = 0;
        }
    }
    // End:0x1B5
    if(!bFinishWhenReady && Outer.ElementInExploreOrder < Outer.POIExploreOrder.Length)
    {
        CurrentPointOfInterest = PointsOfInterest[Outer.POIExploreOrder[Outer.ElementInExploreOrder]];
        Outer.ElementInExploreOrder++;
        GotoState('MoveToPoint');        
    }
    else
    {
        ExitWithSuccess();
    }
    stop;                    
}

state MoveToPoint
{Begin:

    // End:0xB4
    if(!Outer.Pawn.ReachedPoint(CurrentPointOfInterest.Location, none))
    {
        Outer.SetMoveGoal(CurrentPointOfInterest, 0.0000000, false, true, false);
        Outer.Sleep(0.1000000);
        goto 'Begin';        
    }
    else
    {
        GotoState('ExplorePoint');
    }
    stop;        
}

state ExplorePoint
{Begin:

    // End:0x64
    if(CurrentPointOfInterest.LookAt != none)
    {
        Outer.Focus = CurrentPointOfInterest.LookAt;        
    }
    else
    {
        Outer.SetFocalPoint(CurrentPointOfInterest.Location + (Vector(CurrentPointOfInterest.Rotation) * float(100)));
    }
    // End:0x11A
    if(CurrentPointOfInterest.NavPointActions.Length > 0)
    {
        Outer.ExecuteNavActions(CurrentPointOfInterest);        
    }
    else
    {
        Outer.Sleep(CurrentPointOfInterest.ExploreDuration);
    }
    // End:0x183
    if(CurrentPointOfInterest.bStayAtPoint)
    {
        GotoState('StayAtPoint');        
    }
    else
    {
        GotoState('SwitchPoint');
    }
    stop;            
}

state StayAtPoint
{Begin:

    Outer.ExploreAction.AtLastPoint();
Loop:


    // End:0x6D
    if(!bFinishWhenReady)
    {
        Outer.Sleep(0.5000000);
        goto 'Loop';        
    }
    else
    {
        ExitWithSuccess();
    }
    stop;                    
}
