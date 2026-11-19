/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * The base class for all MP specific player controllers
 */
class GearPC_MP extends GearPC
	native(PC);

`include(GearPlayerPersistentDataConstants.uci)

/** strings used when enabling/disabling bot AI in training grounds mode */
var localized string BotsEnabledMessage, BotsDisabledMessage;

/** Played when we go into sudden death **/
var SoundCue SuddenDeathSound;
/** Text to draw when we go into sudden death */
var localized string SuddenDeathString;

/** drawn when the player can no longer respawn in a respawning gametype */
var localized string RespawnsDepletedText;

/** Used to keep the state of whether MP debugging is on**/
var bool bShowDebugMP;

/** True if transitioning to ghost spectating from the dead state.  Used to set camera transition params. */
var transient protected bool bGhostSpectatingFromDeadState;

/** Separate pitch value for ghost spectating since the controller pitch will get zero'd by physwalking. */
var int GhostSpectatingPitch;

var GearTutorial_Leader LeaderTutorial;

/** MP character loader and referencer - not spawned in listen servers or second (or more) player of a splitscreen client */
var GearMPCharacterStore CharacterStore;

/** This is the number of consecutive matches played by this player. DO NOT STORE! */
var transient int ConsecutiveMatchesPlayed;

/** Keeps all data relevant to player and game state needed to reestablish the game after host migration */
var transient GearGameHostMigrationManager GameHostMigrationManager;

/** set if client thinks its stats are low enough for newbie assistance; @see GearGameMP_Base::ShouldGiveNewbHelpTo() */
var bool bRequestedNewbHelp;

cpptext
{
	virtual void NotifyActorChannelFailure(UActorChannel* ActorChan);
}

simulated event PostBeginPlay()
{
	local OnlineGameSettings GameSettings;
	local int MatchType;

	Super.PostBeginPlay();

	// Only enable host migration for Ranked/Social matches
	if (OnlineSub != None &&
		OnlineSub.GameInterface != None &&
		WorldInfo.NetMode == NM_Client &&
		IsPrimaryPlayer())
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (GameSettings != None)
		{
			GameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE,MatchType);
			if (MatchType == eGVMT_Official || MatchType == eGVMT_Player)
			{
				WorldInfo.ToggleHostMigration(true);
			}
		}
	}
}

event InitInputSystem()
{
	Super.InitInputSystem();

	// create the character loader if we are the first player on a client
	if (Role < ROLE_Authority && NetPlayerIndex == 0)
	{
		CharacterStore = new(self) class'GearMPCharacterStore';
		CharacterStore.LoadComplete = PawnClassLoaded;
	}
}

/** called via CharacterStore delegate; notifies the server */
function PawnClassLoaded(class<GearPawn> LoadedClass)
{
	ClientPrestreamTexturesFor(LoadedClass);

	ServerPawnClassLoaded(PathName(LoadedClass));
}
/** called by the client from its CharacterStore's delegate to notify the server that it finished loading a class
 * checks for any Pawns that weren't replicated properly due to loading/network delays and resends them to this client
 * @note: use string instead of class so that if client is ahead of the server it won't cause the server to flush async loading
 */
reliable server native final function ServerPawnClassLoaded(string LoadedClassPath);

/** called by the server to tell the client to load the class for a character */
reliable client final event ClientLoadCharacter(string CharacterPath)
{
	if (CharacterStore != None)
	{
		CharacterStore.LoadPawnClass(CharacterPath);
	}
}
/** called by the server to tell the client to unload or abort loaded the class for a character */
reliable client final function ClientUnloadCharacter(string CharacterPath)
{
	local int i;

	if (CharacterStore != None)
	{
		for (i = 0; i < CharacterStore.LoadedClasses.length; i++)
		{
			if (PathName(CharacterStore.LoadedClasses[i]) ~= CharacterPath)
			{
				CharacterStore.LoadedClasses.Remove(i, 1);
				break;
			}
		}
		CharacterStore.PendingClasses.RemoveItem(CharacterPath);

		WorldInfo.ForceGarbageCollection();
	}
}

/** Start showing the sudden death text */
final reliable client function ClientStartSuddenDeathText()
{
	local float DrawYPos;

	PlaySound(SuddenDeathSound, true);

	DrawYPos = MyGearHud.GetCountdownYPosition() + MyGearHud.CountdownSize.Y + NumPixelsToMoveDownForDramaText();
	MyGearHud.StartDrawingDramaticText( SuddenDeathString, "", 5.0f, 0.25f, 2.0f, DrawYPos, 0.25f, 1.0f );
}

reliable client final function ClientStartOvertimeText()
{
	local float DrawYPos;
	local class<GearGameMP_Base> MPClass;

	ClientPlaySound(SuddenDeathSound);

	MPClass = class<GearGameMP_Base>(WorldInfo.GRI.GameClass);
	DrawYPos = MyGearHud.GetCountdownYPosition() + MyGearHud.CountdownSize.Y + NumPixelsToMoveDownForDramaText();
	MyGearHud.StartDrawingDramaticText(MPClass.default.OvertimeTitle , MPClass.default.OvertimeDesc, 5.0, 0.25, 2.0, DrawYPos, 0.25, 1.0);
}

/*
 * MP cover debugging
*/
exec function MPCoverCheck()
{
	ServerCoverCheck();
}

unreliable server function ServerCoverCheck()
{
	local bool bReachPreciseDestination, bReachedPreciseDestination, bReachPreciseRotation, bReachedPreciseRotation;

	if ( (MyGearPawn.SpecialMove != SM_None) && (MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove] != None) )
	{
		bReachPreciseDestination = MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bReachPreciseDestination;
		bReachedPreciseDestination = MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bReachedPreciseDestination;
		bReachPreciseRotation = MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bReachPreciseRotation;
		bReachedPreciseRotation = MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bReachedPreciseRotation;
	}

	ClientCoverCheck(GetStateName(), MyGearPawn.IsInCover(), MyGearPawn.IsDoingMove2IdleTransition(), MyGearPawn.SpecialMove,
					bBreakFromCover, bIgnoreMoveInput, MyGearPawn.bIsMirrored, MyGearPawn.CoverAction,
					bPreciseDestination, MyGearPawn.CurrentLink, MyGearPawn.CurrentSlotIdx, bReachPreciseDestination, bReachedPreciseDestination,
					bReachPreciseRotation, bReachedPreciseRotation);
}

unreliable client function ClientCoverCheck(name CurrentStateName, bool bServerIsInCover, bool bServerIsDoingMove2IdleTransition, ESpecialMove ServerSpecialMove,
					bool bServerBreakFromCover, byte bServerIgnoreMoveInput, bool bServerIsMirrored,
					ECoverAction ServerCoverAction, bool bServerPreciseDestination, CoverLink ServerLink, int ServerSlotIdx,
					bool bServerReachPreciseDestination, bool bServerReachedPreciseDestination,
					bool bServerReachPreciseRotation, bool bServerReachedPreciseRotation)
{
	local string Result;
	local bool bFoundDiff;
	local bool bReachPreciseDestination, bReachedPreciseDestination, bReachPreciseRotation, bReachedPreciseRotation;

	Result = "MPCoverCheck ";

	if ( (MyGearPawn.SpecialMove != SM_None) && (MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove] != None) )
	{
		bReachPreciseDestination = MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bReachPreciseDestination;
		bReachedPreciseDestination = MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bReachedPreciseDestination;
		bReachPreciseRotation = MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bReachPreciseRotation;
		bReachedPreciseRotation = MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bReachedPreciseRotation;
	}

	if ( GetStateName() != CurrentStateName )
	{
		bFoundDiff = true;
		Result = Result$" State Client "$GetStateName()$" Server "$CurrentStateName;
	}
	else
	{
		Result = Result@GetStateName();
	}

	if ( bServerIsInCover != MyGearPawn.IsInCover() )
	{
		bFoundDiff = true;
		Result = Result$" IsInCover Client "$MyGearPawn.IsInCover()$" Server "$bServerIsInCover;
	}
	if ( bServerIsDoingMove2IdleTransition != MyGearPawn.IsDoingMove2IdleTransition() )
	{
		bFoundDiff = true;
		Result = Result$" Move2Idle Client "$MyGearPawn.IsDoingMove2IdleTransition()$" Server "$bServerIsDoingMove2IdleTransition;
	}
	if ( ServerSpecialMove != MyGearPawn.SpecialMove )
	{
		bFoundDiff = true;
		Result = Result$" SpecialMove Client "$MyGearPawn.SpecialMove$" Server "$ServerSpecialMove;
	}
	if ( bBreakFromCover != bServerBreakFromCover )
	{
		bFoundDiff = true;
		Result = Result$" BreakFromCover Client "$bBreakFromCover$" Server "$bServerBreakFromCover;
	}
	if ( bServerIsMirrored != MyGearPawn.bIsMirrored )
	{
		bFoundDiff = true;
		Result = Result$" bIsMirrored Client "$MyGearPawn.bIsMirrored$" Server "$bServerIsMirrored;
	}
	if ( ServerCoverAction != MyGearPawn.CoverAction )
	{
		bFoundDiff = true;
		Result = Result$" CoverAction Client "$MyGearPawn.CoverAction$" Server "$ServerCoverAction;
	}
	if ( bServerPreciseDestination != bPreciseDestination )
	{
		bFoundDiff = true;
		Result = Result$" bPreciseDestination Client "$bPreciseDestination$" Server "$bServerPreciseDestination;
	}
	if ( ServerLink != MyGearPawn.CurrentLink )
	{
		bFoundDiff = true;
		Result = Result$" CurrentLink Client "$MyGearPawn.CurrentLink$" Server "$ServerLink;
	}
	if ( ServerSlotIdx != MyGearPawn.CurrentSlotIdx )
	{
		bFoundDiff = true;
		Result = Result$" SlotIdx Client "$MyGearPawn.CurrentSlotIdx$" Server "$ServerSlotIdx;
	}

	if ( bServerIgnoreMoveInput != bIgnoreMoveInput )
	{
		bFoundDiff = true;
		Result = Result$" bIgnoreMoveInput Client "$bIgnoreMoveInput$" Server "$bServerIgnoreMoveInput;
	}
	else if ( bIgnoreMoveInput != 0 )
	{
		bFoundDiff = true;
		Result = Result$" bIgnoreMoveInput is "$bIgnoreMoveInput;
	}
	if ( !bFoundDiff )
	{
		Result = "MPCoverCheck in state "$GetStateName()$" - no synch issues found.";
	}

	if ( bServerReachPreciseDestination != bReachPreciseDestination )
	{
		bFoundDiff = true;
		Result = Result$" bReachPreciseDestination Client "$bReachPreciseDestination$" Server "$bServerReachPreciseDestination;
	}
	if ( bServerReachedPreciseDestination != bReachedPreciseDestination )
	{
		bFoundDiff = true;
		Result = Result$" bReachedPreciseDestination Client "$bReachedPreciseDestination$" Server "$bServerReachedPreciseDestination;
	}
	if ( bServerReachPreciseRotation != bReachPreciseRotation )
	{
		bFoundDiff = true;
		Result = Result$" bReachPreciseRotation Client "$bReachPreciseRotation$" Server "$bServerReachPreciseRotation;
	}
	if ( bServerReachedPreciseRotation != bReachedPreciseRotation )
	{
		bFoundDiff = true;
		Result = Result$" bReachedPreciseRotation Client "$bReachedPreciseRotation$" Server "$bServerReachedPreciseRotation;
	}

	if ( bFoundDiff )
		`log(Result);
	if ( (MyGearPawn != None) && (Role < ROLE_Authority) )
		ServerCoverCheck();
}

