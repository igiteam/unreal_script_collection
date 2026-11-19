class SoundGroupParams extends Object;

var() array<EvilSoundSetInfoGroup> SoundSetInfoList;
var() array<EvilSoundInfo> Hit;
var() array<EvilSoundInfo> FireHit;
var() array<EvilSoundInfo> Death;
var() array<EvilSoundInfo> Scream;
var() array<EvilSoundInfo> FallDown;
var() array<EvilSoundInfo> SoundAttackVoice;

static function int GetSoundSetInfoGroupIndex(SoundGroupParams InSoundGroupParams, EvilTypes.ESoundSetType SoundSetType)
{
    local int SoundSetInfoGroupIndex, I;

    SoundSetInfoGroupIndex = -1;
    // End:0x122
    if(InSoundGroupParams != none)
    {
        I = 0;
        J0x29:

        // End:0xC7 [Loop If]
        if(I < InSoundGroupParams.SoundSetInfoList.Length)
        {
            // End:0xB9
            if(int(InSoundGroupParams.SoundSetInfoList[I].SoundSetType) == int(SoundSetType))
            {
                SoundSetInfoGroupIndex = I;
                // [Explicit Break]
                goto J0xC7;
            }
            I++;
            // [Loop Continue]
            goto J0x29;
        }
        J0xC7:

        // End:0x122
        if((SoundSetInfoGroupIndex > -1) && int(InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetType) == int(0))
        {
        }
    }
    return SoundSetInfoGroupIndex;
    //return ReturnValue;    
}

static function float GetLastPlayTime(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, int SoundSetSoundIndex, optional bool bOnylGet)
{
    local float TimeSeconds;

    TimeSeconds = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
    // End:0x13B
    if(!bOnylGet && !IsInitialized(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, SoundSetSoundIndex) || (GetLastPlayTime(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, SoundSetSoundIndex, true)) > TimeSeconds)
    {
        SetLastPlayTime(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, SoundSetSoundIndex, RandRange(0.0000000, TimeSeconds));
        SetInitialized(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, SoundSetSoundIndex, true);
    }
    // End:0x1B7
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundInfoList[SoundSetSoundIndex].LastPlayTime;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundInfoList[SoundSetSoundIndex].LastPlayTime;
    }
    //return ReturnValue;    
}

static function SetLastPlayTime(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, int SoundSetSoundIndex, float LastPlayTime)
{
    // End:0x85
    if(bHearReply)
    {
        InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundInfoList[SoundSetSoundIndex].LastPlayTime = LastPlayTime;        
    }
    else
    {
        InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundInfoList[SoundSetSoundIndex].LastPlayTime = LastPlayTime;
    }
    //return;    
}

static function int GetSoundInfoListLength(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex)
{
    // End:0x60
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundInfoList.Length;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundInfoList.Length;
    }
    //return ReturnValue;    
}

static function float GetChance(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, int SoundSetSoundIndex)
{
    // End:0x7C
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundInfoList[SoundSetSoundIndex].Chance;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundInfoList[SoundSetSoundIndex].Chance;
    }
    //return ReturnValue;    
}

static function SoundCue GetSoundCue(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, int SoundSetSoundIndex)
{
    // End:0x7C
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundInfoList[SoundSetSoundIndex].SoundCue;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundInfoList[SoundSetSoundIndex].SoundCue;
    }
    //return ReturnValue;    
}

static function float GetActualChance(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, int SoundSetSoundIndex)
{
    // End:0x7C
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundInfoList[SoundSetSoundIndex].ActualChance;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundInfoList[SoundSetSoundIndex].ActualChance;
    }
    //return ReturnValue;    
}

static function SetActualChance(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, int SoundSetSoundIndex, float ActualChance)
{
    // End:0x85
    if(bHearReply)
    {
        InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundInfoList[SoundSetSoundIndex].ActualChance = ActualChance;        
    }
    else
    {
        InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundInfoList[SoundSetSoundIndex].ActualChance = ActualChance;
    }
    //return;    
}

static function SetSoundSetInfoTotalChance(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, float TotalChance)
{
    // End:0x68
    if(bHearReply)
    {
        InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.TotalChance = TotalChance;        
    }
    else
    {
        InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.TotalChance = TotalChance;
    }
    //return;    
}

static function SetInitialized(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, int SoundSetSoundIndex, bool bInitialized)
{
    // End:0x87
    if(bHearReply)
    {
        InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundInfoList[SoundSetSoundIndex].bInitialized = bInitialized;        
    }
    else
    {
        InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundInfoList[SoundSetSoundIndex].bInitialized = bInitialized;
    }
    //return;    
}

static function bool IsInitialized(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, int SoundSetSoundIndex)
{
    // End:0x7D
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundInfoList[SoundSetSoundIndex].bInitialized;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundInfoList[SoundSetSoundIndex].bInitialized;
    }
    //return ReturnValue;    
}

