class SeqAct_ModifyObjectList extends SequenceAction
    native
    hidecategories(Object);

var() editconst int ListEntriesCount;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Add To List",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Remove From List",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Empty List",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="ObjectRef",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_ObjectList',LinkedVariables=none,LinkDesc="ObjectListVar",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_Int',LinkedVariables=none,LinkDesc="ListEntriesCount",LinkVar="None",PropertyName="ListEntriesCount",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Modify ObjectList"
    ObjCategory="Object List"
}