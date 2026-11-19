class SkyProj_SecondaryItemBase extends SkyProjectile
    native;

struct native SimulatedLaunchData
{
    var Vector Location;
    var Rotator Rotation;
    var Vector Direction;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        Direction=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SoundInfo
{
    var() SoundCue Sound;
    var() name MaterialType;

    structdefaultproperties
    {
        Sound=none
        MaterialType="None"
    }
};

var(Projectile) int LowCoverRightStartingVelocity;
var(Projectile) int LowCoverLeftStartingVelocity;
var(Projectile) int LowCoverCenterStartingVelocity;
var(Projectile) int StandingCoverRightStartingVelocity;
var(Projectile) int StandingCoverLeftStartingVelocity;
var(Projectile) float StartingVelocity;
var(Projectile) float ExplodeDelay;
var(Projectile) float ExplodeDelayVariance;
var float TotalDelayLength;
var float ThrowStartTime;
var(Mesh) const editconst export editinline SkeletalMeshComponent SkelMesh;
var(Collision) PhysicsAsset PhysAsset;
var(Sounds) SoundCue ThrowSound;
var repnotify transient SimulatedLaunchData LaunchReq;
var bool bLaunched;
var bool bLanded;
var bool bCanPlayBounceEffect;
var bool bCanPlayImpactSound;
var float LandedDot;
var int LandedPitchSpeed;
var(Effects) ParticleSystem BounceEffect;
var(Effects) float BounceEffectPeriod;
var Vector LastCollideLocation;
var(Sounds) float ImpactSoundPeriod;
var(Sounds) SoundCue DefaultImpactSound;
var(Sounds) array<SoundInfo> ImpactSounds;
var protected transient int StimulusID;
var export editinline DynamicLightEnvironmentComponent LightEnv;
var SkyPawn FiringPawn;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        LaunchReq;
}

// Export USkyProj_SecondaryItemBase::execInit(FFrame&, void* const)
native function Init(Vector Direction);

// Export USkyProj_SecondaryItemBase::execInitStats(FFrame&, void* const)
native function InitStats(SkyWeaponBase InstigatorWeapon);

simulated event Destroyed()
{
    // End:0x44
    if(StimulusID >= 0)
    {
        SkyGame(WorldInfo.Game).StimulusSystem.RemoveStimulus(StimulusID);
        StimulusID = -1;
    }
    super.Destroyed();
    //return;    
}

simulated function EnableBounceEffect()
{
    bCanPlayBounceEffect = true;
    //return;    
}

simulated function EnableImpactSound()
{
    bCanPlayImpactSound = true;
    //return;    
}

simulated event DetonateTimer()
{
    local Vector HitNorm;

    // End:0x23
    if(VSize(Velocity) > float(500))
    {
        HitNorm = -Velocity;        
    }
    else
    {
        HitNorm = vect(0.0000000, 0.0000000, 1.0000000);
    }
    // End:0x6E
    if(FiringPawn != none)
    {
        FiringPawn.CheckSecondaryItemExplodedInHand(self);
        Explode(Location, Normal(HitNorm));
    }
    //return;    
}

event OnCollide(float ContactSpeed)
{
    local SkyEmitter Emitter;
    local float mag;
    local SoundCue MaterialImpactSound;

    // End:0x8D
    if(bCanPlayBounceEffect)
    {
        Emitter = Spawn(Class'SkyEmitter', self,, Location, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
        // End:0x8D
        if(Emitter != none)
        {
            mag = VSize(LastCollideLocation - Location);
            // End:0x82
            if(mag > 0.0000000)
            {
                Emitter.SetTemplate(BounceEffect, true);
                bCanPlayBounceEffect = false;
            }
            LastCollideLocation = Location;
        }
    }
    MaterialImpactSound = GetImpactSound();
    MaterialImpactSound.VolumeMultiplier = FMax(ContactSpeed / 500.0000000, 2.0000000);
    bCanPlayImpactSound = false;
    PlaySound(MaterialImpactSound, false, false, false, Location + (GetAudioOffset()));
    MakeNoise(1.0000000);
    //return;    
}

function Vector GetAudioOffset()
{
    return vect(0.0000000, 0.0000000, 0.0000000);
    //return ReturnValue;    
}

function SoundCue GetImpactSound()
{
    local int I;
    local name MaterialType;

    MaterialType = GetGroundMaterialType();
    I = default.ImpactSounds.Find('MaterialType', MaterialType);
    // End:0x44
    if(I == -1)
    {
        return default.DefaultImpactSound;        
    }
    else
    {
        return default.ImpactSounds[I].Sound;
    }
    //return ReturnValue;    
}

simulated event name GetGroundMaterialType()
{
    local Vector HitLocation, HitNormal, TraceStart;
    local TraceHitInfo HitInfo;
    local SkyPhysicalMaterialProperty PhysicalProperty;
    local name MaterialType;

    TraceStart = Location;
    Trace(HitLocation, HitNormal, TraceStart + vect(0.0000000, 0.0000000, 200.0000000), TraceStart, false,, HitInfo);
    // End:0x9E
    if(HitInfo.PhysMaterial != none)
    {
        PhysicalProperty = SkyPhysicalMaterialProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(Class'SkyPhysicalMaterialProperty'));
        // End:0x9E
        if(PhysicalProperty != none)
        {
            MaterialType = PhysicalProperty.MaterialType;
        }
    }
    TraceStart = Location;
    Trace(HitLocation, HitNormal, TraceStart - vect(0.0000000, 0.0000000, 200.0000000), TraceStart, false,, HitInfo);
    // End:0x13C
    if(HitInfo.PhysMaterial != none)
    {
        PhysicalProperty = SkyPhysicalMaterialProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(Class'SkyPhysicalMaterialProperty'));
        // End:0x13C
        if(PhysicalProperty != none)
        {
            MaterialType = PhysicalProperty.MaterialType;
        }
    }
    return MaterialType;
    //return ReturnValue;    
}

