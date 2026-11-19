class OLCamcorderHud extends GFxMoviePlayer
	native;

var OLHUD HUD;
var bool bVisible;
var float RecordingTimeSeconds;

struct native CamcorderHudObjects
{
	var GFxObject ZoomTrackerMC;	// zoom bar
	var GFxObject NVStatusMC;		// cam/passive/active icon bottom right
	var GFxObject BatteryBarMC;	
	var GFxObject RecStatucMC; // stby or blinking red dot
	var GFxObject MainOpacity; 
	var GFxObject BatteryCount;
	var GFxObject RecordingTimeLabel;
};

var transient CamcorderHudObjects Objects;

struct native CamcorderHudState
{
	var int ZoomFactor;
	var int CamcorderMode;
	var int BatteryLeft;
	var int RecStatucState;
	var int MainOpacityState; // 0 - undefined, 1: hidden, 2: shown
	var int BatteryCountState; // +1, so that 0 is undefined
};

var transient CamcorderHudState HudState;

cpptext
{
	void InitCamcorder();
	void Update(FLOAT deltaTime);
}

event SetVisible(bool bShow)
{
	if (bShow == bVisible || Objects.MainOpacity == None)
	{
		return;
	}

	if (bShow)
	{
		Objects.MainOpacity.GotoAndPlay("Open");
	}
	else
	{
		Objects.MainOpacity.GotoAndPlay("Close");
	}

	bVisible = bShow;
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	//`log(self@" WidgetInitialized:"@WidgetName@" WidgetPath:"@WidgetPath);

	if (WidgetName == 'BatteryBar')
	{
		Objects.BatteryBarMC = Widget;
	}
	else if (WidgetName == 'ZoomTracker')
	{
		Objects.ZoomTrackerMC = Widget;
	}
	else if (WidgetName == 'Rec')
	{
		Objects.RecStatucMC = Widget;
	}
	else if (WidgetName == 'NVStatus')
	{
		Objects.NVStatusMC = Widget;
	}
	else if (WidgetName == 'MainOpacity')
	{
		Objects.MainOpacity = Widget;

		Objects.MainOpacity.GotoAndPlay("Opened");
	}
	else if (WidgetName == 'BatteryCount')
	{
		Objects.BatteryCount = Widget;
	}
	else if (WidgetName == 'RecordingTime')
	{
		Objects.RecordingTimeLabel = Widget;
	}
	else
	{
		return false;
	}

	return true;
}

function UpdateRecordingTime(float DeltaTime)
{
	local int TotalSeconds;
	local string Hours, Minutes, Seconds, HundredthsOfASecond, DisplayedTime;

	if (!HUD.PlayerOwner.IsPaused())
	{
		RecordingTimeSeconds += DeltaTime;
	}

	if (Objects.RecordingTimeLabel == None)
	{
		// may take a frame or two to inialize
		return;
	}

	TotalSeconds = FFloor(RecordingTimeSeconds);
	HundredthsOfASecond = string(FFloor((RecordingTimeSeconds - TotalSeconds) * 100));
	Seconds = string(TotalSeconds % 60);
	Minutes = string((TotalSeconds / 60) % 60);
	Hours = string((TotalSeconds / 3600));

	if (Len(Hours) == 1) {
		Hours = "0" $ Hours;
	}
	if (Len(Minutes) == 1) {
		Minutes = "0" $ Minutes;
	}
	if (Len(Seconds) == 1) {
		Seconds = "0" $ Seconds;
	}
	if (Len(HundredthsOfASecond) == 1) {
		HundredthsOfASecond = "0" $ HundredthsOfASecond;
	}

	DisplayedTime = Hours $ ":" $ Minutes $ ":" $ Seconds $ ":" $ HundredthsOfASecond;

	Objects.RecordingTimeLabel.SetString("text", DisplayedTime);
}

defaultproperties
{
	MovieInfo=SwfMovie'OLFrontEnd.camerahud'
	bLogUnhandedWidgetInitializations=true
	bAllowFocus=false
	bAllowInput=false
	bVisible=true
	TimingMode=TM_Real
	RecordingTimeSeconds=0.f
	OnPostAdvance=UpdateRecordingTime

	SoundThemes(0)=(ThemeName=default,Theme=UISoundTheme'Player_Sound.CameraHUDSoundTheme')

	Priority=1
}
