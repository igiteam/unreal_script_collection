/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_Challenges extends NanoUIPage_Base;


var transient array<String> ChallengeBoardCategories;
var transient int   SelectedChallengeBoardIndex;



 /** Move selection to previous Challenge board*/
 simulated function SelectPreviousChallengeBoard( NanoPawn NP )
 {
	 SelectedChallengeBoardIndex--;

	 SelectedChallengeBoardIndex = Max( SelectedChallengeBoardIndex, 0 );
 }

 /** Move selection to next Challenge board*/
 simulated function SelectNextChallengeBoard( NanoPawn NP )
 {
	 SelectedChallengeBoardIndex++;

	 SelectedChallengeBoardIndex = Min( SelectedChallengeBoardIndex, ChallengeBoardCategories.Length-1 );
 }

///// NanoUIPage_Base interface


function HandlePageInput(name ButtonName)
{
	 local NanoPawn NP;

	 NP = GetNanoPawn();
	 switch( ButtonName )
	 {
	 case 'DPad_Up':
		 SelectPreviousChallengeBoard(NP);
		 break;

	 case 'DPad_Down':
		 SelectNextChallengeBoard(NP);
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
	local ChallengeDatum Challenge;
	local Canvas Canvas;

	Canvas = NanoHUD.Canvas;
	NP = GetNanoPawn();

	Super.DrawPage();

	DrawInGameTabBar(PageUIOrigin.X, PageUIOrigin.Y, 5);

	DrawX = PageUIOrigin.X + 20;
	DrawY = PageUIOrigin.Y + 20;

	// would be nice to do this once
	// populate the categories on the left
	ChallengeBoardCategories.Length = 0;
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

		// don't add if NOT ECET_
		if( InStr( Datum.Key, "ECET_") == INDEX_NONE )
		{
			continue;
		}


		if( ChallengeBoardCategories.Find( Datum.Key) == INDEX_NONE )
		{
			ChallengeBoardCategories.AddItem( Datum.Key );
		}
	}


	// draw out all of the categories on the left
	ChallengeBoardCategories.Sort(SortAlphabetize_String);

	foreach ChallengeBoardCategories( LeaderBoardID )
	{
		if( SelectedChallengeBoardIndex == Idx )
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
	KeyWeAreLookingFor = ChallengeBoardCategories[SelectedChallengeBoardIndex];
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


	// okie:
	// draw out the Challenge Data on top



	Canvas.SetDrawColor(255, 255, 255, 255 );
	DrawX = PageUIOrigin.X + 20;
	DrawY = PageUIOrigin.Y + 20;

	DrawX += 200;	

	Challenge = NanoGRI(NP.WorldInfo.GRI).NCM.FindChallengeViaString( KeyWeAreLookingFor );
	
	Canvas.Font = class'Engine'.static.GetMediumFont();
	Canvas.SetDrawColor(0, 128, 0, 255 );
	Canvas.SetPos( DrawX, DrawY );
	Canvas.DrawText( Challenge.Desc, TRUE,,, TextRenderInfo );


	Canvas.SetDrawColor(255, 255, 255, 255 );
	Canvas.Font = class'Engine'.static.GetMediumFont();

	DrawY += 30;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.DrawText( "AmountNeeded:" @ Challenge.AmountNeeded, TRUE,,, TextRenderInfo );

	DrawY += 40;

	// rewards
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor(0, 128, 0, 255 );
	Canvas.DrawText( "Rewards", TRUE,,, TextRenderInfo );
	

	Canvas.SetDrawColor(255, 255, 255, 255 );
	
	Canvas.DrawText( "CurrencyGained:" @ Challenge.TheReward.CurrencyGained, TRUE,,, TextRenderInfo );

	Canvas.DrawText( "NanoPowerBucketsGained:" @ Challenge.TheReward.NanoPowerBucketsGained, TRUE,,, TextRenderInfo );

	Canvas.DrawText( "RebelMindShareGained:" @ Challenge.TheReward.RebelMindShareGained, TRUE,,, TextRenderInfo );

	Canvas.DrawText( "XPGained:" @ Challenge.TheReward.XPGained, TRUE,,, TextRenderInfo );



	// draw out the current standings on the challenge data

	// draw them out using the ID instead of Key
	Canvas.SetDrawColor(255, 255, 255, 255 );
	DrawX = PageUIOrigin.X + 20;
	DrawY = PageUIOrigin.Y + 20;

	DrawY += 220;  // to move down from the challenge info
	DrawX += 200;	

	Canvas.SetPos( DrawX, DrawY );

	Canvas.SetDrawColor(0, 128, 0, 255 );
	Canvas.DrawText( "Current Standings", TRUE,,, TextRenderInfo );
	DrawY += 35;

	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor(255, 255, 255, 255 );
	Canvas.Font = class'Engine'.static.GetTinyFont();
	foreach LeaderBoardEntries( Datum )
	{
		DrawKeyValue( DrawX, DrawY, Datum.ID, Datum.Value );
	}

}

defaultproperties
{
	PageName="CHALLENGE"
}