/** Special version for MP, logs only */
exec function MPDebugCover()
{
	bDebugCover = !bDebugCover;

	ServerDebugCover(bDebugCover);
}

/** Turns on MP Debugging **/
exec simulated function DebugMP()
{
	bShowDebugMP = !bShowDebugMP;
	MyGearHud.SetDebugDraw( DebugDraw_MP, bShowDebugMP );
}

/** This will draw stats we care about in MP on each of the pawns in our view **/
simulated function DebugDraw_MP( GearHUD_Base H )
{
	local vector CamLoc;
	local rotator CamRot;
	local GearPawn GP;

	H.Canvas.SetDrawColor(255,255,255);
	GetPlayerViewPoint(CamLoc,CamRot);

	foreach WorldInfo.AllPawns( class'GearPawn', GP )
	{
		if( GP != None && (GP.Location - CamLoc) dot vector(CamRot) > 0.0f )
		{
			GP.DrawDebug_MP( H, Pawn );
		}
	}
}

/** Returns the preferred MP character and weapon for this player */
reliable client function ClientSetPreferredMPOptions()
{
	// Set the values on the server
	ServerSetPreferredMPOptions(ProfileSettings.GetPreferredPrimaryWeaponId(), ProfileSettings.GetPreferredSecondaryWeaponId());
	ServerSetViralSettings(ProfileSettings.IsEpicDev(), ProfileSettings.HasCompletedAchievement(eGA_RUSTLUNG));
}

/** Set the preferred MP character and weapon for this player on the server */
reliable server function ServerSetPreferredMPOptions(int PrefPrimaryWeapon, int PrefSecondaryWeapon)
{
	local GearPRI GPRI;

	GPRI = GearPRI(PlayerReplicationInfo);
	GPRI.InitialPrimaryWeaponType = PrefPrimaryWeapon;
	GPRI.InitialSecondaryWeaponType = PrefSecondaryWeapon;
	GPRI.bForceNetUpdate = true;
}

/** Set the viral settings for earning the achievement */
reliable server function ServerSetViralSettings(bool bIsEpicDev, bool bHasViralAchievement)
{
	local GearMPPRI GPRI;

	GPRI = GearMPPRI(PlayerReplicationInfo);
	GPRI.bHasViralAchievement = bIsEpicDev || bHasViralAchievement;
}

function PressedDPad(EGameButtons Button)
{
	local array<GearGameWeaponSummary> PrimaryWeaponList, SecondaryWeaponList;
	local int Mod, i, Index;
	local GearPRI PRI;

	// spectator controls: change the default weapons
	if (WantsSpectatorUI() && !IsSplitscreenPlayer())
	{
		PRI = GearPRI(PlayerReplicationInfo);
		if (PRI != None)
		{
			class'GearGameWeaponSummary'.static.GetSortedDefaultWeapons(PrimaryWeaponList, SecondaryWeaponList);
			Mod = 1;
			Index = INDEX_NONE;
			switch (Button)
			{
				case GB_DPad_Up:
					Mod = -1;
					// intentional fallthrough
				case GB_DPad_Down:
					for (i = 0; i < PrimaryWeaponList.length; i++)
					{
						if (PrimaryWeaponList[i].WeaponID == PRI.InitialPrimaryWeaponType)
						{
							Index = i;
							break;
						}
					}
					if (Index == INDEX_NONE)
					{
						Index = 0;
					}
					else
					{
						Index += Mod;
						if (Index < 0)
						{
							Index = PrimaryWeaponList.length - 1;
						}
						else if (Index >= PrimaryWeaponList.length)
						{
							Index = 0;
						}
					}
					ProfileSettings.SetPreferredPrimaryWeaponId(PrimaryWeaponList[Index].WeaponID);
					ServerSetPreferredMPOptions(PrimaryWeaponList[Index].WeaponID, PRI.InitialSecondaryWeaponType);
					SetWeaponSkins();
					break;
				case GB_DPad_Left:
					Mod = -1;
					// intentional fallthrough
				case GB_DPad_Right:
					for (i = 0; i < SecondaryWeaponList.length; i++)
					{
						if (SecondaryWeaponList[i].WeaponID == PRI.InitialSecondaryWeaponType)
						{
							Index = i;
							break;
						}
					}
					if (Index == INDEX_NONE)
					{
						Index = 0;
					}
					else
					{
						Index += Mod;
						if (Index < 0)
						{
							Index = SecondaryWeaponList.length - 1;
						}
						else if (Index >= SecondaryWeaponList.length)
						{
							Index = 0;
						}
					}
					ProfileSettings.SetPreferredSecondaryWeaponId(SecondaryWeaponList[Index].WeaponID);
					ServerSetPreferredMPOptions(PRI.InitialPrimaryWeaponType, SecondaryWeaponList[Index].WeaponID);
					SetWeaponSkins();
					break;
				default:
					break;
			}
		}
	}
	else
	{
		Super.PressedDPad(Button);
	}
}

