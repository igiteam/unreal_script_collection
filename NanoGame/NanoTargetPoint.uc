/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoTargetPoint extends TargetPoint
	AutoExpandCategories( NanoTargetPoint )
	HideCategories( Advanced, Collision, Debug, Display, Mobile, Movement, Object, Physics )
	native
	implements(NanoInterface_Objective);


/** Whether or not this TargetPoint is active. **/
var(NanoTargetPoint) bool bIsActive;


/** Should this TargetPoint Show up on the mini Map **/
var() bool bShowOnMiniMap;

/** Show on the minimap edge even if the target point is "outside" of the current;y view minimap area. **/
var() bool bShowOnMiniMapEvenIfClamped;

/** Color of the dot that appears on the map **/
var() Color MiniMapDotColor;


/** How far to place the debug info above the in world actor**/
var float Debug_InfoTextVerticalOffset;

/** If the NanoTargetPoint is further than this do not draw it.  Helps reduce screen clutter **/
var(DebugInfo) float Debug_DistanceToStopDrawingDebugInfo;

/** Icon to display when in debug mode **/
var(DebugInfo) Texture2D Debug_Icon;



/** How far to place the debug info above the in world actor**/
var(InGameInfo) float InGameInfo_InfoTextVerticalOffset;

/** If the NanoTargetPoint is further than this do not draw it.  Helps reduce screen clutter **/
var(InGameInfo) float InGameInfo_DistanceToStopDrawingInGameInfo;

/** Name to display on the map / in game. **/
var(InGameInfo) Name InGameInfo_Name;

/** String data to display on the map / in game. **/
var(InGameInfo) string InGameInfo_Description;

/** Icon to display when in game **/
var(InGameInfo) Texture2D InGameInfo_Icon;

var(InGameInfo) float InGameInfo_IconScale;

var(InGameInfo) color InGameInfo_IconColor;


/** Our UIIconComponent for easy access. **/
var() UIIconComponent UIComponent;




simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bIsActive = TRUE;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bIsActive = FALSE;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bIsActive = !bIsActive;
	}
}


simulated function DrawDebug( NanoHUD_Base HUD )
{
	local array<Texture2D> Icons;
	local array<string>	Strings;

	// 	local int Idx;
	// 
	// 	for( Idx = 0; Idx < Stimuli.Length; Idx++ )
	// 	{
	// 		DrawDebugLine( Pawn.Location, Stimuli[Idx].Actor.Location, 0, 0, 255 );
	// 		if( Stimuli[Idx].bVisible )
	// 		{
	// 			DrawDebugLine( Pawn.Location, Stimuli[Idx].Location, 0, 255, 0 );
	// 		}
	// 		else
	// 		{
	// 			DrawDebugLine( Pawn.Location, Stimuli[Idx].Location, 255, 0, 0 );
	// 		}
	// 	}


	// only draw the debug info if we are closer than Debug_DistanceToStopDrawingDebugInfo
	// otherwise the screen just becomes a mess of unreadable text
	if( ( HUD.PlayerOwner.Pawn != None )
		&& ( VSize(HUD.PlayerOwner.Pawn.Location - Location) < Debug_DistanceToStopDrawingDebugInfo )
		)
	{
		GetDebugIcons( Icons );

		GetDebugOverheadText( HUD.PlayerOwner, Strings );

		DrawIconOverhead( HUD, Icons, Strings, 2, Debug_InfoTextVerticalOffset );
	}
}


/** @param TextureScale:  this is how big compared to orig you want the texture to be.  (2 == 50%  4 == 25% )**/
simulated function DrawIconOverhead( NanoHUD_Base HUD, out array<Texture2D> Icons, out array<string> Strings, float TextureScale, float TextureVerticalOffset )
{
	local NanoPC	PC;
	local Canvas	Canvas;
	local Vector	CameraLoc, ScreenLoc;
	local Rotator	CameraRot;
	local String	Str;
	local float		X, Y; //HealthPct;
	local Texture2D Icon;
	local float TextureOffSetX, TextureOffSetY;

	PC = NanoPC(HUD.PlayerOwner);
	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255,255,255);

	// project location onto the hud
	PC.GetPlayerViewPoint( CameraLoc, CameraRot );
	ScreenLoc = Canvas.Project( Location + (vect(0,0,1) * TextureVerticalOffset) );
	X = ScreenLoc.X;
	Y = ScreenLoc.Y;


	if( Icons.Length > 0 )
	{
		Icon = Icons[0];

		X = ScreenLoc.X + 2; // give a little border
		Y = ScreenLoc.Y - Icon.SizeY;  // make the text appear next to the icon at the same height

		TextureOffSetX = ScreenLoc.X;
		TextureOffSetY = ScreenLoc.Y;

		TextureOffSetX = TextureOffSetX - Icon.SizeX/TextureScale;
		TextureOffSetY = TextureOffSetY - Icon.SizeY;

		foreach Icons( Icon )
		{	
			Canvas.SetPos( TextureOffSetX, TextureOffSetY);
			Canvas.DrawTexture( Icon, 1.0f/TextureScale );
			//TextureOffSetX = TextureOffSetX + Icon.SizeX/2;
		}
	}


	Canvas.SetDrawColor(255,255,255);

	Canvas.SetPos( X, Y );
	
	//Str $= " " $ GetActionString();

	//Str $= "  Focus:" @ Focus @ FocalPosition.Position ; //X @ FocalPosition.Y @ FocalPosition.Z;

	foreach Strings(Str)
	{
		Canvas.DrawText(Str,TRUE);
	}

	Canvas.SetDrawColor(0,255,0);
	//HealthPct = GetHealthPercentage();
	//Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * HealthPct,4,0,0,2,2);
	//Canvas.SetDrawColor(255,0,0);
	//Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * (1.f - HealthPct),4,0,0,2,2);

	Canvas.SetDrawColor(255,255,255);
}



