class SkyPawnSoundGroup extends SkyPawnSoundGroupBase
    native;

enum EBoneImpactType
{
    BONEIMPACT_None,                // 0
    BONEIMPACT_UpperTorso,          // 1
    BONEIMPACT_ArmsLegs,            // 2
    BONEIMPACT_MAX                  // 3
};

struct native SoundInfoGroup
{
    var() name MaterialType;
    var() SoundCue Sound;

    structdefaultproperties
    {
        MaterialType="None"
        Sound=none
    }
};

struct native GruntSoundInfo
{
    var() SoundCue Sound;
    var() float MinSpeed;

    structdefaultproperties
    {
        Sound=none
        MinSpeed=0.0000000
    }
};

struct native PawnImpactSoundInfo
{
    var() SoundCue Sound;
    var() ParticleSystem Effect;
    var() float MinSpeed;
    var() float MinRepeat;
    var() name Material;
    var() SkyPawnSoundGroup.EBoneImpactType Bone;

    structdefaultproperties
    {
        Sound=none
        Effect=none
        MinSpeed=500.0000000
        MinRepeat=0.7500000
        Material="None"
        Bone=BONEIMPACT_None
    }
};

struct native PawnContextSound
{
    var() SoundCue Sound;
    var() name ContextType;

    structdefaultproperties
    {
        Sound=none
        ContextType="None"
    }
};

struct native SoundGroupEvent
{
    var() SoundCue Sound;
    var() name EventName;

    structdefaultproperties
    {
        Sound=none
        EventName="None"
    }
};

var() array<PawnContextSound> GrabSound;
var() array<PawnContextSound> ShortMove;
var() array<PawnContextSound> ShortMoveHeavy;
var() array<PawnContextSound> LongMove;
var() array<PawnContextSound> LongMoveHeavy;
var() array<PawnContextSound> LegHit;
var() array<PawnContextSound> FootShuffle;
var() array<PawnContextSound> BodyDrag;
var() array<PawnContextSound> VoxBalance;
var() array<PawnContextSound> VoxDeath;
var() array<PawnContextSound> VoxExert;
var() array<PawnContextSound> VoxFall;
var() array<PawnContextSound> VoxHurtLt;
var() array<PawnContextSound> VoxHurtMed;
var() array<PawnContextSound> VoxHirtHigh;
var() array<PawnContextSound> VoxJump;
var() array<PawnContextSound> VoxLand;
var() array<PawnContextSound> VoxStartle;
var() array<PawnContextSound> VoxStruggle;
var() array<PawnContextSound> VoxDangleStartle;
var() array<PawnContextSound> VoxGrenadeThrow;
var() array<PawnContextSound> VoxHijackingUFO;
var() array<PawnContextSound> VoxReloading;
var() array<PawnContextSound> VoxSwitchingWeapons;
var() array<PawnContextSound> VoxEnemyDown;
var() array<PawnContextSound> VoxEnemyDownFlight;
var() array<PawnContextSound> VoxIncomingGrenade;
var() array<PawnContextSound> VoxTaunts;
var() array<PawnContextSound> Vox1;
var() array<PawnContextSound> Vox2;
var() array<PawnContextSound> Vox3;
var() array<PawnContextSound> Vox4;
var() array<PawnContextSound> Vox5;
var() array<PawnContextSound> BodyFall;
var() array<GruntSoundInfo> LandGruntSounds;
var(DeathImpact) array<PawnImpactSoundInfo> DeathImpactSounds;
var(DeathImpact) array<name> UpperTorsoBones;
var(DeathImpact) array<name> ArmsLegsBones;
var() array<SoundInfoGroup> LandImpactSounds;
var() SoundCue DefaultGruntSound;
var() SoundCue DefaultLandSound;
var() SoundCue StartSprintSound;
var() SoundCue StopSprintSound;
var() SoundCue SprintingSound;
var() SoundCue BreathingSound;
var() SoundCue HeavyBreathingSound;
var() float HeavyBreathingDelay;
var() float BreathingFadeoutTime;
var() SoundCue DeathFadeSound;
var() SoundCue DeathScreamSound;
var() float ChanceToPlayFallingScream;
var() float VelocityToPlayFallingScream;
var() SoundCue HeartbeatSound;
var(AdditionalVO) SoundCue VO_ShotAtClose;
var(AdditionalVO) SoundCue VO_GettingHit;
var(AdditionalVO) SoundCue VO_NoAmmo;
var(AdditionalVO) SoundCue VO_FoundJournalEntry;
var(AdditionalVO) SoundCue VO_FoundTechPointCache;
var(AdditionalVO) SoundCue VO_FoundGun;
var(AdditionalVO) SoundCue VO_SwitchGun;
var(AdditionalVO) SoundCue VO_KilledEnemy;
var(AdditionalVO) SoundCue VO_KilledEnemyFlight;
var(AdditionalVO) SoundCue VO_NearDeath;
var(AdditionalVO) SoundCue VO_GrenadeNearby;
var(AdditionalVO) SoundCue VO_RocketPackCloseCall;
var(AdditionalVO) float GrenadeNearbyDistance;
var(AdditionalVO) float KilledEnemy_DelayMin;
var(AdditionalVO) float KilledEnemy_DelayMax;
var(AdditionalVO) float GlobalVODelay;
var(SoundEvent) array<SoundGroupEvent> SoundEvents;

