class EvilPawnSoundGroup_Base extends Object
    abstract;

struct FootstepSoundInfo
{
    var name MaterialType;
    var SoundCue Sound;

    structdefaultproperties
    {
        MaterialType="None"
        Sound=none
    }
};

var SoundGroupParams SoundGroupParamArchetype;
var SoundCue DodgeSound;
var SoundCue DoubleJumpSound;
var SoundCue DefaultJumpingSound;
var SoundCue LandSound;
var SoundCue FallingDamageLandSound;
var SoundCue DyingSound;
var SoundCue HitSounds[3];
var SoundCue GibSound;
var SoundCue DrownSound;
var SoundCue GaspSound;
var array<FootstepSoundInfo> FootstepSounds;
var SoundCue DefaultFootstepSound;
var array<FootstepSoundInfo> JumpingSounds;
var array<FootstepSoundInfo> LandingSounds;
var SoundCue DefaultLandingSound;
var array<FootstepSoundInfo> CrouchingSounds;
var SoundCue DefaultCrouchingSound;
var array<FootstepSoundInfo> CrouchingEndSounds;
var SoundCue DefaultCrouchingEndSound;
var SoundCue BulletImpactSound;
var SoundCue CrushedSound;
var SoundCue BodyExplosionSound;
var SoundCue InstagibSound;

static function bool PlayFaceFXSoundFromArchetypeByChance(Pawn P, EvilTypes.ESoundSetType SoundSetType, optional bool bHearReply, optional bool bPlayOnFacialComponent = true)
{
    local EvilSoundSetNoiseInfo SoundSetNoiseInfo;
    local int SoundSetSoundIndex, SoundSetInfoGroupIndex;
    local bool bSoundPlayed;

    SoundSetSoundIndex = Class'SoundGroupParams'.static.GetRandomSoundByChance(default.SoundGroupParamArchetype, SoundSetType, bHearReply, SoundSetInfoGroupIndex, SoundSetNoiseInfo);
    // End:0x190
    if(SoundSetSoundIndex > -1)
    {
        // End:0x108
        if(bHearReply)
        {
            bSoundPlayed = PlayFaceFXSoundFromSoundSetInfo(P, SoundSetType, bHearReply, default.SoundGroupParamArchetype.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo, SoundSetSoundIndex, SoundSetNoiseInfo, bPlayOnFacialComponent);            
        }
        else
        {
            bSoundPlayed = PlayFaceFXSoundFromSoundSetInfo(P, SoundSetType, bHearReply, default.SoundGroupParamArchetype.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo, SoundSetSoundIndex, SoundSetNoiseInfo, bPlayOnFacialComponent);
        }
    }
    // End:0x215
    if(bSoundPlayed)
    {
        Class'SoundGroupParams'.static.SetLastPlayTime(default.SoundGroupParamArchetype, bHearReply, SoundSetInfoGroupIndex, SoundSetSoundIndex, Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds);
    }
    return bSoundPlayed;
    //return ReturnValue;    
}

static function bool PlayFaceFXSoundFromSoundSetInfo(Pawn P, EvilTypes.ESoundSetType SoundSetType, bool bHearReply, EvilSoundSetInfo SoundSetInfo, int SoundSetSoundIndex, out EvilSoundSetNoiseInfo SoundSetNoiseInfo, optional bool bPlayOnFacialComponent = true)
{
    local SoundCue SoundCue;
    local bool bSoundPlayed;
    local EvilPawn EP;

    EP = EvilPawn(P);
    SoundCue = SoundSetInfo.SoundInfoList[SoundSetSoundIndex].SoundCue;
    // End:0x126
    if(EP != none)
    {
        // End:0xB7
        if(bPlayOnFacialComponent)
        {
            bSoundPlayed = EP.PlayOnFacialComponent(SoundCue);            
        }
        else
        {
            EP.PlaySound(SoundCue);
            bSoundPlayed = true;
        }
        // End:0x126
        if(bSoundPlayed)
        {
            EP.SetFacialComponentSoundSetType(SoundSetType);
        }
    }
    return bSoundPlayed;
    //return ReturnValue;    
}

static function float GetSoundSetInterval(EvilTypes.ESoundSetType SoundSetType, optional bool bHearReply)
{
    local int SoundSetInfoGroupIndex;
    local float SoundSetInterval;

    SoundSetInfoGroupIndex = Class'SoundGroupParams'.static.GetSoundSetInfoGroupIndex(default.SoundGroupParamArchetype, SoundSetType);
    // End:0x94
    if(SoundSetInfoGroupIndex > -1)
    {
        SoundSetInterval = Class'SoundGroupParams'.static.GetSoundSetInterval(default.SoundGroupParamArchetype, bHearReply, SoundSetInfoGroupIndex);
    }
    return SoundSetInterval;
    //return ReturnValue;    
}

