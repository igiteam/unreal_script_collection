class MOHAPlayerController extends PlayerController
    native
    config(Player)
    hidecategories(Navigation)
    implements(MOHAControllerInterface,EAKynapseControllerInterface);

const BEST_CSA_INDEX = 0;
const CONTEXT_CAMPAIGNDIFFICULTY = 3;
const CONTEXT_CAMPAIGNNUM = 2;
const CONTEXT_MPMODENUM = 4;
const CONTEXT_MPMAPNUM = 5;
const CONTEXT_MPRANKTYPE = 6;
const GAME_MODE = 0x0000800B;
const CONTEXT_MAPNAME = 8;
const CONTEXT_PLAYERSTATE = 9;
const CONTEXT_TEAMNAME = 12;

enum EReticuleState
{
    CURSOR_AIM_NONE,                // 0
    CURSOR_AIM_ALLY,                // 1
    CURSOR_AIM_AXIS,                // 2
    CURSOR_AIM_MAX                  // 3
};

enum ERichPresenceStrings
{
    RPS_InActive,                   // 0
    RPS_Menus,                      // 1
    RPS_SinglePlayer,               // 2
    RPS_Multiplayer,                // 3
    RPS_MAX                         // 4
};

enum ERPMPMode
{
    RPS_MP_AO,                      // 0
    RPS_MP_TD,                      // 1
    RPS_MP_AD,                      // 2
    RPS_MP_MAX                      // 3
};

enum ERPMPRank
{
    RPS_MP_TYPE_Ranked,             // 0
    RPS_MP_TYPE_Unranked,           // 1
    RPS_MP_TYPE_MAX                 // 2
};

struct native AIStateDebuggerRecord
{
    var name BrainName;
    var name BrainSubstateName;
    var int Instances;

    structdefaultproperties
    {
        BrainName="None"
        BrainSubstateName="None"
        Instances=0
    }
};

struct native MapNameToContextMapping
{
    var name MapName;
    var int ContextValue;

    structdefaultproperties
    {
        MapName="None"
        ContextValue=0
    }
};

var private native const noexport Pointer VfTable_IEAKynapseControllerInterface;
var bool bCineSavedCollideActors;
var bool bCineSavedBlockActors;
var(BehindView) bool bBehindView;
var bool bJumpRequested;
var bool bStanceChangeRequested;
var bool bSprintRequested;
var bool bTwoStanceChange;
var bool bCrouchJumpStanceChange;
var bool bSavedJumpRequested;
var bool bSavedCrouchRequested;
var bool bFlaring;
var Rotator PrePendulumAirdropRotation;
var float fAirdropLaggedTurnInput;
var float fAirdropLaggedLookInput;
var Actor ReticuleActor;
var() config float fReticuleMaxCheckDistance;
var(HitReaction) config float fHitShakeRotAmplitude_Min;
var(HitReaction) config float fHitShakeRotAmplitude_Max;
var(HitReaction) config float fHitDamageForMaxShake;
var(HitReaction) config float fHitShakeFrequency;
var(HitReaction) config float fHitShakeDuration;
var(WeaponCSA) config float WeaponCSAUseHoldTime;
var float fLastFOV;
var export editinline MOHAPlayerStatsComponent playerStats;
var export editinline MOHAPostProcessComponent PostProcessComponent;
var MOHAPostProcessSettingsAsset defaultPostProcessSettingsAsset;
var bool bPlayingCinematic;
var name ScrubbedAnimationName;
var bool bInITPAnimScrubMode;
var(ITP) config float fAnimationEndPosition;
var(ITP) config float fAnimationEndThreshold;
var float CamDistance;
var float CamUpOffset;
var float CamForwardOffset;
var name CamOldState;
var transient MOHAPlayerPawn CamSavedPlayer;
var float CamDistanceMax;
var float CamDistanceMin;
var float CamDistanceStep;
var float CamUpMin;
var float CamUpMax;
var float CamForwardMin;
var float CamForwardMax;
var array<MOHACSA> csaList;
var float CurrentDemoChargingTime;
var float MaxDemoChargingTime;
var bool bDemoChargeUseRelease;
var Weapon DemoChargeWeapon;
var MOHADemoChargeCSA DemoChargeCSA;
var MOHAMountedGunCSA MountedGun;
var float MountedGunEnterTime;
var float MountedGunExitTime;
var float fStateTime;
var Rotator MountStartingRot;
var Rotator rExitMGRot;
var float fExitAimUpBlend;
var float fExitAimRightBlend;
var float DemoPlaceTime;
var bool bEditActorPickerPicking;
var(EditActorPicker) config float fEditActorPickerDistance;
var(EditActorPicker) config float fEditActorPickerExtents;
var const localized string AmmoPickupMsg;
var const localized string HealthPickupMsg;
var const localized string AmmoFullMsg;
var const localized string HealthFullMsg;
var(Sound) SoundCue HealthPickupSoundCue;
var(Sound) SoundCue AmmoPickupSoundCue;
var(Sound) SoundCue HealthPickupFailedSoundCue;
var(Sound) SoundCue AmmoPickupFailedSoundCue;
var int TouchUntouchTick;
var int LastTouchUntouchTick;
var export editinline KynapseEntityComponent KynapseEntityComponent;
var export editinline StimulusComponent Stimulus;
var bool bFireTriggeredByMouse;
var bool bTickHUDWhilePaused;
var float fCrouchJumpToStandVelocity;
var int HighDefVerticalResolution;
var MOHAPawn ViewTargetPawn;
var UIScene InGameMenu;
var EndGameInteraction m_oEndGameI;
var const localized string JoinFailedTitle;
var const localized string JoinFriendFailedMsg;
var const localized string JoinInviteFailedMsg;
var const localized string JoinGameFullMsg;
var ForceFeedbackWaveform WeaponFireFFWaveform;
var MOHAKeyboardManager PlayerKeyboardManager;
var bool bEnterCheatTriggerL;
var bool bEnterCheatTriggerR;
var bool bUsedCheat;
var bool bCanJumpOrDuck;
var UIScene ProfileScene;
var MOHAUIInteraction.AlertButtonConfig alertButtons;
var UIScene ExternalPauseScene;
var bool externallyPaused;
var const AffordanceNodeVolume CurrentAffordanceNode;
var const AffordanceNodeVolume LastGoodAffordanceNode;
var const array<AffordanceNodeVolume> EngagedAffordanceNodes;
var const array<AffordanceNodeVolume> PreviouslyEngagedAffordanceNodes;
var config float UnengagedTime;
var(suppression) config float fSuppressionMax;
var(suppression) config float fSuppressionThreshhold;
var(suppression) config float fSuppressionSafe;
var(suppression) config float fSuppressionDecayRate;
var float SuppressionMeter;
var bool bDrawSuppressionMeter;
var transient MOHAGamePluginModulator AudioPluginMod;
var protected UIDataStore_MOHAPlayerStats CurrentStatsData;
var protected MOHAProfileSettings ProfileSettings;
var MOHAIncludeClass.eGameDifficulty GameDifficulty;
var bool bShowCompass;
var(AIDebug) array<AIStateDebuggerRecord> AIStateRecord;
var config array<config MapNameToContextMapping> MapNamesToContextValues;
var MultiDebugGraph DebugGraphs;

// Export UMOHAPlayerController::execGetGamePluginModulator(FFrame&, void* const)
native final function MOHAGamePluginModulator GetGamePluginModulator();

// Export UMOHAPlayerController::execReticuleActorTrace(FFrame&, void* const)
native function ReticuleActorTrace(out Actor out_ReticuleActor);

// Export UMOHAPlayerController::execOpenPreviousMenu(FFrame&, void* const)
native function OpenPreviousMenu();

// Export UMOHAPlayerController::execSetMOHAPlayerController(FFrame&, void* const)
native static function SetMOHAPlayerController(MOHAPlayerController PC);

// Export UMOHAPlayerController::execGetMOHAPlayerController(FFrame&, void* const)
native static function MOHAPlayerController GetMOHAPlayerController();

// Export UMOHAPlayerController::execGetKeyboardManager(FFrame&, void* const)
native static function MOHAKeyboardManager GetKeyboardManager();

// Export UMOHAPlayerController::execFinishDestroy(FFrame&, void* const)
native function FinishDestroy();

// Export UMOHAPlayerController::execGetReticuleState(FFrame&, void* const)
native function MOHAPlayerController.EReticuleState GetReticuleState();

// Export UMOHAPlayerController::execIsMoveInputIgnored(FFrame&, void* const)
native function bool IsMoveInputIgnored();

// Export UMOHAPlayerController::execIsLookInputIgnored(FFrame&, void* const)
native function bool IsLookInputIgnored();

// Export UMOHAPlayerController::execHandleWalking(FFrame&, void* const)
native function HandleWalking();

// Export UMOHAPlayerController::execGetLastFOV(FFrame&, void* const)
native function float GetLastFOV();

// Export UMOHAPlayerController::execSaveLoadClear(FFrame&, void* const)
native function SaveLoadClear();

// Export UMOHAPlayerController::execSetGamma(FFrame&, void* const)
native function SetGamma(float GammaValue);

// Export UMOHAPlayerController::execSetAudioVolume(FFrame&, void* const)
native function SetAudioVolume(name GroupName, float FValue);

// Export UMOHAPlayerController::execUnlockNextLevel(FFrame&, void* const)
native function UnlockNextLevel(int CurrentLevel);

// Export UMOHAPlayerController::execIsLoadingScreenActive(FFrame&, void* const)
native final function bool IsLoadingScreenActive();

// Export UMOHAPlayerController::execAddDebugGraphPoint(FFrame&, void* const)
native function AddDebugGraphPoint(string GraphLabel, float X, float Y, optional float fColorThresh);

function StimulusComponent GetStimulusComponent()
{
    return Stimulus;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    InGameMenu = WorldInfo.InGameMenu;
    PlayerKeyboardManager = new Class'MOHAKeyboardManager';
    PlayerKeyboardManager.Init();
    m_oEndGameI = new (self) Class'EndGameInteraction';
    // End:0xA5
    if((WorldInfo.WorldPostProcessSettingsAsset != none) && WorldInfo.WorldPostProcessSettingsAsset.IsA('MOHAPostProcessSettingsAsset'))
    {
        PostProcessComponent.PostProcessSettings = MOHAPostProcessSettingsAsset(WorldInfo.WorldPostProcessSettingsAsset);
    }
    SetMOHAPlayerController(self);
    playerStats.Init(self);
    // End:0xFD
    if(Class'MOHAUtilities'.static.IsEditorActive() && AudioPluginMod != none)
    {
        AudioPluginMod.Cleanup();
        AudioPluginMod = none;
    }
    AudioPluginMod = GetGamePluginModulator();
    //return;    
}

event Destroyed()
{
    // End:0x2E
    if(IsLocalPlayerController())
    {
        // End:0x2E
        if(AudioPluginMod != none)
        {
            AudioPluginMod.Cleanup();
            AudioPluginMod = none;
        }
    }
    super.Destroyed();
    //return;    
}

function DrawEngagedAffordance(Canvas Canvas)
{
    local int I;
    local AffordanceNodeVolume CurVol;

    Canvas.SetPos(float(Canvas.SizeX / 7), float(Canvas.SizeY / 3));
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    Canvas.__NFUN_465__("Current Affordance Node: " $ string(LastGoodAffordanceNode));
    I = 0;
    J0x8C:

    // End:0xCB [Loop If]
    if(I < EngagedAffordanceNodes.Length)
    {
        CurVol = EngagedAffordanceNodes[I];
        DrawSingleEngagedAffordance(Canvas, CurVol);
        I++;
        // [Loop Continue]
        goto J0x8C;
    }
    Canvas.__NFUN_465__(" ");
    Canvas.__NFUN_465__("Previously Engaged Affordances");
    I = 0;
    J0x111:

    // End:0x150 [Loop If]
    if(I < PreviouslyEngagedAffordanceNodes.Length)
    {
        CurVol = PreviouslyEngagedAffordanceNodes[I];
        DrawSingleEngagedAffordance(Canvas, CurVol);
        I++;
        // [Loop Continue]
        goto J0x111;
    }
    //return;    
}

function DrawSingleEngagedAffordance(Canvas Canvas, AffordanceNodeVolume CurVol)
{
    local bool bFightNearby, bAxisArmExists, bNPCsEngagingPlayer;

    bFightNearby = CurVol.IsFightNearby();
    bAxisArmExists = CurVol.DoesArmExist(1);
    bNPCsEngagingPlayer = CurVol.AnyNPCsEngagingPlayer(self);
    Canvas.__NFUN_465__((((((string(CurVol) $ " fn:") $ string(bFightNearby)) $ " aa:") $ string(bAxisArmExists)) $ " ep:") $ string(bNPCsEngagingPlayer));
    //return;    
}

function SetAirdropMoveDirection()
{
    //return;    
}

function OnPostProcessFade(SeqAct_PostProcessFade inAct)
{
    // End:0x3E
    if(inAct.bFadeIn == true)
    {
        FadeIn(inAct.delay, inAct.FadeTime);        
    }
    else
    {
        FadeOut(inAct.delay, inAct.FadeTime);
    }
    //return;    
}

function FadeIn(float fDelay, float fFadeTime)
{
    MOHAHUD(myHUD).FadeIn(fDelay, fFadeTime);
    //return;    
}

function FadeOut(float fDelay, float fFadeTime)
{
    MOHAHUD(myHUD).FadeOut(fDelay, fFadeTime);
    //return;    
}

exec function SetDifficulty(MOHAIncludeClass.eGameDifficulty Difficulty)
{
    local MOHAPlayerPawn PlayerPawn;

    GameDifficulty = Difficulty;
    PlayerPawn = MOHAPlayerPawn(Pawn);
    // End:0x39
    if(PlayerPawn != none)
    {
        PlayerPawn.InitDifficultySettings();
    }
    //return;    
}

exec function FlareChute(optional byte FireModeNum)
{
    //return;    
}

exec function FlareChuteEnd(optional byte FireModeNum)
{
    //return;    
}

event name GetControllerStateName()
{
    return GetStateName();
    //return ReturnValue;    
}

function bool IronsightsLeanEnabled()
{
    return ((MOHAPlayerPawn(Pawn) != none) && MOHAPlayerPawn(Pawn).IsIronsightsActive()) && !bSprintRequested;
    //return ReturnValue;    
}

function bool IsIronsightsActive()
{
    return (MOHAPlayerPawn(Pawn) != none) && MOHAPlayerPawn(Pawn).IsIronsightsActive();
    //return ReturnValue;    
}

