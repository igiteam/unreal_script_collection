class SPDAction_SpawnSkeletalMesh extends SPDAction_SpawnActor
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var(SPDAction) SkeletalMesh SkelMesh;
var(SPDAction) bool MatchBoneOrientationOfOriginal;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDSkeletalMesh newActor;

    newActor = SPDSkeletalMesh(CreateActor(Manager, Actor, DamageInfo));
    // End:0xDC
    if(newActor != none)
    {
        newActor.SkeletalMeshComponent.SetPhysicsWeight(1.0000000);
        newActor.SkeletalMeshComponent.SetPhysicsAsset(none);
        newActor.SkeletalMeshComponent.SetSkeletalMesh(SkelMesh);
        FindBestSpotForSpawnLocation(newActor);
        // End:0xB7
        if(MatchBoneOrientationOfOriginal)
        {
            MatchActorBoneOrientations(Actor, newActor);
        }
        newActor.DisablePathBlocking(newActor.m_pathBlockInfo, bDisablePathBlocking);
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    NewActorClass=Class'SPDSkeletalMesh'
    Action="Spawn Skeletal Mesh"
}