class SkyBTNode_Act_MetaVariable extends SkyBTNode_Leaf_Action
    native;

enum MetaVariableOp
{
    MVOP_Assign,                    // 0
    MVOP_Increment,                 // 1
    MVOP_Decrement,                 // 2
    MVOP_CheckExists,               // 3
    MVOP_CheckLessThan,             // 4
    MVOP_CheckGreaterThan,          // 5
    MVOP_Undefine,                  // 6
    MVOP_MAX                        // 7
};

var(Variable) string VariableName;
var(Variable) float VariableValue;
var(Variable) bool bVariableIsGlobal;
var(Variable) bool bRelativeToWorldTime;
var(Variable) SkyBTNode_Act_MetaVariable.MetaVariableOp Operation;
