/**
 * The FrontEnd class that kicks off the main movie
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_PartyPanel extends GFxMoviePlayer;


/** Reference to the movie info for the party panel */
var SwfMovie PPMovieRef;

/** Called as soon as this object is created so we can set up the movie reference and kickstart the front end */
function Init(optional LocalPlayer Player)
{
	super.Init(Player);
	// Set the reference for the movie itself
	MovieInfo = PPMovieRef;

	SetTimingMode(TM_Real);

	// Initialize the movie
	Start();
	// Advance the movie to the first frame
	Advance(0);
}

/** Called every frame so we can handle anything we may need every tick */
function TickFrontEnd(float DeltaTime)
{
}


defaultproperties
{
}