/** Client function so that the MP game objects can force the scoreboard up. */
reliable client function ClientToggleScoreboard( bool bOn )
{
	MyGearHud.ToggleScoreboard( bOn );
}

/** Called by the Annex game object to have the Command Point Indicator glow */
reliable client function ClientSetCommandPointIndicatorGlow( int NumPulses, float LengthOfPulse = 1.f )
{
	if ( MyGearHud != None )
	{
		MyGearHud.SetCommandPointIndicatorGlow( NumPulses, LengthOfPulse );
	}
}

/** Notifies the client that a round has ended and updates the player's stats
 *	@param bIsWinner Did this player win?
 *  @param bIsDraw Was this round a draw?
 *	@param bIsFirst	 Was this player ranked first place?
 */
reliable client function ClientStatRoundEnded(bool bIsWinner, bool bIsDraw, bool bIsFirst)
{
	local EGearMPTypes MatchType;
	local GearMPPRI MPPRI;

	if (bIsDraw)
	{
		ModifyStat('RoundsDrawnMP');
	}
	else if (bIsWinner)
	{
		ModifyStat('RoundsWonMP');

		MatchType = class'GearUIManager'.static.GetMPGameTypeStatic(GearGRI(WorldInfo.GRI));
		if (MatchType == eGEARMP_CTL && GearPRI(PlayerReplicationInfo).bIsLeader)
		{
			ModifyStat('RoundsWonAsLeaderMP');
		}
	}
	else
	{
		ModifyStat('RoundsLostMP');
	}

	if (bIsFirst)
	{
		ModifyStat('RoundsFirstMP');
	}

	MPPRI = GearMPPRI(PlayerReplicationInfo);
	if (MPPRI != None && MPPRI.TotalTimeInCoverThisRound > 0)
	{
		// Save cover time to the tenths digit
		ModifyStat('CoverTimeMP', MPPRI.TotalTimeInCoverThisRound * 10);
	}
}

/** Notifies the client that a game has ended and updates the player's stats
 *  @param bIsComplete Did the match complete (Winner not None on server)
 *	@param bIsWinner Did this player win?
 *	@param bIsFirst	 Was this player ranked first place?
 */
