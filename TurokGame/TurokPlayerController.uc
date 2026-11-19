class TurokPlayerController extends PlayerController
    native
    nativereplication
    config(Game)
    hidecategories(Navigation)
    implements(TurokActionInterface,TurokAnimInterfaceGraphNotify,TurokAnimInterfaceGraphEvents);

const TUROK_MOVE_RESTART_TIME = 0.03;
const TUROK_MAX_SPEEDMODIFIER = 2.0;
const TUROK_MAX_POSITIONERRORSQUARED = 4.0;
const TUROK_MAX_NEARZEROVELOCITYSQUARED = 4.0;
const TUROK_MAX_VEHICLEPOSITIONERRORSQUARED = 300.0;
const TUROK_CLIENTADJUSTUPDATECOST = 250.0;

enum EAimReticleOverride
{
    EARO_Off,                       // 0
    EARO_Enemy,                     // 1
    EARO_MAX                        // 2
};

enum ETurokSoundMode
{
    TSM_NORMAL,                     // 0
    TSM_GRENADE,                    // 1
    TSM_STEALTH,                    // 2
    TSM_STEALTHKILL,                // 3
    TSM_DEAD,                       // 4
    TSM_MAX                         // 5
};

struct native PlayerConstraints
{
    var @NULL mPositionActor;
    var @NULL mLookAtActor;
    var bool mbAllowMovement;
    var float mLookAtTime;
    var @NULL mLookAtConstraints;
    var @NULL mLookAtSpline;
    var @NULL mInitialLookAt;
    var @NULL mTargetLookAt;
    var float mCurrentTime;

    structdefaultproperties
    {
        mPositionActor=none
        mLookAtActor=none
        mbAllowMovement=false
        mLookAtTime=0.0000000
        mLookAtConstraints=(Pitch=0,Yaw=0,Roll=0)
        mLookAtSpline=none
        mInitialLookAt=(Pitch=0,Yaw=0,Roll=0)
        mTargetLookAt=(Pitch=0,Yaw=0,Roll=0)
        mCurrentTime=0.0000000
    }
};

struct native HitReactionInfo
{
    var class<Class> DamageType;
    var int Damage;
    var @NULL HitLocation;
    var @NULL hitFromLocation;