static function float GetSoundSetInfoTotalChance(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex)
{
    // End:0x5F
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.TotalChance;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.TotalChance;
    }
    //return ReturnValue;    
}

static function float GetSoundSetInterval(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex)
{
    // End:0x5F
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundSetInterval;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundSetInterval;
    }
    //return ReturnValue;    
}

static function float GetSoundSetInfoInterval(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex)
{
    // End:0x5F
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.interval;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.interval;
    }
    //return ReturnValue;    
}

static function float GetSoundSetInfoChance(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex)
{
    // End:0x5F
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.Chance;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.Chance;
    }
    //return ReturnValue;    
}

static function EvilSoundSetNoiseInfo GetSoundSetNoiseInfo(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex)
{
    // End:0x5F
    if(bHearReply)
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].HearReplySoundSetInfo.SoundSetNoiseInfo;        
    }
    else
    {
        return InSoundGroupParams.SoundSetInfoList[SoundSetInfoGroupIndex].SoundSetInfo.SoundSetNoiseInfo;
    }
    //return ReturnValue;    
}

static function CheckSoundSetInfo(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex)
{
    local int I;
    local float TimeSeconds;
    local int OldestPlayTimeSoundIndex;

    TimeSeconds = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
    OldestPlayTimeSoundIndex = 0;
    // End:0x394
    if((GetSoundInfoListLength(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex)) > 0)
    {
        SetSoundSetInfoTotalChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, 0.0000000);
        I = (GetSoundInfoListLength(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex)) - 1;
        J0xD3:

        // End:0x2DD [Loop If]
        if(I >= 0)
        {
            SetActualChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, I, GetChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, I));
            // End:0x1DA
            if(((GetLastPlayTime(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, I)) + (GetSoundSetInfoInterval(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex))) > TimeSeconds)
            {
                SetActualChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, I, 0.0000000);
            }
            // End:0x252
            if((GetLastPlayTime(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, I)) < (GetLastPlayTime(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, OldestPlayTimeSoundIndex)))
            {
                OldestPlayTimeSoundIndex = I;
            }
            SetSoundSetInfoTotalChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, (GetSoundSetInfoTotalChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex)) + (GetActualChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, I)));
            I--;
            // [Loop Continue]
            goto J0xD3;
        }
        // End:0x394
        if((GetSoundSetInfoTotalChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex)) <= float(0))
        {
            SetActualChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, OldestPlayTimeSoundIndex, 1.0000000);
            SetSoundSetInfoTotalChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, GetActualChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, OldestPlayTimeSoundIndex));
        }
    }
    //return;    
}

static function int GetRandomSoundByChance(SoundGroupParams InSoundGroupParams, EvilTypes.ESoundSetType SoundSetType, bool bHearReply, out int SoundSetInfoGroupIndex, optional out EvilSoundSetNoiseInfo outSoundSetNoiseInfo)
{
    local int SoundSetSoundIndex;

    SoundSetInfoGroupIndex = GetSoundSetInfoGroupIndex(InSoundGroupParams, SoundSetType);
    // End:0x76
    if(SoundSetInfoGroupIndex > -1)
    {
        SoundSetSoundIndex = CheckRandomSoundIndexByChanceFromSoundSetInfo(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, outSoundSetNoiseInfo);        
    }
    else
    {
        SoundSetSoundIndex = -1;
    }
    return SoundSetSoundIndex;
    //return ReturnValue;    
}

static function int CheckRandomSoundIndexByChanceFromSoundSetInfo(SoundGroupParams InSoundGroupParams, bool bHearReply, int SoundSetInfoGroupIndex, optional out EvilSoundSetNoiseInfo outSoundSetNoiseInfo)
{
    local float R, T;
    local int I;

    CheckSoundSetInfo(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex);
    // End:0x19A
    if((GetSoundInfoListLength(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex)) > 0)
    {
        // End:0x197
        if(FRand() < (GetSoundSetInfoChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex)))
        {
            R = RandRange(0.0000000, GetSoundSetInfoTotalChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex));
            I = 0;
            J0xCA:

            // End:0x197 [Loop If]
            if(I < (GetSoundInfoListLength(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex)))
            {
                T += (GetActualChance(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex, I));
                // End:0x189
                if(R < T)
                {
                    outSoundSetNoiseInfo = GetSoundSetNoiseInfo(InSoundGroupParams, bHearReply, SoundSetInfoGroupIndex);
                    return I;
                }
                I++;
                // [Loop Continue]
                goto J0xCA;
            }
        }        
    }
    return -1;
    //return ReturnValue;    
}
