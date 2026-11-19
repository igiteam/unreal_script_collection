class SeqCond_MapSelectorThree extends SequenceCondition
    hidecategories(Object);

var() array<string> MapNames;
var() bool bNextLevelIfComplete;

function Activated()
{
    local string MapName;
    local int Index;
    local SPMissionStats CurrentMissionStats;
    local PlayerController PC;
    local MOHAPlayerReplicationInfo PRI;

    MapName = Class'Engine.SaveLoadSystem'.static.GetMapName();
    Index = 0;
    J0x1C:

    // End:0x13F [Loop If]
    if(Index < MapNames.Length)
    {
        // End:0x135
        if(InStr(MapName, MapNames[Index]) != -1)
        {
            // End:0x11B
            if(bNextLevelIfComplete)
            {
                // End:0x83
                foreach GetWorldInfo().LocalPlayerControllers(PC)
                {
                    PRI = MOHAPlayerReplicationInfo(PC.PlayerReplicationInfo);                    
                }                
                // End:0x11B
                if(PRI != none)
                {
                    PRI.GetSPMissionStats(Index, CurrentMissionStats);
                    // End:0xD9
                    if(Index >= (MapNames.Length - 1))
                    {
                        OutputLinks[Index].bHasImpulse = true;
                        return;
                    }
                    // End:0x11B
                    if(CurrentMissionStats.bCompleted)
                    {
                        Class'Engine.SaveLoadSystem'.static.Clear("");
                        OutputLinks[Index + 8].bHasImpulse = true;
                        return;
                    }
                }
            }
            OutputLinks[Index].bHasImpulse = true;
            return;
        }
        Index++;
        // [Loop Continue]
        goto J0x1C;
    }
    OutputLinks[7].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    MapNames[0]="TRA"
    MapNames[1]="HUS"
    MapNames[2]="AVA"
    MapNames[3]="NEP"
    MapNames[4]="MAR"
    MapNames[5]="VAR_FAC"
    MapNames[6]="VAR_FLK"
    OutputLinks[0]=(Links=none,LinkDesc="Training",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Husky",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Avalanche",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="Neptune",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[4]=(Links=none,LinkDesc="MarketGarden",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[5]=(Links=none,LinkDesc="Varsity",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[6]=(Links=none,LinkDesc="Varsity2",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[7]=(Links=none,LinkDesc="Unknown",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[8]=(Links=none,LinkDesc="Hus_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[9]=(Links=none,LinkDesc="Ava_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[10]=(Links=none,LinkDesc="Nep_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[11]=(Links=none,LinkDesc="Mar_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[12]=(Links=none,LinkDesc="Fac_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[13]=(Links=none,LinkDesc="Flk_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjClassVersion=4
    ObjName="Get Current Map Name From Save Data2"
    ObjCategory="UI"
}