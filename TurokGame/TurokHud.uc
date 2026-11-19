class TurokHud extends HUD
    transient
    native
    config(Game)
    hidecategories(Navigation);

enum eTurokHUDButtonImage
{
    TUROK_HUD_BUTTON_A,             // 0
    TUROK_HUD_BUTTON_B,             // 1
    TUROK_HUD_BUTTON_X,             // 2
    TUROK_HUD_BUTTON_Y,             // 3
    TUROK_HUD_BUTTON_LT,            // 4
    TUROK_HUD_BUTTON_LB,            // 5
    TUROK_HUD_BUTTON_RT,            // 6
    TUROK_HUD_BUTTON_RB,            // 7
    TUROK_HUD_BUTTON_L3,            // 8
    TUROK_HUD_BUTTON_MAX            // 9
};

enum ETurokHudPromptPriority
{
    ETHPP_NONE,                     // 0
    ETHPP_INVENTORY,                // 1
    ETHPP_LADDERPROMPT,             // 2
    ETHPP_TURRETPROMPT,             // 3
    ETHPP_ACTIONVOLUME,             // 4
    ETHPP_KNIFEPROMPT,              // 5
    ETHPP_NOTURRETPLACEMENT,        // 6
    ETHPP_MAX                       // 7
};

var @NULL mPawnOwner;
var @NULL mAmmoDisplay;
var @NULL mReticle;
var @NULL mScopeReticle;
var @NULL mRPGScope;
var @NULL mHitIndicator;
var @NULL mPrimal;
var @NULL mGrenade;
var @NULL mMessage;
var @NULL mInventoryIndicator;
var @NULL mDinoMelee;
var @NULL mObjectiveText;
var @NULL mHudStats;
var @NULL mDpadWeaponSelect;
var @NULL mProgressBar;
var @NULL mStealthVignette;
var @NULL mPS3Notification;
var @NULL mFullScreenVideo;
var @NULL mTutorialText;
var @NULL mKnifeKill;
var @NULL mChapterMarker;
var @NULL mCheckpoint;
var @NULL mNoPlacement;
var array mObjectiveIndicators;
var byte mCurrentWeaponReticuleType;
var @NULL RHWeapon;
var @NULL LHWeapon;
var float mFadeOutTime;
var float mCurrentFadeOutTime;
var float mFadeWaitTime;
var float mCurrentFadeWaitTime;
var float mFadeOutAmount;
var float mCurrentFadeValue;
var bool bAllowHudFade;
var bool mbRenderPrimalVitals;
var bool mbRenderDebugAmmo;
var bool mbRenderMeleeDebug;
var bool mbDisplayInGameStats;
var bool mbShowReticle;
var bool mbShowStatsScreen;
var bool mbShowScreenBlackout;
var bool mPreviousHudState;
var private bool mbActionPromptInitialized;
var private bool mbKnifePromptInitialized;
var private bool mbKnifePromptVisible;
var private bool mbColorCubeEnabled;
var bool mbDrawingRpgScope;
var @NULL mBlackoutTex;
var float mSafeZoneHalfPcnt;
var @NULL mSafeTex;
var float MPObjectiveItemAlpha;
var export editinline @NULL mSoundController;
var int mAmbientSndChannel;
var @NULL mHUDAmbientSndCue;
var @NULL BackupColorCubeTexture[2];
var float BackupColorCubeBlend[2];
var @NULL mPauseColorCubeTexture;
var name mDeathMatEffectName;
var @NULL mDeathDOFAndBloomEffect;
var private float mOriginalBlurKernelSize;
var private float mOriginalMaxNearBlurAmount;
var private float mOriginalMaxFarBlurAmount;
var private float mOriginalFocusInnerRadius;
var private float mOriginalFocusDistance;
var private float mBlurKernelSize;
var private float mMaxNearBlurAmount;
var private float mMaxFarBlurAmount;
var private float mFocusDistance;
var private float mFocusInnerRadius;
var private array mPrioritizedDrawObjects;
//var delegate<@NULL> __DrawPrioritizedObject__Delegate;

