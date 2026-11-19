//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGFxFrontend extends GFxMoviePlayer
      config(UI);

var localized string Training;
var localized string Range01;
var localized string Range02;
var localized string Range03;
var localized string Range04;
var localized string SinglePlay;
var localized string MultiPlay;
var localized string GameSetting;
var localized string CastList;
var localized string Exit;
var localized string GameMode;
var localized string MapChose;
var localized string Level;
var localized string CreatServer;
var localized string JoinServer;
var localized string Refresh;
var localized string ReFreshsBy;
var localized string Photo;
var localized string Control;
var localized string SoundSet;
var localized string ID;
var localized string Back;
var localized string OK;
struct  MapNameType
{
 var string ShowName;
 var string FileName;
};
var localized array<string> LevelName;
var localized array<string> GameModeName;
var localized array<MapNameType> MapName;
var localized array<string> MessageTitle;
var localized array<string> MessageInfo ;
var localized array<string> JobTip;




function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0);
    return TRUE;
}
