/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSavedMove extends SavedMove;

var int DashPip;
var bool bIsJumpMove;
var bool bHoldingJump;
var int LastJumpLevel;
var vector LastWallJumpNormal;
var bool bLastJumpWasForward;
var vector JumpStickDir;

var bool bIsDashMove;
var bool bIsBamfing;

var bool bIsAttachedToWallMove;
var float WallStabThrottle;
var vector SwordAttachDir;



function bool IsImportantMove(vector CompareAccel)
{
	return DashPip >= 0 || bIsJumpMove || Super.IsImportantMove(CompareAccel);
}

function bool CanCombineWith(SavedMove NewMove, Pawn InPawn, float MaxDelta)
{
	local NanoPawn NP;
	local NanoSavedMove NanoMove;
	local NanoSpecialMove SpecialMove;

	NP = NanoPawn(InPawn);
	NanoMove = NanoSavedMove(NewMove);
	SpecialMove = NP.ActiveSpecialMove;

	return ((NanoMove == None || (NanoMove.DashPip == DashPip && !bIsJumpMove && !NanoMove.bIsJumpMove))    // Don't combine dash or jump moves
			&& !NP.IsAttachedToPerch()                                                                        // Don't combine when we're locked to a platform
			&& (SpecialMove == None || !SpecialMove.bUseUnsynchedServerMove)                                // Don't combine during unsynched moves
			&& Super.CanCombineWith(NewMove,InPawn,MaxDelta));
}

function SetMoveFor(PlayerController P, float DeltaTime, vector NewAccel, EDoubleClickDir InDoubleClick)
{
	local NanoPawn NP;
	local NanoSkill_Dash DashSkill;
	local NanoSkill_Jump JumpSkill;
	local vector CamLoc;
	local rotator CamRot;

	NP = NanoPawn(P.Pawn);
	if(NP != None)
	{
		// Check for jump
		bIsJumpMove = NP.bIsJumping && (NP.Physics != PHYS_None);
		if( bIsJumpMove )
		{
			JumpSkill = NP.GetActiveSkill(class'NanoSkill_Jump');
			bHoldingJump = (NP.JumpHoldTime > 0.f);
			LastJumpLevel = JumpSkill.LastJumpLevel;
			LastWallJumpNormal = NP.LastWallJumpNormal;
			bLastJumpWasForward = NP.bLastJumpWasForward;

			P.GetActorEyesViewPoint(CamLoc,CamRot);
			JumpStickDir.X = P.PlayerInput.RawJoyRight;
			JumpStickDir.Y = P.PlayerInput.RawJoyUp;
			JumpStickDir = JumpStickDir >> CamRot;
		}
		else
		{
			bIsJumpMove = FALSE;
		}
		
		// Check for dash
		bIsDashMove = NP.bIsDashing;
		if( bIsDashMove )
		{
			DashSkill = NP.GetActiveSkill(class'NanoSkill_Dash');
			if (DashSkill != None)
			{
				DashPip = DashSkill.CurrentDashPip;
			}

			bIsBamfing = NP.bIsBamfing;
		}
		
		// Check for attached to wall
		bIsAttachedToWallMove = NP.bIsAttachedToWall;
		WallStabThrottle = NP.WallStabThrottle;
		SwordAttachDir = -NP.WallAttachNormal;
	}
	else
	{
		DashPip = -1;		
		bIsJumpMove = FALSE;	
		bIsAttachedToWallMove = FALSE;
	}

	Super.SetMoveFor(P,DeltaTime,NewAccel,InDoubleClick);

	bForceRMVelocity = bForceRMVelocity || (NP != None && NP.MantleState != MANTLE_None);
}

defaultproperties
{
	DashPip=-1
}
