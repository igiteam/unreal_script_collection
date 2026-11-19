class TPGameViewportClient extends GameViewportClient
	native
	config(Game);


var BluffInteraction       BluffInteractionObj;
var LevelSelectInteraction LSInteraction;
var GrappleInteraction     GrappleInteractionObj;
var ObjectiveInteraction   ObjectiveInteractionObj;
var TPShellInteraction     TPShellInteraction;

var CheatMenuInteraction   CheatMenuInteractionObj;
	
var GrappleInteraction_v2  GrappleInteraction_v2Obj;
var TPMPGameInteraction    MPInteraction;
var BombGoBoomInteraction  BGBInteraction;

var Array<Material> LoadingScreens;

var bool bOldDisplayDiagnostics;
var bool bLoadingScreenActive;
var bool bLoadingCampaignMap;
var float LoadingScreenActiveTime;

var byte TPShellIndex;
var byte BGBIndex;

var config bool bDisableDiagnosticsAndCopyright;

enum ePlayMovie
{
	PLAYMOVIE_LoadFromMemoryBlock,
	PLAYMOVIE_LoadFromMemoryLoop,
	PLAYMOVIE_StreamBlock,
	PLAYMOVIE_StreamLoop,
	PLAYMOVIE_StreamNoBlock
};

var LCDManager LCDManager;

// stored in here cause it's never destroyed during a run of the game
var int BonusActiveArray[6];

var bool bRequiresKeyboardInputOnConsole;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


event bool Init(out string OutError)
{
	local bool superRetVal;
	//Register the bluffing system
	BluffInteractionObj = new(Self) class'BluffInteraction';
	if( InsertInteraction(BluffInteractionObj) == -1 )
	{
		OutError = "Failed to add interaction to GlobalInteractions array:" @ BluffInteractionObj;
		return false;
	}

	LSInteraction = new(Self) class'LevelSelectInteraction';
	if( InsertInteraction(LSInteraction) == -1 )
	{
		OutError = "Failed to add Level Select interaction to GlobalInteractions array:" @ LSInteraction;
		return false;
	}

	GrappleInteractionObj = new(Self) class'GrappleInteraction';
	if( InsertInteraction(GrappleInteractionObj) == -1 )
	
	{
		OutError = "Failed to add interaction to GlobalInteractions array:" @ GrappleInteractionObj;
		return false;
	}
	
	ObjectiveInteractionObj = new(self) class'ObjectiveInteraction';
	if(InsertInteraction(ObjectiveInteractionObj) == -1)
	{
		OutError = "Failed to add interaction to GlobalInteractions array:" @ ObjectiveInteractionObj;
		return false;
	}









	GrappleInteraction_v2Obj = new(self) class'GrappleInteraction_v2';
	if(InsertInteraction(GrappleInteraction_v2Obj) == -1)
	{
		OutError = "Failed to add interaction to GlobalInteractions array:" @ GrappleInteraction_v2Obj;
		return false;
	}

    MPInteraction = new(self) class'TPMPGameInteraction';
	if(InsertInteraction(MPInteraction) == -1)
	{
		OutError = "Failed to add interaction to GlobalInteractions array:" @ MPInteraction;
		return false;
	}

    // ADD INTERACTIONS ABOVE THIS COMMENT (or at least above the following lines of code that get
    // the length of the Interactions array

    BGBIndex     = GlobalInteractions.Length;
    TPShellIndex = GlobalInteractions.Length+1;

	superretval = Super.Init(OutError);

	if (superretval)
	{
		bLoadingScreenActive = true;
		//DisplayLoadingScreen();
	}

	if (bDisableDiagnosticsAndCopyright || !ShouldDisplayDiagnostics())
	{
		bDisplayDiagnostics = false;
	}

	return superretval;
}

event InitializeShellInteraction(TPPlayerController myTPC)
{
	//TPSIClass = class<TPShellInteraction>(DynamicLoadObject("TPGameContent.TPShellInteractionContent", class'class'));
    TPShellInteraction = new(self) class'TPShellInteractionContent';
	
	//TPShellInteraction = new(self) TPSIClass;
	InsertInteraction(TPShellInteraction, TPShellIndex);
	
	TPShellInteraction.GetPlayerController(myTPC);
}

