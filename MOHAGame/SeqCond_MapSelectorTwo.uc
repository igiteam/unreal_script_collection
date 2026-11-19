class SeqCond_MapSelectorTwo extends SequenceCondition
    hidecategories(Object);

var() array<string> MapNames;

function Activated()
{
    local string MapName;
    local int Index;

    MapName = Class'Engine.SaveLoadSystem'.static.GetMapName();
    Index = 0;
    J0x1C:

    // End:0x6C [Loop If]
    if(Index < MapNames.Length)
    {
        // End:0x62
        if(InStr(MapName, MapNames[Index]) != -1)
        {
            OutputLinks[Index].bHasImpulse = true;
            return;
        }
        Index++;
        // [Loop Continue]
        goto J0x1C;
    }
    OutputLinks[5].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    MapNames[0]="Hus"
    MapNames[1]="Ava"
    MapNames[2]="Nep"
    MapNames[3]="Mar"
    MapNames[4]="Var_Flk"
    MapNames[5]="Var_Fac"
    OutputLinks[0]=(Links=none,LinkDesc="Husky",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Avalanche",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Neptune",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="MarketGarden",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[4]=(Links=none,LinkDesc="Varsity",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[5]=(Links=none,LinkDesc="Varsity2",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[6]=(Links=none,LinkDesc="Unknown",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjClassVersion=4
    ObjName="Get Current Map Name From Save Data"
    ObjCategory="UI"
}