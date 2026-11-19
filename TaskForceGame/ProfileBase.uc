class ProfileBase extends Object;


// --- WARNING --------------------------------------------------------------------------------------------------------
const AccuracyMin           = 0.5;
const TacticsMin            = 0.5;
const AgilityMin            = 0.5;

const AccuracyMax           = 1.0;
const TacticsMax            = 1.0;
const AgilityMax            = 1.0;

const MaxStrLen             = 15;

const cNumTeams             = 20;
const cNumPlayersPerTeam    = 6;
const cNumLadders           = 4;
const cNumLadderRungs       = 7;
const cNumDifficultyLevels  = 4;
const cNumMaps              = 15;

const cNumPos               = 3;
enum EPlayerPos
{
    POS_Defense,
    POS_Offense,
    POS_Freelance,
    POS_None,
};

var localized string PositionText[cNumPos];
// --- WARNING --------------------------------------------------------------------------------------------------------
// -Update ULoadSaveManager::MaxSaveGameFileSize if the maximum save game size changes
// -Update ULoadSaveManager::SaveGameFileVersion if the data layout changes
// --- WARNING --------------------------------------------------------------------------------------------------------


static simulated function string StaticGetPositionString(EPlayerPos pos)
{
    return default.PositionText[int(pos)];
}

static simulated function string CapStringLen(string s, optional string version)
{
    s = s $ version;
    if (Len(s) <= MaxStrLen)
        return s;
    return Left(s, MaxStrLen - Len(version)) $ version;
}



// Decompiled with UE Explorer.
defaultproperties
{
    PositionText[0]="DEFENSE"
    PositionText[1]="OFFENSE"
    PositionText[2]="FREELANCE"
}