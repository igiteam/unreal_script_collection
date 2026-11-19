/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_MessengerCallForPackagePickup extends NanoAICmd within NanoAI;


var protected transient float DelayToWaitForPickup;

var protected transient NanoProceduralMissionRewardBase RewardToGive; 


static function bool CallForPackagePickup( NanoAI AI, float InDelay, NanoProceduralMissionRewardBase InRewardToGive )
{
	local NanoAICmd_MessengerCallForPackagePickup Cmd;

	if( AI != None )
	{
		Cmd = new(AI) Default.Class;
		if( Cmd != None )
		{
			Cmd.DelayToWaitForPickup = InDelay;
			Cmd.RewardToGive = InRewardToGive;
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}



/** 
 *  So we will push this onto the Stack and then only when it is is resumed 
 *  will we actually call for our friend to come and meet with us.
 *  
 **/
function Resumed( Name OldCommandName )
{
	if( Pawn != none )
	{
	    `log( "Calling for friend!!" );
    	CallForFriendToComeAndPickUpPackage();
	}

	Super.Resumed( OldCommandName );
}


/** 
 * This will spawn a metacorp guy to come and pick up the package.
 *  
 **/
function CallForFriendToComeAndPickUpPackage()
{
	local Vector PackagePickUpSpawnLoc;
	local NanoAI_Trooper AI;
	local Vector LocationToActallyMoveTo;


	// @TODO:  so here we can recurse! and bring another messenger out instead of the captain.
	// this will allow us to keep having the quest run and run for harder "difficulty"


	PackagePickUpSpawnLoc = NanoGRI(WorldInfo.GRI).NPES.FindSpawnLocation_Messenger( class'NanoPawn_MetaCorp_RiotCop_Captain', Pawn.Location );
	AI = NanoAI_Trooper(NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop_Captain', ESM_SpawnAroundCornerOutOfSight, FALSE, PackagePickUpSpawnLoc ));

	if( AI != none )
	{
		NanoPawnBase(AI.Pawn).AddProceduralMisisonReward( RewardToGive ); // give the reward the dude picking up the package

		class'NanoAICmd_PickUpMessengerPackage'.static.PickUpPackage( AI, Outer, Pawn.Location );
		
        //class'NanoAICmd_Move_UntilReachable'.static.MoveToPoint( AI, Pawn.Location );

		// all of these move to commands are lame in that they don't take an episilon for how close you have to be to the place

		LocationToActallyMoveTo = Pawn.Location + ( vector(Pawn.Rotation) * 64.0f );

		AI.MoveToLocation( LocationToActallyMoveTo, 5.0f, TRUE );  // here we need to send them to the spawn location which the player can see
		//AI.MoveToActor( Pawn, 5.0f, TRUE );  // here we need to send them to the spawn location which the player can see
		DrawDebugCoordinateSystem( LocationToActallyMoveTo , rot(0,0,0), 10.0f, TRUE );
	}

}



defaultproperties
{
}


