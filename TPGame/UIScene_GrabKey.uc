class UIScene_GrabKey extends UIScene_BaseHudScene;

// Delay before accepting the next button press
var float ButtonDelay;
var float CurrentButtonDelay;
var bool bNoInput;

var UILabel KeyLabel;
var string KeyMarkup;
var bool bGrabbedKey;


delegate OnResults(int PlayerIndex, name ReturnButton);
delegate OnSceneClose();
delegate bool OnFadeOutCompleted();

event InitScene()
{
	OnRawInputKey=CustomInputKey;

	SetVisibility(true);

	super.InitScene();

	// Delay button input at the start of the scene
	DelayButtonInput();

	KeyLabel = UILabel(FindChild('KeyLabel', true));
	KeyLabel.SetDatastoreBinding(KeyMarkup);
}

function SetKeyText(string NewText)
{
	if (KeyLabel != None)
		KeyLabel.SetValue(NewText);
}

function SetKeyDatastoreBinding(string NewMarkup)
{
	KeyMarkup = NewMarkup;
	if (KeyLabel != None)
		KeyLabel.SetDatastoreBinding(NewMarkup);
}

function CleanUp()
{
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

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if (EventParms.EventType == IE_Released && !bGrabbedKey)
	{
		if (EventParms.InputKeyName == 'XboxTypeS_A' ||
			EventParms.InputKeyName == 'XboxTypeS_B' ||
			EventParms.InputKeyName == 'XboxTypeS_X' ||
			EventParms.InputKeyName == 'XboxTypeS_Y' ||
			EventParms.InputKeyName == 'XboxTypeS_LeftX' ||
			EventParms.InputKeyName == 'XboxTypeS_LeftY' ||
			EventParms.InputKeyName == 'XboxTypeS_RightX' ||
			EventParms.InputKeyName == 'XboxTypeS_RightY' ||
			EventParms.InputKeyName == 'XboxTypeS_DPad_Right' ||
			EventParms.InputKeyName == 'XboxTypeS_DPad_Left' ||
			EventParms.InputKeyName == 'XboxTypeS_DPad_Up' ||
			EventParms.InputKeyName == 'XboxTypeS_DPad_Down' ||
			EventParms.InputKeyName == 'XboxTypeS_LeftTrigger' ||
			EventParms.InputKeyName == 'XboxTypeS_LeftShoulder' ||
			EventParms.InputKeyName == 'XboxTypeS_RightTrigger' ||
			EventParms.InputKeyName == 'XboxTypeS_RightShoulder' ||
			EventParms.InputKeyName == 'XboxTypeS_Back' ||
			EventParms.InputKeyName == 'XboxTypeS_Start' ||
			EventParms.InputKeyName == 'XboxTypeS_RightThumbstick' ||
			EventParms.InputKeyName == 'XboxTypeS_LeftThumbstick')
		{
			return true;
		}
		else if (EventParms.InputKeyName == 'Escape')
		{
			OnResults(EventParms.PlayerIndex, '');
			FadeOut();
			OnSceneClose();
			bGrabbedKey = true;
			return true;
		}
		else
		{
			OnResults(EventParms.PlayerIndex, EventParms.InputKeyName);
			FadeOut();
			OnSceneClose();
			bGrabbedKey = true;
			return true;
		}
	}
	return true; // Eat all input
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

