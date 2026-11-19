class OLUIMessage extends OLGFxMoviePlayer
	dependson(OLHUD);

var GFxClikWidget MessageBox;

var float MessageXPos;
var float MessageYPos;
var float MessageWidth;
var float MessageHeight;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0);

	return true;
}

function OnClose()
{
}

function SetVisible(bool bVisible)
{
	if (MessageBox != None)
	{
		MessageBox.SetVisible(bVisible);
	}
}

function SetMessage(EHUDMessageType MessageType, string Message)
{
	if (MessageBox != None)
	{
		if (class'OLUtils'.static.IsPS4())
		{
			MessageBox.SetBool("usePS4", true);
		}
		else if (class'OLUtils'.static.IsDingo())
		{
			MessageBox.SetBool("useXBOX", true);
		}
		MessageBox.SetInt("type", MessageType);
		MessageBox.SetText(Message);
	}
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{    
	local bool bResult;
	bResult = true;

	switch(WidgetName)
	{
	case 'igMessage':
		MessageBox = GFxClikWidget(Widget);
		MessageBox.SetText("Test");

		if (class'OLUtils'.static.IsPS4())
		{
			MessageBox.SetBool("usePS4", true);
		}
		else if (class'OLUtils'.static.IsDingo())
		{
			MessageBox.SetBool("useXBOX", true);
		}
		break;
	default:
		bResult = false;
		break;
	}

	return bResult;
}

defaultproperties
{    
	WidgetBindings.Add((WidgetName="igMessage",WidgetClass=class'GFxClikWidget'))

	MovieInfo=SwfMovie'OLFrontEnd.Message'

	bAllowFocus=false
	bAllowInput=false

	Priority=3
}
