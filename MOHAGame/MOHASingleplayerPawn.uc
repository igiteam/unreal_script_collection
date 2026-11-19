class MOHASingleplayerPawn extends MOHAPlayerPawn
    config(Player)
    hidecategories(Navigation);

var export editinline array<export editinline CCPerformerGhost> GhostCCPs;
var export editinline array<export editinline AudioComponent> GhostAudioComponents;

simulated function PostBeginPlay()
{
    local int I, J, NIndex, VoiceID;
    local CCLevelInfo LI;

    super.PostBeginPlay();
    // End:0xBC
    if(GhostCCPs.Length > 0)
    {
        LI = CCDirector(GhostCCPs[0].GetCCDirector()).GetCCLevelInfo();
        // End:0xB9
        if(none != LI)
        {
            NIndex = 0;
            J0x4A:

            // End:0x99 [Loop If]
            if(NIndex < LI.NationalitySettings.Length)
            {
                // End:0x8F
                if(int(LI.NationalitySettings[NIndex].Nationality) == int(1))
                {
                    // [Explicit Break]
                    goto J0x99;
                }
                ++NIndex;
                // [Loop Continue]
                goto J0x4A;
            }
            J0x99:

            // End:0xB9
            if(NIndex == LI.NationalitySettings.Length)
            {
                LI = none;
            }
        }        
    }
    else
    {
        LI = none;
    }
    I = 0;
    J0xCA:

    // End:0x1F6 [Loop If]
    if(I < GhostCCPs.Length)
    {
        GhostCCPs[I].GhostIndex = I;
        GhostCCPs[I].PostBeginPlay(0);
        // End:0x178
        if(none != LI)
        {
            J = int(float(I) % float(LI.NationalitySettings[NIndex].ValidVoiceIDs.Length));
            VoiceID = LI.NationalitySettings[NIndex].ValidVoiceIDs[J];            
        }
        else
        {
            VoiceID = Class'CCChannelAudio'.static.Index2VoiceID(int(float(I) % float(9)));
        }
        GhostCCPs[I].Nationality = 1;
        GhostCCPs[I].bVoiceIDNeverExpires = true;
        GhostCCPs[I].SetVoiceID(VoiceID);
        ++I;
        // [Loop Continue]
        goto J0xCA;
    }
    //return;    
}

function AudioComponent GetGhostAudioComponent(int GhostIndex)
{
    // End:0x29
    if((GhostIndex >= 0) && GhostIndex < GhostAudioComponents.Length)
    {
        return GhostAudioComponents[GhostIndex];
    }
    return none;
    //return ReturnValue;    
}

function int BroadcastCCStimulusToGhostPerformers(CCStimulus Stimulus)
{
    local int I, SentToCount;

    SentToCount = 0;
    I = 0;
    J0x0E:

    // End:0x5E [Loop If]
    if(I < GhostCCPs.Length)
    {
        // End:0x54
        if(none != GhostCCPs[I])
        {
            ++SentToCount;
            GhostCCPs[I].OnStimulus(Stimulus);
        }
        ++I;
        // [Loop Continue]
        goto J0x0E;
    }
    return SentToCount;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: CCPerformerGhost'Default__MOHASingleplayerPawn.CCP0'
    begin object name=CCP0 class=Class'CCPerformerGhost'
    end object
    GhostCCPs[0]=CCP0
    // Reference: CCPerformerGhost'Default__MOHASingleplayerPawn.CCP1'
    begin object name=CCP1 class=Class'CCPerformerGhost'
    end object
    GhostCCPs[1]=CCP1
    // Reference: AudioComponent'Default__MOHASingleplayerPawn.AC0'
    begin object name=AC0 class=Class'Engine.AudioComponent'
    end object
    GhostAudioComponents[0]=AC0
    // Reference: AudioComponent'Default__MOHASingleplayerPawn.AC1'
    begin object name=AC1 class=Class'Engine.AudioComponent'
    end object
    GhostAudioComponents[1]=AC1
    // Reference: AudioComponent'Default__MOHASingleplayerPawn.ShellShockSoundComponent'
    begin object name=ShellShockSoundComponent
    end object
    ShellShockSound=ShellShockSoundComponent
    // Reference: AudioComponent'Default__MOHASingleplayerPawn.NonRealtimeAudio'
    begin object name=NonRealtimeAudio
    end object
    NonRealtimeAudio=NonRealtimeAudio
    // Reference: MOHASkeletalMeshComponent'Default__MOHASingleplayerPawn.FPMeshComponent0'
    begin object name=FPMeshComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHASingleplayerPawn.MyLightEnvironment'
    end object
    FPArms=FPMeshComponent0
    // Reference: WhizComponent'Default__MOHASingleplayerPawn.whiz'
    begin object name=whiz
    end object
    whiz=whiz
    // Reference: CylinderComponent'Default__MOHASingleplayerPawn.LeanCollisionCylinder'
    begin object name=LeanCollisionCylinder
    end object
    LeanCollisionComponent=LeanCollisionCylinder
    // Reference: AudioComponent'Default__MOHASingleplayerPawn.AirdropBGSound'
    begin object name=AirdropBGSound
    end object
    Airdrop_BG_Loop=AirdropBGSound
    // Reference: AudioComponent'Default__MOHASingleplayerPawn.AirdropWindSound'
    begin object name=AirdropWindSound
    end object
    Airdrop_WindVolumeLoop=AirdropWindSound
    // Reference: MOHASkeletalMeshComponent'Default__MOHASingleplayerPawn.clipMesh'
    begin object name=clipMesh
    end object
    ITPClipMesh=clipMesh
    // Reference: MOHAWeaponUpgradeManager'Default__MOHASingleplayerPawn.UpgradeManager'
    begin object name=UpgradeManager
    end object
    WeaponUpgradeManager=UpgradeManager
    // Reference: MOHAAirdropComponent'Default__MOHASingleplayerPawn.MyAirdropComponent'
    begin object name=MyAirdropComponent
    end object
    AirdropComponent=MyAirdropComponent
    // Reference: AxonScriptEventObserverComponent'Default__MOHASingleplayerPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHASingleplayerPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    Mesh=FPMeshComponent0
    // Reference: CylinderComponent'Default__MOHASingleplayerPawn.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHASingleplayerPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: ArrowComponent'Default__MOHASingleplayerPawn.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=MyLightEnvironment
    Components[4]=AxonObserver0
    Components[5]=FPMeshComponent0
    Components[6]=MyAirdropComponent
    Components[7]=whiz
    Components[8]=UpgradeManager
    Components[9]=LeanCollisionCylinder
    Components[10]=AirdropBGSound
    Components[11]=ShellShockSoundComponent
    Components[12]=AirdropWindSound
    Components[13]=NonRealtimeAudio
    Components[14]=CCP0
    Components[15]=AC0
    Components[16]=CCP1
    Components[17]=AC1
    CollisionComponent=CollisionCylinder
}