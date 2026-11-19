/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_InteractionAttemptBase extends NanoSpecialMove
	abstract;

var transient   NanoPawn	GrabVictimPawn;
var transient Name	AttackerGrabAttemptAnim;

var transient Name SpecialMoveEnemyToDo;


/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	if( NewMove == 'NSM_Melee_HitReaction' )
	{
		//`log( GetFuncName() @ "HitReaction!!" );
		return TRUE;
	}

	//`log( GetFuncName() @ `showvar(NewMove) );

	return FALSE;
}


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	PlayGrabAttemptAnimation();
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.ClearTimer( nameof(FinishGrabAttempt), self );

	MyNP.FullBodySlot.StopCustomAnim( 0.1f );

	Super.SpecialMoveEnded( PrevMove, NextMove );
}

function PlayGrabAttemptAnimation()
{
	local float AnimTime;
	local float BlendInTime;

	// Stop running animations
	MyNP.RunningFullBodySlot.StopCustomAnim(0.f);
	MyNP.FallingFullBodySlot.StopCustomAnim(0.f);
	MyNP.ZeroMovementVariables();

	// Ignore root motion for other slot anim so blend doesn't cause a pop
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	// Play anim and return duration
	BlendInTime = 0.1f;
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( AttackerGrabAttemptAnim, GetSpeedModifier(), BlendInTime, -1.f, FALSE, TRUE );
	if( AnimTime <= 0.f )
	{
		`log( `location@"ERROR: got invalid anim time" );
		// Failsafe to make sure timers don't break;
		AnimTime = 0.01;
	}

	// Setup root motion
	MyNP.Mesh.RootMotionMode = RMM_Accel;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );

	//MyNP.SetTimer( AnimTime, FALSE, nameof(FinishGrabAttempt), self );


	`log( `showvar(MyNP.InteractionPawn) );

	MyNP.DoSpecialMove( SpecialMoveEnemyToDo, TRUE, MyNP.InteractionPawn );

}

function FinishGrabAttempt()
{
	MyNP.EndSpecialMove();
}

function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	CheckAbortGrabAttempt();
}

function CheckAbortGrabAttempt()
{
	local float Dist2D;
	local NanoPawn VictimPawn;
	local bool bAbort;
	local NanoWeap_Melee Weap;

	Weap = NanoWeap_Melee(MyNP.Weapon);

	if( Weap.bSlashDamaging )
	{
		VictimPawn = NanoPawn(Weap.ComboTargetedActor);
		if( VictimPawn != None )
		{
			VictimPawn.LastGrabbedTime = MyNP.WorldInfo.TimeSeconds;
		}
		MyNP.LastGrabAttemptTime = MyNP.WorldInfo.TimeSeconds;
	}
	else
	{
		VictimPawn = NanoPawn(Weap.ComboTargetedActor);
		if( VictimPawn != None && VictimPawn.Physics != PHYS_Falling && VictimPawn.InteractionPawn == None )
		{
			Dist2D = VSize2D(MyNP.Location - VictimPawn.Location);
			if( Dist2D > Weap.WeaponRange )
			{
				bAbort = TRUE;
			}
		}
		else
		{
			bAbort = TRUE;
		}

		if( bAbort )
		{
			FinishGrabAttempt();
		}
	}
}


defaultproperties
{

}
