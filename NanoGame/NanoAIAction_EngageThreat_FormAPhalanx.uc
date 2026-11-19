/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_FormAPhalanx extends NanoAIAction_EngageThreatBase within NanoAI_Trooper;


var transient NanoFormation_Wall WallFormation;

/** Lock formation to the facing this target? */
var() transient Actor FormationLookTarget;

/** max members per row **/ 
var() int RowSize;

var() float SpacingBetweenFormationMembers;
var() float SpacingBetweenFormationRows;




static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;


	if( (	NanoGRI(InAI.WorldInfo.GRI).AIBlackboard.bDoPhalanx == TRUE ) || ( NanoAI(InAI).bPhalanxLeader == TRUE ) )
	{
		Retval = 90000;
		NanoGRI(InAI.WorldInfo.GRI).AIBlackboard.bDoPhalanx = FALSE;
	}


	return Retval;
}




function Pushed()
{ 
	Super.Pushed();

	bPhalanxLeader = TRUE;

	MakeOurPhalanx();
}

function Popped()
{ 
	Super.Popped();
}



function MakeOurPhalanx()
{
	local int NumJoined;

	local NanoAI AI;

	// make our formation
	SpawnFormation();

	AddAIToFormation( Outer );
	NumJoined++;

	// tell everyone else to JOIN UP!
	foreach Outer.WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( AI == Outer )
		{
			continue;
		}

		`log( "joining up! " );
		AddAIToFormation( AI );


		if( ++NumJoined == 4 )
		{
			break;
		}
	}
}



function AddAIToFormation( NanoAI AI )
{
	AI.bInFormation = TRUE;
	AI.ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_Defensive_MemberOfAFormation' );
	WallFormation.AddMember( AI );
}



function SpawnFormation()
{
	WallFormation = Spawn(class'NanoFormation_Wall',,, Pawn.Location);

	FormationLookTarget = NanoGRI(WorldInfo.GRI).GetPlayerPawn();

	if( FormationLookTarget != None )
	{
		WallFormation.LookAtGoal = FormationLookTarget;
		WallFormation.SetRotation(rotator(FormationLookTarget.Location - Location));
	}
	else
	{
		WallFormation.DesiredYaw = Rotation.Yaw;
	}

	`log(`location@`showvar(WallFormation.Rotation)@`showvar(Rotation));
	WallFormation.ColSpacing = SpacingBetweenFormationMembers;
	WallFormation.RowSpacing = SpacingBetweenFormationRows;
	WallFormation.SetRowSize(RowSize);
}





state MemberOfAFormation
{
	


Begin:

	`AILog( GetStateName()@"Begin TAG" );

	`log( "Oh yesss " );

	// let's move toward the foe!
	WallFormation.PathGoal = NanoGRI(WorldInfo.GRI).GetPlayerPawn();
	WallFormation.LookAtGoal = NanoGRI(WorldInfo.GRI).GetPlayerPawn();


	`log( "pushing PathToGoal on" @ `showvar(WallFormation) @ `showvar(WallFormation.PathGoal) );
 
	WallFormation.PushState( 'PathToGoal' );



	Sleep(2.f);
	Goto('Begin');
}



defaultproperties
{
	StartingStateName="MemberOfAFormation"

	SpacingBetweenFormationMembers=128.f
	SpacingBetweenFormationRows=256.f
	RowSize=2

}