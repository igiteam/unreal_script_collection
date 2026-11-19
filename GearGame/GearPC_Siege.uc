/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPC_Siege extends GearHordePC
	native(PC);

`include(GearLeaderboardConstants.uci)

//Scaleform Char Select Screen
//Name of the movie class
var const string CharSelectMovieClassName;

//The char select movie
var UIScene_SiegeCharSelect CharSelectMovie;

//The last character selected
var byte LastCharSelected;

/**
 * If the player beats their high score that high score and wave is written
 *
 * @param OnlineStatsWriteClass the stats class to write with
 * @param bIsIncomplete TRUE if the match wasn't finished at the time of the write
 */
reliable client function ClientWriteLeaderboardStats(class<OnlineStatsWrite> OnlineStatsWriteClass, optional bool bIsIncomplete=false)
{
	local GearPRI_Siege SiegePRI;
	local GearTeamInfo GearTeam;

	SiegePRI = GearPRI_Siege(PlayerReplicationInfo);
	GearTeam = GearTeamInfo(PlayerReplicationInfo.Team);
	// Always write scores (backend handles high score)
	if (SiegePRI != None &&
		GearTeam != None &&
		// Players who just joined get no score this round
		SiegePRI.ScoreAtJoinTime > -1)
	{
		Super(GearPC_MP).ClientWriteLeaderboardStats(OnlineStatsWriteClass);
	}
}

/**
 * Called whenever StartNextWave() is called to update the rich presence
 *
 * @param Wave the wave that we are in
 */
reliable client function ClientSetSiegePresence(int Wave)
{
	local LocalPlayer LP;
	local array<LocalizedStringSetting> StringSettings;
	local array<SettingsProperty> Properties;
	local SettingsProperty Prop;

	LP = LocalPlayer(Player);
	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		StringSettings.Length = 1;
		// Set the map name for rich presence
		StringSettings[0].AdvertisementType = ODAT_OnlineService;
		StringSettings[0].Id = class'GearGame'.const.CONTEXT_MAPNAME;
		StringSettings[0].ValueIndex = class'GearLeaderboardSettings'.static.GetMapIdFromName(name(WorldInfo.GetMapName(true)));
		// Add the wave as a property
		Prop.PropertyId = `PROPERTY_WAVE;
		Prop.AdvertisementType = ODAT_OnlineService;
		class'Settings'.static.SetSettingsDataInt(Prop.Data,Wave);
		Properties.AddItem(Prop);

		OnlineSub.PlayerInterface.SetOnlineStatus(LP.ControllerId, class'GearGame'.const.CONTEXT_PRESENCE_SIEGEPRESENCE, StringSettings, Properties);
	}
}

/** Setup the carrot ladder for arcade now that we have friends */
simulated function OnReadFriendsComplete(bool bWasSuccessful)
{
	local LocalPlayer LP;
	LP = LocalPlayer(Player);
	if (LP != None && bWasSuccessful)
	{
		StatManager.SetupCarrotLadder("GearGame.GearCarrotLadder_Siege");
	}

	OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(LP.ControllerId,OnReadFriendsComplete);
}

reliable client function ClientRestart(Pawn NewPawn)
{
	local name StatName;
	local GearPawn GP;

	Super.ClientRestart(NewPawn);

	// close UI if it's still open
	if (NewPawn != None)
	{
		if (CharSelectMovie != none)
		{
			CharSelectMovie.Close();
			CharSelectMovie = none;
		}
	}

	if (TutorialMgr != None)
	{
		GP = GearPawn(NewPawn);
		if (GP != None)
		{
			TutorialMgr.StartTutorial(GearPawn(NewPawn).SiegeTutorialType);
		}
		// bit of a hack for the Reaver special case, not worth generalizing at the moment
		else if (Vehicle_Reaver_Base(NewPawn) != None)
		{
			TutorialMgr.StartTutorial(GEARTUT_SIEGE_Reaver);
		}
	}

	// Record the spawn
	if (class'GearLeaderboardWriteSiege'.static.GetPlayerStatNameFromClassName(NewPawn.Class.Name, StatName))
	{
		ModifyStat(name(StatName $ "Spawns"));
	}
}

reliable client final function ClientOpenClassSelector()
{
	local class<UIScene_SiegeCharSelect> CharSelectClass;
	local GearGRI_Horde GRI;

	//Don't show char select if we are done!
	GRI = GearGRI_Horde(WorldInfo.GRI);
	if(GRI != None &&
		GRI.InvasionCurrentWaveIndex == GRI.InvasionNumTotalWaves &&
		GRI.GameStatus >= GS_EndMatch)
	{
		return;
	}

	if (IsDead() || IsSpectating())
	{
		//@hack: wait for EOR scene to close to avoid conflicts in the UI system
		if (GearHUDMP_Base(MyGearHud).EndOfRoundSceneIsOpen())
		{
			SetTimer(1.0, false, nameof(ClientOpenClassSelector));
		}
		else
		{
			if (CharSelectMovie == None)
			{
				//If we don't have the GRI and gameclass
				if (WorldInfo.GRI == None || class<GearGameSiege_Base>(WorldInfo.GRI.GameClass) == None)
				{
					SetTimer(0.1,false,nameof(ClientOpenClassSelector));
				}
				else
				{
					CharSelectClass = class<UIScene_SiegeCharSelect>(DynamicLoadObject(CharSelectMovieClassName, class'Class'));
					if (CharSelectClass != None && GearPRI_Siege(PlayerReplicationInfo).WavePointsRemaining > 0)
					{
						CharSelectMovie = new(self) CharSelectClass;
						CharSelectMovie.SiegeGameClass = class<GearGameSiege_Base>(WorldInfo.GRI.GameClass);
						CharSelectMovie.Init(LocalPlayer(self.Player));
					}
				}
			}
			else if (CharSelectMovie.bCharacterSelected)
			{
				// wait for old instance to close
				SetTimer(0.1, false, nameof(ClientOpenClassSelector));
			}
			else
			{
				//You just want to refresh the points
				CharSelectMovie.UpdateNumPoints();
			}

		}
	}
}