reliable client function ClientStatGameEnded(bool bIsComplete, bool bIsWinner, bool bIsFirst)
{
	local int MatchesPlayed;
	local EGearMPTypes MatchType;
	local EGearAchievement AchievementID;

	if (bIsComplete)
	{
		ModifyStat('GamesPlayedMP');

		MatchType = class'GearUIManager'.static.GetMPGameTypeStatic(GearGRI(WorldInfo.GRI));
		switch (MatchType)
		{
		case eGEARMP_Warzone:
			ModifyStat('WarzonePlayed');
			// @ACHIEVEMENT - Welcome To Warzone
			AchievementID = eGA_WELCOMETOWARZONE;
			break;
		case eGEARMP_Execution:
			ModifyStat('ExecutionPlayed');
			// @ACHIEVEMENT - Welcome To Execution
			AchievementID = eGA_WELCOMETOEXECUTION;
			break;
		case eGEARMP_Horde:
			ModifyStat('HordePlayed');
			break;
		case eGEARMP_Wingman:
			ModifyStat('WingmanPlayed');
			// @ACHIEVEMENT - Welcome to Wingman
			AchievementID = eGA_WELCOMETOWINGMAN;
			break;
		case eGEARMP_KOTH:
			ModifyStat('KOTHPlayed');
			// @ACHIEVEMENT - Welcome to KOTH
			AchievementID = eGA_WELCOMETOKINGOFTHEHILL;
			break;
		case eGEARMP_CTL:
			ModifyStat('CTLPlayed');
			// @ACHIEVEMENT - Welcome to CTL
			AchievementID = eGA_WELCOMETOCAPTURETHELEADER;
			break;
		case eGEARMP_Newbie:
			ModifyStat('TDMPlayed');
			// @ACHIEVEMENT - Welcome to TDM
			AchievementID = eGA_WELCOMETOTEAMDEATHMATCH;
			break;
		case eGEARMP_Siege:
			ModifyStat('SiegePlayed');
			break;
		default:
			`Log("ClientStatGameEnded unknown gametype when applying stat credit.");
			break;
		}

		MatchesPlayed = StatManager.GetStatValueByName('GamesPlayedMP');
		if (MatchType != eGEARMP_Horde && MatchType != eGEARMP_Siege && MatchesPlayed >= 1)
		{
			NotifyEarnedAward('Cherry');
			// @BETA
			NotifyEarnedAward('BetaTester');
		}

		if (bIsWinner)
		{
			ModifyStat('GamesWonMP');
		}
		else
		{
			ModifyStat('GamesLostMP');
		}

		if (bIsFirst)
		{
			ModifyStat('GamesFirstMP');
		}

		// Only Social/Ranked unlock achievements
		if (AchievementID > 0)
		{
			if (GearGRI_MP(WorldInfo.GRI).PlaylistId > 0)
			{
				ClientUnlockAchievement(AchievementID);
			}
		}

		if (GearPawn_Infantry(Pawn) != None && GearPawn_Infantry(Pawn).bIsFemale)
		{
			ModifyStat('FemaleCharMP');
		}
	}
}

/** Client call to allow us to do HUD effects and sounds because of the end of the game approaching */
reliable client function ClientEndOfGameWarning( int ScoreDiff, int TeamIndex )
{
	if ( MyGearHud != None )
	{
		MyGearHud.DoEndOfGameWarning( ScoreDiff, TeamIndex );
	}
}

/** Message sent from Assassination game mode that a leader has died */
reliable client function ClientLeaderDied( GearPRI LeaderPRI )
{
	if ( MyGearHud != None )
	{
		MyGearHud.StartLeaderDiedMessage( LeaderPRI );
	}
}

/** Message sent from Wingman game mode that power weapons are available */
reliable client function ClientWeaponsSpawned()
{
	if ( MyGearHud != None )
	{
		MyGearHud.StartWeaponSpawnedMessage();
	}
}

/** Message sent from Wingman game mode that your buddy has died */
reliable client function ClientBuddyDied( GearPRI BuddyPRI )
{
	ClientPlaySound(SoundCue'DLC_Annex.Annex.TeamMemberKilledCue');
	if ( MyGearHud != None )
	{
		MyGearHud.StartBuddyDiedMessage( BuddyPRI );
	}
}

/** Message sent from Lambent game mode that only lambent are left */
reliable client function ClientOnlyLambentLeft()
{
	if (MyGearHud != None)
	{
		MyGearHud.StartOnlyLambentLeftMessage();
	}
}

/** called when this player's team's score for Newb has been reduced such that no more respawning is possible */
reliable client final function ClientRespawnsDepleted()
{
	MyGearHud.StartDrawingDramaticText(RespawnsDepletedText, "", 5.0, 0.25, 2.0, MyGearHud.GetCountdownYPosition() + MyGearHud.CountdownSize.Y + NumPixelsToMoveDownForDramaText());
}

/**
 * Tells the client to iterate through its teammates skins and set the force
 * streaming status flag.
 *
 * @param Seconds	Number of seconds to force all mips to stream in
 */
reliable client function ClientPrestreamTeamSkins(optional float Seconds)
{
	// Pre-stream the textures for the startup weapons.
	class'GearWeap_Shotgun'.default.Mesh.PrestreamTextures( Seconds, true );
	class'GearWeap_AssaultRifle'.default.Mesh.PrestreamTextures( Seconds, true );
	class'GearWeap_LocustAssaultRifle'.default.Mesh.PrestreamTextures( Seconds, true );
	class'GearWeap_SmokeGrenade'.default.Mesh.PrestreamTextures( Seconds, true );
	class'GearWeap_COGPistol'.default.Mesh.PrestreamTextures( Seconds, true );
}

/**
 * Called when an arbitrated match has ended and we need to return to our party
 */
reliable client function ClientArbitratedMatchEnded()
{
	local OnlineGameSettings PartySettings;

	// Show the scoreboard which will go to the main menu when done
	MyGearHud.ToggleScoreboard(TRUE);

	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
	}
	if (PartySettings == None)
	{
		Super.ClientArbitratedMatchEnded();
	}
}

/**
 * Whether or not its ok to restart this player
 *   Overloaded here to never restart a team 255 player in MP
 */
function bool CanRestartPlayer()
{
	local GearPRI PRI;

	PRI = GearPRI(PlayerReplicationInfo);

	if (PRI == none)
	{
		return false;
	}

	return Super.CanRestartPlayer() && PRI.Team != None && PRI.Team.TeamIndex < 255 && PRI.PreferredCOGIndex != -1;
}

/** sends the player to the correct state from dead */
function TransitionFromDeadState()
{
	TransitionToSpectate(GearGRI_MP(WorldInfo.GRI).DefaultSpectatingState);
}

/** turns the player into a spectator and gives the AI control over his Pawn */
exec function MakeMeABot()
{
	ServerMakeMeABot();
}
reliable server function ServerMakeMeABot()
{
	local GearAI AI;
	local Pawn OldPawn;

	if (Pawn != None)
	{
		OldPawn = Pawn;
		UnPossess();
		AI = Spawn(class'GearAI_TDM');
		AI.Possess(OldPawn, false);
		GearPRI(AI.PlayerReplicationInfo).bIsLeader = GearPRI(PlayerReplicationInfo).bIsLeader;
		GearPRI(PlayerReplicationInfo).bIsLeader = false;

		if (PlayerReplicationInfo.Team != None)
		{
			PlayerReplicationInfo.Team.AddToTeam(AI);
			PlayerReplicationInfo.Team.RemoveFromTeam(self);
			PlayerReplicationInfo.Team = None;
			GearGameMP_Base(WorldInfo.Game).CreateTeamSquads(AI.GetTeamNum());
		}
		PlayerReplicationInfo.bOnlySpectator = true;
		TransitionToSpectate('PlayerSpectating');
		SetViewTarget(OldPawn);
	}
}

exec function NextViewTarget()
{
	local GearPawn WP;
	WP = GearPawn(ViewTarget);
	if (WP == None || WP.NextPawn == None)
	{
		SetViewTarget(WorldInfo.PawnList);
	}
	else
	{
		SetViewTarget(WP.NextPawn);
	}
	if (ViewTarget == MyGearPawn)
	{
		GotoState('PlayerWalking');
	}
	else
	{
		GotoState('PlayerSpectating');
	}
}

function RestoreShowSubtitles()
{
	// MP has no subtitles!
	SetShowSubtitles( FALSE );
}

/**
 * Sets the rich presence for training grounds if playing training grounds
 */
reliable client function ClientSetOnlineStatus()
{
	local GearGRI_MP GRI;

	GRI = GearGRI_MP(WorldInfo.GRI);
	if (GRI != None &&
		GRI.TrainingGroundsID > -1)
	{
		SetRichPresenceString(class'GearVersusGameSettings'.const.CONTEXT_PRESENCE_TRAININGGROUNDSPRESENCE);
	}
	Super.ClientSetOnlineStatus();
}

state Dead
{
	/**
	 * When dead, just turn off the overhead map
	 *
	 * @param PreviousStateName - the last state we were in
	 */
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		SetOverheadMapActive(false);
	}
}

/***********************************************************************************
 * BEGIN Spectating
 ***********************************************************************************/

 /**
 * GhostSpectating
 * Allows the player to walk around the world with only world collision to spectate.
 */
state GhostSpectating extends CustomSpectating
{
	function PickInitialViewTarget()
	{
		local ViewTargetTransitionParams TransParms;
		TransParms.BlendTime = bGhostSpectatingFromDeadState ? 0.f : 0.5f;
		ServerViewSelf(TransParms);
	}

	function PickNextViewTarget();
	function PickPrevViewTarget();

	event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
	{
		// bounce off of other players when moving
		if (GearPawn(Other) != None)
		{
			Velocity -= Normal(Other.Location - Location) * 2048.f;
		}
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(PlayerCamera.Rotation,X,Y,Z);
		Acceleration = PlayerInput.aForward*X + PlayerInput.aStrafe*Y + PlayerInput.aUp*vect(0,0,1);
		UpdateRotation(DeltaTime);

		if (Role < ROLE_Authority) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, Acceleration, DCLICK_None, rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime, Acceleration, DCLICK_None, rot(0,0,0));
		}
	}

	function BeginState(Name PreviousStateName)
	{
		local rotator CamRot;
		local vector CamLoc, TestLoc, BaseTestLoc, TestFwdOffset, TestRightOffset, Unused;
		local bool bFoundLoc;

		bGhostSpectatingFromDeadState = PreviousStateName == 'Dead';

		Super.BeginState(PreviousStateName);

		// try to place the ghost camera intelligently
		if (PreviousStateName == 'Dead' && IsLocalPlayerController())
		{
			// coming from dead state, put the ghost cam where the player died

			GetAxes(LastPawn.Rotation, TestFwdOffset, TestRightOffset, Unused);
			TestFwdOffset *= 300.f;
			TestRightOffset *= 300.f;

			// try behind the pawn
			BaseTestLoc = LastPawn.Location + vect(0,0,200);
			TestLoc = BaseTestLoc - TestFwdOffset;
			bFoundLoc = class'NavigationHandle'.static.ObstaclePointCheck(TestLoc, vect(25.f,25.f,25.f));
			if (!bFoundLoc)
			{
				// try right some
				TestLoc = BaseTestLoc + TestRightOffset;
				bFoundLoc = class'NavigationHandle'.static.ObstaclePointCheck(TestLoc, vect(25.f,25.f,25.f));
				if (!bFoundLoc)
				{
					// try left
					TestLoc = BaseTestLoc - TestRightOffset;
					bFoundLoc = class'NavigationHandle'.static.ObstaclePointCheck(TestLoc, vect(25.f,25.f,25.f));
					if (!bFoundLoc)
					{
						// try fwd
						TestLoc = BaseTestLoc + TestFwdOffset;
						bFoundLoc = class'NavigationHandle'.static.ObstaclePointCheck(TestLoc, vect(25.f,25.f,25.f));
					}
				}
			}

			if (bFoundLoc)
			{
				SetLocation(TestLoc);

				if (TestLoc == LastPawn.Location)
				{
					// starting at pawnloc, keep looking like we're looking
					CamRot = GearPlayerCamera(PlayerCamera).Rotation;
				}
				else
				{
					// look at midpoint of elevated testloc and pawn loc
					CamRot = rotator(((LastPawn.Location + BaseTestLoc) * 0.5f) - TestLoc);
				}
				SetRotation(CamRot);
				GhostSpectatingPitch = CamRot.Pitch;
			}
		}

		if (!bFoundLoc)
		{
			GetPlayerViewPoint(CamLoc, CamRot);
			SetLocation(CamLoc);
			SetRotation(CamRot);
		}

		SetCollision(true, false);
		SetCollisionSize(22.0, 35.0);
	}

	function EndState(Name NextStateName)
	{
		SetCollisionSize(22.0, 22.0);
		Super.EndState(NextStateName);
	}

	function PlayerTick( float DeltaTime )
	{
		Global.PlayerTick(DeltaTime);
	}

	function UpdateRotation(float DeltaTime)
	{
		local rotator NewRot;

		Global.UpdateRotation(DeltaTime);
		// make sure no roll sneaked in
		if (Rotation.Roll != 0)
		{
			NewRot = Rotation;
			NewRot.Roll = 0;
			SetRotation(NewRot);
		}
	}
}

simulated exec function ToggleOverheadMap()
{
	if (MyGearHud != None)
	{
		MyGearHud.bDrawOverheadMPMap = !MyGearHud.bDrawOverheadMPMap;
	}
}
simulated exec function SetOverheadMapActive(bool bActive)
{
	if (MyGearHud != None)
	{
		MyGearHud.bDrawOverheadMPMap = bActive;
	}
}

reliable client function ClientSetHUD(class<HUD> newHUDType)
{
	local bool bWasViewingOverheadMap;

	bWasViewingOverheadMap = (MyGearHud == None || (MyGearHud != None && MyGearHud.bDrawOverheadMPMap));
	Super.ClientSetHUD(newHUDType);
	if (bWasViewingOverheadMap)
	{
		SetOverheadMapActive(true);
		// switch to scoreboard after a short delay
		SetTimer(5.0, false, nameof(SetOverheadMapActive));
	}
}

function TransitionToSpectateFromEndOfRound()
{
	if (Pawn != None)
	{
		ServerUnPossess();
	}
	// everyone is forced to battle cam eor
	if (GetStateName() != 'CustomSpectating')
	{
		SetTimer(0.5, false, nameof(TransitionToSpectate));
	}
}

reliable server final function ServerUnPossess()
{
	if (Pawn != None)
	{
		UnPossess();
		GotoState('Dead');
	}
}

/**
 * Returns whether or not the SpectateType passed in is valid for this PC
 *
 * @param SpectateType	Name of the spectating type to check
 *
 * @return	Whether or not SpectateType is valid
 */
function bool IsValidSpectatingType(Name SpectateType)
{
	return ( Super.IsValidSpectatingType(SpectateType) || SpectateType == 'CustomSpectating' ||
			SpectateType == 'GhostSpectating' || SpectateType == 'MapSpectating' );
}

/***********************************************************************************
 * END Spectating
 ***********************************************************************************/

/***********************************************************************************
 * BEGIN BattleCam
 ***********************************************************************************/

auto state PlayerWaiting
{
	function PickInitialViewTarget()
	{
		ViewFirstSpectatorPoint();
	}

	function PickNextViewTarget()
	{
		ViewNextSpectatorPoint();
	}

	function PickPrevViewTarget()
	{
		ViewPrevSpectatorPoint();
	}

	simulated function BeginState(Name PreviousStateName)
	{
		super.BeginState( PreviousStateName );

		// look for the initial battle cam
		LocallySetInitialViewTarget();
	}

	simulated function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);

		bIsUsingStreamingVolumes = true;
	}

	reliable client function ClientSetHUD(class<HUD> newHUDType)
	{
		Global.ClientSetHUD(newHUDType);

		// if still spectating then pick a viewtarget
		ViewFirstSpectatorPoint();
		RefreshAllSafeZoneViewports();
	}

	function UpdateRotation(float DeltaTime)
	{
		local rotator DeltaRot, ViewRotation;
		local float MaxDeltaRot;
		local GearSpectatorPoint SpectatorPt;

		SpectatorPt = GearSpectatorPoint(GetViewTarget());
		if (SpectatorPt != None)
		{
			// Calculate Delta to be applied on ViewRotation
			DeltaRot.Yaw	= PlayerInput.aTurn;
			DeltaRot.Pitch	= PlayerInput.aLookUp;

			MaxDeltaRot = SpectatorPt.MaxRotationRate * DeltaTime;
			DeltaRot.Yaw = FClamp(DeltaRot.Yaw, -MaxDeltaRot, MaxDeltaRot);
			DeltaRot.Pitch = FClamp(DeltaRot.Pitch, -MaxDeltaRot, MaxDeltaRot);

			ViewRotation = Rotation;
			ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
			SetRotation( ViewRotation );
		}
		else
		{
			super.UpdateRotation(DeltaTime);
		}
	}

	function PlayerTick( float DeltaTime )
	{
		Global.PlayerTick(DeltaTime);

		if (BattleCamPath != None)
		{
			BattleCamPath.UpdateCameraPosition(DeltaTime);
		}
	}
}

function SetViewTarget( Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams  )
{
	local Actor BattleCamVT;

	// make sure we never switch to battle cam while alive
	if (Pawn == None || CameraActor(NewViewTarget) == None || IsSpectating())
	{
		// intercept transitions to the default camera
		if ( Role == ROLE_Authority && Pawn == None && (NewViewTarget == self || NewViewTarget == None) && !IsInState('GhostSpectating') &&
			GearPlayerInput_Screenshot(PlayerInput) == None )
		{
			// and replace with battle cam!
			BattleCamVT = LocallySetInitialViewTarget(TRUE);
			if (BattleCamVT != None)
			{
				`log(WorldInfo.TimeSeconds@self@getfuncname()@"Replacing"@`showvar(NewViewTarget)@"with"@`showvar(BattleCamVT));
				if (ViewTarget == BattleCamVT)
				{
					`log("- already viewtarget, ignored redundant call");
					return;
				}
				NewViewTarget = BattleCamVT;
			}
		}

		Super.SetViewTarget(NewViewTarget, TransitionParams);
	}
}

/**
 * Sets the viewtarget for the first battle camera found, called mid-transitions to keep the camera seamless (especially for clients).
 */
simulated function Actor LocallySetInitialViewTarget(optional bool bSkipSetViewTarget)
{
	local Sequence GameSequence;
	local int Idx;
	local array<SequenceObject> Objs;
	// locally look for a battle cam to view
	GameSequence = WorldInfo.GetGameSequence();
	GameSequence.FindSeqObjectsByClass(class'SeqAct_SpectatorCameraPath',TRUE,Objs);
	for (Idx = 0; Idx < Objs.Length; Idx++)
	{
		BattleCamPath = SeqAct_SpectatorCameraPath(Objs[Idx]);
		break;
	}
	if (BattleCamPath != None)
	{
		BattleCamPath.ResetToStartingPosition();
		if (!bSkipSetViewTarget)
		{
			ClientSetViewTarget(BattleCamPath.GetAssociatedCameraActor());
		}
		return BattleCamPath.GetAssociatedCameraActor();
	}
	return None;
}

event NotifyLoadedWorld(name WorldPackageName, bool bFinalDest)
{
	local GearPC PC;
	local LocalPlayer LP;

	// clear out any input locks we managed to carry through the level change
	bIgnoreMoveInput = 0;
	bIgnoreLookInput = 0;
	InputIsDisabledCount = 0;
	bCinematicMode = false;
	bInvisible = false;

	// clear loaded characters; server will send new list
	if (CharacterStore != None)
	{
		CharacterStore.LoadedClasses.length = 0;
		CharacterStore.PendingClasses.length = 0;
	}

	// look for the initial battle cam
	LocallySetInitialViewTarget();

	// if we didn't find a view target then default to normal behavior
	if (ViewTarget == None)
	{
		Super.NotifyLoadedWorld(WorldPackageName,bFinalDest);
	}
	else
	{
		SetLocation(ViewTarget.Location);
		SetRotation(ViewTarget.Rotation);
	}

	// Blur the background
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		LP = LocalPlayer(PC.Player);
		LP.OverridePostProcessSettings(PC.PausePPSettings);
	}

	SetTimer(8.0, false, nameof(ClearBlurPP));

	// Show the overhead map until the server recreates your hud
	//@note: if we're coming from the menus, this does nothing, but GearMenuHUD will draw it anyway
	SetOverheadMapActive(true);

	if (bFinalDest)
	{
		CheckForNewbHelp();
	}
}

event PlayerTick(float DeltaTime)
{
	local GearGRI GRI;
	local GearTeamPlayerStart P;
	local bool bFoundTeam0, bFoundTeam1;
	local Engine TheEngine;

	Super.PlayerTick(DeltaTime);

	// prestream likely spawn points
	GRI = GearGRI(WorldInfo.GRI);
	if (GRI == None || GRI.GameStatus == GS_WaitingForHost || GRI.GameStatus == GS_PreMatch)
	{
		TheEngine = class'Engine'.static.GetEngine();
		foreach WorldInfo.AllNavigationPoints(class'GearTeamPlayerStart', P)
		{
			if (P.TeamIndex == 0)
			{
				if (!bFoundTeam0)
				{
					TheEngine.AddTextureStreamingSlaveLoc(P.Location);
					bFoundTeam0 = true;
					if (bFoundTeam0 && bFoundTeam1)
					{
						break;
					}
				}
			}
			else if (P.TeamIndex == 1)
			{
				if (!bFoundTeam1)
				{
					TheEngine.AddTextureStreamingSlaveLoc(P.Location);
					bFoundTeam1 = true;
					if (bFoundTeam0 && bFoundTeam1)
					{
						break;
					}
				}
			}
		}
	}
}

/** player wants to buy their way back into the game (if allowed) */
reliable server final function ServerBuyRespawn()
{
	if (GearGameHorde_Base(WorldInfo.Game) != None)
	{
		GearGameHorde_Base(WorldInfo.Game).BuyRespawn(self);
	}
}

simulated function ViewFirstSpectatorPoint()
{
	// looking for first point, so reset to beginning
	if (BattleCamPath != None)
	{
		BattleCamPath.ResetToStartingPosition();
	}

	ServerViewFirstSpectatorPoint();
}

unreliable server function ServerViewFirstSpectatorPoint()
{
	local CameraActor SpectatorPathCamera;
	// if it's coop then only allow them to view players
	if ( IsSpectating() && !IsActuallyPlayingCoop() )
	{
		if (BattleCamPath != None)
		{
			// attach to the camera path actor
			SpectatorPathCamera = BattleCamPath.GetAssociatedCameraActor();
			// set view target to the camera actor connected
			SetViewTarget(SpectatorPathCamera);
			ClientSetViewTarget(SpectatorPathCamera);
		}
		else
		{
			CurrSpectatorPoint = GearGame(WorldInfo.Game).GetFirstSpectatorPoint();
			if ( CurrSpectatorPoint != None )
			{
				SetViewTarget( CurrSpectatorPoint );
				ClientSetViewTarget( CurrSpectatorPoint );
			}
			else
			{
				// otherwise send them to a player
				ServerViewNextPlayer();
			}
		}
	}
}

simulated function ViewNextSpectatorPoint()
{
	if ( IsSpectating() && !IsActuallyPlayingCoop() )
	{
		if (BattleCamPath != None)
		{
			if (CameraActor(ViewTarget) == None)
			{
				ServerViewFirstSpectatorPoint();
			}
			else
			{
				// we handle spectator camera paths client-side, since we're not changing viewtargets.
				if (BattleCamPath.bPaused || !BattleCamPath.bIsPlaying)
				{
					PlaySound(SoundCue'Music_Stingers.CameraZoom.CameraZoomA_Cue', TRUE);
				}
				BattleCamPath.MoveToNextStop();
			}
		}
		else
		{
			ServerViewNextSpectatorPoint();
		}
	}
}

unreliable server function ServerViewNextSpectatorPoint()
{
	if ( IsSpectating() && !IsActuallyPlayingCoop() )
	{
		if ( (CurrSpectatorPoint == None) || (CurrSpectatorPoint == GetViewTarget()) )
		{
			CurrSpectatorPoint = GearGame(WorldInfo.Game).GetNextSpectatorPoint( CurrSpectatorPoint );
		}

		if ( CurrSpectatorPoint != None )
		{
			SetViewTarget( CurrSpectatorPoint );
			ClientSetViewTarget( CurrSpectatorPoint );
		}
		else
		{
			// otherwise send them to a player
			ServerViewNextPlayer();
		}
	}
}

simulated function ViewPrevSpectatorPoint()
{
//	`log("***"@GetFuncName()@IsSpectating()@!IsCoop()@WorldInfo.GRI@GearGRI(WorldInfo.GRI).CurrentLevelSpectatorCameraPath);

	if ( IsSpectating() && !IsActuallyPlayingCoop() )
	{
		if (BattleCamPath != None)
		{
			// we handle spectator camera paths client-side, since we're not changing viewtargets.
			if (BattleCamPath.bPaused || !BattleCamPath.bIsPlaying)
			{
				PlaySound(SoundCue'Music_Stingers.CameraZoom.CameraZoomA_Cue', TRUE);
			}
			BattleCamPath.MoveToPrevStop();
		}
		else
		{
			ServerViewPrevSpectatorPoint();
		}
	}
}

unreliable server function ServerViewPrevSpectatorPoint()
{
	if ( IsSpectating() && !IsActuallyPlayingCoop() )
	{
		if ( (CurrSpectatorPoint == None) || (CurrSpectatorPoint == GetViewTarget()) )
			CurrSpectatorPoint = GearGame(WorldInfo.Game).GetPrevSpectatorPoint( CurrSpectatorPoint );
		if ( CurrSpectatorPoint != None )
		{
			SetViewTarget( CurrSpectatorPoint );
			ClientSetViewTarget( CurrSpectatorPoint );
		}
		else
		{
			// otherwise send them to a player
			ServerViewNextPlayer();
		}
	}
}

/*
 *	CleanupPRI - called at the end of Controller::Destroyed
 *	overridden here to check for necessary dedicated server restart after last player left in ranked matches
 */
function CleanupPRI()
{
	Super.CleanupPRI();

	// Ranked matches don't have beacons to update reservations, so restart if this is the last player logging out
	if (WorldInfo.NetMode == NM_DedicatedServer && WorldInfo.Game != None && WorldInfo.Game.bUsingArbitration)
	{
		if (WorldInfo.Game.NumPlayers == 0)
		{
			GearGameMP_Base(WorldInfo.Game).DedicatedServerRestart();
		}
	}
}


function Restart(bool bVehicleTransition)
{
	Super.Restart(bVehicleTransition);

	if (MyGearPawn != None)
	{
		if (!bVehicleTransition && GearPRI(PlayerReplicationInfo).bIsLeader)
		{
			DoLeaderShout();
		}
	}
}

// Function called to allow the leader to select to start moving
simulated function ReadyLeader()
{
	if(LeaderTutorial != None)
	{
		LeaderTutorial.ReadyButton();
	}
}

/***********************************************************************************
 * END BattleCam
 ***********************************************************************************/

/**
 * Logs out the information for MGS play testing to gather data. Does this natively to
 * bypass final release compiling out the `Log statements
 *
 * @param HostMode the netmode of the host (to be able to see dedicated server or not)
 * @param bIsStartOrEnd whether this the beginning of a round/match or end of a round/match
 * @param MatchType the type of match being played (ranked, social, system link, etc.)
 */
native reliable client function ClientLogMPTestAutomationData(ENetMode HostNetMode,bool bIsStartOrEnd,EGearVersusMatchType MatchType);

/**
 * Called by the server to authoritatively tell the client that he has earned an award
 * added as a catchall for MCP stats recording
 * @param AwardName - The name of the award. Should be consistent across all players
 */
function NotifyEarnedAward(name AwardName)
{
	// Don't let players spectating or otherwise not on a team earn an award
	// Don't let players who just joined earn awards either
	if (PlayerReplicationInfo != None && PlayerReplicationInfo.Team != None && PlayerReplicationInfo.Team.TeamIndex != 255)
	{
		Super.NotifyEarnedAward(AwardName);
	}
}

/**
 * Is called when someone joins/leaves the player's party chat session
 *
 * @param bJoinedOrLeft true if the player joined, false if they left
 * @param PlayerName the name of the player that was affected
 * @param PlayerId the net id of the player that left
 */
function OnPartyMemberListChanged(bool bJoinedOrLeft,string PlayerName,UniqueNetId PlayerId)
{
	if (bJoinedOrLeft)
	{
		`Log(PlayerName$" has joined your party");
	}
	else
	{
		`Log(PlayerName$" has left your party");
	}
}

/**
 * Is called when someone in your party chat has their custom data change (game controlled)
 *
 * @param PlayerName the name of the player that was affected
 * @param PlayerId the net id of the player that had data change
 * @param CustomData1 the first 4 bytes of the custom data
 * @param CustomData2 the second 4 bytes of the custom data
 * @param CustomData3 the third 4 bytes of the custom data
 * @param CustomData4 the fourth 4 bytes of the custom data
 */
function OnPartyMembersInfoChanged(string PlayerName,UniqueNetId PlayerId,int CustomData1,int CustomData2,int CustomData3,int CustomData4)
{
return;
	switch (CustomData1)
	{
		case PNT_Achievement:
			ShowPartyMemberAchievementInfo(PlayerName,CustomData2);
			break;
		case PNT_Award:
			ShowPartyMemberAwardInfo(PlayerName,CustomData2,CustomData3);
			break;
		case PNT_LevelChange:
			ShowPartyMemberLevelInfo(PlayerName,CustomData2);
			break;
		default:
			`Log(PlayerName$" had unknown event "$CustomData1$" sent to party members");
			break;
	}
}

/**
 * Updates other members of your Xbox Live Party with your newly earned award
 *
 * @param Award the award you just earned
 */
function UpdatePartyWithAwardInfo(GearAward Award)
{
	local int AwardCount;
	local LocalPlayer LP;

	LP = LocalPlayer(Player);

	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PartyChatInterface != None)
	{
		// Get this player's count of how many times earned
		AwardCount = AwardManager.GetAwardEarnedCountByName(Award.AwardName);
		// Notify other party members of this information
		OnlineSub.PartyChatInterface.SetPartyMemberCustomData(LP.ControllerId,PNT_Award,Award.PersistentDataID,AwardCount,0);
	}
}

/**
 * When a client unlocks an achievement, send this information to other party members for bragging rights
 *
 * @param Achievement the achievement they just unlocked
 */
reliable client function ClientUnlockAchievement(EGearAchievement Achievement)
{
	local LocalPlayer LP;

	LP = LocalPlayer(Player);

	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PartyChatInterface != None)
	{
		// Notify other party members of the achievement
		OnlineSub.PartyChatInterface.SetPartyMemberCustomData(LP.ControllerId,PNT_Achievement,Achievement,0,0);
	}

	Super.ClientUnlockAchievement(Achievement);
}

/**
 * Displays the party member that just unlocked the achievement and whether you have unlocked it
 *
 * @param PlayerName the name of the player in your party that earned the achievement
 * @param AchievementId the achievement they just earned
 */
function ShowPartyMemberAchievementInfo(string PlayerName,int AchievementId)
{
}

/**
 * Displays that the party member that just earned an award and where you stand compared to them
 *
 * @param PlayerName the name of the player in your party that earned an award
 * @param AwardId the award they just earned
 * @param TimesEarned the number of times they've earned the award
 */
function ShowPartyMemberAwardInfo(string PlayerName,int AwardId,int TimesEarned)
{
	local int AwardCount;
	local GearAward Award;
	local GearAlertManager AlertManager;

	AlertManager = GetAlertManager();

// @todo joeg -- loc me

	if (AlertManager != None)
	{
		// Look up the award
		Award = AwardManager.FindAwardByPersistentDataID(AwardId);
		if (Award != None)
		{
			// Get this player's count of how many times earned
			AwardCount = AwardManager.GetAwardEarnedCountByName(Award.AwardName);
			// Show a relative count
			AlertManager.Alert(eALERT_Leaderboard,
				PlayerName$" just earned "$ Award.GetNameString(Award.AwardName),
				"You",
				PlayerName,
				AwardCount,
				TimesEarned,
				GEARAWARDPROGREP_Integer,
				Award.IconPath,
				Award.MedalRank);
		}
	}
}

/**
 * Displays that the party member just leveled up and where you compare level wise
 *
 * @param PlayerName the name of the player in your party that leveled up
 * @param NewLevel the new level they acquired
 */
function ShowPartyMemberLevelInfo(string PlayerName,int NewLevel)
{
	local int PlayerLevel;
	local GearAlertManager AlertManager;

	AlertManager = GetAlertManager();

// @todo joeg -- loc me

	if (AlertManager != None)
	{
		PlayerLevel = StatManager.GetStatValueByName('Level');
		// Show a relative count
		AlertManager.Alert(eALERT_Leaderboard,
			PlayerName$" was promoted to level "$NewLevel,
			"You",
			PlayerName,
			PlayerLevel,
			NewLevel,
			GEARAWARDPROGREP_Integer,
			"");
	}
}

/**
 * Get the list of registered players in a session
 *
 * @param SessionName name of session to get players from
 * @param OutRegisteredPlayers array of players in the session
 */
function GetRegisteredPlayersInSession(name SessionName, out array<UniqueNetId> OutRegisteredPlayers)
{
	if (OnlineSubsystemCommonImpl(OnlineSub) != None)
	{
		OnlineSubsystemCommonImpl(OnlineSub).GetRegisteredPlayers(SessionName,OutRegisteredPlayers);
	}
}

/**
 * @return Current game search class in use
 */
function class<OnlineGameSearch> GetCurrentSearchClass()
{
	local int MatchModeIdx;

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		if (ProfileSettings != None &&
			ProfileSettings.GetProfileSettingValueId(`VERSUS_MATCH_MODE, MatchModeIdx))
		{
			switch (MatchModeIdx)
			{
			case eGVMT_Player:
				return class'GearPlayerVersusGameSearch';
				break;
			case eGVMT_Official:
			default:
				return class'GearVersusGameSearchRanked';
			}
		}
	}
	return class'GearVersusGameSearch';
}

/**
 * This peer player has been selected as the new host.
 * Notify all other clients that have also lost their server connection to begin traveling to the newly migrated session.
 * Begin traveling as the new host.
 *
 * @param SessionName Name of the session that was migrated. Can be 'None' if migrating without a session
 */
function PeerDesignatedAsHost(name SessionName)
{
	// Copy GRI/PRI data to named interface object for rebuilding player data when match reloads
	PerformGameHostMigration();
	// This will initiate the travel as new host and also notify clients via peer net drive RPC
	Super.PeerDesignatedAsHost(SessionName);
}

/**
 * Notification that a PRI is about to be destroyed
 *
 * @param PRI player replication info about to be destroyed
 */
function NotifyPreDestroyPRI(PlayerReplicationInfo PRI)
{
	if (WorldInfo.NetMode == NM_Client &&
		WorldInfo.bAllowHostMigration &&
		IsPrimaryPlayer())
	{
		if (GameHostMigrationManager == None)
		{
			GameHostMigrationManager = new class'GearGameHostMigrationManager';
		}
		GameHostMigrationManager.AddPlayerData(GearPRI(PRI));
	}
}

/**
 * Used to trigger the harvesting of data for host migration. Note this assumes
 * that the online portion was already done under the covers. This only migrates
 * the game state needed to start the game near to where it left off
 */
event PerformGameHostMigration()
{
	local int PriIndex,PeerIdx,PartyIdx;
	local array<CurrentPlayerMet> Players;
	local CurrentPlayerMet CurrentPlayer;
	local GearRecentPlayer GearCurrentPlayer;
	local GearRecentPlayersList RecentPlayersList;

	if (OnlineSub != None)
	{
		// Create the object that will persist across map loads
		if (GameHostMigrationManager == None)
		{
			GameHostMigrationManager = new class'GearGameHostMigrationManager';
		}
		OnlineSub.SetNamedInterface('GameHostMigrationManager',GameHostMigrationManager);

		`Log(`location @ ": copying game data for host migration...");

		// Store off the game information
		GameHostMigrationManager.AddGameData(GearGRI(WorldInfo.GRI));
		// Add all of the player information
		for (PriIndex = 0; PriIndex < WorldInfo.GRI.PRIArray.Length; PriIndex++)
		{
			if (!WorldInfo.GRI.PRIArray[PriIndex].bBot)
			{
				GameHostMigrationManager.AddPlayerData(GearPRI(WorldInfo.GRI.PRIArray[PriIndex]));
			}
		}

		// Also update recent players list since host waits for them during pending match
		// The gear recent players list is also used to setup the beacons after travel
		RecentPlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
		if (RecentPlayersList != None)
		{
			RecentPlayersList.ClearAllGearParties();

			for (PriIndex=0; PriIndex < GameHostMigrationManager.Players.Length; PriIndex++)
			{
				PeerIdx = FindConnectedPeerIndex(GameHostMigrationManager.Players[PriIndex].UniqueId);
				if (GameHostMigrationManager.Players[PriIndex].UniqueId == PlayerReplicationInfo.UniqueId ||
					(PeerIdx != INDEX_NONE && ConnectedPeers[PeerIdx].bLostConnectionToHost))
				{
					CurrentPlayer.NetId = GameHostMigrationManager.Players[PriIndex].UniqueId;
					CurrentPlayer.Skill = GameHostMigrationManager.Players[PriIndex].PlayerSkill;
					CurrentPlayer.TeamNum = GameHostMigrationManager.Players[PriIndex].TeamId;
					Players.AddItem(CurrentPlayer);

					GearCurrentPlayer = CurrentPlayer;
					GearCurrentPlayer.Level = GameHostMigrationManager.Players[PriIndex].PlayerLevel;
					RecentPlayersList.AddLastGearPartyPlayer(GameHostMigrationManager.Players[PriIndex].PartyOwnerUniqueId,GearCurrentPlayer);

					`Log(`location @ ": adding recent player entry "
						$" netid="$class'OnlineSubsystem'.static.UniqueNetIdToString(GearCurrentPlayer.NetId)
						$" team="$GearCurrentPlayer.TeamNum
						$" skill="$GearCurrentPlayer.Skill
						$" level="$GearCurrentPlayer.Level);
				}
			}
			RecentPlayersList.SetCurrentPlayersList(Players);

			// fixup gear parties with lost party leaders
			for (PartyIdx=0; PartyIdx < RecentPlayersList.LastGearParties.Length; PartyIdx++)
			{
				// no peer connection means that the party leader is lost
				if (RecentPlayersList.LastGearParties[PartyIdx].PartyLeader != PlayerReplicationInfo.UniqueId &&
					FindConnectedPeerIndex(RecentPlayersList.LastGearParties[PartyIdx].PartyLeader) == INDEX_NONE)
				{
					// promote another peer to be the party leader
					if (RecentPlayersList.LastGearParties[PartyIdx].PartyMembers.Length > 0)
					{
						RecentPlayersList.LastGearParties[PartyIdx].PartyLeader = RecentPlayersList.LastGearParties[PartyIdx].PartyMembers[0].NetId;
					}
				}
			}
		}
	}
}

