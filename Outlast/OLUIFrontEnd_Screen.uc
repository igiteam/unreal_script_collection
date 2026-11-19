class OLUIFrontEnd_Screen extends OLUIFrontEnd_View
    config(UI);

/** Title of the view. Defined in DefaultScaleformSandboxUI.ini. */
var config String ViewTitle;

var localized string BackText;
var localized string EnterText;
var localized string YesText;
var localized string NoText;
var localized string CloseText;
var localized string AcceptText;

var transient GFxObject CircleLabel;
var transient GFxObject CrossLabel;

function bool IsTopMostView()
{
	return (MenuManager != none && MenuManager.ViewStack.length > 0 && MenuManager.ViewStack[MenuManager.ViewStack.length-1] == self);
}

function bool IsDemo()
{
	local OLGame TheGame;
	TheGame = OLGame(class'WorldInfo'.static.GetWorldInfo().Game);

	return TheGame != None && TheGame.IsDemo();
}

function bool IsDLCInstalled()
{
	local OLGame TheGame;
	TheGame = OLGame(class'WorldInfo'.static.GetWorldInfo().Game);

	return TheGame != None && TheGame.IsDLCInstalled();
}

function string LocalizeNarrative(string SectionName, string KeyName)
{
	if (class'OLUtils'.static.IsPlayingDLC())
	{
		return Localize(SectionName, KeyName, "OLNarrativeDLC");
	}
	else
	{
		return Localize(SectionName, KeyName, "OLNarrative");
	}
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{    
	local bool bWasHandled;
	bWasHandled = true;

	switch(WidgetName)
	{
	case ('CrossLabel'):
		CrossLabel = Widget;
		CrossLabel.SetText(EnterText);
		break;
	case ('CircleLabel'):
		CircleLabel = Widget;
		CircleLabel.SetText(BackText);
		break;
	default:
		bWasHandled = false;
	}

	if (!bWasHandled)
	{
		bWasHandled = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);  
	}
	return bWasHandled;
}

defaultproperties
{
}