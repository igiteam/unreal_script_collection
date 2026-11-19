class SkyProj_AirRemote extends SkyProj_SecondaryItem
    native;

simulated function PostBeginPlay()
{
    super(SkyProjectile).PostBeginPlay();
    bLaunched = false;
    SkelMesh.SetPhysicsAsset(PhysAsset);
    SkelMesh.SetBlockRigidBody(false);
    SkelMesh.bUpdateKinematicBonesFromAnimation = true;
    SkelMesh.PhysicsWeight = 0.0000000;
    SkelMesh.FindSkelControl('Scale').SetSkelControlStrength(1.0000000, 0.0000000);
    //return;    
}

// Export USkyProj_AirRemote::execInit(FFrame&, void* const)
native function Init(Vector Direction);

// Export USkyProj_AirRemote::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

simulated function launch(Vector Loc, Rotator Rot, Vector Direction, optional Vector ExtraVelocity, optional float spinRate)
{
    // End:0x2B
    if(int(Role) == int(ROLE_Authority))
    {
        ClientLaunch(Loc, Rot, Direction);
    }
    bLaunched = true;
    CollisionComponent = SkelMesh;
    SetPhysics(10);
    SkelMesh.SetHasPhysicsAssetInstance(true);
    SkelMesh.PhysicsWeight = 1.0000000;
    SetCollision(false, false);
    SkelMesh.SetBlockRigidBody(false);
    SkelMesh.WakeRigidBody();
    SkelMesh.SetRBRotation(Rot);
    SkelMesh.SetRBPosition(Loc);
    SkelMesh.SetRBLinearVelocity(Direction * StartingVelocity, true);
    SkelMesh.SetLightEnvironment(LightEnv);
    SkelMesh.PlayAnim('air_remote_open_moving');
    //return;    
}

reliable client simulated function ClientLaunch(Vector Loc, Rotator Rot, Vector Direction)
{
    // End:0x2B
    if(int(Role) < int(ROLE_Authority))
    {
        launch(Loc, Rot, Direction);
    }
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    return;
    //return;    
}

// Export USkyProj_AirRemote::execExplode(FFrame&, void* const)
native simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor Other, optional bool bContinueAfterExplosion);

function PickEffectAndSound(name physmatname)
{
    //return;    
}

simulated function Destroyed()
{
    // End:0x44
    if(StimulusID >= 0)
    {
        SkyGame(WorldInfo.Game).StimulusSystem.RemoveStimulus(StimulusID);
        StimulusID = -1;
    }
    //return;    
}
