class EvilAIReactCond_RandomCallDelegate extends EvilAIReactCond_GenericCallDelegate within EvilAIController;

var float CallChance;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    return super.ShouldActivate(InInstigator, OriginatingChannel) && FRand() < CallChance;
    //return ReturnValue;    
}

defaultproperties
{
    CallChance=1.0000000
}