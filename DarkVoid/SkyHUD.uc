class SkyHUD extends HUD
    native
    config(Game);

enum ETechPointDisplayState
{
    TPDS_Off,                       // 0
    TPDS_OldTotal,                  // 1
    TPDS_Both,                      // 2
    TPDS_NewTotal,                  // 3
    TPDS_MAX                        // 4
};

enum HUDCoverState
{
    HUDCoverNone,                   // 0
    HUDCoverEnterVU,                // 1
    HUDCoverEnterVD,                // 2
    HUDCoverEnterH,                 // 3
    HUDCoverSlip,                   // 4
    HUDCoverSwatVU,                 // 5
    HUDCoverSwatVD,                 // 6
    HUDCoverSwatH,                  // 7
    HUDCoverDive,                   // 8
    HUDCoverMantleVU,               // 9
    HUDCoverMantleVD,               // 10
    HUDCoverMantleH,                // 11
    HUDCoverStepUp,                 // 12
    HUDCoverExitVU,                 // 13
    HUDCoverMantleVUSwap,           // 14
    HUDCoverDangle,                 // 15
    HUDCoverState_MAX               // 16
};

enum EIndicatorValueCompare
{
    EIVC_None,                      // 0
    EIVC_GreaterThan,               // 1
    EIVC_LessThan,                  // 2
    EIVC_MAX                        // 3
};

enum EIndicatorReactionTest
{
    EIRT_None,                      // 0
    EIRT_During,                    // 1
    EIRT_After,                     // 2
    EIRT_MAX                        // 3
};

enum EArmorConditional
{
    EAC_MustHave,                   // 0
    EAC_MustNotHave,                // 1
    EAC_HealthAbove,                // 2
    EAC_HealthBelow,                // 3
    EAC_MAX                         // 4
};

struct native DamageArrow
{
    var Vector HitDir;
    var float TimeOfImpact;
    var int Damage;
    var int ArrowAlpha;
    var Pawn Attacker;

    structdefaultproperties
    {
        HitDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        TimeOfImpact=0.0000000
        Damage=0
        ArrowAlpha=0
        Attacker=none
    }
};

struct native InteractionInstruction
{
    var() name InteractName;
    var() string InteractButton;
    var() Surface InteractIcon;
    var() string InteractText;
    var() string KeyboardAlt;
    var() float IconHeight;
    var() int Precedence;
    var() bool ShowIfNoModifier;
    var transient name InteractModifier;
    var transient Surface InteractButtonIcon;
    var transient string InteractButtonText;
    var transient int InteractColorParam;
    var transient bool bAvailableNow;
    var transient int BindingPrecedence;

    structdefaultproperties
    {
        InteractName="None"
        InteractButton=""
        InteractIcon=none
        InteractText=""
        KeyboardAlt=""
        IconHeight=0.1185190
        Precedence=0
        ShowIfNoModifier=false
        InteractModifier="None"
        InteractButtonIcon=none
        InteractButtonText=""
        InteractColorParam=0
        bAvailableNow=false
        BindingPrecedence=0
    }
};

struct native InteractionButton
{
    var() string ButtonName;
    var() Surface ButtonIcon;
    var() bool KeyboardOk;
    var() Surface InlineIcon;
    var() int ColorParameter;

    structdefaultproperties
    {
        ButtonName=""
        ButtonIcon=none
        KeyboardOk=false
        InlineIcon=none
        ColorParameter=0
    }
};

struct native HealthConditional
{
    var() SkyHUD.EIndicatorValueCompare Condition;
    var() float HealthPercent;

    structdefaultproperties
    {
        Condition=EIVC_None
        HealthPercent=0.0000000
    }
};

struct native ArmorConditional
{
    var() SkyHUD.EArmorConditional Conditional;
    var() SkyPawn.EArmorType Type;
    var() float ArmorHealth;

    structdefaultproperties
    {
        Conditional=EAC_MustHave
        Type=ArmorType_Undefined
        ArmorHealth=0.0000000
    }
};

struct native IndicatorActionDisplay
{
    var() init string Command;
    var() bool bUseDisabledColor;
    var() deprecated Color DisplayColor;

    structdefaultproperties
    {
        Command=""
        bUseDisabledColor=true
    }
};

struct native Indicator
{
    var() array< class<SkyInteractor> > AffectedClasses;
    var(Base) name Name;
    var(Base) float VisibleDist;
    var(Base) float VisibleInnerMaterialDist;
    var(Base) Vector vScale;
    var(Base) deprecated MaterialInterface MatOuter;
    var(Base) deprecated MaterialInterface MatInner;
    var(Base) IndicatorActionDisplay InnerIcon;
    var(Base) IndicatorActionDisplay OuterIcon;
    var(Base) Vector vOffset;
    var(Base) name SocketName;
    var(Rules) array<HealthConditional> arHealthConditions;
    var(Rules) array<ArmorConditional> arArmorConditionals;
    var(Rules) bool bAllWeakPointsDestroyed;
    var(Rules) string RequiredArchetype;
    var(Rules) array<SkyPawn_Archon.EStumbleType> ArchonRequiredStumbleTypes;
    var(Rules) SkyHUD.EIndicatorReactionTest ReactionTest;
    var(Rules) name Reaction;
    var(Rules) bool bAllowZeroHealthIndicator;
    var bool bStartedReaction;
    var Actor actorOverride;
    var deprecated MaterialInterface matOverride;
    var deprecated Color colorOverride;
    var init string szCommandOverride;
    var transient MaterialInstanceConstant mic;

    structdefaultproperties
    {
        AffectedClasses=none
        Name="None"
        VisibleDist=0.0000000
        VisibleInnerMaterialDist=0.0000000
        vScale=(X=1.0000000,Y=1.0000000,Z=0.0000000)
        InnerIcon=(Command="",bUseDisabledColor=true)
        OuterIcon=(Command="",bUseDisabledColor=true)
        vOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SocketName="None"
        arHealthConditions=none
        arArmorConditionals=none
        bAllWeakPointsDestroyed=false
        RequiredArchetype=""
        ArchonRequiredStumbleTypes=none
        ReactionTest=EIRT_None
        Reaction="None"
        bAllowZeroHealthIndicator=false
        bStartedReaction=false
        actorOverride=none
        szCommandOverride=""
        mic=none
    }
};

struct native IndicatorIcon
{
    var deprecated MaterialInterface MatIcon;
    var deprecated Color colorIcon;
    var init string szCommand;
    var bool bUseDisabledColor;
    var Vector vScreenPos;
    var Vector vScale;
    var transient MaterialInstanceConstant mic;

    structdefaultproperties
    {
        szCommand=""
        bUseDisabledColor=false
        vScreenPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        vScale=(X=1.0000000,Y=1.0000000,Z=0.0000000)
        mic=none
    }
};

struct native PickupTutorial
{
    var() name PickupID;
    var() UIScene TutorialScene;

    structdefaultproperties
    {
        PickupID="None"
        TutorialScene=none
    }
};

struct native ObjectiveHealthTrack
{
    var string LabelText;
    var Pawn Pawn;
    var float Health;

    structdefaultproperties
    {
        LabelText=""
        Pawn=none
        Health=0.0000000
    }
};

var array< delegate<DebugDraw> > DebugDrawList;
var bool bSceneHudObjective;
var bool bSceneTakeOffMessage;
var bool bSceneExitAircraftMessage;
var bool bSceneParachuteMessage;
var bool bSceneInteractionText;
var bool bSceneWeaponAmmoPickup;
var bool bSceneWeaponAmmoPickupFull;
var bool bSceneSkipCinematic;
var bool bSceneGripMeter;
var bool bSceneWeaponSwitch;
var bool bSceneWeaponPickup;
var bool bSceneVerifyThrustMessage;
var transient bool bShowObjectiveHUD;
var transient bool bNextObjectiveTutorial;
var(Objective) bool ShowFriendlyPlaneIcons;
var bool bLastFramePaused;
var bool bEnablePlaneBrackets;
var bool bDisplayVehicleDebugText;
var bool bDrawingMelee;
var transient bool bShowInfoHud;
var transient bool bCanEnterVerticalCover;
var bool bShowAllAI;
var transient bool bObjectiveView;
var transient bool bForceObjectiveView;
var transient bool bInputForceObjectiveView;
var transient bool bControllerConnected;
var config float TeammateNameDrawDistance;
var config float TeammateVehicleNameDrawDistance;
var config float EnemyNameDrawDistance;
var config float EnemyVehicleNameDrawDistance;
var config float DeadEnemyNameDrawDistance;
var() SkyUIScene_Hud HudSceneTemplate;
var SkyUIScene_Hud HudScene;
var transient SkyHudWidget_DamageIndicator DamageIndicatorWidget;
var transient UIVisibilityPanel pnlPrimary;
var transient UIImage imgPrimaryIcon;
var transient UILabel lblPrimaryAmmo;
var transient UIVisibilityPanel imgPrimaryInfinity;
var transient UIVisibilityPanel pnlSecondary;
var transient UIImage imgSecondaryIcon;
var transient UILabel lblSecondaryAmmo;
var transient UIVisibilityPanel imgSecondaryInfinity;
var transient UIVisibilityPanel pnlInteract;
var transient UIVisibilityPanel pnlInteractSwap;
var transient UIImage imgInteractSwapIcon;
var transient UIImage imgNoSwapIcon;
var transient UIVisibilityPanel pnlInteractAction;
var transient UIImage imgInteractIcon;
var transient UILabel lblInteractIcon;
var transient UIImage imgInteractKeyboardBG;
var transient UIImage imgInteractButton;
var transient UILabel lblInteractButton;
var transient UIImage imgInteractBackground;
var transient UIImage imgInteractActionBackground;
var transient UIVisibilityPanel pnlGrip;
var transient UIProgressBar UIProgressBar_GripMeter;
var transient UIImage imgGripInstruct;
var transient UILabel lblGripInstruct;
var transient UIImage imgGripKeyboardBG;
var transient UIVisibilityPanel pnlBoost;
var transient UIProgressBar UIProgressBar_BoostMeter;
var transient UILabel lblObjectiveText;
var transient UILabel lblHelpText;
var transient UILabel lblInteractionText;
var transient UIScreenObject AutosaveIcon;
var transient UIScreenObject ProfileSaveIcon;
var transient UIScreenObject CheckpointMsg;
var transient UILabel TechPointTotal;
var transient UILabel TechPointAdd;
var transient UIVisibilityPanel pnlAAGun;
var transient UIImage imgAAGun;
var transient UILabel lblNextGun;
var transient UILabel lblPrevGun;
var transient UIVisibilityPanel pnlMissionHealth1;
var transient UIVisibilityPanel pnlMissionHealth2;
var transient UIVisibilityPanel pnlMissionHealth3;
var transient array<UIVisibilityPanel> MissionHealthPanels;
var transient Vector ReticleHitLocation;
var transient Vector ReticleHitNormal;
var(Reticle) LinearColor ReticleColorNone;
var(Reticle) LinearColor ReticleColorFriendly;
var(Reticle) LinearColor ReticleColorEnemy;
var Font Font;
var() Font InteractionFont;
var() SkyRadar Radar;
var() SoundCue JournalPickupSoundEffect;
var const MaterialInterface MatHealthEffect;
var MaterialInstanceConstant MatHealthEffectInstance;
var(Objective) const Surface TexObjectiveArrow;
var(Objective) const float ObjectiveArrowWidth;
var(Objective) const float ObjectiveArrowHeight;
var(Objective) const Surface TexObjOffscreenArrow;
var(Objective) const float ObjOffscreenArrowWidth;
var(Objective) const float ObjOffscreenArrowHeight;
var(Objective) const float ObjOffscreenArrowRadius;
var(Objective) const Font ObjectiveRangeFont;
var(Objective) const Color ObjectiveRangeColor;
var(Objective) const float ObjectiveMarginPct;
var(Objective) const SoundCue ObjectiveShowSound;
var transient MaterialInstanceConstant ObjectiveArrowMatInst;
var transient MaterialInstanceConstant ObjOffscreenArrowMatInst;
var(Objective) Surface TexBracketCorner;
var(Objective) Surface TexBracketSidesYellow;
var(Objective) float PlaneBracketMinDistance;
var(Objective) float PlaneBracketMinStartFade;
var(Objective) float PlaneBracketMaxStartFade;
var(Objective) float PlaneBracketMaxDistance;
var(Objective) float PlaneBracketMaxDistanceAlpha;
var(Objective) float FloatingInteractButtonScale;
var transient string InteractionKeyString;
var transient float HelpStringTimeout;
var transient Surface TexGroundWeapon;
var transient Surface TexEquippedWeapon;
var transient Surface TexGroundItem;
var transient Surface TexEquippedItem;
var const float HealthDockLeftX;
var const float HealthDockTopY;
var string HUDTitle;
var transient string CurrentInteractionText;
var transient string LastInteractionText;
var transient float LastOverlayDraw;
var transient array<SkyHUDOverlay> HUDOverlays;
var transient array<SkyVariableMaterial> HudVariableMaterials;
var transient string EquippedWeaponName;
var transient string GroundWeaponName;
var transient string EquippedItemName;
var transient string GroundItemName;
var transient string WeaponSwapCost;
var transient int LastCostIndex;
var transient int TechPointCurVal;
var transient int TechPointAddVal;
var transient SkyHUD.ETechPointDisplayState TechPointDisplayState;
var deprecated transient SkyHUD.HUDCoverState CoverActionAvailable;
var float VehicleCheckDelay;
var transient int LastCachedInteractionIdx;
var LocalPlayer SideViewLocalPlayer;
var Pawn PawnOwner;
var array<DamageArrow> DmgArrows;
var const float DmgArrowFadeTime;
var const float UpdateDmgArrowsDelay;
var const float DrawWeaponPickupDelay;
var const float HudFadeInDelay;
var const float HudFadeOutDelay;
var const float HudKeepVisibleTime;
var float HudIdleTime;
var float HudVisibility;
var int HudLastHealthValue;
var float HudStaminaValue;
var float HudLastStaminaValue;
var int HudPrimaryValue;
var int HudSecondaryValue;
var int HudLastPrimaryValue;
var int HudLastSecondaryValue;
var float HudFadeInDelta;
var(HUD) float HealthDamagePulseFadeDelay;
var float HealthDamagePulseFade;
var transient float StaminaValue;
var(Objective) const float ObjectiveFadeDelay;
var transient float ObjectiveLastHideTime;
var transient float ObjectiveLastShowTime;
var transient name CoverAction;
var const float UpdateCoverStatusDelay;
var() array<InteractionInstruction> Interactions;
var() array<InteractionButton> Buttons;
var native transient map{VOID,VOID} ButtonMap;
var transient int CurrentInteraction;
var transient name InteractionModifier;
var transient Surface OverrideInteractIcon;
var transient string OverrideInteractString;
var transient Surface SwapInteractIcon;
var transient Surface GripInstructionIcon;
var transient string CurrenInteractButtonAction;
var() array<Surface> GripInstructionIcons;
var() array<string> GripInstructionStrings;
var() array<LinearColor> UIColors;
var() int DisabledColorIndex;
var() int DefaultHUDColorIndex;
var() int OutOfAmmoColorIndex;
var transient float HudDelta;
var transient float HudLastDelta;
var float NearDeathSoundThreshold;
var export editinline AudioComponent NearDeathSound;
var transient Actor DebugTargetActor;
var transient MaterialInterface MovieMat;
var transient Surface CachedInputButtonForCommand;
var transient string CachedInputButtonCommand;
var transient name CachedInputButtonModifier;
var transient int CachedInputButtonColorparam;
var transient int CachedInputButtonPrecedence;
var transient name CurInteractionIconOverride;
var transient Actor IndicatorOverriddenActor;
var(Indicators) array<Indicator> arIndicators;
var init array<init IndicatorIcon> arIndicatorIcons;
var array<Actor> arPotentialActors;
var transient name LastGripActionInteractionName;
var(PopupScenes) array<UIScene> arPopupScenes;
var() array<PickupTutorial> arPickupTutorials;
var transient array<ObjectiveHealthTrack> HealthTracks;
var transient float PlaneBracketTexWidth;
var transient float PlaneBracketTexHeight;
var name OpacityName;
var name FadeOutName;
var name DrawColorName;
var name AmmoCountName;
var name MaxAmmoCountName;
var name OverheatName;
var transient string LastHelpText;
//var delegate<DebugDraw> __DebugDraw__Delegate;

