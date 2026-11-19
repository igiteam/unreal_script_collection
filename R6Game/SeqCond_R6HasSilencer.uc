class SeqCond_R6HasSilencer extends SequenceCondition
    native
    hidecategories(Object);

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Equipped",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Not Equipped",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Pawn",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Is Silencer Equipped"
}