// Export USkyPawnSoundGroup::execGetSoundCueByProperty(FFrame&, void* const)
native function SoundCue GetSoundCueByProperty(name PropertyName, SkyPawn Pawn);

// Export USkyPawnSoundGroup::execValidBone(FFrame&, void* const)
native function bool ValidBone(name BoneName, SkyPawnSoundGroup.EBoneImpactType Type);

event SoundCue GetSoundEvent(name EventName)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x58 [Loop If]
    if(I < SoundEvents.Length)
    {
        // End:0x4E
        if(SoundEvents[I].EventName == EventName)
        {
            return SoundEvents[I].Sound;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return ReturnValue;    
}

event PlayDeathFadeSound(Pawn P)
{
    P.PlaySound(DeathFadeSound, false, true);
    //return;    
}

function PlayStartSprintSound(Pawn P)
{
    P.PlaySound(StartSprintSound, false, true);
    //return;    
}

function PlayStopSprintSound(Pawn P)
{
    P.PlaySound(StopSprintSound, false, true);
    //return;    
}

event PlayBreathingSound(Pawn P)
{
    // End:0x25
    if(BreathingSound != none)
    {
        P.PlaySound(BreathingSound, false, true);
    }
    //return;    
}

function SoundCue GetLandSound(name MaterialType)
{
    local int I;

    I = LandImpactSounds.Find('MaterialType', MaterialType);
    // End:0x34
    if(I == -1)
    {
        return DefaultLandSound;        
    }
    else
    {
        return LandImpactSounds[I].Sound;
    }
    //return ReturnValue;    
}

function SoundCue GetGruntSound(float ImpactSpeed)
{
    local int I;

    I = LandGruntSounds.Length - 1;
    J0x0F:

    // End:0x5B [Loop If]
    if(I >= 0)
    {
        // End:0x51
        if(ImpactSpeed > LandGruntSounds[I].MinSpeed)
        {
            return LandGruntSounds[I].Sound;
        }
        --I;
        // [Loop Continue]
        goto J0x0F;
    }
    return DefaultGruntSound;
    //return ReturnValue;    
}

event PlayLandSounds(Pawn P, float ImpactSpeed, name MaterialType)
{
    P.PlaySound(GetGruntSound(ImpactSpeed), false, true);
    P.PlaySound(GetLandSound(MaterialType), false, true);
    //return;    
}

simulated function PlayKilledEnemyDelayed(SkyPawn Owner, bool bEnemyOnGround)
{
    local float delay;

    delay = RandRange(KilledEnemy_DelayMin, KilledEnemy_DelayMax);
    // End:0x37
    if(bEnemyOnGround)
    {
        Owner.CachedKilledEnemyVO = VO_KilledEnemy;        
    }
    else
    {
        Owner.CachedKilledEnemyVO = VO_KilledEnemyFlight;
    }
    Owner.SetTimer(delay, false, 'PlayCachedKilledEnemyVO');
    //return;    
}
