class SPAnimGenericFunctionMonitorNode extends SPAnimSwitchNode
    native;

/** Enums Variable Declaration the name of the variable to monitor in our owner's SPAIController */
var() name functionName;
var() name InitFunctionName;
var() name ShutdownFunctionName;
/** variable only used by the editor for previewing animations */
var() transient name TestActiveChild;
var name ActiveChildName;
var transient Actor m_lastOwner;
var private native transient Pointer m_scriptCallBackFunction;
var transient name LastActiveChildName;
var transient int LastActiveIndex;

event name GenericFunctionMonitorProto(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    //return ReturnValue;    
}

event name GenericInitFunctionMonitorProto(SPAnimGenericFunctionMonitorNode Node)
{
    //return ReturnValue;    
}

event name GenericShutdownFunctionMonitorProto(SPAnimGenericFunctionMonitorNode Node)
{
    //return ReturnValue;    
}
