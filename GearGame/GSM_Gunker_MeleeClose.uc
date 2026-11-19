
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Gunker_MeleeClose extends GearSpecialMove;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	Super.SpecialMoveStarted(bForced,PrevMove);

	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);
	if (GunkerPawn != None)
	{
		// Play body stance animation
		GunkerPawn.AnimSeq_MeleeSwipe.SetAnim('Gunker_PushBack_Scoop');
		GunkerPawn.AnimSeq_MeleeSwipe.PlayAnim();
	}

	if (PawnOwner.Role == ROLE_Authority)
	{
		// Play a swiping sound
		GunkerPawn.PlaySound(GunkerPawn.MeleeSwipeSound,,,, GunkerPawn.Location);
		// Swipe voice
		GunkerPawn.SpeakLine(None, GunkerPawn.VoiceSwipeAttack, "", 0.f, Speech_Immediate);
		// Knock everyone in front down
		PawnOwner.SetTimer(0.5, false, nameof(KnockbackEnemies), self);
	}
}

/** Makes the enemies in front of the gunker get knocked back */
function KnockbackEnemies()
{
	local GearPawn GP;
	local GearPawn_LocustGunkerBase GunkerPawn;

	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);

	foreach PawnOwner.WorldInfo.AllPawns(class'GearPawn', GP, PawnOwner.Location, GearAI_Gunker(PawnOwner.Controller).EnemyDistance_Melee)
	{
		// Only knock back enemies who are alive
		if (GP != None && GP.IsAliveAndWell() && !PawnOwner.WorldInfo.GRI.OnSameTeam(GP, PawnOwner))
		{
			// Make sure the enemies are in front of the Gunker
			if (Normal(GP.Location - PawnOwner.Location) dot vector(PawnOwner.Rotation) > 0.1)
			{
				if (GP.VerifySMHasBeenInstanced(SM_CoverHead))
				{
					GP.ServerDoSpecialMove(SM_CoverHead, TRUE, None, 5.f);
				}
				GP.SetLocation(GP.Location + vect(0,0,10.0f));
				GP.SetPhysics(PHYS_Falling);
				GP.Velocity = Normal(GP.Location - PawnOwner.Location) * 2000.0;
				GP.Velocity.z = 200.0;
				GP.TakeDamage(GearPawn_LocustGunkerBase(PawnOwner).BoomerMeleeDamage, PawnOwner.Controller, GP.Location, Normal(GP.Location - PawnOwner.Location), class'GDT_GunkerSwipe');
				// Play an impact sound
				if (GunkerPawn != None)
				{
					GunkerPawn.PlaySound(GunkerPawn.HitImpactFromSwipeSound,,,, GP.Location);
				}
			}
		}
	}
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.ClearTimer('KnockbackEnemies', Self);
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
}