delegate DrawPrioritizedObject(@NULL HUD)
{
    //return;    
}

function DrawPrioritized()
{
    local byte highestPriority;
    local int I;

    // End:0x8A
    if(mPrioritizedDrawObjects.Length > 0)
    {
        highestPriority = mPrioritizedDrawObjects[0].Priority;
        I = 0;
        J0x29:

        // End:0x8A [Loop If]
        if(I < mPrioritizedDrawObjects.Length)
        {
            // End:0x7D
            if(int(highestPriority) == int(mPrioritizedDrawObjects[I].Priority))
            {
                mPrioritizedDrawObjects[I].DrawPrioritizedObject(self);
                // [Explicit Continue]
                goto J0x80;
            }
            // [Explicit Break]
            goto J0x8A;
            J0x80:

            ++I;
            // [Loop Continue]
            goto J0x29;
        }
    }
    J0x8A:

    //return;    
}

// Export UTurokHud::execAddObjectiveIndicator(FFrame&, void* const)
native function AddObjectiveIndicator(@NULL goalObject, string goalName);

// Export UTurokHud::execUpdateObjectiveIndicator(FFrame&, void* const)
native function UpdateObjectiveIndicator(@NULL goal_object, string goal_name);

exec function ShowHud()
{
    bShowHUD = true;
    //return;    
}

exec function HideHud()
{
    bShowHUD = false;
    //return;    
}

exec function ShowTargetReticle()
{
    ShowReticle();
    //return;    
}

exec function HideTargetReticle()
{
    HideReticle();
    //return;    
}

exec function RollEndOfGameCredits()
{
    NativeRollEndOfGameCredits();
    //return;    
}

// Export UTurokHud::execRemoveObjectiveIndicator(FFrame&, void* const)
native function RemoveObjectiveIndicator(string goal_name);

event PlayHudVideo(@NULL videoAction)
{
    mFullScreenVideo.StartVideo(videoAction);
    //return;    
}

event StopHudVideo()
{
    mFullScreenVideo.StopVideo();
    //return;    
}

event ShowChapterMarker(int chapterNum)
{
    mChapterMarker.ShowChapterMarker(chapterNum);
    //return;    
}

event ShowCheckpoint()
{
    mCheckpoint.ShowCheckpoint();
    //return;    
}

// Export UTurokHud::execDrawActions(FFrame&, void* const)
native function DrawActions();

// Export UTurokHud::execDrawKnifeKill(FFrame&, void* const)
native function DrawKnifeKill();

// Export UTurokHud::execNativeRollEndOfGameCredits(FFrame&, void* const)
native function NativeRollEndOfGameCredits();

// Export UTurokHud::execAddPrioritizedDrawCall(FFrame&, void* const)
native function AddPrioritizedDrawCall(delegate<@NULL> kDrawPriorityDelegate, @NULL kPrioritizedObject, byte kPriority);

// Export UTurokHud::execRemovePrioritizedDrawCall(FFrame&, void* const)
native function RemovePrioritizedDrawCall(@NULL kPrioritizedObject);

// Export UTurokHud::execUpdateHUDFade(FFrame&, void* const)
native function UpdateHUDFade();

// Export UTurokHud::execGetDialogSceneClient(FFrame&, void* const)
native function @NULL GetDialogSceneClient();

// Export UTurokHud::execDrawDebugAmmo(FFrame&, void* const)
native function DrawDebugAmmo();

// Export UTurokHud::execIsSpectating(FFrame&, void* const)
native function bool IsSpectating();

exec function ShowChapter(int chapter)
{
    ShowChapterMarker(chapter);
    //return;    
}

exec function SetKnifeKillVisible(bool Show)
{
    mbKnifePromptVisible = Show;
    mKnifeKill.SetVisible(Show);
    //return;    
}

