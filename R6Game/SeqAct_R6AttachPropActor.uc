class SeqAct_R6AttachPropActor extends SequenceAction
    native
    hidecategories(Object);

var() name m_AttachBoneName;
var() Vector m_vRelativeLocation;
var() Rotator m_rRelativeRotation;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Prop",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Attach Prop Actor"
    ObjCategory="Actor"
}