event DeInitializeShellInteraction(TPPlayerController myTPC)
{
	//`log("Setting shell interaction to NONE");
	TPShellInteraction = None;
	myTPC.TPShellInt = None;
	GlobalInteractions.Remove(TPShellIndex, 1);

	myTPC.ClientForceGarbageCollection();
}

event InitializeBombGoBoomInteraction(TPPlayerController tppController, BombGoBoomInteraction bgb)
{
    if (!GlobalInteractions[BGBIndex].IsA('BombGoBoomInteraction'))
    {
        BGBInteraction       = bgb;
	    BGBIndex             = InsertInteraction(BGBInteraction, BGBIndex);

        BGB.GetPlayerController(tppController);
    }
}

event DeInitializeBombGoBoomInteraction(TPPlayerController tppController)
{
    if (GlobalInteractions[BGBIndex].IsA('BombGoBoomInteraction'))
    {
        BGBInteraction = None;
        GlobalInteractions.Remove(BGBIndex, 1);
    }
}

event InitializeLCDManager(TPPlayerController tppController)
{
	if (LCDManager == none)
	{
		LCDManager = new (Outer) class'LCDManager';
		LCDManager.Initialize(tppController);
	}
}

/**
 * Override Goodness - Removed Pause Text
 * Displays the transition screen.
 * @param Canvas - The canvas to use for rendering.
 */
function DrawTransition(Canvas Canvas)
{
	//local int i;
	
    switch(Outer.TransitionType)
	{
		case TT_Loading:
			//Canvas.SetOrigin(0,0);
			//Canvas.SetPos(0,0);
			//i = Rand(LoadingScreens.Length);
			//Canvas.DrawMaterialTile(LoadingScreens[i-1], Canvas.SizeX, Canvas.SizeX);
			//Canvas.SetOrigin(0,0);
            //DrawTransitionMessage(Canvas,LoadingMessage);
			//`log("LOADING!!!!!!!!");
			DisplayLoadingScreen();
			break;
		case TT_Saving:
			DrawTransitionMessage(Canvas,SavingMessage);
			break;
		case TT_Connecting:
			DrawTransitionMessage(Canvas,ConnectingMessage);
			break;
		case TT_Precaching:
			DrawTransitionMessage(Canvas,PrecachingMessage);
			break;
		//case TT_Paused:
		//	DrawTransitionMessage(Canvas,PausedMessage);
		//	break;
	}
}

event Tick(float DeltaTime)
{
	//// Go back ot the main menu if we lose our network cable
	//if (GetCurrentWorldInfo().NetMode != NM_Standalone && HasNetworkDisconnected())
	//{
	//	class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Title>", Localize("NetworkMessages", "DisconnectedTitle", "TPGame"));
	//	class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Message>", Localize("NetworkMessages", sconnectedMessage", "TPGame"));
	//	class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Display>", "1");
	//	class'UIRoot'.static.SetDataStoreStringValue("<Registry:FrontEndError_Online>", "1");
	//	
	//	`log("TPGameViewportClient::Tick() caused disconnect due to HasNetworkDisconnected().");

	//	ConsoleCommand("disconnect");
	//}
	if (bLoadingScreenActive)
	{
		// check and make sure our loading screen is actually up (if it isn't, we need to open it again)
		/*if (UIController.FindSceneByTag('LoadingScreenDefault') == None)
		{
			`log("No loading screen found, opening it again");
			UIController.OpenScene(UIScene'UI_LoadingScreens.LoadingScreenDefault');
		}*/
	
		if (!FullScreenIsMoviePlaying())
		{
			LCDManager.ShowLoading();
			//`log("NO MOVIE STARTING LOADING SCREEN!");
			FullScreenPlayMovie('LoadingScreen', PLAYMOVIE_StreamLoop);
		}

		LoadingScreenActiveTime += DeltaTime;
		if (!GetCurrentWorldInfo().IsConsoleBuild() && !bLoadingCampaignMap && LoadingScreenActiveTime > 120.0f)
		{
			;
			EndLoadingScreen();
		}
	}

	if ( FullScreenIsMoviePlaying() == false )
		ClearBinkMovieLaunchedFromUTPGameViewportClient();
}