    structdefaultproperties
    {
        DamageType=Class'TurokDamageType'
        Damage=0
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        hitFromLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SinglePlayerObjective
{
    var int mDescStringHash;
    var @NULL mLocation;
    var string mObjectiveName;

    structdefaultproperties
    {
        mDescStringHash=0
        mLocation=none
        mObjectiveName=""
    }
};

var private native const noexport @NULL VfTable_ITurokActionInterface;
var protected @NULL TurokOnlineSub;
var protected @NULL VoiceInterface;
var const config float VoiceCommNearRadius;
var const config float VoiceCommUpdateRate;
var const config float GameStatUpdateRate;
var const config bool AllowCheatsInMP;
var private byte mLastInputDirection;
var input float mMeleeLeftAnalogX;
var input float mMeleeLeftAnalogY;
var array mImpactDebugText;
var bool mbImpactGodMode;
var bool mbImpactReaperMode;
var bool mbDrawExplosionDebug;
var private bool mbDrawPredatorAttackDebug;
var private bool mbDrawWeaponDebug;
var private bool mbDrawImpactDebug;
var private bool mbDrawAnimDebug3D;
var private bool mbDrawPawnDebug3D;
var private bool mbDrawPathDebug3D;
var private bool mbDrawAICountDebug;
var private bool mbDrawGrassCollision;
var private bool mbShowGrassStats;
var private bool mbShowCoverDebug;
var private bool mbWaterBossDebug;
var private bool mbDrawAudioDebug;
var private int mNetErrorCount;
var private bool mbShowClientMessages;
var(HitReaction) bool mbIgnoreGodMode;
var(HitReaction) export editinline @NULL mShooter1;
var(HitReaction) export editinline @NULL mShooter2;
var @NULL mPlayerConstraints;
var private float mImpulseTime;
var private @NULL mImpulseVector;
var(HitReaction) export editinline @NULL mHitReactionManager;
var repnotify @NULL mHitReactionInfo;
var private float mHitReactionTime;
var private const float mHitReactionInterval;
var private repnotify @NULL mSRI;
var private @NULL mStats;
var private @NULL mAchievementTracker;
var private byte mSavedAchievementTrackerShotgunTrackingState;
var private byte mNetMoveMode;
var private bool mNetDualServerMove;
var private const float mMiniGameMoveRate;
var float mAnalogSpeedModifier;
var private float mForcedPhysicTick;
var private float mMaxSpeedMod;
var private byte mAckedMaxSpeedMod;
var byte mCompressedMaxSpeedMod;
var private float mSpeedMod;
var private byte mAckedSpeedMod;
var byte mCompressedSpeedMod;
var @NULL mContextAction;
var repnotify @NULL mActiveContextAction;
var @NULL mActionVolume;
var @NULL mPickupMiniGunSentry;
var private transient bool mEnterTurret;
var repnotify int mRivalPlayerId;
var int mSpectatedPlayerId;
var private byte mWinningReason;
var byte mWinReasonRoundOver;
var private byte mWinPlayerRoundOver[8];
var private byte mWinTeamIDRoundOver;
var private @NULL mAimIndexTarget;
var @NULL mAimAssistTarget;
var @NULL mAimReticleTarget;
var byte mAimReticleOverride;
var @NULL mStealthKillTarget;
var @NULL mForcedStealthKillTarget;
var @NULL mVehicleToDrive;
var private @NULL mLastPawnChecked;
var @NULL mZoomer;
var @NULL mStealthZoomer;
var private @NULL mWeaponShakeRot;
var private @NULL mWeaponShakeRotLH;
var private @NULL mKillerPawn;
var name mPendingDeathCam;
var private bool mbDrawLadderHud;
var private @NULL mClimbLadderButtonImage;
var private @NULL mClimbLadderButtonImagePS3;
var private @NULL mClimbLadderDrawFont;
var private const int mClimbLadderHash;
var private const float mClimbLadderTextScale;
var private bool mbLadderPromptInitialized;
var private bool mbTurretPromptInitialized;
var private bool mbTurretIsMinigun;
var array mSPObjectives;
var config float mButtonHoldTime;
var private bool mButtonXWeaponSwapped;
var private bool mButtonYWeaponSwapped;
var @NULL mPopupController;
var bool mZoomPressed;
var bool mActionPressed;
var bool mbSkipCinema;
var bool mbCinemaDisabledDive;
var bool mValidStoredMotionBlurEnable;
var bool mStoredMotionBlurEnable;
var const config int mNearMissDist;
var byte mTurokSoundMode;
var byte mPrevTurokSoundMode;
var @NULL mEmitterManager;

replication
{
    // Pos:0x000
    if(bNetDirty
        mActiveContextAction, mContextAction, 
        mHitReactionInfo, mPickupMiniGunSentry, 
        mRivalPlayerId, mSRI, 
        mSpectatedPlayerId;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2C
    if(VarName == 'mHitReactionInfo')
    {
        // End:0x29
        if(Pawn != none)
        {
            ApplyHitReaction();
        }        
    }
    else
    {
        // End:0xC9
        if(VarName == 'mActiveContextAction')
        {
            // End:0x59
            if(IsDead())
            {
                DestroyActiveContextAction();                
            }
            else
            {
                // End:0x97
                if(mActiveContextAction == none)
                {
                    // End:0x94
                    if(!IsInState('ShowWinLossText') && !IsInState('ShowWinLossTextBetweenRounds'))
                    {
                        EnterStartState();
                    }                    
                }
                else
                {
                    // End:0xB8
                    if(IsInState('CannedAnimation'))
                    {
                        GotoState('ContextActionAnimation');                        
                    }
                    else
                    {
                        GotoState('PerformingContextAction');
                    }
                }
            }            
        }
        else
        {
            // End:0x102
            if(VarName == 'mRivalPlayerId')
            {
                // End:0xF5
                if(mRivalPlayerId == -1)
                {
                    PlayRivalKilledSpeech();
                }
                UpdatePlayerRival();                
            }
            else
            {
                // End:0x169
                if(VarName == 'mSRI')
                {
                    // End:0x166
                    if(mSRI != none)
                    {
                        // End:0x166
                        if(mStats == none)
                        {
                            mStats = new mSRI.StatsClass;
                            mStats.BindToReplicator(mSRI);
                            InitializeAchievementTracker();
                        }
                    }                    
                }
                else
                {
                    super(Controller).ReplicatedEvent(VarName);
                }
            }
        }
    }
    //return;    
}

// Export UTurokPlayerController::execOnControllerChanged(FFrame&, void* const)
native function OnControllerChanged(int ControllerId, bool bIsConnected);

// Export UTurokPlayerController::execPlayerTick(FFrame&, void* const)
native function PlayerTick(float DeltaTime);

// Export UTurokPlayerController::execUpdateRotation(FFrame&, void* const)
native function UpdateRotation(float DeltaTime);

// Export UTurokPlayerController::execLimitViewRotation(FFrame&, void* const)
native function @NULL LimitViewRotation(@NULL ViewRotation, float ViewPitchMin, float ViewPitchMax);

// Export UTurokPlayerController::execGetWeaponShakeRot(FFrame&, void* const)
native function @NULL GetWeaponShakeRot();

// Export UTurokPlayerController::execUsingFirstPersonCamera(FFrame&, void* const)
native function bool UsingFirstPersonCamera();

// Export UTurokPlayerController::execShouldUpdateCamera(FFrame&, void* const)
native function bool ShouldUpdateCamera();

// Export UTurokPlayerController::execGetPlayerInput(FFrame&, void* const)
native function @NULL GetPlayerInput();

// Export UTurokPlayerController::execApplyKeyBindings(FFrame&, void* const)
native function ApplyKeyBindings();

// Export UTurokPlayerController::execGetPlayerViewPoint(FFrame&, void* const)
native simulated function GetPlayerViewPoint(out @NULL povLocation, out @NULL povRotation);

// Export UTurokPlayerController::execMoveAutonomous(FFrame&, void* const)
native function MoveAutonomous(float DeltaTime, byte CompressedFlags, @NULL newAccel, @NULL DeltaRot);

// Export UTurokPlayerController::execTurokOldServerMove(FFrame&, void* const)
unreliable server native function TurokOldServerMove(float OldTimeStamp, @NULL OldAccel, byte OldMoveFlags, byte OldMaxSpeedModifier, byte OldCurSpeedModifier);

// Export UTurokPlayerController::execTurokServerMove(FFrame&, void* const)
unreliable server native function TurokServerMove(float TimeStamp, @NULL InAccel, int ClientView, byte ClientRoll, byte MoveFlags, byte MaxSpeedMod, byte CurSpeedMod, @NULL ClientLoc);

// Export UTurokPlayerController::execTurokDualServerMove(FFrame&, void* const)
unreliable server native function TurokDualServerMove(float TimeStamp0, @NULL InAccel0, int ClientView0, byte ClientRoll0, byte Flags0, byte MaxSpeedMod0, byte CurSpeedMod0, float TimeStamp1, @NULL InAccel1, int ClientView1, byte ClientRoll1, byte Flags1, byte MaxSpeedMod1, byte CurSpeedMod1, @NULL ClientLoc);

// Export UTurokPlayerController::execSendClientAdjustment(FFrame&, void* const)
native function SendClientAdjustment();

// Export UTurokPlayerController::execSetMaxSpeedModifier(FFrame&, void* const)
native final function SetMaxSpeedModifier(float MaxSpeedMod);

// Export UTurokPlayerController::execSetSpeedModifier(FFrame&, void* const)
native final function SetSpeedModifier(float SpeedMod);

// Export UTurokPlayerController::execCompressSpeedModifier(FFrame&, void* const)
native static final function byte CompressSpeedModifier(float Modifer);

// Export UTurokPlayerController::execUnCompressSpeedModifier(FFrame&, void* const)
native static final function float UnCompressSpeedModifier(byte Modifer);

// Export UTurokPlayerController::execSetContextAction(FFrame&, void* const)
native function SetContextAction(@NULL Action);

// Export UTurokPlayerController::execSetActionVolume(FFrame&, void* const)
native function SetActionVolume(@NULL Volume);

// Export UTurokPlayerController::execGetContextAction(FFrame&, void* const)
native function @NULL GetContextAction();

// Export UTurokPlayerController::execGetActiveContextAction(FFrame&, void* const)
native function @NULL GetActiveContextAction();

// Export UTurokPlayerController::execTickActions(FFrame&, void* const)
native function TickActions(float DeltaTime);

// Export UTurokPlayerController::execCleanupContextActions(FFrame&, void* const)
native function CleanupContextActions();

// Export UTurokPlayerController::execUpdateMultiplayerStats(FFrame&, void* const)
protected native function UpdateMultiplayerStats();

// Export UTurokPlayerController::execDrawWeaponDebug(FFrame&, void* const)
native function DrawWeaponDebug(@NULL HUD);

// Export UTurokPlayerController::execDrawImpactDebug(FFrame&, void* const)
native function DrawImpactDebug(@NULL HUD);

// Export UTurokPlayerController::execDebugNetReset(FFrame&, void* const)
native function int DebugNetReset();

// Export UTurokPlayerController::execDebugNetResetAllClients(FFrame&, void* const)
native function int DebugNetResetAllClients();

// Export UTurokPlayerController::execDrawClimbLadderText(FFrame&, void* const)
native final function DrawClimbLadderText(@NULL HUD);

// Export UTurokPlayerController::execDrawHUDPrompt(FFrame&, void* const)
native final function DrawHUDPrompt(@NULL HUD);

// Export UTurokPlayerController::execHandleGenericAction(FFrame&, void* const)
native static final function bool HandleGenericAction(int inCode, optional float inParameter);

// Export UTurokPlayerController::execFindSoundGroupDuckerIndex(FFrame&, void* const)
native final function int FindSoundGroupDuckerIndex(name SGName);

// Export UTurokPlayerController::execResetSoundGroupVolumes(FFrame&, void* const)
native final function ResetSoundGroupVolumes();

// Export UTurokPlayerController::execGetSoundGroupVolume(FFrame&, void* const)
native final function float GetSoundGroupVolume(name SGName, bool BaseVolume);

// Export UTurokPlayerController::execGetAudioDucker(FFrame&, void* const)
native final function @NULL GetAudioDucker();

// Export UTurokPlayerController::execResetAudioDuckers(FFrame&, void* const)
native final function ResetAudioDuckers();

// Export UTurokPlayerController::execSetSoundGroupVoiceMode(FFrame&, void* const)
native final function SetSoundGroupVoiceMode(name SGName, int applySoundMode);

// Export UTurokPlayerController::execSetSoundMode(FFrame&, void* const)
native final function SetSoundMode(int NewSoundMode);

// Export UTurokPlayerController::execGetSoundMode(FFrame&, void* const)
native final function byte GetSoundMode();

// Export UTurokPlayerController::execSetSoundGroupNoReverb(FFrame&, void* const)
native final function SetSoundGroupNoReverb(name SGName, bool applyNoReverb);

// Export UTurokPlayerController::execSetSoundGroupVolume(FFrame&, void* const)
native function SetSoundGroupVolume(name SGName, float Volume);

// Export UTurokPlayerController::execResetSoundGroupVolume(FFrame&, void* const)
native function ResetSoundGroupVolume(name SGName);

// Export UTurokPlayerController::execSoloSoundGroup(FFrame&, void* const)
native function SoloSoundGroup(name SGName);

// Export UTurokPlayerController::execResetSoundState(FFrame&, void* const)
native function ResetSoundState(optional bool clearAllAudioDuckers);

// Export UTurokPlayerController::execPrintAudioComponents(FFrame&, void* const)
native function PrintAudioComponents();

// Export UTurokPlayerController::execPrintDuckerList(FFrame&, void* const)
native function PrintDuckerList();

// Export UTurokPlayerController::execGetLocalPlayerController(FFrame&, void* const)
native static final function @NULL GetLocalPlayerController();

// Export UTurokPlayerController::execInitEmitterManager(FFrame&, void* const)
native function InitEmitterManager();

// Export UTurokPlayerController::execGetEmitterManager(FFrame&, void* const)
native function @NULL GetEmitterManager();

// Export UTurokPlayerController::execUpdateVoiceMuteList(FFrame&, void* const)
private native final function UpdateVoiceMuteList();

function OnToggleCameraInterpolation(@NULL Action)
{
    local @NULL TCam;

    TCam = TurokPlayerCamera(PlayerCamera);
    // End:0x8E
    if(TCam != none)
    {
        // End:0x56
        if(Action.InputLinks[0].bHasImpulse)
        {
            TCam.mCameraFirstPerson.mCanInterpolate = true;            
        }
        else
        {
            // End:0x8E
            if(Action.InputLinks[1].bHasImpulse)
            {
                TCam.mCameraFirstPerson.mCanInterpolate = false;
            }
        }
    }
    //return;    
}

function OnAIEnterVehicle(@NULL Action)
{
    local array objVarsVehicle;
    local @NULL Vehicle;

    Vehicle = TurokVehicle(Pawn);
    // End:0x95
    if((Pawn != none) && Vehicle == none)
    {
        Action.GetObjectVars(objVarsVehicle, "Vehicle");
        // End:0x95
        if(objVarsVehicle.Length > 0)
        {
            Vehicle = TurokVehicle(objVarsVehicle[0]);
            // End:0x95
            if(Vehicle != none)
            {
                Vehicle.PawnEnter(Pawn, Action.mSeat);
            }
        }
    }
    //return;    
}

function OnAIExitVehicle(@NULL Action)
{
    local @NULL Vehicle, tph;

    Vehicle = TurokVehicle(Pawn);
    // End:0x73
    if(Vehicle != none)
    {
        tph = TurokPawnHuman(Vehicle.Driver);
        // DebugMode: 0
        assert(tph != none);
        Vehicle.PawnExit(tph.mSeatIndex, Action.mbSkipAnimation);        
    }
    else
    {
        // End:0xEE
        if(Pawn != none)
        {
            tph = TurokPawnHuman(Pawn);
            // DebugMode: 0
            assert(tph != none);
            Vehicle = TurokVehicle(tph.DrivenVehicle);
            // End:0xEE
            if(Vehicle != none)
            {
                Vehicle.PawnExit(tph.mSeatIndex, Action.mbSkipAnimation);
            }
        }
    }
    //return;    
}

function OnPlayerTriggerSafeZone(@NULL Action)
{
    // End:0x37
    if(Action.InputLinks[0].bHasImpulse)
    {
        TurokPawnPlayer(Pawn).mIsInKnockDownSafeZone = true;        
    }
    else
    {
        // End:0x6B
        if(Action.InputLinks[1].bHasImpulse)
        {
            TurokPawnPlayer(Pawn).mIsInKnockDownSafeZone = false;
        }
    }
    //return;    
}

function OnGeneric(@NULL inAction)
{
    switch(inAction.Code)
    {
        // End:0x17
        case 0:
            // End:0x43
            break;
        // End:0x40
        case 1:
            HandleGenericAction(inAction.Code, inAction.Parameter);
            // End:0x43
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function OnSetMusicSlider(@NULL inAction)
{
    local int NumChanges, N;

    NumChanges = inAction.SliderChanges.Length;
    N = 0;
    J0x1C:

    // End:0xB6 [Loop If]
    if(N < NumChanges)
    {
        WorldInfo.GetMusicSystem().MusicSetSlider(inAction.TuneNumber, inAction.SliderChanges[N].Slider, inAction.SliderChanges[N].Volume, inAction.SliderChanges[N].Time);
        N++;
        // [Loop Continue]
        goto J0x1C;
    }
    //return;    
}

function OnStartMusic(@NULL inAction)
{
    WorldInfo.GetMusicSystem().MusicPlayTrack(inAction.TuneNumber, inAction.MusicSoundCues, inAction.bSilentStart, inAction.BPM, inAction.NoteType, inAction.BarLength);
    //return;    
}

function OnStopMusic(@NULL inAction)
{
    WorldInfo.GetMusicSystem().MusicStop(inAction.TuneNumber, inAction.FadeOutTime);
    //return;    
}

function OnAudioDucker(@NULL inAction)
{
    local int I;
    local @NULL AudioDucker;

    AudioDucker = GetAudioDucker();
    // End:0x105
    if(AudioDucker != none)
    {
        AudioDucker.SetAudioDuckerItem(inAction.mDuckerName, inAction.mRestoreVolumes, inAction.mFadeTime);
        // End:0x105
        if(!inAction.mRestoreVolumes)
        {
            I = 0;
            J0x6C:

            // End:0xE8 [Loop If]
            if(I < inAction.mDuckerCommands.Length)
            {
                AudioDucker.AddDuckerCommand(inAction.mDuckerName, inAction.mDuckerCommands[I].mSoundGroupName, inAction.mDuckerCommands[I].mTargetVolume);
                I++;
                // [Loop Continue]
                goto J0x6C;
            }
            AudioDucker.ActivateAudioDuckerItem(inAction.mDuckerName);
        }
    }
    //return;    
}

function ShowObjectiveText(int string_hash)
{
    local @NULL HUD;

    HUD = TurokHud(myHUD);
    // End:0x3C
    if(HUD != none)
    {
        HUD.mObjectiveText.InitObjText(string_hash);
    }
    //return;    
}

function OnSetObjective(@NULL inAction)
{
    local @NULL HUD;
    local int string_hash, num_objectives, Index;

    // End:0x2A9
    if(inAction.mObjectiveName != "")
    {
        HUD = TurokHud(myHUD);
        // End:0xFC
        if((inAction.mbOnlyUpdateLocation == true) && inAction.mObjectiveLocation != none)
        {
            Index = 0;
            J0x57:

            // End:0xFA [Loop If]
            if(Index < mSPObjectives.Length)
            {
                // End:0xF0
                if(mSPObjectives[Index].mObjectiveName == inAction.mObjectiveName)
                {
                    mSPObjectives[Index].mLocation = inAction.mObjectiveLocation;
                    // End:0xED
                    if(HUD != none)
                    {
                        HUD.UpdateObjectiveIndicator(inAction.mObjectiveLocation, inAction.mObjectiveName);
                    }
                    // [Explicit Break]
                    goto J0xFA;
                }
                ++Index;
                // [Loop Continue]
                goto J0x57;
            }
            J0xFA:

            return;
        }
        J0xFC:

        // End:0x142 [Loop If]
        if(mSPObjectives.Length != 0)
        {
            // End:0x137
            if(HUD != none)
            {
                HUD.RemoveObjectiveIndicator(mSPObjectives[0].mObjectiveName);
            }
            mSPObjectives.Remove(0, 1);
            // [Loop Continue]
            goto J0xFC;
        }
        num_objectives = mSPObjectives.Length;
        mSPObjectives.Insert(num_objectives, 1);
        mSPObjectives[num_objectives].mObjectiveName = inAction.mObjectiveName;
        // End:0x207
        if(inAction.mObjectiveLocation != none)
        {
            mSPObjectives[num_objectives].mLocation = inAction.mObjectiveLocation;
            // End:0x207
            if((HUD != none) && inAction.mbOnlyShowText == false)
            {
                HUD.AddObjectiveIndicator(inAction.mObjectiveLocation, inAction.mObjectiveName);
            }
        }
        // End:0x2A6
        if((inAction.mStringID != "") && HUD != none)
        {
            string_hash = Class'TurokEngine.TurokUI'.static.GetEngine().GetLocalization().HashAHashString(inAction.mStringID);
            mSPObjectives[num_objectives].mDescStringHash = string_hash;
            ShowObjectiveText(mSPObjectives[num_objectives].mDescStringHash);
        }        
    }
    //return;    
}

function OnClearObjective(@NULL inAction)
{
    local @NULL HUD;
    local int I, num_objectives;

    num_objectives = mSPObjectives.Length;
    I = 0;
    J0x13:

    // End:0x9E [Loop If]
    if(I < num_objectives)
    {
        // End:0x94
        if(mSPObjectives[I].mObjectiveName == inAction.mObjectiveName)
        {
            HUD = TurokHud(myHUD);
            // End:0x86
            if(HUD != none)
            {
                HUD.RemoveObjectiveIndicator(inAction.mObjectiveName);
            }
            mSPObjectives.Remove(I, 1);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x13;
    }
    //return;    
}

function OnCinematicToggleStealthEffect(@NULL Action)
{
    //return;    
}

function OnSetFadeColor(@NULL Action)
{
    // End:0x28
    if(PlayerCamera != none)
    {
        PlayerCamera.FadeColor = Action.mFadeColor;
    }
    //return;    
}

function OnLowerPlayerWeapons(@NULL Action)
{
    local bool bHideHUD, bHideReticle, bLowerWeapons;
    local @NULL TurokPawnHuman, TurokHud, mgr;

    bHideHUD = false;
    bHideReticle = false;
    // End:0x8E
    if(Action.InputLinks[0].bHasImpulse)
    {
        mbCinemaDisabledDive = Action.mbAffectDiveAbility;
        bHideHUD = Action.mbHideHud;
        bHideReticle = Action.mbHideReticle;
        bLowerWeapons = true;
        // End:0x8B
        if(mZoomPressed)
        {
            ZoomReleased();
        }        
    }
    else
    {
        // End:0xCC
        if(Action.InputLinks[1].bHasImpulse)
        {
            mbCinemaDisabledDive = false;
            bHideHUD = false;
            bHideReticle = false;
            bLowerWeapons = false;
        }
    }
    // End:0x17C
    if(Action.mbDoNotAffectWeapons == false)
    {
        TurokPawnHuman = TurokPawnHuman(Pawn);
        // End:0x17C
        if(TurokPawnHuman != none)
        {
            // End:0x17C
            if(TurokPawnHuman.mWeaponMediator != none)
            {
                mgr = TurokInventoryManager(Pawn.InvManager);
                // End:0x15A
                if((mgr != none) && mgr.PendingWeapon != none)
                {
                    mgr.PendingWeapon = none;
                }
                TurokPawnHuman.mWeaponMediator.LowerWeapons(bLowerWeapons);
            }
        }
    }
    TurokHud = TurokHud(myHUD);
    // End:0x1C7
    if(TurokHud != none)
    {
        TurokHud.bShowHUD = !bHideHUD;
        TurokHud.mbShowReticle = !bHideReticle;
    }
    //return;    
}

function OnShowQuiver(@NULL Action)
{
    local @NULL TurokPawnPlayer;

    TurokPawnPlayer = TurokPawnPlayer(Pawn);
    // End:0x40
    if(TurokPawnPlayer != none)
    {
        TurokPawnPlayer.SetQuiverVisibility(!Action.mbShowQuiver);
    }
    //return;    
}

function OnForceLevelRestart(@NULL Action)
{
    // End:0x4D
    if(PlayerCamera != none)
    {
        PlayerCamera.bEnableFading = true;
        PlayerCamera.FadeColor = MakeColor(0, 0, 0, 0);
        PlayerCamera.FadeAmount = 1.0000000;
    }
    GotoState('Dead');
    ServerRestartPlayer();
    //return;    
}

function OnAimReticleOverride(@NULL Action)
{
    mAimReticleOverride = Action.mAimReticleOverride;
    //return;    
}

unreliable client simulated event ClientHearSound(@NULL ASound, @NULL SourceActor, @NULL SourceLocation, bool bStopWhenOwnerDestroyed, optional bool bIsOccluded)
{
    local editinline @NULL AC;

    // End:0x62
    if(SourceActor == none)
    {
        AC = WorldInfo.CreateAudioComponent(ASound, false, bStopWhenOwnerDestroyed);
        // End:0x5F
        if(AC != none)
        {
            AC.bUseOwnerLocation = false;
            AC.Location = SourceLocation;
        }        
    }
    else
    {
        // End:0xBC
        if((SourceActor == (GetViewTarget())) || SourceActor == self)
        {
            AC = CreateAudioComponent(ASound, false, bStopWhenOwnerDestroyed);
            // End:0xB9
            if(AC != none)
            {
                AC.bAllowSpatialization = false;
            }            
        }
        else
        {
            AC = SourceActor.ClientCreateAudioComponent(ASound, bStopWhenOwnerDestroyed);
        }
    }
    // End:0xED
    if(AC == none)
    {
        return;
    }
    // End:0x10B
    if(bIsOccluded)
    {
        AC.VolumeMultiplier *= 0.5000000;
    }
    AC.bAutoDestroy = true;
    // End:0x191
    if(TurokDestroyablePartKActor(SourceActor) != none)
    {
        AC.VolumeMultiplier *= TurokDestroyablePartKActor(SourceActor).mSoundController.GetVolumeMultiplier();
        AC.PitchMultiplier *= TurokDestroyablePartKActor(SourceActor).mSoundController.GetPitchMultiplier();        
    }
    else
    {
        // End:0x206
        if(TurokPawn(SourceActor) != none)
        {
            AC.VolumeMultiplier *= TurokPawn(SourceActor).mSoundController.GetVolumeMultiplier();
            AC.PitchMultiplier *= TurokPawn(SourceActor).mSoundController.GetPitchMultiplier();            
        }
        else
        {
            // End:0x27B
            if(TurokVehicle(SourceActor) != none)
            {
                AC.VolumeMultiplier *= TurokVehicle(SourceActor).mSoundController.GetVolumeMultiplier();
                AC.PitchMultiplier *= TurokVehicle(SourceActor).mSoundController.GetPitchMultiplier();                
            }
            else
            {
                // End:0x2ED
                if(TurokProjectile(SourceActor) != none)
                {
                    AC.VolumeMultiplier *= TurokProjectile(SourceActor).mSoundController.GetVolumeMultiplier();
                    AC.PitchMultiplier *= TurokProjectile(SourceActor).mSoundController.GetPitchMultiplier();
                }
            }
        }
    }
    AC.Play();
    //return;    
}

// Export UTurokPlayerController::execCheckNearMiss(FFrame&, void* const)
native function CheckNearMiss(@NULL Shooter, @NULL W, @NULL WeapLoc, @NULL LineDir, @NULL HitLocation);

simulated function OnForceFeedback(@NULL Action)
{
    // End:0x39
    if(Action.InputLinks[0].bHasImpulse)
    {
        TurokPlayForceFeedbackWaveform(Action.FFWaveform);        
    }
    else
    {
        // End:0x6F
        if(Action.InputLinks[1].bHasImpulse)
        {
            TurokStopForceFeedbackWaveform(Action.FFWaveform);
        }
    }
    //return;    
}

// Export UTurokPlayerController::execTurokPlayForceFeedbackWaveform(FFrame&, void* const)
native function TurokPlayForceFeedbackWaveform(@NULL FFWaveform);

simulated function TurokStopForceFeedbackWaveform(optional @NULL FFWaveform)
{
    // End:0x24
    if(ForceFeedbackManager != none)
    {
        ForceFeedbackManager.StopForceFeedbackWaveform(FFWaveform);
    }
    //return;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local float Radius, Height, sphereSize;
    local @NULL Canvas;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x22
    if(Pawn == none)
    {
        return;
    }
    Canvas = HUD.Canvas;
    // End:0x171
    if(Pawn.Anchor != none)
    {
        Canvas.DrawColor.R = 250;
        Canvas.DrawColor.G = 250;
        Canvas.DrawColor.B = 50;
        Pawn.DrawDebugLine(Pawn.Location, Pawn.Anchor.Location, 250, 250, 50);
        Pawn.DrawDebugSphere(Pawn.Anchor.Location, 25.0000000 - (Sin(WorldInfo.TimeSeconds % float(90)) * float(5)), 4, 250, 250, 50);
        Canvas.__NFUN_465__("ANCHOR: " $ string(Pawn.Anchor), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
    }
    // End:0x293
    if(HUD.ShouldDisplayDebug('AimAssist'))
    {
        HUD.Canvas.SetDrawColor(250, 50, 50);
        HUD.Canvas.__NFUN_465__("Assist: " $ string(mAimAssistTarget));
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0000000, out_YPos);
        // End:0x293
        if(mAimAssistTarget != none)
        {
            sphereSize = TurokPawn(mAimAssistTarget).mAimAssistSphereSize;
            // End:0x268
            if(sphereSize == 0.0000000)
            {
                mAimAssistTarget.GetBoundingCylinder(Radius, Height);
                sphereSize = FMax(Radius, Height);
            }
            Pawn.DrawDebugSphere(mAimAssistTarget.Location, sphereSize, 16, 250, 50, 50);
        }
    }
    // End:0x2D4
    if(HUD.ShouldDisplayDebug('emittermanager'))
    {
        mEmitterManager.DisplayDebug(HUD, out_YL, out_YPos);
    }
    //return;    
}

reliable server function DebugServerBroadcastMessage(string Str)
{
    WorldInfo.Game.Broadcast(self, Str, 'Debug');
    //return;    
}

function DebugBroadcastMessage(string Msg)
{
    DebugServerBroadcastMessage(Msg);
    //return;    
}

function DebugMessage(string Msg)
{
    ClientMessage(Msg);
    //return;    
}

function bool IsShowWeaponDebug()
{
    return mbDrawWeaponDebug;
    //return ReturnValue;    
}

simulated function NotifyWeaponEquipped(@NULL EquippedWeapon)
{
    // End:0x13
    if(mZoomPressed)
    {
        ZoomPressed();
    }
    //return;    
}

simulated function UpdatePlayerRival()
{
    local @NULL TP;

    // End:0x30
    foreach WorldInfo.AllPawns(Class'TurokPawnPlayer', TP)
    {
        TP.UpdatePlayerColor();        
    }    
    //return;    
}

simulated function bool IsPlayerRival(@NULL MPPlayer)
{
    // End:0x23
    if(MPPlayer.PlayerReplicationInfo.PlayerID == mRivalPlayerId)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function PlayRivalKilledSpeech()
{
    local @NULL GRI;

    GRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
    // End:0x76
    if((GRI != none) && GRI.GetMissionInfo() != none)
    {
        GRI.GetMissionInfo().PlayRivalKilledSpeech(int(GetTeamNum()), TurokHud(myHUD));
    }
    //return;    
}

function NotifyGraphStart(@NULL graph, byte actorType)
{
    // End:0x41
    if((Pawn != none) && !Pawn.IsInState('CannedAnimation'))
    {
        Pawn.PushState('CannedAnimation');
    }
    GotoState('CannedAnimation');
    //return;    
}

function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    //return;    
}

function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    //return;    
}

function GraphEvent(@NULL Event, byte actorType)
{
    //return;    
}

function int GraphBranch(@NULL branch, byte actorType)
{
    return branch.mPreviewBranchIndex;
    //return ReturnValue;    
}

function bool GraphInterrupt(@NULL Item, byte actorType)
{
    return false;
    //return ReturnValue;    
}

function float GraphBlend(@NULL blend)
{
    return blend.mChild2Weight;
    //return ReturnValue;    
}

simulated event PostBeginPlay()
{
    local @NULL GI;

    super.PostBeginPlay();
    // End:0xE7
    if(int(Role) == int(ROLE_Authority))
    {
        GI = TurokGameInfo(WorldInfo.Game);
        // End:0xE7
        if(GI != none)
        {
            mSRI = __NFUN_278__(GI.mStatsReplicationClass, self);
            mStats = new mSRI.StatsClass;
            mStats.BindToReplicator(mSRI);
            mStats.Clear();
            GetStatTracker().RegisterPlayerStats(self, mStats);
            // End:0xE7
            if(WorldInfo.Game.bMultiplayerGame)
            {
                SetTimer(GameStatUpdateRate, true, 'UpdateMultiplayerStats');
            }
        }
    }
    TurokOnlineSub = Class'Engine.GameEngine'.static.GetTurokOnlineSubsystem();
    // End:0x185
    if(TurokOnlineSub != none)
    {
        VoiceInterface = TurokOnlineSub.VoiceInterface;
        // End:0x185
        if(NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none)))
        {
            // End:0x185
            if(((int(Role) == int(ROLE_Authority)) && WorldInfo.Game != none) && WorldInfo.Game.bMultiplayerGame)
            {
                SetTimer(VoiceCommUpdateRate, true, 'UpdateVoiceMuteList');
            }
        }
    }
    // End:0x1A1
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        EnterMultiplayerGame();
    }
    //return;    
}

function Reset()
{
    super.Reset();
    mRivalPlayerId = 0;
    // End:0x29
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        EnterMultiplayerGame();
    }
    //return;    
}

simulated event ReceivedPlayer()
{
    super.ReceivedPlayer();
    // End:0x44
    if(IsLocalPlayerController())
    {
        UpdateSettingsFromProfile();
        InitializeAchievementTracker();
        mHitReactionManager.Init();
        InitEmitterManager();
    }
    //return;    
}

function OnExternalUIChanged(bool bIsOpening)
{
    bIsExternalUIOpen = bIsOpening;
    //return;    
}

// Export UTurokPlayerController::execApplyPlayerPreferences(FFrame&, void* const)
native function ApplyPlayerPreferences(optional bool bInitSystem);

event InitInputSystem()
{
    super.InitInputSystem();
    ApplyPlayerPreferences(true);
    // End:0x8B
    if(TurokOnlineSub != none)
    {
        // End:0x88
        if(NotEqual_InterfaceInterface(TurokOnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            TurokOnlineSub.SystemInterface.SetExternalUIChangeDelegate(OnExternalUIChanged);
            TurokOnlineSub.SystemInterface.SetControllerChangeDelegate(OnControllerChanged);            
        }        
    }
    //return;    
}

simulated event Destroyed()
{
    CleanupContextActions();
    // End:0x9E
    if(IsLocalPlayerController())
    {
        // End:0x8B
        if(TurokOnlineSub != none)
        {
            // End:0x8B
            if(NotEqual_InterfaceInterface(TurokOnlineSub.SystemInterface, OnlineSystemInterface(none)))
            {
                TurokOnlineSub.SystemInterface.ClearExternalUIChangeDelegate(OnExternalUIChanged);
                TurokOnlineSub.SystemInterface.ClearControllerChangeDelegate(OnControllerChanged);
            }
        }
        mHitReactionManager.UnInit();
    }
    // End:0xBC
    if(mSRI != none)
    {
        mSRI.Destroy();
        mSRI = none;
    }
    // End:0x124
    if(mStats != none)
    {
        // End:0x10A
        if((WorldInfo.Game != none) && (GetStatTracker()) != none)
        {
            GetStatTracker().DeregisterPlayerStats(mStats);
        }
        mStats.Clear();
        mStats = none;
    }
    // End:0x149
    if(mAchievementTracker != none)
    {
        mAchievementTracker.UnInit();
        mAchievementTracker = none;
    }
    // End:0x167
    if(myHUD != none)
    {
        myHUD.Destroy();
        myHUD = none;
    }
    super.Destroyed();
    //return;    
}

function CleanupPRI()
{
    // End:0x1E
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.Destroy();
        PlayerReplicationInfo = none;
    }
    //return;    
}

event PreRender(@NULL Canvas)
{
    // End:0x3A
    if((TurokPawnPlayer(Pawn) != none) && !IsPaused())
    {
        TurokPawnPlayer(Pawn).PreRender(Canvas);
    }
    //return;    
}

event bool IsDeadCpp()
{
    return IsDead();
    //return ReturnValue;    
}

simulated function InitializeAchievementTracker()
{
    local @NULL db, Profile;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0x9F
    if(db != none)
    {
        Profile = TurokOnlineProfile(db.GetSignedInProfile());
        // End:0x9F
        if(Profile != none)
        {
            // End:0x9F
            if(mStats != none)
            {
                mAchievementTracker = Class'TurokAchievementTracker'.static.SafeConstruct();
                mAchievementTracker.Init(mStats, Profile, self);
                mStats.SetAchievementTracker(mAchievementTracker);
            }
        }
    }
    //return;    
}

function UpdateOptionsSettingInvertMouse(int invert)
{
    local bool bInvert;

    // End:0x16
    if(invert == 0)
    {
        bInvert = false;        
    }
    else
    {
        bInvert = true;
    }
    PlayerInput.bInvertMouse = bInvert;
    //return;    
}

function UpdateOptionsSettingVibration(int vibrate)
{
    local bool bVibrate;

    // End:0x3F
    if(ForceFeedbackManager != none)
    {
        // End:0x21
        if(vibrate == 0)
        {
            bVibrate = false;            
        }
        else
        {
            bVibrate = true;
        }
        ForceFeedbackManager.bAllowsForceFeedback = bVibrate;
    }
    //return;    
}

function UpdateOptionsSettingSensitivity(float sensitivity)
{
    // End:0x1A
    if(sensitivity < 30.0000000)
    {
        sensitivity = 30.0000000;
    }
    // End:0x34
    if(sensitivity > 100.0000000)
    {
        sensitivity = 100.0000000;
    }
    TurokPlayerInput(PlayerInput).mSensitivityPlayerAdjustment = sensitivity / 100.0000000;
    //return;    
}

simulated function UpdateSettingsFromProfile()
{
    local @NULL db, Profile;
    local int temp_int, invert, vibrate;
    local float sensitivity;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0x179
    if(db != none)
    {
        Profile = TurokOnlineProfile(db.GetSignedInProfile());
        // End:0x12A
        if(Profile != none)
        {
            Profile.GetProfileSettingValueId(2, temp_int);
            // End:0x74
            if(temp_int == 1)
            {
                invert = 1;                
            }
            else
            {
                invert = 0;
            }
            UpdateOptionsSettingInvertMouse(invert);
            Profile.GetProfileSettingValueInt(1, temp_int);
            // End:0xB9
            if(temp_int == 3)
            {
                vibrate = 1;                
            }
            else
            {
                vibrate = 0;
            }
            UpdateOptionsSettingVibration(vibrate);
            Profile.GetProfileSettingValueInt(13, temp_int);
            sensitivity = float(temp_int);
            UpdateOptionsSettingSensitivity(sensitivity);
            db.SetPlayerSettingsNoProfile(invert, vibrate, sensitivity);            
        }
        else
        {
            db.GetPlayerSettingsNoProfile(invert, vibrate, sensitivity);
            UpdateOptionsSettingInvertMouse(invert);
            UpdateOptionsSettingVibration(vibrate);
            UpdateOptionsSettingSensitivity(sensitivity);
        }
    }
    //return;    
}

event WritePersonalStats(@NULL Profile)
{
    local @NULL TurokProfile, Achievements;

    TurokProfile = TurokOnlineProfile(Profile);
    // DebugMode: 0
    assert(TurokProfile != none);
    // End:0x29
    if(mStats == none)
    {
        return;
    }
    // End:0x50
    if(TurokMultiplayerStats(mStats) != none)
    {
        TurokProfile.MergeMPStats(mStats);        
    }
    else
    {
        TurokProfile.MergeCommonStats(mStats);
        mStats.Clear();
        mAchievementTracker.ReloadLifetimeStats();
    }
    // End:0xE2
    if(Class'Engine.Engine'.static.IsXenon() == false)
    {
        Achievements = TurokAchievements(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfileAchievements());
        // End:0xE2
        if(Achievements != none)
        {
            TurokProfile.SetAchievements(Achievements);
        }
    }
    //return;    
}

event NotifyNetworkSessionEnded()
{
    GotoState('NetGameEnded');
    //return;    
}

protected simulated function EnterMultiplayerGame()
{
    local @NULL ConnectViewpoint, ViewPoint;
    local byte ViewpointTeam;
    local @NULL Lobby, LobbyGS, LocalLobbyPlayer;

    ViewpointTeam = 0;
    // End:0xC6
    if(Class'Engine.Engine'.static.GetTurokNet() != none)
    {
        Lobby = Class'Engine.Engine'.static.GetTurokNet().GetLobby();
        // End:0xC6
        if((Lobby != none) && int(Lobby.GetGameState()) != int(0))
        {
            LobbyGS = Lobby.GetGameSettings();
            // End:0xC6
            if((LobbyGS.GetGameModeId() == 2) && Lobby.GetLocalOnlinePlayer(LocalLobbyPlayer))
            {
                // End:0xC6
                if(int(LocalLobbyPlayer.Team) == 1)
                {
                    ViewpointTeam = 1;
                }
            }
        }
    }
    ConnectViewpoint = none;
    ViewPoint = none;
    // End:0x140
    foreach WorldInfo.AllNavigationPoints(Class'TurokMPViewpoint', ViewPoint)
    {
        // End:0x13F
        if((int(ViewPoint.GetViewpointReason()) == int(0)) && int(ViewPoint.GetViewpointAssign()) == int(ViewpointTeam))
        {
            ConnectViewpoint = ViewPoint;
            // End:0x140
            break;
        }        
    }    
    // End:0x1A5
    if(ConnectViewpoint != none)
    {
        SetViewTarget(ConnectViewpoint);
        ConnectViewpoint.NotifyActivation(self);
        SetLocation(ConnectViewpoint.Location);
        SetRotation(ConnectViewpoint.Rotation);
        SimulatedSetTurokCamera('MPViewpoint');
    }
    IgnoreMoveInput(true);
    IgnoreLookInput(true);
    //return;    
}

reliable server event ServerShortTimeout()
{
    bShortConnectTimeOut = true;
    ResetTimeMargin();
    //return;    
}

reliable client simulated function ClientSetRemainingTime(@NULL GRI, int RemainingTime)
{
    // End:0x28
    if(WorldInfo.GRI == none)
    {
        WorldInfo.GRI = GRI;
    }
    // End:0x59
    if(WorldInfo.GRI != none)
    {
        WorldInfo.GRI.RemainingTime = RemainingTime;
    }
    //return;    
}

private final simulated function SetNetMoveMode(byte moveMode)
{
    // End:0x15
    if(int(mNetMoveMode) == int(moveMode))
    {
        return;
    }
    // End:0x37
    if((int(mNetMoveMode) == int(0)) || int(moveMode) == int(0))
    {
    }
    ClearNetMoveVariables();
    mNetMoveMode = moveMode;
    //return;    
}

private final simulated function ClearNetMoveVariables()
{
    Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    // End:0x59
    if(Pawn != none)
    {
        Pawn.Acceleration = Acceleration;
        Pawn.Velocity = Velocity;
    }
    bPressedJump = false;
    bDuck = 0;
    bRun = 0;
    mMaxSpeedMod = 1.0000000;
    mAckedMaxSpeedMod = 128;
    mCompressedMaxSpeedMod = 128;
    mSpeedMod = 1.0000000;
    mAckedSpeedMod = 128;
    mCompressedSpeedMod = 128;
    ClearAckedMoves();
    CleanOutSavedMoves();
    ClientUpdateTime = WorldInfo.TimeSeconds;
    CurrentTimeStamp = 0.0000000;
    ResetTimeMargin();
    ServerTimeStamp = 0.0000000;
    LastActiveTime = WorldInfo.TimeSeconds;
    LastUpdateTime = 0.0000000;
    PendingAdjustment.TimeStamp = 0.0000000;
    PendingAdjustment.bAckGoodMove = 0;
    mForcedPhysicTick = 0.0000000;
    //return;    
}

function int GetNetErrorCount()
{
    return mNetErrorCount;
    //return ReturnValue;    
}

private final function @NULL FindClimbableLadder()
{
    local @NULL humanPawn, lv;

    humanPawn = TurokPawnHuman(Pawn);
    // End:0xDC
    if((humanPawn != none) && humanPawn.CanGrabLadder())
    {
        lv = TurokLadderVolume(humanPawn.PhysicsVolume);
        // End:0xDC
        if(((lv != none) && lv.Encompasses(humanPawn)) && humanPawn.mLadderController.CanStartClimbing(lv))
        {
            humanPawn.mLadderController.CacheAnimData(lv);
            // End:0xDC
            if(lv.IsPawnAbleToClimb(humanPawn))
            {
                return lv;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

private final function NetLocalMove(float DeltaTime)
{
    // DebugMode: 0
    assert(int(mNetMoveMode) == int(2));
    //return;    
}

private final function NetMiniGameMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove)
{
    local byte MoveFlags;
    local bool bSuppressMove;

    bSuppressMove = false;
    // End:0x3F
    if(((WorldInfo.TimeSeconds - ClientUpdateTime) * WorldInfo.TimeDilation) < mMiniGameMoveRate)
    {
        bSuppressMove = true;
    }
    // End:0x5E
    if(Pawn != none)
    {
        Pawn.AutonomousPhysics(DeltaTime);        
    }
    else
    {
        AutonomousPhysics(DeltaTime);
    }
    // End:0xBD
    if(!bSuppressMove)
    {
        MoveFlags = Class'TurokSavedMove'.static.GetFlags(self, DoubleClickMove);
        ServerMiniGameMove(DeltaTime, newAccel, MoveFlags);
        bPressedJump = false;
        bDuck = 0;
        bRun = 0;
    }
    //return;    
}

unreliable server function ServerMiniGameMove(float DeltaTime, @NULL newAccel, byte NewFlags)
{
    local byte DoubleClickMove;

    // End:0x12
    if(int(mNetMoveMode) != int(1))
    {
        return;
    }
    ServerTimeStamp = WorldInfo.TimeSeconds;
    DoubleClickMove = SavedMoveClass.static.SetFlags(NewFlags, self);
    ProcessMove(DeltaTime, newAccel, DoubleClickMove, rot(0, 0, 0));
    //return;    
}

function ReplicateMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
{
    local @NULL NewMove, OldMove, LastMove, tPendingMove, AlmostLastMove;

    local byte ClientRoll;
    local float NetMoveDelta;

    // End:0x12
    if(int(mNetMoveMode) != int(0))
    {
        return;
    }
    MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
    DeltaTime = FMin(DeltaTime, MaxResponseTime);
    // End:0x62
    if(ClientUpdateTime == WorldInfo.TimeSeconds)
    {
        DeltaTime = 0.0300000;
    }
    // End:0x115
    if(SavedMoves != none)
    {
        LastMove = TurokSavedMove(SavedMoves);
        AlmostLastMove = LastMove;
        OldMove = none;
        J0x8F:

        // End:0x115 [Loop If]
        if(LastMove.NextMove != none)
        {
            // End:0xEE
            if(((OldMove == none) && Pawn != none) && LastMove.TurokIsImportantMove(self, LastAckedAccel, mAckedMaxSpeedMod, mAckedSpeedMod))
            {
                OldMove = LastMove;
            }
            AlmostLastMove = LastMove;
            LastMove = TurokSavedMove(LastMove.NextMove);
            // [Loop Continue]
            goto J0x8F;
        }
    }
    NewMove = TurokSavedMove(GetFreeMove());
    // End:0x133
    if(NewMove == none)
    {
        return;
    }
    NewMove.TurokSetMoveFor(self, DeltaTime, newAccel);
    bDoubleJump = false;
    ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DoubleClickMove, DeltaRot);
    // End:0x457
    if(Pawn != none)
    {
        Pawn.InitMovementPhysics(NewMove.Delta);
        NewMove.TurokPreMove(self, TurokPawn(Pawn));
        tPendingMove = TurokSavedMove(PendingMove);
        // End:0x457
        if((tPendingMove != none) && tPendingMove.TurokCanCombineWith(NewMove, Pawn, MaxResponseTime))
        {
            Pawn.SetLocation(tPendingMove.TurokGetStartPosition());
            Pawn.Velocity = tPendingMove.StartVelocity;
            // End:0x27B
            if(tPendingMove.StartBase != Pawn.Base)
            {
            }
            Pawn.SetBase(tPendingMove.StartBase);
            Pawn.Floor = tPendingMove.StartFloor;
            Pawn.Mesh.RootMotionDelta += tPendingMove.mRootMotionDelta;
            Pawn.Mesh.RootMotionRotation = Normalize(tPendingMove.mRootMotionRotation + Pawn.Mesh.RootMotionRotation);
            NewMove.mRootMotionDelta += tPendingMove.mRootMotionDelta;
            NewMove.mRootMotionRotation = Normalize(tPendingMove.mRootMotionRotation + NewMove.mRootMotionRotation);
            NewMove.Delta += tPendingMove.Delta;
            NewMove.TurokSetStartPosition(Pawn);
            tPendingMove = none;
            // End:0x450
            if(LastMove == PendingMove)
            {
                // End:0x3F8
                if(SavedMoves == PendingMove)
                {
                    SavedMoves.NextMove = FreeMoves;
                    FreeMoves = SavedMoves;
                    SavedMoves = none;                    
                }
                else
                {
                    PendingMove.NextMove = FreeMoves;
                    FreeMoves = PendingMove;
                    // End:0x43D
                    if(AlmostLastMove != none)
                    {
                        AlmostLastMove.NextMove = none;
                        LastMove = AlmostLastMove;
                    }
                }
                FreeMoves.Clear();
            }
            PendingMove = none;
        }
    }
    // End:0x47F
    if(Pawn != none)
    {
        Pawn.AutonomousPhysics(NewMove.Delta);        
    }
    else
    {
        AutonomousPhysics(DeltaTime);
    }
    NewMove.TurokPostMove(self);
    // End:0x4B4
    if(SavedMoves == none)
    {
        SavedMoves = NewMove;        
    }
    else
    {
        LastMove.NextMove = NewMove;
    }
    // End:0x5BA
    if(PendingMove == none)
    {
        // End:0x530
        if(((Player.CurrentNetSpeed > 10000) && WorldInfo.GRI != none) && WorldInfo.GRI.PRIArray.Length <= 10)
        {
            NetMoveDelta = 0.0110000;            
        }
        else
        {
            NetMoveDelta = FMax(0.0222000, (2.0000000 * WorldInfo.MoveRepSize) / float(Player.CurrentNetSpeed));
        }
        // End:0x5BA
        if((WorldInfo.TimeSeconds != ClientUpdateTime) && ((WorldInfo.TimeSeconds - ClientUpdateTime) * WorldInfo.TimeDilation) < NetMoveDelta)
        {
            PendingMove = NewMove;
            return;
        }
    }
    ClientUpdateTime = WorldInfo.TimeSeconds;
    ClientRoll = byte((Rotation.Roll >> 8) & 255);
    TurokCallServerMove(NewMove, OldMove, ((Pawn == none) ? Location : Pawn.Location), ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535), ClientRoll);
    PendingMove = none;
    //return;    
}

function TurokCallServerMove(@NULL NewMove, @NULL OldMove, @NULL ClientLoc, int ClientView, byte ClientRoll)
{
    local @NULL tPendingMove;

    // End:0x60
    if(OldMove != none)
    {
        TurokOldServerMove(OldMove.TimeStamp, OldMove.Acceleration, OldMove.CompressedFlags(), OldMove.mMaxSpeedMod, OldMove.mSpeedMod);
    }
    // End:0x193
    if(PendingMove != none)
    {
        tPendingMove = TurokSavedMove(PendingMove);
        TurokDualServerMove(tPendingMove.TimeStamp, tPendingMove.Acceleration, ((tPendingMove.Rotation.Yaw & 65535) << 16) + (tPendingMove.Rotation.Pitch & 65535), byte((tPendingMove.Rotation.Roll >> 8) & 255), tPendingMove.CompressedFlags(), tPendingMove.mMaxSpeedMod, tPendingMove.mSpeedMod, NewMove.TimeStamp, NewMove.Acceleration, ClientView, ClientRoll, NewMove.CompressedFlags(), NewMove.mMaxSpeedMod, NewMove.mSpeedMod, ClientLoc);        
    }
    else
    {
        TurokServerMove(NewMove.TimeStamp, NewMove.Acceleration, ClientView, ClientRoll, NewMove.CompressedFlags(), NewMove.mMaxSpeedMod, NewMove.mSpeedMod, ClientLoc);
    }
    //return;    
}

unreliable server function ServerDrive(float InForward, float InStrafe, float aUp, bool InJump, int View)
{
    local @NULL ViewRotation;

    ViewRotation.Pitch = View & 65535;
    ViewRotation.Yaw = View >> 16;
    ViewRotation.Roll = 0;
    SetRotation(ViewRotation);
    // End:0x8A
    if((Pawn != none) && Vehicle(Pawn) == none)
    {
        DesiredRotation = ViewRotation;
        Pawn.DesiredRotation = DesiredRotation;
    }
    ProcessDrive(InForward, InStrafe, aUp, InJump);
    //return;    
}

function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
{
    super.ProcessDrive(InForward, InStrafe, InUp, InJump);
    //return;    
}

unreliable server function ServerRide(float DeltaTime, int View)
{
    local @NULL ViewRotation;

    ViewRotation.Pitch = View & 65535;
    ViewRotation.Yaw = View >> 16;
    ViewRotation.Roll = 0;
    SetRotation(ViewRotation);
    // End:0x78
    if(Pawn != none)
    {
        DesiredRotation = ViewRotation;
        Pawn.DesiredRotation = DesiredRotation;
    }
    // End:0x97
    if(Pawn != none)
    {
        Pawn.AutonomousPhysics(DeltaTime);        
    }
    else
    {
        AutonomousPhysics(DeltaTime);
    }
    bDuck = 0;
    bRun = 0;
    bPressedJump = false;
    //return;    
}

event ResetTimeMargin()
{
    // End:0x1A
    if(mForcedPhysicTick != 0.0000000)
    {
        mForcedPhysicTick = 0.0000000;
    }
    super.ResetTimeMargin();
    //return;    
}

function CleanOutSavedMoves()
{
    mNetErrorCount = 0;
    super.CleanOutSavedMoves();
    //return;    
}

unreliable server function ServerMove(float TimeStamp, @NULL InAccel, @NULL ClientLoc, byte NewFlags, byte ClientRoll, int View)
{
    //return;    
}

event ClientUpdatePosition()
{
    local @NULL CurMove;
    local int realbRun, realbDuck;
    local bool bRealJump;
    local int numMovesReplayed;
    local float savedMaxSpeedModifier, savedCurSpeedModifier;
    local @NULL savedRootMotionDelta, savedRootMotionRotation;

    bUpdatePosition = false;
    // End:0x30
    if((Pawn != none) && int(Pawn.Physics) == int(10))
    {
        return;
    }
    realbRun = int(bRun);
    realbDuck = int(bDuck);
    bRealJump = bPressedJump;
    bUpdating = true;
    numMovesReplayed = 0;
    ClearAckedMoves();
    // End:0x318
    if(Pawn != none)
    {
        savedMaxSpeedModifier = mMaxSpeedMod;
        savedCurSpeedModifier = mSpeedMod;
        savedRootMotionDelta = Pawn.Mesh.RootMotionDelta;
        savedRootMotionRotation = Pawn.Mesh.RootMotionRotation;
        CurMove = TurokSavedMove(SavedMoves);
        J0xDB:

        // End:0x2C8 [Loop If]
        if(CurMove != none)
        {
            ++numMovesReplayed;
            // End:0x126
            if((PendingMove == CurMove) && Pawn != none)
            {
                TurokSavedMove(PendingMove).TurokSetStartPosition(Pawn);
            }
            mMaxSpeedMod = UnCompressSpeedModifier(CurMove.mMaxSpeedMod);
            mSpeedMod = UnCompressSpeedModifier(CurMove.mSpeedMod);
            Pawn.Mesh.RootMotionDelta = CurMove.mRootMotionDelta;
            Pawn.Mesh.RootMotionRotation = CurMove.mRootMotionRotation;
            MoveAutonomous(CurMove.Delta, CurMove.CompressedFlags(), CurMove.Acceleration, rot(0, 0, 0));
            CurMove.SavedLocation = Pawn.Location;
            CurMove.SavedVelocity = Pawn.Velocity;
            CurMove.EndBase = Pawn.Base;
            // End:0x2AC
            if((CurMove.EndBase != none) && !CurMove.EndBase.bWorldGeometry)
            {
                CurMove.SavedRelativeLocation = Pawn.Location - CurMove.EndBase.Location;
            }
            CurMove = TurokSavedMove(CurMove.NextMove);
            // [Loop Continue]
            goto J0xDB;
        }
        Pawn.Mesh.RootMotionDelta = savedRootMotionDelta;
        Pawn.Mesh.RootMotionRotation = savedRootMotionRotation;
        mSpeedMod = savedCurSpeedModifier;
        mMaxSpeedMod = savedMaxSpeedModifier;
    }
    bUpdating = false;
    bPressedJump = bRealJump;
    bDuck = byte(realbDuck);
    bRun = byte(realbRun);
    //return;    
}

unreliable client simulated event TurokVeryShortClientAdjustPosition(float TimeStamp, float NewLocX, float NewLocY, float NewLocZ, @NULL NewBase)
{
    local @NULL Floor;

    // End:0x1F
    if(Pawn != none)
    {
        Floor = Pawn.Floor;
    }
    TurokLongClientAdjustPosition(TimeStamp, 'PlayerWalking', 1, NewLocX, NewLocY, NewLocZ, 0.0000000, 0.0000000, 0.0000000, NewBase, Floor.X, Floor.Y, Floor.Z);
    //return;    
}

unreliable client simulated event TurokShortClientAdjustPosition(float TimeStamp, name NewState, byte newPhysics, float NewLocX, float NewLocY, float NewLocZ, @NULL NewBase)
{
    local @NULL Floor;

    // End:0x1F
    if(Pawn != none)
    {
        Floor = Pawn.Floor;
    }
    TurokLongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, 0.0000000, 0.0000000, 0.0000000, NewBase, Floor.X, Floor.Y, Floor.Z);
    //return;    
}

unreliable client simulated event TurokClientAdjustPosition(float TimeStamp, name NewState, byte newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, @NULL NewBase)
{
    local @NULL Floor;

    // End:0x1F
    if(Pawn != none)
    {
        Floor = Pawn.Floor;
    }
    TurokLongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, Floor.X, Floor.Y, Floor.Z);
    //return;    
}