function bool PlayerCanUseWeapon()
{
    // End:0x2E
    if(MOHAPlayerPawn(Pawn) != none)
    {
        return !MOHAPlayerPawn(Pawn).IsWeaponDisabled();        
    }
    else
    {
        // End:0x40
        if(MOHAMountedGun(Pawn) != none)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool PlayerCanSwitchWeapons()
{
    return ((((PlayerCanUseWeapon()) && !DisableDPadWeaponSwitch()) && !DisableMouseWheelWeaponSwitch()) && !IsHoldingHellBox()) && !IsWeaponDropPending();
    //return ReturnValue;    
}

function bool DisableDPadWeaponSwitch()
{
    local bool bGOWControllerScheme, bScopeActive, bDPadWeaponSwitch;

    bGOWControllerScheme = int(MOHAPlayerInput(PlayerInput).ControllerScheme) == int(1);
    bScopeActive = ((Pawn != none) && EALASmallArms(Pawn.Weapon) != none) && EALASmallArms(Pawn.Weapon).IsScopeActive();
    bDPadWeaponSwitch = (PlayerInput.PressedKeys.Find('XboxTypeS_DPad_Up') != -1) || PlayerInput.PressedKeys.Find('XboxTypeS_DPad_Down') != -1;
    return (bGOWControllerScheme && bScopeActive) && bDPadWeaponSwitch;
    //return ReturnValue;    
}

function bool DisableMouseWheelWeaponSwitch()
{
    local bool bScopeActive, bMouseWheelPressed;

    bScopeActive = ((Pawn != none) && EALASmallArms(Pawn.Weapon) != none) && EALASmallArms(Pawn.Weapon).IsScopeActive();
    bMouseWheelPressed = (PlayerInput.PressedKeys.Find('MouseScrollDown') != -1) || PlayerInput.PressedKeys.Find('MouseScrollUp') != -1;
    return bScopeActive && bMouseWheelPressed;
    //return ReturnValue;    
}

simulated function bool IsHoldingHellBox()
{
    return (EALAWeapon(Pawn.Weapon) != none) && int(EALAWeapon(Pawn.Weapon).WeaponType) == int(23);
    //return ReturnValue;    
}

simulated function bool IsWeaponDropPending()
{
    return ((EALAWeapon(Pawn.Weapon) != none) && Pawn.InvManager.PendingWeapon != none) && EALAWeapon(Pawn.Weapon).bDropWeaponWhenPutDownDone;
    //return ReturnValue;    
}

function bool PlayerIsDead()
{
    return (MOHAPlayerPawn(Pawn) != none) && MOHAPlayerPawn(Pawn).IsDead();
    //return ReturnValue;    
}

function bool PlayerCanRespawn()
{
    return (MOHAPlayerPawn(Pawn) != none) && MOHAPlayerPawn(Pawn).CanRespawn();
    //return ReturnValue;    
}

function bool CanJumpOrDuck()
{
    return bCanJumpOrDuck;
    //return ReturnValue;    
}

function bool PlayerCanReload()
{
    local MOHACSA csa;

    // End:0x16
    if(!WorldInfo.IsConsoleBuild())
    {
        return true;
    }
    // End:0xC6
    if((MOHAPlayerPawn(Pawn) != none) && csaList.Length != 0)
    {
        csa = csaList[0];
        // End:0xC6
        if((csa != none) && !csa.bDirty)
        {
            // End:0xC6
            if(((csa.IsA('MOHAMountedGunCSA') || csa.IsA('MOHAGrenadeCSA')) || csa.IsA('MOHAWeaponCSA')) || csa.IsA('MOHAPickupCrateCSA'))
            {
                return false;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

event bool IsUsingMouse()
{
    return ((MOHAPlayerInput(PlayerInput) != none) ? MOHAPlayerInput(PlayerInput).bUsingMouse : false);
    //return ReturnValue;    
}

function GetBlendedMouse(out float X, out float Y, int NumSamples)
{
    // End:0x37
    if(MOHAPlayerInput(PlayerInput) != none)
    {
        MOHAPlayerInput(PlayerInput).GetBlendedMouse(X, Y, NumSamples);
    }
    //return;    
}

event PlayerTick(float DeltaTime)
{
    PlayerInput.PlayerInput(DeltaTime);
    // End:0x2B
    if(bUpdatePosition)
    {
        ClientUpdatePosition();
    }
    NotifyPawnOfSprint();
    CheckCrouchJumpStanceChange();
    // End:0x7E
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        TickSuppression(DeltaTime);
        PlayerMove(DeltaTime, DeltaTime);        
    }
    else
    {
        MultiplayerMove(DeltaTime);
    }
    AdjustFOV(DeltaTime);
    UpdateCSAList();
    // End:0xBC
    if(bEditActorPickerPicking == true)
    {
        DrawCurrentEditActorPick();
    }
    // End:0x1CA
    if(PostProcessComponent != none)
    {
        // End:0x143
        if(((LocalPlayer(Player) != none) && LocalPlayer(Player).MOHAPostProcessSettings != none) && LocalPlayer(Player).MOHAPostProcessSettings.IsA('MOHAPostProcessSettingsAsset'))
        {
            PostProcessComponent.PostProcessSettings = MOHAPostProcessSettingsAsset(LocalPlayer(Player).MOHAPostProcessSettings);            
        }
        else
        {
            // End:0x19E
            if((WorldInfo.WorldPostProcessSettingsAsset != none) && WorldInfo.WorldPostProcessSettingsAsset.IsA('MOHAPostProcessSettingsAsset'))
            {
                PostProcessComponent.PostProcessSettings = MOHAPostProcessSettingsAsset(WorldInfo.WorldPostProcessSettingsAsset);                
            }
            else
            {
                PostProcessComponent.PostProcessSettings = defaultPostProcessSettingsAsset;
            }
        }
        PostProcessComponent.Update(DeltaTime);
    }
    ReticuleActorTrace(ReticuleActor);
    // End:0x1FF
    if(bTickHUDWhilePaused)
    {
        MOHAHUD(myHUD).PauseTick(DeltaTime);
    }
    TouchUntouchTick++;
    // End:0x229
    if(playerStats != none)
    {
        playerStats.Tick(DeltaTime);
    }
    //return;    
}

function DrawSuppression(Canvas Canvas)
{
    local Vector pos;
    local float XL, YL;
    local string meter;
    local int I;

    // End:0x0D
    if(!bDrawSuppressionMeter)
    {
        return;
    }
    I = 0;
    J0x14:

    // End:0x3F [Loop If]
    if(float(I) < SuppressionMeter)
    {
        meter = meter $ "X";
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    pos.X = float(Canvas.SizeX / 2);
    pos.Y = float((Canvas.SizeY * 2) / 3);
    Canvas.__NFUN_464__(meter, XL, YL);
    pos.X -= (XL * 0.5000000);
    Canvas.SetPos(pos.X, pos.Y);
    Canvas.DrawColor = myHUD.RedColor;
    Canvas.__NFUN_469__(meter);
    //return;    
}

function TickSuppression(float DeltaTime)
{
    // End:0x19
    if(SuppressionMeter >= fSuppressionThreshhold)
    {
        OnSuppressed();
    }
    AddSuppression(0.0000000 - (fSuppressionDecayRate * DeltaTime));
    //return;    
}

function OnSuppressed()
{
    BroadcastStimulusToNearbyAllies(5000.0000000, "PlayerSuppressed");
    SuppressionMeter = 0.0000000;
    //return;    
}

function OnUnsuppressed()
{
    //return;    
}

function AddSuppression(float suppression)
{
    SuppressionMeter += suppression;
    SuppressionMeter = FClamp(SuppressionMeter, 0.0000000, fSuppressionMax);
    //return;    
}

function FireNear(out StimulusListenerSubscription Listener, out StimulusSenderSubscription Sender)
{
    local float threat;
    local int Team;

    threat = 1.0000000;
    Team = 2;
    Sender.Owner.GetStimuliSenderParamInt('BulletImpact', 'Team', Team);
    // End:0x5D
    if(Team != 0)
    {
        AddSuppression(threat);
    }
    //return;    
}

simulated function TickHUDWhilePaused(bool bPause)
{
    bTickHUDWhilePaused = bPause;
    WorldInfo.bPauseTicksLocalPlayer = bPause;
    SetPause(bPause);
    //return;    
}

simulated function MultiplayerMove(float DeltaTime)
{
    PlayerMove(DeltaTime, DeltaTime);
    //return;    
}

simulated function NotifyPawnOfSprint()
{
    // End:0x2B
    if(MOHAPlayerPawn(Pawn) != none)
    {
        MOHAPlayerPawn(Pawn).bSprintRequested = bSprintRequested;
    }
    //return;    
}

function CheckJumpOrDuck()
{
    local MOHAPlayerInput pInput;

    // End:0x2E
    if(!CanJumpOrDuck() || PlayerIsDead())
    {
        bJumpRequested = false;
        bStanceChangeRequested = false;
    }
    // End:0x82
    if(!Pawn.bCanJump || (int(WorldInfo.NetMode) != int(NM_Standalone)) && MOHAPlayerPawn(Pawn).IsIronsightsActive())
    {
        bJumpRequested = false;
    }
    // End:0x2DF
    if(int(MOHAPlayerPawn(Pawn).eCurrentStanceChange) == int(0))
    {
        // End:0xE4
        if(bJumpRequested && int(MOHAPlayerPawn(Pawn).eCurrentStance) == int(0))
        {
            MOHAPlayerPawn(Pawn).Player_JumpEvent();            
        }
        else
        {
            // End:0x1B9
            if(bJumpRequested && int(MOHAPlayerPawn(Pawn).eCurrentStance) == int(1))
            {
                // End:0x18B
                if(int(WorldInfo.NetMode) == int(NM_Standalone))
                {
                    // End:0x188
                    if((Pawn.Weapon != none) && int(EALASmallArms(Pawn.Weapon).GetIronsightsState()) != int(3))
                    {
                        MOHAPlayerPawn(Pawn).Player_JumpEvent();
                        bCrouchJumpStanceChange = true;
                    }                    
                }
                else
                {
                    // End:0x1B6
                    if(Pawn.IsLocallyControlled())
                    {
                        MOHAPlayerPawn(Pawn).UpwardStanceChangeRequest();
                    }
                }                
            }
            else
            {
                // End:0x2CF
                if(bStanceChangeRequested)
                {
                    // End:0x28B
                    if((int(MOHAPlayerPawn(Pawn).eCurrentStance) == int(0)) && int(Pawn.Physics) == int(1))
                    {
                        MOHAPlayerPawn(Pawn).DownwardStanceChangeRequest();
                        pInput = MOHAPlayerInput(PlayerInput);
                        // End:0x288
                        if((pInput != none) && playerStats != none)
                        {
                            // End:0x288
                            if(pInput.bSprintCrouchToStandRequested)
                            {
                                pInput.bSprintCrouchToStandRequested = false;
                                playerStats.GiveXboxLiveAchievement("ACH_SP_Crouch_Sprint");
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x2CF
                        if((int(MOHAPlayerPawn(Pawn).eCurrentStance) == int(1)) && !bCrouchJumpStanceChange)
                        {
                            MOHAPlayerPawn(Pawn).UpwardStanceChangeRequest();
                        }
                    }
                }
            }
        }
        bJumpRequested = false;
        bStanceChangeRequested = false;
    }
    //return;    
}

simulated function CheckCrouchJumpStanceChange()
{
    // End:0x7C
    if((Pawn != none) && bCrouchJumpStanceChange)
    {
        // End:0x7C
        if(Pawn.Velocity.Z <= fCrouchJumpToStandVelocity)
        {
            // End:0x72
            if(int(WorldInfo.NetMode) == int(NM_Client))
            {
                MOHAPlayerPawn(Pawn).UpwardStanceChangeRequest();
                bCrouchJumpStanceChange = false;
            }
            ServerSetCrouchJumpStanceStatus();
        }
    }
    //return;    
}

reliable server function ServerSetCrouchJumpStanceStatus()
{
    MOHAPlayerPawn(Pawn).UpwardStanceChangeRequest();
    bCrouchJumpStanceChange = false;
    //return;    
}

exec function BehindView()
{
    bBehindView = !bBehindView;
    //return;    
}

exec function ToggleYawGraph()
{
    MOHAPlayerInput(PlayerInput).bDrawYawSpeedGraph = !MOHAPlayerInput(PlayerInput).bDrawYawSpeedGraph;
    //return;    
}

exec function TogglePitchGraph()
{
    MOHAPlayerInput(PlayerInput).bDrawPitchSpeedGraph = !MOHAPlayerInput(PlayerInput).bDrawPitchSpeedGraph;
    //return;    
}

exec function ToggleCursor(bool bEnable)
{
    // End:0x32
    if(myHUD != none)
    {
        MOHAHUD(myHUD).hud_cursor.RenderWithQuickFade(bEnable);
    }
    //return;    
}

function ResetCursor()
{
    // End:0x2C
    if(myHUD != none)
    {
        MOHAHUD(myHUD).hud_cursor.ResetCursor();
    }
    //return;    
}

function WeaponCSAHoldTimeExpired()
{
    local MOHACSA csa;

    // End:0x2A
    if(GetHighestPriorityCSA(csa))
    {
        csa.UsedBy(Pawn);
    }
    //return;    
}

exec function SwitchWeaponPress()
{
    SwitchWeapon();
    // End:0x34
    if(PlayerCanSwitchWeapons())
    {
        MOHAHUD(myHUD).ToggleWeaponInfo(false,, 0);
    }
    //return;    
}

exec function SwitchWeapon()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return;
    }
    // End:0x48
    if(Pawn.Weapon == none)
    {
        SwitchToBestWeapon();
        return;
    }
    // End:0x7D
    if(Pawn.InvManager != none)
    {
        MOHAInventoryManager(Pawn.InvManager).SwitchWeapon();
    }
    //return;    
}

exec function SwitchPreviousWeapon()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return;
    }
    // End:0x48
    if(Pawn.Weapon == none)
    {
        SwitchToBestWeapon();
        return;
    }
    // End:0x7D
    if(Pawn.InvManager != none)
    {
        MOHAInventoryManager(Pawn.InvManager).SwitchPreviousWeapon();
    }
    //return;    
}

exec function SwitchPrimary()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return;
    }
    // End:0x79
    if(Pawn.InvManager != none)
    {
        MOHAHUD(myHUD).ToggleWeaponInfo(false,, 0);
        MOHAInventoryManager(Pawn.InvManager).SwitchPrimary();
    }
    //return;    
}

exec function SwitchSecondary()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return;
    }
    // End:0x79
    if(Pawn.InvManager != none)
    {
        MOHAHUD(myHUD).ToggleWeaponInfo(false,, 0);
        MOHAInventoryManager(Pawn.InvManager).SwitchSecondary();
    }
    //return;    
}

exec function SwitchOffWeapon()
{
    // End:0x16
    if(WorldInfo.Pauser != none)
    {
        return;
    }
    // End:0x4D
    if(Pawn.InvManager != none)
    {
        MOHAInventoryManager(Pawn.InvManager).SetCurrentWeapon(none);
    }
    //return;    
}

exec function SwitchGrenade()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return;
    }
    // End:0x79
    if(none != Pawn.InvManager)
    {
        MOHAHUD(myHUD).ToggleWeaponInfo(false,, 1);
        MOHAInventoryManager(Pawn.InvManager).SwitchGrenade();
    }
    //return;    
}

exec function SwitchFragGrenade()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return;
    }
    // End:0x79
    if(Pawn.InvManager != none)
    {
        MOHAHUD(myHUD).ToggleWeaponInfo(false,, 1);
        MOHAInventoryManager(Pawn.InvManager).SwitchFragGrenade();
    }
    //return;    
}

exec function SwitchPistol()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return;
    }
    // End:0x79
    if(Pawn.InvManager != none)
    {
        MOHAHUD(myHUD).ToggleWeaponInfo(false,, 0);
        MOHAInventoryManager(Pawn.InvManager).SwitchPistol();
    }
    //return;    
}

exec function SwitchGammon()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return;
    }
    // End:0x79
    if(Pawn.InvManager != none)
    {
        MOHAHUD(myHUD).ToggleWeaponInfo(false,, 1);
        MOHAInventoryManager(Pawn.InvManager).SwitchGammon();
    }
    //return;    
}

exec function SwitchStick()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return;
    }
    // End:0x79
    if(Pawn.InvManager != none)
    {
        MOHAHUD(myHUD).ToggleWeaponInfo(false,, 1);
        MOHAInventoryManager(Pawn.InvManager).SwitchStick();
    }
    //return;    
}

exec function LoadMG42Weapon()
{
    // End:0x16
    if(WorldInfo.Pauser != none)
    {
        return;
    }
    // End:0x4D
    if(Pawn.InvManager != none)
    {
        MOHAInventoryManager(Pawn.InvManager).FilteredNextWeapon(4);
    }
    //return;    
}

exec function Weapon RaiseDemoCharge()
{
    // End:0x27
    if((WorldInfo.Pauser != none) || !PlayerCanSwitchWeapons())
    {
        return none;
    }
    // End:0x5F
    if(Pawn.InvManager != none)
    {
        return MOHAInventoryManager(Pawn.InvManager).FilteredNextWeapon(3);
    }
    //return ReturnValue;    
}

exec function UseRelease()
{
    local MOHACSA csa;
    local float TimeHeld;

    TimeHeld = GetTimerRate('WeaponCSAHoldTimeExpired') - GetTimerCount('WeaponCSAHoldTimeExpired');
    GetHighestPriorityCSA(csa);
    // End:0x9B
    if((((csa != none) && !csa.IsA('MOHAGrenadeCSA')) && WorldInfo.IsConsoleBuild()) && PlayerCanUseWeapon())
    {
        // End:0x9B
        if(TimeHeld < WeaponCSAUseHoldTime)
        {
            StartReload(0);
        }
    }
    ClearTimer('WeaponCSAHoldTimeExpired');
    //return;    
}

exec function SwitchToBestWeapon(optional bool bForceNewWeapon)
{
    // End:0x12
    if(!PlayerCanSwitchWeapons())
    {
        return;
    }
    super(Controller).SwitchToBestWeapon(bForceNewWeapon);
    //return;    
}

// Export UMOHAPlayerController::execWorldTick(FFrame&, void* const)
native function WorldTick(float DeltaTime);

// Export UMOHAPlayerController::execClearSubtitles(FFrame&, void* const)
native function ClearSubtitles();

exec function SkipBriefing()
{
    local array<SequenceObject> AllSeqEvents;
    local Sequence GameSeq;
    local int idx;
    local SeqEvent_SkipBriefingEvent pressedEvent;
    local array<int> ActivationImpulses;

    // End:0x13
    if(GetStateName() != 'BRFInTheBriefing')
    {
        return;
    }
    GameSeq = WorldInfo.GetGameSequence();
    // End:0xAF
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_SkipBriefingEvent', true, AllSeqEvents);
        ActivationImpulses[0] = 0;
        idx = 0;
        J0x5D:

        // End:0xA5 [Loop If]
        if(idx < AllSeqEvents.Length)
        {
            pressedEvent = SeqEvent_SkipBriefingEvent(AllSeqEvents[idx]);
            pressedEvent.CheckActivate(self, self, false, ActivationImpulses);
            idx++;
            // [Loop Continue]
            goto J0x5D;
        }
        ClearSubtitles();
    }
    //return;    
}

exec function SkipToJump()
{
    local float TargetTime, TickSize, LastTickSize;
    local MOHAPlayerPawn P;

    TickSize = 0.0000000;
    TargetTime = 0.0000000;
    P = MOHAPlayerPawn(Pawn);
    // End:0x4F
    if((P == none) || P.GetStateName() != 'ITPInThePlane')
    {
        return;
    }
    // End:0x75
    if(!IsLevelUnlocked(WorldInfo.CurrentMission, int(GameDifficulty)))
    {
        return;
    }
    ClearSubtitles();
    TargetTime = P.fDebugSkipWorldTimeVal;
    J0x93:

    LastTickSize = TickSize;
    TickSize = TargetTime - P.GetCurrentITPAnimPosition();
    TickSize = FClamp(TickSize, 0.0000000, P.GetCurrentITPAnimLength() - P.GetCurrentITPAnimPosition());
    WorldTick(TickSize);
    // End:0x93
    if(!(Abs(LastTickSize - TickSize) <= 0.0250000))
        goto J0x93;
    //return;    
}

event float GetShotSpread()
{
    // End:0x68
    if(((Pawn != none) && Pawn.Weapon != none) && Pawn.Weapon.IsA('EALAWeapon'))
    {
        return EALAWeapon(Pawn.Weapon).GetCursorSpread();        
    }
    else
    {
        return -1.0000000;
    }
    //return ReturnValue;    
}

function NotifyWeaponFired(Weapon W, byte FireMode)
{
    // End:0x22
    if(W.IsA('EALASmallArms'))
    {
        ClientPlayForceFeedbackWaveform(WeaponFireFFWaveform);
    }
    //return;    
}

function NotifyWeaponFinishedFiring(Weapon W, byte FireMode)
{
    //return;    
}

function int GetTeamIndex()
{
    return 0;
    //return ReturnValue;    
}

function bool IsSniperController()
{
    return false;
    //return ReturnValue;    
}

function respawn()
{
    // End:0x43
    if(WorldInfo.bNewRespawnSystem || Class'MOHAUtilities'.static.IsEditorActive())
    {
        Pawn.Destroy();
        ServerRestartPlayer();        
    }
    else
    {
        ClientTravel("?", 2);
    }
    //return;    
}

exec function MouseFire()
{
    bFireTriggeredByMouse = true;
    //return;    
}

