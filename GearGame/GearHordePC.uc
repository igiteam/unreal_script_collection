/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Specialized player controller to only write stats when a high score is hit
 */
class GearHordePC extends GearPC_MP
	dependson(GearTeamInfo)
	native(PC);

`include(GearLeaderboardConstants.uci)

/** set after player has purchased their respawn for the current wave, indicating they can't do so again until the next wave */
var bool bRespawnedThisWave;
/** set if this player should be skipped the next time interest is handed out */
var bool bSkipInterest;

/** info on enemy packages that have been loaded or are in the process of loading
 * on the server, contains items that the client has confirmed it has loaded
 * on the client, contains items that have been or are still in the process of being loaded
 * for listen server players, this array is always empty (managed by GameInfo instead)
 */
struct native LoadedEnemyList
{
	/** object name of list */
	var name ListName;
	/** client only - reference to the list object to hold it in memory */
	var GearHordeEnemyList List;
};
var array<LoadedEnemyList> EnemyLists;

/** drawn when a new bonus objective is added */
var localized string NewBonusObjectiveText;
/** strings displayed after completing a bonus objective */
var localized string BonusCompleteText, BonusRewardText, BonusFailedText, BonusPartialRewardText;

cpptext
{
	/**
	 * Builds a list of components that are hidden based upon gameplay
	 *
	 * @param ViewLocation the view point to hide/unhide from
	 * @param HiddenComponents the list to add to/remove from
	 */
	virtual void UpdateHiddenComponents(const FVector& ViewLocation,TSet<UPrimitiveComponent*>& HiddenComponents);
}

replication
{
	if (bNetOwner)
		bRespawnedThisWave;
}

/** tells a client to load and bind an enemy list that will soon be in use */
reliable client final function ClientLoadEnemyList(name ListName)
{
	local int Idx;

	if (Role < ROLE_Authority)
	{
		Idx = EnemyLists.Add(1);
		EnemyLists[Idx].ListName = ListName;
		EnemyLists[Idx].List = new(None, string(ListName)) class'GearHordeEnemyList';
		EnemyLists[Idx].List.LoadComplete = EnemyListLoaded;
		EnemyLists[Idx].List.Load();
	}
}

/** set to enemy list object's delegate to handle loading being completed */
final function EnemyListLoaded(GearHordeEnemyList List)
{
	ServerEnemyListLoaded(List.Name);
}

/** notification from client to server that the named list has been fully loaded */
reliable server final function ServerEnemyListLoaded(name ListName)
{
	local int Idx;

	Idx = EnemyLists.Add(1);
	EnemyLists[Idx].ListName = ListName;

	GearGameHorde_Base(WorldInfo.Game).CheckEnemyListReady(ListName);
}

/** removes the specified enemy list from this controller's list (for the client this will also cause it to be GC'ed) */
final function RemoveEnemyList(name ListName)
{
	local int i;

	// intentionally loop through all even after finding one just in case we get duplicates somehow
	while (i < EnemyLists.length)
	{
		if (EnemyLists[i].ListName == ListName)
		{
			EnemyLists.Remove(i, 1);
		}
		else
		{
			i++;
		}
	}

	if (NetConnection(Player) != None)
	{
		ClientRemoveEnemyList(ListName);
	}
}

/** called by the server to remove the specified enemy list so it can be GC'ed */
protected reliable client final function ClientRemoveEnemyList(name ListName)
{
	RemoveEnemyList(ListName);
	WorldInfo.ForceGarbageCollection();
}

/**
 * Starts the online game using the session name in the PRI
 */
reliable client function ClientStartOnlineGame()
{
	Super.ClientStartOnlineGame();
	SetupCarrotLadder();
}

/** Read into the friends list and setup the carrot ladder */
simulated function SetupCarrotLadder()
{
	local LocalPlayer LP;
	LP = LocalPlayer(Player);
	if (LP != None)
	{
		OnlineSub.PlayerInterface.AddReadFriendsCompleteDelegate(LP.ControllerId,OnReadFriendsComplete);
		OnlineSub.PlayerInterface.ReadFriendsList(LP.ControllerId);
	}
}

/** Setup the carrot ladder for horde now that we have friends */
simulated function OnReadFriendsComplete(bool bWasSuccessful)
{
	local LocalPlayer LP;
	LP = LocalPlayer(Player);
	if (LP != None && bWasSuccessful)
	{
		StatManager.SetupCarrotLadder("GearGame.GearCarrotLadder_Horde");
	}

	OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(LP.ControllerId,OnReadFriendsComplete);
}

/**
 * If the player beats their high score that high score and wave is written
 *
 * @param OnlineStatsWriteClass the stats class to write with
 * @param bIsIncomplete TRUE if the match wasn't finished at the time of the write
 */
reliable client function ClientWriteLeaderboardStats(class<OnlineStatsWrite> OnlineStatsWriteClass, optional bool bIsIncomplete=false)
{
	local GearHordePRI HordePRI;
	local GearTeamInfo GearTeam;

	HordePRI = GearHordePRI(PlayerReplicationInfo);
	GearTeam = GearTeamInfo(PlayerReplicationInfo.Team);
	// Always write scores (backend handles high score)
	if (HordePRI != None &&
		GearTeam != None &&
		// Players who just joined get no score this round
		HordePRI.ScoreAtJoinTime > -1)
	{
		Super.ClientWriteLeaderboardStats(OnlineStatsWriteClass, bIsIncomplete);
	}
}

/**
 * Called whenever StartNextWave() is called to update the rich presence
 *
 * @param Wave the wave that we are in
 */
reliable client function ClientSetHordePresence(int Wave)
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

		OnlineSub.PlayerInterface.SetOnlineStatus(LP.ControllerId, class'GearGame'.const.CONTEXT_PRESENCE_HORDEPRESENCE, StringSettings, Properties);
	}
}

/** called to provide extra notification of a new bonus objective */
reliable client final function ClientNewBonusObjective()
{
	ClientPlaySound(GearHUDInvasion_Base(MyGearHud).BonusObjectiveSound);
	MyGearHud.StartDrawingDramaticText(NewBonusObjectiveText, "", 5.0, 0.25, 2.0, MyGearHud.GetCountdownYPosition() + MyGearHud.CountdownSize.Y + NumPixelsToMoveDownForDramaText());
}

/** called on each client after completing a bonus objective to show an announcement on the HUD */
reliable client final function ClientCompletedBonus(int Reward, bool bFailed)
{
	local string RewardText;

	if (Reward > 0)
	{
		RewardText = (bFailed ? BonusPartialRewardText : BonusRewardText) @ Reward;
	}
	MyGearHUD.StartDrawingDramaticText( bFailed ? BonusFailedText : BonusCompleteText, RewardText, 8.0, 0.25, 2.0,
						MyGearHUD.GetCountdownYPosition() + MyGearHUD.CountdownSize.Y + NumPixelsToMoveDownForDramaText(), 2.0, 2.0 );

	if (!bFailed && ProfileSettings != None)
	{
		ProfileSettings.UpdateAchievementProgression(eGA_CALLINGYOURSHOTS, self);
	}
}

/**
 * total hack - returns false in horde so that we don't pause the game in horde when the host's gamepad is disconnected
 */
function bool AllowPauseForControllerRemovalHack()
{
	return false;
}

/** determine player's fortification building ability based on their persistent data */
simulated function InitFortificationUpgradeLevels()
{
	local int i, j, UpgradeLevel;
	local float RepairPct;
	local class<GearFortification> FortClass;

	for (i = 0; i < FortUpgradeAwardMap.length; i++)
	{
		FortClass = class<GearFortification>(FindObject("GearGame.GearFortification_" $ FortUpgradeAwardMap[i].FortName, class'Class'));
		if (FortClass == None)
		{
			`Warn("Failed to find fortification '" $ FortUpgradeAwardMap[i].FortName $ "'");
		}
		else
		{
			UpgradeLevel = -1;
			for (j = 0; j < FortUpgradeAwardMap[i].UpgradeAwards.length; j++)
			{
				if ( FortUpgradeAwardMap[i].UpgradeAwards[j] == 'None' ||
					AwardManager.HasEarnedAwardByName(FortUpgradeAwardMap[i].UpgradeAwards[j]) )
				{
					UpgradeLevel++;
				}
			}
			RepairPct = RepairPctRange.X;
			for (j = 0; j < FortUpgradeAwardMap[i].RepairAwards.length; j++)
			{
				if ( FortUpgradeAwardMap[i].RepairAwards[j] == 'None' ||
					AwardManager.HasEarnedAwardByName(FortUpgradeAwardMap[i].RepairAwards[j]) )
				{
					RepairPct -= (RepairPctRange.X - RepairPctRange.Y) / float(FortUpgradeAwardMap[i].RepairAwards.length);
				}
			}
			SetFortificationUpgradeLevel(FortClass, UpgradeLevel, RepairPct);
		}
	}
}

//Notification that the wave has changed
simulated function WaveChanged(int NewWave)
{
}

//Notification that the enemy count has changed
simulated function EnemyCountChanged(int NewEnemyCount)
{
	local GearHUDInvasion_Base InvHUD;

	InvHUD = GearHUDInvasion_Base(myHUD);
	if (InvHUD != None)
	{
		InvHUD.EnemyCountChanged();
	}
}

/** clears all optional Horde enemy lists from memory */
// Intentionally here for testers
exec function ClearHordeSubLists()
{
	local GearGameHorde_Base Game;

	Game = GearGameHorde_Base(WorldInfo.Game);
	while (Game.EnemyLists.length > 1)
	{
		Game.RemoveEnemyList(Game.EnemyLists[1]);
	}
}

/** starts loading a Horde enemy list */
// Intentionally here for testers
exec function AddHordeEnemyList(name ListName)
{
	GearGameHorde_Base(WorldInfo.Game).PrepareEnemyList(ListName);
}
