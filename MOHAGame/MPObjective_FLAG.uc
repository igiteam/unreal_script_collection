class MPObjective_FLAG extends Actor
    native
    config(Game)
    notplaceable
    hidecategories(Navigation);

enum EMPObjectiveFlagState
{
    OBJ_FLAG_NEUTRAL,               // 0
    OBJ_FLAG_FROM_NEUTRAL_TO_AXIS,  // 1
    OBJ_FLAG_FROM_AXIS_TO_NEUTRAL,  // 2
    OBJ_FLAG_AXIS,                  // 3
    OBJ_FLAG_FROM_NEUTRAL_TO_ALLIED,// 4
    OBJ_FLAG_FROM_ALLIED_TO_NEUTRAL,// 5
    OBJ_FLAG_ALLIED,                // 6
    OBJ_FLAG_MAX                    // 7
};

var const export editinline SpriteComponent PlacementSprite;
var() export editinline SkeletalMeshComponent skelFlagMesh;
var SkelControlSingleBone FlagTranslation;
var MOHAMultiplayerController CreditedActivater;
var transient array<MOHAMultiplayerController> AlliedActivaterArray;
var transient array<MOHAMultiplayerController> AxisActivaterArray;
var transient bool bHasBeenAxis;
var transient bool bHasBeenAllied;
var transient bool bOverrideRequiresTwoToCapture;
var transient bool bRopeSoundPlaying;
var transient int m_iGRIIndex;
var() MPObjective_FLAG.EMPObjectiveFlagState m_InitialState;
var MPObjective_FLAG.EMPObjectiveFlagState m_State;
var MPObjective_FLAG.EMPObjectiveFlagState m_SavedState;
var bool bUpdateStateDisplay;
var config bool bReturnToNeutral;
var config bool bReturnToFullCaptureState;
var() bool bRequiresTwoToCapture;
var() bool bEnablePlayRopeSound;
var bool bShouldSetMessagesForControllers;
var config float PointsForCapture;
var config float PointsForNeutralize;
var config float TeamPointsForHelping;
var(FlagHud) int FlagHudIndex;
var() float timeToCapture;
var repnotify float captureTimer;
var float inProgressToCaptureTimer;
var MaterialInstanceConstant AxisMat;
var MaterialInstanceConstant NeutralMat;
var MaterialInstanceConstant AlliedMat;
var(Sound) SoundCue AxisCaptureSoundCue;
var(Sound) SoundCue AlliedCaptureSoundCue;
var(Sound) export editinline AudioComponent RopeSound;

