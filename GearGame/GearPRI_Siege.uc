/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPRI_Siege extends GearPRI_WaveBased
	native
	dependson(GearGameSiege_Base);

/** how many wave points this player has remaining to spend on Locust */
var repnotify int WavePointsRemaining;

/** how many wave points this player has spent THIS round */
var repnotify int WavePointsSpentThisRound;
/** Holds above last value to calculate delta */
var int WavePointsSpentThisRoundLast;
/** how many bonus points this player has earned this round */
var repnotify int WavePointsEarnedThisRound;
/** Holds above last value to calculate delta */
var int WavePointsEarnedThisRoundLast;

/** progress towards gaining another wave point (based on acquiring score) */
var float WavePointBonusProgress;

/** Locust characters this player has unlocked in each column
 * special values: 255 (locked), 254 (unlocked, haven't chosen the character to use in that tier)
 * @warning: static array for replication; Locust list must not exceed this size x 4
 */
var repnotify byte UnlockedCharacters[`LOCUSTLIST_COLUMNS];

/** what char the player has selected */
var repnotify byte SiegeCharIndex;

/** whether this PRI is for an enemy hero character */
var bool bIsHero;

/** Count how long the player has been idle on the selection screen */
var int IdleTime;

replication
{
	if (bNetInitial)
		bIsHero;

	if (bNetDirty)
		WavePointsRemaining, WavePointsSpentThisRound, WavePointsEarnedThisRound, WavePointBonusProgress,
		SiegeCharIndex;

	if (bNetOwner)
		UnlockedCharacters;
}

function int ModifyScore(int Amt, EExperienceBuckets Bucket)
{
	local Controller C;
	local float TeammateWavePointBonus;
	local GearGameSiege_Base Game;

	// some Locust attacks cause self damage but we don't want to penalize players for using them,
	// so ignore any negative scoring
	if (Amt > 0 && GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress)
	{
		if (GetTeamNum() == 1)
		{
			Game = GearGameSiege_Base(WorldInfo.Game);
			IncrementWavePointProgress(Amt / Game.WavePointBonusScale);
			if (Game.WavePointBonusScaleTeammate > 0.0)
			{
				// also give all of our teammates a small boost
				TeammateWavePointBonus = Amt / Game.WavePointBonusScaleTeammate;
				foreach GearTeamInfo(Team).TeamMembers(C)
				{
					if (PlayerController(C) != None && C.PlayerReplicationInfo != self)
					{
						GearPRI_Siege(C.PlayerReplicationInfo).IncrementWavePointProgress(TeammateWavePointBonus);
					}
				}
			}
		}

		return Super.ModifyScore(Amt, Bucket);
	}
	else
	{
		return 0;
	}
}

/** increases the wave point bonus amount; if it reaches a whole number, awards a wave point for use in character selection */
final function IncrementWavePointProgress(float Amount)
{
	WavePointBonusProgress += Amount;
	if (WavePointBonusProgress >= 1.0)
	{
		WavePointsRemaining += int(WavePointBonusProgress);
		WavePointsEarnedThisRound += int(WavePointBonusProgress);
		WavePointBonusProgress -= int(WavePointBonusProgress);

		if (PlayerController(Owner) != None && PlayerController(Owner).IsLocalPlayerController())
		{
			ReplicatedEvent(nameof(WavePointsEarnedThisRound));
		}

		if (WavePointsRemaining > 0 && GearPC_Siege(Owner) != None && Owner.IsInState('Spectating'))
		{
			GearPC_Siege(Owner).ClientOpenClassSelector();
		}
	}
	bForceNetUpdate = true;
}

function ScoreHeal(GearPRI InstigatorPRI, float HealthPct)
{
	local int Amount;
	local float TokenLoss;
	local GearPRI_Siege LossPRI;

	// award score based on percentage healed, with 100% being standard revive score
	// remove the same amount from this player
	Amount = PointsFor_Revives * HealthPct;
	if (Amount > 0)
	{
		InstigatorPRI.ModifyScore(Amount, eEXP_Revives);
		ForceScorePenalty(-Amount, eEXP_Revives);
		if (GearPC(InstigatorPRI.Owner) != None)
		{
			GearPC(InstigatorPRI.Owner).AddScoreGameMessage(69, Amount, self);
		}

		TokenLoss = Amount / GearGameSiege_Base(WorldInfo.Game).WavePointBonusScale;
		if (WavePointsRemaining < Round(TokenLoss))
		{
			// if the saved player doesn't have the tokens, revert the token bonus to the reviver (but leave the points)
			LossPRI = GearPRI_Siege(InstigatorPRI);
		}
		else
		{
			LossPRI = self;
		}
		LossPRI.WavePointBonusProgress -= TokenLoss;
		if (LossPRI.WavePointBonusProgress < 0.0)
		{
			LossPRI.WavePointsRemaining += FFloor(LossPRI.WavePointBonusProgress);
			LossPRI.WavePointBonusProgress -= FFloor(LossPRI.WavePointBonusProgress);
		}
	}
}

/** used by Siege specific code when we are really sure we want to take away points (e.g. revival scoring) */
final function ForceScorePenalty(int Amt, EExperienceBuckets Bucket)
{
	Super.ModifyScore(Amt, Bucket);
}

simulated event ReplicatedEvent(name VarName)
{
	local int Delta;
	local GearPC_Siege PC;

	if (VarName == nameof(WavePointsRemaining))
	{
		if (WavePointsRemaining > 0)
		{
			PC = GearPC_Siege(Owner);
			if (PC != None && PC.IsSpectating())
			{
				// give a delay in case change happens while player is already spawning
				// (avoid flashing the UI back on and then removing it)
				PC.SetTimer(1.0, false, nameof(PC.ClientOpenClassSelector));
			}
		}
	}
	else if (VarName == nameof(WavePointsSpentThisRound))
	{
		PC = GearPC_Siege(Owner);
		if (PC != None && PC.StatManager != None)
		{
			Delta = WavePointsSpentThisRound - WavePointsSpentThisRoundLast;
			if (Delta > 0)
			{
				PC.StatManager.ModifyStat('TokensSpent', Delta, GEARSTATMODTYPE_Delta);
			}
		}

		WavePointsSpentThisRoundLast = WavePointsSpentThisRound;
	}
	else if (VarName == nameof(WavePointsEarnedThisRound))
	{
		PC = GearPC_Siege(Owner);
		if (PC != None && PC.StatManager != None)
		{
			Delta = WavePointsEarnedThisRound - WavePointsEarnedThisRoundLast;
			if (Delta > 0)
			{
				PC.StatManager.ModifyStat('TokensEarned', Delta, GEARSTATMODTYPE_Delta);
			}
		}

		WavePointsEarnedThisRoundLast = WavePointsEarnedThisRound;
	}
	else if (VarName == nameof(UnlockedCharacters))
	{
		// tell the UI
		PC = GearPC_Siege(Owner);
		if (PC != None && PC.CharSelectMovie != None)
		{
			PC.CharSelectMovie.UpdateNumPoints();
		}
	}
	else
	{
		if (VarName == nameof(SiegeCharIndex) || VarName == nameof(bIsDead))
		{
			//TELL THE UI
			foreach WorldInfo.LocalPlayerControllers(class'GearPC_Siege',PC)
			{
				if (PC.PlayerReplicationInfo != self && PC.CharSelectMovie != None)
				{
					PC.CharSelectMovie.OtherPlayersStatusChanged();
				}
			}
		}
		Super.ReplicatedEvent(VarName);
	}
}

simulated function RecordKilledBy(PlayerReplicationInfo PRI)
{
	local GearPRI_Siege SiegePRI;

	// only heroes can be a nemesis of a player
	SiegePRI = GearPRI_Siege(PRI);
	if (SiegePRI == None || SiegePRI.bIsHero)
	{
		Super.RecordKilledBy(PRI);
	}
}

defaultproperties
{
	SiegeCharIndex=200
}