static function bool GetSoundSetNoiseInfo(Pawn P, EvilTypes.ESoundSetType SoundSetType, optional bool bHearReply, optional out EvilSoundSetNoiseInfo SoundSetNoiseInfo)
{
    local int SoundSetInfoGroupIndex;

    SoundSetInfoGroupIndex = Class'SoundGroupParams'.static.GetSoundSetInfoGroupIndex(default.SoundGroupParamArchetype, SoundSetType);
    // End:0x97
    if(SoundSetInfoGroupIndex > -1)
    {
        SoundSetNoiseInfo = Class'SoundGroupParams'.static.GetSoundSetNoiseInfo(default.SoundGroupParamArchetype, bHearReply, SoundSetInfoGroupIndex);
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function int GetMaxConcurrentPlayCount(EvilTypes.ESoundSetType SoundSetType, optional bool bHearReply)
{
    local int SoundSetInfoGroupIndex, MaxConcurrentPlayCount;

    SoundSetInfoGroupIndex = Class'SoundGroupParams'.static.GetSoundSetInfoGroupIndex(default.SoundGroupParamArchetype, SoundSetType);
    // End:0x112
    if(SoundSetInfoGroupIndex > -1)
    {
        // End:0xB7
        if(bHearReply)
        {
            MaxConcurrentPlayCount = default.SoundGroupParamArchetype.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.MaxConcurrentPlayCount;            
        }
        else
        {
            MaxConcurrentPlayCount = default.SoundGroupParamArchetype.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.MaxConcurrentPlayCount;
        }        
    }
    else
    {
        MaxConcurrentPlayCount = -1;
    }
    return MaxConcurrentPlayCount;
    //return ReturnValue;    
}

static function float GetLastPlayedSoundTime(EvilTypes.ESoundSetType SoundSetType, optional bool bHearReply)
{
    local int SoundSetInfoGroupIndex, I;
    local float LastPlayedSoundTime, TempPlayedSoundTime;

    SoundSetInfoGroupIndex = Class'SoundGroupParams'.static.GetSoundSetInfoGroupIndex(default.SoundGroupParamArchetype, SoundSetType);
    // End:0x12D
    if(SoundSetInfoGroupIndex > -1)
    {
        I = 0;
        J0x5A:

        // End:0x12A [Loop If]
        if(I < Class'SoundGroupParams'.static.GetSoundInfoListLength(default.SoundGroupParamArchetype, bHearReply, SoundSetInfoGroupIndex))
        {
            TempPlayedSoundTime = Class'SoundGroupParams'.static.GetLastPlayTime(default.SoundGroupParamArchetype, bHearReply, SoundSetInfoGroupIndex, I);
            // End:0x11C
            if(LastPlayedSoundTime < TempPlayedSoundTime)
            {
                LastPlayedSoundTime = TempPlayedSoundTime;
            }
            I++;
            // [Loop Continue]
            goto J0x5A;
        }        
    }
    else
    {
        LastPlayedSoundTime = -1.0000000;
    }
    return LastPlayedSoundTime;
    //return ReturnValue;    
}

static function int GetActualConcurrentPlayCount(EvilTypes.ESoundSetType SoundSetType, optional bool bHearReply)
{
    local int SoundSetInfoGroupIndex, ActualPlayCount, I;

    SoundSetInfoGroupIndex = Class'SoundGroupParams'.static.GetSoundSetInfoGroupIndex(default.SoundGroupParamArchetype, SoundSetType);
    // End:0x118
    if(SoundSetInfoGroupIndex > -1)
    {
        I = 0;
        J0x5A:

        // End:0x115 [Loop If]
        if(I < Class'SoundGroupParams'.static.GetSoundInfoListLength(default.SoundGroupParamArchetype, bHearReply, SoundSetInfoGroupIndex))
        {
            ActualPlayCount += Class'SoundGroupParams'.static.GetSoundCue(default.SoundGroupParamArchetype, bHearReply, SoundSetInfoGroupIndex, I).CurrentPlayCount;
            I++;
            // [Loop Continue]
            goto J0x5A;
        }        
    }
    else
    {
        ActualPlayCount = -1;
    }
    return ActualPlayCount;
    //return ReturnValue;    
}

static function PlayInstagibSound(Pawn P)
{
    P.PlaySound(default.InstagibSound, false, true);
    //return;    
}

static function PlayBulletImpact(Pawn P)
{
    P.PlaySound(default.BulletImpactSound, false, true);
    //return;    
}

static function PlayCrushedSound(Pawn P)
{
    P.PlaySound(default.CrushedSound, false, true);
    //return;    
}

static function PlayBodyExplosion(Pawn P)
{
    P.PlaySound(default.CrushedSound, false, true);
    //return;    
}

static function PlayDodgeSound(Pawn P)
{
    P.PlaySound(default.DodgeSound, false, true);
    //return;    
}

static function PlayDoubleJumpSound(Pawn P)
{
    P.PlaySound(default.DoubleJumpSound, false, true);
    //return;    
}

static function PlayJumpSound(Pawn P)
{
    P.PlaySound(default.DefaultJumpingSound, false, true);
    //return;    
}

static function PlayLandSound(Pawn P)
{
    // End:0x3C
    if(default.LandSound != none)
    {
        P.PlaySound(default.LandSound, false, true);
    }
    //return;    
}

static function PlayFallingDamageLandSound(Pawn P)
{
    // End:0x3C
    if(default.FallingDamageLandSound != none)
    {
        P.PlaySound(default.FallingDamageLandSound, false, true);
    }
    //return;    
}

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
    local int I;

    I = default.FootstepSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? default.DefaultFootstepSound : default.FootstepSounds[I].Sound);
    //return ReturnValue;    
}

