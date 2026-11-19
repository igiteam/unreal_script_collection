class EvilAIReactCond_Strafe extends EvilAIReactCond_RandomPushCommand within EvilAIController;

var Vector StrafePoint;
var protected class<EvilAICmd_Strafe> StrafeCommandClass;

function Initialize()
{
    StrafeCommandClass = Outer.StrafeCommand;
    SubscribeToMyChannels();
    //return;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0x9B
    if((!super.ShouldActivate(InInstigator, OriginatingChannel) || !StrafeCommandClass.static.GetStrafePoint(Outer, StrafePoint)) || int(Outer.MyEvilPawn.CoverType) != int(0))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function Activate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    super(EvilAIReactCondition).Activate(InInstigator, OriginatingChannel);
    // End:0xB0
    if(Outer.DoStrafeByDirections(Outer.,, Outer.Enemy))
    {
        LastOutputTime = Outer.WorldInfo.TimeSeconds;
    }
    //return;    
}

defaultproperties
{
    CommandClass=Class'EvilAICmd_Strafe'
    AutoSubscribedChannels[0]="TriggerStrafe"
    AutoSubscribedChannels[1]="TriggerSideStrafe"
}