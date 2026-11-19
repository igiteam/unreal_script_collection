/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_SkyPatrol extends NanoAI_Trooper;

var NanoPawn_MetaCorp_SkywayPatrol SkyPatrol;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);

	SkyPatrol = NanoPawn_MetaCorp_SkywayPatrol(Pawn);

	class'BoidRule_SkyPatrolHeight'.static.AddRule( self );
}


function MoveToActor( Actor NewMoveActor, optional float MaxMoveTime, optional bool NewbFaceFocus = TRUE )
{
	class'NanoAICmd_Move_Flight'.static.MoveToActor( self, NewMoveActor );
}

function MoveToLocation( vector NewMoveLocation, optional float MaxMoveTime, optional bool NewbFaceFocus = TRUE )
{
	class'NanoAICmd_Move_Flight'.static.MoveToPoint( self, NewMoveLocation );
}

function HandleBoidAlteringEvent( Name EventName, bool bEnableBoids )
{
	local int Idx;
	if( EventName == 'WaitingForAttackToFinish' )
	{
		for( Idx = 0; Idx < BoidRules.Length; Idx++ )
		{
			BoidRules[Idx].SetActive( bEnableBoids );
		}
	}
	else
	{
		Super.HandleBoidAlteringEvent( EventName, bEnableBoids );
	}	
}

state Idle_Patrol
{
	function PickNewAction()
	{
		local NanoInterface_PatrolDestination NIPD;
		local array<NanoInterface_PatrolDestination> PatrolList;
		local NanoPawnBase	P;
		local float Dist;
		local Vector PatrolDest;
		
		foreach WorldInfo.AllPawns( class'NanoPawnBase', P )
		{
			NIPD = NanoInterface_PatrolDestination(P);
			if( NIPD != None ) 
			{
				Dist = VSize(P.Location-Pawn.Location);
				if( Dist > 512.f )
				{
					PatrolList[PatrolList.Length] = NIPD;
				}
			}
		}

		NIPD = PatrolList[Rand(PatrolList.Length)];
		`AILog( "Out of a list of"@PatrolList.Length@"selected"@NIPD );
		if( NIPD != None && NIPD.GetPatrolDestination(PatrolDest) )
		{
			MoveToLocation( PatrolDest );
		}
	}

Begin:
	`AILog( GetStateName()@"Begin TAG" );
	PickNewAction();
	Sleep(1.f);
	Goto('Begin');
}

function PrepareForFlight()
{
	SkyPatrol.StartFlying();
	SetActiveBoidMovementByClass( class'BoidRule_SkyPatrolHeight', TRUE );
}

function PrepareForLanding()
{
	//todo - only want to do this for one time use jetpacks 
 	SkyPatrol.StopFlying();
 	SetActiveBoidMovementByClass( class'BoidRule_SkyPatrolHeight', FALSE );
}

state Alert 
{
	function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);
		PrepareForFlight();
	}

	function bool ShouldTransitionToCombat()
	{
		if( class'NavigationHandle'.static.GetPylonFromPos( SkyPatrol.Location ) == None )
		{
			return FALSE;
		}

		// @todo fix this guy's alert state up
		//return Super.ShouldTransitionToCombat();
	}
}

state Combat
{
	function PickNewAction()
	{
		PossiblyPickFireTarget();

		`AILog( GetFuncName()@FireTarget@bHasBaton );

		if (FireTarget != None)
		{
			NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_StopPlayer,Pawn);
			if((!bHasBaton || VSize2D(FireTarget.GetTargetedLocation() - Pawn.Location) > 384.f))
			{
				GotoState('Combat_RangedAttack');
			}
			else
			{
				GotoState('Combat_MeleeAttack');
			}
		}
	}
}

state Combat_RangedAttack
{
	function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);

		PrepareForFlight();
	}

	function bool ShouldTransitionToMelee()
	{
		local StimulusQuery Query;
		local array<int> StimulusIndices;

		if (`TimeSince(TimeOfTransition) > 2.f)
		{
			Query.Visibility = QO_Require;
			Query.bAllowFriendly = FALSE;
			Query.bAllowNonFriendly = TRUE;
			Query.MinFOV = -1.f;
			Query.MaxFOV = -1.f;
			Query.MaxDist = 768.f;
			if (MultipleResultStimulusQuery(Query,StimulusIndices) > 0)
			{
				if (StimulusIndices.Length > 3)
				{
					return TRUE;
				}
				else
				{
					return FRand() < (StimulusIndices.Length/3.f);
				}
			}
		}
		return FALSE;
	}

	function PossiblyMoveToFireLocation()
	{
		local vector NewLocation, FireLineCross;
		NewLocation = Pawn.Location;
		if (FireTarget != None)
		{
			if ((bAttemptingToFireWeapon && FRand() > 0.85) || (!bAttemptingToFireWeapon && FRand() > 0.5f))
			{
				FireLineCross = Normal((FireTarget.GetTargetedLocation() - NewLocation) cross vect(0,0,1));
				if (FRand() > 0.5)
				{
					NewLocation += FireLineCross * RandRange(256.f,384.f);
				}
				else
				{
					NewLocation -= FireLineCross * RandRange(256.f,384.f);
				}
				if (VSize2D(FireTarget.GetTargetedLocation() - NewLocation) < 512.f)
				{
					NewLocation += Normal(NewLocation - FireTarget.GetTargetedLocation()) * 256.f;
				}
			}
			if (NewLocation != Pawn.Location)
			{
				MoveToLocation( NewLocation, 3.f, TRUE );
			}
		}
	}
}


defaultproperties
{
	bHasBaton=FALSE
}
