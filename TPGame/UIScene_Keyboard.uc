class UIScene_Keyboard extends UIScene_BaseHudScene;

// Delay before accepting the next button press
var float ButtonDelay;
var float CurrentButtonDelay;
var bool bNoInput;
var string CurrentText;
var int MaxChars;

var int CurrCol;
var int CurrRow;

var UILabel TextEntry;
var UILabelButton CurrentKey;

struct RowInfo
{
	var array<name> Cols;
};

var array<RowInfo> Rows;

struct RowCaptions
{
	var array<string> Cols;
};

var array<RowCaptions> UpperCaptions;
var array<RowCaptions> LowerCaptions;
var array<RowCaptions> SymbolCaptions;

var bool bAllowLowerCase, bAllowSymbols;

enum EKeyboardMode
{
	KeyMode_Upper,
	KeyMode_Lower,
	KeyMode_Symbols
};

var EKeyboardMode KeyMode;

delegate OnResults(int PlayerIndex, string ReturnValue);
delegate OnSceneClose();
delegate bool OnFadeOutCompleted();

event InitScene()
{
	OnRawInputKey=CustomInputKey;

	SetVisibility(true);

	super.InitScene();

	// Delay button input at the start of the scene
	DelayButtonInput();

	TextEntry = UILabel(FindChild('TextEntry', true));
	if (TextEntry == None)
	{
		;
		FadeOut();
		return;
	}

	CurrCol = 0;
	CurrRow = 0;
	CurrentKey = UILabelButton(FindChild('ButtonA', true));
	CurrentKey.SetFocus(CurrentKey.GetOwner());

	TextEntry.SetValue(CurrentText$"_");
	
	SetViewportRequiresKeyboardInput(true);
	
}

function SetHelperText(string DatastoreBinding)
{
	local UILabel HelperLabel;
	HelperLabel = UILabel(FindChild('HelperText', true));
	HelperLabel.SetDatastoreBinding(DatastoreBinding);
}

function SetCurrentText(string NewText)
{
	CurrentText = NewText;
	if (TextEntry != None)
		TextEntry.SetValue(NewText$"_");
}
function CleanUp()
{
	SetViewportRequiresKeyboardInput(false);
}

event SceneDeactivated()
{
	CleanUp();
	Super.SceneDeactivated();
}

function NotifyGameSessionEnded()
{
	CleanUp();
	Super.NotifyGameSessionEnded();
}

function Backspace()
{
	local int Length;
	Length = Len(CurrentText);

	if (Length != 0)
	{
		CurrentText = Left(CurrentText, Length - 1);
		if (TextEntry != None)
			TextEntry.SetValue(CurrentText$"_");
	}
}

function Space()
{
	if (Len(CurrentText) < MaxChars)
	{
		CurrentText = CurrentText $ " ";
		if (TextEntry != None)
			TextEntry.SetValue(CurrentText$"_");
	}
}

function ChangeCol(bool bRight)
{
	local int NumCols;
	local bool bFoundNewButton;
	local UILabelButton NewButton;

	NumCols = Rows[CurrRow].Cols.Length;
	bFoundNewButton = false;

	while (!bFoundNewButton)
	{
		if (bRight)
			CurrCol++;
		else
			CurrCol--;

		if (CurrCol < 0)
			CurrCol = NumCols - 1;
		else if (CurrCol >= NumCols)
			CurrCol = 0;

		NewButton = UILabelButton(FindChild(name("Button" $ string(Rows[CurrRow].Cols[CurrCol])), true));

		if (NewButton != None)
			bFoundNewButton = true;
	}

	CurrentKey.KillFocus(CurrentKey.GetOwner());
	CurrentKey = NewButton;
	CurrentKey.SetFocus(CurrentKey.GetOwner());
}

function ChangeRow(bool bDown)
{
	local int NumRows;
	local bool bFoundNewButton;
	local UILabelButton NewButton;
	
	NumRows = Rows.Length;
	bFoundNewButton = false;

	while (!bFoundNewButton)
	{
		if (bDown)
			CurrRow++;
		else
			CurrRow--;

		if (CurrRow < 0)
			CurrRow = NumRows - 1;
		else if (CurrRow >= NumRows)
			CurrRow = 0;

		NewButton = UILabelButton(FindChild(name("Button" $ string(Rows[CurrRow].Cols[CurrCol])), true));

		if (NewButton != None)
			bFoundNewButton = true;
	}

	CurrentKey.KillFocus(CurrentKey.GetOwner());
	CurrentKey = NewButton;
	CurrentKey.SetFocus(CurrentKey.GetOwner());
}

