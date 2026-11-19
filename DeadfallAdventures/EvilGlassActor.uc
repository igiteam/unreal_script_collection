class EvilGlassActor extends FracturedStaticMeshActor
    native
    hidecategories(Navigation);

var bool bIsBreaking;
var() bool bAlwaysBlastHoles;
var() bool bBreakChunksOnInterpActorTouch;
var bool bUseParticleTrick;
var() bool bEnabled;
var transient bool bForceSpawnPart;
var int ReceivedShots;
var Vector ShatterOrigin;
var Vector BlowDirection;
var float AccumulatedTime;
var int AccumulatedDamage;
var() float InitialShatterDelay;
var() float DamageToRadius;
var() float ShatterPropagationSpeed;
var() float ShatterSpeedFluctuations;
var() ParticleSystem FakeShardEffect;
var() int DamageThresholdToMaterialChange;
var() int DamageTresholdToHole;
var() float EventsDamageScale;
var() float InterpActorTouchBreakRadius;
var transient Actor GlassBreaker;
var float PreviousFractureSoundStart;

simulated function bool ShouldChangeMaterial()
{
    // End:0x35
    if((AccumulatedDamage > DamageThresholdToMaterialChange) && AccumulatedDamage < DamageTresholdToHole)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function bool ShouldDealDamage()
{
    // End:0x2B
    if((AccumulatedDamage > DamageTresholdToHole) || bAlwaysBlastHoles)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function bool ShouldStartShatter()
{
    // End:0x64
    if((bEnabled && AccumulatedDamage > DamageTresholdToHole) && !bIsBreaking || bIsBreaking && AccumulatedTime <= InitialShatterDelay)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function StartShatter(Vector StartLocation, Vector Momentum)
{
    // End:0x6B
    if(ShatterPropagationSpeed > 0.0100000)
    {
        bIsBreaking = true;
        ShatterOrigin = StartLocation;
        BlowDirection = Momentum;
        AccumulatedTime = 0.0000000;
        bUseParticleTrick = true;
        Enable('Tick');
    }
    //return;    
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local float PrevSoundStart;
    local bool bPrevForceSpawnPart;

    // End:0x13
    if(!bEnabled)
    {
        return;
    }
    GlassBreaker = DamageCauser;
    AccumulatedDamage += Damage;
    PrevSoundStart = PreviousFractureSoundStart;
    bPrevForceSpawnPart = bForceSpawnPart;
    // End:0xB5
    if(EvilPlayerController(EventInstigator) != none)
    {
        bForceSpawnPart = true;
        PreviousFractureSoundStart = WorldInfo.TimeSeconds - 50.0000000;
    }
    // End:0xE0
    if(ShouldChangeMaterial())
    {
        BreakOffPartsInRadius(HitLocation, 0.0000000, 0.0000000, true);
    }
    // End:0x18E
    if(ShouldDealDamage())
    {
        super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        BreakOffPartsInRadius(HitLocation, float(Damage) * DamageToRadius, 0.0000000, true);
        // End:0x18E
        if(ShouldStartShatter())
        {
            StartShatter(HitLocation, Momentum);
        }
    }
    PreviousFractureSoundStart = FMax(PreviousFractureSoundStart, PrevSoundStart);
    bForceSpawnPart = bPrevForceSpawnPart;
    //return;    
}

simulated event TakeDamageForEvents(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x13
    if(!bEnabled)
    {
        return;
    }
    GlassBreaker = DamageCauser;
    AccumulatedDamage += int(float(Damage) * EventsDamageScale);
    // End:0x74
    if(ShouldChangeMaterial())
    {
        BreakOffPartsInRadius(HitLocation, 0.0000000, 0.0000000, true);
    }
    //return;    
}

function Tick(float ElapsedTime)
{
    local float Distance;

    super(Actor).Tick(ElapsedTime);
    // End:0x116
    if(bIsBreaking)
    {
        AccumulatedTime += ElapsedTime;
        // End:0xAE
        if(AccumulatedTime >= InitialShatterDelay)
        {
            Distance = AccumulatedTime - InitialShatterDelay;
            Distance *= (ShatterPropagationSpeed + (FRand() * ShatterSpeedFluctuations));
            BreakOffPartsInRadius(ShatterOrigin, Distance, 0.0000000, true);
        }
        // End:0x116
        if(FracturedStaticMeshComponent.GetNumVisibleFragments() == 0)
        {
            bIsBreaking = false;
            Disable('Tick');
            SetCollisionType(1);
            FracturedStaticMeshComponent.SetBlockRigidBody(false);
        }
    }
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    Disable('Tick');
    bWorldGeometry = false;
    //return;    
}

simulated event BreakOffPartsInRadius(Vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles)
{
    local int I, TotalVisible;
    local array<byte> FragmentVis;
    local array<int> IgnoreFrags;
    local array<FracturedStaticMeshPart> NoCollParts;
    local Vector PartVel, FracCenter, ToFracCenter, ApproxExploDir;
    local FracturedStaticMesh FracMesh;
    local FracturedStaticMeshPart FracPart;
    local Box FracBox;
    local float ChunkDist, VelScale;
    local bool bHasBrokenAnything;

    // End:0x11
    if(!bEnabled)
    {
        return;
    }
    FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
    FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
    TotalVisible = FracturedStaticMeshComponent.GetNumVisibleFragments();
    // End:0x19B
    if(((FracMesh.LoseChunkOutsideMaterial != none) || FracturedStaticMeshComponent.LoseChunkOutsideMaterialOverride != none) && TotalVisible == FragmentVis.Length)
    {
        // End:0x15D
        if(FracturedStaticMeshComponent.LoseChunkOutsideMaterialOverride != none)
        {
            FracturedStaticMeshComponent.SetMaterial(0, FracturedStaticMeshComponent.LoseChunkOutsideMaterialOverride);            
        }
        else
        {
            FracturedStaticMeshComponent.SetMaterial(0, FracMesh.LoseChunkOutsideMaterial);
        }
    }
    I = 0;
    J0x1A6:

    // End:0x5CE [Loop If]
    if(I < FragmentVis.Length)
    {
        // End:0x5C0
        if((int(FragmentVis[I]) != int(0)) && I != FracturedStaticMeshComponent.GetCoreFragmentIndex())
        {
            FracBox = FracturedStaticMeshComponent.GetFragmentBox(I);
            FracCenter = 0.5000000 * (FracBox.Max + FracBox.Min);
            ToFracCenter = FracCenter - Origin;
            ChunkDist = VSize(ToFracCenter);
            // End:0x5C0
            if(ChunkDist < Radius)
            {
                // End:0x450
                if(FracMesh.bSpawnPhysicsChunks && FRand() < FracMesh.ChanceOfPhysicsChunk)
                {
                    PartVel = BlowDirection;
                    VelScale = 1.0000000 - (ChunkDist / Radius);
                    FracPart = SpawnPart(I, PartVel * VelScale, VRand() * FracMesh.ChunkAngVel, 1.0000000, false);
                    // End:0x44D
                    if(FracPart != none)
                    {
                        FracPart.FracturedStaticMeshComponent.DisableRBCollisionWithSMC(FracturedStaticMeshComponent, true);
                        FracPart.FracturedStaticMeshComponent.SetRBChannel(7);
                        NoCollParts[NoCollParts.Length] = FracPart;
                    }                    
                }
                else
                {
                    // End:0x580
                    if((FakeShardEffect != none) && WorldInfo.MyFractureManager != none)
                    {
                        PartVel = BlowDirection;
                        VelScale = 1.0000000 - (ChunkDist / Radius);
                        WorldInfo.MyFractureManager.SpawnChunkDestroyEffect(FakeShardEffect, FracBox, PartVel * VelScale, (DrawScale * ((DrawScale3D.X + DrawScale3D.Y) + DrawScale3D.Z)) / float(3));
                    }
                }
                IgnoreFrags[IgnoreFrags.Length] = I;
                FragmentVis[I] = 0;
                bHasBrokenAnything = true;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x1A6;
    }
    // End:0x677
    if(FracturedStaticMeshComponent.GetCoreFragmentIndex() == -1)
    {
        ApproxExploDir = Normal(FracturedStaticMeshComponent.Bounds.Origin - Origin);
        BreakOffIsolatedIslands(FragmentVis, IgnoreFrags, ApproxExploDir, NoCollParts, bWantPhysChunksAndParticles);
    }
    FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
    // End:0x6D2
    if(int(Physics) == int(10))
    {
        FracturedStaticMeshComponent.RecreatePhysState();
    }
    // End:0x787
    if(((ExplosionFractureSound != none) && bHasBrokenAnything) && (WorldInfo.TimeSeconds - PreviousFractureSoundStart) > ExplosionFractureSound.GetCueDuration())
    {
        PreviousFractureSoundStart = WorldInfo.TimeSeconds;
        PlaySound(ExplosionFractureSound, true, true, false, Origin, true);
    }
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x2B
    if(bBreakChunksOnActorTouch)
    {
        BreakOffPartsInRadius(HitLocation, 80.0000000, 0.0000000, true);
    }
    // End:0x89
    if(bBreakChunksOnInterpActorTouch && InterpActor(Other) != none)
    {
        BreakOffPartsInRadius(Other.Location, InterpActorTouchBreakRadius, 0.0000000, true);
    }
    //return;    
}

defaultproperties
{
    InitialShatterDelay=0.7000000
    EventsDamageScale=0.3000000
    // Reference: FracturedStaticMeshComponent'Default__EvilGlassActor.FracturedStaticMeshComponent0'
    begin object name=FracturedStaticMeshComponent0
        ReplacementPrimitive=none
        BlockActors=false
        BlockRigidBody=false
        bNotifyRigidBodyCollision=true
        ScriptRigidBodyCollisionThreshold=1.0000000
    end object
    FracturedStaticMeshComponent=FracturedStaticMeshComponent0
    // Reference: FracturedSkinnedMeshComponent'Default__EvilGlassActor.FracturedSkinnedComponent0'
    begin object name=FracturedSkinnedComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilGlassActor.LightEnvironment0'
    end object
    SkinnedComponent=FracturedSkinnedComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__EvilGlassActor.LightEnvironment0'
    begin object name=LightEnvironment0
    end object
    Components[0]=LightEnvironment0
    Components[1]=FracturedSkinnedComponent0
    Components[2]=FracturedStaticMeshComponent0
    CollisionType=ECollisionType.COLLIDE_BlockAll
    bMovable=true
    bBlockActors=false
    CollisionComponent=FracturedStaticMeshComponent0
}