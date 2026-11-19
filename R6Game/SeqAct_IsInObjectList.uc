class SeqAct_IsInObjectList extends SequenceAction
    native
    hidecategories(Object);

var() bool bCheckForAllObjects;
var private transient bool bObjectFound;

defaultproperties
{
    bCheckForAllObjects=true
    InputLinks[0]=(LinkDesc="Test if in List",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="In List",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Not in List",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Object(s)ToTest",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_ObjectList',LinkedVariables=none,LinkDesc="ObjectListVar",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="IsIn ObjectList"
    ObjCategory="Object List"
}