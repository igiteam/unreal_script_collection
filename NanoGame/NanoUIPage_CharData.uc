/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_CharData extends NanoUIPage_Base;


///// NanoUIPage_Base interface


function HandlePageInput(name ButtonName)
{

}

function PageShown()
{

}

function PageHidden()
{

}

function DrawPage()
{
	local MCPDatum Datum;
	local float DrawX;
	local float DrawY;
	local array<String> DoNotList;
	local int Idx;
	local Canvas Canvas;
	local NanoPawn NP;
	local NanoPRI NPRI;

	Canvas = NanoHUD.Canvas;
	NP = GetNanoPawn();
	NPRI = GetNanoPRI();

	Super.DrawPage();

	DrawInGameTabBar(PageUIOrigin.X, PageUIOrigin.Y, 3);

	// just draw a list atm
	Canvas.SetDrawColor(255, 255, 255, 255);
	DrawX = PageUIOrigin.X + 20;
	DrawY = PageUIOrigin.Y + 20;


	// draw MOTD
	DoNotList.AddItem( class'NanoMCPKeys'.default.MOTD );

	foreach NanoGRI(NP.WorldInfo.GRI).MCP.MCPData( Datum )
	{
		if( Datum.Key == class'NanoMCPKeys'.default.MOTD  )
		{
			DrawKeyValue( DrawX, DrawY, Datum.Key, Datum.Value );
			break;
		}
	}

	// draw out character level
	foreach NanoGRI(NP.WorldInfo.GRI).MCP.MCPData( Datum )
	{
		if( Datum.Key == class'NanoMCPKeys'.default.EXP  )
		{
			for( Idx = NPRI.XPPerLevel.Length-1; Idx > 0; --Idx )
			{
				//`log( Datum.Value @ NanoPRI(PlayerOwner.PlayerReplicationInfo).XPPerLevel[Idx]@ idx );
				if( int(Datum.Value) > NPRI.XPPerLevel[Idx] )
				{
					break;
				}
			}

			DrawKeyValue( DrawX, DrawY, "CurrLevel", String(Idx) );
			break;
		}
	}


	// challenges completed





	// draw a line

	Canvas.SetPos( DrawX, DrawY );
	Canvas.DrawText( "=======================", TRUE,,, TextRenderInfo );

	DrawY += 20.0;


	foreach NanoGRI(NP.WorldInfo.GRI).MCP.MCPData( Datum )
	{
		if( ( Datum.ID != "" ) && ( Datum.ID != class'NanoTypes'.static.GetLocalPlayerUserName() ) )
		{
			continue;
		}

		if( DoNotList.Find( Datum.Key ) != INDEX_NONE )
		{
			continue;
		}

		// don't add if  ECET_
		if( InStr( Datum.Key, "ECET_") != INDEX_NONE )
		{
			continue;
		}


		//`log( "  " @ `showvar(Datum.Key) @ `showvar(Datum.Value) );
		DrawKeyValue( DrawX, DrawY, Datum.Key, Datum.Value );
	}

}

defaultproperties
{
	PageName="CHARACTER"
}