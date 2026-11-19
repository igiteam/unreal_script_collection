
class TPGameReplicationInfo extends GameReplicationInfo
	config(game)
	native;

var BulletDecalManager BulletDecalManager;

var TPDebugInfo DebugInfo;

enum EGameStatus
{
	GS_None,
	GS_Lobby,
	GS_PreGame,
	GS_GameInProgress,
	GS_PostGame,
	GS_Loading,
};

var repnotify EGameStatus GameStatus;
var bool bHasEnoughPlayers;

// Weapon Performance Flags
enum eWeaponPerformanceFlags
{	
	WPF_NONE,			// 0
	WPF_MUZZLEFLASH,	// 1
	WPF_DYNALIGHT,		// 2
	WPF_BLANK,			// Blank for bitfield
	WPF_HITEFFECTS,		// 4
};

var int WeaponPerformanceFlags;

var int TheChapterPointToStartAt;

replication
{
	if (Role == Role_Authority)
		GameStatus, bHasEnoughPlayers;
}

simulated event ReplicatedEvent( name VarName )
{
	local PlayerController PC;
	local TPPlayerController TPC;

	if (VarName == 'GameStatus')
	{
		ForEach WorldInfo.AllControllers(class'PlayerController', PC)
		{	
			TPC = TPPlayerController(PC);
			if (TPC != none)
			{
				// Show the loading screen if we are loading into a map
				if (GameStatus == GS_Loading)
					TPC.ClientLoadingScreen(true);
				if (GameStatus == GS_PreGame)
					TPC.ClientLoadingScreen(false);
					
				TPC.ClientSetGameStatus(GameStatus);
			}
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

native function SetEngineDebugInfo();

// HACK, these are duplicated int TPPlayerController.uc.
// If you change these, change those!
const GAME_MODE									= 0x0000800B;
const CONTEXT_MAPNAME							= 1;

function SetGameStatus(EGameStatus NewGameStatus)
{
	local PlayerController PC;
	local TPPlayerController TPC;
	local OnlineGameSettings GameSettings;
	local int MapID;
	local int GameMode;

	GameStatus = NewGameStatus;

	switch (GameStatus)
	{
		case GS_Lobby:
			break;

		case GS_PreGame:
			break;
			
		case GS_PostGame:
			break;

		case GS_GameInProgress:
			break;
	}

// 	`log( "*****JOHNDEBUG: In SetGameStatus" );	

	//
	// Loop through all clients and update their rich presence string
	//
	ForEach WorldInfo.AllControllers( class'PlayerController', PC )
	{	
		TPC = TPPlayerController(PC);

		if ( TPC != none )
		{
			GameSettings = TPC.OnlineSub.GameInterface.GetGameSettings();

			GameSettings.GetStringSettingValue(GAME_MODE,GameMode);
			GameSettings.GetStringSettingValue(CONTEXT_MAPNAME,MapID);

 			//`log( "*****KellyDEBUG: In SetGameStatus for " $ TPC $ " GameMode is " $ GameMode $ " GameStatus is " $ GameStatus );	
 			//ScriptTrace();

			TPC.UpdateMPRichPresence( MapID, int(GameSettings.bIsLanMatch), GameStatus, GameMode );
		}

	}	
}

event SetCurrentChapterPoint( int ChapterPoint )
{
	if ( Role == ROLE_Authority )
	{
		TheChapterPointToStartAt = ChapterPoint;
	}
}


simulated function PostBeginPlay()
{
//	local name TextHandle;
//	local name ProgressBar;

	super.PostBeginPlay();
	if( DebugInfo == None )
	{
		DebugInfo = new(Outer) class'TPDebugInfo';
		SetEngineDebugInfo();
	}

	//if (LCDInterface == none)
	//{
		//LCDInterface = new (Outer) class'LCDInterface';
		
		
		/*TextHandle = LCDInterface.AddText(OT_SCROLLING_TEXT, TS_MEDIUM, 0, 160);
		LCDInterface.SetOrigin(TextHandle, 0, 2);
		ProgressBar = LCDInterface.AddProgressBar(PBT_DOT_CURSOR);
		LCDInterface.SetOrigin(ProgressBar, 20, 36);
		LCDInterface.SetProgressBarSize(ProgressBar,120,5);
		LCDInterface.ModifyControlsOnPage(0);
		LCDInterface.SetText(TextHandle, "Welcome to Turning Point.  I hope you enjoy!!");

		LCDInterface.ShowPage(0);
	*/

	//}

	if (BulletDecalManager == none)
	{
		BulletDecalManager = new(Outer) class'BulletDecalManager';
		BulletDecalManager.Initialize();
	}
}

simulated function bool IsWeaponPerfFlagOn(int WPFType)
{
	return ((WeaponPerformanceFlags & WPFType) != 0);
}

simulated function TogglePerformanceFlags(int WPFType)
{
	if (WPFType > 0)
	{
		 WeaponPerformanceFlags = WeaponPerformanceFlags ^ WPFType;
	}
	else
	{
		WeaponPerformanceFlags = 0;
	}
}

