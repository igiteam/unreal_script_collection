class SeqEvent_R6TeamAlertStatus extends SequenceEvent
    native
    hidecategories(Object);

var() float m_fThresholdAware;
var() float m_fThresholdCombating;
var() bool m_bTriggerWhenAnyPawnChangesStatus;
var bool m_bTriggerOnAwareChange;
var bool m_bTriggerOnCombatChange;

defaultproperties
{
    m_fThresholdAware=0.5000000
    m_fThresholdCombating=0.5000000
    m_bTriggerOnAwareChange=true
    m_bTriggerOnCombatChange=true
    MaxTriggerCount=2
    bPlayerOnly=false
    OutputLinks[0]=(Links=none,LinkDesc="Now Aware",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Now Combating",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Team Status Changed"
    ObjCategory="Team"
}