exec function AddPS3Messages()
{
    mPS3Notification.AddAchievement(315317600);
    mPS3Notification.AddInvite("Johnny88 invited you to a multiplayer game");
    mPS3Notification.AddAchievement(-1866607784);
    //return;    
}

exec function ShowScores()
{
    local @NULL Controller;

    // End:0x21
    if(!mHudStats.bAllowPlayerDismissal && mbShowStatsScreen)
    {
        return;
    }
    Controller = Class'TurokPlayerController'.static.GetLocalPlayerController();
    // End:0x79
    if(((Controller == none) || Controller.IsInState('NetGameEnded')) || Controller.IsInState('RoundEnded'))
    {
        return;
    }
    SetShowScoreboards(!mbShowStatsScreen);
    //return;    
}

exec function HudStatsScrollUp()
{
    // End:0x1E
    if(mHudStats != none)
    {
        mHudStats.ScrollUp();
    }
    //return;    
}

exec function HudStatsScrollDown()
{
    // End:0x1E
    if(mHudStats != none)
    {
        mHudStats.ScrollDown();
    }
    //return;    
}

exec function HudStatsViewGamercard()
{
    // End:0x1E
    if(mHudStats != none)
    {
        mHudStats.ShowGamercard();
    }
    //return;    
}

exec function TogglePrimalVitals()
{
    mbRenderPrimalVitals = !mbRenderPrimalVitals;
    //return;    
}

exec function ToggleDebugAmmo()
{
    mbRenderDebugAmmo = !mbRenderDebugAmmo;
    //return;    
}

exec function ToggleMeleeDebug()
{
    mbRenderMeleeDebug = !mbRenderMeleeDebug;
    //return;    
}

exec function AnimDebugNext()
{
    //return;    
}

exec function ShowAnimDebug(string StartingPoint)
{
    super.ShowAnimDebug(StartingPoint);
    AnimDebugThisIsKing = PlayerOwner.CheatManager == none;
    //return;    
}

exec function UseAnimDebugTarget(bool isOverridden)
{
    AnimDebugThisIsKing = isOverridden;
    //return;    
}

exec function ToggleReticleTravelTest()
{
    mReticle.mbTestReticleTravel = !mReticle.mbTestReticleTravel;
    //return;    
}

exec function ShowScreenBlackout(int Show)
{
    // End:0x16
    if(Show == 0)
    {
        mbShowScreenBlackout = false;        
    }
    else
    {
        mbShowScreenBlackout = true;
    }
    //return;    
}

exec function ShowTutorial()
{
    ShowTutorialHud(1250914783, 5);
    //return;    
}

exec function HideTutorial()
{
    HideTutorialHud();
    //return;    
}

event SetStatsAllowPlayerDismissmal(bool allow)
{
    // End:0x21
    if(mHudStats != none)
    {
        mHudStats.bAllowPlayerDismissal = allow;
    }
    //return;    
}

event ResetScoreboardHighlight()
{
    // End:0x1E
    if(mHudStats != none)
    {
        mHudStats.ResetHighlightIndex();
    }
    //return;    
}

// Export UTurokHud::execSetShowScoreboards(FFrame&, void* const)
native function SetShowScoreboards(bool Show, optional bool allow_player_dismissal);

function InitElements()
{
    local @NULL Inv;

    ShowScreenBlackout(0);
    // End:0x9E
    if((mPawnOwner != none) && mPawnOwner.IsLocallyControlled())
    {
        Inv = TurokInventoryManager(mPawnOwner.InvManager);
        // End:0x6B
        if(Inv != none)
        {
            Inv.UpdateHUDState(RHWeapon, LHWeapon);
        }
        // End:0x9E
        if(RHWeapon != none)
        {
            OnChangeWeapon(RHWeapon, LHWeapon);
            OnChangeCrosshair(RHWeapon, LHWeapon);
        }
    }
    //return;    
}

function InviteReceivedDelegate(string Msg)
{
    mPS3Notification.AddInvite(Msg);
    //return;    
}

