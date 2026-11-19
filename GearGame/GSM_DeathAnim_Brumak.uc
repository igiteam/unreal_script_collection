
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_DeathAnim_Brumak extends GSM_DeathAnim;

/**
 * Play a death animation followed by rag doll physics.
 * Return TRUE if successful, FALSE if couldn't find an animation and wants to go into ragdoll.
 */
function bool PlayDeathAnimation(class<GearDamageType> DamageType, vector HitLoc)
{
	local BodyStance	BS_DeathAnim;
	local bool			bLoop, bPickedDeathAnimation, bRotateToShotDir, bShotFromSide;
	local Rotator		ShotRotation, PawnLookRotation;
	local GearGRI		MyGRI;
	local Vector		WorldHitDir, LookX, LookY, LookZ, WorldHitX, WorldHitY, WorldHitZ;
	local Vector		LocalHitDir;

	bPickedDeathAnimation = FALSE;
	bLoop = FALSE;

	// Pointer to GameReplicationInfo.
	MyGRI = GearGRI(PawnOwner.WorldInfo.GRI);

	// Pawn look rotation is pawn rotation + his aimoffset horizontal value. This is what really matters to find out how the pawn should fall.
	PawnLookRotation.Yaw = NormalizeRotAxis(PawnOwner.Rotation.Yaw + PawnOwner.AimOffsetPct.X * 16384.f);

	// Did pawn got shot in the back?
	if( VSizeSq(PawnOwner.TearOffMomentum) > 0.01f )
	{
		// Figure out where the shot came from so we can trigger proper death animations.
		GetAxes(PawnLookRotation, LookX, LookY, LookZ);

		// Normalize and turn into 2D space. We don't care about Z axis.
		WorldHitDir = -1.f * (PawnOwner.TearOffMomentum);
		WorldHitDir.Z = 0.f;
		WorldHitDir = Normal(WorldHitDir);

		LocalHitDir.X = WorldHitDir dot LookX;
		LocalHitDir.Y = WorldHitDir dot LookY;

		bShotFromSide = Abs(LocalHitDir.Y) > Abs(LocalHitDir.X);
		GetAxes(Rotator(WorldHitDir), WorldHitX, WorldHitY, WorldHitZ);
	}
	else
	{
		`Warn(PawnOwner.WorldInfo.TimeSeconds @ PawnOwner @ class @ GetFuncName() @ "TearOffMomentum is zero:" @ PawnOwner.TearOffMomentum @ "for" @ DamageType @ Normal(HitLoc-PawnOwner.Location));
	}

	// If cannot play a death animation, we'll just hold the current animation pose before collapsing in rag doll
	// But if we can, let's pick which animation to play.
	if( PawnOwner.bPlayDeathAnimations && !PawnOwner.bHasPlayedHeadShotDeath )
	{
		// Pick a high kick death animation (for explosives/shotgun).
		if( !bPickedDeathAnimation && DamageType.default.bHighKickDeathAnimation )
		{
			// See if Pawn got shot in the back, then do forward fall
			if( LocalHitDir.X < 0.f && PawnOwner.DeathAnimHighFwd.Length != 0 )
			{
				BS_DeathAnim.Stance.Length = 1; // Array of struct needs to be pre-sized.
				BS_DeathAnim.Stance[0].Slot = BS_FullBody;
				BS_DeathAnim.Stance[0].AnimName = PickDeathAnimationFromList(PawnOwner.DeathAnimHighFwd, MyGRI.LastDeathAnimHighFwdIndex);
				bRotateToShotDir = TRUE;
				bPickedDeathAnimation = TRUE;
				ShotRotation.Yaw = Rotator(-WorldHitX).Yaw;
			}
			// See if Pawn got shot in the front, then do a backward fall
			else if( LocalHitDir.X >= 0.f && PawnOwner.DeathAnimHighBwd.Length != 0 )
			{
				BS_DeathAnim.Stance.Length = 1; // Array of struct needs to be pre-sized.
				BS_DeathAnim.Stance[0].Slot = BS_FullBody;
				BS_DeathAnim.Stance[0].AnimName = PickDeathAnimationFromList(PawnOwner.DeathAnimHighBwd, MyGRI.LastDeathAnimHighBwdIndex);
				bRotateToShotDir = TRUE;
				bPickedDeathAnimation = TRUE;
				ShotRotation.Yaw = Rotator(WorldHitX).Yaw;
			}

			`if(`notdefined(FINAL_RELEASE))
			if( bDebug )
			{
				if( bPickedDeathAnimation )
				{
					`log(PawnOwner.WorldInfo.TimeSeconds @ PawnOwner @ class @ GetFuncName() @ "Picked a High Kick death animation." @ BS_DeathAnim.Stance[0].AnimName @ "LocalHitDir:" @ LocalHitDir);
				}
				else
				{
					`log(PawnOwner.WorldInfo.TimeSeconds @ PawnOwner @ class @ GetFuncName() @ "Has empty DeathAnimHighFwd or DeathAnimHighBwd couldn't play high kick death animation."  @ "LocalHitDir:" @ LocalHitDir);
				}
			}
			`endif
		}

		// Pick a standard kill animation (for standard weapons).
		if( TRUE )
		{
			// See if we can play a death from the side first, these are less common than Fwd/Bwd deaths
			// If the Pawn doesn't have sideways deaths, we can always fall back to Fwd/Bwd.
			if( !bPickedDeathAnimation && bShotFromSide )
			{
				// See if Pawn got Shot from left, then do right fall
				if( LocalHitDir.Y < 0.f && PawnOwner.DeathAnimStdRt.Length != 0 )
				{
					BS_DeathAnim.Stance.Length = 1; // Array of struct needs to be pre-sized.
					BS_DeathAnim.Stance[0].Slot = BS_FullBody;
					BS_DeathAnim.Stance[0].AnimName = PickDeathAnimationFromList(PawnOwner.DeathAnimStdRt, MyGRI.LastDeathAnimStdRtIndex);
					bRotateToShotDir = TRUE;
					bPickedDeathAnimation = TRUE;
					ShotRotation.Yaw = Rotator(WorldHitY).Yaw;
				}
				// See if Pawn got Shot from right, then do left fall
				else if( LocalHitDir.Y >= 0.f && PawnOwner.DeathAnimStdLt.Length != 0 )
				{
					BS_DeathAnim.Stance.Length = 1; // Array of struct needs to be pre-sized.
					BS_DeathAnim.Stance[0].Slot = BS_FullBody;
					BS_DeathAnim.Stance[0].AnimName = PickDeathAnimationFromList(PawnOwner.DeathAnimStdLt, MyGRI.LastDeathAnimStdLtIndex);
					bRotateToShotDir = TRUE;
					bPickedDeathAnimation = TRUE;
					ShotRotation.Yaw = Rotator(-WorldHitY).Yaw;
				}
			}

			// Fwd/Bwd deaths
			if( !bPickedDeathAnimation )
			{
				// See if Pawn got shot in the back, then do forward fall
				if( LocalHitDir.X < 0.f && PawnOwner.DeathAnimStdFwd.Length != 0 )
				{
					BS_DeathAnim.Stance.Length = 1; // Array of struct needs to be pre-sized.
					BS_DeathAnim.Stance[0].Slot = BS_FullBody;
					BS_DeathAnim.Stance[0].AnimName = PickDeathAnimationFromList(PawnOwner.DeathAnimStdFwd, MyGRI.LastDeathAnimStdFwdIndex);
					bRotateToShotDir = TRUE;
					bPickedDeathAnimation = TRUE;
					ShotRotation.Yaw = Rotator(-WorldHitX).Yaw;
				}
				// See if Pawn got shot in the front, then do a backward fall
				else if( LocalHitDir.X >= 0.f && PawnOwner.DeathAnimStdBwd.Length != 0 )
				{
					BS_DeathAnim.Stance.Length = 1; // Array of struct needs to be pre-sized.
					BS_DeathAnim.Stance[0].Slot = BS_FullBody;
					BS_DeathAnim.Stance[0].AnimName = PickDeathAnimationFromList(PawnOwner.DeathAnimStdBwd, MyGRI.LastDeathAnimStdBwdIndex);
					bRotateToShotDir = TRUE;
					bPickedDeathAnimation = TRUE;
					ShotRotation.Yaw = Rotator(WorldHitX).Yaw;
				}
			}

			`if(`notdefined(FINAL_RELEASE))
			if( bDebug )
			{
				if( bPickedDeathAnimation )
				{
					`log(PawnOwner.WorldInfo.TimeSeconds @ PawnOwner @ class @ GetFuncName() @ "Picked a standard death animation." @ BS_DeathAnim.Stance[0].AnimName @ "LocalHitDir:" @ LocalHitDir);
				}
				else
				{
					`log(PawnOwner.WorldInfo.TimeSeconds @ PawnOwner @ class @ GetFuncName() @ "Couldn't find suitable std death animations!!"  @ "LocalHitDir:" @ LocalHitDir);
				}
			}
			`endif
		}

		// Play one shot death animation
		if( bPickedDeathAnimation )
		{
			PawnOwner.BS_Play(BS_DeathAnim, 1.25f, 0.2f, -1.f, bLoop, FALSE);
		}
		else
		{
			`Warn(PawnOwner.WorldInfo.TimeSeconds @ PawnOwner @ class @ GetFuncName() @ "Couldn't find a death animation to play! LocalHitDir:" @ LocalHitDir);
			// Do rag doll death instead.
			return FALSE;
		}

		// if we should rotate Pawn to match direction of shot, do so
		if( bRotateToShotDir )
		{
			`if(`notdefined(FINAL_RELEASE))
			if( bDebug )
			{
				PawnOwner.FlushPersistentDebugLines();
				PawnOwner.DrawDebugLine(PawnOwner.Location, PawnOwner.Location + Vector(PawnLookRotation) * 50,		255, 000, 000, TRUE);
				PawnOwner.DrawDebugLine(PawnOwner.Location, PawnOwner.Location + Vector(ShotRotation) * 50,			000, 255, 000, TRUE);
				PawnOwner.DrawDebugLine(PawnOwner.Location, PawnOwner.Location - PawnOwner.TearOffMomentum * 50,	000, 000, 255, TRUE);
			}
			`endif

			// @note laurent: Interpolation doesn't work. Probably physics mode, or tick not getting called when killed. Need to look into it.
			//SetFacePreciseRotation(ShotRotation, 0.2f);
			PawnOwner.SetRotation(ShotRotation);
		}
	}

	PawnOwner.EndSpecialMove();
	return TRUE;
}

defaultproperties
{
	bDebug=FALSE
}
