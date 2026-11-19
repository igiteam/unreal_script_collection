class CCChannelAudio extends CCChannel
    native
    editinlinenew
    hidecategories(Object,Object);

const CC_VOICEID_COUNT = 9;

enum ENationality
{
    CC_NATIONALITY_NONE,            // 0
    CC_NATIONALITY_USA,             // 1
    CC_NATIONALITY_ENGLAND,         // 2
    CC_NATIONALITY_GERMANY,         // 3
    CC_NATIONALITY_ITALY,           // 4
    CC_NATIONALITY_HEER_INFANTRY_EUROPE,// 5
    CC_NATIONALITY_HEER_INFANTRY_TROPICAL,// 6
    CC_NATIONALITY_HEER_OFFICER,    // 7
    CC_NATIONALITY_WAFFEN_SS_INFANTRY,// 8
    CC_NATIONALITY_WAFFEN_SS_OFFICER,// 9
    CC_NATIONALITY_PANZERGRENADIER, // 10
    CC_NATIONALITY_FALLSHIRMJAGER,  // 11
    CC_NATIONALITY_BANE,            // 12
    _CC_NATIONALITY_COUNT,          // 13
    ENationality_MAX                // 14
};

enum EVocalState
{
    CC_VOCALSTATE_CAUTIOUS,         // 0
    CC_VOCALSTATE_ALERT,            // 1
    CC_VOCALSTATE_WOUNDED,          // 2
    _CC_VOCALSTATE_COUNT,           // 3
    EVocalState_MAX                 // 4
};

enum EProximityPolicy
{
    CC_PROXIMITYPOLICY_ALWAYS,      // 0
    CC_PROXIMITYPOLICY_CLOSEST_TO_PLAYER,// 1
    CC_PROXIMITYPOLICY_CLOSEST_TO_STIMULUS,// 2
    CC_PROXIMITYPOLICY_MAX          // 3
};

enum EVoicePolicy
{
    CC_VOICEPOLICY_ALWAYS,          // 0
    CC_VOICEPOLICY_ODD_IDS_ONLY,    // 1
    CC_VOICEPOLICY_MAX              // 2
};

struct native CCAudioPerformanceRequest
{
    var bool bEnabled;
    var int NIndex;
    var int VIndex;
    var int OIndex;
    var int AIndex;
    var float Dist2;

    structdefaultproperties
    {
        bEnabled=false
        NIndex=-1
        VIndex=-1
        OIndex=-1
        AIndex=-1
        Dist2=0.0000000
    }
};

struct native CCAudioChannelAlternate
{
    var() float ProbabilityWeight;
    var() export editinline array<export editinline CCKeyAudio> keys;
    var transient string AudioPerformanceID;
    var transient bool bIDValid;
    var transient bool bHasKeys;
    var transient bool bKeysValidated;
    var transient float ChannelDuration_sec;

    structdefaultproperties
    {
        ProbabilityWeight=1.0000000
        keys=none
        AudioPerformanceID=""
        bIDValid=false
        bHasKeys=false
        bKeysValidated=false
        ChannelDuration_sec=0.0000000
    }
};

struct native CCAudioChannelForVoiceID
{
    var() export editinline array<export editinline CCAudioChannelAlternate> Alternates;

    structdefaultproperties
    {
        Alternates=none
    }
};

struct native CCAudioChannelForVocalState
{
    var() CCAudioChannelForVoiceID VoiceID[9];
    var() CCChannelAudio.EVocalState VocalState;

    structdefaultproperties
    {
        VoiceID[0]=(Alternates=none)
        VoiceID[1]=(Alternates=none)
        VoiceID[2]=(Alternates=none)
        VoiceID[3]=(Alternates=none)
        VoiceID[4]=(Alternates=none)
        VoiceID[5]=(Alternates=none)
        VoiceID[6]=(Alternates=none)
        VoiceID[7]=(Alternates=none)
        VoiceID[8]=(Alternates=none)
        VocalState=0
    }
};

struct native CCAudioChannelForNationality
{
    var() export editinline array<export editinline CCAudioChannelForVocalState> VocalStates;
    var() CCChannelAudio.ENationality Nationality;

    structdefaultproperties
    {
        VocalStates=none
        Nationality=1
    }
};

var(AudioChannel) int MaxSimulResponses;
var(AudioChannel) CCChannelAudio.EProximityPolicy ProximityPolicy;
var(AudioChannel) CCChannelAudio.EVoicePolicy VoicePolicy;
var(AudioChannel) CCHistory.EAgeAttenuationFunction AgeAttenuationFunc;
var const CCChannelAudio.EVocalState VocalStateSearchOrder[6];
var(AudioChannel) float AgeAttenuationMin_sec;
var(AudioChannel) float AgeAttenuationMax_sec;
var(AudioChannel) bool bGhostAudio;
var(AudioChannel) export editinline array<export editinline CCAudioChannelForNationality> Nationalities;

static event int VoiceID2Index(int VoiceID)
{
    return VoiceID - 1;
    //return ReturnValue;    
}

static event int Index2VoiceID(int OIndex)
{
    return OIndex + 1;
    //return ReturnValue;    
}

// Export UCCChannelAudio::execIsEmpty(FFrame&, void* const)
native function bool IsEmpty();

// Export UCCChannelAudio::execFindAudioChannelCoord(FFrame&, void* const)
native function bool FindAudioChannelCoord(out CCAudioPerformanceRequest APR, CCChannelAudio.ENationality Nationality, int VoiceID, CCChannelAudio.EVocalState VocalState);

