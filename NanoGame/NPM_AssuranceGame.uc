/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NPM_AssuranceGame extends NanoProceduralMissionBase
	config(Game);



simulated function StartMission()
{
	`NPMMLog( " StartMission" @ self @ MissionLocation );

	PossiblyFireOffAssuranceGame();
}


function PossiblyFireOffAssuranceGame()
{
	local NanoGRI NGRI;
	local NanoMCP MCP;
	local string UserName;
	local array<string> UsersToChooseFrom;
	local MCPDatum Datum;
	local string AssuranceGamePartner;

	local String CurrValueString;

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	MCP = NGRI.MCP;
	UserName = class'NanoTypes'.static.GetLocalPlayerUserName();

	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGame, CurrValueString );

	// if we are already on one
	if( CurrValueString != "" )
	{
		return;
	}


	// set up the game
	foreach MCP.MCPData( Datum )
	{
		// not us
		if( UserName == Datum.ID )
		{
			continue;
		}

		// if they are not already in an assurance game
		MCP.FindStringValue( Datum.ID, class'NanoMCPKeys'.default.CurrentAssuranceGame, CurrValueString );

		// user is already on an assurance game
		if( CurrValueString != "" )
		{
			continue;
		}

		UsersToChooseFrom.AddItem( Datum.ID );
	}


	// no one avail
	if( UsersToChooseFrom.Length == 0 )
	{
		return;
	}


	AssuranceGamePartner = UsersToChooseFrom[Rand(UsersToChooseFrom.Length)];

	MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGamePartner, AssuranceGamePartner );

	MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGame, String(GetEnum(enum'EAssuranceGameType', EAGT_BullramOrProcMissions) ) );

	MCP.UpdateLocalMCPDatum( AssuranceGamePartner, class'NanoMCPKeys'.default.CurrentAssuranceGamePartner, UserName );

	MCP.UpdateLocalMCPDatum( AssuranceGamePartner, class'NanoMCPKeys'.default.CurrentAssuranceGame, String(GetEnum(enum'EAssuranceGameType', EAGT_BullramOrProcMissions) ) );


	NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_AssuranceGameStarted, 1 );

}




defaultproperties
{
	//RewardType=class'NPMR_Small'
	//ProcMissionTexture=Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_SupplyPile'

	//MissionParts_Rebels.Add( class'NPMP_Rebels_PlaceHolderMesh' )

	//MissionParts_MetaCorp.Add( class'NPMP_MetaCorp_Response_ThreeTrooper' )

}


