class SkyProj_ProximityMine extends SkyProj_SecondaryItemBase
    native;

enum EMagneticMineState
{
    EMMINE_Dormant,                 // 0
    EMMINE_Attached,                // 1
    EMMINE_Active,                  // 2
    EMMINE_AttachingPawn,           // 3
    EMMINE_AttachedPawn,            // 4
    EMMINE_MAX                      // 5
};

struct native ProxMineAttachSound
{
    var() name Material;
    var() SoundCue Sound;

    structdefaultproperties
    {
        Material="None"
        Sound=none
    }
};

struct native ProxMineAttachEffect
{
    var() name Material;
    var() ParticleSystem Effect;

    structdefaultproperties
    {
        Material="None"
        Effect=none
    }
};

var(MagneticMine) float MagneticRadius;
var(MagneticMine) array< class<SkyPawn> > AttachPawnTypes;
var(MagneticMine) float PawnAttachSpeed;
var(MagneticMine) float ActivateDelay;
var(Sounds) array<ProxMineAttachSound> AttachSounds;
var(Sounds) SoundCue ActivateSound;
var(Sounds) SoundCue PawnZipSound;
var(Effects) ParticleSystem PawnZipEffect;
var export editinline ParticleSystemComponent PawnZipPSC;
var(Effects) array<ProxMineAttachEffect> AttachEffects;
var export editinline ParticleSystemComponent AttachPSC;
var SkyPawn AttachPawn;
var float LastPawnCheck;
var SkyProj_ProximityMine.EMagneticMineState CurrentState;

simulated event PostBeginPlay()
{
    ClearTimer();
    LifeSpan = ExplodeDelay;
    //return;    
}

event SetActive()
{
    PlaySound(ActivateSound);
    CurrentState = 2;
    //return;    
}

event AttachToPawn(SkyPawn Pawn)
{
    AttachPawn = Pawn;
    PawnZipPSC.SetTemplate(PawnZipEffect);
    PlaySound(PawnZipSound);
    CurrentState = 3;
    SetPhysics(7);
    //return;    
}

event PawnReached()
{
    CurrentState = 4;
    Timer();
    //return;    
}

function SetFearItem(Vector TargetLoc, Controller InInstigator)
{
    //return;    
}

// Export USkyProj_ProximityMine::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
