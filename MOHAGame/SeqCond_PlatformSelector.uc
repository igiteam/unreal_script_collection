class SeqCond_PlatformSelector extends SequenceCondition
    hidecategories(Object);

function Activated()
{
    switch(GetWorldInfo().GetPlatform())
    {
        // End:0x35
        case 'PC':
            OutputLinks[0].bHasImpulse = true;
            // End:0x7F
            break;
        // End:0x58
        case 'Xenon':
            OutputLinks[1].bHasImpulse = true;
            // End:0x7F
            break;
        // End:0x7C
        case 'PS3':
            OutputLinks[2].bHasImpulse = true;
            // End:0x7F
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="PC",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Xenon",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="PS3",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="WhichPlatform"
    ObjCategory="UI"
}