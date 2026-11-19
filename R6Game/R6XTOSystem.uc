class R6XTOSystem extends Object
    native;

var R6TeamCommunication m_tcOrderQueue[16];
var int m_iNumMessagesInQueue;
var array<R6AICommunicateDef_Ptr> m_aXTOSMessage;

// Export UR6XTOSystem::execInit(FFrame&, void* const)
native final function Init();

// Export UR6XTOSystem::execDestroy(FFrame&, void* const)
native final function Destroy();
