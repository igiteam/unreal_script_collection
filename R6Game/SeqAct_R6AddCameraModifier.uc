class SeqAct_R6AddCameraModifier extends SequenceAction
    hidecategories(Object);

var() array< class<CameraModifier> > ModifiersType;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Add",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Remove",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Camera",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Change Camera Modifiers"
    ObjCategory="Camera"
}