exec function StartFire(optional byte FireModeNum)
{
    // End:0x1B
    if(PlayerCanRespawn())
    {
        respawn();        
    }
    else
    {
        // End:0x33
        if(PlayerCanUseWeapon())
        {
            super.StartFire(FireModeNum);
        }
    }
    //return;    
}

exec function StopFire(optional byte FireModeNum)
{
    super.StopFire(FireModeNum);
    bFireTriggeredByMouse = false;
    //return;    
}

exec function Reload(optional byte FireModeNum)
{
    // End:0x2C
    if((PlayerCanUseWeapon()) && PlayerCanReload())
    {
        StartReload(FireModeNum);
    }
    //return;    
}

reliable server function ServerStartReload(byte FireModeNum)
{
    // End:0x69
    if(((Pawn != none) && Pawn.Weapon != none) && Pawn.Weapon.IsA('EALASmallArms'))
    {
        EALASmallArms(Pawn.Weapon).StartReload(FireModeNum);
    }
    //return;    
}

simulated function StartReload(byte FireModeNum)
{
    // End:0x1F
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStartReload(FireModeNum);
    }
    // End:0x88
    if(((Pawn != none) && Pawn.Weapon != none) && Pawn.Weapon.IsA('EALASmallArms'))
    {
        EALASmallArms(Pawn.Weapon).StartReload(FireModeNum);
    }
    //return;    
}

exec function PCLean(float Amount)
{
    // End:0x3D
    if((Pawn != none) && Pawn.IsA('MOHAPlayerPawn'))
    {
        MOHAPlayerPawn(Pawn).fKeyboardLean = Amount;
    }
    //return;    
}

exec function PCPeek()
{
    // End:0x49
    if(((Pawn != none) && Pawn.IsA('MOHAPlayerPawn')) && IsIronsightsActive())
    {
        MOHAPlayerPawn(Pawn).bKeyboardPeek = true;
    }
    //return;    
}

exec function PCPeekRelease()
{
    // End:0x49
    if(((Pawn != none) && Pawn.IsA('MOHAPlayerPawn')) && IsIronsightsActive())
    {
        MOHAPlayerPawn(Pawn).bKeyboardPeek = false;
    }
    //return;    
}

exec event AimPress()
{
    // End:0x4B
    if(((Pawn != none) && Pawn.IsA('MOHAPlayerPawn')) && PlayerCanUseWeapon())
    {
        MOHAPlayerPawn(Pawn).AimPress();
    }
    //return;    
}

exec event AimRelease()
{
    // End:0x4B
    if(((Pawn != none) && Pawn.IsA('MOHAPlayerPawn')) && PlayerCanUseWeapon())
    {
        MOHAPlayerPawn(Pawn).AimRelease();
    }
    //return;    
}

exec function AirDropMeleePress()
{
    // End:0x3C
    if((Pawn != none) && Pawn.IsA('MOHAPlayerPawn'))
    {
        MOHAPlayerPawn(Pawn).AirDrop_MeleeEvent();
    }
    //return;    
}

exec function EnableIronsightsWalk()
{
    // End:0x26
    if(MOHAPlayerPawn(Pawn) != none)
    {
        MOHAPlayerPawn(Pawn).bIronsightsWalkEnabled = true;
    }
    //return;    
}

exec function DisableIronsightsWalk()
{
    // End:0x26
    if(MOHAPlayerPawn(Pawn) != none)
    {
        MOHAPlayerPawn(Pawn).bIronsightsWalkEnabled = false;
    }
    //return;    
}

exec function animcam()
{
    local MOHAPlayerPawn MP;

    // End:0x3B
    foreach DynamicActors(Class'MOHAPawn', MP)
    {
        // End:0x2A
        if(MP.IsPlayerPawn())
        {
            continue;            
        }
        MP.CamController = self;        
    }    
    CamOldState = GetStateName();
    GotoState('PawnCam');
    //return;    
}

exec function ShowEnterCheatMenu()
{
    local UIInteraction UIController;

    UIController = GetUIController();
    // End:0x36
    if(UIController != none)
    {
        UIController.OpenScene(UIScene'UI_Debug.UIScene_EnterCheat', LocalPlayer(Player));
    }
    //return;    
}

exec function ShowDebugMenu()
{
    local UIInteraction UIController;

    UIController = GetUIController();
    // End:0x36
    if(UIController != none)
    {
        UIController.OpenScene(UIScene'UI_Debug.UIScene_DebugMenu', LocalPlayer(Player));
    }
    //return;    
}

exec event PressEnterCheatL()
{
    bEnterCheatTriggerL = true;
    // End:0x32
    if(bEnterCheatTriggerL && bEnterCheatTriggerR)
    {
        MOHAPlayerInput(PlayerInput).bEnterCheatListen = true;
    }
    //return;    
}

exec event PressEnterCheatR()
{
    bEnterCheatTriggerR = true;
    // End:0x32
    if(bEnterCheatTriggerL && bEnterCheatTriggerR)
    {
        MOHAPlayerInput(PlayerInput).bEnterCheatListen = true;
    }
    //return;    
}

exec event ReleaseEnterCheatL()
{
    bEnterCheatTriggerL = false;
    MOHAPlayerInput(PlayerInput).ResetCheatEntry();
    //return;    
}

exec event ReleaseEnterCheatR()
{
    bEnterCheatTriggerR = false;
    MOHAPlayerInput(PlayerInput).ResetCheatEntry();
    //return;    
}

exec function ShowMenu()
{
    // End:0x20
    if(!IsLoadingScreenActive())
    {
        StopFire();
        DisplayGameMenu();
    }
    //return;    
}

exec function BlockUIInput(bool bBlockInput)
{
    local MOHAUIInteraction Controller;

    Controller = MOHAUIInteraction(GetUIController());
    Controller.BlockUIInput(bBlockInput);
    //return;    
}

exec function SetPlayerView(float Yaw, float Pitch)
{
    local Rotator NewRot;

    NewRot.Pitch = int(((float(90) - Pitch) * float(65536)) / float(360));
    NewRot.Yaw = int(((Yaw + float(90)) * float(65536)) / float(360));
    NewRot.Roll = 0;
    SetRotation(NewRot);
    //return;    
}

function DisplayGameMenu()
{
    local UIInteraction UIController;

    UIController = GetUIController();
    // End:0x5B
    if((UIController != none) && !InGameMenu.IsSceneActive())
    {
        WorldInfo.ForceGarbageCollection();
        UIController.OpenScene(InGameMenu, LocalPlayer(Player));
    }
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos, out int foundBase)
{
    super.DisplayDebug(HUD, out_YL, out_YPos, foundBase);
    // End:0x27
    if(foundBase == 0)
    {
        return;
    }
    // End:0x34
    if(Pawn == none)
    {
        return;
    }
    HUD.Canvas.__NFUN_465__("    Location:" $ string(Pawn.Location));
    HUD.Canvas.__NFUN_465__("    Rotation:" $ string(Pawn.Rotation));
    HUD.Canvas.__NFUN_465__("    DesiredRotation:" $ string(Pawn.DesiredRotation));
    out_YPos += out_YL;
    // End:0x123
    if(IsLocalPlayerController())
    {
        MOHAPlayerInput(PlayerInput).DisplayDebug(HUD, out_YL, out_YPos);
    }
    //return;    
}

event float GetPlayerAnimationPosition()
{
    local float fCurrentPosition;

    fCurrentPosition = MOHAPlayerPawn(Pawn).GetITPAnimationNormalizedPosition(MOHAPlayerPawn(Pawn).FPArms);
    // End:0x84
    if(fCurrentPosition == float(0))
    {
        fCurrentPosition = MOHAPlayerPawn(Pawn).fCurrentAnimTime / MOHAPlayerPawn(Pawn).GetITPAnimatonLength(MOHAPlayerPawn(Pawn).FPArms);
    }
    return fCurrentPosition;
    //return ReturnValue;    
}

function Rotator LimitViewRotationPitchAndYaw(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax, float ViewYawMin, float ViewYawMax)
{
    ViewRotation.Pitch = ViewRotation.Pitch & 65535;
    // End:0xBA
    if((float(ViewRotation.Pitch) > ViewPitchMax) && float(ViewRotation.Pitch) < (float(65535) + ViewPitchMin))
    {
        // End:0x9A
        if(ViewRotation.Pitch < 32768)
        {
            ViewRotation.Pitch = int(ViewPitchMax);            
        }
        else
        {
            ViewRotation.Pitch = int(float(65535) + ViewPitchMin);
        }
    }
    ViewRotation.Yaw = ViewRotation.Yaw & 65535;
    // End:0x174
    if((float(ViewRotation.Yaw) > ViewYawMax) && float(ViewRotation.Yaw) < (float(65535) + ViewYawMin))
    {
        // End:0x154
        if(ViewRotation.Yaw < 32768)
        {
            ViewRotation.Yaw = int(ViewYawMax);            
        }
        else
        {
            ViewRotation.Yaw = int(float(65535) + ViewYawMin);
        }
    }
    return ViewRotation;
    //return ReturnValue;    
}

event PlayerExitsPlane()
{
    GotoState('None');
    //return;    
}

function OnBeginPlayerITP(SeqAct_BeginPlayerITP Action)
{
    bPlayingCinematic = true;
    GotoState('ITPInThePlane');
    // End:0x43
    if(MOHAPlayerPawn(Pawn) != none)
    {
        MOHAPlayerPawn(Pawn).OnBeginPlayerITP(Action);
    }
    //return;    
}

function OnToggleWeapon(SeqAct_ToggleWeapon Action)
{
    // End:0x3A
    if(Action.InputLinks[0].bHasImpulse)
    {
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);        
    }
    else
    {
        // End:0x74
        if(Action.InputLinks[1].bHasImpulse)
        {
            MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);            
        }
        else
        {
            MOHAPlayerPawn(Pawn).SetWeaponDisabled(!MOHAPlayerPawn(Pawn).IsWeaponDisabled());
        }
    }
    //return;    
}

event NewExperienceLevelReached(MOHAIncludeClass.EWeaponType WeaponType, int iNumLevelsGained)
{
    local EALAWeapon UpgradeWeapon;

    UpgradeWeapon = MOHAInventoryManager(Pawn.InvManager).GetWeaponOfType(WeaponType);
    MOHAPlayerPawn(Pawn).WeaponUpgradeManager.StartUpgradeSequence(UpgradeWeapon, iNumLevelsGained);
    // End:0xA2
    if(playerStats != none)
    {
        playerStats.OnWeaponUpgrade(WeaponType, UpgradeWeapon.CurrentUpgradeLevel + iNumLevelsGained, UpgradeWeapon.GetMaxUpgradeLevel());
    }
    //return;    
}

function bool PerformedUseAction()
{
    // End:0x36
    if(WorldInfo.Pauser == PlayerReplicationInfo)
    {
        // End:0x34
        if(int(Role) == int(ROLE_Authority))
        {
            SetPause(false);
        }
        return true;
    }
    // End:0x59
    if((Pawn == none) || !Pawn.bCanUse)
    {
        return true;
    }
    // End:0x6B
    if(int(Role) < int(ROLE_Authority))
    {
        return false;
    }
    // End:0x95
    if(Vehicle(Pawn) != none)
    {
        return Vehicle(Pawn).DriverLeave(false);
    }
    // End:0xA4
    if(FindVehicleToDrive())
    {
        return true;
    }
    // End:0xCE
    if((MountedGun != none) && PlayerMountedOnMG())
    {
        GotoState('PlayerExitingMG');
        return true;
    }
    // End:0xEF
    if((MOHAPlayerPawn(Pawn) == none) && FindMountedGunToUse())
    {
        return true;
    }
    // End:0xFE
    if(CSATriggerInteracted())
    {
        return true;
    }
    return TriggerInteracted();
    //return ReturnValue;    
}

function bool FindMountedGunToUse()
{
    local MOHAMountedGun MG, Best;
    local Vector ViewDir, PawnLoc2D, VLoc2D;
    local float NewDot, BestDot;

    PawnLoc2D = Pawn.Location;
    PawnLoc2D.Z = 0.0000000;
    ViewDir = Vector(Pawn.Rotation);
    // End:0x105
    foreach Pawn.OverlappingActors(Class'MOHAMountedGun', MG, Pawn.VehicleCheckRadius)
    {
        VLoc2D = MG.Location;
        VLoc2D.Z = 0.0000000;
        NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
        // End:0x104
        if((Best == none) || NewDot > BestDot)
        {
            // End:0x104
            if(FastTrace(MG.Location, Pawn.Location))
            {
                Best = MG;
                BestDot = NewDot;
            }
        }        
    }    
    return (Best != none) && Best.MountGun(MOHAPawn(Pawn));
    //return ReturnValue;    
}

exec function EditActorPicker(optional bool bEditController)
{
    local Actor picked;

    // End:0xAC
    if(bEditActorPickerPicking)
    {
        picked = PickerGetCurrent();
        // End:0xAC
        if(picked != none)
        {
            // End:0x79
            if(bEditController && picked.IsA('Pawn'))
            {
                // End:0x79
                if(Pawn(picked).Controller != none)
                {
                    picked = Pawn(picked).Controller;
                }
            }            
            ConsoleCommand("editactor name=" $ string(picked.Name));
        }
    }
    bEditActorPickerPicking = !bEditActorPickerPicking;
    //return;    
}

function DrawCurrentEditActorPick()
{
    local Actor picked;
    local Box Bounds;
    local Vector Extents;

    picked = PickerGetCurrent();
    // End:0x1D
    if(picked == none)
    {
        return;
    }
    picked.GetComponentsBoundingBox(Bounds);
    Extents = (Bounds.Max - Bounds.Min) / 2.0000000;
    DrawDebugBox(picked.Location, Extents, 0, byte(255), 0);
    DrawDebugCoordinateSystem(picked.Location, rot(0, 0, 0), 300.0000000);
    //return;    
}

function Actor PickerGetCurrent()
{
    local Vector vHit, vNorm, vStart, vEnd, vExtents;

    local Rotator vRot;
    local MOHAPawn HitActor;

    GetPlayerViewPoint(vStart, vRot);
    vEnd = vStart + (Vector(vRot) * fEditActorPickerDistance);
    vExtents.X = fEditActorPickerExtents;
    vExtents.Y = fEditActorPickerExtents;
    vExtents.Z = fEditActorPickerExtents;
    // End:0xA0
    foreach TraceActors(Class'MOHAPawn', HitActor, vHit, vNorm, vEnd, vStart, vExtents)
    {        
        return HitActor;        
    }    
    return none;
    //return ReturnValue;    
}

function PawnDied(Pawn inPawn)
{
    MOHAPlayerPawn(inPawn).OwnerChangeVisibleMesh(false);
    ClearEngagedAffordance();
    // End:0x46
    if(myHUD != none)
    {
        MOHAHUD(myHUD).RemoveAllGrenadeIndicators();
    }
    // End:0x72
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        Class'Engine.TriggerVolume_SoundSpace'.static.ResetSoundSpaces();
    }
    super.PawnDied(inPawn);
    Class'Engine.JuiceSubsystem'.static.LevelEvent("Gameplay", "PlayerDeath", string(Class.Name), 0, 0.0000000, "", inPawn.Location);
    // End:0xE7
    if(KynapseEntityComponent != none)
    {
        KynapseEntityComponent.DestroyKynapseEntity();
    }
    // End:0x10A
    if(IsLocalPlayerController())
    {
        MOHAPlayerInput(PlayerInput).bUseViewAcceleration = true;
    }
    //return;    
}

simulated function OnMOHACameraShake(SeqAct_MOHACameraShake inAction)
{
    local ScreenShakeStruct MOHACameraShake;
    local float AmplitudeScale, FrequencyScale;

    AmplitudeScale = inAction.GlobalScale * inAction.GlobalAmplitudeScale;
    FrequencyScale = inAction.GlobalScale * inAction.GlobalFrequencyScale;
    MOHACameraShake = inAction.CameraShake;
    MOHACameraShake.TimeDuration *= inAction.GlobalScale;
    MOHACameraShake.RotAmplitude *= AmplitudeScale;
    MOHACameraShake.RotFrequency *= FrequencyScale;
    MOHACameraShake.LocAmplitude *= AmplitudeScale;
    MOHACameraShake.LocFrequency *= FrequencyScale;
    MOHACameraShake.FOVAmplitude *= AmplitudeScale;
    MOHACameraShake.FOVFrequency *= FrequencyScale;
    // End:0x12F
    if(inAction.InputLinks[0].bHasImpulse)
    {
        PlayCameraShake(MOHACameraShake);        
    }
    else
    {
        // End:0x174
        if(inAction.InputLinks[1].bHasImpulse)
        {
            MOHACameraShake.TimeDuration = 9999999.0000000;
            PlayCameraShake(MOHACameraShake);            
        }
        else
        {
            // End:0x1B7
            if(inAction.InputLinks[2].bHasImpulse)
            {
                MOHACameraShake.TimeDuration = -1.0000000;
                PlayCameraShake(MOHACameraShake);
            }
        }
    }
    //return;    
}

function PlayCameraShake(ScreenShakeStruct ScreenShake)
{
    // End:0x32
    if(MOHAPlayerCamera(PlayerCamera) != none)
    {
        MOHAPlayerCamera(PlayerCamera).MOHACamMod_ScreenShake.AddScreenShake(ScreenShake);
    }
    //return;    
}

function CameraShake(float Duration, Vector newRotAmplitude, Vector newRotFrequency, Vector newLocAmplitude, Vector newLocFrequency, float newFOVAmplitude, float newFOVFrequency)
{
    // End:0x54
    if(MOHAPlayerCamera(PlayerCamera) != none)
    {
        MOHAPlayerCamera(PlayerCamera).MOHACamMod_ScreenShake.StartNewShake(Duration, newRotAmplitude, newRotFrequency, newLocAmplitude, newLocFrequency, newFOVAmplitude, newFOVFrequency);
    }
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum, optional Actor DamageCauser)
{
    local Vector vPlayerToDamage_WS;
    local int hit_by_team;

    // End:0x0E
    if(Damage <= 0)
    {
        return;
    }
    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x13C
    if((myHUD != none) && InstigatedBy != none)
    {
        hit_by_team = ((KynapseAIController(InstigatedBy) != none) ? KynapseAIController(InstigatedBy).GetTeamIndex() : 1);
        // End:0x13C
        if((hit_by_team != (GetTeamIndex())) || InstigatedBy == self)
        {
            vPlayerToDamage_WS = ((DamageCauser != none) ? DamageCauser.Location - Pawn.Location : InstigatedBy.Pawn.Location - Pawn.Location);
            MOHAHUD(myHUD).NotifyHitIndicator(Rotator(vPlayerToDamage_WS));
            UpdatePostProcessEffects(DamageType, Damage, DamageCauser);
            CameraShakeHitReaction(InstigatedBy, Damage);
        }
    }
    //return;    
}

