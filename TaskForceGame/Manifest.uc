class Manifest extends Object
    native;

const cNumLadders = 4;

struct native export ManifestEntry
{
    var Object  gProfile;
    var string  GameName;
    var int     Size; 
    var string  Date;
    var string  Time;
    var int     TeamSymbolIndex;
    var string  PlayerName;
    var string  Difficulty;
    var int     Status[cNumLadders];
    var int     Corrupt;
};

var() transient const array<ManifestEntry> ManifestEntries;

event FillSavedGameInfo(int manifestIndex)
{
    /*
    local GameProfile gProfile;
    local ManifestEntry entry;
    local int l;

    entry = ManifestEntries[manifestIndex];

    gProfile = GameProfile(entry.gProfile);

    if (gProfile.GetPlayerTeam() == None)
        return;

    entry.TeamSymbolIndex = gProfile.GetPlayerTeam().TeamSymbolIndex;
    entry.PlayerName = gProfile.GetPlayer().GetPlayerName();
    entry.Difficulty = gProfile.GetSelectedDifficulty();

    for (l=0; l < gProfile.cNumLadders; ++l)
    {
        if (gProfile.Ladders[l].bLocked)
            entry.Status[l] = -1;
        else
            entry.Status[l] = gProfile.Ladders[l].CurrentPosition;
    }

    ManifestEntries[manifestIndex] = entry;
    */
}
