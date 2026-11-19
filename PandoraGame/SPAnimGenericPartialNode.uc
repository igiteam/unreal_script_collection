class SPAnimGenericPartialNode extends SPAnimPartialBlendNode
    native;

/** Enums Variable Declaration the name of the variable to monitor in our owner's SPAIController */
var() name functionName;
/** variable only used by the editor for previewing animations */
var() transient name TestActiveChild;

event float GenericPartialFunctionProto(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    //return ReturnValue;    
}
