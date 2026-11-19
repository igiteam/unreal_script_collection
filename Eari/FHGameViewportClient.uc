/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class FHGameViewportClient extends UTGameViewportClient;



function DrawTransition(Canvas Canvas)
{
	local int Pos;
	local string MapName;
	local string ParseStr;
	local class<UTGame> GameClass;
	local string HintMessage;
	local bool bAllowHints;
	local string GameClassName;

	// if we are doing a loading transition, set up the text overlays for the loading movie
	if (Outer.TransitionType == TT_Loading)
	{
		bAllowHints = true;

		// we want to show the name of the map except for a number of maps were we want to remap their name
		if( "UDKFrontEndMap" == Outer.TransitionDescription )
		{
			MapName = UTFrontEndString; //"Main Menu"

			// Don't bother displaying hints while transitioning to the main menu (since it should load pretty quickly!)
			bAllowHints = false;
		}
		else
		{
			MapName = Outer.TransitionDescription;
		}

		class'Engine'.static.RemoveAllOverlays();

		// pull the map prefix off the name
		Pos = InStr(MapName,"-");
		if (Pos != -1)
		{
			MapName = right(MapName, (Len(MapName) - Pos) - 1);
		}

		// pull off anything after | (gametype)
		Pos = InStr(MapName,"|");
		if (Pos != -1)
		{
			MapName = left(MapName, Pos);
		}

		// get the class represented by the GameType string
		GameClass = class<UTGame>(FindObject(Outer.TransitionGameType, class'Class'));
		//Desc = "";

		if (GameClass == none)
		{
			// Some of the game types are in UTGameContent instead of UTGame. Unfortunately UTGameContent has not been loaded yet so we have to get its base class in UTGame
			// to get the proper description string.
			Pos = InStr(Outer.TransitionGameType, ".");

			if(Pos != -1)
			{
				ParseStr = Right(Outer.TransitionGameType, Len(Outer.TransitionGameType) - Pos - 1);

				Pos = InStr(ParseStr, "_Content");

				if(Pos != -1)
				{
					ParseStr = Left(ParseStr, Pos);

					ParseStr = "UTGame." $ ParseStr;

					GameClass = class<UTGame>(FindObject(ParseStr, class'Class'));

					if(GameClass != none)
					{
						//Desc = GameClass.default.GameName;
					}
				}
			}
		}
		else
		{
			//Desc = GameClass.default.GameName;
		}

		// NOTE: The position and scale values are in resolution-independent coordinates (between 0 and 1).
		// NOTE: The position and scale values will be automatically corrected for aspect ratio (to match the movie image)

		// Game type name
		//class'Engine'.static.AddOverlay(LoadingScreenGameTypeNameFont, Desc, 0.1822, 0.435, 1.0, 1.0, false);

		// Map name
		//class'Engine'.static.AddOverlay(LoadingScreenMapNameFont, MapName, 0.1822, 0.46, 2.0, 2.0, false);

		// We don't want to draw hints for the Main Menu or FrontEnd maps, so we'll make sure we have a valid game class
		if( bAllowHints )
		{
			// Grab game class name if we have one
			GameClassName = "";
			if( GameClass != none )
			{
				GameClassName = string( GameClass.Name );
			}

			// Draw a random hint!
			// NOTE: We always include deathmatch hints, since they're generally appropriate for all game types
			HintMessage = LoadRandomLocalizedHintMessage( string( class'UTDeathmatch'.Name ), GameClassName);
			if( Len( HintMessage ) > 0 )
			{
				//class'Engine'.static.AddOverlayWrapped( LoadingScreenHintMessageFont, HintMessage, 0.1822, 0.585, 1.0, 1.0, 0.7 );
			}
		}
	}
	else if (Outer.TransitionType == TT_Precaching)
	{
		Canvas.Font = class'UTHUD'.static.GetFontSizeIndex(3);
		Canvas.SetPos(0, 0);
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.DrawRect(Canvas.SizeX, Canvas.SizeY);
		Canvas.SetDrawColor(255, 0, 0, 255);
		Canvas.SetPos(100,200);
		Canvas.DrawText("Precaching...");
	}
}