function UpdatePostProcessEffects(class<DamageType> DamageType, int Damage, optional Actor DamageCauser)
{
    local float fDistToDamageCauser, fEffectTime;

    // End:0x87
    if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
    {
        fDistToDamageCauser = ((DamageCauser != none) ? VSize(DamageCauser.Location - Pawn.Location) : 0.0000000);
        fEffectTime = PostProcessComponent.startExplosion(fDistToDamageCauser);
        MOHAPlayerPawn(Pawn).StartShellShock(fEffectTime);        
    }
    else
    {
        // End:0xAD
        if(ClassIsChildOf(DamageType, Class'MOHAMeleeDamageType'))
        {
            PostProcessComponent.startMeleeHit();            
        }
        else
        {
            // End:0xD0
            if(ClassIsChildOf(DamageType, Class'MOHABulletDamageType'))
            {
                PostProcessComponent.startBulletHit();
            }
        }
    }
    //return;    
}

function HealthUpdated(int iNewHealth)
{
    local int iVergeOfDeathHealth;

    iVergeOfDeathHealth = ((MOHAPlayerPawn(Pawn) != none) ? MOHAPlayerPawn(Pawn).iVergeOfDeathHealth : 1);
    PostProcessComponent.UpdateHealth(iNewHealth, iVergeOfDeathHealth);
    //return;    
}

function NotifyDeath()
{
    PostProcessComponent.startDying();
    playerStats.OnPlayerDeath();
    ResetCursor();
    MOHAHUD(myHUD).ResetCompassBeads();
    //return;    
}

function DeathCleanup()
{
    // End:0xD0
    if((MountedGun != none) && PlayerUsingMountedGun())
    {
        MountedGun.ReturnWeaponToMG();
        MountedGun.LeaveGun(Pawn);
        MOHAPlayerPawn(Pawn).bMountedOnMG = false;
        MOHAInventoryManager(Pawn.InvManager).SwitchToLastNonMGWeapon();
        // End:0xBB
        if(MountedGun.Weapon != none)
        {
            MOHASkeletalMeshComponent(MountedGun.Weapon.Mesh).FOV = 0.0000000;
        }
        MountedGun = none;
        GotoState('PlayerWalking');
    }
    //return;    
}

function BlindedBySpotlight(MOHAHeroSearchlightActor searchLight, bool bBlinding)
{
    // End:0x37
    if(bBlinding && !PostProcessComponent.bSpotLight)
    {
        PostProcessComponent.startSpotLight(searchLight);
    }
    // End:0x70
    if(!bBlinding && !PostProcessComponent.bStopSpotLight)
    {
        PostProcessComponent.stopSpotLight(searchLight);
    }
    //return;    
}

simulated function NotifyPickupAmmoClass(MOHAPlayerPawn.EPickupType PickupType, class<EALAAmmoInventoryClass> AmmoClass)
{
    NotifyPickup(PickupType, AmmoClass.default.DisplayName);
    //return;    
}

simulated function NotifyPickupFailureAmmoClass(MOHAPlayerPawn.EPickupType PickupType, class<EALAAmmoInventoryClass> AmmoClass)
{
    NotifyPickupFailure(PickupType, AmmoClass.default.DisplayName);
    //return;    
}

simulated function NotifyPickup(MOHAPlayerPawn.EPickupType PickupType, optional string PickupName)
{
    local array<string> LocalizedStringVars;
    local string PickupMsg;

    // End:0x3B
    if(int(PickupType) == int(2))
    {
        PostProcessComponent.startMedkit();
        self.ClientPlaySound(HealthPickupSoundCue);        
    }
    else
    {
        PostProcessComponent.startItemPickup();
    }
    // End:0xE1
    if(int(PickupType) == int(0))
    {
        // End:0xCD
        if((myHUD != none) && PickupName != "")
        {
            LocalizedStringVars[LocalizedStringVars.Length] = PickupName;
            PickupMsg = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(AmmoPickupMsg, LocalizedStringVars);
            MOHAHUD(myHUD).DisplayMessage(PickupMsg);
        }
        self.ClientPlaySound(AmmoPickupSoundCue);
    }
    //return;    
}

simulated function NotifyPickupFailure(MOHAPlayerPawn.EPickupType PickupType, optional string PickupName)
{
    local array<string> LocalizedStringVars;
    local string PickupFailedMsg;

    // End:0x103
    if(LastTouchUntouchTick < (TouchUntouchTick - 1))
    {
        // End:0xAE
        if((int(PickupType) == int(0)) && PickupName != "")
        {
            // End:0x97
            if(MOHAHUD(myHUD) != none)
            {
                LocalizedStringVars[LocalizedStringVars.Length] = PickupName;
                PickupFailedMsg = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(AmmoFullMsg, LocalizedStringVars);
                MOHAHUD(myHUD).DisplayMessage(PickupFailedMsg);
            }
            self.ClientPlaySound(AmmoPickupFailedSoundCue);            
        }
        else
        {
            // End:0x103
            if(int(PickupType) == int(2))
            {
                // End:0xEF
                if(MOHAHUD(myHUD) != none)
                {
                    MOHAHUD(myHUD).DisplayMessage(HealthFullMsg);
                }
                self.ClientPlaySound(HealthPickupFailedSoundCue);
            }
        }
    }
    LastTouchUntouchTick = TouchUntouchTick;
    //return;    
}

function CameraShakeHitReaction(Controller InstigatedBy, int Damage)
{
    local Vector vPlayerToInstigator_WS, vRotAmplitude, vRotFrequency, vZero;
    local Rotator rDamageRot;
    local float fShakeRotAmplitude;

    // End:0x0D
    if(InstigatedBy == none)
    {
        return;
    }
    vZero = vect(0.0000000, 0.0000000, 0.0000000);
    fShakeRotAmplitude = fHitShakeRotAmplitude_Min + ((fHitShakeRotAmplitude_Max - fHitShakeRotAmplitude_Min) * FClamp(float(Damage) / fHitDamageForMaxShake, 0.0000000, 1.0000000));
    vPlayerToInstigator_WS = Normal(InstigatedBy.Pawn.Location - Location);
    rDamageRot = Normalize(Rotator(vPlayerToInstigator_WS) - Pawn.Rotation);
    vRotAmplitude.X = fShakeRotAmplitude * Cos((float(rDamageRot.Yaw) * 0.0054932) * 0.0174533);
    vRotAmplitude.Z = fShakeRotAmplitude * Sin((float(rDamageRot.Yaw) * 0.0054932) * 0.0174533);
    vRotAmplitude.Y = 0.0000000;
    vRotFrequency.X = fHitShakeFrequency;
    vRotFrequency.Y = fHitShakeFrequency;
    vRotFrequency.Z = fHitShakeFrequency;
    CameraShake(fHitShakeDuration, vRotAmplitude, vRotFrequency, vZero, vZero, 0.0000000, 0.0000000);
    //return;    
}

function OnWeaponEquipped()
{
    // End:0x49
    if(((csaList.Length > 0) && csaList[0] != none) && csaList[0].IsA('MOHAWeaponCSA'))
    {
        csaList[0].bDisplayed = false;
    }
    //return;    
}

simulated function bool PlayerUsingMountedGun()
{
    return false;
    //return ReturnValue;    
}

simulated function bool PlayerMountedOnMG()
{
    return false;
    //return ReturnValue;    
}

function bool IsMountedMGState()
{
    return false;
    //return ReturnValue;    
}

event float GetFOVAngle()
{
    local float fFOV;

    fFOV = super.GetFOVAngle();
    // End:0x85
    if(Pawn != none)
    {
        // End:0x4A
        if(MOHAPlayerPawn(Pawn) != none)
        {
            fFOV = MOHAPlayerPawn(Pawn).AdjustFOVAngle(fFOV);
        }
        // End:0x85
        if(Pawn.Weapon != none)
        {
            fFOV = Pawn.Weapon.AdjustFOVAngle(fFOV);
        }
    }
    fLastFOV = fFOV;
    return fFOV;
    //return ReturnValue;    
}

exec function PreviousMenu()
{
    OpenPreviousMenu();
    //return;    
}

function DisplayMainMenu()
{
    local UIInteraction UIController;

    UIController = GetUIController();
    // End:0x52
    if(UIController != none)
    {
        UIController.OpenScene(MOHAGameViewportClient(LocalPlayer(Player).ViewportClient).MainMenuScene, LocalPlayer(Player));
    }
    //return;    
}

exec function TogServStats()
{
    m_bRequestingServerStats = !m_bRequestingServerStats;
    ClientRequestingServerStats(m_bRequestingServerStats);
    //return;    
}

simulated function ClientRequestingServerStats(bool newVal)
{
    m_bRequestingServerStats = newVal;
    ServerRequestingServerStats(m_bRequestingServerStats);
    //return;    
}

reliable server function ServerRequestingServerStats(bool newVal)
{
    m_bRequestingServerStats = newVal;
    //return;    
}

function LevelsLoaded()
{
    //return;    
}

function GotoWaitForLoad()
{
    GotoState('WaitingForLoad');
    //return;    
}

function bool CanBeSpectated()
{
    return true;
    //return ReturnValue;    
}

unreliable server function ServerViewNextPlayer()
{
    ServerViewAPlayer(1);
    //return;    
}

unreliable server function ServerViewPrevPlayer()
{
    ServerViewAPlayer(-1);
    //return;    
}

function ServerViewAPlayer(int Dir)
{
    local array<PlayerReplicationInfo> PRIList;
    local PlayerReplicationInfo PRI;
    local Controller C;
    local int I, Index;

    Index = -1;
    // End:0x146
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        PRI = C.PlayerReplicationInfo;
        // End:0x145
        if((C != self) && WorldInfo.Game.CanSpectate(self, PRI))
        {
            I = 0;
            J0x74:

            // End:0xB8 [Loop If]
            if(I < PRIList.Length)
            {
                // End:0xAE
                if(PRIList[I].Score < PRI.Score)
                {
                    // [Explicit Break]
                    goto J0xB8;
                }
                I++;
                // [Loop Continue]
                goto J0x74;
            }
            J0xB8:

            // End:0xFE
            if(I < PRIList.Length)
            {
                PRIList.Insert(I, 1);
                // End:0xEA
                if(Index >= I)
                {
                    Index++;
                }
                PRIList[I] = PRI;                
            }
            else
            {
                PRIList.Length = I + 1;
                PRIList[I] = PRI;
            }
            // End:0x145
            if((RealViewTarget != none) && PRI == RealViewTarget)
            {
                Index = I;
            }
        }        
    }    
    // End:0x21E
    if(PRIList.Length > 0)
    {
        Index += Dir;
        // End:0x179
        if(Index >= PRIList.Length)
        {
            Index = 0;            
        }
        else
        {
            // End:0x193
            if(Index < 0)
            {
                Index = PRIList.Length - 1;
            }
        }
        ClientSetViewTargetPawn(MOHAPawn(Controller(PRIList[Index].Owner).Pawn));
        SetViewTarget(Controller(PRIList[Index].Owner).Pawn);
        ClientSetViewTarget(Controller(PRIList[Index].Owner).Pawn);
    }
    //return;    
}

unreliable client simulated function ClientSetViewTargetPawn(MOHAPawn P)
{
    // End:0x16
    if(P != none)
    {
        ViewTargetPawn = P;
    }
    //return;    
}

unreliable server function ServerViewSelf()
{
    SetLocation(ViewTarget.Location);
    SetViewTarget(self);
    //return;    
}

exec function ViewObjective()
{
    ServerViewObjective();
    //return;    
}

unreliable server function ServerViewObjective()
{
    //return;    
}

function ServerSpectate()
{
    GotoState('Spectating');
    //return;    
}

function bool CheckSystemPausable()
{
    return ((WorldInfo != none) && WorldInfo.CanExternalUIPause) && int(WorldInfo.NetMode) == int(NM_Standalone);
    //return ReturnValue;    
}

function OnGameInviteAccepted(OnlineGameSettings GameInviteSettings)
{
    //return;    
}

function OnExternalUIChanged(bool bIsOpening)
{
    // End:0x13
    if(bIsOpening)
    {
        KillVibration();
    }
    //return;    
}

function OnControllerChanged(int ControllerId, bool bIsConnected)
{
    //return;    
}

function KillVibration()
{
    ForceFeedbackManager.PauseWaveform(true);
    //return;    
}

simulated function float GetFireAxis()
{
    // End:0x2C
    if((PlayerInput == none) || !PlayerInput.IsA('MOHAPlayerInput'))
    {
        return 0.0000000;
    }
    return ((!bFireTriggeredByMouse) ? MOHAPlayerInput(PlayerInput).RawFireDown : 1.0000000);
    //return ReturnValue;    
}

simulated function SetCurrentExperience(optional EALAWeapon ExpWeapon)
{
    local class<EALAWeapon> ExpWeaponClass;

    // End:0x23
    if(ExpWeapon != none)
    {
        ExpWeaponClass = ExpWeapon.Class;        
    }
    else
    {
        // End:0x61
        if(EALAWeapon(Pawn.Weapon) != none)
        {
            ExpWeaponClass = class<EALAWeapon>(Pawn.Weapon.Class);            
        }
        else
        {
            return;
        }
    }
    playerStats.SetCurrentExperienceComponent(ExpWeaponClass);
    //return;    
}

simulated function MOHAWeaponExperienceComponent GetCurrentExperience()
{
    return playerStats.GetCurrentWeaponExpComponent();
    //return ReturnValue;    
}

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
    super.NotifyChangedWeapon(PreviousWeapon, NewWeapon);
    SetCurrentExperience(EALAWeapon(NewWeapon));
    //return;    
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    // End:0x188
    if(Pawn != none)
    {
        Stimulus.SetProxyActor(Pawn);
        Stimulus.AttachSender('PlayerPresence', 'PlayerPresence', vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
        Stimulus.AttachListener('PlayerPresenceCC', 'PlayerPresenceCC', OnPlayerPresenceCB, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
        Stimulus.AttachListener('TakeFire', 'BulletImpact', FireNear, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
        Stimulus.AttachSender('GTFO', 'GTFO', vect(45.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
        KynapseEntityComponent.InitForKynapse();
        // End:0x188
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            SetTimer(1.0000000, true, 'BroadcastNearbyScriptedAID');
        }
    }
    //return;    
}

function BroadcastFriendlyFireGTFOStimulus(MOHAAIPawn DamageTarget)
{
    local Vector vDirToPlayer;

    vDirToPlayer = Normal(Pawn.Location - DamageTarget.Location);
    Stimulus.AttachSender('GTFO2', 'GTFO', DamageTarget.Location + (vDirToPlayer * 15.0000000), rot(0, 0, 0),,, true, true);
    Stimulus.PushStimuliSenderParamInt('GTFO2', 'ForceActivate', 1);
    //return;    
}

function OnPlayerPresenceCB(out StimulusListenerSubscription Listener, out StimulusSenderSubscription Sender)
{
    local MOHAScriptAIController C;

    C = MOHAScriptAIController(Sender.Owner.Owner);
    // End:0x5A
    if(C != none)
    {
        C.OnPlayerPresence(self, Sender.Sender.TimeBetweenSends);
    }
    //return;    
}

function BroadcastNearbyScriptedAID()
{
    local CCStimulus CCS;

    // End:0xB9
    if((CurrentAffordanceNode != none) && MOHAAffordanceAIDComponent(CurrentAffordanceNode.AIDComponent) != none)
    {
        CCS.StimulusType = MOHAAffordanceAIDComponent(CurrentAffordanceNode.AIDComponent).GetNextSpokenEarshot();
        // End:0xB9
        if(CCS.StimulusType != none)
        {
            CCS.SourceActor = Pawn;
            MOHAGameInfo(WorldInfo.Game).GlobalCCDirector.BroadcastStimulus(CCS, 3000.0000000, 1, false);
        }
    }
    //return;    
}

// Export UMOHAPlayerController::execIsUnengagedInAffordance(FFrame&, void* const)
native function bool IsUnengagedInAffordance();

// Export UMOHAPlayerController::execAddEngagedAffordance(FFrame&, void* const)
native function AddEngagedAffordance(AffordanceNodeVolume engaged);

// Export UMOHAPlayerController::execClearEngagedAffordance(FFrame&, void* const)
native function ClearEngagedAffordance();

function CheckUnengagedInAffordance()
{
    // End:0x32
    if(IsUnengagedInAffordance())
    {
        UnengagedTime -= 1.0000000;
        // End:0x32
        if(UnengagedTime <= 0.0000000)
        {
            UnengagedAffordance();
        }
    }
    //return;    
}

event OnEngagedAffordance(AffordanceNodeVolume engaged)
{
    UnengagedTime = default.UnengagedTime;
    SetTimer(1.0000000, true, 'CheckUnengagedInAffordance');
    engaged.TriggerEventClass(Class'EAKynapse.SeqEvent_OnAffordanceFightEngaged', self, 0);
    //return;    
}

event UnengagedAffordance()
{
    ClearTimer('CheckUnengagedInAffordance');
    TriggerOnAffordanceFightDisengaged();
    //return;    
}

function TriggerOnAffordanceFightDisengaged()
{
    local array<SequenceObject> AllConsoleEvents;
    local SeqEvent_OnAffordanceFightDisengaged affEvent;
    local Sequence GameSeq;
    local int idx;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0x90
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'EAKynapse.SeqEvent_OnAffordanceFightDisengaged', true, AllConsoleEvents);
        idx = 0;
        J0x41:

        // End:0x90 [Loop If]
        if(idx < AllConsoleEvents.Length)
        {
            affEvent = SeqEvent_OnAffordanceFightDisengaged(AllConsoleEvents[idx]);
            // End:0x86
            if(affEvent != none)
            {
                affEvent.CheckActivate(self, self);
            }
            idx++;
            // [Loop Continue]
            goto J0x41;
        }
    }
    //return;    
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    super.ClientRestart(NewPawn);
    PostProcessComponent.Init(self);
    // End:0x47
    if(MOHAHUD(myHUD) != none)
    {
        MOHAHUD(myHUD).ClientRestart();
    }
    //return;    
}

event UnPossess()
{
    Stimulus.SetProxyActor(none);
    super.UnPossess();
    //return;    
}

exec function StartAltFire(optional byte FireModeNum)
{
    StartFire(FireModeNum);
    //return;    
}

exec function StopAltFire(optional byte FireModeNum)
{
    StopFire(FireModeNum);
    //return;    
}

reliable server function ServerActiveWeaponPostBegin()
{
    Pawn.InvManager.SwitchToBestWeapon(true);
    //return;    
}

function SpawnParachute()
{
    Pawn.SetPhysics(11);
    GotoState('Airdrop');
    Pawn.GotoState('AirDropControlledFall');
    //return;    
}

function bool DemoChargeTimeDone()
{
    return false;
    //return ReturnValue;    
}

exec function MountMG(MOHAMountedGunCSA gun)
{
    MountedGun = gun;
    GotoState('PlayerMountingMG');
    //return;    
}

function AddCSA(MOHACSA csa)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < csaList.Length)
    {
        // End:0x2E
        if(csaList[I] == csa)
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    csaList[csaList.Length] = csa;
    //return;    
}