// Export UCCChannelAudio::execGetAudioPerformanceID(FFrame&, void* const)
native function bool GetAudioPerformanceID(CCAudioPerformanceRequest APR, out string AudioPerformanceID);

function bool GetKeys(out array<CCKey> OutKeys, out float OutChannelDuration_sec)
{
    return false;
    //return ReturnValue;    
}

function bool GetAudioKeys(CCAudioPerformanceRequest APR, out array<CCKey> keys, out float OutChannelDuration_sec)
{
    // End:0x377
    if(APR.bEnabled)
    {
        // End:0x377
        if((APR.NIndex >= 0) && APR.NIndex < Nationalities.Length)
        {
            // End:0x377
            if((APR.VIndex >= 0) && APR.VIndex < Nationalities[APR.NIndex].VocalStates.Length)
            {
                // End:0x377
                if((APR.OIndex >= 0) && APR.OIndex < 9)
                {
                    // End:0x377
                    if((APR.AIndex >= 0) && APR.AIndex < Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates.Length)
                    {
                        // End:0x28F
                        if(!Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates[APR.AIndex].bKeysValidated)
                        {
                            Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates[APR.AIndex].ChannelDuration_sec = ValidateKeys(Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates[APR.AIndex].keys);
                        }
                        keys = Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates[APR.AIndex].keys;
                        OutChannelDuration_sec = Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates[APR.AIndex].ChannelDuration_sec;
                        return true;
                    }
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function float GetAgeAttenuationFactor(float Age_sec)
{
    return Class'CCHistory'.static.CalculateAgeAttenuationFactor(Age_sec, AgeAttenuationFunc, AgeAttenuationMin_sec, AgeAttenuationMax_sec);
    //return ReturnValue;    
}

function bool IsAudioBankForVoiceIDLoaded(CCAudioPerformanceRequest APR)
{
    local int KIndex;
    local CCKeyAudio Key;
    local float Duration_sec;

    // End:0x280
    if((APR.NIndex >= 0) && APR.NIndex < Nationalities.Length)
    {
        // End:0x280
        if((APR.VIndex >= 0) && APR.VIndex < Nationalities[APR.NIndex].VocalStates.Length)
        {
            // End:0x280
            if((APR.OIndex >= 0) && APR.OIndex < 9)
            {
                // End:0x280
                if((APR.AIndex >= 0) && APR.AIndex < Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates.Length)
                {
                    KIndex = 0;
                    J0x12F:

                    // End:0x27E [Loop If]
                    if(KIndex < Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates[APR.AIndex].keys.Length)
                    {
                        Key = Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[APR.OIndex].Alternates[APR.AIndex].keys[KIndex];
                        // End:0x274
                        if((none != Key) && none != Key.PrimaryCue)
                        {
                            Duration_sec = Key.PrimaryCue.GetCueDuration();
                            // End:0x274
                            if(Duration_sec > 0.0000000)
                            {
                                return true;
                            }
                        }
                        ++KIndex;
                        // [Loop Continue]
                        goto J0x12F;
                    }
                    return false;
                }
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function FindVoiceIDsWithLoadedAudioBanks(CCAudioPerformanceRequest APR, out array<int> VoiceIDs)
{
    local int OIndex, AIndex, KIndex;
    local CCKeyAudio Key;
    local float Duration_sec;
    local bool bVoiceIDIsValid;

    // End:0x266
    if((APR.NIndex >= 0) && APR.NIndex < Nationalities.Length)
    {
        // End:0x266
        if((APR.VIndex >= 0) && APR.VIndex < Nationalities[APR.NIndex].VocalStates.Length)
        {
            OIndex = 0;
            J0x83:

            // End:0x266 [Loop If]
            if(OIndex < 9)
            {
                bVoiceIDIsValid = false;
                AIndex = 0;
                J0x9E:

                // End:0x25C [Loop If]
                if(!bVoiceIDIsValid && AIndex < Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[OIndex].Alternates.Length)
                {
                    KIndex = 0;
                    J0x106:

                    // End:0x252 [Loop If]
                    if(KIndex < Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[OIndex].Alternates[AIndex].keys.Length)
                    {
                        Key = Nationalities[APR.NIndex].VocalStates[APR.VIndex].VoiceID[OIndex].Alternates[AIndex].keys[KIndex];
                        // End:0x248
                        if((none != Key) && none != Key.PrimaryCue)
                        {
                            Duration_sec = Key.PrimaryCue.GetCueDuration();
                            // End:0x248
                            if(Duration_sec > 0.0000000)
                            {
                                VoiceIDs[VoiceIDs.Length] = Index2VoiceID(OIndex);
                                bVoiceIDIsValid = true;
                                // [Explicit Break]
                                goto J0x252;
                            }
                        }
                        ++KIndex;
                        // [Loop Continue]
                        goto J0x106;
                    }
                    J0x252:

                    ++AIndex;
                    // [Loop Continue]
                    goto J0x9E;
                }
                ++OIndex;
                // [Loop Continue]
                goto J0x83;
            }
        }
    }
    //return;    
}

defaultproperties
{
    MaxSimulResponses=1
    AgeAttenuationFunc=2
    VocalStateSearchOrder[0]=1
    VocalStateSearchOrder[1]=2
    VocalStateSearchOrder[3]=2
    VocalStateSearchOrder[4]=1
    AgeAttenuationMin_sec=20.0000000
    AgeAttenuationMax_sec=45.0000000
}