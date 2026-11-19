/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGRI_Horde extends GearGRI_MP
	native;

/** Total number of waves in the Invasion gametype */
var int InvasionNumTotalWaves;

/** The current wave the Invasion gametype is on */
var repnotify int InvasionCurrentWaveIndex;

/** percentage of wave points that are still alive (not spawned or not killed) - compressed to byte */
var byte WavePointsAlivePct;

/** Enemy difficulty */
var class<DifficultySettings> EnemyDifficulty;

/** (Horde only) the number of times we've wrapped around into more difficult "extended" rounds */
var repnotify int ExtendedRestartCount;

/** Total number of enemies that still need to be killed in the current round(wave).  Used in Invasion but could work in any gametype */
var repnotify byte EnemiesLeftThisRound;

/** whether players are currently able to place fortifications */
var repnotify protectedwrite bool bCanPlaceFortifications;

/** list of fortifications for easier access */
var array<GearFortificationMarker> FortificationMarkers;
var array<GearFortification> Fortifications;
var array<GearFortification_Flag> FortificationFlags;
var array<GearFortificationMarker> FortificationMarkersFlags;
/** whether there are any GearFortificationMarkers set to a flag */
var bool bHasFortificationFlags;

/** replicated info about the wave loop mutators that were selected */
struct native HordeExtendedMutRepInfo
{
	var class<GearHordeExtendedMutator> MutatorClass;
	var float Multiplier;
};
var HordeExtendedMutRepInfo ExtendedMutators[8];

replication
{
	if (bNetDirty)
		InvasionCurrentWaveIndex, WavePointsAlivePct, ExtendedRestartCount, EnemiesLeftThisRound, bCanPlaceFortifications,
		ExtendedMutators;

	if (bNetInitial)
		InvasionNumTotalWaves, EnemyDifficulty;
}

simulated event PostBeginPlay()
{
	local GearFortificationMarker Marker;
	local GearFortification Fort;
	local GearFortification_Flag Flag;

	Super.PostBeginPlay();

	foreach DynamicActors(class'GearFortificationMarker', Marker)
	{
		if (ClassIsChildOf(Marker.FortificationType, class'GearFortification_Flag'))
		{
			bHasFortificationFlags = true;
			FortificationMarkersFlags.AddItem(Marker);
		}
		FortificationMarkers.AddItem(Marker);
	}
	foreach DynamicActors(class'GearFortification', Fort)
	{
		Fortifications.AddItem(Fort);
	}
	foreach DynamicActors(class'GearFortification_Flag', Flag)
	{
		FortificationFlags.AddItem(Flag);
	}
}

simulated event ReplicatedEvent( name VarName )
{
	local GearHordePC PC;

	switch (VarName)
	{
		case 'ExtendedRestartCount':
			CheckHordeMessage();
			break;
		case 'EnemiesLeftThisRound':
			foreach LocalPlayerControllers(class'GearHordePC', PC)
			{
				PC.EnemyCountChanged(EnemiesLeftThisRound);
			}
			break;
		case 'bCanPlaceFortifications':
			SetFortificationPlacement(bCanPlaceFortifications);
			break;
		case 'InvasionCurrentWaveIndex':
			foreach LocalPlayerControllers(class'GearHordePC', PC)
			{
				PC.WaveChanged(InvasionCurrentWaveIndex);
			}
			break;
		default:
			Super.ReplicatedEvent(VarName);
			break;
	}
}

/** Checks to see if the mod scene should display */
simulated function CheckHordeMessage()
{
	local GearPC PC;
	if (ExtendedRestartCount > 0)
	{
		foreach LocalPlayerControllers(class'GearPC',PC)
		{
			if (PC.MyGearHUD != None)
			{
				PC.MyGearHUD.AttemptHordeModOpen();
				// only open for one since it's fullscreen
				break;
			}
		}
	}
}

/** enables/disables the ability for players to place and modify fortifications */
simulated function SetFortificationPlacement(bool bNewCanPlaceFortifications)
{
	local GearFortificationMarker GFMarker;
	local GearFortification Fort;
	local GearPC PC;
	local bool bHaveCrippledForts;

	bCanPlaceFortifications = bNewCanPlaceFortifications;

	// enable/disable fortification markers
	foreach FortificationMarkers(GFMarker)
	{
		GFMarker.SetEnabled(bCanPlaceFortifications);
	}
	foreach Fortifications(Fort)
	{
		bHaveCrippledForts = bHaveCrippledForts || Fort.IsInState('Crippled');
		Fort.UpdateRepairGlow();
	}
	// clear any pending fortification info since they can no longer be used
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		if (!bCanPlaceFortifications)
		{
			PC.ModifyFortification = None;
		}
		else if (bHaveCrippledForts && PC.TutorialMgr != None)
		{
			PC.TutorialMgr.StartTutorial(GEARTUT_FortDestruction);
		}
	}
}

/** updates the ghost/glow images that indicate whether fortifications can be bought/repaired/etc */
simulated final function UpdateFortificationGhostImages()
{
	local GearFortificationMarker Marker;
	local GearFortification Fort;

	foreach FortificationMarkers(Marker)
	{
		Marker.UpdateGhostMaterial();
	}
	foreach Fortifications(Fort)
	{
		Fort.UpdateRepairGlow();
	}
}

function UpdateRoundTime()
{
	local GearGameHorde_Base Game;

	//@hack: pause game time while waiting for the players to build initial base
	Game = GearGameHorde_Base(WorldInfo.Game);
	if (Game == None || GearHordeObjective_BuildFlag(Game.ActiveBonusObjective) == None)
	{
		Super.UpdateRoundTime();
	}
}

defaultproperties
{
	WavePointsAlivePct=255
	EnemiesLeftThisRound=255
}
