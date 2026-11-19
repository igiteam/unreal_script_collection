/**
 * Roll attack for the Armored Kantus
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_KantusArmor_RollAttack extends GSM_EvadeFwd;

/** How often to cause damage */
var config float RollDamageFrequency;

/** How much damage to cause */
var config float RollDamage;

/** The last time we caused damage */
var transient float LastRollDamageTime;

/** Camera shake to play while rolling */
var GearCameraShake RollCameraShake;

/** Metal spike extending sound */
var SoundCue MetalSpikeSound;

/** How far into the animation should damage start */
var const float RollDamageStartTime;

/** How far into the roll before we should check for walls blocking */
var const float MinRollTime;

/** When the roll started */
var float RollStartTime;

/** The last location we were at when we caused roll damage */
var vector LocationWhenLastDamaging;

/**
 * Start the body animation when the special move starts.
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	if (PCOwner != None)
	{
		PCOwner.ClientPlayCameraShake(RollCameraShake, 1.0f, TRUE);
	}

	PawnOwner.PlaySound(MetalSpikeSound, TRUE);

	// BEGIN_E3_HACK
	PawnOwner.bActivateMeatShieldMorph = TRUE;
	PawnOwner.MeatShieldMorphTimeToGo = 0.2f;
	// END_E3_HACK

	RollStartTime = PawnOwner.WorldInfo.TimeSeconds;
			
	LocationWhenLastDamaging = PawnOwner.Location;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// BEGIN_E3_HACK
	PawnOwner.bActivateMeatShieldMorph = FALSE;
	PawnOwner.MeatShieldMorphTimeToGo = 0.33f;
	// END_E3_HACK

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

/**
 * Hit colliding actors every RollDamageFrequency seconds
 * 
 * @param DeltaTime - the length of the last frame
 */
simulated function Tick(float DeltaTime)
{
	local Actor A;
	local GearPawn GP;
	local bool bPlayedDeath;

	Super.Tick(DeltaTime);

	if (PawnOwner.Role == ROLE_Authority && bPlayStartAnimation && `TimeSinceEx(PawnOwner, LastRollDamageTime) > RollDamageFrequency && `TimeSinceEx(PawnOwner, RollStartTime) > RollDamageStartTime)
	{
		foreach PawnOwner.VisibleCollidingActors(class'Actor', A, PawnOwner.GetCollisionRadius(), PawnOwner.Location)
		{
			GP = GearPawn(A);
			if (GP != None)
			{
				bPlayedDeath = GP.bPlayedDeath;

				if (!bPlayedDeath)
				{
					LastRollDamageTime = PawnOwner.WorldInfo.TimeSeconds;
				}
			}

			//`log("Hitting" @ `showvar(A));
			A.TakeDamage(RollDamage, PawnOwner.Controller, PawnOwner.Location, Normal(A.Location - PawnOwner.Location) * 500, class'GDT_KantusRoll');
			
			// and make them stumble
			if (GP != None && !GP.bPlayedDeath && !GP.InGodMode() && !GP.IsSameTeam(PawnOwner))
			{
				GP.DoStumbleFromMeleeSpecialMove(PawnOwner);
			}

			// play lens fx if we killed someone
			if (PCOwner != None && GP != None && !bPlayedDeath && GP.bPlayedDeath)
			{
				PCOwner.ClientSpawnCameraLensEffect(class'Emit_CameraBlood_ShotGun');
			}

			if (A.IsA('GearFortification_Wall'))
			{
				LastRollDamageTime = PawnOwner.WorldInfo.TimeSeconds;
			}
		}

		// If we're rolling in place for a while, just end it
		if (`TimeSinceEx(PawnOwner, RollStartTime) > MinRollTime)
		{
			if (VSize(LocationWhenLastDamaging - PawnOwner.Location) < 10.0)
			{
				PlayEndAnim(0);
			}

			//`log(`showvar(VSize(LocationWhenLastDamaging - PawnOwner.Location)));
			LocationWhenLastDamaging = PawnOwner.Location;
		}
	}
}

defaultproperties
{
	BS_EvadeStart=(Stance=((Slot=BS_FullBody,AnimName="Kantus_Roll_Attack_Start")))
	BS_EvadeEnd=(Stance=((Slot=BS_FullBody,AnimName="Kantus_Roll_Attack_End")))

	Begin Object Class=GearCameraShake Name=RollCameraShake0
		OscillationDuration=1.0f
		LocOscillation={(Y=(Amplitude=1.4f,Frequency=21.f),
						Z=(Amplitude=2.8f,Frequency=41.f))}
		RotOscillation={(Pitch=(Amplitude=60.f,Frequency=80.f),
						Yaw=(Amplitude=30.f,Frequency=50.f),
						Roll=(Amplitude=15.f,Frequency=20.f))}
	End Object
	RollCameraShake=RollCameraShake0

	RollDamageStartTime=0.92

	MinRollTime=1.13

	MetalSpikeSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_MeleeCue'
}