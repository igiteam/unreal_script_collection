class SPDAction_SpawnAnimus extends SPDAction_SpawnActor
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var(AnimusHealthPack) float LifeForceAmount;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local AnimusHealthPack newActor;

    newActor = AnimusHealthPack(CreateActor(Manager, Actor, DamageInfo));
    // End:0x7A
    if(newActor != none)
    {
        newActor.LifeForceAmount = LifeForceAmount;
        FindBestSpotForSpawnLocation(newActor);
        newActor.ParentActor = Actor;
        newActor.bKillDuringLevelTransition = true;
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    LifeForceAmount=35.0000000
    bBlockActors=false
    NewActorClass=Class'AnimusHealthPack'
    NewActorClassMP=Class'AnimusHealthPack'
    Action="Spawn Animus"
}