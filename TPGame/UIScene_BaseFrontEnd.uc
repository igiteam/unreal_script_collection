class UIScene_BaseFrontEnd extends UIScene_BaseHudScene;

// Directional Menu Controls
enum eMenuStyle
{
	VERTICAL_MENU,
	HORIZONTAL_MENU,
};

struct MenuInfo
{
	var UILabelButton wMenuButton;		// The actual label button widget for the menu,  it gets filled in from the ButtonName
	var string ButtonName;				// The name of the Label Button to find in the scene
	var UIScene SceneRef;				// The reference to the scene
	var name RemoteEvent;				// If not none, then activate all the remote events tied to this name
	var string CheckboxName;
	var UICheckbox wCheckbox;			// If this menu item is associated with a checkbox, this is set
	var int CheckboxProfileId;			// Profile setting Id the checkbox corresponds to
	var string SliderName;
	var UISlider wSlider;				// if this menu is associated with a slider, this is set
	var int SliderProfileId;			// Profile setting Id the slider corresponds to
	var string SliderValueName;			// This is for if you want to have a numerical representation of the slider also visible on screen
	var UILabel wSliderValue;
	var float SliderValueConversion;	// Divisor to convert actual slider's int value to what you want to display
	var int SliderValueTruncate;		// Only show X characters of the resulting value
	var bool bOnlyCallOnClick;
	var bool bCallLeftRight;
	var bool bDisabled;
};

// All of the Menu Items
var array<MenuInfo> MenuItems;
// The Current Selected Index
var int CurrentSelectedIndex;
// Whether to cycle the menu up and down or left and right
var eMenuStyle MenuStyle;

// The Scene Root
var UIScene RootScene;
var bool bOnlineMenu;

// The Previous Scene if there is one
var UIScene_BaseFrontEnd PreviousMenuScene;

// The Local Player
var LocalPlayer LocPlayer;

// Delay before accepting the next button press
var float ButtonDelay;
var float CurrentButtonDelay;
var bool bNoInput;

var TPPlayerController myTPC;

var UIScene MessageBoxScene;
var UIScene_Keyboard KeyboardScene;

var string LevelName; // Name of the current level

var name ExitRemoteEvent;

var UILabel HelperText;
var string HelperMarkupPC;
var string HelperMarkupPS3;
var string HelperMarkupPS3Circle;

var string DialogHelperMarkupPC;
var string DialogHelperMarkupPS3;
var string DialogHelperMarkupPS3Circle;

// This is used so a UIScene derived from BaseFrontEnd doesn't have to hold a native script reference if it doesnt' want to.
// It is assumed that the length of this is equivalent to the length of MenuItems (so insert Nones for ones you need to be None)
var() array<UIScene> mySceneRefs;

var localized string ExitMessage, ExitTitle;

var() bool bWaitToShowInMainMenu;
var() float TimeToWait;
var float CurrTime;
var() bool bGoBackWithNoPrevScene;

var GameUISceneClient GameSceneClient;

function NotifyLoginStatusChanged( bool bLoggedIn )
{
	if ( RootScene == self )
		return;

	Super.NotifyLoginStatusChanged( bLoggedIn );
}

function NotifyLinkStatusChanged( bool bConnected )
{
	local UIScene ParentScene;

	ParentScene = GetPreviousScene(false);
	if ( !bConnected && bOnlineMenu )
	{
		//@todo - should we always force the scene closed without allowing it to perform closing animations?
		// seems like we'd only want to do this if the this is not the last scene being closed.  but then again,
		// we will usually be displaying a message box or something to notify the user that the network status changed
		// so perhaps it's best to skip all animations
		
		GetPC().SetDisconnectionError(FRONTEND_MENU, true);

		CloseScene( Self, true, true );
	}

	// propagate to the scene below this one
	if ( ParentScene != None )
	{
		ParentScene.NotifyLinkStatusChanged(bConnected);
	}
}

function SetHelperText()
{
	HelperText = UILabel(FindChild('HelperText', true));

	if (HelperText != None)
	{
		//`log("myTPC.PlayerInput.bUsingGamepad"@myTPC.PlayerInput.bUsingGamepad);
		if (!GetWorldInfo().IsConsoleBuild() && !myTPC.PlayerInput.bUsingGamepad)
		{
			HelperText.SetDatastoreBinding(HelperMarkupPC);
		}
		else if (GetWorldInfo().IsPS3Build())
		{
			if (!GetWorldInfo().UseCircleToAccept())
				HelperText.SetDatastoreBinding(HelperMarkupPS3);
			else
				HelperText.SetDatastoreBinding(HelperMarkupPS3Circle);
		}
	}
}

