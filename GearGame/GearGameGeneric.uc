/**
 * This class is needed for the engine to be able to load SP maps and have a native package class to be
 * used in
 * [Engine.GameInfo]
 * DefaultGame=GearGame.GearGameGeneric
 * DefaultServerGame=GearGame.GearGameGeneric
 *
 * Nothing should ever go in here it is just helper class for the engine.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameGeneric extends GameInfo
	native;


/** This is the gametype to fall back after everything else has failed. **/
var string SuperDuperFallBackGameType;

/** This is the gametype for the party game which is the default for the front end */
var String PartyGameClassString;


cpptext
{
	virtual void AddSupportedGameTypes(AWorldInfo* Info, const TCHAR* WorldFilename) const;
}


event PostBeginPlay()
{
	`warn( "This map did not have a game type associated with it.  You need to open it and resave it" );
	`warn( "This map did not have a game type associated with it.  You need to open it and resave it" );
	`warn( "This map did not have a game type associated with it.  You need to open it and resave it" );
	`warn( "This map did not have a game type associated with it.  You need to open it and resave it" );
	`warn( "This map did not have a game type associated with it.  You need to open it and resave it" );

	super.PostBeginPlay();
}

static event string GetDefaultGameClassPath(string MapName, string Options, string Portal)
{
	local string ThisMapPrefix;
	local int Idx;

	// hardcode "geargame_p" as special SP map
	if (MapName ~= "geargame_p")
	{
		return "GearGameContent.GearGameSP";
	}
	else
	{
		ThisMapPrefix = Left(MapName, InStr(MapName, "_"));
		Idx = class'GearGame'.Default.DefaultMapPrefixes.Find('Prefix', ThisMapPrefix);
		if (Idx != INDEX_NONE)
		{
			return class'GearGame'.Default.DefaultMapPrefixes[Idx].GameType;
		}
		else
		{
			return Super.GetDefaultGameClassPath(MapName, Options, Portal);
		}
	}
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	local string ThisMapPrefix;
	local int i,pos;
	local class<GameInfo> NewGameType;
	local string GameOption;

	// if we're in the menu level, use the menu gametype
	if ( class'WorldInfo'.static.IsMenuLevel(MapName) )
	{
		return class<GameInfo>(DynamicLoadObject(default.PartyGameClassString,class'Class'));
	}

	// allow commandline to override game type setting
	GameOption = ParseOption( Options, "Game" );
	if ( GameOption != "" )
	{
		return Default.class;
	}

	// strip the UEDPIE_ from the filename, if it exists (meaning this is a Play in Editor game)
	if ( Left(MapName, 6) ~= "UEDPIE" )
	{
		MapName = Right(MapName, Len(MapName) - 6);
		if ( Left(MapName, 3) ~= "MP_" )
		{
			NewGameType = class<GameInfo>(DynamicLoadObject( default.SuperDuperFallBackGameType,class'Class'));
			if ( NewGameType != None )
			{
				return NewGameType;
			}
			//return Super.SetGameType(MapName, Options, Portal);
		}
	}
	else if ( Left(MapName, 5) ~= "UEDPC" )
	{
		MapName = Right(MapName, Len(MapName) - 5);
	}
	else if ( Left(MapName, 6) ~= "UEDPS3" )
	{
		MapName = Right(MapName, Len(MapName) - 6);
	}
	else if ( Left(MapName, 6) ~= "UED360" )
	{
		MapName = Right(MapName, Len(MapName) - 6);
	}

	// replace self with appropriate gametype if no game specified
	pos = InStr( MapName, "_" );
	ThisMapPrefix = left(MapName,pos);
	for (i = 0; i < class'GearGame'.default.MapPrefixes.length; i++)
	{
		if (class'GearGame'.default.MapPrefixes[i] ~= ThisMapPrefix)
		{
			return Default.class;
		}
	}

	// change game type
	for ( i=0; i<class'GearGame'.Default.DefaultMapPrefixes.Length; i++ )
	{
		if ( class'GearGame'.Default.DefaultMapPrefixes[i].Prefix ~= ThisMapPrefix )
		{
			NewGameType = class<GameInfo>(DynamicLoadObject(class'GearGame'.Default.DefaultMapPrefixes[i].GameType,class'Class'));
			if ( NewGameType != None )
			{
				return NewGameType;
			}
		}
	}
	for ( i=0; i<class'GearGame'.Default.CustomMapPrefixes.Length; i++ )
	{
		if ( class'GearGame'.Default.CustomMapPrefixes[i].Prefix ~= ThisMapPrefix )
		{
			NewGameType = class<GameInfo>(DynamicLoadObject(class'GearGame'.Default.CustomMapPrefixes[i].GameType,class'Class'));
			if ( NewGameType != None )
			{
				return NewGameType;
			}
		}
	}


	NewGameType = class<GameInfo>(DynamicLoadObject( default.SuperDuperFallBackGameType,class'Class'));
	if ( NewGameType != None )
	{
		return NewGameType;
	}


	// if no gametype found, use DemoGame
	return Super.SetGameType( MapName, Options, Portal );
}


auto State PendingMatch
{
	function CheckStartMatch()
	{
		// start the match immediately
		StartMatch();
	}

Begin:
	CheckStartMatch();
	Sleep(1.f);
	Goto('Begin');
}

/** This is our overridden StartMatch() function **/
function StartMatch()
{
	if ( CheckForSentinelRun() )
	{
		return;
	}

	`log("Starting match...");
	Super.StartMatch();

	// transition to the new in progress state
	GotoState('MatchInProgress');

	// BugIt functionality
	// need to delay here as in MP maps there is a delay in starting the match even with QuickStart on
	SetTimer( 5.0f, FALSE, nameof(CheckForBugItCommand) );
}

/** This will check to see if there is a BugIt command active and then call the BugItGo function **/
function CheckForBugItCommand()
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		break;
	}

	if( BugLocString != "" || BugRotString != "" )
	{
		if( PC.CheatManager != none )
		{
			//`log( "BugLocString:" @ BugLocString );
			//`log( "BugRotString:" @ BugRotString );
			PC.BugItGoString( BugLocString, BugRotString );
		}
	}
}


state MatchInProgress
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
	}

Begin:
	if( (CauseEventCommand != "") && (MyAutoTestManager != None) )
	{
		MyAutoTestManager.GotoState('SentinelHandleCauseEventCommand');
	}
}




defaultproperties
{
	PlayerReplicationInfoClass=class'GearGame.GearPRI'
	PlayerControllerClass=class'GearGame.GearPC'
	DefaultPawnClass=class'GearGame.GearPawn_COGMarcus'
	GameReplicationInfoClass=class'GearGame.GearGRI'

	SuperDuperFallBackGameType="GearGameContent.GearGameSP"
	PartyGameClassString="GearGameContent.GearPartyGame"
}