// Export USkyProj_SecondaryItemBase::execExplode(FFrame&, void* const)
native simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor Other, optional bool bContinueAfterExplosion);

simulated function launch(Vector Loc, Rotator Rot, Vector Direction, optional Vector ExtraVelocity, optional float spinRate)
{
    local Vector NewAngularVelocity;

    // End:0x5B
    if(int(Role) == int(ROLE_Authority))
    {
        LaunchReq.Location = Loc;
        LaunchReq.Rotation = Rot;
        LaunchReq.Direction = Direction * 100.0000000;
    }
    bLaunched = true;
    CollisionComponent = SkelMesh;
    SetPhysics(10);
    SkelMesh.SetHasPhysicsAssetInstance(true);
    SkelMesh.PhysicsWeight = 1.0000000;
    SkelMesh.SetBlockRigidBody(true);
    SkelMesh.WakeRigidBody();
    SkelMesh.SetRBPosition(Loc);
    SkelMesh.SetRBRotation(Rot);
    NewAngularVelocity.X = RandRange(-spinRate, spinRate);
    NewAngularVelocity.Y = RandRange(-spinRate, spinRate);
    NewAngularVelocity.Z = RandRange(-spinRate, spinRate);
    SkelMesh.SetRBAngularVelocity(NewAngularVelocity, false);
    SkelMesh.SetRBLinearVelocity((Direction * float(GetStartingVelocity())) + ExtraVelocity, false);
    PlaySound(ThrowSound);
    SetFearItem(Location, InstigatorController);
    SkelMesh.SetLightEnvironment(LightEnv);
    super.launch(Loc, Rot, Direction, ExtraVelocity, spinRate);
    //return;    
}

function int GetStartingVelocity()
{
    local SkyPawnCoverUser SPCU;

    SPCU = SkyPawnCoverUser(Owner.Owner);
    // End:0x14A
    if(SPCU != none)
    {
        // End:0x4F
        if(int(SPCU.GetCoverState()) == int(0))
        {
            return int(StartingVelocity);            
        }
        else
        {
            // End:0xBA
            if(int(SPCU.GetCoverType()) == int(1))
            {
                // End:0x92
                if(int(SPCU.GetPositionInCover()) == int(2))
                {
                    return StandingCoverRightStartingVelocity;                    
                }
                else
                {
                    // End:0xB7
                    if(int(SPCU.GetPositionInCover()) == int(1))
                    {
                        return StandingCoverLeftStartingVelocity;
                    }
                }                
            }
            else
            {
                // End:0x14A
                if(int(SPCU.GetCoverType()) == int(2))
                {
                    // End:0xFD
                    if(int(SPCU.GetPositionInCover()) == int(0))
                    {
                        return LowCoverCenterStartingVelocity;                        
                    }
                    else
                    {
                        // End:0x125
                        if(int(SPCU.GetPositionInCover()) == int(2))
                        {
                            return LowCoverRightStartingVelocity;                            
                        }
                        else
                        {
                            // End:0x14A
                            if(int(SPCU.GetPositionInCover()) == int(1))
                            {
                                return LowCoverLeftStartingVelocity;
                            }
                        }
                    }
                }
            }
        }
    }
    return int(StartingVelocity);
    //return ReturnValue;    
}

function SetFearItem(Vector TargetLoc, Controller InInstigator)
{
    // End:0x4C
    if(SkyGame(WorldInfo.Game) != none)
    {
        StimulusID = SkyGame(WorldInfo.Game).StimulusSystem.AddStimulus(0, self);
    }
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x1F
    if(bLaunched)
    {
        HitWall(HitNormal, Other, none);
    }
    //return;    
}

// Export USkyProj_SecondaryItemBase::execHitWall(FFrame&, void* const)
native simulated function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp, optional int Item);
