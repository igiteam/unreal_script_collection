//-----------------------------------------------------------
// base on HDIDSystem.fla
//-----------------------------------------------------------

class HDIDSystem extends Object; // extends GFxMoviePlayer;

var localized array<string> Login_enterGame;
var localized array<string> Login_deleteUser;
var localized array<string> Login_createUser;
var localized array<string> Login_quitGame;
var localized array<string> Create_title;
var localized array<string> Create_inputguide;
var localized array<string> Create_error;
var localized array<string> Create_ok;
var localized array<string> Create_cancel;
var localized array<string> Delete_title;
var localized array<string> Delete_guide;
var localized array<string> Delete_ok;
var localized array<string> Delete_cancel;

//var LoginPlayerManager playerManager;
var int LanguageIndex;

// var transient
var transient GFxObject HD_Title;


function EnterLogin (int index)
{
     LanguageIndex = index;
}

function Array<string> LoadData()
{
    local Array<string> UserName;
    local int i;
	local LoginPlayerManager PlayerManager;

	PlayerManager = class'GameEngine'.static.GetPlayerManager();

    for( i=0; i<playerManager.Players.length; i++ )
    {
        UserName.addItem( PlayerManager.Players[i].playerName );
    }

    return UserName;
}

function SaveData()
{
	local LoginPlayerManager PlayerManager;

	PlayerManager = class'GameEngine'.static.GetPlayerManager();

    PlayerManager.SaveData();
}

function AddPlayer(string playerName)
{
	local LoginPlayerManager PlayerManager;

	PlayerManager = class'GameEngine'.static.GetPlayerManager();

    PlayerManager.AddPlayer(playerName);
}

function DeletePlayer(string playerName)
{
	local LoginPlayerManager PlayerManager;

	PlayerManager = class'GameEngine'.static.GetPlayerManager();

    PlayerManager.DeletePlayer(playerName);
}

function EnterGame(string playerName)
{
	local LoginPlayerManager PlayerManager;

	PlayerManager = class'GameEngine'.static.GetPlayerManager();

    PlayerManager.currentPlayerName = PlayerName;
    PlayerManager.SaveConfig ();
}

