class SeqAct_WaitUntilUnflashed extends SeqAct_Latent
    native
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Check Flashed",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Normal",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Pawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Wait Until Unflashed"
    ObjCategory="Pawn"
}