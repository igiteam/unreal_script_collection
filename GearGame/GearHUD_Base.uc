/**
 * GearHUD_Base
 * Gear Heads Up Display base
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUD_Base extends HUD
	native
	dependson(GearTypes)
	config(Game);

/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** Use a minimal HUD? (just crosshair) */
var() config bool bMinimalHUD;

/** name of the taccom MaterialEffect in the post process chain */
var name TacComPPEffectName;
/** Reference to the material effect in the post process chain used for TacCom */
var MaterialEffect TacComEffect;
/** Reference to the MIC for TacCom to remove redundant casts */
var MaterialInstanceConstant TacComMIC;

/** Are we currently doing the initial fade in of TacCom at the beginning of a new round? */
var bool bInitialTaccomFadeIn;

var localized string OverTimeString;

/** Set in DrawHUD so we can do stuff based on whether we are in an MP game or not **/
var bool bInMultiplayerMode;
/** Set in DrawHUD so we can do stuff based on whether we are in an MP Coop game or not */
var bool bInMPCoopMode;

/** List of debug draw functions */
var array<delegate<DebugDraw> > DebugDrawList;

/** Current fade color */
var transient color FadeColor;

/** Last fade alpha to interpolate from */
var transient float PreviousFadeAlpha;

/** Desired fade alpha to interpolate to */
var transient float DesiredFadeAlpha;

/** Current fade alpha */
var transient float FadeAlpha;

/** Current time for fade alpha interpolation */
var transient float FadeAlphaTime;

/** Delay before fading */
var transient float FadeAlphaDelay;

/** Total time for fade alpha interpolation */
var transient float DesiredFadeAlphaTime;

var bool bMBDisabled;

/** whether to make the target show unfriendly or not */
var bool bUnfriendlySpotted;
/** Unfriendly actor that the reticle is over. @fixme, replace bUnfriendlySpotted with this. */
var Actor UnfriendlyReticleActor;
/** True if the target is movable cover */
var bool bMovableCoverSpotted;
/** Should we display 'reticle plus' */
var transient bool bShowReticlePlus;
/** Blink time of reticle plus */
var float ReticlePlusBlinkTime;

/** Red screen value for making screen go red when you die */
var const float MaxRednessOfDeathScreen;

/** Last time weapon info needed to be drawn */
var transient float LastWeaponInfoTime;

/** Used when drawing the out of ammo icon */
var transient float LastOutOfAmmoTime;

/** The animating Mortar crosshair tick */
var CanvasIcon MortarCrosshairTickIcon;
/** The mark saved to show where you last shot the Mortar */
var CanvasIcon MortarCrosshairSaveIcon;

/** Symbol to draw over the reticle when out of ammo */
var CanvasIcon OutOfAmmoIcon;

/** Symbol to draw over the reticle when out of ammo */
var CanvasIcon OutOfAmmoIcon2;

/** X button icon for coop interaction menu */
var CanvasIcon XButtonIcon;

/** Y button icon for coop interaction menu */
var CanvasIcon YButtonIcon;

/** A button icon for coop interaction menu */
var CanvasIcon AButtonIcon;

/** B button icon for coop interaction menu */
var CanvasIcon BButtonIcon;

/** Text to print on the coop interaction menu for ammo sharing */
var localized string CoopInteractionShareAmmoText;

/** Text to print on the coop interaction menu for weapon sharing */
var localized string CoopInteractionTradeWeaponsText;

/** Text to print on the coop interaction menu for weapon sharing */
var localized string CoopInteractionTradeSecondaryWeaponsText;

/** Text to print on the coop interaction menu for money sharing */
var localized string CoopInteractionGiveMoneyText;

/** The alpha value of the coop interaction menu */
var float CoopMenuOpacity;

/** How fast the coop interaction menu should fade in and out */
var float CoopMenuFadeRate;

/** Text to print when you're killed by your nemesis */
var localized string NemesisText;

/** Text to print when you kill someone over the nemesis threshold amount of times */
var localized string DominatingText;

/** Cached variable of the pawn we are controlling (PawnOwner.Pawn unless we are riding a bloodmount) */
var transient Pawn ControlledPawn;

/** Text to print next to your assist points */
var localized string AssistText;

enum EAssessSquadBackgroundType
{
	EASBT_Normal,
	EASBT_Dead,
};

struct native AssessSquadData
{
	var float NameYFromCenter;
	var float OrderYFromCenter;
	var float HeadYFromTopOfBackground;
};
var AssessSquadData SquadDisplayData;

struct native AssessSquadCoord
{
	var float XFromTopRight;
	var float YFromTopRight;
};

// structure containing coords for all teammates
struct native AllAssessSquadCoord
{
	var array<AssessSquadCoord> Coords;
};

/** AssessSquadCoords for each splitscreen type */
var array<AllAssessSquadCoord>	AssessSquadCoords;

/** Icons for drawing squadmates in assess mode */
var array<CanvasIcon > SquadBackgrounds;
/** Icon used for the nameplate of the squadmates */
var const CanvasIcon SquadBackgroundNamePlate;

/** enum of the actions of squadmates */
enum EAssessSquadStatus
{
	EASS_None,
	EASS_Normal,
	EASS_Attack,
	EASS_Down,
	EASS_Dead,
	EASS_Defensive,
};

/**
 * enum of the displayable action orders of squadmates
 *  ATTACK is using weapon icons
 */
enum EDisplayableSquadStatus
{
	eSO_DEFENSIVE,
	eSO_ATTACK,
	eSO_DOWN,
	eSO_REVIVE,
	eSO_DEAD,
	eSO_NORMAL,		// <-- Keep this at the bottom since we must use DeathMessageIcons
};

/** Strings for displaying the current action of the squadmate */
var array<CanvasIcon> SquadStatusIcons;

/** SquadIndicator structure and data */
struct native SquadLocatorDatum
{
	var float DirOfHit;
	var MaterialInstanceConstant MILocation;
};
var array<SquadLocatorDatum> SquadLocator;
var const int NumSquadLocators;
var int CurrSquadLocatorToUse;
var Material SquadLocatorMaterial;

/** Material for pulsing the weapon indicator */
var MaterialInstanceConstant ActiveReloadPulseMaterialConstant;
var MaterialInstanceConstant SuperSweetPulseMaterialConstant;
var Material ActiveReloadPulseMaterial;
var Material SuperSweetReloadPulseMaterial;

/** all of our quick version 1 hit location chevron replacement */
var Material HitLocatorMaterial;

const MAX_HIT_LOCATORS = 3;
var int CurrHitLocatorDataIndex;

struct native HitLocatorDatum
{
	var float DirOfHit;
	var float HitLocationFadePercent;
	var MaterialInstanceConstant MILocation;
	var Actor ActorWhoShotMe;
	var vector HitLocation;
	var bool bDirLocked;
	var int TotalDamage;
};

var HitLocatorDatum HitLocatorList[MAX_HIT_LOCATORS];

/** Current action possible, prioritized by EActionType */
var ActionInfo ActiveAction;
/** Previously active, kept around for blending */
var ActionInfo PreviousAction;

/** Fade in time for actions */
var config float ActionFadeInTime;
/** Fade out time for actions */
var config float ActionFadeOutTime;


/** Icon used for the weapon info */
var const CanvasIcon WeaponInfoFrame;

/** Material instance used for the crimson omen shown when the player is hurt */
var MaterialInstanceConstant OmenMatInstRef;
var MaterialInstanceConstant OmenMatInst;
/** size of omen area (square) */
var float OmenSize;

/** Material instance used for assess mode PPE */
var MaterialInstanceConstant AssessModeMatInst;

/** Current fade color for the overlay */
var LinearColor AssessModeFadeColor;

/** Fade in/out time for assess mode */
var config float AssessModeFadeTime;

var AudioComponent	TacComLoop;
struct native DeathData
{
	// we need to cache victim info here and not use the PRI because in some cases (nonplayers, player leaving the game, etc)
	// the PRI may become invalid while the message is still being displayed
	var string KillerName;
	var string VictimName;
	var byte KillerTeamIndex;
	var byte VictimTeamIndex;
	var class<GearDamageType> Damage;
	var EGearDeathType DeathType;
	var float					TimeRemaining;
	var int                     BloodIconIndex;
	var bool                    bShowBlood;
	var bool                    bUseMessageText;
	var string                  MessageText;
	var bool					bUseTeamColors;
	var bool bKillerDrawTeamColor;
	var bool bKillerIsCOG;
	var bool bKillerIsPlayerOne;
	var bool bKillerIsPlayerTwo;
	var bool bVictimDrawTeamColor;
	var bool bVictimIsCOG;
	var bool bVictimIsPlayerOne;
	var bool bVictimIsPlayerTwo;
	var bool					bAlwaysShow;
	var bool					bShowPlayerNames;
	var float Scale;
	var int GameSpecificID;

	structdefaultproperties
	{
		Scale=1.f
		GameSpecificID=-1
	}
};

var array<CanvasIcon> GameSpecificIcon;
var CanvasIcon RevivedIcon;

/** Total time for drawing the death data */
var const float DeathDataTime;
/** Fade time for death data */
var const float DeathDataFadeTime;
/** Array of strings to display when people die in multiplayer */
var array<DeathData> HUDMessages;
/** maximum number of HUDMessages that may be displayed at once */
var int MaxHUDMessages;

/** Array of strings to display when people die in multiplayer - These are the high priority ones */
var array<DeathData> PriorityHUDMessages;
/** maximum number of Priority HUDMessages that may be displayed at once */
var int MaxPriorityHUDMessages;

/** Amount to offset the priority hud messages in the Y direction to avoid being directly over the crosshair */
var float PriorityHUDMessageYOffset;


/** whether we should draw death messages when not in multiplayer mode */
var bool bAlwaysDrawDeathMessages;

/** Total time for drawing the ammo data */
var const float AmmoDataTime;
/** Fade time for ammo data */
var const float AmmoDataFadeTime;

/** whether we should draw the points earned for a kill */
var bool bDrawKillPoints;
/** how many kill points we're currently displaying */
struct native KillPointInfo
{
	/** number of points */
	var int Value;
	/** time we started displaying them */
	var float StartTime;
};
var array<KillPointInfo> KillPoints;
/** how long it should take for the kill point display to fade out */
var float KillPointsFadeTime;
/** how long should the kill points display remain static */
var float KillPointsTime;
/** where the kill points go as they're fading */
var vector2D KillPointsDest;

/** How long should it take to fade the ridable pawn health out */
var config float RidablePawnHealthFadeTime;

/** Enum for HUD colors in Gears */
enum EGearHUDColor
{
	eWARHUDCOLOR_WHITE,
	eWARHUDCOLOR_RED,
	eWARHUDCOLOR_BLACK,
	eWARHUDCOLOR_WHITE_DK,
	eWARHUDCOLOR_TEAMRED,
	eWARHUDCOLOR_TEAMBLUE,
	eWARHUDCOLOR_CHATICONRED,
	eWARHUDCOLOR_CHATICONBLUE,
	eWARHUDCOLOR_PLAYERONE,
	eWARHUDCOLOR_PLAYERTWO,
	eWARHUDCOLOR_YELLOW,
};

//const HUD_COLOR_COUNT = eWARHUDCOLOR_PLAYERTWO;
const HUD_COLOR_COUNT = 11;
/** The list of colors to use on the HUD */
var color HudColors[HUD_COLOR_COUNT];

/** Cinematic vars**/
var bool bPlayCinematic;
var float CinematicTextDisplayStartTime;

/** Array of blood icons which are used for the background of the kill messages**/
const BLOOD_ICON_AMT = 4;
var CanvasIcon BloodIcons[BLOOD_ICON_AMT];

/** Current Blood index.  so we don't repeat the same blood splat **/
var int CurrBloodIndex;

/** Values for safezone locations and viewport center */
var float SafeZoneLeft, SafeZoneRight, SafeZoneTop, SafeZoneBottom, SafeZoneBottomFromViewport, SafeZoneFriendlyCenterX, SafeZoneFriendlyCenterY;
/** set this to be true to have it recalculated */
var bool bRefreshSafeZone;

/** Scale of the weapon info */
var const float WeaponInfoScale;

/** The current splitscreen mode we are in */
var ESplitScreenType CurrSplitscreenType;

/** Percentage of the screen height drawable for death messages */
var float HUDMessagesScreenPercent;

/** Percentage of the screen height drawable for death messages */
var float PriorityHUDMessagesScreenPercent;

/**
* Post process settings for bleed out effect.
*/
var PostProcessSettings BleedOutPPSettings;

/**
* Post process settings for taccom effect.
*/
var PostProcessSettings TaccomPPSettings;

/** structure to keep track of the weapon selector */
struct native WeaponSelectData
{
	var const int	TotalNumBlinks;
	var const float	TotalBlinkTime;
	var float		StartBlinkTime;
};
var WeaponSelectData	WeaponSelect;

/**
 * The possible results of an active reload
 */
enum EActiveReloadResultType
{
	eARResult_None,
	eARResult_Success,
	eARResult_SuperSuccess,
	eARResult_Failed,
};

/**
 * Structure to store the action reload data needed for the AR bar
 */
struct native ActionReloadBarData
{
	var const CanvasIcon		BackGround;		// the background
	var const CanvasIcon		Flash;			// for flashes
	var const CanvasIcon		TickMark;		// the moving indicator
	var const CanvasIcon		SuccessRegion;	// the texture to show success regions
	var const CanvasIcon		PerfectGrade;	// gradient for getting a perfect
	var const CanvasIcon		GoodGrade;		// gradient for getting a normal AR
	var const float				FlashDuration;	// amount of time in seconds the AR will flash when a result occurs
	var const float				FadeDuration;	// amount of time in seconds the AR will fade when a result occurs

	var float				TickMarkTime;	// the time the tick should be using to draw
	var EActiveReloadResultType	ARResult;	// if the button was pressed, this is the result
	var float ARResultTime;	// world time ARResult was determined (for fading out the bar)
};
var ActionReloadBarData	ARBarData;

struct native ActionIconAnimData
{
	/** Time of the last time we made an icon switch for animating action icons */
	var float LastActionAnimationSwitch;
	/** Current index of the animating action icon */
	var int CurrentIconIndex;
};
var ActionIconAnimData	ActionIconAnimInfo;

/** Display for showing dead teammates */
var Material DeadTaccomSplatMaterial;
var MaterialInstanceConstant DeadTaccomSplatMaterialConstant;

/** Display for showing revived teammates */
var CanvasIcon ReviveTaccomIcon;

/** Icon to show which players are currently talking */
var CanvasIcon VoiceTaccomIcon;

/** Offset position for the voice taccom icon, this is the offset from the center of the squad circle. */
var float VoiceTaccomIconPos[2];

/** If TRUE, the scoreboard will keep itself hidden */
var bool bRestrictScoreboard;

/** Start time of crosshair fading */
var float CrosshairFadeStartTime;
/** Whether the crosshair fade is in or out */
var bool bIsFadingCrosshairIn;
/** Current opacity percentage of the crosshair fade */
var float CrosshairFadeOpacity;
/** Total fadetime of the crosshair */
var const float TotalCrosshairFadeTime;
/** true to always draw the crosshair, useful for accuracy debugging */
var transient bool bAlwaysShowCrosshair;


/** Whether or not we are tracking player chat (usually TRUE when the taccom is up). */
var bool bTrackingChat;

/** Start time of taccom fading */
var float TaccomFadeStartTime;
/** Whether the taccom fade is in or out */
var bool bIsFadingTaccomIn;
/** Current opacity percentage of the taccom fade */
var float TaccomFadeOpacity;
/** Total fadetime of the taccom */
var const float TotalTaccomFadeTime;

/** Start time of coop pause fading */
var float CoopPauseFadeStartTime;
/** Whether the CoopPause fade is in or out */
var bool bIsFadingCoopPauseIn;
/** Current opacity percentage of the CoopPause fade */
var float CoopPauseFadeOpacity;
/** Total fadetime of the CoopPause */
var const float TotalCoopPauseFadeTime;

/** Whether to draw the weapon indicator or not */
var bool bDrawWeaponIndicator;
/** Start time of weapon fading */
var float WeaponFadeStartTime;
/** Whether the weapon fade is in or out */
var bool bIsFadingWeaponIn;
/** Current opacity percentage of the Weapon fade */
var float WeaponFadeOpacity;
/** Total fadetime of the Weapon */
var const float TotalWeaponFadeTime;

//--------------- Dramatic Text Draw Variables ----------------
/** Total amount of time to draw the dramatic string */
var float TotalDramaticStringDrawTime;
/** Total amount of time to fade the dramatic string in */
var float TotalDramaticStringFadeInTime;
/** Total amount of time to fade the dramatic string out */
var float TotalDramaticStringFadeOutTime;
/** The time we started drawing the dramatic strings */
var float DramaticStringDrawStartTime;
/** The first dramatic string to draw */
var String DramaticString1;
/** The second dramatic string to draw */
var String DramaticString2;
/** Vertical value of where to draw the dramatic text */
var float DramaticTextDrawYStart;
/** Amount of time for the lines to wait on fading in */
var float DramaticLineWaitTime;
/** Amount of time for the lines to fade prior to the text */
var float DramaticLineFadeTime;

//--------------- SubtitleArea Text Draw Variables ----------------
// This is for drawing text in the subtitle area... this is not ACTUALLY drawing subtitles
// but merely drawing strings in the area where subtitles normally would draw
/** Total amount of time to draw the string */
var float TotalSubtitleStringDrawTime;
/** Total amount of time to fade the subtitle string in */
var float TotalSubtitleStringFadeInTime;
/** Total amount of time to fade the subtitle string out */
var float TotalSubtitleStringFadeOutTime;
/** The time we started drawing the subtitle strings */
var float SubtitleStringDrawStartTime;
/** The subtitle string to draw */
var String SubtitleString;

/** localized string for displaying a weapon being taken in MP */
var localized String WeaponTakenString;

/** localized strings for coop-client pause screen */
var localized String ServerMessageString;
var localized String ServerPauseString;
var PlayerReplicationInfo ServerPausedByPRI;

/** localized string to display when the game is loading */
var localized String LoadingString;
var localized String CheckpointReachedString;

/** The last time a checkpoint was hit */
var float TimeOfLastCheckpoint;
var const float MinTimeBeforeFadeForCheckpoint;
var const float FadeTimeForCheckpoint;

/** This flag is used by clients of a coop game to determined the previous frame's pause state */
var bool bCoopClientWasPaused;

/** Distance at which you will see your DBNO teammate icon in full opacity */
var() config float DBNOFullOpacityDistance;
/** Distance at which your DBNO teammate icon stops fading out */
var() config float DBNOMaxFadeOpacityDistance;
/** The most faded your DBNO teammate icon will be */
var() config float DBNOMaxFadeOpacity;

/** Icon for background of countdown */
var CanvasIcon CountdownBgdIcon;
/** size of countdown timer area */
var vector2d CountdownSize;
/** Countdown End time */
var float CountdownEndTime;
var float CountdownStartTime;
var float CountdownStopTime;
var const float CountdownTotalFadeInTime;
var const float CountdownTotalFadeOutTime;
var float CountdownTimeToDraw;
var bool bDrewCountdownLastFrame;

/** String to draw based on the kismet SeqAct_DrawMessage action */
var string KismetMessageText;
var float  KismetMessageEndTime;

/** Reference to the content class for the pause menu */
var const class<UIScene_Pause> UI_PauseSceneClass;
/** Instance reference to the pause menu that's currently up */
var UIScene_Pause UI_PauseSceneInstance;

/** Reference to the content class for the gameover UI scene */
var const class<UIScene_GameOver>   GameOverPlayerClass;
var transient UIScene_GameOver      GameOverPlayer;

/** The content class reference to the GFx UI scene for the end-of-round scene */
var const class<UIScene_EndOfRound> EndRoundUIScenePlayerClass;
/** The instance reference to the GFx UI scene for the end-of-round scene */
var UIScene_EndOfRound EndRoundUIScenePlayerInstance;

/** Reference to the path choice scene content class */
var() class<UIScene_PathChoice>    PathChoicePlayerClass;
/** The instance reference to the UI scene for path selection */
var transient UIScene_PathChoice    PathChoiceScene;

/** The content class reference to the UI scene for discoverables */
var const class<UIScene_Discoverable>   DiscoverablePlayerClass;
/** The instance reference to the UI scene for the discoverables */
var transient UIScene_Discoverable      DiscoverablePlayerInstance;

/** Reference to the callout scene class, used for in game credits, act / chapter announcements, etc */
var() class<UIScene_Callouts>       CalloutPlayerClass;
/** Reference to the actual instance of the callout scene */
var transient UIScene_Callouts      CalloutSceneInstance;

var transient float LastMortarTickPercent;

var transient bool bDrawOverheadMPMap;
var OverheadMapPlacementActor OverheadMapActor;

/** Enum for the different special icons that could be drawn in squadmate UI */
enum EGearSpecialIconType
{
	eGSIT_None,
	eGSIT_Leader,
	eGSIT_BuddyCOG,
	eGSIT_BuddyLocust
};

/** Icon of the leader */
var CanvasIcon LeaderIcon;
/** Icon for a COG buddy */
var CanvasIcon BuddyIconCOG;
/** Icon for a Locust buddy */
var CanvasIcon BuddyIconLocust;

/** Whether to show names when spectating or not */
var bool bShowNamesWhenSpectating;

/** Array of HUD locators currently being used */
var transient array<GearHUDLocator> HUDLocators;

/** Reference to the material effect in the post process chain used for being blind */
var MaterialEffect BlindEffect;
/** Reference to the MIC for being blind to remove redundant casts */
var MaterialInstanceConstant BlindMIC;

var const FontRenderInfo Text_NoClipShadowed;
var const FontRenderInfo Text_ClipShadowed;

/** spectator display properties */
var CanvasIcon SpectateBackgroundIcon, SpectatePlayersIcon, SpectateBattleCamIcon;
var localized string SpectateGhostTitle, SpectateBattleCamTitle;
var localized string GenericKilledByText;
var localized string SpectateGhostLabel, SpectateShowNamesLabel, SpectateHideNamesLabel;

/** Spot text while ghost spectating */
var localized string SpectateSpotLabel;

/** Texture to draw when aiming at a friendly */
var Texture2D FriendlyCrosshair;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if( ActiveReloadPulseMaterialConstant == None )
	{
		ActiveReloadPulseMaterialConstant = new(outer) class'MaterialInstanceConstant';
		ActiveReloadPulseMaterialConstant.SetParent( ActiveReloadPulseMaterial );
	}
	if ( SuperSweetPulseMaterialConstant == None )
	{
		SuperSweetPulseMaterialConstant = new(outer) class'MaterialInstanceConstant';
		SuperSweetPulseMaterialConstant.SetParent( SuperSweetReloadPulseMaterial );
	}

	GearPC(PlayerOwner).RefreshAllSafeZoneViewports();

	OmenMatInst = new(self) class'MaterialInstanceConstant';
	OmenMatInst.SetParent( OmenMatInstRef );
	// Bring the blend of the omen in slightly earlier
	OmenMatInst.SetScalarParameterValue('OmenFadeInOffset',-0.2);
}

/** Initiate the display of "no longer leader" - needed by GearHUDKTL */
function StartNoLongerLeaderDisplay( bool bLeaderIsKiller );

/** Stubs for the DM version of the HUD */
function ShowPlayerName();

simulated function bool IsMapCycleTransitioning()
{
	return false;
}

