/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO extends NSM_StunnedAndDazed;


var array<name> EnterDBNOAnimList;


/**
 * Don't allow hit reactions to move our DBNO guy.  He is DBNO!  This stops race condition of going DBNO but still being "hit" and the special
 * move not triggering fast enough and having a hit reaction queued up which kicks us out of DBNO.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	if( NewMove == 'NSM_Melee_HitReaction' )
	{
		return FALSE;
	}

	return Super.CanOverrideMoveWith( NewMove );
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local float AnimTime;

	Super.SpecialMoveStarted( bForced, PrevMove );

	// we are assuming there is a HitReaction on the pawn that this was triggered from
	// if for some reason there was not, just use the default Duration.
	if( MyNP.HitReaction.PostHitReactionStunTime != 0.0f )
	{
		Duration = MyNP.HitReaction.PostHitReactionStunTime;
	}

	if( MyNP.HitReaction.PostHitReactionStunAnimName != '' )
	{
		AnimName = MyNP.HitReaction.PostHitReactionStunAnimName;
	}

	// turn off the bzzztzt bzzzzzt sound from the baton
	if( NanoWeap_Baton(MyNP.Weapon) != None )
	{
		NanoWeap_Baton(MyNP.Weapon).KillElectricitySound();
	}


	// this is busted in some way
	//AnimTime = PlayAnimation_EnterDBNO();

	AnimTime = 0.001f;

	MyNP.SetTimer( AnimTime, FALSE, nameof(PlayAnimation), self );

	//`log( `showvar(Duration) @ `showvar(MyNP.HitReaction.PostHitReactionStunTime) );
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.ClearTimer( nameof(PlayAnimation), self );

	//CachedSlot.StopCustomAnim( 0.1f );

	// if the pawn is not dead then shake it off
	if( MyNP.IsInState( 'Dying' ) == FALSE )
	{
		MyNP.DoSpecialMove( 'NSM_ShakeItOff', TRUE );
	}

}


/**
 * @return float the length of the animation being played
 **/
function float PlayAnimation_EnterDBNO()
{
	local AnimNodeSequence Seq;
	local float AnimTime;
	local float AnimRate;

	AnimRate = GetSpeedModifier();

	// Ignore root motion for other slot anim so blend doesn't cause a pop
	CachedSlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	AnimTime = CachedSlot.PlayCustomAnim( GetDBNOAnimName(), AnimRate, 0.1f, -1.f, bLooping, TRUE, StartTime, EndTime );
	AnimTime -= (AnimPosition * AnimRate);
	AnimTime = FMax( AnimTime, 0.1f );

	Seq = CachedSlot.GetCustomAnimNodeSeq();
	Seq.SetPosition( AnimPosition, TRUE );
	
	// Setup root motion
	MyNP.Mesh.RootMotionMode = RMM;
	CachedSlot.SetRootBoneAxisOption( RBA_X, RBA_Y, RBA_Z );

	return AnimTime;
}


function name GetDBNOAnimName()
{
	return EnterDBNOAnimList[Rand(EnterDBNOAnimList.Length)];
}



DefaultProperties
{
	EnterDBNOAnimList.Add( "DBNO_Enter_A" )
	EnterDBNOAnimList.Add( "DBNO_Enter_B" )
	
	bAutoPlayAnimation=FALSE

	AnimName="DBNO_Idle"
	bLooping=FALSE
	EndTime=0.0f

	bDisableMovement=TRUE
	RootMotionScaleFactor=0.0f
}
