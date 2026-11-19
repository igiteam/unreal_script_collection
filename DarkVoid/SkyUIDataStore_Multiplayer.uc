class SkyUIDataStore_Multiplayer extends UIDataStore
    transient
    native
    config(Game);

struct native LevelEntry
{
    var() string Filename;
    var() class<GameInfo> GameType;
    var() string ReadableName;
    var() string Description;
    var() bool Included;

    structdefaultproperties
    {
        Filename=""
        GameType=none
        ReadableName=""
        Description=""
        Included=false
    }
};

var private native const noexport Pointer VfTable_IUIListElementProvider;
var private native const noexport Pointer VfTable_IUIListElementCellProvider;
var config array<config LevelEntry> LevelList;
var string NetMode;
var transient array<int> GameTypeIndices;
var transient array< class<GameInfo> > GameTypes;
var transient int CurrentGameType;
var transient int CurrentMap;