simulated event PostRender()
{
	`if(`notdefined(FINAL_RELEASE))
	local float		XL, YL, YPos;
	`endif
	local Font		OldFont;
	local GameViewportClient VPClient;
	local GearPRI OwnerPRI;
	local GearPC PC;
`if(`isdefined(_WATERMARK_))
	local string BuildDate;
`endif //END _WATERMARK_
	local bool bIsMapCycleTransitioning;

	// is this a multiplayer game?
	bInMultiplayerMode = (WorldInfo.GRI != None && WorldInfo.GRI.IsMultiplayerGame());
	bInMPCoopMode = (WorldInfo.GRI != None && WorldInfo.GRI.IsCoopMultiplayerGame());

	// calculate the screen percentage for death and ammo messages
	HUDMessagesScreenPercent = bInMultiplayerMode ? 0.75f : 0.75f;
	PriorityHUDMessagesScreenPercent = bInMultiplayerMode ? 0.25f : 0.25f;

	// Set up delta time
	RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;

	PC = GearPC(PlayerOwner);
	if ( PC != None )
	{
		// Cache the pawn we are controlling
		ControlledPawn = PlayerOwner.Pawn;

		PC.DrawDebugTextList(Canvas,RenderDelta);
		if ( PC.Player != None )
		{
			VPClient = LocalPlayer(PlayerOwner.Player).ViewportClient;
			CurrSplitscreenType = VPClient.GetSplitscreenConfiguration();

			// NOTE: CalculateDeadZone is being cached now -
			if (bRefreshSafeZone)
			{
				CalculateDeadZone();
			}

			// Just in case SpectatorUISceneInstance gets created during split screen
			if (PC.WantsSpectatorUI())
			{
				SafeZoneBottom = Canvas.ClipY - (Canvas.ClipY * 0.9f * 0.836455f) - (Canvas.ClipY * 0.05f);
			}
			else
			{
				SafeZoneBottom = SafeZoneBottomFromViewport;
			}


			//VPClient.CalculatePixelCenter( SafeZoneFriendlyCenterX, SafeZoneFriendlyCenterY, LocalPlayer(PlayerOwner.Player), Canvas );
			SafeZoneFriendlyCenterX = Canvas.ClipX/2;
			SafeZoneFriendlyCenterY = Canvas.ClipY/2;

			PC.SceneYOffsetForSplitscreen = (CurrSplitscreenType == eSST_2P_VERTICAL) ? SafeZoneTop + (WeaponInfoFrame.VL*0.5f*WeaponInfoScale) : 0.f;
		}

		OwnerPRI = GearPRI(PlayerOwner.PlayerReplicationInfo);


//debug
`if(`notdefined(FINAL_RELEASE))
		if( ControlledPawn != None )
		{
			ControlledPawn.DrawPathStep( Canvas );
		}
`endif
	}

	// Pre calculate most common variables
	if ( SizeX != Canvas.SizeX || SizeY != Canvas.SizeY )
	{
		PreCalcValues();
	}

	if( bPlayCinematic && ( (WorldInfo.TimeSeconds - CinematicTextDisplayStartTime ) < 3 ) )
	{
		OldFont = Canvas.Font;
		Canvas.SetPos(130,130);
		Canvas.Font = class'Engine'.Static.GetLargeFont();
		Canvas.DrawText("CINEMATIC");
		Canvas.Font = OldFont;
	}

	bIsMapCycleTransitioning = IsMapCycleTransitioning();

`if(`notdefined(FINAL_RELEASE))
	if ( bShowDebugInfo && PlayerOwner.ViewTarget != None )
	{
		Canvas.Font = class'Engine'.Static.GetTinyFont();
		Canvas.DrawColor = ConsoleColor;
		Canvas.StrLen("X", XL, YL);
		YPos = 0;
		PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);

		if (ShouldDisplayDebug('AI') && (Pawn(PlayerOwner.ViewTarget) != None))
		{
			DrawRoute(Pawn(PlayerOwner.ViewTarget));
		}
	}
	else if ( !bShowHud && !bIsMapCycleTransitioning )
	{
		// handle any debug draws
		foreach DebugDrawList(DebugDraw)
		{
			DebugDraw(self);
		}
	}
	else
`endif
    if( (bShowHud || bIsMapCycleTransitioning) &&
		(OwnerPRI  == None || OwnerPRI.bShowHUD) )
	{
		PlayerOwner.DrawHud( Self );

		DrawHud();

		DisplayKismetMessages();

`if(`notdefined(FINAL_RELEASE))
		if (!bMinimalHUD)
		{
			DisplayConsoleMessages();
			DisplayLocalMessages();
		}
`endif
	}

`if(`notdefined(FINAL_RELEASE))
	if (GearGame(WorldInfo.Game) != None && GearGame(WorldInfo.Game).UnscriptedDialogueManager != None)
	{
		if (GearGame(WorldInfo.Game).UnscriptedDialogueManager.bEnableGUDSBrowsing)
		{
			GearGame(WorldInfo.Game).UnscriptedDialogueManager.GUDBrowserRender(Canvas);
		}
		else if (GearGame(WorldInfo.Game).UnscriptedDialogueManager.bEnableEffortsBrowsing)
		{
			GearGame(WorldInfo.Game).UnscriptedDialogueManager.EffortsBrowserRender(Canvas);
		}
	}
`endif

	// draw message info
	DrawHUDMessages(RenderDelta);

	if (bDrawKillPoints)
	{
		DrawKillPoints(RenderDelta);
	}

	MaybeDrawOverheadMPMap();

	// Don't show the dramatic text if the pause menu is open or bShowHud is false in an MP match
	// We want it to show when bShowHud is false in SP so we can see it over the cinematics
	if ( !HideHUDFromScenes() &&
		 (!bInMultiplayerMode || bShowHud) )
	{
		UpdateDramaticText();
	}

	if (FadeAlpha != 0.f)
	{
		Canvas.SetOrigin(0,0);
		Canvas.SetPos(0,0);
		Canvas.DrawColor = MakeColor(FadeColor.R,FadeColor.G,FadeColor.B,FadeAlpha);
		Canvas.DrawTile(Texture2D'WhiteSquareTexture',Canvas.ClipX,Canvas.ClipY,0,0,2,2);
	}

	if( LoadingTextIsDrawing() )
	{
		OldFont = Canvas.Font;
		DrawLoadingText();
		Canvas.Font = OldFont;
	}

	LastHUDRenderTime = WorldInfo.TimeSeconds;
}

event Destroyed()
{
	if ( UI_PauseSceneInstance != None )
	{
		UI_PauseSceneInstance.Close(TRUE);
	}
	if ( GameOverPlayer != None )
	{
		GameOverPlayer.Close(TRUE);
	}
	if ( CalloutSceneInstance != None )
	{
		CalloutSceneInstance.Close(TRUE);
	}
	if ( EndRoundUIScenePlayerInstance != None )
	{
		EndRoundUIScenePlayerInstance.Close(TRUE);
	}
	if ( PathChoiceScene != None )
	{
		PathChoiceScene.Close(TRUE);
	}

	if ( WorldInfo != None && WorldInfo.Game != None )
	{
		WorldInfo.Game.ForceClearUnpauseDelegates(Self);
	}

	Super.Destroyed();
	ResetTaccomOpacity();
}

/**
 * Reset the HUD
 */
function Reset()
{
	local GearPlayerCamera Cam;

	ActiveAction.bActive = FALSE;
	ActiveAction.BlendPct = 0.f;
	PreviousAction.bActive = FALSE;
	PreviousAction.BlendPct = 0.f;
	ClearHUDAfterShowToggle();

	CrosshairFadeStartTime = 0.0f;
	bIsFadingCrosshairIn = FALSE;
	CrosshairFadeOpacity = 0.0f;

	TaccomFadeStartTime = 0.0f;
	bIsFadingTaccomIn = FALSE;
	bInitialTaccomFadeIn = FALSE;
	ResetTaccomOpacity();

	CoopPauseFadeStartTime = 0.0f;
	bIsFadingCoopPauseIn = FALSE;
	CoopPauseFadeOpacity = 0.0f;

	WeaponFadeStartTime = 0.0f;
	bDrawWeaponIndicator = FALSE;
	bIsFadingWeaponIn = FALSE;
	WeaponFadeOpacity = 0.0f;

	TimeOfLastCheckpoint = -1;

	Cam = GearPlayerCamera(PlayerOwner.PlayerCamera);
	if ( Cam != None )
	{
		Cam.SetColorScale( vect(1,1,1) );
	}

	ClearHitLocatorData();

	GearPC(PlayerOwner).RefreshAllSafeZoneViewports();

	// Close the callout scene in case we were in the middle of displaying something
	if( CalloutSceneInstance != None )
	{
		CalloutSceneInstance.Close(TRUE);
	}

	// Close the game over scene
	if( GameOverPlayer != None )
	{
		GameOverPlayer.Close(TRUE);
	}
}

/** Clear out the display messages */
simulated function ClearHUDAfterShowToggle()
{
	LastWeaponInfoTime = -9999;
	HUDMessages.length = 0;
	PriorityHUDMessages.length = 0;
}

final function GearPawn ResolvePawn(optional out Vehicle WPVehicle, optional out GearVehicle GVehicle)
{
	local GearPawn WP;
	local GearWeaponPawn WeapPawn;
	local Turret TurretPawn;
	local GearPawnRidable_Base RidablePawn;

	WP = GearPawn(ControlledPawn);

	if (WP != none)
	{
		RidablePawn = GearPawnRidable_Base(WP);
	}

	if ( WP == None || WP.bDeleteMe )
	{
		// use the vehicle
		WPVehicle = Vehicle(ControlledPawn);
		GVehicle = GearVehicle(WPVehicle);
		WeapPawn = GearWeaponPawn(WPVehicle);

		// Handle being in passenger seat
		if(WeapPawn != None)
		{
			GVehicle = WeapPawn.MyVehicle;
		}
		if (WPVehicle != None)
		{
			WP = GearPawn(WPVehicle.Driver);
		}
		// try the viewtarget
		if (WP == None)
		{
			WP = GearPawn(PlayerOwner.ViewTarget);
		}
		// maybe a turret?
		if (WP == None)
		{
			TurretPawn = Turret(ControlledPawn);
			if(TurretPawn != None)
			{
				WP = GearPawn(TurretPawn.Driver);
			}
		}
	}
	else if (RidablePawn != none && RidablePawn.bAllowDriverDamage)
	{
		WP = RidablePawn.Driver;
	}

	return WP;
}

/**
 * Possibly draw the overhead map
 *
 * @return TRUE if the map was drawn, FALSE if not
 */
protected function bool MaybeDrawOverheadMPMap()
{
	local GearPC_Siege GPCS;

	GPCS = GearPC_Siege(PlayerOwner);
	if (bDrawOverheadMPMap && (GPCS == None || GPCS.CharSelectMovie == None || !GPCS.CharSelectMovie.bMovieIsOpen))
	{
		if (OverheadMapActor == None)
		{
			foreach AllActors(class'OverheadMapPlacementActor', OverheadMapActor)
			{
				break;
			}
		}
		if (OverheadMapActor != None)
		{
			OverheadMapActor.DrawOverheadMap(self);
			return true;
		}
	}

	return false;
}

function DrawObjectives(float Alpha, bool bUseUpdateCheck)
{
	GearPC(PlayerOwner).ObjectiveMgr.DrawObjectives(self, Alpha,, bUseUpdateCheck);
}

/**
 * The Main Draw loop for the hud.  Gets called before any messaging.  Should be subclassed.
 */
function DrawHUD()
{
	local GearPC PC;
	local GearPawn WP;
	local bool bIsTurreting;
	local float XL, YL;
	local Vehicle WPVehicle;
	local GearVehicle GVehicle;
	local GearPawnRidable_Base GPRidable;
	local GearTurret GT;
	local int Alpha;
	local GearGRI_SP GRISP;
	local bool bVehicleWantsHUD;
	local bool bVehicleWantsCrossHair;
	local int PawnHealth;
	local int PawnDefaultHealth;

	PC = GearPC(PlayerOwner);

	// See if we should show/hide the spectator scene
	CheckSpectatorScene();

	// handle any debug draws
	foreach DebugDrawList(DebugDraw)
	{
		DebugDraw(self);
	}

	if (KismetMessageText != "")
	{

		if(KismetMessageEndTime > 0 && KismetMessageEndTime <= WorldInfo.TimeSeconds)
		{
			KismetMessageText = "";
			KismetMessageEndTime = 0;
		}
		else
		{
			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);//Font'Warfare_HUD.WarfareHUD_Font18pt';
			Canvas.TextSize(KismetMessageText,XL,YL);
			Canvas.SetPos(Canvas.ClipX/2 - XL/2 - 16, Canvas.ClipY/3 - YL/2 - 16);
			Canvas.SetDrawColor(47,47,47,128);
			Canvas.DrawTile(Texture2D'EngineResources.WhiteSquareTexture',XL + 32, YL + 32, 0, 0, 2, 2);
			Canvas.SetPos(Canvas.ClipX/2 - XL/2, Canvas.ClipY/3 - YL/2);
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE],255);
			Canvas.DrawText(KismetMessageText,FALSE);
		}
	}

	// if the hud isn't turned off
	if ( bShowHud &&
		 !HideHUDFromScenes() )
	{
		if (PC != None)
		{
			WP = ResolvePawn(WPVehicle,GVehicle);

			// If we are not dead dead (dead)
			if (WP != None && !WP.bTearOff)
			{
				if (!PC.IsSpectating())
				{
					UpdateHUDLocators();
				}
				// if in assess mode
				if( PC.bAssessMode || (TaccomFadeOpacity > 0.f) )
				{
					// still draw the DBNO indicator in assess mode
					if (!WP.bTearOff && !WP.IsDBNO() && !WP.IsDoingSpecialMove(SM_RecoverFromDBNO))
					{
						if (WP.IsAHostage())
						{
							DrawHealth(WP.InteractionPawn.Health, WP.InteractionPawn.DefaultHealth);
						}
						else
						{
							DrawHealth(WP.Health, WP.DefaultHealth);
						}
					}
					// only draw assess mode
					DrawAssessMode(PC);
				}
				else
				{
					// Give game specific HUD a chance to draw special icons above the heads of players
					DrawSpecialPlayerIcons(WP);

					bIsTurreting = (PC.GetStateName() == 'PlayerTurreting');
					bVehicleWantsHUD = (GVehicle != None && GVehicle.WantsNormalHUD(PlayerOwner)) ? true : false;
					bVehicleWantsCrossHair = (GVehicle != None && GVehicle.WantsCrosshair(PlayerOwner)) ? true : false;
					if ((WPVehicle == None && WP != None) ||
						(GVehicle != None && (bVehicleWantsCrossHair || bVehicleWantsHUD)) ||
						bIsTurreting)
					{
						GT = GearTurret(ControlledPawn);

						if (GVehicle != None)
						{
							// Draw recent completed/received objectives
							DrawObjectives(1.0, true);

							if(GVehicle.bDrawHealthOnHUD)
							{
								DrawHealth(GVehicle.Health, GVehicle.GetVehicleDefaultHealth());
							}
							else if (bVehicleWantsHUD)
							{
								GVehicle.GetPlayerHealth(PlayerOwner, PawnHealth, PawnDefaultHealth);
								DrawHealth(PawnHealth, PawnDefaultHealth);
							}
						}
						else if (WP != None)
						{
							// Draw recent completed/received objectives
							DrawObjectives(1.0, true);

							// draw health indicator
							if (!WP.bTearOff && !WP.IsDBNO() && !WP.IsDoingSpecialMove(SM_RecoverFromDBNO))
							{
								if (WP.IsAHostage())
								{
									DrawHealth(WP.InteractionPawn.Health, WP.InteractionPawn.DefaultHealth);
								}
								else
								{
									DrawHealth(WP.Health, WP.DefaultHealth);
								}
							}
						}

						DrawHitLocationIndicator();

						// crosshair
						if (GVehicle == None || bVehicleWantsCrossHair)
						{
							DrawWeaponCrosshair(PC,WP);
						}

						DrawCoopInteractionMenu();

						// and weapon info (if desired)
						if ( (GVehicle == None || GVehicle.ShouldShowWeaponOnHUD(PC)) &&
							 (GT == None || GT.ShouldShowWeaponOnHUD()) )
						{
							UpdateWeaponIndicator(PC, WP, (ControlledPawn != None) ? ControlledPawn : Pawn(PlayerOwner.ViewTarget));
						}

						//@FIXME: temporarily using this code to also draw weapon/ammo pickup costs
						//if (GearGRI(WorldInfo.GRI) != None && GearGRI(WorldInfo.GRI).bCanPlaceFortifications)
						//{
							DrawFortificationInfo();
						//}

						// If the driver has independent damage, then the ridable pawn should show a health bar.
						GPRidable = GearPawnRidable_Base(ControlledPawn);
						if (GPRidable != none)
						{
							if (GPRidable.bAllowDriverDamage && WorldInfo.TimeSeconds - GPRidable.LastHealthChangeTime < RidablePawnHealthFadeTime)
							{
								Alpha = 255 * (1.0f - (WorldInfo.TimeSeconds - GPRidable.LastHealthChangeTime) / RidablePawnHealthFadeTime);
								DrawRidablePawnHealth(GPRidable, Canvas.SizeX / 2, Canvas.SizeY - 100.0f * WeaponInfoScale, Alpha, 3.0f);
							}

							if (GPRidable.ShouldDrawCoverIcon())
							{
								DrawRidablePawnCoverIcon(GPRidable, Canvas.SizeX / 2, Canvas.SizeY - 100.0f * WeaponInfoScale, 3.0f);
							}
						}

						if (GT != None && GT.OwnerFort != None)
						{
							DrawTurretHealth(GT, Canvas.SizeX / 2, Canvas.SizeY - 100.0f * WeaponInfoScale, 255, 3.0f);
						}
					}

					GRISP = GearGRI_SP(WorldInfo.GRI);
					if (GRISP != None && GRISP.bDrawTowerHealth)
					{
						UpdateTowerHealth(GRISP);
					}

					if (!PC.IsSpectating())
					{
						// draw any action icons
						DrawActions(RenderDelta);
					}

					if ( bInMultiplayerMode && bShowNamesWhenSpectating )
					{
						DrawSpectatingNames(PC, WP);
					}
				}
			}
			else if (!PC.IsInState('ScreenshotMode'))
			{
				if (PC.bAssessMode || TaccomFadeOpacity > 0.0)
				{
					DrawAssessMode(PC);
					if (PC.bAssessMode)
					{
						UpdateHUDLocators();
					}
				}
				else
				{
					UpdateHUDLocators();

					if (WP != None && WP.IsAHostage())
					{
						DrawHealth(WP.InteractionPawn.Health, WP.InteractionPawn.DefaultHealth);
					}
 					else if (!PC.IsSpectating())
 					{
 						// fully dead, show full omen
 						DrawHealth(0, 1);
 					}
					if ( bInMultiplayerMode && bShowNamesWhenSpectating )
					{
						DrawSpectatingNames(PC, WP);
					}
				}
			}
		}

		// draw the countdown
		if (!UpdateCountdown() && bInMultiplayerMode)
		{
			DrawRespawnTimer();
		}

		// Draw the subtitle text
		UpdateSubtitleText();

		if ( bInMultiplayerMode )
		{
			if ( PC.IsInState('Reviving') )
			{
				// make sure we can draw the button mash action icon
				DrawActions(RenderDelta);
			}
		}

		if (WorldInfo.IsPlayingDemo())
		{
			DrawDemoPlaybackHUD();
		}
	}
}

/** Stub for drawing the tower health in the tempest fight */
function UpdateTowerHealth(GearGRI_SP GRISP);

/** renders HUD elements used when playing back a recorded demo */
simulated final function DrawDemoPlaybackHUD()
{
	local array<int> RewindPoints;
	local float Pct, RewindPct;
	local int i, CurrentFrame, TotalFrames;

	// draw progress bar
	WorldInfo.GetDemoFrameInfo(CurrentFrame, TotalFrames);
	Pct = float(CurrentFrame) / TotalFrames;
	// complete part
	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(Canvas.ClipX * 0.15, Canvas.ClipY * 0.075);
	Canvas.DrawBox(Canvas.ClipX * 0.7 * Pct, 4.0);
	// incomplete part
	Canvas.DrawColor = Canvas.DrawColor * 0.5;
	Canvas.CurX = FFloor(Canvas.ClipX * (0.15 + (0.7 * Pct)));
	Canvas.DrawBox(Canvas.ClipX * 0.85 - Canvas.CurX, 4.0);

	if (WorldInfo.GetDemoRewindPoints(RewindPoints))
	{
		// draw a tick for each rewind point
		Canvas.CurY -= 6.0;
		for (i = 0; i < RewindPoints.length; i++)
		{
			RewindPct = float(RewindPoints[i]) / TotalFrames;
			Canvas.DrawColor = (RewindPct <= Pct) ? WhiteColor : (WhiteColor * 0.5);
			Canvas.CurX = FFloor(Canvas.ClipX * (0.15 + (0.7 * RewindPct))) - 1;
			Canvas.DrawBox(3, 16.0);
		}
	}
}

/** Returns the respawn time interval for the game */
simulated function int GetRespawnTimeInterval()
{
	return 15;
}

/** Draw the timer that tells the player when they will respawn */
simulated final protected function DrawRespawnTimer()
{
	local String TimeString;
	local float TextWidth, TextHeight, DrawX, DrawY;
	local int TimeToDraw;
	local GearGRI_MP GRI;

	GRI = GearGRI_MP(WorldInfo.GRI);
	if (GRI != None &&
		GearPC(PlayerOwner).bWaitingToRespawn &&
		GRI.GameStatus == GS_RoundInProgress)
	{
		DrawX = Canvas.ClipX/2;
		DrawY = SafeZoneTop + CountdownSize.Y + 3.f;

		TimeToDraw = GRI.RespawnTime;
		TimeString = CreateTimeString( TimeToDraw );
		Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		Canvas.TextSize( TimeString, TextWidth, TextHeight );
		TextWidth *= 1.2;
		TextHeight *= 1.2;
		DrawX -= TextWidth/2;
		DrawStringWithBackground( DrawX, DrawY, TimeString,, 1.2, 1.2 );
	}
}

/** Update the drawing of the weapon icon */
final protected function UpdateWeaponIndicator(GearPC PC, GearPawn WP, Pawn PawnOwner)
{
	local GearWeapon Weap;
	local bool bIsCurrentlyOn;
	local GearPRI WPRI;

	WPRI = GearPRI(PC.PlayerReplicationInfo);
	Weap = GearWeapon(PawnOwner.Weapon);

	if (Weap != None && WPRI != None && PC.CurrentPPType != eGPP_GameOver)
	{
		if (WalkVolume(PawnOwner.PhysicsVolume) == None || !WalkVolume(PawnOwner.PhysicsVolume).bActive)
		{
			bIsCurrentlyOn = bInMultiplayerMode || (WorldInfo.TimeSeconds - LastWeaponInfoTime < 4.0f) || PC.bIsTargeting || PC.IsButtonActive(GB_RightTrigger) || Weap.IsReloading() || Weap.IsFiring() || PC.IsInCombat() || WPRI.bAlwaysDrawWeaponIndicatorInHUD ;
		}

		// weapon is about to hide (or if we are not always showing it then do not fade it)
		if ( bDrawWeaponIndicator )
		{
			if ( !bIsCurrentlyOn && !WPRI.bAlwaysDrawWeaponIndicatorInHUD )
			{
				bDrawWeaponIndicator = FALSE;
				bIsFadingWeaponIn = FALSE;
				WeaponFadeStartTime = WorldInfo.TimeSeconds - (TotalWeaponFadeTime * (1.f - WeaponFadeOpacity));
			}
		}
		// weapon is about to show
		else if ( bIsCurrentlyOn )
		{
			bDrawWeaponIndicator = TRUE;
			bIsFadingWeaponIn = TRUE;
			WeaponFadeStartTime = WorldInfo.TimeSeconds - (TotalWeaponFadeTime * WeaponFadeOpacity);
		}

		// Determine what the opacity of the Weapon should be.
		if ( bIsFadingWeaponIn || bDrawWeaponIndicator )
		{
			if ( (WeaponFadeStartTime > 0.f) && ((WorldInfo.TimeSeconds - WeaponFadeStartTime) < TotalWeaponFadeTime) )
			{
				WeaponFadeOpacity = (WorldInfo.TimeSeconds - WeaponFadeStartTime) / TotalWeaponFadeTime;
			}
			else
			{
				WeaponFadeOpacity = 1.f;
				bIsFadingWeaponIn = FALSE;
			}
		}
		else if ( !bIsFadingWeaponIn && ((WorldInfo.TimeSeconds - WeaponFadeStartTime) < TotalWeaponFadeTime) && (WeaponFadeStartTime > 0.f) )
		{
			WeaponFadeOpacity = 1.f - ((WorldInfo.TimeSeconds - WeaponFadeStartTime) / TotalWeaponFadeTime);
		}
		else
		{
			WeaponFadeOpacity = 0.f;
			return;
		}

		if( WeaponFadeOpacity <= 0.f )
		{
			return;
		}

		// we always want to see the weapon indicator at full opacity
		if( WPRI.bAlwaysDrawWeaponIndicatorInHUD )
		{
			WeaponFadeOpacity = 1.0f;
		}

		DrawWeaponInfo(PC, WP, Weap, Canvas.ClipX - SafeZoneRight - WeaponInfoFrame.UL,SafeZoneTop,255 * WeaponFadeOpacity, WeaponInfoScale, 1.2f, FALSE,  Weap.bCanActiveReload, FALSE, TRUE);
		DrawOutOfAmmoIndicator(PC, Weap);
	}
	else
	{
		WeaponFadeStartTime = 0.0f;
		bDrawWeaponIndicator = FALSE;
		bIsFadingWeaponIn = FALSE;
		WeaponFadeOpacity = 0.0f;
	}
}

/**
 * Sets the active action for displaying on the HUD.
 */
final event bool SetActionInfo(EActionType NewActionType, ActionInfo NewAction, optional bool bMirrorImage)
{
	local int Idx;
	local Name CurrActionName;

	CurrActionName = ActiveAction.ActionName;

	// if there currently is an active action
	if (ActiveAction.bActive)
	{
		// if the new priority is greater than or equal to the previous priority (0 is highest) and it is a different action
		if ( NewActionType <= ActiveAction.ActionType &&
			 (NewAction.ActionName != ActiveAction.ActionName ||
			 NewAction.ToolTipText != ActiveAction.ToolTipText ||
			 bMirrorImage != ActiveAction.bMirror ||
			 ( ((NewAction.ActionIconDatas.length > 0) && (ActiveAction.ActionIconDatas.length > 0)) &&
			    (NewAction.ActionIconDatas[0].ActionIcons[0] != ActiveAction.ActionIconDatas[0].ActionIcons[0]) ))
			)
		{
			// then de-activate this one
			PreviousAction = ActiveAction;
			PreviousAction.bActive = FALSE;
		}
		else
		{
			// otherwise ignore
			return FALSE;
		}
	}
	// set the new active action
	ActiveAction = NewAction;
	ActiveAction.ActionType = NewActionType;
	ActiveAction.bActive = TRUE;
	ActiveAction.BlendPct = 0.f;
	ActiveAction.ActivateTime = WorldInfo.TimeSeconds;
	ActiveAction.bMirror = bMirrorImage;
	// cache some draw info for the icons
	for (Idx = 0; Idx < ActiveAction.ActionIconDatas.Length; Idx++)
	{
		// total the icon sizes
		ActiveAction.SizeX += ActiveAction.ActionIconDatas[Idx].ActionIcons[0].UL;
		// if not the last element
		if (Idx < ActiveAction.ActionIconDatas.Length - 1)
		{
			// add any spacing
			ActiveAction.SizeX += ActiveAction.IconSpacing;
		}
		// pick the max height
		ActiveAction.SizeY = FMax(ActiveAction.SizeY,ActiveAction.ActionIconDatas[Idx].ActionIcons[0].VL);
	}
	ActiveAction.bCached = TRUE;

	ActionIconAnimInfo.CurrentIconIndex = 0;
	ActionIconAnimInfo.LastActionAnimationSwitch = WorldInfo.TimeSeconds;

	// See if we should trigger the event delegates for being able to execute someone
	if ( (CurrActionName != ActiveAction.ActionName) && (ActiveAction.ActionName == 'CurbStomp') )
	{
		GearPC(PlayerOwner).TriggerGearEventDelegates( eGED_Executions );
	}

	return TRUE;
}

/**
 * Clears the active action if it matches the specified type.
 */
final function bool ClearActionInfoByType(EActionType ActionType)
{
	if (ActiveAction.bActive && ActionType == ActiveAction.ActionType)
	{
		// disable the active action
		ActiveAction.bActive = FALSE;
		ActiveAction.ActionType = AT_None;
		// move to previous so it can be blended
		PreviousAction = ActiveAction;
		return TRUE;
	}
	return FALSE;
}

/** Clear the active action regardless of its type */
final function ClearActiveActionInfo()
{
	ActiveAction.bActive = FALSE;
	ActiveAction.ActionType = AT_None;
}

simulated function GetSubtitleSize(out float Width, out float Height)
{
	if (SubtitleStringDrawStartTime > 0.0 || GearPC(PlayerOwner).IsShowingSubtitles())
	{
		Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		Canvas.TextSize("W", Width, Height);
		Width *= 1.2;
		Height *= 1.2;
	}
}

/** See if we need to remap the buttons based on alternate control schemes */
final function RemapButtonIcon( out ActionInfo Action )
{
	local GearPC GPC;
	local GearPRI PRI;

	GPC = GearPC(PlayerOwner);

	if (Action.ActionName != '')
	{
		// Check for trigger swap
		if ( (GPC.PlayerReplicationInfo != None) && (GearPRI(GPC.PlayerReplicationInfo).TrigConfig != WTCO_Default) )
		{
			// Suicide bomb must show the 'Left Trigger' instead of the 'Right Trigger'
			if ( Action.ActionName == 'SuicideBomb' )
			{
				Action.ActionIconDatas[0].ActionIcons[0] = GPC.GearIcons[eGEARICON_LT];
			}
		}

		// Check for meatbag swap
		if (Action.ActionName == 'GrabMeatShield' && GPC.bChangeExecutionControls)
		{
			Action.ActionIconDatas[0].ActionIcons[0] = GPC.GearIcons[eGEARICON_X];
		}
		// Check for alternate controls
		if ( GPC.bUseAlternateControls )
		{
			// Anything previously shown as 'X' is now 'Y'
			if ( Action.ActionIconDatas[0].ActionIcons[0].U == GPC.GearIcons[eGEARICON_X].U &&
				 Action.ActionIconDatas[0].ActionIcons[0].V == GPC.GearIcons[eGEARICON_X].V )
			{
				Action.ActionIconDatas[0].ActionIcons[0] = GPC.GearIcons[eGEARICON_Y];
			}
			// Anything previously shown as 'Y' is now 'StickClick'
			// except punch face execution's button mash
			else if (((Action.ActionIconDatas[0].ActionIcons[0].U == GPC.GearIcons[eGEARICON_Y].U &&
				Action.ActionIconDatas[0].ActionIcons[0].V == GPC.GearIcons[eGEARICON_Y].V) ||
				(Action.ActionIconDatas[0].ActionIcons[0].U == GPC.GearIcons[eGEARICON_Y_PRESSED].U &&
				Action.ActionIconDatas[0].ActionIcons[0].V == GPC.GearIcons[eGEARICON_Y_PRESSED].V)) &&
				Action.ActionName != 'PunchFace' )
			{
				PRI = GearPRI(GPC.PlayerReplicationInfo);
				if (Action.Actionname == 'LookAtSomething')
				{
					Action.IconAnimationSpeed=0.35f;
				}
				else
				{
					Action.IconAnimationSpeed=0.1f;
				}

				if (PRI != none &&
					(PRI.StickConfig == WSCO_SouthPaw || PRI.StickConfig == WSCO_Legacy))
				{
					Action.ActionIconDatas[0].ActionIcons.length = 2;
					Action.ActionIconDatas[0].ActionIcons[0] = GPC.GearIcons[eGEARICON_LS];
					Action.ActionIconDatas[0].ActionIcons[1] = GPC.GearIcons[eGEARICON_LS_PRESSED];
				}
				else
				{
					Action.ActionIconDatas[0].ActionIcons.length = 2;
					Action.ActionIconDatas[0].ActionIcons[0] = GPC.GearIcons[eGEARICON_RS];
					Action.ActionIconDatas[0].ActionIcons[1] = GPC.GearIcons[eGEARICON_RS_PRESSED];
				}
			}
		}
	}
}

/**
 * Does the actual work of drawing an ActionInfo.
 */
final function DrawActionInfo(float DeltaTime, const out ActionInfo ActionToDraw)
{
	local int Alpha, Idx;
	local float DrawX, DrawY, TextW, TextH, StartY, SubTitleH, SubTitleW;
	local int IconIndex;
	local ActionInfo Action;

	Action = ActionToDraw;

	if (ActionToDraw.bCenterY)
	{
		StartY = Canvas.ClipY / 2.0f;
	}
	// AT_Player should be drawn just under the crosshair
	else if (ActionToDraw.bDrawBelowCrosshair)
	{
		StartY = Canvas.ClipY / 2.0f - 75;
	}
	else
	{
		GetSubtitleSize( SubTitleW, SubTitleH );
		StartY = SafeZoneBottom + SubTitleH;
	}

	Alpha = Action.BlendPct * 255.f;

	if (Alpha > 0)
	{
		if (Len(Action.TooltipText) > 0 && (ActionToDraw.bDrawBelowCrosshair || GearPRI(PlayerOwner.PlayerReplicationInfo) == None || GearPRI(PlayerOwner.PlayerReplicationInfo).bShowPictograms))
		{
			Canvas.Font = class'Engine'.static.GetAdditionalFont(Action.FontIndex);
			Canvas.StrLen(Action.TooltipText, TextW, TextH);
			TextW *= 1.2;
			TextH *= 1.2;
			DrawX = SafeZoneFriendlyCenterX - TextW/2.f;
			DrawY = Canvas.ClipY - StartY - TextH - Action.SizeY;

			// draw the black shadow text
			Canvas.SetPos( DrawX+3, DrawY );
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha);
			Canvas.DrawText(Action.TooltipText,, 1.2, 1.2);
			// Set position for white text
			Canvas.SetPos( DrawX, DrawY-3 );

			// draw the text white
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha);
			Canvas.DrawText(Action.TooltipText,, 1.2, 1.2);
		}

		// draw icons
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha);

		// See if we need to remap the button icon for alternate control scheme
		RemapButtonIcon(Action);

		if (Action.IconAnimationSpeed > 0.0 && ActionIconAnimInfo.LastActionAnimationSwitch + Action.IconAnimationSpeed < WorldInfo.TimeSeconds)
		{
			ActionIconAnimInfo.LastActionAnimationSwitch = WorldInfo.TimeSeconds;
			ActionIconAnimInfo.CurrentIconIndex = (ActionIconAnimInfo.CurrentIconIndex + 1) % Action.ActionIconDatas[0].ActionIcons.length;
		}

		if (GearPRI(PlayerOwner.PlayerReplicationInfo) == None || GearPRI(PlayerOwner.PlayerReplicationInfo).bShowPictograms)
		{
			DrawX = SafeZoneFriendlyCenterX - Action.SizeX/2.f;
			// draw each icon
			for (Idx = 0; Idx < Action.ActionIconDatas.Length; Idx++)
			{
				IconIndex = ActionIconAnimInfo.CurrentIconIndex;
				if ( IconIndex >= Action.ActionIconDatas[Idx].ActionIcons.length )
				{
					IconIndex = 0;
				}

				DrawY = Canvas.ClipY - StartY - Action.SizeY;
				DrawY += Action.SizeY/2.f - Action.ActionIconDatas[Idx].ActionIcons[IconIndex].VL/2.f;

				// check to see if we need to mirror the last icon (ex. cover leans)
				if (Action.bMirror && Idx == Action.ActionIconDatas.Length - 1)
				{
					Canvas.SetPos( DrawX, DrawY );
					Canvas.DrawTile(Action.ActionIconDatas[Idx].ActionIcons[IconIndex].Texture,
						Action.ActionIconDatas[Idx].ActionIcons[IconIndex].UL,
						Action.ActionIconDatas[Idx].ActionIcons[IconIndex].VL,
						Action.ActionIconDatas[Idx].ActionIcons[IconIndex].U+Action.ActionIconDatas[Idx].ActionIcons[0].UL,
						Action.ActionIconDatas[Idx].ActionIcons[IconIndex].V,
						-Action.ActionIconDatas[Idx].ActionIcons[IconIndex].UL,
						Action.ActionIconDatas[Idx].ActionIcons[IconIndex].VL);
				}
				else
				{
					Canvas.DrawIcon(Action.ActionIconDatas[Idx].ActionIcons[IconIndex],DrawX,DrawY);
				}
				DrawX += Action.ActionIconDatas[Idx].ActionIcons[IconIndex].UL + Action.IconSpacing;
			}
		}
	}
}

/**
 * Draw the current action.
 */
