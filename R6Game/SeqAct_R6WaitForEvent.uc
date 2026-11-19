class SeqAct_R6WaitForEvent extends SeqAct_Latent
    native
    hidecategories(Object);

var() name m_EventNameToWaitFor;
var bool m_bReadyForEvent;
var bool m_bReceivedEvent;

// Export USeqAct_R6WaitForEvent::execOnEvent(FFrame&, void* const)
native final function OnEvent(name EventName);

defaultproperties
{
    m_EventNameToWaitFor="DefaultEvent"
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjClassVersion=2
    ObjName="Wait For Kismet Event"
    ObjCategory="Event"
}