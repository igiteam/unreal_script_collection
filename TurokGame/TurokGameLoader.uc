class TurokGameLoader extends GameInfo
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

struct native GameTypePrefix
{
    var string Prefix;
    var string ClassName;

    structdefaultproperties
    {
        Prefix=""
        ClassName=""
    }
};

var protected const config string DefaultGameType;
var protected const config array GamePrefixes;

defaultproperties
{
    bRestartLevel=false
    bDelayedStart=false
    bWaitingToStartMatch=true
    HUDType=none
    PlayerControllerClass=none
}