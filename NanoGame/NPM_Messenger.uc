/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NPM_Messenger extends NanoProceduralMissionBase
	config(Game);



simulated function StartMission()
{
	local Vector MessengerSpawnLoc;
	local Vector MessengerDestinationLoc;
	local NanoAI AI;
	local NanoProceduralMissionRewardBase RewardToGive;

	`NPMMLog( " StartMission" @ self @ MissionLocation );
	//DrawDebugCoordinateSystem( SpawnLocation, rot(0,0,0), 50, TRUE );

	// to spawn this guy out of the way and then have him run to the spawn location
	// update the HUD
	// then have him take off running to some point on the navmesh where his end point is
	//Spawn( class'NanoPawn_MetaCorp_Messenger', self,, SpawnLocation, );
	
	MessengerSpawnLoc = NanoGRI(WorldInfo.GRI).NPES.FindSpawnLocation_Messenger( class'NanoPawn_MetaCorp_Messenger', MissionLocation );
	`NPMMLog( "MessengerSpawnLoc" @ MessengerSpawnLoc );

	//DrawDebugLine( MessengerSpawnLoc, NanoGRI(WorldInfo.GRI).NPES.GetPlayerLocation(), 128, 128, 0, TRUE );


	if( VSize(MessengerSpawnLoc) == 0 )
	{
		`NPMMLog( " no MessengerSpawnLoc"  );
		return;
	}

	// we need to change SpawnAIType to not always sent the AI at the player
	// need to change the FindSpawnLocation code to be our own or more templatized
    AI = NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_Messenger', ESM_SpawnAroundCornerOutOfSight, FALSE, MessengerSpawnLoc );

	if( AI != none )
	{
		AI.SetTeam( 1 );

		// need to update the HUD here
		NanoGRI(WorldInfo.GRI).NPMM.AddMissionManagerObjectives( AI.Pawn );

		// so tricky!
		// push AI move to messenger path

		MessengerDestinationLoc = NanoGRI(WorldInfo.GRI).NPES.FindLocation_MessengerDestination( class'NanoPawn_MetaCorp_Messenger', MissionLocation );
		`NPMMLog( "MessengerDestinationLoc" @ MessengerDestinationLoc );

		if( VSize(MessengerDestinationLoc) != 0 )
		{
			//DrawDebugLine( MessengerDestinationLoc, SpawnLocation, 255, 255, 255, TRUE );
			//DrawDebugCoordinateSystem( MessengerDestinationLoc, rot(0,0,0), 10.0f, TRUE );

			//AI.MoveToLocation( MessengerDestinationLoc ); // head out to the destination
			RewardToGive = Spawn( RewardType );
			class'NanoAICmd_MessengerCallForPackagePickup'.static.CallForPackagePickup( AI, 5.0f, RewardToGive );
			class'NanoAICmd_MessengerPath'.static.MoveTo( AI, MessengerDestinationLoc );
		}
		else
		{
			`NPMMLog(" NO Destination found!!! :-(" );
		}

		class'NanoAICmd_Pause'.static.Pause( AI, 5.0f ); // wait a bit
		AI.MoveToLocation( MissionLocation );  // here we need to send them to the spawn location which the player can see				
	}
}




defaultproperties
{
	RewardType=class'NPMR_Small'
}