/**
 * Tells the server the number of disconnects this player has
 *
 * @param CurrentDisconnectCount number of disconnects this player has prior to the match
 */
reliable server function ServerSetDisconnectCount(int CurrentDisconnectCount)
{
	local GearMPPRI PRI;

	PRI = GearMPPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		PRI.DisconnectCount = CurrentDisconnectCount;
	}
}

/**
 * Adjusts the client's disconnect count up or down depending on completing a match or not
 *
 * @param Adjustment the amount to change the quit count by
 * @param bRespond whether to report back the disconnect count to the server
 */
reliable client function ClientAdjustDisconnectCount(int Adjustment, bool bRespond=false)
{
	local int DisconnectCount;

	if (ProfileSettings != None)
	{
		// Report the current disconnect count (it will get incremented in WriteStatsForDroppedPlayer)
		DisconnectCount = ProfileSettings.GetDisconnectCount();
		// Save the newly incremented count for reporting next time if a player drops in social
		ProfileSettings.AdjustDisconnectCount(Adjustment);
	}

	if (bRespond && DisconnectCount > 0)
	{
	   ServerSetDisconnectCount(DisconnectCount);
	}
}

/**
 * Tells the server the number of consecutive matches played for match bonuses
 *
 * @param ConsecutiveMatches the number of matches in a row they've played
 */
