class Interaction extends UIRoot
    transient
    native;

var bool m_bEnableUseGamePadOption;
var int m_iDesiredIndex;
//var delegate<OnInitialize> __OnInitialize__Delegate;

// Export UInteraction::execInputKey(FFrame&, void* const)
native event bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed);

// Export UInteraction::execInputChar(FFrame&, void* const)
native event bool InputChar(int ControllerId, string Unicode);

// Export UInteraction::execInit(FFrame&, void* const)
native final function Init();

delegate OnInitialize()
{
    return;
}

function Initialized()
{
    return;
}

// Export UInteraction::execCanProcessKey(FFrame&, void* const)
native function bool CanProcessKey(name Key);

defaultproperties
{
    m_iDesiredIndex=-1
    OnInitialize=Initialized
}