function RemoveCSA(MOHACSA csa)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xA1 [Loop If]
    if(I < csaList.Length)
    {
        // End:0x97
        if((csaList[I] != none) && csaList[I] == csa)
        {
            // End:0x89
            if(true == csaList[I].bDisplayed)
            {
                MOHAHUD(myHUD).RemoveCSA();
                csaList[I].bDisplayed = false;
            }
            csaList.Remove(I, 1);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function bool CSATriggerInteracted()
{
    local MOHACSA csa;

    // End:0x8B
    if(GetHighestPriorityCSA(csa))
    {
        // End:0x72
        if((csa.IsA('MOHAWeaponCSA') || csa.IsA('MOHAMountedGunCSA')) || csa.IsA('MOHAPickupCrateCSA'))
        {
            SetTimer(WeaponCSAUseHoldTime, false, 'WeaponCSAHoldTimeExpired');            
        }
        else
        {
            return csa.UsedBy(Pawn);
        }
    }
    return false;
    //return ReturnValue;    
}

function bool GetHighestPriorityCSA(out MOHACSA csa)
{
    // End:0x28
    if((Pawn != none) && csaList.Length > 0)
    {
        csa = csaList[0];
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool GetDemoChargePosAndRot(out Vector vDemoChargePos, out Rotator rDemoChargeRot)
{
    // End:0x3B
    if(csaList[0] != none)
    {
        vDemoChargePos = csaList[0].Location;
        rDemoChargeRot = csaList[0].Rotation;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ClearCSAList()
{
    // End:0x23
    if(myHUD != none)
    {
        MOHAHUD(myHUD).RemoveCSA();
    }
    csaList.Remove(0, csaList.Length);
    //return;    
}

event UpdateCSAList()
{
    local int I, J, Max;
    local float dotProduct, csaDistance;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local MOHACSA swapCSA;
    local float CSARadiusBuffer;
    local MOHACSA LastBestCSA;

    // End:0x5C5
    if((Pawn != none) && csaList.Length != 0)
    {
        GetPlayerViewPoint(cameraLoc, cameraRot);
        I = csaList.Length - 1;
        J0x3C:

        // End:0x3F4 [Loop If]
        if(I >= 0)
        {
            // End:0x67
            if(csaList[I] == none)
            {
                csaList.Remove(I, 1);
                // [Explicit Continue]
                goto J0x3EA;
            }
            // End:0xF2
            if(!csaList[I].IsUsableBy(self))
            {
                csaList[I].bDirty = true;
                // End:0xEF
                if(csaList[I].bDisplayed)
                {
                    // End:0xD8
                    if(myHUD != none)
                    {
                        MOHAHUD(myHUD).RemoveCSA();
                    }
                    csaList[I].bDisplayed = false;
                }
                // [Explicit Continue]
                goto J0x3EA;
            }
            CSARadiusBuffer = csaList[I].CylinderComponent.CollisionRadius + 100.0000000;
            csaDistance = VSize(csaList[I].GetPosition() - Pawn.Location);
            // End:0x25E
            if(csaDistance < csaList[I].CylinderComponent.CollisionRadius)
            {
                dotProduct = Normal(csaList[I].Location - cameraLoc) Dot Vector(cameraRot);
                // End:0x244
                if(csaList[I].bLookAt && dotProduct < csaList[I].fLookAtThreshold)
                {
                    csaList[I].bDirty = true;
                    // End:0x241
                    if(csaList[I].bDisplayed)
                    {
                        // End:0x22A
                        if(myHUD != none)
                        {
                            MOHAHUD(myHUD).RemoveCSA();
                        }
                        csaList[I].bDisplayed = false;
                    }                    
                }
                else
                {
                    csaList[I].bDirty = false;
                }                
            }
            else
            {
                // End:0x302
                if((csaDistance > csaList[I].CylinderComponent.CollisionRadius) && csaDistance < CSARadiusBuffer)
                {
                    // End:0x2E8
                    if(csaList[I].bDisplayed)
                    {
                        // End:0x2D1
                        if(myHUD != none)
                        {
                            MOHAHUD(myHUD).RemoveCSA();
                        }
                        csaList[I].bDisplayed = false;
                    }
                    csaList[I].bDirty = true;                    
                }
                else
                {
                    // End:0x329
                    if(csaDistance > CSARadiusBuffer)
                    {
                        RemoveCSA(csaList[I]);
                        // [Explicit Continue]
                        goto J0x3EA;
                    }
                }
            }
            csaList[I].fWeight = dotProduct;
            csaList[I].fWeight += (1.0000000 - (VSize(csaList[I].Location - Pawn.Location) / InteractDistance));
            csaList[I].fWeight += csaList[I].fWeightScale;
            // End:0x3EA
            if(csaList[I].bDirty)
            {
                csaList[I].fWeight -= 100.0000000;
            }
            J0x3EA:

            I--;
            // [Loop Continue]
            goto J0x3C;
        }
        // End:0x5C5
        if(csaList.Length != 0)
        {
            LastBestCSA = csaList[0];
            I = 0;
            J0x414:

            // End:0x4D5 [Loop If]
            if(I < (csaList.Length - 1))
            {
                Max = I;
                J = I + 1;
                J0x440:

                // End:0x492 [Loop If]
                if(J < csaList.Length)
                {
                    // End:0x488
                    if(csaList[J].fWeight > csaList[Max].fWeight)
                    {
                        Max = J;
                    }
                    J++;
                    // [Loop Continue]
                    goto J0x440;
                }
                swapCSA = csaList[I];
                csaList[I] = csaList[Max];
                csaList[Max] = swapCSA;
                I++;
                // [Loop Continue]
                goto J0x414;
            }
            // End:0x52C
            if(LastBestCSA != csaList[0])
            {
                // End:0x52C
                if(LastBestCSA.bDisplayed)
                {
                    LastBestCSA.bDisplayed = false;
                    // End:0x52C
                    if(myHUD != none)
                    {
                        MOHAHUD(myHUD).RemoveCSA();
                    }
                }
            }
            // End:0x5C5
            if(((csaList.Length != 0) && !csaList[0].bDisplayed) && !csaList[0].bDirty)
            {
                csaList[0].bDisplayed = true;
                // End:0x5C5
                if(myHUD != none)
                {
                    MOHAHUD(myHUD).DisplayCSA(csaList[0].GetCSAText(self), csaList[0].bForceRender);
                }
            }
        }
    }
    //return;    
}

function TakeScreenshotNextFrame(string Text)
{
    ClientMessage(Text);
    SetTimer(0.1000000,, 'LatentScreenshot');
    //return;    
}

function LatentScreenshot()
{
    ConsoleCommand("SCREENSHOT");
    //return;    
}

event DrawDebug3DText(coerce string Text, Vector Position, byte R, byte G, byte B, bool b3D)
{
    MOHAHUD(myHUD).DrawDebug3DText(Text, Position, R, G, B, b3D);
    //return;    
}

function ForceExitIronSights()
{
    local MOHAPlayerPawn MOHAPawn;

    MOHAPawn = MOHAPlayerPawn(Pawn);
    // End:0xD3
    if(MOHAPawn != none)
    {
        // End:0x70
        if(MOHAPawn.IsIronsightsActive() && EALASmallArms(MOHAPawn.Weapon) != none)
        {
            EALASmallArms(MOHAPawn.Weapon).ExitIronSights();            
        }
        else
        {
            // End:0xD3
            if((EALAWeapon(MOHAPawn.Weapon) != none) && int(EALAWeapon(MOHAPawn.Weapon).IronsightsState) == int(3))
            {
                EALAWeapon(MOHAPawn.Weapon).ExitIronSights();
            }
        }
    }
    //return;    
}

function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons)
{
    local MOHAPlayerPawn MOHAPawn;

    MOHAPawn = MOHAPlayerPawn(Pawn);
    // End:0x47
    if(MOHAPawn != none)
    {
        // End:0x2E
        if(bInCinematicMode)
        {
            ForceExitIronSights();
        }
        MOHAPawn.SetWeaponDisabled(bInCinematicMode);
    }
    bCanJumpOrDuck = !bInCinematicMode;
    bGodMode = bInCinematicMode;
    // End:0xEE
    if(bInCinematicMode)
    {
        // End:0xB0
        if(Pawn.GetStateName() != 'BRFInTheBriefing')
        {
            MOHAGameInfo(WorldInfo.Game).GlobalCCDirector.DisableAID();
        }
        bCineSavedCollideActors = Pawn.bCollideActors;
        bCineSavedBlockActors = Pawn.bBlockActors;
        Pawn.SetCollision(false, false);        
    }
    else
    {
        MOHAGameInfo(WorldInfo.Game).GlobalCCDirector.EnableAID();
        Pawn.SetCollision(bCineSavedCollideActors, bCineSavedBlockActors);
    }
    super.SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons);
    //return;    
}

exec function testHealthUpdate(int iHealth)
{
    PostProcessComponent.UpdateHealth(iHealth);
    //return;    
}

exec function testStartMeleeHit()
{
    PostProcessComponent.startMeleeHit();
    //return;    
}

exec function testStartSpotLight()
{
    PostProcessComponent.startSpotLight();
    //return;    
}

exec function testStopSpotLight()
{
    PostProcessComponent.stopSpotLight();
    //return;    
}

exec function testStartDying()
{
    PostProcessComponent.startDying();
    //return;    
}

exec function testStopDying()
{
    PostProcessComponent.stopDying();
    //return;    
}

exec function testStartMedkit()
{
    PostProcessComponent.startMedkit();
    //return;    
}

exec function testStartItemPickup()
{
    PostProcessComponent.startItemPickup();
    //return;    
}

exec function testStartBulletHit()
{
    PostProcessComponent.startBulletHit();
    //return;    
}

exec function testStartExplosion(float Value)
{
    PostProcessComponent.startExplosion(Value);
    //return;    
}

function DrawAffordanceAID(Canvas Canvas)
{
    Canvas.SetPos(0.0000000, float(Canvas.SizeY / 3));
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    // End:0x7E
    if(CurrentAffordanceNode == none)
    {
        Canvas.__NFUN_465__("Not inside an AffordanceNode");        
    }
    else
    {
        Canvas.__NFUN_465__("Stimuli for AffordanceNode: " $ string(CurrentAffordanceNode));
        // End:0xF2
        if(MOHAAffordanceAIDComponent(CurrentAffordanceNode.AIDComponent) != none)
        {
            MOHAAffordanceAIDComponent(CurrentAffordanceNode.AIDComponent).DrawAffordanceAID(Canvas);
        }
    }
    //return;    
}

function DrawAffordanceUnitTests(Canvas Canvas)
{
    Canvas.SetPos(float(Canvas.SizeX / 7), float(Canvas.SizeY / 3));
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    // End:0x8D
    if(CurrentAffordanceNode == none)
    {
        Canvas.__NFUN_465__("Not inside an AffordanceNode");        
    }
    else
    {
        Canvas.__NFUN_465__("Affordance Unit Tests: " $ string(CurrentAffordanceNode));
        CurrentAffordanceNode.RunUnitTests(Canvas, self);
    }
    //return;    
}

simulated function RegisterPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local class<UIDataStore_MOHAPlayerStats> PlayerStatsDataStoreClass;
    local UIDataStore_MOHAPlayerData MOHAPlayerData;
    local class<UIDataStore_MOHAPlayerData> PlayerDataStoreClass;

    LP = LocalPlayer(Player);
    // End:0x200
    if(LP != none)
    {
        DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
        // End:0x200
        if(DataStoreManager != none)
        {
            CurrentStatsData = UIDataStore_MOHAPlayerStats(DataStoreManager.FindDataStore('MOHAPlayerStats', LP));
            // End:0xE4
            if(CurrentStatsData == none)
            {
                PlayerStatsDataStoreClass = class<UIDataStore_MOHAPlayerStats>(DataStoreManager.FindDataStoreClass(Class'UIDataStore_MOHAPlayerStats'));
                // End:0xE1
                if(PlayerStatsDataStoreClass != none)
                {
                    CurrentStatsData = DataStoreManager.CreateDataStore(PlayerStatsDataStoreClass);
                    // End:0xDE
                    if(CurrentStatsData != none)
                    {
                        // End:0xDB
                        if(!DataStoreManager.RegisterDataStore(CurrentStatsData, LP))
                        {
                        }                        
                    }                    
                }                
            }
            MOHAPlayerData = UIDataStore_MOHAPlayerData(DataStoreManager.FindDataStore('MOHAPlayerData', LP));
            // End:0x18A
            if(MOHAPlayerData == none)
            {
                PlayerDataStoreClass = class<UIDataStore_MOHAPlayerData>(DataStoreManager.FindDataStoreClass(Class'UIDataStore_MOHAPlayerData'));
                // End:0x18A
                if(PlayerDataStoreClass != none)
                {
                    MOHAPlayerData = DataStoreManager.CreateDataStore(PlayerDataStoreClass);
                    // End:0x187
                    if(MOHAPlayerData != none)
                    {
                        // End:0x184
                        if(!DataStoreManager.RegisterDataStore(MOHAPlayerData, LP))
                        {
                        }                        
                    }                    
                }
            }
            // End:0x200
            if((MOHAPlayerData != none) && MOHAPlayerData.ProfileProvider != none)
            {
                ProfileSettings = MOHAProfileSettings(MOHAPlayerData.ProfileProvider.Profile);
                // End:0x1ED
                if(ProfileSettings.SettingsHaveBeenLoaded())
                {
                    UpdateLocalCacheOfProfileSettings();
                }
                ProfileSettings.DumpProfileSettings();
            }
        }
    }
    playerStats.BindStatsDataProvider();
    super.RegisterPlayerDataStores();
    //return;    
}

simulated function UnregisterPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;

    LP = LocalPlayer(Player);
    // End:0x69
    if(LP != none)
    {
        DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
        // End:0x69
        if(DataStoreManager != none)
        {
            // End:0x69
            if(CurrentStatsData != none)
            {
                // End:0x5F
                if(!DataStoreManager.UnregisterDataStore(CurrentStatsData))
                {
                }
                CurrentStatsData = none;                
            }
        }
    }
    super.UnregisterPlayerDataStores();
    //return;    
}

exec function CalculateMissionRating()
{
    playerStats.CalculateMissionRating();
    //return;    
}

exec function LogGlobalStats()
{
    playerStats.LogGlobalStats();
    //return;    
}

simulated function OnMissionComplete(SeqAct_MissionComplete Action)
{
    // End:0x23
    if(playerStats != none)
    {
        playerStats.OnMissionComplete(Action);
    }
    //return;    
}

simulated function OnAddInventory(Inventory NewItem)
{
    // End:0x23
    if(playerStats != none)
    {
        playerStats.OnAddInventory(NewItem);
    }
    //return;    
}

simulated function OnKickGrenade()
{
    // End:0x1E
    if(playerStats != none)
    {
        playerStats.OnKickGrenade();
    }
    //return;    
}

simulated function OnWeaponHit(MOHAIncludeClass.EWeaponType WeaponType, name BoneName, Pawn HitPawn, class<DamageType> HitDamageType, bool FatalHit)
{
    // End:0x38
    if(playerStats != none)
    {
        playerStats.OnWeaponHit(WeaponType, BoneName, HitPawn, HitDamageType, FatalHit);
    }
    // End:0x5B
    if(myHUD != none)
    {
        MOHAHUD(myHUD).OnNotifyWeaponHit();
    }
    //return;    
}

simulated function OnSkillDropLanding(SeqAct_SkillDropLanding Action)
{
    // End:0x2C
    if(playerStats != none)
    {
        playerStats.OnSkillDropLanding(Action.SkillDropId);
    }
    //return;    
}

reliable client simulated event ClientCommitMapChange(optional bool bShouldSkipLevelStartupEvent, optional bool bShouldSkipLevelBeginningEvent)
{
    SaveLoadClear();
    super.ClientCommitMapChange(bShouldSkipLevelStartupEvent, bShouldSkipLevelBeginningEvent);
    //return;    
}

reliable client simulated function ClientSetRichPresence()
{
    local LocalPlayer LocPlayer;
    local LocalizedStringSetting Setting;
    local array<LocalizedStringSetting> Contexts;
    local array<SettingsProperty> Properties;
    local name MapName;
    local int MapContextValue;
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAGameResource GameDataStore;
    local string GameMode;
    local Plasma P;

    LocPlayer = LocalPlayer(Player);
    P = Class'Plasma.Plasma'.static.GetPlasma();
    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x6D
    if(DataStoreManager != none)
    {
        GameDataStore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
    }
    // End:0x39F
    if(LocPlayer != none)
    {
        MapName = name(GetURLMap());
        // End:0xF6
        if(((MapName == 'shell') && GameDataStore != none) && GameDataStore.bPlayerInputSelected)
        {
            Class'Plasma.Plasma'.static.GetPlasma().SetRichPresence(byte(LocPlayer.ControllerId), 1, Contexts, Properties);            
        }
        else
        {
            MapContextValue = DetermineMapStringId(name(GetURLMap()));
            // End:0x39F
            if(MapContextValue != -1)
            {
                // End:0x1E7
                if(int(WorldInfo.NetMode) == int(NM_Standalone))
                {
                    Setting.Id = 2;
                    Setting.ValueIndex = MapContextValue;
                    Contexts[Contexts.Length] = Setting;
                    Setting.Id = 3;
                    Setting.ValueIndex = int(GameDifficulty);
                    Contexts[Contexts.Length] = Setting;
                    Class'Plasma.Plasma'.static.GetPlasma().SetRichPresence(byte(LocPlayer.ControllerId), 2, Contexts, Properties);                    
                }
                else
                {
                    Setting.Id = 5;
                    Setting.ValueIndex = MapContextValue;
                    Contexts[Contexts.Length] = Setting;
                    Setting.Id = 4;
                    GameMode = P.CurrentGameOptions.GameType;
                    // End:0x281
                    if(GameMode == "ObjectiveAirborne")
                    {
                        Setting.ValueIndex = 0;                        
                    }
                    else
                    {
                        // End:0x2AF
                        if(GameMode == "TeamDeathmatch")
                        {
                            Setting.ValueIndex = 1;                            
                        }
                        else
                        {
                            // End:0x2E3
                            if(GameMode == "TeamDeathmatchAirborne")
                            {
                                Setting.ValueIndex = 2;
                            }
                        }
                    }
                    Contexts[Contexts.Length] = Setting;
                    Setting.Id = 6;
                    // End:0x33F
                    if(Class'Plasma.Plasma'.static.GetPlasma().isRanked())
                    {
                        Setting.ValueIndex = 0;                        
                    }
                    else
                    {
                        Setting.ValueIndex = 1;
                    }
                    Contexts[Contexts.Length] = Setting;
                    Class'Plasma.Plasma'.static.GetPlasma().SetRichPresence(byte(LocPlayer.ControllerId), 3, Contexts, Properties);
                }
            }
        }
    }
    //return;    
}

function int DetermineMapStringId(name MapName)
{
    local int SearchIndex;

    SearchIndex = 0;
    J0x07:

    // End:0x56 [Loop If]
    if(SearchIndex < MapNamesToContextValues.Length)
    {
        // End:0x4C
        if(MapName == MapNamesToContextValues[SearchIndex].MapName)
        {
            return MapNamesToContextValues[SearchIndex].ContextValue;
        }
        SearchIndex++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function OnPlayerStatsNotify(MOHAIncludeClass.EHUDNotifications Type)
{
    // End:0x33
    if(int(Type) == int(2))
    {
        BroadcastStimulusToNearbyAllies(5000.0000000, "MultipleEnemyKills");
    }
    //return;    
}

function BroadcastStimulusToNearbyAllies(float Radius, string StimulusTypeName)
{
    local CCStimulus CCS;

    CCS.StimulusType = CCStimulusType(DynamicLoadObject("MOHA_CC.Stimuli." $ StimulusTypeName, Class'CCStimulusType', false));
    CCS.SourceActor = Pawn;
    MOHAGameInfo(WorldInfo.Game).GlobalCCDirector.BroadcastStimulus(CCS, Radius, 1);
    //return;    
}

event InitInputSystem()
{
    super.InitInputSystem();
    MOHAPlayerInput(PlayerInput).InitBindings();
    // End:0x4A
    if(!WorldInfo.IsConsoleBuild())
    {
        MOHAPlayerInput(PlayerInput).InitMouseSensitivity();
    }
    //return;    
}

exec function UpdateLocalCacheOfProfileSettings()
{
    // End:0x1F9
    if(ProfileSettings != none)
    {
        PlayerInput.bInvertMouse = ProfileSettings.GetInvertMouseOption();
        MOHAPlayerInput(PlayerInput).SetBindings(ProfileSettings.GetControllerSchemeOption());
        MOHAPlayerInput(PlayerInput).SetAimSensitivity(ProfileSettings.GetAimSensitivityOption());
        PlayerReplicationInfo.bControllerVibrationAllowed = ProfileSettings.GetControllerVibrationOption();
        SetAudioVolume('MusicVolume', ProfileSettings.GetAudioMusicVolume());
        SetAudioVolume('SFXVolume', ProfileSettings.GetAudioSFXVolume());
        SetGamma(ProfileSettings.GetGammaSetting());
        GameDifficulty = byte(ProfileSettings.GetDifficultyOption());
        SetShowSubtitles(ProfileSettings.GetSubtitleConfigOption());
        bShowCompass = ProfileSettings.GetToggleCompassOption();
        // End:0x190
        if(MOHAHUD(myHUD) != none)
        {
            MOHAHUD(myHUD).ToggleCompass(bShowCompass);
        }
        // End:0x1BC
        if(!WorldInfo.IsConsoleBuild())
        {
            MOHAPlayerInput(PlayerInput).UpdateMouseSensitivity();
        }
        // End:0x1F6
        if(MOHAPlayerPawn(Pawn) != none)
        {
            MOHAPlayerPawn(Pawn).bDisableSprintFX = !ProfileSettings.GetSprintEffectsOption();
        }        
    }
    //return;    
}

exec function DumpPlayerSettings()
{
    // End:0x31
    if(ProfileSettings != none)
    {
        ProfileSettings.DumpProfileSettings();
        ProfileSettings.DumpLevelUnlockSettings();
    }
    //return;    
}

exec function ResetPlayerSettings()
{
    // End:0x1E
    if(ProfileSettings != none)
    {
        ProfileSettings.SetToDefaults();
    }
    //return;    
}

function bool IsLevelUnlocked(int Level, int Difficulty)
{
    // End:0x2C
    if(ProfileSettings != none)
    {
        return ProfileSettings.IsLevelUnlocked(Level, Difficulty);        
    }
    //return ReturnValue;    
}

function UnlockLevel(int Level, int Difficulty)
{
    local int currentDiff;

    // End:0x4B
    if(ProfileSettings != none)
    {
        currentDiff = 0;
        J0x12:

        // End:0x48 [Loop If]
        if(currentDiff <= Difficulty)
        {
            ProfileSettings.UnlockLevelByDifficulty(Level, currentDiff);
            currentDiff++;
            // [Loop Continue]
            goto J0x12;
        }        
    }
    //return;    
}

event bool HasCompletedLevel(int Level, int Difficulty)
{
    // End:0x2C
    if(ProfileSettings != none)
    {
        return ProfileSettings.HasCompletedLevel(Level, Difficulty);        
    }
    return false;
    //return ReturnValue;    
}

event bool GetGameComplete(int Difficulty)
{
    // End:0x27
    if(ProfileSettings != none)
    {
        return ProfileSettings.GetGameComplete(Difficulty);        
    }
    return false;
    //return ReturnValue;    
}

function OnHUDMessage(SeqAct_HUDMessage Action)
{
    local string ReplacedText;

    // End:0xD0
    if(MOHAHUD(myHUD) != none)
    {
        // End:0xB8
        if(Action.InputLinks[0].bHasImpulse)
        {
            ReplacedText = Action.Message;
            ReplaceText(ReplacedText, "%b", GetUseButtonToken());
            MOHAHUD(myHUD).DisplayMessage(ReplacedText, Action.fDisplayTime, Action.fPosX, Action.fPosY, Action.bRenderEvenWhenHUDOff);            
        }
        else
        {
            MOHAHUD(myHUD).RemoveMessage();
        }
    }
    //return;    
}

function bool IsCheatActive(MOHAIncludeClass.ECheatType CheatType)
{
    local MOHAPlayerReplicationInfo PRI;

    PRI = MOHAPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x3D
    if(PRI != none)
    {
        return PRI.SPCheatFlags[int(CheatType)].bIsActive;
    }
    return false;
    //return ReturnValue;    
}

event bool IsAnyCheatActive()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x33 [Loop If]
    if(I < 8)
    {
        // End:0x29
        if(IsCheatActive(byte(I)))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function bool ToggleCheat(MOHAIncludeClass.ECheatType CheatType)
{
    local MOHAPlayerReplicationInfo PRI;

    PRI = MOHAPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x82
    if(PRI != none)
    {
        PRI.SPCheatFlags[int(CheatType)].bIsActive = !PRI.SPCheatFlags[int(CheatType)].bIsActive;
        return PRI.SPCheatFlags[int(CheatType)].bIsActive;
    }
    return false;
    //return ReturnValue;    
}

function ClearCheats()
{
    local MOHAPlayerReplicationInfo PRI;

    PRI = MOHAPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x1D
    if(PRI == none)
    {
        return;
    }
    bUsedCheat = false;
    PRI.ClearCheatFlags();
    //return;    
}

function bool GetSprintFXSetting()
{
    // End:0x22
    if(ProfileSettings != none)
    {
        return ProfileSettings.GetSprintEffectsOption();        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

event PauseGameNoUI(bool bPause)
{
    local string pauseStr;

    // End:0xC0
    if((CheckSystemPausable()) && myHUD != none)
    {
        WorldInfo.bPauseUpdatesPlayerCamera = bPause;
        // End:0x9C
        if(bPause)
        {
            pauseStr = Localize("GeneralStrings", "Paused", "UIStrings");
            MOHAHUD(myHUD).DisplayMessage(pauseStr, 0.0000000, 0.9000000, 0.7500000, true);            
        }
        else
        {
            MOHAHUD(myHUD).RemoveMessage();
        }
        OnExternalUIChanged(bPause);
    }
    //return;    
}

event PauseGame(bool bPause)
{
    local MOHAUIInteraction UIController;

    // End:0xE4
    if(CheckSystemPausable())
    {
        WorldInfo.bPauseUpdatesPlayerCamera = bPause;
        UIController = MOHAUIInteraction(GetUIController());
        // End:0x41
        if(UIController == none)
        {
            return;
        }
        // End:0x87
        if(bPause && !externallyPaused)
        {
            // End:0x84
            if(UIController.OpenScene(ExternalPauseScene, LocalPlayer(Player)))
            {
                externallyPaused = true;                
            }            
        }
        else
        {
            // End:0xD5
            if((!bPause && externallyPaused) && !UIController.controllerUnplugged)
            {
                // End:0xD5
                if(UIController.CloseScene(ExternalPauseScene))
                {
                    externallyPaused = false;                    
                }
            }
        }
        OnExternalUIChanged(bPause);        
    }
    //return;    
}

event ControllerChanged(int ControllerId, bool bIsConnected)
{
    local MOHAUIInteraction UIController;
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x112
    if((CheckSystemPausable()) && LocPlayer.ControllerId == ControllerId)
    {
        WorldInfo.bPauseUpdatesPlayerCamera = !bIsConnected;
        UIController = MOHAUIInteraction(GetUIController());
        // End:0x6D
        if(UIController == none)
        {
            return;
        }
        // End:0xB5
        if(!bIsConnected && !externallyPaused)
        {
            // End:0xB2
            if(UIController.OpenScene(ExternalPauseScene, LocalPlayer(Player)))
            {
                externallyPaused = true;                
            }            
        }
        else
        {
            // End:0x101
            if((bIsConnected && externallyPaused) && !UIController.externalUIOpen)
            {
                // End:0x101
                if(UIController.CloseScene(ExternalPauseScene))
                {
                    externallyPaused = false;                    
                }
            }
        }
        OnControllerChanged(ControllerId, bIsConnected);
    }
    //return;    
}

function string GetUseButtonToken()
{
    local string TokenString;
    local MOHAIncludeClass.eControllerScheme ControllerScheme;
    local name Platform;

    ControllerScheme = MOHAPlayerInput(PlayerInput).ControllerScheme;
    Platform = WorldInfo.GetPlatform();
    // End:0x59
    if(Platform == 'Xenon')
    {
        TokenString = GetXenonUseButtonToken(ControllerScheme);        
    }
    else
    {
        // End:0x84
        if(Platform == 'PS3')
        {
            TokenString = GetPS3UseButtonToken(ControllerScheme);            
        }
        else
        {
            TokenString = GetPCButtonText();
        }
    }
    return TokenString;
    //return ReturnValue;    
}

function string GetXenonUseButtonToken(MOHAIncludeClass.eControllerScheme ControllerScheme)
{
    // End:0x17
    if(int(ControllerScheme) == int(2))
    {
        return "[$X]";
    }
    return "[$A]";
    //return ReturnValue;    
}

function string GetPS3UseButtonToken(MOHAIncludeClass.eControllerScheme ControllerScheme)
{
    return "[$X]";
    //return ReturnValue;    
}

function string GetPCButtonText()
{
    local string UseKey;

    // End:0x78
    if(PlayerKeyboardManager != none)
    {
        UseKey = PlayerKeyboardManager.GetCurrentKeyBinding("UseAction", 1);
        // End:0x63
        if(Len(UseKey) < 1)
        {
            UseKey = PlayerKeyboardManager.GetCurrentKeyBinding("UseAction", 2);
        }
        // End:0x78
        if(Len(UseKey) < 1)
        {
            UseKey = "";
        }
    }
    return UseKey;
    //return ReturnValue;    
}

function RecordAIState(MOHAScriptAIController C, int Cost)
{
    local AIStateDebuggerRecord sdr;
    local AxonBrainState Abs;

    Abs = C.ABSS.BrainStateTop();
    // End:0x85
    if(Abs != none)
    {
        sdr.BrainName = Abs.Class.Name;
        sdr.BrainSubstateName = Abs.GetStateName();
        sdr.Instances = Cost;
    }
    AddAIStateRecord(sdr);
    //return;    
}

function AddAIStateRecord(AIStateDebuggerRecord sdr)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xAE [Loop If]
    if(I < AIStateRecord.Length)
    {
        // End:0xA4
        if((AIStateRecord[I].BrainName == sdr.BrainName) && AIStateRecord[I].BrainSubstateName == sdr.BrainSubstateName)
        {
            sdr.Instances += AIStateRecord[I].Instances;
            AIStateRecord[I] = sdr;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    AIStateRecord[AIStateRecord.Length] = sdr;
    //return;    
}

function PrintAIStateRecords(Canvas Canvas)
{
    local int I, Instances, Y, X;
    local float XL, YL;
    local AIStateDebuggerRecord sdr;

    X = Canvas.SizeX / 10;
    Y = Canvas.SizeY / 10;
    Canvas.__NFUN_464__("W", XL, YL);
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    Instances = TotalAIStateRecordInstances();
    Canvas.SetPos(float(X), float(Y));
    Canvas.__NFUN_465__("AI State records: " $ string(LastGoodAffordanceNode));
    Y += int(YL);
    I = 0;
    J0xD3:

    // End:0x1F6 [Loop If]
    if(I < AIStateRecord.Length)
    {
        sdr = AIStateRecord[I];
        Canvas.SetPos(float(X), float(Y));
        Canvas.__NFUN_465__((string(sdr.BrainName) $ "::") $ string(sdr.BrainSubstateName));
        Canvas.SetPos(float(X + 250), float(Y));
        Canvas.__NFUN_465__(string(sdr.Instances));
        Canvas.SetPos(float(X + 280), float(Y));
        Canvas.__NFUN_465__(string((float(sdr.Instances) / float(Instances)) * 100.0000000));
        Y += int(YL);
        I++;
        // [Loop Continue]
        goto J0xD3;
    }
    Canvas.SetPos(float(X), float(Y));
    Canvas.__NFUN_465__("Total instances: " $ string(Instances));
    //return;    
}

function int TotalAIStateRecordInstances()
{
    local int Instances, I;

    Instances = 0;
    I = 0;
    J0x0E:

    // End:0x44 [Loop If]
    if(I < AIStateRecord.Length)
    {
        Instances += AIStateRecord[I].Instances;
        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    return Instances;
    //return ReturnValue;    
}

event ResetPlasmaAchievements()
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x45
    if(P != none)
    {
        P.GetAchievementManager().ClearLocalAchievementData();
    }
    //return;    
}

auto state PlayerWaiting
{
    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x1C
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            return;
        }
        super.StartFire(FireModeNum);
        //return;        
    }
Begin:

    PlayerReplicationInfo.bOnlySpectator = false;
    SetCameraMode('ThirdPerson');
    stop;                
}

state PlayerWalking
{
    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        super.PlayerMove(DeltaTime, fRotationDeltaSeconds);
        // End:0x2F
        if(DeltaTime != 0.0000000)
        {
            bSavedCrouchRequested = false;
            bSavedJumpRequested = false;
        }
        //return;        
    }
    stop;    
}

state PawnCam extends Spectating
{
    exec function animcam()
    {
        local MOHAPlayerPawn MP;

        // End:0x3B
        foreach DynamicActors(Class'MOHAPawn', MP)
        {
            // End:0x2A
            if(MP.IsPlayerPawn())
            {
                continue;                
            }
            MP.CamController = none;            
        }        
        GotoState(CamOldState);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        CamSavedPlayer = MOHAPlayerPawn(Pawn);
        super.BeginState(PreviousStateName);
        ServerViewNextPlayer();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ResetCameraMode();
        ServerViewSelf();
        Possess(CamSavedPlayer, false);
        super.EndState(NextStateName);
        //return;        
    }

    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        super(BaseSpectating).PlayerMove(DeltaTime, fRotationDeltaSeconds);
        CamUpOffset += ((PlayerInput.aForward * DeltaTime) * 0.2000000);
        CamForwardOffset += ((PlayerInput.aStrafe * DeltaTime) * 0.2000000);
        CamUpOffset = float(Clamp(int(CamUpOffset), int(CamUpMin), int(CamUpMax)));
        CamForwardOffset = float(Clamp(int(CamForwardOffset), int(CamForwardMin), int(CamForwardMax)));
        // End:0xB3
        if(DeltaTime != 0.0000000)
        {
            bSavedCrouchRequested = false;
            bSavedJumpRequested = false;
        }
        //return;        
    }

    exec function PrevWeapon()
    {
        CamDistance -= CamDistanceStep;
        CamDistance = float(Clamp(int(CamDistance), int(CamDistanceMin), int(CamDistanceMax)));
        //return;        
    }

    exec function NextWeapon()
    {
        CamDistance += CamDistanceStep;
        CamDistance = float(Clamp(int(CamDistance), int(CamDistanceMin), int(CamDistanceMax)));
        //return;        
    }

    exec function StartAltFire(optional byte FireModeNum)
    {
        animcam();
        //return;        
    }
    stop;    
}

state Airdrop
{
    function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        // End:0x25
        if(NewVolume.bWaterVolume)
        {
            GotoState(Pawn.WaterMovementState);
        }
        //return;        
    }

    event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        // End:0x5C
        if(!FloorActor.IsA('MOHAAIPawn') && !FloorActor.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Pawn).AirDrop_LandingEvent();
            GotoState('AirDropLanding');
            return true;
        }
        return bUpdating;
        //return ReturnValue;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        // End:0x0D
        if(Pawn == none)
        {
            return;
        }
        // End:0x56
        if((int(Role) == int(ROLE_Authority)) && int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        //return;        
    }

    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        local Vector X, Y, Z, newAccel, ZAxis;

        local Actor.EDoubleClickDir DoubleClickMove;
        local Rotator OldRotation;
        local bool bSaveJump;
        local float dotResult;

        // End:0x1C
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            // End:0x266
            if(DeltaTime != 0.0000000)
            {
                Pawn.GetPawnAxes(X, Y, Z);
                ZAxis = vect(0.0000000, 0.0000000, 1.0000000);
                dotResult = X Dot ZAxis;
                // End:0x8E
                if(Abs(dotResult) > 0.9950000)
                {
                    X = Z;
                }
                X.Z = 0.0000000;
                X = Normal(X);
                Y = ZAxis Cross X;
                Y = Normal(Y);
                newAccel = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
                newAccel.Z = 0.0000000;
                newAccel = Pawn.AccelRate * Normal(newAccel);
                DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
                OldRotation = Rotation;
                UpdateRotation(fRotationDeltaSeconds);
                bDoubleJump = false;
                // End:0x1B7
                if(bPressedJump && Pawn.CannotJumpNow())
                {
                    bSaveJump = true;
                    bPressedJump = false;                    
                }
                else
                {
                    bSaveJump = false;
                }
                // End:0x205
                if(int(Role) < int(ROLE_Authority))
                {
                    ReplicateMove(DeltaTime, fRotationDeltaSeconds, newAccel, DoubleClickMove, (OldRotation - Rotation) + PendingRotation);                    
                }
                else
                {
                    ProcessMove(DeltaTime, newAccel, DoubleClickMove, (OldRotation - Rotation) + PendingRotation);
                }
                PendingRotation = rot(0, 0, 0);
                bPressedJump = bSaveJump;
                bSavedCrouchRequested = false;
                bSavedJumpRequested = false;                
            }
            else
            {
                OldRotation = Rotation;
                UpdateRotation(fRotationDeltaSeconds);
                PendingRotation += (OldRotation - Rotation);
                // End:0x2BF
                if(int(WorldInfo.NetMode) == int(NM_Client))
                {
                    Pawn.AutonomousPhysics(fRotationDeltaSeconds);
                }
            }
        }
        //return;        
    }

    exec function FlareChute(optional byte FireModeNum)
    {
        local MOHAPlayerPawn PlayerPawn;
        local MOHAParachuteActor myParachute;

        PlayerPawn = MOHAPlayerPawn(Pawn);
        // End:0x94
        if(PlayerPawn != none)
        {
            myParachute = MOHAPlayerPawn(Pawn).AirdropParachuteMesh;
            // End:0x53
            if(myParachute != none)
            {
                myParachute.FlareChute();
            }
            PlayerPawn.AirDrop_ChuteFlareEvent();
            SetTimer(PlayerPawn.AirdropComponent.AirdropTimerChuteFlare, false, 'FlareChuteEnd');
            bFlaring = true;
        }
        //return;        
    }

    exec function FlareChuteEnd(optional byte FireModeNum)
    {
        local MOHAParachuteActor myParachute;

        // End:0x7C
        if((Pawn != none) && Pawn.IsA('MOHAPlayerPawn'))
        {
            myParachute = MOHAPlayerPawn(Pawn).AirdropParachuteMesh;
            // End:0x5C
            if(myParachute != none)
            {
                myParachute.FlareChuteDone();
            }
            MOHAPlayerPawn(Pawn).AirDrop_DecendEvent();
            bFlaring = false;
        }
        //return;        
    }

    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, ViewRotation, pendulumRotatedRotation, delta_removed, Comp;

        local MOHAPawn myMohaPawn;

        ViewRotation = Rotation;
        DesiredRotation = ViewRotation;
        DeltaRot.Pitch = int(((IsLocalPlayerController()) ? PlayerInput.aLookUp : 0.0000000));
        DeltaRot.Pitch *= MOHAPawn(Pawn).AirdropComponent.AirdropLookSpeedScale;
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        ViewShake(DeltaTime);
        ViewRotation.Roll = 0;
        myMohaPawn = MOHAPawn(Pawn);
        Comp = MOHAPlayerPawn(myMohaPawn).GetAirdropViewCompensation();
        // End:0x10C
        if(myMohaPawn != none)
        {
            pendulumRotatedRotation = myMohaPawn.DoAirdropPendulumViewRotation(ViewRotation, delta_removed);
        }
        SetRotation(ViewRotation + Comp);
        // End:0x144
        if(Pawn != none)
        {
            Pawn.FaceRotation(pendulumRotatedRotation, DeltaTime);
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        PrePendulumAirdropRotation = Rotation;
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);
        // End:0x47
        if(IsLocalPlayerController())
        {
            MOHAPlayerInput(PlayerInput).bUseViewAcceleration = false;
        }
        MOHAPlayerPawn(Pawn).RenderBody(true);
        // End:0x7E
        if(playerStats != none)
        {
            playerStats.OnPlayerAirDrop();
        }
        // End:0xB4
        if(myHUD != none)
        {
            myHUD.bShowHUD = true;
            MOHAHUD(myHUD).SetRenderMode(2);
        }
        bFlaring = false;
        //return;        
    }

    function EndState(name NextStateName)
    {
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);
        MOHAPlayerPawn(Pawn).RenderBody(false);
        bFlaring = false;
        //return;        
    }
    stop;    
}