static function OpenPickupTutorial(name PickupID, PlayerController PCInstigator)
{
    local SkyHUD theHUD;
    local OnlineProfileSettings OPC;
    local GameUISceneClient GSC;
    local int bfOpened, iTutorial;
    local UIScene TutorialScene;

    // End:0x0D
    if(PCInstigator == none)
    {
        return;
    }
    // End:0x24
    if(PCInstigator.CinematicModeRefCount > 0)
    {
        return;
    }
    theHUD = SkyHUD(PCInstigator.myHUD);
    // End:0x4B
    if(theHUD == none)
    {
        return;
    }
    OPC = PCInstigator.GetProfileSettings();
    // End:0x72
    if(OPC == none)
    {
        return;
    }
    // End:0x94
    if(!OPC.GetProfileSettingValueInt(93, bfOpened))
    {
        return;
    }
    iTutorial = 0;
    J0x9B:

    // End:0x112 [Loop If]
    if(iTutorial < theHUD.arPickupTutorials.Length)
    {
        // End:0x108
        if(theHUD.arPickupTutorials[iTutorial].PickupID == PickupID)
        {
            TutorialScene = theHUD.arPickupTutorials[iTutorial].TutorialScene;
            // [Explicit Break]
            goto J0x112;
        }
        iTutorial++;
        // [Loop Continue]
        goto J0x9B;
    }
    J0x112:

    // End:0x1F7
    if(iTutorial < theHUD.arPickupTutorials.Length)
    {
        // End:0x143
        if((bfOpened & (1 << iTutorial)) != 0)
        {
            return;
        }
        GSC = Class'Engine.UIRoot'.static.GetSceneClient();
        // End:0x166
        if(GSC == none)
        {
            return;
        }
        bfOpened = bfOpened | (1 << iTutorial);
        OPC.SetProfileSettingValueInt(93, bfOpened);
        // End:0x1C9
        if(PickupID == 'Melee')
        {
            theHUD.SetTimer(0.3500000, false, 'ShowMeleeTutorial');            
        }
        else
        {
            // End:0x1DF
            if(PickupID == 'Journal')
            {                
            }
            else
            {
                GSC.OpenScene(TutorialScene);
            }
        }
    }
    //return;    
}

