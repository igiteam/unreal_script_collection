class SeqCond_MP_GameMode extends SequenceCondition
    hidecategories(Object);

function Activated()
{
    local WorldInfo TheWorld;
    local GameReplicationInfo theGRI;

    TheWorld = GetWorldInfo();
    // End:0x2B
    if(TheWorld != none)
    {
        theGRI = TheWorld.GRI;
    }
    // End:0xD9
    if(theGRI != none)
    {
        // End:0x64
        if(theGRI.IsA('ObjectiveAirborneGameReplicationInfo'))
        {
            OutputLinks[0].bHasImpulse = true;            
        }
        else
        {
            // End:0x92
            if(theGRI.IsA('TeamDeathMatchAirborneGameReplicationInfo'))
            {
                OutputLinks[1].bHasImpulse = true;                
            }
            else
            {
                // End:0xC1
                if(theGRI.IsA('TDMGameReplicationInfo'))
                {
                    OutputLinks[2].bHasImpulse = true;                    
                }
                else
                {
                    OutputLinks[3].bHasImpulse = true;
                }
            }
        }        
    }
    else
    {
        OutputLinks[4].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="AB",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="ADM",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="DM",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="Unknown",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[4]=(Links=none,LinkDesc="Error",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="WhichGameMode"
    ObjCategory="Multiplayer"
}