unreliable client simulated event TurokLongClientAdjustPosition(float TimeStamp, name NewState, byte newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, @NULL NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
{
    local @NULL NewLocation, NewVelocity, NewFloor, MoveActor, CurrentMove, TheViewTarget;

    ++mNetErrorCount;
    UpdatePing(TimeStamp);
    // End:0xEA
    if(Pawn != none)
    {
        // End:0x69
        if(Pawn.bTearOff)
        {
            Pawn = none;
            // End:0x67
            if(!GamePlayEndedState() && !IsInState('Dead'))
            {
                GotoState('Dead');
            }
            return;
        }
        MoveActor = Pawn;
        TheViewTarget = GetViewTarget();
        // End:0xE7
        if((TheViewTarget != Pawn) && (TheViewTarget == self) || (Pawn(TheViewTarget) != none) && Pawn(TheViewTarget).Health <= 0)
        {
            ResetCameraMode();
            SetViewTarget(Pawn);
        }        
    }
    else
    {
        MoveActor = self;
        // End:0x197
        if(GetStateName() != NewState)
        {
            // End:0x133
            if((NewState == 'RoundEnded') || NewState == 'ShowWinLossText')
            {
                GotoState(NewState);                
            }
            else
            {
                // End:0x17A
                if(IsInState('Dead'))
                {
                    // End:0x175
                    if((NewState != 'PlayerWalking') && NewState != 'PlayerSwimming')
                    {
                        GotoState(NewState);
                    }
                    return;                    
                }
                else
                {
                    // End:0x197
                    if(NewState == 'Dead')
                    {
                        GotoState(NewState);
                    }
                }
            }
        }
    }
    // End:0x1A8
    if(CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    CurrentTimeStamp = TimeStamp;
    NewLocation.X = NewLocX;
    NewLocation.Y = NewLocY;
    NewLocation.Z = NewLocZ;
    NewVelocity.X = NewVelX;
    NewVelocity.Y = NewVelY;
    NewVelocity.Z = NewVelZ;
    // End:0x243
    if(int(mNetMoveMode) != int(0))
    {
        return;
    }
    CurrentMove = TurokSavedMove(SavedMoves);
    J0x253:

    // End:0x501 [Loop If]
    if(CurrentMove != none)
    {
        // End:0x4F7
        if(CurrentMove.TimeStamp <= CurrentTimeStamp)
        {
            SavedMoves = CurrentMove.NextMove;
            CurrentMove.NextMove = FreeMoves;
            FreeMoves = CurrentMove;
            // End:0x4D1
            if(CurrentMove.TimeStamp == CurrentTimeStamp)
            {
                LastAckedAccel = CurrentMove.Acceleration;
                FreeMoves.Clear();
                // End:0x41B
                if(((InterpActor(NewBase) != none) || Vehicle(NewBase) != none) && NewBase == CurrentMove.EndBase)
                {
                    // End:0x418
                    if(((GetStateName() == NewState) && IsInState('PlayerWalking')) && (int(MoveActor.Physics) == int(1)) || int(MoveActor.Physics) == int(2))
                    {
                        // End:0x3AA
                        if(VSizeSq(CurrentMove.SavedRelativeLocation - NewLocation) < 4.0000000)
                        {
                            CurrentMove = none;
                            return;                            
                        }
                        else
                        {
                            // End:0x418
                            if((((Vehicle(NewBase) != none) && VSizeSq(Velocity) < 4.0000000) && VSizeSq(NewVelocity) < 4.0000000) && VSizeSq(CurrentMove.SavedRelativeLocation - NewLocation) < 300.0000000)
                            {
                                CurrentMove = none;
                                return;
                            }
                        }
                    }                    
                }
                else
                {
                    // End:0x4C7
                    if(((((VSizeSq(CurrentMove.SavedLocation - NewLocation) < 4.0000000) && VSizeSq(CurrentMove.SavedVelocity - NewVelocity) < 4.0000000) && GetStateName() == NewState) && IsInState('PlayerWalking')) && (int(MoveActor.Physics) == int(1)) || int(MoveActor.Physics) == int(2))
                    {
                        CurrentMove = none;
                        return;
                    }
                }
                CurrentMove = none;                
            }
            else
            {
                FreeMoves.Clear();
                CurrentMove = TurokSavedMove(SavedMoves);
            }            
        }
        else
        {
            CurrentMove = none;
        }
        // [Loop Continue]
        goto J0x253;
    }
    // End:0x574
    if(MoveActor.bHardAttach)
    {
        // End:0x572
        if(MoveActor.Base == none)
        {
            // End:0x546
            if(NewBase != none)
            {
                MoveActor.SetBase(NewBase);
            }
            // End:0x56D
            if(MoveActor.Base == none)
            {
                MoveActor.SetHardAttach(false);                
            }
            else
            {
                return;
            }            
        }
        else
        {
            return;
        }
    }
    NewFloor.X = NewFloorX;
    NewFloor.Y = NewFloorY;
    NewFloor.Z = NewFloorZ;
    // End:0x5EA
    if((InterpActor(NewBase) != none) || Vehicle(NewBase) != none)
    {
        NewLocation += NewBase.Location;
    }
    MoveActor.bCanTeleport = false;
    // End:0x612
    if(MoveActor.SetLocation(NewLocation))
    {        
    }
    else
    {
        // End:0x745
        if(((((Pawn(MoveActor) != none) && Pawn(MoveActor).CylinderComponent.CollisionHeight > Pawn(MoveActor).CrouchHeight) && !Pawn(MoveActor).bIsCrouched) && int(newPhysics) == int(1)) && int(MoveActor.Physics) != int(10))
        {
            MoveActor.SetPhysics(newPhysics);
            // End:0x717
            if(!MoveActor.SetLocation(NewLocation + (vect(0.0000000, 0.0000000, 1.0000000) * Pawn(MoveActor).MaxStepHeight)))
            {
                Pawn(MoveActor).ForceCrouch();
                MoveActor.SetLocation(NewLocation);                
            }
            else
            {
                MoveActor.MoveSmooth(vect(0.0000000, 0.0000000, -1.0000000) * Pawn(MoveActor).MaxStepHeight);
            }
        }
    }
    MoveActor.bCanTeleport = true;
    // End:0x792
    if((int(MoveActor.Physics) != int(10)) && int(newPhysics) != int(10))
    {
        MoveActor.SetPhysics(newPhysics);
    }
    // End:0x7B5
    if(MoveActor != self)
    {
        MoveActor.SetBase(NewBase, NewFloor);
    }
    MoveActor.Velocity = NewVelocity;
    UpdateStateFromAdjustment(NewState);
    bUpdatePosition = true;
    //return;    
}

function ClearAckedMoves()
{
    local @NULL CurMove;

    CurMove = TurokSavedMove(SavedMoves);
    J0x10:

    // End:0xE6 [Loop If]
    if(CurMove != none)
    {
        // End:0xE0
        if(CurMove.TimeStamp <= CurrentTimeStamp)
        {
            // End:0x87
            if(CurMove.TimeStamp == CurrentTimeStamp)
            {
                LastAckedAccel = CurMove.Acceleration;
                mAckedMaxSpeedMod = CurMove.mMaxSpeedMod;
                mAckedSpeedMod = CurMove.mSpeedMod;
            }
            SavedMoves = CurMove.NextMove;
            CurMove.NextMove = FreeMoves;
            FreeMoves = CurMove;
            FreeMoves.Clear();
            CurMove = TurokSavedMove(SavedMoves);            
        }
        else
        {
            // [Explicit Break]
            goto J0xE6;
        }
        // [Loop Continue]
        goto J0x10;
    }
    J0xE6:

    //return;    
}

event NotifyCausedDamage(@NULL damagedPawn, @NULL HitLocation)
{
    local @NULL Controller;

    // End:0x36
    foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
    {
        Controller.NotifyTeammateCausedDamage(self, damagedPawn);        
    }    
    //return;    
}

event NotifyAimAssistTargetChanged(@NULL aimAssistTarget)
{
    local @NULL Controller;

    // End:0x36
    foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
    {
        Controller.NotifyTeammateTargetChanged(self, aimAssistTarget);        
    }    
    //return;    
}

function NotifyVehicleTakeHit(@NULL InstigatedBy)
{
    local @NULL Controller;

    // End:0x36
    foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
    {
        Controller.NotifyTeammateHit(self, InstigatedBy);        
    }    
    //return;    
}

function NotifyBeingShotAtByAI(@NULL Shooter)
{
    local @NULL Controller;

    // End:0x36
    foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
    {
        Controller.NotifyTeammateShotAt(self, Shooter);        
    }    
    //return;    
}

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    local @NULL newHitReactionInfo, wcController;

    // End:0x1FC
    if((Damage > 0) || bGodMode && InstigatedBy.Pawn.CanHurt(Pawn) || (WorldInfo.Game != none) && TurokGameInfo(WorldInfo.Game).mAllowFriendlyFire)
    {
        // End:0xAB
        foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', wcController)
        {
            wcController.NotifyTeammateHit(self, InstigatedBy);            
        }        
        // End:0x1FC
        if(((int(WorldInfo.NetMode) == int(NM_Standalone)) || Class'TurokHitReaction'.static.IsImportantReaction(Damage)) || (WorldInfo.TimeSeconds - mHitReactionTime) > mHitReactionInterval)
        {
            newHitReactionInfo.DamageType = DamageType;
            newHitReactionInfo.Damage = Damage;
            newHitReactionInfo.HitLocation = HitLocation;
            // End:0x184
            if((InstigatedBy == none) || InstigatedBy.Pawn == none)
            {
                newHitReactionInfo.hitFromLocation = Pawn.Location;                
            }
            else
            {
                newHitReactionInfo.hitFromLocation = InstigatedBy.Pawn.Location;
            }
            // End:0x1FC
            if(Pawn.IsLocallyControlled() || DamageType != Class'Engine.DmgType_Fell')
            {
                mHitReactionInfo = newHitReactionInfo;
                mHitReactionTime = WorldInfo.TimeSeconds;
                ApplyHitReaction(InstigatedBy);
            }
        }
    }
    //return;    
}

function ApplyHitReaction(optional @NULL InstigatedBy = none)
{
    // End:0xAD
    if((TurokPawnPlayer(Pawn) != none) && !Pawn.InGodMode() || mbIgnoreGodMode)
    {
        mHitReactionManager.NotifyDamageTaken(InstigatedBy, mHitReactionInfo.Damage, mHitReactionInfo.HitLocation, Pawn.Location - mHitReactionInfo.hitFromLocation, mHitReactionInfo.DamageType, mHitReactionInfo.hitFromLocation);
    }
    TurokPlayForceFeedbackWaveform(mHitReactionInfo.DamageType.default.DamagedFFWaveform);
    // End:0x13B
    if((TurokHud(myHUD) != none) && mHitReactionManager.mbEnable == true)
    {
        TurokHud(myHUD).DisplayHit(mHitReactionInfo.hitFromLocation, mHitReactionInfo.Damage, mHitReactionInfo.DamageType);
    }
    // End:0x192
    if(TurokPawnPlayer(Pawn) != none)
    {
        TurokPawnPlayer(Pawn).PlayTakeDamageSound(float(mHitReactionInfo.Damage), mHitReactionInfo.HitLocation, mHitReactionInfo.DamageType);
    }
    //return;    
}

exec function ShowObjectiveLocatorHUD()
{
    local @NULL playerHud;

    playerHud = TurokHud(myHUD);
    // End:0xBC
    if((((playerHud != none) && playerHud.PlayerOwner != none) && playerHud.PlayerOwner.PlayerReplicationInfo != none) && !IsSpectating())
    {
        playerHud.ShowObjectiveLocator();
        // End:0xBC
        if(!Class'TurokUtil'.static.IsMultiplayerGame())
        {
            // DebugMode: 0
            assert(mSPObjectives.Length <= 1);
            // End:0xBC
            if(mSPObjectives.Length == 1)
            {
                ShowObjectiveText(mSPObjectives[0].mDescStringHash);
            }
        }
    }
    //return;    
}

reliable client simulated event ReceiveLocalizedMessage(class<Class> messagetype, optional int Switch, optional @NULL RelatedPRI_1, optional @NULL RelatedPRI_2, optional @NULL OptionalObject)
{
    local class<Class> TurokMsgType;

    // End:0x35
    if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || WorldInfo.GRI == none)
    {
        return;
    }
    TurokMsgType = class<TurokLocalizedMessage>(messagetype);
    // End:0x7F
    if(TurokMsgType != none)
    {
        Class'TurokLocalizedMessage'.static.ReceiveMessage(TurokMsgType, self, RelatedPRI_1, RelatedPRI_2, OptionalObject, Switch);
        return;
    }
    super.ReceiveLocalizedMessage(messagetype, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    //return;    
}

function DrawHUD(@NULL HUD)
{
    local @NULL bosswater, pawnplayer;
    local float yOffset, dist;
    local bool bShowTurretPrompt;
    local @NULL vPlayer;

    // End:0x23
    if(Pawn != none)
    {
        Pawn.DrawHUD(HUD);
    }
    pawnplayer = TurokPawnHuman(Pawn);
    // End:0x97
    if(pawnplayer != none)
    {
        bShowTurretPrompt = (((pawnplayer.DrivenVehicle == none) && mVehicleToDrive != none) && TurokVehicle(mVehicleToDrive) != none) && TurokVehicle(mVehicleToDrive).SimulatedTestTryToDrive(Pawn);
    }
    // End:0xF3
    if((((bShowTurretPrompt == false) && mPickupMiniGunSentry == none) && mbTurretPromptInitialized == true) || (mbDrawLadderHud == false) && mbLadderPromptInitialized == true)
    {
        TurokHud(HUD).RemovePrioritizedDrawCall(self);
    }
    // End:0x13C
    if((mbDrawLadderHud == true) && mbLadderPromptInitialized == false)
    {
        TurokHud(myHUD).AddPrioritizedDrawCall(DrawClimbLadderText, self, 2);
        mbLadderPromptInitialized = true;        
    }
    else
    {
        // End:0x15E
        if((mbDrawLadderHud == false) && mbLadderPromptInitialized == true)
        {
            mbLadderPromptInitialized = false;
        }
    }
    // End:0x1AF
    if((bShowTurretPrompt == true) && mbTurretPromptInitialized == false)
    {
        mbTurretIsMinigun = false;
        TurokHud(HUD).AddPrioritizedDrawCall(DrawHUDPrompt, self, 3);
        mbTurretPromptInitialized = true;        
    }
    else
    {
        // End:0x224
        if((((bShowTurretPrompt == false) && mPickupMiniGunSentry != none) && mbTurretPromptInitialized == false) && pawnplayer.mIsOnFire == false)
        {
            mbTurretIsMinigun = true;
            TurokHud(HUD).AddPrioritizedDrawCall(DrawHUDPrompt, self, 3);
            mbTurretPromptInitialized = true;            
        }
        else
        {
            // End:0x253
            if(((bShowTurretPrompt == false) && mPickupMiniGunSentry == none) && mbTurretPromptInitialized == true)
            {
                mbTurretPromptInitialized = false;
            }
        }
    }
    // End:0x26B
    if(mbDrawWeaponDebug)
    {
        DrawWeaponDebug(HUD);
    }
    // End:0x283
    if(mbDrawImpactDebug)
    {
        DrawImpactDebug(HUD);
    }
    // End:0x29B
    if(mbDrawPredatorAttackDebug)
    {
        DrawPredatorAttackDebug(HUD);
    }
    // End:0x2B3
    if(mbDrawAnimDebug3D)
    {
        DrawAnimDebug3D(HUD);
    }
    // End:0x2CB
    if(mbDrawPawnDebug3D)
    {
        DrawPawnDebug3D(HUD);
    }
    // End:0x2E3
    if(mbDrawPathDebug3D)
    {
        DrawPathDebug3D(HUD);
    }
    // End:0x2FB
    if(mbDrawAICountDebug)
    {
        DrawAICountDebug(HUD);
    }
    // End:0x313
    if(mbDrawGrassCollision)
    {
        DrawGrassCollision(HUD);
    }
    // End:0x32B
    if(mbShowGrassStats)
    {
        DrawGrassStats(HUD);
    }
    // End:0x9CB
    if(mbWaterBossDebug)
    {
        yOffset = 40.0000000;
        // End:0x9CA
        foreach WorldInfo.AllControllers(Class'TurokAIControllerBossWater', bosswater)
        {
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          bosswater: " $ string(bosswater.Pawn.Health), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          goalstate: " $ string(bosswater.mGoalState), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          state: " $ string(bosswater.GetStateName()), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          low: " $ string(bosswater.mInLowIdle), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          attacks: " $ string(bosswater.mAttacksToDo), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          bites: " $ string(bosswater.mBitesToDo), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          left zone: " $ string(bosswater.mIsTargetInLeftZone), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          right zone: " $ string(bosswater.mIsTargetInRightZone), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          player: " $ string(TurokPawnPlayer(Pawn).Health), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          w2tar: " $ string(bosswater.mBlendTargetWeight2), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            HUD.Canvas.__NFUN_465__("          w2: " $ string(bosswater.mBlendWeight2), false);
            HUD.Canvas.SetPos(float(HUD.Canvas.SizeX) * 0.7500000, yOffset);
            yOffset += float(16);
            vPlayer = TurokPawnPlayer(Pawn).Location - bosswater.mTarget;
            dist = VSize(vPlayer);
            HUD.Canvas.__NFUN_465__("          dist: " $ string(dist), false);            
        }        
    }
    // End:0x9E3
    if(mbDrawAudioDebug)
    {
        DrawAudioDebug(HUD);
    }
    //return;    
}

function DrawPredatorAttackDebug(@NULL HUD)
{
    local @NULL predController;

    // End:0x47
    foreach WorldInfo.AllControllers(Class'TurokAIControllerPredator', predController)
    {
        // End:0x46
        if(predController.mbPlayingStationaryAttack)
        {
            predController.ShowAttackContactPoints(HUD);
        }        
    }    
    //return;    
}

function DrawAnimDebug3D(@NULL HUD)
{
    local @NULL TurokPawn;

    // End:0x5A
    foreach WorldInfo.AllPawns(Class'TurokPawn', TurokPawn)
    {
        // End:0x59
        if((TurokPawn != Pawn) || !TurokPawn.IsFirstPerson())
        {
            TurokPawn.DrawAnimState3D(HUD);
        }        
    }    
    //return;    
}

function DrawPawnDebug3D(@NULL HUD)
{
    local @NULL TurokPawn, TurokVehicle;

    // End:0x31
    foreach WorldInfo.AllPawns(Class'TurokPawn', TurokPawn)
    {
        TurokPawn.DrawPawnState3D(HUD);        
    }    
    // End:0x57
    foreach AllActors(Class'TurokVehicle', TurokVehicle)
    {
        TurokVehicle.DrawVehicleState3D(HUD);        
    }    
    //return;    
}

function DrawPathDebug3D(@NULL HUD)
{
    local @NULL TurokPathNode;

    // End:0x31
    foreach WorldInfo.AllNavigationPoints(Class'TurokPathNode', TurokPathNode)
    {
        TurokPathNode.super(TurokPlayerController).DrawPathDebug3D(HUD);        
    }    
    //return;    
}

function DrawGrassCollision(@NULL HUD)
{
    local @NULL Grass;

    // End:0x29
    foreach AllActors(Class'TurokGrassActor', Grass)
    {
        Grass.DrawCollisionVolumes(HUD);        
    }    
    //return;    
}

function DrawGrassStats(@NULL HUD)
{
    local @NULL Grass;
    local float xOffset, yOffset, xLength, yLength, nameOffset;

    local int blades;
    local float memory;
    local int rendered, updated, colliders;

    blades = 0;
    memory = 0.0000000;
    rendered = 0;
    updated = 0;
    colliders = 0;
    // End:0xF0
    foreach AllActors(Class'TurokGrassActor', Grass)
    {
        blades += Grass.TurokGrassComponent.GetNumBlades();
        memory += (float(Grass.TurokGrassComponent.GetMemory()) / 1048576.0000000);
        rendered += Grass.TurokGrassComponent.GetBladesRendered();
        updated += Grass.TurokGrassComponent.GetBladesUpdated();
        colliders += Grass.TurokGrassComponent.GetActiveColliders();        
    }    
    HUD.Canvas.SetDrawColor(128, byte(255), 128);
    xOffset = 50.0000000;
    yOffset = 50.0000000;
    HUD.Canvas.__NFUN_464__("X", xLength, yLength);
    HUD.Canvas.SetPos(xOffset, yOffset);
    HUD.Canvas.__NFUN_465__("Name");
    nameOffset = 0.0000000;
    nameOffset += float(200);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__("Blades");
    nameOffset += float(75);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__("Memory(MB)");
    nameOffset += float(110);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__("Rendered");
    nameOffset += float(75);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__("Updated");
    nameOffset += float(75);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__("Colliders");
    yOffset += yLength;
    HUD.Canvas.SetPos(xOffset, yOffset);
    HUD.Canvas.__NFUN_465__("================================================================================");
    yOffset += yLength;
    HUD.Canvas.SetPos(xOffset, yOffset);
    HUD.Canvas.__NFUN_465__("Total");
    nameOffset = 0.0000000;
    nameOffset += float(200);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__(string(blades));
    nameOffset += float(75);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__(string(memory));
    nameOffset += float(110);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__(string(rendered));
    nameOffset += float(75);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__(string(updated));
    nameOffset += float(75);
    HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
    HUD.Canvas.__NFUN_465__(string(colliders));
    yOffset += yLength;
    // End:0x873
    foreach AllActors(Class'TurokGrassActor', Grass)
    {
        HUD.Canvas.SetPos(xOffset, yOffset);
        HUD.Canvas.__NFUN_465__(string(Grass));
        blades = Grass.TurokGrassComponent.GetNumBlades();
        memory = float(Grass.TurokGrassComponent.GetMemory()) / 1048576.0000000;
        rendered = Grass.TurokGrassComponent.GetBladesRendered();
        updated = Grass.TurokGrassComponent.GetBladesUpdated();
        colliders = Grass.TurokGrassComponent.GetActiveColliders();
        nameOffset = 0.0000000;
        nameOffset += float(200);
        HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
        HUD.Canvas.__NFUN_465__(string(blades));
        nameOffset += float(75);
        HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
        HUD.Canvas.__NFUN_465__(string(memory));
        nameOffset += float(110);
        HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
        HUD.Canvas.__NFUN_465__(string(rendered));
        nameOffset += float(75);
        HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
        HUD.Canvas.__NFUN_465__(string(updated));
        nameOffset += float(75);
        HUD.Canvas.SetPos(xOffset + nameOffset, yOffset);
        HUD.Canvas.__NFUN_465__(string(colliders));
        yOffset += yLength;        
    }    
    //return;    
}

function DrawAICountDebug(@NULL HUD)
{
    local @NULL debugPawn;
    local int Count;
    local float xOffset, yOffset, xLength, yLength, ai_penalty;

    local @NULL TP;

    Count = 1;
    xOffset = 50.0000000;
    yOffset = 50.0000000;
    HUD.Canvas.__NFUN_464__("X", xLength, yLength);
    HUD.Canvas.SetPos(xOffset, yOffset);
    HUD.Canvas.__NFUN_465__("Num");
    HUD.Canvas.SetPos(xOffset + float(50), yOffset);
    HUD.Canvas.__NFUN_465__("Pawn");
    HUD.Canvas.SetPos(xOffset + float(400), yOffset);
    HUD.Canvas.__NFUN_465__("SpawnNode");
    HUD.Canvas.SetPos(xOffset + float(600), yOffset);
    HUD.Canvas.__NFUN_465__("AI Cost");
    yOffset += yLength;
    HUD.Canvas.SetPos(xOffset, yOffset);
    HUD.Canvas.__NFUN_465__("================================================================================");
    yOffset += yLength;
    // End:0x43E
    foreach WorldInfo.AllPawns(Class'Engine.Pawn', debugPawn)
    {
        // End:0x24A
        if(debugPawn.Health <= 0)
        {
            HUD.Canvas.SetDrawColor(128, 128, 128);            
        }
        else
        {
            // End:0x282
            if(debugPawn.Controller == none)
            {
                HUD.Canvas.SetDrawColor(byte(255), 128, 128);                
            }
            else
            {
                HUD.Canvas.SetDrawColor(128, byte(255), 128);
            }
        }
        HUD.Canvas.SetPos(xOffset, yOffset);
        HUD.Canvas.__NFUN_465__(string(Count));
        HUD.Canvas.SetPos(xOffset + float(50), yOffset);
        HUD.Canvas.__NFUN_465__(string(debugPawn));
        HUD.Canvas.SetPos(xOffset + float(400), yOffset);
        HUD.Canvas.__NFUN_465__(string(debugPawn.mSpawnNode));
        TP = TurokPawn(debugPawn);
        // End:0x429
        if(debugPawn != none)
        {
            HUD.Canvas.SetPos(xOffset + float(600), yOffset);
            // End:0x410
            if(debugPawn.Health > 0)
            {
                ai_penalty += TP.mAIUsageCost;
                HUD.Canvas.__NFUN_465__(string(TP.mAIUsageCost));                
            }
            else
            {
                HUD.Canvas.__NFUN_465__("-");
            }
        }
        Count += 1;
        yOffset += yLength;        
    }    
    HUD.Canvas.SetDrawColor(128, 128, 128);
    HUD.Canvas.SetPos(xOffset, yOffset);
    HUD.Canvas.__NFUN_465__("================================================================================");
    yOffset += yLength;
    // End:0x5CF
    if(ai_penalty > float(8))
    {
        // End:0x550
        if((float(int(float(4) * WorldInfo.TimeSeconds)) % float(2)) == float(0))
        {
            HUD.Canvas.SetDrawColor(byte(255), byte(255), byte(255));            
        }
        else
        {
            HUD.Canvas.SetDrawColor(byte(255), 0, 0);
        }
        HUD.Canvas.SetPos(xOffset, yOffset);
        HUD.Canvas.__NFUN_465__("WARNING! Total AI Cost: " $ string(ai_penalty));        
    }
    else
    {
        HUD.Canvas.SetDrawColor(byte(255), byte(255), byte(255));
        HUD.Canvas.SetPos(xOffset, yOffset);
        HUD.Canvas.__NFUN_465__("Total AI Cost: " $ string(ai_penalty));
    }
    //return;    
}

function DrawAudioDebug(@NULL HUD)
{
    //return;    
}

function bool CanRestartPlayer()
{
    // End:0x3C
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        // End:0x28
        if(!PlayerReplicationInfo.bReadyToPlay)
        {
            return false;
        }
        // End:0x3C
        if(PlayerReplicationInfo.bOutOfLives)
        {
            return false;
        }
    }
    return super.CanRestartPlayer();
    //return ReturnValue;    
}

