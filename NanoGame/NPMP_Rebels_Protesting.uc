/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NPMP_Rebels_Protesting extends NanoProceduralMissionPartBase;







function AttemptToStartMissionPart()
{
	local NanoAI RabbleRouser;

	local Vector MessengerSpawnLoc;

	`log( "NPMP_Rebels_Protesting ");


	// to spawn this guy out of the way and then have him run to the spawn location
	// update the HUD
	// then have him take off running to some point on the navmesh where his end point is
	//Spawn( class'NanoPawn_MetaCorp_Messenger', self,, SpawnLocation, );

	MessengerSpawnLoc = NanoGRI(WorldInfo.GRI).NPES.FindSpawnLocation_Messenger( class'NanoPawn_Rebels_PublicRabbleRouser', MissionLocation );
	`NPMMLog( "MessengerSpawnLoc" @ MessengerSpawnLoc );

	//DrawDebugLine( MessengerSpawnLoc, NanoGRI(WorldInfo.GRI).NPES.GetPlayerLocation(), 128, 128, 0, TRUE );


	if( VSize(MessengerSpawnLoc) == 0 )
	{
		`NPMMLog( " no MessengerSpawnLoc"  );
		return;
	}

	// we need to change SpawnAIType to not always sent the AI at the player
	// need to change the FindSpawnLocation code to be our own or more templatized
	RabbleRouser = NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_Rebels_PublicRabbleRouser', ESM_SpawnAroundCornerOutOfSight, FALSE, MessengerSpawnLoc );

	if( RabbleRouser != none )
	{
		RabbleRouser.SetTeam( 0 );
		NanoAI_Rebels_RabbleRouser(RabbleRouser).LocationToRabbleRouse = MissionLocation;

		// need to update the HUD here
		NanoGRI(WorldInfo.GRI).NPMM.AddMissionManagerObjectives( RabbleRouser.Pawn );

		Mission.Spawned_Rebels.AddItem( RabbleRouser );

		bCompleted = TRUE;
	}

}




defaultproperties
{

}