reliable server function ServerSetConsecutiveMatchesPlayed(int ConsecutiveMatches)
{
	ConsecutiveMatchesPlayed = ConsecutiveMatches;
}

/**
 * Tells the client to update their consecutive match played value
 */
reliable client function ClientUpdateConsecutiveMatchesPlayed()
{
	if (ProfileSettings != None)
	{
		ServerSetConsecutiveMatchesPlayed(ProfileSettings.ConsecutiveMatchesPlayed);
	}
}

/**
 * Tells the client to increment their consecutive match played value
 */
reliable client function ClientIncrementConsecutiveMatchesPlayed()
{
	if (ProfileSettings != None)
	{
		ProfileSettings.ConsecutiveMatchesPlayed++;
	}
}

/** called when playing Training Grounds and the server toggles the active state of the bots */
reliable client final function ClientTGBotsActive(bool bNowActive)
{
	local int Index;

	if (MyGearHud.AddHUDMessage(None, None, Index))
	{
		MyGearHud.PriorityHUDMessages[Index].TimeRemaining = MyGearHud.DeathDataTime;
		MyGearHud.PriorityHUDMessages[Index].bUseMessageText = true;
		MyGearHud.PriorityHUDMessages[Index].MessageText = bNowActive ? BotsEnabledMessage : BotsDisabledMessage;
		MyGearHud.PriorityHUDMessages[Index].bAlwaysShow = true;
	}
	else
	{
		MyGearHud.HUDMessages[Index].TimeRemaining = MyGearHud.DeathDataTime;
		MyGearHud.HUDMessages[Index].bUseMessageText = true;
		MyGearHud.HUDMessages[Index].MessageText = bNowActive ? BotsEnabledMessage : BotsDisabledMessage;
		MyGearHud.HUDMessages[Index].bAlwaysShow = true;
	}
}

