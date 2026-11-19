class UIAction_GetSkillDrops extends UIAction
    hidecategories(Object);

enum eLevel
{
    LEVEL_NONE,                     // 0
    LEVEL_HUSKY,                    // 1
    LEVEL_AVALANCHE,                // 2
    LEVEL_NEPTUNE,                  // 3
    LEVEL_MARKET,                   // 4
    LEVEL_VARFAC,                   // 5
    LEVEL_VARFLK,                   // 6
    LEVEL_MAX                       // 7
};

var() UIAction_GetSkillDrops.eLevel Level;
var int nLevelNum;
var int nSkillDrops;

function Activated()
{
    local PlayerController PC;
    local MOHAPlayerReplicationInfo PRI;
    local SPMissionStats CurrentMissionStats;

    switch(Level)
    {
        // End:0x16
        case 1:
            nLevelNum = 1;
            // End:0x7F
            break;
        // End:0x26
        case 2:
            nLevelNum = 2;
            // End:0x7F
            break;
        // End:0x36
        case 3:
            nLevelNum = 3;
            // End:0x7F
            break;
        // End:0x46
        case 4:
            nLevelNum = 4;
            // End:0x7F
            break;
        // End:0x56
        case 5:
            nLevelNum = 5;
            // End:0x7F
            break;
        // End:0x66
        case 6:
            nLevelNum = 6;
            // End:0x7F
            break;
        // End:0xFFFF
        default:
            OutputLinks[1].bHasImpulse = true;
            return;
            break;
    }
    // End:0xB1
    foreach GetWorldInfo().LocalPlayerControllers(PC)
    {
        PRI = MOHAPlayerReplicationInfo(PC.PlayerReplicationInfo);        
    }    
    // End:0x105
    if(PRI != none)
    {
        PRI.GetSPMissionStats(nLevelNum, CurrentMissionStats);
        nSkillDrops = CurrentMissionStats.iSkillDropLandings;
        OutputLinks[0].bHasImpulse = true;
        return;
    }
    OutputLinks[1].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Skill Drops Found",LinkVar="None",PropertyName="nSkillDrops",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Get Skill Drops"
}