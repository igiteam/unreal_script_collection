class AdvAICmd_POIBehavior extends EvilAICommand within EvilAIController;

var float Duration;
var float ActionEndTime;
var float TimeLeft;
var bool bLooped;

function Pushed()
{
    super.Pushed();
    bIgnoreNotifies = false;
    GotoState('InBehaviour');
    //return;    
}

function Popped()
{
    Outer.MyEvilPawn.ServerEndPawnAction(36);
    super(GameAICommand).Popped();
    //return;    
}

state InBehaviour
{Begin:

    ActionEndTime = Outer.MyEvilPawn.WorldInfo.TimeSeconds + Duration;
Loop:


    // End:0xBB
    if(Outer.MyEvilPawn != none)
    {
        Outer.MyEvilPawn.ServerDoPawnAction(36);
    }
    // End:0x147
    if(bLooped && ActionEndTime > Outer.MyEvilPawn.WorldInfo.TimeSeconds)
    {
        Outer.Sleep(0.1000000);
        goto 'Loop';
    }
    // End:0x21B
    if(ActionEndTime > Outer.MyEvilPawn.WorldInfo.TimeSeconds)
    {
        TimeLeft = ActionEndTime - Outer.MyEvilPawn.WorldInfo.TimeSeconds;
        Outer.Sleep(TimeLeft);
    }
    GotoState('InFinish');
    stop;            
}

state InFinish
{Begin:

    // End:0x45
    if(Outer.GetActiveCommand() == self)
    {
        Status = 'Success';
        ExitWithSuccess();        
    }
    else
    {
        Outer.Sleep(0.1000000);
        goto 'Begin';
    }
    stop;                
}
