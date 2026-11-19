/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NPM_MetaCorpLimo extends NanoProceduralMissionBase
	config(Game);



simulated function StartMission()
{
	`NPMMLog( " StartMission" @ self @ MissionLocation );

	StartUpMissionParts( MissionParts_Rebels );

	StartUpMissionParts( MissionParts_MetaCorp );
}





defaultproperties
{
	RewardType=class'NPMR_Small'

	MissionParts_Rebels.Add( class'NPMP_Rebels_PlaceHolderMesh' )

	//MissionParts_MetaCorp.Add( class'NPMP_MetaCorp_Response_ThreeTrooper' )

}


