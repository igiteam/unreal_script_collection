class SPGrenadeLauncherPersistentNPC extends SPGrenadeLauncherPersistent
    abstract
    native
    config(Game);

// Export USPGrenadeLauncherPersistentNPC::execIsAMolotovGrenade(FFrame&, void* const)
native function bool IsAMolotovGrenade();

simulated function AttachWeapon(SkeletalMeshComponent parentMesh, name BoneName)
{
    // End:0x78
    if(Mesh != none)
    {
        Mesh.SetHidden(false);
        Mesh.SetShadowParent(parentMesh);
        Mesh.SetLightEnvironment(parentMesh.LightEnvironment);
        // End:0x78
        if(parentMesh != none)
        {
            parentMesh.AttachComponent(Mesh, BoneName);
        }
    }
    DetermineDestFOV(0.0000000);
    ClientSetWeaponDPG(1);
    //return;    
}

simulated function DetachWeapon()
{
    local editinline SkeletalMeshComponent parentMesh;

    // End:0x25
    if(Owner != none)
    {
        parentMesh = Pawn(Owner).Mesh;
    }
    // End:0x87
    if(Mesh != none)
    {
        Mesh.SetHidden(true);
        Mesh.SetShadowParent(none);
        Mesh.SetLightEnvironment(LightEnvironment);
        // End:0x87
        if(parentMesh != none)
        {
            parentMesh.DetachComponent(Mesh);
        }
    }
    //return;    
}

simulated function SPGrenadePersistent GrenadeFireNPC(Vector inputDesiredVelocity, Vector StartLocation)
{
    local SPGrenadePersistent SpawnedProjectile;
    local Vector speedScalar;

    SpawnedProjectile = FireGrenadePersistent(StartLocation, speedScalar);
    // End:0x90
    if(SpawnedProjectile != none)
    {
        SpawnedProjectile.Init(Normal(inputDesiredVelocity));
        SpawnedProjectile.StaticMeshComponent.SetRBLinearVelocity(inputDesiredVelocity);
        SpawnedProjectile.SetGravityZOverride(GetGravityZ());
        SpawnedProjectile.bKillDuringLevelTransition = true;
    }
    // End:0xAF
    if(BulletGrenadePersistentClass == BulletMolotovClass)
    {
        AttachFireToMolotov(SpawnedProjectile, true);
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}