function AchievementUnlockedDelegate(int AchievementNameHash)
{
    mPS3Notification.AddAchievement(AchievementNameHash);
    //return;    
}

function PostBeginPlay()
{
    super.PostBeginPlay();
    mPawnOwner = Pawn(PlayerOwner.ViewTarget);
    mAmmoDisplay = new (self) Class'TurokHudAmmoDisplay';
    mReticle = new (self) Class'TurokHudReticle';
    mScopeReticle = new (self) Class'TurokHudScope';
    mRPGScope = new (self) Class'TurokHudScopeRPG';
    mHitIndicator = new (self) Class'TurokHudHitIndicator';
    mPrimal = new (self) Class'TurokHudPrimal';
    mGrenade = new (self) Class'TurokHudGrenade';
    mMessage = new (self) Class'TurokHudMessage';
    mInventoryIndicator = new (self) Class'TurokHudInventoryIndicators';
    mDinoMelee = new (self) Class'TurokHudDinoMelee';
    mObjectiveText = new (self) Class'TurokHudObjectiveText';
    mHudStats = new (self) Class'TurokHudStats';
    mDpadWeaponSelect = new (self) Class'TurokHudDpadWeaponSelect';
    mProgressBar = new (self) Class'TurokHudProgressBar';
    mStealthVignette = new (self) Class'TurokHudStealthVignette';
    mPS3Notification = new (self) Class'TurokHudPS3Notification';
    mFullScreenVideo = new (self) Class'TurokHudFullScreenVideo';
    mTutorialText = new (self) Class'TurokHudTutorialText';
    mKnifeKill = new (self) Class'TurokHudKnifeKill';
    mChapterMarker = new (self) Class'TurokHudChapterMarker';
    mCheckpoint = new (self) Class'TurokHudCheckpoint';
    mNoPlacement = new (self) Class'TurokHudNoPlacement';
    mAmmoDisplay.Init(self);
    mReticle.Init(self);
    mScopeReticle.Init(self);
    mRPGScope.Init(self);
    mHitIndicator.Init(self);
    mPrimal.Init(self);
    mGrenade.Init(self);
    mGrenade.mAmmoDisplay = mAmmoDisplay;
    mMessage.Init(self);
    mInventoryIndicator.Init(self);
    mDinoMelee.Init(self);
    mObjectiveText.Init(self);
    mHudStats.Init(self);
    mDpadWeaponSelect.Init(self);
    mProgressBar.Init(self);
    mStealthVignette.Init(self);
    mFullScreenVideo.Init(self);
    mTutorialText.Init(self);
    mKnifeKill.Init(self);
    mChapterMarker.Init(self);
    mCheckpoint.Init(self);
    mNoPlacement.Init(self);
    mPS3Notification.Init(self);
    Class'Engine.TurokOnlineDashboard'.static.Instance().__InGameInviteReceivedDelegate__Delegate = InviteReceivedDelegate;
    Class'Engine.TurokOnlineDashboard'.static.Instance().__InGameAchievementUnlockedDelegate__Delegate = AchievementUnlockedDelegate;
    InitElements();
    //return;    
}

// Export UTurokHud::execDrawPS3SafeZone(FFrame&, void* const)
native function DrawPS3SafeZone();

// Export UTurokHud::execDrawObjectiveIndicators(FFrame&, void* const)
native function DrawObjectiveIndicators();

function HudToDrawWhenTheySayDontDrawHud()
{
    DrawObjectiveIndicators();
    DrawObjectiveText();
    //return;    
}

// Export UTurokHud::execSquelchObjectiveIndicatorAndText(FFrame&, void* const)
native function SquelchObjectiveIndicatorAndText();

// Export UTurokHud::execKillWeaponSwapAnim(FFrame&, void* const)
native function KillWeaponSwapAnim();

function DrawSystemHUD()
{
    mPS3Notification.Draw();
    //return;    
}

