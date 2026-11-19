class SPJavelinPersistent extends Projectile
    native;

enum eJavelinTargetType
{
    eJavelinTarget_None,            // 0
    eJavelinTarget_Actor,           // 1
    eJavelinTarget_ActorOffset,     // 2
    eJavelinTarget_Bone,            // 3
    eJavelinTarget_Location,        // 4
    eJavelinTarget_MAX              // 5
};

struct native JavelinTargetInfo
{
    var SPJavelinPersistent.eJavelinTargetType TargetType;
    var Actor targetActor;
    var int TargetBoneIdx;
    var Vector TargetLocation;

    structdefaultproperties
    {
        TargetType=eJavelinTarget_None
        targetActor=none
        TargetBoneIdx=0
        TargetLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var transient Pawn firedBy;
var transient JavelinTargetInfo Target;
var ImpactInfo Impact;
var float TurnRate;
var float Age;
var SPPhysicalMaterial SPPhysMat;
var(DestructComponent) const editconst export editinline SPActorDestructComponent DestructComponent;
var() export editinline SkeletalMeshComponent Mesh;

// Export USPJavelinPersistent::execSetTargetActor(FFrame&, void* const)
native function SetTargetActor(Actor theTarget);

// Export USPJavelinPersistent::execSetTargetLocation(FFrame&, void* const)
native function SetTargetLocation(Vector theTarget);

// Export USPJavelinPersistent::execSetTargetNone(FFrame&, void* const)
native function SetTargetNone();

function BulletHitSomething(Vector HitNormal, Actor HitActor, Vector HitLocation, optional TraceHitInfo HitInfo)
{
    GotoState('Death', 'Begin', true, false);
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetPhysics(6);
    //return;    
}

simulated function Destroyed()
{
    super(Actor).Destroyed();
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x13
    if(DamageType == Class'SPDamageTypeBloodTickExplosion')
    {
        return;
    }
    super(Actor).ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

auto state Waiting
{    J0x00:
    // End:0x1B [Loop If]
    if(int(Physics) != int(6))
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x00;
    }
    GotoState('Flying', 'Begin', true, false);
    stop;            
}

state Flying
{
    function Tick(float DeltaTime)
    {
        // End:0x62
        if(int(Physics) == int(6))
        {
            Age += DeltaTime;
            // End:0x40
            if(Age >= float(10))
            {
                GotoState('Death', 'Begin', true, false);
            }
            // End:0x5A
            if(Age < 0.2500000)
            {
                bBlockActors = false;                
            }
            else
            {
                bBlockActors = true;
            }
        }
        //return;        
    }

    function BulletHitSomething(Vector HitNormal, Actor HitActor, Vector HitLocation, optional TraceHitInfo HitInfo)
    {
        Impact.HitActor = HitActor;
        Impact.HitInfo = HitInfo;
        Impact.HitLocation = HitLocation;
        Impact.HitNormal = HitNormal;
        Impact.RayDir = Normal(HitLocation - Location);
        // End:0x89
        if(HitActor == firedBy)
        {
            return;
        }
        // End:0xD6
        if(((Pawn(HitActor) != none) && SPGorgonPawnPersistent(HitActor) == none) && SPBloodTickPawnPersistent(HitActor) == none)
        {
            GotoState('AttachToTarget', 'Begin', true, false);            
        }
        else
        {
            GotoState('Death', 'Begin', true, false);
        }
        //return;        
    }
Begin:

    stop;                
}

state AttachToTarget
{
    function Tick(float DeltaTime)
    {
        local Vector Momentum;

        Momentum.X = 0.0000000;
        Momentum.Y = 0.0000000;
        Momentum.Z = 0.0000000;
        // End:0x104
        if(((Impact.HitActor != none) && Pawn(Impact.HitActor) != none) && Pawn(Impact.HitActor).Health > 0)
        {
            Impact.HitActor.TakeDamageAndProcEffects(5.0000000 * DeltaTime, firedBy.Controller, Impact.HitLocation, Momentum, Class'SPDamageTypePoison', Impact.HitInfo, self);            
        }
        else
        {
            DetachJavelin();
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local Vector Momentum;

        Momentum = Impact.RayDir * float(5);
        SetPhysics(0);
        SetBase(Impact.HitActor,, SkeletalMeshComponent(Impact.HitInfo.HitComponent), Impact.HitInfo.BoneName);
        Age = 0.0000000;
        Impact.HitActor.TakeDamageAndProcEffects(5.0000000 * 0.1000000, firedBy.Controller, Impact.HitLocation, Momentum, Class'SPDamageTypeJavelin', Impact.HitInfo, self);
        //return;        
    }

    function DetachJavelin()
    {
        SetBase(none);
        SetPhysics(2);
        GotoState('Death', 'Begin', true, false);
        //return;        
    }
Begin:

    SetTimer(3.0000000, false, 'DetachJavelin');
    stop;                    
}

state Death
{Begin:

    SetBase(none);
    // End:0x2C
    if(int(Physics) == int(6))
    {
        SetPhysics(2);
        Sleep(2.0000000);
    }
    Destroy();
    stop;                    
}
