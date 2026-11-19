class SeqCond_MapSelector extends SequenceCondition
    hidecategories(Object);

function Activated()
{
    switch(GetWorldInfo().MapName)
    {
        // End:0x39
        case "Hus_Briefing":
            OutputLinks[0].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x5B
        case "Husky1":
            OutputLinks[1].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x84
        case "Ava_Briefing":
            OutputLinks[2].bHasImpulse = true;
            // End:0x252
            break;
        // End:0xAB
        case "Avalanche1":
            OutputLinks[3].bHasImpulse = true;
            // End:0x252
            break;
        // End:0xD4
        case "Nep_Briefing":
            OutputLinks[4].bHasImpulse = true;
            // End:0x252
            break;
        // End:0xF9
        case "Neptune1":
            OutputLinks[5].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x122
        case "Mar_Briefing":
            OutputLinks[6].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x14C
        case "MarketGarden1":
            OutputLinks[7].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x179
        case "Var_Fac_Briefing":
            OutputLinks[8].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x19E
        case "Varsity1":
            OutputLinks[9].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x1CB
        case "Var_Flk_Briefing":
            OutputLinks[10].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x1F0
        case "Varsity2":
            OutputLinks[11].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x215
        case "Training":
            OutputLinks[12].bHasImpulse = true;
            // End:0x252
            break;
        // End:0x237
        case "Shell":
            OutputLinks[14].bHasImpulse = true;
            // End:0x252
            break;
        // End:0xFFFF
        default:
            OutputLinks[13].bHasImpulse = true;
            // End:0x252
            break;
            break;
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Hus_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Husky1",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Ava_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="Avalanche1",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[4]=(Links=none,LinkDesc="Nep_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[5]=(Links=none,LinkDesc="Neptune1",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[6]=(Links=none,LinkDesc="Mar_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[7]=(Links=none,LinkDesc="MarketGarden1",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[8]=(Links=none,LinkDesc="Var_Fac_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[9]=(Links=none,LinkDesc="Varsity1",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[10]=(Links=none,LinkDesc="Var_Flk_Briefing",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[11]=(Links=none,LinkDesc="Varsity2",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[12]=(Links=none,LinkDesc="Training",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[13]=(Links=none,LinkDesc="Shell",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[14]=(Links=none,LinkDesc="Other",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjClassVersion=5
    ObjName="Get Current Map Name From Map's WorldInfo"
    ObjCategory="UI"
}