static function SoundCue GetJumpSound(name MaterialType)
{
    local int I;

    I = default.JumpingSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? default.DefaultJumpingSound : default.JumpingSounds[I].Sound);
    //return ReturnValue;    
}

static function SoundCue GetLandSound(name MaterialType)
{
    local int I;

    I = default.LandingSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? default.DefaultLandingSound : default.LandingSounds[I].Sound);
    //return ReturnValue;    
}

static function SoundCue GetCrouchSound(name MaterialType)
{
    local int I;

    I = default.CrouchingSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? default.DefaultCrouchingSound : default.CrouchingSounds[I].Sound);
    //return ReturnValue;    
}

static function SoundCue GetCrouchEndSound(name MaterialType)
{
    local int I;

    I = default.CrouchingEndSounds.Find('MaterialType', MaterialType);
    return (((I == -1) || MaterialType == 'None') ? default.DefaultCrouchingEndSound : default.CrouchingEndSounds[I].Sound);
    //return ReturnValue;    
}

static function PlayDyingSound(Pawn P)
{
    // End:0x58
    if(!PlayFaceFXSoundFromArchetypeByChance(P, 3))
    {
        // End:0x58
        if(default.DyingSound != none)
        {
            P.PlaySound(default.DyingSound);
        }
    }
    //return;    
}

static function bool PlayTakeHitSound(Pawn P, int Damage, class<DamageType> DamageType)
{
    local int HitSoundIndex;

    // End:0xFD
    if(!PlayFaceFXSoundFromArchetypeByChance(P, 1))
    {
        // End:0xFA
        if(default.HitSounds[HitSoundIndex] != none)
        {
            // End:0xA2
            if(float(P.Health) > (0.5000000 * float(P.HealthMax)))
            {
                HitSoundIndex = ((Damage < 20) ? 0 : 1);                
            }
            else
            {
                HitSoundIndex = ((Damage < 20) ? 1 : 2);
            }
            P.PlaySound(default.HitSounds[HitSoundIndex]);
            return true;
        }        
    }
    else
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function bool PlayTakeFireHitSound(Pawn P, int Damage)
{
    return PlayFaceFXSoundFromArchetypeByChance(P, 2);
    //return ReturnValue;    
}

static function bool PlayShootAttackVoice(Pawn P)
{
    return PlayFaceFXSoundFromArchetypeByChance(P, 7);
    //return ReturnValue;    
}

static function bool PlayAttackAmbient(Pawn P)
{
    return PlayFaceFXSoundFromArchetypeByChance(P, 13);
    //return ReturnValue;    
}

static function bool PlayMeleeAttackVoice(Pawn P)
{
    return PlayFaceFXSoundFromArchetypeByChance(P, 6);
    //return ReturnValue;    
}

static function PlayGibSound(Pawn P)
{
    P.PlaySound(default.GibSound, true);
    //return;    
}

static function PlayGaspSound(Pawn P)
{
    P.PlaySound(default.GaspSound, true);
    //return;    
}

static function PlayDrownSound(Pawn P)
{
    P.PlaySound(default.DrownSound, true);
    //return;    
}