function Possess(@NULL aPawn, bool bVehicleTransition)
{
    local @NULL TurokPawn;

    super.Possess(aPawn, bVehicleTransition);
    TurokPawn = TurokPawn(aPawn);
    // End:0x4C
    if((TurokPawn != none) && !bVehicleTransition)
    {
        TurokPawn.AnimInterruptToLoco();
    }
    // End:0x74
    if(TurokMPPlayerReplicationInfo(PlayerReplicationInfo) != none)
    {
        TurokMPPlayerReplicationInfo(PlayerReplicationInfo).ClearPlayerdead();
    }
    //return;    
}

function Restart(bool bVehicleTransition)
{
    Pawn.Restart();
    Enemy = none;
    ServerTimeStamp = 0.0000000;
    ResetTimeMargin();
    SimulatedPossessPawn(Pawn);
    // End:0x5D
    if(IsLocalPlayerController())
    {
        AcknowledgePossession(Pawn);        
    }
    else
    {
        TurokClientRestart(Pawn);
    }
    //return;    
}

function SimulatedPossessPawn(@NULL NewPawn)
{
    local @NULL tpp, tppm;

    // End:0x4A
    if(IsLocalPlayerController())
    {
        tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
        // End:0x4A
        if(tppm != none)
        {
            tppm.RestoreKismetSettings();
        }
    }
    ResetPlayerMovementInput();
    ClearNetMoveVariables();
    // End:0x9B
    if(((Pawn != none) && Pawn.bTearOff) || Pawn != NewPawn)
    {
        UnPossess();
        Pawn = none;
    }
    Pawn = NewPawn;
    // End:0xB3
    if(Pawn == none)
    {
        return;
    }
    tpp = TurokPawnPlayer(Pawn);
    // End:0xE2
    if(tpp != none)
    {
        tpp.SimulatedPossessedBy(self);
    }
    Pawn.SetBaseEyeheight();
    Pawn.EyeHeight = Pawn.BaseEyeHeight;
    SetViewTarget(Pawn);
    // End:0x167
    if(Vehicle(Pawn) == none)
    {
        SimulatedResetTurokCamera();
        TurokPlayerCamera(PlayerCamera).mCameraFirstPerson.ScriptResetCameraLocation();
        EnterStartState();
    }
    mAimAssistTarget = none;
    mAimReticleTarget = none;
    //return;    
}

event AcknowledgePossession(@NULL NewPawn)
{
    // End:0x53
    if(LocalPlayer(Player) != none)
    {
        // End:0x53
        if(AcknowledgedPawn != NewPawn)
        {
            AcknowledgedPawn = NewPawn;
            ServerAcknowledgePossession(NewPawn);
            // End:0x53
            if(NewPawn != none)
            {
                SimulatedPossessPawn(NewPawn);
            }
        }
    }
    //return;    
}

reliable server function ServerAcknowledgePossession(@NULL NewPawn)
{
    // End:0x21
    if(NewPawn != Pawn)
    {
        TurokClientRestart(Pawn);        
    }
    else
    {
        // End:0x54
        if(NewPawn != AcknowledgedPawn)
        {
            ResetTimeMargin();
            AcknowledgedPawn = NewPawn;
            TurokClientRestart(NewPawn);
        }
    }
    //return;    
}

reliable client simulated function TurokClientRestart(@NULL NewPawn)
{
    // End:0x1E
    if(NewPawn != AcknowledgedPawn)
    {
        AcknowledgePossession(NewPawn);
    }
    //return;    
}

reliable client simulated event ClientRestoreMigratedState(@NULL InRotation, bool InDuck)
{
    SetRotation(InRotation);
    bDuck = byte(((InDuck) ? 1 : 0));
    // End:0x5E
    if(Pawn != none)
    {
        Pawn.FaceRotation(InRotation, 0.0000000);
        Pawn.ShouldCrouch(InDuck);
    }
    //return;    
}

reliable client simulated function ClientReset()
{
    super.ClientReset();
    WorldInfo.ResetGameTemporaries();
    WorldInfo.GRI.RemainingTime = WorldInfo.GRI.TimeLimit * 60;
    WorldInfo.GRI.ElapsedTime = 0;
    myHUD.Reset();
    //return;    
}

reliable client simulated function ClientSetNetSpeed(int netSpeed)
{
    ClientCap = netSpeed;
    SetNetSpeed(netSpeed);
    // End:0x21
    if(Player != none)
    {
    }
    //return;    
}

simulated function SimulatedClearActiveState()
{
    // End:0x43
    if(IsLocalPlayerController())
    {
        mHitReactionManager.Clear();
        // End:0x43
        if(myHUD != none)
        {
            TurokHud(myHUD).ResetHUD();
        }
    }
    bDuck = 0;
    CleanupContextActions();
    mPickupMiniGunSentry = none;
    mbDrawLadderHud = false;
    //return;    
}

reliable client simulated function ClientNotifyKilled(@NULL Killer)
{
    mKillerPawn = Killer;
    SimulatedSetTurokCamera(mPendingDeathCam);
    mPendingDeathCam = 'DeathCam';
    GotoState('Dead');
    //return;    
}

function PawnLogout(@NULL P)
{
    P.Died(self, Class'TurokDamageTypeLogout', P.Location);
    //return;    
}

function PawnDied(@NULL P)
{
    super.PawnDied(P);
    // End:0x41
    if(TurokMPPlayerReplicationInfo(PlayerReplicationInfo) != none)
    {
        TurokMPPlayerReplicationInfo(PlayerReplicationInfo).SetPlayerDead(P.Location);
    }
    //return;    
}

function NotifyKilled(@NULL Killer, @NULL Killed, @NULL KilledPawn)
{
    // End:0xFA
    if((Killed == self) && KilledPawn == self.Pawn)
    {
        // End:0x36
        if(Killer == none)
        {
            mKillerPawn = none;            
        }
        else
        {
            mKillerPawn = TurokPawn(Killer.Pawn);
        }
        // End:0xA8
        if(!GamePlayEndedState())
        {
            // End:0x8A
            if(!IsLocalPlayerController())
            {
                // End:0x87
                if(!bPendingDelete)
                {
                    ClientNotifyKilled(mKillerPawn);
                }                
            }
            else
            {
                SimulatedSetTurokCamera(mPendingDeathCam);
                mPendingDeathCam = 'DeathCam';
            }
        }
        // End:0xFA
        if((IsLocalPlayerController()) && !Class'TurokUtil'.static.IsMultiplayerGame())
        {
            Class'TurokEngine.TurokUI'.static.GetEngine().GetDifficultySystem().AddLocalPlayerDeath();
        }
    }
    super(Controller).NotifyKilled(Killer, Killed, KilledPawn);
    //return;    
}

function CheckJumpOrDuck()
{
    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    // End:0x4B
    if(bPressedJump)
    {
        // End:0x32
        if(!mbCinemaDisabledDive && PerformDive())
        {
            return;
        }
        Pawn.DoJump(bUpdating);
    }
    // End:0x95
    if((int(Pawn.Physics) != int(2)) && Pawn.bCanCrouch)
    {
        Pawn.ShouldCrouch(int(bDuck) != 0);
    }
    //return;    
}

function ReturnToWalking()
{
    GotoState('PlayerWalking');
    //return;    
}

function GotoImpulseState(float impluseTime, @NULL impulseVector)
{
    mImpulseTime = impluseTime;
    mImpulseVector = impulseVector;
    // End:0x36
    if(!IsInState('CannedAnimation'))
    {
        GotoState('PlayerImpulse');
    }
    //return;    
}

simulated function bool AllowSkeletalHurtImpulse()
{
    return true;
    //return ReturnValue;    
}

simulated function bool CanPickupFlagBeSet()
{
    return true;
    //return ReturnValue;    
}

simulated function bool RequestSetPlayerCanPickupInventory(bool bReqCanPickup)
{
    local bool bWasAllowedToSet;

    // End:0x30
    if(CanPickupFlagBeSet())
    {
        TurokPawnPlayer(Pawn).bCanPickupInventory = bReqCanPickup;
        bWasAllowedToSet = true;
    }
    return bWasAllowedToSet;
    //return ReturnValue;    
}

simulated function OnKnockdownPlayer(@NULL Action)
{
    local array sourceActors;
    local @NULL tpp;

    tpp = TurokPawnPlayer(Pawn);
    // End:0x221
    if(Action.InputLinks[0].bHasImpulse)
    {
        Action.GetObjectVars(sourceActors, "Source Actor");
        // End:0x1BF
        if((sourceActors.Length > 0) && Actor(sourceActors[0]) != none)
        {
            // End:0x144
            if(Action.mbKnockdownImmediately)
            {
                // End:0xF6
                if(Pawn(sourceActors[0]) != none)
                {
                    tpp.mbForcedKnockdown = true;
                    tpp.PlayKnockdown(Pawn(sourceActors[0]).Controller, Actor(sourceActors[0]).Location);
                    tpp.mbForcedKnockdown = false;                    
                }
                else
                {
                    tpp.mbForcedKnockdown = true;
                    tpp.PlayKnockdown(none, Actor(sourceActors[0]).Location);
                    tpp.mbForcedKnockdown = false;
                }                
            }
            else
            {
                // End:0x17D
                if(Action.mbKnockdownOnNextAttack)
                {
                    tpp.SetForcedKnockdownValues(Actor(sourceActors[0]), -1.0000000);                    
                }
                else
                {
                    // End:0x1BC
                    if(Action.mbKnockdownOnProximity)
                    {
                        tpp.SetForcedKnockdownValues(Actor(sourceActors[0]), Action.mKnockdownProximity);
                    }
                }
            }            
        }
        else
        {
            // End:0x1F6
            if(Action.mbKnockdownImmediately)
            {
                tpp.PlayKnockdown(none, Pawn.Location);                
            }
            else
            {
                // End:0x221
                if(Action.mbKnockdownOnNextAttack)
                {
                    tpp.SetForcedKnockdownValues(none, -1.0000000);
                }
            }
        }
    }
    //return;    
}

function OnConstrainPlayer(@NULL Action)
{
    local array objVarsPosition, objVarsLookAt;

    // End:0x0F
    if(IsDead())
    {
        return;
    }
    // End:0x1B8
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x1B5
        if(!IsInState('ConstrainPlayerState'))
        {
            Action.GetObjectVars(objVarsPosition, "Position");
            // End:0x7D
            if(objVarsPosition.Length == 0)
            {
                mPlayerConstraints.mPositionActor = none;                
            }
            else
            {
                mPlayerConstraints.mPositionActor = Actor(objVarsPosition[0]);
            }
            Action.GetObjectVars(objVarsLookAt, "Look At");
            // End:0xD6
            if(objVarsLookAt.Length == 0)
            {
                mPlayerConstraints.mLookAtActor = none;                
            }
            else
            {
                mPlayerConstraints.mLookAtActor = Actor(objVarsLookAt[0]);
            }
            mPlayerConstraints.mbAllowMovement = Action.mbAllowMovement;
            mPlayerConstraints.mLookAtTime = Action.mLookAtTime;
            mPlayerConstraints.mLookAtConstraints = Action.mLookAtConstraints;
            mPlayerConstraints.mLookAtSpline.Initialize(Action.mLookAtSplinePoints);
            mPlayerConstraints.mInitialLookAt = Rotation;
            mPlayerConstraints.mCurrentTime = 0.0000000;
            PushState('ConstrainPlayerState');
        }        
    }
    else
    {
        // End:0x22D
        if(Action.InputLinks[1].bHasImpulse)
        {
            // End:0x22D
            if(IsInState('ConstrainPlayerState'))
            {
                PopState();
                // End:0x22D
                if((IsStateValidPostCinema()) == false)
                {
                    GotoState('PlayerWalking');
                    // End:0x22D
                    if(Pawn != none)
                    {
                        Pawn.GotoState('None');
                    }
                }
            }
        }
    }
    //return;    
}

event bool IsStateValidPostCinema()
{
    return true;
    //return ReturnValue;    
}

function NotifyChangedWeapon(@NULL PreviousWeapon, @NULL NewWeapon)
{
    local int idx;
    local @NULL weaponEvent;

    TurokPawnPlayer(Pawn).SetTurokAbilities();
    // End:0x4A
    if(TurokWeapon(NewWeapon) != none)
    {
        mZoomer.Owner = TurokWeapon(NewWeapon).mZoomValues;
    }
    idx = 0;
    J0x51:

    // End:0xEF [Loop If]
    if(idx < Pawn.GeneratedEvents.Length)
    {
        weaponEvent = TurokSeqEvent_PlayerChangedWeapon(Pawn.GeneratedEvents[idx]);
        // End:0xE5
        if((weaponEvent != none) && (weaponEvent.WeaponType == none) || NewWeapon.IsA(weaponEvent.WeaponType.Name))
        {
            weaponEvent.CheckActivate(self, self);
        }
        idx++;
        // [Loop Continue]
        goto J0x51;
    }
    idx = 0;
    J0xF6:

    // End:0x182 [Loop If]
    if(idx < GeneratedEvents.Length)
    {
        weaponEvent = TurokSeqEvent_PlayerChangedWeapon(GeneratedEvents[idx]);
        // End:0x178
        if((weaponEvent != none) && (weaponEvent.WeaponType == none) || NewWeapon.IsA(weaponEvent.WeaponType.Name))
        {
            weaponEvent.CheckActivate(self, self);
        }
        idx++;
        // [Loop Continue]
        goto J0xF6;
    }
    //return;    
}

// Export UTurokPlayerController::execCauseWeaponViewShake(FFrame&, void* const)
native function CauseWeaponViewShake(@NULL shakeVec, optional bool rightHand);

function @NULL FindNearestVisibleTarget(@NULL basePawn, float distanceLimit)
{
    local @NULL nearbyPawn;
    local float closest, tdist;
    local @NULL nearestTarget, dirToTarget, pawnRotation, closeRot, tempLoc;

    local int closingAngle;

    closest = 10000000.0000000;
    nearestTarget = none;
    // End:0x17F
    foreach basePawn.VisibleCollidingActors(Class'TurokPawn', nearbyPawn, distanceLimit)
    {
        // End:0x46
        if(basePawn == nearbyPawn)
        {
            continue;            
        }
        // End:0x5E
        if(nearbyPawn.Health <= 0)
        {
            continue;            
        }
        basePawn.GetActorEyesViewPoint(tempLoc, pawnRotation);
        dirToTarget = Rotator(nearbyPawn.Location - basePawn.Location);
        closeRot = pawnRotation - dirToTarget;
        closingAngle = int(float(closeRot.Yaw) % float(65536));
        // End:0xF4
        if(closingAngle > 32768)
        {
            closingAngle += -65536;            
        }
        else
        {
            // End:0x10F
            if(closingAngle < -32768)
            {
                closingAngle += 65536;
            }
        }
        closingAngle = int(Abs(float(closingAngle)));
        // End:0x133
        if(closingAngle > 2184)
        {
            continue;            
        }
        tdist = VSize(nearbyPawn.Location - basePawn.Location);
        // End:0x17E
        if(tdist < closest)
        {
            closest = tdist;
            nearestTarget = nearbyPawn;
        }        
    }    
    return nearestTarget;
    //return ReturnValue;    
}

// Export UTurokPlayerController::execGetAimAssistTarget(FFrame&, void* const)
native function @NULL GetAimAssistTarget(@NULL StartFireLoc, out @NULL aimToTarget);

function @NULL GetStealthKillTarget()
{
    local @NULL StealthTarget;

    StealthTarget = TurokPawn(mAimAssistTarget);
    // End:0x33
    if((StealthTarget == none) && mForcedStealthKillTarget != none)
    {
        StealthTarget = mForcedStealthKillTarget;
    }
    mStealthKillTarget = StealthTarget;
    return mStealthKillTarget;
    //return ReturnValue;    
}

// Export UTurokPlayerController::execGetAdjustedAimFor(FFrame&, void* const)
native function @NULL GetAdjustedAimFor(@NULL W, @NULL StartFireLoc);

function NotifyAddInventory(@NULL NewItem)
{
    local @NULL TurokPawnPlayer, TurokWeapon;

    TurokPawnPlayer = TurokPawnPlayer(Pawn);
    // End:0x99
    if((TurokPawnPlayer != none) && !TurokPawnPlayer.IsFirstPerson())
    {
        TurokWeapon = TurokWeapon(NewItem);
        // End:0x99
        if(TurokWeapon != none)
        {
            // End:0x99
            if((int(TurokWeapon.mWeaponType) == int(1)) && TurokPawnPlayer.IsFirstPerson() == false)
            {
                TurokPawnPlayer.SetQuiverVisibility(false);
            }
        }
    }
    //return;    
}

exec function Use()
{
    ScriptTrace();
    //return;    
}

unreliable server function ServerUse()
{
    ScriptTrace();
    //return;    
}

exec function StartAction()
{
    local @NULL mgr;

    // End:0xA9
    if((Pawn != none) && Pawn.Health > 0)
    {
        mgr = TurokInventoryManager(Pawn.InvManager);
        // End:0xA9
        if(((mgr != none) && mgr.PendingWeapon == none) && !mgr.SimulatedGetIsDroppingWeaponForPickup())
        {
            // End:0x9F
            if(!mbTurretIsMinigun && mbTurretPromptInitialized)
            {
                mgr.SimulatedSetIsDroppingWeaponForPickup(true);
            }
            ServerStartAction();
        }
    }
    //return;    
}

