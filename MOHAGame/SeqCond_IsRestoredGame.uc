class SeqCond_IsRestoredGame extends SequenceCondition
    hidecategories(Object);

event Activated()
{
    // End:0x29
    if(Class'Engine.SaveLoadSystem'.static.AtLevelStartCheckpoint())
    {
        OutputLinks[1].bHasImpulse = true;        
    }
    else
    {
        OutputLinks[0].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="True",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="False",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Is Restored Game"
    ObjCategory="Save/Load"
}