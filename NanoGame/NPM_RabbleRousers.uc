/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NPM_RabbleRousers extends NanoProceduralMissionBase
	config(Game);



simulated function StartMission()
{
	`NPMMLog( " StartMission" @ self @ MissionLocation );
	//DrawDebugCoordinateSystem( MissionLocation, rot(0,0,0), 50, TRUE );

	StartUpMissionParts( MissionParts_Rebels );

	StartUpMissionParts( MissionParts_MetaCorp );

}




defaultproperties
{
	RewardType=class'NPMR_Small'

	MissionParts_Rebels.Add( class'NPMP_Rebels_Protesting' )

	MissionParts_MetaCorp.Add( class'NPMP_MetaCorp_Response_ThreeTrooper' )
}

/*

-make alert be an AICmd  
   -make certain it does not break anything


-delay the call / change up how the response to the rabble rouser works  
   -so like:
       -miscreant taks (rabble rouser, grafitti painter)
	   -then a response to the task  (squad, tattler, drop ship, etc)

*/