function DrawHUD()
{
    local @NULL RPG;

    MPObjectiveItemAlpha = 255.0000000;
    mbDrawingRpgScope = false;
    // End:0x53
    if(mPawnOwner != Pawn(PlayerOwner.ViewTarget))
    {
        mPawnOwner = Pawn(PlayerOwner.ViewTarget);
        InitElements();
    }
    // End:0x3CB
    if(((mPawnOwner != none) && mPawnOwner.IsLocallyControlled()) && mPawnOwner.Health > 0)
    {
        // End:0x9D
        if(!bAllowHudFade)
        {
            ResetFadeTimer();
        }
        UpdateHUDFade();
        mStealthVignette.Draw();
        // End:0xD6
        if(mbRenderPrimalVitals)
        {
            mPrimal.Draw();
        }
        DrawObjectiveIndicators();
        // End:0x35B
        if(!bThirdPersonHud)
        {
            // End:0xFE
            if(mbRenderDebugAmmo)
            {
                DrawDebugAmmo();
            }
            mProgressBar.Draw();
            // End:0x166
            if(mAmmoDisplay.WeaponDrawInfoRH.CurrentWeapon != none)
            {
                mAmmoDisplay.RHWeaponFiringMode = int(mAmmoDisplay.WeaponDrawInfoRH.CurrentWeapon.GetFiringMode());
            }
            mAmmoDisplay.Draw();
            // End:0x1AA
            if(mAmmoDisplay.WeaponDrawInfoRH.CurrentWeapon != none)
            {
                mGrenade.Draw();
            }
            // End:0x300
            if(mbShowReticle)
            {
                // End:0x1D9
                if(int(mCurrentWeaponReticuleType) == int(12))
                {
                    mScopeReticle.Draw();                    
                }
                else
                {
                    // End:0x2D8
                    if((int(mCurrentWeaponReticuleType) == int(9)) && RHWeapon != none)
                    {
                        RPG = TurokWeapRpgNative(RHWeapon);
                        // End:0x29C
                        if((RPG != none) && RPG.mbLockOnHUD)
                        {
                            // End:0x25D
                            if(!mRPGScope.bWasOpen)
                            {
                                mRPGScope.bWasOpen = true;
                                mRPGScope.StartOpen();
                            }
                            mRPGScope.SetLockStatus(RPG.mLockOnCounter);
                            mRPGScope.Draw();
                            mbDrawingRpgScope = true;                            
                        }
                        else
                        {
                            mRPGScope.bWasOpen = false;
                            // End:0x2D5
                            if(mDpadWeaponSelect.mbDrawElement == false)
                            {
                                mReticle.Draw();
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x300
                        if(mDpadWeaponSelect.mbDrawElement == false)
                        {
                            mReticle.Draw();
                        }
                    }
                }
            }
            mHitIndicator.Draw();
            DrawKnifeKill();
            mNoPlacement.Draw();
            // End:0x358
            if(mDpadWeaponSelect.mbDrawElement == true)
            {
                mDpadWeaponSelect.Draw();
            }            
        }
        else
        {
            // End:0x3A3
            if((int(mCurrentWeaponReticuleType) == int(5)) || int(mCurrentWeaponReticuleType) == int(6))
            {
                mReticle.Draw();
                mHitIndicator.Draw();
            }
        }
        DrawObjectiveText();
        DrawActions();
        DrawPrioritized();
        DrawTutorialHUD();
    }
    mMessage.Draw();
    mFullScreenVideo.Draw();
    //return;    
}

function DrawObjectiveText()
{
    mObjectiveText.Draw();
    //return;    
}

function DrawChapterMarker()
{
    mChapterMarker.Draw();
    //return;    
}

function DrawCheckpoint()
{
    mCheckpoint.Draw();
    //return;    
}

function DrawStatsScoreboard()
{
    // End:0x1C
    if(mbShowStatsScreen)
    {
        mHudStats.Draw();
    }
    //return;    
}

function DrawTutorialHUD()
{
    mTutorialText.Draw();
    //return;    
}

function DrawScreenBlackout()
{
    // End:0x6D
    if(mbShowScreenBlackout)
    {
        Canvas.SetPos(0.0000000, 0.0000000);
        Canvas.SetDrawColor(0, 0, 0, byte(255));
        Canvas.__NFUN_466__(mBlackoutTex, 1280.0000000, 720.0000000, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
    }
    //return;    
}

function ResetHUD()
{
    local @NULL RPG;

    mbShowReticle = true;
    mInventoryIndicator.Reset();
    mKnifeKill.Reset();
    mDinoMelee.Reset();
    mHitIndicator.Reset();
    mHudStats.Reset();
    ResetFadeTimer();
    // End:0xD0
    if((int(mCurrentWeaponReticuleType) == int(9)) && RHWeapon != none)
    {
        RPG = TurokWeapRpgNative(RHWeapon);
        // End:0xD0
        if((RPG != none) && RPG.mbLockOnHUD)
        {
            RPG.EndScreenEffect();
        }
    }
    mCheckpoint.Reset();
    mObjectiveText.ResetObjText();
    // End:0x109
    if(mbColorCubeEnabled)
    {
        RestoreColorCube();
    }
    mDpadWeaponSelect.InstantKillHud();
    //return;    
}

function ResetFadeTimer()
{
    mCurrentFadeWaitTime = 0.0000000;
    //return;    
}

function OnChangeCrosshair(@NULL RightWpn, @NULL LeftWpn)
{
    RHWeapon = RightWpn;
    LHWeapon = LeftWpn;
    mReticle.SetWeaponType(RightWpn, LeftWpn);
    // End:0x55
    if(RightWpn != none)
    {
        mCurrentWeaponReticuleType = RightWpn.mWeaponType;        
    }
    else
    {
        mCurrentWeaponReticuleType = 0;
    }
    mAmmoDisplay.AllowWeaponIconFadeOut();
    bAllowHudFade = true;
    //return;    
}

function OnChangeWeapon(@NULL RightWpn, @NULL LeftWpn)
{
    local bool bNew;

    bNew = false;
    // End:0x1B
    if(RightWpn == none)
    {
        bNew = false;
    }
    // End:0x5E
    if((mPawnOwner != none) && mPawnOwner.IsLocallyControlled())
    {
        bNew = mAmmoDisplay.SetWeaponType(RightWpn, LeftWpn);
    }
    // End:0x79
    if(bNew)
    {
        ResetFadeTimer();
        bAllowHudFade = false;
    }
    //return;    
}

function DisplayHit(@NULL hitFromLocation, int Damage, class<Class> DamageType)
{
    mHitIndicator.DisplayHit(hitFromLocation, Damage, DamageType);
    //return;    
}

// Export UTurokHud::execShowObjectiveLocator(FFrame&, void* const)
native function ShowObjectiveLocator();

event ShowReticle()
{
    mbShowReticle = true;
    //return;    
}

event HideReticle()
{
    mbShowReticle = false;
    //return;    
}

event ShowTutorialHud(int textHash, byte buttonImage)
{
    mTutorialText.ShowTutorialText(textHash, buttonImage);
    //return;    
}

event HideTutorialHud()
{
    mTutorialText.HideTutorialText();
    //return;    
}

function AddMessage(@NULL Message)
{
    mMessage.AddMessage(Message);
    //return;    
}

function ShowNoPlacement()
{
    mNoPlacement.SetVisible(true);
    //return;    
}

simulated event PlayHUDSound(@NULL sc, optional float Volume = 1.0000000)
{
    mSoundController.TryPlayLocalSoundAt(sc, Location, false, Volume);
    //return;    
}

event Destroyed()
{
    super.Destroyed();
    Class'Engine.TurokOnlineDashboard'.static.Instance().__InGameInviteReceivedDelegate__Delegate = None;
    Class'Engine.TurokOnlineDashboard'.static.Instance().__InGameAchievementUnlockedDelegate__Delegate = None;
    //return;    
}

event EnableColorCube()
{
    local @NULL tppm;

    mbColorCubeEnabled = true;
    // End:0x23
    if(Class'TurokEngine.TurokUI'.static.IsInGameVideoPlaying() == true)
    {
        return;
    }
    mPreviousHudState = bShowHUD;
    bShowHUD = false;
    tppm = Class'TurokEngine.TurokUI'.static.GetEngine().TurokPostProcessManager;
    BackupColorCubeTexture[0] = tppm.GetTargetColorCubeTexture(0);
    BackupColorCubeTexture[1] = tppm.GetTargetColorCubeTexture(1);
    BackupColorCubeBlend[0] = tppm.GetTargetFloat(36);
    BackupColorCubeBlend[1] = tppm.GetTargetFloat(37);
    mOriginalBlurKernelSize = tppm.GetTargetFloat(9);
    mOriginalMaxNearBlurAmount = tppm.GetTargetFloat(10);
    mOriginalMaxFarBlurAmount = tppm.GetTargetFloat(11);
    mOriginalFocusDistance = tppm.GetTargetFloat(6);
    mOriginalFocusInnerRadius = tppm.GetTargetFloat(7);
    tppm.BeginSettings();
    tppm.SetColorCubeTexture(0, mPauseColorCubeTexture);
    tppm.SetFloatNative(36, 1.0000000);
    tppm.SetFloatNative(9, mBlurKernelSize);
    tppm.SetFloatNative(10, mMaxNearBlurAmount);
    tppm.SetFloatNative(11, mMaxFarBlurAmount);
    tppm.SetFloatNative(6, mFocusDistance);
    tppm.SetFloatNative(7, mFocusInnerRadius);
    tppm.EndSettings();
    //return;    
}

event RestoreColorCube()
{
    local @NULL tppm;

    mbColorCubeEnabled = false;
    // End:0x23
    if(Class'TurokEngine.TurokUI'.static.IsInGameVideoPlaying() == true)
    {
        return;
    }
    bShowHUD = mPreviousHudState;
    tppm = Class'TurokEngine.TurokUI'.static.GetEngine().TurokPostProcessManager;
    tppm.BeginSettings();
    tppm.SetColorCubeTexture(0, BackupColorCubeTexture[0]);
    tppm.SetColorCubeTexture(1, BackupColorCubeTexture[1]);
    tppm.SetFloatNative(36, BackupColorCubeBlend[0]);
    tppm.SetFloatNative(37, BackupColorCubeBlend[1]);
    tppm.SetFloatNative(9, mOriginalBlurKernelSize);
    tppm.SetFloatNative(10, mOriginalMaxNearBlurAmount);
    tppm.SetFloatNative(11, mOriginalMaxFarBlurAmount);
    tppm.SetFloatNative(6, mOriginalFocusDistance);
    tppm.SetFloatNative(7, mOriginalFocusInnerRadius);
    tppm.EndSettings();
    //return;    
}

defaultproperties
{
    mFadeOutTime=5.0000000
    mFadeWaitTime=5.0000000
    mFadeOutAmount=0.6000000
    bAllowHudFade=true
    mbShowReticle=true
    mPreviousHudState=true
    mBlackoutTex=Texture2D'EngineResources.Black'
    mSafeZoneHalfPcnt=0.0750000
    mSafeTex=Texture2D'EngineResources.DecoPaint'
    MPObjectiveItemAlpha=255.0000000
    // Reference: TurokSoundController'Default__TurokHud.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent class=Class'TurokSoundController'
    end object
    mSoundController=TurokSoundControllerComponent
    mAmbientSndChannel=-1
    mPauseColorCubeTexture=Texture2D'FXColorCubes.ColorCubeDesatPauseMenu'
    mDeathMatEffectName="DefaultDOFAndBloom"
    mBlurKernelSize=10.0000000
    mMaxNearBlurAmount=1.0000000
    mMaxFarBlurAmount=1.0000000
    mFocusDistance=8000.0000000
    Components[0]=TurokSoundControllerComponent
}