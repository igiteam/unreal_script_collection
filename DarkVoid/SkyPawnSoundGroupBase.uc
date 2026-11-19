class SkyPawnSoundGroupBase extends Object
    abstract
    native;

struct native FootstepSoundInfo
{
    var() name MaterialType;
    var() SoundCue Sound;

    structdefaultproperties
    {
        MaterialType="None"
        Sound=none
    }
};

var() SoundCue DodgeSound;
var() SoundCue DoubleJumpSound;
var() SoundCue DefaultJumpingSound;
var() SoundCue LandSound;
var() SoundCue FallingDamageLandSound;
var() SoundCue DyingSound;
var() SoundCue HitSounds[3];
var() SoundCue GibSound;
var() array<FootstepSoundInfo> FootstepSounds;
var() SoundCue DefaultFootstepSound;
var() array<FootstepSoundInfo> ShallowWaterFootstepSounds;
var() SoundCue DefaultShallowWaterFootstepSound;
var() array<FootstepSoundInfo> DeepWaterFootstepSounds;
var() SoundCue DefaultDeepWaterFootstepSound;
var() array<FootstepSoundInfo> JumpingSounds;
var() array<FootstepSoundInfo> LandingSounds;
var() SoundCue DefaultLandingSound;
var() SoundCue BulletImpactSound;
var() SoundCue CrushedSound;
var() SoundCue BodyExplosionSound;
var() SoundCue InstagibSound;

function PlayInstagibSound(Pawn P)
{
    P.PlaySound(InstagibSound, false, true);
    //return;    
}

function PlayBulletImpact(Pawn P)
{
    P.PlaySound(BulletImpactSound, false, true);
    //return;    
}

function PlayCrushedSound(Pawn P)
{
    P.PlaySound(CrushedSound, false, true);
    //return;    
}

function PlayBodyExplosion(Pawn P)
{
    P.PlaySound(CrushedSound, false, true);
    //return;    
}

function PlayDodgeSound(Pawn P)
{
    P.PlaySound(DodgeSound, false, true);
    //return;    
}

function PlayDoubleJumpSound(Pawn P)
{
    P.PlaySound(DoubleJumpSound, false, true);
    //return;    
}

function PlayJumpSound(Pawn P)
{
    P.PlaySound(DefaultJumpingSound, false, true);
    //return;    
}

function PlayLandSound(Pawn P)
{
    P.PlaySound(LandSound, false, true);
    //return;    
}

function PlayFallingDamageLandSound(Pawn P)
{
    P.PlaySound(FallingDamageLandSound, false, true);
    //return;    
}

function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
    local int I;

    I = FootstepSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? DefaultFootstepSound : FootstepSounds[I].Sound);
    //return ReturnValue;    
}

function SoundCue GetShallowWaterFootstepSound(int FootDown, name MaterialType)
{
    local int I;

    I = ShallowWaterFootstepSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? DefaultShallowWaterFootstepSound : ShallowWaterFootstepSounds[I].Sound);
    //return ReturnValue;    
}

function SoundCue GetDeepWaterFootstepSound(int FootDown, name MaterialType)
{
    local int I;

    I = DeepWaterFootstepSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? DefaultShallowWaterFootstepSound : DeepWaterFootstepSounds[I].Sound);
    //return ReturnValue;    
}

function SoundCue GetJumpSound(name MaterialType)
{
    local int I;

    I = JumpingSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? DefaultJumpingSound : JumpingSounds[I].Sound);
    //return ReturnValue;    
}

function SoundCue GetLandSound(name MaterialType)
{
    local int I;

    I = LandingSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? DefaultLandingSound : LandingSounds[I].Sound);
    //return ReturnValue;    
}

function PlayDyingSound(Pawn P)
{
    P.PlaySound(DyingSound);
    //return;    
}

// Export USkyPawnSoundGroupBase::execPlayTakeHitSound(FFrame&, void* const)
native function PlayTakeHitSound(Pawn P, int Damage);

function PlayGibSound(Pawn P)
{
    P.PlaySound(GibSound, true);
    //return;    
}
