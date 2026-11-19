class SeqAct_R6MathOperationInt extends SequenceAction
    native
    hidecategories(Object);

enum EMathOperation
{
    MO_ADDITION,                    // 0
    MO_SUBTRACTION,                 // 1
    MO_MULTIPLICATION,              // 2
    MO_DIVISION,                    // 3
    MO_MAX                          // 4
};

var() SeqAct_R6MathOperationInt.EMathOperation m_eMathOperation;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="A",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="B",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Result",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Math Operation Int"
    ObjCategory="Math"
}