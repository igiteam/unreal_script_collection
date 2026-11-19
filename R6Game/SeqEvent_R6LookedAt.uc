class SeqEvent_R6LookedAt extends SequenceEvent
    native
    hidecategories(Object);

var() float m_fMaxLookedAtDistance;
var() float m_fLookedAtDuration;
var float m_fVisibleByPlayerTime;

defaultproperties
{
    m_fMaxLookedAtDistance=5000.0000000
    ObjName="Looked At"
    ObjCategory="Actor"
}