function DrawActions(float DeltaTime)
{
	if (!PlayerOwner.IsSpectating() && (!GearPC(PlayerOwner).bIsTargeting || !PlayerOwner.IsSplitscreenPlayer()))
	{
		// if we have an active action
		if (ActiveAction.bActive)
		{
			// figure out the blend pct, instantaneous if it's swapping
			if (PreviousAction.BlendPct > 0.f)
			{
				ActiveAction.BlendPct = 1.0;
			}
			else
			{
				ActiveAction.BlendPct = FClamp(ActiveAction.BlendPct + (1.f/ActionFadeInTime * DeltaTime),0.f,1.f);
			}
			// and draw
			DrawActionInfo(DeltaTime,ActiveAction);
		}
		// check the previous action to see if it's still blending out
		if (PreviousAction.BlendPct > 0.f)
		{
			if (ActiveAction.bActive)
			{
				PreviousAction.BlendPct = 0.f;
			}
			else
			{
				PreviousAction.BlendPct = FClamp(PreviousAction.BlendPct - (1.f/ActionFadeOutTime * DeltaTime),0.f,1.f);
			}
			DrawActionInfo(DeltaTime, PreviousAction);
		}
	}
}


function DrawMPStatus(GearPC PC)
{
	local string Text;

	Canvas.Font = class'Engine'.Static.GetSmallFont();
	`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE] );
	if (PC.IsSpectating())
	{
		Text = "Press fire to spawn...";
	}
	// if any text was set, then draw it
	if (Text != "")
	{
		Canvas.SetPos(SafeZoneLeft, Canvas.ClipY - SafeZoneBottom);
		Canvas.DrawText(Text,FALSE);
	}
}

/**
 * Delegate hook for anything that wants a debug draw.
 *
 * @see: DebugDraws, DrawHUD()
 */
delegate DebugDraw(GearHUD_Base H)
{
}

/**
 * Handy function to add/remove debug draw functions.
 */
function SetDebugDraw(delegate<DebugDraw> DebugDrawFunc, bool bAdd)
{
	local int Idx;
	Idx = DebugDrawList.Find(DebugDrawFunc);
	if (bAdd && Idx == -1)
	{
		DebugDrawList[DebugDrawList.Length] = DebugDrawFunc;
	}
	else
	if (!bAdd && Idx != -1)
	{
		DebugDrawList.Remove(Idx,1);
	}
}

function ToggleDebugDraw(delegate<DebugDraw> DebugDrawFunc)
{
	local int Idx;
	Idx = DebugDrawList.Find(DebugDrawFunc);
	if (Idx != INDEX_None)
	{
		`log("Removing debug draw function");
		DebugDrawList.Remove(Idx,1);
	}
	else
	{
		`log("Adding debug draw function");
		DebugDrawList.AddItem(DebugDrawFunc);
	}
}

function bool IsDebugDrawActive(delegate<DebugDraw> DebugDrawFunc)
{
	return DebugDrawList.Find(DebugDrawFunc) != INDEX_None;
}

/** Start a color Fade */
simulated function ColorFade( Color NewFadeColor, byte FromAlpha, byte ToAlpha, float FadeTime )
{
	// set the new fade color/alpha
	PreviousFadeAlpha	= FromAlpha;
	FadeAlpha = FromAlpha;
	DesiredFadeAlpha	= ToAlpha;
	FadeColor			= NewFadeColor;

	// set the new fade time
	DesiredFadeAlphaTime	= FadeTime;
	FadeAlphaTime			= 0.f;
}

/**
 * Overridden to handle interpolating current fade if any.
 */
function Tick(float DeltaTime)
{
	if (FadeAlphaTime != DesiredFadeAlphaTime)
	{
		if (FadeAlphaDelay > 0.f)
		{
			FadeAlphaDelay -= DeltaTime;
		}
		else
		{
			if (FadeAlphaTime > DesiredFadeAlphaTime)
			{
				FadeAlphaTime = FMax(FadeAlphaTime - DeltaTime, DesiredFadeAlphaTime);
			}
			else
			{
				FadeAlphaTime = FMin(FadeAlphaTime + DeltaTime, DesiredFadeAlphaTime);
			}
		}
		FadeAlpha = lerp( PreviousFadeAlpha, DesiredFadeAlpha, FadeAlphaTime/DesiredFadeAlphaTime );
	}

	// Allow the End of Round scene to update, if needed
	if( EndRoundUIScenePlayerInstance != None )
	{
		EndRoundUIScenePlayerInstance.UpdateWidgetValues();
	}
}


/**
 * This will fade in the camera from black.  The idea is to hide the occlusion query flickers
 * when you zip around the level fast like.
 **/
function SpectatorCameraFadeIn(optional float FadeInTime = 0.25)
{
	// don't mess with any current fading in co-op as it may be script controlled
	if (!bDrawOverheadMPMap && (FadeAlphaTime == DesiredFadeAlphaTime || GearGRI(WorldInfo.GRI) == None || !GearGRI(WorldInfo.GRI).bIsCoop))
	{
		FadeColor = MakeColor(0,0,0,255);
		// if no active fade then start from black
		if (FadeAlpha == 0)
		{
			FadeAlpha = 255;
		}
		PreviousFadeAlpha = FadeAlpha;
		DesiredFadeAlpha = 0;
		FadeAlphaDelay = 0.025f;
		DesiredFadeAlphaTime = FadeInTime;
		FadeAlphaTime = 0.0f;
	}
}

function SpectatorCameraFadeOut(optional bool bAutoFadeIn, optional float FadeInTime = 0.3f)
{
	// don't mess with any current fading in co-op as it may be script controlled
	if (FadeAlphaTime == DesiredFadeAlphaTime || GearGRI(WorldInfo.GRI) == None || !GearGRI(WorldInfo.GRI).bIsCoop)
	{
		ColorFade(MakeColor(0,0,0,255),0,255,FadeInTime - 0.1f);
		if (bAutoFadeIn)
		{
			SetTimer( FadeInTime,FALSE,nameof(SpectatorCameraFadeIn) );
		}
	}
}

/** Draw the omen to indicate health */
final function DrawHealth(int CurrentHealth, int DefaultHealth)
{
	local float HealthPct;

	// not for cinematics
	// don't bother drawing if it would have zero opacity
	if (!PlayerOwner.bCinematicMode && CurrentHealth != DefaultHealth)
	{
		// figure out current health pct
		HealthPct = FClamp(CurrentHealth / float(DefaultHealth), 0.0, 1.0);
		// draw the omen
		OmenMatInst.SetScalarParameterValue('Visibility', 1.0 - HealthPct);
		Canvas.SetPos(Canvas.SizeX * 0.5 - OmenSize * 0.5, Canvas.SizeY * 0.5 - OmenSize * 0.5);
		Canvas.DrawMaterialTile(OmenMatInst, OmenSize, OmenSize, 0, 0, 1, 1);
	}
}

simulated function TargetingModeChanged( bool bIsTargetting )
{
	local bool bShouldDrawCrosshair;
	bShouldDrawCrosshair = ShouldDrawCrosshair(GearPawn(ControlledPawn));
	bIsFadingCrosshairIn = bIsTargetting && bShouldDrawCrosshair;
	if ( bIsFadingCrosshairIn )
	{
		CrosshairFadeStartTime = WorldInfo.TimeSeconds - (TotalCrosshairFadeTime * CrosshairFadeOpacity);
	}
	else if (!bShouldDrawCrosshair)
	{
		CrosshairFadeStartTime = WorldInfo.TimeSeconds - (TotalCrosshairFadeTime * (1.f - CrosshairFadeOpacity));
	}
}

exec function DebugCrosshair()
{
	bAlwaysShowCrosshair = !bAlwaysShowCrosshair;
}

final function bool ShouldDrawCrosshair(GearPawn GP, optional out GearWeapon Weap)
{
	local GearVehicle Vehicle;
	local GearWeaponPawn WeapPawn;
	local GearTurret TurretPawn;

	if (!PlayerOwner.bCinematicMode && !bDrawOverheadMPMap)
	{
		// If camera is following siegebeast projectile
		if( Projectile(PlayerOwner.ViewTarget) != None )
		{
			return FALSE;
		}

		if ( GearPawn(ControlledPawn) == None )
		{
			// in a vehicle?
			Vehicle = GearVehicle(ControlledPawn);
			if (Vehicle != None)
			{
				Weap = Vehicle.Seats[0].Gun;
				return Vehicle.WantsCrosshair(PlayerOwner) || bAlwaysShowCrosshair;
			}

			// in a passenger seat?
			WeapPawn = GearWeaponPawn(ControlledPawn);
			if(WeapPawn != None)
			{
				Weap = WeapPawn.MyVehicleWeapon;
				return WeapPawn.MyVehicle.WantsCrosshair(PlayerOwner) || bAlwaysShowCrosshair;
			}

			// on a turret?
			TurretPawn = GearTurret(ControlledPawn);
			if (TurretPawn != None)
			{
				Weap = GearWeapon(TurretPawn.Weapon);
				return TurretPawn.WantsCrosshair(PlayerOwner) || bAlwaysShowCrosshair;
			}
		}

		// normal gearpawn walking around?
		if (GP != None && GearWeapon(GP.Weapon) != None)
		{
			Weap = GearWeapon(GP.Weapon);
			return (Weap.ShouldDrawCrosshair() && GP.CanFireWeapon(TRUE) && !GP.ShouldDelayFiring(TRUE)) || bAlwaysShowCrosshair;
		}
	}
	return FALSE;
}

final function DrawWeaponCrosshair(GearPC PC, GearPawn WP)
{
	local CanvasIcon CrosshairIcon;
	local float DrawX, DrawY, Scale, MortarTickPercent, XOffset, YOffset;
	local GearWeapon Weap;
	local bool bShouldDrawCrosshair;
	local GearWeap_HeavyMortarBase MortarWeap;
	local MaterialInstanceConstant OverlayMIC;

	// ControlledPawn being none means we're spectating most likely and don't want to draw the crosshair
	bShouldDrawCrosshair = ShouldDrawCrosshair(GearPawn(ControlledPawn),Weap);

	// Determine what the opacity of the crosshair should be.
	if ( bIsFadingCrosshairIn || bShouldDrawCrosshair )
	{
		if ( (CrosshairFadeStartTime > 0.f) && ((WorldInfo.TimeSeconds - CrosshairFadeStartTime) < TotalCrosshairFadeTime) )
		{
			CrosshairFadeOpacity = (WorldInfo.TimeSeconds - CrosshairFadeStartTime) / TotalCrosshairFadeTime;
		}
		else
		{
			CrosshairFadeOpacity = 1.f;
			bIsFadingCrosshairIn = FALSE;
		}
	}
	else if ( !bIsFadingCrosshairIn && ((WorldInfo.TimeSeconds - CrosshairFadeStartTime) < TotalCrosshairFadeTime) && (CrosshairFadeStartTime > 0.f) )
	{
		CrosshairFadeOpacity = 1.f - ((WorldInfo.TimeSeconds - CrosshairFadeStartTime) / TotalCrosshairFadeTime);
	}
	else
	{
		CrosshairFadeOpacity = 0.f;
	}

	if ( CrosshairFadeOpacity > 0.f )
	{
		// no red crosshair for mortar because you can't really hit enemies you're pointing at
		if (bUnfriendlySpotted && UnfriendlyReticleActor != None && VSize(WP.Location - UnfriendlyReticleActor.Location) <= Weap.WeaponRange && GearWeap_HeavyMortarBase(Weap) == None)
		{
			if( bShowReticlePlus )
			{
				if( (WorldInfo.TimeSeconds % ReticlePlusBlinkTime) < (ReticlePlusBlinkTime * 0.5f) )
				{
					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_YELLOW], int(255.f*CrosshairFadeOpacity) );
				}
				else
				{
					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_RED], int(255.f*CrosshairFadeOpacity) );
				}
			}
			else
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_RED], int(255.f*CrosshairFadeOpacity) );
			}
		}
		else
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], int(255.f*CrosshairFadeOpacity) );
		}

		// zoomed weapon overlay (e.g sniper)
		if (WP.bIsZoomed)
		{
			OverlayMIC = Weap.GetZoomedHUDOverlay();
			if (OverlayMIC != None)
			{
				Canvas.SetPos( 0, 0 );
				Canvas.DrawMaterialTile( OverlayMIC, Canvas.ClipX, Canvas.ClipY );
			}
		}

		// crosshair
		CrosshairIcon = Canvas.MakeIcon(Weap.GetCrosshairIcon(PC, XOffset, YOffset));
		Scale = Weap.GetCrossHairScale();

		if (CrosshairIcon.Texture != None)
		{
			if (Weap.bCrosshairExpanding)
			{
				CrosshairIcon.UL = CrosshairIcon.Texture.GetSurfaceWidth() / 2;
				CrosshairIcon.VL = CrosshairIcon.Texture.GetSurfaceHeight() / 2;

				XOffset = CrosshairIcon.UL * (Weap.BaseCrosshairScale - Scale);
				YOffset = CrosshairIcon.VL * (Weap.BaseCrosshairScale - Scale);

				// draw top left
				CrosshairIcon.U = 0;
				CrosshairIcon.V = 0;
				Canvas.DrawIcon(CrosshairIcon, 0.5f * Canvas.ClipX - CrosshairIcon.UL * Weap.BaseCrosshairScale + XOffset, 0.5f * Canvas.ClipY - CrosshairIcon.VL * Weap.BaseCrosshairScale + YOffset, Weap.BaseCrosshairScale);

				// draw top right
				CrosshairIcon.U = CrosshairIcon.UL;
				CrosshairIcon.V = 0;
				Canvas.DrawIcon(CrosshairIcon, 0.5f * Canvas.ClipX - XOffset, 0.5f * Canvas.ClipY - CrosshairIcon.VL * Weap.BaseCrosshairScale + YOffset, Weap.BaseCrosshairScale);

				// draw bottom left
				CrosshairIcon.U = 0;
				CrosshairIcon.V = CrosshairIcon.VL;
				Canvas.DrawIcon(CrosshairIcon, 0.5f * Canvas.ClipX - CrosshairIcon.UL * Weap.BaseCrosshairScale + XOffset, 0.5f * Canvas.ClipY - YOffset, Weap.BaseCrosshairScale);

				// draw bottom right
				CrosshairIcon.U = CrosshairIcon.UL;
				CrosshairIcon.V = CrosshairIcon.VL;
				Canvas.DrawIcon(CrosshairIcon, 0.5f * Canvas.ClipX - XOffset, 0.5f * Canvas.ClipY - YOffset, Weap.BaseCrosshairScale);
			}
			else
			{
				if (Weap.bCrosshairMirrored)
				{
					DrawX = (0.5 - XOffset) * Canvas.ClipX - (CrosshairIcon.UL * Scale);
				}
				else
				{
					DrawX = (0.5 - XOffset) * Canvas.ClipX - (CrosshairIcon.UL * 0.5 * Scale);
				}
				DrawY = (0.5 - YOffset) * Canvas.ClipY - (CrosshairIcon.VL * 0.5 * Scale);
				Canvas.DrawIcon(CrosshairIcon, DrawX, DrawY, Scale);
				if (Weap.bCrosshairMirrored)
				{
					DrawX = (0.5 + XOffset) * Canvas.ClipX;
					CrosshairIcon.U += CrosshairIcon.UL;
					CrosshairIcon.UL = -CrosshairIcon.UL;
					Canvas.DrawIcon(CrosshairIcon, DrawX, DrawY, Scale);
				}
			}
		}

		if (!bUnfriendlySpotted && ActiveAction.bActive)
		{
			// draw the lame 'x' if aiming at a friendly
			if ( ActiveAction.ActionType == AT_PLAYER )
			{
				Canvas.SetDrawColor(180,180,180,180);
				Canvas.SetPos(Canvas.ClipX/2 - FriendlyCrosshair.GetSurfaceWidth()/2 - 1,Canvas.ClipY/2 - FriendlyCrosshair.GetSurfaceHeight()/2);
				Canvas.DrawTexture(FriendlyCrosshair,1.0);
			}
			// Draw the hand icon if aiming at a movable object
			else if ( ActiveAction.ActionType == AT_MovableObject )
			{
				Canvas.SetDrawColor(180,180,180,180);
				Canvas.SetPos(Canvas.ClipX/2 - Texture2D'Warfare_HUD.HUD_InteractXhair'.GetSurfaceWidth()/2 - 1,Canvas.ClipY/2 - Texture2D'Warfare_HUD.HUD_InteractXhair'.GetSurfaceHeight()/2);
				Canvas.DrawTexture(Texture2D'Warfare_HUD.HUD_InteractXhair',1.0);
			}

			if (Weap.bDrawAdditionalCrosshairIfAimingAtFriendly || (ActiveAction.ActionType != AT_PLAYER && ActiveAction.ActionType != AT_MovableObject))
			{
				Weap.DrawAdditionalCrosshair(self);
			}
		}
		else
		{
			Weap.DrawAdditionalCrosshair(self);
		}

		MortarWeap = GearWeap_HeavyMortarBase(Weap);
		if ( MortarWeap != None )
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], int(255.f*CrosshairFadeOpacity) );

			MortarTickPercent = MortarWeap.GetSlottedElevationPct(MortarWeap.LastLastElevationPct);
			if ( MortarTickPercent > 0.0f )
			{
				Canvas.DrawIcon( MortarCrosshairSaveIcon, DrawX, DrawY+86*Scale-MortarTickPercent*56*Scale, Scale );
			}

			MortarTickPercent = MortarWeap.GetSlottedElevationPct(MortarWeap.CurrentElevationPct);
			Canvas.DrawIcon( MortarCrosshairTickIcon, DrawX, DrawY+86*Scale-MortarTickPercent*56*Scale, Scale );

			if (LastMortarTickPercent < MortarTickPercent)
			{
				LastMortarTickPercent = FInterpTo(LastMortarTickPercent,MortarTickPercent,RenderDelta,16.f);
			}
			else
			{
				LastMortarTickPercent = MortarTickPercent;
			}
			Canvas.SetPos(DrawX + 90.f,DrawY + 60.f);
			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
			Canvas.DrawText((50 + int(LastMortarTickPercent * 100))$"m",FALSE);
		}
	}

	`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE],255 );
}

/** Draw the interaction menu for ammo share, money share, coop taunt, etc. */
function DrawCoopInteractionMenu()
{
	local float DrawX, DrawY;
	local float XL, YL;

	// Determine the opacity of the menu
	if (ActiveAction.bActive && ActiveAction.ActionType == AT_PLAYER)
	{
		CoopMenuOpacity = FMin(CoopMenuOpacity + WorldInfo.DeltaSeconds * CoopMenuFadeRate, 1.0f);
	}
	else
	{
		CoopMenuOpacity = FMax(CoopMenuOpacity - WorldInfo.DeltaSeconds * CoopMenuFadeRate, 0.0f);
	}

	if (CoopMenuOpacity > 0 && GearPC(PlayerOwner).bCanUseCoopInteractionMenu)
	{
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], 255 * CoopMenuOpacity);
		Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);

		if (GearPC(PlayerOwner).CanDoSpecialMove(SM_ShareAmmo))
		{
			Canvas.TextSize(CoopInteractionShareAmmoText, XL, YL);
			DrawX = Canvas.ClipX/2 - XL/2;
			DrawY = Canvas.ClipY/2 - YButtonIcon.VL/2 - YButtonIcon.VL * 1.5 - YL;
			Canvas.SetPos(DrawX, DrawY);
			Canvas.DrawText(CoopInteractionShareAmmoText,FALSE);
			Canvas.DrawIcon(YButtonIcon, Canvas.ClipX/2 - YButtonIcon.UL/2, Canvas.ClipY/2 - YButtonIcon.VL/2 - YButtonIcon.VL * 1.5);
		}

		if (GearPC(PlayerOwner).CanDoSpecialMove(SM_TradeWeapons))
		{
			Canvas.TextSize(CoopInteractionTradeWeaponsText, XL, YL);
			DrawX = Canvas.ClipX/2 - XButtonIcon.UL/2 - XButtonIcon.UL * 2 - XL;
			DrawY = Canvas.ClipY/2 - YL/2;
			Canvas.SetPos(DrawX, DrawY);
			Canvas.DrawText(CoopInteractionTradeWeaponsText,FALSE);
			Canvas.DrawIcon(XButtonIcon, Canvas.ClipX/2 - XButtonIcon.UL/2 - XButtonIcon.UL * 2, Canvas.ClipY/2 - XButtonIcon.VL/2);
		}

		if (GearPC(PlayerOwner).MyGearPawn.CanGiveMoney())
		{
			Canvas.TextSize(CoopInteractionGiveMoneyText, XL, YL);
			DrawX = Canvas.ClipX/2 - BButtonIcon.UL/2 + BButtonIcon.UL * 3;
			DrawY = Canvas.ClipY/2 - YL/2;
			Canvas.SetPos(DrawX, DrawY);
			Canvas.DrawText(CoopInteractionGiveMoneyText,FALSE);
			Canvas.DrawIcon(BButtonIcon, Canvas.ClipX/2 - BButtonIcon.UL/2 + BButtonIcon.UL * 2, Canvas.ClipY/2 - BButtonIcon.VL/2);
		}

		if (GearPC(PlayerOwner).CanDoSpecialMove(SM_TradeWeaponsSecondaryAI))
		{
			Canvas.TextSize(CoopInteractionTradeSecondaryWeaponsText, XL, YL);
			DrawX = Canvas.ClipX/2 - XL/2;
			DrawY = Canvas.ClipY/2 - AButtonIcon.VL/2 + AButtonIcon.VL * 2.5 + 30.0f;
			Canvas.SetPos(DrawX, DrawY);
			Canvas.DrawText(CoopInteractionTradeSecondaryWeaponsText,FALSE);
			Canvas.DrawIcon(AButtonIcon, Canvas.ClipX/2 - AButtonIcon.UL/2, Canvas.ClipY/2 - AButtonIcon.VL/2 + AButtonIcon.VL * 1.5 + 30.0f);
		}
	}
}

function DrawOvertime()
{
	StartDrawingDramaticText( OverTimeString, "", 8.0f, 0.25f, 2.0f, GetCountdownYPosition() + CountdownSize.Y + GearPC(PlayerOwner).NumPixelsToMoveDownForDramaText(), 0.25f, 2.0f );
}

/**
 * Adds a new hit locator entry for drawing in DrawHitLocationIndicator().
 */
final function AddNewHitLocatorData( Actor InstigatorA, int DamageReceived, optional vector HitLocation, optional bool bDirLocked )
{
	local GearPawn GP;
	local GearVehicle GVehicle;
	local int i, LocatorIndex;
	local bool bFound;
	local vector HitDir;

	GP = ResolvePawn(,GVehicle);
	if (GP != None || GVehicle != None)
	{
		// try to reuse an existing one from about the same direction
		HitDir = Normal(HitLocation - GP.Location);
		for (i = 0; i < MAX_HIT_LOCATORS; i++)
		{
			if (HitLocatorList[i].HitLocationFadePercent > 0.0 && HitDir dot Normal(HitLocatorList[i].HitLocation - GP.Location) > 0.996) // ~5 degrees
			{
				LocatorIndex = i;
				bFound = true;
				break;
			}
		}
		if (!bFound)
		{
			// wrap around the list if necessary
			if (++CurrHitLocatorDataIndex >= MAX_HIT_LOCATORS)
			{
				CurrHitLocatorDataIndex = 0;
			}
			LocatorIndex = CurrHitLocatorDataIndex;
			HitLocatorList[LocatorIndex].TotalDamage = 0;
			if (HitLocatorList[LocatorIndex].MILocation != None)
			{
				HitLocatorList[LocatorIndex].MILocation.ClearParameterValues();
			}
		}
		HitLocatorList[LocatorIndex].TotalDamage += DamageReceived;
		HitLocatorList[LocatorIndex].ActorWhoShotMe = InstigatorA;
		HitLocatorList[LocatorIndex].HitLocation = HitLocation;
		if (bDirLocked)
		{
			HitLocatorList[LocatorIndex].DirOfHit = CalculateLocationMaterialEffect(HitLocatorList[LocatorIndex].HitLocation);
		}
		HitLocatorList[LocatorIndex].bDirLocked = bDirLocked;
		HitLocatorList[LocatorIndex].HitLocationFadePercent = 1.0f;
		// initialize the material if needed
		if (HitLocatorList[LocatorIndex].MILocation == None)
		{
			HitLocatorList[LocatorIndex].MILocation = new(self) class'MaterialInstanceConstant';
			HitLocatorList[LocatorIndex].MILocation.SetParent(HitLocatorMaterial);
		}
		// extra warning based on the amount of damage done
		if (GP != None)
		{
			HitLocatorList[LocatorIndex].MILocation.SetScalarParameterValue('HUD_DamageDir_Warning', HitLocatorList[LocatorIndex].TotalDamage / (GP.DefaultHealth * 0.6));
		}

		// Change the color and fadeout time when in the submarine
		if (Vehicle_Submarine_Base(GVehicle) != None)
		{
			HitLocatorList[LocatorIndex].MILocation.SetVectorParameterValue('HUD_DamgeDir_Color', Vehicle_Submarine_Base(GVehicle).HUDSonarColor);
			HitLocatorList[LocatorIndex].HitLocationFadePercent = 0.5f;
		}
	}
}

/** Clear the hit indicators */
final function ClearHitLocatorData()
{
	local int Idx;

	for ( Idx = 0; Idx < MAX_HIT_LOCATORS; Idx++ )
	{
		HitLocatorList[Idx].HitLocationFadePercent = 0.0f;
	}
}


/**
 * This will determine which value to update the hit locater material with
 **/
final function float CalculateLocationMaterialEffect( vector LocationToTest )
{
	local Vector Loc, AxisX, AxisY, AxisZ, ShotDirection;
	local Rotator Rot;
	local float DirOfHit_L, PositionInQuadrant;
	local bool bIsInFront;
	local vector2D	AngularDist;
	local Pawn P;

	if ( PlayerOwner != None )
	{
		PlayerOwner.GetPlayerViewPoint( Loc, Rot );
	}
	else
	{
		P = ResolvePawn();
		if( P != None )
		{
			Loc = P.Location;
			Rot = P.Rotation;
		}
		// we have nothing so return straight up
		else
		{
			return 0.0;
		}
	}

	GetAxes(Rot, AxisX, AxisY, AxisZ);
	ShotDirection = -1.0 * Normal(Loc - LocationToTest);

	bIsInFront = GetAngularDistance( AngularDist, ShotDirection, AxisX, AxisY, AxisZ );
	GetAngularDegreesFromRadians( AngularDist );

	PositionInQuadrant = Abs(AngularDist.X) * 0.00278; // 0.00278 = 0.25/90.0

	//`log( "bIsInFront: " $ bIsInFront @ "AngularDist: " $ AngularDist.X @ "PositionInQuadrant" @ PositionInQuadrant @ "Abs(AngularDist.X)" @ Abs(AngularDist.X) @ "Multiplier" @ Multiplier );

	// 0 - .25  UpperRight
	// .25 - .50 LowerRight
	// .50 - .75 LowerLeft
	// .75 - 1 UpperLeft
	if( bIsInFront )
	{
	   if( AngularDist.X > 0 )
	   {
		   DirOfHit_L = PositionInQuadrant;
	   }
	   else
	   {
		   DirOfHit_L = 0.0 - PositionInQuadrant;
	   }
	}
	else
	{
		if( AngularDist.X > 0 )
		{
		   DirOfHit_L = 0.5 - PositionInQuadrant;
		}
	   else
	   {
		   DirOfHit_L = 0.5 + PositionInQuadrant;
	   }
	}

	DirOfHit_L = -1 * DirOfHit_L;

	//`log( "DirOfHit_L" @ DirOfHit_L @ "QuadrantStart" @ QuadrantStart @ "PositionInQuadrant" @ PositionInQuadrant @ "Abs(AngularDist.X)" @ Abs(AngularDist.X) @ "Multiplier" @ Multiplier );

	return DirOfHit_L;
}

function float CalculateRevivePercentAlive( GearPawn AGearPawn )
{
	return FClamp(1.0 - ((WorldInfo.TimeSeconds - AGearPawn.TimeOfDBNO) / AGearPawn.GetRevivalTime()), 0.0, 1.0);
}

simulated function SetBleedOutEffectSettings( float TotalTime )
{
	BleedOutPPSettings.Bloom_InterpolationDuration = TotalTime;
	BleedOutPPSettings.DOF_InterpolationDuration = TotalTime;
	BleedOutPPSettings.Scene_InterpolationDuration = TotalTime;
}

simulated function SetTaccomPostProcessSettings()
{
	TaccomPPSettings = LocalPlayer(PlayerOwner.Player).CurrentPPInfo.LastSettings;
	TaccomPPSettings.Scene_InterpolationDuration = TotalTaccomFadeTime;
	TaccomPPSettings.bOverride_Scene_ColorGradingLUT = TRUE;
	TaccomPPSettings.ColorGrading_LookupTable = Texture2D'Interface_Taccom2.LUT_Taccom01';
	TaccomPPSettings.Scene_HighLights = vect(1,1,1);
	TaccomPPSettings.Scene_MidTones = vect(1,1,1);
	TaccomPPSettings.Scene_Shadows = vect(0,0,0);
}

final function DrawHitLocationIndicator()
{
	local float DrawX, DrawY;
	local int Index;
	local LinearColor LinColor;

	// hitlocator material size is hard-coded to 256x256
	DrawX = CenterX - 128;
	DrawY = CenterY - 128;
	for( Index = 0; Index < MAX_HIT_LOCATORS; ++Index )
	{
		if( HitLocatorList[Index].HitLocationFadePercent > 0.f )
		{
			// calculate the rotation based on the hit location
			if ( !HitLocatorList[Index].bDirLocked )
			{
				if ( !IsZero(HitLocatorList[Index].HitLocation) )
				{
					HitLocatorList[Index].DirOfHit = CalculateLocationMaterialEffect( HitLocatorList[Index].HitLocation );
				}
				// calculate the rotation based on the current player orientation versus the actor who hit us
				else if ( HitLocatorList[Index].ActorWhoShotMe != None )
				{
					HitLocatorList[Index].DirOfHit = CalculateLocationMaterialEffect( HitLocatorList[Index].ActorWhoShotMe.Location );
				}
			}
			LinColor.R = HitLocatorList[Index].DirOfHit;
			LinColor.A = 1.0;
			HitLocatorList[Index].MILocation.SetVectorParameterValue( 'HUD_Damage_Rotator', LinColor );
			HitLocatorList[Index].HitLocationFadePercent -= RenderDelta; //0.05;  // 5%
			LinColor.R = HitLocatorList[Index].HitLocationFadePercent;
			HitLocatorList[Index].MILocation.SetVectorParameterValue( 'Hit_Fade', LinColor );
			Canvas.SetPos(DrawX,DrawY);
			Canvas.DrawMaterialTile(HitLocatorList[Index].MILocation, 256, 256, 0, 0, 1.f, 1.f);
		}
	}
}

