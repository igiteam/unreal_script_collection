class SeqCond_IncrementFloat extends SequenceCondition
    native
    hidecategories(Object);

var() float IncrementAmount;
var() float ValueA;
var() float ValueB;
var float sValueA;
var float sValueB;

defaultproperties
{
    IncrementAmount=1.0000000
    OutputLinks[0]=(Links=none,LinkDesc="A <= B",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="A > B",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="A == B",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="A < B",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[4]=(Links=none,LinkDesc="A >= B",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="A",LinkVar="None",PropertyName="ValueA",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="B",LinkVar="None",PropertyName="ValueB",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Float Counter"
    ObjCategory="Counter"
}