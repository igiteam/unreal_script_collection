/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_FaceShield extends GearSpecialMove
	config(Pawn);

/** Body stance to shield your face */
var() GearPawn.BodyStance BS_FaceShield;

/**
 * Play the animation loop and set a timer to stop it
 * 
 * @param bForced - whether the special move was forced
 * 
 * @param PrevMove - the last special move
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	PawnOwner.BS_Play(BS_FaceShield, 1.0f, 0.2f, 0.1f, TRUE, TRUE, 'RunWalk');
		
	if (PawnOwner.Role == ROLE_Authority)
	{
		PawnOwner.SetTimer(1.5f, FALSE, nameof(Self.FaceShieldDone), Self);
	}
}

/** End the special move */
function FaceShieldDone()
{
	PawnOwner.ServerEndSpecialMove();
}

/**
 * Stop the animation
 * 
 * @param PrevMove - the last special move
 * 
 * @param NextMove - the next special move
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Stop cringe anims, play the end cringe animation.
	PawnOwner.BS_Stop(BS_FaceShield, 0.2f);
	
	PawnOwner.ClearTimer(nameof(Self.FaceShieldDone));

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_FaceShield={(Stance=(
		(Slot=BS_Layer_Stand_Idle_Idle,AnimName="ADD_Bright_Light"),
		(Slot=BS_Layer_Stand_Walk_Idle,AnimName="ADD_AR_Walk_React_Bright_Light"),
		(Slot=BS_Layer_Stand_Run_Idle,AnimName="ADD_AR_Run_React_Bright_Light"))
		)}

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE

	bBreakFromCover=TRUE

	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
}