function UnTouchedBy(MOHAMultiplayerController Toucher)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x45 [Loop If]
    if(I < AlliedActivaterArray.Length)
    {
        // End:0x3B
        if(AlliedActivaterArray[I] == Toucher)
        {
            AlliedActivaterArray.Remove(I, 1);
            // [Explicit Break]
            goto J0x45;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x45:

    I = 0;
    J0x4C:

    // End:0x8A [Loop If]
    if(I < AxisActivaterArray.Length)
    {
        // End:0x80
        if(AxisActivaterArray[I] == Toucher)
        {
            AxisActivaterArray.Remove(I, 1);
            // [Explicit Break]
            goto J0x8A;
        }
        I++;
        // [Loop Continue]
        goto J0x4C;
    }
    J0x8A:

    Toucher.ClientSetSpawnText("", 0.0000000);
    bShouldSetMessagesForControllers = true;
    //return;    
}

function TouchedBy(MOHAMultiplayerController Toucher)
{
    local int I;

    // End:0x73
    if(Toucher.PlayerReplicationInfo.Team.TeamIndex == 0)
    {
        I = 0;
        J0x2D:

        // End:0x5E [Loop If]
        if(I < AlliedActivaterArray.Length)
        {
            // End:0x54
            if(AlliedActivaterArray[I] == Toucher)
            {
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x2D;
        }
        AlliedActivaterArray[AlliedActivaterArray.Length] = Toucher;        
    }
    else
    {
        // End:0xE3
        if(Toucher.PlayerReplicationInfo.Team.TeamIndex == 1)
        {
            I = 0;
            J0xA0:

            // End:0xD1 [Loop If]
            if(I < AxisActivaterArray.Length)
            {
                // End:0xC7
                if(AxisActivaterArray[I] == Toucher)
                {
                    return;
                }
                I++;
                // [Loop Continue]
                goto J0xA0;
            }
            AxisActivaterArray[AxisActivaterArray.Length] = Toucher;
        }
    }
    bShouldSetMessagesForControllers = true;
    //return;    
}

event SetMessagesForClientControllers()
{
    local int I, TotalActiveNum, AlliedActivateNum, AxisActivateNum;
    local MOHAMultiplayerController.MPFlagMessagesEnums AlliedMessage, AxisMessage;

    AlliedActivateNum = AlliedActivaterArray.Length;
    AxisActivateNum = AxisActivaterArray.Length;
    TotalActiveNum = AlliedActivateNum + AxisActivateNum;
    // End:0x3A
    if(TotalActiveNum == 0)
    {
        return;        
    }
    else
    {
        // End:0xCF
        if((AlliedActivateNum > 0) && AxisActivateNum > 0)
        {
            // End:0x87
            if((int(m_State) == int(2)) || int(m_State) == int(3))
            {
                AlliedMessage = 0;
                AxisMessage = 1;                
            }
            else
            {
                // End:0xBC
                if((int(m_State) == int(5)) || int(m_State) == int(6))
                {
                    AxisMessage = 0;
                    AlliedMessage = 1;                    
                }
                else
                {
                    AlliedMessage = 2;
                    AxisMessage = 2;
                }
            }            
        }
        else
        {
            // End:0x173
            if(((((bRequiresTwoToCapture == true) && bOverrideRequiresTwoToCapture == false) && TotalActiveNum == 1) && int(m_State) != int(6)) && int(m_State) != int(3))
            {
                // End:0x13D
                if(int(m_State) == int(2))
                {
                    AlliedMessage = 0;
                    AxisMessage = 3;                    
                }
                else
                {
                    // End:0x160
                    if(int(m_State) == int(5))
                    {
                        AlliedMessage = 3;
                        AxisMessage = 0;                        
                    }
                    else
                    {
                        AlliedMessage = 3;
                        AxisMessage = 3;
                    }
                }                
            }
            else
            {
                // End:0x1A8
                if((int(m_State) == int(6)) || int(m_State) == int(3))
                {
                    AlliedMessage = 4;
                    AxisMessage = 4;                    
                }
                else
                {
                    // End:0x1EF
                    if(((int(m_State) == int(4)) || int(m_State) == int(1)) || int(m_State) == int(0))
                    {
                        AlliedMessage = 5;
                        AxisMessage = 5;                        
                    }
                    else
                    {
                        // End:0x228
                        if(int(m_State) == int(5))
                        {
                            // End:0x21D
                            if(AxisActivateNum > 0)
                            {
                                AlliedMessage = 1;
                                AxisMessage = 0;                                
                            }
                            else
                            {
                                AlliedMessage = 5;
                            }                            
                        }
                        else
                        {
                            // End:0x246
                            if(AlliedActivateNum > 0)
                            {
                                AxisMessage = 1;
                                AlliedMessage = 0;                                
                            }
                            else
                            {
                                AxisMessage = 5;
                            }
                        }
                    }
                }
            }
        }
    }
    I = 0;
    J0x255:

    // End:0x28D [Loop If]
    if(I < AlliedActivaterArray.Length)
    {
        AlliedActivaterArray[I].ClientSetFlagMessage(AlliedMessage);
        I++;
        // [Loop Continue]
        goto J0x255;
    }
    I = 0;
    J0x294:

    // End:0x2CC [Loop If]
    if(I < AxisActivaterArray.Length)
    {
        AxisActivaterArray[I].ClientSetFlagMessage(AxisMessage);
        I++;
        // [Loop Continue]
        goto J0x294;
    }
    //return;    
}

event AxisEarnObjectiveFlagPoints(bool bNeutralize)
{
    local int I;
    local float Points;

    // End:0x1A
    if(bNeutralize == true)
    {
        Points = PointsForNeutralize;        
    }
    else
    {
        Points = PointsForCapture;
    }
    // End:0xCC
    if(WorldInfo.Game != none)
    {
        I = 0;
        J0x40:

        // End:0xCC [Loop If]
        if(I < AxisActivaterArray.Length)
        {
            ObjectiveGameInfo(WorldInfo.Game).ScoreObjectiveFlagPoints(int(Points), AxisActivaterArray[I]);
            // End:0xC2
            if(AxisActivaterArray.Length > 1)
            {
                ObjectiveGameInfo(WorldInfo.Game).ScoreTeamFlagPoints(int(TeamPointsForHelping), AxisActivaterArray[I]);
            }
            I++;
            // [Loop Continue]
            goto J0x40;
        }
    }
    //return;    
}

event AlliedEarnObjectiveFlagPoints(bool bNeutralize)
{
    local int I;
    local float Points;

    // End:0x1A
    if(bNeutralize == true)
    {
        Points = PointsForNeutralize;        
    }
    else
    {
        Points = PointsForCapture;
    }
    // End:0xCC
    if(WorldInfo.Game != none)
    {
        I = 0;
        J0x40:

        // End:0xCC [Loop If]
        if(I < AlliedActivaterArray.Length)
        {
            ObjectiveGameInfo(WorldInfo.Game).ScoreObjectiveFlagPoints(int(Points), AlliedActivaterArray[I]);
            // End:0xC2
            if(AlliedActivaterArray.Length > 1)
            {
                ObjectiveGameInfo(WorldInfo.Game).ScoreTeamFlagPoints(int(TeamPointsForHelping), AlliedActivaterArray[I]);
            }
            I++;
            // [Loop Continue]
            goto J0x40;
        }
    }
    //return;    
}

simulated function ResetToDefaultState()
{
    CreditedActivater = none;
    AlliedActivaterArray.Remove(0, AlliedActivaterArray.Length);
    AxisActivaterArray.Remove(0, AxisActivaterArray.Length);
    m_SavedState = m_InitialState;
    captureTimer = 0.0000000;
    ChangeState(m_InitialState);
    //return;    
}

simulated function PostBeginPlay()
{
    local ObjectiveGameReplicationInfo obgri;

    obgri = ObjectiveGameReplicationInfo(WorldInfo.GRI);
    // End:0x26
    if(obgri == none)
    {
        return;
    }
    super.PostBeginPlay();
    obgri.AddFlagObjective(self);
    m_State = m_InitialState;
    FlagTranslation = SkelControlSingleBone(skelFlagMesh.FindSkelControl('FlagTranslation'));
    FlagTranslation.ControlStrength = 1.0000000;
    FlagTranslation.SetSkelControlActive(true);
    ResetToDefaultState();
    //return;    
}

simulated function Destroyed()
{
    local ObjectiveGameReplicationInfo obgri;

    obgri = ObjectiveGameReplicationInfo(WorldInfo.GRI);
    // End:0x38
    if(obgri != none)
    {
        obgri.RemoveFlagObjective(self);
    }
    super.Destroyed();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local AnimNodeSequence SeqNode;

    // End:0x10F
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        // End:0xA2
        if(FlagTranslation == none)
        {
            FlagTranslation = SkelControlSingleBone(skelFlagMesh.FindSkelControl('FlagTranslation'));
            FlagTranslation.ControlStrength = 1.0000000;
            FlagTranslation.SetSkelControlActive(true);
            SeqNode = AnimNodeSequence(skelFlagMesh.Animations);
            SeqNode.PlayAnim(true, 1.0000000, 0.0000000);
        }
        // End:0xDA
        if(captureTimer < inProgressToCaptureTimer)
        {
            captureTimer += DeltaTime;
            // End:0xD7
            if(captureTimer > inProgressToCaptureTimer)
            {
                captureTimer = inProgressToCaptureTimer;
            }            
        }
        else
        {
            // End:0x10F
            if(captureTimer > inProgressToCaptureTimer)
            {
                captureTimer -= DeltaTime;
                // End:0x10F
                if(captureTimer < inProgressToCaptureTimer)
                {
                    captureTimer = inProgressToCaptureTimer;
                }
            }
        }
    }
    // End:0x14D
    if(FlagTranslation != none)
    {
        FlagTranslation.BoneTranslation.Z = (1.0000000 - (captureTimer / timeToCapture)) * -140.0000000;
    }
    UpdateInfo();
    super.Tick(DeltaTime);
    //return;    
}

simulated event UpdateInfo()
{
    local ObjectiveGameReplicationInfo obgri;

    obgri = ObjectiveGameReplicationInfo(WorldInfo.GRI);
    // End:0x38
    if(obgri != none)
    {
        obgri.UpdateFlagObjective(self);
    }
    //return;    
}

simulated function MakeRopeSoundDecision(int numberActive, MPObjective_FLAG.EMPObjectiveFlagState inState)
{
    // End:0x4E
    if((((numberActive > 0) && int(inState) != int(6)) && int(inState) != int(3)) && int(inState) != int(0))
    {
        PlayRopeSound();        
    }
    else
    {
        StopRopeSound();
    }
    //return;    
}

simulated event PlayRopeSound()
{
    // End:0x2D
    if(!bRopeSoundPlaying && bEnablePlayRopeSound)
    {
        bRopeSoundPlaying = true;
        RopeSound.Play();
    }
    //return;    
}

simulated event StopRopeSound()
{
    // End:0x20
    if(bRopeSoundPlaying)
    {
        bRopeSoundPlaying = false;
        RopeSound.Stop();
    }
    //return;    
}

simulated event ChangeState(MPObjective_FLAG.EMPObjectiveFlagState NewState)
{
    local MPObjective_FLAG.EMPObjectiveFlagState SavedState;
    local ObjectiveGameReplicationInfo obgri;

    obgri = ObjectiveGameReplicationInfo(WorldInfo.GRI);
    // End:0x26
    if(obgri == none)
    {
        return;
    }
    SavedState = m_State;
    m_State = NewState;
    obgri.UpdateFlagObjective(self);
    stateChanged();
    switch(m_State)
    {
        // End:0x79
        case 0:
            bHasBeenAllied = false;
            bHasBeenAxis = false;
            // End:0x154
            break;
        // End:0xE4
        case 3:
            bHasBeenAxis = true;
            // End:0xE1
            if(int(SavedState) != int(m_State))
            {
                PlaySound(AxisCaptureSoundCue);
                // End:0xE1
                if(Class'Engine.WorldInfo'.static.IsDedicatedServer())
                {
                    Class'Engine.Engine'.static.DSLog("Axis capture flag.");
                }
            }
            // End:0x154
            break;
        // End:0x151
        case 6:
            bHasBeenAllied = true;
            // End:0x14E
            if(int(SavedState) != int(m_State))
            {
                PlaySound(AlliedCaptureSoundCue);
                // End:0x14E
                if(Class'Engine.WorldInfo'.static.IsDedicatedServer())
                {
                    Class'Engine.Engine'.static.DSLog("Allies capture flag.");
                }
            }
            // End:0x154
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x16C
    if(int(Role) == int(ROLE_Authority))
    {
        bShouldSetMessagesForControllers = true;
    }
    //return;    
}

simulated event stateChanged()
{
    local bool bTriggerKismet;

    switch(m_State)
    {
        // End:0x0C
        case 0:
        // End:0x11
        case 1:
        // End:0x32
        case 4:
            skelFlagMesh.SetMaterial(0, NeutralMat);
            // End:0x81
            break;
        // End:0x37
        case 3:
        // End:0x58
        case 2:
            skelFlagMesh.SetMaterial(0, AxisMat);
            // End:0x81
            break;
        // End:0x5D
        case 6:
        // End:0x7E
        case 5:
            skelFlagMesh.SetMaterial(0, AlliedMat);
            // End:0x81
            break;
        // End:0xFFFF
        default:
            break;
    }
    bUpdateStateDisplay = true;
    // End:0x15A
    if((MOHAGameReplicationInfo(WorldInfo.GRI).RemainingTime > 0) && int(m_SavedState) != int(m_State))
    {
        switch(m_State)
        {
            // End:0xF9
            case 0:
                // End:0xF6
                if((int(m_SavedState) != int(1)) && int(m_SavedState) != int(4))
                {
                    bTriggerKismet = true;
                }
                // End:0x13C
                break;
            // End:0x119
            case 3:
                // End:0x116
                if(int(m_SavedState) != int(2))
                {
                    bTriggerKismet = true;
                }
                // End:0x13C
                break;
            // End:0x139
            case 6:
                // End:0x136
                if(int(m_SavedState) != int(5))
                {
                    bTriggerKismet = true;
                }
                // End:0x13C
                break;
            // End:0xFFFF
            default:
                break;
        }
        m_SavedState = m_State;
        // End:0x15A
        if(bTriggerKismet)
        {
            TriggerObjectiveFlagKismet();
        }
    }
    //return;    
}

simulated function ClearStateUpdate()
{
    bUpdateStateDisplay = false;
    //return;    
}

simulated function bool HasStateChanged()
{
    return bUpdateStateDisplay;
    //return ReturnValue;    
}

function TriggerObjectiveFlagKismet()
{
    // End:0x24
    if(FindEventsOfClass(Class'SeqEvent_ObjectiveFlagStateChanged'))
    {
        TriggerEventClass(Class'SeqEvent_ObjectiveFlagStateChanged', self);        
    }
    //return;    
}

defaultproperties
{
    // Reference: SpriteComponent'Default__MPObjective_FLAG.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Scale=0.1000000
    end object
    PlacementSprite=Sprite
    // Reference: SkeletalMeshComponent'Default__MPObjective_FLAG.SkelMComp'
    begin object name=SkelMComp class=Class'Engine.SkeletalMeshComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MPObjective_FLAG.MyLightEnvironment'
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
    end object
    skelFlagMesh=SkelMComp
    m_iGRIIndex=-1
    bUpdateStateDisplay=true
    bReturnToNeutral=true
    bReturnToFullCaptureState=true
    PointsForCapture=1.0000000
    PointsForNeutralize=1.0000000
    TeamPointsForHelping=1.0000000
    FlagHudIndex=-1
    timeToCapture=10.0000000
    // Reference: AudioComponent'Default__MPObjective_FLAG.RopeSound01'
    begin object name=RopeSound01 class=Class'Engine.AudioComponent'
    end object
    RopeSound=RopeSound01
    // Reference: DynamicLightEnvironmentComponent'Default__MPObjective_FLAG.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[0]=MyLightEnvironment
    Components[1]=SkelMComp
    Components[2]=Sprite
    Components[3]=RopeSound01
    RemoteRole=1
    bNoDelete=true
    SupportedEvents=/* Array type was not detected. */
}