class PKStakeVirtualProjectile extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var() export editinline StaticMeshComponent Mesh;
var PKPawn BindedActor;
var name BindedBoneName;
var const bool bPinned;
var bool bDebugLogs;
var bool bShowDebugTraces;
var Vector BindOffset;
var SoundCue StakeHitSoundCue;

simulated function SetInitialVelocity(Vector InVelocity, Controller StakeOwner)
{
    local PKPawn PKP;
    local Actor HitPawn;
    local Vector HitLoc, HitNorm;
    local TraceHitInfo _TraceHitInfo;
    local Vector BodyCMSHitLocation;

    Velocity = InVelocity * 0.5000000;
    HitPawn = Trace(HitLoc, HitNorm, Location + Velocity, Location, true,, _TraceHitInfo, 1);
    PKP = PKPawn(HitPawn);
    // End:0xC0
    if((PKP == none) || StakeOwner == PKP.Controller)
    {
        Destroy();
        return;
    }
    // End:0x2BD
    if(int(PKP.Physics) != int(10))
    {
        PKP.CollisionComponent = PKP.Mesh;
        PKP.Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
        // End:0x200
        if(PKP.Mesh.bNotUpdatingKinematicDueToDistance)
        {
            PKP.Mesh.ForceSkelUpdate();
            PKP.Mesh.UpdateRBBonesFromSpaceBases(true, true);
        }
        PKP.Mesh.PhysicsWeight = 1.0000000;
        PKP.SetPhysics(10);
        PKP.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        PKP.SetPawnRBChannels(true);
    }
    BindedActor = PKPawn(HitPawn);
    // End:0x2ED
    if(BindedActor == none)
    {
        Destroy();
        return;
    }
    BindedBoneName = _TraceHitInfo.BoneName;
    Mesh.SetAbsolute(,, true);
    Mesh.SetRotation(Rotator(Velocity));
    Class'EvilGame.EvilPawn'.static.GetGlobalCMassLocation(PKPawn(HitPawn).Mesh, BodyCMSHitLocation, BindedBoneName);
    Class'EvilGame.EvilPawn'.static.SetRBLinearVelocityToLinkedBodies(PKPawn(HitPawn).Mesh, Velocity, false, BindedBoneName);
    BindOffset = Normal(InVelocity) * (-VSize(Location - BodyCMSHitLocation) * 1.1000000);
    PKPawn(HitPawn).PinningStakes.AddItem(self);
    //return;    
}

simulated event PinnedPawn(PKPawn P)
{
    P.SpawnImpactDecal(Location, Normal(-Velocity));
    P.PlaySound(StakeHitSoundCue, true,, false, Location);
    //return;    
}

static simulated function bool CanPinTo(Actor TestActor)
{
    local bool bResult;

    bResult = true;
    // End:0x48
    if(ClassIsChildOf(TestActor.Class, Class'EvilGame.EvilPawn'))
    {
        bResult = false;        
    }
    else
    {
        // End:0x84
        if(ClassIsChildOf(TestActor.Class, Class'Engine.KActor'))
        {
            bResult = false;            
        }
        else
        {
            // End:0xC0
            if(ClassIsChildOf(TestActor.Class, Class'EvilGame.EvilDestructibleObject'))
            {
                bResult = false;                
            }
            else
            {
                // End:0xFC
                if(ClassIsChildOf(TestActor.Class, Class'EvilGame.EvilDynamicDestructibleObject'))
                {
                    bResult = false;                    
                }
                else
                {
                    // End:0x138
                    if(ClassIsChildOf(TestActor.Class, Class'Engine.FracturedStaticMeshActor'))
                    {
                        bResult = false;                        
                    }
                    else
                    {
                        // End:0x174
                        if(ClassIsChildOf(TestActor.Class, Class'PainItemKActorBase'))
                        {
                            bResult = false;                            
                        }
                        else
                        {
                            // End:0x1B0
                            if(ClassIsChildOf(TestActor.Class, Class'Engine.InterpActor'))
                            {
                                bResult = false;                                
                            }
                            else
                            {
                                // End:0x22B
                                if(ClassIsChildOf(TestActor.Class, Class'Engine.StaticMeshActor') && StaticMeshActor(TestActor).StaticMeshComponent.CanBecomeDynamic())
                                {
                                    bResult = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

static simulated function bool PassThruTest(Actor TestActor)
{
    local bool bResult;

    bResult = false;
    // End:0x45
    if(ClassIsChildOf(TestActor.Class, Class'PainItemBase'))
    {
        bResult = true;
    }
    return bResult;
    //return ReturnValue;    
}

static simulated function Actor FindStaticActor(PKPawn P, name BoneName, Vector TraceStart, Vector TraceEnd)
{
    local Actor GoodActor, TraceActor;
    local Vector HitNorm, HitLoc;
    local PKStakeVirtualProjectile Proj;

    GoodActor = none;
    // End:0x67
    foreach P.PinningStakes(Proj)
    {
        // End:0x66
        if(Proj.BindedBoneName == BoneName)
        {            
            return none;
        }        
    }    
    // End:0x12B
    foreach P.TraceActors(Class'Engine.Actor', TraceActor, HitLoc, HitNorm, TraceEnd, TraceStart)
    {
        // End:0x12A
        if(!Class'PKStakeVirtualProjectile'.static.PassThruTest(TraceActor))
        {
            // End:0x127
            if(Class'PKStakeVirtualProjectile'.static.CanPinTo(TraceActor))
            {
                GoodActor = TraceActor;
            }
            // End:0x12B
            break;
        }        
    }    
    return GoodActor;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PKStakeVirtualProjectile.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    begin object name="StaticMesh" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'wp_Stakegun.Mesh.sk_wp_StakegunAmmoStickBig_01_01'
        ReplacementPrimitive=none
        Scale=0.0400000
    end object
    Mesh=StaticMesh
    StakeHitSoundCue=SoundCue'a_Stake.Cue.stake_hit2'
    Components[0]=StaticMesh
    // Reference: StaticMeshComponent'Default__PKStakeVirtualProjectile.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    begin object name="StaticMeshComponent0" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'phx_Misc.sm_en_all_Kamyk_01_01'
        ReplacementPrimitive=none
        HiddenGame=true
        HiddenEditor=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    Components[1]=StaticMeshComponent0
    LifeSpan=8.0000000
    CollisionComponent=StaticMeshComponent0
}