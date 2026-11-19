class SeqCond_IsInCinematicMode extends SequenceCondition
    hidecategories(Object);

function Activated()
{
    local MOHAPlayerController MOHAPC;

    // End:0x37
    foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', MOHAPC)
    {
        // End:0x36
        if(NetConnection(MOHAPC.Player) == none)
        {
            // End:0x37
            break;
        }        
    }    
    OutputLinks[0].bHasImpulse = MOHAPC.bCinematicMode;
    OutputLinks[1].bHasImpulse = !MOHAPC.bCinematicMode;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="True",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="False",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Is In Cinematic Mode"
}