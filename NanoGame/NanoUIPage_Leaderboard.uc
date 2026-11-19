/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_Leaderboard extends NanoUIPage_Base;

var transient array<String> LeadearboardCategories;
var transient int   SelectedLeaderboardIndex;



 /** Move selection to previous leaderboard */
 simulated function SelectPreviousLeaderBoard( NanoPawn NP )
 {
	SelectedLeaderboardIndex--;

	SelectedLeaderboardIndex = Max( SelectedLeaderboardIndex, 0 );
 }

 /** Move selection to next leaderboard*/
 simulated function SelectNextLeaderBoard( NanoPawn NP )
 {
	SelectedLeaderboardIndex++;

	SelectedLeaderboardIndex = Min( SelectedLeaderboardIndex, LeadearboardCategories.Length-1 );
 }

///// NanoUIPage_Base interface


function HandlePageInput(name ButtonName)
{
	 local NanoPawn NP;

	 NP = GetNanoPawn();
	 switch( ButtonName )
	 {
	 case 'DPad_Up':
		 SelectPreviousLeaderBoard(NP);
		 break;

	 case 'DPad_Down':
		 SelectNextLeaderBoard(NP);
		 break;
	 }
}

function PageShown()
{

}

function PageHidden()
{

}

function DrawPage()
{
	local String LeaderBoardID;
	local MCPDatum Datum;
	local int Idx;
	local float DrawX;
	local float DrawY;
	local string KeyWeAreLookingFor;
	local array<MCPDatum> LeaderBoardEntries;
	local NanoPawn NP;
	local Canvas Canvas;

	Canvas = NanoHUD.Canvas;
	NP = GetNanoPawn();

	Super.DrawPage();

	DrawX = PageUIOrigin.X + 20;
	DrawY = PageUIOrigin.Y + 20;

	// would be nice to do this once
	// populate the categories on the left
	LeadearboardCategories.Length = 0;
	foreach NanoGRI(NP.WorldInfo.GRI).MCP.MCPData( Datum )
	{
		// if it is a global key then don't add
		if( Datum.ID == "" )
		{
			continue;
		}

		if( Datum.Key == class'NanoMCPKeys'.default.RebelHandPrintLocation )
		{
			continue;
		}

		if( Datum.Key == class'NanoMCPKeys'.default.RebelHandPrintRotation )
		{
			continue;
		}

		// don't add if  ECET_
		if( InStr( Datum.Key, "ECET_") != INDEX_NONE )
		{
			continue;
		}


		if( LeadearboardCategories.Find( Datum.Key) == INDEX_NONE )
		{
			LeadearboardCategories.AddItem( Datum.Key );
		}
	}


	// draw out all of the categories on the left
	LeadearboardCategories.Sort(SortAlphabetize_String);

	foreach LeadearboardCategories( LeaderBoardID )
	{
		if( SelectedLeaderboardIndex == Idx )
		{
			Canvas.SetDrawColor(255, 255, 255, 255 );
		}
		else
		{
			Canvas.SetDrawColor(128, 128, 128, 255 );
		}

		Canvas.SetPos( DrawX, DrawY );
		Canvas.DrawText( LeaderBoardID, TRUE,,, TextRenderInfo );

		// move to next line
		DrawY += 20.0;

		
		Idx++;
	}

	// for each category get all of the datums
	KeyWeAreLookingFor = LeadearboardCategories[SelectedLeaderboardIndex];
	foreach NanoGRI(NP.WorldInfo.GRI).MCP.MCPData( Datum )
	{
		if( Datum.Key == KeyWeAreLookingFor )
		{
			if( Datum.Value != "" )
			{
				LeaderBoardEntries.AddItem( Datum );
			}
		}
	}

	// sort the datums
	LeaderBoardEntries.Sort(SortHighestToLowest_MCPDatum);


	// draw them out using the ID instead of Key
	Canvas.SetDrawColor(255, 255, 255, 255 );
	DrawX = PageUIOrigin.X + 20;
	DrawY = PageUIOrigin.Y + 20;

	DrawX += 200;

	foreach LeaderBoardEntries( Datum )
	{
		DrawKeyValue( DrawX, DrawY, Datum.ID, Datum.Value );
	}

}

defaultproperties
{
	PageName="LEADERBOARD"
}