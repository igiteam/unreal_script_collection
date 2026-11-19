/**
 * DifficultyScreen
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Difficulty extends GearGFxMoviePlayer
	Config(UI);

// --- Widget References ------------------------------
/** The containing object for all of our widgets. Used to provide easy access to actionscript functionality. */
var transient GFxObject MainBag;

/** The difficulty selectors (there are two) */
var transient UIWidget_DifficultySelector DifficultySelectors[2];

/** The timer */
var transient GFxObject TimerLabel;

/** Whether or not the scene is ready */
var transient bool bReady;

/** Whether or not this is the first selection made */
var transient bool bIsFirstSelection;

/** The countdown time for difficulty selection */
var config int DifficultySelectCountdownTime;

/** Reference to the parent front end movie that spawned this one */
var transient UIScene_FrontEnd FrontEndReference;

/** Array of difficulty classes in order */
var array< class <DifficultySettings> > DifficultyClasses;


//==============================================================
// Localized strings
//==============================================================

var localized string SelectBB;
var localized string BackBB;
var localized array<string> DifficultyNames;
var localized string SceneTitle;

//==============================================================
// MoviePlayer function
//==============================================================

/** 
 *  This should be called when a new GearGFxMoviePlayer is initialized.
 *  
 *  @param Player - Local player that is to be the owner of this scene
 */
function Init(optional LocalPlayer Player)
{
	local GearPRI PRI;

	super.Init(Player);

	FlushPlayerInput(FALSE);
	if (FrontEndReference != none)
	{
		FrontEndReference.BlurMainMenu();

		//If this is the host, we need to quickly write into the PRI that he hasn't selected anything
		if (GetGearPC().Role == ROLE_Authority)
		{
			PRI = GearPRI(GetGearPC().PlayerReplicationInfo);
			PRI.bDifficultySelectionMade = false;
			PRI.bNetDirty = true;
			PRI.bForceNetUpdate = true;
		}
	}
}

/**
 *  Called when the menu is closed, after it has animated out
 */
event OnClose()
{
	local GearPartyGRI PartyGRI;
	if (FrontEndReference != none)
	{
		FrontEndReference.DifficultyScene = none;
		if (FrontEndReference.GetGearPC().Role == ROLE_Authority)
		{
			PartyGRI = GearPartyGRI(FrontEndReference.GetGRI());
			if (PartyGRI != none)
			{
				PartyGRI.bDifficultySelection = false;
				PartyGRI.bForceNetUpdate = true;
			}
		}
		FrontEndReference.UnblurMainMenu();
	}
	super.OnClose();
}

/** 
 *  Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	`log("Difficulty WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
		//Main view
		case 'DifficultySelectMain':
			MainBag = Widget;
			break;
		//Buttonbar
		case 'ControllerMap':
			if (GetPC().Role == ROLE_Authority)
			{
				Widget.SetString("htmlText",SelectBB $ " " $ BackBB);
			}
			else
			{
				Widget.SetString("htmlText",SelectBB);
			}
			break;
		//The UIWidget_DifficultySelector widgets
		case 'DifficultySelectPlayer0':
			DifficultySelectors[0] = UIWidget_DifficultySelector(Widget);
			DifficultySelectors[0].OwningPlayer = GetGPCByLocalPlayerIndex(0);
			SetWidgetPathBinding(DifficultySelectors[0], WidgetPath);
			break;
		case 'DifficultySelectPlayer1':
			DifficultySelectors[1] = UIWidget_DifficultySelector(Widget);
			DifficultySelectors[1].OwningPlayer = GetGPCByLocalPlayerIndex(1);
			SetWidgetPathBinding(DifficultySelectors[1], WidgetPath);
			break;
		//The timer
		case 'lblTimer':
			TimerLabel = Widget;
			TimerLabel.SetString("text","");
			break;
		//The act and chapter
		case 'lblActChapter':
			Widget.SetString("text",DetermineActChapterText());
			break;
		//The title of the scene
		case 'lblSceneTitle':
			Widget.SetString("htmlText", SceneTitle);
			break;
		default:
			`log("Unhandled widget in UIScene_Difficulty: " @ WidgetPath,, 'GearsUI');
			return false;
	}
	return true;
}

/**
 * Callback after all widgets have been initialized in a frame
 */
