class SPDAction_SpawnStaticMesh extends SPDAction_SpawnActor
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var(SPDAction) StaticMesh Mesh;
var(SPDAction) bool bUseExpensivePathBlocking;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDStaticMesh newActor;

    newActor = SPDStaticMesh(CreateActor(Manager, Actor, DamageInfo));
    // End:0xD4
    if(newActor != none)
    {
        newActor.StaticMeshComponent.SetStaticMesh(Mesh);
        FindBestSpotForSpawnLocation(newActor);
        // End:0xA3
        if(bUseExpensivePathBlocking)
        {
            // End:0xA3
            if(newActor.KynapseComponent != none)
            {
                newActor.KynapseComponent.ChangeExpensivePathBlocking(bUseExpensivePathBlocking);
            }
        }
        // End:0xD4
        if(bDisablePathBlocking)
        {
            newActor.DisablePathBlocking(newActor.m_pathBlockInfo, bDisablePathBlocking);            
        }
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    NewActorClass=Class'SPDStaticMesh'
    NewActorClassMP=Class'SPDStaticMeshMP'
    Action="Spawn Static Mesh"
}