// When we press the A Button to select the Menu Item this function gets called
function OnClick(UIScene OpenedScene, int MenuIndex);

function OnLeftRight(int MenuIndex, bool bRight);

function OnSliderChange(int MenuIndex, bool Positive)
{
	local int NewVal;

	if (myTPC != None)
	{
		NewVal = MenuItems[MenuIndex].wSlider.GetValue();
		if (Positive)
			NewVal++;
		else
			NewVal--;

		if (MenuItems[MenuIndex].wSlider.SetValue(NewVal))
		{
			//`log("Setting"@MenuItems[MenuIndex].SliderProfileId@"to"@NewVal);
			myTPC.ProfileSettings.SetProfileSettingValueInt(MenuItems[MenuIndex].SliderProfileId, NewVal);
			if (MenuItems[MenuIndex].wSliderValue != None && MenuItems[MenuIndex].SliderValueConversion != 0.0f)
			{
				MenuItems[MenuIndex].wSliderValue.SetValue(Left((NewVal / MenuItems[MenuIndex].SliderValueConversion),MenuItems[MenuIndex].SliderValueTruncate));
			}
		}
	}
}

function OnCheckBoxClick(int MenuIndex)
{
	local bool NewVal;

	if (myTPC != None)
	{
		NewVal = !MenuItems[MenuIndex].wCheckbox.IsChecked();
		MenuItems[MenuIndex].wCheckbox.SetValue(NewVal);
		if (NewVal)
			myTPC.ProfileSettings.SetProfileSettingValueId(MenuItems[MenuIndex].CheckboxProfileId, 1);
		else
			myTPC.ProfileSettings.SetProfileSettingValueId(MenuItems[MenuIndex].CheckboxProfileId, 0);
	}
}

function ResetCheckbox(int i)
{
	local int TempValue;

	if (MenuItems[i].wCheckbox != None)
	{
		myTPC.ProfileSettings.GetProfileSettingValueId(MenuItems[i].CheckboxProfileId, TempValue);
		//`log("Profile value set to"@TempValue);
		if (TempValue == 0)
			MenuItems[i].wCheckbox.SetValue(false);
		else
			MenuItems[i].wCheckbox.SetValue(true);
	}
	else
	{
		;
	}
}
function ResetSlider(int i)
{
	local int TempValue;

	if (MenuItems[i].wSlider != None)
	{
		myTPC.ProfileSettings.GetProfileSettingValueInt(MenuItems[i].SliderProfileId, TempValue);
		//`log("Profile value set to"@TempValue);
		MenuItems[i].wSlider.SetValue(TempValue);
		if (MenuItems[i].SliderValueName != "")
		{
			MenuItems[i].wSliderValue = UILabel(FindChild(name(MenuItems[i].SliderValueName), true));
			if (MenuItems[i].wSliderValue != None && MenuItems[i].SliderValueConversion != 0.0f)
			{
				MenuItems[i].wSliderValue.SetValue(Left((TempValue / MenuItems[i].SliderValueConversion),MenuItems[i].SliderValueTruncate));
			}
		}
	}
	else
	{
		;
	}
}