function HandleAccept()
{
	if (CurrentKey != None)
	{
		if (Len(CurrentText) < MaxChars)
		{
			CurrentText = CurrentText $ CurrentKey.GetCaption();
			if (TextEntry != None)
			{
				TextEntry.SetValue(CurrentText$"_");
			}
		}
	}
}

function HandleBack(int PlayerIndex)
{
	OnResults(PlayerIndex, "");
	FadeOut();
	OnSceneClose();
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	local int i, j;
	local bool done;
	local string TextToAdd;
	local name KeyName;

	if (EventParms.InputKeyName == 'XboxTypeS_A' && EventParms.EventType == IE_Released)
	{
		if (!GetWorldInfo().UseCircleToAccept())
			HandleAccept();
		else
			HandleBack(EventParms.PlayerIndex);
	}
	else if ((EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') && EventParms.EventType == IE_Pressed)
	{
		ChangeCol(false);
	}
	else if ( (EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right') && EventParms.EventType == IE_Pressed )
	{
		ChangeCol(true);
	}
	else if ( (EventParms.InputKeyName == 'XboxTypeS_DPad_Up' || EventParms.InputKeyName == 'Gamepad_LeftStick_Up') && EventParms.EventType == IE_Pressed )
	{
		ChangeRow(false);
	}
	else if ( (EventParms.InputKeyName == 'XboxTypeS_DPad_Down' || EventParms.InputKeyName == 'Gamepad_LeftStick_Down') && EventParms.EventType == IE_Pressed )
	{
		ChangeRow(true);
	}
	else if ((EventParms.InputKeyName == 'XboxTypeS_B' || EventParms.InputKeyName == 'Escape') && EventParms.EventType == IE_Released)
	{
		if (!GetWorldInfo().UseCircleToAccept())
			HandleBack(EventParms.PlayerIndex);
		else
			HandleAccept();
	}
	else if ((EventParms.InputKeyName == 'XboxTypeS_Start' || EventParms.InputKeyName == 'Enter') && EventParms.EventType == IE_Released)
	{
		OnResults(EventParms.PlayerIndex, CurrentText);
		FadeOut();
		OnSceneClose();
	}
	else if ((EventParms.InputKeyName == 'XboxTypeS_X' && EventParms.EventType == IE_Released) || (EventParms.InputKeyName == 'Backspace' && (EventParms.EventType == IE_Released || EventParms.EventType == IE_Repeat)))
	{
		Backspace();
	}
	else if ((EventParms.InputKeyName == 'XboxTypeS_Y' && EventParms.EventType == IE_Released) || (EventParms.InputKeyName == 'SpaceBar' && (EventParms.EventType == IE_Released || EventParms.EventType == IE_Repeat)))
	{
		Space();
	}
	else if ((EventParms.InputKeyName == 'XboxTypeS_RightShoulder' || EventParms.InputKeyName == 'RightControl') && EventParms.EventType == IE_Released)
	{
		SwapCaptions();
	}
	else if ((EventParms.InputKeyName == 'XboxTypeS_LeftShoulder' || EventParms.InputKeyName == 'LeftControl') && EventParms.EventType == IE_Released)
	{
		SwapCaptions(false);
	}
	else if ((Len(CurrentText) < MaxChars) && (EventParms.EventType == IE_Released || EventParms.EventType == IE_Repeat))
	{
		KeyName = EventParms.InputKeyName;
		
		if( KeyName == 'NumPadZero')
			KeyName = 'Zero';
		else if( KeyName == 'NumPadOne')
			KeyName = 'One';
		else if( KeyName == 'NumPadTwo')
			KeyName = 'Two';
		else if( KeyName == 'NumPadThree')
			KeyName = 'Three';
		else if( KeyName == 'NumPadFour')
			KeyName = 'Four';
		else if( KeyName == 'NumPadFive')
			KeyName = 'Five';
		else if( KeyName == 'NumPadSix')
			KeyName = 'Six';
		else if( KeyName == 'NumPadSeven')
			KeyName = 'Seven';
		else if( KeyName == 'NumPadEight')
			KeyName = 'Eight';
		else if( KeyName == 'NumPadNine')
			KeyName = 'Nine';

	
		// We need to see if any of the keyboard keys were pressed
		for (i=0; i<Rows.Length; i++)
		{
			for (j=0; j<Rows[i].Cols.Length; j++)
			{
				if (KeyName == Rows[i].Cols[j])
				{
					if (KeyName == 'One')
						TextToAdd = "1";
					else if (KeyName == 'Two')
						TextToAdd = "2";
					else if (KeyName == 'Three')
						TextToAdd = "3";
					else if (KeyName == 'Four')
						TextToAdd = "4";
					else if (KeyName == 'Five')
						TextToAdd = "5";
					else if (KeyName == 'Six')
						TextToAdd = "6";
					else if (KeyName == 'Seven')
						TextToAdd = "7";
					else if (KeyName == 'Eight')
						TextToAdd = "8";
					else if (KeyName == 'Nine')
						TextToAdd = "9";
					else if (KeyName == 'Zero')
						TextToAdd = "0";
					else
						TextToAdd = string(KeyName);

					//`log("Matched"@KeyName);
					// add this character to our text

					if (Len(CurrentText) < MaxChars)
					{
						CurrentText = CurrentText $ TextToAdd;
						if (TextEntry != None)
							TextEntry.SetValue(CurrentText$"_");
					}


					// now, focus on this key
					CurrRow = i;
					CurrCol = j;
					CurrentKey.KillFocus(CurrentKey.GetOwner());
					CurrentKey = UILabelButton(FindChild(name("Button" $ string(KeyName)), true));
					CurrentKey.SetFocus(CurrentKey.GetOwner());

					done = true;
					break;
				}
			}

			if (done)
				return true;
		}
	}

	return true; // Eat all input
}

function SwapCaptions(optional bool bForward = true)
{
	local EKeyboardMode NewMode;
	local int i, j;
	local UILabelButton KeyToSwap;
	local string NewCaption;

	NewMode = KeyMode;

	if (bForward)
	{
		switch (KeyMode)
		{
			case KeyMode_Upper:
				if (bAllowLowerCase)
					NewMode = KeyMode_Lower;
				else if (bAllowSymbols)
					NewMode = KeyMode_Symbols;

				break;
			
			case KeyMode_Lower:
				if (bAllowSymbols)
					NewMode = KeyMode_Symbols;
				else
					NewMode = KeyMode_Upper;

				break;

			case KeyMode_Symbols:
				NewMode = KeyMode_Upper;
				break;
		}
	}
	else
	{
		switch (KeyMode)
		{
			case KeyMode_Upper:
				if (bAllowSymbols)
					NewMode = KeyMode_Symbols;
				else if (bAllowLowerCase)
					NewMode = KeyMode_Lower;

				break;
			
			case KeyMode_Lower:
				NewMode = KeyMode_Upper;
				break;

			case KeyMode_Symbols:
				if (bAllowLowerCase)
					NewMode = KeyMode_Lower;
				else
					NewMode = KeyMode_Upper;

				break;
		}
	}

	if (NewMode != KeyMode)
	{
		for (i=0; i<Rows.Length; i++)
		{
			for (j=0; j<Rows[i].Cols.Length; j++)
			{
				if (Rows[i].Cols[j] != 'BLAH')
				{
					KeyToSwap = UILabelButton(FindChild(name("Button" $ string(Rows[i].Cols[j])), true));
					
					switch (NewMode)
					{
						case KeyMode_Upper:
							NewCaption = UpperCaptions[i].Cols[j];
							break;

						case KeyMode_Lower:
							NewCaption = LowerCaptions[i].Cols[j];
							break;

						case KeyMode_Symbols:
							NewCaption = SymbolCaptions[i].Cols[j];
							break;
					}
					KeyToSwap.SetCaption("");
					KeyToSwap.SetCaption(NewCaption);
				}
			}
		}

		KeyMode = NewMode;
	}
}

event FadeCompleted()
{
	Super.FadeCompleted();
	if ( Opacity <= 0.0f )
	{
		// Call delegate
		if(OnFadeOutCompleted()==false)
		{
			SceneClient.CloseScene(self);
		}
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

function NotifyLinkStatusChanged( bool bConnected )
{
	super.NotifyLinkStatusChanged(bConnected);

	if (!bConnected)
	{
		GetPC().SetDisconnectionError(FRONTEND_MENU, true);
		GetPC().ActivateRemoteEvent('ReopenRoot');
		SceneClient.CloseScene(self);
	}
}