/**
 * Checks for a host tampering with the session and marks it as such
 *
 * @param bIsConnected the new connection state
 */
function OnLinkStatusChange(bool bIsConnected)
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	if (!bIsConnected &&
		// Ignore this for local matches (matches without a party session)
		OnlineSub.GameInterface.GetGameSettings('Party') != None)
	{
		// Check for host tampering and deny them the win
		if (WorldInfo.NetMode == NM_ListenServer)
		{
			GearGame(WorldInfo.Game).SetHostTamperedWithMatch();
			// Mark the server as having a problem
			WorldInfo.Game.bHasNetworkError = true;
			// Force off the scoreboard
			MyGearHud.ToggleScoreboard(FALSE);
			MyGearHud.bRestrictScoreboard = true;
		}
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		// Show the user why we kicked them back
		if (UIManager != None)
		{
			ButtonAliases.AddItem('GenericAccept');
			UIManager.ShowUIMessage('ConnectionError',
				Localize("MessageBoxErrorStrings","LostLink_Title","GearGameUI"),
				Localize("MessageBoxErrorStrings","LostLink_Message","GearGameUI"),
				ButtonAliases,
				None,
				LocalPlayer(Player),,,,,false);
		}
		ReturnToMainMenu(true);
	}
}

/**
 * Delegate called when a player's status changes but doesn't change profiles
 *
 * @param NewStatus the new login status for the user
 * @param NewId the new id to associate with the user
 */