state AirDropLanding
{
    event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        return bUpdating;
        //return ReturnValue;        
    }

    event PlayerTick(float DeltaTime)
    {
        super(MOHAPlayerController).PlayerTick(DeltaTime);
        UpdateRotation(DeltaTime);
        //return;        
    }

    function UpdateRotation(float DeltaTime)
    {
        local Rotator NewRotation, ViewRotation;

        ViewRotation = Rotation;
        DesiredRotation = ViewRotation;
        ViewRotation.Roll *= FClamp(1.0000000 - (5.0000000 * DeltaTime), 0.0000000, 1.0000000);
        ViewRotation.Pitch *= FClamp(1.0000000 - (5.0000000 * DeltaTime), 0.0000000, 1.0000000);
        SetRotation(ViewRotation);
        NewRotation = ViewRotation;
        NewRotation.Roll = Rotation.Roll;
        NewRotation.Pitch = Rotation.Pitch;
        // End:0xEF
        if(Pawn != none)
        {
            Pawn.FaceRotation(NewRotation, DeltaTime);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        IgnoreMoveInput(false);
        IgnoreLookInput(false);
        // End:0x39
        if(IsLocalPlayerController())
        {
            MOHAPlayerInput(PlayerInput).bUseViewAcceleration = true;
        }
        // End:0x5E
        if(myHUD != none)
        {
            MOHAHUD(myHUD).SetRenderMode(0);
        }
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);
        MOHAPlayerPawn(Pawn).RenderBody(false);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);
        MOHAPlayerPawn(Pawn).RenderBody(true);
        //return;        
    }
    stop;    
}