final function DrawAmmo( GearWeapon Weap, int Alpha, float AmmoPerIcon, out float RemainingAmmo, out float DrawX, out float DrawY, float Scale, bool bHighlight )
{
	local CanvasIcon AmmoIcon;

	if ( RemainingAmmo > 0 )
	{
		AmmoIcon = Weap.HUDDrawData.AmmoIcon;
		Canvas.SetPos( DrawX, DrawY );
		if ( bHighlight )
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha );
		}
		else
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
		}
		Canvas.DrawTile( AmmoIcon.Texture, ((RemainingAmmo-Weap.ActiveReload_NumBonusShots)/AmmoPerIcon)*Weap.GetPixelWidthOfAmmo()*Scale, AmmoIcon.VL*Scale, AmmoIcon.U, AmmoIcon.V, ((RemainingAmmo-Weap.ActiveReload_NumBonusShots)/AmmoPerIcon)*Weap.GetPixelWidthOfAmmo(), AmmoIcon.VL );

		if ( Weap.IsReloading() )
		{
			DrawX += (RemainingAmmo/AmmoPerIcon)*Weap.GetPixelWidthOfAmmo()*Scale;
			RemainingAmmo -= RemainingAmmo-Weap.ActiveReload_NumBonusShots;
		}
		else
		{
			DrawX += ((RemainingAmmo-Weap.ActiveReload_NumBonusShots)/AmmoPerIcon)*Weap.GetPixelWidthOfAmmo()*Scale;
			RemainingAmmo -= RemainingAmmo-Weap.ActiveReload_NumBonusShots;
		}
	}
}

final function DrawSuperAmmo( GearWeapon Weap, int Alpha, float AmmoPerIcon, out float RemainingAmmo, out float DrawX, out float DrawY, float Scale, bool bHighlite )
{
	local CanvasIcon AmmoIcon;
	local LinearColor LinColor;

	if ( Weap.ActiveReload_NumBonusShots > 0 )
	{
		AmmoIcon = Weap.HUDDrawDataSuper.AmmoIcon;

		// scalar for the coordinates of the panning texture, lower value enlarges, defaulted to 1.5
		//ActiveReloadPulseMaterialConstant.SetScalarParameterValue( 'HUD_Element_TScale',  );

		// brightness of the pulse
		//ActiveReloadPulseMaterialConstant.SetScalarParameterValue( 'HUD_Element_TValue',  );

		// color of the material and the alpha
		LinColor = MakeLinearColor(0.25f, 0.25f, 0.25f, 1.0f*(Alpha/255.f));
		ActiveReloadPulseMaterialConstant.SetVectorParameterValue( 'HUD_Elementcolor', LinColor );

		if ( bHighlite )
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha );
		}
		else
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
		}
		Canvas.SetPos( DrawX, DrawY ) ;
		Canvas.DrawMaterialTile( ActiveReloadPulseMaterialConstant, (Weap.ActiveReload_NumBonusShots/AmmoPerIcon)*Weap.GetPixelWidthOfAmmo()*Scale, AmmoIcon.VL*Scale, AmmoIcon.U/512, AmmoIcon.V/512, ((Weap.ActiveReload_NumBonusShots/AmmoPerIcon)*Weap.GetPixelWidthOfAmmo())/512, AmmoIcon.VL/512 );
		DrawX += (Weap.ActiveReload_NumBonusShots/AmmoPerIcon)*Weap.GetPixelWidthOfAmmo()*Scale;
		RemainingAmmo -= Weap.ActiveReload_NumBonusShots;
	}
}

final function DrawEmptyAmmo( GearWeapon Weap, int Alpha, float DrawX, float DrawY, float Scale )
{
	local CanvasIcon AmmoIcon;

	AmmoIcon = Weap.HUDDrawData.AmmoIcon;
	Canvas.SetPos( DrawX, DrawY ) ;
	Canvas.SetDrawColor(47,47,47,Alpha);
	Canvas.DrawTile( AmmoIcon.Texture, AmmoIcon.UL*Scale, AmmoIcon.VL*Scale, AmmoIcon.U, AmmoIcon.V, AmmoIcon.UL, AmmoIcon.VL );
}

final function DrawWeaponIcon( GearWeapon Weap, float DrawX, float DrawY, int Alpha, float Scale )
{
	local float FlashValue;

	if ( Weap.IsReloading() && (ARBarData.ARResult == eARResult_SuperSuccess) )
	{
		FlashValue = (WorldInfo.TimeSeconds % 0.25f) / 0.25f;
	}
	else
	{
		FlashValue = 1.f;
	}

	`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha*FlashValue );
	Canvas.DrawIcon(Weap.WeaponIcon,DrawX,DrawY,0.85f*Scale);
}

final function SetWeaponSelectColor( int Alpha )
{
	local float MaxWhite, MinWhite, CurrWhite, CurrTime, IntervalTime, CurrBlinkTime;
	local int CurrInterval;

	MaxWhite = 255;
	MinWhite = 200;
	CurrTime = WorldInfo.TimeSeconds;

	if ( CurrTime >= WeaponSelect.StartBlinkTime + WeaponSelect.TotalBlinkTime )
	{
		Canvas.SetDrawColor( MinWhite, MinWhite, MinWhite, Alpha );
	}
	else
	{
		IntervalTime = WeaponSelect.TotalBlinkTime/(WeaponSelect.TotalNumBlinks*2);
		CurrBlinkTime = CurrTime - WeaponSelect.StartBlinkTime;
		CurrInterval = int(CurrBlinkTime/IntervalTime);
		// Going from Max to Min
		if ( CurrInterval%2 == 0 )
		{
			CurrWhite = lerp( MaxWhite, MinWhite, (CurrBlinkTime-CurrInterval*IntervalTime)/IntervalTime );
			Canvas.SetDrawColor( CurrWhite, CurrWhite, CurrWhite, Alpha );
		}
		else
		{
			CurrWhite = lerp( MinWhite, MaxWhite, (CurrBlinkTime-CurrInterval*IntervalTime)/IntervalTime );
			Canvas.SetDrawColor( CurrWhite, CurrWhite, CurrWhite, Alpha );
		}
	}
}

final function ClearWeaponSelectData()
{
	WeaponSelect.StartBlinkTime = WorldInfo.TimeSeconds;
}

/**
 * Called when an AR is successful
 */
simulated function ActiveReloadSuccess( bool bDidSuperSweetReload )
{
	local GearPC PC;
	local GearWeapon Weap;

	PC = GearPC(PlayerOwner);
	Weap = GearWeapon(PC.Pawn.Weapon);

	if ( bDidSuperSweetReload )
	{
		ARBarData.ARResult = eARResult_SuperSuccess;
	}
	else
	{
		ARBarData.ARResult = eARResult_Success;
	}
	ARBarData.ARResultTime = WorldInfo.TimeSeconds;

	if (PC != None && PC.StatManager != None && Weap != None)
	{
		if (ARBarData.ARResult == eARResult_Success)
		{
			PC.StatManager.ModifyStat(name(Weap.default.WeaponStatName $ "ARSuccess" $ class<GearGame>(WorldInfo.GRI.GameClass).default.StatGametypeSuffix),1,GEARSTATMODTYPE_Delta);
		}
		else
		{
			// All successful reloads
			PC.StatManager.ModifyStat(name('WeaponARSuperSuccess' $ class<GearGame>(WorldInfo.GRI.GameClass).default.StatGametypeSuffix),1,GEARSTATMODTYPE_Delta);

			// By weapon
			PC.StatManager.ModifyStat(name(Weap.default.WeaponStatName $ "ARSuperSuccess" $ class<GearGame>(WorldInfo.GRI.GameClass).default.StatGametypeSuffix),1,GEARSTATMODTYPE_Delta);
		}

	}
}

/**
 * Called when an AR is unsuccessful
 */
simulated function ActiveReloadFail( bool bFailedActiveReload )
{
	local GearPC PC;
	local GearWeapon Weap;

	PC = GearPC(PlayerOwner);
	Weap = GearWeapon(PC.Pawn.Weapon);

	ARBarData.ARResult = eARResult_Failed;
	ARBarData.ARResultTime = WorldInfo.TimeSeconds;

	if (PC != None && PC.StatManager != None && Weap != None)
	{
		PC.StatManager.ModifyStat(name(Weap.default.WeaponStatName $ "ARFail" $ class<GearGame>(WorldInfo.GRI.GameClass).default.StatGametypeSuffix),1,GEARSTATMODTYPE_Delta);
	}
}

/**
 * Resets the active reload data
 */
simulated function ResetActiveReload()
{
	ARBarData.ARResult = eARResult_None;
	ARBarData.TickMarkTime = WorldInfo.TimeSeconds;
	ARBarData.ARResultTime = 0.0;
}

final function DrawActionReloadBar( GearWeapon Weap, float DrawX, float DrawY, int Alpha, float Scale )
{
	local float ActiveReloadStartTime, SuperSweetSpotOffset, SuperSweetSpotDuration, SweetSpotDuration;
	local int StartSuperSweetBox, EndSuperSweetBox, StartSweetBox, EndSweetBox, StopLocationX;
	local float BarLength, FadeAlphaPercent, FlashAlphaPercent, ARTimeLeft;
	local EGearHUDColor eARColor;
	local float SuperSweetSpotStartTime;

	// get the ar values
	Weap.GetActiveReloadValues(ActiveReloadStartTime,SuperSweetSpotOffset,SuperSweetSpotDuration,SweetSpotDuration);

	// if the player failed everything is colored red, else it's white as normal
	if ( ARBarData.ARResult != eARResult_Failed )
	{
		eARColor = eWARHUDCOLOR_WHITE;
	}
	else
	{
		eARColor = eWARHUDCOLOR_RED;
	}

	// calc the time left in the AR
	ARTimeLeft = Weap.ReloadStartTime + Weap.ReloadDuration - WorldInfo.TimeSeconds;
	if ( ARTimeLeft < ARBarData.FadeDuration )
	{
		FadeAlphaPercent = ARTimeLeft / ARBarData.FadeDuration;
		FlashAlphaPercent = FadeAlphaPercent;
	}
	else
	{
		FadeAlphaPercent = 1.f;
		FlashAlphaPercent = FadeAlphaPercent;
	}

	SuperSweetSpotStartTime = (ActiveReloadStartTime + SuperSweetSpotOffset);
	// AR not attempted yet
	if ( !Weap.bActiveReloadAttempted )
	{
		// update the tick time
		ARBarData.TickMarkTime = WorldInfo.TimeSeconds - Weap.ReloadStartTime;

		// let's be trixy and speed up the tickmark until we hit the supersweetspot
		if (SuperSweetSpotOffset == 0 && ARBarData.TickMarkTime < SuperSweetSpotStartTime)
		{
			ARBarData.TickMarkTime = ((ARBarData.TickMarkTime ** 4.f) / (SuperSweetSpotStartTime ** 4.f)) * SuperSweetSpotStartTime;
		}

	}
	// AR has been attempted
	else
	{
		ARBarData.TickMarkTime = Weap.AR_TimeActiveReloadAttempted - Weap.ReloadStartTime;

		// let's be trixy and speed up the tickmark until we hit the supersweetspot
		if (SuperSweetSpotOffset == 0 && ARBarData.TickMarkTime < SuperSweetSpotStartTime)
		{
			ARBarData.TickMarkTime = ((ARBarData.TickMarkTime ** 4.f) / (SuperSweetSpotStartTime ** 4.f)) * SuperSweetSpotStartTime;
		}

		// recalc time left
		ARTimeLeft = FMin(ARTimeLeft, ARBarData.FlashDuration - (WorldInfo.TimeSeconds - ARBarData.ARResultTime));

		// calc the alpha on the flash
		FlashAlphaPercent = FClamp(ARTimeLeft / ARBarData.FlashDuration, 0.0, 1.0);
		FadeAlphaPercent = FClamp((ARBarData.FadeDuration - (WorldInfo.TimeSeconds - Weap.ReloadStartTime - ARBarData.TickMarkTime)) / ARBarData.FadeDuration, 0.0, 1.0);
		FadeAlphaPercent = FMin(FadeAlphaPercent, FlashAlphaPercent);
	}

	// early out if we alpha out
	if ( (FadeAlphaPercent <= 0.f) && (FlashAlphaPercent < 0.f) )
	{
		return;
	}

	BarLength = ARBarData.BackGround.UL * Scale;


	// draw background
	`SetHUDDrawColor(HudColors[eARColor], byte(Alpha*FadeAlphaPercent) );
	Canvas.SetPos( DrawX, DrawY );
	Canvas.DrawTile( ARBarData.BackGround.Texture, BarLength, ARBarData.BackGround.VL, ARBarData.BackGround.U, ARBarData.BackGround.V, ARBarData.BackGround.UL, ARBarData.BackGround.VL );

	// everything below is centered on the background
	DrawY += ARBarData.BackGround.VL * 0.5;

	// calculate sweet box locations
	StartSuperSweetBox = int((ActiveReloadStartTime + SuperSweetSpotOffset)/ Weap.ReloadDuration * BarLength);
	EndSuperSweetBox = int((ActiveReloadStartTime + SuperSweetSpotOffset + SuperSweetSpotDuration) / Weap.ReloadDuration * BarLength);

	if (SuperSweetSpotOffset > 0)
	{
		StartSweetBox = int(ActiveReloadStartTime / Weap.ReloadDuration * BarLength);
	}
	else
	{
		StartSweetBox = int((ActiveReloadStartTime ** 4.f) / (SuperSweetSpotStartTime ** 4.f) * SuperSweetSpotStartTime / Weap.ReloadDuration * BarLength);
	}

	EndSweetBox = int((ActiveReloadStartTime + SuperSweetSpotDuration + SweetSpotDuration) / Weap.ReloadDuration * BarLength);

	// fix up any overlapping of the sweet boxes
	if (StartSweetBox >= StartSuperSweetBox && StartSweetBox <= EndSuperSweetBox)
	{
		StartSweetBox = EndSuperSweetBox - (EndSuperSweetBox - StartSuperSweetBox) / 3;
	}

	if (EndSweetBox >= StartSuperSweetBox && EndSweetBox <= EndSuperSweetBox)
	{
		EndSweetBox = StartSuperSweetBox + (EndSuperSweetBox - StartSuperSweetBox) / 3;
	}

	// draw sweet box
	`SetHUDDrawColor(HudColors[eARColor], byte(FlashAlphaPercent * 255.f) );
	Canvas.SetPos( DrawX + StartSweetBox, DrawY - (ARBarData.SuccessRegion.VL * 0.5) );
	Canvas.DrawTile( ARBarData.SuccessRegion.Texture, EndSweetBox-StartSweetBox, ARBarData.SuccessRegion.VL, ARBarData.SuccessRegion.U, ARBarData.SuccessRegion.V, ARBarData.SuccessRegion.UL, ARBarData.SuccessRegion.VL );

	// draw super sweet box
	`SetHUDDrawColor(HudColors[eARColor], byte(FlashAlphaPercent * 255.f) );
	Canvas.SetPos( DrawX + StartSuperSweetBox, DrawY - (ARBarData.PerfectGrade.VL * 0.5) );
	Canvas.DrawTile( ARBarData.PerfectGrade.Texture, EndSuperSweetBox-StartSuperSweetBox, ARBarData.PerfectGrade.VL, ARBarData.PerfectGrade.U, ARBarData.PerfectGrade.V, ARBarData.PerfectGrade.UL, ARBarData.PerfectGrade.VL );

	// draw tick mark
	`SetHUDDrawColor(HudColors[eARColor], Alpha*FlashAlphaPercent );
	StopLocationX = DrawX + (ARBarData.TickMarkTime / Weap.ReloadDuration * BarLength) - ARBarData.TickMark.UL/2;
	Canvas.SetPos( StopLocationX, DrawY - ARBarData.TickMark.VL/2 );
	Canvas.DrawTile( ARBarData.TickMark.Texture, ARBarData.TickMark.UL, ARBarData.TickMark.VL, ARBarData.TickMark.U, ARBarData.TickMark.V, ARBarData.TickMark.UL, ARBarData.TickMark.VL );

	// draw super sweet gradient
	if ( ARBarData.ARResult == eARResult_SuperSuccess )
	{
		`SetHUDDrawColor(HudColors[eARColor], Alpha*FlashAlphaPercent );
		Canvas.SetPos( DrawX, DrawY - (ARBarData.Flash.VL * 0.5) );
		Canvas.DrawTile( ARBarData.Flash.Texture, BarLength, ARBarData.Flash.VL, ARBarData.Flash.U, ARBarData.Flash.V, ARBarData.Flash.UL, ARBarData.Flash.VL );
	}
	// draw the other gradient
	else if ( (ARBarData.ARResult == eARResult_Success) || (ARBarData.ARResult == eARResult_Failed) )
	{
		`SetHUDDrawColor(HudColors[eARColor], Alpha*FlashAlphaPercent );
		// draw at the tick, clamped to the bar
		StopLocationX = Clamp(StopLocationX,DrawX + ARBarData.GoodGrade.UL/2,DrawX + BarLength - ARBarData.GoodGrade.UL/2);
		Canvas.SetPos( StopLocationX-ARBarData.GoodGrade.UL/2, DrawY - (ARBarData.GoodGrade.VL * 0.5) );
		Canvas.DrawTile( ARBarData.GoodGrade.Texture, ARBarData.GoodGrade.UL, ARBarData.GoodGrade.VL, ARBarData.GoodGrade.U, ARBarData.GoodGrade.V, ARBarData.GoodGrade.UL, ARBarData.GoodGrade.VL );
	}
}

final function DrawWeaponInfo(GearPC PC, GearPawn WP, GearWeapon Weap, float DrawX, float DrawY, int Alpha, float Scale, float FrameScale, optional bool bHighlight, optional bool bDrawAR, optional bool bDrawEmptyVersion, optional bool bIsMainIndicator)
{
	local float RemainingAmmo, AmmoPerIcon;
	local int IconCount;
	local string MagText;
	local float MagazineSize, OrigDrawX, OrigDrawY, Heat, HeatColorPercent;
	local EGearSpecialIconType SpecialIconType;
	local CanvasIcon SpecialIcon;
	local bool bHeatLimitedWeapon;
	local GearWeap_HeavyCoopMGAmmoBoxBase CoopAmmoBox;

	if (Alpha == 0)
	{
		return;
	}

	OrigDrawX = DrawX;
	OrigDrawY = DrawY;
	Canvas.Font = Font'Warfare_HUD.WarfareHUD_font';

	// draw the weapon frame icon
	// draw the hilite if needed
	if (bHighlight)
	{
		SetWeaponSelectColor( Alpha );
		Canvas.DrawIcon(WeaponInfoFrame,DrawX,DrawY,1.2f * Scale);
	}
	else
	{
		bHeatLimitedWeapon = (Weap != None) && Weap.IsHeatLimited();

		if( bHeatLimitedWeapon )
		{
			Heat = Weap.GetCurrentBarrelHeat();
			if ( Heat >= 0.65 )
			{
				Canvas.SetDrawColor( 247, 28, 36, Alpha*0.5f );
				Canvas.DrawIcon(WeaponInfoFrame,DrawX,DrawY,FrameScale * Scale);

				HeatColorPercent = (Heat - 0.65f) / 0.35f;
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha*(1.0f-HeatColorPercent*0.35f) );
				Canvas.DrawIcon(WeaponInfoFrame,DrawX,DrawY,FrameScale * Scale);
			}
			else
			{
				HeatColorPercent = Heat / 0.65f;
				Canvas.SetDrawColor( 247, 28, 36, Alpha*0.5f*HeatColorPercent );
				Canvas.DrawIcon(WeaponInfoFrame,DrawX,DrawY,FrameScale * Scale);

				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha );
				Canvas.DrawIcon(WeaponInfoFrame,DrawX,DrawY,FrameScale * Scale);
			}
		}
		else
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha );
			Canvas.DrawIcon(WeaponInfoFrame,DrawX,DrawY,FrameScale * Scale);
		}
	}

	// Return if we're drawing the icon empty
	if ( bDrawEmptyVersion )
	{
		return;
	}

	`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );

	if (Weap != None)
	{
		// draw the weapon icon
		DrawX = OrigDrawX + (20.f + Weap.IconXOffset)*Scale;
		DrawY = OrigDrawY + Weap.IconYOffset*Scale;

		// draw the reload indicator
		if ( Weap.IsReloading() && bDrawAR && Weap.Instigator == ControlledPawn )
		{
			DrawActionReloadBar( Weap, OrigDrawX, OrigDrawY+(WeaponInfoFrame.VL*FrameScale*Scale)+ARBarData.TickMark.VL/4, Alpha, Scale );
		}

		DrawWeaponIcon( Weap, DrawX, DrawY, Alpha, Scale );

		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );

		// note: this coop ammo box stuff is hackily wedged in here.  worth refactoring if it survives prototyping
		CoopAmmoBox = GearWeap_HeavyCoopMGAmmoBoxBase(Weap);
		// if there is any ammo
		MagazineSize = (CoopAmmoBox == None) ? Weap.WeaponMagSize : CoopAmmoBox.GetMagazineSizeForHUD();

		// coop ammo box returns zero here, need to make it go through ths code path?
		if (Weap.Instigator == ControlledPawn)
		{
			if (!Weap.DrawSpecialAmmoInfo(self, OrigDrawX, OrigDrawY, Alpha, Scale, bHighlight) && MagazineSize > 0)
			{
				// draw the ammo bar
				DrawX = OrigDrawX + 60.f;
				DrawY = OrigDrawY + 45.f*Scale;
				IconCount = Weap.GetAmmoIconCount();
				RemainingAmmo = (CoopAmmoBox == None) ? MagazineSize - Weap.AmmoUsedCount : CoopAmmoBox.GetRemainingAmmoForHUD();
				if ( IconCount != 0 )
				{
					AmmoPerIcon = MagazineSize/float(IconCount);

					// empty spots
					DrawEmptyAmmo( Weap, Alpha, DrawX, DrawY, Scale );

					if ( Weap.IsReloading() )
					{
						DrawSuperAmmo( Weap, Alpha, AmmoPerIcon, RemainingAmmo, DrawX, DrawY, Scale, bHighlight );
						DrawAmmo( Weap, Alpha, AmmoPerIcon, RemainingAmmo, DrawX, DrawY, Scale, bHighlight );
					}
					else
					{
						DrawAmmo( Weap, Alpha, AmmoPerIcon, RemainingAmmo, DrawX, DrawY, Scale, bHighlight );
						DrawSuperAmmo( Weap, Alpha, AmmoPerIcon, RemainingAmmo, DrawX, DrawY, Scale, bHighlight );
					}
				}

				// magazine count
				DrawX = OrigDrawX + 4.f*Scale;
				DrawY -= 8.f*Scale;
				if (Weap.bInfiniteSpareAmmo)
				{
					MagText = "";
				}
				else
				{
					MagText = (CoopAmmoBox == None) ?
									  string(int(Weap.SpareAmmoCount+MagazineSize-Weap.AmmoUsedCount))
									: string(int(CoopAmmoBox.GetTotalRemainingAmmoForHUD()));
					if (len(MagText) == 2)
					{
						MagText = "0"$MagText;
					}
					else if (len(MagText) == 1)
					{
						MagText = "00"$MagText;
					}
				}
				Canvas.SetPos(DrawX,DrawY-2);
				if (Weap.IsCriticalAmmoCount())
				{
					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_RED], Alpha );
				}
				else if (bHighlight)
				{
					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha );
				}
				else
				{
					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
				}
				Canvas.DrawText(MagText, FALSE);
			}
		}

		// See if we should draw a special icon in the weapon indicator
		SpecialIconType = SpecialIconToDrawInWeaponIndicator(PC, bIsMainIndicator);
		if ( SpecialIconType == eGSIT_Leader )
		{
			if ( IsCOG(PC.PlayerReplicationInfo) )
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_TEAMBLUE], Alpha );
			}
			else
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_TEAMRED], Alpha );
			}

			SpecialIcon = LeaderIcon;
			Canvas.DrawIcon( SpecialIcon, Canvas.ClipX - SafeZoneRight - SpecialIcon.UL*Scale/2, SafeZoneTop + 4.0f*Scale, Scale );
		}
	}
}

/**
 * Update the out of ammo time
 *
 * @param FireModeNum - the current fire mode
 */
function UpdateOutOfAmmoTime(byte FireModeNum)
{
	if (FireModeNum != class'GearWeapon'.const.MELEE_ATTACK_FIREMODE)
	{
		LastOutOfAmmoTime = WorldInfo.TimeSeconds;
	}
}

/**
 * Draw an indicator to show that we're out of ammo
 *
 * @param PC - controller drawing the HUD for
 *
 * @param Weap - which weapon we're inspecting
 */
function DrawOutOfAmmoIndicator(GearPC PC, GearWeapon Weap)
{
	local int DrawX, DrawY, OutOfAmmoAlpha;
	local float FadeTime, Scale;

	FadeTime = 0.75f;

	if (PC.bIsTargeting)
	{
		LastOutOfAmmoTime = WorldInfo.TimeSeconds;
	}

	if (!Weap.bSkipOutOfAmmoIndicator && `TimeSince(LastOutOfAmmoTime) < FadeTime && !Weap.HasAnyAmmo())
	{
		OutOfAmmoAlpha = 255 * (1.0f - `TimeSince(LastOutOfAmmoTime)/FadeTime);

		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], OutOfAmmoAlpha);

		Scale = 0.75;
		DrawX = Canvas.ClipX / 2 - OutOfAmmoIcon.UL / 2 * Scale;
		DrawY = Canvas.ClipY / 2 - OutOfAmmoIcon.VL / 2 * Scale;
		Canvas.DrawIcon(OutOfAmmoIcon, DrawX, DrawY, Scale);

		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_RED], OutOfAmmoAlpha);

		Scale = 1.5;
		DrawX = Canvas.ClipX / 2 - OutOfAmmoIcon2.UL / 2 * Scale;
		DrawY = Canvas.ClipY / 2 - OutOfAmmoIcon2.VL / 2 * Scale;
		Canvas.DrawIcon(OutOfAmmoIcon2, DrawX, DrawY, Scale);
	}
}

/** Whether to draw the leader icon or not */
function EGearSpecialIconType SpecialIconToDrawInWeaponIndicator( GearPC PC, bool bIsMainWeaponIndicator )
{
	return eGSIT_None;
}

/**
 * Callback for when a player has talked.
 *
 * @param TalkingPlayer the player that is talking
 * @param bIsTalking if true, the player is now talking, if false they are no longer talking
 */
function OnPlayerTalking(UniqueNetId TalkingPlayer,bool bIsTalking)
{
	Local GearPRI TalkerPRI;
	TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
	if ( TalkerPRI != None )
	{
		TalkerPRI.bIsTalking = bIsTalking;
		TalkerPRI.LastTalkTime = WorldInfo.RealTimeSeconds;
	}
}

/**
 * Finds the PRI for the player with the NetId passed in.
 *
 * @param TestID		ID to search for.
 *
 * @return a PRI for the player with the provided NetId.
 */
function GearPRI ResolveUniqueNetID(UniqueNetId TestID)
{
	local GearGRI GRI;
	local int i;

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		for (i=0;i<GRI.PRIArray.Length;i++)
		{
			if (GRI.PRIArray[i] != None && GRI.PRIArray[i].UniqueId == TestID)
			{
				return GearPRI(GRI.PRIArray[i]);
			}
		}
	}
	return None;
}


/**
 * Sets a talking delegate so we can display chat icons.
 */
function TrackChat()
{
	local OnlineSubSystem OnlineSub;

	if (!bTrackingChat)
	{

		OnlineSub = class'GameEngine'.static.GetOnlineSubSystem();
		if (OnlineSub != None && OnLineSub.VoiceInterface != None)
		{
			OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);
		}

		bTrackingChat = TRUE;

	}
}

/**
 * Removes the talking delegate we set to display chat icons.
 */
function IgnoreChat()
{
	local OnlineSubSystem OnlineSub;

	if ( bTrackingChat )
	{
		OnlineSub = class'GameEngine'.static.GetOnlineSubSystem();
		if (OnlineSub != None && OnLineSub.VoiceInterface != None)
		{
			OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(OnPlayerTalking);
		}

		bTrackingChat = FALSE;
	}
}

/**
 * Enables TAC/COM and related FX, fades in interface.  Called from GearPC.EnableAssessMode().
 */
function EnableAssessMode()
{
	bInitialTaccomFadeIn = FALSE;
	// start the looping tac/com sound
	TacComLoop.Play();
	// enable chat icon delegate
	TrackChat();
	// start fading in
	bIsFadingTaccomIn = TRUE;
	TaccomFadeStartTime = WorldInfo.TimeSeconds - (TotalTaccomFadeTime * TaccomFadeOpacity);

	ConstructTaccomLocators();
}

/** Constructs taccom locators
 *  @param OtherGP - Optional parameter. If this is set, it will attempt to only add the taccom locator for this GP. Otherwise it will attempt to find and add locators for all valid targets.
 */
function ConstructTaccomLocators(optional GearPawn OtherGP)
{
	local GearPawn GP;
	local GearPRI PRI;
	local Vehicle Veh;

	//Pop up TacCom hud locators!
	//If I am driving something, I really want to use the driver instead.
	//Ridable pawns get the PRI and the pawn doesn't have one, no reason to get the driver.
	Veh = Vehicle(ControlledPawn);
	if ( Veh != None )
	{
		GP = GearPawn(Veh.Driver);
	}
	else
	{
		GP = GearPawn(ControlledPawn);
	}
	PRI	= GearPRI(GearPC(PlayerOwner).PlayerReplicationInfo);

	if (OtherGP == None)
	{
		foreach WorldInfo.AllPawns(class'GearPawn', OtherGP)
		{
			if (IsPawnValidForAssessMode(OtherGP, PRI, GP))
			{
				AddHudLocator(class'GearHUDLocator_TacCom', OtherGP);
			}
		}
	}
	else
	{
		if (IsPawnValidForAssessMode(OtherGP, PRI, GP))
		{
			AddHudLocator(class'GearHUDLocator_TacCom', OtherGP);
		}
	}
}

/**
 * Disables TAC/COM and related FX, starts fading out interface.  Called from GearPC.DisableAssessMode().
 */
final function DisableAssessMode()
{
	// clear the chat icon delegate
	IgnoreChat();
	// stop the looping tac/com sound
	TacComLoop.Stop();
	bIsFadingTaccomIn = FALSE;
	// start fading out
	TaccomFadeStartTime = WorldInfo.TimeSeconds - (TotalTaccomFadeTime * (1.f - TaccomFadeOpacity));
}

