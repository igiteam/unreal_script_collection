
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Wretch_PounceAttack_Siege extends GSM_Wretch_PounceAttack;

var protected const vector2d CameraTurnTime;

var float SteeringPct;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local rotator NewPlayerRot;
	local float YawDiff, Pct, CamTurnTime;
	local GearGameplayCamera Cam;
	local vector Direction, X, Y, Z;

   	Super.SpecialMoveStarted(bForced,PrevMove);

	// for players, turn to face direction he's trying to move
	if (PCOwner != None)
	{
		GetAxes(PCOwner.Rotation, X, Y, Z);

		// go in direction stick is pointing
		Direction = Normal((PCOwner.RemappedJoyUp * X) + (PCOwner.RemappedJoyRight * Y));

		// @fixme jf, using vel here is suboptimal, cuz it doesn't directly map to
		// player desires (like the stick does).  But using raw stick values doesn't
		// do well in multi, so coming up with something here would be good.
		// That is, if this iteration of roadie run survives. :)
		if (!IsZero(Direction)) // && (!bDisallowReverseTransitions || (vector(PCOwner.Rotation) dot Direction) > 0.0))
		{
			NewPlayerRot = Rotator(Direction);

			// figure how far we turned so we can turn the camera smoothly into the new orientation
			YawDiff = NormalizeRotAxis(PCOwner.Rotation.Yaw - NewPlayerRot.Yaw);

			// turn the player
			PCOwner.SetRotation( NewPlayerRot );
			PawnOwner.SetRotation( NewPlayerRot );
			PCOwner.AttemptMeleeAdhesion();

			// start executing a code-driven camera turn
			Cam = GearPlayerCamera(PCOwner.PlayerCamera).GameplayCam;
			if (Cam != None)
			{
				// some minor gymnastics here to find a function that feels good.
				// we want a snappier turn at 180, but we can tolerate a slower rate
				// closer to 0.  0.9 is the time to rotate at 180, and 0.6 is the
				// time to rotate at 0.
				Pct = Abs(YawDiff) / 32768.f;

				Pct = Sqrt(Pct);		// good feeling function
				CamTurnTime = GetRangeValueByPct(CameraTurnTime, Pct);

				Cam.BeginTurn(YawDiff, 0, CamTurnTime, 0.f);
			}
		}
	}
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	// strafe becomes turning
	Input.aTurn = (Input.aStrafe * SteeringPct);
	Input.aStrafe = 0.0;

	Super.PreProcessInput(Input);
}

defaultproperties
{
	bLockPawnRotation=false
	bBreakFromCover=true
	bDisableMovement=false
	bCanFireWeapon=false
	RootMotionScaleFactor=1.f

	RootBoneAxis_X=RBA_Translate
	RootBoneAxis_Y=RBA_Translate
	RootBoneAxis_Z=RBA_Translate

	SteeringPct=0.5f

	CameraTurnTime=(X=0.15f,Y=0.6f)
}
