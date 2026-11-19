/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameWaveBased extends GearGameMP_Base
	native
	abstract;

/** the difficulty level for the enemies */
var class<DifficultySettings> EnemyDifficulty;

/** highest "checkpoint" wave reached, for "restart from checkpoint" functionality */
var int LastCheckpointWave;

/** The amount of XP to award per round for each difficulty */
var config int XPCasual;
var config int XPNormal;
var config int XPHardcore;
var config int XPInsane;

/** The amount of XP to add to the base XP per 10 waves of Horde/Beast */
var config int XPCasualPoisonIncrease;
var config int XPNormalPoisonIncrease;
var config int XPHardcorePoisonIncrease;
var config int XPInsanePoisonIncrease;

/** The amount of interest to apply to the XP as the basis of the compounding */
var config float XPCasualInterestRate;
var config float XPNormalInterestRate;
var config float XPHardcoreInterestRate;
var config float XPInsaneInterestRate;

/**
 * Purposefully left blank to skip the base class implementation
 */
function WriteOnlinePlayerScores()
{
}

/**
 * Determines how much XP to award each player based off their consecutive waves played
 */
function AwardXP()
{
	local GearPC PC;
	local GearPRI_WaveBased PRI;
	local int WavesPlayed, BaseXP, PoisonXP, CompoundedXP, i;
	local float XPInterest;

	// Give XP based upon difficulty
	switch (EnemyDifficulty.default.DifficultyLevel)
	{
		case DL_Casual:
			BaseXP = XPCasual;
			PoisonXP = XPCasualPoisonIncrease;
			XPInterest = XPCasualInterestRate;
			break;
		case DL_Normal:
			BaseXP = XPNormal;
			PoisonXP = XPNormalPoisonIncrease;
			XPInterest = XPNormalInterestRate;
			break;
		case DL_Hardcore:
			BaseXP = XPHardcore;
			PoisonXP = XPHardcorePoisonIncrease;
			XPInterest = XPHardcoreInterestRate;
			break;
		case DL_Insane:
			BaseXP = XPInsane;
			PoisonXP = XPInsanePoisonIncrease;
			XPInterest = XPInsaneInterestRate;
			break;
	}
	`Log("");
	// Determine where in the poison bonus chart they are (1 - 5x)
	BaseXP += PoisonXP * (LastCheckpointWave / 10);
	`Log("BaseXP ("$BaseXP$") PoisonXP ("$PoisonXP$") LastCheckpointWave ("$LastCheckpointWave$")");
	// Update the rich presence info and award out the XP
	foreach WorldInfo.AllControllers(class'GearPC',PC)
	{
		// Determine how much XP this player gets
		PRI = GearPRI_WaveBased(PC.PlayerReplicationInfo);
		if (PRI != None)
		{
			// Determine the number of waves this player has played
			WavesPlayed = LastCheckpointWave - PRI.WaveNumAtJoinTime;
			if (WavesPlayed > 0 &&
				// Don't award XP for players that just joined
				PRI.ScoreAtJoinTime > -1)
			{
				// Determine how much of a bonus to give for consecutive waves played
				CompoundedXP = BaseXP * WavesPlayed * XPInterest;
				`Log("CompoundedXP ("$CompoundedXP$") WavesPlayed ("$LastCheckpointWave$") XPInterest ("$XPInterest$")");
				`Log("Total XP ("$CompoundedXP + BaseXP$")");
				// Total XP is base + compounded
				PRI.ExpBuckets[eEXP_WinBonus] = BaseXP;
				PRI.ExpBuckets[eEXP_ParticipationBonus] = CompoundedXP;
				// Notify the client of their XP earned
				PC.ClientUpdateXP(PRI.ExpBuckets);

				// clear the buckets for next wave
				for (i = 0; i < ArrayCount(PRI.ExpBuckets); i++)
				{
					PRI.ExpBuckets[i] = 0;
				}
			}
		}
	}
	`Log("");
}
