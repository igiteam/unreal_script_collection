class SeqAct_LevelVisibility extends SeqAct_Latent
    native
    hidecategories(Object);

var() LevelStreamingKismet Level;
var() name LevelName;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Make Visible",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Hide",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Change Level Visibility"
    ObjCategory="Level"
}