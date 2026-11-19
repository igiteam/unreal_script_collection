class EvilAIReactCond_Grenade extends EvilAIReactConditionConduit within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    return (super.ShouldActivate(InInstigator, OriginatingChannel) && !Outer.IsFriendlyPawn(InInstigator.Instigator)) && Outer.bAllowCombatTransitions;
    //return ReturnValue;    
}

function Activate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local EvilProjectile_Base Proj;

    Proj = EvilProjectile_Base(InInstigator);
    // End:0x1C5
    if(((Proj != none) && VSizeSq(Proj.Location - Outer.MyEvilPawn.Location) < Square(Proj.ExplosionArchetype.DamageRadius)) && Outer.FastTrace(Outer.MyEvilPawn.Location, Proj.Location))
    {
        // End:0x1C5
        if(Outer.CanEvade())
        {
            Outer.EvadeAwayFromActor(Proj, ((Proj.Instigator != none) ? EvilPawn(Proj.Instigator) : none));
        }
    }
    //return;    
}

defaultproperties
{
    MinTimeBetweenActivations=0.2000000
    AutoSubscribedChannels[0]="WarnProjExplode"
}