reliable server final function ServerChooseClass(int Index)
{
	// if the game rejected the choice for any reason, tell the client to put the UI back up
	// since it closes when a choice is made
	if ( Pawn == None && (IsDead() || IsSpectating()) && GearGRI(WorldInfo.GRI).RoundTime > 1 &&
		!GearGameSiege_Base(WorldInfo.Game).SpawnPlayer(self, Index) )
	{
		if (LocalPlayer(Player) == None)
		{
			ClientOpenClassSelector();
		}
		else
		{
			// time delay so current UI has a chance to close
			SetTimer(0.01, false, nameof(ClientOpenClassSelector));
		}
	}
}

state Dead
{
	event EndState(name NextStateName)
	{
		Super.EndState(NextStateName);

		if (Role == ROLE_Authority && !bPendingDelete && GearPRI_Siege(PlayerReplicationInfo).WavePointsRemaining > 0)
		{
			ClientOpenClassSelector();
		}
	}
}

/** Plays some attack audio when the player clicks the stick */
unreliable server function ServerPlayAttackYell()
{
	if (WorldInfo.Game != None && MyGearPawn != None)
	{
		MyGearPawn.PlayAttackYell();
	}
}

//Notification that the wave has changed
simulated function WaveChanged(int NewWave)
{
	local GearPRI_Siege SiegePRI;

	super.WaveChanged(NewWave);

	if (CharSelectMovie != None)
	{
		CharSelectMovie.UpdateWave(NewWave);
	}
	else
	{
		ClientOpenClassSelector();
	}

	SiegePRI = GearPRI_Siege(PlayerReplicationInfo);
	if (SiegePRI != None)
	{
		SiegePRI.WavePointsEarnedThisRoundLast = 0;
		SiegePRI.WavePointsSpentThisRoundLast = 0;
	}
}

//Notification that the enemy count has changed
simulated function EnemyCountChanged(int NewEnemyCount)
{
	super.EnemyCountChanged(NewEnemyCount);

	if (CharSelectMovie != None)
	{
		CharSelectMovie.UpdateEnemyCount(NewEnemyCount);
	}
}

/**
 * We have a custom sound mode for siege
 *
 * @return the name of the sound mode to use
 */
simulated function Name FindBestSoundMode()
{
	local GearGRI GRI;
	local bool bOkToDoGameStateModes;

	GRI = GearGRI(WorldInfo.GRI);

	bOkToDoGameStateModes = (!IsSplitscreenPlayer() && ((GRI == None) || GRI.GameStatus == GS_RoundInProgress));

	// priority order
	// only do these if we're not in split screen and in SP or while an MP game is in progress
	if (bOkToDoGameStateModes)
	{
		if ( (MyGearPawn != None) && MyGearPawn.IsDBNO() )
		{
			return 'DBNO';
		}

		if (IsDead() && !IsSpectating())
		{
			return 'Death';
		}
	}

	return 'Siege';
}

/** Overridden for Siege to allow melee adhesion for certain creatures. */
simulated protected function bool TargetIsValidMeleeAdhesionTarget(GearPawn TestGP)
{
	local bool bAllowNormalMeleeAdhesion;
	if ( MyGearPawn.IsA('GearPawn_LocustWretchBase') || MyGearPawn.IsA('GearPawn_LocustTickerBase') )
	{
		bAllowNormalMeleeAdhesion = true;
	}

	if ( !bAllowNormalMeleeAdhesion && !TestGP.IsEvading() )
	{
		return FALSE;
	}

	if (!MyGearPawn.TargetIsValidMeleeTarget(TestGP, FALSE))
	{
		return FALSE;
	}

	return TRUE;
}

function TryToRoadieRun()
{
	local GearPawn_LocustBoomerBase Boomer;

	Super.TryToRoadieRun();

	// when boomer starts RRing, do charge telegraph in siege
	Boomer = GearPawn_LocustBoomerBase(MyGearPawn);
	if (Boomer != None)
	{
		if (IsDoingSpecialMove(SM_RoadieRun))
		{
			Boomer.TelegraphCharge();
		}
	}
}

/** Tell the client to setup the blind effects */
reliable client function ClientToggleSerapedeEffects(bool bVal)
{
	local GearHUDSiege SiegeHUD;

	SiegeHUD = GearHUDSiege(MyGearHud);
	if (SiegeHUD != None)
	{
		SiegeHUD.ToggleSerapedeEffects(bVal);
	}
}

function PawnDied(Pawn inPawn)
{
	ClientToggleSerapedeEffects(false);
	Super.PawnDied(inPawn);
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	// If I'm a berserker, turn on the blind effects
	if (GearPawn_LocustSerapedeBase(aPawn) != None)
	{
		ClientToggleSerapedeEffects(true);
	}

	Super.Possess(aPawn, bVehicleTransition);
}

function UnPossess()
{
	// Make sure the berserker blind effects are turned off
	ClientToggleBlindEffects(false);
	ClientToggleSerapedeEffects(false);

	Super.UnPossess();
}

function PressedDPad(EGameButtons Button)
{
	// skip the MP default weapon selection since that's not applicable for this gametype
	Super(GearPC).PressedDPad(Button);
}

DefaultProperties
{
	InputClass=class'GearPlayerInput_Siege'
	CharSelectMovieClassName="GearGameContent.UIScene_SiegeCharSelectContent"
	MinHitWall=-0.5f
}
