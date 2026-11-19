class SPDAction_SpawnLifeForce extends SPDAction_SpawnActor
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var() float LifeForceAmount;
var() bool OverrideLifeForceAmount;
var() export editinline SPDGenericActionList OnTriggerActionList;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPLifeForceHolder lifeForceHolder;

    lifeForceHolder = SPLifeForceHolder(CreateActor(Manager, Actor, DamageInfo));
    // End:0x57
    if(OverrideLifeForceAmount)
    {
        lifeForceHolder.InitialLifeForceAmount = LifeForceAmount;
        lifeForceHolder.LifeForceAmount = LifeForceAmount;
    }
    lifeForceHolder.ParentActor = Actor;
    lifeForceHolder.ParentSPDAction = self;
    lifeForceHolder.bKillDuringLevelTransition = true;
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    OverrideLifeForceAmount=true
    bCheckForSpawnCollision=false
    NewActorClass=Class'SPLifeForceHolder'
    NewActorClassMP=Class'SPLifeForceHolder'
    Action="Spawn Life Force"
}