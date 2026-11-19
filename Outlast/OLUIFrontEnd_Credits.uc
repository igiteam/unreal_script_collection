class OLUIFrontEnd_Credits extends OLUIFrontEnd_Screen;

var transient GFxClikWidget BackButton;
var transient GFxObject CreditsScroll;
var bool bGameOver;

function bool Back()
{
	local OLGame TheGame;
	
	if (bGameOver)
	{
		bGameOver = false;

		TheGame = OLGame(class'WorldInfo'.static.GetWorldInfo().Game);
		TheGame.TravelToStartupMap();
		return false;
	}
	else
	{
		return super.Back();
	}
}

function OnCreditsFinished()
{
	Back();
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
	if (CreditsScroll != None)
	{
		CreditsScroll.GotoAndPlayI(2);
	}
}

function OnViewDeactivated()
{
	CreditsScroll.GotoAndStopI(1);
}

function Press_Back(GFxClikWidget.EventData ev)
{
	Back();
}

/** Callback when a CLIK widget with enableInitCallback set to TRUE is initialized.  Returns TRUE if the widget was handled, FALSE if not. */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;
	local bool bIsTopmostView;
	bWasHandled = TRUE;

	switch(WidgetName)
	{
		case ('backBtn'):
			BackButton = GFxClikWidget(Widget);
			BackButton.AddEventListener('CLIK_press', Press_Back);
			BackButton.SetString("label", BackText);
			break;
		case ('creditsScroll'):
			CreditsScroll = Widget;
			CreditsScroll.SetFunction("onCreditsFinished", self, nameof(OnCreditsFinished));

			if (MenuManager.ViewStack.length > 0)
			{
				bIsTopmostView = (MenuManager.ViewStack[MenuManager.ViewStack.length-1] == self);
				if (bIsTopmostView)
				{
					CreditsScroll.GotoAndPlayI(2);
				}
			}
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
	SubWidgetBindings.Add((WidgetName="backBtn",WidgetClass=class'GFxClikWidget'))
	bGameOver=false
}