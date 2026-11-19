class SeqAct_R6AnimStaticShoot extends SeqAct_Latent
    native
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Fire bullet",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Pawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    ObjName="Shoot In Animation"
    ObjCategory="R6AI"
}