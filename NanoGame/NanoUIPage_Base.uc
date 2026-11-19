/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_Base extends Object
	abstract;

var NanoHUD_Base NanoHUD;

var() vector2D		PageUIOrigin;
var() Material		PageUIBackground;
var() color			PageUITextColor;
var() LinearColor	PageUICaratLColor;
var() Texture2D		PageUIBlobTexture;

var()   Texture2D   UITabTex;

var FontRenderInfo TextRenderInfo;

var string          PageName;

function NanoPC GetNanoPC()
{
	return NanoPC(NanoHUD.PlayerOwner);
}

function NanoPawn GetNanoPawn()
{
	return NanoPawn(NanoHUD.PlayerOwner.Pawn);
}

function NanoPRI GetNanoPRI()
{
	return NanoPRI(NanoHUD.PlayerOwner.PlayerReplicationInfo);
}

function NanoGRI GetNanoGRI()
{
	local NanoPawn NP;

	NP = GetNanoPawn();
	return NanoGRI(NP.WorldInfo.GRI);
}

function NanoMCP GetNanoMCP()
{
	return GetNanoGRI().MCP;
}


delegate int SortAlphabetize_String( String A, String B )
{
	return ( Locs(A) > Locs(B) ? -1 : 0 );
}


delegate int SortHighestToLowest_MCPDatum( MCPDatum A, MCPDatum B )
{
	// bigger is better!
	return ( int(A.Value) < int(B.Value) ? -1 : 0 );
}

/** Draws tab bar under a window, lighting up specified tab */
function DrawInGameTabBar(float UIOriginX, float UIOriginY, int ActiveTab)
{
	local Canvas Canvas;
	local int i, TabOffset;
	local NanoUIPage_Base Page;
	local bool bIsActivePage;
	local float XL, YL;

	Canvas = NanoHUD.Canvas;

	// Draw tab region
	Canvas.SetDrawColor(255, 255, 255, 140);

	Canvas.SetPos(UIOriginX + 12, UIOriginY + 512 - 29);
	Canvas.DrawTile(UITabTex, 30,61, 0,51, 30,61);

	Canvas.SetPos(UIOriginX + 12 + 30, UIOriginY + 512);
	Canvas.DrawTile(UITabTex, 600,32, 31,80, 32,32);

	Canvas.SetPos(UIOriginX + 12 + 30 + 600, UIOriginY + 512);
	Canvas.DrawTile(UITabTex, 15,32, 98,80, -15,32);

	// LB
	Canvas.SetPos(UIOriginX + 12 + 32, UIOriginY + 512 + 8);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.DrawTile(UITabTex, 26,16, 392,31, 26,16);

	Canvas.Font = class'Engine'.static.GetTinyFont();

	TabOffset = 12 + 32 + 40;

	for(i=0; i<NanoHUD.UIPages.Length; i++)
	{
		Page = NanoHUD.UIPages[i];
		bIsActivePage = (Page == self);

		// Missions
		Canvas.SetPos(UIOriginX + TabOffset, UIOriginY + 512 + 10);
		Canvas.SetDrawColor(255, 255, 255, bIsActivePage ? 255 : 140);
		Canvas.DrawText(Page.PageName);

		// Move on enough for the text
		Canvas.StrLen(Page.PageName, XL, YL);
		TabOffset += (XL + 15);
	}

	// RB
	Canvas.SetPos(UIOriginX + TabOffset, UIOriginY + 512 + 8);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.DrawTile(UITabTex, 26,16, 420,31, 26,16);
}

/** Draw button bar under a window */
function DrawButtonHelpBar(float UIOriginX, float UIOriginY, string ButtonAInfo, bool bButtonAEnabled, string ButtonXInfo, bool bButtonXEnabled)
{
	local Canvas Canvas;

	Canvas = NanoHUD.Canvas;

	// Draw button region
	Canvas.SetDrawColor(255, 255, 255, 140);

	Canvas.SetPos(UIOriginX + 1024 - 30 -12, UIOriginY + 512 - 29);
	Canvas.DrawTile(UITabTex, 30,61, 30,51, -30,61);

	Canvas.SetPos(UIOriginX + 1024 - 30 - 280 - 12, UIOriginY + 512);
	Canvas.DrawTile(UITabTex, 300,32, 31,80, 32,32);

	Canvas.SetPos(UIOriginX + 1024 - 30 - 280 - 15 - 12, UIOriginY + 512);
	Canvas.DrawTile(UITabTex, 15,32, 83,80, 15,32);

	// Draw A button
	if( Len(ButtonAInfo) > 0 )
	{
		Canvas.SetDrawColor(255,255,255, bButtonAEnabled ? 255 : 128);

		Canvas.SetPos(UIOriginX + 721, UIOriginY + 513);
		Canvas.DrawTile(UITabTex, 26,26, 484,33, 26,26);

		Canvas.SetPos(UIOriginX + 721 + 32, UIOriginY + 520);
		Canvas.DrawText(ButtonAInfo);
	}

	// Draw X button
	if( Len(ButtonXInfo) > 0 )
	{
		Canvas.SetDrawColor(255,255,255, bButtonXEnabled ? 255 : 128);

		Canvas.SetPos(UIOriginX + 858, UIOriginY + 513);
		Canvas.DrawTile(UITabTex, 26,26, 452,33, 26,26);

		Canvas.SetPos(UIOriginX + 858 + 32, UIOriginY + 520);
		Canvas.DrawText(ButtonXInfo);
	}
}

function DrawKeyValue( out float DrawX, out float DrawY, const String InKey, const String InValue )
{
	local Canvas Canvas;

	Canvas = NanoHUD.Canvas;

	Canvas.SetPos( DrawX, DrawY );
	Canvas.DrawText( InKey, TRUE,,, TextRenderInfo );

	// move over to draw the "value" (which will be a number usually)
	DrawX += 150;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.DrawText( InValue, TRUE,,, TextRenderInfo );
	DrawX -= 150;

	// move to next line
	DrawY += 20.0;
}

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
	local Canvas Canvas;

	Canvas = NanoHUD.Canvas;

	Canvas.Font = class'Engine'.static.GetTinyFont();
	Canvas.SetPos(PageUIOrigin.X, PageUIOrigin.Y);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.DrawMaterialTile(PageUIBackground, 1024, 512, 0, 0, 1, 1);

	DrawInGameTabBar(PageUIOrigin.X, PageUIOrigin.Y, 1);
}

defaultproperties
{
	PageUIOrigin=(X=128,Y=104)
	PageUIBackground=Material'Nano_ProtoHUD_Ingame.M_UI_HUD_Ingame_Menu_Background2_Plain'
	PageUITextColor=(R=220,G=220,B=220)
	PageUICaratLColor=(R=0.8,G=0.5,B=0.8,A=0.8)
	PageUIBlobTexture=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_Menu_IconsA'

	UITabTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_IngameMenu_Inventory'

	TextRenderInfo=(bEnableShadow=true)

	PageName="NONE"
}