class R6AnimNodeSequenceHandSignal extends R6AnimNodeSequenceCustom
    native
    hidecategories(Object,Object,Object,Object);

enum EHandSignalType
{
    HANDSIGNAL_FP,                  // 0
    HANDSIGNAL_TP,                  // 1
    HANDSIGNAL_TC,                  // 2
    HANDSIGNAL_TCCROUCH,            // 3
    HANDSIGNAL_MAX                  // 4
};

var(HandSignal) R6AnimNodeSequenceHandSignal.EHandSignalType m_eType;
var R6EngineEnums.EOrderSignalId m_Order;
var transient int m_iLastTick;