function PostWidgetInit()
{
	local int i, DifficultyIndex;
	local array<ASValue> args;
	local ASValue ASVal;
	local GearPC GPC;

	//PostWidgetInit the subwidgets
	for (i = 0; i < 2; i++)
	{
		if (DifficultySelectors[i] != none)
		{
			DifficultySelectors[i].SubPostWidgetInit();
		}
	}

	//If this is our first PostWidgetInit, get the party going!
	if (!bReady)
	{	
		ASVal.Type = AS_Number;

		for (i = 0; i < 2; i++)
		{
			if (class'Engine'.static.GetEngine().GamePlayers.Length > i)
			{
				//Controller
				ASVal.n = class'Engine'.static.GetEngine().GamePlayers[i].ControllerId;
				args.AddItem(ASVal);

				//Difficulty
				ASVal.n = 0;
				GPC = GearPC(class'Engine'.static.GetEngine().GamePlayers[i].Actor);
				if (GPC != none)
				{
					GPC.ProfileSettings.GetProfileSettingValueId(`GameIntensity,DifficultyIndex);
					ASVal.n = DifficultyIndex;
				}
				args.AddItem(ASVal);
			}
			else
			{
				//Controller
				ASVal.n = -1;
				args.AddItem(ASVal);
				//Difficulty
				args.AddItem(ASVal);
			}
		}

		ASVal.Type = AS_Boolean;
		GPC = GearPC(GetPC());
		ASVal.b = (GPC != None && GPC.Role == ROLE_Authority);
		args.AddItem(ASVal);

		MainBag.Invoke("Initialize",args);
		bReady = true;
	}
}

/** 
 * Can be overridden to filter input to this movie.
 * 
 * @param   ControllerId    ID of the controller which created the input
 * @param   ButtonName      Name of the button pressed
 * @param   InputEvent      What type of input event this was (i.e. pressed, hold, release)
 * 
 * @return  TRUE to trap the input, FALSE to let it pass through to Gfx
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	return FALSE;
}

/** Starts the countdown to game start */
function StartDifficultySelectionTimer()
{
	local GearPartyGRI PartyGRI;

	PartyGRI = GearPartyGRI(GetGRI());
	//If there is more than one player start the countdown
	if (PartyGRI != none)
	{
		if (GetPC().WorldInfo.Game.NumPlayers > 1)
		{
			PartyGRI.ResetMainMenuCountdownTimer(DifficultySelectCountdownTime);
		}
		else
		{
			//Kill the countdown
			PartyGRI.MainMenuCountdownTimer = -1;
		}
	}
}

/**
 * Called when something has happened to the secondary player (added or removed)
 * 
 * @param ControllerId - The controller Id for the secondary player, -1 if the secondary player does not exist
 * @param DifficultyIndex - The default difficulty index for the secondary player
 */
final function ModifySecondaryController(int ControllerId, int DifficultyIndex)
{
	local array<ASValue> args;
	local ASValue ASVal;
	local GFxObject DataProvider;
	local int i;

	if (DifficultySelectors[1] != none && DifficultySelectors[1].DifficultyList != none)
	{
		DataProvider = DifficultySelectors[1].DifficultyList.GetObject("dataProvider");

		for(i=0; i < 4; i++)
		{
			if (DifficultyIndex == i)
			{
				DataProvider.SetElementMemberBool(i,"bIsChosen",true);
			}
			else
			{
				DataProvider.SetElementMemberBool(i,"bIsChosen",false);
			}
		}

		args.Length = 0;
		DifficultySelectors[1].DifficultyList.Invoke("invalidateData",args);
	}


	ASVal.Type = AS_Number;
	//Controller
	ASVal.n = class'Engine'.static.GetEngine().GamePlayers[0].ControllerId;
	args.AddItem(ASVal);
	//Difficulty
	ASVal.n = -1;
	args.AddItem(ASVal);

	//Controller
	ASVal.n = ControllerId;
	args.AddItem(ASVal);
	//Difficulty
	ASVal.n = DifficultyIndex;
	args.AddItem(ASVal);

	MainBag.Invoke("ModifyControllers",args);
}

/**
 * Main update function
 * 
 * @param DeltaTime - Time since the last update
 */
final function UpdateDiffScreen(float DeltaTime)
{
	local GearPartyGRI PartyGRI;
	local array<ASValue> args;
	local int DifficultyIndex, i;
	local array<int> NumPlayersSelected;
	local GearPC GPC;
	local GearPRI PRI;
	local PlayerReplicationInfo TempPRI;
	local bool bPlayerDiffsChanged;


	PartyGRI = GearPartyGRI(GetGRI());
	if (bReady && PartyGRI != none)
	{
		if (PartyGRI.MainMenuCountdownTimer > 0)
		{
			if (TimerLabel.GetString("htmlText") != string(PartyGRI.MainMenuCountdownTimer))
			{
				//timer has advanced, play sound
				PlaySoundFromTheme('Difficulty_CountTick');
			}
			TimerLabel.SetString("htmlText",string(PartyGRI.MainMenuCountdownTimer));
		}
		else
		{
			TimerLabel.SetString("htmlText","");
			if (PartyGRI.MainMenuCountdownTimer == 0)
			{
				//Start the fadeout
				args.Length = 0;
				MainBag.Invoke("StartingGame",args);
				//Start the campaign
				FrontEndReference.StartCampaign();
				PartyGRI.MainMenuCountdownTimer = -1;
			}
		}

		//Figure out how many people have selected each difficulty
		//Zero the array of players difficulties
		NumPlayersSelected.length = DifficultyClasses.Length;
		for (i=0; i < NumPlayersSelected.Length; i++)
		{
			NumPlayersSelected[i] = 0;
		}

		
		//For each difficulty tally the number of players who have selected it
		foreach PartyGRI.PRIArray(TempPRI)
		{
			PRI = GearPRI(TempPRI);
			//Only count the ones who have made a selection (everyone but host primary is pre-selected)
			if (PRI.bDifficultySelectionMade)
			{
				DifficultyIndex = GetDifficultyIndexFromDifficultyClass(PRI.Difficulty);
				if (DifficultyIndex != INDEX_NONE)
				{
					NumPlayersSelected[DifficultyIndex]++;
				}
			}
		}

		//Figure out what the local player's have selected and subtract them so the numbers are all from non-local players
		foreach GetPC().WorldInfo.AllControllers(class'GearPC', GPC)
		{
			if (GPC.IsLocalPlayerController() && GearPRI(GPC.PlayerReplicationInfo).bDifficultySelectionMade)
			{
				DifficultyIndex = GetDifficultyIndexFromDifficultyClass(GearPRI(GPC.PlayerReplicationInfo).Difficulty);
				if (DifficultyIndex != INDEX_NONE)
				{
					NumPlayersSelected[DifficultyIndex]--;
				}
			}
		}

		//Update the difficulty list numbers
		for (i=0; i < 2; i++)
		{
			bPlayerDiffsChanged = DifficultySelectors[i].UpdateNumPlayersSelected(NumPlayersSelected);
		}

		if (bPlayerDiffsChanged)
		{
			PlaySoundFromTheme('Difficulty_OtherPlayerSelect');
		}
	}
}


/** Helper function to get the GearPC referenced by the given local player index
 *  
 *  @param LocalPlayerIndex - the index to get the gear pc for
 *  
 *  @return The gearpc corresponding to the given local player index
 */
function GearPC GetGPCByLocalPlayerIndex(int LocalPlayerIndex)
{
	local GearPC GPC;
	local Engine Eng;

	Eng = class'Engine'.static.GetEngine();

	if (LocalPlayerIndex < 0 || LocalPlayerIndex >= Eng.GamePlayers.Length)
	{
		return none;
	}

	//Find the PC that this controller represents
	foreach GetPC().LocalPlayerControllers(class'GearPC',GPC)
	{
		if (GearLocalPlayer(GPC.Player) == Eng.GamePlayers[LocalPlayerIndex])
		{
			return GPC;
		}
	}
	return None;
}


/**
 * Function that determines what text should appear in the act/chapter label
 * 
 * @return the text that should appear in the act/chapter label
 */
function string DetermineActChapterText()
{
	local int SelectedChapter;
	local GearCampaignChapterData ChapProvider;
	local GearCampaignActData ActProvider;

	SelectedChapter = FrontEndReference.SelectedChapter;
	
	ChapProvider = class'GearUIDataStore_GameResource'.static.GetChapterDataProvider(SelectedChapter);
	ActProvider = class'GearUIDataStore_GameResource'.static.GetActDataProvider(ChapProvider.ActNum);

	return ActProvider.DisplayName $", "$ ChapProvider.DisplayName;

}

/**
 * Helper function to get the index of the difficulty from a specific difficulty class
 * 
 * @param DifficultyClass - the difficulty class we want to get the index for
 * 
 * @return the index of DifficultyClass, INDEX_NONE if we don't know
 */
function int GetDifficultyIndexFromDifficultyClass(class<DifficultySettings> DifficultyClass)
{
	local int i;

	for (i=0; i < DifficultyClasses.Length; i++)
	{
		if (DifficultyClasses[i] == DifficultyClass)
		{
			return i;
		}
	}
	return INDEX_NONE;
}

/**
 * Fade the scene out
 */
function CloseSceneGracefully()
{
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_String;
	ASVal.s = "fadeOutCancel";
	args.AddItem(ASVal);

	MainBag.Invoke("gotoAndPlay",args);
}

//==============================================================
// ActionScript Callbacks
//==============================================================

/**
 * Callback when an option was selected
 * 
 * @param   ControllerID - The controller id of the controller that selected something
 * @param   DifficultyIndex - Index of the option that was selected from the menu
 */
function Callback_OptionWasSelected(int ControllerID, int DifficultyIndex)
{
	local GearPC GPC;

	//Find the PC that this controller represents
	foreach GetPC().LocalPlayerControllers(class'GearPC',GPC)
	{
		if (GearLocalPlayer(GPC.Player).ControllerId == ControllerID)
		{
			GPC.ProfileSettings.SetProfileSettingValueId(`GameIntensity, DifficultyIndex);
			GPC.UpdateDifficultySetting();
			GPC.ServerDifficultySelected(true);
			break;
		}
	}
}

/** Callback for when the server aborts from the difficulty selection screen 
 *  NOTE - the actionscript is set up so only the server primary player should even be able to call this  
 **/
function Callback_Abort()
{
	GetGearPC().ServerDifficultySelected(false);
	FrontEndReference.ReturnFromDifficulty();
}

/**
 * Callback from actionscript when the scene has finished fading out.  This performs the latent action selected by the user
 */
function Callback_DoneFadingOut()
{
	Close();
}


defaultproperties
{
	bIsFirstSelection = true

	bCaptureInput=TRUE
	bOnlyOwnerFocusable=false
	bPauseGameWhileActive=false

	OnPostAdvance=UpdateDiffScreen

	WidgetBindings.Add((WidgetName="DifficultySelectPlayer0",WidgetClass=class'UIWidget_DifficultySelector'))
	WidgetBindings.Add((WidgetName="DifficultySelectPlayer1",WidgetClass=class'UIWidget_DifficultySelector'))

	CaptureKeys.Empty()
	CaptureKeys(0)=XboxTypeS_Start
	CaptureKeys(1)=XboxTypeS_A
	CaptureKeys(2)=XboxTypeS_B
	CaptureKeys(3)=XboxTypeS_X
	CaptureKeys(4)=XboxTypeS_Y
	CaptureKeys(5)=XboxTypeS_DPad_Up
	CaptureKeys(6)=XboxTypeS_DPad_Down
	CaptureKeys(7)=XboxTypeS_DPad_Right
	CaptureKeys(8)=XboxTypeS_DPad_Left
	CaptureKeys(9)=Gamepad_LeftStick_Up
	CaptureKeys(10)=Gamepad_LeftStick_Down
	CaptureKeys(11)=Gamepad_LeftStick_Right
	CaptureKeys(12)=Gamepad_LeftStick_Left

	DifficultyClasses.Add(class'DifficultySettings_Casual')
	DifficultyClasses.Add(class'DifficultySettings_Normal')
	DifficultyClasses.Add(class'DifficultySettings_Hardcore')
	DifficultyClasses.Add(class'DifficultySettings_Insane')
}