function EAssessSquadStatus GetSquadmateStatus( GearPawn AGearPawn )
{
	local GearAI AI;

	// Hostages are considered dead.
	if( AGearPawn.IsDBNO() && !AGearPawn.IsAHostage()  )
	{
		return EASS_Down;
	}

	if( AGearPawn.bPlayedDeath )
	{
		return EASS_Dead;
	}

	AI = GearAI( AGearPawn.Controller );
	if ( AI != None )
	{
		switch ( AI.CombatMood )
		{
			case AICM_Normal:		return EASS_Normal;
			case AICM_Passive:		return EASS_Defensive;
			case AICM_Aggressive:	return EASS_Attack;
		}
	}

	return EASS_None;
}

/** Converts SquadmateStatus to DisplayableSquadmateStatus */
function EDisplayableSquadStatus ConvertSquadmateStatus( EAssessSquadStatus ASS_Status )
{
	switch ( ASS_Status )
	{
		case EASS_Normal:		return eSO_NORMAL;
		case EASS_Down:			return eSO_DOWN;
		case EASS_Dead:			return eSO_DEAD;
		case EASS_Defensive:	return eSO_DEFENSIVE;
		case EASS_Attack:		return eSO_ATTACK;
		default:				return eSO_NORMAL;
	}
}

final function DrawSquadLocator( Actor AWarPawn, float CenterXCoord, float CenterYCoord, float Scale, int Alpha )
{
	local float DrawX, DrawY;
	local int Idx;
	local LinearColor LinColor;

	// If the array is empty fill it up
	if ( SquadLocator.length <= 0 )
	{
		CurrSquadLocatorToUse = 0;
		SquadLocator.length = NumSquadLocators;
		for ( Idx = 0; Idx < SquadLocator.length; Idx++ )
		{
			SquadLocator[Idx].MILocation = new(outer) class'MaterialInstanceConstant';
			SquadLocator[Idx].MILocation.SetParent( SquadLocatorMaterial );
		}
	}

	if ( AWarPawn != None )
	{
		SquadLocator[CurrSquadLocatorToUse].DirOfHit = CalculateLocationMaterialEffect( AWarPawn.Location );
	}
	LinColor = MakeLinearColor(SquadLocator[CurrSquadLocatorToUse].DirOfHit, 0.0f, 0.0f, 1.0);
	SquadLocator[CurrSquadLocatorToUse].MILocation.SetVectorParameterValue( 'HUD_Location_Rotator', LinColor );
	SquadLocator[CurrSquadLocatorToUse].MILocation.SetScalarParameterValue( 'Hit_Fade', Alpha/255.f );

	DrawX = CenterXCoord - 128*Scale;
	DrawY = CenterYCoord - 128*Scale;
	Canvas.SetPos( DrawX, DrawY ) ;
	Canvas.DrawMaterialTile( SquadLocator[CurrSquadLocatorToUse].MILocation, 256*Scale, 256*Scale, 0, 0, 1.f, 1.f );

	CurrSquadLocatorToUse = (CurrSquadLocatorToUse + 1) % NumSquadLocators;
}

/** Returns the type of special icon to draw in the squadmate UI */
function EGearSpecialIconType GetSpecialIconType( GearPawn PawnToTest )
{
	return eGSIT_None;
}

function DrawStrikeThru( int StrikeCount, float DrawX, float DrawY, float Width, float Height, EGearHUDColor eColor, byte Alpha )
{
	Canvas.SetPos( DrawX, DrawY );
	`SetHUDDrawColor(HudColors[eColor], Alpha );

	switch ( StrikeCount % 4 )
	{
	case 0:
		Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_Objective_Strike', Width, Height, 0, 0, 512, 32 );
		break;
	case 1:
		Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_Objective_Strike', Width, Height, 512, 0, -512, 32 );
		break;
	case 2:
		Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_Objective_Strike', Width, Height, 0, 32, 512, -32 );
		break;
	case 3:
		Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_Objective_Strike', Width, Height, 512, 32, -512, -32 );
		break;
	}
}

final function DrawCenteredText(int DrawX, int DrawY, string Text)
{
	local float XL, YL;
	Canvas.TextSize( Text, XL, YL );
	Canvas.SetPos( DrawX-XL/2, DrawY );
	Canvas.DrawText( Text );
}

final function vector2d GetSquadMateIconPos(GearPawn Pawn, vector Origin, rotator Direction, float Scale)
{
	local vector PawnLocation, OriginToPawn;
	local vector2d AngularDist;
	PawnLocation = Pawn.Location;
	PawnLocation.Z = Origin.Z;
	OriginToPawn = Normal( Origin - PawnLocation );
	// trying some a little different than a plain circle, feel free to delete if nobody cares for it
	AngularDist.X = asin(OriginToPawn dot Normal(vector(Direction) cross vect(0,0,1)));
	AngularDist.Y = asin(OriginToPawn dot vector(Direction));
	AngularDist.X = FClamp(Canvas.ClipX/2 + FClamp(AngularDist.X,-1.f,1.f) * (Canvas.ClipX/2 - (128.f * Scale)),SafeZoneLeft + 64.f,Canvas.ClipX - SafeZoneRight - 64.f);
	AngularDist.Y = FClamp(Canvas.ClipY/2 + FClamp(AngularDist.Y,-1.f,1.f) * (Canvas.ClipY/2 - (128.f * Scale)),SafeZoneTop + 64.f,Canvas.ClipY - SafeZoneBottom - 64.f);
	return AngularDist;

}

/** Whether to draw the face icon when in taccom or not */
function bool IsPawnValidForAssessMode(GearPawn PawnToTest, GearPRI LocalPRI, GearPawn LocalPawn)
{
	local GearPRI TestPRI;

	// if not the same pawn and the pawn is alive/dbno
	if (PawnToTest != LocalPawn && PawnToTest.SpecialMove != SM_Hostage && (!PawnToTest.IsInState('Dying') || ShouldDrawDBNOIndicator(PawnToTest)) && !PawnToTest.bHidden)
	{
		if( PawnToTest.DrivenVehicle != None )
		{
			TestPRI = GearPRI(PawnToTest.DrivenVehicle.PlayerReplicationInfo);
		}
		else
		{
			TestPRI = GearPRI(PawnToTest.PlayerReplicationInfo);
		}

		// if spectating then we want to view everyone
		if (PlayerOwner.IsSpectating())
		{
			return true;
		}
		// leaders have a special locator
		else if (TestPRI != None && TestPRI.bIsLeader)
		{
			return false;
		}
		else if ( LocalPawn != None && LocalPawn.IsSameTeam(PawnToTest) )
		{
			if (WorldInfo.GRI != None && !WorldInfo.GRI.IsMultiplayerGame())
			{
				// in campaign only show squadmates
				return (TestPRI != None && (TestPRI.bForceShowInTaccom || TestPRI.SquadName == LocalPRI.SquadName));
			}
			return true;
		}
		else if (TestPRI != None && LocalPRI != None && LocalPRI.IsNemesis(TestPRI))
		{
			return true;
		}
	}
	return false;
}

/** Whether to draw the name above a player's head or not in taccom */
function bool ShouldDrawNameAboveHeadInTaccom( GearPawn PawnToTest, GearPRI LocalPRI, GearPawn LocalPawn )
{
	// only show other players who are DBNO or alive
	if (LocalPawn != PawnToTest && !PawnToTest.bPlayedDeath)
	{
		// show if spectating, or DBNO w/ teammates
		return LocalPawn == None || !LocalPawn.IsDBNO() || LocalPawn.IsSameTeam(PawnToTest);
	}
	return FALSE;
}

/** Whether to draw the name above a player's head or not in taccom when they're face icon is showing */
function bool ShouldDrawNameAboveHeadInTaccomWhenFaceIconIsShown( GearPawn PawnToTest, GearPRI LocalPRI, GearPawn LocalPawn )
{
	return TRUE;
}

/**
 * Clears the current TacCom effect.
 * @note - do not call this every frame since it will break splitscreen if called by the second viewport!
 */
final function ResetTaccomOpacity()
{
	TaccomFadeOpacity = 0.f;
	// and set the scalar parm on the effect
	if (TacComEffect != None && TacComMIC != None)
	{
		TacComMIC.SetScalarParameterValue('Opacity',0.f);
		TacComEffect.bShowInGame = FALSE;
	}
}

final function DrawAssessMode(GearPC PC)
{
	// cache the reference if needed
	if (TacComEffect == None)
	{
		TacComEffect = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect(TacComPPEffectName));
		if (TacComEffect.Material.GetPackageName() != 'Transient')
		{
			// Create a MIC for this viewport
			TacComMIC = new(TacComEffect) class'MaterialInstanceConstant';
			TacComMIC.SetParent(TacComEffect.Material);
			TacComEffect.Material = TacComMIC;
		}
		else
		{
			TacComMIC = MaterialInstanceConstant(TacComEffect.Material);
		}
	}

	// Determine what the opacity of the taccom screen should be.
	if (bIsFadingTaccomIn || PC.bAssessMode)
	{
		if (TaccomFadeStartTime > 0.0 && (WorldInfo.TimeSeconds - TaccomFadeStartTime) < TotalTaccomFadeTime)
		{
			TaccomFadeOpacity = (WorldInfo.TimeSeconds - TaccomFadeStartTime) / TotalTaccomFadeTime;
		}
		else
		{
			TaccomFadeOpacity = 1.f;
		}
		TacComEffect.bShowInGame = true;
	}
	else if (!bIsFadingTaccomIn && (WorldInfo.TimeSeconds - TaccomFadeStartTime) < TotalTaccomFadeTime && TaccomFadeStartTime > 0.0)
	{
		if (TaccomFadeStartTime > WorldInfo.TimeSeconds)
		{
			TaccomFadeOpacity = 1.f;
		}
		else
		{
			TaccomFadeOpacity = 1.f - ((WorldInfo.TimeSeconds - TaccomFadeStartTime) / TotalTaccomFadeTime);
		}
		TacComEffect.bShowInGame = true;
	}
	else
	{
		TacComEffect.bShowInGame = false;
		TaccomFadeOpacity = 0.f;
	}
	// and set the scalar parm on the effect
	if (TacComEffect != None)
	{
		//`log(WorldInfo.TimeSeconds@`showvar(PC)@`showvar(TaccomFadeOpacity)@`showvar(TaccomEffect.bShowInGame)@`showvar(TaccomEffect)@`showvar(bInitialTaccomFadeIn));
		// if doing the initial fadein then skip the PP effect
		if (bInitialTaccomFadeIn)
		{
			TacComMIC.SetScalarParameterValue('Opacity',0.f);
		}
		// otherwise update to the current opacity
		else
		{
			TacComMIC.SetScalarParameterValue('Opacity',TaccomFadeOpacity);
			if (CurrSplitscreenType != eSST_None)
			{
				TacComMIC.SetScalarParameterValue('RimAlpha',0.f);
			}
			else
			{
				TacComMIC.SetScalarParameterValue('RimAlpha',1.f);
			}
		}
	}
	// if currently drawing taccom then draw objectives
	if (TaccomFadeOpacity > 0.f && (!bInMultiplayerMode || bInMPCoopMode))
	{
		DrawObjectives(TaccomFadeOpacity, false);
	}
}

/** draw info for nearby fortifications we can place/repair/upgrade */
function DrawFortificationInfo()
{/* @FIXME: decide if we want to keep this in the action icon area
	local string FortCostText;
	local GearPC PC;
	local float XL, YL;
	local GearFortificationMarker GFMarker;
	local int Cost, SellValue;

	if ( ActiveAction.ActionType != AT_Pickup &&
		GearPawn(PlayerOwner.Pawn) != None && GearPawnRidable_Base(PlayerOwner.Pawn) == None && !GearPawn(PlayerOwner.Pawn).IsAKidnapper() )
	{
		PC = GearPC(PlayerOwner);
		if (PC.MyGearPawn != None && !PC.MyGearPawn.IsInCover())
		{
			foreach PC.Pawn.TouchingActors(class'GearFortificationMarker', GFMarker)
			{
				if ( NoZDot(vector(PC.Pawn.Rotation), Normal(GFMarker.Location - PC.Pawn.Location)) > 0.0 &&
					PC.GetFortificationUpgradeLevel(GFMarker.FortificationType) >= 0 )
				{
					if (!GFMarker.FortificationType.static.IsEncroachingOnBuildLocation(PC.Pawn, GFMarker.Location, GFMarker.Rotation))
					{
						if (PC.CanPayFortificationCost(GFMarker.FortificationType))
						{
							`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE],255);
							FortCostText = (PC.bUseAlternateControls ? "RSClick TO BUY" : "Y TO BUY") @ GFMarker.FortificationType.default.DisplayName;
						}
						else
						{
							`SetHUDDrawColor(HudColors[eWARHUDCOLOR_RED],255);
							FortCostText = "TO BUY" @ GFMarker.FortificationType.default.DisplayName;
						}
						FortCostText $= ":" @ string(GFMarker.FortificationType.static.GetPurchaseCost(0, WorldInfo));
						Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
						Canvas.StrLen(FortCostText, XL, YL);
						Canvas.SetPos(Canvas.ClipX * 0.5 - XL * 0.5, Canvas.ClipY * 0.7 - YL * 0.5);
						Canvas.DrawText(FortCostText);
						break;
					}
				}
			}
		}
		if (GFMarker == None && PC.ModifyFortification != None)
		{
			if (PC.ModifyFortification.GetConditionPct() < 1.0)
			{
				if ( (PC.ModifyFortification.Health > 0 || PC.GetFortificationUpgradeLevel(PC.ModifyFortification.Class) >= PC.ModifyFortification.UpgradeLevel) &&
					!PC.ModifyFortification.static.IsEncroachingOnBuildLocation(PC.Pawn, PC.ModifyFortification.Location, PC.ModifyFortification.Rotation) )
				{
					Cost = PC.ModifyFortification.GetRepairCost();
					if (PC.ModifyFortification.RepairIsReload())
					{
						FortCostText = "TO RELOAD";
					}
					else if (PC.ModifyFortification.Health <= 0)
					{
						FortCostText = "TO REBUILD";
					}
					else
					{
						FortCostText = "TO REPAIR";
					}
					FortCostText @= PC.ModifyFortification.DisplayName @ "(" $ string(Cost) $ ")";
					if (PC.PlayerReplicationInfo.Score > 0)
					{
						FortCostText = (PC.bUseAlternateControls ? "RSClick " : "Y ") $ FortCostText;
						`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE],255);
					}
					else
					{
						`SetHUDDrawColor(HudColors[eWARHUDCOLOR_RED],255);
					}
				}
			}
			else if (PC.ModifyFortification.UpgradeLevel + 1 < PC.ModifyFortification.Cost.length)
			{
				if (PC.GetFortificationUpgradeLevel(PC.ModifyFortification.Class) <= PC.ModifyFortification.UpgradeLevel)
				{
					FortCostText = "UPGRADE LOCKED";
				}
				else
				{
					Cost = PC.ModifyFortification.Cost[PC.ModifyFortification.UpgradeLevel + 1] - PC.ModifyFortification.Cost[PC.ModifyFortification.UpgradeLevel];
					FortCostText = "TO UPGRADE" @ PC.ModifyFortification.DisplayName @ "(" $ string(Cost) $ ")";
					if (PC.PlayerReplicationInfo.Score >= Cost)
					{
						FortCostText = (PC.bUseAlternateControls ? "RSClick " : "Y ") $ FortCostText;
						`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE],255);
					}
					else
					{
						`SetHUDDrawColor(HudColors[eWARHUDCOLOR_RED],255);
					}
				}
			}
			if (FortCostText != "" || (PC.ModifyFortification.Owner == PC && class'GearGameHorde_Base'.default.bCanSellFortifications))
			{
				if (PC.ModifyFortification.Owner == PC && class'GearGameHorde_Base'.default.bCanSellFortifications)
				{
					SellValue = int(PC.ModifyFortification.GetConditionPct() * PC.ModifyFortification.Cost[PC.ModifyFortification.UpgradeLevel] * PC.ModifyFortification.TearDownRecoveryPct);
					if (FortCostText != "")
					{
						FortCostText $= ", ";
					}
					FortCostText $= "B TO SELL (" $ SellValue $ ")";
				}

				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
				Canvas.StrLen(FortCostText, XL, YL);
				Canvas.SetPos(Canvas.ClipX * 0.5 - XL * 0.5, Canvas.ClipY * 0.7 - YL * 0.5);
				Canvas.DrawText(FortCostText);
			}
		}
	}*/
}

/**
 * A very rough health bar for ridable pawns
 *
 * @param RidablePawn - the pawn to draw a health bar for
 *
 * @param DrawX - the horizontal center to start drawing the bar
 *
 * @param DrawY - the Y coord to start starting the bar
 *
 * @param Alpha - the opacity of the health bar between 0 and 255
 *
 * @param Scale - how big should the bar be drawn
 */
function DrawRidablePawnHealth(GearPawnRidable_Base RidablePawn, float DrawX, float DrawY, float Alpha, float Scale)
{
	local CanvasIcon HealthIcon;
	local float HealthPercent, DamagePercent;

	HealthIcon = RidablePawn.HealthIcon;

	if (HealthIcon.Texture != None)
	{
		DrawX -= HealthIcon.UL * Scale * 0.5;

		Canvas.SetPos(DrawX - 1, DrawY - 1);
		Canvas.SetDrawColor(47, 47, 47, Alpha);
		Canvas.DrawTileStretched(HealthIcon.Texture, HealthIcon.UL * Scale + 2, HealthIcon.VL + 2, HealthIcon.U, HealthIcon.V, HealthIcon.UL, HealthIcon.VL);

		// Determine the color to draw
		HealthPercent = float(RidablePawn.Health) / float(RidablePawn.DefaultHealth);
		DamagePercent = 1.0 - HealthPercent;
		if (DamagePercent >= 0.5)
		{
			Canvas.SetDrawColor(255 - (18 * DamagePercent), 255 - (227 * DamagePercent), 255 - (219 * DamagePercent), Alpha);
		}
		else
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha);
		}

		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawTileStretched(HealthIcon.Texture, HealthIcon.UL * Scale * HealthPercent, HealthIcon.VL, HealthIcon.U, HealthIcon.V, HealthIcon.UL * HealthPercent, HealthIcon.VL);
	}
}

/**
 * A very rough health bar for turrets
 *
 * @param GT - the pawn to draw a health bar for
 *
 * @param DrawX - the horizontal center to start drawing the bar
 *
 * @param DrawY - the Y coord to start starting the bar
 *
 * @param Alpha - the opacity of the health bar between 0 and 255
 *
 * @param Scale - how big should the bar be drawn
 */
function DrawTurretHealth(GearTurret GT, float DrawX, float DrawY, float Alpha, float Scale)
{
	local CanvasIcon HealthIcon;
	local float HealthPercent, DamagePercent;

	HealthIcon = GT.HealthIcon;

	if (HealthIcon.Texture != None)
	{
		DrawX -= HealthIcon.UL * Scale * 0.5;

		Canvas.SetPos(DrawX - 1, DrawY - 1);
		Canvas.SetDrawColor(47, 47, 47, Alpha);
		Canvas.DrawTileStretched(HealthIcon.Texture, HealthIcon.UL * Scale + 2, HealthIcon.VL + 2, HealthIcon.U, HealthIcon.V, HealthIcon.UL, HealthIcon.VL);

		// Determine the color to draw
		HealthPercent = float(GT.Health) / float(GT.OwnerFort.StartingHealth[GT.OwnerFort.UpgradeLevel]);
		DamagePercent = 1.0 - HealthPercent;
		if (DamagePercent >= 0.5)
		{
			Canvas.SetDrawColor(255 - (18 * DamagePercent), 255 - (227 * DamagePercent), 255 - (219 * DamagePercent), Alpha);
		}
		else
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha);
		}

		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawTileStretched(HealthIcon.Texture, HealthIcon.UL * Scale * HealthPercent, HealthIcon.VL, HealthIcon.U, HealthIcon.V, HealthIcon.UL * HealthPercent, HealthIcon.VL);
	}
}

/**
 * A very rough cover icon for ridable pawns
 *
 * @param RidablePawn - the pawn to draw a cover icon for
 *
 * @param DrawX - the horizontal center to start drawing the icon
 *
 * @param DrawY - the Y coord to start starting the icon
 *
 * @param Scale - how big the health bar was drawn
 */
function DrawRidablePawnCoverIcon(GearPawnRidable_Base RidablePawn, float DrawX, float DrawY, float Scale)
{
	local CanvasIcon CoverIcon;

	`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], 255);

	CoverIcon = RidablePawn.CoverIcon;
	DrawX -= RidablePawn.HealthIcon.UL * Scale * 0.5;
	DrawX -= CoverIcon.UL + 20;
	DrawY -= CoverIcon.VL / 2;
	Canvas.SetPos(DrawX, DrawY);
	Canvas.DrawTile(CoverIcon.Texture, CoverIcon.UL, CoverIcon.VL, CoverIcon.U, CoverIcon.V, CoverIcon.UL, CoverIcon.VL);
}

/** Draws names above heads when the player is spectating */
function DrawSpectatingNames(GearPC PC, GearPawn GP)
{
	local GearPawn OtherGP;
	local GearPRI PRI;
	local vector CameraLoc;
	local rotator CameraRot;

	if ( PC.IsSpectating() )
	{
		PRI	= GearPRI(PC.PlayerReplicationInfo);
		PC.GetPlayerViewpoint(CameraLoc,CameraRot);

		foreach WorldInfo.AllPawns( class'GearPawn', OtherGP )
		{
			if( IsPawnValidForAssessMode( OtherGP, PRI, GP ) )
			{
				// if the player isn't currently visible
				if ( IsSquadMateVisible(OtherGP,CameraLoc,CameraRot,PC) && ShouldDrawNameAboveHeadInTaccomWhenFaceIconIsShown( OtherGP, PRI, GP ) )
				{
					DrawSquadMateNameAboveHead( OtherGP, CameraLoc, CameraRot, 255 );
				}
			}
		}
	}
}

/** Special icon to draw above the name of the player in taccom */
function EGearSpecialIconType SpecialIconToDrawAboveHead(GearPawn PawnToTest)
{
	return eGSIT_None;
}

final function bool IsSquadMateVisible(GearPawn TestPawn, vector CamLoc, rotator CamRot, GearPC PC)
{
	local vector CamToPawn;
	CamToPawn = Normal(TestPawn.Location - CamLoc);
	return (CamToPawn dot vector(CamRot)) > 0.7f * (85.f/PC.GetFOVAngle()) && `TimeSince(TestPawn.LastRenderTime) < 0.5f && PC.LineOfSightTo(TestPawn);
}

/** Returns the canvasicon of the specialicontype passed in */
final function CanvasIcon GetSpecialCanvasIcon( EGearSpecialIconType IconType )
{
	local CanvasIcon ReturnIcon;

	switch ( IconType )
	{
		case eGSIT_Leader:
			ReturnIcon = LeaderIcon;
			break;
		case eGSIT_BuddyCOG:
			ReturnIcon = BuddyIconCOG;
			break;
		case eGSIT_BuddyLocust:
			ReturnIcon = BuddyIconLocust;
			break;
	}

	return ReturnIcon;
}

function EGearHUDColor GetSquadMateNameColor(GearPawn SquadmatePawn)
{
	local byte TeamNum;

	// default to 2 teams with 0 being COG (blue), 1 being Locust (red), all others being neutral (white)
	TeamNum = SquadmatePawn.GetTeamNum();
	if (TeamNum == 0)
	{
		return eWARHUDCOLOR_TEAMBLUE;
	}
	else if (TeamNum == 1)
	{
		return eWARHUDCOLOR_TEAMRED;
	}
	else
	{
		return eWARHUDCOLOR_WHITE;
	}
}

/** Draw the name of the player above their head in screenspace */
final function DrawSquadMateNameAboveHead( GearPawn SquadmatePawn, vector CameraLoc, rotator CameraRot, optional byte Alpha = 255, optional EGearSpecialIconType SpecialIconType = eGSIT_None )
{
	local float TextX, TextY;
	local vector PawnExtent, ScreenLoc, CameraDir, SquademateDir;
	local GearPC PC;
	local CanvasIcon SpecialIcon;
	local EGearHUDColor ColorType, TextColor;

	PC = GearPC(PlayerOwner);
	if ( (SquadmatePawn != None) && (Pawn(SquadmatePawn.Base) == None) && SquadmatePawn.PlayerReplicationInfo != None && !SquadmatePawn.bIsHiddenByCamera && `TimeSince(SquadmatePawn.LastRenderTime) < 2.f && PC.LineOfSightTo(SquadmatePawn) )
	{
		TextColor = GetSquadMateNameColor(SquadmatePawn);
		// Configure the color, alpha, font, and get the size of the string
		`SetHUDDrawColor(HudColors[TextColor], Alpha );
		Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		Canvas.TextSize( SquadmatePawn.PlayerReplicationInfo.PlayerName, TextX, TextY );

		CameraDir = vector(CameraRot);
		SquademateDir = SquadmatePawn.Location - CameraLoc;
		if ( CameraDir Dot SquademateDir > 0 && SquadmatePawn.HeadBoneNames.Length > 0 )
		{
			PawnExtent = SquadmatePawn.Mesh.GetBoneLocation( SquadmatePawn.HeadBoneNames[0] );
			PawnExtent.Z += 30.0f;
			ScreenLoc = Canvas.Project( PawnExtent );
			ScreenLoc.X -= TextX / 2;
			ScreenLoc.Y -= TextY * 1.5f;

			// make sure this isn't clipping past the canvas (splitscreen)
			if (ScreenLoc.Y < 0 || ScreenLoc.Y > Canvas.ClipY - SafeZoneBottom)
			{
				return;
			}

			// Set the text position and draw
			Canvas.SetPos( ScreenLoc.X, ScreenLoc.Y );
			Canvas.DrawText( SquadmatePawn.PlayerReplicationInfo.PlayerName,,,, Text_ClipShadowed);

			if ( SpecialIconType != eGSIT_None )
			{
				SpecialIcon = GetSpecialCanvasIcon( SpecialIconType );
				ColorType = IsCOG(SquadmatePawn.PlayerReplicationInfo) ? eWARHUDCOLOR_TEAMBLUE : eWARHUDCOLOR_TEAMRED;
				`SetHUDDrawColor(HudColors[ColorType], Alpha );
				Canvas.DrawIcon( SpecialIcon, ScreenLoc.X + TextX/2 - SpecialIcon.UL/2, ScreenLoc.Y - SpecialIcon.VL, 1.0f );
			}
		}
	}
}

/** Whether we should draw a DBNO player's indicator or not */
final function bool ShouldDrawDBNOIndicator( GearPawn AWPawn )
{
	local GearPRI TestPRI, LocalPRI;
	local GearGRI GRI;
	if (AWPawn != None && !AWPawn.IsAHostage())
	{
		GRI = GearGRI(WorldInfo.GRI);
		TestPRI = GearPRI(AWPawn.PlayerReplicationInfo);
		LocalPRI = GearPRI(PlayerOwner.PlayerReplicationInfo);
		if( (WorldInfo.GRI.IsMultiplayerGame() ||
				(!WorldInfo.GRI.IsMultiplayerGame() &&
					(AWPawn.IsA('GearPawn_COGMarcus') || AWPawn.IsA('GearPawn_COGDom'))) ||
				(TestPRI != None &&
					(TestPRI.bForceShowInTaccom || GRI == None || (!GRI.bInCoopSplit || !GRI.bGapSquadSplit || TestPRI.SquadName == LocalPRI.SquadName)))) &&
			(AWPawn.IsDBNO() || (AWPawn.TimeOfRevival > 0 && AWPawn.TimeOfRevival > WorldInfo.TimeSeconds-2.f) || (AWPawn.IsInState('Dying') && (AWPawn.TimeOfDeath+2.f > WorldInfo.TimeSeconds))) )
		{
			return TRUE;
		}
	}
	return FALSE;
}

/**
 * Overridden to clear any transient data on player death.
 */
function PlayerOwnerDied()
{
	Super.PlayerOwnerDied();
	// clear any actions
	bUnfriendlySpotted = FALSE;
	ActiveAction.bActive = FALSE;
	ActiveAction.BlendPct = 0.f;
	PreviousAction.bActive = FALSE;
	PreviousAction.BlendPct = 0.f;
}

/** adds an entry to the correct HUDMessages array; also handles clamping to the maximum number of entries
 *	@param	Killer - The killer PRI
 *	@param	Victim - The victim PRI
 *	@param	Index - the index into the array
 *	@return True if using Priority, false otherwise
 */
final function bool AddHUDMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, out int Index)
{
	if (PlayerOwner != None)
	{
		if (Victim == PlayerOwner.PlayerReplicationInfo)
		{
			if (MaxPriorityHUDMessages > 0 && PriorityHUDMessages.length >= MaxPriorityHUDMessages)
			{
				PriorityHUDMessages.Remove(0, 1);
			}
			Index = PriorityHUDMessages.Add(1);
			SetMessageKillerAndVictim(Index, Killer, Victim, PriorityHUDMessages);
			return TRUE;
		}
	}

	if (MaxHUDMessages > 0 && HUDMessages.length >= MaxHUDMessages)
	{
		HUDMessages.Remove(0, 1);
	}
	Index = HUDMessages.Add(1);
	SetMessageKillerAndVictim(Index, Killer, Victim, HUDMessages);
	return FALSE;
}

