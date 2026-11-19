class OLMainHud extends GFxMoviePlayer
	native;

var OLHUD HUD;
var localized string SavingMessageText;

struct native MainHudObjects
{
	var GFxObject NotificationIcons;
	var GFxObject SavingMessage;
};

var MainHudObjects Objects;

struct native MainHudState
{
	var bool bRecordingNotificationIconVisible;
	var bool bObjectiveNotificationIconVisible;
	var bool bCheckpointNotificationIconVisible;
	var bool bDocumentNotificationIconVisible;
};

var MainHudState HudState;

cpptext
{
	void Init();
	void Update(FLOAT deltaTime);
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	//`log(self@" WidgetInitialized:"@WidgetName@" WidgetPath:"@WidgetPath);

	if (WidgetName == 'notificationIcons')
	{
		Objects.NotificationIcons = Widget;
	}
	else if (WidgetName == 'savingMessage')
	{
		Objects.SavingMessage = Widget;
		Objects.SavingMessage.GetObject("message").SetString("text", SavingMessageText);
	}
	else
	{
		return false;
	}

	return true;
}

defaultproperties
{
	MovieInfo=SwfMovie'MainHud.MainHud'
	bAllowFocus=false
	bAllowInput=false

	Priority=2
}