reliable server function ServerStartAction()
{
    mEnterTurret = false;
    PerformedUseAction();
    // End:0x86
    if(!mEnterTurret)
    {
        // End:0x86
        if((Pawn != none) && TurokInventoryManager(Pawn.InvManager) != none)
        {
            TurokInventoryManager(Pawn.InvManager).SimulatedSetIsDroppingWeaponForPickup(false);
            TurokInventoryManager(Pawn.InvManager).SetFalseIsDroppingWeaponForPickup();
        }
    }
    //return;    
}

exec function StopAction()
{
    ServerStopAction();
    //return;    
}

reliable server function ServerStopAction()
{
    EndUseAction();
    //return;    
}

function bool PerformedUseAction()
{
    local @NULL humanPawn, PlayerPawn, TVH;
    local bool bWeapCanUseAction;

    bWeapCanUseAction = true;
    // End:0x2E
    if(WorldInfo.Pauser == PlayerReplicationInfo)
    {
        SetPause(false);
        return true;
    }
    // End:0x51
    if((Pawn == none) || !Pawn.bCanUse)
    {
        return true;
    }
    // End:0x75
    if(TurokInventoryManager(Pawn.InvManager).mNextWeaponRight != none)
    {
        return true;
    }
    mActionPressed = true;
    humanPawn = TurokPawnHuman(Pawn);
    // End:0xBB
    if(TurokVehicle(Pawn) != none)
    {
        humanPawn = TurokPawnHuman(TurokVehicle(Pawn).Driver);
    }
    TVH = TurokVehicle(humanPawn.DrivenVehicle);
    // End:0x103
    if(TVH != none)
    {
        TVH.PawnExit(humanPawn.mSeatIndex, false);
        return true;
    }
    PlayerPawn = TurokPawnPlayer(Pawn);
    // End:0x120
    if(PlayerPawn == none)
    {
        return false;
    }
    // End:0x137
    if(FindVehicleToDrive())
    {
        mEnterTurret = true;
        return true;
    }
    // End:0x17B
    if((humanPawn != none) && humanPawn.mWeaponMediator != none)
    {
        bWeapCanUseAction = humanPawn.mWeaponMediator.CanUseAction();
    }
    // End:0x1C4
    if(((mContextAction != none) && bWeapCanUseAction) && mContextAction.IsRequirementsMet())
    {
        mActiveContextAction = mContextAction;
        GotoState('PerformingContextAction');
        return true;
    }
    // End:0x1D3
    if(TriggerInteracted())
    {
        return true;
    }
    // End:0x1E7
    if(PerformUsePawn(PlayerPawn))
    {
        return true;
    }
    // End:0x1FB
    if(PerformClimbLadder(PlayerPawn))
    {
        return true;
    }
    // End:0x224
    if(PlayerPawn.mIsOnFire == false)
    {
        // End:0x224
        if(PerformReclaimMiniGunFromAutoTurret(PlayerPawn))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function EndUseAction()
{
    //return;    
}

function EndUseActiveContextAction()
{
    mActionPressed = false;
    mActiveContextAction.StopAction(false);
    EnterStartState();
    //return;    
}

simulated function DestroyActiveContextAction()
{
    // End:0x28
    if((mActiveContextAction != none) && mActiveContextAction != mContextAction)
    {
        mActiveContextAction.Destroy();
    }
    mActiveContextAction = none;
    //return;    
}

function bool FindVehicleToDrive()
{
    // End:0x46
    if((Vehicle(Pawn.Base) != none) && Vehicle(Pawn.Base).TryToDrive(Pawn))
    {
        return true;
    }
    return (mVehicleToDrive != none) && mVehicleToDrive.TryToDrive(Pawn);
    //return ReturnValue;    
}

function bool PerformReclaimMiniGunFromAutoTurret(@NULL PlayerPawn)
{
    local @NULL gun, mgr;

    // End:0xCB
    if(((mPickupMiniGunSentry != none) && mPickupMiniGunSentry.IsInState('Pickup')) && !IsInState('CinematicState'))
    {
        gun = mPickupMiniGunSentry.GetPrimaryWeapon();
        mgr = TurokInventoryManager(PlayerPawn.InvManager);
        // End:0xC4
        if(((mgr != none) && gun != none) && mgr.ShouldPickupWeapon(gun.Class))
        {
            mPickupMiniGunSentry.GiveTo(PlayerPawn);
            return true;
        }
        mPickupMiniGunSentry = none;
    }
    return false;
    //return ReturnValue;    
}

function bool PerformUsePawn(@NULL PlayerPawn)
{
    local @NULL out_HitLocation, out_HitNormal, out_PlayerLoc, out_PlayerRot, hitPawn, HitController;

    PlayerPawn.GetActorEyesViewPoint(out_PlayerLoc, out_PlayerRot);
    hitPawn = TurokPawnHuman(PlayerPawn.Trace(out_HitLocation, out_HitNormal, out_PlayerLoc + (Vector(out_PlayerRot) * float(100)), out_PlayerLoc, true));
    // End:0xCF
    if((hitPawn != none) && int(hitPawn.GetTeamNum()) == 255)
    {
        HitController = TurokAIControllerHumanFriendly(hitPawn.Controller);
        // End:0xCF
        if(HitController != none)
        {
            HitController.ToggleBeingUsed(int(GetTeamNum()), PlayerPawn);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool PerformClimbLadder(@NULL humanPawn)
{
    local @NULL L;

    L = FindClimbableLadder();
    // End:0x31
    if(L != none)
    {
        humanPawn.ClimbLadder(L);
        return true;
    }
    return false;
    //return ReturnValue;    
}

exec function ToggleIK()
{
    // End:0x71
    if(Pawn(ViewTarget) != none)
    {
        // End:0x53
        if(Pawn(ViewTarget).Mesh.bIgnoreControllers > 0)
        {
            Pawn(ViewTarget).Mesh.bIgnoreControllers = 0;            
        }
        else
        {
            Pawn(ViewTarget).Mesh.bIgnoreControllers = 1;
        }
    }
    //return;    
}

exec function ShowBones()
{
    // End:0x71
    if(Pawn(ViewTarget) != none)
    {
        // End:0x53
        if(Pawn(ViewTarget).Mesh.bDisplayBones > 0)
        {
            Pawn(ViewTarget).Mesh.bDisplayBones = 0;            
        }
        else
        {
            Pawn(ViewTarget).Mesh.bDisplayBones = 1;
        }
    }
    //return;    
}

exec function ShowAttackDebug()
{
    mbDrawPredatorAttackDebug = !mbDrawPredatorAttackDebug;
    //return;    
}

exec function ShowAnimDebug3D()
{
    mbDrawAnimDebug3D = !mbDrawAnimDebug3D;
    //return;    
}

exec function ShowDebug3D()
{
    mbDrawPawnDebug3D = !mbDrawPawnDebug3D;
    //return;    
}

exec function ShowPathDebug3D()
{
    mbDrawPathDebug3D = !mbDrawPathDebug3D;
    //return;    
}

exec function ShowGrassCollision()
{
    mbDrawGrassCollision = !mbDrawGrassCollision;
    //return;    
}

exec function ShowGrassInfo()
{
    mbShowGrassStats = !mbShowGrassStats;
    //return;    
}

exec function ShowAICount()
{
    mbDrawAICountDebug = !mbDrawAICountDebug;
    //return;    
}

exec function ShowCoverDebug()
{
    mbShowCoverDebug = !mbShowCoverDebug;
    //return;    
}

exec function ShowWeaponDebug()
{
    mbDrawWeaponDebug = !mbDrawWeaponDebug;
    //return;    
}

exec function ImpactDebug()
{
    mbDrawImpactDebug = !mbDrawImpactDebug;
    //return;    
}

exec function ImpactGodMode()
{
    mbImpactGodMode = !mbImpactGodMode;
    // End:0x20
    if(mbImpactReaperMode)
    {
        mbImpactReaperMode = false;
    }
    //return;    
}

exec function ImpactReaperMode()
{
    mbImpactReaperMode = !mbImpactReaperMode;
    // End:0x20
    if(mbImpactGodMode)
    {
        mbImpactGodMode = false;
    }
    //return;    
}

exec function ShowExplosionDebug()
{
    mbDrawExplosionDebug = !mbDrawExplosionDebug;
    //return;    
}

exec function WaterBossDebug()
{
    mbWaterBossDebug = !mbWaterBossDebug;
    //return;    
}

exec function ShowAudioDebug()
{
    mbDrawAudioDebug = !mbDrawAudioDebug;
    //return;    
}

exec function AudioDump()
{
    PrintAudioComponents();
    ServerPause();
    //return;    
}

exec function ListDuckers()
{
    PrintDuckerList();
    //return;    
}

exec function AllBBPosters(name post)
{
    local @NULL poster;
    local float Data;
    local int numPosters;

    // End:0x2A
    foreach WorldInfo.super(TurokPlayerController).AllBBPosters(post, poster, none, Data)
    {
        numPosters++;        
    }    
    //return;    
}

exec function ShootPlayer1()
{
    // End:0x2D
    if(TurokPawnPlayer(Pawn) != none)
    {
        mShooter1.ComputeAndSendDamage(TurokPawnPlayer(Pawn));
    }
    //return;    
}

exec function ShootPlayer2()
{
    // End:0x2D
    if(TurokPawnPlayer(Pawn) != none)
    {
        mShooter2.ComputeAndSendDamage(TurokPawnPlayer(Pawn));
    }
    //return;    
}

exec function TI_Override()
{
    local @NULL MyPlayer;

    MyPlayer = LocalPlayer(Player);
    // End:0xAF
    if(MyPlayer != none)
    {
        // End:0x70
        if(MyPlayer.bOverrideTurokIrisSettings)
        {
            ClientMessage("Iris settings override disabled");
            MyPlayer.ClearTurokIrisSettingsOverride();            
        }
        else
        {
            ClientMessage("Iris settings override enabled");
            MyPlayer.EnableTurokIrisSettingsOverride();
        }
    }
    //return;    
}

exec function TI_SetAvgLum(float Luminance)
{
    local @NULL MyPlayer, MyIrisSettings;

    MyPlayer = LocalPlayer(Player);
    // End:0x61
    if(MyPlayer != none)
    {
        MyIrisSettings = MyPlayer.GetOverrideTurokIrisSettings();
        MyIrisSettings.mTargetAvgLuminance = Luminance;
        MyPlayer.SetOverrideTurokIrisSettings(MyIrisSettings);
    }
    //return;    
}

exec function TI_SetSpd(float AdaptSpeed)
{
    local @NULL MyPlayer, MyIrisSettings;

    MyPlayer = LocalPlayer(Player);
    // End:0x61
    if(MyPlayer != none)
    {
        MyIrisSettings = MyPlayer.GetOverrideTurokIrisSettings();
        MyIrisSettings.mAdaptSpeed = AdaptSpeed;
        MyPlayer.SetOverrideTurokIrisSettings(MyIrisSettings);
    }
    //return;    
}

exec function TI_SetLumMin(float LumMin)
{
    local @NULL MyPlayer, MyIrisSettings;

    MyPlayer = LocalPlayer(Player);
    // End:0x61
    if(MyPlayer != none)
    {
        MyIrisSettings = MyPlayer.GetOverrideTurokIrisSettings();
        MyIrisSettings.mAdaptLuminanceMin = LumMin;
        MyPlayer.SetOverrideTurokIrisSettings(MyIrisSettings);
    }
    //return;    
}

exec function TI_SetLumMax(float LumMax)
{
    local @NULL MyPlayer, MyIrisSettings;

    MyPlayer = LocalPlayer(Player);
    // End:0x61
    if(MyPlayer != none)
    {
        MyIrisSettings = MyPlayer.GetOverrideTurokIrisSettings();
        MyIrisSettings.mAdaptLuminanceMax = LumMax;
        MyPlayer.SetOverrideTurokIrisSettings(MyIrisSettings);
    }
    //return;    
}

exec function TI_SetContrast(float Contrast)
{
    local @NULL MyPlayer, MyIrisSettings;

    MyPlayer = LocalPlayer(Player);
    // End:0x61
    if(MyPlayer != none)
    {
        MyIrisSettings = MyPlayer.GetOverrideTurokIrisSettings();
        MyIrisSettings.mContrast = Contrast;
        MyPlayer.SetOverrideTurokIrisSettings(MyIrisSettings);
    }
    //return;    
}

exec function TI_SetWhiteSqd(float WhiteSquared)
{
    local @NULL MyPlayer, MyIrisSettings;

    MyPlayer = LocalPlayer(Player);
    // End:0x61
    if(MyPlayer != none)
    {
        MyIrisSettings = MyPlayer.GetOverrideTurokIrisSettings();
        MyIrisSettings.mWhiteSquared = WhiteSquared;
        MyPlayer.SetOverrideTurokIrisSettings(MyIrisSettings);
    }
    //return;    
}

exec function TI_SetPctChange(float Pct)
{
    local @NULL MyPlayer, MyIrisSettings;

    MyPlayer = LocalPlayer(Player);
    // End:0x61
    if(MyPlayer != none)
    {
        MyIrisSettings = MyPlayer.GetOverrideTurokIrisSettings();
        MyIrisSettings.mPercentageChangeClamp = Pct;
        MyPlayer.SetOverrideTurokIrisSettings(MyIrisSettings);
    }
    //return;    
}

exec function TI_Toggle()
{
    local @NULL MyPlayer, MyIrisSettings;

    MyPlayer = LocalPlayer(Player);
    // End:0xC4
    if(MyPlayer != none)
    {
        MyIrisSettings = MyPlayer.GetOverrideTurokIrisSettings();
        MyIrisSettings.mUseToneMapping = !MyIrisSettings.mUseToneMapping;
        MyPlayer.SetOverrideTurokIrisSettings(MyIrisSettings);
        // End:0xA4
        if(MyIrisSettings.mUseToneMapping)
        {
            ClientMessage("TurokIris Enabled");            
        }
        else
        {
            ClientMessage("TurokIris Disabled");
        }
    }
    //return;    
}

exec function TI_ShowSettings()
{
    local @NULL MyPlayer, MyIrisSettings;
    local string OutStr;

    MyPlayer = LocalPlayer(Player);
    // End:0x230
    if(MyPlayer != none)
    {
        // End:0x6C
        if(MyPlayer.bOverrideTurokIrisSettings)
        {
            ClientMessage("Iris Override Enabled");
            MyIrisSettings = MyPlayer.GetOverrideTurokIrisSettings();            
        }
        else
        {
            ClientMessage("Iris Override Disabled");
            MyIrisSettings = MyPlayer.CurrentTurokIrisInfo.LastSettings;
        }
        OutStr = "UseToneMapping " @ string(MyIrisSettings.mUseToneMapping);
        OutStr = (OutStr @ "\nTargetAvgLum ") @ string(MyIrisSettings.mTargetAvgLuminance);
        OutStr = (OutStr @ "\nAdaptSpeed ") @ string(MyIrisSettings.mAdaptSpeed);
        OutStr = (OutStr @ "\nAdaptLumMin ") @ string(MyIrisSettings.mAdaptLuminanceMin);
        OutStr = (OutStr @ "\nAdaptLumMax ") @ string(MyIrisSettings.mAdaptLuminanceMax);
        OutStr = (OutStr @ "\nContrast ") @ string(MyIrisSettings.mContrast);
        OutStr = (OutStr @ "\nWhiteSqd ") @ string(MyIrisSettings.mWhiteSquared);
        OutStr = (OutStr @ "\nPctChangeClamp ") @ string(MyIrisSettings.mPercentageChangeClamp);
        ClientMessage(OutStr);
    }
    //return;    
}

exec function TPP_Begin()
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    tppm.BeginSettings();
    //return;    
}

exec function TPP_Apply(optional float WorldFXLerpTime = -1.0000000, optional float ScreenFXLerpTime = -1.0000000)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    tppm.EndSettings(WorldFXLerpTime, ScreenFXLerpTime);
    //return;    
}

exec function TPP_SetBool(string Variable, bool Value)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0x74
    if(!tppm.SetBool(Variable, Value))
    {
        ClientMessage("TPP_SetBool unknown variable " @ Variable);
    }
    //return;    
}

function TPP_SetBoolNative(byte Variable, bool Value)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0x76
    if(!tppm.SetBoolNative(Variable, Value))
    {
        ClientMessage("TPP_SetBool unknown variable " @ string(Variable));
    }
    //return;    
}

exec function TPP_SetFloat(string Variable, float Value)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0x74
    if(!tppm.SetFloat(Variable, Value))
    {
        ClientMessage("TPP_SetFloat unknown variable " @ Variable);
    }
    //return;    
}

function TPP_SetFloatNative(byte Variable, float Value)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0x76
    if(!tppm.SetFloatNative(Variable, Value))
    {
        ClientMessage("TPP_SetFloat unknown variable " @ string(Variable));
    }
    //return;    
}

exec function TPP_SetColor(string Variable, float R, float G, float B)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0x7E
    if(!tppm.SetColor(Variable, R, G, B))
    {
        ClientMessage("TPP_SetColor unknown variable " @ Variable);
    }
    //return;    
}

function TPP_SetColorNative(byte Variable, float R, float G, float B)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0x80
    if(!tppm.SetColorNative(Variable, R, G, B))
    {
        ClientMessage("TPP_SetColor unknown variable " @ string(Variable));
    }
    //return;    
}

exec function TPP_SetVignetteTexture(@NULL Value)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0x67
    if(!tppm.SetVignetteTexture(Value))
    {
        ClientMessage("TPP_SetVignetteTexture Error!");
    }
    //return;    
}

exec function TPP_SetColorCubeTexture(int Slot, @NULL Value)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0x6D
    if(!tppm.SetColorCubeTexture(Slot, Value))
    {
        ClientMessage("TPP_SetColorCubeTexture Error!");
    }
    //return;    
}

function bool TPP_GetTargetBool(byte Variable)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    return tppm.GetTargetBool(Variable);
    //return ReturnValue;    
}

function float TPP_GetTargetFloat(byte Variable)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    return tppm.GetTargetFloat(Variable);
    //return ReturnValue;    
}

function @NULL GetTargetColor(byte Variable)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    return tppm.GetTargetColor(Variable);
    //return ReturnValue;    
}

function @NULL TPP_GetTargetVignetteTexture()
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    return tppm.GetTargetVignetteTexture();
    //return ReturnValue;    
}

function @NULL TPP_GetTargetColorCubeTexture(int Slot)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    return tppm.GetTargetColorCubeTexture(Slot);
    //return ReturnValue;    
}

