class OLFlashForwardScreen extends GFxMoviePlayer;

var localized string Text;

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	//`log(self@" WidgetInitialized:"@WidgetName@" WidgetPath:"@WidgetPath);

	if (WidgetName == 'text')
	{
		Widget.SetString("text", Text);
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
