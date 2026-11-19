class SPDAction_SpawnLifeForceObj extends SPDAction_SpawnActor
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var() float LifeForceAmount;
var() bool OverrideLifeForceAmount;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPLifeForceHolder lifeForceHolder;
    local SPPawn thePawn;

    thePawn = SPPawn(Actor);
    // End:0x38
    if(thePawn != none)
    {
        NewActorClass = thePawn.GetLifeForceHolderClass();        
    }
    else
    {
        NewActorClass = Class'SPLifeForceHolder';
    }
    NewActorClassMP = NewActorClass;
    lifeForceHolder = SPLifeForceHolder(CreateActor(Manager, Actor, DamageInfo));
    // End:0xA5
    if(OverrideLifeForceAmount)
    {
        lifeForceHolder.InitialLifeForceAmount = LifeForceAmount;
        lifeForceHolder.LifeForceAmount = LifeForceAmount;
    }
    lifeForceHolder.ParentActor = Actor;
    lifeForceHolder.ParentSPDAction = none;
    lifeForceHolder.bKillDuringLevelTransition = true;
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    OverrideLifeForceAmount=true
    bBlockActors=false
    bCheckForSpawnCollision=false
    Action="Spawn Life Force"
    bServerOnly=true
}