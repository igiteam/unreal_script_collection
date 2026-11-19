/**
 * This action displays the message box dialog scene.
 *
 * Copyright ? 2006 Epic Games, Inc. All Rights Reserved.
 */
class UIAction_DisplayMessageBox extends UIAction
	native(Sequence);

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

/** Markup for the title label on the dialog. */
var() string	TitleMarkup;

/** Markup for the message label on the dialog. */
var() string	MessageMarkup;

/** Markup for the button label on the dialog. */
var() string	ButtonMarkup360;
var() string	ButtonMarkupPC;
var() string	ButtonMarkupPS3;
var() string	ButtonMarkupPS3Circle;

/** Whether we should handle multiple options or not. */
var() bool		bSimpleDialog;

/** How long should we wait before timing out (and sending the abort)? */
var() float		TimeoutPeriod;


/** Whether or not the latent action is done executing. */
var bool		bIsDone;
var float		DisplayTime;

/** Result of the message box, whether the user chose OK or Cancel. */
var transient bool		bMessageResult;

/** Reference to scene that we opened. */
var transient UIScene	OpenedScene;

/** Reference to the message box scene. */
var() UIScene	MessageBoxScene;

/** The minimum opacity to fade scenes under the message box to. */
var() float		MinOpacity;

/**
 * Sets up the message box scene.
 */
event SetupScene(UIScene_Confirmation Scene)
{
	local TPPlayerController PC;
	local bool bUsingGamepad;
	local LinearColor TestColor;
	
	// Hack so the timed confirmation screens (i.e. "Confirm Resolution") are readable
	if (TimeoutPeriod > 0.0)
	{
		testColor.a = 1.5;
		Scene.SetBackgroundColor(TestColor);
	}
	
	foreach GetWorldInfo().AllControllers(class'TPPlayerController', PC)
	{
		bUsingGamepad = PC.PlayerInput.bUsingGamepad;
	}

	GetOwnerScene().Opacity = MinOpacity;
	//Scene.bHidden = true; //SPARK APRIL CODEDROP
	Scene.SetVisibility(true);
	
	if (!GetWorldInfo().IsConsoleBuild() && !bUsingGamepad)
	{
		Scene.SetButtonLabelDatastoreBinding(ButtonMarkupPC);
	}
	else if (GetWorldInfo().IsPS3Build())
	{
		if (!GetWorldInfo().UseCircleToAccept())
			Scene.SetButtonLabelDatastoreBinding(ButtonMarkupPS3);
		else
			Scene.SetButtonLabelDatastoreBinding(ButtonMarkupPS3Circle);
	}
	else
	{
		Scene.SetButtonLabelDatastoreBinding(ButtonMarkup360);
	}
	if(bSimpleDialog)
	{
		Scene.SimpleMode();
	}
	Scene.SetTitleDatastoreBinding(TitleMarkup);
	Scene.SetMessageDatastoreBinding(MessageMarkup);
	Scene.OnResults = OnBoxClosed;
	Scene.OnFadeOutCompleted = OnFadeCompleted;
}

/**
 * Called when the message box closes.
 *
 * @param InPlayerIndex		The player index that responded to the dialog.
 * @param bInAcceptOk		Whether the player accepted or cancelled the dialog.
 */
function OnBoxClosed(int InPlayerIndex, bool bInAcceptOk)
{
	;
	bMessageResult = bInAcceptOk;
	GetOwnerScene().Opacity = 1.0f;
}

/** 
 * Called when the box finishes fading out.
 */
function bool OnFadeCompleted()
{
	bIsDone = true;
	return true;
}


