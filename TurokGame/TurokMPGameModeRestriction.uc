class TurokMPGameModeRestriction extends Object
    native
    collapsecategories
    hidecategories(Object);

var() bool Deathmatch;
var() bool TeamDM;
var() bool CTF;
var() bool AssaultCTF;
var() bool WarGames;
var() bool Coop;

// Export UTurokMPGameModeRestriction::execIsRelevantForGameMode(FFrame&, void* const)
native final function bool IsRelevantForGameMode();

defaultproperties
{
    Deathmatch=true
    TeamDM=true
    CTF=true
    AssaultCTF=true
    WarGames=true
    Coop=true
}