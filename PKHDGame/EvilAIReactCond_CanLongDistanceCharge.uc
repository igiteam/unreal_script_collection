class EvilAIReactCond_CanLongDistanceCharge extends EvilAIReactCond_GenericCallDelegate within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    return (((super.ShouldActivate(InInstigator, OriginatingChannel) && Outer.CanLongDistanceCharge()) && !Outer.MyEvilPawn.IsAiming()) && !Outer.IsFiring()) && Outer.MyEvilPawn.bInMoveLatent;
    //return ReturnValue;    
}