function ShowMeleeTutorial()
{
    local GameUISceneClient GSC;
    local int I;

    GSC = Class'Engine.UIRoot'.static.GetSceneClient();
    // End:0x23
    if(GSC == none)
    {
        return;
    }
    I = 0;
    J0x2A:

    // End:0x93 [Loop If]
    if(I < arPickupTutorials.Length)
    {
        // End:0x89
        if(arPickupTutorials[I].PickupID == 'Melee')
        {
            GSC.OpenScene(arPickupTutorials[I].TutorialScene);
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x2A;
    }
    //return;    
}

function SetHealthTrackPawn(string lbl, Pawn P)
{
    local int I;
    local ObjectiveHealthTrack T;

    I = 0;
    J0x07:

    // End:0x5F [Loop If]
    if(I < HealthTracks.Length)
    {
        // End:0x55
        if(HealthTracks[I].LabelText == lbl)
        {
            HealthTracks[I].Pawn = P;
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    T.LabelText = lbl;
    T.Health = 0.0000000;
    T.Pawn = P;
    HealthTracks.AddItem(T);
    UpdateHealthTracks();
    //return;    
}

function SetHealthTrack(string lbl, float H)
{
    local int I;
    local ObjectiveHealthTrack T;

    I = 0;
    J0x07:

    // End:0x5F [Loop If]
    if(I < HealthTracks.Length)
    {
        // End:0x55
        if(HealthTracks[I].LabelText == lbl)
        {
            HealthTracks[I].Health = H;
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    T.LabelText = lbl;
    T.Health = H;
    T.Pawn = none;
    HealthTracks.AddItem(T);
    UpdateHealthTracks();
    //return;    
}

function ClearHealthTrack(string lbl)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4F [Loop If]
    if(I < HealthTracks.Length)
    {
        // End:0x45
        if(HealthTracks[I].LabelText == lbl)
        {
            HealthTracks.Remove(I, 1);
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    UpdateHealthTracks();
    //return;    
}

event UpdateHealthTracks()
{
    local int I;
    local UILabel lbl;
    local UIProgressBar bar;

    I = 0;
    J0x07:

    // End:0x24C [Loop If]
    if(I < MissionHealthPanels.Length)
    {
        // End:0x242
        if(MissionHealthPanels[I] != none)
        {
            // End:0x227
            if(HealthTracks.Length > I)
            {
                MissionHealthPanels[I].SetVisibility(true);
                lbl = UILabel(MissionHealthPanels[I].FindChild('lblMissionHealth'));
                bar = UIProgressBar(MissionHealthPanels[I].FindChild('barMissionHealth'));
                // End:0xDA
                if(lbl != none)
                {
                    lbl.SetValue(HealthTracks[I].LabelText);
                }
                // End:0x224
                if(bar != none)
                {
                    // End:0x1AD
                    if(HealthTracks[I].Pawn != none)
                    {
                        bar.ProgressBarValue.MinValue = 0.0000000;
                        bar.ProgressBarValue.MaxValue = float(Pawn(HealthTracks[I].Pawn.ObjectArchetype).Health);
                        bar.ProgressBarValue.CurrentValue = float(HealthTracks[I].Pawn.Health);                        
                    }
                    else
                    {
                        bar.ProgressBarValue.MinValue = 0.0000000;
                        bar.ProgressBarValue.MaxValue = 100.0000000;
                        bar.ProgressBarValue.CurrentValue = HealthTracks[I].Health * float(100);
                    }
                }
                // [Explicit Continue]
                goto J0x242;
            }
            MissionHealthPanels[I].SetVisibility(false);
        }
        J0x242:

        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x283
    if(HealthTracks.Length > 0)
    {
        // End:0x280
        if(!IsTimerActive('UpdateHealthTracks'))
        {
            SetTimer(0.5000000, true, 'UpdateHealthTracks');
        }        
    }
    else
    {
        ClearTimer('UpdateHealthTracks');
    }
    //return;    
}

// Export USkyHUD::execDrawIndicators(FFrame&, void* const)
native function DrawIndicators(Vector vPosRef);

// Export USkyHUD::execSetIndicatorOverride(FFrame&, void* const)
native function bool SetIndicatorOverride(name nameIndicator, Actor actorOverride, string szCommandOverride);

// Export USkyHUD::execNotifyPotentialActorsOfHudDestroy(FFrame&, void* const)
native function NotifyPotentialActorsOfHudDestroy();

// Export USkyHUD::execDrawIndicatorIcons(FFrame&, void* const)
native function DrawIndicatorIcons();

// Export USkyHUD::execAddIndicatorIcon(FFrame&, void* const)
native function AddIndicatorIcon(Vector vPosWorld, Vector vScale, string szCommand, bool bLockToVertical, Vector vOffset, optional bool bUseDisabledColor = false);

// Export USkyHUD::execGetScreenPos(FFrame&, void* const)
native function bool GetScreenPos(Vector WorldPos, bool bLockToVertical, Vector Offset, out Vector vScreenPos);

// Export USkyHUD::execDrawAudioCueDebug(FFrame&, void* const)
native function DrawAudioCueDebug();

// Export USkyHUD::execDrawAudioCategoriesDebug(FFrame&, void* const)
native function DrawAudioCategoriesDebug();

// Export USkyHUD::execDrawAudioMusicDebug(FFrame&, void* const)
native function DrawAudioMusicDebug();

// Export USkyHUD::execDrawAudioOcclusion(FFrame&, void* const)
native function DrawAudioOcclusion();

// Export USkyHUD::execDrawAudioStreams(FFrame&, void* const)
native function DrawAudioStreams();

// Export USkyHUD::execDrawPlaneBrackets(FFrame&, void* const)
native function DrawPlaneBrackets();

event DrawAudioCueDebugName(AudioComponent Component)
{
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.DrawText(string(Component.SoundCue.Name));
    //return;    
}

event DrawAudioCueDebugWaveInstance(string InstanceName, float Distance, float RelVel, float Volume, float Pitch, int Voices, float DirectOcclusion, float ReverbOcclusion)
{
    Canvas.SetDrawColor(255, 196, 196, 255);
    Canvas.DrawText((((((((((((((InstanceName $ " Dist: ") $ string(Distance)) $ " RelVel: ") $ string(RelVel)) $ " Vol: ") $ string(Volume)) $ " Pitch: ") $ string(Pitch)) $ " Voices: ") $ string(Voices)) $ " DOcc: ") $ string(DirectOcclusion)) $ " ROcc: ") $ string(ReverbOcclusion));
    //return;    
}

event DrawAudioCueDebugBeginParam(string Type)
{
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.SetPos(Canvas.CurX - float(5), Canvas.CurY);
    Canvas.DrawText(Type $ ":");
    Canvas.SetPos(Canvas.CurX + float(5), Canvas.CurY);
    //return;    
}

event DrawAudioCueDebugInstanceParam(string ParamName, float Value)
{
    Canvas.SetDrawColor(196, 196, 255, 255);
    Canvas.DrawText((ParamName $ ": ") $ string(Value));
    //return;    
}

event DrawAudioCategoryDebug(string CatName, float Value)
{
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.DrawText((CatName $ ": ") $ string(Value));
    //return;    
}

event DrawAudioVoiceCount(int TotalVoices)
{
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.DrawText("Total Voices: " $ string(TotalVoices));
    //return;    
}

event DrawAudioReverb(string ReverbName, int ChannelCount)
{
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.DrawText((("Reverb: " $ ReverbName) $ " Channels: ") $ string(ChannelCount));
    //return;    
}

event DrawAudioOccPos(Vector WorldLoc, string CueText)
{
    local Vector ScreenPos;
    local float objHalfSpace, Size, unused;
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(PlayerOwner.PlayerCamera);
    ScreenPos = WorldLoc;
    ScreenPos.Z = ScreenPos.Z + 25.0000000;
    ScreenPos = Canvas.Project(ScreenPos);
    objHalfSpace = Vector(SkyCam.Rotation) Dot (WorldLoc - SkyCam.Location);
    // End:0x1B9
    if((((ScreenPos.X > float(0)) || ScreenPos.Y > float(0)) || ScreenPos.X < Canvas.ClipX) || ScreenPos.Y < Canvas.ClipY)
    {
        // End:0x124
        if(objHalfSpace < float(0))
        {
            return;
        }
        Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
        Canvas.TextSize(CueText, Size, unused);
        Canvas.SetPos(ScreenPos.X - (Size / float(2)), ScreenPos.Y);
        Canvas.DrawTextClipped(CueText);
    }
    //return;    
}

// Export USkyHUD::execCacheButtonArray(FFrame&, void* const)
native function CacheButtonArray();

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    Radar = new (self) Class'SkyRadar' (Radar);
    Radar.Init(self);
    SetTimer(VehicleCheckDelay, true, 'UpdateNearbyVehicle');
    SetTimer(UpdateCoverStatusDelay + ((FRand() - 0.5000000) * (UpdateCoverStatusDelay * 0.1000000)), true, 'UpdateCover');
    SetTimer(UpdateDmgArrowsDelay, true, 'UpdateDmgArrows');
    SetTimer(DrawWeaponPickupDelay, true, 'DrawWeaponPickup');
    MatHealthEffectInstance = new (Outer) Class'Engine.MaterialInstanceConstant';
    MatHealthEffectInstance.SetParent(MatHealthEffect);
    MatHealthEffectInstance.SetScalarParameterValue('healthdamagepulse', 0.0000000);
    MatHealthEffectInstance.SetScalarParameterValue('PercentageValue', 1.0000000);
    CreateHudScene();
    bShowObjectiveHUD = true;
    // End:0x159
    if(MaterialInterface(TexObjectiveArrow) != none)
    {
        ObjectiveArrowMatInst = new (Outer) Class'Engine.MaterialInstanceConstant';
        ObjectiveArrowMatInst.SetParent(MaterialInterface(TexObjectiveArrow));
    }
    // End:0x19B
    if(MaterialInterface(TexObjOffscreenArrow) != none)
    {
        ObjOffscreenArrowMatInst = new (Outer) Class'Engine.MaterialInstanceConstant';
        ObjOffscreenArrowMatInst.SetParent(MaterialInterface(TexObjOffscreenArrow));
    }
    //return;    
}

// Export USkyHUD::execLinkToHudScene(FFrame&, void* const)
native function LinkToHudScene();

// Export USkyHUD::execRenderMemory(FFrame&, void* const)
native function RenderMemory();

// Export USkyHUD::execRenderMovie(FFrame&, void* const)
native function bool RenderMovie();

// Export USkyHUD::execPostRender(FFrame&, void* const)
native simulated event PostRender();

event HandleScoreboard()
{
    // End:0x51
    if(ScoreBoard != none)
    {
        ScoreBoard.Canvas = Canvas;
        ScoreBoard.DrawHUD();
        // End:0x51
        if(ScoreBoard.bDisplayMessages)
        {
            DisplayConsoleMessages();
        }
    }
    //return;    
}

event ShowDebugInfo()
{
    local float XL, YL, YPos;
    local SkyPlayerController SPC;
    local Actor DebugRenderTarget;

    // End:0x23
    if(DebugTargetActor == none)
    {
        DebugRenderTarget = PlayerOwner.ViewTarget;        
    }
    else
    {
        DebugRenderTarget = DebugTargetActor;
    }
    Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
    Canvas.DrawColor = ConsoleColor;
    Canvas.StrLen("X", XL, YL);
    YPos = 0.0000000;
    DebugRenderTarget.DisplayDebug(self, YL, YPos);
    // End:0xD9
    if(Pawn(DebugRenderTarget) == none)
    {
        PlayerOwner.DisplayDebug(self, YL, YPos);
    }
    // End:0x118
    if((ShouldDisplayDebug('AI')) && Pawn(DebugRenderTarget) != none)
    {
        DrawRoute(Pawn(DebugRenderTarget));        
    }
    else
    {
        // End:0x18A
        if(ShouldDisplayDebug('planeai'))
        {
            SPC = SkyPlayerController(PlayerOwner);
            // End:0x187
            if(SPC != none)
            {
                // End:0x187
                if(SPC.ViewTargetAirVehicle != none)
                {
                    SPC.ViewTargetAirVehicle.DisplayDebug(self, YL, YPos);
                }
            }            
        }
        else
        {
            // End:0x1AA
            if(ShouldDisplayDebug('streaming'))
            {
                RenderStreamingInfo();
            }
        }
    }
    // End:0x1E4
    if(ShouldDisplayDebug('audiocue'))
    {
        Canvas.SetPos(150.0000000, 150.0000000);
        DrawAudioCueDebug();
    }
    // End:0x236
    if(ShouldDisplayDebug('audiomusic'))
    {
        Canvas.SetPos(300.0000000, 15.0000000);
        Canvas.SetDrawColor(255, 255, 255, 255);
        DrawAudioMusicDebug();
    }
    // End:0x270
    if(ShouldDisplayDebug('audiocategory'))
    {
        Canvas.SetPos(100.0000000, 200.0000000);
        DrawAudioCategoriesDebug();
    }
    // End:0x290
    if(ShouldDisplayDebug('audioocclusion'))
    {
        DrawAudioOcclusion();
    }
    // End:0x2B0
    if(ShouldDisplayDebug('audiostreams'))
    {
        DrawAudioStreams();
    }
    // End:0x2D0
    if(ShouldDisplayDebug('memgraph'))
    {
        RenderMemory();
    }
    //return;    
}

// Export USkyHUD::execSetDebugTarget(FFrame&, void* const)
native exec function SetDebugTarget(optional string TargetName);

exec function SetDebugTargetByLock()
{
    // End:0xB0
    if((((PlayerOwner != none) && PlayerOwner.Pawn != none) && SkyWeaponBase(PlayerOwner.Pawn.Weapon) != none) && Pawn(SkyWeaponBase(PlayerOwner.Pawn.Weapon).LockedTarget) != none)
    {
        DebugTargetActor = Pawn(SkyWeaponBase(PlayerOwner.Pawn.Weapon).LockedTarget);
    }
    //return;    
}

event DrawAIOverlays()
{
    //return;    
}

function DrawLocalMessage(int I)
{
    //return;    
}

simulated function UpdateWeaponHudScene()
{
    //return;    
}

function RenderStreamingInfo()
{
    local StaticMeshActor SMActor;

    // End:0x30
    foreach AllActors(Class'Engine.StaticMeshActor', SMActor)
    {
        SMActor.StaticMeshComponent.RenderStreamingInfo(self);        
    }    
    //return;    
}

simulated function SkyVehicle FindNearVehicle()
{
    local Vehicle V, Best;
    local Vector ViewDir, PawnLoc2D, VLoc2D;
    local float NewDot, BestDot;
    local SkyPawn SP;

    SP = SkyPawn(PawnOwner);
    // End:0x1D
    if(SP == none)
    {
        return none;
    }
    // End:0x39
    if(Vehicle(SP.Base) != none)
    {
        return none;
    }
    PawnLoc2D = SP.Location;
    PawnLoc2D.Z = 0.0000000;
    ViewDir = Vector(SP.Rotation);
    // End:0x166
    foreach SP.OverlappingActors(Class'Engine.Vehicle', V, SP.VehicleCheckRadius)
    {
        VLoc2D = V.Location;
        VLoc2D.Z = 0.0000000;
        NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
        // End:0x165
        if((Best == none) || NewDot > BestDot)
        {
            // End:0x165
            if(FastTrace(V.Location, SP.Location) && V.CanEnterVehicle(SP))
            {
                Best = V;
                BestDot = NewDot;
            }
        }        
    }    
    return SkyVehicle(Best);
    //return ReturnValue;    
}

simulated function UpdateNearbyVehicle()
{
    DrawVehicleOverlay();
    //return;    
}

simulated function UpdateCover()
{
    local SkyPlayerController SPC;
    local SkyPawnCoverUser SP;
    local CoverReference Info;
    local int I;
    local array<InteractionInstruction> PossibleCoverActions;
    local int bestprecedence, bestlineprecedence, bestindex;
    local name OldCoverAction;

    SPC = SkyPlayerController(PlayerOwner);
    SP = SkyPawnCoverUser(SPC.Pawn);
    bCanEnterVerticalCover = false;
    OldCoverAction = CoverAction;
    // End:0x67
    if((SPC == none) || SP == none)
    {
        CoverAction = 'None';        
    }
    else
    {
        // End:0xBA
        if(((((PlayerOwner.CinematicModeRefCount > 0) || bSceneWeaponPickup) || bSceneWeaponSwitch) || bSceneWeaponAmmoPickup) || bSceneInteractionText)
        {
            CoverAction = 'None';            
        }
        else
        {
            // End:0x107
            if((SP.CommittedToRocketPacking() || SP.IsInteracting()) || bDrawingMelee)
            {
                CoverAction = 'None';                
            }
            else
            {
                // End:0x204
                if(int(SP.GetCoverState()) == int(0))
                {
                    // End:0x158
                    if(SPC.CanLeapToCover())
                    {
                        bCanEnterVerticalCover = true;
                        CoverAction = 'CoverEnterVU';                        
                    }
                    else
                    {
                        // End:0x1A9
                        if(SPC.CanTryToRunToCover() && SPC.TryToRunToCover(0.0000000, true, true))
                        {
                            bCanEnterVerticalCover = true;
                            CoverAction = 'CoverEnterVD';                            
                        }
                        else
                        {
                            // End:0x1F2
                            if(SPC.CanTryToRunToCover() && SPC.TryToRunToCover(0.0000000, true))
                            {
                                CoverAction = 'CoverEnterH';                                
                            }
                            else
                            {
                                CoverAction = 'None';
                            }
                        }
                    }                    
                }
                else
                {
                    // End:0x235
                    if(int(SP.GetCoverState()) == int(27))
                    {
                        CoverAction = 'CoverDangle';                        
                    }
                    else
                    {
                        CoverAction = 'None';
                        I = 0;
                        J0x24B:

                        // End:0x35F [Loop If]
                        if(I < Interactions.Length)
                        {
                            // End:0x355
                            if(Left(string(Interactions[I].InteractName), 5) ~= "Cover")
                            {
                                // End:0x30F
                                if(Interactions[I].InteractModifier != 'None')
                                {
                                    // End:0x30C
                                    if(SPC.PlayerInput.PressedKeys.Find(Interactions[I].InteractModifier) >= 0)
                                    {
                                        Interactions[I].bAvailableNow = false;
                                        PossibleCoverActions.InsertItem(0, Interactions[I]);
                                    }
                                    // [Explicit Continue]
                                    goto J0x355;
                                }
                                // End:0x355
                                if(Interactions[I].ShowIfNoModifier)
                                {
                                    Interactions[I].bAvailableNow = false;
                                    PossibleCoverActions.AddItem(Interactions[I]);
                                }
                            }
                            J0x355:

                            ++I;
                            // [Loop Continue]
                            goto J0x24B;
                        }
                        I = 0;
                        J0x366:

                        // End:0xE42 [Loop If]
                        if(I < PossibleCoverActions.Length)
                        {
                            // End:0x3DF
                            if(PossibleCoverActions[I].InteractName == 'CoverSlipLeft')
                            {
                                // End:0x3DF
                                if(SP.CanSlip() && SP.IsOnLeftSideOfCover())
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                            }
                            // End:0x44D
                            if(PossibleCoverActions[I].InteractName == 'CoverSlipRight')
                            {
                                // End:0x44A
                                if(SP.CanSlip() && !SP.IsOnLeftSideOfCover())
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x4DC
                            if(PossibleCoverActions[I].InteractName == 'CoverSwatVULeft')
                            {
                                // End:0x4D9
                                if((SP.CanSwatTurn(Info) && SP.IsOnLeftSideOfCover()) && int(SP.GetCoverOrientation()) == int(1))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x56D
                            if(PossibleCoverActions[I].InteractName == 'CoverSwatVURight')
                            {
                                // End:0x56A
                                if((SP.CanSwatTurn(Info) && !SP.IsOnLeftSideOfCover()) && int(SP.GetCoverOrientation()) == int(1))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x5FC
                            if(PossibleCoverActions[I].InteractName == 'CoverSwatVDLeft')
                            {
                                // End:0x5F9
                                if((SP.CanSwatTurn(Info) && SP.IsOnLeftSideOfCover()) && int(SP.GetCoverOrientation()) == int(2))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x68D
                            if(PossibleCoverActions[I].InteractName == 'CoverSwatVDRight')
                            {
                                // End:0x68A
                                if((SP.CanSwatTurn(Info) && !SP.IsOnLeftSideOfCover()) && int(SP.GetCoverOrientation()) == int(2))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x71C
                            if(PossibleCoverActions[I].InteractName == 'CoverSwatHLeft')
                            {
                                // End:0x719
                                if((SP.CanSwatTurn(Info) && SP.IsOnLeftSideOfCover()) && int(SP.GetCoverOrientation()) == int(0))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x7AD
                            if(PossibleCoverActions[I].InteractName == 'CoverSwatHRight')
                            {
                                // End:0x7AA
                                if((SP.CanSwatTurn(Info) && !SP.IsOnLeftSideOfCover()) && int(SP.GetCoverOrientation()) == int(0))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x819
                            if(PossibleCoverActions[I].InteractName == 'CoverDiveLeft')
                            {
                                // End:0x816
                                if(SP.CanDiveRoll() && SP.IsOnLeftSideOfCover())
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x887
                            if(PossibleCoverActions[I].InteractName == 'CoverDiveRight')
                            {
                                // End:0x884
                                if(SP.CanDiveRoll() && !SP.IsOnLeftSideOfCover())
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x8DE
                            if(PossibleCoverActions[I].InteractName == 'CoverStepUp')
                            {
                                // End:0x8DB
                                if(SP.CanStepUp())
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0x956
                            if(PossibleCoverActions[I].InteractName == 'CoverExitVU')
                            {
                                // End:0x953
                                if(SP.CanMantle() && int(SP.GetCoverOrientation()) == int(1))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0xA7C
                            if(PossibleCoverActions[I].InteractName == 'CoverMantleVU')
                            {
                                // End:0xA79
                                if((SP.CanMantle() && int(SP.GetCoverOrientation()) == int(1)) && ((SP.CurrentSlotPct < 0.5000000) && !SP.CurrentLink.Slots[SP.LeftSlotIdx].bHideMantleIcon) || (SP.CurrentSlotPct > 0.5000000) && !SP.CurrentLink.Slots[SP.RightSlotIdx].bHideMantleIcon)
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0xBAD
                            if(PossibleCoverActions[I].InteractName == 'CoverMantleVault')
                            {
                                // [Explicit Continue]
                                goto J0xE38;
                                // End:0xBAA
                                if(SP.CanMantle())
                                {
                                    // End:0xBAA
                                    if(SPC.PlayerCamera != none)
                                    {
                                        // End:0xB3E
                                        if(int(SP.GetCoverOrientation()) == int(1))
                                        {
                                            // End:0xB3B
                                            if((Vector(SPC.PlayerCamera.Rotation) Dot vect(0.0000000, 0.0000000, -1.0000000)) > 0.0000000)
                                            {
                                                PossibleCoverActions[I].bAvailableNow = true;
                                            }                                            
                                        }
                                        else
                                        {
                                            // End:0xBAA
                                            if(int(SP.GetCoverOrientation()) == int(2))
                                            {
                                                // End:0xBAA
                                                if((Vector(SPC.PlayerCamera.Rotation) Dot vect(0.0000000, 0.0000000, 1.0000000)) > 0.0000000)
                                                {
                                                    PossibleCoverActions[I].bAvailableNow = true;
                                                }
                                            }
                                        }
                                    }
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0xCD3
                            if(PossibleCoverActions[I].InteractName == 'CoverMantleVD')
                            {
                                // End:0xCD0
                                if((SP.CanMantle() && int(SP.GetCoverOrientation()) == int(2)) && ((SP.CurrentSlotPct < 0.5000000) && !SP.CurrentLink.Slots[SP.LeftSlotIdx].bHideMantleIcon) || (SP.CurrentSlotPct > 0.5000000) && !SP.CurrentLink.Slots[SP.RightSlotIdx].bHideMantleIcon)
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0xD4B
                            if(PossibleCoverActions[I].InteractName == 'CoverMantleH')
                            {
                                // End:0xD48
                                if(SP.CanMantle() && int(SP.GetCoverOrientation()) == int(0))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0xDC3
                            if(PossibleCoverActions[I].InteractName == 'CoverLedgeLeapUp')
                            {
                                // End:0xDC0
                                if(SP.CanPerformAdeptLedgeJump() && int(SP.GetCoverOrientation()) == int(1))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                                // [Explicit Continue]
                                goto J0xE38;
                            }
                            // End:0xE38
                            if(PossibleCoverActions[I].InteractName == 'CoverLedgeLeapDown')
                            {
                                // End:0xE38
                                if(SP.CanPerformAdeptLedgeJump() && int(SP.GetCoverOrientation()) == int(2))
                                {
                                    PossibleCoverActions[I].bAvailableNow = true;
                                }
                            }
                            J0xE38:

                            ++I;
                            // [Loop Continue]
                            goto J0x366;
                        }
                        bestprecedence = 65535;
                        bestlineprecedence = 65535;
                        bestindex = 0;
                        I = 0;
                        J0xE66:

                        // End:0xF69 [Loop If]
                        if(I < PossibleCoverActions.Length)
                        {
                            // End:0xF5F
                            if(PossibleCoverActions[I].bAvailableNow)
                            {
                                // End:0xEF6
                                if(PossibleCoverActions[I].Precedence < bestprecedence)
                                {
                                    bestprecedence = PossibleCoverActions[I].Precedence;
                                    bestlineprecedence = PossibleCoverActions[I].BindingPrecedence;
                                    bestindex = I;
                                    // [Explicit Continue]
                                    goto J0xF5F;
                                }
                                // End:0xF5F
                                if((PossibleCoverActions[I].Precedence == bestprecedence) && PossibleCoverActions[I].BindingPrecedence < bestlineprecedence)
                                {
                                    bestlineprecedence = PossibleCoverActions[I].BindingPrecedence;
                                    bestindex = I;
                                }
                            }
                            J0xF5F:

                            ++I;
                            // [Loop Continue]
                            goto J0xE66;
                        }
                        // End:0xF9F
                        if(PossibleCoverActions[bestindex].bAvailableNow)
                        {
                            CoverAction = PossibleCoverActions[bestindex].InteractName;
                        }
                        // End:0xFD6
                        if((CoverAction == 'CoverLedgeLeapUp') || CoverAction == 'CoverLedgeLeapDown')
                        {
                            CoverAction = 'None';
                        }
                    }
                }
            }
        }
    }
    // End:0xFF6
    if(CoverAction != OldCoverAction)
    {
        SetInteraction(CoverAction);
    }
    //return;    
}

function DrawEngineHUD()
{
    //return;    
}

exec function ToggleInfoHud()
{
    bShowInfoHud = !bShowInfoHud;
    //return;    
}

delegate DebugDraw(SkyHUD H)
{
    //return;    
}

function SetDebugDraw(delegate<DebugDraw> DebugDrawFunc, bool bAdd)
{
    local int Idx;

    Idx = DebugDrawList.Find(DebugDrawFunc);
    // End:0x42
    if(bAdd && Idx == -1)
    {
        DebugDrawList[DebugDrawList.Length] = DebugDrawFunc;        
    }
    else
    {
        // End:0x6A
        if(!bAdd && Idx != -1)
        {
            DebugDrawList.Remove(Idx, 1);
        }
    }
    //return;    
}

// Export USkyHUD::execUpdateHudWidgets(FFrame&, void* const)
native function UpdateHudWidgets();

// Export USkyHUD::execCheckController(FFrame&, void* const)
native function bool CheckController();

event CheckControllerTick()
{
    // End:0x17
    if(CheckController())
    {
        CheckInteractionModifiers();
    }
    //return;    
}

// Export USkyHUD::execDrawNecessaryWidgets(FFrame&, void* const)
native function DrawNecessaryWidgets();

event DrawDemoHUD()
{
    DrawNecessaryWidgets();
    //return;    
}

function SetHelpText(string Text, float TimeOut)
{
    HelpStringTimeout = TimeOut;
    // End:0x45
    if((HelpStringTimeout > float(0)) && lblHelpText != none)
    {
        LastHelpText = Text;
        lblHelpText.SetValue(Text);
    }
    //return;    
}

event DrawLoggingHUD()
{
    local SkyAIController AIC;
    local Pawn MyPawn;
    local bool bShowLogging;
    local Vector ScreenLoc;
    local int I;

    // End:0xDD
    if(ShouldDisplayDebug('listai'))
    {
        ScreenLoc.X = 400.0000000;
        ScreenLoc.Y = 0.0000000;
        Canvas.SetDrawColor(0, 255, 0);
        // End:0xDC
        foreach WorldInfo.AllControllers(Class'SkyAIController', AIC)
        {
            ScreenLoc.Y += float(15);
            Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            Canvas.DrawTextClipped("" $ string(AIC));            
        }        
    }
    // End:0x1BC
    if(ShouldDisplayDebug('listpawns'))
    {
        ScreenLoc.X = 600.0000000;
        ScreenLoc.Y = 0.0000000;
        Canvas.SetDrawColor(0, 255, 0);
        // End:0x1BB
        foreach WorldInfo.AllPawns(Class'Engine.Pawn', MyPawn)
        {
            ScreenLoc.Y += float(15);
            Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            Canvas.DrawTextClipped("" $ string(MyPawn));            
        }        
    }
    // End:0x42B
    if(ShouldDisplayDebug('Gangs'))
    {
        I = 0;
        J0x1D9:

        // End:0x42B [Loop If]
        if(I < WorldInfo.Game.TargetableActors.Length)
        {
            ScreenLoc = Canvas.Project(WorldInfo.Game.TargetableActors[I].Location);
            ScreenLoc.X += float(20);
            ScreenLoc.Y -= float(100);
            Canvas.SetDrawColor(255, 255, 255);
            Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            Canvas.DrawTextClipped("Targetable Actor: " $ string(WorldInfo.Game.TargetableActors[I]));
            ScreenLoc.Y -= float(15);
            Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            Canvas.DrawTextClipped("Team: " $ string(WorldInfo.Game.TargetableActors[I].GetTeamNum()));
            ScreenLoc.Y -= float(15);
            Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            Canvas.DrawTextClipped("GangName: " $ string(WorldInfo.Game.TargetableActors[I].GangName));
            I++;
            // [Loop Continue]
            goto J0x1D9;
        }
    }
    // End:0x8B9
    foreach WorldInfo.AllControllers(Class'SkyAIController', AIC)
    {
        // End:0x8B8
        if(AIC != none)
        {
            // End:0x46E
            if(AIC.bAILogging)
            {
                bShowLogging = true;
            }
            // End:0x8B8
            if(SkyBotControllerPilot(AIC) != none)
            {
                // End:0x8B8
                if((ShouldDisplayDebug('basicai')) && SkyBotControllerPilot(AIC).Pawn != none)
                {
                    ScreenLoc = Canvas.Project(SkyBotControllerPilot(AIC).Pawn.Location);
                    ScreenLoc.X += float(50);
                    ScreenLoc.Y -= float(100);
                    Canvas.SetDrawColor(255, 255, 255);
                    Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                    // End:0x63E
                    if((SkyBotControllerPilot(AIC).GetStateName() == 'FlyingEvade') || SkyBotControllerPilot(AIC).GetStateName() == 'FlyingEvadeHijackMe')
                    {
                        // End:0x5C8
                        if(SkyBotControllerPilot(AIC).bDoingHardEvade)
                        {
                            Canvas.SetDrawColor(255, 0, 0);
                        }
                        Canvas.DrawText((("STATE: " $ string(SkyBotControllerPilot(AIC).GetStateName())) $ " HardEvade: ") $ string(SkyBotControllerPilot(AIC).bDoingHardEvade), false);
                        Canvas.SetDrawColor(255, 255, 255);                        
                    }
                    else
                    {
                        // End:0x6C4
                        if(SkyBotControllerPilot(AIC).GetStateName() == 'FlyingFlyBy')
                        {
                            Canvas.DrawText((("STATE: " $ string(SkyBotControllerPilot(AIC).GetStateName())) $ " CurrentFlyByActor: ") $ string(SkyBotControllerPilot(AIC).CurrentFlyByActor), false);                            
                        }
                        else
                        {
                            Canvas.DrawTextClipped("State: " $ string(SkyBotControllerPilot(AIC).GetStateName()));
                        }
                    }
                    ScreenLoc.Y -= float(15);
                    Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                    Canvas.DrawTextClipped("Enemy: " $ string(SkyBotControllerPilot(AIC).Enemy));
                    ScreenLoc.Y -= float(15);
                    Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                    Canvas.DrawTextClipped("Controller: " $ string(AIC));
                    ScreenLoc.Y -= float(15);
                    Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                    // End:0x858
                    if(SkyBotControllerPilot(AIC).bCurrentlyAutoCorrecting)
                    {
                        Canvas.SetDrawColor(255, 0, 0);
                    }
                    Canvas.DrawTextClipped("bCurrentlyAutoCorrecting: " $ string(SkyBotControllerPilot(AIC).bCurrentlyAutoCorrecting));
                    Canvas.SetDrawColor(255, 255, 255);
                }
            }
        }        
    }    
    // End:0x918
    if(bShowLogging)
    {
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.SetPos(15.0000000, 30.0000000);
        Canvas.DrawTextClipped("AI LOGGING: ON");
    }
    //return;    
}

// Export USkyHUD::execDrawHUD(FFrame&, void* const)
native function DrawHUD();

event HandleDebugDraw()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x42 [Loop If]
    if(I < DebugDrawList.Length)
    {
        __DebugDraw__Delegate = DebugDrawList[I];
        DebugDraw(self);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event SetGripButton(string Button)
{
    // End:0x30D
    if((imgGripInstruct != none) && lblGripInstruct != none)
    {
        // End:0x99
        if(Button == "A")
        {
            imgGripInstruct.SetVisibility(bControllerConnected);
            lblGripInstruct.SetVisibility(!bControllerConnected);
            imgGripInstruct.SetValue(GripInstructionIcons[1]);
            lblGripInstruct.SetValue(GripInstructionStrings[1]);
            GripInstructionIcon = GripInstructionIcons[1];            
        }
        else
        {
            // End:0x11D
            if(Button == "B")
            {
                imgGripInstruct.SetVisibility(bControllerConnected);
                lblGripInstruct.SetVisibility(!bControllerConnected);
                imgGripInstruct.SetValue(GripInstructionIcons[2]);
                lblGripInstruct.SetValue(GripInstructionStrings[2]);
                GripInstructionIcon = GripInstructionIcons[2];                
            }
            else
            {
                // End:0x1A1
                if(Button == "X")
                {
                    imgGripInstruct.SetVisibility(bControllerConnected);
                    lblGripInstruct.SetVisibility(!bControllerConnected);
                    imgGripInstruct.SetValue(GripInstructionIcons[3]);
                    lblGripInstruct.SetValue(GripInstructionStrings[3]);
                    GripInstructionIcon = GripInstructionIcons[3];                    
                }
                else
                {
                    // End:0x225
                    if(Button == "Y")
                    {
                        imgGripInstruct.SetVisibility(bControllerConnected);
                        lblGripInstruct.SetVisibility(!bControllerConnected);
                        imgGripInstruct.SetValue(GripInstructionIcons[4]);
                        lblGripInstruct.SetValue(GripInstructionStrings[4]);
                        GripInstructionIcon = GripInstructionIcons[4];                        
                    }
                    else
                    {
                        // End:0x288
                        if(Button == "")
                        {
                            imgGripInstruct.SetVisibility(false);
                            lblGripInstruct.SetVisibility(false);
                            imgGripInstruct.SetValue(none);
                            lblGripInstruct.SetValue("");
                            GripInstructionIcon = none;                            
                        }
                        else
                        {
                            imgGripInstruct.SetVisibility(true);
                            lblGripInstruct.SetVisibility(false);
                            imgGripInstruct.SetValue(GripInstructionIcons[0]);
                            lblGripInstruct.SetValue("");
                            GripInstructionIcon = GripInstructionIcons[0];
                        }
                    }
                }
            }
        }
        lblGripInstruct.StringRenderComponent.SetColor(UIColors[DefaultHUDColorIndex]);
    }
    // End:0x393
    if((imgGripKeyboardBG != none) && MaterialInstance(imgGripKeyboardBG.ImageComponent.ImageRef.ImageTexture) != none)
    {
        MaterialInstance(imgGripKeyboardBG.ImageComponent.ImageRef.ImageTexture).SetVectorParameterValue('DrawColor', UIColors[DefaultHUDColorIndex]);
    }
    //return;    
}

// Export USkyHUD::execGetPawnMaxHealth(FFrame&, void* const)
native function int GetPawnMaxHealth();

function UpdateStamina()
{
    // End:0x84
    if((SkyAirVehicle(PlayerOwner.Pawn) != none) && SkyAirVehicle(PlayerOwner.Pawn).Driver != none)
    {
        StaminaValue = SkyAirVehicle(PlayerOwner.Pawn).SpecialManeuverFuelCur / SkyAirVehicle(PlayerOwner.Pawn).SpecialManeuverFuelMax;
    }
    HudLastStaminaValue = HudStaminaValue;
    HudStaminaValue = StaminaValue;
    //return;    
}

function DrawPrimary(Texture2D texPrimary, optional int Count, optional int countMax, optional bool infiniteAmmo = false)
{
    local float Scale, RadarScale, LeftPos, TopPos, fontOffsetX, fontOffsetY,
	    TexWidth, TvSafeOffsetX, TvSafeOffsetY;

    TvSafeOffsetX = 90.0000000;
    TvSafeOffsetY = 60.0000000;
    // End:0x2A
    if(texPrimary == none)
    {
        return;
    }
    Canvas.Font = Font;
    RadarScale = Canvas.ClipX / (float(1024) * 2.2500000);
    Scale = Canvas.ClipX / (float(1024) * 3.5000000);
    TexWidth = float(texPrimary.SizeX) * Scale;
    // End:0x137
    if(SkyAirVehicle(PlayerOwner.Pawn) != none)
    {
        LeftPos = ((Canvas.ClipX - (float(512) * RadarScale)) + (float(30) * RadarScale)) + float(20);
        TopPos = (80.0000000 * RadarScale) - float(25);
        fontOffsetX = LeftPos + float(5);
        fontOffsetY = TopPos + TexWidth;        
    }
    else
    {
        LeftPos = Canvas.ClipX - (float(350) * RadarScale);
        TopPos = 30.0000000;
        fontOffsetX = (LeftPos + TexWidth) + float(10);
        fontOffsetY = TopPos + float(5);
    }
    Canvas.SetPos(LeftPos - TvSafeOffsetX, TopPos + TvSafeOffsetY);
    // End:0x1E9
    if(Count == 0)
    {
        Canvas.SetDrawColor(255, 0, 0, byte(HudVisibility * float(255)));        
    }
    else
    {
        Canvas.SetDrawColor(255, 255, 255, byte(HudVisibility * float(255)));
    }
    Canvas.DrawTexture(texPrimary, Scale);
    // End:0x2D7
    if(infiniteAmmo == false)
    {
        // End:0x291
        if(countMax > 0)
        {
            Canvas.SetPos(fontOffsetX - TvSafeOffsetX, fontOffsetY + TvSafeOffsetY);
            Canvas.DrawText((string(Count) $ "/") $ string(countMax));            
        }
        else
        {
            Canvas.SetPos(fontOffsetX - TvSafeOffsetX, fontOffsetY + TvSafeOffsetY);
            Canvas.DrawText(string(Count));
        }        
    }
    HudLastPrimaryValue = HudPrimaryValue;
    HudPrimaryValue = Count;
    //return;    
}

function DrawSecondary(Texture2D texPrimary, optional int Count, optional int countMax, optional bool infiniteAmmo = false)
{
    local float Scale, RadarScale, LeftPos, TopPos, fontOffsetX, fontOffsetY,
	    TexWidth, TvSafeOffsetX, TvSafeOffsetY;

    TvSafeOffsetX = 90.0000000;
    TvSafeOffsetY = 60.0000000;
    // End:0x2A
    if(texPrimary == none)
    {
        return;
    }
    Canvas.Font = Font;
    RadarScale = Canvas.ClipX / (float(1024) * 2.2500000);
    Scale = Canvas.ClipX / (float(1024) * 3.5000000);
    TexWidth = float(texPrimary.SizeX) * Scale;
    // End:0x13E
    if(SkyAirVehicle(PlayerOwner.Pawn) != none)
    {
        LeftPos = ((Canvas.ClipX - (float(512) * RadarScale)) + (float(30) * RadarScale)) + float(20);
        TopPos = ((140.0000000 * RadarScale) + TexWidth) - float(25);
        fontOffsetX = LeftPos + float(5);
        fontOffsetY = TopPos + TexWidth;        
    }
    else
    {
        LeftPos = Canvas.ClipX - (float(350) * RadarScale);
        TopPos = (30.0000000 + TexWidth) + float(10);
        fontOffsetX = (LeftPos + TexWidth) + float(10);
        fontOffsetY = TopPos + float(5);
    }
    Canvas.SetPos(LeftPos - TvSafeOffsetX, TopPos + TvSafeOffsetY);
    // End:0x1FD
    if(Count == 0)
    {
        Canvas.SetDrawColor(255, 0, 0, byte(HudVisibility * float(255)));        
    }
    else
    {
        Canvas.SetDrawColor(255, 255, 255, byte(HudVisibility * float(255)));
    }
    Canvas.DrawTexture(texPrimary, Scale);
    // End:0x2EB
    if(infiniteAmmo == false)
    {
        // End:0x2A5
        if(countMax > 0)
        {
            Canvas.SetPos(fontOffsetX - TvSafeOffsetX, fontOffsetY + TvSafeOffsetY);
            Canvas.DrawText((string(Count) $ "/") $ string(countMax));            
        }
        else
        {
            Canvas.SetPos(fontOffsetX - TvSafeOffsetX, fontOffsetY + TvSafeOffsetY);
            Canvas.DrawText(string(Count));
        }        
    }
    HudLastSecondaryValue = HudSecondaryValue;
    HudSecondaryValue = Count;
    //return;    
}

event DrawReputation(int Points)
{
    local float Scale, LeftPos, TopPos, HealthDockWidth, HealthDockHeight, iconOffsetX,
	    iconOffsetY, fontOffsetX, fontOffsetY;

    Scale = Canvas.ClipX / float(1024 * 3);
    HealthDockWidth = 512.0000000 * Scale;
    HealthDockHeight = 512.0000000 * Scale;
    iconOffsetX = 0.2500000;
    iconOffsetY = 0.9000000;
    LeftPos = HealthDockLeftX + (HealthDockWidth * iconOffsetX);
    TopPos = HealthDockTopY + (HealthDockHeight * iconOffsetY);
    fontOffsetX = LeftPos + float(10);
    fontOffsetY = TopPos;
    Canvas.Font = Font;
    Canvas.SetPos(LeftPos, TopPos);
    Canvas.SetDrawColor(255, 255, 255, byte(HudVisibility * float(255)));
    Canvas.SetPos(fontOffsetX, fontOffsetY);
    Canvas.DrawText("Rep: " $ string(Points));
    //return;    
}

event DrawActorOverlays()
{
    local Vector ScreenPos;
    local SkyCamera SkyCam;
    local float Size, unused, Distance;
    local int distancefade;
    local float objHalfSpace;
    local SkyPawn_MP P;
    local Actor AutoAimTarget;
    local Vector HitLocation, HitNormal;
    local Actor HitActor;
    local TraceHitInfo HitInfo;
    local SkyAreaOfOperationVolume AOO;

    // End:0x85F
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        SkyCam = SkyCamera(PlayerOwner.PlayerCamera);
        // End:0x41
        if(SkyCam == none)
        {
            return;
        }
        // End:0x8A
        if(SkyPawn(PlayerOwner.Pawn) != none)
        {
            AutoAimTarget = SkyPawn(PlayerOwner.Pawn).AutoAimImpact.HitActor;
        }
        // End:0x85E
        foreach WorldInfo.AllPawns(Class'SkyPawn_MP', P)
        {
            // End:0x1A0
            if(P == PlayerOwner.Pawn)
            {
                // End:0x19C
                if(P.bAFK)
                {
                    Canvas.Font = Class'Engine.Engine'.static.GetLargeFont();
                    Canvas.SetDrawColor(0, 192, 0, 255);
                    Canvas.TextSize("-~= AFK =~-", Size, unused);
                    Canvas.SetPos((Canvas.ClipX / float(2)) - (Size / float(2)), Canvas.ClipY / float(2));
                    Canvas.DrawTextClipped("-~= AFK =~-");
                }
                continue;                
            }
            // End:0x1E8
            if((Vehicle(PlayerOwner.Pawn) != none) && P == Vehicle(PlayerOwner.Pawn).Driver)
            {
                continue;                
            }
            // End:0x2E3
            if((P.Health <= (P.HealthMax / 2)) && (int(P.GetTeamNum()) != int(PlayerOwner.GetTeamNum())) || int(P.GetTeamNum()) == int(255))
            {
                HitActor = PlayerOwner.Trace(HitLocation, HitNormal, P.Location, SkyCam.Location, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 8);
                // End:0x2E3
                if((HitActor == none) || HitActor == P)
                {
                    DrawInteraction(P, P);
                }
            }
            // End:0x32D
            if(PlayerOwner.Pawn != none)
            {
                Distance = VSize(P.Location - PlayerOwner.Pawn.Location);                
            }
            else
            {
                Distance = VSize(P.Location - PlayerOwner.Location);
            }
            // End:0x36F
            if(AutoAimTarget == P)
            {
                Distance = 0.0000000;
            }
            // End:0x48C
            if((int(P.GetTeamNum()) == int(PlayerOwner.GetTeamNum())) && int(P.GetTeamNum()) != int(255))
            {
                // End:0x40B
                if((P.DrivenVehicle == none) && Distance < TeammateNameDrawDistance)
                {
                    distancefade = int((float(255) * (TeammateNameDrawDistance - Distance)) / TeammateNameDrawDistance);                    
                }
                else
                {
                    // End:0x455
                    if((P.DrivenVehicle != none) && Distance < TeammateVehicleNameDrawDistance)
                    {
                        distancefade = int((float(255) * (TeammateVehicleNameDrawDistance - Distance)) / TeammateVehicleNameDrawDistance);                        
                    }
                    else
                    {
                        continue;                        
                    }
                }
                distancefade = Min(255, distancefade * 2);
                Canvas.SetDrawColor(0, 0, 255, byte(distancefade));                
            }
            else
            {
                // End:0x506
                if((P.Health <= 0) && Distance < DeadEnemyNameDrawDistance)
                {
                    distancefade = int((float(255) * (DeadEnemyNameDrawDistance - Distance)) / DeadEnemyNameDrawDistance);
                    distancefade = Min(255, distancefade * 2);
                    Canvas.SetDrawColor(255, 0, 0, byte(distancefade));                    
                }
                else
                {
                    // End:0x550
                    if((P.DrivenVehicle == none) && Distance < EnemyNameDrawDistance)
                    {
                        distancefade = int((float(255) * (EnemyNameDrawDistance - Distance)) / EnemyNameDrawDistance);                        
                    }
                    else
                    {
                        // End:0x59A
                        if((P.DrivenVehicle != none) && Distance < EnemyVehicleNameDrawDistance)
                        {
                            distancefade = int((float(255) * (EnemyVehicleNameDrawDistance - Distance)) / EnemyVehicleNameDrawDistance);                            
                        }
                        else
                        {
                            continue;                            
                        }
                    }
                    distancefade = Min(255, distancefade * 2);
                    Canvas.SetDrawColor(255, 0, 0, byte(distancefade));
                }
            }
            ScreenPos = P.Location;
            ScreenPos.Z = ScreenPos.Z + 150.0000000;
            ScreenPos = Canvas.Project(ScreenPos);
            objHalfSpace = Vector(SkyCam.Rotation) Dot (P.Location - SkyCam.Location);
            // End:0x85D
            if((((ScreenPos.X > float(0)) || ScreenPos.Y > float(0)) || ScreenPos.X < Canvas.ClipX) || ScreenPos.Y < Canvas.ClipY)
            {
                // End:0x6EE
                if(objHalfSpace < float(0))
                {
                    continue;                    
                }
                Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
                Canvas.TextSize(P.GetHumanReadableName(), Size, unused);
                Canvas.SetPos(ScreenPos.X - (Size / float(2)), ScreenPos.Y);
                Canvas.DrawTextClipped(P.GetHumanReadableName());
                // End:0x85D
                if(P.bAFK)
                {
                    Canvas.SetDrawColor(0, 192, 0, byte(distancefade));
                    Canvas.TextSize("-~= AFK =~-", Size, unused);
                    Canvas.SetPos(ScreenPos.X - (Size / float(2)), ScreenPos.Y + unused);
                    Canvas.DrawTextClipped("-~= AFK =~-");
                }
            }            
        }        
    }
    // End:0x8D1
    if((ShouldDisplayDebug('AOO')) && bShowDebugInfo)
    {
        // End:0x8D0
        foreach WorldInfo.AllActors(Class'SkyAreaOfOperationVolume', AOO)
        {
            AOO.DisplayDebug(self, ScreenPos.X, ScreenPos.Y);            
        }        
    }
    LastOverlayDraw = WorldInfo.TimeSeconds;
    //return;    
}

// Export USkyHUD::execDrawObjective(FFrame&, void* const)
native simulated function DrawObjective(int ObjectiveIdx);

function DrawWeaponPickup()
{
    local Actor TouchActor;
    local SkyPawn SP;
    local SkyWeaponPickup Pickup;
    local SkyWeaponPickupFactory PickupFact;
    local SkyPickup InvPickup;
    local SkyPickupFactory InvPickupFact;
    local class<SkyWeapon> GroundWeaponClass;
    local SkyWeapon GroundWeaponArchetype;
    local class<SkyWeapon> EquippedWeaponClass;
    local SkyWeapon EquippedWeaponArchetype;
    local class<SkyItem_RocketPack> RocketpackClass;
    local SkyItem_RocketPack RocketPackArchetype;
    local bool bCanSwitchWeapons, bCanPickupWeapon, bCanPickupAmmo, bSceneSwitch, bAmmoFullyMaxed;

    local int costindex;
    local SkyWeaponPickup BestPickup;
    local SkyWeaponPickupFactory BestPickupFact;
    local SkyPickup BestInvPickup;
    local SkyPickupFactory BestInvPickupFact;
    local float CurDist, bestDist;
    local bool InitBest;
    local SkyPlayerController SPC;
    local bool bNeedMoreAmmo;
    local SkyWeapon SkyWeap;
    local int AmmoToRefill;
    local WeaponHUDParam WHP;
    local bool bInCover;

    InitBest = false;
    SPC = SkyPlayerController(PlayerOwner);
    // End:0x65
    if((((PlayerOwner == none) || PlayerOwner.Pawn == none) || SkyPawnCoverUser(PlayerOwner.Pawn) == none) || SPC == none)
    {
        return;
    }
    SPC.BestPickup = none;
    bCanSwitchWeapons = false;
    bCanPickupWeapon = false;
    bCanPickupAmmo = false;
    bSceneSwitch = false;
    bAmmoFullyMaxed = false;
    bInCover = int(SkyPawnCoverUser(PlayerOwner.Pawn).GetCoverState()) != int(0);
    SP = SkyPawn(PlayerOwner.Pawn);
    // End:0xF7
    if(SP == none)
    {
        return;
    }
    // End:0x5AD
    foreach PlayerOwner.Pawn.TouchingActors(Class'Engine.Actor', TouchActor)
    {
        Pickup = SkyWeaponPickup(TouchActor);
        PickupFact = SkyWeaponPickupFactory(TouchActor);
        // End:0x156
        if(Pickup == none)
        {
            InvPickup = SkyPickup(TouchActor);
        }
        // End:0x171
        if(PickupFact == none)
        {
            InvPickupFact = SkyPickupFactory(TouchActor);
        }
        // End:0x32A
        if((Pickup != none) || PickupFact != none)
        {
            // End:0x1DE
            if((Pickup != none) && Pickup.CanGive(SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)))
            {
                GroundWeaponClass = class<SkyWeapon>(Pickup.InventoryClass);                
            }
            else
            {
                // End:0x235
                if((PickupFact != none) && PickupFact.CanGive(SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)))
                {
                    GroundWeaponClass = PickupFact.SpawnedArchetype.Class;
                }
            }
            // End:0x244
            if(GroundWeaponClass == none)
            {
                continue;                
            }
            CurDist = VSize(TouchActor.Location - SP.Location);
            // End:0x2CB
            if((Pickup != none) && !InitBest || CurDist < bestDist)
            {
                bestDist = CurDist;
                BestPickup = Pickup;
                SPC.BestPickup = Pickup;
                InitBest = true;                
            }
            else
            {
                // End:0x327
                if((PickupFact != none) && !InitBest || CurDist < bestDist)
                {
                    bestDist = CurDist;
                    BestPickupFact = PickupFact;
                    SPC.BestPickup = PickupFact;
                    InitBest = true;
                }
            }
            // End:0x5AC
            continue;
        }
        // End:0x5AC
        if((InvPickup != none) || InvPickupFact != none)
        {
            // End:0x3B1
            if((InvPickup != none) && InvPickup.CanGive(SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)))
            {
                RocketpackClass = class<SkyItem_RocketPack>(InvPickup.InventoryClass);
                RocketPackArchetype = SkyItem_RocketPack(InvPickup.DroppedItemArchetype);                
            }
            else
            {
                // End:0x427
                if((SkyInvPickupFactory(InvPickupFact) != none) && InvPickupFact.CanGive(SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)))
                {
                    RocketpackClass = class<SkyItem_RocketPack>(InvPickupFact.InventoryType);
                    RocketPackArchetype = SkyItem_RocketPack(SkyInvPickupFactory(InvPickupFact).SpawnedInvArchetype);
                }
            }
            // End:0x458
            if(SkyBonusPickupFactory(InvPickupFact) != none)
            {
                // End:0x455
                if(!SkyBonusPickupFactory(InvPickupFact).bRequiresButtonPress)
                {
                    continue;                    
                }                
            }
            else
            {
                // End:0x467
                if(RocketpackClass == none)
                {
                    continue;                    
                }
            }
            // End:0x4A3
            if(SP.RocketPack != none)
            {
                // End:0x4A3
                if(SP.RocketPack.ObjectArchetype == RocketPackArchetype)
                {
                    continue;                    
                }
            }
            CurDist = VSize(TouchActor.Location - PlayerOwner.Pawn.Location);
            // End:0x542
            if((InvPickup != none) && !InitBest || CurDist < bestDist)
            {
                bestDist = CurDist;
                BestInvPickup = InvPickup;
                BestPickup = none;
                BestPickupFact = none;
                SPC.BestPickup = InvPickup;
                InitBest = true;
                // End:0x5AC
                continue;
            }
            // End:0x5AC
            if((InvPickupFact != none) && !InitBest || CurDist < bestDist)
            {
                bestDist = CurDist;
                BestInvPickupFact = InvPickupFact;
                BestPickup = none;
                BestPickupFact = none;
                SPC.BestPickup = InvPickupFact;
                InitBest = true;
            }
        }        
    }    
    // End:0xDC0
    if((BestPickup != none) || BestPickupFact != none)
    {
        // End:0x635
        if((BestPickup != none) && BestPickup.CanGive(SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)))
        {
            GroundWeaponClass = class<SkyWeapon>(BestPickup.InventoryClass);
            GroundWeaponArchetype = SkyWeapon(BestPickup.DroppedItemArchetype);            
        }
        else
        {
            // End:0x6A1
            if((BestPickupFact != none) && BestPickupFact.CanGive(SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)))
            {
                GroundWeaponClass = BestPickupFact.SpawnedArchetype.Class;
                GroundWeaponArchetype = BestPickupFact.SpawnedArchetype;
            }
        }
        // End:0x737
        if(GroundWeaponArchetype.bIsSecondaryWeapon && SP.SecondaryWeapon != none)
        {
            EquippedWeaponClass = class<SkyWeapon>(SP.SecondaryWeapon.Class);
            EquippedWeaponArchetype = SkyWeapon(SP.SecondaryWeapon);
            bAmmoFullyMaxed = SkyWeapon(SP.SecondaryWeapon).AmmoFullyMaxed(0);            
        }
        else
        {
            // End:0x7CC
            if(!GroundWeaponArchetype.bIsSecondaryWeapon && SP.Weapon != none)
            {
                EquippedWeaponClass = class<SkyWeapon>(SP.Weapon.Class);
                EquippedWeaponArchetype = SkyWeapon(SP.Weapon);
                bAmmoFullyMaxed = SkyWeapon(SP.Weapon).AmmoFullyMaxed(0);
            }
        }
        // End:0xBC2
        if((GroundWeaponClass == EquippedWeaponClass) || (SP.BackWeapon != none) && GroundWeaponClass == SP.BackWeapon.Class)
        {
            // End:0x8A1
            if((GroundWeaponClass == EquippedWeaponClass) && GroundWeaponArchetype.bIsSecondaryWeapon)
            {
                SkyWeap = SkyWeapon(SP.SecondaryWeapon);
                bNeedMoreAmmo = ((SkyWeap == none) || SkyWeap.AmmoCount < SkyWeap.MaxAmmoCount) || SkyWeap.bForceRefillOnTouch;                
            }
            else
            {
                // End:0x959
                if(GroundWeaponClass == EquippedWeaponClass)
                {
                    SkyWeap = SkyWeapon(SP.Weapon);
                    bNeedMoreAmmo = (((SkyWeap == none) || !SkyWeap.HasFullAmmo()) || SkyWeap.AdditionalAmmo < SkyWeap.MaxAdditionalAmmo) || SkyWeap.bForceRefillOnTouch && SP.NeedsAmmo(SP.Weapon);                    
                }
                else
                {
                    SkyWeap = SkyWeapon(SP.BackWeapon);
                    bNeedMoreAmmo = (((SkyWeap == none) || !SkyWeap.HasFullAmmo()) || SkyWeap.AdditionalAmmo < SkyWeap.MaxAdditionalAmmo) || SkyWeap.bForceRefillOnTouch && SP.NeedsAmmo(SP.BackWeapon);
                }
            }
            // End:0xB67
            if(bNeedMoreAmmo)
            {
                // End:0xAB8
                if(BestPickupFact != none)
                {
                    // End:0xA3E
                    if(SkyWeap.bForceRefillOnTouch)
                    {
                        SkyWeap.Loaded(true);                        
                    }
                    else
                    {
                        AmmoToRefill = GroundWeaponArchetype.MaxAmmoCount + GroundWeaponArchetype.AdditionalAmmo;
                        SkyInventoryManager(SP.InvManager).AddAmmoToWeapon(AmmoToRefill, GroundWeaponArchetype.Class, false);
                    }
                    BestPickupFact.PickedUpBy(SP);                    
                }
                else
                {
                    // End:0xB59
                    if(BestPickup != none)
                    {
                        // End:0xAEE
                        if(SkyWeap.bForceRefillOnTouch)
                        {
                            SkyWeap.Loaded(true);                            
                        }
                        else
                        {
                            AmmoToRefill = BestPickup.ContainedAmmo;
                            SkyInventoryManager(SP.InvManager).AddAmmoToWeapon(AmmoToRefill, class<SkyWeapon>(BestPickup.InventoryClass), false);
                        }
                        BestPickup.PickedUpBy(SP);
                    }
                }
                HudIdleTime = 0.0000000;                
            }
            else
            {
                bCanPickupAmmo = true;
                bAmmoFullyMaxed = true;
                // End:0xBAE
                if(GetWeaponParam(GroundWeaponArchetype.WeaponName, WHP))
                {
                    TexGroundWeapon = WHP.PickupTexture;
                }
                SPC.BestPickup = none;
            }            
        }
        else
        {
            // End:0xD0A
            if(((EquippedWeaponClass != none) && GroundWeaponClass != none) && !bInCover)
            {
                // End:0xC23
                if((EquippedWeaponName != EquippedWeaponArchetype.DisplayIcon) || GroundWeaponName != GroundWeaponArchetype.DisplayIcon)
                {
                    bSceneSwitch = true;
                }
                HudIdleTime = 0.0000000;
                EquippedWeaponName = EquippedWeaponArchetype.DisplayIcon;
                // End:0xC7A
                if(GetWeaponParam(EquippedWeaponArchetype.WeaponName, WHP))
                {
                    TexEquippedWeapon = WHP.PickupTexture;
                }
                GroundWeaponName = GroundWeaponArchetype.DisplayIcon;
                // End:0xCC6
                if(GetWeaponParam(GroundWeaponArchetype.WeaponName, WHP))
                {
                    TexGroundWeapon = WHP.PickupTexture;
                }
                WeaponSwapCost = "" $ string(GroundWeaponArchetype.RepCost);
                // End:0xCFF
                if(GroundWeaponArchetype.bIsSecondaryWeapon)
                {
                    bCanPickupWeapon = true;                    
                }
                else
                {
                    bCanSwitchWeapons = true;
                }                
            }
            else
            {
                // End:0xDBD
                if((GroundWeaponClass != none) && !bInCover)
                {
                    // End:0xD43
                    if(GroundWeaponName != GroundWeaponArchetype.DisplayIcon)
                    {
                        bSceneSwitch = true;
                    }
                    HudIdleTime = 0.0000000;
                    GroundWeaponName = GroundWeaponArchetype.DisplayIcon;
                    // End:0xD9A
                    if(GetWeaponParam(GroundWeaponArchetype.WeaponName, WHP))
                    {
                        TexGroundWeapon = WHP.PickupTexture;
                    }
                    WeaponSwapCost = "" $ string(GroundWeaponArchetype.RepCost);
                    bCanPickupWeapon = true;
                }
            }
        }        
    }
    else
    {
        // End:0xFC2
        if(!bInCover && (BestInvPickup != none) || BestInvPickupFact != none)
        {
            // End:0xE54
            if((BestInvPickup != none) && BestInvPickup.CanGive(SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)))
            {
                RocketpackClass = class<SkyItem_RocketPack>(BestInvPickup.InventoryClass);
                RocketPackArchetype = SkyItem_RocketPack(BestInvPickup.DroppedItemArchetype);                
            }
            else
            {
                // End:0xECA
                if((SkyInvPickupFactory(BestInvPickupFact) != none) && BestInvPickupFact.CanGive(SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)))
                {
                    RocketpackClass = class<SkyItem_RocketPack>(BestInvPickupFact.InventoryType);
                    RocketPackArchetype = SkyItem_RocketPack(SkyInvPickupFactory(BestInvPickupFact).SpawnedInvArchetype);
                }
            }
            // End:0xFC2
            if((RocketpackClass != none) && RocketPackArchetype != none)
            {
                // End:0xF3F
                if(SP.RocketPack == none)
                {
                    HudIdleTime = 0.0000000;
                    GroundWeaponName = RocketPackArchetype.DisplayText;
                    TexGroundWeapon = RocketPackArchetype.DisplayTexture;
                    bCanPickupWeapon = true;
                    bSceneSwitch = true;                    
                }
                else
                {
                    HudIdleTime = 0.0000000;
                    EquippedWeaponName = SP.RocketPack.DisplayText;
                    TexEquippedWeapon = SP.RocketPack.DisplayTexture;
                    GroundWeaponName = RocketPackArchetype.DisplayText;
                    TexGroundWeapon = RocketPackArchetype.DisplayTexture;
                    bCanSwitchWeapons = true;
                    bSceneSwitch = true;
                }
            }
        }
    }
    // End:0xFEB
    if(bInCover)
    {
        bCanSwitchWeapons = false;
        bCanPickupWeapon = false;
        bCanPickupAmmo = false;
        bSceneSwitch = true;
    }
    // End:0x1089
    if((bCanSwitchWeapons || bCanPickupWeapon) && GroundWeaponClass != none)
    {
        // End:0x1082
        if(SkyGameReplicationInfo(WorldInfo.GRI).bUseRep && PickupFact != none)
        {
            // End:0x1077
            if(GroundWeaponClass.default.RepCost <= SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).ReputationPoints)
            {
                costindex = 1;                
            }
            else
            {
                costindex = 2;
            }            
        }
        else
        {
            costindex = 0;
        }
    }
    DisplayWeaponPickupUIScene(bCanSwitchWeapons, bCanPickupWeapon, bCanPickupAmmo, bSceneSwitch, costindex, bAmmoFullyMaxed);
    //return;    
}

function DisplayWeaponPickupUIScene(bool CanSwitchWeapons, bool CanPickupWeapon, bool CanPickupAmmo, bool SceneSwitch, int costindex, bool bAmmoFull)
{
    local name CurrentInteractionName;
    local SkyPlayerController SPC;

    SPC = SkyPlayerController(PlayerOwner);
    // End:0x1D
    if(SPC == none)
    {
        return;
    }
    bSceneWeaponSwitch = false;
    bSceneWeaponPickup = false;
    bSceneWeaponAmmoPickup = false;
    bSceneWeaponAmmoPickupFull = false;
    // End:0x6B
    if((CurrentInteractionText != "") || bDrawingMelee)
    {
        pnlInteract.SetVisibility(false);
        return;
    }
    // End:0xB1
    if(CanSwitchWeapons && SPC.CanPickupWeapon())
    {
        SetInteraction('WeapSwap',, TexGroundWeapon);
        bSceneWeaponSwitch = true;        
    }
    else
    {
        // End:0xF7
        if(CanPickupWeapon && SPC.CanPickupWeapon())
        {
            SetInteraction('WeapPickup',, TexGroundWeapon);
            bSceneWeaponPickup = true;            
        }
        else
        {
            // End:0x16A
            if(CanPickupAmmo && SPC.CanPickupWeapon())
            {
                // End:0x146
                if(bAmmoFull)
                {
                    bSceneWeaponAmmoPickupFull = true;
                    SetInteraction('WeapAmmoFull',, TexGroundWeapon);                    
                }
                else
                {
                    SetInteraction('WeapAmmo',, TexGroundWeapon);
                    bSceneWeaponAmmoPickup = true;
                }                
            }
            else
            {
                // End:0x24A
                if(CoverAction == 'None')
                {
                    CurrentInteractionName = Interactions[CurrentInteraction].InteractName;
                    // End:0x24A
                    if(((((CurrentInteractionName == 'WeapSwap') || CurrentInteractionName == 'WeapPickup') || CurrentInteractionName == 'WeapAmmoFull') || CurrentInteractionName == 'WeapAmmo') || CurrentInteractionName == 'WeapLocker')
                    {
                        // End:0x235
                        if(CurrentInteractionName == 'WeapLocker')
                        {
                            Class'SkyHUD'.static.OpenPickupTutorial('WeaponLocker', SPC);
                        }
                        SetInteraction('None');
                    }
                }
            }
        }
    }
    LastCostIndex = costindex;
    //return;    
}

event bool TryDrawInteractionIcon(Vector vWorldPosition, SkyInteractor OwnerInteractor)
{
    local SkyInteraction Interaction;
    local Actor actorIndicator;

    // End:0x0D
    if(OwnerInteractor == none)
    {
        return false;
    }
    Interaction = OwnerInteractor.GetCachedInteraction();
    // End:0xE8
    if((Interaction != none) && Interaction.bUseIndicator)
    {
        actorIndicator = OwnerInteractor.CachedTarget;
        // End:0xBA
        if((Interaction != none) && Interaction.bIndicatorOnVehicle)
        {
            // End:0xBA
            if(SkyArchonPilot(OwnerInteractor.CachedTarget) != none)
            {
                actorIndicator = SkyArchonPilot(OwnerInteractor.CachedTarget).PilotedPawn;
            }
        }
        return SetIndicatorOverride(Interaction.IndicatorToOverride, actorIndicator, Interaction.szCommand);
    }
    return false;
    //return ReturnValue;    
}

// Export USkyHUD::execGetKeyboardStringForCommand(FFrame&, void* const)
native function string GetKeyboardStringForCommand(name Command, optional int List = -1);

event DrawInteraction(SkyInteractor TargetInteractor, SkyInteractor OwnerInteractor)
{
    local Vector Offset;
    local Surface Icon;

    // End:0x0D
    if(TargetInteractor == none)
    {
        return;
    }
    // End:0x37
    if(TryDrawInteractionIcon(TargetInteractor.GetTargetLocation(none), OwnerInteractor))
    {
        return;
    }
    Offset.X = 0.0000000;
    Offset.Y = 0.0000000;
    Offset.Z = 80.0000000;
    Icon = GetInputButtonForCommand("bActionButton");
    // End:0xFF
    if(Icon != none)
    {
        DrawIconAtActor(TargetInteractor, Icon, "", FloatingInteractButtonScale, false, Offset, PlayerOwner.Pawn.IsTimerActive(PlayerOwner.Pawn.InteractionTimerName));        
    }
    else
    {
        // End:0x125
        if(InteractionKeyString == "")
        {
            InteractionKeyString = GetKeyboardStringForCommand('bActionButton');
        }
        DrawIconAtActor(TargetInteractor, none, InteractionKeyString, FloatingInteractButtonScale, false, Offset, PlayerOwner.Pawn.IsTimerActive(PlayerOwner.Pawn.InteractionTimerName));
    }
    //return;    
}

event DrawIconAtLocation(Vector WorldPos, Surface Icon, string Text, float iconScale, bool bLockToVertical, optional Vector Offset, optional bool bDisabled)
{
    local Vector targetDiff, Vertical, ScreenPos;
    local float halfSpace;
    local SkyCamera SkyCam;
    local MaterialInstanceConstant mic;
    local float resScale, XL, YL;

    // End:0x1D
    if((Icon == none) && Text == "")
    {
        return;
    }
    // End:0xA8
    if(bLockToVertical)
    {
        Vertical.X = 0.0000000;
        Vertical.Y = 0.0000000;
        Vertical.Z = 1.0000000;
        targetDiff = ProjectOnTo(WorldPos - PawnOwner.Location, Vertical);
        WorldPos = PawnOwner.Location + targetDiff;
    }
    WorldPos += Offset;
    // End:0xFA
    if(PlayerController(PawnOwner.Controller) != none)
    {
        SkyCam = SkyCamera(PlayerController(PawnOwner.Controller).PlayerCamera);        
    }
    else
    {
        // End:0x168
        if((PawnOwner.DrivenVehicle != none) && PlayerController(PawnOwner.DrivenVehicle.Controller) != none)
        {
            SkyCam = SkyCamera(PlayerController(PawnOwner.DrivenVehicle.Controller).PlayerCamera);
        }
    }
    // End:0x175
    if(SkyCam == none)
    {
        return;
    }
    iconScale = (iconScale * Canvas.ClipY) / float(720);
    ScreenPos = Canvas.Project(WorldPos);
    halfSpace = Vector(SkyCam.Rotation) Dot (WorldPos - SkyCam.Location);
    // End:0x274
    if(((((ScreenPos.X < float(0)) || ScreenPos.Y < float(0)) || ScreenPos.X > Canvas.ClipX) || ScreenPos.Y > Canvas.ClipY) || halfSpace < float(0))
    {        
    }
    else
    {
        Canvas.DrawColor.A = 255;
        Canvas.DrawColor.R = 255;
        Canvas.DrawColor.G = 255;
        Canvas.DrawColor.B = 255;
        // End:0x50C
        if(Icon != none)
        {
            Canvas.SetPos(ScreenPos.X - ((Icon.GetSurfaceWidth() * iconScale) / float(2)), ScreenPos.Y - (Icon.GetSurfaceHeight() * iconScale));
            // End:0x3E0
            if(Texture2D(Icon) != none)
            {
                Canvas.DrawTile(Texture2D(Icon), Icon.GetSurfaceWidth() * iconScale, Icon.GetSurfaceHeight() * iconScale, 0.0000000, 0.0000000, Icon.GetSurfaceWidth(), Icon.GetSurfaceHeight());                
            }
            else
            {
                // End:0x509
                if(MaterialInterface(Icon) != none)
                {
                    // End:0x4AD
                    if(bDisabled)
                    {
                        mic = new (Outer) Class'Engine.MaterialInstanceConstant';
                        mic.SetParent(MaterialInterface(Icon));
                        mic.SetVectorParameterValue('DrawColor', UIColors[DisabledColorIndex]);
                        Canvas.DrawMaterialTile(mic, Icon.GetSurfaceWidth() * iconScale, Icon.GetSurfaceHeight() * iconScale, 0.0000000, 0.0000000, 1.0000000, 1.0000000);                        
                    }
                    else
                    {
                        Canvas.DrawMaterialTile(MaterialInterface(Icon), Icon.GetSurfaceWidth() * iconScale, Icon.GetSurfaceHeight() * iconScale, 0.0000000, 0.0000000, 1.0000000, 1.0000000);
                    }
                }
            }            
        }
        else
        {
            // End:0x8D7
            if(Text != "")
            {
                Canvas.Font = InteractionFont;
                Canvas.TextSize(Text, XL, YL);
                resScale = Canvas.ClipX / float(720);
                resScale = 1.0000000 + ((resScale - float(1)) / float(3));
                // End:0x717
                if((imgInteractKeyboardBG != none) && MaterialInstance(imgInteractKeyboardBG.ImageComponent.ImageRef.ImageTexture) != none)
                {
                    MaterialInstance(imgInteractKeyboardBG.ImageComponent.ImageRef.ImageTexture).SetVectorParameterValue('DrawColor', UIColors[((bDisabled) ? DisabledColorIndex : DefaultHUDColorIndex)]);
                    Canvas.SetPos(ScreenPos.X - ((resScale * (float(28) + (XL / 1.5000000))) * iconScale), ScreenPos.Y - ((resScale * (float(52) + (YL / float(2)))) * iconScale));
                    Canvas.DrawMaterialTile(MaterialInstance(imgInteractKeyboardBG.ImageComponent.ImageRef.ImageTexture), ((resScale * (51.0000000 + XL)) * 1.3300000) * iconScale, (resScale * (45.0000000 + YL)) * iconScale, 0.0000000, 0.0000000, 1.0000000, 1.0000000);
                }
                Canvas.DrawColor.R = byte(UIColors[((bDisabled) ? DisabledColorIndex : DefaultHUDColorIndex)].R * float(255));
                Canvas.DrawColor.G = byte(UIColors[((bDisabled) ? DisabledColorIndex : DefaultHUDColorIndex)].G * float(255));
                Canvas.DrawColor.B = byte(UIColors[((bDisabled) ? DisabledColorIndex : DefaultHUDColorIndex)].B * float(255));
                Canvas.DrawColor.A = byte(UIColors[((bDisabled) ? DisabledColorIndex : DefaultHUDColorIndex)].A * float(255));
                Canvas.SetPos(ScreenPos.X - ((resScale * (XL / float(2))) * iconScale), ScreenPos.Y - ((resScale * (float(36) + (YL / float(2)))) * iconScale));
                Canvas.DrawText(Text,, resScale * iconScale, resScale * iconScale, 3);
            }
        }
    }
    //return;    
}

simulated function DrawIconAtActor(Actor actortarget, Surface Icon, string Text, float iconScale, bool bLockToVertical, optional Vector Offset, optional bool bDisabled)
{
    // End:0x37
    if((((Icon == none) && Text == "") || actortarget == none) || PawnOwner == none)
    {
        return;
    }
    // End:0x65
    if((SkyPawn(actortarget) != none) && SkyPawn(actortarget).Health <= 0)
    {
        return;
    }
    DrawIconAtLocation(actortarget.GetTargetLocation(none), Icon, Text, iconScale, bLockToVertical, Offset, bDisabled);
    //return;    
}

function DrawVehicleOverlay()
{
    local SkyPlayerController SPC;

    SPC = SkyPlayerController(PlayerOwner);
    // End:0x7F
    if(SkyAirVehicle(SPC.Pawn) != none)
    {
        // End:0x59
        if(!SkyAirVehicle(SPC.Pawn).bFlying)
        {
            bSceneTakeOffMessage = true;            
        }
        else
        {
            bSceneTakeOffMessage = false;
        }
        // End:0x7C
        if(SPC.bWantToLeave)
        {
            bSceneExitAircraftMessage = true;
        }        
    }
    else
    {
        bSceneTakeOffMessage = false;
    }
    // End:0xA4
    if(!SPC.bWantToLeave)
    {
        bSceneExitAircraftMessage = false;
    }
    // End:0xC2
    if(SPC.bWantRocketpackThrust)
    {
        bSceneVerifyThrustMessage = true;        
    }
    else
    {
        bSceneVerifyThrustMessage = false;
    }
    //return;    
}

event DrawHUDOverlays()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x36 [Loop If]
    if(I < HUDOverlays.Length)
    {
        DrawHUDOverlay(HUDOverlays[I]);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function DrawHUDOverlay(SkyHUDOverlay overlay)
{
    local float matWidth, matHeight;

    // End:0x17
    if(overlay.MatInstance == none)
    {
        return;
    }
    matWidth = overlay.Width * Canvas.ClipX;
    matHeight = overlay.Height * Canvas.ClipY;
    Canvas.SetPos((overlay.XLoc - (overlay.Width / float(2))) * Canvas.ClipX, (overlay.YLoc - (overlay.Height / float(2))) * Canvas.ClipY);
    overlay.MatInstance.SetScalarParameterValue('Fade', overlay.MaterialAlpha / float(255));
    overlay.MatInstance.SetScalarParameterValue('Wipe', overlay.MaterialWipe);
    Canvas.DrawMaterialTile(overlay.MatInstance, matWidth, matHeight, 0.0000000, 0.0000000, 1.0000000, 1.0000000);
    //return;    
}

event DrawHUDVariableMaterials()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x36 [Loop If]
    if(I < HudVariableMaterials.Length)
    {
        DrawHUDVariableMaterial(HudVariableMaterials[I]);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function DrawHUDVariableMaterial(SkyVariableMaterial Material)
{
    local int I;
    local float T, numer, denom, TimeSinceStart, interpValue;

    TimeSinceStart = WorldInfo.TimeSeconds - Material.StartTime;
    I = 0;
    J0x2D:

    // End:0x37C [Loop If]
    if(I < Material.Params.Length)
    {
        // End:0x372
        if(Material.Params[I].Active)
        {
            // End:0x11E
            if(!Material.Params[I].DisableStartValueClamp && Material.Params[I].StartTime > TimeSinceStart)
            {
                Material.MaterialInstance.SetScalarParameterValue(Material.Params[I].ParameterName, Material.Params[I].StartValue);
                // [Explicit Continue]
                goto J0x372;
            }
            // End:0x1D1
            if(!Material.Params[I].DisableEndValueClamp && TimeSinceStart > Material.Params[I].EndTime)
            {
                Material.MaterialInstance.SetScalarParameterValue(Material.Params[I].ParameterName, Material.Params[I].EndValue);
                // [Explicit Continue]
                goto J0x372;
            }
            // End:0x372
            if((TimeSinceStart >= Material.Params[I].StartTime) && TimeSinceStart <= Material.Params[I].EndTime)
            {
                T = TimeSinceStart - Material.Params[I].StartTime;
                numer = Material.Params[I].EndValue - Material.Params[I].StartValue;
                denom = Material.Params[I].EndTime - Material.Params[I].StartTime;
                // End:0x2F4
                if(denom == float(0))
                {
                    // [Explicit Continue]
                    goto J0x372;
                }
                interpValue = Material.Params[I].StartValue + (T * (numer / denom));
                Material.MaterialInstance.SetScalarParameterValue(Material.Params[I].ParameterName, interpValue);
            }
        }
        J0x372:

        I++;
        // [Loop Continue]
        goto J0x2D;
    }
    // End:0x3E3
    if(Material.bFullScreenSizeOverride)
    {
        Canvas.DrawMaterialTile(Material.MaterialInstance, Canvas.ClipX, Canvas.ClipY, 0.0000000, 0.0000000, 1.0000000, 1.0000000);        
    }
    else
    {
        Canvas.DrawMaterialTile(Material.MaterialInstance, Material.LocX, Material.LocY, Material.mWidth, Material.mHeight, 1.0000000, 1.0000000);
    }
    //return;    
}

exec function ShowSecondaryWeapAnimDebug()
{
    //return;    
}

exec function ToggleObjectiveHUD()
{
    bShowObjectiveHUD = !bShowObjectiveHUD;
    //return;    
}

exec function ShowVehicleDebugInfo()
{
    bDisplayVehicleDebugText = !bDisplayVehicleDebugText;
    //return;    
}

exec function FadeHUDTo(float Visibility, optional float fadeDelay)
{
    // End:0x12
    if(HudVisibility == Visibility)
    {
        return;
    }
    // End:0x2F
    if(Visibility < 0.0000000)
    {
        HudVisibility = 0.0000000;        
    }
    else
    {
        // End:0x4C
        if(Visibility > 1.0000000)
        {
            HudVisibility = 1.0000000;            
        }
        else
        {
            HudVisibility = Visibility;
        }
    }
    //return;    
}

exec function VDebug(optional name DebugType)
{
    // End:0x4B
    if(DebugType == 'None')
    {
        // End:0x35
        if(ShouldDisplayDebug('Vehicle'))
        {
            bShowDebugInfo = true;            
        }
        else
        {
            ShowDebug('Vehicle');
        }        
    }
    else
    {
        ShowDebug(name("v" $ string(DebugType)));
    }
    SaveConfig();
    //return;    
}

function DisplayHit(Vector HitDir, int Damage, class<DamageType> DamageType, optional Pawn InstigatedBy)
{
    local int InsertIndex;

    // End:0x34
    if(DamageIndicatorWidget != none)
    {
        DamageIndicatorWidget.TrackDamage(HitDir, Damage, DamageType, InstigatedBy);
    }
    InsertIndex = DmgArrows.Length;
    DmgArrows.Insert(InsertIndex, 1);
    DmgArrows[InsertIndex].HitDir = HitDir;
    DmgArrows[InsertIndex].TimeOfImpact = WorldInfo.TimeSeconds;
    DmgArrows[InsertIndex].Damage = Damage;
    DmgArrows[InsertIndex].Attacker = InstigatedBy;
    DmgArrows[InsertIndex].ArrowAlpha = 255;
    //return;    
}

function UIInteraction GetUIController(optional out LocalPlayer LP)
{
    LP = LocalPlayer(PlayerOwner.Player);
    // End:0x40
    if(LP != none)
    {
        return LP.ViewportClient.UIController;
    }
    return none;
    //return ReturnValue;    
}

event Destroyed()
{
    local GameUISceneClient sc;

    sc = Class'Engine.UIRoot'.static.GetSceneClient();
    // End:0x45
    if((sc != none) && HudScene != none)
    {
        sc.CloseScene(HudScene, true);
    }
    NotifyPotentialActorsOfHudDestroy();
    // End:0x6A
    if(NearDeathSound != none)
    {
        NearDeathSound.Stop();
    }
    super.Destroyed();
    //return;    
}

function CreateHudScene()
{
    local LocalPlayer LP;
    local UIScene Scene;
    local GameUISceneClient sc;

    LP = LocalPlayer(PlayerOwner.Player);
    sc = Class'Engine.UIRoot'.static.GetSceneClient();
    // End:0x109
    if(sc != none)
    {
        // End:0x67
        if(!sc.InsertScene(0, HudSceneTemplate, LP, Scene))
        {
            return;            
        }
        else
        {
            HudScene = SkyUIScene_Hud(Scene);
            LinkToHudScene();
            MissionHealthPanels[0] = pnlMissionHealth1;
            // End:0xAE
            if(pnlMissionHealth1 != none)
            {
                pnlMissionHealth1.SetVisibility(false);
            }
            MissionHealthPanels[1] = pnlMissionHealth2;
            // End:0xDB
            if(pnlMissionHealth2 != none)
            {
                pnlMissionHealth2.SetVisibility(false);
            }
            MissionHealthPanels[2] = pnlMissionHealth3;
            // End:0x109
            if(pnlMissionHealth3 != none)
            {
                pnlMissionHealth3.SetVisibility(false);
            }
        }
    }
    //return;    
}

exec function HideScores()
{
    // End:0x13
    if(bShowScores)
    {
        ShowScores();
    }
    //return;    
}

event CheckHudIdleTime()
{
    local float fadeInterpolation;

    // End:0x17
    if(PlayerOwner.Pawn == none)
    {
        return;
    }
    // End:0x60
    if((SkyVehicle(PlayerOwner.Pawn) != none) || SkyGame_Story(WorldInfo.Game) == none)
    {
        FadeHUDTo(1.0000000);        
    }
    else
    {
        // End:0xB1
        if(((HudLastSecondaryValue != HudSecondaryValue) || HudLastPrimaryValue != HudPrimaryValue) || PlayerOwner.Pawn.IsFiring())
        {
            HudIdleTime = 0.0000000;            
        }
        else
        {
            HudIdleTime += RenderDelta;
        }
        // End:0x11A
        if(HudIdleTime < HudKeepVisibleTime)
        {
            // End:0x10C
            if(HudVisibility < 1.0000000)
            {
                HudFadeInDelta += RenderDelta;
                fadeInterpolation = HudFadeInDelta / HudFadeInDelay;
                FadeHUDTo(fadeInterpolation);                
            }
            else
            {
                HudFadeInDelta = 0.0000000;
            }            
        }
        else
        {
            // End:0x163
            if(HudIdleTime < (HudKeepVisibleTime + HudFadeOutDelay))
            {
                fadeInterpolation = ((HudKeepVisibleTime + HudFadeOutDelay) - HudIdleTime) / HudFadeOutDelay;
                FadeHUDTo(fadeInterpolation);                
            }
            else
            {
                FadeHUDTo(0.0000000);
            }
        }
    }
    //return;    
}

exec function DisplayHudObjective(optional bool DontAutoHide, optional bool IncludeSound)
{
    ObjectiveLastShowTime = WorldInfo.TimeSeconds;
    bObjectiveView = true;
    bShowObjectiveHUD = true;
    bInputForceObjectiveView = DontAutoHide;
    // End:0x5A
    if(IncludeSound && ObjectiveShowSound != none)
    {
        PlaySound(ObjectiveShowSound);
    }
    // End:0x99
    if(LastHelpText == "<Strings:SkyUI.E1M2.e1m2_tut_obj>")
    {
        SetHelpText(" ", 0.1000000);
    }
    //return;    
}

exec event HideHudObjective()
{
    local string CurrMap;

    ObjectiveLastHideTime = WorldInfo.TimeSeconds;
    bObjectiveView = false;
    bShowObjectiveHUD = false;
    // End:0x90
    if(bNextObjectiveTutorial)
    {
        CurrMap = WorldInfo.GetMapName();
        // End:0x88
        if(int(Mid(CurrMap, 1, 1)) <= 1)
        {
            SetHelpText("<Strings:SkyUI.E1M2.e1m2_tut_obj>", 5.0000000);
        }
        bNextObjectiveTutorial = false;
    }
    //return;    
}

exec function ShowScores()
{
    // End:0x34
    if(ScoreBoard != none)
    {
        bShowScores = !bShowScores;
        ScoreBoard.ChangeState(bShowScores);
    }
    //return;    
}

function UpdateDmgArrows()
{
    local int I;

    I = 0;
    J0x07:

    // End:0xA4 [Loop If]
    if(I < DmgArrows.Length)
    {
        // End:0x9A
        if((((DmgArrows[I].TimeOfImpact + DmgArrowFadeTime) < WorldInfo.TimeSeconds) || DmgArrows[I].Attacker == none) || DmgArrows[I].Attacker.Health <= 0)
        {
            DmgArrows.Remove(I, 1);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export USkyHUD::execDrawDmgArrows(FFrame&, void* const)
native function DrawDmgArrows();

// Export USkyHUD::execUpdateInteractButtonPosition(FFrame&, void* const)
native function UpdateInteractButtonPosition();

// Export USkyHUD::execGetInputButtonForCommand(FFrame&, void* const)
native function Surface GetInputButtonForCommand(string Command, optional out name Modifier, optional out int ColorParam, optional out int Precedence, optional int List = -1);

// Export USkyHUD::execGetCurrentInteractButtonImage(FFrame&, void* const)
native function Surface GetCurrentInteractButtonImage();

event SetInteraction(name iName, optional Surface IconOverride, optional Surface IconSwap)
{
    local int Index;
    local Surface Icon;
    local string Text;
    local float centerHeight, rightSide;
    local name Modifier;
    local int ColorParam;
    local SkyPawnCoverUser SPCU;

    SPCU = SkyPawnCoverUser(PawnOwner);
    // End:0xE1
    if((iName == Interactions[CurrentInteraction].InteractName) && pnlInteract.IsVisible())
    {
        // End:0xDE
        if((IconOverride != OverrideInteractIcon) && (IconOverride != none) || OverrideInteractIcon != Interactions[CurrentInteraction].InteractIcon)
        {
            DumpCallStack();
            OverrideInteractIcon = IconOverride;
            // End:0xB7
            if(imgInteractIcon != none)
            {
                imgInteractIcon.SetValue(IconOverride);
            }
            // End:0xDE
            if(pnlInteractAction != none)
            {
                pnlInteractAction.SetVisibility(IconOverride != none);
            }
        }        
    }
    else
    {
        // End:0x153
        if(iName == 'None')
        {
            CurrentInteraction = 0;
            InteractionModifier = 'None';
            // End:0x12A
            if(pnlInteract != none)
            {
                pnlInteract.SetVisibility(false);
            }
            // End:0x14A
            if(pnlInteractSwap != none)
            {
                pnlInteractSwap.SetVisibility(false);
            }
            SwapInteractIcon = none;
            return;
        }
        CurrentInteraction = 0;
        Index = 0;
        J0x161:

        // End:0x1A9 [Loop If]
        if(Index < Interactions.Length)
        {
            // End:0x19F
            if(Interactions[Index].InteractName == iName)
            {
                CurrentInteraction = Index;
                // [Explicit Break]
                goto J0x1A9;
            }
            ++Index;
            // [Loop Continue]
            goto J0x161;
        }
        J0x1A9:

        // End:0x502
        if(((Interactions[CurrentInteraction].InteractButton != "") && SPCU != none) && int(SPCU.GetCoverState()) != int(27))
        {
            Icon = Interactions[CurrentInteraction].InteractButtonIcon;
            Modifier = Interactions[CurrentInteraction].InteractModifier;
            ColorParam = Interactions[CurrentInteraction].InteractColorParam;
            // End:0x2D6
            if(Icon != none)
            {
                InteractionModifier = Modifier;
                // End:0x27E
                if(pnlInteract != none)
                {
                    pnlInteract.SetVisibility(true);
                }
                // End:0x2B3
                if(imgInteractButton != none)
                {
                    imgInteractButton.SetValue(Icon);
                    imgInteractButton.SetVisibility(true);
                }
                // End:0x2D3
                if(lblInteractButton != none)
                {
                    lblInteractButton.SetVisibility(false);
                }                
            }
            else
            {
                // End:0x4F0
                if(Interactions[CurrentInteraction].InteractButtonText != "")
                {
                    InteractionModifier = Modifier;
                    // End:0x31E
                    if(pnlInteract != none)
                    {
                        pnlInteract.SetVisibility(true);
                    }
                    // End:0x33E
                    if(imgInteractButton != none)
                    {
                        imgInteractButton.SetVisibility(false);
                    }
                    // End:0x4ED
                    if(lblInteractButton != none)
                    {
                        // End:0x407
                        if(ColorParam < UIColors.Length)
                        {
                            lblInteractButton.StringRenderComponent.SetColor(UIColors[ColorParam]);
                            // End:0x404
                            if((imgInteractKeyboardBG != none) && MaterialInstance(imgInteractKeyboardBG.ImageComponent.ImageRef.ImageTexture) != none)
                            {
                                MaterialInstance(imgInteractKeyboardBG.ImageComponent.ImageRef.ImageTexture).SetVectorParameterValue('DrawColor', UIColors[ColorParam]);
                            }                            
                        }
                        else
                        {
                            lblInteractButton.StringRenderComponent.SetColor(UIColors[DefaultHUDColorIndex]);
                            // End:0x4B2
                            if((imgInteractKeyboardBG != none) && MaterialInstance(imgInteractKeyboardBG.ImageComponent.ImageRef.ImageTexture) != none)
                            {
                                MaterialInstance(imgInteractKeyboardBG.ImageComponent.ImageRef.ImageTexture).SetVectorParameterValue('DrawColor', UIColors[DefaultHUDColorIndex]);
                            }
                        }
                        lblInteractButton.SetValue(Interactions[CurrentInteraction].InteractButtonText);
                        lblInteractButton.SetVisibility(true);
                    }                    
                }
                else
                {
                    InteractionModifier = 'None';
                }
            }            
        }
        else
        {
            // End:0x522
            if(pnlInteract != none)
            {
                pnlInteract.SetVisibility(false);
            }
            // End:0x542
            if(pnlInteractSwap != none)
            {
                pnlInteractSwap.SetVisibility(false);
            }
            SwapInteractIcon = none;
            return;
        }
        // End:0x6E9
        if((CurrentInteraction > 0) && imgInteractButton != none)
        {
            centerHeight = imgInteractButton.Position.Value[1];
            centerHeight += (imgInteractButton.Position.Value[3] / 2.0000000);
            rightSide = imgInteractButton.Position.Value[0] + imgInteractButton.Position.Value[2];
            imgInteractButton.Position.Value[1] = centerHeight - (Interactions[CurrentInteraction].IconHeight / float(2));
            imgInteractButton.Position.Value[3] = Interactions[CurrentInteraction].IconHeight;
            imgInteractButton.Position.Value[0] = rightSide - (Interactions[CurrentInteraction].IconHeight / float(2));
            imgInteractButton.Position.Value[2] = Interactions[CurrentInteraction].IconHeight / float(2);
            UpdateInteractButtonPosition();
        }
        // End:0x702
        if(IconOverride != none)
        {
            Icon = IconOverride;            
        }
        else
        {
            Icon = Interactions[CurrentInteraction].InteractIcon;
        }
        // End:0x774
        if(Icon != none)
        {
            // End:0x749
            if(imgInteractBackground != none)
            {
                imgInteractBackground.SetVisibility(false);
            }
            // End:0x769
            if(imgInteractActionBackground != none)
            {
                imgInteractActionBackground.SetVisibility(true);
            }
            Text = "";            
        }
        else
        {
            // End:0x794
            if(imgInteractBackground != none)
            {
                imgInteractBackground.SetVisibility(true);
            }
            // End:0x7B4
            if(imgInteractActionBackground != none)
            {
                imgInteractActionBackground.SetVisibility(false);
            }
            Text = Interactions[CurrentInteraction].InteractText;
        }
        // End:0x92F
        if(Icon != OverrideInteractIcon)
        {
            ColorParam = Interactions[CurrentInteraction].InteractColorParam;
            OverrideInteractIcon = Icon;
            // End:0x90F
            if(((Icon != none) && SPCU != none) && int(SPCU.GetCoverState()) != int(27))
            {
                // End:0x88C
                if(MaterialInstance(Icon) != none)
                {
                    // End:0x88C
                    if(ColorParam < UIColors.Length)
                    {
                        MaterialInstance(Icon).SetVectorParameterValue('DrawColor', UIColors[ColorParam]);
                    }
                }
                // End:0x8AC
                if(pnlInteractAction != none)
                {
                    pnlInteractAction.SetVisibility(true);
                }
                // End:0x8CC
                if(imgInteractIcon != none)
                {
                    imgInteractIcon.SetValue(Icon);
                }
                // End:0x8EC
                if(imgInteractIcon != none)
                {
                    imgInteractIcon.SetVisibility(true);
                }
                // End:0x90C
                if(lblInteractIcon != none)
                {
                    lblInteractIcon.SetVisibility(false);
                }                
            }
            else
            {
                // End:0x92F
                if(pnlInteractAction != none)
                {
                    pnlInteractAction.SetVisibility(false);
                }
            }
        }
        // End:0xADC
        if(Icon == none)
        {
            ColorParam = Interactions[CurrentInteraction].InteractColorParam;
            OverrideInteractString = Text;
            // End:0xA9C
            if(Text != "")
            {
                // End:0x98D
                if(pnlInteractAction != none)
                {
                    pnlInteractAction.SetVisibility(true);
                }
                // End:0x9AD
                if(imgInteractIcon != none)
                {
                    imgInteractIcon.SetVisibility(false);
                }
                // End:0xA99
                if(lblInteractIcon != none)
                {
                    // End:0x9F0
                    if(ColorParam < UIColors.Length)
                    {
                        lblInteractIcon.StringRenderComponent.SetColor(UIColors[ColorParam]);                        
                    }
                    else
                    {
                        lblInteractIcon.StringRenderComponent.SetColor(UIColors[DefaultHUDColorIndex]);
                    }
                    lblInteractIcon.SetValue(Text);
                    lblInteractIcon.SetVisibility(true);
                    // End:0xA99
                    if((lblInteractButton != none) && lblInteractIcon.GetValue() == lblInteractButton.GetValue())
                    {
                        // End:0xA99
                        if(pnlInteractAction != none)
                        {
                            pnlInteractAction.SetVisibility(false);
                        }
                    }
                }                
            }
            else
            {
                // End:0xABC
                if(lblInteractIcon != none)
                {
                    lblInteractIcon.SetValue(Text);
                }
                // End:0xADC
                if(pnlInteractAction != none)
                {
                    pnlInteractAction.SetVisibility(false);
                }
            }
        }
    }
    // End:0xC20
    if(IconSwap != SwapInteractIcon)
    {
        ColorParam = Interactions[CurrentInteraction].InteractColorParam;
        SwapInteractIcon = IconSwap;
        // End:0xC00
        if(((IconSwap != none) && SPCU != none) && int(SPCU.GetCoverState()) != int(27))
        {
            // End:0xB98
            if(MaterialInstance(IconSwap) != none)
            {
                // End:0xB98
                if(ColorParam < UIColors.Length)
                {
                    MaterialInstance(IconSwap).SetVectorParameterValue('DrawColor', UIColors[ColorParam]);
                }
            }
            // End:0xBB8
            if(pnlInteractSwap != none)
            {
                pnlInteractSwap.SetVisibility(true);
            }
            // End:0xBD8
            if(imgInteractSwapIcon != none)
            {
                imgInteractSwapIcon.SetValue(IconSwap);
            }
            // End:0xBFD
            if(imgNoSwapIcon != none)
            {
                imgNoSwapIcon.SetVisibility(bSceneWeaponAmmoPickupFull);
            }            
        }
        else
        {
            // End:0xC20
            if(pnlInteractSwap != none)
            {
                pnlInteractSwap.SetVisibility(false);
            }
        }
    }
    //return;    
}

// Export USkyHUD::execTexList(FFrame&, void* const)
native exec function TexList();

exec function ShowDebug(optional name DebugType)
{
    local SkyBotControllerPilot SBCP;

    super.ShowDebug(DebugType);
    // End:0x35
    if(bShowDebugInfo)
    {
        ToggleShowDebugAOO(ShouldDisplayDebug('AOO'));        
    }
    else
    {
        ToggleShowDebugAOO(bShowDebugInfo);
    }
    // End:0x8F
    if(DebugType == 'tethers')
    {
        FlushPersistentDebugLines();
        // End:0x8E
        foreach WorldInfo.AllControllers(Class'SkyBotControllerPilot', SBCP)
        {
            SBCP.bAlreadyDrewTetherSphere = false;            
        }        
    }
    //return;    
}

// Export USkyHUD::execToggleShowDebugAOO(FFrame&, void* const)
native function ToggleShowDebugAOO(bool Enable);

function CheckInteractionModifiers()
{
    local int I;
    local name Modifier;
    local int ColorParam, Precedence;
    local string Command;
    local DataStoreClient dsc;
    local SkyUIDataStore_HUD dsh;
    local UIProviderScriptFieldValue Value;

    CachedInputButtonCommand = "";
    CachedInputButtonModifier = 'None';
    CachedInputButtonColorparam = DefaultHUDColorIndex;
    CachedInputButtonPrecedence = 0;
    CachedInputButtonForCommand = none;
    // End:0x78
    if((PlayerOwner != none) && SkyPawnCoverUser(PlayerOwner.Pawn) != none)
    {
        SkyPawnCoverUser(PlayerOwner.Pawn).LedgeJumpKeyString = "";
    }
    dsc = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x31D
    if(dsc != none)
    {
        dsh = SkyUIDataStore_HUD(dsc.FindDataStore('SkyHUD'));
        // End:0x31D
        if(dsh != none)
        {
            I = 0;
            J0xD0:

            // End:0x280 [Loop If]
            if(I < Interactions.Length)
            {
                // End:0x122
                if(Interactions[I].InteractButton ~= "name")
                {
                    Command = string(Interactions[I].InteractName);                    
                }
                else
                {
                    Command = Interactions[I].InteractButton;
                }
                Interactions[I].InteractButtonText = "";
                Interactions[I].InteractButtonIcon = GetInputButtonForCommand(Command, Modifier, ColorParam, Precedence);
                // End:0x1FD
                if(Interactions[I].InteractButtonIcon == none)
                {
                    // End:0x1FD
                    if(dsh.GetFieldValue("ACTION_" $ Command, Value))
                    {
                        Interactions[I].InteractButtonText = Value.StringValue;
                    }
                }
                Interactions[I].InteractModifier = Modifier;
                Interactions[I].InteractColorParam = ColorParam;
                Interactions[I].BindingPrecedence = Precedence;
                Modifier = 'None';
                ColorParam = DefaultHUDColorIndex;
                Precedence = 65535;
                ++I;
                // [Loop Continue]
                goto J0xD0;
            }
            dsh.RefreshSubscribers();
            // End:0x2B4
            if(lblObjectiveText != none)
            {
                lblObjectiveText.RefreshSubscriberValue();
            }
            // End:0x2D0
            if(lblNextGun != none)
            {
                lblNextGun.RefreshSubscriberValue();
            }
            // End:0x2EC
            if(lblPrevGun != none)
            {
                lblPrevGun.RefreshSubscriberValue();
            }
            // End:0x308
            if(lblHelpText != none)
            {
                lblHelpText.RefreshSubscriberValue();
            }
            SetInteraction('None');
        }
    }
    //return;    
}

event ShowCheckpointMsg(float Duration)
{
    // End:0x40
    if(CheckpointMsg != none)
    {
        CheckpointMsg.SetVisibility(true);
        // End:0x40
        if(Duration > float(0))
        {
            SetTimer(Duration, false, 'HideCheckpointMsg');
        }
    }
    //return;    
}

event HideCheckpointMsg()
{
    // End:0x20
    if(CheckpointMsg != none)
    {
        CheckpointMsg.SetVisibility(false);
    }
    //return;    
}

event ShowAutosaveIcon(float Duration)
{
    // End:0x40
    if(AutosaveIcon != none)
    {
        AutosaveIcon.SetVisibility(true);
        // End:0x40
        if(Duration > float(0))
        {
            SetTimer(Duration, false, 'HideAutosaveIcon');
        }
    }
    //return;    
}

event bool IsAutosaveIconVisible()
{
    // End:0x1D
    if(AutosaveIcon != none)
    {
        return AutosaveIcon.IsVisible();
    }
    return false;
    //return ReturnValue;    
}

event HideAutosaveIcon()
{
    // End:0x20
    if(AutosaveIcon != none)
    {
        AutosaveIcon.SetVisibility(false);
    }
    //return;    
}

event ShowProfileSaveIcon(float Duration)
{
    // End:0x42
    if((ProfileSaveIcon != none) && Duration > float(0))
    {
        ProfileSaveIcon.SetVisibility(true);
        SetTimer(Duration, false, 'HideProfileSaveIcon');
    }
    //return;    
}

event HideProfileSaveIcon()
{
    local SkyPlayerControllerBase SPC;
    local OnlineProfileSettings Settings;

    // End:0x97
    if(ProfileSaveIcon != none)
    {
        SPC = SkyPlayerControllerBase(PawnOwner.Controller);
        // End:0x82
        if(SPC != none)
        {
            Settings = SPC.GetProfileSettings();
            // End:0x82
            if((Settings != none) && int(Settings.AsyncState) != int(0))
            {
                ShowProfileSaveIcon(1.0000000);
                return;
            }
        }
        ProfileSaveIcon.SetVisibility(false);
    }
    //return;    
}

event AddTechPoints(int Delta, int oldtotal)
{
    TechPointCurVal = oldtotal;
    TechPointAddVal = Delta;
    // End:0x2C
    if(Delta == 0)
    {
        TechPointDisplayState = 3;        
    }
    else
    {
        TechPointDisplayState = 1;
    }
    // End:0x6B
    if(TechPointTotal != none)
    {
        TechPointTotal.SetValue(string(oldtotal));
        TechPointTotal.SetVisibility(true);
    }
    SetTimer(1.0000000, false, 'TickTechPointDisplay');
    //return;    
}

event TickTechPointDisplay()
{
    // End:0x8B
    if(PlayerOwner != none)
    {
        // End:0x8B
        if((PlayerOwner.Pawn == none) || PlayerOwner.Pawn.Health <= 0)
        {
            // End:0x61
            if(TechPointTotal != none)
            {
                TechPointTotal.SetVisibility(false);
            }
            // End:0x81
            if(TechPointAdd != none)
            {
                TechPointAdd.SetVisibility(false);
            }
            TechPointDisplayState = 0;
            return;
        }
    }
    // End:0x11A
    if(int(TechPointDisplayState) == int(1))
    {
        TechPointDisplayState = 2;
        // End:0x104
        if(TechPointAdd != none)
        {
            // End:0xD3
            if(TechPointAddVal < 0)
            {
                TechPointAdd.SetValue(string(TechPointAddVal));                
            }
            else
            {
                TechPointAdd.SetValue("+" $ string(TechPointAddVal));
            }
            TechPointAdd.SetVisibility(true);
        }
        SetTimer(1.0000000, false, 'TickTechPointDisplay');        
    }
    else
    {
        // End:0x191
        if(int(TechPointDisplayState) == int(2))
        {
            TechPointDisplayState = 3;
            // End:0x152
            if(TechPointAdd != none)
            {
                TechPointAdd.SetVisibility(false);
            }
            // End:0x17B
            if(TechPointTotal != none)
            {
                TechPointTotal.SetValue(string(TechPointCurVal + TechPointAddVal));
            }
            SetTimer(2.0000000, false, 'TickTechPointDisplay');            
        }
        else
        {
            // End:0x1C9
            if(int(TechPointDisplayState) == int(3))
            {
                TechPointDisplayState = 0;
                // End:0x1C9
                if(TechPointTotal != none)
                {
                    TechPointTotal.SetVisibility(false);
                }
            }
        }
    }
    //return;    
}

function UpdateAAGunHUD()
{
    // End:0xD1
    if((SkyVehicle_AAGun_Gatling(PlayerOwner.Pawn) != none) && SkyVehicle_AAGun_Gatling(PlayerOwner.Pawn).HUDImage != none)
    {
        // End:0x79
        if(imgAAGun != none)
        {
            imgAAGun.SetValue(SkyVehicle_AAGun_Gatling(PlayerOwner.Pawn).HUDImage);
        }
        // End:0x99
        if(pnlAAGun != none)
        {
            pnlAAGun.SetVisibility(true);
        }
        // End:0xB5
        if(lblPrevGun != none)
        {
            lblPrevGun.RefreshSubscriberValue();
        }
        // End:0xD1
        if(lblNextGun != none)
        {
            lblNextGun.RefreshSubscriberValue();
        }
    }
    //return;    
}

function HideAAGunHUD()
{
    // End:0x20
    if(pnlAAGun != none)
    {
        pnlAAGun.SetVisibility(false);
    }
    //return;    
}