/** utility for setting HUDMessage "killer" and "victim" properties from the PRIs */
final function SetMessageKillerAndVictim(int HUDMessageIndex, PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, out array<DeathData> MessageArray)
{
	local GearPRI Player1PRI, Player2PRI;
	local GearPC PC;

	if (PlayerOwner != None)
	{
		foreach PlayerOwner.LocalPlayerControllers(class'GearPC', PC)
		{
			if (Player1PRI == None)
			{
				Player1PRI = GearPRI(PC.PlayerReplicationInfo);
			}
			else
			{
				Player2PRI = GearPRI(PC.PlayerReplicationInfo);
				break;
			}
		}
	}

	if (Killer != None)
	{
		MessageArray[HUDMessageIndex].KillerName = Killer.PlayerName$" ";
		MessageArray[HUDMessageIndex].KillerTeamIndex = Killer.GetTeamNum();
		MessageArray[HUDMessageIndex].bKillerDrawTeamColor = ShouldDrawTeamColor(Killer);
		MessageArray[HUDMessageIndex].bKillerIsCOG = (Killer.GetTeamNum() == TEAM_COG);
		MessageArray[HUDMessageIndex].bKillerIsPlayerOne = false;
		MessageArray[HUDMessageIndex].bKillerIsPlayerTwo = false;
		if (Player1PRI != None && Player1PRI == Killer)
		{
			MessageArray[HUDMessageIndex].bKillerIsPlayerOne = true;
		}
		else if (Player2PRI != None && Player2PRI == Killer)
		{
			MessageArray[HUDMessageIndex].bKillerIsPlayerTwo = true;
		}
	}
	if (Victim != None)
	{
		MessageArray[HUDMessageIndex].VictimName = " "$Victim.PlayerName$" ";
		MessageArray[HUDMessageIndex].VictimTeamIndex = Victim.GetTeamNum();
		MessageArray[HUDMessageIndex].bVictimDrawTeamColor = ShouldDrawTeamColor(Victim);
		MessageArray[HUDMessageIndex].bVictimIsCOG = (Victim.GetTeamNum() == TEAM_COG);
		MessageArray[HUDMessageIndex].bVictimIsPlayerOne = false;
		MessageArray[HUDMessageIndex].bVictimIsPlayerTwo = false;
		if (Player1PRI != None && Player1PRI == Victim)
		{
			MessageArray[HUDMessageIndex].bVictimIsPlayerOne = true;
		}
		else if (Player2PRI != None && Player2PRI == Victim)
		{
			MessageArray[HUDMessageIndex].bVictimIsPlayerTwo = true;
		}
	}
}

/** @see AddTeamMessageData **/
function AddDeathMessageData(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<GearDamageType> GearDamage, EGearDeathType DeathType, bool bIsKnockdown, optional int PointsAwarded, optional bool bSkipBlood)
{
	local int index;

	if (bInMultiplayerMode || bAlwaysDrawDeathMessages)
	{
		if (Victim != None)
		{
			if (++CurrBloodIndex > BLOOD_ICON_AMT - 1)
			{
				CurrBloodIndex = 0;
			}
			if (AddHUDMessage(Killer, Victim, index))
			{
				PriorityHUDMessages[index].BloodIconIndex = CurrBloodIndex;
				PriorityHUDMessages[index].DeathType = DeathType;
				PriorityHUDMessages[index].TimeRemaining = DeathDataTime;
				if (bIsKnockdown)
				{
					PriorityHUDMessages[index].Damage = class'GDT_KnockedDown';
				}
				else
				{
					PriorityHUDMessages[index].Damage = GearDamage;
					if (GearDamage == class'GDT_ShieldBash')
					{
						PriorityHUDMessages[index].Damage = class'GDT_Melee';
					}
				}
				PriorityHUDMessages[index].bShowBlood = !bSkipBlood;
				PriorityHUDMessages[index].bUseTeamColors = TRUE;
				if (PointsAwarded != 0)
				{
					PriorityHUDMessages[index].bUseMessageText = TRUE;
					if (PointsAwarded > 0)
					{
						PriorityHUDMessages[index].MessageText = "+"@PointsAwarded;
					}
					else
					{
						PriorityHUDMessages[index].MessageText = "-"@int(Abs(PointsAwarded));
					}
				}
				// always show player names for kills
				PriorityHUDMessages[index].bShowPlayerNames = TRUE;

				// Add another message to show you were killed by your nemesis
				if (PlayerOwner.PlayerReplicationInfo == Victim && GearPRI(Victim).IsNemesis(Killer))
				{
					if (MaxPriorityHUDMessages > 0 && PriorityHUDMessages.length >= MaxPriorityHUDMessages)
					{
						PriorityHUDMessages.Remove(0, 1);
					}

					index = PriorityHUDMessages.Add(1);
					PriorityHUDMessages[index].MessageText = NemesisText;
					PriorityHUDMessages[index].bUseMessageText = TRUE;
					PriorityHUDMessages[index].TimeRemaining = DeathDataTime;
					PriorityHUDMessages[index].bShowPlayerNames = FALSE;
				}
			}
			else
			{
				HUDMessages[index].BloodIconIndex = CurrBloodIndex;
				HUDMessages[index].DeathType = DeathType;
				HUDMessages[index].TimeRemaining = DeathDataTime;
				if (bIsKnockdown)
				{
					HUDMessages[index].Damage = class'GDT_KnockedDown';
				}
				else
				{
					HUDMessages[index].Damage = GearDamage;
					if (GearDamage == class'GDT_ShieldBash')
					{
						HUDMessages[index].Damage = class'GDT_Melee';
					}
				}
				HUDMessages[index].bShowBlood = !bSkipBlood;
				HUDMessages[index].bUseTeamColors = TRUE;
				if (PointsAwarded != 0)
				{
					HUDMessages[index].bUseMessageText = TRUE;

					if (Killer != PlayerOwner.PlayerReplicationInfo)
					{
						if (PointsAwarded > 0)
						{
							HUDMessages[index].MessageText = AssistText @ "+" @ PointsAwarded;
						}
						else
						{
							HUDMessages[index].MessageText = "-" @ int(Abs(PointsAwarded));
						}
					}
					else
					{
						if (PointsAwarded > 0)
						{
							HUDMessages[index].MessageText = "+" @ PointsAwarded;
						}
						else
						{
							HUDMessages[index].MessageText = "-" @ int(Abs(PointsAwarded));
						}
					}
				}
				// always show player names for kills
				HUDMessages[index].bShowPlayerNames = TRUE;

				// Add text if you've become a nemesis
				if (!bIsKnockdown && PlayerOwner.PlayerReplicationInfo == Killer && GearPRI(Victim).IsNemesis(Killer))
				{
					index = HUDMessages.Add(1);
					HUDMessages[index].MessageText = DominatingText;
					HUDMessages[index].bUseMessageText = TRUE;
					HUDMessages[index].TimeRemaining = DeathDataTime;
					HUDMessages[index].bShowPlayerNames = FALSE;
				}
			}
		}
	}

	AddKillPoints(PointsAwarded);
}

/**
 * Add points to the kill points running total
 *
 * @param PointsAwarded - how many points were earned this kill
 */
function AddKillPoints(int PointsAwarded)
{
	local int Idx;

	if (bDrawKillPoints && PointsAwarded != 0)
	{
		// If we're not fading out, add the points to the current display
		Idx = KillPoints.length - 1;
		if (Idx >= 0 && WorldInfo.TimeSeconds - KillPoints[Idx].StartTime <= KillPointsTime )
		{
			KillPoints[Idx].Value += PointsAwarded;
		}
		else
		{
			Idx = KillPoints.Add(1);
			KillPoints[Idx].Value = PointsAwarded;
		}
		KillPoints[Idx].StartTime = WorldInfo.TimeSeconds;
	}
}

/** @see AddDeathData **/
final function AddWeaponTakenMessage( PlayerReplicationInfo WeaponTaker, class<GearDamageType> GearDamage )
{
	local int index;

	if ( bInMultiplayerMode )
	{
		if (AddHUDMessage(WeaponTaker, None, index))
		{
			PriorityHUDMessages[index].bShowPlayerNames = TRUE;
			PriorityHUDMessages[index].TimeRemaining = DeathDataTime;
			PriorityHUDMessages[index].Damage = GearDamage;
			if (GearDamage != None)
			{
				PriorityHUDMessages[index].Scale = GearDamage.default.IconScale;
			}
			PriorityHUDMessages[index].bShowBlood = FALSE;
			PriorityHUDMessages[index].bUseMessageText = TRUE;
			PriorityHUDMessages[index].MessageText = WeaponTakenString;
			PriorityHUDMessages[index].bUseTeamColors = TRUE;
		}
		else
		{
			HUDMessages[index].bShowPlayerNames = TRUE;
			HUDMessages[index].TimeRemaining = DeathDataTime;
			HUDMessages[index].Damage = GearDamage;
			if (GearDamage != None)
			{
				HUDMessages[index].Scale = GearDamage.default.IconScale;
			}
			HUDMessages[index].bShowBlood = FALSE;
			HUDMessages[index].bUseMessageText = TRUE;
			HUDMessages[index].MessageText = WeaponTakenString;
			HUDMessages[index].bUseTeamColors = TRUE;
		}
	}
}

final function AddScoreGameMessage(int Id, int Pts, optional GearPRI Victim)
{
	local int index;

	if (AddHUDMessage(PlayerOwner.PlayerReplicationInfo, Victim, index))
	{
		PriorityHUDMessages[index].bShowPlayerNames = TRUE;
		PriorityHUDMessages[index].TimeRemaining = DeathDataTime;
		PriorityHUDMessages[index].Damage = None;
		PriorityHUDMessages[index].GameSpecificID = Id;
		PriorityHUDMessages[index].bShowBlood = FALSE;
		if (Pts > 0)
		{
			PriorityHUDMessages[index].bUseMessageText = TRUE;
			PriorityHUDMessages[index].MessageText = "+"@Pts;
		}
		PriorityHUDMessages[index].bUseTeamColors = TRUE;
	}
	else
	{
		HUDMessages[index].bShowPlayerNames = TRUE;
		HUDMessages[index].TimeRemaining = DeathDataTime;
		HUDMessages[index].Damage = None;
		HUDMessages[index].GameSpecificID = Id;
		HUDMessages[index].bShowBlood = FALSE;
		if (Pts > 0)
		{
			HUDMessages[index].bUseMessageText = TRUE;
			HUDMessages[index].MessageText = "+"@Pts;
		}
		HUDMessages[index].bUseTeamColors = TRUE;
	}
}

/** @see AddDeathData **/
final function AddAmmoMessage(PlayerReplicationInfo AmmoTaker, class<GearDamageType> GearDamage, int Amount, optional bool bWasAmmoShare)
{
	local int index;
	local string AmmoText;

	if (Amount != 0)
	{
		AmmoText = "x " $ Amount;
	}

	if (bWasAmmoShare)
	{
		if (MaxPriorityHUDMessages > 0 && PriorityHUDMessages.length >= MaxPriorityHUDMessages)
		{
			PriorityHUDMessages.Remove(0, 1);
		}

		index = PriorityHUDMessages.Add(1);
		PriorityHUDMessages[index].TimeRemaining = AmmoDataTime;
		PriorityHUDMessages[index].Damage = GearDamage;
		PriorityHUDMessages[index].bShowBlood = FALSE;
		PriorityHUDMessages[index].bUseMessageText = TRUE;
		PriorityHUDMessages[index].MessageText = AmmoText;
	}
	else if (AddHUDMessage(AmmoTaker, None, index))
	{
		PriorityHUDMessages[index].TimeRemaining = AmmoDataTime;
		PriorityHUDMessages[index].Damage = GearDamage;
		PriorityHUDMessages[index].bShowBlood = FALSE;
		PriorityHUDMessages[index].bUseMessageText = TRUE;
		PriorityHUDMessages[index].MessageText = AmmoText;
	}
	else
	{
		HUDMessages[index].TimeRemaining = AmmoDataTime;
		HUDMessages[index].Damage = GearDamage;
		HUDMessages[index].bShowBlood = FALSE;
		HUDMessages[index].bUseMessageText = TRUE;
		HUDMessages[index].MessageText = AmmoText;
	}
}

/** @see AddDeathData **/
final function AddPlayerJoinMessage( PlayerReplicationInfo Player, String JoinMessage )
{
	local int index;
	local GearGRI GGRI;

	GGRI = GearGRI(WorldInfo.GRI);

	if (!WorldInfo.static.IsMenuLevel())
	{
		// Added gamestatus check in MP because the server thinks the player left them game during travel
		if (!bInMultiplayerMode || (GGRI != None && GGRI.GameStatus >= GS_RoundInProgress))
		{
			if (AddHUDMessage(Player, None, index))
			{
				PriorityHUDMessages[index].TimeRemaining = DeathDataTime;
				PriorityHUDMessages[index].Damage = None;
				PriorityHUDMessages[index].bShowBlood = FALSE;
				PriorityHUDMessages[index].bUseMessageText = TRUE;
				PriorityHUDMessages[index].MessageText = JoinMessage;
				PriorityHUDMessages[index].bAlwaysShow = TRUE;
			}
			else
			{
				HUDMessages[index].TimeRemaining = DeathDataTime;
				HUDMessages[index].Damage = None;
				HUDMessages[index].bShowBlood = FALSE;
				HUDMessages[index].bUseMessageText = TRUE;
				HUDMessages[index].MessageText = JoinMessage;
				HUDMessages[index].bAlwaysShow = TRUE;
			}

		}
	}
}

/** Is the loading or checkpoint currently drawing? */
final function bool LoadingTextIsDrawing()
{
	local GearEngine Engine;

	Engine = GearEngine(class'Engine'.static.GetEngine());

	if ( WorldInfo.bRequestedBlockOnAsyncLoading ||
		 (Engine != None && Engine.PendingCheckpointAction == Checkpoint_Save) ||
		 ((TimeOfLastCheckpoint + MinTimeBeforeFadeForCheckpoint + FadeTimeForCheckpoint > WorldInfo.TimeSeconds) && (TimeOfLastCheckpoint != -1)) )
	{
		return TRUE;
	}
	return FALSE;
}

/** Draw the loading text */
final function bool DrawLoadingText()
{
	local float FontCalcX, FontCalcY, SubTitleW, SubTitleH, StartY, DrawX, DrawY;
	local GearEngine Engine;
	local String StringToDraw;
	local byte Alpha;

	if ( LoadingTextIsDrawing() )
	{
		Alpha = 255;
		Engine = GearEngine(class'Engine'.static.GetEngine());
		if ( Engine != None && Engine.PendingCheckpointAction == Checkpoint_Save )
		{
			TimeOfLastCheckpoint = WorldInfo.TimeSeconds;

			// only draw the checkpoint text if the user is not saving to disk; when saving to disk we show a UI scene with an
			// animated cog material and different text
			if (!Engine.bShouldWriteCheckpointToDisk)
			{
				StringToDraw = CheckpointReachedString;
			}
		}
		else if ( TimeOfLastCheckpoint + MinTimeBeforeFadeForCheckpoint + FadeTimeForCheckpoint > WorldInfo.TimeSeconds &&
			      TimeOfLastCheckpoint != -1.0 )
		{
			// only draw the checkpoint text if the user is not saving to disk; when saving to disk we show a UI scene with an
			// animated cog material and different text
			if (WorldInfo.NetMode == NM_Client || !Engine.bShouldWriteCheckpointToDisk)
			{
				StringToDraw = CheckpointReachedString;
			}

			if ( TimeOfLastCheckpoint + MinTimeBeforeFadeForCheckpoint < WorldInfo.TimeSeconds )
			{
				Alpha = 255 * (1.0f - ((WorldInfo.TimeSeconds - TimeOfLastCheckpoint + MinTimeBeforeFadeForCheckpoint) / FadeTimeForCheckpoint));
			}
		}
		else
		{
			StringToDraw = LoadingString;
		}

		if ( StringToDraw != "" )
		{
			GetSubtitleSize( SubTitleW, SubTitleH );
			StartY = SafeZoneBottom + SubTitleH;

			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
			Canvas.TextSize( StringToDraw, FontCalcX, FontCalcY );
			FontCalcX *= 1.2;
			FontCalcY *= 1.2;
			DrawX = SafeZoneLeft;
			DrawY = Canvas.ClipY - StartY - FontCalcY;
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha );
			DrawObjectiveBack(Texture2D'Warfare_HUD.WarfareHUD_main', 156, 29, 21, 19, DrawX-8, DrawY-2, FontCalcX+16, FontCalcY+4 );

			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
			Canvas.SetPos( DrawX, DrawY );
			Canvas.DrawText( StringToDraw,, 1.2, 1.2 );
		}

		return TRUE;
	}

	return FALSE;
}

/** Whether the PRI is COG or Locust */
final function bool IsCOG( PlayerReplicationInfo PRI )
{
	return (class'GearGFxMoviePlayer'.static.GetRaceUsingPRIOnly(GearPRI(PRI)) == eGEARRACE_COG);
}

/** Whether we should draw the team color of the player */
function bool ShouldDrawTeamColor( PlayerReplicationInfo OtherPRI )
{
	return TRUE;
}

/**
 * Display how many points were earned for the last few kills
 *
 * @param DeltaTime - the duration of the last frame
 */
function DrawKillPoints(float DeltaTime)
{
	local byte Alpha;
	local string KillPointsText;
	local float XL, YL, TimeSinceStart, FadeAmount;
	local int i;

	while (i < KillPoints.length)
	{
		TimeSinceStart = WorldInfo.TimeSeconds - KillPoints[i].StartTime;
		if (TimeSinceStart > KillPointsTime + KillPointsFadeTime)
		{
			KillPoints.Remove(i, 1);
		}
		else
		{
			if (KillPoints[i].Value >= 0)
			{
				KillPointsText = "+" $ KillPoints[i].Value;
			}
			else
			{
				KillPointsText = String(KillPoints[i].Value);
			}

			FadeAmount = 1.0 - FMax(0.0, (TimeSinceStart - KillPointsTime) / KillPointsFadeTime);

			Alpha = 255.0f * FadeAmount;
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha);

			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
			Canvas.TextSize(KillPointsText, XL, YL);

			XL *= 1.2;
			YL *= 1.2;

			Canvas.SetPos( Lerp(Canvas.ClipX / 2.0 + 40, Canvas.ClipX * KillPointsDest.X + 40, 1.0 - FadeAmount),
					Lerp(Canvas.ClipY / 2.0 - YL / 2.0, Canvas.ClipY * KillPointsDest.Y, 1.0 - FadeAmount) );
			Canvas.DrawText(KillPointsText,, 1.2, 1.2);

			i++;
		}
	}
}

final function DrawHUDMessages(float DeltaTime)
{
	local float DrawXStart, DrawX, DrawY, TotalVerticalSpace, FontCalcX, FontCalcY;
	local int index, maxMessages, lastMessageIndex, PlayerIndex;

	local GearPC PC;

	PC = GearPC(PlayerOwner);

	// don't draw messages if we are displaying checkpoints
	if ( LoadingTextIsDrawing() || (HUDMessages.Length == 0 && PriorityHUDMessages.Length == 0))
	{
		return;
	}

	// update messages
	for ( index = 0; index < HUDMessages.length; index++ )
	{
		HUDMessages[index].TimeRemaining -= DeltaTime;
		if ( HUDMessages[index].TimeRemaining <= 0.f )
		{
			HUDMessages.Remove(index--, 1);
		}
	}
	for ( index = 0; index < PriorityHUDMessages.length; index++ )
	{
		PriorityHUDMessages[index].TimeRemaining -= DeltaTime;
		if ( PriorityHUDMessages[index].TimeRemaining <= 0.f )
		{
			PriorityHUDMessages.Remove(index--, 1);
		}
	}

	Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
	Canvas.TextSize( "W", FontCalcX, FontCalcY );


	//Normal HUD Messages
	DrawX = SafeZoneLeft;
	DrawY = Canvas.ClipY - SafeZoneBottom - FontCalcY;
	if (PC.IsSpectating() && PC.IsSplitscreenPlayer(PlayerIndex) && PlayerIndex == 1)
	{
		DrawY -= 20.f;
	}
	DrawXStart = DrawX;

	// calculate how many death messages we can show
	TotalVerticalSpace = Canvas.ClipY - SafeZoneTop - SafeZoneBottom;
	if ( FontCalcY != 0.f )
	{
		maxMessages = (TotalVerticalSpace * HUDMessagesScreenPercent) / FontCalcY;
	}
	lastMessageIndex = (HUDMessages.length <= maxMessages) ? 0 : (HUDMessages.length - maxMessages);

	for( index = HUDMessages.length - 1; index >= lastMessageIndex; index-- )
	{
		DrawY = DrawHUDMessage(HudMessages[index], DrawXStart, DrawY, FontCalcY, false);
	}

	//Priority HUD Messages
	// calculate how many death messages we can show
	TotalVerticalSpace = Canvas.ClipY - SafeZoneTop - SafeZoneBottom;
	if ( FontCalcY != 0.f )
	{
		maxMessages = (TotalVerticalSpace * PriorityHUDMessagesScreenPercent) / FontCalcY;
	}
	lastMessageIndex = (PriorityHUDMessages.length <= maxMessages) ? 0 : (PriorityHUDMessages.length - maxMessages);
	DrawX = (Canvas.ClipX - SafeZoneLeft - SafeZoneRight)/2 + SafeZoneLeft;
	DrawY = (TotalVerticalSpace/2) + SafeZoneBottom + PriorityHUDMessageYOffset;
	if (PC.IsSpectating() && PC.IsSplitscreenPlayer(PlayerIndex) && PlayerIndex == 1)
	{
		DrawY -= 20.f;
	}
	DrawXStart = DrawX;

	// don't draw priority messages if the UI is up since the center of the screen will be taken
	if (!HideHUDFromScenes())
	{
		for (index = PriorityHUDMessages.length - 1; index >= lastMessageIndex; index--)
		{
			DrawY = DrawHUDMessage(PriorityHudMessages[index], DrawXStart, DrawY, FontCalcY, true, true);
		}
	}
}

function float DrawHUDMessage(DeathData MessageData, float DrawXStart, float DrawYStart, float FontCalcY, bool bCenter, optional bool bUseFullWeaponName)
{
	local byte Alpha;
	local CanvasIcon DeathIcon;
	local float DrawX, DrawY, XL, YL, DamTypeHeight, TextYOffset, DrawOffsetY, FirstTextWidth, SecondTextWidth, WeaponWidth, WeaponIconWidth, WeaponNameWidth, BeforeWeaponX;
	local float MessageTextWidth;

	DrawX = DrawXStart;
	DrawY = DrawYStart;

	DeathIcon.Texture = None;
	// see if we should show this message or not
	if ( (bShowHud && (bInMultiplayerMode || !GearPC(Owner).IsDead())) || MessageData.bAlwaysShow )
	{
		Alpha = byte((MessageData.TimeRemaining > DeathDataFadeTime) ? 255.f : 255.f * (MessageData.TimeRemaining/DeathDataFadeTime));
		if ( MessageData.Damage != None )
		{
			if (MessageData.DeathType == GDT_HEADSHOT)
			{
				DeathIcon = class'GearDamageType'.default.HeadshotIcon;
			}
			else
			{
				DeathIcon = MessageData.Damage.default.KilledByIcon;
			}
			DamTypeHeight = DeathIcon.VL * MessageData.Scale;
		}
		else if (MessageData.GameSpecificID != -1 && (MessageData.GameSpecificID < GameSpecificIcon.Length || MessageData.GameSpecificID == 69))
		{
			// hey sexy!
			if (MessageData.GameSpecificID == 69)
			{
				DeathIcon = RevivedIcon;
			}
			else
			{
				DeathIcon = GameSpecificIcon[MessageData.GameSpecificID];
			}
			DamTypeHeight = DeathIcon.VL;
		}
		else
		{
			DamTypeHeight = FontCalcY;
		}

		if (MessageData.bShowPlayerNames)
		{
			Canvas.TextSize( MessageData.KillerName, FirstTextWidth, YL );
			Canvas.TextSize( MessageData.VictimName, SecondTextWidth, YL );
		}
		if (bUseFullWeaponName && MessageData.Damage != None &&  class'GearTypes'.default.WeaponClasses[MessageData.Damage.default.WeaponID] != None )
		{
			Canvas.TextSize( class'GearTypes'.default.WeaponClasses[MessageData.Damage.default.WeaponID].default.ItemName, WeaponNameWidth, YL );
		}
		if ( MessageData.Damage != None || DeathIcon.Texture != None )
		{
			WeaponIconWidth = (DeathIcon.UL*MessageData.Scale);
		}
		if ( WeaponNameWidth > WeaponIconWidth )
		{
			WeaponWidth = WeaponNameWidth;
		}
		else
		{
			WeaponWidth = WeaponIconWidth;
		}
		if (MessageData.bUseMessageText)
		{
			Canvas.TextSize(MessageData.MessageText, MessageTextWidth, YL);
		}

		if (bCenter)
		{
			DrawX = DrawXStart - ((FirstTextWidth+SecondTextWidth+WeaponWidth+MessageTextWidth)/2);
		}

		TextYOffset = fmax((DamTypeHeight/2 - FontCalcY/2), (FontCalcY/2 - DamTypeHeight/2));

		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );

		// draw the killer name
		if (MessageData.bShowPlayerNames)
		{
			if (MessageData.bKillerIsPlayerOne)
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_PLAYERONE], Alpha );
			}
			else if (MessageData.bKillerIsPlayerTwo)
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_PLAYERTWO], Alpha );
			}
			else if (MessageData.bUseTeamColors && MessageData.bKillerDrawTeamColor && MessageData.KillerTeamIndex != 255)
			{
				if (MessageData.bKillerIsCOG)
				{
					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_TEAMBLUE], Alpha );
				}
				else
				{
					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_RED], Alpha );
				}
			}
			else
			{
				//`log(`showvar(MessageData.bUseTeamColors)@`showvar(MessageData.bKillerDrawTeamColor)@`showvar(MessageData.KillerTeamIndex));
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
			}

			Canvas.TextSize( MessageData.KillerName, XL, YL );
			if ( MessageData.Damage != None )
			{
				DrawOffsetY = DeathIcon.VL * MessageData.Scale;
			}
			else
			{
				DrawOffsetY = YL;
			}
			Canvas.SetPos( DrawX,DrawY+TextYOffset-DrawOffsetY );
			Canvas.DrawText(MessageData.KillerName,,,, Text_NoClipShadowed);

			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
			DrawX += XL;
		}
		else
		{
			if ( MessageData.Damage != None )
			{
				DrawOffsetY = DeathIcon.VL * MessageData.Scale;
			}
			else
			{
				DrawOffsetY = FontCalcY;
			}
		}

		//save off where we started before we did the weapons
		BeforeWeaponX = DrawX;

		if (bUseFullWeaponName)
		{
			if (MessageData.Damage != None &&
				class'GearTypes'.default.WeaponClasses[MessageData.Damage.default.WeaponID] != None )
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
				DrawX += (WeaponWidth - WeaponNameWidth)/2;
				Canvas.SetPos (DrawX, DrawY+TextYOffset-DrawOffsetY+(FontCalcY*1.5));
				Canvas.DrawText(class'GearTypes'.default.WeaponClasses[MessageData.Damage.default.WeaponID].default.ItemName,,,, Text_NoClipShadowed);
			}
		}

		DrawX = BeforeWeaponX + ((WeaponWidth - WeaponIconWidth)/2);

		// draw backdrop blood
		if( MessageData.bShowBlood )
		{
			Canvas.SetPos( DrawX,DrawY-15-DrawOffsetY );

			// draw blood tile here
			Canvas.DrawIcon(BloodIcons[MessageData.BloodIconindex],DrawX,DrawY-15-DrawOffsetY);
		}

		if ( MessageData.Damage != None || DeathIcon.Texture != None )
		{
			// mega hack!
			Canvas.DrawIcon(DeathIcon,DrawX,DrawY-DrawOffsetY,MessageData.Scale);
		}

		DrawX = BeforeWeaponX + WeaponWidth;

		// draw the victim name
		if (MessageData.bShowPlayerNames)
		{
			if (MessageData.bVictimIsPlayerOne)
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_PLAYERONE], Alpha );
			}
			else if (MessageData.bVictimIsPlayerTwo)
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_PLAYERTWO], Alpha );
			}
			else if (MessageData.bUseTeamColors && MessageData.bVictimDrawTeamColor && MessageData.VictimTeamIndex != 255)
			{
				if (MessageData.bVictimIsCOG)
				{
					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_TEAMBLUE], Alpha );
				}
				else
				{
					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_TEAMRED], Alpha );
				}
			}
			else
			{
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
			}

			Canvas.SetPos( DrawX,DrawY+TextYOffset-DrawOffsetY );
			Canvas.DrawText(MessageData.VictimName,,,, Text_NoClipShadowed);
			if (MessageData.bUseMessageText)
			{
				Canvas.TextSize( MessageData.VictimName, XL, YL );
				DrawX += XL;
			}

			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
		}

		if( MessageData.bUseMessageText )
		{
			Canvas.SetPos( DrawX,DrawY+TextYOffset-DrawOffsetY );
			Canvas.DrawText(MessageData.MessageText,,,, Text_NoClipShadowed);
		}

		// move the Draw Pos to the next starting position
		//Skip two lines if you are drawing the full weapon name
		if (bUseFullWeaponName)
		{
			DrawY -= FontCalcY * 1.5f;
		}
		DrawY -= FontCalcY * 1.5f;
	}

	return DrawY;
}


function PlayCinematic()
{
	bPlayCinematic = TRUE;
	CinematicTextDisplayStartTime = WorldInfo.TimeSeconds;
}

function DrawTileSplit(Texture2D Tex, int TU, int TV, int TUL, int TVL, int X, int Y, int XL, int YL, int UL, int VL)
{
	// top lefth
	Canvas.SetPos(X,Y);
	Canvas.DrawTile(Tex,UL,VL,TU,TV,UL,VL);
	// top right
	Canvas.SetPos(X + XL - UL,Y);
	Canvas.DrawTile(Tex,UL,VL,TU+TUL-UL,TV,UL,VL);
	// bottom left
	Canvas.SetPos(X,Y + YL - VL);
	Canvas.DrawTile(Tex,UL,VL,TU,TV+TVL-VL,UL,VL);
	// bottom right
	Canvas.SetPos(X + XL - UL, Y + YL - VL);
	Canvas.DrawTile(Tex,UL,VL,TU+TUL-UL,TV+TVL-VL,UL,VL);
	// top
	Canvas.SetPos(X + UL,Y);
	Canvas.DrawTile(Tex,XL - (UL*2),VL,TU+UL,TV,TUL - (UL*2),VL);
	// bottom
	Canvas.SetPos(X + UL,Y + YL - VL);
	Canvas.DrawTile(Tex,XL - (UL*2),VL,TU+UL,TV+TVL-VL,TUL - (UL*2),TVL - VL);
	// middle
	Canvas.SetPos(X,Y + VL);
	//Canvas.DrawTile(Tex,XL,YL - (VL*2),TU+2,TV+VL,TUL-4,TVL - (VL*2));
	Canvas.DrawTile(Tex,XL,YL - (VL*2),TU,TV+VL,TUL,TVL - (VL*2));
}

