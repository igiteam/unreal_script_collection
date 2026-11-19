//=============================================================================
// ExamplePlayerController
// Example specific playercontroller
// PlayerControllers are used by human players to control pawns.
//
// Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
//=============================================================================
//class TPPlayerController extends GamePlayerController
class TPPlayerController extends KynapseGamePlayerController
	native
	dependson(GrappleInteraction)
	dependson(AnimNotify_ComboButton)
	dependson(TPPawn)
	dependson(TPAchievements)
	config(Game);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// Constants for Presence

// HACK, this is duplicated int TPGameReplicationInfo.uc.
// If you change this, change that!
const GAME_MODE									= 0x0000800B;
const NOT_PLAYING_PRESENCE						= 0;
const MULTIPLAYER_TDM_PRESENCE					= 1;
const MULTIPLAYER_DM_PRESENCE					= 2;
const MENUS_PRESENCE							= 3;
const SINGLEPLAYER_PRESENCE						= 4;

// Constants for Contexts
const CONTEXT_SPMAPNAME							= 3;
const CONTEXT_SPDIFFICULTY						= 4;

// Multiplayer Map Name Context
// HACK, this is duplicated int TPGameReplicationInfo.uc.
// If you change this, change that!
const CONTEXT_MAPNAME							= 1;

// SystemLink or XBOX Live, I hate that we have to do this.
const CONTEXT_MPGAMETYPE						= 5;

const CONTEXT_GAMESTATUS						= 6;

const IN_GAME									= 0;
const IN_LOBBY									= 1;

const GRENADE_TIME_UP							= 0.2;

enum eSPMapContext
{
	SPMAPNAME_NYSS,
	SPMAPNAME_NYBR,
	SPMAPNAME_NYES,
	SPMAPNAME_DCRD,
	SPMAPNAME_DCWH,
	SPMAPNAME_UKTL,
	SPMAPNAME_UKBR,
	SPMAPNAME_UKZP
};

enum eSPDifficultyContext
{
	SPDIFFICULY_NORMAL,
	SPDIFFICULY_HARD,
	SPDIFFICULTY_EASY,
	SPDIFFICULY_INSANE
};

var int numEmittersOnScreen;
var int numEmittersInMemory;

var bool bSPMapNameDirty;
var String LastTravelURL;

var UIScene curDialogScene;

struct native TCharacterInfo
{
	var string CharacterClass;
	var string DisplayName;
	var int TeamID;
};

enum eTeam
{
	T_PARTISAN,
	T_NAZI,
};

enum ePlayerClassType
{
	PCT_ASSAULT,
	PCT_SNIPER,
	PCT_SUPPORT,
	PCT_ANTITANK,
	PCT_RIFLEMAN,
	PCT_MEDIC,
};

/** List of all interactable triggers, for rendering purposes */
struct native InteractableInfo
{
	var Trigger InteractTrigger;
	var bool bUsuable;
	var SeqEvent_Used Event;
};
var transient array<InteractableInfo> InteractableList;

/** Currently highlighted interactable */
var	InteractableInfo	HighlightedInteractable;

// Multiplayer Informational Data
var int CharacterIndex;

// The default weapons and character meshes for each type of multiplayer game / team combination
struct native ConnectionInfo
{
	var int	AxisMesh, AxisWeap;
	var int AllyMesh, AllyWeap;
	var int DMMesh,   DMWeap;
};

var repnotify bool bDontNotifyClientPickup;	// Terrible name, but if its true you DO NOT notify the client to toggle his pickup message, false = Notify

var ConnectionInfo connectInfo;


struct native SpawnStruct
{
	var float score;
	var vector location;
	var bool isSpawned;
};

struct native SoundDuckingStruct
{
	var name  channelName;
	var float iniLevel;
	var float defLevel;
	var float curLevel;
	var float duckLevel;
	var bool  isSlave;
	var bool  isMaster;		// A soundgroup or "channel" can be a slave, master, or neither, but not both.
	var bool  wasIndividuallyDucked;
	var bool  isPlayingSound;
};

struct native SlaveChannel
{
	var name  channelName;
	var int   soundGroupID;
	var float duckingFactor;
};

struct native MasterSoundChannel
{
	var int					soundgroupID;
	var int					tier;
	var float				masterDuckingFactor;
	var float				slaveDuckingFactor;
	var array<SlaveChannel> individualDuckingFactor;
};

struct native NetPerformanceMonitor
{
	var int					numFrames;
	var float				deltaTime;
	var float				FPS;
};

var NetPerformanceMonitor		netPerformance;

// Change to dynamic array
var array<SpawnStruct> spawnHolder;

var array<SoundDuckingStruct>	soundDucking;
var array<MasterSoundChannel>	masterSoundChannels;	// Not MASTER as mentioned in INI, but Sounds that when active duck other sound groups
var int							activeMasterID;			// -1 if no master is active
var                 bool                                        bThirdPersonRefocus;
var                 bool                                        bCamTransition;
var                 float                                       FOVStart;
var                 bool                                        bSmoothFOV;
var                 bool                                        bFOVUp;
var                 float                                       FOVRate;
var                 bool                                        bAllowUpdateRotation;
var                 bool                                        bPendingFire;
var repnotify       bool                                        bTargettingFriendly;
var					float										pickupTime;	// Players can only pickup weapons once a second to prevent spam.
var					bool										bAllowGrenadeUse;
var					bool										bUnlimitedGrenadeMode;

//var                 AnimNodeAimOffset                           anode_AIM;
//var                 AnimNodeAimOffset                           anode_AIM_FPS;
var                 AnimNodeScalePlayRate                       anode_WalkRate;
var                 TPAnimBlendBySpeed                          anode_speedBlend;
var                 SkelControlLookAt                           skel_HeadTrack;
var	                AnimNodeBlend                               anode_WeaponBlend;
var                 AnimNodeBlend                               anode_CrouchWeaponBlend;
var                 AnimNodeBlend                               anode_PostureBlend;
var                 AnimNodeBlend                               anode_HangBlend;

var                 SkelControlLookAt                           skel_GunAim;

var					TPSkelControlPlayerPitch					skel_SpinePitch;
var					TPSkelControlPlayerRoll						skel_SpineRoll;

var private bool			bWasAimingDownSight;


var                 float           WalkLoopDistance;
var                 float           RunLoopDistance;
var                 float           SprintLoopDistance;

var bool						m_bCamper;
var bool						m_bGranny;
var bool						m_bPendingTransition;

var float CrouchBlendTime;

var bool bSprint;
var transient bool PreventedFromSprinting;
var float CurrSprintTime;
var transient bool WantsToClimb;
var float PlayerStaminaTime;
var float MaxPlayerStamina;

var		float timeRemaining;
var		float timeElapsed;
var		float timeOrig;  // Currently Unused.

// Camper Variables
const	MIN_PLAYER_MOVE_DIST_SQ	= 1.0;
const	CAMP_RADIUS_SQ			= 90000.0;

var		float	TimeSinceLastMove;
var		vector	LastPlayerPos;
var()	float	CampTime;

var() MultiplayerGameState mpGameState;

/** Channel the player is associated with regardless of their state */
var int VoiceChannel;

var name OldCameraStyle;

// Bluff vars

var BluffInteraction BluffInt;
var TPPawn BluffOpponent;
var BluffPerformance CurrentBluffPerformance;
var int bluffAttempts;

//var TPWehrmachtAIController BluffOpponentController; //what to do when we interact w/different enemy types


// Grapple vars




var GrappleInteraction GrapInt;
var TPPawn             GrappleOpponent;
var GrapplePerformance CurrentGrapplePerformance;
var eGrappleAction     eGrappleAction;
var config bool        bUseGrappleCam;

var bool				m_bIsGrappling;

var ObjectiveInteraction  ObjInt;
var TPShellInteraction    TPShellInt;
var CheatMenuInteraction  CheatMenuInt;
var GrappleInteraction_v2 GrapInt_v2;
//var TPMPGameInteraction   MPInteraction;






var name PrevMusicTrack;

var bool bAllowClientMessages;

var bool bIsThirdPerson;
var bool bClampView;
var bool bKismetClampView;

var EObstacle        Obstacle;
var transient vector ShimmyDirection;
var transient vector LastHitWallNormal;
var transient vector ShimmyLoc;
var transient float  JumpDistance;
var transient float  JumpDuration;
var transient float  ShimmyManualDistance;
var transient float  TotalTime;
var transient bool   bHittingWall;
var transient bool   bHitWallPressedJump;
var bool             bSnapWall;
var bool             bUsingWalledShimmy;
var config float     PickupDistance;
var config float	 LookAtPickupDistance;
var float            Temp1;
var float            OrigZ;
var config float     AimHelpAngle;
var config float	 ThirdPersonFOV;
var config float	 CrouchFOV;
var bool             bDontRotatePawn;
var bool             bDontUseAimOffset;
var bool             bHasPrevLadderAction;
var bool             bPipeRight;

var TPWeapon         LastWeapon; // Used for human shield

var config float     GrappleRadius;

var TPBeamMovementVolume      CurrentBeamVolume;
var TPBeamTransitionVolume    CurrentBeamTVolume;

var TPPipeVolume              CurrentPipeVolume;

// Button that the player can use
//var UseButton	UseButton;

var Bool			bWasPlayerDead;

var TPDefendAreaVolume m_RestrictedAreaVolume;

// Leaning Variables
enum eLeanDirection
{
	No_Lean,
	Left_Lean,
	Right_Lean,
};

enum EDisconnectionScreenType
{
	FRONTEND_MENU,
	MESSAGEBOX_MENU,
	FRONTEND_INGAME,
	MESSAGEBOX_INGAME,
};


var eLeanDirection LeanDirection;
var float LeanAmount;
var rotator PrevRotation;
var config float MaxLeanPitchAngle;
var config float MaxLeanYawAngle;
var HeadCylinder HeadCollisionCylinder;		// Used when player is leaning

// Fast Throw Grenade Variable
var bool bThrowGrenade;
var Weapon PrevWeaponOnGrenade;

// Input button for switching current weapon or reloading
var input byte bReload;
var config float SwitchWeaponTime;	// Time to say we are switching Fire Types instead of just reloading
var float ReloadButtonHeldTime;
var bool bReloadGrabbedWeapon;

var bool bDisableJumpButton;

/** view shaking that is currently being applied */
var ShakeInfo CurrentViewShake;
/** current offsets applied to the camera due to CurrentViewShake */
var vector ShakeOffset; // current magnitude to offset camera position from shake
var rotator ShakeRot; // current magnitude to offset camera rotation from shake

var TPPawn LastAimTarget;
var float  LastBestDist;




var bool			 bGogglesEnabled;
var MaterialEffect	 GoggleEffect;
var bool			 bAllowGoggles;

var bool			bFontTest;
var bool			bSpawnTest;
var bool			bSoundTest;
var bool			bLoadoutTest;

var Actor	pointOfInterest;			//	The thing we want to look at when we press the Y button a la GOW
var bool	lookingAtPointOfInterest;	//	Are we looking at pointOfInterest because user is pushing the button?

var TPProfileSettings ProfileSettings;

var TPPlayerAchievements Achievements;

// The loadout to use to fill out the weaponry when restarting from a checkpoint
struct native CheckpointLoadout
{
	var string WeaponName[4];
	var int AmmoInMagazine[4];
	var int AmmoCount[4];
	var int SelectedWeapon;
	var bool bIsValid;
};

var bool				bInFrontEnd;

// Checkpoint var.s
var TPCheckpointManager	TPCM;
var Bool				bShouldCheckPointTeleport;

var CheckpointLoadout	CKP_Loadout;
var SoundCue			LoadCheckpointCue;

var UIScene				TutorialScene;
var UIScene				PauseMenuScene;
var UIScene				PauseMenuMPScene;
var UIScene				VictoryScene;
var UIScene				IntelPickupScene;
var UIScene				ConfirmResolutionScene;
//var UIScene				DeviceChangedScene;
//var UIScene				TPGameOver;

// Gameover-related stuff
var Float				GameOverTimerDelay;
var UIScene				GameOverScene;
var UIScene				OpenedUISceneGameOver;
var AudioComponent		GameOverLoop;
var SoundCue			OpenGameOverCue;

// Character Info Stuff for MP
var config array<TCharacterInfo> Characters;
var array<TCharacterInfo> PartisanList;
var array<TCharacterInfo> NaziList;

var string HostedMapName;

var vector	DebugCamPos;
var rotator DebugCamRot;
var	vector	DebugCamVelocity;
var vector  DebugCamAcceleration;

var string  TutorialMarkup;

// Bonus info
var TPBonus	bonusInfo;

/** Holds a ref to the online stats read object */
var TPGameStatsRead StatsRead;
var TPGameStatsWrite StatsWrite;
var bool bUsesArbitration;
var bool bInvitedToGame;
var bool bQuitOnlineGame;

var UIScene myHUDUIScene;
var UIScene_TPHUD HUDTemplate;
var config bool bUseNewHUD;

// Scoreboard Information
var UIScene ScoreboardScene;
var UIScene_BaseScoreboard ScoreboardSceneDMTemplate;
var UIScene_BaseScoreboard ScoreboardSceneTeamDMTemplate;

var UIScene myNonWeaponUIScene;
var UIScene_TPNonWeaponHUD NonWeaponHUDTemplate;

var UIScene TeamLobby, DMLobby, MPCharacterScene;
var bool bLanMatch;
var bool bIgnoreCloseNotify;

// Latent play movie stuff

var SeqAct_PlayMovieLatent m_LatentMovieAction;
var bool m_bWaitingForLatentMovieToFinish;


// Objective stuff
struct native ObjectiveInfo
{
	/** Name of objective for scripting purposes */
	var() Name ObjectiveName;
	/** Objective description to draw on the HUD */
	var() string ObjectiveMarkup;
	/** Is this objective completed? */
	var() bool bCompleted;
	/** Time at which this objective was received */
	var() float ReceiptTime;
	/** Time at which this objective was completed */
	var() float CompletedTime;
};

/** List of current player objectives */
var array<ObjectiveInfo> Objectives;

var bool bLocalCacheOfProfileUpdated;


var private Pawn MyLastHitPawn; //this is private so we have to go through the setter func to set it

/** Whether TargetAdhesion is enabled or not **/
var() config bool bTargetAdhesionEnabled;

var Actor CachedCrosshairActor;
var float LineCheckTime;

var config bool bIsDemoMode;
var config bool bEnableCheats;
var config bool bIsPreview;

var bool bCommitMapChangePending;

var bool bLoginWarningInProgress;

var float LastWriteProfileTime;

var bool bAllowUIInput;



var bool bControllerAssigned;
var bool bAssignedControllerDisconnected;
var int DisconnectedAssignedController;
var int bControllersConnectionStatus[7];

var bool bSystemPauseRequested; // Whether the system has requested a pause or not.
var bool bGamePausedBySystemRequest; // Indicates that the game was paused due to system request
var qword ShowFlagsBeforeSystemPause; // The viewport showflags before we paused the system

var bool bPauseRequested;


var bool bLoginChanged;

var UIScene WriteProfileScene;

native function bool GetPostProcessSettings(out PostProcessSettings OutPostProcessSettings);
native function bool ClearPathTo(Pawn ToGuy);
native function TPTuneManagerBase GetActiveTuneManager();
native function SetActiveTuneManager( TPTuneManagerBase theTuneManager );
native function BOOL IsEditorActive();
function bool BreakOutEligible();
function OnForceHumanShieldDeath(SeqAct_ForceHumanShieldDeath action);

native function bool IsSoftened();
native function ShowControllerDisconnectMsg(int InControllerID);
native function HideControllerDisconnectMsg();
native function EnableUI();
native function DisableUI();
native function SetViewportPauseShowFlags();
native function RestoreViewportShowFlags();
native function int GetParticleAvailableMemory();

static native function bool CanSpawnAtLocation(out vector ChkLocation, vector ChkExtent, Actor SpawnPointActor );

/** called by the server checkpoint loading code to tell the client to load/unload the levels required for the checkpoint with the passed in info */
reliable client native final event ClientProcessCheckpointLevels(string CheckpointPackageName, string PersistentLevelName, string CheckpointPathname);

native function ResetMovement();

native function Actor GetCrosshairTarget();

native function GetStoreDifficulty(out int difficulty, bool store);

native function bool DeathCamCollisionNoHit(Vector startLoc, Vector endLoc);
native function bool GrenadeHandCollisionNoHit(Vector startLoc, Vector endLoc);


native final function String GetNextSublevel();

native function SelectScreenRes(int num, bool fullScreen);
native function GetResolutionStrings(out array<string> ResolutionNames);
native function RevertScreenRes();

native function UpdateProfile();

replication
{
	// bDontNotifyClientPickup acts as a notify toggle for bPickup
	if (bNetDirty && Role == ROLE_Authority)
		bDontNotifyClientPickup;
}

simulated function LCDManager GetLCDManager()
{
	return TPGameViewportClient(LocalPlayer(Player).ViewportClient).LCDManager;
}

reliable client event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime  )
{
	local bool bIsUserCreated;

	if ( myHUD != None )
	{
		myHUD.Message( PRI, S, Type, MsgLifeTime );
	}

	if ( ((Type == 'Say') || (Type == 'TeamSay')) && (PRI != None) )
	{
		S = "<Fonts:EngineFonts.MediumFont>"$PRI.PlayerName$": "$S$"<Fonts:/>";
		bIsUserCreated = true;	// This came from a user so flag as user created
	}

	// since this is on the client, we can assume that if Player exists, it is a LocalPlayer
	if (Player != None)
	{
		// Don't allow this if the parental controls block it
		if (!bIsUserCreated || (bIsUserCreated && CanViewUserCreatedContent()) )
		{
			LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText(S);
		}
	}

}


function KMSKOnMessageBoxClose(int PlayerIndex, bool bReturnValue)
{
	;
	;
	;

}

exec function KMSKDisconnectTest( int disNum )
{
	switch ( disNum )
	{
		case 0:
			SetDisconnectionError(FRONTEND_MENU);
			DestroyOnlineSession();
			ConsoleCommand("Disconnect");
			break;
		case 1:
			SetDisconnectionError(MESSAGEBOX_MENU, false, KMSKOnMessageBoxClose);
			break;
		case 2:
			SetDisconnectionError(FRONTEND_INGAME);
			DestroyOnlineSession();
			ConsoleCommand("Disconnect");
			break;
		case 3:
			SetDisconnectionError(MESSAGEBOX_INGAME, true, KMSKOnMessageBoxClose);
			break;
	}
}

simulated function SetDisconnectionError( EDisconnectionScreenType seType, optional bool bTestForEthernet = false, optional delegate<OnMessageBoxClose> OnCloseDelegate )
{
	local string error_title, error_message;
	local bool isXbox;

	/*	seTypes:
			FRONTEND_MENU,
			MESSAGEBOX_MENU,
			FRONTEND_INGAME,
			MESSAGEBOX_INGAME,
	*/

	;
	isXbox	= WorldInfo.IsConsoleBuild(CONSOLE_Xbox360);

	// Handle Ethernet Errors Only on Consoles
	if ( bTestForEthernet && WorldInfo.IsConsoleBuild() && !OnlineSub.SystemInterface.HasLinkConnection())
	{
		if ( isXbox )
		{
			error_title		= Localize("NetworkMessages", "EthernetDisconnectedTitle", "TPGame");
			error_message	= Localize("NetworkMessages", "EthernetDisconnectedMessage", "TPGame");
		}
		else // WorldInfo.IsConsoleBuild(CONSOLE_PS3); // PC does not have ethernet disconnection detection in UnrealEngine3
		{
			error_title		= Localize("NetworkMessages", "LostConnectionFromHostTitle", "TPGame");
			error_message	= Localize("NetworkMessages", "PSNEthernetDisconnectedMessage", "TPGame");
		}	
	}
	else
	{
		// If this happened while in the menu
		if ( seType == FRONTEND_MENU || seType == MESSAGEBOX_MENU )
		{
			error_title		= Localize("NetworkMessages", "LostConnectionFromHostTitle", "TPGame");

			if ( isXbox )
				error_message	= Localize("NetworkMessages", "X360LostConnectionFromHostMessage", "TPGame");
			else
				error_message	= Localize("NetworkMessages", "LostConnectionFromHostMessage", "TPGame");
		}

		// If this happened while in-game
		else // ( seType == FRONTEND_INGAME || seType == MESSAGEBOX_INGAME )
		{
			error_title		= Localize("NetworkMessages", "DisconnectedTitle", "TPGame");

			if ( isXbox )
				error_message	= Localize("NetworkMessages", "X360DisconnectedMessage", "TPGame");
			else
				error_message	= Localize("NetworkMessages", "DisconnectedMessage", "TPGame");
		}

	}

	// Display this message using a dialog box
	if ( seType == MESSAGEBOX_MENU || seType == MESSAGEBOX_INGAME )
	{
		// function DisplayMessageBox(string Message, optional string Title = "", optional bool bSimpleMode = false)
		DisplayMessageBox( error_message, error_title, true, OnCloseDelegate );
	}

	// Display this message through the FrontEnd
	else // ( seType == FRONTEND_MENU || seType == FRONTEND_INGAME )
	{
		// function SetFrontEndErrorMessage(string Title, string Message, optional bool bWasOnline = false, ... , ...)
		SetFrontEndErrorMessage( error_title, error_message, true);
	}

}

//exec function GetMapList()
//{
//	local DataStoreClient DataStoreManager;
//	local UIDataStore_TPGameSettings TPGameSettings;
//
//	DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
//	if ( DataStoreManager != None )
//	{
//		// now create the Turning Point data store
//		TPGameSettings = UIDataStore_TPGameSettings(DataStoreManager.FindDataStore('TPGameSettings',none));
//		if ( TPGameSettings != None )
//		{
//			//TPGameSettings.MapList = TPGameInfo(WorldInfo.Game).GetAllMasterMaps();
//		}
//	}
//}

simulated event ReplicatedEvent( name varName )
{
	if ( varName == 'bDontNotifyClientPickup' )
	{
		// bDontNotifyClientPickup acts as a notify toggle for bPickup
		TPHud(myHud).bPickup	= bDontNotifyClientPickup;
		bDontNotifyClientPickup = true;
	}
	else
	{
		Super.ReplicatedEvent(varName);
	}

}

// Handler for leaving an Xbox blade
function TPOnExternalUIChanged(bool bIsOpening)
{
	if (bLoginChanged && !bIsOpening)
	{
		bLoginChanged = false;
		UpdateProfile();
	}
}

event InitInputSystem()
{
	local int i;
	Super.InitInputSystem();

	if (OnlineSub != None)
	{
		// Register for accepting game invites for other controllers if possible
		if (OnlineSub.GameInterface != None && LocalPlayer(Player) != None)
		{
			for (i = 0; i < 4; i++)
			{
				// Check to see if we are not the main controller cause the super already adds this delegate
				if (LocalPlayer(Player).ControllerId != i) 
					OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(i,OnGameInviteAccepted);
			}
		}
	}

	// Registers online delegates for when the player changes their live status.
	RegisterOnlineDelegates();

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	// If there is an online subsystem, add our callback for UI changes
	if (OnlineSub != None)
	{
		VoiceInterface = OnlineSub.VoiceInterface;
		if (OnlineSub.SystemInterface != None)
		{
			OnlineSub.SystemInterface.AddExternalUIChangeDelegate(TPOnExternalUIChanged);
		}

		UpdateControllerConnectionStatus();
	}
}

function bool IsInShellLevel()
{
	return class'UIInteraction'.static.IsMenuLevel();
}

simulated event Destroyed()
{
	local int i;

	// If this is a deathmatch
	if (Role == ROLE_Authority)
	{
		// Does this player leaving effetively end a match
		// DM ) Only one player is left
		// TDM ) Only one team has players left
		if ( WorldInfo.GRI.GameClass.default.bTeamGame )
		{
			TPMultiplayerGameTeamDMInfo(WorldInfo.Game).HandleDisconnect(PlayerReplicationInfo.PlayerID);
		}
		else
		{
			TPMultiplayerGameInfo(WorldInfo.Game).HandleDisconnect(PlayerReplicationInfo.PlayerID);
		}

	}

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	// If there is an online subsystem, clear our callback for UI changes
	if (OnlineSub != None)
	{
		OnlineSub.SystemInterface.ClearExternalUIChangeDelegate(TPOnExternalUIChanged);

		// Cleanup game invite delegate
		if (OnlineSub.GameInterface != None && LocalPlayer(Player) != None)
		{
			for (i = 0; i < 4; i++)
				OnlineSub.GameInterface.ClearGameInviteAcceptedDelegate(i,OnGameInviteAccepted);
		}
	}
	
	ClearOnlineDelegates();
	Super.Destroyed();
}

exec function ChangeTeam( string TeamName )
{
	local int N;

	if ( TeamName ~= "us" )
		N = 0;
	else if ( TeamName ~= "them" )
		N = 1;

	ServerChangeTeam(N);
}

// Tell the server we have changed our default loadouts
reliable server function ServerChangeConnectionInfo(int AxisMesh, int AxisWeap, int AllyMesh, int AllyWeap, int DMMesh, int DMWeap)
{
	connectInfo.AxisMesh	= AxisMesh;
	connectInfo.AxisWeap	= AxisWeap;
	connectInfo.AllyMesh	= AllyMesh;
	connectInfo.AllyWeap	= AllyWeap;
	connectInfo.DMMesh		= DMMesh;
	connectInfo.DMWeap		= DMWeap;
}

// Tell the client we have received our default loadouts, store them for possible future modification in lobby
reliable client function ClientUpdateConnectionInfo(int AxisMesh, int AxisWeap, int AllyMesh, int AllyWeap, int DMMesh, int DMWeap)
{
	connectInfo.AxisMesh	= AxisMesh;
	connectInfo.AxisWeap	= AxisWeap;
	connectInfo.AllyMesh	= AllyMesh;
	connectInfo.AllyWeap	= AllyWeap;
	connectInfo.DMMesh		= DMMesh;
	connectInfo.DMWeap		= DMWeap;
}

reliable server function ServerChangeCharacterClass(TCharacterInfo CInfo)
{
	TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = CInfo;
}

reliable server function SetHostedMapName(string MapName)
{
	HostedMapName = MapName;
}

final function OnGetCharacterName(UIAction_GetCharacterName Action)
{
	if (int(GetDefaultURL("team")) == T_PARTISAN)
	{
		CharacterIndex = int(GetDefaultURL("AllyMesh"));
		TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = PartisanList[CharacterIndex];
	}
	else
	{
		CharacterIndex = int(GetDefaultURL("AxisMesh"));
		TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = NaziList[CharacterIndex];
	}

	Action.CurrentCharacter = TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo.DisplayName;
}

final function OnGetTeamID(UIAction_GetTeamID Action)
{
	Action.CurrentTeam = Pawn.PlayerReplicationInfo.Team.TeamIndex;
	if (Action.TeamImage != none)
	{
		if (Action.CurrentTeam == T_PARTISAN)
		{
			Action.TeamImage.SetValue(TPPlayerReplicationInfo(Pawn.PlayerReplicationInfo).AlliedImage);
		}
        else
		{
			Action.TeamImage.SetValue(TPPlayerReplicationInfo(Pawn.PlayerReplicationInfo).AxisImage);
		}
	}
}

//final function OnCycleMPAttributes(UIAction_CycleMPAttributes Action)
//{
//	`log(Action.InputLinks[0].bHasImpulse);
//	`log(Action.InputLinks[1].bHasImpulse);
//	`log(Action.InputLinks[2].bHasImpulse);
//}
//
//final function OnCyclePlayerMesh(UIAction_CyclePlayerMesh Action)
//{
//}

//final function OnServerTravel(UIAction_ServerTravel Action)
//{
//	//local string URL;
////	local string PlayerName;
//
////	PlayerName = "Player";
//	if ( Action != None && Action.GetOwner().GetPlayerOwner().Actor == self)
//	{
//		//if (OnlineSub != None)
//		//{
//		//	PlayerName = OnlineSub.PlayerInterface.GetPlayerNickname(0);
//		//}
//
//		if (WorldInfo.IsConsoleBuild())
//			CreateOnlineSession();
//		else
//			CreateLanSession();
//
//		if (int(GetDefaultURL("team")) == T_PARTISAN)
//		{
//			CharacterIndex = int(GetDefaultURL("AllyMesh"));
//			TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = PartisanList[CharacterIndex];
//		}
//		else
//		{
//			CharacterIndex = int(GetDefaultURL("AxisMesh"));
//			TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = NaziList[CharacterIndex];
//		}
//
//		HostedMapName = Action.MapName$"?Team="$Pawn.PlayerReplicationInfo.Team.TeamIndex;
//		`log(HostedMapName);
//	}
//}

final function OnChangeTeam(UIAction_ChangeTeam Action)
{
	if ( Action != None && Action.GetOwner().GetPlayerOwner().Actor == self)
	{
		if (WorldInfo.NetMode != NM_Standalone)
		{
			if (Pawn.PlayerReplicationInfo.Team.TeamIndex == 1)
			{
				CharacterIndex = int(GetDefaultURL("AllyMesh"));
				TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = PartisanList[CharacterIndex];
				ServerChangeCharacterClass(TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo);
				ChangeTeam("us");
			}
			else
			{
				CharacterIndex = int(GetDefaultURL("AxisMesh"));
				TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = NaziList[CharacterIndex];
				ServerChangeCharacterClass(TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo);
				ChangeTeam("them");
			}
		}
		else
		{
			if (Action.CurrentTeamImage != none)
			{
				if (Pawn.PlayerReplicationInfo.Team.TeamIndex == T_PARTISAN)
				{
					Pawn.PlayerReplicationInfo.Team.TeamIndex = T_NAZI;
					CharacterIndex = int(GetDefaultURL("AxisMesh"));
					TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = NaziList[CharacterIndex];
					Action.CurrentTeamImage.SetValue(TPPlayerReplicationInfo(Pawn.PlayerReplicationInfo).AxisImage);
				}
                else
				{
					Pawn.PlayerReplicationInfo.Team.TeamIndex = T_PARTISAN;
					Action.CurrentTeamImage.SetValue(TPPlayerReplicationInfo(Pawn.PlayerReplicationInfo).AlliedImage);
				}
			}
		}
		UpdateURL("team", ""$Pawn.PlayerReplicationInfo.Team.TeamIndex, true);
		StaticSaveConfig();

		/*if (Pawn.PlayerReplicationInfo.Team.TeamIndex == T_PARTISAN)
		{
			CharacterIndex = int(GetDefaultURL("AllyMesh"));
			TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = PartisanList[CharacterIndex];
		}
		else
		{
			CharacterIndex = int(GetDefaultURL("AxisMesh"));
			TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = NaziList[CharacterIndex];
		}*/
	}
}


simulated event PostBeginPlay()
{
	local int i;

	Super.PostBeginPlay();

	// Assign an existing checkpoint managers if one exists; otherwise, create a new one
	if (TPCM == None)
	{
		foreach AllActors(class'TPCheckpointManager', TPCM)
		{
			;
			break;
		}
		if (TPCM == None)
		{
			;
			TPCM = Spawn(class'TPCheckpointManager');
		}
	}

	if (PartisanList.Length == 0 && NaziList.Length == 0)
	{
		for (i = 0; i < Characters.Length; i++)
		{
			if (Characters[i].TeamID == T_PARTISAN)
			{
				PartisanList[PartisanList.Length] = Characters[i];
			}
			else if (Characters[i].TeamID == T_NAZI)
			{
				NaziList[NaziList.Length] = Characters[i];
			}
		}

		if (int(GetDefaultURL("team")) == T_PARTISAN)
		{
			CharacterIndex = int(GetDefaultURL("AllyMesh"));

			if ( TPPlayerReplicationInfo(PlayerReplicationInfo) != None )
				TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = PartisanList[CharacterIndex];
		}
		else
		{
			CharacterIndex = int(GetDefaultURL("AxisMesh"));

			if ( TPPlayerReplicationInfo(PlayerReplicationInfo) != None )
				TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = NaziList[CharacterIndex];
		}

	}

/*	else
	{
		`Log( 'TurningPoint_CheckpointSystem', "we have a TPCheckpointManager" );
	}*/

/*	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	// If there is an online subsystem, set the icon location
	if (OnlineSub != None && OnlineSub.SystemInterface != None)
	{
		// Place network notification images/icons at the bottom right
		OnlineSub.SystemInterface.SetNetworkNotificationPosition(NNP_BottomCenter);
		CleanupUngracefulReturnToMenu();
	}*/

/*	if (TPPlayerInput(PlayerInput) != None)
	{
		TPPlayerInput(PlayerInput).LastInputTime = WorldInfo.TimeSeconds;
		PlayerInput.bInvertMouse = class'WarGameSettings'.default.InvertLook.bValue;
	}*/

	// store the points of interest for clients
//	StorePointsOfInterest();

	// init the post processing settings
//	InitPausePostProcessSettings();
//	InitGameoverPostProcessSettings();

	if ( soundDucking.Length == 0 )
	{
		InitializeSoundDucking();
	}

	StatsRead = new class'TPGameStatsRead';
	StatsWrite = new class'TPGameStatsWrite';

}

/**
 * Helper function that actually will stream in the next chapter
 */
function StreamNextChapter()
{
	if (TPCM.MEMDEBUG_StreamNextChapter() == false)
	{
		SetTimer(0, false, 'StreamNextChaper');
	}
}

/**
 * Test level streaming level to level
 * @param Delay Optional parameter of how long to delay between stream-ins
 */
exec function TestAllStreaming(optional int Delay)
{
	// default to 60
	if (Delay == 0)
	{
		Delay = 60;
	}

	// load the initial map
//	ClientTravel("wargame_p?loadchapter=37", TRAVEL_Absolute);

	// start the looping timer
	SetTimer(Delay, true, 'StreamNextChapter');
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
// this is the logic that set the FOV's for the gun & arms
simulated function SetArmsFOV(const float FOV)
{
	local PlayerPawn PlayerPawn;
	local TPSkeletalMeshComponent ArmsSkeletalMeshComponent;

	//`log("set arms FOV to " @ FOV);
	PlayerPawn = PlayerPawn(Pawn);
	if (PlayerPawn != None && PlayerPawn.Mesh != None)
	{
		// setup the custom render FOV based on current weapon
		ArmsSkeletalMeshComponent = TPSkeletalMeshComponent(PlayerPawn.Mesh);
		if (ArmsSkeletalMeshComponent != None)
		{
			//`log("set arms FOV!!!!!!");
			ArmsSkeletalMeshComponent.SetFOV(FOV);
		}
	}
}

// this is the logic that set the FOV's for the gun & arms
simulated function SetGunFOV(const float FOV)
{
	local PlayerPawn PlayerPawn;
	local TPWeapon PlayerWeapon;
	local TPSkeletalMeshComponent GunSkeletalMeshComponent;

	//`log("set gun FOV to " @ FOV);
	PlayerPawn = PlayerPawn(Pawn);
	PlayerWeapon = PlayerPawn != None ? TPWeapon(PlayerPawn.Weapon) : None;
	if (PlayerWeapon != None && PlayerWeapon.Mesh != None)
	{
		// setup the custom render FOV based on current weapon
		GunSkeletalMeshComponent = TPSkeletalMeshComponent(PlayerWeapon.Mesh);
		if (GunSkeletalMeshComponent != None)
		{
			GunSkeletalMeshComponent.SetFOV(FOV);
		}
	}
}

// Setting Skeletal Mesh in Multiplayer
exec function SetSkeletalMesh(class<TPPawn> PawnClass)
{
	if (Role < Role_Authority)
	{
		PlayerPawn(Pawn).MyMesh = PawnClass.default.Mesh;
		PlayerPawn(Pawn).SetSkeletalMesh(PawnClass.default.Mesh);
	}
	else
		ServerSetMesh(PawnClass.default.Mesh);
}

exec function MPMenu()
{
	//local string URL;
	//if(WorldInfo.NetMode == NM_Standalone)
	//{
		//URL = "MPEntry";
		//ClientTravel(URL, TRAVEL_Absolute);
		//MPInteraction.GotoState('Active');
		//LocalPlayer(Player).ViewportClient.UIController.OpenScene(UIScene'UI_MPMenus.Menu.TPMainMenu', LocalPlayer(Player));
	//}
}

simulated function DrawFontTest(HUD hud)
{
	local Canvas	canvas;
	local string	dummyText;
	local int		i, x2, y2;
	local float		xl, yl;
	local font		systemFonts[3];
	local font		customFonts[2];

	canvas = hud.Canvas;

	canvas.Font = class'Engine'.Static.GetMediumFont();

	dummyText = "The quick brown fox jumps over the lazy dog.";

	systemFonts[0] = class'Engine'.Static.GetTinyFont();
	systemFonts[1] = class'Engine'.Static.GetSmallFont();
	systemFonts[2] = class'Engine'.Static.GetMediumFont();

	customFonts[0] = class'Engine'.Static.GetSmallFont();
	customFonts[1] = class'Engine'.Static.GetSmallFont();

	canvas.Font = class'Engine'.Static.GetLargeFont();
	Canvas.SetPos(80, 125);
	Canvas.DrawText("System Fonts");

	x2 = 130;
	y2 = 175;

	for ( i = 0 ; i < ArrayCount(systemFonts) ; i++)
	{
		canvas.Font = systemFonts[i];
		Canvas.StrLen(dummyText,xl,yl);
		canvas.SetPos( x2, y2 );
		canvas.DrawText(dummyText);
		y2 = y2 + int(yl);

	}

	canvas.Font = class'Engine'.Static.GetLargeFont();
	Canvas.SetPos(80, y2);
	Canvas.DrawText("Custom Fonts");

	for ( i = 0 ; i < ArrayCount(customFonts) ; i++)
	{
		canvas.Font = customFonts[i];
		Canvas.StrLen(dummyText,xl,yl);
		canvas.SetPos( x2, y2 );
		canvas.DrawText(dummyText);
		y2 = y2 + int(yl);

	}

	canvas.Font = class'Engine'.Static.GetLargeFont();
	Canvas.SetPos(80, y2);
	Canvas.DrawText("Bitmap Fonts");

	canvas.Font = customFonts[i];
	Canvas.StrLen(dummyText,xl,yl);
	canvas.SetPos( x2, y2 );
	canvas.DrawText("No bitmap font support.");

	canvas.Font = class'Engine'.Static.GetSmallFont();
}

simulated function InitializeSoundDucking()
{
	local array<Name> soundgroupNames;
	local int i;

	soundgroupNames = GetSoundGroupNames();

	for ( i = 0 ; i < soundgroupNames.Length ; i++ )
	{
		soundDucking.Insert(i, 1);
		soundDucking[i].channelName	= soundgroupNames[i];
		soundDucking[i].iniLevel	= GetSoundGroupCurrentVolume(soundgroupNames[i]);
		soundDucking[i].defLevel	= GetSoundGroupDefaultVolume(soundDucking[i].channelName);

	}

	InitializeMasterSoundgroups();
	InitializeSlaveSoundgroups();



}

// For testing
exec function SetGroupVolume( name audioGroup, float volume )
{
	local int audioGroupIndex;
	local int i;

	if ( audioGroup == 'all')
	{
		//ReparseSoundGroups();
		for ( i = 0 ; i < soundDucking.Length ; i++ )
		{
			SetAudioGroupVolume(soundDucking[i].channelName, soundDucking[i].duckLevel);
		}
		ResetSoundGroupVolumesToDefault();
		LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText( "Reinitializing Sound Ducking System.");
		return;
	}

	audioGroupIndex = FindSoundGroupByName( audioGroup );

	if ( audioGroupIndex == -1 )
	{
		LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText( "SoundGroup not found.");
	}

	else
	{
		LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText( "Changing" @ soundDucking[audioGroupIndex].channelName @ "volume:" @ soundDucking[audioGroupIndex].iniLevel @ "->" @ volume);
		soundDucking[audioGroupIndex].iniLevel = volume;
	}

}
exec function SetMaster( int master )
{
	activeMasterID = master;
}

exec function SoundTest(optional float soundVolume = -1.0)
{
	bSoundTest = !bSoundTest;

	if ( soundVolume <= -1.0 )
		SetAudioGroupVolume('MASTER', soundVolume);

}

exec function LoadoutTest()
{
	bLoadoutTest = !bLoadoutTest;

	Say("Loadout Test is now set to" @ bLoadoutTest);

}

exec function SpawnTest()
{
	bSpawnTest = !bSpawnTest;

	Say("Spawn Test is now set to" @ bSpawnTest);

}
exec function FontTest()
{
	bFontTest = !bFontTest;

	Say("Font Test is now set to" @ bFontTest);
}

exec function MPCheat()
{













}

exec function TogglePCChat()
{
	if (!WorldInfo.IsConsoleBuild() && WorldInfo.NetMode != NM_Standalone)
		UIScene_TPNonWeaponHUD(myNonWeaponUIScene).StartChat();
}

function Reset()
{
	local vehicle DrivenVehicle;

    DrivenVehicle = Vehicle(Pawn);
	if( DrivenVehicle != None )
		DrivenVehicle.DriverLeave(true); // Force the driver out of the car

	if ( Pawn != None )
	{
		PawnDied( Pawn );
		UnPossess();
	}

	super.Reset();

	SetViewTarget( Self );
    ResetCameraMode();

	//if (WorldInfo.NetMode == NM_Standalone)
	WaitDelay = WorldInfo.TimeSeconds + 2;
	//else
	//	WaitDelay = WorldInfo.TimeSeconds + TPGameReplicationInfo(WorldInfo.GRI).GameClass.default.RespawnDelay;

    FixFOV();
    if ( PlayerReplicationInfo.bOnlySpectator )
    	GotoState('Spectating');
    else
		GotoState('PlayerWaiting');

//	if (TPShellInt != None)
//		TPShellInt.GotoState('Inactive');
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas Canvas;
	local PlayerPawn PlayerPawn;
	local TPWeapon PlayerWeapon;

	PlayerPawn = PlayerPawn(Pawn);
	PlayerWeapon = PlayerPawn != None ? TPWeapon(PlayerPawn.Weapon) : None;

	Canvas = HUD.Canvas;

	if ( bFontTest )
	{
		DrawFontTest(hud);
		return;
	}

	if ( bSoundTest )
		return;

	canvas.Font = class'Engine'.Static.GetSmallFont();

	if ( Pawn == None )
	{
		if ( PlayerReplicationInfo == None )
		{
			Canvas.DrawText("NO PLAYERREPLICATIONINFO", false);
		}
		else
		{
			PlayerReplicationInfo.DisplayDebug(HUD,out_YL,out_YPos);
		}
		out_YPos += out_YL;
		Canvas.SetPos(4,out_YPos);

		Canvas.DrawText("Camera State:" @ TPPlayerCamera(PlayerCamera).CameraStyle $ "," @ TPPlayerCamera(PlayerCamera).deathCam.t);
		out_YPos += out_YL;

		Canvas.DrawText("Camera Location:" @ TPPlayerCamera(PlayerCamera).ViewTarget.POV.Location $ "," @ TPPlayerCamera(PlayerCamera).ViewTarget.POV.Rotation);
		out_YPos += out_YL;




		super.DisplayDebug(HUD,out_YL,out_YPos);
		return;
	}

	Canvas.SetDrawColor(255,0,0);
	Canvas.DrawText("CONTROLLER "$GetItemName(string(Self))$" Pawn "$GetItemName(string(Pawn)));
	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);

	Canvas.DrawText(" bPreciseDestination:" @ bPreciseDestination);
	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);

	if (HUD.ShouldDisplayDebug('AI'))
	{
		if ( Enemy != None )
		{
			Canvas.DrawText("     STATE: "$GetStateName()$" Enemy "$Enemy.GetHumanReadableName(), false);
		}
		else
		{
			Canvas.DrawText("     STATE: "$GetStateName()$" NO Enemy ", false);
		}
		out_YPos += out_YL;
		Canvas.SetPos(4,out_YPos);
	}

	out_YPos += out_YL;
	out_YPos += out_YL;
	Canvas.SetDrawColor(0,255,0);
	Canvas.SetPos(4,out_YPos);

	Canvas.DrawText("Current Weapon:" @ PlayerWeapon );
	out_YPos += out_YL;

	Canvas.DrawText("Animation:");
	out_YPos += out_YL;

	Canvas.DrawText(" Player:" @ "UNKNOWN");
	out_YPos += out_YL;

	Canvas.DrawText(" Weapon:" @ "UNKNOWN");
	out_YPos += out_YL;

	Canvas.DrawText("Flash Count:" @ PlayerPawn.FlashCount);
	out_YPos += out_YL;

	Canvas.DrawText("bThrowGrenade:" @ bThrowGrenade);
	out_YPos += out_YL;


	Canvas.DrawText("State:" @ PlayerPawn.GetStateName());
	out_YPos += out_YL;

	Canvas.DrawText("In Reload:" @ PlayerPawn.bIsReloading);
	out_YPos += out_YL;

	Canvas.SetPos(4,out_YPos);

}

// Set up Server Mesh
reliable server function ServerSetMesh(SkeletalMeshComponent SkelM)
{
	PlayerPawn(Pawn).MyMesh = SkelM;
	PlayerPawn(Pawn).SetSkeletalMesh(SkelM);
}

exec function DoMelee()
{
	local PlayerPawn pPawn;

	pPawn = PlayerPawn(Pawn);
	if (pPawn != none)
		pPawn.DoMeleeAttack();
}

exec function Spatialize(float spatialFactor)
{
	SpatializeAudio(spatialFactor);

}

exec function MasterVolume( float newMasterVolume )
{
	SetMasterVolume( newMasterVolume );
}
exec function SetWeaponFOV(float FOV)
{
	SetArmsFOV(FOV);
	SetGunFOV(FOV);
}

exec function SetCameraOffsetLocation(float x, float y, float z)
{
	TPPlayerCamera(PlayerCamera).OffsetLocation.X = x;
	TPPlayerCamera(PlayerCamera).OffsetLocation.Y = y;
	TPPlayerCamera(PlayerCamera).OffsetLocation.Z = z;
}
exec function SetCameraOffsetRotation(int Y, int P, int R)
{
	TPPlayerCamera(PlayerCamera).OffsetRotation.Yaw = Y;
	TPPlayerCamera(PlayerCamera).OffsetRotation.Pitch = P;
	TPPlayerCamera(PlayerCamera).OffsetRotation.Roll = R;
}

// Turns the scoreboard on and off for an individual player when the server declares a game has ended/started or for when you are dead/respawned.
reliable client function ToggleScoreboardonController(bool bEnable)
{
	TpHUD(myHUD).bShowScores = bEnable;
}

// this is the logic that set the FOV's for the gun & arms
reliable client function SetGunAndArmsFOVs()
{
	local float FOV;
	local PlayerPawn PlayerPawn;
	local TPWeapon PlayerWeapon;

	PlayerPawn = PlayerPawn(Pawn);
	PlayerWeapon = PlayerPawn != None ? TPWeapon(PlayerPawn.Weapon) : None;
	if (PlayerWeapon != None)
	{	// use the special FOV from the gun
		FOV = PlayerWeapon.PlayerRenderWeaponFOV;
	}
	else
	{	// reset the FOV to default
		FOV = 60;
	}
	SetArmsFOV(FOV);
	SetGunFOV(FOV);
}

reliable client function ResetGunAndArmsFOVs()
{
	SetArmsFOV(0);
	SetGunFOV(0);
}

exec function SkipCinematic()
{
	if (bCinematicMode)
		ConsoleCommand("CANCELMATINEE");
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/** Start as PhysicsSpectator by default */
auto state PlayerWaiting
{
	exec function StartFire( optional byte FireModeNum )
	{
		if (WorldInfo.NetMode != NM_Standalone && TPGameReplicationInfo(WorldInfo.GRI).GameStatus > GS_Lobby && TPGameReplicationInfo(WorldInfo.GRI).GameStatus != GS_PostGame)
		{
			ServerReStartPlayer();
		}
	}

	function PlayerMove(float DeltaTime)
	{
		local UIScene LobbyScene;
		
		// Sometimes the lobby doesnt open and we are stuck in a dead state.  
		// This is the hack fix to show the lobby
		if (/*WorldInfo.NetMode == NM_Client && */TPGameReplicationInfo(WorldInfo.GRI).GameStatus == GS_Lobby )
		{
			if (WorldInfo.GRI.GameClass.default.bTeamGame)
			{
				LobbyScene = GetUIController().FindSceneByTag('TeamLobbyUI');
			
				if (LobbyScene != none)
					return;
				
				;
				;
				;
				;
				;
				;
				;
				ClientOpenLobby(true);
			}
			else
			{
				LobbyScene = GetUIController().FindSceneByTag('DMLobbyUI');
			
				if (LobbyScene != none)
					return;
				
				;
				;
				;
				;
				;
				;
				;
				
				ClientOpenLobby(false);
			}
		}
	
		if (Pawn == none)
			return;

		super.PlayerMove(DeltaTime);
	}

	reliable server function ServerRestartPlayer()
	{
		super.ServerRestartPlayer();
		PlayerReplicationInfo.bOnlySpectator = false;
		WorldInfo.Game.bRestartLevel = false;
		// We are already restarting the player in Super to the GameInfo, this is redundant and harmful.
		//WorldInfo.Game.RestartPlayer( self );
	}
Begin:
	if (WorldInfo.NetMode == NM_Standalone)
	{
		PlayerReplicationInfo.bOnlySpectator = false;
		WorldInfo.Game.bRestartLevel = false;

		WorldInfo.Game.RestartPlayer( self );
		SetCameraMode('1st');
		ClientSetCameraMode('1st');
		ServerReStartPlayer();
	}
}

reliable server function AskForPawn()
{
	if ( GamePlayEndedState() )
		ClientGotoState(GetStateName(), 'Begin');
	else if ( Pawn != None )
		GivePawn(Pawn);
	else if (TPGameReplicationInfo(WorldInfo.GRI).GameStatus > GS_Lobby)
	{
		bFrozen = false;
		//ServerRestartPlayer();	// Do not spawn the player, game logic/UI menu handles that. 
	}
}

simulated event ReceivedPlayer()
{
	local string Value;

	super.ReceivedPlayer();

	;
	if (LocalPlayer(Player) != none)
		InitCallbacks();

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		SetupInteractions();

		connectInfo.AxisMesh	= ProfileSettings.GetAxisMesh();//GetIntOption(Options, "AxisMesh", 0);
		connectInfo.AxisWeap	= ProfileSettings.GetAxisWeapon();//GetIntOption(Options, "AxisWeap", 0);
		connectInfo.AllyMesh	= ProfileSettings.GetAlliedMesh();//GetIntOption(Options, "AllyMesh", 0);
		connectInfo.AllyWeap	= ProfileSettings.GetAlliedWeapon();//GetIntOption(Options, "AllyWeap", 0);
		connectInfo.DMMesh	= ProfileSettings.GetDMMesh();//GetIntOption(Options, "DMMesh", 0);
		connectInfo.DMWeap	= ProfileSettings.GetDMWeapon();//GetIntOption(Options, "DMWeap", 0);

		ClientUpdateConnectionInfo(	connectInfo.AxisMesh, connectInfo.AxisWeap, 
									connectInfo.AllyMesh, connectInfo.AllyWeap, 
									connectInfo.DMMesh,	connectInfo.DMWeap	);

		//`log(ProfileSettings.GetDMMesh()$" - "$connectInfo.DMMesh);

		// Added for PC to make sure to see if the gamepad was used when changing maps.
		if ( class'UIRoot'.static.GetDataStoreStringValue("<Registry:UsingGamePad>", Value) )
		{
			ClientSetUseGamePad( ( Value=="1" ) ? true : false );
		}
		//ClientUpdateConnectionInfo();
	}
}

// THIS function IS CALLED WHEN THE PAWN IS POSSESSED BY THIS CONTROLLER
// PUT ANY ONE-TIME INITIALIZATION CODE HERE
function Possess(Pawn aPawn, bool bVehicleTransition)
{
	local class<Weapon> WeaponClass;

	super.Possess(aPawn,bVehicleTransition);
	AllAnimNodesPresent();

	if (skel_HeadTrack != none)
	{
		skel_HeadTrack.BlendInTime = 0.2;
		skel_HeadTrack.BlendOutTime = 0.2;
	}










 	if (Pawn.IsA('TPPawn'))
		TPPawn(Pawn).SetUniform( TPPawn(Pawn).Uniform ); //sets up the rank icon

	// default to translation for RootMotionMode
	Pawn.Mesh.RootMotionMode=RMM_Translate;
	Pawn.Mesh.RootMotionRotationMode=RMRM_RotateActor;

	SetTimer(0.15f,true,'InteractModeTimer');

    SetTimer(0.1f,true,'FindEnemyToGrapple_v2');

	if (WorldInfo.NetMode == NM_Standalone)
	{
		SetTimer(0.11f,true,'FindLiveGrenades');
		ShowNewHUD();
	}

    if( StartSpot != None && TPPlayerStart(StartSpot) != None && bVehicleTransition==false)
    {
		if( myHUD != None && TPHUD(myHUD) != None)
		{
			TPHUD(myHUD).DrawFlags.bDrawCopyright = TPPlayerStart(StartSpot).bEnableHud;
		}

		if( TPGameViewportClient(LocalPlayer(Player).ViewportClient) != None )
		{
			TPGameViewportClient(LocalPlayer(Player).ViewportClient).SetDisplayDiagnostics(TPPlayerStart(StartSpot).bEnableDiagnosticMessages);
		}

		ShowHUDElements(TPPlayerStart(StartSpot).bEnableHud);
		}
	else
	{
		ShowHUDElements(true);
	}

	// If we have unlimited grenades, we need to equip the player with a grenade.
	if ( WorldInfo.NetMode == NM_Standalone && IsBonusActive(BONUS_ALWAYS_HAVE_GRENADES) )
	{	
		if (!m_bPendingTransition)
		{
			WeaponClass = class<Weapon>(FindObject("TPGameContent.Grenade", class'Class'));
			Pawn.CreateInventory( WeaponClass, true );
		}
	}
}

reliable client function ClientSetScoreboard(bool bTeamGame)
{
	if (WorldInfo.NetMode != NM_Standalone)
	{
		ClearTimer('FindLiveGrenades');
		SetTimer(0.11f,true,'FindLiveGrenades');

		if (myHUDUIScene != none)
			GetUIController().CloseScene(myHUDUIScene);
		myHUDUIScene = none;

		if (ScoreboardScene != none)
			GetUIController().CloseScene(ScoreboardScene);
		ScoreboardScene = none;
		ShowNewHUD(bTeamGame);
	}
}

reliable client function ShowNewHUD(optional bool bTeamGame)
{
	if (WorldInfo.NetMode == NM_DedicatedServer)
		return;

	;

	if (ScoreboardSceneDMTemplate == None)
		ScoreboardSceneDMTemplate = UIScene_BaseScoreboard(WorldInfo.ScoreboardSceneDMTemplate);

	if (ScoreboardSceneTeamDMTemplate == None)
		ScoreboardSceneTeamDMTemplate = UIScene_BaseScoreboard(WorldInfo.ScoreboardSceneTeamDMTemplate);

	;

	// create the HUD UIScene
	if (myHUDUIScene == None)
	{
		TPHUD(myHUD).DrawFlags.bDrawCompass = false;
		if (WorldInfo.NetMode == NM_Standalone)
		{
			GetUIController().OpenScene(HUDTemplate, LocalPlayer(Player), myHUDUIScene);
			GetUIController().OpenScene(NonWeaponHUDTemplate, LocalPlayer(Player), myNonWeaponUIScene);
		}
		else
		{
			GetUIController().OpenScene(HUDTemplate, None, myHUDUIScene);
			GetUIController().OpenScene(NonWeaponHUDTemplate, None, myNonWeaponUIScene);

			;
			if (ScoreboardScene == none)
			{
				if (bTeamGame)
					GetUIController().OpenScene(ScoreboardSceneTeamDMTemplate, None, ScoreboardScene);
				else
					GetUIController().OpenScene(ScoreboardSceneDMTemplate, None, ScoreboardScene);
			}
		}
	}
	if (WorldInfo.NetMode != NM_Standalone && ScoreboardScene == none)
	{
		TPHUD(myHUD).DrawFlags.bDrawCompass = false;

		if (TPGameReplicationInfo(WorldInfo.GRI).GameClass.Default.bTeamGame)
			GetUIController().OpenScene(ScoreboardSceneTeamDMTemplate, None, ScoreboardScene);
		else
			GetUIController().OpenScene(ScoreboardSceneDMTemplate, None, ScoreboardScene);
	}
}

reliable client function ShowHUDElements(bool bShowHUD)
{
	local bool bFadeWhenInactive;
	local bool bShowCrosshair;

	// if we have a valid profile, and the HUD is forcibly disabled, override bShowHUD
	if (ProfileSettings != None && ProfileSettings.GetVideoGamma() != 0.0f)
	{
		bFadeWhenInactive = ProfileSettings.GetHUDOption();
		bShowCrosshair = ProfileSettings.GetCrosshairOption();
	}
	else
	{
		bFadeWhenInactive = true;
		bShowCrosshair = true;
	}

	if( myHUD != None && TPHUD(myHUD) != None)
	{
		TPHUD(myHUD).DrawFlags.bDrawCompass = false;
		TPHUD(myHUD).DrawFlags.bDrawInventory = false;
		TPHUD(myHUD).DrawFlags.bDrawAmmoCount = false;
		TPHUD(myHUD).DrawFlags.bDrawGrenades = false;
		ShowCrosshair(bShowCrosshair);
	}

		if( ObjInt != None )
		{
		ObjInt.DrawFlags.bDrawObjectiveMessages = bShowHUD;
		}

	bAllowClientMessages = bShowHUD;

	if (myHUDUIScene != None)
	{
		if (bShowHUD)
			UIScene_TPHUD(myHUDUIScene).bHUDOptionOn = true;
		else
			UIScene_TPHUD(myHUDUIScene).bHUDOptionOn = false;

		UIScene_TPHUD(myHUDUIScene).bFadeWhenInactive = bFadeWhenInactive;
    }
}

reliable client function FadeInHUD()
{
	if (myHUDUIScene != None)
	{
		UIScene_TPHUD(myHUDUIScene).FadeInHUD();
	}
}

reliable client function ClientExitArbitratedMatch()
{
	;
	WriteProfile(true);
	DestroyOnlineSession();
	if (WorldInfo.NetMode == NM_Client)
		SetDisconnectionError(FRONTEND_INGAME);
}

reliable client function ClientArbitratedMatchEnded()
{
	;
	WriteProfile(true);
	EndOnlineGame();
	SetFrontEndErrorMessage("", "", true, true);
	//bIgnoreCloseNotify = true;
}

reliable client function ClientLoadingScreen(bool bShow)
{
	if (bShow)
	{
		GetLCDManager().ShowLoading();
		TPGameViewportClient(LocalPlayer(Player).ViewportClient).DisplayLoadingScreen();
	}
	else
	{	
		GetLCDManager().ShowSplash();
		
		TPGameViewportClient(LocalPlayer(Player).ViewportClient).EndLoadingScreen();
	}
}

// Setup the Interactions for the local client
reliable client function SetupInteractions()
{
	local TPGameViewportClient viewport;
	viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);

	BluffInt     = viewport.BluffInteractionObj;
	GrapInt      = viewport.GrappleInteractionObj;
    ObjInt       = viewport.ObjectiveInteractionObj;
    TPShellInt   = viewport.TPShellInteraction;



    GrapInt_v2   =viewport.GrappleInteraction_v2Obj;

	if (ObjInt != none)
		ObjInt.GetPlayerController(self);
	if (CheatMenuInt != none)
		CheatMenuInt.GetPlayerController(self);

	// Keyboard stuff too
	GrapInt_v2.GrappleKeyboard = GetNonControllerBinding("Use | SkipCinematic");
	GrapInt_v2.KillKeyboard = GetNonControllerBinding("MoveForward");
	GrapInt_v2.ShieldKeyboard = GetNonControllerBinding("MoveBackward");

	/*if (WorldInfo.NetMode != NM_Standalone)
	{
		MPInteraction = TPGameViewportClient(LocalPlayer(Player).ViewportClient).MPInteraction;

		if (MPInteraction != none)
			MPInteraction.GetPlayerController(self);
	}*/

	// Immediately go to the main screen
	if (TPShellInt != none)
	{
		TPShellInt.GetPlayerController(self);
		if(TPShellInt.bStartupShell && WorldInfo.NetMode == NM_Standalone)
		{
			TPShellInt.GotoState('Active');
			TPShellInt.bStartupShell = false;
		}
	}

	viewport.InitializeLCDManager(self);
	if (bIsDemoMode)
	{
		viewport.bDisableDiagnosticsAndCopyright = true;
		viewport.bDisplayDiagnostics = false;
	}
}

exec function PerformanceBooster()
{
	if (WorldInfo.NetMode != NM_Standalone)
	{
		MPCheat();
		LocalPlayer(Player).ViewportClient.ConsoleCommand("Viewmode Unlit");
		ToggleWeaponEffects(WPF_HITEFFECTS);
		LocalPlayer(Player).ViewportClient.ConsoleCommand("show particles");
		LocalPlayer(Player).ViewportClient.ConsoleCommand("show decals");
		LocalPlayer(Player).ViewportClient.ConsoleCommand("show foliage");
		LocalPlayer(Player).ViewportClient.ConsoleCommand("show dynamicshadows");
		LocalPlayer(Player).ViewportClient.ConsoleCommand("show postprocess");
		LocalPlayer(Player).ViewportClient.ConsoleCommand("show fog");
		/*
			MP_Cheats
			Viewmode Unlit
			ToggleWeaponEffects(0)
			Show particles
			Show decals
			Show DynamicShadows
			Show PostProcess
			Show Folliage
			Show Fog
	*/
	}

}

exec function ToggleWeaponEffects(int Flags)
{
	TPGameReplicationInfo(WorldInfo.GRI).TogglePerformanceFlags(Flags);
}

reliable client function ClientRestart(Pawn NewPawn)
{
	super.ClientRestart(NewPawn);
}

function ClientDisplayCheckpointText()
{
	local TpHUD MyTPHud;
	MyTPHud = TpHUD(myHud);

	if (MyTPHud != None)
	{
		MyTPHud.StartDrawingCheckpointText();
	}
}

reliable client function ClientDisplayChapterpointText()
{
	local TpHUD MyTPHud;
	MyTPHud = TpHUD(myHud);

	if (MyTPHud != None)
	{
		MyTPHud.StartDrawingChapterpointText();
	}
}

exec function bool CheckPointExists()
{
	return TPCM.HasCheckpoint();
}



/**
 * Handles updating the InteractableList for the HUD.
 */
simulated function InteractModeTimer()
{
	local vector cameraLoc;
	local rotator cameraRot;
	local array<Trigger> useList;
	local int idx, evtIdx;
	local array<SequenceEvent> evtList;
	GetPlayerViewPoint(cameraLoc, cameraRot);
	// empty the current list
	InteractableList.Length = 0;
	// get the list of usuable triggers
	GetTriggerUseList(InteractDistance,1024.f,0.f,false,useList);
	// now build the list of interactable objects
	InteractableList.Length = useList.Length;
	for (idx = 0; idx < useList.Length; idx++)
	{
		InteractableList[idx].InteractTrigger = useList[idx];
		// check for actual event activation
		evtList.Length = 0;
		useList[idx].FindEventsOfClass(class'SeqEvent_Used',evtList);

		if (evtList.Length > 0)
		{
			InteractableList[idx].bUsuable = false;
			// test each event for activation
			for (evtIdx = 0; evtIdx < evtList.Length && !InteractableList[idx].bUsuable; evtIdx++)
			{
				if (evtList[evtIdx].CheckActivate(useList[idx],Pawn,true))
				{
					InteractableList[idx].bUsuable = true;
					InteractableList[idx].Event = SeqEvent_Used(evtList[evtIdx]);
				}
				else
				if (evtList[evtIdx].bEnabled)
				{
					// save the last enabled event as the one to draw unusuable
					InteractableList[idx].Event = SeqEvent_Used(evtList[evtIdx]);
				}
			}
			// only highlight if directly looking at the trigger
			if (InteractableList[idx].bUsuable)
			{
				InteractableList[idx].bUsuable = PointDistToLine(useList[idx].Location/* + useList[idx].CollisionComponent.Bounds.Origin*/,vector(cameraRot),cameraLoc) <= 60.f;
			}
		}
		// remove if no events associated with it
		else
		{
			useList.Remove(idx,1);
			InteractableList.Remove(idx,1);
			idx--;
		}
	}
	// pick the closest target
	PickClosestInteractable();
}

/**
 * Pick closest Interactable target.
 * Only works if 'HighlightedInteractable' is not defined. (Works as an initialization function).
 * If a satisfactory result is found, then 'HighlightedInteractable' variable is updated.
 */

simulated function PickClosestInteractable()
{
	local int		idx;
	local float		Dist, BestDist;
	local vector	CamLoc;
	local rotator	CamRot;

	// if there is already a highlighted target, then skip.
	if( HighlightedInteractable.InteractTrigger != None )
	{
		return;
	}

	// Find target the closest to the crosshair
	GetPlayerViewPoint( CamLoc, CamRot );
	BestDist = -1;
	for (idx=0; idx<InteractableList.Length; idx++)
	{
		Dist = PointDistToLine(InteractableList[idx].InteractTrigger.Location + InteractableList[idx].InteractTrigger.CollisionComponent.Bounds.Origin, vector(CamRot), CamLoc);
		if( BestDist == -1 || Dist < BestDist )
		{
			BestDist				= Dist;
			HighlightedInteractable	= InteractableList[idx];
		}
	}
}

//event OnAnimPlay(AnimNodeSequence SeqNode)
//{
//
//}
//
//event OnAnimEnd(AnimNodeSequence SeqNode)
//{
//    if (SeqNode.AnimSeqName == 'bb0005t_ground_mobile_stand_alert_mantlejumpland')
//    {
//        TPPawn(Pawn).Obstacle=OB_Nothing;
//    }
//    else if (SeqNode.AnimSeqName == 'bb0005k_air_mobile_stand_alert_catch')
//    {
//        if (TPPawn(Pawn).Obstacle == OB_Catchable)
//            PlayerHang ( );
//    }
//}

//////////////////////////////////////////////////////////////////
/** Shakes the player's view with the given parameters
	Should only be called on the owning client */
function ShakeView(ShakeInfo NewViewShake)
{
	// apply the new rotation shaking only if it is larger than the current amount
	if (VSize(NewViewShake.RotMag) > VSize(CurrentViewShake.RotMag))
	{
		CurrentViewShake.RotMag = NewViewShake.RotMag;
		CurrentViewShake.RotRate = NewViewShake.RotRate;
		CurrentViewShake.RotTime = NewViewShake.RotTime;
	}
	// apply the new offset shaking only if it is larger than the current amount
	if (VSize(NewViewShake.OffsetMag) > VSize(CurrentViewShake.OffsetMag))
	{
		CurrentViewShake.OffsetMag = NewViewShake.OffsetMag;
		CurrentViewShake.OffsetRate = NewViewShake.OffsetRate;
		CurrentViewShake.OffsetTime = NewViewShake.OffsetTime;
	}
}

function OnCameraShake(SeqAct_CameraShake ShakeAction)
{
	;

    if (ShakeAction.bStopCameraShake)
        StopViewShaking();
    else
        ShakeView(ShakeAction.CameraShake);
}

/** Turns off any view shaking */
function StopViewShaking()
{
	local ShakeInfo EmptyViewShake;
		EmptyViewShake.OffsetTime=0.0f;	// FIXMERON : Yech.

	ShakeOffset.X = 0;
	ShakeOffset.Y = 0;
	ShakeOffset.Z = 0;

	ShakeRot.Pitch = 0;
	ShakeRot.Yaw   = 0;
	ShakeRot.Roll  = 0;

	CurrentViewShake = EmptyViewShake;
}

final native function CheckShake(out float MaxOffset, out float Offset, out float Rate, float Time);

final native function UpdateShakeRotComponent(out float Max, out int Current, out float Rate, float Time, float DeltaTime);

/** Sets ShakeOffset and ShakeRot to the current view shake that should be applied to the camera */
function ViewShake(float DeltaTime)
{
    if (!IsZero(CurrentViewShake.OffsetRate))
    {
       // modify shake offset
	   ShakeOffset.X += DeltaTime * CurrentViewShake.OffsetRate.X;
	   CheckShake(CurrentViewShake.OffsetMag.X, ShakeOffset.X, CurrentViewShake.OffsetRate.X, CurrentViewShake.OffsetTime);

	   ShakeOffset.Y += DeltaTime * CurrentViewShake.OffsetRate.Y;
	   CheckShake(CurrentViewShake.OffsetMag.Y, ShakeOffset.Y, CurrentViewShake.OffsetRate.Y, CurrentViewShake.OffsetTime);

       ShakeOffset.Z += DeltaTime * CurrentViewShake.OffsetRate.Z;
	   CheckShake(CurrentViewShake.OffsetMag.Z, ShakeOffset.Z, CurrentViewShake.OffsetRate.Z, CurrentViewShake.OffsetTime);

	   CurrentViewShake.OffsetTime -= DeltaTime;
    }

    if (!IsZero(CurrentViewShake.RotRate))
    {
       UpdateShakeRotComponent(CurrentViewShake.RotMag.X, ShakeRot.Pitch, CurrentViewShake.RotRate.X, CurrentViewShake.RotTime, DeltaTime);
	   UpdateShakeRotComponent(CurrentViewShake.RotMag.Y, ShakeRot.Yaw, CurrentViewShake.RotRate.Y, CurrentViewShake.RotTime, DeltaTime);
	   UpdateShakeRotComponent(CurrentViewShake.RotMag.Z, ShakeRot.Roll, CurrentViewShake.RotRate.Z, CurrentViewShake.RotTime, DeltaTime);
   	   CurrentViewShake.RotTime -= DeltaTime;
    }
}
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


reliable server function ServerSetAimPose(bool bFriendly)
{
	bTargettingFriendly = bFriendly;
}

simulated function SetAimPose(bool bFriendly)
{
    if (bFriendly)
    {
	    if (Role < Role_Authority)
		    ServerSetAimPose(bFriendly);

        ClearTimer('SetAimPoseInternal');
        bTargettingFriendly = bFriendly;
    }
    else
    {
        if (!IsTimerActive('SetAimPoseInternal') && bTargettingFriendly)
            SetTimer(0.2,,'SetAimPoseInternal');
    }
}

simulated function SetAimPoseInternal()
{
    if (Role < Role_Authority)
	    ServerSetAimPose(false);

    bTargettingFriendly = false;

    if (bPendingFire)
        StartFire();
}

exec function StopFire( optional byte FireModeNum )
{
    bPendingFire = false;

    if (PrevWeaponOnGrenade != None)
        return;

    Super.StopFire(FireModeNum);
}

//
// Primary fire has been triggered.
//
exec function StartFire( optional byte FireModeNum )
{
    local TPWeapon CurrentWeapon;

    CurrentWeapon = TPWeapon( Pawn.Weapon );

    if ((CurrentWeapon != None && CurrentWeapon.IsInState('ActiveSprinting')) || PrevWeaponOnGrenade != None)
        return;

	if (Pawn!=None && !bCinematicMode && (IsInState('PlayerWalking') || IsInState('PlayerLean') || IsInState('PlayerShielding')))
	{
		if (bTargettingFriendly)
        {
            bPendingFire = true;
			return;
        }

        if ((CurrentWeapon != None) && (!CurrentWeapon.Empty()) && bIsThirdPerson && !IsInState('PlayerShielding'))
           ServerCamera('1st');

        //if our only weapon is a grenade, the Right Trigger does nothing, because the grenade button is R Bumper
		if ((Pawn.Weapon != None) && !Pawn.Weapon.IsA('Grenade_Persistent'))
		{
			FadeInHUD();
			Pawn.StartFire( FireModeNum );
		}
	}
	if (Pawn.IsA('SVehicle'))
		Pawn.StartFire(FireModeNum);
}

reliable server function ServerReload()
{
	local TPWeapon CurrentWeapon;
	local PlayerPawn pPawn;

	pPawn = PlayerPawn(pawn);

	if ( pPawn == None )
		return;

	CurrentWeapon = TPWeapon( pPawn.Weapon );

	if ( CurrentWeapon == None )
		return;

	if(bIsThirdPerson)
	{
		ServerCamera('1st');
	}

	//if (bIsReloading)
	//{
		if (CurrentWeapon.CanReload() && !CurrentWeapon.MagazineFull())
			CurrentWeapon.GotoState('Reloading');
	//}
	//pPawn.bIsReloading = true;
}

function bool DenyPickup(Inventory inv)
{
    if (IsInState('PlayerShielding'))
        return true;

    return false;
}

reliable server function bool PickupWeapons()
{
	local float			distanceToPickup;	// How far are we from this weapon we are attempting to pickup?
	local PlayerPawn	pPawn;				// The player pawn belonging to this controller.
	Local TPWeapon		weap;				// IF APPLICABLE: The weapon in our inventory thats the same type of our pickup
	local TPDroppedIntelPickup Intel;

	pPawn = PlayerPawn(Pawn);

	// Are we currently attempting to pick up a DROPPED weapon?
	if (pPawn.PendingPickup != None)
    {
		DistanceToPickup = VSize(pPawn.PendingPickup.Location - Pawn.Location);
        if (DistanceToPickup < PickupDistance)
        {
			// Hack for Health Pickups until we get past Vertical Slice
/*			if ( pPawn.PendingPickup.IsA('TPDroppedHealthPickup') )
			{
				if (Pawn.Health < pPawn.MaxPlayerHealth)
				{
					PlaySound(TPDroppedHealthPickup(pPawn.PendingPickup).PickupSound);
					Pawn.Health += (TPDroppedHealthPickup(pPawn.PendingPickup).HealPercentage * pPawn.MaxPlayerHealth) * 0.01;
					TPDroppedHealthPickup(pPawn.PendingPickup).UsedMesh.Destroy();
					pPawn.PendingPickup.Destroy();
					pPawn.PendingPickup = None;

					if (TpHUD(myHUD) != none)
					{
						TpHUD(myHUD).bPickup=false;
						bDontNotifyClientPickup = false;
					}

				}
			}
			else*/
			if ( pPawn.PendingPickup.IsA('TPDroppedIntelPickup'))
			{
				if (TpHUD(myHUD) != none)
				{
					TpHUD(myHUD).bPickup=false;
					bDontNotifyClientPickup = false;
				}


				Intel = TPDroppedIntelPickup(pPawn.PendingPickup);
				TPGameInfo(WorldInfo.Game).CurrentIntelPickup = Intel.IntelNumber;
				//`log("Setting Intel to"@TPGameInfo(WorldInfo.Game).CurrentIntelPickup);

				Achievements.ClientGiveIntel(Intel.IntelNumber);
				WriteProfile();

				GetUIController().OpenScene(IntelPickupScene, LocalPlayer(Player));

				pPawn.PendingPickup.Destroy();
				pPawn.PendingPickup = None;
			}
			// Pickup weapons like normal
			else
			{
				pPawn.PendingPickup.GiveTo (Pawn);
				pPawn.PendingPickup = None;

				if (TpHUD(myHUD) != none)
				{
					TpHUD(myHUD).bPickup=false;
					bDontNotifyClientPickup = false;
				}


				if(bIsThirdPerson)
				{
					TPWeapon(Pawn.Weapon).SetHidden(true);
				}
			}
		    return true;
        }
		else if (DistanceToPickup < LookAtPickupDistance)
		{
			// Hack for Health Pickups until we get past Vertical Slice
/*			if ( pPawn.PendingPickup.IsA('TPDroppedHealthPickup') )
			{
				if (Pawn.Health < pPawn.MaxPlayerHealth)
				{
					Pawn.Health += (TPDroppedHealthPickup(pPawn.PendingPickup).HealPercentage * pPawn.MaxPlayerHealth) * 0.01;
					pPawn.PendingPickup.Destroy();
					pPawn.PendingPickup = None;

					if (TpHUD(myHUD) != none)
					{
						TpHUD(myHUD).bPickup=false;
						bDontNotifyClientPickup = false;
					}

				}
			}
			else */
			if ( pPawn.PendingPickup.IsA('TPDroppedIntelPickup'))
			{
				if (TpHUD(myHUD) != none)
				{
					TpHUD(myHUD).bPickup=false;
					bDontNotifyClientPickup = false;
				}

				Intel = TPDroppedIntelPickup(pPawn.PendingPickup);
				TPGameInfo(WorldInfo.Game).CurrentIntelPickup = Intel.IntelNumber;
				//`log("Setting Intel to"@TPGameInfo(WorldInfo.Game).CurrentIntelPickup);

				Achievements.ClientGiveIntel(Intel.IntelNumber);
				WriteProfile();

				GetUIController().OpenScene(IntelPickupScene, LocalPlayer(Player));

				pPawn.PendingPickup.Destroy();
				pPawn.PendingPickup = None;
			}
			// Pickup weapons like normal
			else
			{
				pPawn.PendingPickup.GiveTo (Pawn);
				pPawn.PendingPickup = None;

				if (TpHUD(myHUD) != none)
				{
					TpHUD(myHUD).bPickup=false;
					bDontNotifyClientPickup = false;
				}

				if(bIsThirdPerson)
				{
					TPWeapon(Pawn.Weapon).SetHidden(true);
				}
			}
			return true;
		}
	}
	// Are we trying to pickup a weapon from a pickup factory?
	if (pPawn.PendingPickupFactory != None)
    {
		// How far is this weapon pickup from our current location?
		//DistanceToPickup = VSize(pPawn.PendingPickupFactory.Location - Pawn.Location);

		// The code originally here was identical to the else case, so they have been unforked.  If we ever do distance
		// checks for better pickup accuracy please fork the logic in here. - KKing
		//if (DistanceToPickup < PickupDistance)
        //{

        //}

		// Do I already have the weapon type that I am trying to pick up.
		Weap = TPWeapon(pPawn.FindInventoryType(pPawn.PendingPickupFactory.InventoryType));

		// If I do, I need to decide if I need to
		//		> "gut" this weapon by stealing its ammo OR
		//		> leave the weapon be as I already have enough ammo
		if( Weap != None )
		{
			// I have full ammo, so I can't take this weapon nor gut its ammo.  Leave it in the world.
			if ( Weap.bInfiniteAmmo )
				return true;

			/*
				TEST CASES: with respect to:
				Magazine Capcity = 3
				Max Reserve Ammo = 12

					( --- Before Pickup ---- )		Pickup?			( --- After Pickup ---- )
				Magazine Ammo		Reserve Ammo				Magazine Ammo		Reserve Ammo
					3					9			NO				3					9
					1					9			NO				1					9
					3					8			YES				3					9
					0					2			YES				0					12
					0					12			NO				0					12
			*/

			// If I do not have full ammo in either reserve, or in the clip's size + reserve.
			if ( Weap.AmmoCount + Weap.MagazineSize < Weap.MaxAmmo )
			{
				// (NOTE) ^^^^ I am intentionally using magazinesize and not ammoinMagazine.  Otherwise the player could
				//        |||| gain more ammo than they get on initial loadout.

				// If the last clip is empty, I should go back to maximum ammo
				if ( Weap.AmmoInMagazine == 0 )
				{
					Weap.AmmoCount = Weap.MaxAmmo;
				}
				// Otherwise, make my ammo reserve max ammo minus the current clip I have loaded
				else
				{
					Weap.AmmoCount = Weap.MaxAmmo - Weap.MagazineSize;
				}

				// Taking any ammo from the weapon results in it being despawned
				pPawn.PendingPickupFactory.GiveTo (Pawn);
			}
			else
			{
				// I have full ammo, so I can't take this weapon nor gut its ammo.  Leave it in the world.
				return true;
			}
		}
		// I don't have this gun, so I should take it
		else
		{
			pPawn.PendingPickupFactory.GiveTo (Pawn);
		}

		// We are no longer pending a pickup from a weapon factory, as its action was handled above.
		pPawn.PendingPickupFactory = None;

		// Nor does the HUD need to keep stating that a pickup was just handled
		if (TpHUD(myHUD) != none)
		{
			TpHUD(myHUD).bPickup=false;
			bDontNotifyClientPickup = false;
		}

		// Not sure, but not setting the current weapon to hidden may cause it to be rendered because the new weap is active
		if(bIsThirdPerson)
		{
			TPWeapon(Pawn.Weapon).SetHidden(true);
		}
		return true;
	}

	return false;
}

exec function Reload()
{
	local PlayerPawn	pPawn;
	local TPWeapon		CurrentWeapon;

    if (!Pawn.bCollideWorld)  // ie. when shimmying
        return;

    if (bSprint)
        return;

	// Don't allow a reload while swapping weapons
	if (Pawn.InvManager.PendingWeapon != None)
		return;
		
	ReloadButtonHeldTime = 0.0f;

	if (!bReloadGrabbedWeapon)
	{
		//`log("Didn't grab a weapon, reloading");
		FadeInHUD();
		pPawn = PlayerPawn(pawn);

		if ( pPawn == None )
			return;

		CurrentWeapon = TPWeapon( pPawn.Weapon );

		if ( CurrentWeapon == None )
			return;

		if (CurrentWeapon.CanReload() && !CurrentWeapon.MagazineFull())
				CurrentWeapon.GotoState('Reloading');

		//pPawn.bIsReloading = true;
		ServerReload();
	}
	else
	{
		bReloadGrabbedWeapon = false;
	}
}

simulated function AdjustFOV(float DeltaTime )
{
    if (bCinematicMode)
    {
        if (Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon).IsAimDownSight())
            ToggleAimDownSight(true);

        FOV(DesiredFOV);
        return;
    }

	if(Pawn != None && Pawn.PhysicsVolume.IsA('TPFOVVolume'))
	{
		DesiredFOV = TPFOVVolume(Pawn.PhysicsVolume).FOVInVolume;
		TPFOVVolume(Pawn.PhysicsVolume).TPC = self;
		if ( FOVAngle != DesiredFOV )
		{
		//if (PhysicsVolume.Encompasses(Pawn))
		//{
			if ( FOVAngle > DesiredFOV )
				FOVAngle = FOVAngle - FMax(4, 3 * DeltaTime * (FOVAngle - DesiredFOV));
			else
				FOVAngle = FOVAngle - FMin(-4, 3 * DeltaTime * (FOVAngle - DesiredFOV));
			if ( Abs(FOVAngle - DesiredFOV) <= 2 )
				FOVAngle = DesiredFOV;

			 FOV (FOVAngle);
		//}
		}
		return;
	}

    // FOV is adjusted in TPPlayerCamera
    if (bCamTransition)
        return;

	if (FOVAngle != DesiredFOV)
	{
        if (!bSmoothFOV) // Don't interpolate FOV
        {
            FOVAngle = DesiredFOV;
        }
        else
        {
            //if (FOVAngle > DesiredFOV)
            //    FOVAngle -= DeltaTime * FOVRate;
            //else
            //    FOVAngle += DeltaTime * FOVRate;

			if (bFOVUp)
			{
				FOVAngle += DeltaTime * FOVRate;

				if (FOVAngle >= DesiredFOV)
				{
                    FOVAngle = DesiredFOV;
                    bSmoothFOV = false;
				}
			}
			else
			{
				FOVAngle -= DeltaTime * FOVRate;
				if (FOVAngle <= DesiredFOV)
				{
                    FOVAngle = DesiredFOV;
                    bSmoothFOV = false;
				}
			}

            //if (Abs(FOVAngle - DesiredFOV) <= 2)
            //{
            //    FOVAngle = DesiredFOV;
            //    bSmoothFOV = false;   // Reset
            //}
        }

        FOV (FOVAngle);
	}
}

simulated function SetDesiredFOV(float NewFOV, optional float NewRate = default.FOVRate, optional bool bSmoothTransition = false)
{
	bFOVUp     = NewFOV > FOVAngle;
	bSmoothFOV = bSmoothTransition;
	FOVRate    = NewRate;
    FOVStart   = FOVAngle;
	DesiredFOV = NewFOV;
}

simulated function ResetFOV()
{
	DesiredFOV = DefaultFOV;
	//FOVAngle = DefaultFOV;
}

exec function EnableAimDownSight(optional bool CinematicOverride = false)
{
	local Turret   playerTurret;
    local TPWeapon weap;

    weap = TPWeapon(Pawn.Weapon);

   	SetWasAimingDownSight( true );

	if (weap != None)
    {
		if (!weap.IsAimDownSightLocked() && !weap.bToggleAimDownSight && !weap.IsPuttingDown() &&
			!weap.IsReloading())
		    ToggleADSInternal(CinematicOverride);
    }
	else if (Pawn.IsA('Turret'))
	{
		playerTurret = Turret(Pawn);
		playerTurret.AimDownSight(self, True);
	}
}

exec function DisableAimDownSight(optional bool CinematicOverride = false)
{
	local Turret   playerTurret;
    local TPWeapon weap;

    weap = TPWeapon(Pawn.Weapon);

    // ADS will be disabled when unpausing
    if (WorldInfo.Pauser != None)
        return;

	SetWasAimingDownSight( false );

    if (weap != None)
    {
		if (!weap.IsAimDownSightLocked() && weap.bToggleAimDownSight)
            ToggleADSInternal(CinematicOverride);
    }
    else if (Pawn.IsA('Turret'))
	{
		playerTurret = Turret(Pawn);
		playerTurret.AimDownSight(self, False);
	}
}

exec function ToggleAimDownSight(optional bool CinematicOverride = false)
{
	ToggleADSInternal(CinematicOverride);
}

simulated function ToggleADSInternal(optional bool CinematicOverride = false)
{
	local TPWeapon CurrentWeapon;
	local Turret   playerTurret;

	// Allow turrets to handle their own
	if (Pawn.IsA('Turret'))
	{
		playerTurret = Turret(Pawn);
		playerTurret.ToggleAimDownSight(self);
		return;
	}

    if ( Pawn.Weapon ==	None )
		return;

	CurrentWeapon =	TPWeapon( Pawn.Weapon );

	if ( CurrentWeapon == None )
		return;

	// Prevent the player from beginning to aim down sight at times, but he should ALWAYS
	// come out of it when told.
	if (!CurrentWeapon.bToggleAimDownSight)
	{
	    // Don't allow aim down	sight during a cutscene or when sprinting
		if ((bCinematicMode && !CinematicOverride) || bSprint)
			return;

	    if (!Pawn.bCollideWorld)  // ie. when shimmying
		    return;
	}

	if (bIsThirdPerson && !CurrentWeapon.bToggleAimDownSight)
		ServerCamera('1st');

    CurrentWeapon.ToggleAimDownSight(self);

	TPPawn(Pawn).bIsAimDownSight = CurrentWeapon.bToggleAimDownSight;
	TPPawn(Pawn).ServerSetADS(CurrentWeapon.bToggleAimDownSight);
}


// Overriden from parent for TP's aim assist.  Main difference is tracing with TRACEFLAG_Bullet,
// and returning with BaseAimRot unmodified if pawn is hit.  There is a slight discrepency between
// the cursor turning red and this function's call to PickTarget finding a BestTarget due to
// the different FireDir and projStart parameters but this only really matter when a pawn
// is up close in which case aim assist isn't really needed anyway.
//
function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	local vector	FireDir, AimSpot, HitLocation, HitNormal, OldAim, AimOffset;
	local actor		BestTarget, HitActor;
	local float		bestDist;
	local bool		bNoZAdjust, bInstantHit;
	local rotator	BaseAimRot, AimRot;

	bInstantHit = ( W == None || W.bInstantHit );
	BaseAimRot = (Pawn != None) ? Pawn.GetBaseAimRotation() : Rotation;

//disabling TP shot assist



        return BaseAimRot;

///////////////////////////////////////////




	FireDir	= vector(BaseAimRot);
	HitActor = Trace(HitLocation, HitNormal, StartFireLoc + W.GetTraceRange() * FireDir, StartFireLoc, true,,,TRACEFLAG_Bullet);

    if ( (HitActor != None) && HitActor.bProjTarget )
	{
		BestTarget = HitActor;
		bNoZAdjust = true;
		OldAim = HitLocation;
		BestDist = VSize(BestTarget.Location - Pawn.Location);

        return BaseAimRot;
	}
	else
	{
		BestTarget = LastAimTarget;

        if ( BestTarget == None )
		{
			return BaseAimRot;
		}
		OldAim = StartFireLoc + FireDir * bestDist;
	}

    ShotTarget = Pawn(BestTarget);
    if ( !AimingHelp(bInstantHit) )
	{
    	return BaseAimRot;
	}

    // aim at target - help with leading also
	FireDir = BestTarget.Location - StartFireLoc;
    AimSpot = StartFireLoc + LastBestDist * Normal(FireDir);
	AimOffset = AimSpot - OldAim;

    if ( ShotTarget != None )
    {
	    // adjust Z of shooter if necessary
	    if ( bNoZAdjust )
	        AimSpot.Z = OldAim.Z;
	    else if ( AimOffset.Z < 0 )
	        AimSpot.Z = ShotTarget.Location.Z + 0.4 * ShotTarget.CylinderComponent.CollisionHeight;
	    else
	        AimSpot.Z = ShotTarget.Location.Z - 0.7 * ShotTarget.CylinderComponent.CollisionHeight;
    }
    else
	    AimSpot.Z = OldAim.Z;

	// if not leading, add slight random error ( significant at long distances )
	if ( !bNoZAdjust )
	{
		AimRot = rotator(AimSpot - StartFireLoc);
		if ( FOVAngle < DefaultFOV - 8 )
			AimRot.Yaw = AimRot.Yaw + 200 - Rand(400);
		else
			AimRot.Yaw = AimRot.Yaw + 375 - Rand(750);
		return AimRot;
	}
	return rotator(AimSpot - StartFireLoc);
}

simulated function bool PreventSprint()
{
	Local TPWeapon				Weapon;
	local Grenade_Persistent	curGrenade;

	Weapon = TPWeapon(Pawn.Weapon);
	if (Weapon != None)
	{
		if ( IsInState('PlayerShielding') || TPWeapon(Pawn.Weapon).IsAimDownSight() || PlayerPawn(Pawn).bIsCrouched )
			return true;

		// if our current weapon is a grenade, and it is either equipping or being put down, then we mustn't equip a new grenade.
		curGrenade = Grenade_Persistent(Pawn.Weapon);

		if ( curGrenade != none )
		{
			if ( curGrenade.GetStateName() == 'GrenadeThrow' )
				return false;
			else
				return true;
		}

		return TPWeapon(Pawn.Weapon).IsFiring();
	}
	else
		return IsInState('PlayerShielding') || PlayerPawn(Pawn).bIsCrouched;
}

exec function Sprint()
{
	PreventedFromSprinting = false;

    if (PreventSprint())
    {
		PreventedFromSprinting = true;
        return;
	}

	FadeInHUD();
    bSprint = true;

	CurrSprintTime = 0.0f;

    //PlayerPawn(Pawn).PlaySprintSoundTimer(true);
}

exec function StopSprint()
{
	PreventedFromSprinting = false;

    if (bSprint)
    {
        bSprint = false;
	    SetSprinting(false);
	    if (Pawn.Weapon != None && TPWeapon(Pawn.Weapon).IsInState('ActiveSprinting'))
            TPWeapon(Pawn.Weapon).GoToState('Active');
        PlayerPawn(Pawn).PlaySprintSoundTimer(false);

	    if (WorldInfo.NetMode == NM_Standalone)
		    Achievements.ClientAddToSprintTime(CurrSprintTime);
    }
}

/* CycleGrenade()
- If there's no grenade equipped, equip one
- Otherwise, cycle to the next grenade
*/
exec function CycleGrenade()
{
	/*if ( WorldInfo.Pauser!=None )
		return;

	// Change to first person if not already
	if(bIsThirdPerson)
       ServerCamera('1st');

	if(Pawn.InvManager != None)
	{
		TPInventoryManager(Pawn.InvManager).CycleGrenade();
	}*/
}

/* PrevWeapon()
- switch to previous inventory group weapon
*/
exec function PrevWeapon()
{
	local TPWeapon CurrentWeapon;

	if (Pawn == none)
		return;

	CurrentWeapon = TPWeapon( Pawn.Weapon );
	/*if (WorldInfo.NetMode != NM_Standalone)
	{
		if (myHUD.bShowScores)
		{
			if (Pawn.PlayerReplicationInfo.Team.TeamIndex == 1)
			{
				LocalPlayer(Player).ViewportClient.UIController.OpenScene(UIScene'UI_MPMenus.TPAcceptDialog', LocalPlayer(Player));
			}
			return;
		}
	}*/

    if (PrevWeaponOnGrenade != None)  // in the middle of throwing a grenade
        return;

    if (!Pawn.bCollideWorld)  // ie. when shimmying
        return;

    if ( WorldInfo.Pauser!=None || bCinematicMode )
		return;

	if (CurrentWeapon != None && (CurrentWeapon.bWeaponIsHolstered || CurrentWeapon.IsInState('WeaponEquipping')))
		return;
		
	if ( Pawn != none && Pawn.Weapon != None && TPWeapon(Pawn.Weapon).IsReloading() )
	{
		;
		return;
	}
		

	FadeInHUD();
	// Change to first person if not already
	if(bIsThirdPerson)
       ServerCamera('1st');

    if ( Pawn.Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}

	if ( Pawn.InvManager != None )
		Pawn.InvManager.PrevWeapon();
}

/* NextWeapon()
- switch to next inventory group weapon
*/
exec function NextWeapon()
{
	local TPWeapon CurrentWeapon;

	if (Pawn == none)
		return;

	CurrentWeapon = TPWeapon( Pawn.Weapon );

	/*if (WorldInfo.NetMode != NM_Standalone)
	{
		if (myHUD.bShowScores)
		{
			if (Pawn.PlayerReplicationInfo.Team.TeamIndex == 0)
			{
				LocalPlayer(Player).ViewportClient.UIController.OpenScene(UIScene'UI_MPMenus.TPAcceptDialog', LocalPlayer(Player));
			}
			return;
		}
	}*/

    if (PrevWeaponOnGrenade != None)  // in the middle of throwing a grenade
        return;

    if (!Pawn.bCollideWorld)  // ie. when shimmying
        return;

	if (CurrentWeapon != None && (CurrentWeapon.bWeaponIsHolstered || CurrentWeapon.IsInState('WeaponEquipping')))
		return;
		
	if ( WorldInfo.Pauser!=None || bCinematicMode )
		return;

	if ( Pawn != none && Pawn.Weapon != None && TPWeapon(Pawn.Weapon).IsReloading() )
	{
		;
		return;
	}
		

	FadeInHUD();
    // Change to first person if not already
	if(bIsThirdPerson)
      ServerCamera('1st');

	if ( Pawn.Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}

	if ( Pawn.InvManager != None )
		Pawn.InvManager.NextWeapon();
}

 //
 //  Find any anim tree nodes that you need to access in the tick here
 //  and cache them in a class variable
 // return false if you cannot find a specific node
 //
simulated function bool AllAnimNodesPresent()
{
//	if (anode_AIM == none)
//	{
//		anode_AIM = AnimNodeAimOffset(Pawn.Mesh.Animations.FindAnimNode('AIM_NODE'));
//		if (anode_AIM == none)
//		{
//			`log("Cannot find player anim node named 'AIM_NODE'!!");
//			return false;
//		}
//
//
//	}

	/*if (anode_AIM_FPS == none)
	{
		anode_AIM_FPS = AnimNodeAimOffset(Pawn.Mesh.Animations.FindAnimNode('FirstPerson_AIM'));
		if (anode_AIM_FPS == none)
		{
			`log("Cannot find player anim node named 'FirstPerson_AIM'!!");
			return false;
		}
	}
	*/

	//if (Role < Role_Authority)
	//{
		/*if (skel_HeadTrack == none)
		{
			skel_HeadTrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));
			if (skel_HeadTrack == none)
			{
				`log("Cannot find sleketal control node named 'HeadTrack'!!");
				return false;
			}
		}*/

	//	if( skel_LeftHandIK == none)
	//	{
	//		skel_LeftHandIK = SkelControlLimb(Pawn.Mesh.FindSkelControl('LeftHandIK'));
	//		if( skel_LeftHandIK == none)
	//		{
	//			`log("Cannot find sleketal control node named 'LeftHandIK'!!");
	//			return false;
	//		}
	//
	//		bLeftHandIK = true;
	//
	//	}


		//  if (skel_GunAim == none)
		//  {
		//     skel_GunAim = SkelControlLookAt(Pawn.Mesh.FindSkelControl('GunAim'));
		//     if (skel_GunAim == none)
		//     {
		//    	`log("Cannot find sleketal control node named 'GunAim'!!");
		//     	return false;
		//     }
		//   	skel_GunAim.BlendInTime = 0.2;
		//	skel_GunAim.BlendOutTime = 0.2;
		//
		//  }


		/*if (anode_WalkRate == none)
		{
			anode_WalkRate = AnimNodeScalePlayRate(Pawn.Mesh.Animations.FindAnimNode('WFwdSpeedCtrl'));
			if (anode_WalkRate == none)
			{
				`log("Cannot find player anim node named 'WFwdSpeedCtrl'!!");
				return false;
			}
		}*/

		/*if (anode_speedBlend == none)
		{
			anode_speedBlend  = TPAnimBlendBySpeed(Pawn.Mesh.Animations.FindAnimNode('IdleWalkSpeedBlend'));
			if (anode_speedBlend == none)
			{
				`log("Cannot find player anim node named 'IdleWalkSpeedBlend'!!");
				return false;
			}
		}*/

	//	if (anode_speedBlend != none)
	//	{
	//		if (anode_speedBlend.synchNode == none)
	//		{
	//			anode_speedBlend.synchNode =  AnimNodeSynch(Pawn.Mesh.Animations.FindAnimNode('SyncSingleton'));
	//			if (anode_speedBlend.synchNode == none)
	//			{
	//				`log("==============================================================================Cannot find SYNCH NODE");
	//			//	anode_speedBlend.synchNode.Children(1);
	//				return false;
	//			}
	//		}
	//	}


		/*if( skel_SpinePitch == None )
		{
			skel_SpinePitch  = TPSkelControlPlayerPitch(Pawn.Mesh.FindSkelControl('SpinePitch'));
			if (skel_SpinePitch == none)
			{
				`log("Cannot find player anim node named 'SpinePitch'!!");
				return false;
			}

			skel_SpinePitch.ControlStrength = 1.0;

			skel_SpinePitch.BlendInTime = 0.2;
			skel_SpinePitch.BlendOutTime = 0.2;

		}

		if( skel_SpineRoll == None )
		{
			skel_SpineRoll  = TPSkelControlPlayerRoll(Pawn.Mesh.FindSkelControl('SpineRoll'));
			if (skel_SpineRoll == none)
			{
				`log("Cannot find player anim node named 'SpineRoll'!!");
				return false;
			}

			skel_SpineRoll.ControlStrength = 1.0;

			skel_SpineRoll.BlendInTime = 0.2;
			skel_SpineRoll.BlendOutTime = 0.2;

		}*/

		/*if( anode_WeaponBlend == none)
		{
			anode_WeaponBlend = AnimNodeBlend(Pawn.Mesh.Animations.FindAnimNode('WeaponBlend'));
			if(anode_WeaponBlend == none)
			{
			`log("Cannot find player anim node named 'WeaponBlend'!!");
			return false;
			}
		}*/

		/*if( anode_CrouchWeaponBlend == none)
		{
			anode_CrouchWeaponBlend = AnimNodeBlend(Pawn.Mesh.Animations.FindAnimNode('CrouchWeaponBlend'));
			if(anode_CrouchWeaponBlend == none)
			{
			`log("Cannot find player anim node named 'CrouchWeaponBlend'!!");
			return false;
			}
		}

		if( anode_PostureBlend == none)
		{
			anode_PostureBlend = AnimNodeBlend(Pawn.Mesh.Animations.FindAnimNode('PostureBlend'));
			if(anode_PostureBlend == none)
			{
			`log("Cannot find player anim node named 'PostureBlend'");
			return false;
			}
		}*/

		/*if (anode_HangBlend == none)
		{
			anode_HangBlend = AnimNodeBlend(Pawn.Mesh.Animations.FindAnimNode('HangBlend'));
			if (anode_HangBlend == none)
			{
			`log("Cannot find player anim node named 'HangBlend'");
			return false;
			}

			anode_HangBlend.SetBlendTarget(0.0, 0.0);
		}*/
	//}


	return true;
}

// Overriden from base class in order to set player pawn's physics and not the controller physics!
simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
    //Super.OnSetPhysics(Action);
	Pawn.SetPhysics( Action.NewPhysics );
}

function PlayerPawn GetPlayerPawn()
{
	local PlayerPawn lPlayerPawn;
	local Vehicle lVehicle;

	lPlayerPawn = PlayerPawn(Pawn);
	if (lPlayerPawn == None)
	{
		lVehicle = Vehicle(Pawn);
		if (lVehicle != None)
		{
			lPlayerPawn = PlayerPawn(lVehicle.Driver);
		}
	}

	return lPlayerPawn;
}

// Tries to	find a vehicle to drive	within a limited radius. Returns the vehicle if	successful
function Vehicle FindVehicle()
{
	local Vehicle V, Best;
	local vector ViewDir, PawnLoc2D, VLoc2D, VehicleDir, DeltaPos;
	local float	NewDot,	BestDot, VehicleDot;

	if (Vehicle(Pawn.Base) != None	&& Vehicle(Pawn.Base).CanEnterVehicle(Pawn))
	{
		return Vehicle(Pawn.Base);
	}

	// Pick	best nearby	vehicle
	PawnLoc2D =	Pawn.Location;
	PawnLoc2D.Z	= 0;
	ViewDir	= vector(Pawn.Rotation);

	ForEach	Pawn.OverlappingActors(class'Vehicle', V, Pawn.VehicleCheckRadius)
	{
		if (!V.CanEnterVehicle(Pawn))
			continue;

		// Prefer vehicles that	Pawn is	facing
		VLoc2D = V.Location;
		Vloc2D.Z = 0;
		DeltaPos = Normal(VLoc2D-PawnLoc2D);
		NewDot = DeltaPos Dot ViewDir;
		if (NewDot > 0 && ((Best ==	None) || (NewDot > BestDot)))
		{
			// If this is a turret, we must also be behind the turret
			if (V.IsA('Turret'))
			{
				VehicleDir = vector(V.Rotation);
				VehicleDot = DeltaPos Dot VehicleDir;
				if (VehicleDot < 0)
					continue;
			}
			// check that vehicle is visible
			if (FastTrace(V.Location,Pawn.Location))
			{
				Best = V;
				BestDot	= NewDot;
			}
		}
	}
	return Best;
 }

/** Tries to find a vehicle to drive within a limited radius. Returns true if successful */
// Overrides the original in PlayerController to ensure that the behavior of the icon & the action match
function bool FindVehicleToDrive()
{
	local Vehicle Best;

	Best = FindVehicle();

	if (Best != None)
		return Best.TryToDrive(Pawn);

	return FALSE;
}

reliable client function SetMPGameState(MultiplayerGameState gameState)
{
	mpGameState = gameState;
}

unreliable client function SyncWithServerTime(int elapsed, int remaining)
{
	timeRemaining = remaining;
	timeElapsed = elapsed;
}

simulated function int FindSoundGroupByName(name soundgroupName)
{
	local int i;

	for ( i = 0 ; i < soundDucking.Length ; i++ )
	{
		if ( soundDucking[i].channelName == soundgroupName )
			return i;
	}

	return -1;
}

simulated function InitializeMasterSoundgroups()
{
	local int tier;
	local int channelID;
	local int soundgroupID;

	tier = 8; // The number of master Channels we have
	channelID = 0;

	// Must populate in Reverse Tier Order to prevent having to do a sort()

    // Special_Bomb_MiniGame , Tier 8
	soundgroupID										= FindSoundGroupByName( name("Special_Bomb_MiniGame") );
	soundDucking[soundGroupID].isMaster					= true;
	masterSoundChannels.Insert(channelID, 1);
	masterSoundChannels[channelID].soundgroupID			= soundGroupID;
	masterSoundChannels[channelID].tier					= tier--;
	masterSoundChannels[channelID].masterDuckingFactor	= 1.0;
	masterSoundChannels[channelID].individualDuckingFactor.Insert(0, 2);
	masterSoundChannels[channelID].individualDuckingFactor[0].channelName	= 'Music';
	masterSoundChannels[channelID].individualDuckingFactor[0].duckingFactor = 0.85;
	masterSoundChannels[channelID].individualDuckingFactor[1].channelName	= 'Props_Vehicles';
	masterSoundChannels[channelID].individualDuckingFactor[1].duckingFactor = 0.85;
	masterSoundChannels[channelID++].slaveDuckingFactor	= 0.9;

    // Foley_Grapple , Tier 7
	soundgroupID										= FindSoundGroupByName( name("Foley_Grapple") );
	soundDucking[soundGroupID].isMaster					= true;
	masterSoundChannels.Insert(channelID, 1);
	masterSoundChannels[channelID].soundgroupID			= soundGroupID;
	masterSoundChannels[channelID].tier					= tier--;
	masterSoundChannels[channelID].masterDuckingFactor	= 1.0;
	masterSoundChannels[channelID].individualDuckingFactor.Insert(0, 6);
	masterSoundChannels[channelID].individualDuckingFactor[0].channelName	= 'Foley_Grapple_Movement';
	masterSoundChannels[channelID].individualDuckingFactor[0].duckingFactor = 1.0;
	masterSoundChannels[channelID].individualDuckingFactor[1].channelName	= 'Dialog_Vocal';
	masterSoundChannels[channelID].individualDuckingFactor[1].duckingFactor = 1.0;
	masterSoundChannels[channelID].individualDuckingFactor[2].channelName	= 'Dialog_Player';
	masterSoundChannels[channelID].individualDuckingFactor[2].duckingFactor = 1.0;
	masterSoundChannels[channelID].individualDuckingFactor[3].channelName	= 'Music';
	masterSoundChannels[channelID].individualDuckingFactor[3].duckingFactor = 0.8;
	masterSoundChannels[channelID].individualDuckingFactor[4].channelName	= 'Weapons_Fire_NPC';
	masterSoundChannels[channelID].individualDuckingFactor[4].duckingFactor = 0.75;
	masterSoundChannels[channelID].individualDuckingFactor[5].channelName	= 'DST_Projectiles';
	masterSoundChannels[channelID].individualDuckingFactor[5].duckingFactor = 0.65;
	masterSoundChannels[channelID++].slaveDuckingFactor	= 0.9;

    // Weapons_Fire_Special , Tier 6
	soundgroupID										= FindSoundGroupByName( name("Weapons_Fire_Special") );
	soundDucking[soundGroupID].isMaster					= true;
	masterSoundChannels.Insert(channelID, 1);
	masterSoundChannels[channelID].soundgroupID			= soundGroupID;
	masterSoundChannels[channelID].tier					= tier--;
	masterSoundChannels[channelID].masterDuckingFactor	= 1.0;
	masterSoundChannels[channelID].individualDuckingFactor.Insert(0, 2);
	masterSoundChannels[channelID].individualDuckingFactor[0].channelName	= 'Music';
	masterSoundChannels[channelID].individualDuckingFactor[0].duckingFactor = 0.9;
	masterSoundChannels[channelID].individualDuckingFactor[1].channelName	= 'DST_Projectiles';
	masterSoundChannels[channelID].individualDuckingFactor[1].duckingFactor = 0.75;
	masterSoundChannels[channelID++].slaveDuckingFactor	= 0.85;

	// Weapons_Fire , Tier 5
	soundgroupID										= FindSoundGroupByName( name("Weapons_Fire") );
	soundDucking[soundGroupID].isMaster					= true;
	masterSoundChannels.Insert(channelID, 1);
	masterSoundChannels[channelID].soundgroupID			= soundGroupID;
	masterSoundChannels[channelID].tier					= tier--;
	masterSoundChannels[channelID].masterDuckingFactor	= 1.0;
	masterSoundChannels[channelID].individualDuckingFactor.Insert(0, 2);
	masterSoundChannels[channelID].individualDuckingFactor[0].channelName	= 'Music';
	masterSoundChannels[channelID].individualDuckingFactor[0].duckingFactor = 0.9;
	masterSoundChannels[channelID].individualDuckingFactor[1].channelName	= 'DST_Projectiles';
	masterSoundChannels[channelID].individualDuckingFactor[1].duckingFactor = 1.1;
	masterSoundChannels[channelID++].slaveDuckingFactor	= 0.9;

	// Dialog_Radio , Tier 4
	soundgroupID										= FindSoundGroupByName( name("Dialog_Radio") );
	soundDucking[soundGroupID].isMaster					= true;
	masterSoundChannels.Insert(channelID, 1);
	masterSoundChannels[channelID].soundgroupID			= soundGroupID;
	masterSoundChannels[channelID].tier					= tier--;
	masterSoundChannels[channelID].masterDuckingFactor	= 0.9;
	masterSoundChannels[channelID++].slaveDuckingFactor	= 0.85;

	// Dialog_Scene , Tier 3
	soundgroupID										= FindSoundGroupByName( name("Dialog_Scene") );
	soundDucking[soundGroupID].isMaster					= true;
	masterSoundChannels.Insert(channelID, 1);
	masterSoundChannels[channelID].soundgroupID			= soundGroupID;
	masterSoundChannels[channelID].tier					= tier--;
	masterSoundChannels[channelID].masterDuckingFactor	= 0.9;
	masterSoundChannels[channelID++].slaveDuckingFactor	= 0.85;

    // Special_Shell_Shock , Tier 2
	soundgroupID										= FindSoundGroupByName( name("Special_Shell_Shock") );
	soundDucking[soundGroupID].isMaster					= true;
	masterSoundChannels.Insert(channelID, 1);
	masterSoundChannels[channelID].soundgroupID			= soundGroupID;
	masterSoundChannels[channelID].tier					= tier--;
	masterSoundChannels[channelID].masterDuckingFactor	= 0.35;
	masterSoundChannels[channelID].individualDuckingFactor.Insert(0, 4);
	masterSoundChannels[channelID].individualDuckingFactor[0].channelName	= 'Ambient';
	masterSoundChannels[channelID].individualDuckingFactor[0].duckingFactor = 1.0;
	masterSoundChannels[channelID].individualDuckingFactor[1].channelName	= 'Ambient_Cues';
	masterSoundChannels[channelID].individualDuckingFactor[1].duckingFactor = 1.0;
	masterSoundChannels[channelID].individualDuckingFactor[2].channelName	= 'Music';
	masterSoundChannels[channelID].individualDuckingFactor[2].duckingFactor = 1.0;
	masterSoundChannels[channelID].individualDuckingFactor[3].channelName	= 'Props_Vehicles';
	masterSoundChannels[channelID].individualDuckingFactor[3].duckingFactor = 1.0;
	masterSoundChannels[channelID++].slaveDuckingFactor	= 0.25;

    // Special_Scene , Tier 1
	soundgroupID										= FindSoundGroupByName( name("Special_Scene") );
	soundDucking[soundGroupID].isMaster					= true;
	masterSoundChannels.Insert(channelID, 1);
	masterSoundChannels[channelID].soundgroupID			= soundGroupID;
	masterSoundChannels[channelID].tier					= tier--;
	masterSoundChannels[channelID].masterDuckingFactor	= 0.9;
	masterSoundChannels[channelID].individualDuckingFactor.Insert(0, 2);
	masterSoundChannels[channelID].individualDuckingFactor[0].channelName	= 'Dialog_Scene';
	masterSoundChannels[channelID].individualDuckingFactor[0].duckingFactor = 1.0;
	masterSoundChannels[channelID].individualDuckingFactor[1].channelName	= 'Music';
	masterSoundChannels[channelID].individualDuckingFactor[1].duckingFactor = 0.9;
	masterSoundChannels[channelID++].slaveDuckingFactor	= 0.7;


}

simulated function InitializeSlaveSoundgroups()
{
	local int i;

	// Iterate through all sound groups.
	for ( i = 0 ; i < soundDucking.Length ; i++ )
	{
		// Does this soundgroup have the name MASTER in it  ( could also check if we have a childgroupname to traverse, but this works easily)
		if ( InStr(soundDucking[i].channelName, "MASTER") != -1 )
			soundDucking[i].isSlave = false;
		else if ( string(soundDucking[i].channelName) ~= "MASTER" )	// this should work for the top case, but isn't
			soundDucking[i].isSlave = false;
		else if ( !soundDucking[i].isMaster )
			soundDucking[i].isSlave = true;
	}

}

simulated function FindActiveMasterSoundgroup()
{
	// SPARK CODEDROP - Fixed up soundgroup spammage
	local MasterSoundChannel msc;
	local int i;
	local name sgName;

	if ( soundducking.Length == 0 )
		return;

	activeMasterID = -1;

	// SPARK CODEDROP - Fixed up soundgroup spammage
	for ( i = 0 ; i < masterSoundChannels.Length ; i++ )
	{
		msc = masterSoundChannels[i];
		sgName = soundducking[ msc.soundgroupID ].channelName;
		// since the tier is in ascending order, we don't need to check to see if the prev master was "higher" priority
		if ( GetSoundGroupIsPlaying( sgName ) )
			activeMasterID = i;
	}

}

simulated function QueryActiveSoundgroups()
{
	local int masterID;
	local int soundgroupID;

	// Reset our active master channel from last frame.
	activeMasterID = -1;

	// Sound Ducking must be active in order to query the master channel
	if ( soundDucking.Length <= 0 )
		return;

	// Iterate through all sound groups.
	for ( masterID = 0 ; masterID < masterSoundChannels.Length ; masterID++ )
	{
		soundgroupID = masterSoundChannels[ masterID ].soundgroupID;
		soundDucking[soundgroupID].isPlayingSound = GetSoundGroupIsPlayingFromID( soundgroupID );	// resolve to masterSoundChannels

		if ( soundDucking[soundgroupID].isPlayingSound )
			activeMasterID = masterID;
	}
}

simulated function CalculateSoundDucking()
{
	local int i, j;
	local MasterSoundChannel msc;

	if ( activeMasterID == -1 )
		return;

	msc = masterSoundChannels[activeMasterID];

	for ( i = 0 ; i < soundDucking.Length ; i++ )
	{
		if ( msc.soundgroupID == i )
			continue;

		// Is this an indidividually ducked channel
		for ( j = 0; j < msc.individualDuckingFactor.length; j++ )
		{
			if ( soundDucking[i].channelName == msc.individualDuckingFactor[j].channelName  )
			{
				soundDucking[i].duckLevel *= msc.individualDuckingFactor[j].duckingFactor;
				soundDucking[i].wasIndividuallyDucked = true;
				continue;
			}

		}

			// Ignore all other ducking for this channel


		if ( soundDucking[i].isSlave )
		{
			soundDucking[i].duckLevel	*= msc.slaveDuckingFactor;

		}
		if ( soundDucking[i].isMaster )
		{
			soundDucking[i].duckLevel	*= msc.masterDuckingFactor;
		}

	}
}

simulated function SetSoundDucking()
{
	local int i;

	for ( i = 0 ; i < soundDucking.Length ; i++ )
	{
		// Don't set the channel's volume if it didn't change from the last time we set it
		if ( false == ( GetSoundGroupCurrentVolumeByID(i) ~= soundDucking[i].duckLevel ) )
		{
			SetAudioGroupVolumeNoParse(i, soundDucking[i].duckLevel);
		}
			
		if (soundDucking[i].iniLevel > 0.0f)
			soundDucking[i].duckLevel = soundDucking[i].duckLevel / soundDucking[i].iniLevel;
		else
			soundDucking[i].duckLevel = 0.0f;
	}

	// Set the master sound group volume and force it to multiply into new sound group volumes now that all children have been set.
	if ( soundDucking.Length > 0 )
		SetAudioGroupVolume(soundDucking[0].channelName, soundDucking[0].duckLevel);
	

}

simulated function UpdateSoundDucking()
{
	local int i;
	// iterate through
	for ( i = 0 ; i < soundDucking.Length ; i++ )
	{
		soundDucking[i].curLevel				= soundDucking[i].iniLevel;
		// Set to curLevel initially
		soundDucking[i].duckLevel				= soundDucking[i].curLevel;
		soundDucking[i].wasIndividuallyDucked	= false;

	}

	//FindActiveMasterSoundgroup(); // Slower functionality compared to QueryActiveSoundgroups()
	QueryActiveSoundgroups();

	// Calculate Ducking
	CalculateSoundDucking();

	SetSoundDucking();


}
//
// Logic tick for the player controller. Just updates physics weapon logic
//
simulated function PlayerTick(float DeltaTime)
{
    local float fVel;
	local vector	CamLoc;
	local rotator	CamRot;
	//local float fDot;

	//local vector vCamDir,vPawnDir;

	local TPDroppedPickup CheckedPickup;
	local vector X, Y, Z;
	local float DistanceToPickup;
	local vector Start, End, HitNormal, HitLocation;
	local Vehicle CloseVehicle;

    local PlayerPawn        thePlayerPawn;
    local TPPawn			lTPPawn;
	local TPGameReplicationInfo TPGRI;

	local TPGameViewportClient viewport;

	// Granny & camper var.s
	local vector newPos, delta;

	if ( bSystemPauseRequested )
	{
		if ( !bGamePausedBySystemRequest )
		{
			if( TPPauseMenu() )
			{
				// Save the viewport show flags and have it show nothing...
				//SetViewportPauseShowFlags();
				
				bGamePausedBySystemRequest = true;
				// Cancel any other pause request
				bPauseRequested = false;
				;
			}
		}
	}

	if( bPauseRequested && !bSystemPauseRequested && !bGamePausedBySystemRequest)
	{
		if( TPPauseMenu() )
		{
			;
			bPauseRequested = false;
		}
	}


	if ( myHUD.bShowDebugInfo )
	{
		myHUD.bShowHUD = false;
	}
	else
	{
		myHUD.bShowHUD = true;
	}

	if ( WorldInfo.NetMode != NM_Standalone )
	{
		netPerformance.DeltaTime += DeltaTime;
		netPerformance.numFrames++;

		if ( netPerformance.DeltaTime > 15 )
		{
			netPerformance.FPS = netPerformance.numFrames / netPerformance.DeltaTime;
			netPerformance.numFrames = 0;
			netPerformance.DeltaTime = 0;

		}
		
	}

	// The player has not yet picked up a weapon.  Add to his pickup time guard.  A player may only pick
	// pick up 1 weapon per second to guard against "juggling"
	pickupTime += DeltaTime;

	TPGRI = TPGameReplicationInfo(WorldInfo.GRI);
	if (TPGRI != none)
	{
	if ( TPGRI.GameStatus == GS_GameInProgress || TPGRI.GameStatus == GS_PostGame)
	{
		timeRemaining -= DeltaTime;
		timeElapsed += DeltaTime;
		if (timeRemaining <= 0)
			timeRemaining = 0;
	}

	if ( TPGRI.GameStatus == GS_PreGame )
	{
		timeRemaining += DeltaTime;
		timeElapsed += DeltaTime;
	}
	}

    // Get the playerpawn's goodness
    thePlayerPawn = GetPlayerPawn();

    // Initialize stuff for campers
   	super.PlayerTick(DeltaTime);

	// SP Presence stuff
	if (WorldInfo.NetMode == NM_Standalone && bSPMapNameDirty)
	{
		SetSPPresence();
	}

   	if (thePlayerPawn != None)
   	{
   		// Check for an unmoving player
   		newPos = thePlayerPawn.Location;
   		delta = newPos - LastPlayerPos;
   		LastPlayerPos = newPos;

		// If we are firing, we should not be allowed to sprint ( happens when you press sprint + fire at same time )
		if ( bSprint && PreventSprint() )
			StopSprint();

   		if (VSizeSq(delta) < MIN_PLAYER_MOVE_DIST_SQ)
   		{
   			TimeSinceLastMove += DeltaTime;
   		}
   		else // Clear the timer now that we're moving again
   		{
   			TimeSinceLastMove = 0;
   		}

   		if (TimeSinceLastMove > CampTime)
   		{
   			// If the flag was already set, then we don't need to do anything
   			// Otherwise, set flag in the pawn and trigger the event
   			if (!m_bCamper)
   			{
   				m_bCamper = TRUE;
   				TriggerEventClass(class'SeqEvent_Camper', thePlayerPawn, 0);
   				//`Log("Camper Move or you will die");
   			}
   		}
   		else
   		{
   			// If the flag was set, then clear it and send the no longer camping event
   			if (m_bCamper)
   			{
   				m_bCamper = FALSE;
   				TriggerEventClass(class'SeqEvent_Camper', thePlayerPawn, 1);
   			}
   		}
   	}

	if (bReload == 1 && !bReloadGrabbedWeapon)
	{
		ReloadButtonHeldTime += DeltaTime;

		// Do not allow a player to pick up a weapon if they recently picked up a weapon to prevent juggling
		if ( pickuptime > 1.0 && ReloadButtonHeldTime > SwitchWeaponTime && TpHUD(myHUD) != none && TpHUD(myHUD).bPickup && Pawn.bCanPickupInventory )	// PR 4172 - Added switchweapon time bac
		{
			PickupWeapons();	// This is a reliable server function, therefore its return value is invalid, don't check against it.
			pickuptime = 0.0;	// This player will have to wait a full second before picking up a weapon again.

			FadeInHUD();
			TpHUD(myHUD).bPickup=false;
			bReloadGrabbedWeapon=true;
			ReloadButtonHeldTime=0.0f;
		}

	}

	//if ( Pawn.Weapon == None )
	//	return;

	if (Pawn != None)
	{
		// Update our sound ducking channels
		if ( pawn.IsLocallyControlled() )// we are local
		{
			UpdateSoundDucking();
			if (!bLocalCacheOfProfileUpdated && GetCurrentLevelName() != "entry_master")
			{
				UpdateLocalCacheOfProfileSettings();
			}
		}

		if (WorldInfo.NetMode == NM_Standalone)
		{
			if (bSprint && VSize(Pawn.Velocity)> 0.0)
			{
				//`log(self @ "I'm sprinting!" @ CurrSprintTime);
				CurrSprintTime += DeltaTime;
			}

			Achievements.ClientUpdateGrenadeTimer(DeltaTime);
		}

		lTPPawn = TPPawn(Pawn);

		// If the player is dead (or dying), then don't display any of the various indicators
		if (thePlayerPawn.bShellShockKillPlayer)
		{
			TpHUD(myHUD).bShowHud	= false;

			TpHUD(myHUD).bPickup				= false;
			thePlayerPawn.PendingPickupFactory	= None;

			// Also ensure that any tutorials are closed
			if (!bWasPlayerDead)
			{
		       GetUIController().CloseScene(TutorialScene);
		       ClearObjectives();
		       bWasPlayerDead = TRUE;
			}
		}

		if (bSnapWall)
        {
            // After snapping to wall at end of animation, rotation seems
            // to be applied so snap here...
            lTPPawn.SnapToWall (ShimmyDirection, 0);
            lTPPawn.ShimmyToggle=true;
            bSnapWall = false;
        }

		// Do ray check and grab actor
		GetAxes( Rotation, X, Y, Z );

		Start	= Pawn.GetPawnViewLocation();
		End		= Start + (LookAtPickupDistance * X);

		TpHUD(myHUD).bPickup=false;  // kking - reset Pickup flag
        if (Pawn.bCanPickupInventory)
        {
		    foreach TraceActors(class'TPDroppedPickup',CheckedPickup, HitLocation,HitNormal, End, Start, vect(1,1,1))
		    {
                if (Pawn.InvManager.FindInventoryType(CheckedPickup.TPSPInventoryClass) == None)
                {
			        thePlayerPawn.PendingPickup = CheckedPickup;
			        TpHUD(myHUD).PickupText=CheckedPickup.GetPickupName ();
			        TpHUD(myHUD).bPickup=true;
			        break;
                }
		    }
        }

		End		= Start + (PickupDistance * X);

		if
		(
			thePlayerPawn.PendingPickup != None && // some of these are weapons
			thePlayerPawn.PendingPickup.IsA('TPDroppedPickupWeapon') && 
			thePlayerPawn.IsUsingHumanShield()
		)
		{
			TpHUD(myHUD).bPickup        = false;
			thePlayerPawn.PendingPickup = None;
			bDontNotifyClientPickup     = false;
		}
		if 
		(
			thePlayerPawn.PendingPickupFactory != None && // all of these are weapons
			thePlayerPawn.IsUsingHumanShield())
		{
			TpHUD(myHUD).bPickup               = false;
			thePlayerPawn.PendingPickupFactory = None;
			bDontNotifyClientPickup            = false;
		}

		if (thePlayerPawn.PendingPickup != None && CheckedPickup == none)
        {
			// Added by Ryan for Trace Pickup
			DistanceToPickup = VSize(thePlayerPawn.PendingPickup.Location - Pawn.Location);

			if (DistanceToPickup < PickupDistance)
			{
				TpHUD(myHUD).bPickup=true;
			}
			else
            {
                TpHUD(myHUD).bPickup		= false;
                thePlayerPawn.PendingPickup = None;
				bDontNotifyClientPickup		= false;
            }
        }
		if (thePlayerPawn.PendingPickupFactory != None)
        {
			// Added by Ryan for Trace Pickup
			DistanceToPickup = VSize(thePlayerPawn.PendingPickupFactory.Location - Pawn.Location);

			if (DistanceToPickup < PickupDistance)
			{
				TpHUD(myHUD).bPickup=true;
			}
			else
            {
                TpHUD(myHUD).bPickup				= false;
                thePlayerPawn.PendingPickupFactory	= None;
				bDontNotifyClientPickup				= false;
				// kmsk
            }
        } 

		if (lTPPawn != None && !lTPPawn.bIsCrouched && Pawn.Physics == PHYS_Walking &&
			lTPPawn.LadderAction == LA_None && !thePlayerPawn.ToStandInProgress() &&
            (lTPPawn.CanEnterLadderFromTop ( ) ||
             lTPPawn.CanEnterLadderFromBottom ( )))
        {
            TpHUD(myHUD).bLadderPrompt=true;
        }
        else
        {
            TpHUD(myHUD).bLadderPrompt=false;
        }

        if (CurrentPipeVolume != None && !IsInState('PlayerPiping'))
            TpHUD(myHUD).bPipePrompt=true;
        else
            TpHUD(myHUD).bPipePrompt=false;


		PlayerCamera.GetCameraViewPoint(CamLoc,CamRot);
		CamRot += TPPlayerCamera(PlayerCamera).OffsetRotation;

		fVel = VSize(Pawn.Velocity);

 		if (thePlayerPawn != None)
 		{
			if (fVel<WalkLoopDistance)
			{
				thePlayerPawn.anode_WalkRate.ScaleByValue = fVel/WalkLoopDistance;
			}
			else if	( fVel < RunLoopDistance )
			{
				thePlayerPawn.anode_WalkRate.ScaleByValue = fVel/RunLoopDistance;
			}
			else if	( fVel < SprintLoopDistance	)
			{
				thePlayerPawn.anode_WalkRate.ScaleByValue = fVel/SprintLoopDistance;
			}
		}

  // 		if( GrappleOpponent == none )
  // 		{
  // 			if( FindEnemyToGrapple( GrappleOpponent ) )
  // 			{
  // 				//`log(self @ "I want to grapple" @ GrappleOpponent);
  // 				GrapInt.EnablePrompt( self, TPWehrmachtAIController(GrappleOpponent.Controller));
  // 			}
  // 		}
  // 		else
		//{

		//	if ( IsEnemyGrappleable( GrappleOpponent ) == false )
		//	{
		//		GrapInt.CancelPrompt();
		//		GrappleOpponent = None;
		//	}

		//	if( FindEnemyToBluff( BluffOpponent ) )
		//	{
		//		//`log(self @ "I want to bluff" @ BluffOpponent);

		//		//BluffOpponentController = TPWehrmachtAIController(BluffOpponent.Controller); //get rid of this
		//		BluffInt.EnablePrompt( self, TPWehrmachtAIController(BluffOpponent.Controller));
		//	}
		//	if( BluffOpponent!=None )
		//	{
		//		// Added additional check to see if you are facing away from the bluff opponent.
		//		if( !IsEnemyBluffable(BluffOpponent) || VSize( BluffOpponent.Location - Pawn.Location ) > `BLUFF_CHECK_RADIUS*1.5f  || vector(Pawn.Rotation) dot Normal(BluffOpponent.Location - Pawn.Location) < 0)
		//		{
		//			//We have walked away from the prompting opponent, or he stopped being bluffable
		//			BluffInt.CancelPrompt();
		//			BluffOpponent = None;
		//		}
		//	}

		//}

		if( m_bWaitingForLatentMovieToFinish )
		{
		    viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
			// checking on movie
			if ( viewport != none && (viewport.FullScreenIsMoviePlaying(m_LatentMovieAction.MovieName) == false ) )
			{
				EndPlayMovieLatentAction();
			}
		}

 		// Check for other interactible items (e.g. vehicles)
 		TpHUD(myHUD).bUseButton = false;

 		// If we're driving a vehicle (i.e. we really are a vehicle) then there
 		// should be a prompt to exit.
 		if (Pawn.IsA('Vehicle'))
 		{
 		}
 		else
 		{
 			CloseVehicle = FindVehicle();
 			if (CloseVehicle !=	None)
 			{
				if (TPBaseVehicle(CloseVehicle) == none)
				{
	 				// Add some	form of	useful text	here...
 					TpHUD(myHUD).bUseButton	= true;
 				}
 			}
		}
	}
}

exec function ChangeFireType()
{
	//if (Pawn.Weapon != None)
	//{
	//	TPWeapon(Pawn.Weapon).ChangeFireTypes();
	//	TPHUD(myHud).bRenderWeaponFireTypes = true;
	//	TPHUD(myHud).WeaponFireTypeAlpha = 255;
	//}
}


//exec function TickPatfinder()
//{
//    TPPawn(Pawn).GetAISystem().DEBUG_PathFinderTick();
//}
//
//exec function PatfindForward()
//{
//    local vector TestPos;
//
//    TestPos = Pawn.Location +  vector(Pawn.Rotation)*2000;
//    TPPawn(Pawn).GetAISystem().DEBUG_PathfindTO(TestPos, TPPawn(Pawn).AIObject);
//}

reliable client event PlayerHang ( )
{
    GoToState ('PlayerHanging');
}

reliable client event PlayerCatch ( )
{
    local TPPlayerMovementVolume MovementVolume;
	local TPPawn TPawn;

    TPawn = TPPawn(Pawn);

    if (TPawn.MovementVolumes.Length != 0)
        MovementVolume = TPawn.MovementVolumes[TPawn.MovementVolumes.Length-1];

    TPawn.SnapToWall (-LastHitWallNormal, JumpDistance);
    DisableAimDownSight();

    TPawn.StopMovement();
    Pawn.SetPhysics(PHYS_Flying);
    //TPawn.Obstacle = OB_Catchable;
	TPawn.ClientSetObstacle(OB_Catchable);
    Pawn.bCollideWorld=false;
    bDontRotatePawn=true;

    if (MovementVolume != None && !MovementVolume.ShimmyOptions.bUseNonWalledAnimations)
    {
        bUsingWalledShimmy = true;
        PlayerPawn(Pawn).anode_HangBlend.SetBlendTarget(0.0, 0.0);
    }
    else
    {
        bUsingWalledShimmy = false;
        PlayerPawn(Pawn).anode_HangBlend.SetBlendTarget(1.0, 0.0);
    }

    //ServerCamera('FreeCam');
    //CameraMode ('FreeCam', 1);
}

simulated function PlayerStopHangingDrop ( )
{
    TPPawn(Pawn).Obstacle = OB_Dropping;
}

simulated function PlayerStopHangingClimb ( )
{
    TPPawn(Pawn).Obstacle=OB_Climbable;
    Pawn.Mesh.RootMotionMode=RMM_Translate;
}

simulated function vector PushPlayerUp(float DeltaTime)
{
    local float PrevNewLocation;
    local float Percentage;
	local vector NewAccel;
    local vector NewLocation;

    TPPawn(Pawn).StopMovement ( );

    TotalTime += DeltaTime;

    NewLocation = Pawn.Location;

    PrevNewLocation = OrigZ;
    Percentage = fclamp (TotalTime/JumpDuration, 0, 1);

    NewLocation.Z = Percentage*JumpDistance;
    OrigZ = NewLocation.Z;
    NewLocation.Z = NewLocation.Z - PrevNewLocation;

    NewLocation.Z = Pawn.Location.Z + NewLocation.Z;

    Pawn.SetLocation (NewLocation);

	NewAccel.Z = NewLocation.Z-PrevNewLocation;

	return NewAccel;
}

// Whether the user can throw a grenade
function bool CanThrowGrenade()
{
	local bool					abortGrenade;
	local Grenade_Persistent	curGrenade;

	abortGrenade = false;

	// If our current weapon is a grenade, and it is either equipping or being put down, then we mustn't equip a new grenade.
	curGrenade = Grenade_Persistent(Pawn.Weapon);
	if ( curGrenade != none )
	{
		if ( !bAllowGrenadeUse )
		{

			if ( curGrenade.GetStateName() == 'WeaponEquipping' )
				abortGrenade = true;

			if ( curGrenade.GetStateName() == 'WeaponPuttingDown' )
				abortGrenade = true;
		}
	}

	if ( bSprint == true )
		abortGrenade = true;

	if (bCinematicMode || TPWeapon(Pawn.Weapon).IsReloading() || TPWeapon(Pawn.Weapon).IsFiring() || !bAllowGrenadeUse )
	{
		abortGrenade = true;
	}

    if ( abortGrenade )
    {
		bAllowGrenadeUse = false;
        return false;
    }

	bAllowGrenadeUse = true;
	return true;

}

// Added grenade fast throw button
exec function EquipGrenade()
{
	local Inventory		W;

	bAllowGrenadeUse = true;

	if ( !CanThrowGrenade() ) 
		return;

	if (Pawn.Weapon.IsA('Grenade_Persistent'))
	{
		if (Pawn.InvManager.PendingWeapon != None)
			PrevWeaponOnGrenade = Pawn.InvManager.PendingWeapon;
		else
			PrevWeaponOnGrenade = TPInventoryManager(Pawn.InvManager).GetNextWeapon();
		;
	}
	else
		PrevWeaponOnGrenade = Pawn.Weapon;

	if ( Pawn.InvManager != None )
		W = TPInventoryManager(Pawn.InvManager).CurrentGrenade;

	FadeInHUD();

	if (W != none && (TPWeapon(W).AmmoInMagazine + TPWeapon(W).AmmoCount) > 0)
	{
        PlayerPawn(Pawn).SetUnequipAnimRate(class'Grenade_Persistent'.Default.TransitionRateMultiplier);

        if (PrevWeaponOnGrenade != W)
		{
			Pawn.InvManager.SetCurrentWeapon(Weapon(W));
		}
		else
		{
			// if our only weapon is a grenade, make sure to clear out the PrevWeaponOnGrenade
			if ( TPInventoryManager(Pawn.InvManager).NumWeaponsInInventory() == 0 )
				PrevWeaponOnGrenade = none;

			Grenade_Persistent(Pawn.Weapon).ActualCookTime = class'Grenade_Persistent'.default.CookTime;
			StartGrenadeCooking();
		}
	}
	else
	{
		;
		ClearTimer('GrenadeCookTick');
		PrevWeaponOnGrenade = none;
		bThrowGrenade = true;
	}
}

exec function FastThrowGrenade()
{
	 if ( !CanThrowGrenade() )
        return;

	if (Pawn.Weapon.IsA('Grenade_Persistent'))
	{
		ClearTimer('GrenadeCookTick');
        Pawn.Weapon.StartFire(0);

		if ( PreventedFromSprinting == true )
			Sprint();
	}
	else
		bThrowGrenade = true;
}

state PlayerMantlingLow
{
ignores NextWeapon, PrevWeapon, Reload, EnableAimDownSight, StartFire, FastThrowGrenade, EquipGrenade;

    event BeginState (name PrevState)
    {
        local TPPawn tppawn;
        
        tppawn = TPPawn(Pawn);

		ServerCamera('FreeCam');
        tppawn.StopMovement ( );
        tppawn.Obstacle=OB_MantleableLow;
		Pawn.Mesh.RootMotionMode=RMM_Translate;
        Pawn.SetPhysics (PHYS_Flying);
        //Pawn.bCollideWorld=true;

        //Pawn.PhysicsVolume.GroundFriction = 0;
        // 0.25f is time it takes for player to put his hands on wall
        // in this anim - hardcoded for now
        JumpDuration = 0.25f;
        Pawn.SetLocation (Pawn.Location + 20*LastHitWallNormal);
		OrigZ = 0;

        JumpDistance += 5; // Low framerate hack!
        if( tppawn.MovementVolumes.Length > 0 )
        {
			tppawn.MovementVolumes[tppawn.MovementVolumes.Length-1].TriggerEventClass(class'SeqEvent_Movement', self, 0);
			Pawn.bCollideWorld=!tppawn.MovementVolumes[tppawn.MovementVolumes.Length-1].MantleOptions.bTurnOffInitialCollision;
        }
        else
        {
			;
        }

        StopFire();
        Pawn.bCanPickupInventory=false;
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
		ServerCamera('1st');
//ShimmyManualDistance = Pawn.Location.Z - ShimmyManualDistance;
//ClientMessage ("RealDistance : " @ Temp1);
//ClientMessage ("TotalDistanc : " @ ShimmyManualDistance);
//ClientMessage ("AnimDistance : " @ ShimmyManualDistance - Temp1);
        Pawn.SetPhysics(PHYS_Falling);
        Pawn.bCollideWorld = true;
        TPPawn(Pawn).Obstacle=OB_Nothing;
		TPPawn(Pawn).ClientSetObstacle(OB_Nothing);
        GoToState('PlayerWalking');
        Pawn.bCanPickupInventory=true;
    }

    function PlayerMove(float DeltaTime)
    {
        local vector NewAccel;

		NewAccel = PushPlayerUp(DeltaTime);

        RechargeStamina(DeltaTime);
		// Update rotation.
		//OldRotation = Rotation;
        UpdateRotation( DeltaTime );

		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, NewAccel, DCLICK_None, Rotation);
		}
    }
}

state PlayerMantlingMedium
{
ignores NextWeapon, PrevWeapon, Reload, EnableAimDownSight, StartFire, FastThrowGrenade, EquipGrenade;

    event BeginState (name PrevState)
    {
        local TPPawn tppawn;

        tppawn = TPPawn(Pawn);

		ServerCamera('FreeCam');
        tppawn.StopMovement ( );
        tppawn.Obstacle=OB_MantleableMedium;
        Pawn.Mesh.RootMotionMode=RMM_Translate;
        Pawn.SetPhysics (PHYS_Flying);
        //Pawn.bCollideWorld=true;
        JumpDuration = 0.3f;
        OrigZ = 0;
        Pawn.SetLocation (Pawn.Location + 20*LastHitWallNormal);
		JumpDistance += 5; // Low framerate hack!

        if( tppawn.MovementVolumes.Length > 0 )
        {
			tppawn.MovementVolumes[tppawn.MovementVolumes.Length-1].TriggerEventClass(class'SeqEvent_Movement', self, 0);
			Pawn.bCollideWorld=!tppawn.MovementVolumes[tppawn.MovementVolumes.Length-1].MantleOptions.bTurnOffInitialCollision;
        }
        else
        {
			;
        }


        StopFire();
        Pawn.bCanPickupInventory=false;
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
		ServerCamera('1st');
        Pawn.SetPhysics(PHYS_Falling);
        Pawn.bCollideWorld = true;
        TPPawn(Pawn).Obstacle=OB_Nothing;
		TPPawn(Pawn).ClientSetObstacle(OB_Nothing);
        GoToState('PlayerWalking');
        Pawn.bCanPickupInventory=true;
    }

    function PlayerMove(float DeltaTime)
    {
        local vector NewAccel;

		NewAccel = PushPlayerUp(DeltaTime);

        RechargeStamina(DeltaTime);
		// Update rotation.
		//OldRotation = Rotation;
        UpdateRotation( DeltaTime );

		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, NewAccel, DCLICK_None, rot(0,0,0));
		}
    }
}

state PlayerHanging
{
ignores NextWeapon, PrevWeapon, Reload, EnableAimDownSight, StartFire, FastThrowGrenade, EquipGrenade;

    event BeginState (name PrevState)
    {
        local TPPawn tppawn;

        tppawn = TPPawn(Pawn);

        Pawn.SetPhysics(PHYS_None);
        Pawn.bCollideWorld=false;

        tppawn.Obstacle = OB_Hangable;
        //ServerCamera('FreeCam');
        bDontRotatePawn=true;

        if( tppawn.MovementVolumes.Length > 0 )
        {
			tppawn.MovementVolumes[tppawn.MovementVolumes.Length-1].TriggerEventClass(class'SeqEvent_Movement', self, 1);
        }
        else
        {
			;
        }
        StopFire();
        Pawn.bCanPickupInventory=false;

        PlayerPawn(Pawn).ToStandDone(0);
    }

    event EndState(name NextStateName)
    {
        //CameraMode('1st');
        bDontRotatePawn=false;

        // Start falling faster
        Pawn.Velocity.Z = -500;
        Pawn.bCanPickupInventory=true;
    }

    event bool NotifyLanded(vector HitNormal, actor Wall)
    {
        TPPawn(Pawn).Obstacle=OB_Landed;
		TPPawn(Pawn).ClientSetObstacle(OB_Landed);
        return false;
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        if (SeqNode.AnimSeqName == 'bb0005t_ground_mobile_stand_alert_mantlejumpland')
        {
            TPPawn(Pawn).Obstacle=OB_Nothing;
            GoToState ('PlayerWalking');
        }
        else if (SeqNode.AnimSeqName == 'bb0005h_air_mobile_stand_alert_mantleclimbhighwall')
        {
            Pawn.SetPhysics (PHYS_Falling);
            //Pawn.bCollideWorld = true;
            TPPawn(Pawn).Obstacle=OB_Nothing;
            GoToState ('PlayerWalking');
        }
        else if (SeqNode.AnimSeqName == 'bb0005i_air_mobile_stand_alert_jumpoff')
        {
            Pawn.SetPhysics(PHYS_Falling);
            Pawn.bCollideWorld = true;
            TPPawn(Pawn).Obstacle=OB_Falling;
            TPPawn(Pawn).FallTime = 0;  // so we don't check for surface catching for
                                        // a certain amount of time
            GoToState ('PlayerWalking');
        }
        else if (SeqNode.AnimSeqName == 'bb0005n_air_mobile_stand_alert_shimmyright' ||
            SeqNode.AnimSeqName == 'bb0027a_air_mobile_position_alert_shimmyright' ||
            SeqNode.AnimSeqName == 'bb0005o_air_mobile_stand_alert_shimmyleft' ||
            SeqNode.AnimSeqName == 'bb0027b_air_mobile_position_alert_shimmyleft')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
        }
        else if (SeqNode.AnimSeqName == 'bb0005p_air_mobile_stand_alert_shimmy90right' ||
            SeqNode.AnimSeqName == 'bb0027i_air_mobile_position_alert_shimmy90right')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            TPPawn(Pawn).SnapToWall (ShimmyDirection, 0);
            bSnapWall = true;
        }
        else if (SeqNode.AnimSeqName == 'bb0005q_air_mobile_stand_alert_shimmy90left' ||
            SeqNode.AnimSeqName == 'bb0027h_air_mobile_position_alert_shimmy90left')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            TPPawn(Pawn).SnapToWall (ShimmyDirection, 0);
            bSnapWall = true;
        }
        else if (SeqNode.AnimSeqName == 'bb0005r_air_mobile_stand_alert_shimmy270right' ||
            SeqNode.AnimSeqName == 'bb0027k_air_mobile_position_state_shimmy270right')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            TPPawn(Pawn).SnapToWall (ShimmyDirection, 0);
            bSnapWall = true;

        }
        else if (SeqNode.AnimSeqName == 'bb0005s_air_mobile_stand_alert_shimmy270left' ||
            SeqNode.AnimSeqName == 'bb0027j_air_mobile_position_state_shimmy270left')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            TPPawn(Pawn).SnapToWall (ShimmyDirection, 0);
            bSnapWall = true;
        }
    }

    function PlayerMove(float DeltaTime)
    {
        local float Percentage;
        local vector MovementVec;
        local TPPawn tpPawn;

        tpPawn = TPPawn(Pawn);

        tpPawn.StopMovement ( );

        if (tpPawn.Obstacle != OB_Climbable && tpPawn.Obstacle == OB_Hangable && tpPawn.Shimmy == SH_None && !bSnapWall)
        {
            tpPawn.Shimmy = tpPawn.TestShimmyDirection
                (PlayerInput.aStrafe, ShimmyDirection, ShimmyManualDistance);

            // Turn on extracting rotation.
            Pawn.Mesh.RootMotionRotationMode=RMRM_RotateActor;

            // Default to using translation from animation when shimmying
            if (ShimmyManualDistance == 0)
            {
                Pawn.Mesh.RootMotionMode=RMM_Translate;
            }
            else
            {
                TotalTime = 0;
                JumpDuration = 0.8;
                ShimmyLoc = Pawn.Location;
                Pawn.Mesh.RootMotionMode=RMM_Ignore;
            }
        }

        if (TPPawn(Pawn).Shimmy != SH_None && ShimmyManualDistance > 1.0f)
        {
            // Move the player manually
            TotalTime += DeltaTime;
            Percentage = fclamp(TotalTime/JumpDuration, 0, 1);
            MovementVec = ShimmyDirection*ShimmyManualDistance*Percentage;
            Pawn.SetLocation(ShimmyLoc + MovementVec);
        }

        if (PlayerInput.aForward < 0)
            WantsToClimb = false;
        else
            WantsToClimb = true;

        RechargeStamina(DeltaTime);
		// Update rotation.
		//OldRotation = Rotation;

        if (tpPawn.MovementVolumes.Length == 0 ||
            (tpPawn.MovementVolumes[tpPawn.MovementVolumes.Length-1].bCameraCanRotate))
            UpdateRotation( DeltaTime );
    }
}

state PlayerVaulting
{
    event BeginState (name PrevState)
    {
		//local vector NewAccel;

        TPPawn(Pawn).Obstacle=OB_Vaultable;
		Pawn.Mesh.RootMotionMode=RMM_Translate;
        Pawn.SetPhysics (PHYS_Flying);
        IgnoreMoveInput(true);
		ClientIgnoreMoveInput(true);
        // @hack for preventing hitting the vaulting wall (animation issue?)
        Pawn.SetLocation (Pawn.Location + 20*LastHitWallNormal);
		//NewAccel = (Pawn.Location + 20*LastHitWallNormal)-Pawn.Location;
		//ReplicateMove(WorldInfo.DeltaSeconds, NewAccel, DCLICK_None, rot(0,0,0));
		// The time it takes for player to put his hands on wall
        // in this anim - hardcoded for now
        JumpDuration = 0.5f;
        OrigZ = 0;
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        Pawn.SetPhysics(PHYS_Falling);
        TPPawn(Pawn).Obstacle=OB_Nothing;
		TPPawn(Pawn).ClientSetObstacle(OB_Nothing);
        IgnoreMoveInput(false);
		ClientIgnoreMoveInput(false);
        GoToState('PlayerWalking');
    }

    function PlayerMove(float DeltaTime)
    {
        local vector NewAccel;

		NewAccel = PushPlayerUp(DeltaTime);

        RechargeStamina(DeltaTime);
        UpdateRotation( DeltaTime );

		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, NewAccel, DCLICK_None, rot(0,0,0));
		}
    }
}

state PlayerVaultMantling
{
ignores NextWeapon, PrevWeapon, Reload, EnableAimDownSight, StartFire, FastThrowGrenade, EquipGrenade;

    event BeginState (name PrevState)
    {
        TPPawn(Pawn).StopMovement ( );
        TPPawn(Pawn).Obstacle=OB_VaultMantleable;
		Pawn.SetPhysics (PHYS_Flying);
		Pawn.Mesh.RootMotionMode=RMM_Translate;
        Pawn.bCollideWorld=false;
        //Pawn.PhysicsVolume.GroundFriction = 0;
        JumpDuration = 0.25f;
        OrigZ = 0;
        JumpDistance += 5; // Low framerate hack!
        StopFire();
        Pawn.bCanPickupInventory=false;
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        Pawn.SetPhysics(PHYS_Falling);
		//Pawn.Mesh.RootMotionMode=RMM_Translate;
        Pawn.bCollideWorld = true;
        TPPawn(Pawn).Obstacle=OB_Nothing;
		TPPawn(Pawn).ClientSetObstacle(OB_Nothing);
  	    GoToState('PlayerWalking');
        Pawn.bCanPickupInventory=true;
    }

    function PlayerMove(float DeltaTime)
    {
        local vector NewAccel;

		NewAccel = PushPlayerUp(DeltaTime);

        RechargeStamina(DeltaTime);
		// Update rotation.
		//OldRotation = Rotation;
        UpdateRotation( DeltaTime );

		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, NewAccel, DCLICK_None, rot(0,0,0));
		}
	}
}

// player is climbing ladder
state PlayerClimbing
{
ignores NextWeapon, PrevWeapon, Reload, EnableAimDownSight, StartFire, FastThrowGrenade, EquipGrenade;

	event NotifyPhysicsVolumeChange( PhysicsVolume NewVolume )
	{
        if (TPPawn(Pawn).LadderAction == LA_ExitSewer || TPPawn(Pawn).LadderAction == LA_ExitTop)
            return;
        else
            Super.NotifyPhysicsVolumeChange(NewVolume);
	}

    event BeginState (name PreviousStateName)
    {
		if (WorldInfo.NetMode == NM_Standalone)
			ServerCamera('FreeCam');
		else
		{
			Pawn.Mesh.SetOwnerNoSee(true);
			if (Pawn.Weapon != none)
				Pawn.Weapon.Mesh.SetOwnerNoSee(true);
		}

        Pawn.bCollideWorld = false;
        Pawn.Mesh.RootMotionMode=RMM_Translate;
        Pawn.Mesh.RootMotionRotationMode=RMRM_RotateActor;
			bDontRotatePawn=true;
        bDontUseAimOffset=true;

        StopFire();
		//bIsThirdPerson = true;
        Pawn.bCanPickupInventory=false;
    }


    event EndState (name NextStateName)
    {
        local vector LadderLoc;
        local TPLadderVolume ladder;

        LadderLoc   = TPPawn(Pawn).Ladder.Location;
        LadderLoc.Z = Pawn.Location.Z;

        // Ensure player's collision cylinder is clear from ladder collision when
        // exiting bottom
                if (Pawn.Location.Z - 150 < TPPawn(Pawn).Ladder.Bottom.Z)
        {
			ladder = TPLadderVolume(Pawn.OnLadder);
			TPPawn(Pawn).ServerSetLocationAndRotation(LadderLoc + vector(TPPawn(Pawn).Ladder.WallDir) * -3 *
                CylinderComponent(Pawn.CollisionComponent).CollisionRadius, TPPawn(Pawn).Ladder.WallDir);
            Pawn.SetLocation(LadderLoc + vector(TPPawn(Pawn).Ladder.WallDir) * -3 *
                CylinderComponent(Pawn.CollisionComponent).CollisionRadius);
        }
		else if (WorldInfo.NetMode != NM_Standalone && Pawn.Location.Z - 150 > TPPawn(Pawn).Ladder.Top.Z)
		{
			ladder = TPLadderVolume(Pawn.OnLadder);
			TPPawn(Pawn).ServerSetLocationAndRotation(LadderLoc + vector(TPPawn(Pawn).Ladder.WallDir) * 3 *
                CylinderComponent(Pawn.CollisionComponent).CollisionRadius, TPPawn(Pawn).Ladder.WallDir);
            Pawn.SetLocation(LadderLoc + vector(TPPawn(Pawn).Ladder.WallDir) * 3 *
                CylinderComponent(Pawn.CollisionComponent).CollisionRadius);
		}

        ServerCamera('1st');
        Pawn.bCollideWorld = true;
        bDontRotatePawn=false;
        bDontUseAimOffset=false;
		//bIsThirdPerson = false;
        TPPawn(Pawn).Obstacle=OB_Nothing;

		// Using for Multiplayer
		if (WorldInfo.NetMode != NM_Standalone)
		{
			Pawn.Mesh.SetOwnerNoSee(false);
			if (Pawn.Weapon != none)
				Pawn.Weapon.Mesh.SetOwnerNoSee(false);
		}

        if (WorldInfo.NetMode == NM_Standalone && TPPawn(Pawn).IsInLadderVolume)
        {
            ladder = TPLadderVolume(Pawn.OnLadder);
            // Still in volume, untouch then retouch to reset things
            ladder.PawnLeavingVolume(Pawn);
            ladder.PawnEnteredVolume(Pawn);
        }

		PlayerPawn(Pawn).ServerSetClimbing(false);
        Pawn.bCanPickupInventory=true;
	}

    event OnAnimEnd (AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
		local TPPawn TPawn;

		TPawn = TPPawn(Pawn);

        if (SeqNode.AnimSeqName == 'bb0008a_ground_mobile_stand_alert_ladderenterbottom')
		{
			IgnoreMoveInput(false);
			ClientIgnoreMoveInput(false);
		}
		else if (SeqNode.AnimSeqName == 'bb0008g_ground_mobile_stand_alert_ladderexitbottom')
		{
			GoToState ('PlayerWalking');
		}
		else if (SeqNode.AnimSeqName == 'bb0008d_ground_mobile_stand_alert_ladderexittop')
		{
            Pawn.EndClimbLadder(TPawn.Ladder);
			
			if (WorldInfo.NetMode != NM_Standalone)
				TPawn.ClientEndClimbLadder(TPawn.Ladder);

			GoToState ('PlayerWalking');
		}
		else if (SeqNode.AnimSeqName == 'bf0107a_ground_static_stand_alert_jumpoutmanhole')
		{
			Pawn.EndClimbLadder(TPawn.Ladder);
			GoToState ('PlayerWalking');
		}
		else if (SeqNode.AnimSeqName == 'bb0008e_ground_mobile_stand_alert_ladderentertop')
		{
			IgnoreMoveInput(false);
			ClientIgnoreMoveInput(false);
		}
		else if (SeqNode.AnimSeqName == 'bb0008j_ground_mobile_stand_alert_ladderjumpoff')
		{
			GotoState('PlayerWalking');
		}
		else if (SeqNode.AnimSeqName == 'bf0085d_ground_static_stand_alert_transtoladderdown')
		{
			ClearLatentAction(class'SeqAct_LadderActions');
			TPawn.FinishSceneAnimation();

			if (IsMoveInputIgnored())
			{
				IgnoreMoveInput(false);
				ClientIgnoreMoveInput(false);
			}
		}
		//else if (SeqNode.AnimSeqName == 'bf0085a_ground_static_stand_alert_transandplacebomb')
		//{
		//	Pawn.Mesh.DetachComponent(bombActor.StaticMeshComponent);
		//	bombActor.Destroy();

		//	ClearLatentAction(class'SeqAct_LadderActions');
		//	bHasPrevLadderAction=false;
  //      }
    }

    function OnLadderActions(SeqAct_LadderActions action)
    {
   //     if (bHasPrevLadderAction)
   //         ClearLatentAction(class'SeqAct_LadderActions');

   //     switch (action.LadderAction)
   //     {
   //     case PlaceBomb:
   //         if (bombActor != None)
   //             bombActor.Destroy();

   //         bombActor = Spawn(class'KActorSpawnable');
   //         bombActor.StaticMeshComponent.SetStaticMesh(StaticMesh'NYBR_Mario.Mesh.NYBR_Bomb_01');
   //         Pawn.Mesh.AttachComponentToSocket(bombActor.StaticMeshComponent, 'prop');

   //         TPPawn(Pawn).PlaySceneAnimation('bf0085a_ground_static_stand_alert_transandplacebomb', 1);
   //         if (!IsMoveInputIgnored())
			//{
			//	IgnoreMoveInput(true);
			//	ClientIgnoreMoveInput(true);
			//}
   //         break;
   //     case TurnKnobs:
   //         TPPawn(Pawn).PlaySceneAnimation('bf0085b_ground_static_stand_alert_turnknobloop', 0);
   //         break;
   //     case PressButtons:
   //         TPPawn(Pawn).PlaySceneAnimation('bf0085c_ground_static_stand_alert_pressbuttons', 0);
   //         break;
   //     case Finish:
   //         TPPawn(Pawn).PlaySceneAnimation('bf0085d_ground_static_stand_alert_transtoladderdown', 1);
   //         break;
   //     default:
   //         break;
   //     }
    }

	function PlayerMove( float DeltaTime )
	{
		local TPPawn TPawn;
		local vector NewLocation;
		local vector NewAccel;
		local ELadder CurrLadderAction;

		if ( Pawn == None )
		{
			GotoState('Dead');
			return;
		}

		TPawn = TPPawn(Pawn);

        Pawn.Mesh.SetDepthPriorityGroup(SDPG_World); // Set back to proper mode in ServerCamera

        if (TPawn.LadderAction == LA_IdleR || TPawn.LadderAction == LA_IdleL)
        {
			CurrLadderAction = TPawn.TestLadder (PlayerInput.aForward, TPawn.Ladder);
			TPawn.LadderAction = CurrLadderAction;
			TPawn.ServerSetLadderAction(CurrLadderAction);
        }

        if( Role == Role_Authority && WorldInfo.NetMode != NM_StandAlone )
		{
			// Update ViewPitch for remote clients
			Pawn.SetRemoteViewPitch( Rotation.Pitch );
		}

		/////////////////////////////////////////

		Pawn.Acceleration	= NewAccel;

        TPawn.StopMovement ( );

		if (WorldInfo.NetMode != NM_Standalone)
			UpdateRotation(DeltaTime);

        if (TPawn.LadderAction == LA_Slide)
        {
			Pawn.bCollideWorld = true;
            //Pawn.Acceleration.Z -= 1.0f;
            //Pawn.LadderSpeed = 500.0f;

            NewLocation = Pawn.Location;
            NewLocation.Z -= 500.0f * DeltaTime;

			TPawn.ServerSetLocationAndRotation(NewLocation, Pawn.Rotation);
			Pawn.SetLocation (NewLocation);

            if (TPawn.TestLadder (0, TPawn.Ladder) == LA_None)
            {
				TPawn.ServerSetLocationAndRotation(NewLocation, TPawn.Ladder.WallDir);
				Pawn.SetRotation(TPawn.Ladder.WallDir);
                TPawn.LadderAction = LA_None;
				TPawn.ServerSetLadderAction(LA_None);
				TPawn.OnLadder = TPawn.Ladder;
				TPawn.SetPhysics(PHYS_Walking);
                GoToState ('PlayerWalking');
            }
			return;
        }

        if( bPressedJump && (TPawn.LadderAction == LA_IdleR || TPawn.LadderAction == LA_IdleL))
		{
            TPawn.LadderAction = LA_JumpOff;
			TPawn.ServerSetLadderAction(LA_JumpOff);
		}

        bPressedJump = false;

		if (Role < Role_Authority)
			TPawn.ServerSetLocationAndRotation(Pawn.Location, TPawn.Ladder.WallDir);
	}
}

state PlayerPiping
{
ignores NextWeapon, PrevWeapon, Reload, EnableAimDownSight, /*DisableAimDownSight, */StartFire, FastThrowGrenade, EquipGrenade;

    event BeginState (name PreviousStateName)
    {
        Pawn.Mesh.RootMotionMode=RMM_Translate;
        Pawn.Mesh.RootMotionRotationMode=RMRM_RotateActor;
        Pawn.SetPhysics(PHYS_Flying);
        IgnoreMoveInput(true);
		ClientIgnoreMoveInput(true);
        TPPawn(Pawn).PlaySceneAnimation('bb0033a_air_mobile_flight_alert_jumptohang', 1);

        ServerCamera('Freecam');
        StopFire();
        Pawn.bCanPickupInventory=false;
    }


    event EndState (name NextStateName)
    {
        TPPawn(Pawn).FinishSceneAnimation();
        Pawn.SetPhysics(PHYS_Walking);

        bAllowUpdateRotation=true;

        ServerCamera('1st');
        Pawn.bCanPickupInventory=true;
    }

    event OnAnimEnd (AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        Pawn.Mesh.RootMotionMode=RMM_Translate;

        if (SeqNode.AnimSeqName == 'bb0033a_air_mobile_flight_alert_jumptohang' ||
            SeqNode.AnimSeqName == 'bb0033e_air_mobile_flight_alert_movetolhandforwrd' ||
            SeqNode.AnimSeqName == 'bb0033h_air_mobile_flight_alert_turnrhandforwrd')
        {
            IgnoreMoveInput(false);
			ClientIgnoreMoveInput(false);
            TPPawn(Pawn).PlaySceneAnimation('bb0033b_air_static_flight_idle_hanglhandforwrd',0);
            bPipeRight=false;
            CurrentPipeVolume.SnapToPipe(TPPawn(Pawn),,,false);
        }
        else if (SeqNode.AnimSeqName == 'bb0033c_air_mobile_flight_alert_movetorhandforwrd' ||
            SeqNode.AnimSeqName == 'bb0033g_air_mobile_flight_alert_turnlhandforwrd')
        {
            IgnoreMoveInput(false);
			ClientIgnoreMoveInput(false);
            TPPawn(Pawn).PlaySceneAnimation('bb0033d_air_static_flight_idle_hangrhandforwrd',0);
            bPipeRight=true;
            CurrentPipeVolume.SnapToPipe(TPPawn(Pawn),,,false);
        }
        else if (SeqNode.AnimSeqName == 'bb0033f_air_mobile_flight_alert_dropfromhang')
        {
            IgnoreMoveInput(false);
			ClientIgnoreMoveInput(false);
            GoToState('PlayerWalking');
        }
    }

    function PlayerMove(float DeltaTime)
    {
        local vector  NewAccel, X, Y, Z;
        local rotator cameraRot;

		if( PlayerCamera.CameraStyle == 'FreeCam')
		{
			cameraRot = PlayerCamera.ViewTarget.POV.Rotation;
			cameraRot.Pitch = 0;
			GetAxes(cameraRot, X,Y,Z);
		}
		else
			GetAxes(Pawn.Rotation,X,Y,Z);

        NewAccel = PlayerInput.aForward*X + PlayerInput.aStrafe*Y;

        TPPawn(Pawn).StopMovement ( );

        if (bPressedJump)
        {
            bPressedJump=false;
            IgnoreMoveInput(false);
			ClientIgnoreMoveInput(false);
            Pawn.SetPhysics(PHYS_Falling);
            Pawn.Mesh.RootMotionMode=RMM_Accel;
            GoToState('PlayerWalking');
            TPPawn(Pawn).PlaySceneAnimation('bb0033f_air_mobile_flight_alert_dropfromhang',1);
        }
        else if (PlayerInput.aForward != 0 || PlayerInput.aStrafe != 0)
        {
            if (vector(Pawn.Rotation) dot Normal(NewAccel) >= 0 && !CurrentPipeVolume.CloseToEnd(Pawn, NewAccel))
            {
                IgnoreMoveInput(true);
				ClientIgnoreMoveInput(true);
                if (bPipeRight)
                    TPPawn(Pawn).PlaySceneAnimation('bb0033e_air_mobile_flight_alert_movetolhandforwrd',1);
                else
                    TPPawn(Pawn).PlaySceneAnimation('bb0033c_air_mobile_flight_alert_movetorhandforwrd',1);
            }
            else if (vector(Pawn.Rotation) dot Normal(NewAccel) < 0)
            {
                Pawn.Mesh.RootMotionMode=RMM_Ignore;
                IgnoreMoveInput(true);
				ClientIgnoreMoveInput(true);
                if (bPipeRight)
                    TPPawn(Pawn).PlaySceneAnimation('bb0033h_air_mobile_flight_alert_turnrhandforwrd',1);
                else
                    TPPawn(Pawn).PlaySceneAnimation('bb0033g_air_mobile_flight_alert_turnlhandforwrd',1);
            }
        }

        if (bAllowUpdateRotation)
            UpdateRotation(DeltaTime);

        // Calculate distance to end of pipe volume and manually move player to the end if necessary
    }
}

// State for Leaning around
state PlayerLean
{
	event PushedState()
	{
		HeadCollisionCylinder.CollisionComponent.SetTraceBlocking(true, true);
		TPPawn(Pawn).StopMovement();
        bClampView = true;

        if (!bKismetClampView)
       		PrevRotation = Rotation;

	}
	event PoppedState()
	{
		HeadCollisionCylinder.CollisionComponent.SetTraceBlocking(false, false);
		LeanDirection = No_Lean;

        if (!bKismetClampView)
            bClampView = false;
	}
	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

	function PlayerMove(float DeltaTime)
	{
		UpdateRotation(DeltaTime);
		if (PlayerInput.RawJoyRight < -0.1)
			LeanDirection = Left_Lean;
		else if (PlayerInput.RawJoyRight > 0.1)
			LeanDirection = Right_Lean;
		else
			LeanDirection = No_Lean;

		if (TPWeapon( Pawn.Weapon ).IsReloading())
			LeanDirection = No_Lean;
	}
	exec function ToggleAimDownSight(optional bool CinematicOverride = false)
	{
		PopState();
	}
	exec function PrevWeapon()
	{
	}
	exec function NextWeapon()
	{
	}
}

simulated function ClientTestObstacle()
{
	TestObstacle();
}

reliable server function TestObstacle ( )
{
    local bool bAllowVault, bAllowMantle, bAllowShimmy;
    local int  Index;
	local TPPawn TPawn;
	local PlayerPawn PPawn;

	TPawn = TPPawn(Pawn);
	PPawn = PlayerPawn(Pawn);

	if (TPawn.MovementVolumes.Length != 0)
    {
        Index = TPawn.MovementVolumes.Length-1;
        bAllowVault  = TPawn.MovementVolumes[Index].Movement.bAllowVault;
        bAllowMantle = TPawn.MovementVolumes[Index].Movement.bAllowMantle;
        bAllowShimmy = TPawn.MovementVolumes[Index].Movement.bAllowShimmy;
    }
    else
    {
        return;
    }

	//`log("bWantsToCrouch=" $ PPawn.bWantsToCrouch $ "bIsCrouched=" $ PPawn.bIsCrouched $ ", ToStandInProgress()=" $ PPawn.ToStandInProgress());
	if( PPawn.bWantsToCrouch || PPawn.bIsCrouched || PPawn.ToStandInProgress() )
	{
		//`log(self @ "returning out of obs because I just want to crouch");
		return;
	}

    TotalTime    = 0;

    //@todo CollisionExtent not used for now
    JumpDistance = 0;

	//if (TPPawn(Pawn).bAllowVault)
    if (bAllowVault)
    {
        // Note : JumpDistance not used for player
        Obstacle = TPawn.TestVault (LastHitWallNormal, JumpDistance);
		switch (Obstacle)
        {
            case OB_Vaultable:
                if ((bSprint || bHitWallPressedJump) && Pawn.Velocity.Z == 0)
                {
                    //PushState ('PlayerVaulting');
					TPawn.ClientSetObstacle(OB_Vaultable);
                    GoToState ('PlayerVaulting');
                }
                break;
            default:
                Obstacle = OB_Nothing;
				TPawn.ClientSetObstacle(OB_Nothing);
                break;
        }
    }

	// for debugging purposes...
    if (Pawn.Physics != PHYS_Falling && TPGameReplicationInfo(WorldInfo.GRI).DebugInfo.GetDebugFlag(TPD_SHOWMANTLE))
    {
        TPawn.TestMantle (LastHitWallNormal, JumpDistance);
    }

    if (Pawn.Physics == PHYS_Falling)
    {
        Obstacle = TPawn.TestMantle (LastHitWallNormal, JumpDistance);

		if (Pawn.Physics != PHYS_Falling)
		{
			Obstacle = OB_Nothing;
			TPawn.ClientSetObstacle(OB_Nothing);
		}

		switch (Obstacle)
        {
            case OB_VaultMantleable:
                if (bAllowMantle)
				{
					TPawn.ClientSetObstacle(OB_VaultMantleable);
					GoToState ('PlayerVaultMantling');
					//`log("OB_VaultMantleable");
				}
				break;
            case OB_MantleableLow:
                if (bAllowMantle)
				{
					TPawn.ClientSetObstacle(OB_MantleableLow);
					GoToState ('PlayerMantlingLow');
					//`log("OB_MantleableLow");
				}
                break;
            case OB_MantleableMedium:
                if (bAllowMantle)
				{
					TPawn.ClientSetObstacle(OB_MantleableMedium);
                    GoToState ('PlayerMantlingMedium');
					//`log("OB_MantleableMedium");
				}
                break;
            case OB_Catchable:
                if (bAllowShimmy)
                {
					TPawn.ClientSetObstacle(OB_Catchable);
                    // So the hands line up with the surface that is being hung from
                    JumpDistance -= 5;
                    bAllowUpdateRotation=false;
                    PlayerCatch ( );
					//`log("OB_Catchable");
                }
                break;
            default:
                break;
        }
    }
}


//SPMIRROR with state PlayerWalking in PlayerController.uc
state PlayerWalking
{
    event BeginState(name PrevState)
    {
        bAllowUpdateRotation=true;
        Pawn.OnLadder = None;
    }

	event PausedState()
	{
//		`log(self @ "PlayerWalking paused state");
	}
	event ContinuedState()
	{
//		`log(self @ "PlayerWalking continued state");
	}

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        if (SeqNode.AnimSeqName == 'bb0005t_ground_mobile_stand_alert_mantlejumpland')
        {
            TPPawn(Pawn).Obstacle=OB_Nothing;
        }
        else if (SeqNode.AnimSeqName == 'bb0005k_air_mobile_stand_alert_catch')
        {
            if (TPPawn(Pawn).Obstacle == OB_Catchable)
                PlayerHang ( );
        }
        else if (SeqNode.AnimSeqName == 'bb0033f_air_mobile_flight_alert_dropfromhang')
        {
            IgnoreMoveInput(false);
			ClientIgnoreMoveInput(false);
            TPPawn(Pawn).FinishSceneAnimation();
        }
        else if (SeqNode.AnimSeqName == 'bb0027d_air_mobile_stand_alert_shimmyfallright' ||
            SeqNode.AnimSeqName == 'bb0027c_air_mobile_stand_alert_shimmyfallleft')
        {
            IgnoreMoveInput(false);
			ClientIgnoreMoveInput(false);
            TPPawn(Pawn).FinishSceneAnimation();
            PlayerPawn(Pawn).anode_HangBlend.SetBlendTarget(1.0, 0.0);
            TPPawn(Pawn).SnapToWall (LastHitWallNormal, 0);
            GoToState('PlayerHanging');
        }
        else if (SeqNode.NodeName == 'ToCrouch')
        {
            PlayerPawn(Pawn).ToCrouchDone();
        }
        else if (SeqNode.NodeName == 'ToStand')
        {
            PlayerPawn(Pawn).ToStandDone();
        }
    }

    function OnForceBeamFall(SeqAct_ForceBeamFall Action)
    {
        if (CurrentBeamVolume != None)
        {
            if (Action.Side == Right)
                CurrentBeamVolume.LastAccelDir = CurrentBeamVolume.PlaneYNormal;
            else
                CurrentBeamVolume.LastAccelDir = -CurrentBeamVolume.PlaneYNormal;

            SetTimer(0.05, true, 'BeamFall');
        }
    }

    function bool BeamFall()
    {
        local bool   Opposite;
        local float  Dist;
        local bool   RightSide;
        local quat   QuatRot;
        local bool   bFall;
        local PlayerPawn playerPawn;

        bFall = false;

        if (CurrentBeamVolume != None && Pawn.Physics == PHYS_Walking)
        {
            ClearTimer('BeamFall');

            RightSide = (CurrentBeamVolume.LastAccelDir dot CurrentBeamVolume.PlaneYNormal) >= 0;

            // Player is facing the other way on the beam
            Opposite =  vector(Pawn.Rotation) dot vector(CurrentBeamVolume.Rotation) < 0;

            if (RightSide && !Opposite && CurrentBeamVolume.bAllowFallOffRight)
                return false;
            else if (RightSide && Opposite && CurrentBeamVolume.bAllowFallOffRight)
                return false;
            else if (!RightSide && Opposite && CurrentBeamVolume.bAllowFallOffLeft)
                return false;
            else if (!RightSide && !Opposite && CurrentBeamVolume.bAllowFallOffLeft)
                return false;

            Pawn.Mesh.RootMotionMode         = RMM_Translate;
            Pawn.Mesh.RootMotionRotationMode = RMRM_RotateActor;
            Pawn.bCollideWorld               = false;
            TPPawn(Pawn).StopMovement();
            Pawn.SetPhysics(PHYS_Flying);
            ServerCamera('Freecam');
            IgnoreMoveInput(true);
			ClientIgnoreMoveInput(true);
            JumpDistance=0;

            playerPawn = PlayerPawn(Pawn);

            playerPawn.anode_HangBlend.SetBlendTarget(1.0, 0.0);
            playerPawn.Obstacle = OB_Hangable;

            if (Pawn.bIsCrouched)
            {
                playerPawn.ChangePostureInternal();
                playerPawn.ToStandDone();
            }

            if (RightSide && !Opposite)
            {
                playerPawn.TestLedgeDistance(CurrentBeamVolume.PlaneYNormal, Dist);
                Pawn.SetRotation (CurrentBeamVolume.Rotation);
                LastHitWallNormal=-CurrentBeamVolume.PlaneYNormal;

                QuatRot = QuatFromAxisAndAngle(vector(Pawn.Rotation) << rot(0,-16384,0),45*DegToRad);
                SetRotation (rotator(-QuatRotateVector(QuatRot, vector(Pawn.Rotation) << rot(0,-24576,0))));
                playerPawn.PlaySceneAnimation('bb0027d_air_mobile_stand_alert_shimmyfallright', 1);
                bFall = true;
            }
            else if (!RightSide && Opposite)
            {
                playerPawn.TestLedgeDistance(-CurrentBeamVolume.PlaneYNormal, Dist);
                Pawn.SetRotation (rotator(-vector(CurrentBeamVolume.Rotation)));
                LastHitWallNormal=CurrentBeamVolume.PlaneYNormal;

                QuatRot = QuatFromAxisAndAngle(vector(Pawn.Rotation) << rot(0,-16384,0),45*DegToRad);
                SetRotation (rotator(-QuatRotateVector(QuatRot, vector(Pawn.Rotation) << rot(0,-24576,0))));
                playerPawn.PlaySceneAnimation('bb0027d_air_mobile_stand_alert_shimmyfallright', 1);
                bFall = true;
            }
            else if (!RightSide && !Opposite)
            {
                playerPawn.TestLedgeDistance(-CurrentBeamVolume.PlaneYNormal, Dist);
                Pawn.SetRotation (CurrentBeamVolume.Rotation);
                LastHitWallNormal=CurrentBeamVolume.PlaneYNormal;

                QuatRot = QuatFromAxisAndAngle(vector(Pawn.Rotation) << rot(0,-16384,0),45*DegToRad);
                SetRotation (rotator(-QuatRotateVector(QuatRot, vector(Pawn.Rotation) << rot(0,24576,0))));
                playerPawn.PlaySceneAnimation('bb0027c_air_mobile_stand_alert_shimmyfallleft', 1);
                bFall = true;
            }
            else if (RightSide && Opposite)
            {
                playerPawn.TestLedgeDistance(CurrentBeamVolume.PlaneYNormal, Dist);
                Pawn.SetRotation (rotator(-vector(CurrentBeamVolume.Rotation)));
                LastHitWallNormal=-CurrentBeamVolume.PlaneYNormal;

                QuatRot = QuatFromAxisAndAngle(vector(Pawn.Rotation) << rot(0,-16384,0),45*DegToRad);
                SetRotation (rotator(-QuatRotateVector(QuatRot, vector(Pawn.Rotation) << rot(0,24576,0))));
                playerPawn.PlaySceneAnimation('bb0027c_air_mobile_stand_alert_shimmyfallleft', 1);
                bFall = true;
            }

            if (bFall)
            {
   				Pawn.TriggerEventClass(class'SeqEvent_BeamFall', Pawn);
            }
        }

        return bFall;
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        bHittingWall = true;

        bHitWallPressedJump = false;

        LastHitWallNormal = HitNormal;
		//SetLastHitWall(HitNormal, true;l);
        // Allow Pawn HitNotify to be called

		super.NotifyHitWall(HitNormal, Wall);
        return false;
    }
	reliable client function SetLastHitWall(vector HitNormal, bool bHitWall)
	{
		LastHitWallNormal = HitNormal;
		bHittingWall = bHitWall;
	}

    event bool NotifyLanded(vector HitNormal, actor Wall)
    {
        if (TPPawn(Pawn).Obstacle == OB_Falling)
        {
            TPPawn(Pawn).Obstacle=OB_Landed;
        }

		if (Global.NotifyLanded(HitNormal, Wall))
		{
			return true;
		}

        return false;
    }

	reliable server function SetPawnVelocity(vector Vel)
	{
		Pawn.Velocity = Vel;
	}

	//Adjusted PlayerMove to use 3rd person controls in FreeCam
	function PlayerMove( float DeltaTime )
	{

		local vector			X,Y,Z, NewAccel, vCamPos;

        local vector            AccelDir;
        local float             AccelDotBeam;
        local float             AccelSize;
        local float             JoyRatio;
        local float             BeamDist;

		local eDoubleClickDir	DoubleClickMove;
		local rotator			OldRotation, vCamRot;
		local bool				bSaveJump;
		local PlayerPawn        thePlayerPawn;
		local TPWeapon			Weapon;


		//local vector FaceDir;
		local vector DesiredDir;
		//local float DotProd;
		local rotator EndRot;

		local rotator cameraRot;

		if( Pawn == none )
		{
			GotoState('Dead');
		}
		else
		{
            // Get the playerpawn's goodness
            thePlayerPawn = PlayerPawn(Pawn);

            if (TPPawn(Pawn).Obstacle != OB_Nothing)
            {
                PlayerInput.aForward = 0;
                PlayerInput.aStrafe  = 0;
            }

            if (TPPawn(Pawn).Obstacle == OB_Catchable)
            {
                TPPawn(Pawn).StopMovement ( );
            }

			if( PlayerCamera.CameraStyle == 'FreeCam')
			{
				//Movement will be relative to the camera view direction
				//GetAxes(PlayerCamera.ViewTarget.POV.Rotation,X,Y,Z);

				//Zero out the pitch first - we are only interested in camera's yaw
				cameraRot = PlayerCamera.ViewTarget.POV.Rotation;
				cameraRot.Pitch = 0;
				GetAxes(cameraRot, X,Y,Z);
			}
			else if (PlayerCamera.CameraStyle == 'ThirdPerson')
            {
                 PlayerCamera.GetCameraViewPoint( vCamPos, vCamRot );
                 GetAxes(vCamRot,X,Y,Z);
            }
			else
				GetAxes(Pawn.Rotation,X,Y,Z);


			// Update acceleration.
			NewAccel	= PlayerInput.aForward*X + PlayerInput.aStrafe*Y;
            AccelSize   = VSize(NewAccel);

            if (CurrentBeamVolume != None && CurrentBeamTVolume == None && AccelSize > 0 && Pawn.Physics == PHYS_Walking)
            {
                AccelDir     = Normal(NewAccel);
                AccelDotBeam = AccelDir dot vector(CurrentBeamVolume.Rotation);

                if (PlayerInput.RawJoyRight == 0)
                    JoyRatio = 1;
                else
                    JoyRatio = abs(PlayerInput.RawJoyUp)/abs(PlayerInput.RawJoyRight);

                //if (abs(AccelDotBeam) < CurrentBeamVolume.FallAngleThresholdDegrees &&
                //    (abs(PlayerInput.RawJoyUp)   > CurrentBeamVolume.ControllerThreshold ||
                //    abs(PlayerInput.RawJoyRight) > CurrentBeamVolume.ControllerThreshold))
                //if (abs(AccelDotBeam) < CurrentBeamVolume.FallAngleThresholdDegrees &&
                //    (abs(PlayerInput.RawJoyUp)   > 0 ||
                //    abs(PlayerInput.RawJoyRight) > 0))
                if (abs(AccelDotBeam) < CurrentBeamVolume.FallAngleThresholdDegrees)
                {
                    BeamDist = abs(CurrentBeamVolume.GetSignedDistanceToYPlane(Pawn.Location));

                    if (BeamDist > CurrentBeamVolume.FallDistanceThreshold &&
                        abs(CurrentBeamVolume.GetSignedDistanceToYPlane(Pawn.Location + AccelDir)) > BeamDist)
                    {
                        CurrentBeamVolume.LastAccelDir = AccelDir;
                        if (BeamFall())
                            return;
                    }
                }
                else if (JoyRatio > 0.5)
                {
                    NewAccel = NewAccel << (Rotator(Normal(NewAccel)) - CurrentBeamVolume.Rotation);

                    if (AccelDotBeam < 0)
                        NewAccel *= -1;
                }
            }

            NewAccel.Z	= 0;
			if( AccelSize < 1.0 )
			{
				NewAccel = vect(0,0,0);
			}
			DoubleClickMove = PlayerInput.CheckForDoubleClickMove( DeltaTime/WorldInfo.TimeDilation );

			if( PlayerCamera.CameraStyle == 'FreeCam')
			{
				//Rotate the Pawn to face the direction of travel.

				If(Pawn.Physics == PHYS_Walking && (NewAccel.X != 0.0f || NewAccel.Y != 0.0f))
				{
					// Get the direction the pawn is facing
				//	FaceDir = vector(Pawn.Rotation);

					// Calculate the vector we want to face.
					DesiredDir = Normal(NewAccel);

//					Diff = DesiredDir - FaceDir;
//					Diff = Diff * 0.1f;


                    EndRot = RLerp(Pawn.Rotation,Rotator(DesiredDir),5.0f*DeltaTime,true);
  //                  DesiredDir = FaceDir+Diff;

	//				EndRot = rotator(DesiredDir);

	//				EndRot.Pitch = Pawn.Rotation.Pitch;
					EndRot.Roll = 0;
     				Pawn.SetRotation(EndRot);

			    }
			}

			Weapon = TPWeapon(Pawn.Weapon);
			
            // Adjust player speed in 1st person based on movement direction
            if(PlayerInput.aForward < 0.0 && !bIsThirdPerson)
			{
				if (Weapon != None && Weapon.IsAimDownSight())
					SetGroundSpeed(thePlayerPawn.BackwardGroundSpeed * thePlayerPawn.ADSSpeedModifier);
				else
					SetGroundSpeed(thePlayerPawn.BackwardGroundSpeed);
				//thePlayerPawn.GroundSpeed = thePlayerPawn.BackwardGroundSpeed;
			}
			else
			{
				if (Weapon != None && Weapon.IsAimDownSight())
					SetGroundSpeed(thePlayerPawn.NormalGroundSpeed * thePlayerPawn.ADSSpeedModifier);
				else
					SetGroundSpeed(thePlayerPawn.NormalGroundSpeed);
                //thePlayerPawn.GroundSpeed = thePlayerPawn.NormalGroundSpeed;
			}


			// Adjust player speed if sprinting
			if(bSprint && PlayerStaminaTime > 0 && !IsGrenadeInUse() && (Weapon == None || (Weapon != None && !Weapon.IsAimDownSight())))
			{
			     if(!bIsThirdPerson)
			     {
			         // The player is sprinting when forward and not moving laterally or backwards
			         if(PlayerInput.aForward > 0.0 && !(PlayerInput.aForward == 0.0 && (PlayerInput.aStrafe < 0.0 || PlayerInput.aStrafe > 0.0)))
		             {
                          if (VSize(Pawn.Velocity) >= 550.0 && Weapon != None && Weapon.IsInState('Active'))
						  {
							  SetSprinting(true);
							  Weapon.GoToState('ActiveSprinting');
						  }
						  SetGroundSpeed(thePlayerPawn.SprintGroundSpeed);
                          UpdateStamina(DeltaTime);
			         }
                     else if (Pawn.Weapon.IsInState('ActiveSprinting'))
                     {
                        SetSprinting(false);
                        Weapon.GoToState('Active');
                     }
			     }
			     else
			     {
			         // The player will sprint in all directions except when moving laterally
                     if(!(PlayerInput.aForward == 0.0 && (PlayerInput.aStrafe < 0.0 || PlayerInput.aStrafe > 0.0)))
                 	 {
			              //thePlayerPawn.GroundSpeed = thePlayerPawn.SprintGroundSpeed;
						  SetGroundSpeed(thePlayerPawn.SprintGroundSpeed);
			              UpdateStamina(DeltaTime);
                     }
                 }
            }
            else if (bSprint && PlayerStaminaTime <= 0)
            {
                if (Weapon.IsInState('ActiveSprinting'))
                {
                    if (VSize(Pawn.Velocity) <= 250.0)
                    {
                        Weapon.GoToState('Active');
                        SetSprinting(false);
                    }
                    else
                    {
                        PlayerPawn(Pawn).PlaySprintSoundTimer(true);
                    }
                }
            }

            RechargeStamina(DeltaTime);

			// Update rotation.
			OldRotation = Rotation;

            if (bAllowUpdateRotation)
                UpdateRotation( DeltaTime );

            bDoubleJump = false;

            if( bPressedJump && Pawn.CannotJumpNow() )
			{
                bSaveJump = true;
				bPressedJump = false;
			}
			else
			{
				bSaveJump = false;
			}

			if( Role < ROLE_Authority ) // then save this move and replicate it
			{
				ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
			}
			else
			{
		      	ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
			}

            if (bHittingWall)
                ClientTestObstacle ( );

			bPressedJump = bSaveJump;

            bHittingWall = false;
            ViewShake(DeltaTime);

			//Super.PlayerMove(DeltaTime);
		}
	}
	function ProcessMove( float DeltaTime, vector newAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {

        super.ProcessMove(DeltaTime,newAccel, DoubleClickMove, DeltaRot);

        if(Pawn != none)
        {
			if( Role == Role_Authority && WorldInfo.NetMode != NM_StandAlone )
			{
				// Update ViewPitch for remote clients
				Pawn.SetRemoteViewPitch( Rotation.Pitch );
			}

            if (VSize(Pawn.Velocity)<VSize(newAccel))
            {
                Pawn.Acceleration = newAccel;
            }
            else
            {
                Pawn.Acceleration.X = 0;
                Pawn.Acceleration.Y = 0;
            }
        }
    }
}



// Recharge stamina bar if empty
function RechargeStamina(float DeltaTime)
{
    local float fVel;

    fVel = VSize(Pawn.Velocity);
    if((!bSprint || (Pawn.Weapon != None && !Pawn.Weapon.IsInState('ActiveSprinting'))) &&
        PlayerStaminaTime <= MaxPlayerStamina)
    {
        // slow stamina recharge if player is moving
        if(fVel > 0)
        {
            PlayerStaminaTime += (DeltaTime*0.5);
        }
        // medium stamina recharge if player is standing
        else if(fVel == 0 && !PlayerPawn(Pawn).bIsCrouched)
        {
            PlayerStaminaTime += (DeltaTime*0.8);
        }
        // fastest stamina recharge if player is crouching
        else if(fVel == 0 && PlayerPawn(Pawn).bIsCrouched)
        {
            PlayerStaminaTime += (DeltaTime*1.2);
        }
       if(PlayerStaminaTime > MaxPlayerStamina)
            PlayerStaminaTime = MaxPlayerStamina;
    }
}

// Update Stamina Bar
function UpdateStamina(float DeltaTime)
{
    if(!PlayerPawn(Pawn).bIsCrouched)
        PlayerStaminaTime -= DeltaTime;
        //`log("------Stamina is at "$PlayerStaminaTime);
    else
        PlayerStaminaTime -= (DeltaTime/3);

    if (PlayerStaminaTime <= 0.0f)
	{
	   PlayerStaminaTime = 0.0f;
	}

    if (Pawn.InGodMode())
        PlayerStaminaTime = MaxPlayerStamina;

    PlayerPawn(Pawn).UpdateSprintingRate(PlayerStaminaTime, MaxPlayerStamina);
}


// Player Driving a vehicle.
state PlayerDriving
{
    ignores SeePlayer, /* CHAD REMOVED HearNoise,*/HearNoise, Bump;

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

	// Set the throttle, steering etc. for the vehicle based on the input provided
	function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
	{
		local Vehicle CurrentVehicle;
;
		CurrentVehicle = Vehicle(Pawn);
		if (CurrentVehicle != None)
		{
			//`log("Forward:"@InForward@" Strafe:"@InStrafe@" Up:"@InUp);
			bPressedJump = InJump;
			CurrentVehicle.SetInputs(InForward, -InStrafe, InUp);
			CheckJumpOrDuck();
		}
	}

	function PlayerMove( float DeltaTime )
	{
		// update 'looking' rotation
		UpdateRotation(DeltaTime);

		// TODO: Don't send things like aForward and aStrafe for gunners who don't need it
		// Only servers can actually do the driving logic.
		ProcessDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump);
		if (Role < ROLE_Authority)
		{
			ServerDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
		}

		bPressedJump = false;
	}

	reliable server function ServerUse()
	{
		local Vehicle CurrentVehicle;

		CurrentVehicle = Vehicle(Pawn);
		CurrentVehicle.DriverLeave(false);
	}

	function BeginState(Name PreviousStateName)
	{
		CleanOutSavedMoves();
	}

	function EndState(Name NextStateName)
	{
		CleanOutSavedMoves();
	}
}

// Allow the player to control the turret
state PlayerTurreting
{
ignores SeePlayer, HearNoise, Bump;

/*	server function TurretServerMove
	(
		float	TimeStamp,
		vector	ClientLoc,
		bool	NewbDuck,
		byte	ClientRoll,
		int		View
	)
	{
		Global.ServerMove(TimeStamp, Vect(0,0,0), ClientLoc, 0, ClientRoll, View);
	}*/

    function PlayerMove(float DeltaTime)
    {
		if( Pawn == None )
		{
			GotoState('dead');
			return;
		}

		UpdateRotation( DeltaTime );

		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		}
    }

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

    function BeginState(Name PreviousStateName)
    {
		Pawn.MaxPitchLimit = 16384; // extending pitch limit (limits network weapon aiming)
    }

    function EndState(Name NextStateName)
    {
		if ( Pawn != None )
		{
			Pawn.MaxPitchLimit = Pawn.default.MaxPitchLimit; // restoring pitch limit
		}
	}

Begin:
}


simulated function OnClampPlayerView(SeqAct_ClampPlayerView Act)
{
    bClampView = Act.bEnable;
    bKismetClampView = Act.bEnable;

    if (bClampView)
    {
        SetRotation(Pawn.Rotation);

        PrevRotation      = Rotation;
        MaxLeanPitchAngle = Act.MaxLeanPitchAngle;
        MaxLeanYawAngle   = Act.MaxLeanYawAngle;

        Pawn.Mesh.SetHidden(Act.bHidePlayerMesh);
        myHud.bShowHUD=!Act.bHideHUD;
    }
    else
    {
        MaxLeanPitchAngle = Default.MaxLeanPitchAngle;
        MaxLeanYawAngle   = Default.MaxLeanYawAngle;

        Pawn.Mesh.SetHidden(false);
        myHud.bShowHUD=true;
    }
}


simulated function ClampViewRotation(out rotator Rot, float PitchAngle, float YawAngle)
{
	local int Val;

    if (!bClampView)
        return;

	// Convert PitchAngle to Unreal's Rotation Value
	Val = PitchAngle*65536.0f/360.0f;

	// Clamp between 0 < PitchAngle < 90 degrees
	if (Rotation.Pitch + Rot.Pitch > Val && Rotation.Pitch + Rot.Pitch <= 16384)
		Rot.Pitch = Val - Rotation.Pitch;
	// Clamp between -90 < PitchAngle < 0 degrees
	else if (Rotation.Pitch + Rot.Pitch < 65536 - Val && Rotation.Pitch + Rot.Pitch >= 49152)
		Rot.Pitch = (65536 - Val) - Rotation.Pitch;

	// Convert YawAngle to Unreal's Rotation Value
	Val = YawAngle*65536.0f/360.0f;

	// Clamp Yaw to stay between -YawAngle < OriginalYaw < YawAngle
	if (Rotation.Yaw + Rot.Yaw > PrevRotation.Yaw + Val)
		Rot.Yaw = (PrevRotation.Yaw + Val) - Rotation.Yaw;
	else if (Rotation.Yaw + Rot.Yaw < PrevRotation.Yaw - Val)
		Rot.Yaw = (PrevRotation.Yaw - Val) - Rotation.Yaw;
}

function UpdateRotation( float DeltaTime)
{

	local Rotator	DeltaRot, newRotation, ViewRotation, vCamRot;
	local Vector vCamDir, vPlayerDir;
	local float fDot,fDotThreshold;


	ViewRotation = Rotation;
	DesiredRotation = ViewRotation; //save old rotation

    if (Pawn != None && Pawn.Weapon != None && !IsInState('PlayerShielding'))
        TPWeapon(Pawn.Weapon).UpdateRecoil (DeltaTime);

//disabling TP aim assist (target friction)







	// Calculate Delta to be applied on ViewRotation
	DeltaRot.Yaw	= PlayerInput.aTurn;
	DeltaRot.Pitch	= PlayerInput.aLookUp;



	//UTGame Target adhesion
	if( ( bTargetAdhesionEnabled )
		&& ( Pawn != none )
		/*&& ( PlayerInput.aForward != 0 || PlayerInput.aStrafe != 0)*/
		)
	{
		TPPlayerInput(PlayerInput).ApplyTargetAdhesion( DeltaTime, TPWeapon(Pawn.Weapon), DeltaRot.Yaw, DeltaRot.Pitch );
	}

	//for debuggin
	TPPlayerInput(PlayerInput).screen_aTurn = PlayerInput.aTurn+DeltaRot.Yaw;
	TPPlayerInput(PlayerInput).screen_aLookUp = PlayerInput.aLookUp+DeltaRot.Pitch;


    ClampViewRotation(DeltaRot, MaxLeanPitchAngle, MaxLeanYawAngle);

	ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );

    SetRotation(ViewRotation);

	ViewShake( deltaTime );

	NewRotation = ViewRotation;
	NewRotation.Roll = Rotation.Roll;

	if( PlayerCamera.CameraStyle != 'ThirdPerson')
	{
    	if ( Pawn != None && !bDontRotatePawn)
	    	Pawn.FaceRotation(NewRotation, deltatime);
	}
	else
	{
	    PlayerCamera.GetCameraViewPoint(vCamDir,vCamRot);
	    vCamDir = vector(vCamRot);
		vPlayerDir = vector(Pawn.Rotation);

		fDot = vCamDir dot vPlayerDir;

		if (bThirdPersonRefocus)
		   fDotThreshold = 0.95;
        else
           fDotThreshold = 0.3;

		if (fDot<fDotThreshold || PlayerInput.aForward!=0 || PlayerInput.aStrafe!=0)
    	{
              if ( Pawn != None )
              {
	    	     Pawn.FaceRotation(NewRotation, deltatime);
	    	     bThirdPersonRefocus = true;
              }
        }
        else
        {
           bThirdPersonRefocus = false;
        }
	}

}


simulated function OnGiveInventory(SeqAct_GiveInventory inAction)
{
	local int Idx;
	local class<Inventory> InvClass;

	//`log("TPDemoPlayerController::OnGiveInventory  Pawn=" @ Pawn @ "Pawn.weapon=" @ Pawn.Weapon);

	if (InAction.InventoryList.Length > 0 )
	{
		for (Idx = 0; Idx < InAction.InventoryList.Length; Idx++)
		{
			InvClass = InAction.InventoryList[idx];
			if (InvClass != None)
			{
				Pawn.CreateInventory(InvClass);
			}
			else
			{
				InAction.ScriptLog("WARNING: Attempting to give NULL inventory!");
			}
		}
	}
	else
	{
		InAction.ScriptLog("WARNING: Give Inventory without any inventory specified!");
	}


	//`log("TPDemoPlayerController::OnGiveInventory  Pawn.Weapon=" @ Pawn.Weapon);

	//Pawn.InvManager.SetCurrentWeapon(Pawn.InvManager.GetBestWeapon(false));
	//Pawn.InvManager.SwitchToBestWeapon();

}


simulated function OnSetCurrentWeapon(SeqAct_SetCurrentWeapon inAction)
{
	local Weapon newWeapon;

	newWeapon = Weapon(Pawn.FindInventoryType( inAction.CurrentWeapon ) ); //Should we add weapon to inventory if not found?
	if( newWeapon != None )
	{
		Pawn.InvManager.SetCurrentWeapon( newWeapon );
	}
}

exec function HidePlayer(bool hide)
{
	if (pawn!=None)
	{
		pawn.SetHidden(hide);
	}
}

reliable server function ServerSetGroundSpeed(float speed)
{
	if ( pawn != none )
	pawn.GroundSpeed = speed;
}

reliable server function ServerSetSprinting(bool Val)
{
	TPPawn(Pawn).bIsSprinting = Val;
}

simulated function SetSprinting(bool Val)
{
	if (TPPawn(Pawn) != none)
	{
		TPPawn(Pawn).bIsSprinting = Val;
		if (Role < Role_Authority)
			ServerSetSprinting(Val);
	}
}

exec function SetGroundSpeed(float speed)
{
	if (pawn!=None)
	{
		if (Role == Role_Authority)
			pawn.GroundSpeed = speed;
		else
			ServerSetGroundSpeed(speed);
	}
}

exec function SetJumpHeight(float height)
{
	if (pawn!=None)
	{
		pawn.JumpZ = height;
	}
}

exec function SetFreeCamDistance(float dist)
{
	if( PlayerCamera != None )
	{
		PlayerCamera.FreeCamDistance = dist;
	}
}

exec function SetFreeCamOffset(float x, float y, float z)
{
	if( PlayerCamera != None )
	{
		PlayerCamera.FreeCamOffset.x = x;
		PlayerCamera.FreeCamOffset.y = y;
		PlayerCamera.FreeCamOffset.z = z;
	}
}

exec function SetHealth(float newHealth)
{
	if( pawn != None )
	{
		pawn.Health = newHealth;
	}
}

exec function SetPlayerScale(float newScale)
{
	local SkelControlSingleBone node;
	local TPPawn thePawn;

	thePawn = TPPawn(Pawn);

	if(thePawn != None)
	{
		node = SkelControlSingleBone(thePawn.Mesh.FindSkelControl('ScaleControl'));
		if(node != None)
		{
			node.ControlStrength = 1.0;
			node.BoneScale = newScale;


			thePawn.CylinderComponent.Translation = thePawn.OriginalHeightInfo.CollisionTranslation * newScale;
			thePawn.CylinderComponent.CollisionHeight = thePawn.OriginalHeightInfo.CollisionHeight * newScale;

			thePawn.SetPrePivot( thePawn.OriginalHeightInfo.PrePivot * newScale );

			//may want to scale the groundspeed too?

			thePawn.CurrentScale = newScale;


			thePawn.SnapToFloor();
		}
	}
}

//exec function AIDebug()
//{
//    if (Pawn != none)
//    {
//       if (TPPawn(Pawn) != none)
//       {
//          TPPawn(Pawn).GetAISystem().bDisplayAIDebug = !TPPawn(Pawn).GetAISystem().bDisplayAIDebug;
//       }
//    }
//}


exec function ScaleBone(Name boneName, float newScale)
{
	if( TPPawn(Pawn) != none )
	{
		TPPawn(Pawn).ScaleBone( boneName, newScale );
	}
}

exec function SelectLevel()
{
    local TPGameViewportClient viewport;
    viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
   	if( viewport != None && viewport.LSInteraction != None)
   	    viewport.LSInteraction.Toggle( PlayerPawn(Pawn) );

}
exec function TPShell()
{
    local TPGameViewportClient viewport;
    viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
   	if( WorldInfo.NetMode == NM_Standalone)
	{
		if( viewport != none)
		{
			if (viewport.TPShellInteraction == None)
				viewport.InitializeShellInteraction(self);

			if (viewport.TPShellInteraction != None)
			{
				WriteProfile(true); // for now, write the profile when going to the shell
   				viewport.TPShellInteraction.Toggle();
			}
		}
	}
}

exec function TPExitShell()
{
	local TPGameViewportClient viewport;
    viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
	if (viewport != None && viewport.TPShellInteraction != None)
	{
		//`log("CALLING DEINITIALIZE SHELL INTERACTION");
		viewport.DeInitializeShellInteraction(self);
	}
}

exec function bool TPPauseMenu()
{
	local TPGameViewportClient viewport;
	local bool bSuccess;

	
	bSuccess = false;
    viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);

	if ( viewport != none && viewport.FullScreenIsMoviePlaying() )
	{
		/*
		if ( bSystemPauseRequested )
		{
			`Log("TPPauseMenu::bSystemPauseRequested: Pausing during movieplayback...");
			//viewport.FullScreenPauseMovie(true);
			DisableUI();

			if ( !IsPaused() )
			{
				SetPause(true);
			}

			bSuccess = true;
		}
		*/
		bSuccess = false;
	}
	else
	{
		if (IsInShellLevel())
		{
			if ( bSystemPauseRequested || (WorldInfo.IsConsoleBuild(CONSOLE_PS3) && bAssignedControllerDisconnected) )
			{
				if ( !IsPaused() )
				{
					SetPause(true);
				}

				//if (Player != none && LocalPlayer(Player).ViewportClient != none)
				//{
				//	`Log("TPPauseMenu:OnSystemPauseRequest: InShellMainMenu - Disabling UI....");
				//	DisableUI();
				//}
				bSuccess = true;
			}
		}
		else
		{
			if ( !IsPaused() )
			{
				// Close the tutorial - it doesn't play nicely with the options screen
			   GetUIController().CloseScene(TutorialScene);
			
				if( WorldInfo.NetMode == NM_Standalone)
				{
					if (ForceFeedbackManager != None)
					{
						ForceFeedbackManager.PauseWaveform(true);
					}
					WriteProfile(true);
					GetUIController().OpenScene(PauseMenuScene, LocalPlayer(Player));
					myHUD.bShowHUD = false;
				}
				else
				{
					if (PauseMenuMPScene == None)
						PauseMenuMPScene = WorldInfo.PauseMenuMPScene;

					GetUIController().OpenScene(PauseMenuMPScene, LocalPlayer(Player));
					//myHUD.bShowHUD = false;
					myHUD.bShowScores = false;
				}
			}

			bSuccess = true;
		}

		if ( bSuccess )
		{
			if ( !bSystemPauseRequested )
			{
				if ( WorldInfo.IsConsoleBuild(CONSOLE_PS3) && bAssignedControllerDisconnected )
				{
					ShowControllerDisconnectMsg( DisconnectedAssignedController + 1 );
				}
			}
		}
	}
	
	return bSuccess;
}

simulated function ApplyPausePostProcess()
{
	local PostProcessSettings myPost;

	if (PlayerPawn(Pawn) == None || !PlayerPawn(Pawn).bShellShockActive)
	{
		GetPostProcessSettings(myPost);
		//myPost.bEnableDOF=false;
		//myPost.bEnableMotionBlur=false;
		//myPost.bEnableBloom=false;
		myPost.Scene_Desaturation=0.9;
		myPost.bEnableSceneEffect=true;
		LocalPlayer(Player).OverridePostProcessSettings(myPost, 0.0);
	}
}

simulated function ClearPausePostProcess()
{
	if (PlayerPawn(Pawn) == None || !PlayerPawn(Pawn).bShellShockActive)
	{
		LocalPlayer(Player).ClearPostProcessSettingsOverride();
	}
}

exec function TPExitPauseMenu()
{
	ClearPausePostProcess();
	myHUD.bShowHUD = true;
	myHUD.bShowScores = false;
    SetTimer(0.1,,'DisableAimDownSight');
	CheckWriteProfile();
	if (ForceFeedbackManager != None)
	{
		ForceFeedbackManager.PauseWaveform(false);
	}
}

simulated function EndPlayMovieLatentAction()
{
	m_bWaitingForLatentMovieToFinish = false;

	ClearLatentAction(class'SeqAct_PlayMovieLatent', false);

	m_LatentMovieAction = None;

	// 	if (GFullScreenMovie->GameThreadIsMoviePlaying(*MovieName.ToString()) &&

}




simulated function OnPlayMovieLatent(SeqAct_PlayMovieLatent Action)
{
	local TPGameViewportClient viewport;
	   viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);

	if (WorldInfo.NetMode == NM_Standalone && viewport != None)
	{
		m_bWaitingForLatentMovieToFinish = true;
		m_LatentMovieAction = Action;
		//`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " OnPlayMovieLatent WorldInfo.NetMode == NM_Standalone && viewport != None Movie Name: " @ Action.MovieName @ " Play Move: " @ Action.PlayMode @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		viewport.FullScreenPlayMovie(Action.MovieName, Action.PlayMode);

		//`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " OnPlayMovieLatent back from iewport.FullScreenPlayMovie -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	//else
	//{
	//	//`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " OnPlayMovieLatent not play WorldInfo.NetMode != NM_Standalone( " @ WorldInfo.NetMode @ ") || viewport == None Movie Name: " @ Action.MovieName @ " Play Move: " @ Action.PlayMode @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	//}
}

simulated function OnPlayMovie(SeqAct_PlayMovie Action)
{
	local TPGameViewportClient viewport;
	   viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);

	if (WorldInfo.NetMode == NM_Standalone && viewport != None)
	{
		//`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " OnPlayMovie WorldInfo.NetMode == NM_Standalone && viewport != None Movie Name: " @ Action.MovieName @ " Play Move: " @ Action.PlayMode @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		viewport.FullScreenPlayMovie(Action.MovieName, Action.PlayMode);

		//`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " OnPlayMovie back from iewport.FullScreenPlayMovie -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	/*else
	{
		`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " OnPlayMovie not play WorldInfo.NetMode != NM_Standalone( " @ WorldInfo.NetMode @ ") || viewport == None Movie Name: " @ Action.MovieName @ " Play Move: " @ Action.PlayMode @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}*/
}

simulated function OnStopMovie(SeqAct_StopMovie Action)
{
	local TPGameViewportClient viewport;
    viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);

	if (WorldInfo.NetMode == NM_Standalone && viewport != None)
	{
		viewport.FullScreenStopMovie(Action.MovieName, Action.bWaitForMovieToFinish);
	}
}

exec function GotoWinScreen()
{
    //local TPGameViewportClient viewport;
	//WriteProfile(true);
	Achievements.ClientCheckAccuracy();

    /*viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
   	if( viewport != none)
	{
		if (viewport.TPShellInteraction == None)
			viewport.InitializeShellInteraction(self);

		if (viewport.TPShellInteraction != None)
   			viewport.TPShellInteraction.GotoState('PlayerVictory');
	}*/
	GetUIController().OpenScene(VictoryScene, LocalPlayer(Player));
}

native function string GetRealCurrentLevelName();

function string GetCurrentLevelName()
{
	local string LevelName;
	local int index;
	LevelName = Repl( Locs(WorldInfo.GetLocalURL()), ".tpm", "" );
	//LevelName = Repl( Locs("s:\\turningpoint\\tpgame\\content\\maps\\gamemaps\\nybr\\nybr6\\nybr6_master?blahblah"), ".tpm", "" );
	index = InStr(LevelName, "?");
	LevelName = Left(LevelName, index);

	while (InStr(LevelName, "\\") != -1)
	{
	    //`log("LevelName is'"$LevelName$"'");
		LevelName = Mid(LevelName, InStr(LevelName, "\\") + 1);
	}

	while (InStr(LevelName, "/") != -1)
	{
		//`log("LevelName is'"$LevelName$"'");
		LevelName = Mid(LevelName, InStr(LevelName, "/") + 1);
	}

	return LevelName;
}

event PlayLevelIntroMovie(string InLevel)
{
	local TPGameViewportClient viewport;
	local String NextLevel;
	viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
	NextLevel = Caps(InLevel);
	;
	
	if (!bIsDemoMode)
	{

		//1/29/08 - Kelly made these StreamBlock to eliminate bink stuttering during load from DVD

		;
		if (NextLevel == "NYSS1_MASTER")
		{
		;
			//viewport.FullScreenPlayMovie('CT01', PLAYMOVIE_StreamNoBlock);
			viewport.FullScreenPlayMovie('CT01', PLAYMOVIE_StreamBlock);
		}
	 	else if (NextLevel == "NYBR6_MASTER")
		{
			;
			//viewport.FullScreenPlayMovie('NYBR_Intro', PLAYMOVIE_StreamNoBlock);
			viewport.FullScreenPlayMovie('NYBR_Intro', PLAYMOVIE_StreamBlock);
		}
		else if (NextLevel == "NYES_MASTER")
		{
			//viewport.FullScreenPlayMovie('CT02', PLAYMOVIE_StreamNoBlock);
			viewport.FullScreenPlayMovie('CT02', PLAYMOVIE_StreamBlock);
		}
		else if (NextLevel == "DCRD1_MASTER")
		{
			//viewport.FullScreenPlayMovie('CT03', PLAYMOVIE_StreamNoBlock);
			viewport.FullScreenPlayMovie('CT03', PLAYMOVIE_StreamBlock);
		}
		else if (NextLevel == "DCWH_EXT_MASTER")
		{
			//viewport.FullScreenPlayMovie('CT04', PLAYMOVIE_StreamNoBlock);
			viewport.FullScreenPlayMovie('CT04', PLAYMOVIE_StreamBlock);
		}
		else if (NextLevel == "UKTL_MASTER")
		{
			//viewport.FullScreenPlayMovie('CT05', PLAYMOVIE_StreamNoBlock);
			viewport.FullScreenPlayMovie('CT05', PLAYMOVIE_StreamBlock);
		}
		else if (NextLevel == "UKBR_MASTER")
		{
			//viewport.FullScreenPlayMovie('UKBR_Intro', PLAYMOVIE_StreamNoBlock);
			viewport.FullScreenPlayMovie('UKBR_Intro', PLAYMOVIE_StreamBlock);
		}
		else if (NextLevel == "UKZP_MASTER")
		{
			//viewport.FullScreenPlayMovie('UKZP_Intro', PLAYMOVIE_StreamNoBlock);
			viewport.FullScreenPlayMovie('UKZP_Intro', PLAYMOVIE_StreamBlock);
		}
	}
}

exec function ExitWinScreen()
{
	local string LevelName, ShortName;
	local string NextLevel;
	local int i;

	WriteProfile(true);
	
	LevelName = GetCurrentLevelName();
	
	if(LevelName == "")
	{
	    LevelName = Locs(GetNextSublevel());
	}
	LevelName = Caps(LevelName);
	ShortName = Left(LevelName, 4);
	
	;

	;

	if (!bIsDemoMode)
	{
		if (ShortName == "NYSS")
		{
			NextLevel = "nybr6_master";
		}
		else if (ShortName == "NYBR" || LevelName == "CS_SUBWAY_MASTER")
		{
			NextLevel = "nyes_master";
		}
		else if (ShortName == "NYES")
		{
			NextLevel = "dcrd1_master";
		}
		else if (LevelName == "DCRD1_MASTER" || LevelName == "DCRD2_MASTER" || LevelName == "DCRD3_MASTER")
			NextLevel = "dcrd5_master";
		else if (LevelName == "DCRD4_MASTER" || LevelName == "DCRD5_MASTER" || LevelName == "DCRD6_MASTER")
		{
			if (!bIsPreview)
				NextLevel = "dcwh_ext_master";
			else
				NextLevel = "ukbr_master";
		}
		else if (ShortName == "DCWH")
		{
			NextLevel = "uktl_master";
		}
		else if (ShortName == "UKTL")
		{
			NextLevel = "ukbr_master";
		}
		else if (ShortName == "UKBR")
		{
			if (!bIsPreview)
				NextLevel = "ukzp_master";
			else
				NextLevel = "entry_master";
		}
		else if (ShortName == "UKZP")
		{
			NextLevel = "entry_master";
		}
		else
		{
			for (i = 0; i < 5; i++)
			{
				;
			}
			NextLevel = "entry_master";
		}
		PlayLevelIntroMovie(NextLevel);
	}
	else
	{
		;
		NextLevel = "entry_master";
	}

	if (NextLevel != "")
		LocalTravel(NextLevel);
}

simulated function OnEndLoadingScreen(SeqAct_EndLoadingScreen action)
{
	ExitLoadingScreen();
}

exec function ExitLoadingScreen()
{
	local TPGameViewportClient viewport;
	viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);

	if( viewport != none )
		viewport.EndLoadingScreen();
}

exec function GotoLoseScreen()
{
//	local TPGameViewportClient viewport;
//	WriteProfile(true);
//	viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
    Pause();
	GetUIController().OpenScene(GameOverScene, LocalPlayer(Player));
/*   	if( viewport != none)
	{
		if (viewport.TPShellInteraction == None)
			viewport.InitializeShellInteraction(self);

		if (viewport.TPShellInteraction != None && viewport.TPShellInteraction.bDisplayShell == true)
   			viewport.TPShellInteraction.GotoState('PlayerFailure');
	}*/
}


event bool FindAvailableTeleportSpot(TPPawn TestPawn, optional NavigationPoint TeleportAnchor, optional bool bSkipRadiusSearch)
{
	local array<NavigationPoint> NavList;
	local NavigationPoint Nav;
	local vector ChkLoc, NavLoc;
//	local TPSoldierAIController AI;
	local int Idx;

//	ServerReviveTeamMate(TestPawn);
//	AI = TPSoldierAIController(TestPawn.Controller);
	// if an anchor was specified
	if (TeleportAnchor != None)
	{
		// then attempt to spawn at that anchor
		Nav = TeleportAnchor;
		NavLoc = Nav.Location;
		if (CanSpawnAtLocation(NavLoc,TestPawn.GetCollisionExtent(),Nav))
		{
//			if (AI != None)
//			{
//				if (AI.TeleportToLocation(NavLoc,Nav.Rotation))
//				{
//					return TRUE;
//				}
//			}
//			else
			if (TestPawn.SetLocation(Nav.Location))
			{
//				TestPawn.BreakFromCover();
				SetRotation(Nav.Rotation);
				ClientSetRotation(Nav.Rotation, TRUE);
				TestPawn.SetPhysics(PHYS_Falling);
				return TRUE;
			}
		}
		// otherwise use the anchor as the check location
		ChkLoc = TeleportAnchor.Location;
	}
	else
	{
		// use current pawn location if possible
		ChkLoc = Pawn != None ? Pawn.Location : Location;
	}
	if (!bSkipRadiusSearch)
	{
		// grab nodes in a radius
		class'NavigationPoint'.static.GetAllNavInRadius(TestPawn,ChkLoc,1024.f,NavList);
		for (Idx = 0; Idx < NavList.Length; Idx++)
		{
			Nav = NavList[Idx];
			if (!Nav.IsA('CoverSlotMarker') &&
				Abs(Nav.Location.Z - ChkLoc.Z) < 78.f)
			{
				NavLoc = Nav.Location;
				if (CanSpawnAtLocation(NavLoc,TestPawn.GetCollisionExtent(),Nav))
				{
//					if (AI != None)
//					{
//						if (AI.TeleportToLocation(NavLoc,Nav.Rotation))
//						{
//							return TRUE;
//						}
//					}
//					else
					if (TestPawn.SetLocation(NavLoc))
					{
//						TestPawn.BreakFromCover();
						SetRotation(Nav.Rotation);
						ClientSetRotation(Nav.Rotation, TRUE);
						TestPawn.SetPhysics(PHYS_Falling);
						return TRUE;
					}
				}
			}
		}
	}
	;
	return FALSE;
}

exec function LocalTravel( string URL )
{
	local TPGameViewportClient viewport;
	local MaterialEffect myDamagePost;

	;	

	if( URL == "entry_master" )
	{
		bInFrontEnd = true;
		;	
	}
	else
	{
		bInFrontEnd = false;
	}

    viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
	if( WorldInfo.NetMode==NM_Standalone )
	{
		ClearPostMaterials();
	myDamagePost = MaterialEffect(LocalPlayer(Player).PlayerPostProcess.FindPostProcessEffect('DamagePost'));
	myDamagePost.bShowInGame = true;

		bSPMapNameDirty = true;
		viewport.DisplayLoadingScreen();
		Objectives.Length = 0;
		LastWriteProfileTime = -500.f;
		// we need to unload the shell interaction first.
        
        FinishBombGoBoomGame();
        PlayerPawn(Pawn).ShellShockFinished();

		if (viewport != None && viewport.TPShellInteraction != None)
		{
			//`log("CALLING DEINITIALIZE SHELL INTERACTION");
			viewport.DeInitializeShellInteraction(self);
		}

		// Reset level-specific stuff
		ProfileSettings.ResetSinglePlayerStats();
		Achievements.ClientResetSniperKillCount();
		Achievements.ClientResetGrappleKillCount();

		WriteProfile(true);

		super.LocalTravel(URL);
	}
}

//exec function Use()
//{
//	local vector X, Y, Z;
//
//	super.Use();
//
//	if (UseButton != none)
//	{
//		if (UseButton.IsA('DoorActor'))
//		{
//			GetAxes(UseButton.Rotation, X, Y, Z);
//			if (Normal(UseButton.Location-Pawn.Location) dot Y > 0)
//				UseButton.TriggerEventClass( class'SeqEvent_UseDoor', Pawn, 0);
//			else
//				UseButton.TriggerEventClass( class'SeqEvent_UseDoor', Pawn, 1);
//		}
//		else
//		{
//			UseButton.PlayUseSound();
//			UseButton.TriggerEventClass( class'SeqEvent_UseButton', Pawn, 0);
//		}
//	}
//}

//************************ - BEGIN SECTION - ****************************
// BLUFF INTERACTION
//***********************************************************************

function StartBluffPerformance(BluffPerformance perf)
{
}

//function bool CanBluff()
//{
//	//make sure  is inactive
//	if( GrapInt.IsActive() )
//		return false;
//
//	return true;
//}

//Called by an opponent to initiate the bluff prompt
//function EnableBluffPrompt(TPPawn opponent)
//{
//	BluffOpponent = opponent;
//	BluffOpponentController = TPWehrmachtAIController(BluffOpponent.Controller);
//	BluffInt.BluffPrompt(self);
//}

//Called by an opponent on second chance - go directly into bluff
//function ForceBluff(TPPawn opponent)
//{
//	`log("ForceBluff in TPC");
//    BluffOpponent = opponent;
//	BluffOpponentController = TPWehrmachtAIController(BluffOpponent.Controller);
//
//	//BluffInt.GotoState('Active');
//    BluffInt.ForceBluff(self);
//}

//event CancelBluff()
//{
//}


//Called when Bluff Kismet sequence is activated.. Obsolete, this was just for testing
//function OnBluff(SeqAct_Bluff action)
//{
//	local array<Object> objVars;
//	local int idx;
//
//
//
//	Action.GetObjectVars(objVars,"Opponent");
//	for (idx = 0; idx < objVars.Length && BluffOpponent == None; idx++)
//	{
//		BluffOpponent = TPPawn(objVars[idx]);
//	}
//
//	BluffInt.BluffPrompt(self);
//
//	BluffAction = action;
//}


//Called by Bluff Interaction when bluff starts
function EnterBluff(BluffInteraction BI)
{
//	//Let the opponent know we are entering the actual bluff.
//	TPWehrmachtAIController(BluffOpponent.Controller).EnterBluff();

	//cancel the grapple prompt in case it's active
	GrapInt.CancelPrompt();

	PushState('PlayerBluffing');
}

//Called by Bluff Interaction to end the bluff
function ExitBluff()
{
	PopState();
}

//function BluffExpression(eBluffExpression Expression)
//{
//}
//
//function SelectedButtonResponse(bool bOutcome)
//{
//}

function ClearBluffAttempts()
{
    bluffAttempts = 0;
}

function EvaluateUniform()
{
    local int i;

    for(i = 0; i < BluffOpponent.Uniform; i++)
    {
        if(TPPawn(Pawn).Uniform <= i)
            ++bluffAttempts;
    }
    ;

}

function bool IsBluffing()
{
	return( IsInState('PlayerBluffing') );
}

// called when the bMiniGameOnly in the custom bluff kismet is flagged
event MiniGameOnly(int KismetBluffAttempts, float KismetBluffTimer)
{
    BluffAttempts = KismetBluffAttempts - 1;
    BluffInt.bluffTimer = KismetBluffTimer;
    BluffInt.bMiniGameOnly = true;
    BluffInt.EnableMiniGame(self);
}

//We are in this state when we are actively bluffing
state PlayerBluffing
{
	function EnterBluff(BluffInteraction BI)
	{
		//override
	}


	event PushedState()
	{
		//Go into bluff cam


        OldCameraStyle = PlayerCamera.CameraStyle;
		Camera('Bluff');


		//turn off skel controllers
		skel_HeadTrack.SetSkelControlActive(false);
		skel_SpinePitch.SetSkelControlActive(false);



	    //currentTarget = BluffOpponent;

		//No movement allowed...
		ResetMovement();


		PlayerInput.IgnoreMoveInput( true );
		PlayerInput.ClientIgnoreMoveInput(true);
		PlayerInput.IgnoreLookInput( TRUE );


		// SLIN - Commented out for Joe's subway minigame
        //TPPawn(Pawn).PlaySceneAnimation('bd0001f_ground_static_stand_idle_playerstandidle', 0);

		if(!BluffInt.bMiniGameOnly)
        {
            ClearBluffAttempts();
		    EvaluateUniform();
		}
	}

	event PoppedState()
	{
        Camera(OldCameraStyle);

		//BluffOpponent = None;
		//BluffOpponentController = None;

		TPPawn(Pawn).FinishSceneAnimation();

		skel_HeadTrack.SetSkelControlActive(true);
		skel_SpinePitch.SetSkelControlActive(true);

		PlayerInput.IgnoreMoveInput( FALSE );
		PlayerInput.ClientIgnoreMoveInput(false);
		PlayerInput.IgnoreLookInput( false );

	}
    // Player has selected a button - true = Success
//    function SelectedButtonResponse(bool bOutcome)
//    {
//        if(bOutcome && bluffAttempts > 0)
//        {
//            `log("--------Redoing the bluff!------");
//            bluffAttempts--;
//            BluffOpponentController.PushState('BluffReencounter');
//            return;
//        }
//
//        if(bOutcome)
//		{
//          `log("------------You're the winner!!!------------");
//          // Go to successful outcome
//          BluffOpponentController.PushState('BluffSuccess');
//          BluffInt.minigameTimer = 0;
//        }
//		else
//		{
//          `log("------------You're the big fat loser!!!------------");
//          // Go to failed response
//          BluffOpponentController.PushState('BluffFailure');
//          BluffInt.minigameTimer = 0;
//        }
//    }




    //Player has chosen a response
//	function BluffExpression( eBluffExpression Expression )
//	{
//		local eBluffResponse response;
//
//		//`log("BluffExpression in Bluffin state" @ Expression);
//
//		response = DetermineResponse( Expression );
//
//		BluffOpponentController.BluffExpression( Expression );
//
//
//		if(BluffAction != None)
//		{
//			BluffAction.Response = response;
//			ClearLatentAction(class'SeqAct_Bluff', false); //abort
//			PopState();
//		}
//
//
//		Pawn.TriggerEventClass( class'SeqEvent_BluffResponse', BluffOpponentController, response);
//
//
//	}

//	function eBluffResponse DetermineResponse( eBluffExpression chosenExpression )
//	{
//		local eBluffResponse response;
//
//		response = BluffResponse_Aborted;
//
//		if( Uniform == BluffOpponentController.Uniform )
//		{
//			//Correct response is Respect, Surprise response is Surprise, the rest are incorrect?
//			if( chosenExpression == Expression_Respect)
//				response = BluffResponse_Correct;
//			else if( chosenExpression == Expression_Surprise)
//				response = BluffResponse_Surprise;
//			else
//				response = BluffResponse_Incorrect;
//
//			// ****What is the neutral response in this case?
//
//		}
//		else if( Uniform > BluffOpponentController.Uniform )
//		{
//			//Correct response is Contempt, neutral response is Respect.
//			if( chosenExpression == Expression_Contempt)
//				response = BluffResponse_Correct;
//			else if( chosenExpression == Expression_Respect)
//				response = BluffResponse_Neutral;
//			else if( chosenExpression == Expression_Surprise)
//				response = BluffResponse_Surprise;
//			else
//				response = BluffResponse_Incorrect;
//
//		}
//		else
//		{
//			//Correct response is Fear, Surprise response is Surprise, the rest are incorrect?
//			if( chosenExpression == Expression_Cowering)
//				response = BluffResponse_Correct;
//			else if( chosenExpression == Expression_Surprise)
//				response = BluffResponse_Surprise;
//			else
//				response = BluffResponse_Incorrect;
//
//			// ****What is the neutral response in this case?
//		}
//
//		return response;
//	}




	function StartBluffPerformance(BluffPerformance perf)
	{
		CurrentBluffPerformance = perf;

		switch(perf)
		{
			case BP_Player_Success:
				TPPawn(Pawn).PlaySceneAnimation( 'bd0001k_ground_static_stand_alert_playerresponseanger', 1 );
				break;
			case BP_Player_Failure:
				TPPawn(Pawn).PlaySceneAnimation( 'bd0001g_ground_static_stand_alert_playerresponsesurprise2', 1 );
				break;

		}
	}

	event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		BluffInt.NotifyPerformanceFinished(CurrentBluffPerformance);
	}


	function PlayerMove(float DeltaTime)
	{
//		local vector toOpponent;
//
//		toOpponent = Normal( BluffOpponent.Location - Pawn.Location);
//
//		Pawn.SetRotation( rotator(toOpponent) );
	}

	simulated function PlayerTick(float DeltaTime)
	{
//		local vector EyeLoc;
//		local rotator EyeRot;

   		//need this?
   		//super.PlayerTick(DeltaTime);


//		BluffOpponent.GetActorEyesViewPoint(EyeLoc, EyeRot);

//
//		skel_HeadTrack.TargetLocation=EyeLoc;
//
//        skel_HeadTrack.ControlStrength = 1;
////        skel_HeadTrack.ControlStrength = 0;
//
//		skel_SpinePitch.BoneRotation.Pitch = 0;
//

	}

//	event OnAnimEnd(AnimNodeSequence SeqNode)
//	{
//		//pass to the wehrmacht
//		BluffOpponentController.OnAnimEnd(SeqNode);
//	}


}

function bool CanPlayerBluff()
{
	//make sure grapple is inactive
/*
	if( GrapInt.IsActive() )
	{
		return false;
	}
*/

	return true;
}

function bool IsEnemyBluffable( TPPawn BluffEnemy )
{
	if( BluffEnemy==None )
		return false;

	if( BluffEnemy.Health <= 0 )
	{
		//Is this the best way to determine death?
		return false;
	}


	if( BluffEnemy.Controller == None ||
		(!BluffEnemy.Controller.IsInState('Guard') &&
		!BluffEnemy.Controller.IsInState('Challenge')))
	{
		return false;
	}

	// check that enemy is visible to the player... could also iterate using VisibleActors instead of OverlappingActors
	if ( FastTrace(BluffEnemy.Location,Pawn.Location)==false )
	{
		return false;
	}

	return true;
}
function bool FindEnemyToBluff(out TPPawn BluffEnemy)
{
	local WehrmachtPawn P, Best;
	local vector ViewDir, PawnLoc2D, VLoc2D;
	local float NewDot, BestDot;

	if( CanPlayerBluff()==false || Pawn == none)
		return false;

	PawnLoc2D = Pawn.Location;
	PawnLoc2D.Z = 0;
	ViewDir = vector(Pawn.Rotation);
	Best = None;

    ForEach Pawn.OverlappingActors(class'WehrmachtPawn', P, 200) //todo: don't hardcode check to wehrmacht pawns?
	{
		if( IsEnemyBluffable(P)==false )
			continue;

		// Prefer enemies that Pawn is facing
		VLoc2D = P.Location;
		Vloc2D.Z = 0;
		NewDot = Normal(VLoc2D-PawnLoc2D) Dot ViewDir;
		if ( (Best == None) || (NewDot > BestDot) )
		{
			Best = P;
			BestDot = NewDot;
		}

	}


    if( Best == None )
		return false;

	BluffEnemy = Best;
	return true;

}

//************************ - END SECTION - ****************************
// BLUFF INTERACTION
//***********************************************************************

event OnStartBombGoBoomGame(SeqAct_StartBombGoBoomGamePersistent Action)
{
    local TPGameViewportClient  viewport;
    local BombGoBoomInteraction bgb;

    viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);

    bgb = Action.GetInteraction(viewport);

	if (viewport.BGBInteraction == None)
    {
		viewport.InitializeBombGoBoomInteraction(self, bgb);
    }
    else // This shouldn't happen but just in case
    {
        viewport.DeInitializeBombGoBoomInteraction(self);
		viewport.InitializeBombGoBoomInteraction(self, bgb);
    }

    bgb.StartGame();
}

function FinishBombGoBoomGame()
{
    TPGameViewportClient(LocalPlayer(Player).ViewportClient).DeInitializeBombGoBoomInteraction(self);
}

//event StartBombGame(SeqAct_StartBombGame Action)
//{
//    BombInt.Rounds = Action.Rounds;
//    GoToState('PlayerBombing');
//}

state PlayerDoNothing
{
    event BeginState(name PrevState)
    {
		PlayerInput.IgnoreMoveInput(true);
		PlayerInput.ClientIgnoreMoveInput(true);
		PlayerInput.IgnoreLookInput(true);
        TPPawn(Pawn).StopMovement();
        Pawn.SetPhysics(PHYS_None);
        StopSprint();
    }

    event EndState(name NextState)
    {
        PlayerInput.IgnoreMoveInput(false);
		PlayerInput.ClientIgnoreMoveInput(false);
		PlayerInput.IgnoreLookInput(false);
        Pawn.SetPhysics(PHYS_Walking);
    }
}



//************************ - BEGIN SECTION - ****************************
// GRAPPLE INTERACTION
//***********************************************************************

function bool CanPlayerGrapple()
{
	//make sure bluff is inactive
	if( BluffInt != none && BluffInt.IsActive() )
	{
		//`log(self @ "can't grapple because of bluff");
		return false;
	}

	return true;
}

function bool IsEnemyGrappleable( TPPawn GrappleEnemy )
{
	local	float	cosVal;

	if( GrappleEnemy==None )
		return false;

	if( GrappleEnemy.Health <= 0 )
	{
		//Is this the best way to determine death?
		return false;
	}

	//
	// In order to be able to grapple an opponent, he must be close enough and we must be
	// facing towards him.  Must be within a 45 degree angle.
	//
	cosVal = Cos( 30* PI / 180 );

	if ( (VSize( GrappleEnemy.Location - Pawn.Location ) > 200*1.5f) ||
		 (vector(Pawn.Rotation) dot Normal(GrappleEnemy.Location - Pawn.Location) < cosVal) )
	{
		return false;
	}

//`log(self @ GrappleEnemy @ "is grappleable");
	return true;
}

function bool FindEnemyToGrapple(out TPPawn GrappleEnemy)
{
	local WehrmachtPawn P, P2, Best;
	local vector ViewDir, PawnLoc2D, VLoc2D;
	local float NewDot, BestDot;
	local int numFound;

	if( CanPlayerGrapple()==false || Pawn == none)
		return false;

	PawnLoc2D = Pawn.Location;
	PawnLoc2D.Z = 0;
	ViewDir = vector(Pawn.Rotation);
	numFound = 0;
	Best = None;


    ForEach Pawn.OverlappingActors(class'WehrmachtPawn', P, 200) //todo: don't hardcode check to wehrmacht pawns?
    {
		//bug? we are getting duplicate pawns in this loop
		if( P == Best )
			continue;

		if( IsEnemyGrappleable(P)==false )
			continue;


		//Count the eligible opponents
		numFound++;


		// Prefer enemies that Pawn is facing
		VLoc2D = P.Location;
		Vloc2D.Z = 0;
		NewDot = Normal(VLoc2D-PawnLoc2D) Dot ViewDir;
		if ( (Best == None) || (NewDot > BestDot) )
		{
			Best = P;
			BestDot = NewDot;
		}
    }



    if( Best == None )
		return false;


	if( numFound > 1 )
	{
		//More than one eligible grapple opponent was found in the area... we are disallowing in this case for now.
		//`log(self @ "found > 1 grapple opponent... exiting.");
		return false;
	}


	//Now check if our best enemy has a grappleable opponent near him
    ForEach Best.OverlappingActors(class'WehrmachtPawn', P2, 800) //todo: don't hardcode check to wehrmacht pawns?
    {
		//bug? we are getting duplicate pawns in this loop
		if( P2 == Best )
			continue;

		//`log("      best"  @ Best @ "is testing overlapping guy" @ P2);

    	if( IsEnemyGrappleable(P2)==true )
    	{
			//`log(self @ "found grapple opponent near best... exiting.");
			return false;
		}

	}

	GrappleEnemy = Best;
	return true;
}

function ExitGrapple()
{
	GrappleOpponent = None;

	PopState();
}

function EnterGrapple(GrappleInteraction GI)
{
	//cancel the bluff prompt in case it's active
	BluffInt.CancelPrompt();


	PushState('PlayerGrappling');
}

event StartGrapplePerformance(GrapplePerformance perf);
function StartGrappleAction(eGrappleAction action, name AnimName, optional float FailTimer = 5.0f, optional int NumTimes = 1);


function bool IsGrappling()
{
	return( IsInState('PlayerGrappling') );
}

state PlayerGrappling
{
	event PushedState()
	{
		m_bIsGrappling = true;
		//Go into Grapple cam
		OldCameraStyle = PlayerCamera.CameraStyle;
		ClientSetCameraMode(OldCameraStyle);
		Camera('Grapple');

		//Crossfade to grapple music
		FadeToMusicTrack('Grapple');


//		Pawn.Weapon.PutDownWeapon();


		//turn off skel controllers
		skel_HeadTrack.SetSkelControlActive(false);
		skel_SpinePitch.SetSkelControlActive(false);


		ResetMovement();

	}

	event PoppedState()
	{
		//Return to previous music
		FadeToPreviousMusicTrack();


		Camera(OldCameraStyle);

		TPPawn(Pawn).FinishSceneAnimation();

		skel_HeadTrack.SetSkelControlActive(true);
		skel_SpinePitch.SetSkelControlActive(true);

		Pawn.InvManager.SwitchToBestWeapon();

        // Hide pistol after grapple
        if( TPWeapon( Pawn.Weapon ).WeapID == 'Pistol')
        {
            TPWeapon( Pawn.Weapon ).SetHidden(true);
        }

		m_bIsGrappling = false;

	}

	event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		//`log(self @ "anim end" @ SeqNode.AnimSeqName);
		GrapInt.NotifyPerformanceFinished(CurrentGrapplePerformance);
	}

	event StartGrapplePerformance(GrapplePerformance perf)
	{
		CurrentGrapplePerformance=perf;

		switch(perf)
		{
			case GP_CameraIntro:
				TPPawn(Pawn).PlaySceneAnimation('be0000k_ground_static_stand_alert_playercamswitchview', 1/*, `AISCENE_BLENDTIME*/);
				break;



			case GP_DisarmSuccess:
				TPPawn(Pawn).PlaySceneAnimation('be0000a_ground_static_stand_attack_playerdisarm01succeed', 1, 0.25);
				break;

			case GP_DisarmFail:
				TPPawn(Pawn).PlaySceneAnimation('be0000b_ground_static_stand_attack_playerdisarm01fail', 1, 0.25);
				break;



			case GP_PlayerAdvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0000g_ground_static_stand_attack_playergrapple01adv', 1, 0.25);
				break;

			case GP_EnemyAdvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0000h_ground_static_stand_attack_playergrapple01disadv', 1, 0.25);
				break;



			case GP_Idle:
				TPPawn(Pawn).PlaySceneAnimation('be0000e_ground_static_stand_alert_playergrappleidle01', 0, 0.25);
				break;



			case GP_Surprise_PlayerAdvantage:
				//TPPawn(Pawn).PlaySceneAnimation('be0001a_ground_static_stand_attack_adisarmsuccess', 1, `AISCENE_BLENDTIME);
                TPPawn(Pawn).PlaySceneAnimation('be0001c_ground_static_stand_alert_disarmbehind', 1, 0.25);
				break;
			case GP_Surprise_PlayerDisadvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0001b_ground_static_stand_attack_adisarmfail', 1, 0.25);
				break;




			case GP_Struggle_PlayerLoop:
				TPPawn(Pawn).PlaySceneAnimation('be0003b_ground_static_stand_attack_astruggleloop', 0, 0.25);
				break;


			case GP_Struggle_PlayerHitsEnemyA:
				TPPawn(Pawn).PlaySceneAnimation('be0003c_ground_static_stand_attack_astruggleadv', 1, 0.25);
				break;
			case GP_Struggle_PlayerHitsEnemyB:
				TPPawn(Pawn).PlaySceneAnimation('be0003h_ground_static_stand_attack_struggleadvkneeattk', 1, 0.25);
				break;
			case GP_Struggle_PlayerTakesHit:
				TPPawn(Pawn).PlaySceneAnimation('be0003g_ground_static_stand_alert_astruggledisadv', 1, 0.25);
				break;

			case GP_Struggle_PlayerSuperhit:
				TPPawn(Pawn).PlaySceneAnimation('be0003e_ground_static_stand_attack_asuperhit', 1, 0.25);
				break;

			case GP_Struggle_PlayerBreakToNeutral:
				TPPawn(Pawn).PlaySceneAnimation('be0003d_ground_static_stand_alert_abreakoff', 1, 0.25);
				break;

			case GP_Struggle_PlayerDisarmsEnemy:
				TPPawn(Pawn).PlaySceneAnimation('be0003a_ground_static_stand_attack_adisarm', 1, 0.25);
				break;

			case GP_Struggle_PlayerTransTo:
				TPPawn(Pawn).PlaySceneAnimation('be0003f_ground_static_stand_state_atransto', 1, 0.25);
				break;




//			case GP_Combo_PlayerHitsEnemy:
//				TPPawn(Pawn).PlaySceneAnimation('be0005a_ground_static_stand_attack_amultiplefacepunch', 1, `AISCENE_BLENDTIME);
//				break;


			case GP_Combo_PlayerLoopA:
				TPPawn(Pawn).PlaySceneAnimation('be0005a_ground_static_stand_attack_amultiplefacepunch', 1, 0.25);
				break;
			case GP_Combo_PlayerLoopB:
				TPPawn(Pawn).PlaySceneAnimation('be0005h_ground_static_stand_attack_playeradvkicksmash', 1, 0.25);
				break;
			case GP_Combo_PlayerLoopC:
				TPPawn(Pawn).PlaySceneAnimation('be0012a_ground_static_stand_attack_grapplecomboplayer', 1, 0.25);
				break;
			case GP_Combo_PlayerLoopD:
				TPPawn(Pawn).PlaySceneAnimation('be0013a_ground_mixed_stand_attack_punchingcombo', 1, 0.25);
				break;
			case GP_Combo_PlayerLoopE:
				TPPawn(Pawn).PlaySceneAnimation('be0014a_ground_static_stand_attack_brutalfightupperhand', 1, 0.25);
				break;
			case GP_Combo_PlayerLoopF:
				TPPawn(Pawn).PlaySceneAnimation('be0015a_ground_static_stand_attack_grapplekickpunchwinner', 1, 0.25);
				break;

			case GP_Combo_PlayerAdvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0005b_ground_static_stand_attack_asuperpunch', 1, 0.25);
				break;
			case GP_Combo_PlayerDisadvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0005c_ground_static_stand_attack_atakeshit', 1, 0.25);
				break;


			case GP_Combo_PlayerComboFail:
			    TPPawn(Pawn).PlaySceneAnimation('be0011b_ground_static_stand_attack_transblockenemy', 1, 0.25);
				break;


			case GP_Defense_PlayerTransition:
				TPPawn(Pawn).PlaySceneAnimation('be0007a_ground_static_stand_attack_atranstodefense', 1, 0.25);
				break;

			case GP_Defense_PlayerLoop:
				TPPawn(Pawn).PlaySceneAnimation('be0007b_ground_static_stand_attack_aplayerondefenseloop', 0, 0.25);
				break;

			case GP_Defense_PlayerHitsEnemy:
				TPPawn(Pawn).PlaySceneAnimation('be0007c_ground_static_stand_attack_adefensebreak', 1, 0.25);
				break;

		}
	}


}

reliable client function FindLiveGrenades()
{
    local PhysicsGrenade PhysGrenade;

	//`log("Role = "$Role$", Pawn = "$Pawn$", Affect Radius = "$class'Grenade_Persistent'.static.GetDefaultAffectedRadius());
	if ( Pawn != None )
	{
		ForEach Pawn.OverlappingActors(class'PhysicsGrenade', PhysGrenade, class'Grenade_Persistent'.static.GetDefaultAffectedRadius())
		{
			TPHUD(myHud).GrenadeIndicationUpdate(PhysGrenade);
		}
	}

}

//************************ - END SECTION - ****************************
// GRAPPLE INTERACTION
//***********************************************************************


//************************ - START SECTION - ****************************
// GRAPPLE INTERACTION v2
//***********************************************************************

function bool PlayerCanGrapple()
{
	local PlayerPawn PPawn;

    if (PrevWeaponOnGrenade != None)
        return false;

	PPawn = PlayerPawn(Pawn);
	if (PPawn != none)
	{
    	if (!PPawn.bWantsToCrouch && !PPawn.bIsCrouched && !PPawn.ToStandInProgress() && IsInState('PlayerWalking') && PPawn.Physics == PHYS_Walking && TPPlayerCamera(PlayerCamera).IsInFirstPerson())
    	{
        	if (PPawn.Weapon != None)
        	{
            	if (!TPWeapon(Pawn.Weapon).IsAimDownSight())
                	return true;
	            else
    	            return false;
        	}

	        return true;
    	}
	}

    return false;
}

function GrappleFailSafe()
{
    ;

    TPPawn(Pawn).FinishSceneAnimation();
    GrapInt_v2.ClearGrapple();
    GoToState('PlayerWalking');
}

event GrappleImpact(name Label)
{
    // Do nothing
}

simulated function bool FindEnemyToGrapple_v2()
{
    local WehrmachtPawn           Wehr;
    local float                   Dist, BestDist, Angle;
    local vector                  PlayerToEnemy;

	if (GrapInt_v2 == None)
        return false;

    GrappleOpponent = None;
    GrapInt_v2.DisablePrompt();

	if (!PlayerCanGrapple())
		return false;

    ForEach Pawn.VisibleCollidingActors(class'WehrmachtPawn', Wehr, GrappleRadius)
    {
		// Ensure that the pawn isn't without a controller (e.g. when manning a turret)
		if (Wehr.Controller == None)
			continue;

		if(!TPWehrmachtAIController(Wehr.Controller).IsGrappleable() || Wehr.Health <= 0)
			continue;

		if (!ClearPathTo(Wehr))
			continue;

        // Need to be on about the same height level
        if (abs(Wehr.Location.Z - Pawn.Location.Z) > 30)
            continue;

        PlayerToEnemy = Wehr.Location - Pawn.Location;

		// Pick closest enemy
        Dist = VSize(PlayerToEnemy);
        Angle = Normal(PlayerToEnemy) dot vector(Pawn.Rotation);

        if (Angle > 0.90f) // within ~25 degrees
        {
		    if (GrappleOpponent == None || Dist < BestDist)
		    {
			    GrappleOpponent = Wehr;
			    BestDist        = Dist;
		    }
        }
    }

	if (GrappleOpponent != None)
	{
		GrapInt_v2.EnablePrompt(self, TPWehrmachtAIController(GrappleOpponent.Controller));
		return true;
	}
	else
	{
		GrapInt_v2.DisablePrompt();
		return false;
	}
}

state PlayerGrappling_v2
{
ignores NextWeapon, PrevWeapon, Reload, EnableAimDownSight, /*DisableAimDownSight, */FastThrowGrenade, EquipGrenade;

    event BeginState(name PrevState)
    {
        if (bUseGrappleCam)
		    Camera('Grapple');

		PlayerPawn(Pawn).skel_HeadTrack.SetSkelControlActive(false);
		PlayerPawn(Pawn).skel_SpinePitch.SetSkelControlActive(false);

        ResetMovement();

		PlayerInput.IgnoreMoveInput( true );
		PlayerInput.IgnoreLookInput( TRUE );
	}

	event EndState(name NextState)
	{
        if (bUseGrappleCam && NextState != 'PlayerShielding')
            Camera('1st');

        TPPawn(Pawn).FinishSceneAnimation();

		PlayerPawn(Pawn).skel_HeadTrack.SetSkelControlActive(true);
		PlayerPawn(Pawn).skel_SpinePitch.SetSkelControlActive(true);

		PlayerInput.IgnoreMoveInput( FALSE );
		PlayerInput.IgnoreLookInput( false );

        ClearTimer('GrappleFailSafe'); // fix player can't move after load checkpoint then piping
	}

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
        ClearTimer('GrappleFailSafe');
		GrapInt_v2.ActionFinished(eGrappleAction);
	}

	function StartGrappleAction(eGrappleAction action, name AnimName, optional float FailTimer = 5.0f, optional int NumTimes = 1)
	{
        local TPPawn tpPawn;

        tpPawn         = TPPawn(Pawn);
        eGrappleAction = action;

        SetTimer(FailTimer,,'GrappleFailSafe');
        tpPawn.PlaySceneAnimation(AnimName, NumTimes);
    }

    function bool BreakOutEligible()
    {
        return eGrappleAction != GA_EnvKill && eGrappleAction != GA_ShieldKill &&
            eGrappleAction != GA_ShieldDied && eGrappleAction != GA_Kill;
    }

    simulated function bool FindEnemyToGrapple_v2()
    {
        // Break out of grapple if enemy dies somehow
        if (GrappleOpponent.IsInState('Dying') && BreakOutEligible())
        {
            ;
            GrapInt_v2.ClearGrapple();
            TPPawn(Pawn).FinishSceneAnimation();
            GoToState('PlayerWalking');
        }

        return false;
    }

    event GrappleImpact(name Label)
    {
        GrapInt_v2.GrappleImpact(Label);
    }
}

event HumanShieldEquip()
{
    local TPWeapon           pistol, spawned;
    local class<TPWeapon>    temp;
    local TPInventoryManager InvMan;

    LastWeapon = TPWeapon(Pawn.Weapon);

    temp = class<TPWeapon>(FindObject("TPGameContent.Pistol",class'class'));

    spawned                = Spawn(temp);
    spawned.AmmoInMagazine = spawned.MagazineSize;
    spawned.AmmoCount      = rand(spawned.MagazineSize * 2);  // set ammo to random

    pistol = TPInventoryManager(Pawn.InvManager).FindWeaponByClassName('Pistol');

    if (pistol == None)  // give a pistol
    {
        InvMan = TPInventoryManager(Pawn.InvManager);
        if (InvMan.CurrWeapons == InvMan.MaxWeapons)
            InvMan.MaxWeapons++;

        InvMan.AddInventory(spawned, true);
        pistol = spawned;
    }
    else  // give ammo to pistol already in inventory
    {
        spawned.AmmoInMagazine = 0;

        pistol.SetAmmoInMagazine(spawned.MagazineSize);
        pistol.TakeAmmo(spawned);

        spawned.Destroy();
    }

	if( pistol != None )
	{
        Pawn.Weapon.GoToState('Active');          // To ensure weapon will be switched
		Pawn.InvManager.SetCurrentWeapon(pistol); // Make pistol pending
        TPWeapon(Pawn.Weapon).WeaponIsDown();     // Put down current weapon
	}

    if (Pawn.Weapon != None)
    {
        Pawn.Weapon.GoToState('Active');          // bypass equip anims
        TPWeapon(Pawn.Weapon).bWeaponEquipped = true;
        ClientSetDPG(false);
        ResetGunAndArmsFOVs();
    }

    Pawn.Weapon.Mesh.SetHidden(false);
}

state PlayerShielding extends PlayerGrappling_v2
{
    event BeginState (name PrevState)
    {
        local PlayerPawn ThePlayer;
        local rotator NewRot;

        Pawn.bCanBeBaseForPawns = true;

        NewRot = Rotation;
        NewRot.Pitch = 0;
        SetRotation(NewRot);

        ThePlayer = PlayerPawn(Pawn);

		ThePlayer.skel_HeadTrack.SetSkelControlActive(false);
		ThePlayer.skel_SpinePitch.SetSkelControlActive(false);

        SetGroundSpeed(ThePlayer.NormalGroundSpeed * 0.75);

        Pawn.ViewPitchMin = -5000.0;
        Pawn.ViewPitchMax =  7000.0;
    }

    event EndState(name NextState)
    {
        local PlayerPawn         ThePlayer;
        local TPInventoryManager InvMan;

        Pawn.bCanBeBaseForPawns = class'Pawn'.default.bCanBeBaseForPawns;

        ThePlayer = PlayerPawn(Pawn);

        ThePlayer.FinishSceneAnimation();
		ThePlayer.skel_HeadTrack.SetSkelControlActive(true);
		ThePlayer.skel_SpinePitch.SetSkelControlActive(true);

        //TPPawn(Pawn).ThrowActiveWeapon();

        SetGroundSpeed(ThePlayer.NormalGroundSpeed);

        InvMan = TPInventoryManager(Pawn.InvManager);

        if (LastWeapon != None)
        {
            InvMan.SetCurrentWeapon(LastWeapon);
        }

        if (InvMan.MaxWeapons > InvMan.default.MaxWeapons)
        {
            InvMan.ForceBestWeapon = LastWeapon;

            InvMan.MaxWeapons = InvMan.default.MaxWeapons;
            InvMan.TossItem(TPInventoryManager(Pawn.InvManager).FindWeaponByClassName('Pistol'));
            // The pistol had to be added for the human shield...discard it
            // now since player already has max weapons
        }

        if (bUseGrappleCam)
            Camera('1st');

        Pawn.ViewPitchMin = class'PlayerPawn'.default.ViewPitchMin;
        Pawn.ViewPitchMax = class'PlayerPawn'.default.ViewPitchMax;
    }

    function OnForceHumanShieldDeath(SeqAct_ForceHumanShieldDeath action)
    {
        GrapInt_v2.ShieldHasDied();
    }

	function PlayerMove( float DeltaTime )
	{
		local vector			X,Y,Z, NewAccel;
		local rotator			OldRotation;

        GetAxes(Pawn.Rotation,X,Y,Z);

		// Update acceleration.
		NewAccel = PlayerInput.aForward*X + PlayerInput.aStrafe*Y;
		NewAccel.Z	= 0;
		NewAccel = Pawn.AccelRate * Normal(NewAccel);

		// Update rotation.
		OldRotation = Rotation;
		UpdateRotation( DeltaTime );

        ProcessMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
	}
}


//************************ - END SECTION - ****************************
// GRAPPLE INTERACTION v2
//***********************************************************************


function OnSetUniform(SeqAct_SetUniform action)
{
	TPPawn(Pawn).SetUniform( action.Uniform );
}

function eUniform GetUniform()
{
	return TPPawn(Pawn).Uniform;
}

function bool IsDisguised()
{
	return( GetUniform() > Uniform_Peon );
}

//for cheatin on the command line
exec function SetDisguise(int disguise)
{
	TPPawn(Pawn).SetUniform( eUniform(disguise) );
}

function StealUniform( Controller Opponent )
{
	local TPPawn tpOpponentPawn;
	tpOpponentPawn = TPPawn(Opponent.Pawn);
	if( tpOpponentPawn != None )
	{
		if( tpOpponentPawn.Uniform > TPPawn(Pawn).Uniform )
		{
			TPPawn(Pawn).SetUniform(tpOpponentPawn.Uniform);
		}
	}
}



reliable client event ClientUniqueMessage( coerce string S, optional Name Type, optional float MsgLifeTime )
{
	local TPHUD tphud;

	if ( WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.GRI == None )
		return;

	if (Type == '')
		Type = 'Event';

	tphud = TPHUD(myHud);
	if ( tphud != None )
		tphud.AddUniqueConsoleMessage( S, class'LocalMessage', PlayerReplicationInfo, MsgLifeTime );
}

/////////////////////////////////////////////////////
// Start: Events called from kismet to Fade In Screen
/////////////////////////////////////////////////////
event FadeInScreen(string S, float alpha)
{
	TPHUD(myHud).SetFade(true, S, alpha);
}

event FadeInComplete()
{
	TPHUD(myHud).SetFade(false);
}

event FadeOutScreen(string S, float alpha)
{
	TPHUD(myHud).SetFade(true, S, alpha);
}

event FadeOutComplete()
{
    //TPHUD(myHud).bFadeInScreen = false;
}

///////////////////////////////////////////////////
//End: Fade in stuff

event CameraMode (name NewMode, optional float TransitionSpeed)
{
    if (TransitionSpeed > 0)
        TPPlayerCamera(PlayerCamera).TransitionSpeed = TransitionSpeed;
    else
        TPPlayerCamera(PlayerCamera).TransitionSpeed = class'TPPlayerCamera'.default.TransitionSpeed;

    ServerCamera(NewMode);
}

reliable client function ClientSetDPG(bool bFirstPerson)
{
	local TPWeapon CurrentWeapon;
	local SkelControlSingleBone HeadShrink;

	if (Pawn != none)
	{
		if (!Pawn.IsA('Turret'))
		{
			HeadShrink = SkelControlSingleBone(Pawn.Mesh.FindSkelControl('HeadShrink'));
		}

		CurrentWeapon = TPWeapon( Pawn.Weapon );


		// If we have role authority, then regardless of what's passed in: We want to be in first person mode only on ourself.
		if ( role == ROLE_AUTHORITY )
		{
			if ( pawn.IsLocallyControlled() == true && bFirstPerson )
				bFirstPerson = true;
			else
				bFirstPerson = false;
		}


		if (bFirstPerson)
		{
			Pawn.Mesh.SetDepthPriorityGroup(SDPG_Foreground);
            Pawn.Mesh.CastShadow=FALSE;
            Pawn.Mesh.bCastDynamicShadow=FALSE;
            if (HeadShrink != None)
				HeadShrink.SetSkelControlActive(TRUE);
			if (CurrentWeapon != None)
			{
				CurrentWeapon.Mesh.SetDepthPriorityGroup(SDPG_Foreground);
			}
		}
		else
		{
			Pawn.Mesh.SetDepthPriorityGroup(SDPG_World);
            Pawn.Mesh.CastShadow=TRUE;
            Pawn.Mesh.bCastDynamicShadow=TRUE;
            if (HeadShrink != None)
				HeadShrink.SetSkelControlActive(FALSE);
			if (CurrentWeapon != None)
			{
				CurrentWeapon.Mesh.SetDepthPriorityGroup(SDPG_World);
			}
		}
	}
}

simulated function bool IsGrenadeInUse()
{
    return Pawn.Weapon != None && (Pawn.Weapon.class == class'Grenade_Persistent' || PrevWeaponOnGrenade != None);
}

function CancelGrenadeSwitch()
{
    // Cancel any grenade stuff
    if (IsGrenadeInUse())
    {
        Pawn.Weapon.GoToState('WeaponPuttingDown');            // To ensure grenade will be switched
		Pawn.InvManager.SetCurrentWeapon(PrevWeaponOnGrenade); // Set previous weapon as active
        TPWeapon(Pawn.Weapon).WeaponIsDown();                  // Put down grenade
        ClearTimer('GrenadeCookTick');
        PlayerPawn(Pawn).ResetUnequipAnimRate();
        PrevWeaponOnGrenade = None;
    }
}

reliable server function TrueServerCamera( name NewMode )
{
    local MP50_Persistent Mp50;
	local TPWeapon CurrentWeapon;
	//local bool bOldThirdPerson;

	if (Pawn == none)
		return;

	CurrentWeapon = TPWeapon( Pawn.Weapon );

    //bOldThirdPerson = bIsThirdPerson;

    if ( NewMode == '1st' )
	{
    	NewMode = 'FirstPerson';
	}
    else if ( NewMode == '3rd' )
	{
    	NewMode = 'ThirdPerson';
	}
	else if (NewMode == 'Toggle' )
	{
		//Toggle between Freecam and Firstperson
		if( PlayerCamera.CameraStyle == 'FreeCam' || PlayerCamera.CameraStyle == 'ThirdPerson')
		{
			NewMode = 'FirstPerson';
		}
		else
		{
			NewMode = 'FreeCam';
		}
	}

    if( NewMode == 'FirstPerson' && !bCinematicMode  )
    {
		ClientSetDPG(true);
    	bIsThirdPerson = false;
    }
    else if( NewMode == 'DebugCam')
    {
		ClientSetDPG(false);
    	bIsThirdPerson = false;
    }
    else
    {
		ClientSetDPG(false);
    	bIsThirdPerson = true;
		ClearPostMaterials();
    }

    CancelGrenadeSwitch();

    Mp50 = MP50_Persistent(CurrentWeapon);
    if (Mp50 != None)
    {
        if (bIsThirdPerson && Mp50.bFlashlightIsOn)
        {
            Mp50.bWasOn = true;
            Mp50.ToggleFlashlight(false);
        }
        else if (!bIsThirdPerson && Mp50.bWasOn)
        {
            Mp50.bWasOn = false;
            Mp50.ToggleFlashlight(true);
        }
    }

	// Disable aiming down the sight if it was enabled.
    if(CurrentWeapon != None && CurrentWeapon.bToggleAimDownSight)
    {
        ToggleADSInternal();
        CurrentWeapon.ADSTransitionDone();
    }

    if (bIsThirdPerson && CurrentWeapon != None && CurrentWeapon.IsInState('WeaponPuttingDown'))
    {
        CurrentWeapon.WeaponIsDown();     // Finish putting down current weapon
    }
    else if( bIsThirdPerson && CurrentWeapon != None && !(CurrentWeapon.IsInState('WeaponHolstering')) && !CurrentWeapon.bWeaponIsHolstered)
    {
		//we are changing from first to third so holster your weapon
        CurrentWeapon.GotoState('WeaponHolstering');
        //ResetGunAndArmsFOVs();
    }
    else if( !bIsThirdPerson && CurrentWeapon != None && !(CurrentWeapon.IsInState('WeaponEquipping')) && CurrentWeapon.bWeaponIsHolstered)
    {
        CurrentWeapon.bWeaponIsHolstered = false;
        CurrentWeapon.GotoState('WeaponEquipping');
        //SetGunAndArmsFOVs();
    }

    // set the gun & arms FOV's if needed
    if (NewMode == 'Grapple')
    {
        SetDesiredFOV (TPPlayerCamera(PlayerCamera).GrappleFOV);
        //FOV(TPPlayerCamera(PlayerCamera).GrappleFOV);
        ResetGunAndArmsFOVs();
    }
	else if (bIsThirdPerson)
	{
		SetDesiredFOV (ThirdPersonFOV);
        //FOV(ThirdPersonFOV);
		ResetGunAndArmsFOVs();
		if (Pawn.Weapon != None)
			Pawn.Weapon.Mesh.SetHidden(true);
	}
	else
	{
        SetDesiredFOV (DefaultFOV);
        //FOV(DefaultFOV);
		SetGunAndArmsFOVs();
		if (Pawn.Weapon != None)
			Pawn.Weapon.Mesh.SetHidden(false);
	}

	SetCameraMode( NewMode );
	ClientSetCameraMode(NewMode);
	if ( PlayerCamera != None )
		;
}

reliable client function InitDeathCam()
{
	local TPPlayerCamera tPC;
	local vector V;
	local int i;
	local array<vector> container;
//	local vector hitLoc, hitNorm;
	local int selectedRayIndex;
	local float smallNum, largeNum;

	tPC = TPPlayerCamera(PlayerCamera);

	if ( tPC != None )
	{
		// Repeat steps but with small rays
		tPC.deathCam.deathLoc	= pawn.location;
		tPC.deathCam.t			= 0.0;
		v.x						= 0;
		v.y						= 0;
		v.z						= 100;	// Camera should start just above the
		tPC.deathCam.points[0]	= pawn.location + v;

		// Go through all rays
		for ( i = 0 ; i < 10 ; i++ )
		{
			// Cast Collision
			if ( DeathCamCollisionNoHit( tPC.deathCam.deathLoc + tPC.deathCam.rays[i], tPC.deathCam.deathLoc ) )
			//if ( none == Pawn.Trace( HitLoc, HitNorm, tPC.deathCam.deathLoc + tPC.deathCam.rays[i], tPC.deathCam.deathLoc,,,,TRACEFLAG_LevelOnly) )
			{
				//`log( "Long:" @ i $ ")" @ tPC.deathCam.deathLoc @ "->" @ tPC.deathCam.deathLoc + tPC.deathCam.rays[i] );
				// If none, then put into valid container
				container.AddItem( tPC.deathCam.rays[i] );
			}
			else
			{
				//`log( "Long:" @ i $ ")" @ "collision check failed..." );
			}

		}

		// small rays
		if ( container.length <= 0 )
		{
			// Go through all rays
			for ( i = 0 ; i < 5 ; i++ )
			{
				// Cast Collision
				if ( DeathCamCollisionNoHit( tPC.deathCam.deathLoc + tPC.deathCam.smallRays[i], tPC.deathCam.deathLoc ) )
				//if ( none == Trace( HitLoc, HitNorm, tPC.deathCam.deathLoc + tPC.deathCam.smallRays[i], tPC.deathCam.deathLoc,,,,TRACEFLAG_LevelOnly ) )
				{
				//	`log( "Small:" @ i $ ")" @ tPC.deathCam.deathLoc @ "->" @ tPC.deathCam.deathLoc + tPC.deathCam.smallRays[i] );
					// If none, then put into valid container
					container.AddItem( tPC.deathCam.smallRays[i] );
				}
				else
				{
				//	`log( "Small:" @ i $ ")" @ "collision check failed..." );
				}

			}
		}

		// freecam
		if ( container.length <= 0 )
		{
			;
			container.AddItem( tPC.deathCam.points[0] );

		}

		// pick a random ray
		selectedRayIndex = Rand(container.length);

		//`log("Found death cam index at" @ selectedRayIndex);

		// Fill in the rest of the bezier curve that the deathcam will follow
		tPC.deathCam.points[3] = pawn.location + container[selectedRayIndex];

		if ( tPC.deathCam.points[0].X > tPC.deathCam.points[3].X )
		{
			largeNum = tPC.deathCam.points[0].X;
			SmallNum = tPC.deathCam.points[3].X;
		}
		else
		{
			largeNum = tPC.deathCam.points[3].X;
			SmallNum = tPC.deathCam.points[0].X;
		}

		tPC.deathCam.points[1].x = ((largeNum - SmallNum) * 0.75) + SmallNum;
		tPC.deathCam.points[2].x = ((largeNum - SmallNum) * 0.25) + SmallNum;

		if ( tPC.deathCam.points[0].y > tPC.deathCam.points[3].y )
		{
			largeNum = tPC.deathCam.points[0].y;
			SmallNum = tPC.deathCam.points[3].y;
		}
		else
		{
			largeNum = tPC.deathCam.points[3].y;
			SmallNum = tPC.deathCam.points[0].y;
		}

		tPC.deathCam.points[1].y = ((largeNum - SmallNum) * 0.75) + SmallNum;
		tPC.deathCam.points[2].y = ((largeNum - SmallNum) * 0.25) + SmallNum;


		if ( tPC.deathCam.points[0].z > tPC.deathCam.points[3].z )
		{
			largeNum = tPC.deathCam.points[0].z;
			SmallNum = tPC.deathCam.points[3].z;
		}
		else
		{
			largeNum = tPC.deathCam.points[3].z;
			SmallNum = tPC.deathCam.points[0].z;
		}

		tPC.deathCam.points[1].z = ((largeNum - SmallNum) * 0.75) + SmallNum;
		tPC.deathCam.points[2].z = ((largeNum - SmallNum) * 0.25) + SmallNum;

		/*`log( "=============================================" );
		`log( "=============================================" );
		`log( "DeathCam Spline:" @ tPC.deathCam.points[0] @ tPC.deathCam.points[1] @ tPC.deathCam.points[2] @ tPC.deathCam.points[3] );
		`log( "=============================================" );
		`log( "=============================================" );*/

	}
}

//Overridden
reliable server function ServerCamera( name NewMode )
{
    local Actor GetRotation;
    local rotator NewRot, CurrRot;

    if (NewMode == 'Grapple')
    {
        TrueServerCamera(NewMode);
        return;
    }

    if (NewMode == '1st')
    {
			if (TPPlayerCamera(PlayerCamera).TransitionSpeed > 0)
	    		TPPlayerCamera(PlayerCamera).TransitionSpeed *= -1;

			bCamTransition = true;
			SetDesiredFOV(DefaultFOV);
			TPPlayerCamera(PlayerCamera).PushState('PlayerCameraTransition');
    }
	else if ( NewMode == 'DeathCam' )
	{
		// Don't do anything ( intentional )
	}
    else
    {
			// Set the third person rotation of the camera if inside a movement
			// volume that specifies a rotation
			GetRotation = TPPawn(Pawn).GetMovementVolumeActor();
			if (GetRotation != None)
			{
				NewRot  = GetRotation.Rotation;
				CurrRot = Rotation;
				ProcessViewRotation(0, CurrRot, NewRot - CurrRot);
				SetRotation(CurrRot);
			}

			bCamTransition = true;
			TrueServerCamera(NewMode);

			if (TPPlayerCamera(PlayerCamera).TransitionSpeed < 0)
	    		TPPlayerCamera(PlayerCamera).TransitionSpeed *= -1;

			TPPlayerCamera(PlayerCamera).PushState('PlayerCameraTransition');
    }
}


simulated function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
{
	local int Idx;
	local vector cameraLoc;
	local rotator cameraRot;
	local Trigger checkTrigger;
	local SeqEvent_Used	UseSeq;
    local SeqEvent_UsedTP UseSeqTP;
    local float dotAngle;
	local int invIdx;
	local Actor	HitActor;
	local vector HitLoc, HitNorm;

	if (Pawn != None)
	{
		// grab camera location/rotation for checking crosshairDist
		GetPlayerViewPoint(cameraLoc, cameraRot);

		// This doesn't work how it should.  It really needs to query ALL of the triggers and get their
		// InteractDistance and then compare those against the pawn's location and then do the various checks

		// search of nearby actors that have use events
		foreach Pawn.CollidingActors(class'Trigger',checkTrigger,interactDistanceToCheck)
		{
			//`log(self @ "Colliding with trigger" @ checkTrigger @ "with" @ checkTrigger.GeneratedEvents.Length @ "events");

			for (Idx = 0; Idx < checkTrigger.GeneratedEvents.Length; Idx++)
			{
				UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[Idx]);
                UseSeqTP = SeqEvent_UsedTP(UseSeq);

                if (UseSeqTP != None)
                    dotAngle = UseSeqTP.AimToInteractDotAngle;
                else
                    dotAngle = class'SeqEvent_UsedTP'.default.AimToInteractDotAngle;

				if( UseSeq == None )
					continue;

				for(invIdx=0; invIdx<UseSeq.InventoryList.Length; invIdx++)
				{
					if( UseSeq.InventoryList[invIdx] != None && Pawn.InvManager.FindInventoryType( UseSeq.InventoryList[invIdx] ) == None )
					{
						//We are not holding the inventory required by this use action so abort.
						//`log(self @ "Did not use trigger" @ checkTrigger @ "because we are not holding" @ UseSeq.InventoryList[invIdx]);

						UseSeq = None;
						break;
					}

				}

				if( ( ( bUsuableOnly == FALSE ) || ( checkTrigger.GeneratedEvents[Idx].CheckActivate(checkTrigger,Pawn,true)) )
					// check to see if we are looking at the object
					&& ( Normal((checkTrigger.Location/* + checkTrigger.CylinderComponent.Bounds.Origin*/)-cameraLoc) dot vector(cameraRot) >= minDot )

					// if this is an aimToInteract then check to see if we are aiming at the object and we are inside the InteractDistance (NOTE: we need to do use a number close to 1.0 as the dot will give a number that is very close to 1.0 for aiming at the target)
					&& ( ( ( ( UseSeq.bAimToInteract == TRUE ) && ( self.IsAimingAt( checkTrigger, dotAngle ) == TRUE ) && ( VSize(Pawn.Location - (checkTrigger.Location/* + checkTrigger.CylinderComponent.Bounds.Origin*/)) <= UseSeq.InteractDistance ) ) )
					      // if we should NOT aim to interact then we need to be close to the trigger
						|| ( ( UseSeq.bAimToInteract == FALSE ) && ( VSize(Pawn.Location - (checkTrigger.Location/* + checkTrigger.CylinderComponent.Bounds.Origin*/)) <= UseSeq.InteractDistance ) )  // this should be UseSeq.InteractDistance
						  )
				   )
				{
					if (UseButton(checkTrigger) != none && UseButton(checkTrigger).StaticMeshComponent != None)
					{
						if (TraceComponent(HitLoc, HitNorm, UseButton(checkTrigger).StaticMeshComponent, cameraLoc + (vect(1024,0,0) >> cameraRot), cameraLoc, vect(10,10,15)))
						{
							HitActor = Trace(HitLoc, HitNorm, cameraLoc + (vect(1024,0,0) >> cameraRot), cameraLoc, true, vect(10,10,15));
							if ( UseButton(HitActor) != none && UseButton(checkTrigger) == UseButton(HitActor))
							{
								out_useList[out_useList.Length] = checkTrigger;

								//// don't bother searching for more events
								Idx = checkTrigger.GeneratedEvents.Length;
							}
						}
					}
					else
					{

					// Check to see if the door is not locked
					out_useList[out_useList.Length] = checkTrigger;

					// don't bother searching for more events
					Idx = checkTrigger.GeneratedEvents.Length;
					}
				}
				else
				{
//					`log(self @ "   didnot trigger it because" @ "bAimToInteract" @ UseSeq.bAimToInteract
////						@ ( UseSeq != None )
////						@ ( ( bUsuableOnly == FALSE ) || ( checkTrigger.GeneratedEvents[Idx].CheckActivate(checkTrigger,Pawn,true)) )
////						@ ( Normal(checkTrigger.Location-cameraLoc) dot vector(cameraRot) >= minDot )
////						@  ( ( ( UseSeq.bAimToInteract == TRUE ) && ( self.IsAimingAt( checkTrigger, 0.98f ) == TRUE ) && ( VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance ) ) )
////						@ ( ( UseSeq.bAimToInteract == FALSE ) && ( VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance ) )
//
//						@  ( UseSeq.bAimToInteract == TRUE )
//						@  ( self.IsAimingAt( checkTrigger, 0.98f ) == TRUE ) //this one
//						@  ( VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance )
//
//						);

					//`log(self @ "Did not use trigger" @ checkTrigger @ "because of aiming or interact distance");
				}
			}
		}
	}
}

/**
 * Returns Player's Point of View
 * For the AI this means the Pawn's 'Eyes' ViewPoint
 * For a Human player, this means the Camera's ViewPoint
 *
 * @output	out_Location, view location of player
 * @output	out_rotation, view rotation of player
 */
simulated event GetPlayerViewPoint( out vector out_Location, out Rotator out_Rotation )
{
    super.GetPlayerViewPoint(out_Location, out_Rotation);
    // Adding the Camera Shaking Parameters
    out_Rotation = Normalize(out_Rotation + ShakeRot);
	out_Location += ShakeOffset >> Rotation;
}


function OnPictureInPicture(SeqAct_PictureInPicture action)
{


















































}


function GetFreeCamPosition(out vector Pos, out rotator Rot)
{
	local Name oldCamStyle;
	local TViewTarget	tempViewTarget;

	oldCamStyle = PlayerCamera.CameraStyle;
	PlayerCamera.CameraStyle = 'FreeCam';
	ClientSetCameraMode(PlayerCamera.CameraStyle);

	tempViewTarget.Target = PlayerCamera.ViewTarget.Target;

	PlayerCamera.UpdateViewTarget( tempViewTarget, 0.f);
	PlayerCamera.CameraStyle = oldCamStyle;
	ClientSetCameraMode(PlayerCamera.CameraStyle);

	Pos = tempViewTarget.POV.Location;
	Rot = tempViewTarget.POV.Rotation;
}

//for testing pip
exec function gotoFreecam()
{













}

//for testing pip
exec function gohere()
{




























}

//for testing pip
exec function pipaccel(float accel)
{



}
//for testing pip
exec function pipdecel(float decel)
{



}

//for testing pip
exec function away()
{



}

event HostileWarning(TPAIController Attacker)
{
































}


reliable client event ClientMessage( coerce string S, optional Name Type, optional float MsgLifeTime )
{
	if( bAllowClientMessages == false )
		return;

	Super.ClientMessage(S, Type, MsgLifeTime);
}

exec function AllowClientMessages(bool set)
{
	bAllowClientMessages = set;
}


exec function FadeToMusicTrack(Name TrackTypeString)
{
	local array<SequenceObject> ConsoleEvents;
	local Sequence GameSeq;
	local SeqAct_CrossFadeMusicTracks trackAction;

	GameSeq = WorldInfo.GetGameSequence();
	if (GameSeq != None)
	{
		GameSeq.FindSeqObjectsByClass(class'SeqAct_CrossFadeMusicTracks',TRUE,ConsoleEvents);
		if( ConsoleEvents.Length > 0 )
		{
			trackAction = SeqAct_CrossFadeMusicTracks(ConsoleEvents[0]);

			PrevMusicTrack = trackAction.CurrTrackType;

			trackAction.FadeToTrack(TrackTypeString);
		}
	}
}

exec function FadeToPreviousMusicTrack()
{
	FadeToMusicTrack(PrevMusicTrack);
}

//function SendTheComboButton(ComboButtonInfo info)
//{
//	GrapInt.ComboButton(info);
//}
//
event ComboButton(ComboButtonInfo info)
{
	//`log(self @ "combo button event!" @ info.buttonID);

	//pass the event on to the grapple interaction.
	GrapInt.ComboButton(info);

	//self.SendTheComboButton(info);
}
//
//
//
//exec function testcombo()
//{
//	local ComboButtonInfo info;
//	GrapInt.ComboButton(info);
//}



// Chad I removed becuase not used and Set Move Goal is not used the Kynapse way here
//function TellNearestEnemyToComeToMe()
//{
//	local TPPawn p, closestPawn;
//	local float closestPawnDistance;
//
//	closestPawn = None;
//	closestPawnDistance = 10000000.0;
//
//
//	ForEach AllActors(class'TPPawn', p)
//	{
//		if( p!=Pawn &&  VSize(p.Location - Pawn.Location) < closestPawnDistance )
//		{
//			closestPawn = p;
//			closestPawnDistance = VSize(p.Location - Pawn.Location);
//		}
//	}
//
//	if( closestPawn != None )
//	{
//		`log("closestPawn = " @ closestPawn);
//
//		TPAIController(closestPawn.Controller).SetMoveGoal( Pawn, vect(0,0,0), emgtToActor, false);
//
//	}
//
//}

/**
 * Reset Camera Mode to default - Override
 */
event ResetCameraMode()
{
    if ( Pawn != None )
	{	// If we have a pawn, let's ask it which camera mode we should use
		// This may cause issues in MP, investigate.
		TrueServerCamera( Pawn.GetDefaultCameraMode( self ) );
	}
	else
	{	// otherwise default to thirdperson view.
        TrueServerCamera( '1st' );
	}
}

function SetRestrictedAreaVolume( Volume vol )
{
//	m_RestrictedAreaVolume = TPDefendAreaVolume(vol);

	//We have changed volumes.  Since they could be overlapping, search them all

	local TPDefendAreaVolume newVolume;

	m_RestrictedAreaVolume = None;
	ForEach AllActors(class 'TPDefendAreaVolume', newVolume)
	{
		//what if we are in two?  umm
		//if( newVolume.TouchingActor(Pawn) ) //SPARK MAY CODEDROP
		if( newVolume.IsOverlapping(Pawn) )
		{
			m_RestrictedAreaVolume = newVolume;
		}
	}

	/*if( m_RestrictedAreaVolume != None )
		`log(self @ "I am in volume" @ m_RestrictedAreaVolume @ "PeonResponse="@m_RestrictedAreaVolume.PeonResponse);
	else
		`log(self @ "I am in no volume");*/
}

//-----------------------------------------------------------------------
// Function:
// Description:	KISMET action to Display Interact Button
//-----------------------------------------------------------------------
function OnDisplayInteractButton(SeqAct_DisplayInteractButton Action)
{
	local TPHUD myTPHUD;

	myTPHUD = TPHUD(myHud);

    if (Action.InputLinks[0].bHasImpulse)
	{
        myTPHUD.bInteractButton = true;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		myTPHUD.bInteractButton = false;
	}
    else
        myTPHUD.bInteractButton = !myTPHUD.bInteractButton;
}

function ActivateInteractButton(bool bActivate)
{
	local TPHUD myTPHUD;

	myTPHUD = TPHUD(myHud);

    myTPHUD.bInteractButton = bActivate;
}

//test func to switch disguises
exec function disguise(int which)
{














}



//-----------------------------------------------------------------------
// Function:
// Description:	Function to wait for scene anims to finish
//-----------------------------------------------------------------------
function WaitForSceneFinish()
{
    //m_bIsWaitingForSceneFinish = true;
	if (!IsInState('WaitingForSceneAnimFinish'))
    {
       //`AILOG(0, 'AI Disability', "Waiting for scene anim to finish");
	   //ClearYourMindFunc(true, true);
	   GotoState('WaitingForSceneAnimFinish');
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function SceneFinished()
{
//    `AILOG(0, 'AI Disability', "Scene finished - returning to AI control");
//    m_bIsWaitingForSceneFinish = false;
//
//    if (m_bAIDisabled)
//        DisableAI(true, true);
//    else
//        EnableAI(true, true);

//	EvaluateSituation();

    GoToState('PlayerWalking');

}

state WaitingForSceneAnimFinish
{

}

function NotifyChangedWeapon( Weapon PreviousWeapon, Weapon NewWeapon )
{
	super.NotifyChangedWeapon(PreviousWeapon, NewWeapon);

	if (PrevWeaponOnGrenade != None && NewWeapon.IsA('Grenade_Persistent'))
	{
		Grenade_Persistent(NewWeapon).ActualCookTime = class'Grenade_Persistent'.default.CookTime;

		// Investigate if bThrowGrenade has any issues.
		if (bThrowGrenade == true)
		{
			Grenade_Persistent(NewWeapon).SetActualCookTime(class'Grenade_Persistent'.default.CookTime);
			NewWeapon.StartFire(0);
		}
		else
		{
			StartGrenadeCooking();
		}

	}
	else
	{
		if (NewWeapon != none)
		{
			if (GetLCDManager() != none)
			{
				GetLCDManager().ShowMainDisplay();
				GetLCDManager().UpdateWeaponInfo(TPWeapon(NewWeapon));
			}
		}
	}

	bThrowGrenade = false;
}

function StartGrenadeCooking()
{
	;
	Pawn.PlaySound(SoundCue'S_Wpn_Grenade.StickGrenade.StickGrenade_Fuse_Cue');
	SetTimer(0.1, true, 'GrenadeCookTick');
	bAllowGrenadeUse = true;
}

simulated function GrenadeCookTick()
{
	;
	if (Pawn.Weapon.IsA('Grenade_Persistent'))
	{
		Grenade_Persistent(Pawn.Weapon).ActualCookTime -= 0.1;
		if (Grenade_Persistent(Pawn.Weapon).ActualCookTime <= GRENADE_TIME_UP)
		{
			bAllowGrenadeUse = true;
			FastThrowGrenade();
		}
			
	}
}

// End Fast Throw Grenade

state PlayerParachuting
{
    function BeginState(Name PrevState)
    {
        //Pawn.SetPhysics(PHYS_Flying);
		bDontRotatePawn=true;
		bClampView=true;
		Pawn.SetPhysics(PHYS_None);
		PrevRotation = Rotation;
    }

	function PlayerMove( float DeltaTime )
	{
		local vector X, Y, Z, NewVel;
		local rotator NewRot, NewCamRot;

		if (Pawn != none)
		{
			if (!FastTrace(Pawn.Location + vect(0,0,-150), Pawn.Location))
				Pawn.SetPhysics(PHYS_Falling);
		}

		// update 'looking' rotation
		UpdateRotation(DeltaTime);

        if (TPPawn(Pawn).MyParachute != none)
		{
            TPPawn(Pawn).LastStandingLocation.Z = TPPawn(Pawn).MyParachute.Location.Z;

			NewRot = Pawn.Rotation;
			NewCamRot = Rotation;

			GetAxes(Pawn.Rotation, X, Y, Z);

			NewVel += X * PlayerInput.aForward * DeltaTime;
			ParachuteMesh_Persistent(TPPawn(Pawn).MyParachute).DecentVelocity.X = NewVel.X;
			ParachuteMesh_Persistent(TPPawn(Pawn).MyParachute).DecentVelocity.Y = NewVel.Y;

			NewRot.Yaw += PlayerInput.aStrafe * DeltaTime;
			NewCamRot.Yaw += PlayerInput.aStrafe * DeltaTime;
			PrevRotation = NewRot;

			SetRotation(NewCamRot);
			Pawn.FaceRotation(NewRot, deltatime);
          	Pawn.SetLocation (TPPawn(Pawn).MyParachute.Location);
		}
	}

    function EndState (Name NextState)
    {
		// Hack in destroying parachute for now until we get the cloth working
		bDontRotatePawn=false;
		bClampView=false;
		if (Pawn != none)
		{
			TPPawn(Pawn).MyParachute.Destroy();
			TPPawn(Pawn).MyParachute = none;
			Pawn.SetBase(none);
		}
    }

	event bool NotifyLanded (vector HitNormal, actor Wall)
    {
		GoToState('PlayerWalking');
        return false;
    }
}

simulated function OnToggleKynapse(SeqAct_ToggleKynapse Action)
{
	/* not needed any more
	if (action.InputLinks[0].bHasImpulse)
	{
		// turn on
		TPGameInfo(WorldInfo.Game).bKynapseEnabled = true;

	}
	else
	if (action.InputLinks[1].bHasImpulse)
	{
		// turn off
		TPGameInfo(WorldInfo.Game).bKynapseEnabled = false;
	}
	else
	if (action.InputLinks[2].bHasImpulse)
	{
		// toggle
		TPGameInfo(WorldInfo.Game).bKynapseEnabled = !TPGameInfo(WorldInfo.Game).bKynapseEnabled;
	}

	`log("Kynapse toggled:"  @ TPGameInfo(WorldInfo.Game).bKynapseEnabled);
	*/
}


simulated function OnToggleDiagnostics(SeqAct_ToggleDiagnostics inAction)
{
	local TPGameViewportClient viewportClient;

	viewportClient = TPGameViewportClient(LocalPlayer(Player).ViewportClient);

	if (viewportClient != None)
	{
		if (inAction.InputLinks[0].bHasImpulse)
		{
			viewportClient.SetDisplayDiagnostics(true);
		}
		else
		if (inAction.InputLinks[1].bHasImpulse)
		{
			viewportClient.SetDisplayDiagnostics(false);
		}
		else
		if (inAction.InputLinks[2].bHasImpulse)
		{
			viewportClient.ToggleDiagnostics();
		}
	}
}

/**
 * Entry point function for player interactions with the world,
 * re-directs to ServerUse.
 */
exec function Use()
{
	//local bool bUseHandled;

	// Do not perform a use action, if we have a grenade primed...
	if ( PrevWeaponOnGrenade != none )
		return;

	// Or if we are changing weapons
	if (Pawn.InvManager != None && Pawn.InvManager.PendingWeapon != None)
		return;

	if( Role < Role_Authority )
	{
		PerformedUseAction();
		/*if (!bUseHandled && PlayerInput != none)
			PlayerInput.Jump();*/
	}
	ServerUse();
}

reliable server function ServerUse()
{
	//local bool bUseHandled;

	PerformedUseAction();
	/*if (!bUseHandled && PlayerInput != none)
		PlayerInput.Jump();*/
}

exec function ToggleGoggles()
{
	local PlayerPawn myPlayer;

	myPlayer = PlayerPawn(Pawn);

	if (GoggleEffect == None)
	{
		GoggleEffect = MaterialEffect(LocalPlayer(Player).PlayerPostProcess.FindPostProcessEffect('GogglesPost'));
	}

	if (GoggleEffect != None && (!bCinematicMode || bGogglesEnabled) && /*(bAllowGoggles || bGogglesEnabled && !bAllowGoggles) &&*/ (!bIsThirdPerson || bGogglesEnabled))
	{
		TPGameInfo(WorldInfo.Game).ToggleG47UVLights(!bGogglesEnabled);
		GoggleEffect.bShowInGame = !bGogglesEnabled;
		bGogglesEnabled = !bGogglesEnabled;
		if (bGogglesEnabled)
		{
			myPlayer.PlaySound(myPlayer.GoggleStartSound);
			myPlayer.SetTimer(myPlayer.GoggleStartDur, false, 'StartGoggleSound');

			if (myPlayer.bPlayerBlinded)
			{
				//enable the blind post effect if we're currently blinded
				myPlayer.ApplyBlindEffect();
			}
		}
		else
		{
			if (myPlayer.IsTimerActive('StartGoggleSound'))
				myPlayer.ClearTimer('StartGoggleSound');

			if (myPlayer.GoggleEffectAudio.bWasPlaying)
				myPlayer.GoggleEffectAudio.Stop();

			myPlayer.PlaySound(myPlayer.GoggleStopSound);

			if (myPlayer.bPlayerBlinded)
			{
				myPlayer.ClearTimer('FinishBlind');
				myPlayer.FinishBlind();
			}
		}
	}
}

function TurnOffGogglesIfEnabled()
{
	if (bGogglesEnabled)
	{
		ToggleGoggles();
	}
}

function OnSetPlayerGoggles(SeqAct_SetPlayerGoggles Action)
{
	bAllowGoggles = Action.bAllowGoggles;
}

function PawnDied(Pawn P)
{
	ClientPawnDied();
	PrevWeaponOnGrenade = none;
	TPHUD(myHUD).ClearDamageDataIndex();	

	Super.PawnDied(P);
}

/**
 * Client-side notification that the pawn has died.  Any weapon/player/inventory interaction needs to be cleaned up here to ensure clean respawn
 */

reliable client function ClientSetFOV()
{
	FOV(Default.DefaultFOV);
}

reliable client simulated function ClientPawnDied()
{
	// Un-Prime Grenade if dying
	PrevWeaponOnGrenade = none;

	// Turn off ADS 
	DisableAimDownSight();
	FixFOV();
	
	// Disable FX / Scope
	PlayerPawn(Pawn).SetDOFParameters(false, 0, 0, 0);
	
	// Turn off vibration from force feedback.
	ClientStopForceFeedbackWaveform();

	// Clean up the Damage Indicator
	TPHUD(myHUD).ClearDamageDataIndex();

	// Turn off blur affect for grenade damage.
	PlayerPawn(Pawn).ShellShockFinished();

	// Unnotify Weap Pickup if dying
	bDontNotifyClientPickup = true;

	if (TPPlayerInput(PlayerInput) != none)
	{
		// Unduck if dying
		TPPlayerInput(PlayerInput).bDuck = 0;
	}

	// Reset the counters we need to
	Achievements.ClientResetSniperKillCount();
	Achievements.ClientResetGrappleKillCount();

	GetLCDManager().ShowSplash();
	ClientPlayForceFeedbackWaveform(none);
}

   /**
 * Handles the Kismet action to unlock an achievement
 *
 * @param Action the action containing which achievement to unlock
 */
function OnUnlockAchievement(SeqAct_UnlockAchievement Action)
{
	ClientUnlockAchievement(Action.AchievementId);
}

// Checks to see if we need to unlock worldtour
reliable client function ClientCheckWorldTourAchievement()
{
	local int MPMode, MPMapID;
	local OnlineGameSettings GameSettings;

	if (ProfileSettings != none)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings();
		if (GameSettings != none)
		{
			GameSettings.GetStringSettingValue(GAME_MODE, MPMode);
			GameSettings.GetStringSettingValue(CONTEXT_MAPNAME, MPMapID);
			;
			ProfileSettings.SetMPMapPlayed(MPMapID, MPMode);
			WriteProfile(true);
			if (ProfileSettings.PlayedAllMPMaps())
				ClientUnlockAchievement(TA_WORLDTOUR);
		}
	}
}

// Returns TRUE if we're allowed to unlock the indicated Achievement
function bool AchievementAvailable(int AchievementId)
{
	if (TPGameInfo(WorldInfo.Game).CurrentDifficulty == PDO_EASY)
	{
		switch (AchievementId)
		{
			case TA_DEADEYE:
			case TA_DEFENDER:
			case TA_DOLLYMADISONAWARD:
			case TA_GOINGNUCLEAR:
			case TA_ISAVEDTHEGENERAL:
			case TA_NEEDARIDE:
			case TA_PRESIDENTIALMERIT:
			case TA_PRESIDENTIALCITIZENS:
			case TA_PRESIDENTIALFREEDOM:
			case TA_RESERVATIONFORONE:
			case TA_STOWAWAY:
				return FALSE;
		}
	}
	else if (TPGameInfo(WorldInfo.Game).CurrentDifficulty == PDO_NORMAL)
	{
		switch (AchievementId)
		{
			case TA_PRESIDENTIALCITIZENS:
			case TA_PRESIDENTIALFREEDOM:
				return FALSE;
		}
	}
	else if (TPGameInfo(WorldInfo.Game).CurrentDifficulty == PDO_HARD)
	{
		switch (AchievementId)
		{
			case TA_PRESIDENTIALMERIT:
			case TA_PRESIDENTIALFREEDOM:
				return FALSE;
		}
	}
	else if (TPGameInfo(WorldInfo.Game).CurrentDifficulty == PDO_INSANE)
	{
		switch (AchievementId)
		{
			//case TA_DOLLYMADISONAWARD:
			//case TA_GOINGNUCLEAR:
			case TA_PRESIDENTIALMERIT:
			case TA_PRESIDENTIALCITIZENS:
			//case TA_STOWAWAY:
				return FALSE;
		}
	}
	
	return TRUE;
}

/**
 * Unlocks the achievement on the client (can only be done clientside)
 *
 * @param AchievementId the achievement to unlock
 */
reliable client function ClientUnlockAchievement(int AchievementId)
{
	local LocalPlayer LocPlayer;

	if (OnlineSub != None)
	{
		if (!bIsDemoMode && !bIsPreview)
		{
			if (AchievementAvailable(AchievementId))
			{
				// If the extended interface is supported
				if (OnlineSub.PlayerInterfaceEx != None)
				{
					LocPlayer = LocalPlayer(Player);
					;
					OnlineSub.PlayerInterfaceEx.UnlockAchievement(LocPlayer.ControllerId,AchievementId);
				}
				else
				{
					;
				}
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}

/**
 * Registers any game specific datastores
 */
simulated function RegisterPlayerDataStores()
{
	local DataStoreClient DataStoreManager;
	local UIDataStore_TurningPoint TurningPointDataStore;
	local class<UIDataStore_TurningPoint> TurningPointDataStoreClass;
	local LocalPlayer LP;

	// Register the default classes first
	Super.RegisterPlayerDataStores();

	LP = LocalPlayer(Player);

// 	SetMenuPresence();
	SetDefaultPresence();

	if ( OnlinePlayerData != None && OnlinePlayerData.ProfileProvider != None )
	{
		// Get the profile data from the online player data store
		ProfileSettings = TPProfileSettings(OnlinePlayerData.ProfileProvider.Profile);

        Achievements = new(Self) class'TPPlayerAchievements';
		;

		UpdateLocalCacheOfProfileSettings();

		// get a reference to the main data store client
		DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
		if ( DataStoreManager != None && LP != None)
		{
			// now create the Turning Point data store
			TurningPointDataStore = UIDataStore_TurningPoint(DataStoreManager.FindDataStore('TurningPointData',LP));
			if ( TurningPointDataStore == None )
			{
				TurningPointDataStoreClass = class<UIDataStore_TurningPoint>(DataStoreManager.FindDataStoreClass(class'UIDataStore_TurningPoint'));
				if ( TurningPointDataStoreClass != None )
				{
					// find the appropriate class to use for the PlayerSettings data store
					// create the PlayerSettings data store
					TurningPointDataStore = DataStoreManager.CreateDataStore(TurningPointDataStoreClass);
					if ( TurningPointDataStore != None )
					{
						if ( !DataStoreManager.RegisterDataStore(TurningPointDataStore, LP) )
						{
							;
						}
					}
					else
					{
						;
					}
				}
				else
				{
					;
				}
			}
			else
			{
				;
			}

		}
		;
	}
}

/**
 * Unregisters any game specific datastores
 */
simulated function UnregisterPlayerDataStores()
{
	local LocalPlayer LP;
	local DataStoreClient DataStoreManager;
	local UIDataStore_TurningPoint TurningPointDataStore;

	WriteProfile(true);

	Super.UnregisterPlayerDataStores();
	// Clear the ref for GC purposes
	ProfileSettings = None;

	// only execute for local players
	LP = LocalPlayer(Player);
	if ( LP != None )
	{
		// get a reference to the main data store client
		DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
		if ( DataStoreManager != None )
		{
			// unregister the current TurningPoint datastore
			TurningPointDataStore = UIDataStore_TurningPoint(DataStoreManager.FindDataStore('TurningPointData',LP));
			if ( TurningPointDataStore != None )
			{
				if ( !DataStoreManager.UnregisterDataStore(TurningPointDataStore) )
				{
					;
				}
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}
		;
	}
}

exec function ReadProfile()
{
	if (OnlineSub != None)
	{
		;
		OnlineSub.PlayerInterface.ReadProfileSettings(LocalPlayer(Player).ControllerId,ProfileSettings);
	}
}

exec function WriteProfile(optional bool bForceWrite = false)
{
	// Always require at least 5 seconds between writing the profile.
	local Float minTime;
	
	if ( bSystemPauseRequested )
	{
		return;
	}
	
	minTime = (bForceWrite) ? 10 : 300;
	
	if (!bIsDemoMode)
	{
		if (OnlineSub != None && ((WorldInfo.TimeSeconds - LastWriteProfileTime) > minTime) && !bLoginWarningInProgress)
		{
			;
			LastWriteProfileTime = WorldInfo.TimeSeconds;
			OnlineSub.PlayerInterface.WriteProfileSettings(LocalPlayer(Player).ControllerId,ProfileSettings);
		}
		else if ((WorldInfo.TimeSeconds - LastWriteProfileTime) <= 300)
		{
			;
		}
	}
}

function CheckWriteProfile()
{
	local TPGameViewPortClient viewport;

	viewport = TPGameViewPortClient( LocalPlayer(Player).ViewPortClient );

	if (!bIsDemoMode && !bSystemPauseRequested)
	{
		if ( OnlineSub != None && !bLoginWarningInProgress && viewport != none && !viewport.FullScreenIsMoviePlaying() )
		{
			;
		   if (Class'WorldInfo'.Static.IsPS3Build() || !Class'WorldInfo'.Static.IsConsoleBuild())
		   {
				OnlineSub.PlayerInterface.WriteProfileSettings(LocalPlayer(Player).ControllerId,ProfileSettings);
			}
			else
			{
				if ( WorldInfo.NetMode == NM_Standalone )
				{
					LocalPlayer(Player).ViewportClient.UIController.OpenScene(
					WriteProfileScene,
					LocalPlayer(Player));
				}	
			}
		}
	}
}

/** Resets a profile to the default data */
exec function ResetProfile()
{
	local TPProfileSettings ProfSettings;
	if (OnlineSub != None && !bIsDemoMode)
	{
		ProfSettings = new(Outer) class'TPProfileSettings';
		ProfSettings.SetToDefaults();
		UpdateLocalCacheOfProfileSettings();
		OnlineSub.PlayerInterface.WriteProfileSettings(LocalPlayer(Player).ControllerId,ProfSettings);
	}
}

reliable client function ClientIncrementMultiplayerKillCount()
{
	local int ReturnVal;

	//`log(GetFuncName());
	ReturnVal = ProfileSettings.IncrementMPEnemiesKilled(1);
	if (ReturnVal == 1)
		ClientUnlockAchievement(TA_KILLER);
	else if (ReturnVal == 2)
		ClientUnlockAchievement(TA_KILLERINSTINCT);
	else if (ReturnVal == 3)
		ClientUnlockAchievement(TA_MAYBEISHOULDGOOUTSIDE);
}

// this function is called on the client when their MP round is over
reliable client function MPRoundOver(int BulletsFired, int BulletsHit, int Kills)
{
	;
	//Achievements.ClientIncrementBulletsFired(BulletsFired);
	//Achievements.ClientIncrementBulletsHit(BulletsHit);
	if (WorldInfo.GRI.bIsArbitrated)
		Achievements.ClientIncrementMPEnemiesKilled(Kills);

	WriteProfile(true);
}

// ONLY FOR SINGLE PLAYER
function HitEnemyWithBullet()
{
	Achievements.ClientIncrementBulletsHit(1);
}

// Resets all intel as not recieved
exec function ResetIntel()
{
	ProfileSettings.ResetIntelData();
	WriteProfile(true);
}

event bool PlayerHasIntel(int IntelNum)
{
	return ProfileSettings.HaveIntel(IntelNum);
}

function OnHaveAnyIntel(UIAction_HaveAnyIntel Action)
{
	if (ProfileSettings.HaveAnyIntel())
	{
		//`log("I HAVE INTEL BIOTCHES");
		Action.OutputLinks[0].bHasImpulse = TRUE;
	}
	else
	{
		//`log("NO INTEL GATHERED OMGZZ");
	}
}

function OnTogglePlayerJump(SeqAct_TogglePlayerJump Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		bDisableJumpButton = FALSE;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bDisableJumpButton = TRUE;
	}
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bDisableJumpButton = !bDisableJumpButton;
	}
}


reliable client function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
	local MaterialEffect myDamagePost;

	bCinematicMode = bInCinematicMode;

	// if there's a hud, set whether it should be shown or not
	if ( (myHUD != None) && bAffectsHUD )
	{
		myHUD.bShowHUD = !bCinematicMode;
	}

	if (bAffectsMovement)
	{
		IgnoreMoveInput(bCinematicMode);

		if( Pawn != None )
		{
			if( bCinematicMode )
			{
				//`log(self @ "setting player phys to phys_none");
				Pawn.Velocity=vect(0,0,0);
				Pawn.SetPhysics(PHYS_None);
			}
			else
			{
				//`log(self @ "setting player phys to phys_walking");
				Pawn.SetPhysics(PHYS_Walking);
			}
		}
	}
	if (bAffectsTurning)
	{
		IgnoreLookInput(bCinematicMode);
	}

	myDamagePost = MaterialEffect(LocalPlayer(Player).PlayerPostProcess.FindPostProcessEffect('DamagePost'));
	if (bCinematicMode)
	{
		ClearPostMaterials();
		myDamagePost.bShowInGame = false;
	}
	else
	{
		myDamagePost.bShowInGame = true;
	}

}

function HandlePickup(Inventory Inv)
{
	if( StartSpot.IsA('TPPlayerStart') && TPPlayerStart(StartSpot).bEnableHud == false )
		return; //Skip pickup message

	ReceiveLocalizedMessage(Inv.MessageClass,,,,Inv.class);
}

exec function ListConsoleEvents()
{
	//Disabling this - do we need Console Events to print to the screen?
}

// Checkpoint-related code

/////////////////////////////////////////////////////////////////////////////////
// Online Functions for XBOX ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

///**
// * Used to have the server send rich presence information because the Live API
// * doesn't send property/context information for invites
// */
//reliable server function ServerSendRichPresenceInfo()
//{
//	local OnlineGameSettings GameSettings;
//	local OnlineGameInterface GameInterface;
//	local int VersusMode;
//	local int MapId;
//
//	GameInterface = OnlineSub.GameInterface;
//	if (GameInterface != None)
//	{
//		GameSettings = GameInterface.GetGameSettings();
//		// Determine if this is a coop match or not so the right
//		// rich presence string can be set
//		if (GameSettings != None)
//		{
//			// Set the map name
//			//MapId = DetermineMapStringId(name(GetURLMap()));
//			// Tell the client what to set
//			//ClientSetTDMRichPresence(VersusMode,MapId);
//		}
//	}
//}
//
///**
// * Tells the client what the rich presence info is
// *
// * @param VersusMode the mode to register
// * @param MapId the map to update
// */
//reliable client function ClientSetTDMRichPresence(int VersusMode,int MapId)
//{
//	local OnlinePlayerInterfaceEx PlayerInterface;
//	local LocalPlayer LocPlayer;
//	local LocalizedStringSetting Setting;
//	local array<LocalizedStringSetting> Contexts;
//	local array<SettingsProperty> Properties;
//
//	LocPlayer = LocalPlayer(Player);
//
//	if (LocPlayer != None && OnlineSub != None)
//	{
//		PlayerInterface = OnlineSub.PlayerInterfaceEx;
//		// Update the rich presence string
//		PlayerInterface.SetRichPresence(LocPlayer.ControllerId,1,Contexts,Properties);
//	}
//}
//
///**
// * Looks at the current game settings object and uses that to set the
// * rich presence strings
// */
//reliable client function ClientSetRichPresence()
//{
//	local OnlineGameSettings GameSettings;
//	local OnlineGameInterface GameInterface;
//	local OnlinePlayerInterfaceEx PlayerInterface;
//	local LocalPlayer LocPlayer;
//	local LocalizedStringSetting Setting;
//	local array<LocalizedStringSetting> Contexts;
//	local array<SettingsProperty> Properties;
//	local name MapName;
//	local int Ignored;
//	local int GameMode;
//
//	LocPlayer = LocalPlayer(Player);
//
//	if (LocPlayer != None && OnlineSub != None)
//	{
//		GameInterface = OnlineSub.GameInterface;
//		PlayerInterface = OnlineSub.PlayerInterfaceEx;
//		// Make sure the interfaces are supported. Might not be depending on the
//		// platform involved
//		if (GameInterface != None && PlayerInterface != None)
//		{
//			// Figure out if we are playing locally or not
//			GameSettings = GameInterface.GetGameSettings();
//			if (GameSettings != None)
//			{
//				PlayerInterface.SetRichPresence(LocPlayer.ControllerId,1,Contexts,Properties);
//				`log("Got Here!!!!!!!!!!!!");
//			}
//		}
//	}
//}

function UpdateGamerTag()
{
	local LocalPlayer LocPlayer;
	local string Gamertag;

	if (OnlineSub != None)
	{
		LocPlayer = LocalPlayer(Player);
		if (LocPlayer != None)
		{
			// Read the gamertag for this player and change our name to it
			Gamertag = OnlineSub.PlayerInterface.GetPlayerNickname(LocPlayer.ControllerId);
			// Use a server function to do this
			ServerSetGamerTag(Gamertag);
		}
	}
}

/** Used to assign the gamertag as the player name for multiplayer matches */
event InitUniquePlayerId()
{
	UpdateGamerTag();

	Super.InitUniquePlayerId();
}

/**
 * Sets the player name to the client's gamertag so it can be replciated
 * to all clients
 *
 * @param Gamertag the new name to use
 */
reliable server function ServerSetGamerTag(string Gamertag)
{
	local OnlineGameSettings GameSettings;

	GameSettings = OnlineSub.GameInterface.GetGameSettings();
	if (GameSettings != None && GameSettings.bIsLanMatch && !WorldInfo.IsConsoleBuild(CONSOLE_Xbox360))
	{
		//SetName(ProfileSettings.GetLocalAccountName());
		return;
	}

	PlayerReplicationInfo.SetPlayerName(Gamertag);
}

function ActivateRemoteEvent(name EventName)
{
	//local array<SequenceEvent> OutEvents; //SPARK MAY CODEDROP
	local array<SequenceObject> OutEvents;
	
	local SeqEvent_RemoteEvent RemoteEvt;
	local int i;

	if (EventName == '')
		return;

	if (WorldInfo.GetGameSequence() != None)
	{
		WorldInfo.GetGameSequence().FindSeqObjectsByClass(class'SeqEvent_RemoteEvent',TRUE,OutEvents);

		for (i = 0; i < OutEvents.Length; i++)
		{
			RemoteEvt = SeqEvent_RemoteEvent(OutEvents[i]);
			if (RemoteEvt != none && RemoteEvt.EventName == EventName)
			{
				if ( RemoteEvt.bEnabled)
				{
					// check activation for the event
					RemoteEvt.CheckActivate(self,self,false);
				}
			}
		}
	}
}

exec function TestDialogBox()
{
	DisplayMessageBox("a","B", true);

}

exec function TestReopenRoot()
{
	ActivateRemoteEvent('ReopenRoot');
}

/** Logs the change in login status to show the event is working */
function LoginChanged()
{
	local	int	currID;

	;
	;
	;
	;
	;
	//
	// Loop through the local controllers looking for the one that is actually playing the game.
	//
	for ( currID = 0; currID < 4; currID++ )
	{
		//
		// If we are the guy who is actually playing the game, then we have to do some logic to
		// set his status to exactly what he is doing.
		//
		if ( LocalPlayer(Player).ControllerId == currID )
			DoLoginChange();
	}
}

function bool HasInactiveProfile()
{
	local int	currID;
	local bool	bHasInactiveProfile;
	
	bHasInactiveProfile = false;
	for ( currID = 0; currID < 4; currID++ )
	{
		if ( OnlineSub.PlayerInterface.GetLoginStatus(currID) >= LS_UsingLocalProfile && LocalPlayer(Player).ControllerId != currID )
		{
			bHasInactiveProfile = true;
			break;
		}
	}

	return bHasInactiveProfile;
}


/** Logs the change in login status to show the event is working */
function InactiveLoginChanged()
{
	local	int	currID;

	local	array<LocalizedStringSetting>	Contexts;
	local	array<SettingsProperty>			Properties;
	local	UIScene_BaseFrontEnd topScene;

	;
	;
	;
	;
	;

	//
	// Loop through the local controllers.  We don't know who changed their status, but this function
	// will only get called for the inactive player.  So change them all.
	//
	for ( currID = 0; currID < 4; currID++ )
	{
		//
		// If we are the guy who is actually playing the game, then we have to do some logic to
		// set his status to exactly what he is doing.
		//
		if ( LocalPlayer(Player).ControllerId != currID )
			OnlineSub.PlayerInterface.SetOnlineStatus( currID, NOT_PLAYING_PRESENCE, Contexts, Properties );
	}

	topScene = UIScene_BaseFrontEnd(GetUIController().SceneClient.GetActiveScene());
	// If an inactive profile changes for a player, then we must affect the player now due to weird ?failed problems with inactive tag-alongs ( GOW Does this )
	if ( ( topScene != none && topScene.bonlinemenu ) || WorldInfo.NetMode != NM_Standalone ) // If we are in a MP Menu, or a MP Game.
	{
		DoLoginChange();
	}

	
}

function OnDeviceChanged()
{
	local int DeviceID;
	local bool bResult;
	local OnlinePlayerInterfaceEx PlayerInterfaceEx;
	
	local DataStoreClient DataStoreManager;
	local UIDataStore_TPGameSettings TPGameSettings;

	bResult = false;
	// Everytime a device is removed or added while the currently selected device is invalid,
	// reset the "error already displayed" flag.
	if (ProfileSettings != none)
	{
		DeviceID = ProfileSettings.GetCurrentDeviceID();

		// Figure out if wehave an online subsystem registered
		if (OnlineSub != None)
		{
			PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;

			if(PlayerInterfaceEx != none)
			{
				bResult = PlayerInterfaceEx.IsDeviceValid(DeviceID);
			}
		}
		
		if (bResult == FALSE)
		{
			DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
			if ( DataStoreManager != None )
			{
				// now create the Turning Point data store
				TPGameSettings = UIDataStore_TPGameSettings(DataStoreManager.FindDataStore('TPGameSettings',none));
				if ( TPGameSettings != None )
				{
					TPGameSettings.DisplayedStorageDeviceError = 0;
				}
			}
		}
	}
}

/*
native function GetAllDevices(INT DeviceID);

function CallDeviceChangedScene()
{
	local int DeviceID;
	
	// If they changed their storage device, update the profile with the new device.
	if (ProfileSettings != none)
	{
		DeviceID = ProfileSettings.GetCurrentDeviceID();
	}

		`Log("Storage device removed - starting UI.");
		GetAllDevices(DeviceID);
		GetUIController().OpenScene(DeviceChangedScene, LocalPlayer(Player));
}
*/

function DoLoginChange()
{
	//local UIScene_BaseFrontEnd topScene;
	local string feTitle,feMessage;
	local GameUISceneClient SceneClient;
	local bool bLoggedIn;
	local UIScene_BaseFrontEnd topScene;

	bLoginChanged = true;
	feTitle = Localize("XboxMessageBox", "LoginChangeTitle", "TPGame");
	feMessage = Localize("XboxMessageBox", "LoginChangeMessage", "TPGame");

	;
	;
	;
	;
	;
	;

	//topScene = UIScene_BaseFrontEnd(GetUIController().SceneClient.GetActiveScene());

	// Don't handle login changed messages when in the IIS screen.
	//if ( topScene == GetUIController().RootScene )
	if ( UIScene_PressStart(GetUIController().SceneClient.GetActiveScene()) != none )
	{
		return;
	}

	// Ignore login changed messages that are when the active player, is in-game for SP, and his account is still at least active, keep him in-game and ignore the callback
	if (GetCurrentLevelName() != "entry_master" && OnlineSub.PlayerInterface.GetLoginStatus(LocalPlayer(Player).ControllerId) >= LS_UsingLocalProfile )
		return;

	if ( WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !bLoginWarningInProgress )
	{
		SceneClient = class'UIRoot'.static.GetSceneClient();
		if ( SceneClient != None )
		{
			bLoggedIn = OnlineSub.PlayerInterface.GetLoginStatus(LocalPlayer(Player).ControllerId) >= LS_UsingLocalProfile;

			SceneClient.NotifyLoginStatusChanged(bLoggedIn);
		}

		if (GetCurrentLevelName() != "entry_master")
		{
			bLoginWarningInProgress = true;

			if (OnlineSub != None && OnlineSub.PlayerInterfaceEx != None)
			{
				if (WorldInfo.NetMode == NM_Standalone)
				{
					;
					// All FE Messages in reagrds to profile change should bring the user back to the IIE ( Press Start ) due to TRC
					SetFrontEndErrorMessage(feTitle,feMessage,false);
					LocalTravel("entry_master");
				}
				else
				{
					;
					// All FE Messages in reagrds to profile change should bring the user back to the IIE ( Press Start ) due to TRC
					SetFrontEndErrorMessage(feTitle,feMessage,false);
					
					if (WorldInfo.GRI.bIsArbitrated)
					{
						DestroyOnlineSession();
						ConsoleCommand("Disconnect");
					}
					else
					{
						EndOnlineGame();
						ConsoleCommand("Disconnect");
					}
				}
			}
		}
		else
		{
			;
			// All FE Messages in reagrds to profile change should bring the user back to the IIE ( Press Start ) due to TRC
			SetFrontEndErrorMessage(feTitle,feMessage,false);
			ConsoleCommand("Disconnect");
		}

	}
	else
	{
		topScene = UIScene_BaseFrontEnd(GetUIController().SceneClient.GetActiveScene());
;
		// If we are in an online menu
		if ( WorldInfo.NetMode == NM_STANDALONE && topScene != none && topScene.bonlinemenu && OnlineSub.PlayerInterface.GetLoginStatus(LocalPlayer(Player).ControllerId) != LS_LoggedIn )
		{
;
			;
			SetDisconnectionError(FRONTEND_MENU, true);

			SceneClient = class'UIRoot'.static.GetSceneClient();
			if ( SceneClient != None )
			{
				SceneClient.NotifyLoginStatusChanged(false);
			}
			
			ActivateRemoteEvent('ReopenRoot');
		}
	}
}

/** Logs the change in muting list to show the event is working */
function MutingChanged()
{
	;
}

/** Logs the change in friends list to show the event is working */
function FriendsChanged()
{
	;
}

/** Logs the change in content to show the event is working */
function ContentChanged()
{
	;
}

/** Tells this client that it should send voice data over the network */
reliable client function ClientStartNetworkedVoice()
{
	local LocalPlayer LocPlayer;

	LocPlayer = LocalPlayer(Player);
	if (LocPlayer != None && OnlineSub != None && OnlineSub.VoiceInterface != None)
	{
		if (CanCommunicate())
			OnlineSub.VoiceInterface.StartNetworkedVoice(LocalPlayer(Player).ControllerId);
		else
			OnlineSub.VoiceInterface.StopNetworkedVoice(LocalPlayer(Player).ControllerId);
	}
}

/**
 * Locally mutes a remote player
 *
 * @param PlayerNetId the remote player to mute
 */
reliable client event ClientMutePlayer(UniqueNetId PlayerNetId)
{
	local LocalPlayer LocPlayer;

	if (VoiceInterface != None)
	{
		// Use the local player to determine the controller id
		LocPlayer = LocalPlayer(Player);
		if (LocPlayer != None)
		{
			// Have the voice subsystem mute this player
			VoiceInterface.MuteRemoteTalker(LocPlayer.ControllerId,PlayerNetId);
		}
	}
}

/**
 * Locally unmutes a remote player
 *
 * @param PlayerNetId the remote player to unmute
 */
reliable client event ClientUnmutePlayer(UniqueNetId PlayerNetId)
{
	local LocalPlayer LocPlayer;

	if (VoiceInterface != None)
	{
		// Use the local player to determine the controller id
		LocPlayer = LocalPlayer(Player);
		if (LocPlayer != None)
		{
			if (OnlineSub.PlayerInterface.IsMuted(LocalPlayer(Player).ControllerId, PlayerNetId))
				VoiceInterface.MuteRemoteTalker(LocPlayer.ControllerId,PlayerNetId);
			// Have the voice subsystem restore voice for this player
			else
				VoiceInterface.UnmuteRemoteTalker(LocPlayer.ControllerId,PlayerNetId);
		}
	}
}

reliable client function ClientWasKicked()
{
	ClientSetProgressMessage(PMT_ConnectionFailure, Localize("AccessControl", "KickedMsg", "Engine"));
}

//// Updates my mutelist if I cant communicate
//reliable client function ClientUpdateMuteList(UniqueNetId OtherPlayerId)
//{
//	local LocalPlayer LocPlayer;
//
//	LocPlayer = LocalPlayer(Player);
//
//	if (LocPlayer != None && OnlineSub != None && OnlineSub.VoiceInterface != None)
//	{
//		// If we cant communicate due to privledges then stop voice communications and mute other players
//		if (!CanCommunicate())
//		{
//			OnlineSub.VoiceInterface.StopNetworkedVoice(LocalPlayer(Player).ControllerId);
//			ServerMutePlayer(OtherPlayerId);
//		}
//		else
//		{
//			OnlineSub.VoiceInterface.StartNetworkedVoice(LocalPlayer(Player).ControllerId);
//			
//			// Check to see if we have person muted form the dashboard.  If so, then mute the player.
//			//if (OnlineSub.PlayerInterface.IsMuted(LocalPlayer(Player).ControllerId, OtherPlayerId))
//			//	ServerMutePlayer(OtherPlayerId);
//			//else
//				ServerUnmutePlayer(OtherPlayerId);
//		}
//	}
//}

simulated function bool CanCommunicate()
{
	local int PlayerIdx;
	local EFeaturePrivilegeLevel PrivLevel;
	
	for ( PlayerIdx = 0; PlayerIdx < 4; PlayerIdx++ )
	{
		if( OnlineSub.PlayerInterface.GetLoginStatus(PlayerIdx) != LS_NotLoggedIn )
		{
			PrivLevel = OnlineSub.PlayerInterface.CanCommunicate(PlayerIdx);
			
			if (PrivLevel < FPL_Enabled)
			{
				;
				return false;
			}
		}
	}

	;
	return true;
}

/** Logs the online game we created has completed */
function GameCreateDone(bool bWasSuccessful)
{
	local array<int> LinkIndices;

	;

	if (!bWasSuccessful)
	{
		LinkIndices[0] = 3;
		// Tell the UI that the joining is complete
		//GetUIController().SceneClient.GetTopmostScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);
		GetUIController().SceneClient.GetActiveScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);
	}
	else
	{
		DeInitCallbacks();

		LinkIndices[0] = 0;

		// Tell the UI that the game session is created
		//GetUIController().SceneClient.GetTopmostScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);
		GetUIController().SceneClient.GetActiveScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);

		/*ClientTravel*/LocalTravel("?MapCycle="$TPGameInfo(WorldInfo.Game).GameHostURL$"?Game=TPGame.TPMultiplayerGameInfo?Listen?Team=255?Name="$OnlineSub.PlayerInterface.GetPlayerNickname(LocalPlayer(Player).ControllerId));
	}
}

/**
 * Checks to see if controller 0 & 1 are friends. NOTE: Requires that both
 * controllers are signed in
 */
exec function CheckFriends()
{
	local UniqueNetId Xuid2;
	if (OnlineSub != None)
	{
		// Check controllers 0 & 1 for friendship
		OnlineSub.PlayerInterface.GetUniquePlayerId(1,Xuid2);
		if (OnlineSub.PlayerInterface.IsFriend(0,Xuid2) == true)
		{
			;
		}
	}
}

/**
 * Pops up the friends ui for controller 0
 */
exec function ShowFriendsUI()
{
	if (OnlineSub != None)
	{
		if (OnlineSub.PlayerInterface.ShowFriendsUI(0) == true)
		{
			;
		}
		else
		{
			;
		}
	}
}

/** Pops up the friends invite ui for controller zero inviting controller one */
exec function ShowFriendsInviteUI()
{
	local UniqueNetId Xuid1;
	if (OnlineSub != None)
	{
		OnlineSub.PlayerInterface.GetUniquePlayerId(1,Xuid1);
		if (OnlineSub.PlayerInterfaceEx.ShowFriendsInviteUI(0,Xuid1) == true)
		{
			;
		}
		else
		{
			;
		}
	}
}

/** Logs the online game we deleted has completed */
function GameDestroyDone(bool bWasSuccessful)
{
	;
	OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(GameDestroyDone);
	InitCallbacks();

	if (bInvitedToGame)
	{
		// Set the delegate for notification of the join completing
		OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
		// We can immediately accept since there is no online game
		OnlineSub.GameInterface.AcceptGameInvite(LocalPlayer(Player).ControllerId);
		return;
	}

	if (bWasSuccessful && WorldInfo.NetMode != NM_Standalone)
	{
		SetFrontEndErrorMessage("", "", true, true);
		ConsoleCommand("Disconnect");
	}
}

/** Logs the online game search we kicked off has completed */
function GameSearchDone(bool bWasSuccessful)
{
	local OnlineGameSearch Search;
	local OnlineGameSearch.OnlineGameSearchResult SearchResult;
	local array<int> LinkIndices;

	;

	if (OnlineSub != None)
	{
		// Get the object so we can inspect the results
		Search = OnlineSub.GameInterface.GetGameSearch();
		if (Search.Results.Length > 0)
		{
			//@fixme ronp - TTPRO #40059
            SearchResult = Search.Results[0];
			OnlineSub.GameInterface.JoinOnlineGame(LocalPlayer(Player).ControllerId,SearchResult);
		}
		else
		{
			LinkIndices[0] = 3;
			// Tell the UI that the joining is complete
			//GetUIController().SceneClient.GetTopmostScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);
			GetUIController().SceneClient.GetActiveScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);
			//GetUIController().SceneClient.OpenScene(UIScene'UI_TPFrontEnd.ConnectionError');
			;
		}
	}
}

exec function UnlockWorldTour()
{
	local int i, j;

	for (i = 0; i < 2; i++)
	{
		for (j = 0; j < 4; j++)
		{
			ProfileSettings.SetMPMapPlayed(j, i);
		}
	}

	if (ProfileSettings.PlayedAllMPMaps())
		ClientUnlockAchievement(TA_WORLDTOUR);
}
/** Releases the search results allocated data */
function GameJoinDone(bool bWasSuccessful)
{
	local OnlineGameSearch GameSearch;
	local LocalPlayer LocPlayer;
	local string URL;
	local int GameMode, MapID;
	local int colIndex;

	;

	if (!bWasSuccessful)
	{
		OnlineSub.GameInterface.FreeSearchResults();
		;
	}
	else
	{
		if (OnlineSub != None && OnlineSub.GameInterface != None)
		{
			if (OnlineSub.GameInterface.GetResolvedConnectString(URL))
			{
				;

				// Remove the port from the URL Connection string
				if ( WorldInfo.IsPs3Build() || !WorldInfo.IsConsoleBuild() )
				{
					colIndex = InStr(URL, ":");
					URL = Left(URL, colIndex);
				}
				//PlayerName = "Player";
				if (OnlineSub != None)
				{
					//PlayerName = OnlineSub.PlayerInterface.GetPlayerNickname(0);
					if (OnlineSub.PlayerInterfaceEx != None)
					{
						LocPlayer = LocalPlayer(Player);
						if (LocPlayer != None)
						{
							// Force a faster update to the rich presence string
							//***SPCODEDROP JUNEQA_BUILD: MP CHECKME - REPLACED with SetOnlineStatus() ---> OnlineSub.PlayerInterfaceEx.SetRichPresence(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
							GameSearch = OnlineSub.GameInterface.GetGameSearch();
							TPDMOnlineGameSearch(GameSearch).GetStringSettingValue(GAME_MODE, GameMode);
							TPDMOnlineGameSearch(GameSearch).GetStringSettingValue(CONTEXT_MAPNAME, MapID);

							UpdateMPRichPresence( MapID, int(GameSearch.bIsLanQuery), TPGameReplicationInfo(WorldInfo.GRI).GameStatus, GameMode );

							//ProfileSettings.SetMPMapPlayed(MapID, GameMode);
							WriteProfile(true);
							/*if (ProfileSettings.PlayedAllMPMaps())
								ClientUnlockAchievement(TA_WORLDTOUR);*/

//KMM
// 							if (GameMode == 0)
// 							{
// 								OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_DM_PRESENCE,Contexts,Properties);
// 							}
// 							else
// 							{
// 								OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
// 							}
						}
					}
				}

				DeInitCallbacks();

				if (Pawn.PlayerReplicationInfo.Team.TeamIndex == T_PARTISAN)
				{
					CharacterIndex = int(GetDefaultURL("AllyMesh"));
					TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = PartisanList[CharacterIndex];
				}
				else
				{
					CharacterIndex = int(GetDefaultURL("AxisMesh"));
					TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = NaziList[CharacterIndex];
				}
    			// Print out which IP we are connecting to
				;

                OnlineSub.GameInterface.FreeSearchResults();
				;
				
				ConsoleCommand("open "$URL$"?Team=255");
			}
		}
	}
}

exec function GetMapsPlayed()
{
	local int mapMask;
	ProfileSettings.GetProfileSettingValueInt(310 , mapMask);
	;

}

/**
 * Delegate called when the user accepts a game invite externally. This allows
 * the game code a chance to clean up before joining the game via
 * AcceptGameInvite() call.
 *
 * NOTE: There must be space for all signed in players to join the game. All
 * players must also have permission to play online too.
 *
 * @param GameInviteSettings the settings for the game we're to join
 */
function OnGameInviteAccepted(OnlineGameSettings GameInviteSettings)
{
	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		if (GameInviteSettings != None)
		{
			// Make sure the new game has space
			if (InviteHasEnoughSpace(GameInviteSettings))
			{
				// Make sure everyone logged in can play online
				if (CanAllPlayersPlayOnline())
				{
					bIgnoreCloseNotify = true;
					if (WorldInfo.NetMode != NM_Standalone/* && TPGameReplicationInfo(WorldInfo.GRI).GameStatus != GS_Lobby*/)
					{
						WorldInfo.GRI.bNeedsOnlineCleanup = false;
						// Write arbitration data, if required
						if (OnlineSub.GameInterface.GetGameSettings().bUsesArbitration)
						{
							// Write out our version of the scoring before leaving
							ClientWriteOnlinePlayerScores();
						}
						// Set the end delegate, where we'll destroy the game and then join
						OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndForInviteComplete);
						// Force the flush of the stats
						OnlineSub.GameInterface.EndOnlineGame();
					}
					else
					{
						bInvitedToGame = true;
						DestroyOnlineSession();
					}
				}
				else
				{
					// Display an error message
					NotifyNotAllPlayersCanJoinInvite();
				}
			}
			else
			{
				// Display an error message
				NotifyNotEnoughSpaceInInvite();
			}
		}
		else
		{
			// Display an error message
			NotifyInviteFailed();
		}
	}
}

/**
 * Delegate called once the destroy of an online game before accepting an invite
 * is complete. From here, the game invite can be accepted
 */
function OnDestroyForInviteComplete(bool bWasSuccessful)
{
	local int i;
	local bool bJoinSuccess;

	if (bWasSuccessful)
	{
		// Set the delegate for notification of the join completing
		OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
		
		for (i = 0; i < 4; i++)
		{
			// This will have us join async
			if ( OnlineSub.GameInterface.AcceptGameInvite(i) )
			{
				bJoinSuccess = true;
				break;
			}
		}
		if (!bJoinSuccess)
			OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
	}
	else
	{
		// Do some error handling
		NotifyInviteFailed();
	}
}

/**
 * Once the join completes, use the platform specific connection information
 * to connect to it
 *
 * @param bWasSuccessful whether the join worked or not
 */
function OnInviteJoinComplete(bool bWasSuccessful)
{
	local OnlineGameSearch GameSearch;
	local LocalPlayer LocPlayer;
	local string URL;
	local int GameMode, MapID;
	//local string PlayerName;

	;
	// KMSK: Inactive (4)
	if ( HasInactiveProfile() )
	{
		NotifyInviteFailed(Localize("XboxMessageBox", "InactiveProfileHostMessage", "TPGame"),Localize("XboxMessageBox", "SignInToLiveTitle", "TPGame"));
		return;
	}

	if (bWasSuccessful)
	{
		;
		bIgnoreCloseNotify = true;

		if (OnlineSub != None && OnlineSub.GameInterface != None)
		{
			;
			// Set the delegate for notification of the join completing
			OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(GameJoinDone);
			// Get the platform specific information
			if (OnlineSub.GameInterface.GetResolvedConnectString(URL))
			{
				;
				//`Log("Resulting url is ("$URL$")");
				// Open a network connection to it
				//ConsoleCommand("open "$URL);
				//PlayerName = OnlineSub.PlayerInterface.GetPlayerNickname(0);
				if (OnlineSub.PlayerInterfaceEx != None)
				{
					;
					LocPlayer = LocalPlayer(Player);
					if (LocPlayer != None)
					{
						;
						GameSearch = OnlineSub.GameInterface.GetGameSearch();
						TPDMOnlineGameSearch(GameSearch).GetStringSettingValue(GAME_MODE, GameMode);
						TPDMOnlineGameSearch(GameSearch).GetStringSettingValue(CONTEXT_MAPNAME, MapID);

						UpdateMPRichPresence( MapID, int(GameSearch.bIsLanQuery), TPGameReplicationInfo(WorldInfo.GRI).GameStatus, GameMode );

						//ProfileSettings.SetMPMapPlayed(MapID, GameMode);
						//WriteProfile(true);
						/*if (ProfileSettings.PlayedAllMPMaps())
							ClientUnlockAchievement(TA_WORLDTOUR);*/

//KMM
// 						if (GameMode == 0)
// 						{
// 							OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_DM_PRESENCE,Contexts,Properties);
// 						}
// 						else
// 						{
// 							OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
// 						}
						// Force a faster update to the rich presence string
						//***SPCODEDROP JUNEQA_BUILD: MP CHECKME - REPLACED with SetOnlineStatus() ---> OnlineSub.PlayerInterfaceEx.SetRichPresence(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
					//	OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
					}
				}

				DeInitCallbacks();

				;

			/*	if (Pawn.PlayerReplicationInfo.Team.TeamIndex == T_PARTISAN)
				{
					CharacterIndex = int(GetDefaultURL("AllyMesh"));
					TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = PartisanList[CharacterIndex];
				}
				else
				{
					CharacterIndex = int(GetDefaultURL("AxisMesh"));
					TPPlayerReplicationInfo(PlayerReplicationInfo).CharacterInfo = NaziList[CharacterIndex];
				}*/

				bInvitedToGame = false;
				ClientLoadingScreen(false);

				;
				;
				ConsoleCommand("open "$URL$"?Team=255?bIsFromInvite");
				;
			}
		}
	}
	else
	{
		// Do some error handling
		NotifyInviteFailed();
		;
	}
	;
}

/**
 * Starts a match that has been registered
 */
exec function StartOnlineGame()
{
	;

	if (OnlineSub != None)
	{
		OnlineSub.GameInterface.StartOnlineGame();
	}
}

/** Logs the completion of an async task */
function GameStartDone(bool bWasSuccessful)
{
	;
}

/** Logs the completion of an async task */
function GameEndDone(bool bWasSuccessful)
{
	;

	OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(GameEndDone);

	//bIgnoreCloseNotify = false;

	DestroyOnlineSession();

	//InitCallbacks();

	//if (bWasSuccessful)
	//	ConsoleCommand("disconnect");
}

/**
 * Ends a match that has been registered and started
 */
exec function EndOnlineGame()
{
	if (OnlineSub != None && WorldInfo.NetMode != NM_Standalone)
	{
		bQuitOnlineGame = true;
		SetMenuPresence();
		;
		OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(GameEndDone);
		OnlineSub.GameInterface.EndOnlineGame();
	}
}

/** Starts a read of the friends data */
exec function ReadFriends()
{
	;

	if (OnlineSub != None)
	{
		OnlineSub.PlayerInterface.ReadFriendsList(LocalPlayer(Player).ControllerId);
	}
}

/** Dumps all of the friends data when called */
function ReadFriendsListDone(bool bWasSuccessful)
{
	local array<OnlineFriend> Friends;
	local int Index;

	;

	if (OnlineSub != None)
	{
		OnlineSub.PlayerInterface.GetFriendsList(LocalPlayer(Player).ControllerId,Friends);
	}
	// Dump each friend in the list
	for (Index = 0; Index < Friends.Length; Index++)
	{
		;
		;
		;
		;
		;
		;
		;
	}
}

/** Function to query if there are any downloable content packages available */
exec function QueryDownloableContent()
{
	if (OnlineSub != None && OnlineSub.ContentInterface != None)
	{
		OnlineSub.ContentInterface.QueryAvailableDownloads(0);
	}
}

/** Delegate that logs the content availability */
function DownloadableContentQueryDone(bool bWasSuccessful)
{
	local int NewDownloads;
	local int TotalDownloads;
	if (OnlineSub != None && OnlineSub.ContentInterface != None)
	{
		if (bWasSuccessful)
		{
			OnlineSub.ContentInterface.GetAvailableDownloadCounts(LocalPlayer(Player).ControllerId,NewDownloads,TotalDownloads);
		}
		else
		{
			;
		}
	}
	;
}

function bool IsMultiplayerConfirmationBox()
{
	local UIScene_BaseFrontEnd	prevScene;
	local UIScene				curScene;

	curScene = GetUIController().SceneClient.GetActiveScene();

	//`log("KMSK - IsMultiplayerConfirmationBox 1");
	if ( UIScene_Confirmation( curScene ) != None )
	{
		//`log("KMSK - IsMultiplayerConfirmationBox 2");
		prevScene = UIScene_BaseFrontEnd( curScene.GetPreviousScene(false) );

		if ( prevScene != none && prevScene.bOnlineMenu )
		{
			//`log("KMSK - This is an online confirmation box");
			GetUIController().SceneClient.CloseScene(curScene);
			
			return true;
		}
			
	}

	return false;

}

function OnConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus)
{
	local UIScene_BaseFrontEnd	topScene;
	local OnlineGameSettings	GameSettings;
	local bool					inMenu;	

	;
	;
	;
	;
	;

	// Do not handle live messages if already in single player game.
	if ( GetCurrentLevelName() != "entry_master" && WorldInfo.NetMode == NM_STANDALONE )
		return;

	// We know we have an online subsystem or this delegate wouldn't be called
	GameSettings = OnlineSub.GameInterface.GetGameSettings();

	// If we are not in a single player game.
	topScene = UIScene_BaseFrontEnd(GetUIController().SceneClient.GetActiveScene());

	// We are in menu if our current UI Scene is an online menu, or if our dialog box's parent is a multiplayer menu.
	if ( IsMultiplayerConfirmationBox() || ( topScene!= none && topScene.bonlinemenu ) )
		inMenu = true;

	; // OSCS_NotConnected on signout.

	if (GameSettings != None || inMenu)
	{
		// If we are a Live match, this really matters
		if (!GameSettings.bIsLanMatch || inMenu)
		{
			// We are playing a Live match. Determine whether the connection
			// status change requires us to drop and go to the menu
			switch (ConnectionStatus)
			{
				case OSCS_DuplicateLoginDetected:

					if ( inMenu )
						GetUIController().SceneClient.CloseScene(topScene);	// TODO: May need to Fix for PC, in case closing scene and SetFEErrorMessage does a double close.

					if ( WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) )
					{
						SetFrontEndErrorMessage(Localize("UIScene_CreateProfile", "DuplicateLogin_Title", "TPGame"), Localize("UIScene_CreateProfile", "DuplicateLogin_Message", "TPGame"), true);
					}
					else if ( WorldInfo.IsConsoleBuild(CONSOLE_PS3) )
					{
						SetFrontEndErrorMessage(Localize("NetworkMessages", "LostConnectionFromHostTitle", "TPGame"), Localize("NetworkMessages", "DisconnectedString", "TPGame"), true);
					}
					else
					{
						SetFrontEndErrorMessage(Localize("UIScene_CreateProfile", "GameSpyDuplicateLogin_Title", "TPGame"), Localize("UIScene_CreateProfile", "GameSpyDuplicateLogin_Message", "TPGame"), true);
					}

					if (WorldInfo.GRI.bIsArbitrated)
					{
						DestroyOnlineSession();
						ConsoleCommand("Disconnect");
					}
					else
					{
						EndOnlineGame();
						ConsoleCommand("Disconnect");
					}

					break;

				case OSCS_ConnectionDropped:
				case OSCS_NoNetworkConnection:
				case OSCS_ServiceUnavailable:
				case OSCS_UpdateRequired:
				case OSCS_ServersTooBusy:
					
					;

					// Set a front end error message, with ethernet testing
					if ( GameSettings == None )
						SetDisconnectionError(FRONTEND_MENU, true);
					else
						SetDisconnectionError(FRONTEND_INGAME, true);

					if (WorldInfo.GRI.bIsArbitrated)
					{
						DestroyOnlineSession();
						ConsoleCommand("Disconnect");
					}
					else
					{
						EndOnlineGame();
						ConsoleCommand("Disconnect");
					}

					break;
			}
		}
	}
}

function OnDisconnectOnline(int PlayerIndex, bool bReturnValue)
{
	EndOnlineGame();
	;
	ConsoleCommand("Disconnect");
}

function OnLinkStatusChange(bool bIsConnected)
{
	local GameUISceneClient		SceneClient;
	local UIScene_BaseFrontEnd	topScene;
	local UIScene_BaseFrontEnd	prevScene;
	local UIScene				curScene;

	;

	topScene = UIScene_BaseFrontEnd( GetUIController().SceneClient.GetActiveScene() );

	// Do not handle link disconnect if we're not in an online menu.
	if ( topScene == none || ( topScene != none && !topScene.bOnlineMenu ) )
	{
		;
		curScene = GetUIController().SceneClient.GetActiveScene();

		if ( UIScene_Confirmation( curScene ) != None )
		{
			prevScene = UIScene_BaseFrontEnd( curScene.GetPreviousScene(false) );

			if ( prevScene == none || ( prevScene != none && !prevScene.bOnlineMenu ) )
				return;

		}
		else
			return;
	}
		

	SceneClient = class'UIRoot'.static.GetSceneClient();

	if ( SceneClient != None )
	{
		SceneClient.NotifyLinkStatusChanged(bIsConnected);
	}


	if (!bIsConnected)
	{
		// Check for host tampering and deny them the win
		if (WorldInfo.NetMode != NM_Client)
		{
			// Mark the server as having a problem
			WorldInfo.Game.bHasNetworkError = true;
		}
		// Ignore this change if standalone
		if (WorldInfo.NetMode != NM_Standalone)
		{
			;

			SetDisconnectionError(FRONTEND_INGAME, true);

			if (WorldInfo.GRI.bIsArbitrated)
			{
				DestroyOnlineSession();
				ConsoleCommand("Disconnect");
			}
			else
			{
				EndOnlineGame();
				ConsoleCommand("Disconnect");
			}
		}
		else
		{
			ActivateRemoteEvent('ReopenRoot');
		}
	}
}

/** Override to display a message to the user */
function NotifyInviteFailed(optional string errorBoxMessage, optional string errorBoxTitle)
{
	bInvitedToGame = false;

	if ( errorBoxMessage == "" )
	{
		errorBoxMessage = Localize("NetworkMessages", "FailedInviteMessage", "TPGame");
		errorBoxTitle	= Localize("NetworkMessages", "FailedInviteTitle", "TPGame");
	}

	SetFrontEndErrorMessage(errorBoxTitle, errorBoxMessage, true);

	if (WorldInfo.NetMode != NM_Standalone)
	{
		EndOnlineGame();
		ConsoleCommand("Disconnect");
	}
	else
	{
		ActivateRemoteEvent('ReopenRoot');
	}

	//`Log("Invite handling failed");
	// DisplayMessageBox( errorBoxMessage, errorBoxTitle, true);
	ClearInviteDelegates();
}

/**
 * Validates that each local player can play online
 *
 * @return true if there is sufficient space, false if not
 */
function bool CanAllPlayersPlayOnline()
{
	local int i;
	local bool bCanPlayOnline;

	bCanPlayOnline = false;

	for (i = 0; i < 4; i++)
	{
		// Check their login status and permissions
		if (OnlineSub.PlayerInterface.GetLoginStatus(i) != LS_NotLoggedIn && OnlineSub.PlayerInterface.CanPlayOnline(i) == FPL_Disabled)
			return false;
		
		else if (OnlineSub.PlayerInterface.GetLoginStatus(i) == LS_LoggedIn)
		{
			bCanPlayOnline = true;
		}
	}
	return bCanPlayOnline;
}

/** Override to display a message to the user */
function NotifyNotAllPlayersCanJoinInvite()
{
//	`Log("Not all local players have permission to join the game invite");
	DisplayMessageBox(Localize("NetworkMessages", "FailedInviteMessage", "TPGame"), Localize("NetworkMessages", "FailedInviteTitle", "TPGame"), true);
}

/** Override to display a message to the user */
function NotifyNotEnoughSpaceInInvite()
{
//	`Log("Not enough space for all local players in the game invite");
	DisplayMessageBox(Localize("GameMessage", "MaxedOutMessage", "Engine"), Localize("NetworkMessages", "FailedInviteTitle", "TPGame"), true);
}

function ClearLoginDelegates()
{
	local	int		currID;

	for ( currID = 0; currID < 4; currID++ )
	{
		if ( LocalPlayer(Player).ControllerId == currID )
			OnlineSub.PlayerInterface.ClearLoginChangeDelegate(LoginChanged,currID);
		else
			OnlineSub.PlayerInterface.ClearLoginChangeDelegate(InactiveLoginChanged,currID);
	}
}

function AssignLoginDelegates()
{
	local	int		currID;

	for ( currID = 0; currID < 4; currID++ )
	{
		if ( LocalPlayer(Player).ControllerId == currID )
			OnlineSub.PlayerInterface.AddLoginChangeDelegate(LoginChanged,currID);
		else
			OnlineSub.PlayerInterface.AddLoginChangeDelegate(InactiveLoginChanged,currID);
	}
}

/** Sets the delegates for notifications */
exec function InitCallbacks()
{
	if (OnlineSub != None)
	{
		if (OnlineSub.PlayerInterface != None)
		{
			AssignLoginDelegates();

			OnlineSub.SystemInterface.AddStorageDeviceChangeDelegate(OnDeviceChanged);

			OnlineSub.PlayerInterface.AddMutingChangeDelegate(MutingChanged);
			OnlineSub.PlayerInterface.AddFriendsChangeDelegate(LocalPlayer(Player).ControllerId, FriendsChanged);
			OnlineSub.PlayerInterface.AddReadFriendsCompleteDelegate(LocalPlayer(Player).ControllerId,ReadFriendsListDone);
			OnlineSub.PlayerInterface.AddReadProfileSettingsCompleteDelegate(LocalPlayer(Player).ControllerId, OnReadProfileSettingsComplete);
		}
		if (OnlineSub.ContentInterface != None)
		{
			OnlineSub.ContentInterface.AddQueryAvailableDownloadsComplete(LocalPlayer(Player).ControllerId,DownloadableContentQueryDone);
		}

		// Online game related notifications
		if (OnlineSub.GameInterface != None)
		{
			//OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(GameCreateDone);
			//OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(GameDestroyDone);
			//OnlineSub.GameInterface.AddFindOnlineGamesCompleteDelegate(GameSearchDone);
			//OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(GameJoinDone);
			OnlineSub.GameInterface.AddStartOnlineGameCompleteDelegate(GameStartDone);
			//OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(GameEndDone);
		}
		if (OnlineSub.SystemInterface != None)
		{
			// Set the system wide connection changed callback
			//OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
			//OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChange);
		}
	}
}

/** Sets the delegates for notifications */
exec function DeInitCallbacks()
{
	if (OnlineSub != None)
	{
		if (OnlineSub.PlayerInterface != None)
		{
			OnlineSub.PlayerInterface.ClearLoginChangeDelegate(LoginChanged);
			OnlineSub.SystemInterface.ClearStorageDeviceChangeDelegate(OnDeviceChanged);
			OnlineSub.PlayerInterface.ClearMutingChangeDelegate(MutingChanged);
			OnlineSub.PlayerInterface.ClearFriendsChangeDelegate(LocalPlayer(Player).ControllerId, FriendsChanged);
			OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(LocalPlayer(Player).ControllerId,ReadFriendsListDone);
			OnlineSub.PlayerInterface.ClearReadProfileSettingsCompleteDelegate(LocalPlayer(Player).ControllerId, OnReadProfileSettingsComplete);
			;
		}
		if (OnlineSub.ContentInterface != None)
		{
			OnlineSub.ContentInterface.ClearQueryAvailableDownloadsComplete(LocalPlayer(Player).ControllerId,DownloadableContentQueryDone);
			;
		}

		// Online game related notifications
		if (OnlineSub.GameInterface != None)
		{
			//OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(GameCreateDone);
			//OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(GameDestroyDone);
			//OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate(GameSearchDone);
			//OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(GameJoinDone);
			OnlineSub.GameInterface.ClearStartOnlineGameCompleteDelegate(GameStartDone);
			//OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(GameEndDone);
			;
		}
		if (OnlineSub.SystemInterface != None)
		{
			// Set the system wide connection changed callback
			//OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
			//OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChange);
			//`log("Cleared SystemInterface");
		}
	}
}

/** Callback for when the profile finishes reading for this PC. */
function OnReadProfileSettingsComplete(bool bWasSuccessful)
{
	UpdateLocalCacheOfProfileSettings();
}


/** Registers the talker delegate so I can log who is talking */
exec function RegisterTalkerDelegate()
{
	if (OnlineSub != None && OnlineSub.VoiceInterface != None)
	{
		OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);
	}
}

function OnPlayerTalking(UniqueNetId TalkingPlayer)
{
	;
}

/** Tests the keyboard functionality */
exec function ShowXBoxKeyboard(optional string TitleText = "TempTitle", optional string DescriptionText = "Please enter description", optional string DefaultText = "DefaultText")
{
	//SPARK CODEDROP - removed this as it doesn't compile anymore..
	/*
	if (OnlineSub != None)
	{
		//OnlineSub.PlayerInterface.SetKeyboardInputDoneDelegate(OnKeyboardEntryDone);
		if (OnlineSub.PlayerInterface.ShowKeyboardUI(0,TitleText,
			DescriptionText,true,DefaultText))
		{
			`log("Failed to show the virtual keyboard");
		}
	}
	*/
}

client reliable function ClientOpenCharacterSelectScreen(bool bTeamGame)
{
	local UIScene OpenedScene;

	if (MPCharacterScene == none)
		MPCharacterScene = WorldInfo.MPCharacterScene;

	OpenedScene = GetUIController().FindSceneByTag('CharacterSelectUI'/*'SelectCharacter'*/);
	;
	if (OpenedScene != none)
	{
		GetUIController().SceneClient.CloseScene(OpenedScene);
		OpenedScene = none;
	}
	
	if (bTeamGame)
	{
		GetUIController().SceneClient.OpenScene(MPCharacterScene,LocalPlayer(Player),OpenedScene);
		;
		UIScene_TPCharacterSelect(OpenedScene).bTeamGame = bTeamGame;
	}
	else
	{
		GetUIController().SceneClient.OpenScene(MPCharacterScene,LocalPlayer(Player),OpenedScene);
		;
		UIScene_TPCharacterSelect(OpenedScene).bTeamGame = bTeamGame;
	}
}

client reliable event ClientOpenLobby(bool bTeamGame)
{
	//local UIScene_TeamLobby LobbyScene; //SPARK MAY CODEDROP
	local UIScene OpenedScene;

	if (TeamLobby == None)
		TeamLobby = WorldInfo.TeamLobby;

	if (DMLobby == None)
		DMLobby = WorldInfo.DMLobby;

	
	if (bTeamGame)
	{
		OpenedScene = GetUIController().FindSceneByTag('TeamLobbyUI');
		if (OpenedScene == none)
		{
			GetUIController().OpenScene(TeamLobby,LocalPlayer(Player));
		}
		else
		{
			UIScene_BaseHudScene(OpenedScene).SetVisibility(true);
		}
	}
	else
	{
		OpenedScene = GetUIController().FindSceneByTag('DMLobbyUI');
		if (OpenedScene == none)
		{
			GetUIController().OpenScene(DMLobby,LocalPlayer(Player));
		}
		else
		{
			UIScene_BaseHudScene(OpenedScene).SetVisibility(true);
		}
	}

	//GetUIController().SceneClient.OpenScene(UIScene'UI_TPFrontEnd.TeamLobbyUI',None,LobbyScene); //SPARK MAY CODEDROP
	/*if (bTeamGame)
		GetUIController().SceneClient.OpenScene(TeamLobby,LocalPlayer(Player),OpenedScene);
	else
		GetUIController().SceneClient.OpenScene(DMLobby,LocalPlayer(Player),OpenedScene);*/
}

function LoginUITimer()
{
	local UIScene_TPConnectionType topScene;

	if ( OnlineSub.SystemInterface.HasLinkConnection() )
		OnlineSub.PlayerInterface.ShowLoginUI(true);

	topScene = UIScene_TPConnectionType( GetUIController().SceneClient.GetActiveScene() );

	if ( topScene != None )
		topScene.Restore();

}
function OnLoginChange()
{
		;
		;
		;
}

function OnLoginCancelled()
{
		;
		;
		;
}

function OnLoginFailed(byte LocalUserNum,EOnlineServerConnectionStatus ErrorCode)
{
		;
		;
		;
}

exec function GameSpyLogin()
{
	OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
	OnlineSub.PlayerInterface.AddLoginFailedDelegate(PlayerReplicationInfo.PlayerID,OnLoginFailed);
	OnlineSub.PlayerInterface.AddLoginCancelledDelegate(OnLoginCancelled);

	if ( false == OnlineSub.PlayerInterface.Login(PlayerReplicationInfo.PlayerID, "Spark_Kking", "spark") )
	{
		;
		;
		;
	}
}

exec function CreateOnlineSession(int GameMode, int MapID, optional int PrivateConnections = 8)
{
	local OnlineGameSettings GameSettings;
	local LocalPlayer LocPlayer;

	if (OnlineSub != None)
	{
		GameSettings = new(OnlineSub) class'TPDMOnlineGameSettings';
		GameSettings.NumPublicConnections = 8-PrivateConnections;
		GameSettings.NumPrivateConnections = PrivateConnections;
		GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections;
		GameSettings.NumOpenPrivateConnections = GameSettings.NumPrivateConnections;
		GameSettings.bIsLanMatch = bLanMatch;
		GameSettings.bUsesArbitration = bUsesArbitration;

		TPDMOnlineGameSettings(GameSettings).SetStringSettingValue(GAME_MODE, GameMode, false);
		TPDMOnlineGameSettings(GameSettings).SetStringSettingValue(CONTEXT_MAPNAME, MapID, false);
		//TPDMOnlineGameSettings(GameSettings).SetStringProperty(0x2000000A, string(GameSettings.NumPublicConnections - GameSettings.NumOpenPublicConnections)$" / "$string(GameSettings.NumPublicConnections - PrivateConnections));
		//TPDMOnlineGameSettings(GameSettings).NumPlayersInGame = string(GameSettings.NumPublicConnections - GameSettings.NumOpenPublicConnections)$" / "$string(GameSettings.NumPublicConnections - PrivateConnections);
		
		// Register the settings and create the session
		if (OnlineSub.GameInterface.CreateOnlineGame(LocalPlayer(Player).ControllerId,GameSettings) == false)
		{
			;
			return;
		}
		if (OnlineSub.PlayerInterfaceEx != None)
		{
			//ProfileSettings.SetMPMapPlayed(MapID, GameMode);
			WriteProfile(true);

			LocPlayer = LocalPlayer(Player);
			if (LocPlayer != None)
			{
				UpdateMPRichPresence( MapID, int(GameSettings.bIsLanMatch), TPGameReplicationInfo(WorldInfo.GRI).GameStatus, GameMode );
			}
		}
	}
	else
	{
		;
	}
}

/** Destroys the current Live session */
exec function DestroyOnlineSession()
{
	local int i;

	if (OnlineSub != None)
	{
		//FlushStats();
		// Shutdown the session

		;
		OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(GameDestroyDone);

		if (OnlineSub.GameInterface.DestroyOnlineGame() == false)
		{
			if (bInvitedToGame)
			{
				// Set the delegate for notification of the join completing
				OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
				// We can immediately accept since there is no online game
				for (i = 0; i < 4; i++)
				{
					if (OnlineSub.GameInterface.AcceptGameInvite(i/*LocalPlayer(Player).ControllerId*/) == true)
					{
						SetControllerId(i);
						break;
					}
				}
				return;
			}

			if (WorldInfo.NetMode == NM_Client)
			{
				//EndOnlineGame();
				ConsoleCommand("Disconnect");
			}
			;
		}
	}
}

// Helper function to identify the current active online subsystem
exec function OnlineSubsystem()
{
	LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText("Online Subsystem =" @ OnlineSub);
}

/** Creates a lan session with the base defaults and 2 players */
exec function CreateLanSession(optional int PublicConnections = 8)
{
	local OnlineGameSettings GameSettings;
	local LocalPlayer LocPlayer;
	local array<LocalizedStringSetting> Contexts;
	local array<SettingsProperty> Properties;
	local array<int> LinkIndices;

	;
	if (OnlineSub != None)
	{
		GameSettings = new(OnlineSub) class'TPDMOnlineGameSettings';
		GameSettings.NumPublicConnections = PublicConnections;
		GameSettings.bIsLanMatch = bLanMatch;	// KKing & RBaker - Change this back to true.  This is a temp hack to force test online play.
		GameSettings.bUsesArbitration = bUsesArbitration;

		// Register the settings and create the session
		if (OnlineSub.GameInterface.CreateOnlineGame(LocalPlayer(Player).ControllerId,GameSettings) == false)
		{
			LinkIndices[0] = 3;
			// Tell the UI that the joining is complete
			//GetUIController().SceneClient.GetTopmostScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);
			GetUIController().SceneClient.GetActiveScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);

			;
		}
		if (OnlineSub.PlayerInterfaceEx != None)
		{
			LocPlayer = LocalPlayer(Player);
			if (LocPlayer != None)
			{
				// Force a faster update to the rich presence string
				//***SPCODEDROP JUNEQA_BUILD: MP CHECKME - REPLACED with SetOnlineStatus() ---> OnlineSub.PlayerInterfaceEx.SetRichPresence(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
				OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
			}
		}
	}
	else
	{
		LinkIndices[0] = 3;
		// Tell the UI that the joining is complete
		//GetUIController().SceneClient.GetTopmostScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);
		GetUIController().SceneClient.GetActiveScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,true,LinkIndices);
	}
}

/*
if (GameInterface.GetResolvedConnectString(URL))
<joeGraf> ConsoleCommand("open "$URL)
<joeGraf> That will have you join
<joeGraf> You need to wait until the "join complete" notification is fire
*/

/** Joins the first available online session */
exec function JoinFirstOnlineSession(int GameMode)
{
	local OnlineGameSearch GameSearch;

	if (OnlineSub != None)
	{
		GameSearch = new(OnlineSub) class'TPDMOnlineGameSearch';
		GameSearch.bIsLanQuery = bLanMatch;
		GameSearch.bUsesArbitration = bUsesArbitration;

		TPDMOnlineGameSearch(GameSearch).SetStringSettingValue(GAME_MODE, GameMode, false);

		// Search all sessions
		if (OnlineSub.GameInterface.FindOnlineGames(LocalPlayer(Player).ControllerId,GameSearch) == false)
		{
			;
		}
	}
	else
	{

	}
}

/** Joins the first available LAN session */
exec function JoinFirstLanSession()
{
	local array<int> LinkIndices;
	local OnlineGameSearch GameSearch;

	if (OnlineSub != None)
	{
		GameSearch = new(OnlineSub) class'TPDMOnlineGameSearch';
		GameSearch.bIsLanQuery = true;
		// Search all sessions
		if (OnlineSub.GameInterface.FindOnlineGames(LocalPlayer(Player).ControllerId,GameSearch) == false)
		{
			LinkIndices.Insert(0,1);
			LinkIndices[0] = 3;
			// Tell the UI that the joining is complete
			//GetUIController().SceneClient.GetTopmostScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,,LinkIndices);
			GetUIController().SceneClient.GetActiveScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,,LinkIndices);

			;
		}
	}
	else
	{
		LinkIndices.Insert(0,1);
		LinkIndices[0] = 3;
		// Tell the UI that the joining is complete
		//GetUIController().SceneClient.GetTopmostScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,,LinkIndices);
		GetUIController().SceneClient.GetActiveScene().ActivateEventByClass(LocalPlayer(Player).ControllerId,class'UIEvent_ConnectedToGame',,,LinkIndices);
	}
}

// Stat Interface functions

exec function IncrementKill()
{
	if (StatsWrite == none)
		StatsWrite = new class'TPGameStatsWrite';
	StatsWrite.IncrementKill(1);
}

/** Writes stats to the online subsystem stats cache */
exec function WriteStats()
{
	local UniqueNetId PlayerId;

	if (StatsWrite == none)
		StatsWrite = new class'TPGameStatsWrite';

	if (OnlineSub != None)
	{
		OnlineSub.PlayerInterface.GetUniquePlayerId(LocalPlayer(Player).ControllerId,PlayerId);
		OnlineSub.StatsInterface.WriteOnlineStats(PlayerId,StatsWrite);
	}
}

/** Reads stats from the online persistent storage */
exec function ReadStats()
{
	local UniqueNetId PlayerId;
	local array<UniqueNetId> Players;

	if (StatsRead == none)
		StatsRead = new(Outer) class'TPGameStatsRead';


	if (OnlineSub != None)
	{
		OnlineSub.PlayerInterface.GetUniquePlayerId(LocalPlayer(Player).ControllerId,PlayerId);
		Players[0] = PlayerId;
		OnlineSub.StatsInterface.ReadOnlineStats(Players,StatsRead);
	}
}

/** Reads stats from the online persistent storage */
exec function ReadStatsCentered()
{
	if (StatsRead == none)
		StatsRead = new(Outer) class'TPGameStatsRead';

	if (OnlineSub != None)
	{
		OnlineSub.StatsInterface.ReadOnlineStatsByRankAroundPlayer(LocalPlayer(Player).ControllerId,StatsRead);
	}
}

/** Reads stats from the online persistent storage */
exec function ReadStatsByRank()
{
	if (StatsRead == none)
		StatsRead = new(Outer) class'TPGameStatsRead';

	if (OnlineSub != None)
	{
		OnlineSub.StatsInterface.ReadOnlineStatsByRank(StatsRead,1,10);
	}
}

/** Reads stats from the online persistent storage */
exec function ReadStatsForFriends()
{
	if (StatsRead == none)
		StatsRead = new(Outer) class'TPGameStatsRead';

	if (OnlineSub != None)
	{
		OnlineSub.StatsInterface.ReadOnlineStatsForFriends(LocalPlayer(Player).ControllerId,StatsRead);
	}
}

/** Flushes any cached stats to the permanent storage */
exec function FlushStats()
{
	if (OnlineSub != None)
	{
		OnlineSub.StatsInterface.FlushOnlineStats();
	}
}

delegate OnMessageBoxClose(int PlayerIndex, bool bReturnValue);
// End Stat Interface
function DisplayMessageBox(string Message, optional string Title = "", optional bool bSimpleMode = false, optional delegate<OnMessageBoxClose> OnCloseDelegate)
{
	local UIScene TempScene;
	local UIScene_Confirmation ConScene;

	if ( curDialogScene != none )
	{
		//`log( UILabel( UIScene_Confirmation(curDialogScene).FindChild('MessageText',true) ).GetValue() );

		;
		;
		;
		GetUIController().CloseScene(curDialogScene);	
	}
	else
	{
		;
	}

	if ( GetUIController().OpenScene( class'UIScene_BaseFrontEnd'.default.MessageBoxScene, LocalPlayer(Player), TempScene ) )
	{
		curDialogScene = TempScene;

		//FadeInactive();
		ConScene = UIScene_Confirmation(TempScene);
		if (ConScene != None)
		{
			ConScene.FadeIn(true);
			ConScene.SetVisibility(true);
			ConScene.OnSceneClose=OnCloseDelegate;
			
			if (bSimpleMode)
				ConScene.SimpleMode();
			else
			{
				/*if (!WorldInfo.IsConsoleBuild())
				{
					ConScene.SetButtonLabelDatastoreBinding(class'UIScene_BaseFrontEnd'.default.DialogHelperMarkupPC);
				}
				else if (WorldInfo.IsPS3Build())
				{
					ConScene.SetButtonLabelDatastoreBinding(class'UIScene_BaseFrontEnd'.default.DialogHelperMarkupPS3);
				}*/
				if (!WorldInfo.IsConsoleBuild() && !PlayerInput.bUsingGamepad)
				{
					ConScene.SetButtonLabelDatastoreBinding(class'UIScene_BaseFrontEnd'.default.DialogHelperMarkupPC);
				}
				else if (WorldInfo.IsPS3Build())
				{
					if (!WorldInfo.UseCircleToAccept())
						ConScene.SetButtonLabelDatastoreBinding(class'UIScene_BaseFrontEnd'.default.DialogHelperMarkupPS3);
					else
						ConScene.SetButtonLabelDatastoreBinding(class'UIScene_BaseFrontEnd'.default.DialogHelperMarkupPS3Circle);
				}
			}
			if (Title != "")
				ConScene.SetTitle(Title);

			ConScene.SetMessage(Message);
		}
	}
}

function OnConnectionLostResults(int PlayerIndex, bool bReturnValue)
{
	local UIScene Scene;
	if (WorldInfo.NetMode == NM_Standalone)
	{
		//Scene = GetUIController().SceneClient.GetTopmostScene();
		Scene = GetUIController().SceneClient.GetActiveScene();
		GetUIController().CloseScene( Scene );
		DestroyOnlineSession();
	}
	else
	{
		EndOnlineGame();
		//ConsoleCommand("Disconnect");
	}
}

/** Registers a delegate so we get a callback when the player changes anything related to live. */
function RegisterOnlineDelegates()
{
//	local OnlinePlayerInterface PlayerInterface;
	local OnlinePlayerInterfaceEx PlayerInterfaceEx;
	local LocalPlayer LocPlayer;

	LocPlayer = LocalPlayer(Player);

	// Figure out if we are a local player and have an online subsystem registered
	if (LocPlayer != None && OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
/*		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			// Set the login delegate for the player
			PlayerInterface.SetLoginChangeDelegate(NotifyLoginChange,LocPlayer.ControllerId);
			PlayerInterface.SetLoginChangeDelegate(NotifyGlobalLoginChange);
			PlayerInterface.SetReadProfileSettingsCompleteDelegate(LocPlayer.ControllerId,NotifyProfileReadComplete);
			bLoginChanged = false;
		}*/

		PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;
		if(PlayerInterfaceEx != None)
		{
			PlayerInterfaceEx.AddDeviceSelectionDoneDelegate(LocPlayer.ControllerId,NotifyDeviceSelectComplete); //SPARK MAY CODEDROP
		}

		if (OnlineSub.SystemInterface != None)
		{
			// Set the system wide connection changed callback
			OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
			OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChange);
		}
	}
}

/** Clears the online delegates for this PC. */
function ClearOnlineDelegates()
{
//	local OnlinePlayerInterface PlayerInterface;
	local OnlinePlayerInterfaceEx PlayerInterfaceEx;
	local LocalPlayer LocPlayer;

	LocPlayer = LocalPlayer(Player);

	// Figure out if we are a local player and have an online subsystem registered
	if (LocPlayer != None && OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
/*		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			// Clear our delegate
			PlayerInterface.ClearLoginChangeDelegate(NotifyLoginChange,LocPlayer.ControllerId);
			PlayerInterface.ClearLoginChangeDelegate(NotifyGlobalLoginChange);
			PlayerInterface.ClearReadProfileSettingsCompleteDelegate(LocPlayer.ControllerId,NotifyProfileReadComplete);
			bLoginChanged = false;
		}*/

		PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;
		if(PlayerInterfaceEx != None)
		{
			PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(LocPlayer.ControllerId,NotifyDeviceSelectComplete);
		}

		if (OnlineSub.SystemInterface != None)
		{
			// Set the system wide connection changed callback
			OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
			OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChange);
		}
	}
}


/** Callback for when the player selects a storage device. */
function NotifyDeviceSelectComplete(bool bWasSuccessful)
{
	local int DeviceID;
	local string DeviceName;
	local OnlinePlayerInterfaceEx PlayerInterfaceEx;

	// If they changed their storage device, update the profile with the new device.
	if(bWasSuccessful && ProfileSettings != none)
	{
		if (OnlineSub != None)
		{
			// Grab the player interface to verify the subsystem supports it
			PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;
			if (PlayerInterfaceEx != None)
			{
				DeviceID = PlayerInterfaceEx.GetDeviceSelectionResults(LocalPlayer(Player).ControllerId, DeviceName);
				ProfileSettings.SetCurrentDeviceID(DeviceID);

				;
			}
		}
	}
}


/////////////////////////////////////////////////////////////////////////////////
// End Online Functions for XBOX ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
// Allow native code to do some cleanup
native function CleanupBeforeCheckpointOrTransitionNative();

// Client function to clear the active action info
reliable client function ClientClearHUDActiveActionInfo()
{
//	if ( MyWarHud != None )
//	{
//		MyWarHud.ClearActiveActionInfo();
//	}
}

// Cleanup anything needed before checkpointing or transitioning
reliable client function ClientPlayerCleanupBeforeCheckpointOrTransition()
{
//	ClientStopPostProcessOverride(eWPP_BleedOut);
//	ClientClearHUDActiveActionInfo();
	ClearObjectives();
}

// Code to clean up state of pawns/players, when transitioning or loading a checkpoint;  this function should only be called
// from WarGame.CleanupBeforeCheckpointOrTransition.
function PlayerCleanupBeforeCheckpointOrTransition()
{
	local Vehicle V;
	local PlayerPawn PlayerPawn;
//	local TPPlayerInput TPI;

	// let C++ have a go
	CleanupBeforeCheckpointOrTransitionNative();

	// reset the enemy cache
//	LocalEnemies.length = 0;
//	NextLocalEnemyToCheckLOS = 0;

	V = Vehicle(Pawn);
	if (V != none)
	{
		PlayerPawn = PlayerPawn(V.Driver);
		;
		V.DriverLeave(TRUE);
//		V.Destroy();
	}
	else
		PlayerPawn = PlayerPawn(Pawn);

	if (PlayerPawn != None)
	{
		PlayerPawn.bShellShockKillPlayer = false;
		PlayerPawn.ShellShockFinished();
	}

	ClearPostMaterials();

	StopViewShaking();

	ClientPlayerCleanupBeforeCheckpointOrTransition();
	
	// unclamp player view if clamped
    bClampView = false;
    
    // Set the gamespeed to normal if loading checkpoint during deathcam
    WorldInfo.Game.SetGameSpeed(1.0);

    // Reset playerstate if in bombminigame or has controls disabled
    FinishBombGoBoomGame();
}

/**
 * Additional console commands for killing various players, strictly for
 * testing purposes.
 */
exec function Kill(optional string type)
{
	local Controller chkPlayer;
	local TPPawn deadPawn;
    local PhysicsGrenade PhysGrenade;
    local TPGear Gear;
	local Vehicle V;

	local AIController ai;
	if (type ~= "ai" || type ~= "bots" || type ~= "all")
	{
		foreach DynamicActors(class'AIController',ai)
		{
			V = Vehicle(ai.Pawn);
			if( V != None )
			{
				V.DriverLeave( TRUE );
			}

            if(ai.Pawn != none)
            {
                ;
			    ai.Pawn.Destroy();
			}

            ;
			ai.Destroy();
		}
	}
	else if (type ~= "enemy" || type ~= "enemies" || type ~= "badguys")
	{
		foreach DynamicActors(class'Controller',chkPlayer)
		{
			if (chkPlayer.PlayerReplicationInfo.Team != PlayerReplicationInfo.Team)
			{
				// Just knock the driver off; don't actually destroy the turret.
				V = Vehicle(chkPlayer.Pawn);
				if( V != none )
				{
					V.DriverLeave( true );
					;
					V.Destroy();
				}

                if(chkPlayer.Pawn != none)
                {
                    ;
				    chkPlayer.Pawn.Destroy();
				}

                ;
				chkPlayer.Destroy();
			}
		}
	}
	else if( type ~= "friend" || type ~= "friends" || type ~= "goodguys" || type ~= "friendlies" )
	{
		foreach DynamicActors( class'Controller', chkPlayer )
		{
			if( chkPlayer != self && chkPlayer.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team )
			{
				V = Vehicle(chkPlayer.Pawn);
				if( V != None )
				{
					V.DriverLeave( TRUE );
				}

				deadPawn = TPPawn(chkPlayer.Pawn);
				if( deadPawn != None )
				{
					deadPawn.TakeDamage(deadPawn.Health+1, None, deadPawn.Location, vect(0,0,0), class'TPDamageTypeImpactMP50');
				}
			}
		}
	}
	else if (type ~= "grenade")
	{
		ForEach DynamicActors(class'PhysicsGrenade', PhysGrenade)
		{
			PhysGrenade.Destroy();
		}
	}
	else if (type ~= "gear")
	{
		ForEach DynamicActors(class'TPGear', Gear)
		{
			Gear.Destroy();
		}
	}
	else
	{
		foreach DynamicActors( class'Controller', chkPlayer )
		{
			if( chkPlayer != self &&
				(String(chkPlayer.Name) ~= type ||
				(chkPlayer.Pawn != None && String(chkPlayer.Pawn.Name) ~= type)) )
			{
				chkPlayer.Destroy();
			}
		}
	}
}



// notification from the client to the server that it has loaded the checkpoint locally
event ServerNotifyClientLoadedCheckpoint()
{
	local Actor A;

	if (LocalPlayer(Player) == None)
	{
		// force update all infrequently updated relevant actors
		foreach AllActors(class'Actor', A)
		{
			if (A.RemoteRole != ROLE_None && A.NetUpdateFrequency < 1.0)
			{
				//SPARK OCT CODEDROP
				//A.NetUpdateTime = WorldInfo.TimeSeconds - 1.0;
			}
		}
	}
}

function ClientPlayLoadCheckpointSceneSound()
{
	local AudioComponent AC;

	AC = CreateAudioComponent(LoadCheckpointCue, false, true);
	AC.bUseOwnerLocation = TRUE;
	AC.bAutoDestroy = TRUE;
	AC.bSuppressSubtitles = TRUE;
	AC.Play();
}


/**
* Action to load the latest checkpoint.
*/
function OnLoadLastCheckpoint(UIAction_LoadLastCheckpoint Action)
{
	local TPPlayerController PC;

	// we do this here so that it's stopped before it gets unpaused (since the timer will allow the vibe to start up again)
	foreach WorldInfo.AllControllers( class'TPPlayerController', PC )
	{
		PC.ClientStopForceFeedbackWaveform();
//		PC.bSPMapNameDirty = true;
	}

	// play the load checkpoint sound
	foreach WorldInfo.AllControllers( class'TPPlayerController', PC )
	{
		PC.ClientPlayLoadCheckpointSceneSound();
	}

	// Can't really do much with checkpoints while playing in the editor, so just give up
	if (IsEditorActive())
	{
		ConsoleCommand("Quit");
	}
	else if (CheckPointExists())
	{
		RealLoadLastCheckpoint();
	}
	// We really should always have an active checkpoint (even when just starting a level),
	// but reload the map if we don't
	else
	{
		ClientTravel("?Restart", TRAVEL_Relative);
	}
}

function RealLoadLastCheckpoint()
{
	local TPPlayerController PC;

	;

	ClientLoadingScreen(true);

	TpHUD(myHUD).bPickup				= false;

	ResetFOV();
	FOV(DesiredFOV);

	GetUIController().CloseScene(TutorialScene);
	// pause so stuff can't go re-setting cinematic mode, etc

	// make sure the tutorial is turned off
//	KillTutorialMode( false );
	// reset the HUD
//	WarHUD(myHUD).Reset();

	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.SetCinematicMode(FALSE, FALSE, TRUE, TRUE, TRUE, TRUE);
        TPPlayerCamera(PC.PlayerCamera).bUseFallDeathCam = false;
	}

    PlayerCamera.SetFOV(default.DefaultFOV);

	// this will clean up the state of all player controllers and pawns - destroy the ones we don't need, respawn the pawns
	// that will be used by players after loading the checkpoint or completing the transition, killing all enemies, etc.
	TPGameInfo(WorldInfo.Game).CleanupBeforeCheckpointTransition();

//	CleanupUIScenes();

	// clear the countdown
//	WarGRI(WorldInfo.GRI).StopDeathCountdown(true);

	if (Pawn == None)
		AskForPawn();

	TPCM.DelayedLoadCheckpoint( self );
}


event PostLoadCheckpoint()
{
	local Actor A;
	local TPPlayerController PC;

	// reset state of actors that are in the P level
	foreach DynamicActors(class'Actor', A)
	{
		if (A.IsA('DroppedPickup') || A.IsA('PickupFactory') || A.IsA('BloodPool'))
		{
			A.Reset();
		}
	}

	// really make sure cinematic mode is off, since checkpoint load is tick delayed
	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.SetCinematicMode(FALSE, FALSE, TRUE, TRUE, TRUE, TRUE);
		PC.bSPMapNameDirty = true;
	}

	WorldInfo.ForceGarbageCollection();

	//ClientLoadingScreen(false);
}

//	Unlocks a chapter and saves the profile settings
function UnlockChapter(int UnlockedChapter)
{
	// Save the profile, but only if we've actually changed anything.
	if (ProfileSettings.UnlockChapter(UnlockedChapter))
		WriteProfile(true);
}

reliable client function ClientIncrementGamesWon(bool bTeamGame)
{
	local int ReturnVal;
	ReturnVal = ProfileSettings.IncrementRankedGamesWon(bTeamGame);

	//`log(GetFuncName()$": RankedGamesWon = "$ReturnVal$", TeamGame? "$bTeamGame);
	if (ReturnVal >= 20 && bTeamGame)
		ClientUnlockAchievement(TA_TEAMPLAYER);
	else if (!bTeamGame && ReturnVal >= 5)
		ClientUnlockAchievement(TA_PH34RM3H);
	WriteProfile(true);
}

/** Will lock all chapters **/
exec function LockAllChapters()
{
	ProfileSettings.SetProfileSettingValueInt( class'TPProfileSettings'.const.ChapterUnlocked, 0); // keep first level unlocked
	WriteProfile(true);
}

/** Will un lock all chapters **/
exec function UnlockAllChapters()
{
	if (ProfileSettings.UnlockChapter(999)) // change to the actual last chapter number whenever we get one...
		WriteProfile(true);
}

exec function SetMaxChapter(int ChapterNum)
{
	ProfileSettings.SetMaxChapter(ChapterNum);
	WriteProfile(true);
}

// Game Over Code
/** handles bringing up the game over screen for all players */
final function ProcessGameOver()
{
	ClientOpenGameoverSceneFromDelay();
}

function ClientOpenGameoverSceneFromDelay()
{
	local UIInteraction UIController;
	local UIScene OpenedScene;
	local UIScene SceneRef;

	UIController = GetUIController();
	if ( UIController != None )
	{
		SceneRef = GameoverScene;
		UIController.OpenScene( SceneRef, LocalPlayer(Player), OpenedScene );

		if ( OpenedScene != None )
		{
			// play the music for the scene
			//GameoverLoop.Play();
			//GameoverLoop.bNonRealtime = true;
			OpenedUISceneGameover = OpenedScene;
			OpenedUISceneGameover.OnSceneDeactivated = OnGameoverDeactivate;

			// hide the hud
			//HideHUDCleanup();

			// turn subtitles off
			//SetShowSubtitles( false );
		}
	}
}

/**
* Called by the UI system when the gameover screen is closed.
*/
simulated function OnGameoverDeactivate( UIScene DeactivatedScene )
{
/*	local TPPlayerController PC;
	local PlayerController APlayer;
	local int LCCount;
	// tell all non-localplayer clients to close their gameover scenes
	if ( WorldInfo.NetMode < NM_Client )
	{
		// have other local players turn their post process off
		ForEach LocalPlayerControllers( APlayer )
		{
			PC = TPPlayerController(APlayer);
			if ( PC != None )
			{
				if ( LCCount > 0 )
				{
					PC.ClientStopPostProcessOverride( eWPP_Gameover );
				}
				LCCount++;
			}
		}

		// tell non local player controllers to close their gameover screen.
		foreach WorldInfo.AllControllers( class'TPPlayerController', PC )
		{
			if( (PC != none) && (LocalPlayer(PC.Player) == None) )
			{
				PC.ClientCloseOpenedGameoverScene();
			}
		}
	}*/

	ClientCloseOpenedGameOverScene();

	//StopPostProcessOverride( eWPP_Gameover );

	// play the music for the scene
	if (GameoverLoop != None)
		GameoverLoop.Stop();

	// unhide the hud
//	UnHideHUDCleanup();

	// reset subtitles
//	SetShowSubtitles( ProfileSettings.GetSubtitleConfigOption() );

	OpenedUISceneGameover = None;
}

/**
 * Closes the gameover scene if it's still open
 */
function ClientCloseOpenedGameoverScene()
{
	if( OpenedUISceneGameover != None )
	{
		CloseScene( OpenedUISceneGameover );
	}
}

simulated function CloseGameoverScene()
{
	CloseScene( OpenedUISceneGameover );
}

// Look at this function later - RBaker
client reliable event CloseScene( UIScene Scene, optional bool bFadeScreen )
{
	local UIInteraction UIController;

	UIController = GetUIController();

	if ( (UIController != None) && (Scene != None) )
	{
/*		if ( bFadeScreen )
		{
			// incase we're closing a scene already, just finish it off
			if ( CurrFadeOutScene != None )
			{
				CloseScene( CurrFadeOutScene );
			}
			CurrFadeOutScene = UIController.FindSceneByTag( Scene.SceneTag );
			SceneStartFadeOutTime = WorldInfo.TimeSeconds;
		}
		else
		{*/
			UIController.CloseScene( Scene );
//		}
	}
}

// Quit Game Stuff
// Action to quit to the main menu from the game.
event OnQuitToMainMenu(UIAction_QuitToMainMenu Action)
{
//	local array<LocalizedStringSetting> Contexts;
//	local array<SettingsProperty> Properties;
//	local LocalPlayer LocPlayer;
	local bool bInMainMenu;

	;

	PlayerCleanupBeforeCheckpointOrTransition();

	bInMainMenu = (GetURLMap() ~= "entry_master");

//	bWasFromMenu = Action != None;

	// The standby cheat dialog is up, close it
//	HandleStandbyCheat(false);
	// Disable standby cheat detection
//	WorldInfo.SetStandbyCheatDetection(false);

	// Shutting down Live will trigger the connection lost message
//	bIgnoreCloseNotify = true;

//	if (OnlineSub.PlayerInterfaceEx != None)
//	{
//		LocPlayer = LocalPlayer(Player);
//		if (LocPlayer != None)
//		{
//			// Force a faster update to the rich presence string
//			OnlineSub.PlayerInterfaceEx.SetRichPresence(LocPlayer.ControllerId,WRPS_Menus,Contexts,Properties);
//		}
//	}

	// If we aren't in the main menu, show the loading movie since we will travel to warstart.
//	if (bInMainMenu==false)
//	{
//		ShowLoadingMovie(true);
//	}

	// Clean up an Live state on quit. If there is an async task in flight,
	// then skip the clean up until that task is done
//	if (!CleanupLiveOnQuit())
//	{
		// If we are in the menus, do the ungraceful clean up
		if (bInMainMenu)
		{
			CleanupUngracefulReturnToMenu();
		}
		else
		{
			FinishOnQuitToMainMenu(Action);
		}
//	}
}

// Performs our finalization of quiting to the menu. This will be called
// immediately if no Live session is in progress. If there is a Live
// session in progress, this function is called once the clean up has
// finished. Live clean up is async so don't call this if one is pending
// or there can be crashes/asserts
function FinishOnQuitToMainMenu(optional UIAction_QuitToMainMenu Action = None)
{
	local TPPlayerController PC;

	// Don't execute this code in the menu
	if (GetURLMap() != "entry_master")
	{
		if (ROLE == ROLE_Authority && WorldInfo.NetMode != NM_Standalone)
		{
			foreach WorldInfo.AllControllers(class'TPPlayerController',PC)
			{
				if ( LocalPlayer(PC.Player) == None )
				{
					if ( PC != self )
					{
						if (PC.Pawn != None)
						{
							PC.Pawn.Destroy();
						}
						PC.Destroy();
					}
				}
			}
		}

		if (IsEditorActive())
			ConsoleCommand("Quit");
		else
			ConsoleCommand("Disconnect");

		// make sure the tutorial is turned off
//		KillTutorialMode( false );
		// reset the HUD
		myHUD.Reset();

//		CleanupUIScenes();
	}
//	else
//	{
//		bIgnoreCloseNotify = false;
//	}

	WorldInfo.ForceGarbageCollection();

	;
}

// Cleans up any Live related code that wasn't gracefully cleaned up in the
// previous match. This is a catch all for cleaning up once you've arrived
// back in the menus. This code should be unnecessary, but it's better to
// be safe than sorry.
function CleanupUngracefulReturnToMenu()
{
	// Check for being in the menus
	if (GetURLMap() ~= "entry_master" || GetURLMap() == "")
	{
		// Now see if there is a left over game session going
		if (OnlineSub != None &&
			OnlineSub.GameInterface != None &&
			OnlineSub.GameInterface.GetGameSettings() != None)
		{
			;
			// Set the end delegate so we can know when that is complete and call destroy
			OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndDuringCleanupComplete);
			// We have a left over game, so clean up
			OnlineSub.GameInterface.EndOnlineGame();
		}
	}
}

// Called when the end online game has completed
function OnEndDuringCleanupComplete(bool bWasSuccessful)
{
	OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndDuringCleanupComplete);
	// Set the destroy delegate so we can know when that is complete
	OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyDuringCleanupComplete);
	// Now we can destroy the game
	OnlineSub.GameInterface.DestroyOnlineGame();
}

// Called when the destroy online game has completed. At this point it is safe
// to travel back to the menus
function OnDestroyDuringCleanupComplete(bool bWasSuccessful)
{
	OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyDuringCleanupComplete);
	FinishOnQuitToMainMenu();
}

event OnSetSkeletalMesh(SeqAct_SetSkeletalMesh Action)
{
	if (Action.NewSkeletalMesh != None && Action.NewSkeletalMesh != Pawn.Mesh.SkeletalMesh)
	{
		Pawn.Mesh.SetSkeletalMesh(Action.NewSkeletalMesh);
		//ReplicatedMesh = Action.NewSkeletalMesh;
	}
}

event int GetBonusUserID()
{
	return bonusInfo.GetUserID();
}

event int ProcessBonusCode( string bonusCode )
{
	local	int		bonusUnlocked;

	bonusUnlocked = bonusInfo.ProcessBonus( bonusCode );

	if ( bonusUnlocked >= BONUS_NUM )
		return ( -1 );

	if ( bonusUnlocked != -1 )
		UnlockBonus( bonusUnlocked );

	return ( bonusUnlocked );
}

event UnlockBonus( int zeroBasedBonus, optional bool bUnlockAllBonuses)
{
	if( bUnlockAllBonuses )
		ProfileSettings.UnlockAllBonuses( );
	else
		ProfileSettings.UnlockBonus( zeroBasedBonus );
	WriteProfile(true);
}

event bool IsBonusUnlocked( int zeroBasedBonus )
{
	if ( ProfileSettings != None )
		return ProfileSettings.IsBonusUnlocked( zeroBasedBonus );

	return false;
}

event SetBonusActive( int zeroBasedBonus, int Value )
{
	if (IsBonusUnlocked(zeroBasedBonus))
		TPGameViewportClient(LocalPlayer(Player).ViewportClient).BonusActiveArray[zeroBasedBonus] = Value;
}

event bool IsBonusActive( int zeroBasedBonus )
{
	return (IsBonusUnlocked(zeroBasedBonus) && (TPGameViewportClient(LocalPlayer(Player).ViewportClient).BonusActiveArray[zeroBasedBonus] == 1));
}

event Name GetBonusName( int zeroBasedBonus )
{
	return ProfileSettings.GetBonusName( zeroBasedBonus );
}

/** Not really restricted to blood effects, but hey... */
simulated function SpawnCameraEffect(class<Emit_CameraEffect> CamEffectEmitterClass)
{
	local vector CamLoc;
	local rotator CamRot;

	local TPPlayerCamera Cam;
	Cam = TPPlayerCamera(PlayerCamera);

	if ( (Cam != None) && (CamEffectEmitterClass != None) && (Cam.CameraEffectEmitter == None) )
	{
		Cam.CameraEffectEmitter = Spawn(CamEffectEmitterClass, self);
		if (Cam.CameraEffectEmitter != None)
		{
			GetPlayerViewPoint(CamLoc, CamRot);
			Cam.CameraEffectEmitter.UpdateLocation(CamLoc, CamRot, 80.f);
			Cam.CameraEffectEmitter.RegisterCamera(Cam);
		}
	}
}

simulated exec function TestCameraEffect()
{
	SpawnCameraEffect(class'Emit_CameraSplash');
}

//Used for debugging the local profile cache

//`define LogProfile(c,t)

simulated function ToggleMusic(bool musicOn)
{
	if ( musicOn )
	{
		SetGroupVolume('MASTER_Music', 1.0 );

		if ( WorldInfo.IsConsoleBuild(CONSOLE_PS3) )
			SetGroupVolume('Music', 2.0 );	// Music booster for PS3
		else
			SetGroupVolume('Music', 1.0 );
	}
	else
	{
		SetGroupVolume('MASTER_Music', 0.0 );
	}

}
/**
 * Copies profile settings from the datastore and stores them in local variables.
 */
exec function UpdateLocalCacheOfProfileSettings()
{



	local int Value;
	




	if (ProfileSettings != None && ProfileSettings.GetVideoGamma() != 0.0f)
	{
		;
		;
		bLocalCacheOfProfileUpdated = true;

		PlayerInput.bInvertMouse = ProfileSettings.GetInvertMouseOption();
		;

		//Commenting this out until we have a frontend option for Auto Aim
		TPPlayerInput(PlayerInput).bSuperAdhesionEnabled = ProfileSettings.GetAutoAimOption();
		TPPlayerInput(PlayerInput).bTargetAdhesionEnabled = ProfileSettings.GetAutoAimOption();
		;
		

		PlayerReplicationInfo.bControllerVibrationAllowed	= ProfileSettings.GetControllerVibrationOption();
		;

		SetDisplayGamma(ProfileSettings.GetVideoGamma());
		;

		SetMidTonesMultiplier(ProfileSettings.GetMidTones());
		;

		SetHighlightsMultiplier(ProfileSettings.GetHighlights());
		;

		if (ProfileSettings.GetSouthpawForced())
		{
			;
			ProfileSettings.SetProfileSettingValueId(class'TPProfileSettings'.const.ControllerConfigType, TPCO_DefaultSouthPaw);
			ProfileSettings.SetProfileSettingValueId(PSI_MovementControl, PMCO_L_Thumbstick);
		}

		UpdateControllerConfig();

		;
		SetMasterVolume( ProfileSettings.GetMasterVol() );

		;

		ToggleMusic(ProfileSettings.IsMusicEnabled());

		;
		SetShowSubtitles(ProfileSettings.GetSubtitlesOption());

		;
		ShowHUDElements(true); // This will do the checking of the profile settings for us

		;
		ShowCrosshair(ProfileSettings.GetCrosshairOption());

		if (WorldInfo.NetMode == NM_Standalone)
		{
			ProfileSettings.GetProfileSettingValueId(PSI_GameDifficulty, Value);
			;
			TPGameInfo(WorldInfo.Game).SetDifficultyLevel(Value);
			
			if (Pawn != None)
			{
				PlayerPawn(Pawn).MaxPlayerHealth = class'PlayerPawn'.default.MaxPlayerHealth * TPGameInfo(WorldInfo.Game).CurrPlayerHealthMultiplier;
				;
			}
		}

		// Specific stuff for PC
		if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) ) // KMSK
		{
			// Check to see if this is the first time running the game with this profile
			//if (ProfileSettings.GetVideoResolution() == -1)
			//{
			//	`log("KMSK - Resolution set.");
			//	SetFirstTimeResolutionForProfileOnPC();
			//}
			//`LogProfile("FULLSCREEN set to"@ProfileSettings.IsFullscreenEnabled());
			
			//SelectScreenRes(ProfileSettings.GetVideoResolution(), ProfileSettings.IsFullscreenEnabled());

			;
			SetPerformanceSettings(ProfileSettings.GetVideoPerformance());

			// Set the Alias on the Server
			// Commented out, this is now in TPPlayerReplicationInfo::IsInvalidName()
			/*if (OnlineSub.GameInterface.GetGameSettings().bIsLanMatch)
				SetName(ProfileSettings.GetLocalAccountName());*/
		}

		;
	}
}
exec function SetName(coerce string S)
{
	local string NewName;
	local LocalPlayer LocPlayer;
	local OnlineGameSettings GameSettings;

	if (S != "")
	{
		LocPlayer = LocalPlayer(Player);
		if (LocPlayer != None &&
			OnlineSub.GameInterface != None &&
			OnlineSub.PlayerInterface != None)
		{
			// Check to see if they are logged in locally or not
			if (OnlineSub.PlayerInterface.GetLoginStatus(LocPlayer.ControllerId) == LS_LoggedIn &&
				OnlineSub.GameInterface.GetGameSettings() != None)
			{
				GameSettings = OnlineSub.GameInterface.GetGameSettings();

				if (!GameSettings.bIsLanMatch || WorldInfo.IsConsoleBuild(CONSOLE_Xbox360))
					// Ignore what ever was specified and use the profile's nick
					S = OnlineSub.PlayerInterface.GetPlayerNickname(LocPlayer.ControllerId);
			}
		}

		NewName = S;

		ServerChangeName(NewName);
		UpdateURL("Name", NewName, true);
		SaveConfig();
	}
}

//function SetFirstTimeResolutionForProfileOnPC()
//{
//	local array<string> VideoResolutions;
//	local int i;
//
//	GetResolutionStrings(VideoResolutions);
//
//	for (i = 0; i < VideoResolutions.Length; i++)
//	{
//		if (VideoResolutions[i] == "800 x 600")
//		{
//			ProfileSettings.SetProfileSettingValueInt( class'TPProfileSettings'.const.VideoResolution, i); 
//			`LogProfile("FULLSCREEN set to"@ProfileSettings.GetVideoResolution());
//			break;
//		}
//	}
//
//}

// 0 - Low, 1 - Medium, 2 - High
native function SetPerformanceSettings(int PerformanceMode);

native exec function SetDisplayGamma(float DisplayGamma);

native exec function SetMidTonesMultiplier(float MidTones);

native exec function SetHighlightsMultiplier(float Highlights);

/**
 * This will set the bindings array with the updated key/value pair for the various controllers configs
 * we support.
 **/
function UpdateControllerConfig()
{
	local int CurrSensitivity;
	local int CurrConfig;
	local TPPlayerInput TPPInput;
	
	TPPInput = TPPlayerInput(PlayerInput);

	ProfileSettings.GetProfileSettingValueId(PSI_ControllerSensitivity, CurrSensitivity);
	ProfileSettings.GetProfileSettingValueId(class'TPProfileSettings'.const.ControllerConfigType, CurrConfig);

	// First do the joysticks and triggers
	if (CurrConfig == TPCO_Default || CurrConfig == TPCO_Alternate)
	{
		switch (CurrSensitivity)
		{
			case PCSO_Medium:
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', TPPInput.MedLookSensitivity_LeftX );
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', TPPInput.MedLookSensitivity_LeftY );
				UpdateControllerSettings_Worker( 'XboxTypeS_RightX', TPPInput.MedLookSensitivity_RightX );
				UpdateControllerSettings_Worker( 'XboxTypeS_RightY', TPPInput.MedLookSensitivity_RightY );
				break;
			case PCSO_Low:
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', TPPInput.LowLookSensitivity_LeftX );
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', TPPInput.LowLookSensitivity_LeftY );
				UpdateControllerSettings_Worker( 'XboxTypeS_RightX', TPPInput.LowLookSensitivity_RightX );
				UpdateControllerSettings_Worker( 'XboxTypeS_RightY', TPPInput.LowLookSensitivity_RightY );                
				break;
			case PCSO_High:
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', TPPInput.HighLookSensitivity_LeftX );
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', TPPInput.HighLookSensitivity_LeftY );
				UpdateControllerSettings_Worker( 'XboxTypeS_RightX', TPPInput.HighLookSensitivity_RightX );
				UpdateControllerSettings_Worker( 'XboxTypeS_RightY', TPPInput.HighLookSensitivity_RightY );                
				break;
		}

		UpdateControllerSettings_Worker( 'XboxTypeS_RightTrigger', "Fire" );
		UpdateControllerSettings_Worker( 'XboxTypeS_RightShoulder', "EquipGrenade | OnRelease FastThrowGrenade" );
		UpdateControllerSettings_Worker( 'XboxTypeS_RightThumbstick', "TurnOn" );

		UpdateControllerSettings_Worker( 'XboxTypeS_LeftTrigger', "EnableAimDownSight | OnRelease DisableAimDownSight" );
		UpdateControllerSettings_Worker( 'XboxTypeS_LeftShoulder', "DoSprint" );
	}
	else // Southpaw style
	{
		switch (CurrSensitivity)
		{
			case PCSO_Medium:
				UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "Axis aStrafe Speed=1.0 DeadZone=0.3" );
				UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "Axis aBaseY Speed=-1.0 DeadZone=0.3" );
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "Axis aTurn Speed=1.0 DeadZone=0.2" );
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "Axis aLookup Speed=-1.0 DeadZone=0.2" );
				break;
			case PCSO_Low:
				UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "Axis aStrafe Speed=1.0 DeadZone=0.3" );
				UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "Axis aBaseY Speed=-1.0 DeadZone=0.3" );
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "Axis aTurn Speed=0.8 DeadZone=0.2" );
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "Axis aLookup Speed=-0.8 DeadZone=0.2" );
				break;
			case PCSO_High:
				UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "Axis aStrafe Speed=1.0 DeadZone=0.3" );
				UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "Axis aBaseY Speed=-1.0 DeadZone=0.3" );
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "Axis aTurn Speed=1.6 DeadZone=0.2" );
				UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "Axis aLookup Speed=-1.6 DeadZone=0.2" );
				break;
		}

		UpdateControllerSettings_Worker( 'XboxTypeS_LeftTrigger', "Fire" );
		UpdateControllerSettings_Worker( 'XboxTypeS_LeftShoulder', "EquipGrenade | OnRelease FastThrowGrenade" );
		UpdateControllerSettings_Worker( 'XboxTypeS_LeftThumbstick', "TurnOn" );

		UpdateControllerSettings_Worker( 'XboxTypeS_RightTrigger', "EnableAimDownSight | OnRelease DisableAimDownSight" );
		UpdateControllerSettings_Worker( 'XboxTypeS_RightShoulder', "DoSprint" );
	}

	// Now configure the other buttons
	if (CurrConfig == TPCO_Default || CurrConfig == TPCO_DefaultSouthPaw)
	{
		UpdateControllerSettings_Worker( 'XboxTypeS_A', "Jump" );
		UpdateControllerSettings_Worker( 'XboxTypeS_B', "Use | SkipCinematic" );
		UpdateControllerSettings_Worker( 'XboxTypeS_X', "Button bReload | OnRelease Reload" );
		UpdateControllerSettings_Worker( 'XboxTypeS_Y', "ChangePosture" );

		UpdateControllerSettings_Worker( 'XboxTypeS_DPad_Right', "NextWeapon" );
		UpdateControllerSettings_Worker( 'XboxTypeS_DPad_Left', "PrevWeapon" );
		UpdateControllerSettings_Worker( 'XboxTypeS_DPad_Down', "ChangeFireType" );

		//and since the grapple doesn't use bindings...
		if (GrapInt_v2 == None)
		{
			GrapInt_v2 = TPGameViewportClient(LocalPlayer(Player).ViewportClient).GrappleInteraction_v2Obj;
		}

		GrapInt_v2.GrappleButton = 'XboxTypes_B';
		// Keyboard stuff too
		GrapInt_v2.GrappleKeyboard = GetNonControllerBinding("Use | SkipCinematic");
		GrapInt_v2.KillKeyboard = GetNonControllerBinding("MoveForward");
		GrapInt_v2.ShieldKeyboard = GetNonControllerBinding("MoveBackward");
	}
	else // Alternate style
	{
		UpdateControllerSettings_Worker( 'XboxTypeS_A', "Use | SkipCinematic" );
		UpdateControllerSettings_Worker( 'XboxTypeS_B', "Jump" );
		UpdateControllerSettings_Worker( 'XboxTypeS_X', "Button bReload | OnRelease Reload" );
		UpdateControllerSettings_Worker( 'XboxTypeS_Y', "ChangePosture" );

		UpdateControllerSettings_Worker( 'XboxTypeS_DPad_Right', "NextWeapon" );
		UpdateControllerSettings_Worker( 'XboxTypeS_DPad_Left', "PrevWeapon" );
		UpdateControllerSettings_Worker( 'XboxTypeS_DPad_Down', "ChangeFireType" );

		//and since the grapple doesn't use bindings...
		if (GrapInt_v2 == None)
		{
			GrapInt_v2 = TPGameViewportClient(LocalPlayer(Player).ViewportClient).GrappleInteraction_v2Obj;
		}

		GrapInt_v2.GrappleButton = 'XboxTypes_A';
		// Keyboard stuff too
		GrapInt_v2.GrappleKeyboard = GetNonControllerBinding("Use | SkipCinematic");
		GrapInt_v2.KillKeyboard = GetNonControllerBinding("MoveForward");
		GrapInt_v2.ShieldKeyboard = GetNonControllerBinding("MoveBackward");
	}
}

private function UpdateControllerSettings_Worker( name TheName, string TheCommand )
{
	local int BindIndex;

	for( BindIndex = 0;BindIndex < PlayerInput.Bindings.Length; ++BindIndex )
	{
		if( PlayerInput.Bindings[BindIndex].Name == TheName )
		{
			PlayerInput.Bindings[BindIndex].Command = TheCommand;
			//`LogProfile("Setting"@string(TheName)@"to"@TheCommand);
		}
	}
}

simulated function name GetNonControllerBinding(string TheCommand)
{
	local int BindIndex;
	local name Binding;
	local name TempBinding;

	for( BindIndex = 0;BindIndex < PlayerInput.Bindings.Length; ++BindIndex )
	{
		if( PlayerInput.Bindings[BindIndex].Command == TheCommand )
		{
			TempBinding = PlayerInput.Bindings[BindIndex].Name;
			if (TempBinding == 'XboxTypeS_A' ||
				TempBinding == 'XboxTypeS_B' ||
				TempBinding == 'XboxTypeS_X' ||
				TempBinding == 'XboxTypeS_Y' ||
				TempBinding == 'XboxTypeS_Back' ||
				TempBinding == 'XboxTypeS_Start' ||
				TempBinding == 'XboxTypeS_RightThumbstick' ||
				TempBinding == 'XboxTypeS_LeftThumbstick' ||
				TempBinding == 'XboxTypeS_LeftX' ||
				TempBinding == 'XboxTypeS_LeftY' ||
				TempBinding == 'XboxTypeS_RightX' ||
				TempBinding == 'XboxTypeS_RightY' ||
				TempBinding == 'XboxTypeS_DPad_Right' ||
				TempBinding == 'XboxTypeS_DPad_Left' ||
				TempBinding == 'XboxTypeS_DPad_Up' ||
				TempBinding == 'XboxTypeS_DPad_Down' ||
				TempBinding == 'XboxTypeS_LeftTrigger' ||
				TempBinding == 'XboxTypeS_LeftShoulder' ||
				TempBinding == 'XboxTypeS_RightTrigger' ||
				TempBinding == 'XboxTypeS_RightShoulder' ||
				TempBinding == 'Gamepad_LeftStick_Up' ||
				TempBinding == 'Gamepad_LeftStick_Down' ||
				TempBinding == 'Gamepad_LeftStick_Right' ||
				TempBinding == 'Gamepad_LeftStick_Left' ||
				TempBinding == 'Gamepad_RightStick_Up' ||
				TempBinding == 'Gamepad_RightStick_Down' ||
				TempBinding == 'Gamepad_RightStick_Right' ||
				TempBinding == 'Gamepad_RightStick_Left')
			{
				continue;
			}
			else
			{
				Binding = TempBinding;
			}
			//`LogProfile("Setting"@string(TheName)@"to"@TheCommand);
		}
	}

	return Binding;
}

simulated function bool IsAXBoxButton(name TheName)
{
	if (TheName == 'XboxTypeS_A' ||
		TheName == 'XboxTypeS_B' ||
		TheName == 'XboxTypeS_X' ||
		TheName == 'XboxTypeS_Y' ||
		TheName == 'XboxTypeS_Back' ||
		TheName == 'XboxTypeS_Start' ||
		TheName == 'XboxTypeS_RightThumbstick' ||
		TheName == 'XboxTypeS_LeftThumbstick' ||
		TheName == 'XboxTypeS_LeftX' ||
		TheName == 'XboxTypeS_LeftY' ||
		TheName == 'XboxTypeS_RightX' ||
		TheName == 'XboxTypeS_RightY' ||
		TheName == 'XboxTypeS_DPad_Right' ||
		TheName == 'XboxTypeS_DPad_Left' ||
		TheName == 'XboxTypeS_DPad_Up' ||
		TheName == 'XboxTypeS_DPad_Down' ||
		TheName == 'XboxTypeS_LeftTrigger' ||
		TheName == 'XboxTypeS_LeftShoulder' ||
		TheName == 'XboxTypeS_RightTrigger' ||
		TheName == 'XboxTypeS_RightShoulder' ||
		TheName == 'Gamepad_LeftStick_Up' ||
		TheName == 'Gamepad_LeftStick_Down' ||
		TheName == 'Gamepad_LeftStick_Right' ||
		TheName == 'Gamepad_LeftStick_Left' ||
		TheName == 'Gamepad_RightStick_Up' ||
		TheName == 'Gamepad_RightStick_Down' ||
		TheName == 'Gamepad_RightStick_Right' ||
		TheName == 'Gamepad_RightStick_Left')
		return true;

	return false;
}

simulated function SetNonControllerBinding( name TheName, string TheCommand )
{
	local int BindIndex;
	local KeyBind	NewBind;

	for( BindIndex = 0;BindIndex < PlayerInput.Bindings.Length; ++BindIndex )
	{
		if (!IsAXBoxButton(PlayerInput.Bindings[BindIndex].Name) && PlayerInput.Bindings[BindIndex].Command == TheCommand)
		{
			PlayerInput.Bindings[BindIndex].Command = "";
		}
		if( PlayerInput.Bindings[BindIndex].Name == TheName )
		{
			PlayerInput.Bindings[BindIndex].Command = TheCommand;
			;
		}
	}

	NewBind.Name = TheName;
	NewBind.Command = TheCommand;
	PlayerInput.Bindings[PlayerInput.Bindings.Length] = NewBind;
	PlayerInput.SaveConfig();
}

simulated function ShowCrosshair(bool bShow)
{
	if( myHUD != None && TPHUD(myHUD) != None)
	{
		TPHUD(myHUD).DrawFlags.bDrawCrosshair = bShow;
		TPHUD(myHUD).DrawFlags.bDrawDamageIndicator = bShow;
	}
}


exec function DebugCam()
{
	if( PlayerCamera.CameraStyle == 'DebugCam')
	{
		//Turn off debug cam
		ServerCamera('FirstPerson');
		GotoState('PlayerWalking');
	}
	else
	{
		//Turn on debug cam

		GetFreeCamPosition(DebugCamPos,DebugCamRot); //Init cam position

		ServerCamera('DebugCam');
   		GotoState('PlayerDebugCam');
	}
}

state PlayerDebugCam
{
	function PlayerMove( float DeltaTime )
	{
		TickDebugCam(DeltaTime);
	}

	function ProcessMove( float DeltaTime, vector newAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
        Pawn.Acceleration.X = 0;
        Pawn.Acceleration.Y = 0;

        Pawn.Velocity.X = 0;
        Pawn.Velocity.Y = 0;

	}
}
function TickDebugCam(float DeltaTime)
{
	local vector X,Y,Z;
	local Rotator	DeltaRot;
	local float		VelSize;
	local float		DebugCamAccelSpeed;
	local float		DebugCamSpeed;

	DebugCamAccelSpeed = 100;
	DebugCamSpeed = 300;

	GetAxes(DebugCamRot,X,Y,Z);


	DebugCamAcceleration = PlayerInput.aForward*X + PlayerInput.aStrafe*Y + PlayerInput.aUp*vect(0,0,1);
	DebugCamAcceleration = Normal(DebugCamAcceleration) * DebugCamAccelSpeed;



	VelSize = VSize(DebugCamVelocity);
	if( VelSize > 0 )
	{
		DebugCamVelocity = DebugCamVelocity - (DebugCamVelocity - Normal(DebugCamAcceleration) * VelSize) * FMin(DeltaTime * 8, 1);
	}

	DebugCamVelocity = DebugCamVelocity + DebugCamAcceleration * DeltaTime;
	if( VSize(DebugCamVelocity) > DebugCamSpeed )
	{
		DebugCamVelocity = Normal(DebugCamVelocity) * DebugCamSpeed;
	}

	DebugCamPos += DebugCamVelocity;



	DeltaRot.Yaw	= PlayerInput.aTurn;
	DeltaRot.Pitch	= PlayerInput.aLookUp;

	DebugCamRot	+= DeltaRot;

}

function GetDebugCam(out TViewTarget OutVT)
{
	OutVT.POV.Location = DebugCamPos;
	OutVT.POV.Rotation = DebugCamRot;
}

function OnGetTutorialMarkup(UIAction_GetTutorialMarkup uiaction)
{
    uiaction.TutorialMarkupString = TutorialMarkup;
}

function OnTPTutorial(SeqAct_TPTutorial action)
{
    TutorialMarkup = action.TutorialMarkup;
    if (action.InputLinks[0].bHasImpulse) // open
    {
        GetUIController().OpenScene(TutorialScene, LocalPlayer(Player));
    }
    else if (action.InputLinks[1].bHasImpulse) // close
    {
        GetUIController().CloseScene(TutorialScene);
    }

}

// Objective stuff ha
function OnAddObjective(SeqAct_AddObjective inAction)
{
	local bool bFoundObj;
	local int idx;

	//`log("OnAddObjective");
	bFoundObj = false;
	for (idx = 0; idx < Objectives.Length && !bFoundObj; idx++)
	{
		if (Objectives[idx].ObjectiveName == inAction.ObjectiveName)
		{
			bFoundObj = true;
			// update the receipt time
			Objectives[idx].ReceiptTime = WorldInfo.TimeSeconds;
		}
	}
	if (!bFoundObj)
	{
		//`log("OnAddObjective - Adding new entry");
		// add new entry
		if (myNonWeaponUIScene != None)
			UIScene_TPNonWeaponHUD(myNonWeaponUIScene).ObjectiveAdded();

		idx = Objectives.Length;
		Objectives.Length = idx + 1;
		Objectives[idx].ObjectiveName = inAction.ObjectiveName;
		Objectives[idx].ObjectiveMarkup = inAction.ObjectiveMarkup;
		Objectives[idx].ReceiptTime = WorldInfo.TimeSeconds;
	}
}

function OnCompleteObjective(SeqAct_CompleteObjective inAction)
{
	local int idx;

	// search for the objective
	for (idx = 0; idx < Objectives.Length; idx++)
	{
		if (Objectives[idx].ObjectiveName == inAction.ObjectiveName)
		{
			// if aborted then just remove and be done
			// To make this consistent, always just remove the objective and put up the complete! text regardless of what happened
			Objectives.Remove(idx--,1);
			// otherwise mark as completed
			if (myNonWeaponUIScene != None)
				UIScene_TPNonWeaponHUD(myNonWeaponUIScene).ObjectiveComplete();

// 			if (inAction.bAborted)
// 			{
// 				Objectives.Remove(idx--,1);
// 			}
// 			else
// 			{
// 				// otherwise mark as completed
// 				if (myNonWeaponUIScene != None)
// 					UIScene_TPNonWeaponHUD(myNonWeaponUIScene).ObjectiveComplete();
// 
// 				Objectives[idx].bCompleted = true;
// 				Objectives[idx].CompletedTime = WorldInfo.TimeSeconds;
// 			}
		}
	}
}

function ClearObjectives()
{
	local int idx;

	if (myNonWeaponUIScene != None)
		UIScene_TPNonWeaponHUD(myNonWeaponUIScene).ClearDisplay();
	for (idx = 0; idx < Objectives.Length; idx++)
	{
		Objectives.Remove(idx--,1);
	}
}

simulated function WeaponIsEmpty(TPWeapon W)
{
	if (W.CanReload())
		return;

	// Added for Checking Whether you are out of ammo in Kismet
	switch (W.WeapID)
	{
	case 'Panzer':
		TriggerEventClass(class'SeqEvent_WeaponEmpty', W, 0);
		break;
	case 'Grenade':
	case 'Grenade_MP':
	case 'Grenade_Persistent':
		TriggerEventClass(class'SeqEvent_WeaponEmpty', W, 1);
		break;
	}
}

exec function UnlockInsane()
{
	ProfileSettings.UnlockInsane();
	WriteProfile(true);
}

simulated function SetMenuPresence()
{
	local LocalPlayer LocPlayer;
	local array<LocalizedStringSetting> Contexts;
	local array<SettingsProperty> Properties;
	local int i;

	bLoginWarningInProgress = false;
	if (OnlineSub != None && WorldInfo.NetMode == NM_Standalone)
	{
		if (OnlineSub.PlayerInterfaceEx != None)
		{
			LocPlayer = LocalPlayer(Player);
			if (LocPlayer != None)
			{
				for (i=0; i<4;i++)
				{
					if (i == LocPlayer.ControllerId)
						OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MENUS_PRESENCE,Contexts,Properties);
					else
						OnlineSub.PlayerInterface.SetOnlineStatus(i,NOT_PLAYING_PRESENCE,Contexts,Properties); //4 is an empty string
				}
			}
		}
	}
	
}


simulated function SetDefaultPresence()
{
	local LocalPlayer LocPlayer;
	local array<LocalizedStringSetting> Contexts;
	local array<SettingsProperty> Properties;
	local int i;


	bLoginWarningInProgress = false;
	if (OnlineSub != None && WorldInfo.NetMode == NM_Standalone)
	{
		if (OnlineSub.PlayerInterfaceEx != None)
		{
			LocPlayer = LocalPlayer(Player);
			if (LocPlayer != None)
			{
				for (i=0; i<4;i++)
				{
					OnlineSub.PlayerInterface.SetOnlineStatus(i,NOT_PLAYING_PRESENCE,Contexts,Properties); //4 is an empty string
				}
			}
		}
	}
	
}

reliable client function ClientSetOnlineStatus()
{
	local LocalPlayer LocPlayer;
	//local LocalizedStringSetting Setting;
	local OnlineGameSettings GameSettings;
	local int GameMode, MapID;
	local MaterialEffect myDamagePost;

	

	LocPlayer = LocalPlayer(Player);

	if (LocPlayer != None && OnlineSub != None)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings();
		if (GameSettings != none)
		{
			GameSettings.GetStringSettingValue(GAME_MODE,GameMode);
			GameSettings.GetStringSettingValue(CONTEXT_MAPNAME,MapID);
		}

		if( GetURLMap() == "entry_master" )
		{
			SetDefaultPresence();
		}
		else
		{
			if (WorldInfo.NetMode != NM_Standalone)
				UpdateMPRichPresence( MapID, int(GameSettings.bIsLanMatch), TPGameReplicationInfo(WorldInfo.GRI).GameStatus, GameMode );
		}

		if (GameSettings != none && WorldInfo.NetMode == NM_ListenServer)
		{
			;
			OnlineSub.GameInterface.UpdateOnlineGame(GameSettings);
		}

		// This is one of the few early places where LocPlayer should be valid on the CLIENT.
		myDamagePost = MaterialEffect(LocalPlayer(Player).PlayerPostProcess.FindPostProcessEffect('DamagePost'));
		myDamagePost.bShowInGame = true;
		

	}
}


reliable client function ClientSetGameStatus(int NewGameStatus)
{
	local OnlineGameSettings GameSettings;
	local int MapID;
	local int GameMode;

	//GameStatus = NewGameStatus;


	GameSettings = OnlineSub.GameInterface.GetGameSettings();

	GameSettings.GetStringSettingValue(GAME_MODE,GameMode);
	GameSettings.GetStringSettingValue(CONTEXT_MAPNAME,MapID);

	//`log( "*****KellyDEBUG: In ClientSetGameStatus for " $ self $ " GameMode is " $ GameMode $ " GameStatus is " $ NewGameStatus );	
	//ScriptTrace();

	UpdateMPRichPresence( MapID, int(GameSettings.bIsLanMatch), NewGameStatus, GameMode );
}

function SetSPPresence()
{
	local LocalPlayer LocPlayer;
	local array<LocalizedStringSetting> Contexts;
	local array<SettingsProperty> Properties;
	local eSPMapContext SPMapContext;
	local eSPDifficultyContext SPDifficultyContext;
	local string LevelName;

	bSPMapNameDirty = false;
	LevelName = GetCurrentLevelName();
	
	if (LevelName == "entry_master")
	{
		;

		return;
	}
	else if (LevelName == "")
	{
		LevelName = Locs(LastTravelURL); //convert to lower case
		LastTravelURL = "";
	}

	Contexts.Length = 2;

	// Set the map name
	Contexts[0].Id = CONTEXT_SPMAPNAME;
	Contexts[0].AdvertisementType = ODAT_OnlineService;

	if (LevelName == "nyss1_master" || LevelName == "nyss3_master")
 		SPMapContext = SPMAPNAME_NYSS;
 	else if (LevelName == "nybr6_master" || LevelName == "cs_subway_master")
 		SPMapContext = SPMAPNAME_NYBR;
 	else if (LevelName == "nyes_master")
 		SPMapContext = SPMAPNAME_NYES;
 	else if (LevelName == "dcrd1_master" || LevelName == "dcrd2_master" || LevelName == "dcrd3_master")
 		SPMapContext = SPMAPNAME_DCRD;
 	else if (LevelName == "dcrd4_master" || LevelName == "dcrd5_master" || LevelName == "dcrd6_master")
 		SPMapContext = SPMAPNAME_DCRD;
 	else if (LevelName == "dcwh_ext_master" || LevelName == "dcwh_master" || LevelName == "dcwh1_master" || LevelName == "dcwh2_master"
 		|| LevelName == "dcwh3_master" || LevelName == "dcwh4_master" || LevelName == "dcwh5_master")
 		SPMapContext = SPMAPNAME_DCWH;
 	else if (LevelName == "uktl_master")
		SPMapContext = SPMAPNAME_UKTL;
 	else if (LevelName == "ukbr_master")
		SPMapContext = SPMAPNAME_UKBR;
 	else if (LevelName == "ukzp_master")
		SPMapContext = SPMAPNAME_UKZP;
	else
	{
		//SPMapContext = SPMAPNAME_NYSS;
		
		//No Level (error), just set default presence
		SetDefaultPresence();
		return;
	}

	Contexts[0].ValueIndex = SPMapContext;

	// Set the difficulty
	Contexts[1].Id = CONTEXT_SPDIFFICULTY;
	Contexts[1].AdvertisementType = ODAT_OnlineService;

	switch (TPGameInfo(WorldInfo.Game).CurrentDifficulty)
	{
		case PDO_Normal:
			SPDifficultyContext = SPDIFFICULY_NORMAL;
			break;
		case PDO_Easy:
			SPDifficultyContext = SPDIFFICULTY_EASY;
			break;
		case PDO_Hard:
			SPDifficultyContext = SPDIFFICULY_HARD;
			break;
		case PDO_Insane:
			SPDifficultyContext = SPDIFFICULY_INSANE;
			break;
	}

	Contexts[1].ValueIndex = SPDifficultyContext;

	if (OnlineSub != None)
	{
		if (OnlineSub.PlayerInterfaceEx != None)
		{
			LocPlayer = LocalPlayer(Player);
			if (LocPlayer != None)
			{
				;
				OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,SINGLEPLAYER_PRESENCE,Contexts,Properties);
			}
		}
	}
}

reliable client function ClientShowOverTime()
{
	local Inventory inv;
	local TPWeapon tpWeap;
	local MultiplayerPawn netPawn;

	UIScene_TPNonWeaponHUD(myNonWeaponUIScene).SetOverTimeText();
	
	// All weapons have infinite ammo in MP
	// Go through all weapons and set them to infinite ammo ( server should set all clients so foreach is valid )
	foreach AllActors(class'MultiplayerPawn', netPawn)
	{
		;
		;

		for (inv = netPawn.InvManager.InventoryChain; inv != None; inv = inv.Inventory)
		{
			
			tpWeap = TPWeapon(inv);
			tpWeap.MakeWeaponUnlimited();
			;
		}
	}

	
}

state Dead
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		if (WorldInfo.NetMode != NM_Standalone)
			WaitDelay = WorldInfo.TimeSeconds + TPGameReplicationInfo(WorldInfo.GRI).GameClass.default.RespawnDelay;

		/*if (WorldInfo.NetMode != NM_Standalone)
		{
			SetTimer(10.0, false, 'ServerReStartPlayer');

		}*/
	}
}

function UpdateControllerConnectionStatus()
{
	local int Status;
	local int ControllerId;
	local OnlineSubsystem LocalOnlineSub;
	local OnlineSystemInterface LocalSystemInterface;
	// Figure out if we have an online subsystem registered
	LocalOnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (LocalOnlineSub != None)
	{
		LocalSystemInterface = LocalOnlineSub.SystemInterface;
		if (LocalSystemInterface != None)
		{
			for(ControllerId=0; ControllerId < 7; ControllerId++)
			{
				Status = 0;
				if(LocalSystemInterface.IsControllerConnected(ControllerId))
				{
					Status = 1;
				}
				SetControllerConnectionStatus(ControllerID, Status);
			}
		}
	}
}

//exec function PauseMovie()
//{
//	local TPGameViewportClient viewport;
//    viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
//
//	if (WorldInfo.NetMode == NM_Standalone && viewport != None)
//	{
//		`log("Pausing Movie: WasPaused = "$viewport.FullScreenIsMoviePaused());
//		viewport.FullScreenPauseMovie(!viewport.FullScreenIsMoviePaused());
//		`log("IsPausedNow = "$viewport.FullScreenIsMoviePaused());
//	}
//}

function SetControllerConnectionStatus( int ControllerId, int bInStatus )
{
	if (ControllerId >= 0 && ControllerID < 7)
	{
		bControllersConnectionStatus[ControllerId] = bInStatus;
	}
	else
	{
		;
	}
}

function int GetControllerConnectionStatus( int ControllerId )
{
	if (ControllerId >= 0 && ControllerID < 7)
	{
		return bControllersConnectionStatus[ControllerId];
	}
	else
	{
		;
	}

	return 0;
}

function bool SetControllerId( int ControllerId )
{
	local LocalPlayer LocPlayer;

	LocPlayer = LocalPlayer(Player);
	if ( LocPlayer != None )
	{
		ClearOnlineDelegates();

		LocPlayer.SetControllerId(ControllerId);

		RegisterOnlineDelegates();

		bControllerAssigned = true;
		bAssignedControllerDisconnected = false;
		DisconnectedAssignedController = -1;

		SetControllerConnectionStatus( ControllerID , 1);

		;

		ClearLoginDelegates();
		AssignLoginDelegates();

		return true;
	}

	return false;
}

function bool IsControllerConnected()
{
	local LocalPlayer LocPlayer;
	local bool Result;
	LocPlayer = LocalPlayer(Player);
	Result = false;

	if ( LocPlayer != None && LocPlayer.ControllerId >= 0)
	{
		UpdateControllerConnectionStatus();
		if (GetControllerConnectionStatus(LocPlayer.ControllerId) > 0)
		{
			Result = true;
		}
	}

	return Result;
}

/**
 * Attempts to pause/unpause the game when a controller becomes
 * disconnected/connected
 *
 * @param ControllerId the id of the controller that changed
 * @param bIsConnected whether the controller is connected or not
 */
function OnControllerChanged(int ControllerId,bool bIsConnected)
{
	local LocalPlayer LocPlayer;
	local bool bIsInShellMenu;
	local int status;
	//local int idx;
	//local int NewControllerIdx;
	//local LocalPlayer OtherPlayer;

	// Don't worry about remote players
	LocPlayer = LocalPlayer(Player);
	
	bIsInShellMenu = IsInShellLevel();

	status = 0;
	if (bIsConnected)
	{
		status = 1;
	}
	// Keep track of each controller's status...
	SetControllerConnectionStatus(ControllerId, status);

	;

	if ( LocPlayer != None )
	{
		// If the controller that changed, is attached to the this playercontroller
		if ( LocPlayer.ControllerId == ControllerId )
		{
			bIsControllerConnected = bIsConnected;

			;

			if (!bIsInShellMenu || (bIsInShellMenu && bControllerAssigned))
			{
				// Pause if the controller was removed
				if (!bIsConnected)
				{
					if (!bIsInShellMenu && IsPaused() && WorldInfo.IsConsoleBuild(CONSOLE_PS3))
					{
						if ( !bSystemPauseRequested )
						{
							;
							ShowControllerDisconnectMsg(ControllerId + 1);
						}
						else
						{
							;
						}

						bPauseRequested = false;
					}
					else
					{
						;
						bPauseRequested = true; //Queue up a pause request for next tick
					}
					
					bAssignedControllerDisconnected = true;
					DisconnectedAssignedController = ControllerId;
				}
				else
				{
					if (WorldInfo.IsConsoleBuild(CONSOLE_PS3))
					{
						if (!bPauseRequested 
							&& bIsInShellMenu 
							&& bControllerAssigned
							&& !bSystemPauseRequested
							&& !bGamePausedBySystemRequest
							)
						{
							;
							SetPause(false);
							EnableUI();
						}
					}
					bPauseRequested = false; //Clear request
					bAssignedControllerDisconnected = false;
					DisconnectedAssignedController = -1;
					HideControllerDisconnectMsg();
				}
			}
		} 
	}
}

/**
 * Attempts to pause/unpause the game on system request.
 *
 * @param bShouldPause whether we should pause or not
 */
event OnSystemPauseRequest(bool bShouldPause)
{
	//local TPGameViewportClient viewport;
	
	;

	if ( WorldInfo.NetMode != NM_STANDALONE )
		return;

	bSystemPauseRequested = bShouldPause;

	if ( !bSystemPauseRequested )
	{
		if ( bGamePausedBySystemRequest )
		{
			//`Log("OnSystemPauseRequest: UN-Pausing System Pause request - restoring viewport showflags");
			//RestoreViewportShowFlags();

			/*
			viewport = TPGameViewportClient(LocalPlayer(Player).ViewportClient);
			if ( viewport != none && viewport.FullScreenIsMoviePlaying() )
			{
				//`Log("OnSystemPauseRequest: Unpausing during movieplayback!");
				//viewport.FullScreenPauseMovie(false);
				//EnableUI();

				if ( IsPaused() )
				{
					SetPause(false);
				}
			}
			else
			*/
			if ( IsInShellLevel() )
			{
				;
				SetPause(false);
				
				//`Log("OnSystemPauseRequest: In ShellMenu enabling UI.");
				//EnableUI();
			}

			bGamePausedBySystemRequest = false;
		}

		if ( WorldInfo.IsConsoleBuild(CONSOLE_PS3) )
		{
			if ( !IsInShellLevel() && IsPaused() && bAssignedControllerDisconnected  )
			{
				;
				ShowControllerDisconnectMsg(DisconnectedAssignedController + 1);
			}
		}
	}
}

/** actually performs the level transition prepared by PrepareMapChange() */
reliable client event ClientCommitMapChange(optional bool bShouldSkipLevelStartupEvent, optional bool bShouldSkipLevelBeginningEvent)
{
	bCommitMapChangePending = true;

	super.ClientCommitMapChange(bShouldSkipLevelStartupEvent, bShouldSkipLevelBeginningEvent);
}


function SetMyLastHitPawn(Pawn theHitPawn)
{
	MyLastHitPawn = theHitPawn;

	//Notify the input that we hit this pawn for super sticky adhesion
	if( TPPlayerInput(PlayerInput) != None )
		TPPlayerInput(PlayerInput).NotifyNewLastHitPawn(theHitPawn);
}

function Pawn GetMyLastHitPawn()
{
	return MyLastHitPawn;
}



exec function UnlockAllAchievements()
{
	local int i;
	for (i = 13; i <= 55; i++)
	{
		ClientUnlockAchievement(i);
	}
}

function ClearPostMaterials()
{
	TurnOffGogglesIfEnabled();
	if (PlayerPawn(Pawn) != None)
		PlayerPawn(Pawn).ClearMeleeHitEffect();
}

exec function DisableUIInput()
{
	bAllowUIInput = false;
}

function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
	Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,DamageType,Momentum);

	if (Damage > 0)
	{
		ClientPlayTakeHit(HitLocation - Pawn.Location, Damage, DamageType);
	}
}

simulated function HitAnimTimeOut()
{
	if (WorldInfo.NetMode != NM_Standalone)
	{
		MultiplayerPawn(Pawn).bEnableHitReaction = false;
		ClearTimer('HitAnimTimeOut');
	}
}

unreliable client function ClientPlayTakeHit(vector HitLoc, byte Damage, class<DamageType> DamageType)
{
	if( Pawn != None && MultiplayerPawn(Pawn) != None )
	{
		MultiplayerPawn(Pawn).bEnableHitReaction = true;
	}
	SetTimer(1.0f,false,'HitAnimTimeOut');
}

/**
 * Called on the client to have them commit their arbitration results
 */
reliable client function ClientWriteArbitrationEndGameData(class<OnlineStatsWrite> OnlineStatsWriteClass)
{
	local TPGameStatsWrite Stats;
	local TPPlayerReplicationInfo PRI;
	local TPGameReplicationInfo GRI;
	local int Index;
	local int PlayerScore;

	bIgnoreCloseNotify = true;
	// Only calc this if the subsystem can write stats
	if (OnlineSub != None && OnlineSub.StatsInterface != None)
	{
		Stats = TPGameStatsWrite(new OnlineStatsWriteClass);
		// Get the GRI so we can iterate players
		GRI = TPGameReplicationInfo(WorldInfo.GRI);
		// Iterate through the active PRI list updating the stats
		for (Index = 0; Index < GRI.PRIArray.Length; Index++)
		{
			PRI = TPPlayerReplicationInfo(GRI.PRIArray[Index]);
			;
			if (!PRI.bIsInactive)
			{				
				// Set the data
				//UpdateStatsFromPRI(GRI,PRI,Stats);
				Stats.IncrementKill(PRI.Kills);
				Stats.IncrementDeaths(PRI.Deaths);

				if (PRI.Team != none)
					PlayerScore = PRI.Team.Score;
				else
					PlayerScore = PRI.Score;
				
				Stats.IncrementScore(PlayerScore);
				
				if (PRI.GameWinner)
				{
					Stats.IncrementGamesWon(1);
					Stats.IncrementGamesLost(0);
					ClientIncrementGamesWon(PRI.Team != none);
				}
				else
				{
					Stats.IncrementGamesWon(0);
					Stats.IncrementGamesLost(1);
				}

				// This will copy them into the online subsystem where they will be
				// sent via the network in EndOnlineGame()
				OnlineSub.StatsInterface.WriteOnlineStats(PRI.UniqueId,Stats);
			}
		}
	}

	ClientWriteOnlinePlayerScores();
	ServerWritenArbitrationEndGameData();
	// Let the parent class finish up
	//Super.ClientWriteArbitrationEndGameData(OnlineStatsWriteClass);

}

/**
 * Writes the scores for all active players. Override this in your
 * playercontroller class to provide custom scoring
 */
reliable client function ClientWriteOnlinePlayerScores()
{
	local GameReplicationInfo GRI;
	local int Index;
	local array<OnlinePlayerScore> PlayerScores;
	local UniqueNetId ZeroUniqueId;
	local bool bIsTeamGame;
	local int ScoreIndex;

	GRI = WorldInfo.GRI;
	if (GRI != None && OnlineSub != None && OnlineSub.StatsInterface != None)
	{
		// Look at the default object of the gameinfo to determine if this is a
		// team game or not
		bIsTeamGame = GRI.GameClass != None ? GRI.GameClass.default.bTeamGame : FALSE;
		// Iterate through the players building their score data
		for (Index = 0; Index < GRI.PRIArray.Length; Index++)
		{
			if (GRI.PRIArray[Index].UniqueId != ZeroUniqueId)
			{
				ScoreIndex = PlayerScores.Length;
				PlayerScores.Insert(ScoreIndex,1); 
				// Build the skill data for this player
				PlayerScores[ScoreIndex].PlayerId = GRI.PRIArray[Index].UniqueId;
				if (bIsTeamGame)
				{
					PlayerScores[ScoreIndex].TeamId = GRI.PRIArray[Index].Team.TeamIndex;
					PlayerScores[ScoreIndex].Score = GRI.PRIArray[Index].Team.Score;
				}
				else
				{
					PlayerScores[ScoreIndex].TeamId = Index;
					PlayerScores[ScoreIndex].Score = GRI.PRIArray[Index].Score;
				}
			}
		}
		// Now write out the scores
		OnlineSub.StatsInterface.WriteOnlinePlayerScores(PlayerScores);
	}
}

exec function EnableUIInput()
{
	bAllowUIInput = true;
}

function SetFrontEndErrorMessage(string Title, string Message, optional bool bWasOnline = false, optional bool bIgnoreError = false, optional bool bForceOpenRoot = false)
{
	local string messageDisplay;

	if ( class'UIRoot'.static.GetDataStoreStringValue("<Registry:FrontEndError_Display>", messageDisplay ) )
	{
		if ( messageDisplay == "1" )
		{
			class'UIRoot'.static.GetDataStoreStringValue("<Registry:FrontEndError_Message>", messageDisplay);
			;
			return;
		}
			
	}
	if ( bIgnoreError )
	{
		class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Ignore>", "1");	
	}
	class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Title>", Title);
	class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Message>", Message);
	
	if (Len(Message) > 0)
		class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Display>", "1");
	else
		class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Display>", "0");

	if (bWasOnline)
		class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Online>", "1");
	else
		class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Online>", "0");

	if ( bForceOpenRoot )
		class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Online>", "2");
}

/**
 * Notifies the player that an attempt to connect to a remote server failed, or an existing connection was dropped.
 *
 * @param	Message		a description of why the connection was lost
 * @param	Title		the title to use in the connection failure message.
 */
function NotifyConnectionError( string Message, optional string Title )
{
	// This is no longer called.
	if ( WorldInfo.Game != None )
	{
		// Mark the server as having a problem
		WorldInfo.Game.bHasNetworkError = true;
	}

	;
}

reliable client function ClientSetProgressMessage( EProgressMessageType MessageType, string Message, optional string Title )
{
	local bool bArbitrationConnectionError;
	local string ArbitrationErrorMessage;

	;
	switch ( MessageType )
	{
	case PMT_ConnectionFailure:
		// Below works.
		;
		
		;

		if (Message == Localize("GameMessage", "ArbitrationMessage", "Engine"))
			bArbitrationConnectionError = true;

		if (class'UIRoot'.static.GetDataStoreStringValue("<Registry:FrontEndError_ArbitrationError>", ArbitrationErrorMessage ))
		{
			if ( ArbitrationErrorMessage == "1" )
			{
				bArbitrationConnectionError = true;
				class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_ArbitrationError>", "0");
			}
		}

		// If our Message is Server Full, then show that..  Otherwise show Connection TO network lost message.
		if (Message == Localize("GameMessage", "MaxedOutMessage", "Engine") )
			SetFrontEndErrorMessage(Localize("NetworkMessages", "LostConnectionFromHostTitle", "TPGame"), Localize("GameMessage", "MaxedOutMessage", "Engine"), true);
		else
			SetDisconnectionError(FRONTEND_INGAME);
			
		if (WorldInfo.NetMode != NM_Standalone &&
		OnlineSub != None &&
		OnlineSub.GameInterface != None &&
		OnlineSub.GameInterface.GetGameSettings() != None)
		{
			if (/*WorldInfo.NetMode == NM_Client && */WorldInfo.GRI.bIsArbitrated)
			{
				DestroyOnlineSession();
				ConsoleCommand("Disconnect");
			}
			else
			{
				EndOnlineGame();
				ConsoleCommand("Disconnect");
			}
		}
		else
		{
			if (!bArbitrationConnectionError)
				ActivateRemoteEvent('ReopenRoot');
			else
			{
				if ( ArbitrationErrorMessage == "1" )
				{
					DestroyOnlineSession();
					ConsoleCommand("Disconnect");
				}
				else
				{
					class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_ArbitrationError>", "1");
				}
			}
		}
		break;
/*
	case PMT_Information:
		if ( Message == "LAGGY" )
		{
			UIScene_TPNonWeaponHUD( myNonWeaponUIScene ).ShowNetworkError(true);	
		}
		else if ( Message == "NOTLAGGY" )
		{
			UIScene_TPNonWeaponHUD( myNonWeaponUIScene ).ShowNetworkError(false);
		}
		break;*/
	default:
		Super.ClientSetProgressMessage( MessageType, Message, Title );
		break;
	}
}

////reliable client event ClientSetProgressMessage( int InIndex, string S, color C ) //SPARK OCT CODEDROP
//reliable client function ClientSetProgressMessage( EProgressMessageType MessageType, string Message, optional string Title )
//{
//	super.ClientSetProgressMessage( MessageType, Message, Title) ;
//	
//	//SPARK OCT CODEDROP - should we check the MessageType here?
//	
//	//if (InIndex == 0)
//	//{
//	if ( MessageType == PMT_ConnectionFailure )
//	{
//		NotifyConnectionError(Message, Title);
//	}
//	//}
//}

function onDetachPlayerFromVehicle(SeqAct_DetachPlayerFromVehicle action)
{
	local Vehicle V;
    V = Vehicle(Pawn);
	if (V != none)
	{
		V.DriverLeave(TRUE);
	} 
}

simulated function bool GetWasAimingDownSight()
{
	return ( bWasAimingDownSight );
}

simulated function SetWasAimingDownSight( bool set )
{
	bWasAimingDownSight = set;
}

simulated function StoreAimDownSight( bool IsAimDownSight )
{
	if ( IsAimDownSight )
	{
		DisableAimDownSight();
		SetWasAimingDownSight( true );
	}
}

simulated function RestoreAimDownSight()
{
	if ( GetWasAimingDownSight() )
	{
		EnableAimDownSight();
		SetWasAimingDownSight( false );
	}
}

reliable client function ClientSetUseGamePad(bool bUseGamePad)
{
	PlayerInput.SetUsingGamepad(bUseGamePad);
}

reliable client function UpdateMPRichPresence( int MapID, int IsLanMatch, int GameStatus, int GameMode )
{
	local array<LocalizedStringSetting>		Contexts;
	local array<SettingsProperty>			Properties;

	local LocalPlayer LocPlayer;

// 	`log( "*****JOHNDEBUG: In UpdateMPRichPresence for " $ self $ " GameMode is " $ GameMode $ " MapID is " $ MapID );	
// 	ScriptTrace();

	Contexts.Length = 3;

	Contexts[0].Id = CONTEXT_MAPNAME;
	Contexts[0].AdvertisementType = ODAT_OnlineService;
	Contexts[0].ValueIndex = MapID;

	Contexts[1].Id = CONTEXT_MPGAMETYPE;
	Contexts[1].AdvertisementType = ODAT_OnlineService;
	Contexts[1].ValueIndex = IsLanMatch;

	Contexts[2].Id = CONTEXT_GAMESTATUS;
	Contexts[2].AdvertisementType = ODAT_OnlineService;

	if ( TPGameReplicationInfo(WorldInfo.GRI).GameStatus <= GS_Lobby )
	{
		//`log( "*****KELLYDEBUG: In UpdateMPRichPresence for " $ self $ " GameMode is " $ GameMode $ " MapID is " $ MapID @ "IN_LOBBY" );	
		Contexts[2].ValueIndex = IN_LOBBY;
	}
	else
	{
		//`log( "*****KELLYDEBUG: In UpdateMPRichPresence for " $ self $ " GameMode is " $ GameMode $ " MapID is " $ MapID @ "IN_GAME" );	
		Contexts[2].ValueIndex = IN_GAME;
	}


 	//ScriptTrace();




	LocPlayer = LocalPlayer(Player);

	// Force a faster update to the rich presence string
	//***SPCODEDROP JUNEQA_BUILD: MP CHECKME - REPLACED with SetOnlineStatus() ---> OnlineSub.PlayerInterfaceEx.SetRichPresence(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
	if (GameMode == 0)
		OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_DM_PRESENCE,Contexts,Properties);
	else
		OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);

}

