class SeqAct_R6WaitRainbowAlive extends SeqAct_Latent
    native
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Check Status",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="All Alive",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Rainbow",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Wait Until Rainbow Alive"
    ObjCategory="R6Team"
}