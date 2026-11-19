/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_Confirmation extends UIScene_BaseHudScene
	native;

/** Whether or not we are a multichoice dialog. */
var	bool bSimpleMode;

delegate OnResults(int PlayerIndex, bool bAcceptOk);
delegate OnSceneClose();
delegate bool OnFadeOutCompleted();


event SceneActivated( bool bInitialActivation )
{
	Super.SceneActivated(bInitialActivation);
	OnRawInputKey=CustomInputKey;
}

function SetTitle(string Title)
{
	local UILabel Lbl;

	Lbl = UILabel(FindChild('Title',true) );
	if (Lbl != none)
	{
		Lbl.SetValue(Title);
	}
}

function SetMessage(string Message)
{
	local UILabel Lbl;

	Lbl = UILabel(FindChild('MessageText',true) );
	if (Lbl != none)
	{
		Lbl.SetValue(Message);
	}
}

function SetTitleDatastoreBinding(string Markup)
{
	local UILabel Lbl;

	Lbl = UILabel(FindChild('Title',true) );
	if (Lbl != none)
	{
		Lbl.SetDataStoreBinding(Markup);
	}
}

function SetMessageDatastoreBinding(string Markup)
{
	local UILabel Lbl;

	Lbl = UILabel(FindChild('MessageText',true) );
	if (Lbl != none)
	{
		Lbl.SetDataStoreBinding(Markup);
	}
}

function SetButtonLabelDatastoreBinding(string Markup)
{
	local UILabel Lbl;

	Lbl = UILabel(FindChild('ButtonLabel',true) );
	if (Lbl != none)
	{
		Lbl.SetDataStoreBinding(Markup);
	}
}

function SetBackgroundColor(LinearColor NewColor)
{
	local UIImage Image;
	Image = UIImage(FindChild('BackgroundB', true));
	if (Image != None)
	{
		Image.AnimSetColor(NewColor);
	}
}

function SimpleMode()
{
	//SetTitleDatastoreBinding("<Strings:WarfareGame.UIScene_Confirmation.SimpleTitleString>");
	if (GetWorldInfo().IsPS3Build())
	{
		if (!GetWorldInfo().UseCircleToAccept())
			SetButtonLabelDatastoreBinding("<Strings:TPGame.HelperText.DialogOkPS3>");
		else
			SetButtonLabelDatastoreBinding("<Strings:TPGame.HelperText.DialogOkPS3Circle>");
	}
	else if (GetWorldInfo().IsConsoleBuild() || GetPC().PlayerInput.bUsingGamePad)
	{
		SetButtonLabelDatastoreBinding("<Strings:TPGame.HelperText.DialogOk360>");
	}
	else
	{
		SetButtonLabelDatastoreBinding("<Strings:TPGame.HelperText.DialogOkPC>");
	}
	bSimpleMode = true;
}

function FadeIn(bool bResetOpacity)
{
	if ( FadeTime > 0 )
	{
		FadeTime = 0;
		Opacity = FadeDestination;
		FadeCompleted();
	}

	Super.FadeIn( bResetOpacity );
}

function FadeOut()
{
	if ( FadeTime > 0 )
	{
		FadeTime = 0;
		Opacity = FadeDestination;
		FadeCompleted();
	}

	Super.FadeOut();

//	PlayUISound('MenuPopDown');
//	FadeScene(0.0, Opacity * FadeOutTime);
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
			OnSceneClose();
		}
	}
}


//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if (GetWorldInfo().UseCircleToAccept())
	{
		if (EventParms.EventType == IE_Released && EventParms.InputKeyName == 'XboxTypeS_B')
		{
			OnResults(EventParms.PlayerIndex, true);
			FadeOut();
			return true;
		}

		if (EventParms.EventType == IE_Released && EventParms.InputKeyName == 'XboxTypeS_A' && bSimpleMode==false)
		{
			OnResults(EventParms.PlayerIndex, false);
			FadeOut();
			//OnSceneClose();
			return true;
		}
	}
	else
	{
		if (EventParms.EventType == IE_Released && (EventParms.InputKeyName == 'XboxTypeS_A' || (EventParms.InputKeyName == 'Enter' && !GetWorldInfo().IsConsoleBuild())))
		{
			OnResults(EventParms.PlayerIndex, true);
			FadeOut();
			return true;
		}

		if (EventParms.EventType == IE_Released && ((EventParms.InputKeyName == 'XboxTypeS_B' || (EventParms.InputKeyName == 'Escape' && !GetWorldInfo().IsConsoleBuild())) && bSimpleMode==false ))
		{
			OnResults(EventParms.PlayerIndex, false);
			FadeOut();
			//OnSceneClose();
			return true;
		}
	}

	return true;
}

