class SeqAct_R6DisableRainbowAISounds extends SequenceAction
    native
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Disable",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Enable",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Disabled",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Enabled",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Pawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Disable Rainbow AI Sounds"
    ObjCategory="R6Team"
}