function OnLoginStatusChange(ELoginStatus NewStatus,UniqueNetId NewId)
{
	local OnlineGameSettings PartySettings;

	Super.OnLoginStatusChange(NewStatus,NewId);

	// You can stay in the match if you are in system link since it doesn't write leaderboards
	PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
	if (PartySettings != None &&
		NewStatus < LS_LoggedIn &&
		!PartySettings.bIsLanMatch)
	{
		ReturnToMainMenu(true);
	}
}

/**
 * Login changes mean we must go back to the main menu
 *
 * @param LocalUserNum the user that just logged in
 */
function OnLoginChange(byte LocalUserNum)
{
	local UniqueNetId NetId;

	NetId = PlayerReplicationInfo.UniqueId;
	Super.OnLoginChange(LocalUserNum);
	// If we swapped profiles, throw away the saved state
	if (NetId != PlayerReplicationInfo.UniqueId &&
		!WorldInfo.IsMenuLevel())
	{
		ProfileSettings = None;
		PersistentData = None;
		StatManager = None;
	}
	ReturnToMainMenu(true);
}

reliable server final function ServerRequestNewbHelp(bool bNeedsHelp)
{
	bRequestedNewbHelp = bNeedsHelp;
}

/** reads stats and asks the server for gameplay help if we are a newb */
final function CheckForNewbHelp()
{
	local int ControllerId;

	ControllerId = LocalPlayer(Player).ControllerId;

	if (StatManager.GetStatValueByName('KillsMP') <= 10 &&
		// Skip this for anyone that has played MP on Gears2 long enough
		!ProfileSettings.HasRookieGear() &&
		OnlineSub != None &&
		OnlineSub.PlayerInterface != None &&
		OnlineSub.PlayerInterface.GetLoginStatus(ControllerId) == LS_LoggedIn &&
		// Guests won't have achievements so don't let them be eligible
		!OnlineSub.PlayerInterface.IsGuestLogin(ControllerId))
	{
		ServerRequestNewbHelp(true);
	}
	else
	{
		ServerRequestNewbHelp(false);
	}
}

function OnPersistentDataReadComplete(byte LocalUserNum, bool bWasSuccessful)
{
	Super.OnPersistentDataReadComplete(LocalUserNum, bWasSuccessful);

	if (bWasSuccessful)
	{
		CheckForNewbHelp();
	}
}

/** @FIXME: temp debug code */
reliable client function ClientGotoState(name NewState, optional name NewLabel)
{
	if (NewState == 'PlayerWalking')
	{
		`Log("Server sent PlayerWalking while in" @ GetStateName() @ "- Pawn:" @ Pawn);
	}
	Super.ClientGotoState(NewState, NewLabel);
}

defaultproperties
{
	SuddenDeathSound=SoundCue'Music_Stingers.stinger_instantdeath01cue'
	bShowDebugMP = false

	DefaultSpectateType=CustomSpectating

	bUseBattleCamAutoFraming=true
}