simulated function bool HasNetworkDisconnected()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	// If there is an online subsystem, add our callback for UI changes
	if (OnlineSub != None)
	{
		if (OnlineSub.SystemInterface != None)
		{
			return !OnlineSub.SystemInterface.HasLinkConnection();
		}
	}

	return false;
}

simulated event DisplayLoadingScreen()
{
	if (!bLoadingScreenActive && !FullScreenIsMoviePlaying())
	{
		LCDManager.ShowLoading();
		//`log("RUNNING DISPLAY LOADING SCREEN!!!!!!");
		//UIController.OpenScene(UIScene'UI_LoadingScreens.LoadingScreenDefault');
		FullScreenPlayMovie('LoadingScreen', PLAYMOVIE_StreamLoop);
	}

	LoadingScreenActiveTime = 0.0f;
	bLoadingScreenActive = true;

	if (InStr(Locs(GetCurrentWorldInfo().GetLocalURL()), "gamemaps") == -1)
		bLoadingCampaignMap = false;
	else
		bLoadingCampaignMap = true;
}

simulated event EndLoadingScreen()
{
	if (bLoadingScreenActive)
	{
		//`log("RUNNING END LOADING SCREEN!!!!!!");
		bLoadingScreenActive = false;
		//UIController.CloseScene(UIScene'UI_LoadingScreens.LoadingScreenDefault');
		if (FullScreenIsMoviePlaying('LoadingScreen'))
		{
			LCDManager.ShowSplash();
			FullScreenStopMovie('LoadingScreen', false);
		}
	}
}


event PostRender(Canvas Canvas)
{
	if( BluffInteractionObj != none )
		BluffInteractionObj.PostRender(Canvas);

	if (LSInteraction != none)
	   LSInteraction.PostRender(Canvas);

	if (GrappleInteractionObj != None )
		GrappleInteractionObj.PostRender(Canvas);
		
	if(ObjectiveInteractionObj != none)
	   ObjectiveInteractionObj.PostRender(Canvas);
	   
	if(TPShellInteraction != none)
	   TPShellInteraction.PostRender(Canvas);




    if(GrappleInteraction_v2Obj != none)
	   GrappleInteraction_v2Obj.PostRender(Canvas);

    if(BGBInteraction != none)
	   BGBInteraction.PostRender(Canvas);

    //if(MPInteraction != none)
	//   MPInteraction.PostRender(Canvas);

	Super.PostRender(Canvas);
}

event PreScreenShot()
{
	;
	bOldDisplayDiagnostics = bDisplayDiagnostics;
	bDisplayDiagnostics = false;
}
event PostScreenShot()
{
	;
	bDisplayDiagnostics = bOldDisplayDiagnostics;
}

native simulated function FullScreenPlayMovie(name MovieName, ePlayMovie PlayMovieMode);
native simulated function FullScreenStopMovie(name MovieName, bool bWaitForFinish);
native simulated function FullScreenPauseMovie(bool bInPause);
// If no name is passed, it matches against any movie
native simulated function bool FullScreenIsMoviePlaying(optional name MovieName = '');
native simulated function bool FullScreenIsMoviePaused();
native function ClearBinkMovieLaunchedFromUTPGameViewportClient();
native function bool ShouldDisplayDiagnostics();

function SetDisplayDiagnostics(bool bNewVal)
{
	bDisplayDiagnostics = bNewVal;

	if (bDisableDiagnosticsAndCopyright || !ShouldDisplayDiagnostics())
	{
		bDisplayDiagnostics = false;
	}
}

exec function ToggleDiagnostics()
{
	bDisplayDiagnostics = !bDisplayDiagnostics;	

	if (bDisableDiagnosticsAndCopyright || !ShouldDisplayDiagnostics())
	{
		bDisplayDiagnostics = false;
	}
}

/** called before rending subtitles to allow the game viewport to determine the size of the subtitle area
 * @param Min top left bounds of subtitle region (0 to 1)
 * @param Max bottom right bounds of subtitle region (0 to 1)
 */
event GetSubtitleRegion(out vector2D MinPos, out vector2D MaxPos)
{
	MaxPos.X = 1.0f;
	MaxPos.Y = (GamePlayers.length == 1) ? 0.75f : 0.5f;
}

