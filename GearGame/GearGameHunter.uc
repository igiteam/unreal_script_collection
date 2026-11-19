/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameHunter extends GearGameTDM_Base
	abstract;

/** total number of hats in play this round (when one team has all of them, they win) */
var int TotalHatsInPlay;
/** class of hat pickup */
var class<GearHunterHat> HatClass;

function StartMatch()
{
	local int i;
	local GearHunterPRI PRI;

	Super.StartMatch();

	TotalHatsInPlay = 0;
	for (i = 0; i < GameReplicationInfo.PRIArray.length; i++)
	{
		PRI = GearHunterPRI(GameReplicationInfo.PRIArray[i]);
		if (PRI != None && !PRI.bOnlySpectator)
		{
			PRI.NumHats = 1;
			if (WorldInfo.NetMode != NM_DedicatedServer)
			{
				PRI.UpdateHatAttachments();
			}
			TotalHatsInPlay++;
		}
	}
}

function bool TeamHasRespawn(int TeamIdx)
{
	return true;
}

/** @return Actor the AI should move towards to complete game objectives (if any) */
function Actor GetObjectivePointForAI(GearAI AI);
/** sets the appropriate combat mood for the AI based on the current game state */
function SetAICombatMoodFor(GearAI AI);
/** adjust the AI's rating of the given enemy */
function AdjustEnemyRating(GearAI AI, out float out_Rating, Pawn EnemyPawn);

/** notification when a player picks up a hat - check if the round should end because this team has all of them */
function NotifyHatPickup(Pawn Other);

state MatchInProgress
{
	function RestartPlayer(Controller NewPlayer)
	{
		GearPRI(NewPlayer.PlayerReplicationInfo).ClearDeathVariables();
		Super(GearGame).RestartPlayer(NewPlayer);
	}

	function DiscardInventory(Pawn Other, optional Controller Killer)
	{
		local GearHunterPRI PRI;
		local GearPawn GP;
		local vector BaseSpawnLoc;
		local GearHunterHat Hat;

		PRI = GearHunterPRI(Other.PlayerReplicationInfo);
		if (PRI != None)
		{
			GP = GearPawn(Other);
			BaseSpawnLoc = (GP != None && GP.HeadBoneNames.length > 0) ? GP.Mesh.GetBoneLocation(GP.HeadBoneNames[0]) : GP.Location;
			BaseSpawnLoc.Z += CylinderComponent(HatClass.default.CollisionComponent).CollisionHeight + 10.0;
			for (PRI.NumHats = PRI.NumHats; PRI.NumHats > 0; PRI.NumHats--)
			{
				Hat = Other.Spawn(HatClass,,, BaseSpawnLoc + VRand() * 10.0, Other.Rotation);
				if (Hat == None)
				{
					BaseSpawnLoc.Z += 20.0;
					Hat = Other.Spawn(HatClass,,, BaseSpawnLoc + VRand() * 10.0, Other.Rotation);
					if (Hat == None)
					{
						// give up and just reduce hats in play
						TotalHatsInPlay--;
					}
				}
				if (Hat != None)
				{
					Hat.Velocity = VRand() * 150.0;
					Hat.Velocity.Z += 300.0;
				}
			}
			if (WorldInfo.NetMode != NM_DedicatedServer)
			{
				PRI.UpdateHatAttachments();
			}
		}

		Super.DiscardInventory(Other, Killer);
	}

	function NotifyHatPickup(Pawn Other)
	{
		local int i, TeamNum, HatsOwned;
		local GearHunterPRI PRI;

		// check for win
		TeamNum = Other.GetTeamNum();
		for (i = 0; i < Teams[TeamNum].TeamMembers.length; i++)
		{
			PRI = GearHunterPRI(Teams[TeamNum].TeamMembers[i].PlayerReplicationInfo);
			if (PRI != None)
			{
				HatsOwned += PRI.NumHats;
			}
		}
		// if they have all the hats, victory!
		if (HatsOwned >= TotalHatsInPlay)
		{
			HandleTeamWin(TeamNum);
		}
	}

	function BroadcastRespawnMessage()
	{
		if ( GetTotalRespawningPlayers() > 0 &&
			(WorldInfo.TimeSeconds - LastTeamPlayerStartCycleTime >= MaxTeamStartCycleInterval || SpawnPointsAreEncroached(false)) )
		{
			CycleTeamPlayerStarts();
		}
		Super.BroadcastRespawnMessage();
	}
}

defaultproperties
{
	PlayerReplicationInfoClass=class'GearHunterPRI'
}
