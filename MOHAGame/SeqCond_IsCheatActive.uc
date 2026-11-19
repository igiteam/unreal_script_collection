class SeqCond_IsCheatActive extends SequenceCondition
    hidecategories(Object);

var() MOHAIncludeClass.ECheatType Cheat;

function Activated()
{
    local bool bCheatStatus;
    local MOHAPlayerController PlayerController;

    // End:0xD7
    foreach GetWorldInfo().LocalPlayerControllers(PlayerController)
    {
        // End:0x80
        if(int(Cheat) == int(7))
        {
            // End:0x69
            if(PlayerController.IsAnyCheatActive() || PlayerController.bUsedCheat)
            {
                OutputLinks[0].bHasImpulse = true;                
                return;
            }
            OutputLinks[1].bHasImpulse = true;            
            return;
        }
        bCheatStatus = PlayerController.IsCheatActive(Cheat);
        OutputLinks[0].bHasImpulse = bCheatStatus;
        OutputLinks[1].bHasImpulse = !bCheatStatus;        
        return;        
    }    
    OutputLinks[1].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="True",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="False",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjClassVersion=2
    ObjName="Is Cheat Active"
}