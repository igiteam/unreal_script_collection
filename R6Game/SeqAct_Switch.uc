class SeqAct_Switch extends SequenceAction
    native
    hidecategories(Object);

var() int LinkCount;
var() int IncrementAmount;
var() bool bLooping;
var() bool bAutoDisableLinks;
var() array<int> Indices;
var array<int> sIndices;

defaultproperties
{
    LinkCount=1
    IncrementAmount=1
    Indices[0]=1
    OutputLinks[0]=(Links=none,LinkDesc="Link 1",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Int',LinkedVariables=none,LinkDesc="Index",LinkVar="None",PropertyName="Indices",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Switch"
    ObjCategory="Switch"
}