exec function TPP_ShowSettings(optional string Text)
{
    local @NULL TheColor, tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0x1B7
    if(ParseCommand(Text, "MotionBlur"))
    {
        ClientMessage("MotionBlur_Enable" @ string(tppm.GetTargetBool(0)));
        ClientMessage("MotionBlur_MaxVelocity" @ string(tppm.GetTargetFloat(19)));
        ClientMessage("MotionBlur_Amount" @ string(tppm.GetTargetFloat(20)));
        ClientMessage("MotionBlur_Scalar" @ string(tppm.GetTargetFloat(21)));
        ClientMessage("MotionBlur_CameraRotationThreshold" @ string(tppm.GetTargetFloat(22)));
        ClientMessage("MotionBlur_CameraTranslationThreshold" @ string(tppm.GetTargetFloat(23)));        
    }
    else
    {
        // End:0x34A
        if(ParseCommand(Text, "Fog"))
        {
            ClientMessage("Fog_Enable" @ string(tppm.GetTargetBool(1)));
            ClientMessage("Fog_StartDistance" @ string(tppm.GetTargetFloat(24)));
            ClientMessage("Fog_EndDistance" @ string(tppm.GetTargetFloat(25)));
            ClientMessage("Fog_StartDensity" @ string(tppm.GetTargetFloat(26)));
            ClientMessage("Fog_EndDensity" @ string(tppm.GetTargetFloat(27)));
            TheColor = tppm.GetTargetColor(43);
            ClientMessage(((("Fog_Color (" @ string(TheColor.R)) @ string(TheColor.G)) @ string(TheColor.B)) @ ")");            
        }
        else
        {
            // End:0x6E4
            if(ParseCommand(Text, "DOFAndBloom"))
            {
                ClientMessage("DOFAndBloom_Enable" @ string(tppm.GetTargetBool(2)));
                ClientMessage("DOF_FalloffExponent" @ string(tppm.GetTargetFloat(8)));
                ClientMessage("DOF_BlurKernelSize" @ string(tppm.GetTargetFloat(9)));
                ClientMessage("DOF_MaxNearBlurAmount" @ string(tppm.GetTargetFloat(10)));
                ClientMessage("DOF_MaxFarBlurAmount" @ string(tppm.GetTargetFloat(11)));
                ClientMessage("DOF_FocusInnerRadius" @ string(tppm.GetTargetFloat(7)));
                ClientMessage("DOF_FocusDistance" @ string(tppm.GetTargetFloat(6)));
                ClientMessage("Bloom_Scale" @ string(tppm.GetTargetFloat(18)));
                ClientMessage(" ");
                ClientMessage("DOF_FalloffExponent_HitReaction" @ string(tppm.GetTargetFloat(14)));
                ClientMessage("DOF_BlurKernelSize_HitReaction" @ string(tppm.GetTargetFloat(15)));
                ClientMessage("DOF_MaxNearBlurAmount_HitReaction" @ string(tppm.GetTargetFloat(16)));
                ClientMessage("DOF_MaxFarBlurAmount_HitReaction" @ string(tppm.GetTargetFloat(17)));
                ClientMessage("DOF_FocusInnerRadius_HitReaction" @ string(tppm.GetTargetFloat(13)));
                ClientMessage("DOF_FocusDistance_HitReaction" @ string(tppm.GetTargetFloat(12)));                
            }
            else
            {
                // End:0x7DF
                if(ParseCommand(Text, "Custom"))
                {
                    ClientMessage("Vignette_Texture" @ string(tppm.GetTargetVignetteTexture()));
                    ClientMessage("Vignette_Strength" @ string(tppm.GetTargetFloat(28)));
                    TheColor = tppm.GetTargetColor(44);
                    ClientMessage(((("Filter_Color (" @ string(TheColor.R)) @ string(TheColor.G)) @ string(TheColor.B)) @ ")");                    
                }
                else
                {
                    // End:0x982
                    if(ParseCommand(Text, "ToneMap"))
                    {
                        ClientMessage("ToneMap_Enable" @ string(tppm.GetTargetBool(4)));
                        ClientMessage("TI_AvgLum" @ string(tppm.GetTargetFloat(29)));
                        ClientMessage("TI_Spd" @ string(tppm.GetTargetFloat(30)));
                        ClientMessage("TI_LumMin" @ string(tppm.GetTargetFloat(31)));
                        ClientMessage("TI_LumMax" @ string(tppm.GetTargetFloat(32)));
                        ClientMessage("TI_Contrast" @ string(tppm.GetTargetFloat(33)));
                        ClientMessage("TI_WhiteSqd" @ string(tppm.GetTargetFloat(34)));
                        ClientMessage("TI_PctChange" @ string(tppm.GetTargetFloat(35)));                        
                    }
                    else
                    {
                        // End:0xAEC
                        if(ParseCommand(Text, "ColorCube"))
                        {
                            ClientMessage("ColorCube_Texture0" @ string(tppm.GetTargetColorCubeTexture(0)));
                            ClientMessage("ColorCube_Blend0" @ string(tppm.GetTargetFloat(36)));
                            ClientMessage("ColorCube_Texture1" @ string(tppm.GetTargetColorCubeTexture(1)));
                            ClientMessage("ColorCube_Blend1" @ string(tppm.GetTargetFloat(37)));
                            ClientMessage("ColorCube_Texture2" @ string(tppm.GetTargetColorCubeTexture(2)));
                            ClientMessage("ColorCube_Blend2" @ string(tppm.GetTargetFloat(38)));                            
                        }
                        else
                        {
                            // End:0xBF1
                            if(ParseCommand(Text, "EdgeAA"))
                            {
                                ClientMessage("EdgeAA_sampleScalar" @ string(tppm.GetTargetFloat(39)));
                                ClientMessage("EdgeAA_EdgeAABeatsMBlur" @ string(tppm.GetTargetFloat(40)));
                                ClientMessage("EdgeAA_minDistance" @ string(tppm.GetTargetFloat(41)));
                                ClientMessage("EdgeAA_ProcessMethod" @ string(tppm.GetTargetFloat(42)));                                
                            }
                            else
                            {
                                ClientMessage("Usage TPP_ShowSettings <category>");
                                ClientMessage(" Categories are MotionBlur | Fog | DOFAndBloom | Custom | ToneMap | ColorCube | EdgeAA");
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function bool CanPlayerChangeWeapon()
{
    // End:0x16
    if(WorldInfo.Pauser != none)
    {
        return false;
    }
    // End:0x23
    if(Pawn == none)
    {
        return false;
    }
    // End:0x39
    if(Pawn.DrivenVehicle != none)
    {
        return false;
    }
    // End:0x4F
    if(Pawn.InvManager == none)
    {
        return false;
    }
    // End:0x75
    if(TurokInventoryManager(Pawn.InvManager).SimulatedGetIsDroppingWeaponForPickup())
    {
        return false;
    }
    // End:0x9F
    if(TurokInventoryManager(Pawn.InvManager).GetTurokWeaponCount() < 2)
    {
        return false;
    }
    // End:0xD5
    if((IsInState('PlayerClimbing') || IsInState('CannedAnimation')) || IsInState('ConstrainPlayerState'))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

exec function PrevWeapon()
{
    local @NULL W;

    // End:0x12
    if((CanPlayerChangeWeapon()) == false)
    {
        return;
    }
    // End:0xA9
    if(TurokPawnHuman(Pawn).GetPrimaryWeapon() == none)
    {
        W = Pawn.InvManager.GetBestWeapon();
        // End:0xA6
        if(((W != none) && W.InvManager == Pawn.InvManager) && W.Instigator == Pawn)
        {
            SwitchToBestWeapon();
        }        
    }
    else
    {
        // End:0xD9
        if(Pawn.InvManager != none)
        {
            Pawn.InvManager.PrevWeapon();
        }
    }
    //return;    
}

exec function NextWeapon()
{
    local @NULL W;

    // End:0x12
    if((CanPlayerChangeWeapon()) == false)
    {
        return;
    }
    // End:0xA9
    if(TurokPawnHuman(Pawn).GetPrimaryWeapon() == none)
    {
        W = Pawn.InvManager.GetBestWeapon();
        // End:0xA6
        if(((W != none) && W.InvManager == Pawn.InvManager) && W.Instigator == Pawn)
        {
            SwitchToBestWeapon();
        }        
    }
    else
    {
        Pawn.InvManager.NextWeapon();
    }
    //return;    
}

exec function PressedNextWeapon()
{
    local @NULL W;

    // End:0x12
    if((CanPlayerChangeWeapon()) == false)
    {
        return;
    }
    // End:0xE3
    if(TurokInventoryManager(Pawn.InvManager) != none)
    {
        // End:0xC2
        if(TurokPawnHuman(Pawn).GetPrimaryWeapon() == none)
        {
            W = Pawn.InvManager.GetBestWeapon();
            // End:0xBF
            if(((W != none) && W.InvManager == Pawn.InvManager) && W.Instigator == Pawn)
            {
                SwitchToBestWeapon();
            }            
        }
        else
        {
            TurokInventoryManager(Pawn.InvManager).PressedNextWeapon();
        }
    }
    //return;    
}

exec function PressedWeaponDown()
{
    local @NULL W;

    // End:0x12
    if((CanPlayerChangeWeapon()) == false)
    {
        return;
    }
    // End:0xED
    if(TurokInventoryManager(Pawn.InvManager) != none)
    {
        // End:0xC2
        if(TurokPawnHuman(Pawn).GetPrimaryWeapon() == none)
        {
            W = Pawn.InvManager.GetBestWeapon();
            // End:0xBF
            if(((W != none) && W.InvManager == Pawn.InvManager) && W.Instigator == Pawn)
            {
                SwitchToBestWeapon();
            }            
        }
        else
        {
            TurokInventoryManager(Pawn.InvManager).PressedWeaponPermanent();
        }
        ReleasedNextWeapon2();
    }
    //return;    
}

exec function PressedWeaponLeft()
{
    local @NULL W;

    // End:0x12
    if((CanPlayerChangeWeapon()) == false)
    {
        return;
    }
    // End:0xEE
    if(TurokInventoryManager(Pawn.InvManager) != none)
    {
        // End:0xC2
        if(TurokPawnHuman(Pawn).GetPrimaryWeapon() == none)
        {
            W = Pawn.InvManager.GetBestWeapon();
            // End:0xBF
            if(((W != none) && W.InvManager == Pawn.InvManager) && W.Instigator == Pawn)
            {
                SwitchToBestWeapon();
            }            
        }
        else
        {
            TurokInventoryManager(Pawn.InvManager).PressedWeaponDpad(1);
        }
        ReleasedNextWeapon2();
    }
    //return;    
}

exec function PressedWeaponRight()
{
    local @NULL W;

    // End:0x12
    if((CanPlayerChangeWeapon()) == false)
    {
        return;
    }
    // End:0xEE
    if(TurokInventoryManager(Pawn.InvManager) != none)
    {
        // End:0xC2
        if(TurokPawnHuman(Pawn).GetPrimaryWeapon() == none)
        {
            W = Pawn.InvManager.GetBestWeapon();
            // End:0xBF
            if(((W != none) && W.InvManager == Pawn.InvManager) && W.Instigator == Pawn)
            {
                SwitchToBestWeapon();
            }            
        }
        else
        {
            TurokInventoryManager(Pawn.InvManager).PressedWeaponDpad(0);
        }
        ReleasedNextWeapon2();
    }
    //return;    
}

exec function PressedWeaponUp()
{
    // End:0x12
    if((CanPlayerChangeWeapon()) == false)
    {
        return;
    }
    // End:0x96
    if(!Class'TurokUtil'.static.IsMultiplayerGame())
    {
        // End:0x96
        if(TurokInventoryManager(Pawn.InvManager) != none)
        {
            // End:0x6B
            if(TurokPawnHuman(Pawn).GetPrimaryWeapon() == none)
            {
                SwitchToBestWeapon();                
            }
            else
            {
                TurokInventoryManager(Pawn.InvManager).PressedWeaponBow();
            }
            ReleasedNextWeapon2();
        }
    }
    //return;    
}

exec function ReleasedNextWeapon()
{
    //return;    
}

exec function ReleasedNextWeapon2()
{
    // End:0x54
    if((CanPlayerChangeWeapon()) == false)
    {
        TurokHud(myHUD).mDpadWeaponSelect.KillHud();
        TurokHud(myHUD).mDpadWeaponSelect.InstantKillHud();
        return;
    }
    // End:0xAC
    if(TurokInventoryManager(Pawn.InvManager) != none)
    {
        // End:0xAC
        if(TurokPawnHuman(Pawn).GetPrimaryWeapon() != none)
        {
            TurokInventoryManager(Pawn.InvManager).ReleasedNextWeapon();
        }
    }
    //return;    
}

simulated function SwapWeaponHoldTimerX()
{
    local @NULL tInvManager;

    // End:0x23
    if((Pawn == none) || Pawn.DrivenVehicle != none)
    {
        return;
    }
    tInvManager = TurokInventoryManager(Pawn.InvManager);
    // End:0x7E
    if((TurokPawnHuman(Pawn) != none) && TurokPawnHuman(Pawn).IsWeaponReloading())
    {
        SetTimer(mButtonHoldTime, false, 'SwapWeaponHoldTimerX');
        return;
    }
    // End:0xBC
    if((tInvManager != none) && tInvManager.IsDropItemPromptActive())
    {
        tInvManager.DropItemChoiceL();
        mButtonXWeaponSwapped = true;
    }
    //return;    
}

simulated function SwapWeaponHoldTimerY()
{
    local @NULL tInvManager;

    // End:0x23
    if((Pawn == none) || Pawn.DrivenVehicle != none)
    {
        return;
    }
    tInvManager = TurokInventoryManager(Pawn.InvManager);
    // End:0x7E
    if((TurokPawnHuman(Pawn) != none) && TurokPawnHuman(Pawn).IsWeaponReloading())
    {
        SetTimer(mButtonHoldTime, false, 'SwapWeaponHoldTimerY');
        return;
    }
    // End:0xBC
    if((tInvManager != none) && tInvManager.IsDropItemPromptActive())
    {
        tInvManager.DropItemChoiceR();
        mButtonYWeaponSwapped = true;
    }
    //return;    
}

exec function ButtonXPress()
{
    SetTimer(mButtonHoldTime, false, 'SwapWeaponHoldTimerX');
    mButtonXWeaponSwapped = false;
    //return;    
}

exec function ButtonXRelease()
{
    // End:0x6C
    if((!TurokInventoryManager(Pawn.InvManager).IsDropItemPromptActive() || IsTimerActive('SwapWeaponHoldTimerX')) && !mButtonXWeaponSwapped)
    {
        ClearTimer('SwapWeaponHoldTimerX');
        ReloadWeapon();
        EndReload();
    }
    //return;    
}

exec function ButtonYPress()
{
    SetTimer(mButtonHoldTime, false, 'SwapWeaponHoldTimerY');
    mButtonYWeaponSwapped = false;
    //return;    
}

exec function ButtonYRelease()
{
    // End:0x62
    if((!TurokInventoryManager(Pawn.InvManager).IsDropItemPromptActive() || IsTimerActive('SwapWeaponHoldTimerY')) && !mButtonYWeaponSwapped)
    {
        ClearTimer('SwapWeaponHoldTimerY');
        ToggleCrouch();
    }
    //return;    
}

exec function ButtonXReleasePC()
{
    // End:0x58
    if((!TurokInventoryManager(Pawn.InvManager).IsDropItemPromptActive() || IsTimerActive('SwapWeaponHoldTimerX')) && !mButtonXWeaponSwapped)
    {
        ClearTimer('SwapWeaponHoldTimerX');
    }
    //return;    
}

exec function ButtonYReleasePC()
{
    // End:0x58
    if((!TurokInventoryManager(Pawn.InvManager).IsDropItemPromptActive() || IsTimerActive('SwapWeaponHoldTimerY')) && !mButtonYWeaponSwapped)
    {
        ClearTimer('SwapWeaponHoldTimerY');
    }
    //return;    
}

exec function ReloadWeapon()
{
    // End:0x3E
    if((Pawn != none) && TurokPawnHuman(Pawn) != none)
    {
        TurokPawnHuman(Pawn).mWeaponMediator.ReloadWeapons();
    }
    //return;    
}

exec function EndReload()
{
    // End:0x3E
    if((Pawn != none) && TurokPawnHuman(Pawn) != none)
    {
        TurokPawnHuman(Pawn).mWeaponMediator.EndReloadWeapons();
    }
    //return;    
}

exec function NoGun()
{
    // End:0x41
    if(Pawn != none)
    {
        TurokPawnHuman(Pawn).mWeaponMediator.DestroyBothWeapons();
        Pawn.Weapon.Destroy();
    }
    //return;    
}

simulated function LockOnAimAssistTarget()
{
    //return;    
}

reliable client simulated function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
    local @NULL HUD;

    super.ClientSetCinematicMode(bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD);
    // End:0x60
    if((myHUD != none) && bAffectsHUD)
    {
        HUD = TurokHud(myHUD);
        // End:0x60
        if(bInCinematicMode)
        {
            HUD.SquelchObjectiveIndicatorAndText();
        }
    }
    //return;    
}

exec function StartAltFireLH()
{
    local @NULL tph;

    tph = TurokPawnHuman(Pawn);
    // End:0x69
    if(tph != none)
    {
        // End:0x69
        if(tph.mWeaponMediator.IsDualWielding())
        {
            // End:0x69
            if((Pawn != none) && !bCinematicMode)
            {
                Pawn.StartFire(13);
                return;
            }
        }
    }
    // End:0x7B
    if(none != TurokVehicle(Pawn))
    {
        return;
    }
    // End:0x9A
    if(tph != none)
    {
        tph.NotifyAltFireLH(true);
    }
    //return;    
}

exec function StopAltFireLH()
{
    local @NULL tph;

    tph = TurokPawnHuman(Pawn);
    // End:0x69
    if((tph != none) && tph.mWeaponMediator.IsDualWielding())
    {
        // End:0x69
        if((Pawn != none) && !bCinematicMode)
        {
            Pawn.StopFire(13);
        }
    }
    //return;    
}

exec function StartFire(optional byte FireModeNum)
{
    local @NULL tph;

    tph = TurokPawnHuman(Pawn);
    // End:0x37
    if(WorldInfo.Pauser == PlayerReplicationInfo)
    {
        SetPause(false);
        return;
    }
    // End:0x9E
    if((Pawn != none) && !bCinematicMode)
    {
        // End:0x86
        if(tph.mWeaponMediator.IsDualWielding())
        {
            Pawn.StartFire(10);            
        }
        else
        {
            Pawn.StartFire(FireModeNum);
        }
    }
    //return;    
}

exec function StopFire(optional byte FireModeNum)
{
    local @NULL tph;

    tph = TurokPawnHuman(Pawn);
    // End:0x6B
    if(Pawn != none)
    {
        // End:0x53
        if(tph.mWeaponMediator.IsDualWielding())
        {
            Pawn.StopFire(10);            
        }
        else
        {
            Pawn.StopFire(FireModeNum);
        }
    }
    //return;    
}

exec function StartAltFire(optional byte FireModeNum)
{
    local @NULL tph;

    tph = TurokPawnHuman(Pawn);
    // End:0x68
    if(Pawn != none)
    {
        // End:0x53
        if(tph.mWeaponMediator.IsDualWielding())
        {
            Pawn.StartFire(11);            
        }
        else
        {
            Pawn.StartFire(1);
        }
    }
    //return;    
}

exec function StopAltFire(optional byte FireModeNum)
{
    local @NULL tph;

    tph = TurokPawnHuman(Pawn);
    // End:0x68
    if(Pawn != none)
    {
        // End:0x53
        if(tph.mWeaponMediator.IsDualWielding())
        {
            Pawn.StopFire(11);            
        }
        else
        {
            Pawn.StopFire(1);
        }
    }
    //return;    
}

function bool PerformDive()
{
    //return ReturnValue;    
}

exec function MaulingRightTrigger()
{
    //return;    
}

exec function MaulingLeftTrigger()
{
    //return;    
}

exec function ToggleCrouch()
{
    // End:0x18
    if(int(bDuck) == 0)
    {
        bDuck = 1;        
    }
    else
    {
        bDuck = 0;
    }
    //return;    
}

exec function BeginCrouch()
{
    bDuck = 1;
    //return;    
}

exec function EndCrouch()
{
    bDuck = 0;
    //return;    
}

exec function Pause()
{
    Class'TurokEngine.TurokUI'.static.OpenPauseMenu();
    //return;    
}

exec function ZoomPressed()
{
    local bool IsZoomActivated;

    IsZoomActivated = ExecuteZoomPressed();
    mZoomPressed = IsZoomActivated;
    // End:0x3E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerZoomUpdate(mZoomPressed);
    }
    //return;    
}

exec function ZoomReleased()
{
    mZoomPressed = false;
    ExecuteZoomReleased();
    // End:0x2D
    if(int(Role) < int(ROLE_Authority))
    {
        ServerZoomUpdate(false);
    }
    //return;    
}

reliable server function ServerZoomUpdate(bool NewZoom)
{
    local @NULL tph;

    mZoomPressed = NewZoom;
    tph = TurokPawnHuman(Pawn);
    // End:0x41
    if(tph != none)
    {
        tph.NotifyWeaponZoom(mZoomPressed);
    }
    //return;    
}

function bool ExecuteZoomPressed()
{
    local @NULL tph;
    local byte WeaponType;

    tph = TurokPawnHuman(Pawn);
    // End:0x69
    if(tph != none)
    {
        // End:0x69
        if(tph.mWeaponMediator.IsDualWielding())
        {
            // End:0x69
            if((Pawn != none) && !bCinematicMode)
            {
                Pawn.StartFire(12);
                return true;
            }
        }
    }
    // End:0x7B
    if(none != TurokVehicle(Pawn))
    {
        return false;
    }
    // End:0xE4
    if(tph != none)
    {
        WeaponType = tph.mWeaponMediator.GetPrimaryWeapon().mWeaponType;
        // End:0xE4
        if((int(WeaponType) == int(5)) || tph.mWeaponMediator.IsDualWielding())
        {
            return false;
        }
    }
    // End:0x103
    if(tph != none)
    {
        tph.NotifyWeaponZoom(true);
    }
    return true;
    //return ReturnValue;    
}

function ExecuteZoomReleased()
{
    local @NULL tph;

    tph = TurokPawnHuman(Pawn);
    // End:0x69
    if(tph != none)
    {
        // End:0x69
        if(tph.mWeaponMediator.IsDualWielding())
        {
            // End:0x69
            if((Pawn != none) && !bCinematicMode)
            {
                Pawn.StopFire(12);
                return;
            }
        }
    }
    // End:0x7B
    if(none != TurokVehicle(Pawn))
    {
        return;
    }
    // End:0x9A
    if(tph != none)
    {
        tph.NotifyWeaponZoom(false);
    }
    //return;    
}

exec function ThrowWeapon()
{
    local @NULL invMan;

    // End:0x66
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        // End:0x66
        if(none != Pawn)
        {
            invMan = TurokInventoryManager(Pawn.InvManager);
            // End:0x66
            if((invMan != none) && invMan.GetTurokWeaponCount() > 1)
            {
                ServerThrowWeapon();
            }
        }
    }
    //return;    
}

reliable server function ServerThrowWeapon()
{
    // End:0x41
    if((TurokInventoryManager(Pawn.InvManager) != none) && TurokInventoryManager(Pawn.InvManager).IsDropItemPromptActive())
    {
        return;
    }
    ServerThrowSpecificWeapon(none);
    //return;    
}

reliable server function ServerThrowSpecificWeapon(@NULL weaponToToss)
{
    local @NULL POVLoc, TossVel, POVRot, tph;

    tph = TurokPawnHuman(Pawn);
    // End:0x1D
    if(tph == none)
    {
        return;
    }
    // End:0x45
    if(weaponToToss != none)
    {
        // End:0x42
        if(!weaponToToss.CanThrow())
        {
            return;
        }        
    }
    else
    {
        // End:0x77
        if(!tph.CanThrowWeapon() || tph.IsWeaponReloading())
        {
            return;
        }
    }
    GetActorEyesViewPoint(POVLoc, POVRot);
    POVRot.Pitch = 0;
    POVRot.Roll = 0;
    TossVel = Vector(POVRot);
    TossVel = (TossVel * ((tph.Velocity Dot TossVel) + float(250))) + vect(0.0000000, 0.0000000, 250.0000000);
    weaponToToss.ClearPendingFire(0);
    weaponToToss.ClearPendingFire(1);
    tph.TossSpecificWeapon(TossVel, weaponToToss);
    //return;    
}

exec function SpectateNext()
{
    //return;    
}

exec function SpectatePrev()
{
    //return;    
}

exec function SwitchTeam()
{
    ServerSwitchTeam();
    //return;    
}

exec function ChangeTeam(string TeamName)
{
    ServerChangeTeam(int(TeamName));
    //return;    
}

reliable server function ServerSwitchTeam()
{
    local int maxTeams, TeamIndex, CharacterIndex;

    maxTeams = 2;
    // End:0x4E
    if((PlayerReplicationInfo.Team == none) || int(PlayerReplicationInfo.Team.TeamIndex) == (maxTeams - 1))
    {
        TeamIndex = 0;        
    }
    else
    {
        TeamIndex = int(PlayerReplicationInfo.Team.TeamIndex) + 1;
    }
    ServerChangeTeam(TeamIndex);
    // End:0xD6
    if(TurokMPGame(WorldInfo.Game) != none)
    {
        CharacterIndex = TurokMPGame(WorldInfo.Game).GetCharacterIndex(self);
        PlayerReplicationInfo.CharacterIndex = byte(CharacterIndex);
    }
    //return;    
}

// Export UTurokPlayerController::execGetStatTracker(FFrame&, void* const)
protected native function @NULL GetStatTracker();

// Export UTurokPlayerController::execRecordShotFired(FFrame&, void* const)
native function RecordShotFired(@NULL Weapon, class<Class> projectileType);

// Export UTurokPlayerController::execRecordExplosionHit(FFrame&, void* const)
native function RecordExplosionHit(@NULL Projectile, float DamageRadius, @NULL HitLocation, bool bTraceToTopOfBBox);

// Export UTurokPlayerController::execRecordShotHit(FFrame&, void* const)
native function RecordShotHit(@NULL Weapon, array ImpactList, class<Class> projectileType);

// Export UTurokPlayerController::execRecordKill(FFrame&, void* const)
native function RecordKill(@NULL Victim, class<Class> DamageType, @NULL HitInfo);

// Export UTurokPlayerController::execRecordDeath(FFrame&, void* const)
native function RecordDeath(@NULL Killer, class<Class> DamageType);

// Export UTurokPlayerController::execRecordMatchEnded(FFrame&, void* const)
native function RecordMatchEnded(@NULL Winner, @NULL Game, bool GameCompleted);

// Export UTurokPlayerController::execRecordStat(FFrame&, void* const)
native function RecordStat(byte stat, float Value, byte Op);

// Export UTurokPlayerController::execFinishRecordingStats(FFrame&, void* const)
native function FinishRecordingStats();

// Export UTurokPlayerController::execRecordEndRoundStats(FFrame&, void* const)
native function RecordEndRoundStats();

simulated exec function DebugPrintStats()
{
    mStats.DebugPrintAll();
    //return;    
}

simulated exec function DebugDumpStats()
{
    mStats.WriteToFile(PlayerReplicationInfo.PlayerName);
    //return;    
}

simulated exec function ResetStats()
{
    mStats.Clear();
    //return;    
}

simulated exec function DebugFlushStats()
{
    local @NULL db, Profile;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    Profile = TurokOnlineProfile(db.GetSignedInProfile());
    WritePersonalStats(Profile);
    mStats.Clear();
    ServerAdminResetStats();
    //return;    
}

private final function bool ParseCommand(string Text, string Command)
{
    local int CommandLen;

    CommandLen = Len(Command);
    // End:0x25
    if(Left(Text, CommandLen) ~= Command)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

exec function Admin(string Text, optional string ParamString)
{
    return;
    // End:0x29
    if(ParseCommand(Text, "kill"))
    {
        ServerAdminKill(ParamString);        
    }
    else
    {
        // End:0x50
        if(ParseCommand(Text, "playerlist"))
        {
            ServerAdminPlayerList();            
        }
        else
        {
            // End:0x74
            if(ParseCommand(Text, "restart"))
            {
                ServerAdminRestartMap();                
            }
            else
            {
                // End:0x98
                if(ParseCommand(Text, "timeout"))
                {
                    ServerAdminTimeOut();                    
                }
                else
                {
                    // End:0xC0
                    if(ParseCommand(Text, "change"))
                    {
                        ServerAdminChangeMap(ParamString);                        
                    }
                    else
                    {
                        // End:0xE6
                        if(ParseCommand(Text, "kick"))
                        {
                            ServerAdminKick(ParamString);                            
                        }
                        else
                        {
                            // End:0x10C
                            if(ParseCommand(Text, "exec"))
                            {
                                ServerAdminExec(ParamString);                                
                            }
                            else
                            {
                                // End:0x137
                                if(ParseCommand(Text, "dumpstats"))
                                {
                                    ServerAdminDumpStats(ParamString);                                    
                                }
                                else
                                {
                                    // End:0x163
                                    if(ParseCommand(Text, "resetstats"))
                                    {
                                        ServerAdminResetStats(ParamString);                                        
                                    }
                                    else
                                    {
                                        // End:0x18D
                                        if(ParseCommand(Text, "spectate"))
                                        {
                                            ServerAdminSetSpectatorMode(ParamString);                                            
                                        }
                                        else
                                        {
                                            // End:0x1B2
                                            if(ParseCommand(Text, "end"))
                                            {
                                                ServerAdminEndGame(ParamString);                                                
                                            }
                                            else
                                            {
                                                DebugMessage(((((((((("Valid commands are:\n" $ "playerlist\n") $ "restart\n") $ "change <mapname>\n") $ "timeout\n") $ "exec \"<command string>\"") $ "dumpstats\n") $ "resetstats\n") $ "spectate [on|off]\n") $ "end [reason]\n") $ "");
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

exec function NetReset()
{
    // End:0x1D
    if(int(Role) == int(ROLE_Authority))
    {
        ServerNetResetAllClients();        
    }
    else
    {
        ServerNetReset();
    }
    //return;    
}

reliable client simulated function ClientAdminMessage(string Result)
{
    DebugMessage(Result);
    //return;    
}

function ServerAdminPrintResult(string Result)
{
    ClientAdminMessage(Result);
    //return;    
}

reliable server function ServerAdminPlayerList()
{
    local string Result;
    local @NULL PRI;

    Result $= "Player List:\n";
    // End:0x6A
    foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
    {        
        Result $= (((PRI.PlayerName @ "( ping") @ string(PRI.Ping)) $ ")\n");        
    }    
    ServerAdminPrintResult(Result);
    //return;    
}

reliable server function ServerAdminRestartMap()
{
    ServerAdminPrintResult("Map Restarting...");
    WorldInfo.Game.ResetLevel();
    //return;    
}

reliable server function ServerAdminChangeMap(string URL)
{
    local string Result;

    // End:0x49
    if(!Class'TurokUtil'.static.IsLocalPackage(URL))
    {
        Result = ("Package " $ URL) $ " does not exist...";        
    }
    else
    {
        WorldInfo.ServerTravel(URL);
        // End:0x97
        if(WorldInfo.NextURL != "")
        {
            Result = ("Opening " $ URL) $ "...";            
        }
        else
        {
            Result = "Failed to changemap";
        }
    }
    ServerAdminPrintResult(Result);
    //return;    
}

reliable server function ServerAdminKick(string PlayerName)
{
    WorldInfo.Game.Kick(PlayerName);
    ServerAdminPrintResult(("Kicking " $ PlayerName) $ "...");
    //return;    
}

reliable server function ServerAdminKill(string PlayerName)
{
    local @NULL C;

    // End:0x52
    if(PlayerName == "")
    {
        // End:0x2A
        if(Pawn != none)
        {
            Pawn.Suicide();
        }
        ServerAdminPrintResult(PlayerReplicationInfo.PlayerName $ " suicided.");
        return;
    }
    // End:0x139
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x138
        if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.PlayerName ~= PlayerName)
        {
            // End:0x106
            if(C.Pawn != none)
            {
                C.Pawn.Suicide();
                ServerAdminPrintResult(PlayerName $ " was instructed to suicide.");                
                return;
            }
            ServerAdminPrintResult(PlayerName $ " doesn't have a pawn to die.");            
            return;
        }        
    }    
    //return;    
}

reliable server function ServerAdminExec(string Command)
{
    local string Result;

    Result = Class'TurokUtil'.static.ExecEngineCommand(Command);
    ServerAdminPrintResult(((("Executed Cmd[" $ Command) $ "] Result[") $ Result) $ "]");
    //return;    
}

reliable server function ServerAdminDumpStats(optional string PlayerName)
{
    local @NULL Stats;

    // End:0x22
    if(Len(PlayerName) == 0)
    {
        PlayerName = PlayerReplicationInfo.PlayerName;
    }
    Stats = GetStatTracker().GetPlayerStatsByName(PlayerName);
    // End:0x9D
    if(Stats != none)
    {
        Stats.ClientDebugPrintAll(self);
        ServerAdminPrintResult(("Stats for player " $ PlayerName) $ " dumped to client");
    }
    //return;    
}

reliable server function ServerAdminResetStats(optional string PlayerName)
{
    local @NULL Stats;

    // End:0x22
    if(Len(PlayerName) == 0)
    {
        PlayerName = PlayerReplicationInfo.PlayerName;
    }
    Stats = GetStatTracker().GetPlayerStatsByName(PlayerName);
    // End:0x9B
    if(Stats != none)
    {
        Stats.Clear();
        ServerAdminPrintResult(("Stats for player " $ PlayerName) $ " have been reset");
    }
    //return;    
}

reliable server function ServerAdminTimeOut()
{
    local @NULL MPGame;

    MPGame = TurokMPGame(WorldInfo.Game);
    // End:0x26
    if(MPGame == none)
    {
        return;
    }
    // End:0x3C
    if(MPGame.TimeLimit <= 0)
    {
        return;
    }
    ServerAdminPrintResult("Map timing out...");
    WorldInfo.GRI.RemainingTime = 0;
    WorldInfo.GRI.RemainingMinute = 0;
    //return;    
}

reliable server function ServerNetReset()
{
    local int numReset;

    numReset = DebugNetReset();
    ServerAdminPrintResult(("Reset " $ string(numReset)) $ " actors");
    //return;    
}

reliable server function ServerNetResetAllClients()
{
    local int numReset;

    numReset = DebugNetResetAllClients();
    ServerAdminPrintResult(("Reset " $ string(numReset)) $ " actors");
    //return;    
}

reliable server function ServerAdminSetSpectatorMode(string mode)
{
    local @NULL GI;

    GI = TurokMPGame(WorldInfo.Game);
    // End:0x61
    if(GI == none)
    {
        ServerAdminPrintResult("Spectating is only allowed in multiplayer games");
        return;
    }
    // End:0xA2
    if(mode == "off")
    {
        ServerAdminPrintResult("Stop spectating");
        GI.StopSpectating(self);        
    }
    else
    {
        ServerAdminPrintResult("Start spectating");
        GI.StartSpectating(self);
    }
    //return;    
}

reliable server function ServerAdminEndGame(string Reason)
{
    // End:0x1C
    if(Reason == "")
    {
        Reason = "AdminEnd";
    }
    WorldInfo.Game.EndGame(none, Reason);
    ServerAdminPrintResult("Game Ended");
    //return;    
}

reliable server function ServerSuicide()
{
    // End:0x1E
    if(Pawn != none)
    {
        Pawn.Suicide();
    }
    //return;    
}

simulated function SpawnPlayerCamera()
{
    // End:0x0D
    if(PlayerCamera != none)
    {
        return;
    }
    // End:0x51
    if(CameraClass != none)
    {
        PlayerCamera = __NFUN_278__(CameraClass, self);
        // End:0x4E
        if(PlayerCamera != none)
        {
            PlayerCamera.InitializeFor(self);            
        }        
    }
    //return;    
}

function SetCameraMode(name NewCamMode)
{
    SimulatedSetTurokCamera(NewCamMode);
    // End:0x3B
    if((int(Role) == int(ROLE_Authority)) && !IsLocalPlayerController())
    {
        ClientSetTurokCamera(NewCamMode);
    }
    //return;    
}

reliable client simulated function ClientSetCameraMode(name NewCamMode)
{
    ScriptTrace();
    //return;    
}

private reliable client final simulated function ClientSetTurokCamera(name NewCamMode)
{
    SimulatedSetTurokCamera(NewCamMode);
    //return;    
}

// Export UTurokPlayerController::execSimulatedSetTurokCamera(FFrame&, void* const)
native function SimulatedSetTurokCamera(name NewCamMode);

// Export UTurokPlayerController::execSimulatedResetTurokCamera(FFrame&, void* const)
native function SimulatedResetTurokCamera();

// Export UTurokPlayerController::execSimulatedBlendToNewCamera(FFrame&, void* const)
native function SimulatedBlendToNewCamera(name cameraName, float blendTime);

private final function SimulatedSetSpectatorMode(bool bEnable)
{
    // End:0x2C
    if(bEnable)
    {
        // End:0x29
        if(!IsInState('TurokSpectating'))
        {
            GotoState('TurokSpectating');
        }        
    }
    else
    {
        // End:0x4A
        if(IsInState('TurokSpectating'))
        {
            GotoState('PlayerWaiting');
        }
    }
    //return;    
}

private reliable client final simulated function ClientSetSpectatorMode(bool bEnable)
{
    SimulatedSetSpectatorMode(bEnable);
    //return;    
}

function StartSpectating()
{
    SimulatedSetSpectatorMode(true);
    // End:0x2F
    if((int(Role) == int(ROLE_Authority)) && !IsLocalPlayerController())
    {
        ClientSetSpectatorMode(true);
    }
    //return;    
}

function StopSpectating()
{
    SimulatedSetSpectatorMode(false);
    // End:0x2F
    if((int(Role) == int(ROLE_Authority)) && !IsLocalPlayerController())
    {
        ClientSetSpectatorMode(false);
    }
    //return;    
}

unreliable server function ServerViewSelf()
{
    ScriptTrace();
    //return;    
}

unreliable server function ServerViewNextPlayer()
{
    ScriptTrace();
    //return;    
}

unreliable server function TurokServerViewPlayer(int Offset)
{
    local @NULL C;
    local array AvailablePlayers;
    local @NULL CurrentViewTarget;
    local int CurrentIndex;
    local @NULL SelectedTarget;

    CurrentViewTarget = GetViewTarget();
    CurrentIndex = 0;
    // End:0xE9
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0xE8
        if(((C.bIsPlayer && C.Pawn != none) && C.PlayerReplicationInfo != none) && WorldInfo.Game.CanSpectate(self, C.PlayerReplicationInfo))
        {
            // End:0xD6
            if((CurrentViewTarget == C) || CurrentViewTarget == C.Pawn)
            {
                CurrentIndex = AvailablePlayers.Length;
            }
            AvailablePlayers[AvailablePlayers.Length] = C;
        }        
    }    
    // End:0x117
    if(AvailablePlayers.Length == 0)
    {
        mSpectatedPlayerId = 0;
        SetViewTarget(none);
        ClientSetViewTarget(none);
        return;
    }
    // End:0x12C
    if(Offset > 0)
    {
        ++CurrentIndex;        
    }
    else
    {
        --CurrentIndex;
    }
    // End:0x150
    if(CurrentIndex < 0)
    {
        CurrentIndex = AvailablePlayers.Length - 1;        
    }
    else
    {
        // End:0x167
        if(CurrentIndex >= AvailablePlayers.Length)
        {
            CurrentIndex = 0;
        }
    }
    SelectedTarget = AvailablePlayers[CurrentIndex];
    mSpectatedPlayerId = SelectedTarget.PlayerReplicationInfo.PlayerID;
    SetViewTarget(SelectedTarget.Pawn);
    ClientSetViewTarget(SelectedTarget.Pawn);
    //return;    
}

reliable server function AskForPawn()
{
    ScriptTrace();
    //return;    
}

reliable client simulated function ClientRestart(@NULL NewPawn)
{
    ScriptTrace();
    //return;    
}

reliable client simulated function GivePawn(@NULL NewPawn)
{
    ScriptTrace();
    //return;    
}

reliable client simulated event ClientSetViewTarget(@NULL A, optional float TransitionTime)
{
    local @NULL CurrentViewTarget;

    CurrentViewTarget = GetViewTarget();
    // End:0x3A
    if((A == none) && TurokMPViewpoint(CurrentViewTarget) != none)
    {
        ServerVerifyViewTarget();
        return;
    }
    super.ClientSetViewTarget(A, TransitionTime);
    //return;    
}

simulated function CheckEndOfRoundAchievements()
{
    // End:0x3A
    if((IsLocalPlayerController()) && mAchievementTracker != none)
    {
        mAchievementTracker.CheckEndOfRoundAchievements(int(mWinningReason) != int(4));
    }
    //return;    
}

simulated function SetWinPlayerRoundOver(@NULL Id)
{
    mWinPlayerRoundOver[0] = Id.Uid[0];
    mWinPlayerRoundOver[1] = Id.Uid[1];
    mWinPlayerRoundOver[2] = Id.Uid[2];
    mWinPlayerRoundOver[3] = Id.Uid[3];
    mWinPlayerRoundOver[4] = Id.Uid[4];
    mWinPlayerRoundOver[5] = Id.Uid[5];
    mWinPlayerRoundOver[6] = Id.Uid[6];
    mWinPlayerRoundOver[7] = Id.Uid[7];
    //return;    
}

simulated function @NULL GetWinPlayerRoundOver()
{
    local @NULL Id;

    Id.Uid[0] = mWinPlayerRoundOver[0];
    Id.Uid[1] = mWinPlayerRoundOver[1];
    Id.Uid[2] = mWinPlayerRoundOver[2];
    Id.Uid[3] = mWinPlayerRoundOver[3];
    Id.Uid[4] = mWinPlayerRoundOver[4];
    Id.Uid[5] = mWinPlayerRoundOver[5];
    Id.Uid[6] = mWinPlayerRoundOver[6];
    Id.Uid[7] = mWinPlayerRoundOver[7];
    return Id;
    //return ReturnValue;    
}

simulated function SimulatedRoundOver(bool bGameOver, byte R, @NULL EndFocus, @NULL Uid, byte tid)
{
    Reset();
    StopFiring();
    StopFire();
    ZoomReleased();
    StopAltFire();
    StopAltFireLH();
    // End:0x67
    if(TurokPawnHuman(Pawn) != none)
    {
        TurokPawnHuman(Pawn).ActivateWeapons(false);
    }
    // End:0x7B
    if(bGameOver)
    {
        mWinningReason = R;
    }
    // End:0xC5
    if(IsInState('ContextActionAnimation') || IsInState('PerformingContextAction'))
    {
        // End:0xC5
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).LocalAnimInterruptToLoco();
        }
    }
    SetViewTarget(EndFocus);
    // End:0x136
    if(TurokMPViewpoint(EndFocus) != none)
    {
        TurokMPViewpoint(EndFocus).NotifyActivation(self);
        SetLocation(EndFocus.Location);
        SetRotation(EndFocus.Rotation);
        SimulatedSetTurokCamera('MPViewpoint');        
    }
    else
    {
        SimulatedSetTurokCamera('Spectator');
    }
    mWinReasonRoundOver = R;
    mWinTeamIDRoundOver = tid;
    SetWinPlayerRoundOver(Uid);
    // End:0x18A
    if(!bGameOver)
    {
        GotoState('ShowWinLossTextBetweenRounds');        
    }
    else
    {
        GotoState('ShowWinLossText');
    }
    //return;    
}

reliable client simulated function ClientRoundOver(bool bGameOver, byte R, @NULL EndFocus, @NULL winningPlayer, byte WinningTeam)
{
    SimulatedRoundOver(bGameOver, R, EndFocus, winningPlayer, WinningTeam);
    //return;    
}

function RoundOver(bool bGameOver, @NULL EndFocus, @NULL winningPlayer, byte WinningTeam)
{
    local byte R;

    R = TurokMPGameReplicationInfo(WorldInfo.GRI).GetWinningReason();
    // End:0x5A
    if(!IsLocalPlayerController())
    {
        ClientRoundOver(bGameOver, R, EndFocus, winningPlayer, WinningTeam);
    }
    UpdateMultiplayerStats();
    // End:0x79
    if(!bGameOver)
    {
        RecordEndRoundStats();
    }
    // End:0xA6
    if(mSRI != none)
    {
        mSRI.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    }
    PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    SimulatedRoundOver(bGameOver, R, EndFocus, winningPlayer, WinningTeam);
    //return;    
}

function WinLossTimer()
{
    //return;    
}

function bool ValidSession()
{
    local @NULL Lobby;

    Lobby = Class'Engine.Engine'.static.GetTurokNet().GetLobby();
    // End:0x67
    if(((Lobby == none) || (Lobby != none) && int(Lobby.GetGameState()) == int(2)) && TurokMultiplayerHud(myHUD) != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ShowWinLossText_WaitForTheGRI()
{
    local @NULL GRI;

    // End:0xCC
    if(WorldInfo.GRI != none)
    {
        ClearTimer('ShowWinLossText_WaitForTheGRI');
        GRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
        GRI.SetWinningPlayer(GetWinPlayerRoundOver());
        GRI.SetWinningReason(mWinReasonRoundOver);
        GRI.SetWinningTeam(mWinTeamIDRoundOver);
        // End:0xB0
        if(ValidSession())
        {
            TurokMultiplayerHud(myHUD).DrawWinLossInfo(true);
        }
        SetTimer(Class'TurokMPGame'.default.GameEndTimeout, false, 'ShowWinLossText_GotoRoundEnded');
    }
    //return;    
}

function ShowWinLossText_GotoRoundEnded()
{
    GotoState('RoundEnded');
    //return;    
}

function @NULL RLerpShortest(@NULL A, @NULL B, float Weight)
{
    local @NULL Delta;

    Delta = Normalize(B - A);
    return Normalize(A + (Delta * Weight));
    //return ReturnValue;    
}

exec function DebugWeapon()
{
    local @NULL Inventory, tPawn;

    TurokPawnHuman(Pawn).mWeaponMediator.DebugWeapon();
    tPawn = TurokPawn(Pawn);
    // End:0x3E
    if(tPawn == none)
    {
        return;
    }
    tPawn.ClientMessage("mWeaponAttachmentRightHand" @ string(TurokPawnHuman(Pawn).mWeaponAttachmentRightHand));
    tPawn.ClientMessage("mWeaponAttachmentLeftHand" @ string(TurokPawnHuman(Pawn).mWeaponAttachmentLeftHand));
    Inventory = TurokInventoryManager(tPawn.InvManager);
    // End:0x105
    if(Inventory != none)
    {
        Inventory.DebugWeapon();        
    }
    else
    {
        tPawn.ClientMessage("NO INV MGR");
    }
    //return;    
}

exec function DebugSetHealth(int Health)
{
    Pawn.Health = Health;
    //return;    
}

function OnShowChapterpoint(@NULL Action)
{
    local @NULL TurokHud;

    TurokHud = TurokHud(myHUD);
    // End:0x3C
    if(TurokHud != none)
    {
        TurokHud.ShowChapterMarker(Action.mChapterIndex);
    }
    //return;    
}

function AddCheats()
{
    // End:0x21
    if(Class'TurokUtil'.static.IsMultiplayerGame() && !AllowCheatsInMP)
    {
        return;
    }
    // End:0x3C
    if(CheatManager == none)
    {
        CheatManager = new (self) CheatClass;
    }
    //return;    
}

exec function SwitchCharacter(int CharacterIndex)
{
    ServerSwitchCharacter(CharacterIndex);
    //return;    
}

reliable server function ServerSwitchCharacter(int CharacterIndex)
{
    PlayerReplicationInfo.CharacterIndex = byte(CharacterIndex);
    ServerSuicide();
    //return;    
}

reliable client simulated event ClientMessage(coerce string S, optional name Type, optional float MsgLifeTime)
{
    // End:0x20
    if(mbShowClientMessages)
    {
        super.ClientMessage(S, Type, MsgLifeTime);
    }
    //return;    
}

exec function ShowClientMessages()
{
    mbShowClientMessages = !mbShowClientMessages;
    // End:0x3D
    if(mbShowClientMessages)
    {
        ClientMessage("Client messages enabled.");        
    }
    else
    {
        ClientMessage("Client messages disabled.");
    }
    //return;    
}

exec function ToggleImpactFXForEnemies()
{
    Class'TurokWeaponAttachment'.static.ToggleImpactFXForEnemies();
    //return;    
}

exec function ToggleImpactFXSoundOptimization()
{
    Class'TurokWeaponAttachment'.static.ToggleImpactFXSoundOptimization();
    //return;    
}

exec function ToggleImpactFXOptimization()
{
    Class'TurokWeaponAttachment'.static.ToggleImpactFXOptimization();
    //return;    
}

exec function SetMaxNumImpactEffects(int numFX)
{
    Class'TurokWeaponAttachment'.static.SetMaxNumImpactEffects(numFX);
    //return;    
}

event NotifyDirectorControl(bool bNowControlling)
{
    super.NotifyDirectorControl(bNowControlling);
    TurokPawnPlayer(Pawn).SetPOVMeshVisibility(bNowControlling);
    //return;    
}

exec function StartSay()
{
    // End:0x4D
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        // End:0x4D
        if(Player != none)
        {
            LocalPlayer(Player).ViewportClient.ViewportConsole.StartTyping("Say ");
        }
    }
    //return;    
}

exec function StartTeamSay()
{
    // End:0x51
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        // End:0x51
        if(Player != none)
        {
            LocalPlayer(Player).ViewportClient.ViewportConsole.StartTyping("TeamSay ");
        }
    }
    //return;    
}

state TurokBaseSpectating
{
    function bool IsSpectating()
    {
        return true;
        //return ReturnValue;        
    }

    reliable client simulated event ClientSetViewTarget(@NULL A, optional float TransitionTime)
    {
        SetViewTarget(A, TransitionTime);
        SimulatedSetTurokCamera('Spectator');
        // End:0x3F
        if(A == none)
        {
            ServerVerifyViewTarget();
            return;
        }
        SetRotation(A.Rotation);
        // End:0x78
        if(TurokTeamGameHud(myHUD) != none)
        {
            TurokTeamGameHud(myHUD).NotifyViewTargetChanged();
        }
        //return;        
    }

    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        local float MaxVelocity, VelSize;

        MaxVelocity = Class'TurokPawnPlayer'.default.GroundSpeed;
        Acceleration = Normal(newAccel) * MaxVelocity;
        VelSize = VSize(Velocity);
        // End:0x78
        if(VelSize > float(0))
        {
            Velocity = Velocity - ((Velocity - (Normal(Acceleration) * VelSize)) * FMin(DeltaTime * float(8), 1.0000000));
        }
        Velocity = Velocity + (Acceleration * DeltaTime);
        // End:0xB6
        if(VSize(Velocity) > MaxVelocity)
        {
            Velocity = Normal(Velocity) * MaxVelocity;
        }
        // End:0xD4
        if(VSize(Velocity) > float(0))
        {
            MoveSmooth(Velocity * DeltaTime);
        }
        DoubleClickMove = 0;
        bPressedJump = false;
        bDuck = 0;
        bRun = 0;
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        local @NULL X, Y, Z;

        GetAxes(Rotation, X, Y, Z);
        Acceleration = ((PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y)) + (PlayerInput.aUp * vect(0.0000000, 0.0000000, 1.0000000));
        UpdateRotation(DeltaTime);
        ProcessMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
        NetLocalMove(DeltaTime);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SetNetMoveMode(2);
        // End:0x1F
        if(int(Role) == int(ROLE_Authority))
        {
            mSpectatedPlayerId = 0;
        }
        // End:0x34
        if(Pawn != none)
        {
            UnPossess();
        }
        bCollideWorld = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        bCollideWorld = false;
        // End:0x1F
        if(int(Role) == int(ROLE_Authority))
        {
            mSpectatedPlayerId = 0;
        }
        SetNetMoveMode(0);
        //return;        
    }
    stop;    
}

state TurokSpectating extends TurokBaseSpectating
{
    ignores StartFire, StopFire, StartAltFire, StopAltFire, PrevWeapon, NextWeapon, 
	    ReloadWeapon, ThrowWeapon, StartAction, StopAction, ZoomPressed, 
	    ZoomReleased, Suicide, ServerDrive, ProcessDrive, RestartLevel, 
	    ClientRestart;

    exec function SpectateNext()
    {
        TurokServerViewPlayer(1);
        //return;        
    }

    exec function SpectatePrev()
    {
        TurokServerViewPlayer(-1);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x27
        if(PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.bIsSpectator = true;
        }
        WorldInfo.Game.NumSpectators++;
        TurokServerViewPlayer(0);
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x1C
        if(PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.bIsSpectator = false;
        }
        WorldInfo.Game.NumSpectators--;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

auto state PlayerWaiting
{
    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        local float MaxVelocity, VelSize;

        MaxVelocity = Class'TurokPawnPlayer'.default.GroundSpeed;
        Acceleration = Normal(newAccel) * MaxVelocity;
        VelSize = VSize(Velocity);
        // End:0x78
        if(VelSize > float(0))
        {
            Velocity = Velocity - ((Velocity - (Normal(Acceleration) * VelSize)) * FMin(DeltaTime * float(8), 1.0000000));
        }
        Velocity = Velocity + (Acceleration * DeltaTime);
        // End:0xB6
        if(VSize(Velocity) > MaxVelocity)
        {
            Velocity = Normal(Velocity) * MaxVelocity;
        }
        // End:0xD4
        if(VSize(Velocity) > float(0))
        {
            MoveSmooth(Velocity * DeltaTime);
        }
        DoubleClickMove = 0;
        bPressedJump = false;
        bDuck = 0;
        bRun = 0;
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        local @NULL X, Y, Z;

        GetAxes(Rotation, X, Y, Z);
        Acceleration = ((PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y)) + (PlayerInput.aUp * vect(0.0000000, 0.0000000, 1.0000000));
        UpdateRotation(DeltaTime);
        ProcessMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
        NetLocalMove(DeltaTime);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SetNetMoveMode(2);
        Acceleration.X = 0.0000000;
        Acceleration.Y = 0.0000000;
        Acceleration.Z = 0.0000000;
        Velocity.X = 0.0000000;
        Velocity.Y = 0.0000000;
        Velocity.Z = 0.0000000;
        //return;        
    }

    function EndState(name NextStateName)
    {
        IgnoreMoveInput(false);
        IgnoreLookInput(false);
        SetNetMoveMode(0);
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state CannedAnimation
{
    function BeginState(name PreviousState)
    {
        // End:0x1C
        if(Pawn != none)
        {
            Pawn.bCanPickupInventory = false;
        }
        SetNetMoveMode(2);
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        // End:0x60
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).mbEnableImpactAnims = false;
        }
        StopFiring();
        StopFire();
        ZoomReleased();
        StopAltFire();
        StopAltFireLH();
        //return;        
    }

    function EndState(name NextState)
    {
        IgnoreMoveInput(false);
        IgnoreLookInput(false);
        SetNetMoveMode(0);
        // End:0x54
        if((Pawn != none) && Pawn.IsInState('CannedAnimation'))
        {
            Pawn.PopState();
        }
        // End:0x7A
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).mbEnableImpactAnims = true;
        }
        // End:0x96
        if(Pawn != none)
        {
            Pawn.bCanPickupInventory = true;
        }
        //return;        
    }

    simulated function bool AllowSkeletalHurtImpulse()
    {
        return false;
        //return ReturnValue;        
    }

    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        super(PlayerController).ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        DoubleClickMove = 0;
        bPressedJump = false;
        bDuck = 0;
        bRun = 0;
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        NetLocalMove(DeltaTime);
        //return;        
    }

    event bool IsStateValidPostCinema()
    {
        return false;
        //return ReturnValue;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        EnterStartState();
        //return;        
    }

    simulated function bool CanPickupFlagBeSet()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state VehicleCannedAnimation extends CannedAnimation
{    stop;    
}

state StealthKillAnimation extends CannedAnimation
{
    function EndState(name NextState)
    {
        super.EndState(NextState);
        // End:0x31
        if(TurokPawnPlayer(Pawn) != none)
        {
            TurokPawnPlayer(Pawn).mbIsStealthKilling = false;
        }
        //return;        
    }
    stop;    
}

state PerformingContextAction
{
    function BeginState(name PreviousState)
    {
        // End:0x2F
        if(int(Role) == int(ROLE_Authority))
        {
            // DebugMode: 0
            assert(mActiveContextAction != none);
            mActiveContextAction.BeginAction();
        }
        //return;        
    }

    function EndState(name NextState)
    {
        // End:0x15
        if(NextState == 'ContextActionAnimation')
        {
            return;
        }
        // End:0x31
        if(int(Role) == int(ROLE_Authority))
        {
            // DebugMode: 0
            assert(mActiveContextAction != none);
        }
        // End:0x6A
        if((mActiveContextAction != none) && mActiveContextAction.IsInProgress())
        {
            mActiveContextAction.EndPrematurely();            
        }
        DestroyActiveContextAction();
        mActionPressed = false;
        //return;        
    }

    function EndUseAction()
    {
        EndUseActiveContextAction();
        //return;        
    }

    function NotifyGraphStart(@NULL graph, byte actorType)
    {
        GotoState('ContextActionAnimation');
        mActiveContextAction.NotifyGraphStart(graph, actorType);
        //return;        
    }
    stop;    
}

state ContextActionAnimation extends CannedAnimation
{
    simulated function bool AllowSkeletalHurtImpulse()
    {
        return false;
        //return ReturnValue;        
    }

    function bool PerformedUseAction()
    {
        mActionPressed = true;
        mActiveContextAction.BeginAction();
        return true;
        //return ReturnValue;        
    }

    function EndUseAction()
    {
        mActiveContextAction.StopAction(false);
        //return;        
    }

    function BeginState(name PreviousState)
    {
        super.BeginState(PreviousState);
        // DebugMode: 0
        assert(mActiveContextAction != none);
        //return;        
    }

    function EndState(name NextState)
    {
        super.EndState(NextState);
        // End:0x4C
        if(mActiveContextAction != none)
        {
            // End:0x42
            if(mActiveContextAction.IsInProgress())
            {
                mActiveContextAction.EndPrematurely();                
            }
            DestroyActiveContextAction();
        }
        mActionPressed = false;
        //return;        
    }

    function NotifyGraphStart(@NULL graph, byte actorType)
    {
        mActiveContextAction.NotifyGraphStart(graph, actorType);
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        mActiveContextAction.NotifyGraphEndToLoco(graph, locoAsset, actorType);
        EndUseActiveContextAction();
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        mActiveContextAction.NotifyGraphEndToGraph(prevGraph, newGraph, actorType);
        //return;        
    }

    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        mActiveContextAction.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        super(TurokPlayerController).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        //return;        
    }
    stop;    
}

state NetGameEnded
{
    function bool GamePlayEndedState()
    {
        return true;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        local @NULL P, MyPlayer, TGRI, TPRI;

        super(Object).BeginState(PreviousStateName);
        UnPossess();
        // End:0x46
        foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
        {
            P.SetHidden(true);            
        }        
        SimulatedClearActiveState();
        SetNetMoveMode(2);
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        // End:0x204
        if(IsLocalPlayerController())
        {
            MyPlayer = LocalPlayer(Player);
            // End:0xBD
            if(MyPlayer.ViewportClient != none)
            {
                MyPlayer.ViewportClient.SetPauseMenuEnabledEvent(false);
            }
            // End:0xFD
            if(TurokHud(myHUD) != none)
            {
                TurokHud(myHUD).SetShowScoreboards(false);
                TurokHud(myHUD).bThirdPersonHud = true;
            }
            TPRI = TurokMPPlayerReplicationInfo(PlayerReplicationInfo);
            TGRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
            // End:0x204
            if(((TPRI != none) && TGRI != none) && int(TGRI.GetWinningReason()) == int(0))
            {
                TGRI.ForceStatsRecalc();
                TGRI.SetWinningReason(2);
                // End:0x1CC
                if(TurokTeamInfo(TPRI.Team) != none)
                {
                    TGRI.SetWinningTeam(TPRI.Team.TeamIndex);                    
                }
                else
                {
                    TGRI.SetWinningTeam(byte(255));
                }
                TGRI.SetWinningPlayer(TPRI.UniqueId);
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x50
        if(IsLocalPlayerController())
        {
            // End:0x50
            if((TurokHud(myHUD) != none) && TurokHud(myHUD).mDeathDOFAndBloomEffect != none)
            {
                TurokHud(myHUD).RestoreColorCube();
            }
        }
        super(Object).EndState(NextStateName);
        //return;        
    }

    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        super(PlayerController).ProcessMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), DoubleClickMove, rot(0, 0, 0));
        DoubleClickMove = 0;
        bPressedJump = false;
        bDuck = 0;
        bRun = 0;
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        NetLocalMove(DeltaTime);
        //return;        
    }
    stop;    
}

simulated state ShowWinLossTextBetweenRounds
{
    function BeginState(name PreviousStateName)
    {
        local @NULL MyPlayer;

        super(Object).BeginState(PreviousStateName);
        SimulatedClearActiveState();
        SetNetMoveMode(2);
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        // End:0x5C
        if(TurokMultiplayerHud(myHUD) != none)
        {
            TurokMultiplayerHud(myHUD).SetEndOfRound(true);
        }
        // End:0xAA
        if(IsLocalPlayerController())
        {
            MyPlayer = LocalPlayer(Player);
            // End:0xAA
            if(MyPlayer.ViewportClient != none)
            {
                MyPlayer.ViewportClient.SetPauseMenuEnabledEvent(true);
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        local @NULL MyPlayer;

        // End:0x4E
        if(IsLocalPlayerController())
        {
            MyPlayer = LocalPlayer(Player);
            // End:0x4E
            if(MyPlayer.ViewportClient != none)
            {
                MyPlayer.ViewportClient.SetPauseMenuEnabledEvent(true);
            }
        }
        WinLossTimer();
        super(Object).EndState(NextStateName);
        //return;        
    }

    function WinLossTimer()
    {
        // End:0x42
        if(TurokMultiplayerHud(myHUD) != none)
        {
            TurokMultiplayerHud(myHUD).HideWinLossInfo(true);
            TurokMultiplayerHud(myHUD).SetEndOfRound(false);
        }
        //return;        
    }

    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        super(PlayerController).ProcessMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), DoubleClickMove, rot(0, 0, 0));
        DoubleClickMove = 0;
        bPressedJump = false;
        bDuck = 0;
        bRun = 0;
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        NetLocalMove(DeltaTime);
        //return;        
    }
    J0x00:
    // End:0x3A [Loop If]
    if(WorldInfo.GRI == none)
    {
        // DebugMode: 0
        assert(int(Role) != int(ROLE_Authority));
        Sleep(0.1000000);
        goto 'Begin';
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x108
    if(IsLocalPlayerController())
    {
        // DebugMode: 0
        assert(WorldInfo.GRI.IsA('TurokMPGameReplicationInfo'));
        TurokMPGameReplicationInfo(WorldInfo.GRI).SetWinningPlayer(GetWinPlayerRoundOver());
        TurokMPGameReplicationInfo(WorldInfo.GRI).SetWinningReason(mWinReasonRoundOver);
        TurokMPGameReplicationInfo(WorldInfo.GRI).SetWinningTeam(mWinTeamIDRoundOver);
        // End:0x108
        if(TurokMultiplayerHud(myHUD) != none)
        {
            TurokMultiplayerHud(myHUD).DrawWinLossInfo(false);
        }
    }
    stop;                
}

simulated state ShowWinLossText
{
    function BeginState(name PreviousStateName)
    {
        local @NULL MyPlayer;

        super(Object).BeginState(PreviousStateName);
        SimulatedClearActiveState();
        SetNetMoveMode(2);
        IgnoreMoveInput(true);
        IgnoreLookInput(false);
        // End:0x6A
        if(ValidSession())
        {
            myHUD.SetEndOfGame(true);
            TurokMultiplayerHud(myHUD).bThirdPersonHud = true;
        }
        // End:0xCB
        if(IsLocalPlayerController())
        {
            MyPlayer = LocalPlayer(Player);
            // End:0xB8
            if(MyPlayer.ViewportClient != none)
            {
                MyPlayer.ViewportClient.SetPauseMenuEnabledEvent(false);
            }
            SetTimer(0.1000000, true, 'ShowWinLossText_WaitForTheGRI');
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x3F
        if(TurokMultiplayerHud(myHUD) != none)
        {
            TurokMultiplayerHud(myHUD).HideWinLossInfo();
            TurokMultiplayerHud(myHUD).bThirdPersonHud = false;
        }
        super(Object).EndState(NextStateName);
        //return;        
    }

    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        super(PlayerController).ProcessMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), DoubleClickMove, rot(0, 0, 0));
        DoubleClickMove = 0;
        bPressedJump = false;
        bDuck = 0;
        bRun = 0;
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        NetLocalMove(DeltaTime);
        //return;        
    }
    stop;    
}

state RoundEnded
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SimulatedClearActiveState();
        SetNetMoveMode(2);
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        // End:0x74
        if(IsLocalPlayerController())
        {
            // End:0x6A
            if(TurokHud(myHUD) != none)
            {
                TurokHud(myHUD).SetShowScoreboards(true, false);
            }
            CheckEndOfRoundAchievements();
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        local @NULL MyPlayer;

        // End:0x90
        if(IsLocalPlayerController())
        {
            MyPlayer = LocalPlayer(Player);
            // End:0x4E
            if(MyPlayer.ViewportClient != none)
            {
                MyPlayer.ViewportClient.SetPauseMenuEnabledEvent(true);
            }
            // End:0x90
            if(TurokHud(myHUD) != none)
            {
                TurokHud(myHUD).SetShowScoreboards(false);
                TurokHud(myHUD).RestoreColorCube();
            }
        }
        IgnoreMoveInput(false);
        IgnoreLookInput(false);
        SetNetMoveMode(0);
        super.EndState(NextStateName);
        //return;        
    }

    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        super(PlayerController).ProcessMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), DoubleClickMove, rot(0, 0, 0));
        DoubleClickMove = 0;
        bPressedJump = false;
        bDuck = 0;
        bRun = 0;
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        NetLocalMove(DeltaTime);
        //return;        
    }
    stop;    
}

state PlayerClimbing
{
    function BeginState(name PreviousStateName)
    {
        local @NULL TurokLadderVolume, tph;

        TurokLadderVolume = TurokLadderVolume(Pawn.OnLadder);
        // DebugMode: 0
        assert(TurokLadderVolume != none);
        tph = TurokPawnHuman(Pawn);
        ZoomReleased();
        mZoomer.ForceExitZoom();
        tph.SetWeaponsVisibleIn3rdPerson(false);
        // End:0xC5
        if((tph.GetPrimaryWeapon() != none) && TurokWeapSniperRifleNative(tph.GetPrimaryWeapon()) != none)
        {
            TurokWeapSniperRifleNative(tph.GetPrimaryWeapon()).SnapOutOfZoom();
        }
        SimulatedSetTurokCamera('ThirdPerson');
        SetNetMoveMode(1);
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        local @NULL TP, tph;

        TP = TurokPawn(Pawn);
        // End:0x73
        if(TP != none)
        {
            tph = TurokPawnHuman(Pawn);
            tph.SetWeaponsVisibleIn3rdPerson(true);
            // End:0x73
            if(TurokPlayerCamera(PlayerCamera).CameraStyle == 'ThirdPerson')
            {
                SimulatedSetTurokCamera('FirstPerson');
            }
        }
        SetNetMoveMode(0);
        super.EndState(NextStateName);
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        local @NULL X, Y, Z, newAccel, TP, NewRotation;

        GetAxes(Rotation, X, Y, Z);
        TP = TurokPawn(Pawn);
        // End:0x41
        if(TP == none)
        {
            GotoState('Dead');
            return;
        }
        newAccel = PlayerInput.aForward * TP.OnLadder.ClimbDir;
        NewRotation = TP.OnLadder.WallDir;
        SetRotation(NewRotation);
        // End:0xB7
        if(VSize(newAccel) < 1.0000000)
        {
            newAccel = vect(0.0000000, 0.0000000, 0.0000000);
        }
        UpdateRotation(DeltaTime);
        // End:0xEB
        if(int(Role) < int(ROLE_Authority))
        {
            NetMiniGameMove(DeltaTime, newAccel, 0);            
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, 0, rot(0, 0, 0));
        }
        bDoubleJump = false;
        bPressedJump = false;
        bDuck = 0;
        //return;        
    }

    event bool IsStateValidPostCinema()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state PlayerDriving
{
    ignores StartFire, StopFire, StartAltFire, StopAltFire, PrevWeapon, NextWeapon, 
	    ReloadWeapon, ThrowWeapon, ZoomPressed, ZoomReleased, Suicide;

    event PlayerMove(float DeltaTime)
    {
        local float Throttle, reverse;

        UpdateRotation(DeltaTime);
        Throttle = TurokPlayerInput(PlayerInput).mAnalogInputData.rightShoulderButton;
        reverse = -TurokPlayerInput(PlayerInput).mAnalogInputData.leftShoulderButton;
        // End:0x83
        if(PlayerInput.RawJoyUp > Throttle)
        {
            Throttle = PlayerInput.RawJoyUp;
        }
        // End:0xAF
        if(PlayerInput.RawJoyUp < reverse)
        {
            reverse = PlayerInput.RawJoyUp;
        }
        Throttle += reverse;
        ProcessDrive(Throttle, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump);
        // End:0x15F
        if(int(Role) < int(ROLE_Authority))
        {
            ServerDrive(Throttle, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
        }
        bPressedJump = false;
        //return;        
    }
    stop;    
}

state HumanKnockdown extends CannedAnimation
{    stop;    
}

state DefenderMaulAnimation extends CannedAnimation
{
    function BeginState(name prevState)
    {
        local @NULL tPawn, Controller;

        super.BeginState(prevState);
        mLastInputDirection = 2;
        tPawn = TurokPawn(Pawn);
        // End:0x60
        if((tPawn != none) && tPawn.mCurrentGrassField != none)
        {
            tPawn.mCurrentGrassField.EnableOcclusionPrevention();
        }
        // End:0xAD
        foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
        {
            Controller.NotifyTeammateHit(self, TurokPawnHuman(Pawn).mMaulWatcher.mAttackerController);            
        }        
        //return;        
    }

    function EndState(name NextState)
    {
        local @NULL tPawn;

        super.EndState(NextState);
        tPawn = TurokPawn(Pawn);
        // End:0x58
        if((tPawn != none) && tPawn.mCurrentGrassField != none)
        {
            tPawn.mCurrentGrassField.DisableOcclusionPrevention();
        }
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        local @NULL tph;
        local byte maulInput;
        local float strafeAmt, DEAD_ZONE_PCT;

        DEAD_ZONE_PCT = 0.5000000;
        tph = TurokPawnHuman(Pawn);
        // End:0x111
        if((tph != none) && tph.mMaulWatcher != none)
        {
            maulInput = tph.mMaulWatcher.GetRequiredMaulInput();
            // End:0x111
            if(int(maulInput) == int(3))
            {
                strafeAmt = PlayerInput.RawJoyRight;
                // End:0xCC
                if((strafeAmt < -DEAD_ZONE_PCT) && int(mLastInputDirection) != int(0))
                {
                    tph.mMaulWatcher.IncreaseDesiredScrubPercent();
                    mLastInputDirection = 0;                    
                }
                else
                {
                    // End:0x111
                    if((strafeAmt > DEAD_ZONE_PCT) && int(mLastInputDirection) != int(1))
                    {
                        tph.mMaulWatcher.IncreaseDesiredScrubPercent();
                        mLastInputDirection = 1;
                    }
                }
            }
        }
        super.PlayerMove(DeltaTime);
        //return;        
    }

    exec function MaulingRightTrigger()
    {
        local @NULL tph;
        local byte maulInput;

        tph = TurokPawnHuman(Pawn);
        // End:0xAB
        if((tph != none) && tph.mMaulWatcher != none)
        {
            maulInput = tph.mMaulWatcher.GetRequiredMaulInput();
            // End:0xA3
            if(((int(maulInput) == int(2)) && int(mLastInputDirection) != int(1)) || int(maulInput) == int(1))
            {
                tph.mMaulWatcher.IncreaseDesiredScrubPercent();
            }
            mLastInputDirection = 1;
        }
        //return;        
    }

    exec function MaulingLeftTrigger()
    {
        local @NULL tph;
        local byte maulInput;

        tph = TurokPawnHuman(Pawn);
        // End:0xAB
        if((tph != none) && tph.mMaulWatcher != none)
        {
            maulInput = tph.mMaulWatcher.GetRequiredMaulInput();
            // End:0xA3
            if(((int(maulInput) == int(2)) && int(mLastInputDirection) != int(0)) || int(maulInput) == int(0))
            {
                tph.mMaulWatcher.IncreaseDesiredScrubPercent();
            }
            mLastInputDirection = 0;
        }
        //return;        
    }
    stop;    
}

state PlayerWalking
{
    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        // End:0x0D
        if(Pawn == none)
        {
            return;
        }
        // End:0x47
        if((PlayerInput == none) || !TurokPlayerInput(PlayerInput).mbLockPlayer)
        {
            Pawn.Acceleration = newAccel;
        }
        CheckJumpOrDuck();
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        super.PlayerMove(DeltaTime);
        // End:0x22
        if(FindClimbableLadder() != none)
        {
            mbDrawLadderHud = true;            
        }
        else
        {
            mbDrawLadderHud = false;
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local bool bShouldCrouch;

        bShouldCrouch = Pawn.bWantsToCrouch;
        super.BeginState(PreviousStateName);
        // End:0x5E
        if(PreviousStateName == 'HumanKnockdown')
        {
            Pawn.ShouldCrouch(bShouldCrouch);
            // End:0x5E
            if(bShouldCrouch)
            {
                bDuck = 1;
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        mbDrawLadderHud = false;
        mPickupMiniGunSentry = none;
        super.EndState(NextStateName);
        //return;        
    }

    function bool PerformDive()
    {
        local float StartRelAngle;
        local @NULL heading2D, accel2D, normAccel2D, deltaRotation;
        local float diveAngle;

        // End:0x0D
        if(mContextAction != none)
        {
            return false;
        }
        // End:0x28
        if(int(Pawn.Physics) != int(1))
        {
            return false;
        }
        // End:0x3A
        if(TurokPawnPlayer(Pawn) == none)
        {
            return false;
        }
        accel2D = Pawn.Acceleration;
        accel2D.Z = 0.0000000;
        // End:0x84
        if(VSize(accel2D) <= TurokPawnPlayer(Pawn).mMinDiveSpeed)
        {
            return false;
        }
        heading2D = Vector(Pawn.Rotation);
        heading2D.Z = 0.0000000;
        normAccel2D = Normal(accel2D);
        heading2D = Normal(heading2D);
        diveAngle = Acos(FClamp(heading2D Dot normAccel2D, -1.0000000, 1.0000000)) * 57.2957800;
        // End:0x132
        if((diveAngle < TurokPawnPlayer(Pawn).mMinDiveAngle) || diveAngle > TurokPawnPlayer(Pawn).mMaxDiveAngle)
        {
            return false;
        }
        // End:0x144
        if(int(Role) != int(ROLE_Authority))
        {
            return true;
        }
        deltaRotation = Rotator(accel2D) - Pawn.Rotation;
        deltaRotation = Normalize(deltaRotation);
        StartRelAngle = float(deltaRotation.Yaw) * (360.0000000 / 65535.0000000);
        TurokPawnHuman(Pawn).Dive(StartRelAngle);
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state PlayerRiding
{
    ignores ThrowWeapon, ProcessMove, PoppedState;

    event PlayerMove(float DeltaTime)
    {
        UpdateRotation(DeltaTime);
        // End:0x87
        if(int(Role) < int(ROLE_Authority))
        {
            // End:0x3E
            if(Pawn != none)
            {
                Pawn.AutonomousPhysics(DeltaTime);                
            }
            else
            {
                AutonomousPhysics(DeltaTime);
            }
            ServerRide(DeltaTime, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
        }
        bDuck = 0;
        bRun = 0;
        bPressedJump = false;
        //return;        
    }

    function PushedState()
    {
        Pawn.SetPhysics(0);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        ClearNetMoveVariables();
        PushedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearNetMoveVariables();
        PoppedState();
        //return;        
    }
    stop;    
}

state PlayerImpulse
{
    function EndState(name NextStateName)
    {
        ClearTimer('ExitState');
        //return;        
    }

    function ExitState(float DeltaTime)
    {
        GotoState('PlayerWalking');
        //return;        
    }

    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        Pawn.Acceleration = mImpulseVector;
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        local @NULL X, Y, Z, newAccel, OldRotation;

        // End:0x1C
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            GetAxes(Rotation, X, Y, Z);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            // End:0x82
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(DeltaTime, newAccel, 0, OldRotation - Rotation);                
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
            }
        }
        //return;        
    }

    event bool IsStateValidPostCinema()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    SetTimer(mImpulseTime, false, 'ExitState');
    stop;                    
}

state ConstrainPlayerState extends PlayerWalking
{
    event PlayerMove(float DeltaTime)
    {
        local float timeRatio, interpWeight;

        bPressedJump = false;
        // End:0x29
        if(mPlayerConstraints.mbAllowMovement == true)
        {
            super.PlayerMove(DeltaTime);
        }
        // End:0x56
        if(mPlayerConstraints.mLookAtActor == none)
        {
            mPlayerConstraints.mTargetLookAt = Rotation;            
        }
        else
        {
            mPlayerConstraints.mTargetLookAt = Rotator(mPlayerConstraints.mLookAtActor.Location - Pawn.Location);
        }
        mPlayerConstraints.mCurrentTime += DeltaTime;
        // End:0xD4
        if(mPlayerConstraints.mLookAtTime == 0.0000000)
        {
            SetRotation(mPlayerConstraints.mTargetLookAt);            
        }
        else
        {
            // End:0x184
            if(mPlayerConstraints.mCurrentTime < mPlayerConstraints.mLookAtTime)
            {
                timeRatio = FClamp(mPlayerConstraints.mCurrentTime / mPlayerConstraints.mLookAtTime, 0.0000000, 1.0000000);
                interpWeight = mPlayerConstraints.mLookAtSpline.Evaluate(timeRatio);
                SetRotation(RLerpShortest(mPlayerConstraints.mInitialLookAt, mPlayerConstraints.mTargetLookAt, interpWeight));                
            }
            else
            {
                UpdateRotation(DeltaTime);
            }
        }
        //return;        
    }

    function @NULL LimitViewRotation(@NULL ViewRotation, float ViewPitchMin, float ViewPitchMax)
    {
        local @NULL deltaRotation;

        deltaRotation = ViewRotation - mPlayerConstraints.mTargetLookAt;
        deltaRotation.Yaw = NormalizeRotAxis(deltaRotation.Yaw);
        deltaRotation.Pitch = NormalizeRotAxis(deltaRotation.Pitch);
        deltaRotation.Yaw = Clamp(deltaRotation.Yaw, -mPlayerConstraints.mLookAtConstraints.Yaw, mPlayerConstraints.mLookAtConstraints.Yaw);
        deltaRotation.Pitch = Clamp(deltaRotation.Pitch, -mPlayerConstraints.mLookAtConstraints.Pitch, mPlayerConstraints.mLookAtConstraints.Pitch);
        ViewRotation = mPlayerConstraints.mTargetLookAt + deltaRotation;
        ViewRotation.Yaw = NormalizeRotAxis(ViewRotation.Yaw);
        ViewRotation.Pitch = NormalizeRotAxis(ViewRotation.Pitch);
        return super(TurokPlayerController).LimitViewRotation(ViewRotation, ViewPitchMin, ViewPitchMax);
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        PushedState();
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        PoppedState();
        super.EndState(NextStateName);
        //return;        
    }

    function PushedState()
    {
        TurokPawnPlayer(Pawn).ActivateWeapons(false);
        //return;        
    }

    function PoppedState()
    {
        TurokPawnPlayer(Pawn).ActivateWeapons(true);
        //return;        
    }
Begin:

    // End:0x2E
    if(mPlayerConstraints.mPositionActor != none)
    {
        MoveToward(mPlayerConstraints.mPositionActor);        
    }
    else
    {
        // End:0x60
        if(mPlayerConstraints.mbAllowMovement == false)
        {
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
    }
    stop;                
}

state CinematicState
{
    function BeginState(name PreviousStateName)
    {
        PushedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        PoppedState();
        //return;        
    }

    function PushedState()
    {
        local @NULL TurokPawnPlayer;

        TurokPawnPlayer = TurokPawnPlayer(Pawn);
        PauseAllTimers();
        TurokPawnPlayer.mWeaponMediator.StopFiringWeapons(0);
        TurokPawnPlayer.mWeaponMediator.StopFiringWeapons(1);
        mZoomer.EnableSlideZoom(false);
        TurokPawnPlayer.Health = TurokPawnPlayer.mDefaultHealth;
        PlayerInput.PushState('CinematicState');
        Pawn.PushState('CinematicState');
        //return;        
    }

    function PoppedState()
    {
        Pawn.PopState();
        PlayerInput.PopState();
        mZoomer.EnableSlideZoom(true);
        UnpauseAllTimers();
        //return;        
    }
Begin:

    stop;                
}

simulated state Dead
{
    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x15
        if(Class'TurokUtil'.static.IsMultiplayerGame())
        {
            return;
        }
        super.StartFire(FireModeNum);
        //return;        
    }

    event ProcessMove(float DeltaTime, @NULL newAccel, byte DoubleClickMove, @NULL DeltaRot)
    {
        super(PlayerController).ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        DoubleClickMove = 0;
        bPressedJump = false;
        bDuck = 0;
        bRun = 0;
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        local @NULL X, Y, Z, DeltaRot, ViewRotation;

        // End:0x90
        if(!bFrozen)
        {
            GetAxes(Rotation, X, Y, Z);
            ViewRotation = Rotation;
            DeltaRot.Yaw = int(PlayerInput.aTurn);
            DeltaRot.Pitch = int(PlayerInput.aLookUp);
            ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
            SetRotation(ViewRotation);            
        }
        else
        {
            // End:0xB9
            if(!IsTimerActive() || GetTimerCount() > 1.0000000)
            {
                bFrozen = false;
            }
        }
        ViewShake(DeltaTime);
        NetLocalMove(DeltaTime);
        //return;        
    }

    function ScoreboardTimedActivation()
    {
        local @NULL HUD, PRI;

        PRI = TurokMPPlayerReplicationInfo(PlayerReplicationInfo);
        HUD = TurokHud(myHUD);
        // End:0x8D
        if((HUD != none) && PRI != none)
        {
            PRI.CalculateHUDRespawnTime();
            // End:0x8D
            if((WorldInfo.TimeSeconds + 0.2500000) < PRI.GetHUDRespawnTime())
            {
                HUD.SetShowScoreboards(true, false);
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SimulatedClearActiveState();
        SetNetMoveMode(2);
        ZoomReleased();
        mZoomer.ForceExitZoom();
        super.BeginState(PreviousStateName);
        // End:0x69
        if(Class'TurokUtil'.static.IsMultiplayerGame())
        {
            SetTimer(3.0000000 - 0.2500000, false, 'ScoreboardTimedActivation');            
        }
        else
        {
            // End:0x93
            if(TurokHud(myHUD) != none)
            {
                TurokHud(myHUD).SetShowScoreboards(true, false);
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        SetNetMoveMode(0);
        super.EndState(NextStateName);
        ClearTimer('ScoreboardTimedActivation');
        // End:0x4D
        if(TurokHud(myHUD) != none)
        {
            TurokHud(myHUD).SetShowScoreboards(false);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    mbShowClientMessages=true
    // Reference: TurokShooter'Default__TurokPlayerController.Shoot1'
    begin object name=Shoot1 class=Class'TurokShooter'
        ShotDirection=6
    end object
    mShooter1=Shoot1
    // Reference: TurokShooter'Default__TurokPlayerController.Shoot2'
    begin object name=Shoot2 class=Class'TurokShooter'
        ShotDirection=2
    end object
    mShooter2=Shoot2
    mPlayerConstraints=(mPositionActor=none,mLookAtActor=none,mbAllowMovement=false,mLookAtTime=0.0000000,mLookAtConstraints=(Pitch=0,Yaw=0,Roll=0),mLookAtSpline=// Reference: TurokCubicSpline'Default__TurokPlayerController.LookAtSpline'
    begin object name=LookAtSpline class=Class'TurokEngine.TurokCubicSpline'
    end object
    mLookAtSpline=LookAtSpline,mInitialLookAt=(Pitch=0,Yaw=0,Roll=0),mTargetLookAt=(Pitch=0,Yaw=0,Roll=0),mCurrentTime=0.0000000)
    // Reference: TurokHitReaction'Default__TurokPlayerController.TurokHitReactionComponent'
    begin object name=TurokHitReactionComponent class=Class'TurokHitReaction'
        mSettings=/* Array type was not detected. */
        // Reference: TurokParametricShakeComponent'Default__TurokPlayerController.TurokHitReactionComponent.ShakeComponent'
        begin object name=ShakeComponent
        end object
        mGroggyShakeSettings=ShakeComponent
    end object
    mHitReactionManager=TurokHitReactionComponent
    mHitReactionInfo=(DamageType=Class'TurokDamageType',Damage=0,HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),hitFromLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
    mHitReactionInterval=0.2500000
    mMiniGameMoveRate=0.0500000
    mAnalogSpeedModifier=1.0000000
    mMaxSpeedMod=1.0000000
    mAckedMaxSpeedMod=128
    mCompressedMaxSpeedMod=128
    mSpeedMod=1.0000000
    mAckedSpeedMod=128
    mCompressedSpeedMod=128
    mPendingDeathCam="DeathCam"
    mClimbLadderButtonImage=Texture2D'TurokControllerButtons.HUD_360_B'
    mClimbLadderButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mClimbLadderDrawFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mClimbLadderHash=1250914783
    mClimbLadderTextScale=0.3130000
    CameraClass=Class'TurokPlayerCamera'
    MaxResponseTime=0.1000000
    FOVAngle=65.0000000
    DesiredFOV=65.0000000
    DefaultFOV=65.0000000
    // Reference: TurokIrisComponent'Default__TurokPlayerController.TurokIris'
    begin object name=TurokIris
    end object
    mIris=TurokIris
    SavedMoveClass=Class'TurokSavedMove'
    CheatClass=Class'TurokCheatManager'
    InputClass=Class'TurokPlayerInput'
    // Reference: CylinderComponent'Default__TurokPlayerController.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    bNetInitialRotation=true
    // Reference: SpriteComponent'Default__TurokPlayerController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokIris
    Components[3]=TurokHitReactionComponent
    CollisionComponent=CollisionCylinder
}