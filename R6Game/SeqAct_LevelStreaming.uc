class SeqAct_LevelStreaming extends SeqAct_Latent
    native
    hidecategories(Object);

var() /*0x40000000-0x00000000*/ LevelStreamingKismet Level;
var() name LevelName;
var() bool bMakeVisibleAfterLoad;
var() bool bShouldBlockOnLoad;

defaultproperties
{
    bMakeVisibleAfterLoad=true
    InputLinks[0]=(LinkDesc="Load",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Unload",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Stream Level"
    ObjCategory="Level"
}