event InitScene()
{
	local int i;
	local int LevelNameIndex;

	// Assign the player
	LocPlayer = GetPlayerOwner();
	myTPC = GetPC();
	
;	
	
	LevelName = Repl( Locs(myTPC.WorldInfo.GetLocalURL()), ".tpm", "" );
	LevelNameIndex = InStr(LevelName, "?");
	LevelName = Left(LevelName, LevelNameIndex);

	//`log("LevelName is'"$LevelName$"'");

	if (RootScene == none)
		RootScene = self;
	
	if (myTPC.OnlineSub.SystemInterface != None)
	{
		// Set the system wide connection changed callback
		//myTPC.OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
		//myTPC.OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChange);
	}

	for (i = 0; i < MenuItems.Length; i++)
	{
		MenuItems[i].wMenuButton = UILabelButton( FindChild( name( MenuItems[i].ButtonName ), true ) );

		if (mySceneRefs.Length != 0)
		{
			MenuItems[i].SceneRef = mySceneRefs[i];
		}

		if (MenuItems[i].wMenuButton != none)
		{
			MenuItems[i].wMenuButton.ActivateStateByClass(class'UIState_Enabled',0);
			if (MenuItems[i].CheckboxName != "")
			{
				//`log("CheckboxName is"@MenuItems[i].CheckboxName);
				MenuItems[i].wCheckbox = UICheckbox(FindChild(name(MenuItems[i].CheckboxName), true));
				ResetCheckbox(i);
			}
			else if (MenuItems[i].SliderName != "")
			{
				//`log("SliderName is"@MenuItems[i].SliderName);
				MenuItems[i].wSlider = UISlider(FindChild(name(MenuItems[i].SliderName), true));
				ResetSlider(i);
			}
		}
		else
		{
			;
		}
	}

	if (MenuItems.Length > 0)
	{
		//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.Pulse(MenuItems[CurrentSelectedIndex].MaxPulseAlpha, MenuItems[CurrentSelectedIndex].MinPulseAlpha, MenuItems[CurrentSelectedIndex].PulseRate);
		
		//MenuItems[0].wMenuButton.SetFocus(MenuItems[0].wMenuButton.GetOwner());
		
		//Kelly says - How about we set focus to the currentselectedindex..
		CurrentSelectedIndex = Clamp(CurrentSelectedIndex, 0, MenuItems.Length-1);
		MenuItems[CurrentSelectedIndex].wMenuButton.SetFocus(MenuItems[CurrentSelectedIndex].wMenuButton.GetOwner());
	}

	OnRawInputKey=CustomInputKey;
	SetHelperText();

	GameSceneClient = GameUISceneClient(SceneClient);

	if (!bWaitToShowInMainMenu)
		SetVisibility(true);

	super.InitScene();

	// Delay button input at the start of the scene
	DelayButtonInput();
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	local bool bLocalNoInput;
	local TPGameViewportClient viewport;
    viewport = TPGameViewportClient(LocalPlayer(myTPC.Player).ViewportClient);

	bLocalNoInput = false;
	//Hack for PS3
	if ( GetWorldInfo().IsConsoleBuild(CONSOLE_PS3) == true )
	{
		if (myTPC != none && !myTPC.IsControllerConnected())
		{
			//Somehow we're getting inputkey event even though we're not connected!
			bLocalNoInput = true;
		}
	}

	if (!bLocalNoInput && !bNoInput && myTPC.bAllowUIInput && !viewport.FullScreenIsMoviePlaying() && Opacity == 1.0f)
	{
		if (MenuItems.Length > 0)
		{
			switch( MenuStyle )
			{
				case HORIZONTAL_MENU:
					
					if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') 
						|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) )
					{
						if (MenuItems.Length > 1)
							PlayUISound('NavigateLeft');

						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.ResetFade();
						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.Fade(0.0f, 1.0f, 0.0f);
						MenuItems[CurrentSelectedIndex].wMenuButton.KillFocus(MenuItems[CurrentSelectedIndex].wMenuButton.GetOwner());

						do
						{
							CurrentSelectedIndex--;
							if (CurrentSelectedIndex < 0)
								CurrentSelectedIndex = MenuItems.Length - 1;
						} until (!MenuItems[CurrentSelectedIndex].bDisabled);

						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.Pulse(MenuItems[CurrentSelectedIndex].MaxPulseAlpha, MenuItems[CurrentSelectedIndex].MinPulseAlpha, MenuItems[CurrentSelectedIndex].PulseRate);
						MenuItems[CurrentSelectedIndex].wMenuButton.SetFocus(MenuItems[CurrentSelectedIndex].wMenuButton.GetOwner());
						DelayButtonInput();

						return true;
					}
					if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right') 
						|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) )
					{
						if (MenuItems.Length > 1)
							PlayUISound('NavigateRight');

						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.ResetFade();
						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.Fade(0.0f, 1.0f, 0.0f);
						MenuItems[CurrentSelectedIndex].wMenuButton.KillFocus(MenuItems[CurrentSelectedIndex].wMenuButton.GetOwner());
						
						do
						{
							CurrentSelectedIndex++;
							if (CurrentSelectedIndex > MenuItems.Length - 1)
								CurrentSelectedIndex = 0;
						} until (!MenuItems[CurrentSelectedIndex].bDisabled);

						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.Pulse(MenuItems[CurrentSelectedIndex].MaxPulseAlpha, MenuItems[CurrentSelectedIndex].MinPulseAlpha, MenuItems[CurrentSelectedIndex].PulseRate);
						MenuItems[CurrentSelectedIndex].wMenuButton.SetFocus(MenuItems[CurrentSelectedIndex].wMenuButton.GetOwner());
						DelayButtonInput();
						
						return true;
					}

				break;
				case VERTICAL_MENU:

					if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Up' || EventParms.InputKeyName == 'Gamepad_LeftStick_Up') 
						|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Up')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) )
					{
						if (MenuItems.Length > 1)
							PlayUISound('NavigateUp');

						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.ResetFade();
						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.Fade(0.0f, 1.0f, 0.0f);
						MenuItems[CurrentSelectedIndex].wMenuButton.KillFocus(MenuItems[CurrentSelectedIndex].wMenuButton.GetOwner());

						do
						{
							CurrentSelectedIndex--;
							if (CurrentSelectedIndex < 0)
								CurrentSelectedIndex = MenuItems.Length - 1;
						} until (!MenuItems[CurrentSelectedIndex].bDisabled);

						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.Pulse(MenuItems[CurrentSelectedIndex].MaxPulseAlpha, MenuItems[CurrentSelectedIndex].MinPulseAlpha, MenuItems[CurrentSelectedIndex].PulseRate);
						MenuItems[CurrentSelectedIndex].wMenuButton.SetFocus(MenuItems[CurrentSelectedIndex].wMenuButton.GetOwner());
						DelayButtonInput();

						return true;
					}
					if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Down' || EventParms.InputKeyName == 'Gamepad_LeftStick_Down') 
						|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Down')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) )
					{
						if (MenuItems.Length > 1)
							PlayUISound('NavigateDown');

						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.ResetFade();
						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.Fade(0.0f, 1.0f, 0.0f);
						MenuItems[CurrentSelectedIndex].wMenuButton.KillFocus(MenuItems[CurrentSelectedIndex].wMenuButton.GetOwner());

						do
						{
							CurrentSelectedIndex++;
							if (CurrentSelectedIndex > MenuItems.Length - 1)
								CurrentSelectedIndex = 0;
						} until (!MenuItems[CurrentSelectedIndex].bDisabled);

						//MenuItems[CurrentSelectedIndex].wMenuButton.StringRenderComponent.Pulse(MenuItems[CurrentSelectedIndex].MaxPulseAlpha, MenuItems[CurrentSelectedIndex].MinPulseAlpha, MenuItems[CurrentSelectedIndex].PulseRate);
						MenuItems[CurrentSelectedIndex].wMenuButton.SetFocus(MenuItems[CurrentSelectedIndex].wMenuButton.GetOwner());
						DelayButtonInput();
						
						return true;
					}

				break;
			}

			if (MenuItems[CurrentSelectedIndex].wSlider != None)
			{
				if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') 
						|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat))
					OnSliderChange(CurrentSelectedIndex, false);
				else if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right')
						|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat))
					OnSliderChange(CurrentSelectedIndex, true);
			}
			else if (MenuItems[CurrentSelectedIndex].bCallLeftRight)
			{
				if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') 
						|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat))
					OnLeftRight(CurrentSelectedIndex, false);
				else if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right')
						|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat))
					OnLeftRight(CurrentSelectedIndex, true);
			}

			// Selection
			if ( ((EventParms.InputKeyName == 'XboxTypeS_A') || (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Enter')) && EventParms.EventType == IE_Released )
			{
				if (!GetWorldInfo().UseCircleToAccept())
					HandleAccept();
				else
					HandleBack();
				
				return true;
			}
		}

		// Go Back
		if ( EventParms.InputKeyName == 'XboxTypeS_B' && EventParms.EventType == IE_Released )
		{
			if (!GetWorldInfo().UseCircleToAccept())
				HandleBack();
			else
				HandleAccept();
			
			return true;
		}
		if ((EventParms.InputKeyName == 'Escape') && !GetWorldInfo().IsConsoleBuild() && EventParms.EventType == IE_Released)
		{
			HandleBack();

			return true;
		}
	}

	// eat all other input
	return true;
}

