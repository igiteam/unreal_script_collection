class OLEmailScreen extends GFxMoviePlayer;

var localized string EmailText;
var localized string SubjectText;

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	//`log(self@" WidgetInitialized:"@WidgetName@" WidgetPath:"@WidgetPath);

	if (WidgetName == 'EmailText')
	{
		Widget.SetString("text", EmailText);
	}
	else if (WidgetName == 'EmailTitle')
	{
		Widget.SetString("text", SubjectText);
	}
	else
	{
		return false;
	}

	return true;
}

defaultproperties
{
	bLogUnhandedWidgetInitializations=true
	bAllowFocus=false
	bAllowInput=false
	TimingMode=TM_Real
	
	Priority=1
}