state AirDropLanded extends PlayerWalking
{
    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, NewRotation, ViewRotation;

        ViewRotation = Rotation;
        DesiredRotation = ViewRotation;
        ViewRotation.Roll *= 0.6000000;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
        NewRotation = ViewRotation;
        NewRotation.Roll = Rotation.Roll;
        // End:0xEE
        if(Pawn != none)
        {
            Pawn.FaceRotation(NewRotation, DeltaTime);
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);
        MOHAPlayerPawn(Pawn).RenderBody(true);
        MOHAPlayerPawn(Pawn).OnRemoveGear();
        //return;        
    }

    function EndState(name NextStateName)
    {
        local Rotator NewRotation;

        NewRotation = Rotation;
        NewRotation.Roll = 0;
        SetRotation(NewRotation);
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);
        MOHAPlayerPawn(Pawn).RenderBody(false);
        bJumpRequested = false;
        bStanceChangeRequested = false;
        bSprintRequested = false;
        //return;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        // End:0x0D
        if(Pawn == none)
        {
            return;
        }
        Pawn.Acceleration = newAccel * MOHAPawn(Pawn).AirdropComponent.AirdropLandedMoveScale;
        //return;        
    }

    exec function CutChute(optional byte FireModeNum)
    {
        MOHAPlayerPawn(Pawn).OnRemoveGear();
        //return;        
    }
    stop;    
}

state ITPInThePlane
{
    function SendUpdateCinematic(bool bStart)
    {
        // End:0x1B
        if(MOHAPlayerPawn(Pawn).playerPlane == none)
        {
            return;
        }
        // End:0x48
        if(bStart)
        {
            MOHAPlayerPawn(Pawn).playerPlane.ResumeNPCsBehindPlayer();            
        }
        else
        {
            MOHAPlayerPawn(Pawn).playerPlane.PauseNPCsBehindPlayer();
        }
        //return;        
    }

    function StopCinematic()
    {
        // End:0x1C
        if(Pawn.GetStateName() != 'ITPInThePlane')
        {
            return;
        }
        // End:0x44
        if(MOHAPlayerPawn(Pawn) != none)
        {
            MOHAPlayerPawn(Pawn).StopAnimation();
        }
        //return;        
    }

    function StartCinematic()
    {
        // End:0x1C
        if(Pawn.GetStateName() != 'ITPInThePlane')
        {
            return;
        }
        // End:0x44
        if(MOHAPlayerPawn(Pawn) != none)
        {
            MOHAPlayerPawn(Pawn).StartAnimation();
        }
        //return;        
    }

    function UpdateDesiredScrubbedAnimationPosition(float DeltaTime)
    {
        // End:0x0D
        if(!bInITPAnimScrubMode)
        {
            return;
        }
        // End:0x93
        if(!MOHAPlayerPawn(Pawn).bInvoluntaryJump)
        {
            // End:0x65
            if(!PlayerInput.bWasForward)
            {
                // End:0x62
                if(bPlayingCinematic)
                {
                    SendUpdateCinematic(false);
                    StopCinematic();
                    bPlayingCinematic = false;
                    return;
                }                
            }
            else
            {
                // End:0x8E
                if(bPlayingCinematic == false)
                {
                    StartCinematic();
                    SendUpdateCinematic(true);
                    bPlayingCinematic = true;
                }
                return;
            }            
        }
        else
        {
            // End:0xBB
            if(!bPlayingCinematic)
            {
                StartCinematic();
                SendUpdateCinematic(true);
                bPlayingCinematic = true;
            }
        }
        //return;        
    }

    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        local Vector X, Y, Z, newAccel;
        local Actor.EDoubleClickDir DoubleClickMove;
        local Rotator OldRotation;

        // End:0x1C
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            Pawn.GetPawnAxes(X, Y, Z);
            newAccel = vect(0.0000000, 0.0000000, 0.0000000);
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            bDoubleJump = false;
            UpdateDesiredScrubbedAnimationPosition(DeltaTime);
            // End:0xEE
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(DeltaTime, DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);                
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
            }
            // End:0x133
            if(DeltaTime != 0.0000000)
            {
                bSavedCrouchRequested = false;
                bSavedJumpRequested = false;
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        myHUD.bShowHUD = true;
        MOHAHUD(myHUD).SetRenderMode(3);
        StopFire();
        StopAltFire();
        AimRelease();
        AimRelease();
        StartCinematic();
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);
        MOHAPlayerPawn(Pawn).RenderBody(true);
        //return;        
    }

    function EndState(name NextStateName)
    {
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);
        MOHAPlayerPawn(Pawn).RenderBody(false);
        //return;        
    }
Begin:

    stop;                
}

state BRFInTheBriefing
{
    function BeginState(name PreviousStateName)
    {
        myHUD.bShowHUD = false;
        StopFire();
        StopAltFire();
        AimRelease();
        AimRelease();
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);
        MOHAPlayerPawn(Pawn).RenderBody(true);
        //return;        
    }

    function EndState(name NextStateName)
    {
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);
        MOHAPlayerPawn(Pawn).RenderBody(false);
        //return;        
    }

    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        local Vector X, Y, Z, newAccel;
        local Actor.EDoubleClickDir DoubleClickMove;
        local Rotator OldRotation;

        // End:0x1C
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            Pawn.GetPawnAxes(X, Y, Z);
            newAccel = vect(0.0000000, 0.0000000, 0.0000000);
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            bDoubleJump = false;
            // End:0xDF
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(DeltaTime, DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);                
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
            }
            // End:0x124
            if(DeltaTime != 0.0000000)
            {
                bSavedCrouchRequested = false;
                bSavedJumpRequested = false;
            }
        }
        //return;        
    }
    stop;    
}

state PlayerClimbing
{
    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        super.ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        // End:0x71
        if(MOHAPlayerInput(PlayerInput).bJumpDown)
        {
            Pawn.DoJump(bUpdating);
            // End:0x71
            if(int(Pawn.Physics) == int(2))
            {
                GotoState('PlayerWalking');
            }
        }
        //return;        
    }

    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        local Vector X, Y, Z, newAccel;
        local Rotator OldRotation, ViewRotation;

        Pawn.GetPawnAxes(X, Y, Z);
        // End:0xF4
        if(Pawn.OnLadder != none)
        {
            newAccel = (((Vector(Rotation) Dot Vector(Pawn.OnLadder.WallDir)) > 0.0000000) ? PlayerInput.aForward * Pawn.OnLadder.ClimbDir : -PlayerInput.aForward * Pawn.OnLadder.ClimbDir);
            // End:0xF1
            if(Pawn.OnLadder.bAllowLadderStrafing)
            {
                newAccel += (PlayerInput.aStrafe * Y);
            }            
        }
        else
        {
            newAccel = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
        }
        newAccel = Pawn.AccelRate * Normal(newAccel);
        ViewRotation = Rotation;
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        // End:0x1AB
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, DeltaTime, newAccel, 0, OldRotation - Rotation);            
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        }
        bPressedJump = false;
        // End:0x1F5
        if(DeltaTime != 0.0000000)
        {
            bSavedCrouchRequested = false;
            bSavedJumpRequested = false;
        }
        //return;        
    }
    stop;    
}

state PlayerFlying
{
    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        local Vector X, Y, Z;
        local float Up;

        // End:0x2C
        if(MOHAPlayerInput(PlayerInput).bJumpDown)
        {
            Up += Pawn.JumpZ;
        }
        // End:0x58
        if(MOHAPlayerInput(PlayerInput).bCrouchDown)
        {
            Up -= Pawn.JumpZ;
        }
        Pawn.GetPawnAxes(X, Y, Z);
        Pawn.Acceleration = ((PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y)) + (Up * vect(0.0000000, 0.0000000, 1.0000000));
        Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
        // End:0x141
        if(bCheatFlying && Pawn.Acceleration == vect(0.0000000, 0.0000000, 0.0000000))
        {
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        }
        UpdateRotation(DeltaTime);
        // End:0x194
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));            
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
        }
        // End:0x1DF
        if(DeltaTime != 0.0000000)
        {
            bSavedCrouchRequested = false;
            bSavedJumpRequested = false;
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        Pawn.SetHidden(true);
        Pawn.SetPhysics(4);
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x15
        if(NextStateName == 'PlayerFlying')
        {
            return;
        }
        Pawn.SetHidden(false);
        myHUD.bShowHUD = true;
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);
        //return;        
    }
    stop;    
}

