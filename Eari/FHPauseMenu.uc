class FHPauseMenu extends GFxMoviePlayer;

var FHPlayerController playerController;
var FHHUD hud;
var GFxObject hackToPassFlashData;
var string notes;


function initialize_dave(FHHUD mhud, string notesBits)
{
	hud = mhud;
	AddCaptureKey('Escape');
	notes = notesBits;
}

function Init(optional LocalPlayer player)
{
	super.Init(player);
	Start();
	Advance(0);
	//hackToPassFlashData = GetVariableObject("_root.erienotes");
	hackToPassFlashData = GetVariableObject("_root.dynamictext1");
	hackToPassFlashData.SetText(notes);
}

function ExitFhGame()
{
	ConsoleCommand("Disconnect");
	ConsoleCommand("ToggleAllScreenMessages");
}

function ResumeFhGame()
{
	//playerController.Pause();
	Close(false);
	hud.HideMenu();
}


// Decompiled with UE Explorer.
defaultproperties
{
    MovieInfo=SwfMovie'FH_scaleform_resources.ERIE_Menu_Pause'
    bPauseGameWhileActive=true
}