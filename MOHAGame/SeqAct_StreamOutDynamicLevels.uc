class SeqAct_StreamOutDynamicLevels extends SeqAct_MultiLevelStreaming
    native
    hidecategories(Object,SeqAct_MultiLevelStreaming,SeqAct_LevelStreamingBase);

defaultproperties
{
    bShouldBlockOnLoad=true
    InputLinks[0]=(LinkDesc="Stream Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    ObjName="Stream Out Dynamic Levels"
}