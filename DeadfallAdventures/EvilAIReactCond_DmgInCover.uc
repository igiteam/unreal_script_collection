class EvilAIReactCond_DmgInCover extends EvilAIReactCondition within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    return super.ShouldActivate(InInstigator, OriginatingChannel) && int(Outer.MyEvilPawn.CoverType) != int(0);
    //return ReturnValue;    
}

function Activate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    super.Activate(InInstigator, OriginatingChannel);
    // End:0x7C
    if(int(Outer.MyEvilPawn.CoverAction) != int(0))
    {
        Outer.InvalidateCoverAction();        
    }
    //return;    
}

defaultproperties
{
    AutoSubscribedChannels[0]="Damage"
}