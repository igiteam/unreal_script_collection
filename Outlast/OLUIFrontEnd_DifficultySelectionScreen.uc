class OLUIFrontEnd_DifficultySelectionScreen extends OLUIFrontEnd_Screen;

/** A cached reference to the profile of the player that owns this menu.  All affected settings will be changed here */
var transient OLProfileSettings   MyProfile;

var localized string ChooseDifficultyText;
var localized string NormalText;
var localized string HardText;
var localized string NightmareText;
var localized string InsaneText;
var localized string ConfirmInsaneTitleText;
var localized string ConfirmInsaneMsgText;

var transient GFxClikWidget NormalButton;
var transient GFxClikWidget HardButton;
var transient GFxClikWidget NightmareButton;
var transient GFxClikWidget InsaneButton;
var transient GFxClikWidget BackButton;

var transient GFxObject TitleLabel;
var transient bool bShowingInsaneConfirmDialog;

var bool bSpecificChapter;

/** Configures the view when it is first loaded. */
function OnViewLoaded()
{
	Super.OnViewLoaded();

	MyProfile = GetOLPC().ProfileSettings;
	SetFunction("OnConfirmedInsane", self, nameof(OnConfirmedInsane));
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
	Super.OnTopMostView(bPlayOpenAnimation);	

	InsaneButton.SetBool("disabled", bSpecificChapter);
}

function Press_Normal(GFxClikWidget.EventData ev)
{
	GetGame().DifficultyMode = EDM_Normal;
	ProceedToStartGame();
}

function Press_Hard(GFxClikWidget.EventData ev)
{
	GetGame().DifficultyMode = EDM_Hard;
	ProceedToStartGame();
}

function Press_Nightmare(GFxClikWidget.EventData ev)
{
	GetGame().DifficultyMode = EDM_Nightmare;
	ProceedToStartGame();
}

function Press_Insane(GFxClikWidget.EventData ev)
{
	bShowingInsaneConfirmDialog = true;
	ASShowConfirmInsaneDialog(ConfirmInsaneTitleText, ConfirmInsaneMsgText, YesText, NoText, "OnConfirmedInsane");	
}

function OnConfirmedInsane(bool bOk)
{
	bShowingInsaneConfirmDialog = false;

	if (bOk)
	{
		GetGame().DifficultyMode = EDM_Insane;
		ProceedToStartGame();
	}
	else
	{
		MenuManager.PushViewByName('DifficultySelectionScreen');
		MenuManager.PopView();
	}
}

function ProceedToStartGame()
{	
	if (MenuManager.MainMenuView.bShowIntroMsg)
	{
		Pop();
	}
	MenuManager.MainMenuView.DifficultySelected();
}

function OnViewDeactivated()
{	
}

function Pop()
{
	if (MenuManager != none)
	{
		MenuManager.PopView();        
	}
}

function Press_Back(GFxClikWidget.EventData ev)
{
	Back();
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (!bShowingInsaneConfirmDialog && (ButtonName == 'XboxTypeS_DPad_Left' || ButtonName == 'Gamepad_LeftStick_Left' || ButtonName == 'XboxTypeS_DPad_Right' || ButtonName == 'Gamepad_LeftStick_Right'))
	{
		return true; // ignore
	}

	return false;
}

private function ASShowConfirmInsaneDialog(string title, string message, string okButtonLabel, string cancelButtonLabel, string callbackName) { ActionScriptVoid("ShowConfirmInsaneDialog"); }

/** Callback when a CLIK widget with enableInitCallback set to TRUE is initialized.  Returns TRUE if the widget was handled, FALSE if not. */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;
	bWasHandled = TRUE;

	switch(WidgetName)
	{
		case ('backBtn'):
			BackButton = GFxClikWidget(Widget);
			BackButton.AddEventListener('CLIK_press', Press_Back);
			BackButton.SetString("label", BackText);
			break;
		case ('normalBtn'):
			NormalButton = GFxClikWidget(Widget);
			NormalButton.AddEventListener('CLIK_press', Press_Normal);
			NormalButton.SetString("label", NormalText);
			break;
		case ('hardBtn'):
			HardButton = GFxClikWidget(Widget);
			HardButton.AddEventListener('CLIK_press', Press_Hard);
			HardButton.SetString("label", HardText);
			break;
		case ('nightmareBtn'):
			NightmareButton = GFxClikWidget(Widget);
			NightmareButton.AddEventListener('CLIK_press', Press_Nightmare);
			NightmareButton.SetString("label", NightmareText);
			break;
		case ('insaneBtn'):
			InsaneButton = GFxClikWidget(Widget);
			InsaneButton.SetString("label", InsaneText);
			InsaneButton.AddEventListener('CLIK_press', Press_Insane);
			break;
		case ('stagePanel'):
			TitleLabel = Widget;
			TitleLabel.SetText(ChooseDifficultyText);
			break;
		default:
			bWasHandled = FALSE;
	}

	if (!bWasHandled)
	{
		bWasHandled = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);  
	}
	return bWasHandled;
}

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="normalBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="hardBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="nightmareBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="insaneBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="backBtn",WidgetClass=class'GFxClikWidget'))
}