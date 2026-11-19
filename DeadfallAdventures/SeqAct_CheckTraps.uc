class SeqAct_CheckTraps extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local WorldInfo WorldInfo;

    WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0xA6
    if(WorldInfo.GRI != none)
    {
        // End:0x9B
        if(AdvGRI(WorldInfo.GRI).bTraps)
        {
            ActivateOutputLink(0);            
        }
        else
        {
            ActivateOutputLink(1);
        }
    }
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    OutputLinks[0]=(Links=none,LinkDesc="True",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="False",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks=none
    ObjName="Traps enabled? (Multiplayer)"
}