//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDProj_GrenadeBase extends HDProjectile
    native(HDWeapon)
    abstract;

/** Velocity is scaled by this value after each bounce */
var() protected float               VelocityDampingFactor;
/** How much grenade bounces back off wall. 1.0 = normal, 0 = slide against wall */
var() protected float               Bounciness;
/** When grenade dips below this velocity, stop simulating. */
var() protected float               StopSimulatingVelocityThreshhold;
/** Maximum number of bounces */
var() const protected int           MaxBounceCount;

/** Number of times grenade has bounced */
var protected transient int         BounceCount;

var editinline PrimitiveComponent   Mesh;

var const               bool        bUsePhysicsFlag;

var protected transient bool        bEnabledGrenadePhysics;
var protected transient bool        bEnabledGrenadeKinematics;

/** Sound of grenade bouncing on the ground. */
var protected const                 SoundCue GrenadeBounceSound;

var() float                         ExplosiveTime;

var() bool                          bAddBaseVelocity;

/** World velocity of the projectile's frame of reference at the time of firing. */
var transient repnotify vector      InitialFrameOfRefVelocity;

/** Simulate gravity */
var() const protected bool          bPerformGravity;

//
// Internal simulation variables.
//

/** Length of the fixed timestep for grenade simulation. */
var protected const float           SimFixedTimeStep;
/** Used by simulation code to run gravity on a fixed timestep. */
var protected transient const float TimeTilNextGravUpdate;
/** Used by simulation code to track mid-simulation gravity advances on collisions. */
var protected const transient float SimInternalGravityAdvanceTime;

// Light Environment
var LightEnvironmentComponent       MyLightEnvironment;

// client explosive
var bool                            bClientExplosive;

struct native BoundSoundInfo
{
    var name        MaterialType;
    var SoundCue    Sound;
};

var array<BoundSoundInfo>           GrenadeBounceSounds;

var bool                            bInit;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

static function SoundCue GetBounceSound(name MaterialType)
{
    local int i;

    i = default.GrenadeBounceSounds.Find('MaterialType', MaterialType);
    return (i == -1 || MaterialType=='') ? default.GrenadeBounceSound : default.GrenadeBounceSounds[i].Sound;
}


simulated function name GetMaterialBounce()
{
    local vector HitLocation, HitNormal, Dir;
    local TraceHitInfo HitInfo;
    local TMPhysicalMaterialProperty PhysicalProperty;
    local actor HitActor;
    local float TraceDist;

    TraceDist = 10;
    Dir = Normal(Velocity);
    HitActor = Trace(HitLocation, HitNormal, Location - TraceDist * Dir, Location + TraceDist * Dir, false,, HitInfo, TRACEFLAG_Bullet);
    if ( WaterVolume(HitActor) != None )
    {
        return 'Water';
    }
    if (HitInfo.PhysMaterial != None)
    {
        PhysicalProperty = TMPhysicalMaterialProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(class'TMPhysicalMaterialProperty'));
        if (PhysicalProperty != None)
        {
            return PhysicalProperty.MaterialType;
        }
    }
    return '';

}

//---------------------------------------------------------
//  Collision and Physics
//---------------------------------------------------------
simulated protected function EnableGrenadePhysics( bool bKinematics )
{
    local SkeletalMeshComponent SkelMeshComp;

    SkelMeshComp = SkeletalMeshComponent(Mesh);

    if (SkelMeshComp != None && bUsePhysicsFlag )
    {
        SkelMeshComp.SetHasPhysicsAssetInstance(TRUE);

        // Unfix all bodies from kinematic data.
        // So now we switch to being fully physical
        SkelMeshComp.PhysicsAssetInstance.SetAllBodiesFixed(bKinematics);

        // Wake up physics
        SkelMeshComp.WakeRigidBody();

        SkelMeshComp.PhysicsWeight = bKinematics? 0.f : 1.f;
    }
}

/**
 * Test condition to validate a rebound
 *
 * @param   Touched, actor the grenade touched
 * @param   HitNormal, normal of the surface impacted
 * @return  true if the grenade should bounce off
 */
simulated function bool ShouldBounce(Actor Touched, vector HitNormal, optional PrimitiveComponent HitComponent)
{
    if( (Touched == None) || (Base != None) )
    {
        return FALSE;
    }

    // cannot collide with instigator until it has bounced once
    // also don't allow projectiles to collide while spawning on clients
    // because if that were accurate, the projectile would've been destroyed immediately on the server
    // and therefore it wouldn't have been replicated to the client
    if ((Touched == Instigator || (Role < ROLE_Authority && !bBegunPlay)) && BounceCount == 0)
    {
        return FALSE;
    }

    if( Touched.bWorldGeometry || Touched.bBlockActors )
    {
        return TRUE;
    }

    return FALSE;
}

simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    if ( !bInit )
        return;
    HandleCollision( Other, OtherComp, HitLocation, HitNormal );
}

simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
    HandleCollision( Other, OtherComp, Location, HitNormal );
}

simulated function HitWall( vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
    HandleCollision( Wall, WallComp, Location, HitNormal );
}

simulated function HandleCollision( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    //`log(self@"** hit!"@Other@OtherComp@HitNormal@HitLocation);
    if( Other != None && ShouldBounce(Other, HitNormal) && (Physics == PHYS_Projectile || Physics == PHYS_Falling) )
    {
        // a bit of a hack, massage data for pawns
        if ( (Pawn(Other) != None) && (SkeletalMeshComponent(OtherComp) != None) )
        {
            HitNormal = HitLocation - Other.Location;
            HitNormal.Z = 0.f;
            HitNormal = Normal(HitNormal);
        }

        Bounce(HitLocation, HitNormal, Other);
    }
}

/** Stops projectile simulation without destroying it.  Projectile is resting, essentially. */
simulated protected function StopSimulating()
{
    Velocity = vect(0,0,0);
    Acceleration = vect(0,0,0);
    RotationRate = rot(0,0,0);
    SetPhysics(PHYS_None);
    SetCollision(TRUE, FALSE);

    bRotationFollowsVelocity = FALSE;
}

sync reliable function SyncStopSimulating()
{
    if ( Role != Role_Authority )
    {
        StopSimulating();
    }
}

/** Called when grenade stops bouncing and comes to rest. */
simulated function StopBounce(vector HitNormal)
{
    bBounce = FALSE;
    StopSimulating();
    if ( Role == Role_Authority )
    {
        SyncStopSimulating();
    }
}

/**
 * Reflect grenade off a wall
 *
 * @param   HitLocation
 * @param   HitNormal
 */
simulated function Bounce(Vector HitLocation, Vector HitNormal, Actor Other)
{
    local AIController C;
    local SoundCue  BounceSound;

    // If we hit a mover coming towards us, on a fairly flat bit - stick to it
    //`log("HIT"@InterpActor(Other)@(Normal(Other.Velocity) Dot HitNormal)@(HitNormal.Z >= MINFLOORZ));
    if( InterpActor(Other) != None &&
        (Normal(Other.Velocity) Dot HitNormal) > 0.4 &&
        (HitNormal.Z >= MINFLOORZ) )
    {
        if( !bEnabledGrenadePhysics )
        {
            EnableGrenadePhysics(TRUE);
            bEnabledGrenadePhysics = TRUE;
        }

        StopBounce(HitNormal);
        SetBase(Other);
        return;
    }


    if((Normal(Velocity) Dot HitNormal) > 0.4)
    {
        return;
    }
    if( !bBounce || BounceCount >= MaxBounceCount )
    {
        if( !bEnabledGrenadePhysics )
        {
            EnableGrenadePhysics(FALSE);
            bEnabledGrenadePhysics = TRUE;
        }
        StopBounce(HitNormal);
        return;
    }

    BounceCount++;

    // bounce off wall with damping
    Velocity -= (1.f + Bounciness) * HitNormal * (Velocity Dot HitNormal);
    Velocity *= VelocityDampingFactor;

    // should we stop simulating?
    if( VSize(Velocity) < StopSimulatingVelocityThreshhold )
    {
        if( !bEnabledGrenadePhysics )
        {
            EnableGrenadePhysics(FALSE);
            bEnabledGrenadePhysics = TRUE;
        }
        StopBounce(HitNormal);
    }
    else //if(GrenadeBounceSound != none)
    {
        // this will do a little jitter at the end.  We can add another velocity check to stop it
        BounceSound = GetBounceSound( GetmaterialBounce() );
        PlaySound(BounceSound);
    }

    if ( !bEnabledGrenadeKinematics )
    {
        EnableGrenadePhysics(TRUE);
        bEnabledGrenadeKinematics = TRUE;
    }


    if ( (Role == ROLE_Authority) )
    {
        // notify AI of the bounce
        foreach WorldInfo.AllControllers(class'AIController', C)
        {
            C.NotifyProjLanded( self );
        }
    }
}


/**
 * Set the initial velocity and cook time
 */
simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetTimer( ExplosiveTime, false, 'GrenadeTimer' );                  //Grenade begins unarmed

    if ( Role == Role_Authority )
        SetTimer( 0.4, True, 'GrenadeBroadcast');

    RotationRate.Pitch = 100000 * 2 *FRand() - 100000;
    RotationRate.Roll = 100000 * 2 *FRand() - 100000;
    Mesh.SetLightEnvironment(MyLightEnvironment);
}

