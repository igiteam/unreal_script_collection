class CCChannelStateAudio extends CCChannelState
    native
    hidecategories(Object,Object);

var bool bHasFaceFX;
var SoundCue Cue;
var string FaceFXGroupName;
var string FaceFXAnimName;
var CCAudioPerformanceRequest APR;

function PostBeginPlay(CCPerformanceState InPS, int TeamIndex)
{
    local editinline SkeletalMeshComponent OwnerMesh;

    super.PostBeginPlay(InPS, TeamIndex);
    // End:0x1F
    if(PS != InPS)
    {
    }
    PS.CCP.Nationality = PS.CCP.Owner_GetNationality();
    OwnerMesh = PS.CCP.Owner_GetSkeletalMeshComponent();
    // End:0x99
    if(none != OwnerMesh)
    {
        OwnerMesh.DeclareFaceFXRegister("Shouting");
    }
    //return;    
}

function float StartChannel(CCChannel Channel, float StartTime_sec)
{
    local CCChannelAudio AudioChannel;
    local float PerformanceLocalTime_sec, ChannelDuration_sec;

    // End:0x31
    if(bInProgress)
    {
        PerformanceLocalTime_sec = PS.GetPerformanceLocalTime_sec();
        StopChannel(PerformanceLocalTime_sec);
    }
    AudioChannel = CCChannelAudio(Channel);
    // End:0xE3
    if((none != AudioChannel) && AudioChannel.GetAudioKeys(APR, CurrentKeys, ChannelDuration_sec))
    {
        bInProgress = true;
        CurrentKey = -1;
        PS.CCP.GetCCDirector().AudioDirector.RegisterPerformer(PS.CCP, PS.Stimulus, AudioChannel, APR, StartTime_sec);        
    }
    else
    {
        ChannelDuration_sec = 0.0000000;
    }
    return ChannelDuration_sec;
    //return ReturnValue;    
}

function StopChannel(float PerformanceLocalTime_sec)
{
    // End:0x54
    if(bInProgress)
    {
        PS.CCP.GetCCDirector().AudioDirector.UnregisterPerformer(PS.CCP, PS.Stimulus);
    }
    super.StopChannel(PerformanceLocalTime_sec);
    //return;    
}

function float GetChannelDuration_sec(CCChannel Channel)
{
    local CCChannelAudio AudioChannel;
    local float ChannelDuration_sec;

    AudioChannel = CCChannelAudio(Channel);
    // End:0x4F
    if((none == AudioChannel) || !AudioChannel.GetAudioKeys(APR, CurrentKeys, ChannelDuration_sec))
    {
        ChannelDuration_sec = 0.0000000;
    }
    return ChannelDuration_sec;
    //return ReturnValue;    
}

function BeginKey(int KeyIndex, float PerformanceLocalTime_sec)
{
    local CCKeyAudio Key;
    local editinline SkeletalMeshComponent OwnerMesh;
    local FaceFXAsset FaceFXAsset;
    local FaceFXAnimSet FaceFXAnimSetRef;
    local int ASIndex;
    local editinline AudioComponent AudioComp;

    Key = CCKeyAudio(CurrentKeys[KeyIndex]);
    // End:0x39B
    if(none != Key)
    {
        bHasFaceFX = false;
        Cue = Key.PrimaryCue;
        // End:0x39B
        if(Cue != none)
        {
            OwnerMesh = PS.CCP.Owner_GetSkeletalMeshComponent();
            // End:0x1D3
            if((OwnerMesh != none) && OwnerMesh.SkeletalMesh.FaceFXAsset != none)
            {
                FaceFXAnimSetRef = Cue.FaceFXAnimSetRef;
                // End:0x1D3
                if(FaceFXAnimSetRef != none)
                {
                    FaceFXAsset = OwnerMesh.SkeletalMesh.FaceFXAsset;
                    ASIndex = 0;
                    J0xD7:

                    // End:0x11B [Loop If]
                    if(ASIndex < FaceFXAsset.MountedFaceFXAnimSets.Length)
                    {
                        // End:0x111
                        if(FaceFXAsset.MountedFaceFXAnimSets[ASIndex] == FaceFXAnimSetRef)
                        {
                            // [Explicit Break]
                            goto J0x11B;
                        }
                        ++ASIndex;
                        // [Loop Continue]
                        goto J0xD7;
                    }
                    J0x11B:

                    // End:0x148
                    if(ASIndex == FaceFXAsset.MountedFaceFXAnimSets.Length)
                    {
                        FaceFXAsset.MountFaceFXAnimSet(FaceFXAnimSetRef);
                    }
                    // End:0x1A3
                    if((Cue.FaceFXAnimName == "") || Cue.FaceFXGroupName == "")
                    {
                        FaceFXAnimName = string(Cue.Name);
                        FaceFXGroupName = string(FaceFXAnimSetRef.Name);                        
                    }
                    else
                    {
                        FaceFXAnimName = Cue.FaceFXAnimName;
                        FaceFXGroupName = Cue.FaceFXGroupName;
                    }
                    bHasFaceFX = true;
                }
            }
            // End:0x22C
            if((MOHAAIPawn(PS.CCP.Owner) != none) && MOHAAIPawn(PS.CCP.Owner).IsPlayingDeathYell())
            {
                bHasFaceFX = false;
            }
            // End:0x300
            if(bHasFaceFX && Class'MOHAUtilities'.static.GetAiLodIsClose(PS.CCP.Owner))
            {
                // End:0x29E
                if(Key.bShouting)
                {
                    OwnerMesh.SetFaceFXRegister("Shouting", 1.0000000, 2, 0.0000000);                    
                }
                else
                {
                    OwnerMesh.SetFaceFXRegister("Shouting", -1.0000000, 2, 0.0000000);
                }
                // End:0x300
                if(!OwnerMesh.ShouldUpdateFaceFX() || !OwnerMesh.PlayFaceFXAnim(none, FaceFXAnimName, FaceFXGroupName))
                {
                    bHasFaceFX = false;
                }
            }
            // End:0x39B
            if(!bHasFaceFX || !Class'MOHAUtilities'.static.GetAiLodIsClose(PS.CCP.Owner))
            {
                AudioComp = PS.CCP.Owner_GetFaceFXAudioComponent();
                // End:0x39B
                if(none != AudioComp)
                {
                    AudioComp.Stop();
                    AudioComp.SoundCue = Cue;
                    AudioComp.Play();
                }
            }
        }
    }
    //return;    
}

function EndKey(int KeyIndex, float PerformanceLocalTime_sec)
{
    //return;    
}

defaultproperties
{
    APR=(bEnabled=false,NIndex=-1,VIndex=-1,OIndex=-1,AIndex=-1,Dist2=0.0000000)
}