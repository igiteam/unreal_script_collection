/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_Pinata extends GearMutator
	config(Game);

/** maximum score that can be contained in one piece of "candy" */
var config int MaxScorePerPiece;
/** sound played when spawning the points */
var SoundCue SpawnSound;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// enforce valid setting
	if (MaxScorePerPiece <= 0)
	{
		MaxScorePerPiece = 50;
	}
}

function bool OverrideDeathScoring(GearPRI KillerPRI, GearPRI DeadPRI, class<GearDamageType> KillType, EGearDeathType DeathType, optional int AdditionalPts)
{
	local GearPC PC;
	local int TotalScore, Score;
	local GearPinataCandy Candy;
	local Controller DeadController;

	if (PlayerController(KillerPRI.Owner) == None)
	{
		return false;
	}
	else
	{
		DeadController = Controller(DeadPRI.Owner);

		if (WorldInfo.GRI.OnSameTeam(KillerPRI.Owner, DeadPRI.Owner))
		{
			// @STATS - Score stats for a team kill
			`RecordKillEvent(TEAMKILL, Controller(KillerPRI.Owner), KillType, Controller(DeadPRI.Owner));
		}

		// empty list just to be safe
		DeadPRI.PlayerDamageList.length = 0;
		// notify players
		foreach WorldInfo.AllControllers(class'GearPC',PC)
		{
			PC.AddDeathMessage(GearPawn(DeadController.Pawn), KillerPRI, DeadPRI, KillType, DeathType,false);
		}

		TotalScore = DeadPRI.PointsFor_DamagePct + AdditionalPts;
		Controller(DeadPRI.Owner).Pawn.PlaySound(SpawnSound);
		while (TotalScore > 0)
		{
			Score = Min(TotalScore, MaxScorePerPiece);
			TotalScore -= Score;

			Candy = Spawn(class'GearPinataCandy',,, Controller(DeadPRI.Owner).Pawn.Location, RotRand());
			if (Candy != None)
			{
				Candy.ScoringValue = Score;
				Candy.Velocity = VRand() * 200.0;
				Candy.Velocity.Z = 750.0 + 150.0 * FRand();
			}
		}

		return true;
	}
}

defaultproperties
{
	SpawnSound=SoundCue'Interface_Audio.Pinata.PinataExplode_01_Cue'
}
