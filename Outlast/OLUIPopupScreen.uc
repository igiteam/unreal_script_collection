class OLUIPopupScreen extends OLGFxMoviePlayer;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0);

	AddCaptureKey('Spacebar');
	AddCaptureKey('XboxTypeS_A');
	AddCaptureKey('XboxTypeS_Start');

	return true;
}

function OnClose()
{
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (ButtonName == 'Spacebar' || ButtonName == 'XboxTypeS_A' || ButtonName == 'XboxTypeS_Start')
	{
		if (InputEvent == IE_Pressed)
		{
			PlaySoundFromTheme('select');

			Close();

			return true;
		}
	}

	return false;
}

defaultproperties
{    
	SoundThemes(0)=(ThemeName=default,Theme=UISoundTheme'Menu.MenuUISoundTheme')

	bCaptureInput=true
}
