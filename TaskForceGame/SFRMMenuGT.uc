
class SFRMMenuGT extends GameInfo
native;

var bool WaitingForNewPlayers;

var bool fromTimeout;
var bool LiveKick;
var bool LiveLostConn;
var int LiveErrorNum;

var bool liveRollover;
var bool slRollover;
var bool serverFull;

event InitGame( string Options, out string Error )
{
	local string timeoutOption;
	local string liveKickOption;
	local string liveLostConnOption;
	local string liveRolloverOption;
	local string slRolloverOption;
	local string serverFullOption;

	super.InitGame(Options, Error);
	
	timeoutOption = ParseOption(Options, "timeout");
	
	liveRolloverOption = ParseOption(Options, "liveRollover");
	
	slRolloverOption = ParseOption(Options, "slRollover");
	
	liveKickOption = ParseOption(Options, "liveKick");
	
	liveLostConnOption = ParseOption(Options, "liveLostConn");
	
	serverFullOption = ParseOption(Options, "serverfull");
	
	log("MenuGT InitGame timeout: " $ timeoutOption);
	
	if (serverFullOption != "")
	{
		serverFull = true;
	}
	else
	{
		serverFull = false;
	}
	
	if (timeoutOption != "")
	{
		fromTimeout = true;
	}
	else
	{
		fromTimeout = false;
	}
	
	if (liveRolloverOption != "")
	{
		liveRollover = true;
	}
	else
	{
		liveRollover = false;
	}
	
	if (slRolloverOption != "")
	{
		slRollover = true;
	}
	else
	{
		slRollover = false;
	}
	
	log("MenuGT InitGame rollover: " $ liveRolloverOption @ liveRollover);
	
	log("SFRMMultiplayer liveKickOption: " $ liveKickOption);
	if (liveKickOption != "")
	{
		LiveKick = true;
	}
	else
	{
		LiveKick = false;
	}
	
	log("SFRMMultiplayer liveLostConnOption: " $ liveLostConnOption);
	if (liveLostConnOption != "")
	{
		LiveLostConn = true;
	}
	else
	{
		LiveLostConn = false;
	}

	liveErrorNum = GetIntOption( Options, "liveError", -1);
}

event PlayerController Login(string Portal,	string Options,	out string Error)
{
	local PlayerController NewPlayer;
//	local Interaction I; 

	Log("New Player logged in!!");
	NewPlayer = Super.Login(Portal,Options,Error);

//SysLinkSPAM	Log("SFRMPlayerController::PostBeginPlay() "); 

	//
	bRestartLevel = false;	// let player spawn once in levels that must be restarted after every death
	RestartPlayer(newPlayer);
	bRestartLevel = Default.bRestartLevel;
	//

	Level.DefaultMapInfo.ClearCheckpoints();

	return NewPlayer;
}

event PostLogin( PlayerController NewPlayer )
{
	local CombatProxyMenuManager MM;
	local string url;

	if( NewPlayer != None )
	{
		url = Level.GetLocalURL();
		url = Mid( url, InStr(url,"?") );

		// if backTo is in our URL then we want to load the saved stack
		if( InStr( url, "?FromSP" ) != -1 || InStr( url, "?FromMP" ) != -1 )
		{
			log( url );
			NewPlayer.ProfileName = Respace( ParseOption( url, "Name" ) );
			log( "Set profile name to" @ NewPlayer.ProfileName );
			NewPlayer.ClientOpenMenu( "" ); // hacky special string
		}
		else
		{
			NewPlayer.ClientOpenMenu( "PressStart" );
		}

		// kkm: nasty
		Level.DoneLoading = false;

		MM = CombatProxyMenuManager(NewPlayer.Player.BasePlayerMenu);

		if (liveRollover)
		{
			MM.OpenMenu( "LiveRollover" );
		}
		else if( liveErrorNum != -1 )
		{
			MM.HandleLiveError( liveErrorNum );
			liveErrorNum = -1;
		}
		else if( slRollover )
		{
			MM.ShowMessageBox( "SLRollover" );
		}
		else if( serverFull )
		{
			MM.ShowMessageBox( "ServerFull" );
		}
		else if( fromTimeout )
		{
			MM.ShowMessageBox( "ServerTimeout" );
		}

		Super.PostLogin( NewPlayer );
		ZombieWeapon(NewPlayer.Pawn.Weapon).InitializeWeapon();
	}
}

function bool PickupQuery( Pawn Other, Pickup item )
{
//	if ( PickupRPG18(item) != None )
//		return false;

	if ((HealthPickup(item) != none) && (other.Health>=100))
	{
		return false;
	}

	return Super.PickupQuery(Other, item); 

}
function Logout(Controller Exiting)
{
	Super.Logout(Exiting);
}

event RestartPlayer( Controller aPlayer )	
{
	Log ("Tried to restart "$aPlayer); 
//	Super.RestartPlayer(aPlayer);
}

//return like a MP would for testing...
event string GetBeaconText()
{	
	local String levelName;
	
	levelName = string(Level);
	levelName = Left(levelName, InStr(levelName, "."));
	
	return GameName $ "\\t" $ levelName $ "\\t" $ 2 $ "\\t" $ 16;
}


// Decompiled with UE Explorer.
defaultproperties
{
    bWaitingToStartMatch=true
    HUDType="ZombieGame.BasicHUD"
    DefaultPlayerName="SFRMPlayer"
    GameName="Menu"
    GameMessageClass=Class'ZombieNullMessage'
    PlayerControllerClassName="ZombieGame.SFRMPlayerController"
}