function DrawObjectiveBack(Texture Tex, int TU, int TV, int TUL, int TVL, int X, int Y, int XL, int YL)
{
	local float ScaleY;
	ScaleY = float(YL) / float(TVL);

	// left
	Canvas.SetPos(X,Y);
	Canvas.DrawTile(Tex,TUL/2,TVL*ScaleY,TU,TV,TUL/2,TVL);
	// right
	Canvas.SetPos(X+XL-TUL/2,Y);
	Canvas.DrawTile(Tex,TUL/2,TVL*ScaleY,TU+TUL/2,TV,TUL/2,TVL);
	// middle
	Canvas.SetPos(X+TUL/2,Y);
	Canvas.DrawTile(Tex,XL-TUL+1,TVL*ScaleY,TU+TUL/2,TV,1,TVL);
}

/**
* Get the x position of the countdown timer in the hud - extracted from the UpdateCountdown() function
* so that the objective code can consider it to avoid overlapping.
*/
simulated final function float GetCountdownXPosition()
{
	return (Canvas.ClipX * 0.5 - CountdownSize.X * 0.5);
}

/** Get the coundtown Y Position */
simulated function float GetCountdownYPosition()
{
	return SafeZoneTop;
}

/** Whether the countdown timer is drawing or not */
simulated function bool CountdownTimerIsShowing()
{
	return ( (CountdownEndTime > 0) || ((CountdownStopTime > 0) && (WorldInfo.TimeSeconds-CountdownStopTime < CountdownTotalFadeOutTime)) );
}

/** Create a time string */
simulated function String CreateTimeString(float TimeInSeconds)
{
	local float CurrTime, NumMinutes, NumSeconds;
	local String TimeString;

	CurrTime = TimeInSeconds;
	NumMinutes = int(CurrTime / 60.0);
	NumSeconds = int(CurrTime - NumMinutes * 60.0);

	if (NumMinutes <= 0)
	{
		TimeString = "0:";
	}
	else
	{
		TimeString = int(NumMinutes) $ ":";
	}

	if (NumSeconds <= 0)
	{
		TimeString = TimeString $ "00";
	}
	else if (NumSeconds < 10.0)
	{
		TimeString = TimeString $ "0" $ int(NumSeconds);
	}
	else
	{
		TimeString = TimeString $ int(NumSeconds);
	}

	return TimeString;
}

/**
 * Update the countdown variables and draw the countdown
 *
 * @return - whether we drew the countdown or not
 */
simulated function bool UpdateCountdown()
{
	if (CountdownTimerIsShowing())
	{
		bDrewCountdownLastFrame = true;
		if (CountdownStopTime <= 0.0)
		{
			CountdownTimeToDraw = Max(CountdownEndTime - WorldInfo.TimeSeconds, 0.0);
		}

		return DrawCountdown();
	}
	else if (bDrewCountdownLastFrame)
	{
		// Restart the tutorial system if the timer just expired
		GearPC(PlayerOwner).RestartTutorialSystem(GearPC(PlayerOwner).bTutorialSystemWasOn);
		bDrewCountdownLastFrame = false;
	}

	return false;
}

/** @return color to draw the countdown numbers */
simulated function color GetCountdownColor()
{
	return HudColors[eWARHUDCOLOR_WHITE] * 0.75;
}

/**
 * Updates the countdown variables for drawing a countdown on the HUD
 *
 * @return - Whether we were able to draw the countdown or not
 */
simulated function bool DrawCountdown()
{
	local float TextWidth, TextHeight, FadePercent, YPos;
	local String TimeString;

	TimeString = CreateTimeString(CountdownTimeToDraw);

	// Calculate fade percent
	if (WorldInfo.TimeSeconds - CountdownStartTime < CountdownTotalFadeInTime)
	{
		FadePercent = (WorldInfo.TimeSeconds - CountdownStartTime) / CountdownTotalFadeInTime;
	}
	else if (CountdownStopTime > 0.0f)
	{
		if ( (WorldInfo.TimeSeconds - CountdownStopTime) < CountdownTotalFadeOutTime )
		{
			FadePercent = 1.0f - ((WorldInfo.TimeSeconds - CountdownStopTime) / CountdownTotalFadeOutTime);
		}
		// Fade percent is now at or below 0, so stop drawing the countdown
		else
		{
			CountdownEndTime = 0.0f;
			CountdownStopTime = 0.0f;
			return FALSE;
		}
	}
	else
	{
		FadePercent = 1.0f;
	}

	YPos = GetCountdownYPosition();

	// Draw the background
	Canvas.DrawColor = WhiteColor;
	Canvas.DrawColor.A = 255 * FadePercent;
	Canvas.SetPos(GetCountdownXPosition(), YPos);
	Canvas.DrawTile(CountdownBgdIcon.Texture, CountdownSize.X, CountdownSize.Y, CountdownBgdIcon.U, CountdownBgdIcon.V, CountdownBgdIcon.UL, CountdownBgdIcon.VL);

	// Draw the time
	`SetHUDDrawColor(GetCountdownColor(), byte(255.0f*FadePercent));
	Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
	Canvas.TextSize(TimeString, TextWidth, TextHeight);
	TextHeight *= 1.2;
	TextWidth *= 1.2;
	Canvas.SetPos(Canvas.ClipX / 2 - TextWidth / 2, YPos + CountdownBgdIcon.VL / 2 - TextHeight / 2 + 1);
	Canvas.DrawText(TimeString,, 1.2, 1.2);

	return TRUE;
}

/** Start the process of drawing the dramatic text */
simulated function StartDrawingDramaticText( String FirstString, String SecondString, float TotalDrawTime, float TotalFadeInTime, float TotalFadeOutTime, optional float StartDrawYPos = -1, optional float LineWaitTime = 1.0f, optional float LineFadeTime = 1.0f )
{
	local GearPC PC;

	if (WorldInfo.GRI.IsMultiPlayerGame() && GearGRI_MP(WorldInfo.GRI).TrainingGroundsID < 0)
	{
		PC = GearPC(PlayerOwner);
		// Stop tutorials if this is not siege
		if (PC != None &&
			PC.TutorialMgr != None &&
			PC.TutorialMgr.AutoInitType != eGAIT_Siege)
		{
			// Stop the tutorial system since the dramatic text will overlap it, but don't wipe siege tutorials
			PC.StopTutorialSystem(false);
		}
	}

	TotalDramaticStringDrawTime = TotalDrawTime;
	TotalDramaticStringFadeInTime = TotalFadeInTime;
	TotalDramaticStringFadeOutTime = TotalFadeOutTime;
	DramaticStringDrawStartTime = WorldInfo.TimeSeconds;
	DramaticString1 = FirstString;
	DramaticString2 = SecondString;
	DramaticTextDrawYStart = StartDrawYPos;
	DramaticLineWaitTime = LineWaitTime;
	DramaticLineFadeTime = LineFadeTime;
}

/** Stop the process of drawing the dramatic string */
simulated function StopDrawingDramaticText()
{
	local GearPC PC;

	TotalDramaticStringDrawTime = 0.0f;
	DramaticStringDrawStartTime = 0.0f;

	if (WorldInfo.GRI.IsMultiPlayerGame())
	{
		PC = GearPC(PlayerOwner);
		// Restart tutorials if this is not siege
		if (PC != None &&
			PC.TutorialMgr != None &&
			PC.TutorialMgr.AutoInitType != eGAIT_Siege)
		{
			// Start the tutorial system back up again
			GearPC(PlayerOwner).RestartTutorialSystem(GearPC(PlayerOwner).bTutorialSystemWasOn, false);
		}
	}
}

/** Whether the dramatic text is drawing or not */
simulated function bool IsDramaticTextDrawing()
{
	return (DramaticStringDrawStartTime > 0.0f);
}

/** Update and draw the dramatic text */
simulated function bool UpdateDramaticText()
{
	local float DrawX, DrawY, FirstStringTextWidth, FirstStringTextHeight, SecondStringTextWidth, SecondStringTextHeight, AlphaPercent, LineAlphaPercent;
	local byte Alpha, LineAlpha;
	local GearPC PC;
	local bool bIsSplitscreen;
	local bool bIsMultiplayer;


	if ( DramaticStringDrawStartTime > 0.0f )
	{
		// Stop drawing it.
		if ( (WorldInfo.TimeSeconds - DramaticStringDrawStartTime) > TotalDramaticStringDrawTime )
		{
			StopDrawingDramaticText();
			return FALSE;
		}

		PC = GearPC(PlayerOwner);
		bIsSplitscreen = PC.IsSplitscreenPlayer();

		// Err that it is multiplayer (since GRI issues probably won't crop up in single player)
		bIsMultiplayer = true;
		if (WorldInfo.GRI != None)
		{
			bIsMultiplayer = WorldInfo.GRI.IsMultiPlayerGame();
		}

		// Fading in text
		if ( (WorldInfo.TimeSeconds - DramaticStringDrawStartTime) < TotalDramaticStringFadeInTime )
		{
			AlphaPercent = (WorldInfo.TimeSeconds - DramaticStringDrawStartTime) / TotalDramaticStringFadeInTime;
		}
		// Fading out text
		else if ( (WorldInfo.TimeSeconds - DramaticStringDrawStartTime) > (TotalDramaticStringDrawTime - TotalDramaticStringFadeOutTime) )
		{
			AlphaPercent = (TotalDramaticStringDrawTime - (WorldInfo.TimeSeconds - DramaticStringDrawStartTime)) / TotalDramaticStringFadeOutTime;
		}
		else
		{
			AlphaPercent = 1.0f;
		}

		Alpha = byte(255.0f * AlphaPercent);

		// Fading in lines
		if ( ((WorldInfo.TimeSeconds - DramaticStringDrawStartTime) <= DramaticLineWaitTime) || ((WorldInfo.TimeSeconds - DramaticStringDrawStartTime) >= (TotalDramaticStringDrawTime - DramaticLineWaitTime)) )
		{
			LineAlphaPercent = 0.0f;
		}
		else if ( ((WorldInfo.TimeSeconds - DramaticStringDrawStartTime) > DramaticLineWaitTime) && ((WorldInfo.TimeSeconds - DramaticStringDrawStartTime) < (DramaticLineWaitTime + DramaticLineFadeTime)) )
		{
			LineAlphaPercent = (WorldInfo.TimeSeconds - DramaticStringDrawStartTime - DramaticLineWaitTime) / DramaticLineFadeTime;
		}
		// Fading out lines
		else if ( ((WorldInfo.TimeSeconds - DramaticStringDrawStartTime) > (TotalDramaticStringDrawTime - DramaticLineWaitTime - DramaticLineFadeTime)) && ((WorldInfo.TimeSeconds - DramaticStringDrawStartTime) < (TotalDramaticStringDrawTime - DramaticLineWaitTime)) )
		{
			LineAlphaPercent = (TotalDramaticStringDrawTime - (WorldInfo.TimeSeconds - DramaticStringDrawStartTime) - DramaticLineWaitTime) / DramaticLineFadeTime;
		}
		else
		{
			LineAlphaPercent = 1.0f;
		}

		LineAlpha = byte(255.0f * LineAlphaPercent);

		// Draw the first string with black backdrop
		Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		Canvas.TextSize( DramaticString1, FirstStringTextWidth, FirstStringTextHeight );
		FirstStringTextWidth *= 1.2;
		FirstStringTextHeight *= 1.2;

		DrawY = (DramaticTextDrawYStart == -1) ? Canvas.ClipY - SafeZoneBottom - 150.0f : DramaticTextDrawYStart;
		DrawX = Canvas.ClipX/2 - FirstStringTextWidth/2;
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha );
		Canvas.SetPos( DrawX+3, DrawY );
		Canvas.DrawText( DramaticString1,, 1.2, 1.2 );
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
		Canvas.SetPos( DrawX, DrawY-3 );
		Canvas.DrawText( DramaticString1,, 1.2, 1.2  );

		// Draw the left line
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], LineAlpha );
		Canvas.SetPos( DrawX - 512, DrawY-3+(FirstStringTextHeight/2)-8 );
		// Don't show the lines in splitscreen MP
		if (!bIsSplitscreen || !bIsMultiplayer)
		{
			Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_TitleLineBreak', 512, 16, 0, 0, 512, 16);
		}
		// Draw the right line
		Canvas.SetPos( DrawX + FirstStringTextWidth, DrawY-3+(FirstStringTextHeight/2)-8 );
		// Don't show the lines in splitscreen MP
		if (!bIsSplitscreen || !bIsMultiplayer)
		{
			Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_TitleLineBreak', 512, 16, 512, 0, -512, 16);
		}

		// Draw the second string with black backdrop if there is one
		if ( DramaticString2 != "" )
		{
			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
			Canvas.TextSize( DramaticString2, SecondStringTextWidth, SecondStringTextHeight );
			DrawY += FirstStringTextHeight;
			DrawX = Canvas.ClipX/2 - SecondStringTextWidth/2;
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha );
			Canvas.SetPos( DrawX+3, DrawY );
			Canvas.DrawText( DramaticString2 );
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
			Canvas.SetPos( DrawX, DrawY-3 );
			Canvas.DrawText( DramaticString2 );

			// Draw the bottom line
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], LineAlpha );
			Canvas.SetPos( Canvas.ClipX/2 - 512, DrawY+SecondStringTextHeight );
			// Don't show the lines in splitscreen MP
			if (!bIsSplitscreen || !bIsMultiplayer)
			{
				Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_TitleLineBreak', 512, 16, 0, 0, 512, 16);
			}
			Canvas.SetPos( Canvas.ClipX/2, DrawY+SecondStringTextHeight );
			// Don't show the lines in splitscreen MP
			if (!bIsSplitscreen || !bIsMultiplayer)
			{
				Canvas.DrawTile( Texture2D'Warfare_HUD.HUD_TitleLineBreak', 512, 16, 512, 0, -512, 16);
			}
		}

		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

/** Start the process of drawing the subtitle text (not actually subtitles... just the location where subtitle WOULD be)*/
simulated function StartDrawingSubtitleText( String StringToDraw, float TotalDrawTime, float TotalFadeInTime, float TotalFadeOutTime )
{
	TotalSubtitleStringDrawTime = TotalDrawTime;
	TotalSubtitleStringFadeInTime = TotalFadeInTime;
	TotalSubtitleStringFadeOutTime = TotalFadeOutTime;
	SubtitleStringDrawStartTime = WorldInfo.TimeSeconds;
	SubtitleString = StringToDraw;
}

/** Stop the process of drawing the subtitle string */
simulated function StopDrawingSubtitleText()
{
	TotalSubtitleStringDrawTime = 0.0f;
	SubtitleStringDrawStartTime = 0.0f;
}

/** Update and draw the subtitle text */
simulated function UpdateSubtitleText()
{
	local float DrawX, DrawY, StringTextWidth, StringTextHeight, AlphaPercent;
	local byte Alpha;

	if ( SubtitleStringDrawStartTime > 0.0f )
	{
		// Stop drawing it.
		if ( (WorldInfo.TimeSeconds - SubtitleStringDrawStartTime) > TotalSubtitleStringDrawTime )
		{
			StopDrawingSubtitleText();
			return;
		}

		// Fading in text
		if ( (WorldInfo.TimeSeconds - SubtitleStringDrawStartTime) < TotalSubtitleStringFadeInTime )
		{
			AlphaPercent = (WorldInfo.TimeSeconds - SubtitleStringDrawStartTime) / TotalSubtitleStringFadeInTime;
		}
		// Fading out text
		else if ( (WorldInfo.TimeSeconds - SubtitleStringDrawStartTime) > (TotalSubtitleStringDrawTime - TotalSubtitleStringFadeOutTime) )
		{
			AlphaPercent = (TotalSubtitleStringDrawTime - (WorldInfo.TimeSeconds - SubtitleStringDrawStartTime)) / TotalSubtitleStringFadeOutTime;
		}
		else
		{
			AlphaPercent = 1.0f;
		}

		Alpha = byte(255.0f * AlphaPercent);

		// Draw the first string with black backdrop
		Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		Canvas.TextSize( SubtitleString, StringTextWidth, StringTextHeight );
		StringTextWidth *= 1.2;
		StringTextHeight *= 1.2;
		DrawY = Canvas.ClipY - SafeZoneBottom - StringTextHeight;
		DrawX = Canvas.ClipX/2 - StringTextWidth/2;
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], Alpha );
		Canvas.SetPos( DrawX+3, DrawY );
		Canvas.DrawText( SubtitleString,, 1.2, 1.2 );
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
		Canvas.SetPos( DrawX, DrawY-3 );
		Canvas.DrawText( SubtitleString,, 1.2, 1.2 );
	}
}

/**
 * Called by GearWeaponPickupFactory when pickup attempt fails because bCanPickupFactoryWeapons==FALSE
 */
function WeaponFactoryPickupFailed();

/**
 * Subfunction for scoreboard control in children
 * bUseAtoContinueVersion - whether to show the "Press A to Continue" string or not... if not
 * then the "B Back" string shows instead.
 */

function ToggleScoreboard(bool bOn);

/** Used to clear refs that would break GC */
function ClearScoreboardRef();

/**
 * Allows for easy opening of the EndRound/Match menu
 */

function SignalEndofRoundOrMatch(GearGRI GRI);
function SignalStartofRoundOrMatch(GearGRI GRI);

/** Helper function to draw a string with a black background */
simulated function DrawStringWithBackground( float DrawX, float DrawY, String TextToDisplay, optional EGearHUDColor TextColor = eWARHUDCOLOR_WHITE, optional float WidthScale, optional float HeightScale )
{
	local float BackgroundOffset, TextSizeX, TextSizeY, TextDrawWidth;

	BackgroundOffset = 2.0f;

	// Background
	Canvas.TextSize(TextToDisplay, TextSizeX, TextSizeY);
	TextDrawWidth = TextSizeX * WidthScale + 16;
	`SetHUDDrawColor(HudColors[eWARHUDCOLOR_BLACK], 200 );
	DrawObjectiveBack(Texture2D'Warfare_HUD.WarfareHUD_main', 156, 29, 21, 19, DrawX - 8, DrawY - BackgroundOffset, TextDrawWidth, TextSizeY * HeightScale + 2 * BackgroundOffset);

	// Text
	Canvas.SetPos(DrawX,DrawY);
	`SetHUDDrawColor(HudColors[TextColor]);
	Canvas.DrawText(TextToDisplay,, WidthScale, HeightScale);
}

/** Stub for Annex HUD */
function SetCommandPointIndicatorGlow( int NumPulses, float PulseLength )
{
}

/** Stub for Annex HUD */
function DoEndOfGameWarning( int ScoreDiff, int TeamIndex )
{
}

`define		SCENEFILTER_PausersOnly		0x00000004
/**
* Callback so the pause system can know when to unpause the game
*
* @return TRUE if the pause can be removed, FALSE otherwise
*/
function bool CanUnpauseFromUIOpen()
{
	local UIInteraction UIController;
	local bool bResult;

	bResult = TRUE;

	// normally, the UI would prevent the game from being unpaused if any scenes which have bPauseGameWhileActive=TRUE are active.  Since
	// we override the default pause handling in order to apply post-process effects, we need to represent the UI's unpause logic here.
	UIController = PlayerOwner.GetUIController();
	if ( UIController != None )
	{
		bResult = !UIController.SceneClient.IsUIActive(`SCENEFILTER_PausersOnly);
	}

	return bResult;
}

/** Whether the show the hud or not based on screens showing in front of it */
function bool HideHUDFromScenes()
{
	return (GameOverPlayer != none ||
			EndRoundUIScenePlayerInstance != none ||
			UI_PauseSceneInstance != none);
}

/** Allow the HUD to close any scenes or cleanup any UI for when the pause screen is opened */
function CleanUIForPauseScreen();

/** Handles opening the pause screen */
function PauseGame( optional delegate<PlayerController.CanUnpause> CanUnpauseDelegate=CanUnpauseFromUIOpen )
{
	local GearPC MyGearPC;
	local delegate<PlayerController.CanUnpause> DefaultUnpauseDelegate;

	// never pause the game if we're in the menu level - this can happen if the player presses START to bypass the startup movie
	// since both the rendering and game thread will receive the input event
	if ( class'WorldInfo'.static.IsMenuLevel() )
	{
		return;
	}

	MyGearPC = GearPC(PlayerOwner);

	//Open NEW GFX pause screen
	if (UI_PauseSceneClass != None)
	{
		if ( UI_PauseSceneInstance == None && GameOverPlayer == None)
		{
			// Clean up any UI before opening the pause screen
			CleanUIForPauseScreen();

			UI_PauseSceneInstance = new(self) UI_PauseSceneClass;
			UI_PauseSceneInstance.Init(LocalPlayer(MyGearPC.Player));

			if ( UI_PauseSceneInstance != None )
			{
				GearPC(PlayerOwner).StartPostProcessOverride( eGPP_Pause, TRUE );

				// only server can pause.  Opening the pause scene should have already paused the game [because it has
				// bPauseGameWhileActive set] - this is only necessary in cases where we're adding additional CanUnpauseDelegate handlers
				// and the game is already paused.
				if ( WorldInfo.NetMode != NM_Client || WorldInfo.IsPlayingDemo() )
				{
					// but skip this step if we're already paused and the CanUnpauseDelegate is the GearPC's default one.
					DefaultUnpauseDelegate = MyGearPC.CanUnpause;
					if ( !MyGearPC.IsPaused() || CanUnpauseDelegate != DefaultUnpauseDelegate )
					{
						PlayerOwner.SetPause(TRUE,CanUnpauseDelegate);
					}
				}

				// turn subtitles off
				MyGearPC.SetShowSubtitles( FALSE );
			}
		}
	}
}

function UnPauseGame()
{
	local GearPC PC;

	if ( UI_PauseSceneInstance != None || GameOverPlayer != None )
	{
		GearPC(PlayerOwner).StopPostProcessOverride( eGPP_Pause );

		// Close the pause menu player, if there is one
		if (UI_PauseSceneInstance != None)
		{
			UI_PauseSceneInstance.Close(TRUE);
			UI_PauseSceneInstance = None;
		}

		// Close the game over player, if there is one
		if( GameOverPlayer != None )
		{
			GameOverPlayer.Close(TRUE);
			GameOverPlayer = None;
		}

		// only server can unpause
		if (WorldInfo.NetMode != NM_Client)
		{
			PlayerOwner.SetPause(false);
			foreach WorldInfo.AllControllers(class'GearPC', PC)
			{
				if (LocalPlayer(PC.Player) == None)
				{
					PC.ClientUpdateHostPause(false);
				}
			}
		}

		// reset subtitles
		GearPC(PlayerOwner).RestoreShowSubtitles();
	}
}

/** Open the UI scene for a discoverable */
final function OpenDiscoverableScene()
{
	if( (DiscoverablePlayerClass != None) && (DiscoverablePlayerInstance == None) )
	{
		DiscoverablePlayerInstance = new(self) DiscoverablePlayerClass;
		DiscoverablePlayerInstance.Init(LocalPlayer(PlayerOwner.Player));
	}
}

/** Close the UI scene for a discoverable */
final function CloseDiscoverableScene()
{
	if( DiscoverablePlayerInstance != None )
	{
		DiscoverablePlayerInstance.Close();
	}
}

/**
 * Make sure the GRI has been replicated to this player before opening this scene.  This could happen if a player comes in late to the game and the end of round screen opens before
 * the replication of the GRI happens
 *
 * @return TRUE if the GRI is valid, and allows for the EOR scene to be up, FALSE if not
 */
function bool DoesGRIAllowEndOfRoundScene()
{
	return ( ((GearGRI(WorldInfo.GRI) != None) || (WorldInfo.GRI != None && WorldInfo.GRI.PRIArray.length >= 1)) );
}

/** Open the EndOfRound scene */
function OpenEndOfRoundScene()
{
	local GearPC MyGearPC;
	local GearPC_Siege PC_S;
	local int i, k;

	// Make sure the GRI has been replicated to this player before opening this scene,
	// this could happen if a player comes in late to the game and the EndOfRound screen opens before replication of the GRI happens
	if ( (EndRoundUIScenePlayerInstance == None) && DoesGRIAllowEndOfRoundScene() )
	{
		MyGearPC = GearPC(PlayerOwner);

		//If this is siege and the char select screen is open, close it
		PC_S = GearPC_Siege(MyGearPC);
		if( (PC_S != None) && (PC_S.CharSelectMovie != None) )
		{
			PC_S.CharSelectMovie.Close();
			PC_S.CharSelectMovie = none;
		}

		if( EndRoundUIScenePlayerClass != None )
		{
			// If a GFx scoreboard is available, spawn the movie player here
			EndRoundUIScenePlayerInstance = new(self) EndRoundUIScenePlayerClass;
			EndRoundUIScenePlayerInstance.Init(LocalPlayer(MyGearPC.Player));
		}
	}

	// End of round scene is going to open over top of the PriorityHUDMessages
	// Move them all to regular HUDMessages
	for (i = 0; i < PriorityHUDMessages.Length; i++)
	{
		// If it'll just fit on the end, go ahead
		if (HUDMessages.Length < MaxHUDMessages)
		{
			HUDMessages.Add(1);
			HUDMessages[HUDMessages.Length - 1] = PriorityHUDMessages[i];
			continue;
		}

		// Try to find a HUDMessage that's older than a PriorityHUDMessage
		for (k = 0; k < HUDMessages.Length; k++)
		{
			if (PriorityHUDMessages[i].TimeRemaining >= HUDMessages[k].TimeRemaining)
			{
				HUDMessages.Remove(0, 1);
				HUDMessages.Add(1);
				HUDMessages[HUDMessages.Length - 1] = PriorityHUDMessages[i];
				break;
			}
		}
	}
	PriorityHUDMessages.Length = 0;
}

/** Close the EndOfRound scene
 *  @return Whether or not there will be a personal progression scene shown
 */
function bool CloseEndOfRoundScene()
{
	if( EndRoundUIScenePlayerInstance != None )
	{
		EndRoundUIScenePlayerInstance.Close();
		EndRoundUIScenePlayerInstance = None;
	}

	return FALSE;
}

/** Whether the EndOfRound scene is drawing or not */
final function bool EndOfRoundSceneIsOpen()
{
	return (EndRoundUIScenePlayerInstance != None);
}

/**
 * Opens the callout screen.  If none is available, it will instantiate one
 */
function OpenCalloutScene()
{
	// If we haven't already instantiated a callout scene, do so now
	if( (CalloutSceneInstance == None) && (CalloutPlayerClass != None) )
	{
		CalloutSceneInstance = new(self) CalloutPlayerClass;
		CalloutSceneInstance.Init( LocalPlayer(PlayerOwner.Player) );
	}
}

/**
 * Displays the act and chapter callout text
 *
 * @param   ActToDisplay        Act name to display
 * @param   ChapterToDisplay    ChapterToDisplay
 */
function DisplayChapterCallout(string ActToDisplay, string ChapterToDisplay, string ChapterTime, string ChapterLocation)
{
	// Open the callout scene, if it isn't already
	OpenCalloutScene();

	if( CalloutSceneInstance != None )
	{
		CalloutSceneInstance.SetActChapterText(ActToDisplay, ChapterToDisplay, ChapterTime, ChapterLocation);
	}
}

function AdvanceCredits()
{
	// Open the callout scene, if it isn't already
	OpenCalloutScene();

	if( CalloutSceneInstance != None )
	{
		CalloutSceneInstance.AdvanceCredits();
	}
}

/** shows the game over screen */
function ShowGameOverScreen(string Reason, GearPRI Target)
{
	local GearPC MyGearPC;
	local array<string> Pieces;
	local string ParsedReason;

	// never pause the game if we're in the menu level - this can happen if the player presses START to bypass the startup movie
	// since both the rendering and game thread will receive the input event
	if ( class'WorldInfo'.static.IsMenuLevel() || PlayerOwner == None || !PlayerOwner.IsPrimaryPlayer() )
	{
		return;
	}

	ActiveAction.bActive = FALSE;

	// Only open the pause screen if it hasn't been opened already
	if ( GameOverPlayer == None )
	{
		// Clean up any UI before opening the pause screen
		CleanUIForPauseScreen();

		MyGearPC = GearPC(PlayerOwner);
		GameOverPlayer = new(self) GameOverPlayerClass;

		if ( GameOverPlayer != None )
		{
			GameOverPlayer.Init(LocalPlayer(MyGearPC.Player));

			// Handle the parsing and localization of the failure reason
			ParseStringIntoArray(Reason, Pieces, ".", true);
			if( Pieces.Length == 3 )
			{
				ParsedReason = Localize(Pieces[1], Pieces[2], Pieces[0]);
				if (Left(ParsedReason, 1) == "?")
				{
					// failure, go with empty string
					ParsedReason = "";
				}
				else if (Target != None)
				{
					ParsedReason = Repl(ParsedReason, "~t", Target.PlayerName);
				}

				//Find the reason label and set it!
				GameOverPlayer.SetFailureReason(ParsedReason);
			}


			// only server can pause
			if (WorldInfo.NetMode != NM_Client)
			{
				MyGearPC.SetPause(TRUE,CanUnpauseFromUIOpen);
			}

			// turn subtitles off
			MyGearPC.SetShowSubtitles( FALSE );
		}
	}
}

/** Get the player reference for gameover */
function UIScene_GameOver GetGameoverPlayerReference()
{
	return GameOverPlayer;
}

/** Closes the game over scene, if needed */
function ConditionalCloseGameOverScene()
{
	if( GameOverPlayer != None )
	{
		GameOverPlayer.Close(TRUE);
		GameOverPlayer = None;
	}
}

/** Get the scene reference for pausing */
function UIScene_Pause GetPauseSceneReference()
{
	return UI_PauseSceneInstance;
}

/**
 * Opens the path selection scene
 *
 * @param   Action  The kismet action with the path selection data
 */
function OpenPathChoiceScene( SeqAct_DisplayPathChoice Action )
{
	local LocalPlayer LP;

	if( Action != None )
	{
		LP = LocalPlayer(PlayerOwner.Player);
		PathChoiceScene = new(self) PathChoicePlayerClass;
		if ( PathChoiceScene != None )
		{
			PathChoiceScene.Init(LP);
			Action.InitializePathChoice( PathChoiceScene, LP );
		}
	}
}

/**
 * Called on clients to replicate the host's choice for path selection
 *
 * @param   bLeftPathSelected   TRUE if the left path was selected, FALSE if the right path was selected
 */
function ClientActivatePathChoice( bool bLeftPathSelected )
{
	if( PathChoiceScene != None )
	{
		PathChoiceScene.PathSelected(bLeftPathSelected);
	}
}

/** Message from the game object that a leader has died */
function StartLeaderDiedMessage( GearPRI LeaderPRI );

/** Message from the game object that my buddy has died */
function StartBuddyDiedMessage( GearPRI BuddyPRI );

/** Message from the game object that weapons are available */
function StartWeaponSpawnedMessage();

/** Allow HUD to handle a pawn being spotted when targetting */
function HandlePawnTargetted( GearPawn TargetPawn );

/** Message from the game object that only lambent are left */
function StartOnlyLambentLeftMessage();

/** Function that can be overloaded by game-specific HUDs to draw icons above the heads of players */
function DrawSpecialPlayerIcons(GearPawn GP)
{
	local int Idx;

	// in base case, handle target-lock icons
	for (Idx=0; Idx<GP.MissileLockTargets.length; ++Idx)
	{
		DrawTargetLockIconAboveActor(GP.MissileLockTargets[Idx], 255*WeaponFadeOpacity);
	}
}


/** Draw the "target lock" icon above the head of the buddy  Prototype for Heavy rocket launcher. */
final function DrawTargetLockIconAboveActor( Actor ActorToDraw, byte Alpha )
{
	local vector PawnExtent, ScreenLoc, CameraDir, BuddyDir;
	local GearPC PC;
	local vector CameraLoc;
	local rotator CameraRot;
//	local float IconScale;

	local GearPawn PawnToDraw;
	local float BoxW, BoxH;

	BoxW = 30;
	BoxH = 30;

	PC = GearPC(PlayerOwner);

	PC.GetPlayerViewpoint( CameraLoc, CameraRot );

	PawnToDraw = GearPawn(ActorToDraw);
	if (PawnToDraw != None)
	{
		if (!PawnToDraw.bIsHiddenByCamera)
		{
			CameraDir = vector(CameraRot);
			BuddyDir = PawnToDraw.Location - CameraLoc;
			if ( CameraDir Dot BuddyDir > 0 )
			{
				PawnExtent = PawnToDraw.Mesh.GetBoneLocation( PawnToDraw.HeadBoneNames[0] );
				PawnExtent.Z += 30.0f;
				ScreenLoc = Canvas.Project( PawnExtent );
//				IconScale = 1.0f;

				// Set the text position and draw
//				`SetHUDDrawColor(HudColors[ColorType, Alpha );
				Canvas.SetPos(ScreenLoc.X-BoxW/2, ScreenLoc.Y-BoxH/2);
				Canvas.SetDrawColor(64,255,64,Alpha);
				Canvas.DrawBox(BoxW, BoxH);
			}
		}
	}
	else if (ActorToDraw != None)
	{
		ScreenLoc = Canvas.Project( ActorToDraw.Location + vect(0,0,30) );

		Canvas.SetPos(ScreenLoc.X-BoxW/2, ScreenLoc.Y-BoxH/2);
		Canvas.SetDrawColor(64,255,64,Alpha);
		Canvas.DrawBox(BoxW, BoxH);
	}
}

/** @return human readable name of starting weapon with the given index from the PRI by looking it up in the UI weapon providers */
final function string GetStartingWeaponName(int Index)
{
	local UIProviderScriptFieldValue WeaponValue;
	local GearUIDataStore_GameResource GameResourceDS;
	local string Result;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	if (GameResourceDS != None)
	{
		WeaponValue.PropertyTag = 'WeaponId';
		WeaponValue.PropertyType = DATATYPE_Property;
		WeaponValue.StringValue = string(Index);
		Index = GameResourceDS.FindProviderIndexByFieldValue('Weapons', 'WeaponId', WeaponValue);
		if (Index != INDEX_NONE)
		{
			Result = class'GearUIDataStore_GameResource'.static.GetWeaponProvider(Index).FriendlyName;
		}
	}
	return Result;
}

/** @return whether to show the UI for selecting default weapons in the spectator interface */
function bool ShowDefaultWeaponSelector()
{
	return !PlayerOwner.IsSplitscreenPlayer();
}

/** determine if we should draw the spectator scene and draw it if so */
function CheckSpectatorScene()
{
	local GearPC MyGearPC;
	local GearPRI PRI;
	local float YPos, XL, YL, ButtonXL, GhostLabelXPos, ShowNamesXPos;
	local string MainTitle;
	local bool bInactiveGhostCamLabel;

	if (WorldInfo.GRI != None && GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress && !HideHUDFromScenes())
	{
		MyGearPC = GearPC(PlayerOwner);
		if (MyGearPC.WantsSpectatorUI())
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], 255);

			YPos = Canvas.ClipY - (PlayerOwner.IsSplitscreenPlayer() ? 36.0 : 84.0) - 31.0;

			Canvas.SetPos(0, YPos - 24.0);
			Canvas.DrawTile(SpectateBackgroundIcon.Texture, Canvas.ClipX, 432, SpectateBackgroundIcon.U, SpectateBackgroundIcon.V, SpectateBackgroundIcon.UL, SpectateBackgroundIcon.VL);

			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Xbox360_18pt);
			Canvas.DrawIcon(SpectatePlayersIcon, 96.0, YPos, 0.75);
			Canvas.SetPos(136, YPos + 4);
			Canvas.DrawText("_`");

			if (WorldInfo.GRI.IsMultiplayerGame())
			{
				Canvas.DrawIcon(SpectateBattleCamIcon, Canvas.ClipX - 128.0, YPos, 0.75);
				Canvas.StrLen("]^", XL, YL);
				Canvas.SetPos(Canvas.ClipX - 136.0 - XL, YPos + 4);
				Canvas.DrawText("]^");
			}

			if (MyGearPC.GetStateName() == 'GhostSpectating')
			{
				if (GearGRI_Horde(WorldInfo.GRI) != None)
				{
					Canvas.SetDrawColor(180,180,180,180);
					Canvas.SetPos(Canvas.ClipX/2 - FriendlyCrosshair.GetSurfaceWidth()/2 - 1,Canvas.ClipY/2 - FriendlyCrosshair.GetSurfaceHeight()/2);
					Canvas.DrawTexture(FriendlyCrosshair,1.0);

					`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], 255);
					Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
					Canvas.StrLen("SPOT", XL, YL); //@FIXME
					Canvas.SetPos((Canvas.ClipX - XL)/2, Canvas.ClipY / 2 + FriendlyCrosshair.GetSurfaceHeight());
					Canvas.DrawText("SPOT"); //@FIXME
				}

				MainTitle = SpectateGhostTitle;
				bInactiveGhostCamLabel = true;
			}
			else if (MyGearPC.GetStateName() == 'CustomSpectating')
			{
				MainTitle = SpectateBattleCamTitle;
			}
			else
			{
				MainTitle = (Pawn(MyGearPC.ViewTarget) != None) ? Pawn(MyGearPC.ViewTarget).PlayerReplicationInfo.PlayerName : "";
				// If our last pawn is what we're spectating, we're viewing our own dead body so say how we died
				if (MyGearPC.LastPawn == MyGearPC.ViewTarget)
				{
					PRI = GearPRI(MyGearPC.PlayerReplicationInfo);
					if (PRI != None && PRI.LastToKillMePRI != None)
					{
						if (PRI.DamageTypeToKillMe != None && PRI.DamageTypeToKillMe.default.KilledByText != "")
						{
							MainTitle = PRI.DamageTypeToKillMe.default.KilledByText @ PRI.LastToKillMePRI.PlayerName;
						}
						else
						{
							MainTitle = GenericKilledByText @ PRI.LastToKillMePRI.PlayerName;
						}
					}
				}

				PRI = MyGearPC.GetSpectatingPRI();
			}
			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
			Canvas.StrLen(MainTitle, XL, YL);
			Canvas.SetPos((Canvas.ClipX - XL) * 0.5, YPos);
			Canvas.DrawText(MainTitle);

			YPos += 24.0;

			// get size of button icon
			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Xbox360_18pt);
			Canvas.StrLen("X", ButtonXL, YL);

			if (WorldInfo.GRI.IsMultiplayerGame())
			{
				// ghost cam label and button icon
				if (bInactiveGhostCamLabel)
				{
					Canvas.DrawColor = HudColors[eWARHUDCOLOR_WHITE] * 0.6;
					Canvas.DrawColor.A *= 0.6;
				}
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
				Canvas.StrLen(SpectateGhostLabel, XL, YL);
				GhostLabelXPos = Canvas.ClipX * 0.33 - (XL + ButtonXL * 2) * 0.5;
				Canvas.SetPos(GhostLabelXPos, YPos);
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Xbox360_18pt);
				Canvas.DrawText("X ", false);
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
				Canvas.DrawText(SpectateGhostLabel);
				`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], 255);

				// show/hide names label and button icon
				Canvas.StrLen((bShowNamesWhenSpectating ? SpectateHideNamesLabel : SpectateShowNamesLabel), XL, YL);
				ShowNamesXPos = Canvas.ClipX * 0.66 - (XL + ButtonXL * 2) * 0.5;
				Canvas.SetPos(ShowNamesXPos, YPos);
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Xbox360_18pt);
				Canvas.DrawText("A ", false);
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
				Canvas.DrawText((bShowNamesWhenSpectating ? SpectateHideNamesLabel : SpectateShowNamesLabel));

				// weapon selection options
				if (ShowDefaultWeaponSelector())
				{
					PRI = GearPRI(PlayerOwner.PlayerReplicationInfo);
					if (PRI != None)
					{
						YPos += 32.0;
						Canvas.SetPos(GhostLabelXPos, YPos);
						Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Xbox360_18pt);
						Canvas.DrawText("78 ", false);
						Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
						Canvas.DrawText(GetStartingWeaponName(PRI.InitialPrimaryWeaponType));

						Canvas.SetPos(ShowNamesXPos, YPos);
						Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Xbox360_18pt);
						Canvas.DrawText("96 ", false);
						Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
						Canvas.DrawText(GetStartingWeaponName(PRI.InitialSecondaryWeaponType));
					}
				}
			}
		}
	}
}

