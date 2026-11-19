class MissionMPStatsDataProvider extends GlobalMPStatsDataProvider
    transient
    native
    hidecategories(Object,UIRoot);

enum EModeOptions
{
    eMode_ALL,                      // 0
    eMode_AO,                       // 1
    eMode_TD,                       // 2
    eMode_AD,                       // 3
    eMode_MAX                       // 4
};

enum EStatsOptionsIndex
{
    eStats_MAP,                     // 0
    eStats_MODE,                    // 1
    eStats_TEAM,                    // 2
    eStats_MAX                      // 3
};

enum EMapOptions
{
    eMap_ALL,                       // 0
    eMap_REM,                       // 1
    eMap_DV,                        // 2
    eMap_HUNT,                      // 3
    eMap_HUS,                       // 4
    eMap_AVA,                       // 5
    eMap_NEP,                       // 6
    eMap_MAX                        // 7
};

enum ETeamOptions
{
    eTeam_BOTH,                     // 0
    eTeam_ALLIES,                   // 1
    eTeam_AXIS,                     // 2
    eTeam_MAX                       // 3
};

struct native MPMissionStatsOptionMapping
{
    var int CurrentValue;
    var const array<IdToStringMapping> ValueMappings;

    structdefaultproperties
    {
        CurrentValue=0
        ValueMappings=none
    }
};

var array<MPMissionStatsOptionMapping> MPStatsOptions;
var array<string> ModeNames;
var array<string> MapNames;
var array<string> TeamNames;

event bool GetFieldValue(string FieldName, out UIProviderFieldValue out_FieldValue, optional int ArrayIndex = -1)
{
    local int mode, Map, Team;
    local string prefix, stat;
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    mode = MPStatsOptions[1].CurrentValue;
    Map = MPStatsOptions[0].CurrentValue;
    Team = MPStatsOptions[2].CurrentValue;
    // End:0x164
    if(mode != 0)
    {
        // End:0x103
        if(Team != 0)
        {
            // End:0xCF
            if(Map != 0)
            {
                prefix = ((((("GAME_" $ ModeNames[mode]) $ "_") $ TeamNames[Team]) $ "_") $ MapNames[Map]) $ "_";                
            }
            else
            {
                prefix = ((("TYPE_" $ ModeNames[mode]) $ "_") $ TeamNames[Team]) $ "_";
            }            
        }
        else
        {
            // End:0x142
            if(Map != 0)
            {
                prefix = ((("TYPE_" $ ModeNames[mode]) $ "_") $ MapNames[Map]) $ "_";                
            }
            else
            {
                prefix = ("TYPE_" $ ModeNames[mode]) $ "_";
            }
        }        
    }
    else
    {
        // End:0x1C6
        if(Team != 0)
        {
            // End:0x1AD
            if(Map != 0)
            {
                prefix = ((("MAP_" $ TeamNames[Team]) $ "_") $ MapNames[Map]) $ "_";                
            }
            else
            {
                prefix = TeamNames[Team] $ "_";
            }            
        }
        else
        {
            // End:0x1F2
            if(Map != 0)
            {
                prefix = ("MAP_" $ MapNames[Map]) $ "_";                
            }
            else
            {
                prefix = "";
            }
        }
    }
    switch(FieldName)
    {
        // End:0x226
        case "ObjectivePoints":
            stat = "OBJPTS";
            // End:0x278
            break;
        // End:0x247
        case "TeamPoints":
            stat = "TEAMPTS";
            // End:0x278
            break;
        // End:0x26A
        case "KillAssists":
            stat = "KILLASST";
            // End:0x278
            break;
        // End:0xFFFF
        default:
            stat = FieldName;
            break;
    }
    out_FieldValue.StringValue = P.GetFormattedStatValue(prefix $ stat);
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    MPStatsOptions[0]=(CurrentValue=0,ValueMappings=ValueMappings[0]=(Id=0,Name="All Maps")
    ValueMappings[1]=(Id=1,Name="Remagen")
    ValueMappings[2]=(Id=2,Name="Destroyed Village")
    ValueMappings[3]=(Id=3,Name="The Hunt")
    ValueMappings[4]=(Id=0,Name="Husky")
    ValueMappings[5]=(Id=0,Name="Avalanche")
    ValueMappings[6]=(Id=0,Name="Neptune"))
    MPStatsOptions[1]=(CurrentValue=0,ValueMappings=ValueMappings[0]=(Id=0,Name="All Modes")
    ValueMappings[1]=(Id=1,Name="Objective Airborne")
    ValueMappings[2]=(Id=2,Name="Team Deathmatch")
    ValueMappings[3]=(Id=3,Name="Airborne Deathmatch"))
    MPStatsOptions[2]=(CurrentValue=0,ValueMappings=ValueMappings[0]=(Id=0,Name="Both Teams")
    ValueMappings[1]=(Id=1,Name=" Allies")
    ValueMappings[2]=(Id=2,Name="Axis"))
    ModeNames[0]=""
    ModeNames[1]="AB"
    ModeNames[2]="DM"
    ModeNames[3]="ADM"
    MapNames[0]=""
    MapNames[1]="REM"
    MapNames[2]="VIL"
    MapNames[3]="HNT"
    MapNames[4]="HUS"
    MapNames[5]="AVA"
    MapNames[6]="NEP"
    TeamNames[0]=""
    TeamNames[1]="ALLIES"
    TeamNames[2]="AXIS"
}