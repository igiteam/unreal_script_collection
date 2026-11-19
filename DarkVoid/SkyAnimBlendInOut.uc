class SkyAnimBlendInOut extends SkyAnimBlendBase
    native;

enum EBlendInOutTypes
{
    IOBT_In,                        // 0
    IOBT_Loop,                      // 1
    IOBT_Out,                       // 2
    IOBT_None,                      // 3
    IOBT_MAX                        // 4
};

var Object NotifyObj;
var name NotifyEvent;
var const SkyAnimBlendInOut.EBlendInOutTypes State;

// Export USkyAnimBlendInOut::execTriggerOut(FFrame&, void* const)
native function TriggerOut(Object TriggerObj, name Event);
