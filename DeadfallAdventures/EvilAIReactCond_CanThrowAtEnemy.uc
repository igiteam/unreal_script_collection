class EvilAIReactCond_CanThrowAtEnemy extends EvilAIReactCond_CanShootEnemy within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    return (super.ShouldActivate(InInstigator, OriginatingChannel) && Outer.CanThrowAttack()) && Outer.ShouldThrowGrenade();
    //return ReturnValue;    
}

defaultproperties
{
    bCheckSouldStartShootAttack=false
}