class SPDAction_SpawnPrefab extends SPDAction_Spawn
    native
    editinlinenew
    collapsecategories;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(SPDAction) Object Archetype;
var Actor ArchetypeActor;

// Export USPDAction_SpawnPrefab::execCreateFromArcheType(FFrame&, void* const)
native function Actor CreateFromArcheType(Vector SpawnLocation, Rotator SpawnRotation, Actor baseActor);

function Actor CreateActorInternal(SPDProcessManager Manager, Vector SpawnLocation, Rotator SpawnRotation, Actor baseActor)
{
    return CreateFromArcheType(SpawnLocation, SpawnRotation, baseActor);
    //return ReturnValue;    
}

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Action="Spawn using Archetype"
}