event HandleAccept()
{
	local UIScene OpenedScene;
	local UIScene_BaseFrontEnd OpenedFrontEnd;

	if (MenuItems[CurrentSelectedIndex].bOnlyCallOnClick)
	{
		PlayUISound('Clicked');
		OnClick(None, CurrentSelectedIndex);
	}
	else if (MenuItems[CurrentSelectedIndex].SceneRef != none)
	{
		PlayUISound('Clicked');
		FadeInactive();
		ActivateRemoteEvent(MenuItems[CurrentSelectedIndex].RemoteEvent);
		SceneClient.OpenScene(MenuItems[CurrentSelectedIndex].SceneRef, LocPlayer, OpenedScene);
		OpenedFrontEnd = UIScene_BaseFrontEnd(OpenedScene);
		if (OpenedFrontEnd != none)
		{
			OpenedFrontEnd.PreviousMenuScene = self;
			OpenedFrontEnd.LocPlayer = LocPlayer;
			OpenedFrontEnd.RootScene = RootScene;
			if (LevelName == "entry_master" && OpenedFrontEnd.bWaitToShowInMainMenu)
				OpenedFrontEnd.CurrTime = OpenedFrontEnd.TimeToWait;
			else
				OpenedScene.SetVisibility(true);
		}
		OnClick(OpenedScene, CurrentSelectedIndex);
	}
	else if (MenuItems[CurrentSelectedIndex].wCheckbox != None)
	{
		PlayUISound('Clicked');
		OnCheckboxClick(CurrentSelectedIndex);
	}
}