simulated function GrenadeBroadcast()
{
    local HDPawn Victim;
    foreach OverlappingActors( class'HDPawn', Victim, DamageRadius, Location, FALSE )
    {
        if ( Victim != None )
        {
            if( HDPlayerController(Victim.Controller) != none )
            {
                HDPlayerController(Victim.Controller).ClientAddGrenadeInfo(self);
            }
        }
    }
}

simulated function DestroyedGrenadeBroadcast()
{
    local HDPawn Victim;
    foreach OverlappingActors( class'HDPawn', Victim, DamageRadius, Location, FALSE )
    {
        if ( Victim != None )
        {
            if( HDPlayerController(Victim.Controller) != none )
            {
                HDPlayerController(Victim.Controller).ClientRemoveGrenadeInfo(self);
            }
        }
    }
}

sync reliable function SyncSetInit( bool flag )
{
    bInit = flag;
}

function Init(vector Direction)
{
    //SetRotation(Rotator(Direction));

    // reset grenade
    bBounce = TRUE;
    BounceCount = 0;

    Velocity = Speed * Direction;
    Acceleration = AccelRate * Normal(Velocity);

    // tweak direction to account for motion of base
    if ( bAddBaseVelocity && (Instigator != None) && (Instigator.Base != None) && !Instigator.Base.bStatic )
    {
        // @fixme, this will not account for linear vel as a result of base rotation.
        // need to find a way to get that information.
        InitialFrameOfRefVelocity = Instigator.Base.Velocity + (Instigator.Base.AngularVelocity cross (Instigator.Location - Instigator.Base.Location));
        Velocity += InitialFrameOfRefVelocity;
//      `log("adding base vel"@InitialFrameOfRefVelocity@"to old vel"@Direction*Speed@"newvel"@Velocity);
    }
    else
    {
        InitialFrameOfRefVelocity = vect(0,0,0);
    }

    bInit = True;
    SyncSetInit(bInit);
}


/**
 * Explode
 */
simulated function GrenadeTimer()
{
    local SkeletalMeshComponent Skeletal;
    local vector HitLocation, HitNormal, StartTrace, EndTrace;
    local TraceHitInfo HitInfo;
    local RB_BodyInstance   RootBody;
    local matrix HitMatrix;
    local Actor HitActor;

    Skeletal = SkeletalMeshComponent(Mesh);
    if ( Skeletal != none )
    {
       RootBody = Skeletal.FindBodyInstanceNamed('Grenade_body');
       if ( RootBody != None )
       {
           HitMatrix = RootBody.GetUnrealWorldTM();
           StartTrace.X = HitMatrix.WPlane.X;
           StartTrace.Y = HitMatrix.WPlane.Y;
           StartTrace.Z = HitMatrix.WPlane.Z;
           EndTrace = StartTrace + 5 * vect(0,0,-1);
           HitLocation = StartTrace;
           HitNormal = vect(0,0,1);

           foreach TraceActors( class'Actor', HitActor, HitLocation, HitNormal, EndTrace, StartTrace, vect(0,0,0), HitInfo, TRACEFLAG_Bullet)
           {
               if ( HitActor == none )
               {
                  HitLocation = StartTrace;
                  HitNormal = vect(0,0,1);
               }
               else
               {
                   break;
               }
           }
       }
       else
       {
            HitLocation = Location;
            HitNormal = vect(0,0,1);
       }
       Explode(HitLocation, HitNormal);
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    bClientExplosive = True;
    Super.Explode(HitLocation, HitNormal);
}

/** ShouldSpawnExplosionLight()
Decide whether or not to create an explosion light for this explosion
*/
simulated function bool ShouldSpawnExplosionLight(vector HitLocation, vector HitNormal)
{
    local PlayerController P;
    local float Dist;

    // decide whether to spawn explosion light
    ForEach LocalPlayerControllers(class'PlayerController', P)
    {
        Dist = VSize(P.ViewTarget.Location - HitLocation);
        if ( (P.Pawn == Instigator) || (Dist < ExplosionLightClass.Default.Radius) || (Dist < MaxExplosionLightDistance) )
        {
            return true;
        }
    }
    return false;
}

simulated event Destroyed()
{
    if ( Role < Role_Authority && !bClientExplosive )
        GrenadeTimer();
    Super.Destroyed();
    ClearTimer('GrenadeBroadcast');
    DestroyedGrenadeBroadcast();
}

simulated function PhysicsVolumeChange( PhysicsVolume NewVolume )
{
    local HDWaterEffectVolume  WaterEffectVolume;
    local SoundCue             BounceSound;
    WaterEffectVolume = HDWaterEffectVolume(NewVolume);
    if ( NewVolume.bWaterVolume == True || WaterEffectVolume != none )
    {
        BounceSound = GetBounceSound( 'Water' );
        PlaySound(BounceSound);
    }

    Super.PhysicsVolumeChange(NewVolume);
}