function CalculateDeadZone()
{
	local GameViewportClient VPClient;
	local bool bUseMaxSafeZone;
	local int LocalPlayerIndex;

	if (Owner == none)
	{
		`log("Owner isn't set to calculate DeadZone yet");
		return;
	}

	if (PlayerController(Owner).Player == none)
	{
		`log("Player isn't set to calculate DeadZone yet");
		return;
	}

	if (LocalPlayer(PlayerController(Owner).Player).ViewportClient == none)
	{
		`log("ViewportClient isn't set to calculate DeadZone yet");
		return;
	}

	if (Canvas == none)
	{
		`log("Canvas isn't set to calculate DeadZone yet");
		return;
	}

	// calculate the safezones and viewport centers
	VPClient = LocalPlayer(PlayerController(Owner).Player).ViewportClient;
	VPClient.UpdateActiveSplitscreenType();
	bUseMaxSafeZone = (VPClient.GetSplitscreenConfiguration() != eSST_None);

	// if no safe zone, zero all vars.
	if (!VPClient.CalculateDeadZoneForAllSides(LocalPlayer(PlayerController(Owner).Player), Canvas, SafeZoneTop, SafeZoneBottomFromViewport, SafeZoneLeft, SafeZoneRight, bUseMaxSafeZone))
	{
		SafeZoneTop = 0.f;
		SafeZoneBottomFromViewport =  0.f;
		SafeZoneLeft = 0.f;
		SafeZoneRight = 0.f;
	}
	else
	{
		LocalPlayerIndex = VPClient.ConvertLocalPlayerToGamePlayerIndex(LocalPlayer(PlayerController(Owner).Player));
		if (LocalPlayerIndex > 0)
		{
			SafeZoneTop += 3.0f;
		}
	}

	SafeZoneBottomFromViewport = SafeZoneBottomFromViewport + (bUseMaxSafeZone?5.f:0.f);
	SafeZoneBottom = SafeZoneBottomFromViewport;
	bRefreshSafeZone = false;
}

function AttemptHordeModOpen();

/**
 * Add a new HUD locator to the HUD
 *
 * @param LocatorType - The type of locator to create and add to the HUD
 * @param Subject - The actor the locator points to (GearPawn, Annex Ring, etc.)
 * @return if a locator was created, that locator, otherwise None
 */
simulated function GearHUDLocator AddHUDLocator(class<GearHUDLocator> LocatorType, Actor Subject)
{
	local GearHUDLocator NewLocator;

	// See if we can add the locator before creating it
	if (CanAddLocator(LocatorType, Subject))
	{
		// Create an instance of the locator
		NewLocator = new(self) LocatorType;
		// Initialize the locator
		if (NewLocator.InitializeLocator(Subject, self))
		{
			// Add the locator to the locator list
			HUDLocators.AddItem(NewLocator);
			// Sort the list for priority rendering
			HUDLocators.Sort(RateHUDLocatorSort);
		}
		else
		{
			NewLocator = None;
		}
	}

	return NewLocator;
}

/** Sorting delegate for sorting the HUDLocators array using the priorty */
final function int RateHUDLocatorSort(GearHUDLocator A, GearHUDLocator B)
{
	return (A.Priority > B.Priority) ? -1 : 0;
}

/**
 * Removes a HUD locator from the HUD
 *
 * @param Locator - The locator to remove
 */
function RemoveHUDLocator(GearHUDLocator Locator)
{
	HUDLocators.RemoveItem(Locator);
}

/**
 * Update the locators in the HUD, allowing them to draw to the canvas
 */
function UpdateHUDLocators()
{
	local int LocatorIdx;
	local GearHUDLocator NextLocatorForVis;
	local bool bUpdateTaccomLocators;
	local GearPC GearPlayerOwner;
	local vector CameraLoc;
	local rotator CameraRot;
	local bool bSpectating;

	GearPlayerOwner = GearPC(PlayerOwner);
	bSpectating = GearPlayerOwner.IsSpectating();

	// also update postrendered stuff
	GearPlayerOwner.GetPlayerViewPoint(CameraLoc, CameraRot);
	DrawActorOverlays(CameraLoc, CameraRot);

	// Iterate through the locators and allow them to update
	for (LocatorIdx = 0; LocatorIdx < HUDLocators.length; LocatorIdx++)
	{
		if (HUDLocators[LocatorIdx] != None && (GearPlayerOwner.bAssessMode ? HUDLocators[LocatorIdx].bUpdateInTacCom : HUDLocators[LocatorIdx].bUpdateOutsideOfTacCom) )
		{
			// Only draw certain locators while spectating
			if (!bSpectating || HUDLocators[LocatorIdx].bUpdateWhileSpectating)
			{
				HUDLocators[LocatorIdx].UpdateLocator();
			}

			// If the locator is marked for deletion, we must remove it and fix the array iterator
			if (HUDLocators[LocatorIdx].ShouldDeleteLocator())
			{
				//There is a special case...when a DBNO locator goes away, check to see if we need to immediately replace it with a taccom locator
				if (GearHUDLocator_DBNO(HUDLocators[LocatorIdx]) != None)
				{
					bUpdateTaccomLocators = true;
				}
				RemoveHUDLocator(HUDLocators[LocatorIdx]);
				LocatorIdx--;
			}
			else if ( NextLocatorForVis == None ||	NextLocatorForVis.TimeOfLastVisibilityCheck > HUDLocators[LocatorIdx].TimeOfLastVisibilityCheck )
			{
				// prioritize locator for visibility check
				NextLocatorForVis = HUDLocators[LocatorIdx];
		  	}
		}
	}

	// We may need to construct locators if someone just returned from being DBNO
	// We now show locators during coop splits even w/o being in taccom
	if (bUpdateTaccomLocators)
	{
		ConstructTaccomLocators();
	}

	// Do the vis check
	if ( (NextLocatorForVis != None) && (GearPlayerOwner.bAssessMode ? NextLocatorForVis.bUpdateInTacCom : NextLocatorForVis.bUpdateOutsideOfTacCom) )
	{
		NextLocatorForVis.UpdateSubjectVisibility();
	}
}

/**
 * Returns whether a locator can be added to the system
 *
 * @param LocatorType - The type of locator to be added
 * @param Subject - The object the locator will point to
 * @return - Whether this locator can be added or not
 */
simulated function bool CanAddLocator(class<GearHUDLocator> LocatorType, Object Subject)
{
	local bool Retval;

	Retval = true;

	if (LocatorType.default.bLocatorIsSubjectAndTypeUnique)
	{
		Retval = Retval && !HUDLocatorAtSubjectExists(Subject, LocatorType);
	}
	if (LocatorType.default.bLocatorIsSubjectUnique)
	{
		Retval = Retval && !HUDLocatorAtSubjectExists(Subject);
	}
	if (LocatorType.default.bLocatorIsTypeUnique)
	{
		Retval = Retval && !HUDLocatorOfTypeExists(LocatorType);
	}
	return Retval;
}

/**
 * Returns whether a locator exists which is pointing to a particular object
 *
 * @param Subject - The object in question
 * @param LocatorType - Optional parameter for a specific class of Locator. If not null, will only return true if a locator of this type exists on the subject specified.
 * @return - Whether a locator was found
 */
simulated function bool HUDLocatorAtSubjectExists(Object Subject, optional class<GearHUDLocator> LocatorType = None)
{
	local int LocatorIdx;

	// Make sure the subject isn't null
	if (Subject != None)
	{
		// Iterate through the locators
		for (LocatorIdx = 0; LocatorIdx < HUDLocators.length; LocatorIdx++)
		{
			// See if any of the locator subjects match the subject passed in
			if (HUDLocators[LocatorIdx] != None &&
				HUDLocators[LocatorIdx].LocatorSubject == Subject)
			{
				if (LocatorType == None || LocatorType == HUDLocators[LocatorIdx].Class)
				{
					return true;
				}
			}
		}
	}
	return false;
}

/**
 * Returns whether a locator exists of a particular type
 *
 * @param LocatorType - The type of locator in question
 * @return - Whether a locator was found
 */
simulated function bool HUDLocatorOfTypeExists(class<GearHUDLocator> LocatorType)
{
	local int LocatorIdx;

	// Iterate through the locators
	for (LocatorIdx = 0; LocatorIdx < HUDLocators.length; LocatorIdx++)
	{
		// See if any of the locator subjects match the subject passed in
		if (HUDLocators[LocatorIdx] != None &&
			HUDLocators[LocatorIdx].Class == LocatorType)
		{
			return true;
		}
	}
	return false;
}

/**
 * Returns whether a locator exists which is pointing to a particular object and
 *	of a particular type
 *
 * @param LocatorType - The type of locator to look for
 * @param Subject - The object in question
 * @return - Whether a locator was found
 */
simulated function bool HUDLocatorExists(class<GearHUDLocator> LocatorType, Object Subject)
{
	local int LocatorIdx;

	// Make sure the subject isn't null
	if (Subject != None)
	{
		// Iterate through the locators
		for (LocatorIdx = 0; LocatorIdx < HUDLocators.length; LocatorIdx++)
		{
			// See if any of the locator subjects match the subject passed in
			if (HUDLocators[LocatorIdx] != None &&
				HUDLocators[LocatorIdx].LocatorSubject == Subject &&
				HUDLocators[LocatorIdx].Class == LocatorType)
			{
				return true;
			}
		}
	}
	return false;
}

/** Turn the blind post process effect on (for berserker) */
exec function ToggleBlindEffects(bool bVal)
{
	// cache the reference if needed
	if (BlindEffect == None)
	{
		BlindEffect = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('BlindMode'));
		if (BlindEffect.Material.GetPackageName() != 'Transient')
		{
			// Create a MIC for this viewport
			BlindMIC = new(BlindEffect) class'MaterialInstanceConstant';
			BlindMIC.SetParent(BlindEffect.Material);
			BlindEffect.Material = BlindMIC;
		}
		else
		{
			BlindMIC = MaterialInstanceConstant(BlindEffect.Material);
		}
	}

	if (BlindEffect != None)
	{
		BlindEffect.bShowInGame = bVal;
	}
}

/** Returns whether the subject is in front of the camera and if so, will return the screen coords */
native final function bool GetScreenCoordsOfSubject(Canvas theCanvas, Vector SubjectLocation, out Vector ScreenCoords);

defaultproperties
{

	HitLocatorMaterial=Material'Warfare_HUD.HUD_DamageDir_Mat'
	ActiveReloadPulseMaterial=Material'Warfare_HUD.HUD.M_HUD_Throb'
	SuperSweetReloadPulseMaterial=Material'Warfare_HUD.HUD.M_HUD_Throb'

	WeaponInfoFrame=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=346,V=290,UL=163,VL=46)

	OmenMatInstRef=MaterialInstanceConstant'Effects_CameraOmen.Material.CameraOmen_INST';
	OmenSize=196.0

	DeathDataTime=5.5f
	DeathDataFadeTime=0.5f

	AmmoDataTime=5.5f
	AmmoDataFadeTime=0.5f
	LastWeaponInfoTime=-9999.f

	SquadBackgrounds(EASBT_Normal)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=398,V=397,UL=114,VL=114)
	SquadBackgrounds(EASBT_Dead)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=398,V=397,UL=114,VL=114)
	SquadBackgroundNamePlate=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=283,V=397,UL=114,VL=114)

	SquadDisplayData=(NameYFromCenter=8.f,OrderYFromCenter=23.f,HeadYFromTopOfBackground=6.f)

	AssessSquadCoords={(
		(Coords=((XFromTopRight=250,YFromTopRight=89),		// eSST_None
				 (XFromTopRight=139,YFromTopRight=197),
				 (XFromTopRight=84,YFromTopRight=337),
				 (XFromTopRight=139,YFromTopRight=478))),
		(Coords=((XFromTopRight=316,YFromTopRight=62),		// eSST_2P_HORIZONTAL
				 (XFromTopRight=204,YFromTopRight=89),
				 (XFromTopRight=105,YFromTopRight=141),
				 (XFromTopRight=55,YFromTopRight=232))),
		(Coords=((XFromTopRight=55,YFromTopRight=117),		// eSST_2P_VERTICAL
				 (XFromTopRight=55,YFromTopRight=220),
				 (XFromTopRight=55,YFromTopRight=323),
				 (XFromTopRight=55,YFromTopRight=426))),
		(Coords=((XFromTopRight=250,YFromTopRight=89),		// eSST_3P_FAVOR_TOP
				 (XFromTopRight=139,YFromTopRight=197),
				 (XFromTopRight=84,YFromTopRight=337),
				 (XFromTopRight=139,YFromTopRight=478))),
		(Coords=((XFromTopRight=250,YFromTopRight=89),		// eSST_3P_FAVOR_BOTTOM
				 (XFromTopRight=139,YFromTopRight=197),
				 (XFromTopRight=84,YFromTopRight=337),
				 (XFromTopRight=139,YFromTopRight=478))),
		(Coords=((XFromTopRight=250,YFromTopRight=89),		// eSST_4P
				 (XFromTopRight=139,YFromTopRight=197),
				 (XFromTopRight=84,YFromTopRight=337),
				 (XFromTopRight=139,YFromTopRight=478))),
	)}

	// @todo we need to support up to 7 places as omega man is 1 vs 7

	SquadStatusIcons(eSO_DEFENSIVE)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=158,V=152,UL=63,VL=32)
	SquadStatusIcons(eSO_ATTACK)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=158,V=119,UL=63,VL=32)
	SquadStatusIcons(eSO_DOWN)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=78,V=210,UL=42,VL=29)
	SquadStatusIcons(eSO_REVIVE)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=156,V=90,UL=38,VL=29)
	SquadStatusIcons(eSO_DEAD)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=156,V=2,UL=19,VL=26)

	SquadLocatorMaterial=Material'Warfare_HUD.HUD_LocationDir_Mat'

	PreviousFadeAlpha=0
	DesiredFadeAlpha=0
	FadeColor=(R=0,G=0,B=0)
	FadeAlphaDelay=0.f
	DesiredFadeAlphaTime=0.f
	FadeAlphaTime=0.f
//	bDrawSniperZoom=FALSE


	BloodIcons(0)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=108,V=290,UL=59,VL=59)
	BloodIcons(1)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=167,V=290,UL=59,VL=59);
	BloodIcons(2)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=226,V=290,UL=59,VL=59);
	BloodIcons(3)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=285,V=290,UL=59,VL=59);

	CountdownBgdIcon=(Texture=Texture2D'Warfare_HUD.HUD.Siege_Horde_TimerTokens',U=0,V=85,UL=115,VL=31)
	CountdownSize=(X=120.0,Y=34.0)

	DeadTaccomSplatMaterial=Material'Warfare_HUD.M_HUD_Taccom_Dead';
	ReviveTaccomIcon=(Texture=Texture2D'Warfare_HUD.HUD_Taccom_Revive',U=0,V=0,UL=256,VL=256)
	VoiceTaccomIcon=(Texture=Texture2D'Warfare_HUD.FrontEnd.UI_Party_Chatbubble', U=0, V=0, UL=64, VL=32)
	VoiceTaccomIconPos[0]=64.0f
	VoiceTaccomIconPos[1]=62.0f

	MaxRednessOfDeathScreen = 1.f
	WeaponInfoScale=1.f
	CurrSplitscreenType=eSST_None

	WeaponSelect=(TotalNumBlinks=2,TotalBlinkTime=0.25f)

	TotalCrosshairFadeTime=0.25f
	TotalTaccomFadeTime=0.25f
	TotalCoopPauseFadeTime=0.25f
	TotalWeaponFadeTime=0.25f

	CountdownEndTime=0.f

	ARBarData={(
		BackGround=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=260,V=478,UL=200,VL=12),
		Flash=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=260,V=448,UL=200,VL=10),
		TickMark=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=447,V=406,UL=16,VL=33),
		SuccessRegion=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=442,V=386,UL=3,VL=6),
		PerfectGrade=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=450,V=387,UL=8,VL=16),
		GoodGrade=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=261,V=461,UL=96,VL=12),
		FlashDuration=1.0f,
		FadeDuration=0.5f,
	)}

	Begin Object Class=AudioComponent Name=TacComComp
	   SoundCue=SoundCue'Interface_Audio.Interface.TaccomLoopCue'
	End Object
	TacComLoop=TacComComp
	Components.Add(TacComComp);

	CountdownTotalFadeInTime=0.5f
	CountdownTotalFadeOutTime=1.0f
	NumSquadLocators=5

	LeaderIcon=(Texture=Texture2D'Warfare_HUD.HUD.UI_HUD_Leader',U=0,V=0,UL=32,VL=32)
	BuddyIconCOG=(Texture=Texture2D'Warfare_HUD.UI_HUD_WMCog',U=0,V=0,UL=64,VL=32)
	BuddyIconLocust=(Texture=Texture2D'Warfare_HUD.UI_HUD_WMLocust',U=0,V=0,UL=64,VL=32)

	bShowNamesWhenSpectating=true

	MortarCrosshairTickIcon=(Texture=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Mortar_Tick',U=0,V=0,UL=128,VL=16)
	MortarCrosshairSaveIcon=(Texture=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Mortar_SavePoint',U=0,V=0,UL=128,VL=16)

	OutOfAmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=156,V=233,UL=34,VL=56)
	OutOfAmmoIcon2=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=411,V=342,UL=49,VL=49)

	TimeOfLastCheckpoint=-1
	MinTimeBeforeFadeForCheckpoint=1.0f
	FadeTimeForCheckpoint=1.0f

	RevivedIcon=(Texture=Texture2D'Warfare_HUD.ScoreBoard.UI_MP_Icons',U=55,V=0,UL=25,VL=26)

	XButtonIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32)
	YButtonIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=335,UL=35,VL=43)
	AButtonIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43)
	BButtonIcon=(Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=0,UL=45,VL=32)

	CoopMenuFadeRate=6.0f

	MaxHUDMessages=6
	MaxPriorityHUDMessages=2

	PriorityHUDMessageYOffset=0

	HudColors[eWARHUDCOLOR_WHITE]=(R=240,G=240,B=240,A=255)
	HudColors[eWARHUDCOLOR_RED]=(R=170,G=0,B=0,A=255)
	HudColors[eWARHUDCOLOR_YELLOW]=(R=170,G=144,B=0,A=255)
	HudColors[eWARHUDCOLOR_BLACK]=(R=0,G=0,B=0,A=255)
	HudColors[eWARHUDCOLOR_WHITE_DK]=(R=200,G=200,B=200,A=255)
	HudColors[eWARHUDCOLOR_TEAMRED]=(R=205,G=22,B=22,A=255)
	HudColors[eWARHUDCOLOR_TEAMBLUE]=(R=139,G=255,B=255,A=255)
	HudColors[eWARHUDCOLOR_CHATICONRED]=(R=164,G=63,B=63,A=255)
	HudColors[eWARHUDCOLOR_CHATICONBLUE]=(R=170,G=192,B=205,A=255)
	HudColors[eWARHUDCOLOR_PLAYERONE]=(R=255,G=232,B=136,A=255)
	HudColors[eWARHUDCOLOR_PLAYERTWO]=(R=255,G=153,B=91,A=255)

	ReticlePlusBlinkTime=0.15f

	TacComPPEffectName=TacCom

	KillPointsDest=(X=0.5,Y=0.625)
	KillPointsFadeTime=1.25
	KillPointsTime=0.75

	Text_ClipShadowed=(bClipText=true,bEnableShadow=true)
	Text_NoClipShadowed=(bClipText=false,bEnableShadow=true)

	SpectateBackgroundIcon=(Texture=Texture2D'Warfare_HUD.ScoreBoard.UI_Spectator_Bar',U=0,V=0,UL=1024,VL=512)
	SpectatePlayersIcon=(Texture=Texture2D'Warfare_HUD.ScoreBoard.UI_MP_Icons',U=187,V=27,UL=43,VL=43)
	SpectateBattleCamIcon=(Texture=Texture2D'Warfare_HUD.ScoreBoard.UI_MP_Icons',U=142,V=27,UL=43,VL=43)

	FriendlyCrosshair=Texture2D'Warfare_HUD.HUD_FriendlyXHair'

	BleedOutPPSettings={(
		bEnableBloom=TRUE,
		bEnableDOF=TRUE,
		bEnableSceneEffect=TRUE,

		Bloom_Scale = 1.0f,

		DOF_BlurKernelSize = 5.0f,
		DOF_FalloffExponent = 1.0f,
		DOF_FocusDistance = 0.0f,
		DOF_FocusInnerRadius = 0.0f,
		DOF_FocusPosition = (X=0,Y=0,Z=0),
		DOF_FocusType = FOCUS_Distance,
		DOF_MaxFarBlurAmount = 0.7f,
		DOF_MaxNearBlurAmount = 0.7f,

		Scene_Desaturation = 0.0f,
		Scene_HighLights = ( X=0.5f, Y=1.0f, Z=1.0f ),
		Scene_MidTones = ( X=1.f, Y=3.5f, Z=3.5f ),
		Scene_Shadows = ( X=0.005f, Y=0.005f, Z=0.005f ),
	)}
}
