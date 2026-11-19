class EvilAIReactCond_EmergeEnemy extends EvilAIReactConditionConduit within EvilAIController;

var() float DistanceThreshold;
var bool bKnockedDown;

function GetUpWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    Outer.ReactionManager.UnSuppressAllReactions();
    // End:0x78
    if(bKnockedDown)
    {
        Outer.MyEvilPawn.CheckGetUpFromRagdoll();        
    }
    else
    {
        Outer.MyEvilPawn.CheckGetUpFromAnimation();
    }
    //return;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0xA3
    if(super.ShouldActivate(InInstigator, OriginatingChannel))
    {
        // End:0x3C
        if(EvilAIReactChan_Damage(OriginatingChannel) != none)
        {
            return true;            
        }
        else
        {
            return VSizeSq(InInstigator.Location - Outer.Pawn.Location) < (DistanceThreshold ** float(2));
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    OutputFunction=GetUpWrapper
    bOneTimeOnly=true
}