event HandleBack()
{
	if (PreviousMenuScene != none || bGoBackWithNoPrevScene)
	{
		PlayUISound('SceneClosed');
		ActivateRemoteEvent(ExitRemoteEvent);
		SceneClient.CloseScene(self);
		if (PreviousMenuScene != none)
			PreviousMenuScene.SetVisibility(true);
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	if (bNoInput)
	{
		CurrentButtonDelay-=DeltaTime;
		if (CurrentButtonDelay <= 0.0f)
			ButtonDelayOver();
	}

	if (CurrTime > 0.0f)
	{
		CurrTime -= DeltaTime;
		if (CurrTime <= 0.0f)
			SetVisibility(true);
	}

	
	super.UpdateScene(DeltaTime, WorldInfo);
}

event SceneActivated( bool bInitialActivation )
{
	Super.SceneActivated(bInitialActivation);
	if (!bInitialActivation)
	{
		Restore();
	}
}

event SceneDeactivated()
{
	Cleanup();
	Super.SceneDeactivated();
}

function NotifyGameSessionEnded()
{
	CleanUp();
	Super.NotifyGameSessionEnded();
}

function ActivateRemoteEvent(name EventName)
{
	//local array<SequenceEvent> OutEvents; //SPARK MAY CODEDROP
	local array<SequenceObject> OutEvents;
	
	local SeqEvent_RemoteEvent RemoteEvt;
	local TPPlayerController TPC;
	local int i;

	if (EventName == '')
		return;

	TPC = GetPC();
	if (TPC != none)
	{
		if (TPC.WorldInfo.GetGameSequence() != None)
		{
			TPC.WorldInfo.GetGameSequence().FindSeqObjectsByClass(class'SeqEvent_RemoteEvent',TRUE,OutEvents);

			for (i = 0; i < OutEvents.Length; i++)
			{
				RemoteEvt = SeqEvent_RemoteEvent(OutEvents[i]);
				if (RemoteEvt != none && RemoteEvt.EventName == EventName)
				{
					if ( RemoteEvt.bEnabled)
					{
						// check activation for the event
						RemoteEvt.CheckActivate(TPC,TPC,false);
					}
				}
			}
		}
	}
}

function CleanUp()
{
	if (myTPC.OnlineSub.SystemInterface != None)
	{
		// Set the system wide connection changed callback
		//myTPC.OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
		//myTPC.OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChange);
		//`log("Cleared SystemInterface");
	}
}

event SetVisibility( bool bIsVisible )
{
	Super.SetVisibility(bIsVisible);

	if ( bIsVisible )
	{
		SetSceneInputMode( INPUTMODE_ActiveOnly);
	}
	else
	{
		SetSceneInputMode( INPUTMODE_None );
	}
}

function DelayButtonInput()
{
	bNoInput = true;
	CurrentButtonDelay = ButtonDelay;
}

function ButtonDelayOver()
{
	bNoInput = false;
}

function DisplayMessageBox(string Message, optional string Title = "", optional bool bSimpleMode = false)
{
	local UIScene TempScene;
	local UIScene_Confirmation ConScene;
	
	if ( SceneClient.OpenScene( MessageBoxScene, LocPlayer, TempScene ) )
	{
		FadeInactive();
		ConScene = UIScene_Confirmation(TempScene);
		if (ConScene != None)
		{
			ConScene.FadeIn(true);
			ConScene.SetVisibility(true);
			ConScene.OnSceneClose = Restore;
			ConScene.SetMessage(Message);
			
			if (bSimpleMode)
				ConScene.SimpleMode();
			else
			{
				if (!GetWorldInfo().IsConsoleBuild() && !myTPC.PlayerInput.bUsingGamepad)
				{
					ConScene.SetButtonLabelDatastoreBinding(DialogHelperMarkupPC);
				}
				else if (GetWorldInfo().IsPS3Build())
				{
					if (!GetWorldInfo().UseCircleToAccept())
						ConScene.SetButtonLabelDatastoreBinding(DialogHelperMarkupPS3);
					else
						ConScene.SetButtonLabelDatastoreBinding(DialogHelperMarkupPS3Circle);
				}
			}
			if (Title != "")
				ConScene.SetTitle(Title);
			ConScene.OnResults = OnMessageBoxResults;
		}
	}
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (GetWorldInfo().NetMode != NM_Standalone)
		myTPC.ConsoleCommand("disconnect");
	else
	{
		//Scene = SceneClient.GetTopmostScene();
		//SceneClient.CloseScene( Scene );
		myTPC.DestroyOnlineSession();
	}
}

function DisplayKeyboard(string DefaultText, optional int MaxChars=20, optional bool bAllowLower = false, optional bool bAllowSymbols = false)
{
	local UIScene TempScene;
	local UIScene_Keyboard KeyScene;
	
	if ( SceneClient.OpenScene( KeyboardScene, LocPlayer, TempScene ) )
	{
		FadeInactive();
		KeyScene = UIScene_Keyboard(TempScene);
		if (KeyScene != None)
		{
			KeyScene.MaxChars = MaxChars;
			KeyScene.FadeIn(true);
			KeyScene.SetVisibility(true);
			KeyScene.OnSceneClose = Restore;
			KeyScene.SetCurrentText(DefaultText);
			KeyScene.bAllowLowerCase = bAllowLower;
			KeyScene.bAllowSymbols = bAllowSymbols;

            if (!GetWorldInfo().IsConsoleBuild() && !myTPC.PlayerInput.bUsingGamepad)
            {
                KeyScene.SetHelperText("<Strings:TPGame.Keyboard.HelperPC>");
            }
			else if (GetWorldInfo().IsPS3Build())
			{
				if (!GetWorldInfo().UseCircleToAccept())
				{
					if (bAllowLower || bAllowSymbols)
						KeyScene.SetHelperText("<Strings:TPGame.Keyboard.HelperPS3Modes>");
					else
						KeyScene.SetHelperText("<Strings:TPGame.Keyboard.HelperPS3>");
				}
				else
				{
					if (bAllowLower || bAllowSymbols)
						KeyScene.SetHelperText("<Strings:TPGame.Keyboard.HelperPS3ModesCircle>");
					else
						KeyScene.SetHelperText("<Strings:TPGame.Keyboard.HelperPS3Circle>");
				}
			}
			else
			{
				if (bAllowLower || bAllowSymbols)
					KeyScene.SetHelperText("<Strings:TPGame.Keyboard.Helper360Modes>");
				else
					KeyScene.SetHelperText("<Strings:TPGame.Keyboard.Helper360>");
			}

			KeyScene.OnResults = OnKeyboardResults;
		}
	}
}

function OnKeyboardResults(int PlayerIndex, string ReturnValue);

function DisplayExitBox()
{
	local UIScene TempScene;
	local UIScene_Confirmation ConScene;
	
	if ( SceneClient.OpenScene( MessageBoxScene, LocPlayer, TempScene ) )
	{
		FadeInactive();
		ConScene = UIScene_Confirmation(TempScene);
		if (ConScene != None)
		{
			ConScene.FadeIn(true);
			ConScene.SetVisibility(true);
			ConScene.OnSceneClose = Restore;
			ConScene.SetMessage(ExitMessage);
			if (!GetWorldInfo().IsConsoleBuild() && !myTPC.PlayerInput.bUsingGamepad)
			{
				ConScene.SetButtonLabelDatastoreBinding(DialogHelperMarkupPC);
			}
			else if (GetWorldInfo().IsPS3Build())
			{
				if (!GetWorldInfo().UseCircleToAccept())
					ConScene.SetButtonLabelDatastoreBinding(DialogHelperMarkupPS3);
				else
					ConScene.SetButtonLabelDatastoreBinding(DialogHelperMarkupPS3Circle);
			}
			ConScene.SetTitle(ExitTitle);
			ConScene.OnResults = OnExitBoxResults;
		}
	}
}

function OnExitBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (bReturnValue)
	{
		LocPlayer.Actor.ConsoleCommand("exit");
	}
}

function FadeInactive()
{
	CurrTime = 0.0f;
	Super.FadeInactive();
}

