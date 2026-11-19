/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_InterrogateVictim extends NSM_DBNO_InteractionVictimBase;


// we don't want to play any of the "ending" animations and other code when we end the special move so go back to DBNO if we end this
// e.g. interrogation should end with the guy giving up info and bleeding out or dying
function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	if( MyNP.Health > 0 )
	{
		MyNP.PendingSpecialMoveStruct = MyNP.FillSpecialMoveStructFromParams( 'NSM_DBNO' );
	}
	else
	{
		if( NanoPawn_Infantry(MyNP).DBNO_DurationTilBleedOutDeath > 0 )
		{
			`log( "back to dbno idle anim" );
			HACK_BlendBackToIdle();
		}
		else
		{
			`log( "pawn was killed" );
			MyNP.ClearTimer( nameof(PlayGrabbedLoopAnimation), self );
			MyNP.ClearTimer( nameof(FinishSpecialMove), self );

			MyNP.Died( MyNP.ControllerWhoPutMeDBNO, class'NDT_DBNO_Death', MyNP.Location );
			//MyNP.FullBodySlot.StopCustomAnim( 0.25f );
			MyNP.Mesh.RootMotionMode = MyNP.default.Mesh.RootMotionMode;
			MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
		}

	}	
}


function HACK_BlendBackToIdle()
{
	MyNP.FullBodySlot.PlayCustomAnim( 'DBNO_Interrogate_Idle', GetSpeedModifier(), 0.0f, 0.1f, TRUE, TRUE );
}




defaultproperties
{
	VictimGrabSuccessStartAnim="DBNO_Interrogate_Enter"
	VictimGrabSuccessLoopAnim="DBNO_Interrogate_Idle"
	VictimGrabReleaseAnim="DBNO_Interrogate_Idle"
	VictimGrabEscapeAnim="DBNO_Interrogate_Idle"
}
