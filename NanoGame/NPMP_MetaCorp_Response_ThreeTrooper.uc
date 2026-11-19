/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NPMP_MetaCorp_Response_ThreeTrooper extends NanoProceduralMissionPartBase;






function AttemptToStartMissionPart()
{
	local Vector MessengerSpawnLoc; // shit
	local Vector TrooperSpawnLoc; 

	local NanoAI_Trooper TroopLeader;

	local Vector OverrideExtent;

	//local NanoAI RabbleRouser;
	//local array<NanoAI> TargetsToApprehend;

	//local NanoProceduralMissionRewardBase RewardToGive;


	// okie now let's spawn the captain

	`log( "SPAWN THE CAPTAIN!" ); 


	OverrideExtent.x = class'NanoPawn_MetaCorp_RiotCop_Captain'.default.CylinderComponent.CollisionRadius * 2;
	OverrideExtent.Y = class'NanoPawn_MetaCorp_RiotCop_Captain'.default.CylinderComponent.CollisionRadius * 2;
	OverrideExtent.Z = class'NanoPawn_MetaCorp_RiotCop_Captain'.default.CylinderComponent.CollisionHeight;

	// so now spawn some Troopers to run over there and stop the rabble rousers
	TrooperSpawnLoc = NanoGRI(WorldInfo.GRI).NPES.FindSpawnLocation_Messenger( class'NanoPawn_MetaCorp_RiotCop_Captain', MissionLocation, MessengerSpawnLoc, OverrideExtent );
	TroopLeader = NanoAI_Trooper(NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop_Captain', ESM_SpawnAroundCornerOutOfSight, FALSE,  TrooperSpawnLoc ));

	// this is brokesauce!!!!!   my cylinder is in the wall!!!

	DrawDebugCylinder( TrooperSpawnLoc-(Vect(0,0,1)*OverrideExtent.Z), TrooperSpawnLoc + (Vect(0,0,1)*OverrideExtent.Z), OverrideExtent.Y, 10, 255, 0, 0, TRUE );
	DrawDebugCoordinateSystem( TrooperSpawnLoc, rot(0,0,0), 50.0f, TRUE );
	`log( `showvar(OverrideExtent) @ `showvar(TrooperSpawnLoc) @ `showvar(TroopLeader) );

	if( TroopLeader != none )
	{
		`log( "TroopLeader" @ TroopLeader );
		DrawDebugLine( TroopLeader.Pawn.Location, MissionLocation, 255, 0, 0, TRUE );
		TroopLeader.Formation = Spawn(class'NanoFormation_Wall',,,,TroopLeader.Pawn.Rotation);
		NanoFormation_Wall(TroopLeader.Formation).DesiredRowSize = 2;
		//NanoFormation_Wall(TroopLeader.Formation).CalculateLocation();

		//TroopLeader.Formation.AddMember( TroopLeader );


		// so now spawn some pals for him
		// Trooper = NanoAI_Trooper(NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop', ESM_SpawnAroundCornerOutOfSight, TrooperSpawnLoc + vect(1.5,0,0)*class'NanoPawn_MetaCorp_RiotCop_Captain'.default.CylinderComponent.CollisionRadius ));
		//TroopLeader.Formation.AddMember( Trooper );
		//DrawDebugLine( Trooper.Pawn.Location, SpawnLocation, 0, 255, 0, TRUE );
		//`log( "Trooper" @ Trooper @ Trooper.Pawn.Location @ SpawnLocation );

		//Trooper = NanoAI_Trooper(NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop', ESM_SpawnAroundCornerOutOfSight, TrooperSpawnLoc + vect(0,1.5,0)*class'NanoPawn_MetaCorp_RiotCop_Captain'.default.CylinderComponent.CollisionRadius ));
		//TroopLeader.Formation.AddMember( Trooper );
		//DrawDebugLine( Trooper.Pawn.Location, SpawnLocation, 0, 255, 0, TRUE );
		//`log( "Trooper" @ Trooper @ Trooper.Pawn.Location @ SpawnLocation );

		//Trooper = NanoAI_Trooper(NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop', ESM_SpawnAroundCornerOutOfSight, TrooperSpawnLoc + vect(1.5,1.5,0)*class'NanoPawn_MetaCorp_RiotCop_Captain'.default.CylinderComponent.CollisionRadius ));
		//TroopLeader.Formation.AddMember( Trooper );
		//DrawDebugLine( Trooper.Pawn.Location, SpawnLocation, 0, 255, 0, TRUE );
		//`log( "Trooper" @ Trooper @ Trooper.Pawn.Location @ SpawnLocation );

		//RewardToGive = Spawn( Mission.RewardType );


// 		foreach Mission.Spawned_Rebels( RabbleRouser )
// 		{
// 			TargetsToApprehend.AddItem( RabbleRouser );
// 		}

	
		TroopLeader.ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_EngageThreat_Trooper_SmashDownRabbleRousers' );

		TroopLeader.MissionPart = self;


		bCompleted = TRUE;
	}
}





defaultproperties
{

}