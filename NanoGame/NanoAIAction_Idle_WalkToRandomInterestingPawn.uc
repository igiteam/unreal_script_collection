/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_WalkToRandomInterestingPawn extends NanoAIAction_IdleBase within NanoAI;




static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	local array<NanoInterface_PatrolDestination> TheList;

	TheList = GetPatrolList( InAI );

	if( TheList.Length > 0 )
	{
		Retval = default.UtilityStartVal + 30;
		//`AILog_Ext( "NanoAIAction_Idle_PatrolARoute" @ GetPatrolList( InAI ).Length,, InAI );
	}

	return Retval;
}


function static array<NanoInterface_PatrolDestination> GetPatrolList( NanoAIBase InAI )
{
	local NanoPawnBase P;
	local NanoInterface_PatrolDestination NIPD;
	local float Dist;
	local array<NanoInterface_PatrolDestination> PatrolList;
	local vector PatrolDest;


	foreach class'WorldInfo'.static.GetWorldInfo().AllPawns( class'NanoPawnBase', P )
	{
		//`AILog_Ext( " CHECKING" @ P ,, InAI );

		NIPD = NanoInterface_PatrolDestination(P);
		if( NIPD != None ) 
		{
			NIPD.GetPatrolDestination( PatrolDest );

			Dist = VSize(PatrolDest-InAI.Pawn.Location);
			if( Dist > 512.f && Dist < 8192.f )
			{
				PatrolList[PatrolList.Length] = NIPD;
				//`AILog_Ext( "  Adding" @ P ,, InAI );
			}
			else
			{
				//`AILog_Ext( "  Not In Range!" @ P @ `showvar(Dist) ,, InAI );
			}
		}
		else
		{
			//`AILog_Ext( "  Not a NIPD" @ P ,, InAI );
		}
	}

	return PatrolList;
}



state WalkToInterestingPawn extends Idle
{
	function BeginState(Name PrevStateName)
	{
		Super.BeginState( PrevStateName );
	}

	function EndState(Name NextStateName)
	{
		Super.EndState( NextStateName );
	}

	function PickNewAction()
	{
		local NanoInterface_PatrolDestination NIPD;
		local array<NanoInterface_PatrolDestination> PatrolList;

		local Vector PatrolDest;

		PatrolList = GetPatrolList( Outer );

		NIPD = PatrolList[Rand(PatrolList.Length)];
		`AILog( "Out of a list of"@PatrolList.Length@"selected"@NIPD );
		if( NIPD != None && NIPD.GetPatrolDestination(PatrolDest) )
		{
			MoveToLocation( PatrolDest );
		}
	}

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	Sleep(1.f);


	PickNewAction();

	Goto('Begin');

}




defaultproperties
{
	StartingStateName="WalkToInterestingPawn"
}