state PlayerPlacingDemoCharge extends PlayerWalking
{
    function BeginState(name PreviousStateName)
    {
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        MOHAPlayerPawn(Pawn).bInstantlyStop = true;
        MOHAPlayerPawn(Pawn).bLockStanceHeight = true;
        Pawn.bIgnoreForces = true;
        Pawn.bCanJump = false;
        fStateTime = 0.0000000;
        MountStartingRot = Rotation;
        DemoChargeWeapon = RaiseDemoCharge();
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);
        CurrentDemoChargingTime = 0.0000000;
        bDemoChargeUseRelease = false;
        DemoPlaceTime = ((Pawn.Weapon != none) ? 0.9000000 * Pawn.Weapon.PutDownTime : 1.0000000);
        SetTimer(DemoPlaceTime, false, 'TimeDemoChargeTranslation');
        //return;        
    }

    function EndState(name NextStateName)
    {
        IgnoreMoveInput(false);
        IgnoreLookInput(false);
        MOHAPlayerPawn(Pawn).bInstantlyStop = false;
        MOHAPlayerPawn(Pawn).bLockStanceHeight = false;
        Pawn.bIgnoreForces = false;
        Pawn.bCanJump = true;
        MOHAPlayerPawn(Pawn).ResetAnimOffsetPos();
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);
        SwitchWeapon();
        //return;        
    }

    function Vector GetDesiredVMAnimOffset()
    {
        local Vector vPlayerToDemoCharge_WS, vPlayerToDemoCharge_AS, vStanceHeightMod_AS;

        vPlayerToDemoCharge_WS = DemoChargeCSA.Location - MOHAPlayerPawn(Pawn).GetGroundPos();
        vPlayerToDemoCharge_AS = Class'MOHAUtilities'.static.InverseRotateVector(vPlayerToDemoCharge_WS, Rotation);
        vStanceHeightMod_AS = MOHAPlayerPawn(Pawn).vCurrentStanceHeightMod;
        return (vPlayerToDemoCharge_AS - EALADemoCharge(DemoChargeWeapon).GetDemoChargeOffsetFromPlayerRoot()) - vStanceHeightMod_AS;
        //return ReturnValue;        
    }

    function UpdateViewModelOffsetPos(float fPerc)
    {
        MOHAPlayerPawn(Pawn).LerpAnimOffsetPos(GetDesiredVMAnimOffset(), fPerc);
        //return;        
    }

    function UpdateViewModelRotation(float fPerc)
    {
        local Rotator rDesiredRot;

        rDesiredRot.Yaw = DemoChargeCSA.Rotation.Yaw;
        SetRotation(Class'MOHAUtilities'.static.LerpRot(MountStartingRot, rDesiredRot, fPerc));
        //return;        
    }

    function TimeDemoChargeTranslation()
    {
        UpdateViewModelRotation(1.0000000);
        UpdateViewModelOffsetPos(1.0000000);
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local float fPerc;

        global.PlayerTick(DeltaTime);
        // End:0x6A
        if(IsTimerActive('TimeDemoChargeTranslation'))
        {
            fStateTime += DeltaTime;
            fPerc = FClamp(fStateTime / DemoPlaceTime, 0.0000000, 1.0000000);
            UpdateViewModelOffsetPos(fPerc);
            UpdateViewModelRotation(fPerc);
        }
        // End:0x114
        if(MOHAPlayerPawn(Pawn).IsDemoCharging())
        {
            // End:0xA3
            if(bDemoChargeUseRelease)
            {
                GotoState(Pawn.LandMovementState);
                return;
            }
            CurrentDemoChargingTime += DeltaTime;
            // End:0x114
            if(CurrentDemoChargingTime >= MaxDemoChargingTime)
            {
                CurrentDemoChargingTime = MaxDemoChargingTime;
                // End:0x101
                if(DemoChargeCSA != none)
                {
                    Pawn.StartFire(0);
                    DemoChargeCSA.OnPlacedDemoCharge(Pawn);
                }
                GotoState(Pawn.LandMovementState);
            }
        }
        //return;        
    }

    function bool DemoChargeTimeDone()
    {
        // End:0x11
        if(CurrentDemoChargingTime >= MaxDemoChargingTime)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    exec function UseRelease()
    {
        // End:0x0B
        if(Pawn != none)
        {
        }
        //return;        
    }

    function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum, optional Actor DamageCauser)
    {
        global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum, DamageCauser);
        bDemoChargeUseRelease = true;
        //return;        
    }

    function bool CanJumpOrDuck()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state PlayerUsingMG extends PlayerWalking
{
    function bool CanJumpOrDuck()
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        Pawn.bIgnoreForces = true;
        // End:0x34
        if(IsLocalPlayerController())
        {
            MOHAPlayerInput(PlayerInput).bUseViewAcceleration = false;
        }
        //return;        
    }

    function EndState(name PreviousStateName)
    {
        Pawn.bIgnoreForces = false;
        // End:0x34
        if(IsLocalPlayerController())
        {
            MOHAPlayerInput(PlayerInput).bUseViewAcceleration = true;
        }
        //return;        
    }

    simulated function bool PlayerUsingMountedGun()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state PlayerMountingMG extends PlayerUsingMG
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);
        MOHAPlayerPawn(Pawn).bInstantlyStop = true;
        MountStartingRot = Rotation;
        fStateTime = 0.0000000;
        MountedGunEnterTime = ((Pawn.Weapon != none) ? Pawn.Weapon.PutDownTime : 1.0000000);
        MountedGunEnterTime *= 0.9000000;
        SwitchOffWeapon();
        SetTimer(MountedGunEnterTime, false, 'TimeMountMG');
        //return;        
    }

    function Vector GetDesiredVMAnimOffset()
    {
        local Vector vPlayerToMG_WS, vPlayerToMG_AS;

        vPlayerToMG_WS = MountedGun.GetGunPosition() - MOHAPlayerPawn(Pawn).GetGroundPos();
        vPlayerToMG_AS = Class'MOHAUtilities'.static.InverseRotateVector(vPlayerToMG_WS, Rotation);
        return vPlayerToMG_AS - MountedGun.Weapon.GetMGOffsetFromPlayerRoot();
        //return ReturnValue;        
    }

    function TimeMountMG()
    {
        SetRotation(MountedGun.Rotation);
        UpdateViewModelOffsetPos(1.0000000);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        IgnoreLookInput(false);
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);
        //return;        
    }

    function UpdateViewModelOffsetPos(float fPerc)
    {
        MOHAPlayerPawn(Pawn).LerpAnimOffsetPos(GetDesiredVMAnimOffset(), fPerc);
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local float fPerc;

        global.PlayerTick(DeltaTime);
        // End:0x89
        if(IsTimerActive('TimeMountMG'))
        {
            fStateTime += DeltaTime;
            fPerc = FClamp(fStateTime / MountedGunEnterTime, 0.0000000, 1.0000000);
            UpdateViewModelOffsetPos(fPerc);
            SetRotation(Class'MOHAUtilities'.static.LerpRot(MountStartingRot, MountedGun.Rotation, fPerc));
        }
        // End:0xDB
        if(Pawn.Weapon == none)
        {
            MountedGun.TakeWeaponFromMG();
            LoadMG42Weapon();
            MountedGun.MGWeaponRaising();
            GotoState('PlayerMountedMG');
        }
        //return;        
    }

    function bool IsMountedMGState()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state PlayerMountedMG extends PlayerUsingMG
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        MOHAPlayerPawn(Pawn).rMGRot = rot(0, 0, 0);
        MOHAPlayerPawn(Pawn).bMountedOnMG = true;
        //return;        
    }

    function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
    {
        local float fMaxYaw, fMaxPitch;
        local MOHAPlayerPawn PlayerPawn;

        PlayerPawn = MOHAPlayerPawn(Pawn);
        fMaxYaw = MountedGun.Weapon.fMaxYaw;
        fMaxPitch = MountedGun.Weapon.fMaxPitch;
        // End:0xB0
        if((PlayerPawn.Weapon != none) && PlayerPawn.Weapon.IsA('EALASmallArms'))
        {
            EALASmallArms(PlayerPawn.Weapon).ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
        }
        PlayerPawn.rMGRot += DeltaRot;
        // End:0x133
        if(Abs(float(PlayerPawn.rMGRot.Yaw)) > fMaxYaw)
        {
            PlayerPawn.rMGRot.Yaw = int(((PlayerPawn.rMGRot.Yaw > 0) ? fMaxYaw : -fMaxYaw));
        }
        // End:0x1A0
        if(Abs(float(PlayerPawn.rMGRot.Pitch)) > fMaxPitch)
        {
            PlayerPawn.rMGRot.Pitch = int(((PlayerPawn.rMGRot.Pitch > 0) ? fMaxPitch : -fMaxPitch));
        }
        PlayerPawn.fAimRightBlend = FClamp(float(PlayerPawn.rMGRot.Yaw) / fMaxYaw, -1.0000000, 1.0000000);
        PlayerPawn.fAimUpBlend = FClamp(float(PlayerPawn.rMGRot.Pitch) / fMaxPitch, -1.0000000, 1.0000000);
        //return;        
    }

    function bool PlayerCanSwitchWeapons()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool PlayerMountedOnMG()
    {
        return true;
        //return ReturnValue;        
    }

    function bool IsMountedMGState()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state PlayerExitingMG extends PlayerUsingMG
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        fStateTime = 0.0000000;
        MountedGunExitTime = ((Pawn.Weapon != none) ? Pawn.Weapon.PutDownTime : 1.0000000);
        rExitMGRot = MOHAPlayerPawn(Pawn).rMGRot;
        fExitAimUpBlend = MOHAPlayerPawn(Pawn).fAimUpBlend;
        fExitAimRightBlend = MOHAPlayerPawn(Pawn).fAimRightBlend;
        MOHAInventoryManager(Pawn.InvManager).SwitchToLastNonMGWeapon();
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(true);
        IgnoreLookInput(true);
        //return;        
    }

    function EndState(name PreviousStateName)
    {
        super.EndState(PreviousStateName);
        IgnoreMoveInput(false);
        IgnoreLookInput(false);
        MOHAPlayerPawn(Pawn).bInstantlyStop = false;
        MOHAPlayerPawn(Pawn).ResetAnimOffsetPos();
        MOHAPlayerPawn(Pawn).bMountedOnMG = false;
        MountedGun.ReturnWeaponToMG();
        MountedGun.LeaveGun(Pawn);
        MountedGun = none;
        MOHAPlayerPawn(Pawn).SetWeaponDisabled(false);
        //return;        
    }

    function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
    {
        super(MOHAPlayerController).NotifyChangedWeapon(PreviousWeapon, NewWeapon);
        // End:0x37
        if(!NewWeapon.IsA('MOHAMountedGunWeapon'))
        {
            GotoState('PlayerWalking');
        }
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local float fPerc;

        global.PlayerTick(DeltaTime);
        fStateTime += DeltaTime;
        fPerc = FClamp(fStateTime / MountedGunExitTime, 0.0000000, 1.0000000);
        MOHAPlayerPawn(Pawn).rMGRot = rExitMGRot * (1.0000000 - fPerc);
        MOHAPlayerPawn(Pawn).fAimRightBlend = fExitAimRightBlend * (1.0000000 - fPerc);
        MOHAPlayerPawn(Pawn).fAimUpBlend = fExitAimUpBlend * (1.0000000 - fPerc);
        //return;        
    }

    function bool IsMountedMGState()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

simulated state Dead
{
    ignores KilledBy, NextWeapon, PrevWeapon, ThrowWeapon;

    simulated function FindGoodView()
    {
        super.FindGoodView();
        SetCameraMode('Spectator');
        ClientSetCameraMode('Spectator');
        //return;        
    }

    function bool CanBeSpectated()
    {
        return bFrozen;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        CleanOutSavedMoves();
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        bPressedJump = false;
        // End:0x58
        if(myHUD != none)
        {
            myHUD.SetbShowScores(false);
        }
        //return;        
    }
Begin:

    // End:0x2E
    if(LocalPlayer(Player) != none)
    {
        // End:0x2E
        if(myHUD != none)
        {
            myHUD.PlayerOwnerDied();
        }
    }
    stop;        
}

state RoundEnded
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x2B
        if(myHUD != none)
        {
            myHUD.SetbShowScores(false);
        }
        //return;        
    }
    stop;    
}

state WaitingForLoad
{
    ignores RestartLevel, ClientRestart, Suicide, ThrowWeapon, ProcessMove, StartFire;

    function BeginState(name PrevStateName)
    {
        //return;        
    }

    function LevelsLoaded()
    {
        GotoState('PlayerWalking');
        //return;        
    }
    stop;    
}

state Spectating
{
    exec function PrevWeapon()
    {
        ServerViewPrevPlayer();
        //return;        
    }

    exec function NextWeapon()
    {
        ServerViewNextPlayer();
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        ServerViewObjective();
        //return;        
    }

    exec function StartAltFire(optional byte FireModeNum)
    {
        ServerViewObjective();
        //return;        
    }

    function PlayerTick(float DeltaTime)
    {
        global.PlayerTick(DeltaTime);
        // End:0x3A
        if((ViewTargetPawn == none) || !ViewTargetPawn.bSpectatable)
        {
            ServerViewNextPlayer();
        }
        //return;        
    }

    function Rotator LimitViewRotationPitchAndYaw(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax, float ViewYawMin, float ViewYawMax)
    {
        return ViewRotation;
        //return ReturnValue;        
    }

    function UpdateRotation(float DeltaTime)
    {
        super(PlayerController).UpdateRotation(DeltaTime);
        //return;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        super(PlayerController).ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        //return;        
    }

    function bool CanBeSpectated()
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SetCameraMode('Spectator');
        ClientSetCameraMode('Spectator');
        PlayerReplicationInfo.bIsSpectator = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ViewTargetPawn = none;
        //return;        
    }
    stop;    
}

defaultproperties
{
    bCineSavedCollideActors=true
    bCineSavedBlockActors=true
    fReticuleMaxCheckDistance=10000.0000000
    fHitShakeRotAmplitude_Min=750.0000000
    fHitShakeRotAmplitude_Max=2000.0000000
    fHitDamageForMaxShake=100.0000000
    fHitShakeFrequency=10.0000000
    fHitShakeDuration=0.2000000
    WeaponCSAUseHoldTime=0.1750000
    // Reference: MOHAPlayerStatsComponent'Default__MOHAPlayerController.PlayerStatsComponent'
    begin object name=PlayerStatsComponent class=Class'MOHAPlayerStatsComponent'
    end object
    playerStats=PlayerStatsComponent
    // Reference: MOHAPostProcessComponent'Default__MOHAPlayerController.PostProcessComponent0'
    begin object name=PostProcessComponent0 class=Class'MOHAPostProcessComponent'
    end object
    PostProcessComponent=PostProcessComponent0
    defaultPostProcessSettingsAsset=MOHAPostProcessSettingsAsset'PostProcessMaterialPackage.DefaultMOHAPostProcessSettings'
    bPlayingCinematic=true
    fAnimationEndPosition=1.0000000
    CamDistance=200.0000000
    CamDistanceMax=500.0000000
    CamDistanceMin=50.0000000
    CamDistanceStep=30.0000000
    CamUpMin=-100.0000000
    CamUpMax=100.0000000
    CamForwardMin=-100.0000000
    CamForwardMax=100.0000000
    MaxDemoChargingTime=2.0000000
    MountedGunExitTime=1.0000000
    fEditActorPickerDistance=10000.0000000
    fEditActorPickerExtents=5.0000000
    AmmoPickupMsg="%1 Ammo Found"
    HealthPickupMsg="Health Found"
    AmmoFullMsg="%1 Ammo Full"
    HealthFullMsg="Health Full"
    HealthPickupSoundCue=SoundCue'Aud_GCm_FakeWAV.Items.Health_PickUp'
    AmmoPickupSoundCue=SoundCue'Aud_GCm_FakeWAV.Items.Ammo_PickUp'
    HealthPickupFailedSoundCue=SoundCue'Aud_GCm_FakeWAV.Items.PickUp_Full'
    AmmoPickupFailedSoundCue=SoundCue'Aud_GCm_FakeWAV.Items.PickUp_Full'
    // Reference: KynapseEntityComponent'Default__MOHAPlayerController.KynapsePlayerEnt0'
    begin object name=KynapsePlayerEnt0 class=Class'EAKynapse.KynapseEntityComponent'
        bSentient=true
        sKynClassName="player"
        sKynDebugName="player"
    end object
    KynapseEntityComponent=KynapsePlayerEnt0
    // Reference: StimulusComponent'Default__MOHAPlayerController.Stimulus0'
    begin object name=Stimulus0 class=Class'EAKynapse.StimulusComponent'
    end object
    Stimulus=Stimulus0
    fCrouchJumpToStandVelocity=150.0000000
    HighDefVerticalResolution=720
    JoinFailedTitle="Join Failed"
    JoinFriendFailedMsg="Join friend's game failed"
    JoinInviteFailedMsg="Not all local players have permission to join the game invite"
    JoinGameFullMsg="Game is full"
    // Reference: ForceFeedbackWaveform'Default__MOHAPlayerController.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0 class=Class'Engine.ForceFeedbackWaveform'
    end object
    WeaponFireFFWaveform=ForceFeedbackWaveform0
    bCanJumpOrDuck=true
    ProfileScene=UIScene'UI_Popups.InGame_PU_Small_PM'
    ExternalPauseScene=UIScene'UI_Pause.SimplePause'
    UnengagedTime=6.0000000
    fSuppressionMax=30.0000000
    fSuppressionThreshhold=28.0000000
    fSuppressionSafe=2.0000000
    fSuppressionDecayRate=3.0000000
    GameDifficulty=1
    MapNamesToContextValues[0]=(MapName="Hus_M1_P",ContextValue=0)
    MapNamesToContextValues[1]=(MapName="Hus_M1_Briefing",ContextValue=0)
    MapNamesToContextValues[2]=(MapName="Ava_Pes_P",ContextValue=1)
    MapNamesToContextValues[3]=(MapName="Ava_Pes_Briefing",ContextValue=1)
    MapNamesToContextValues[4]=(MapName="Nep_Azv_P",ContextValue=2)
    MapNamesToContextValues[5]=(MapName="Nep_Azv_Briefing",ContextValue=2)
    MapNamesToContextValues[6]=(MapName="Mar_Nij_P",ContextValue=3)
    MapNamesToContextValues[7]=(MapName="Mar_Nij_Briefing",ContextValue=3)
    MapNamesToContextValues[8]=(MapName="Var_Fac_P",ContextValue=4)
    MapNamesToContextValues[9]=(MapName="Var_Fac_Briefing",ContextValue=4)
    MapNamesToContextValues[10]=(MapName="Var_Flk_P",ContextValue=5)
    MapNamesToContextValues[11]=(MapName="Var_Flk_Briefing",ContextValue=5)
    MapNamesToContextValues[12]=(MapName="Tra_Jmp_P",ContextValue=6)
    MapNamesToContextValues[13]=(MapName="MP_Remagen_P",ContextValue=0)
    MapNamesToContextValues[14]=(MapName="MP_DV_P",ContextValue=1)
    MapNamesToContextValues[15]=(MapName="MP_TH_P",ContextValue=2)
    MapNamesToContextValues[16]=(MapName="MP_Hus_P",ContextValue=3)
    MapNamesToContextValues[17]=(MapName="MP_Ava_P",ContextValue=4)
    MapNamesToContextValues[18]=(MapName="MP_Nep_P",ContextValue=5)
    CameraClass=Class'MOHAPlayerCamera'
    FOVAngle=80.0000000
    DesiredFOV=80.0000000
    DefaultFOV=80.0000000
    CheatClass=Class'MOHACheatManager'
    InputClass=Class'MOHAPlayerInput'
    // Reference: CylinderComponent'Default__MOHAPlayerController.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAPlayerController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=KynapsePlayerEnt0
    Components[3]=Stimulus0
    Components[4]=PlayerStatsComponent
    Components[5]=PostProcessComponent0
    CollisionComponent=CollisionCylinder
}