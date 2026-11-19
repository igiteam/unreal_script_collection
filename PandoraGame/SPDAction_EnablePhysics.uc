class SPDAction_EnablePhysics extends SPDAction
    native
    editinlinenew
    collapsecategories;

// Export USPDAction_EnablePhysics::execInitPhysics(FFrame&, void* const)
native function bool InitPhysics(SkeletalMeshComponent SmComponent, float Weight);

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local editinline SkeletalMeshComponent SkeletalMesh;
    local editinline StaticMeshComponent StaticMesh;

    // End:0x0E
    if(Actor == none)
    {
        return 1;
    }
    SkeletalMesh = Actor.GetSkeletalMeshComponent();
    // End:0x88
    if((SkeletalMesh != none) && SkeletalMesh.PhysicsAsset != none)
    {
        Actor.SetPhysics(10);
        InitPhysics(SkeletalMesh, SkeletalMesh.GetPhysicsWeight());
        SkeletalMesh.WakeRigidBody();        
    }
    else
    {
        StaticMesh = Actor.GetStaticMeshComponent();
        // End:0xC9
        if(StaticMesh != none)
        {
            Actor.SetPhysics(10);
            StaticMesh.WakeRigidBody();
        }
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Action="Enables Physics."
}