simulated function GetDebugIcons( out array<Texture2D> Icons )
{
	if( Debug_Icon != None )
	{
		Icons.AddItem( Debug_Icon ); 
	}
}


function GetDebugOverheadText( PlayerController PC, out array<string> OutText )
{
	OutText.AddItem( ""$Self );

	if( InGameInfo_Name != '' )
	{
		OutText.AddItem( String(InGameInfo_Name) );
	}

	if( PC.Pawn != None )
	{
		OutText.AddItem("DistFromPlayer"@VSize(Location-PC.Pawn.Location) ); // @" ZDifference"@(Location.Z-PC.Pawn.Location.Z));
	}

//	OutText.AddItem( "test" );
}


simulated function DrawInGameInfo( NanoHUD_Base HUD )
{
	local array<Texture2D> Icons;
	local array<string>	Strings;

	// only draw the debug info if we are closer than Debug_DistanceToStopDrawingDebugInfo
	// otherwise the screen just becomes a mess of unreadable text
	if( ( HUD.PlayerOwner.Pawn != None )
		&& ( VSize(HUD.PlayerOwner.Pawn.Location - Location) < InGameInfo_DistanceToStopDrawingInGameInfo )
		&& ( NanoPC(HUD.PlayerOwner).bDebugAI == FALSE )
		)
	{
		GetGameInfoIcons( Icons );

		GetGameInfoOverheadText( HUD.PlayerOwner, Strings );

		DrawIconOverhead( HUD, Icons, Strings, 4, InGameInfo_InfoTextVerticalOffset );
	}
}


function GetGameInfoOverheadText( PlayerController PC, out array<string> OutText )
{
	if( InGameInfo_Name != '' )
	{
		OutText.AddItem( String(InGameInfo_Name) );
	}

	if( InGameInfo_Description != "" )
	{
		OutText.AddItem( InGameInfo_Description );
	}

	//	OutText.AddItem( "test" );
}

simulated function GetGameInfoIcons( out array<Texture2D> Icons )
{
	if( InGameInfo_Icon != None )
	{
		Icons.AddItem( InGameInfo_Icon );
	}
}


/** Return location of objective, used by radar */
simulated function vector GetObjectiveLocation()
{
	return Location;
}


/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent()
{
	return UIComponent;
}



simulated function OnModifyNanoTargetPoint( SeqAct_ModifyNanoTargetPoint InAction )
{
	bIsActive = InAction.bIsActive;
}



defaultproperties
{
	bIsActive=TRUE

	MiniMapDotColor=(R=34,G=34,B=139,A=255)

	Debug_InfoTextVerticalOffset=64
	InGameInfo_InfoTextVerticalOffset=128
	Debug_DistanceToStopDrawingDebugInfo=12000
	InGameInfo_DistanceToStopDrawingInGameInfo=8000


	Begin Object Class=UIIconComponent Name=UIIconComponent0
	    MiniMap=(bShown=FALSE,bShownEvenIfClamped=FALSE,DistancesToDrawIcon=(X=0,Y=0),Icon=None,IconScale=0.06f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=0,TextName="",TextDescription="",TextVerticalOffset=0.0f)
	End Object
	UIComponent=UIIconComponent0
	Components.Add(UIIconComponent0)

	Debug_Icon=Texture2D'EditorResources.S_NavP'

	InGameInfo_IconScale=0.1f

	TickFrequencyDecreaseDistanceStart=4000
	TickFrequencyDecreaseDistanceEnd=8000
	TickFrequencyAtEndDistance=0.1
}