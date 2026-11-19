class TriggerVolume extends Volume
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

var(Trigger) bool m_bTriggerWithPawnBlockVolume;

defaultproperties
{
    BrushColor=(R=100,G=255,B=100,A=255)
    bColored=true
    SupportedEvents[0]=Class'SeqEvent_Touch'
    SupportedEvents[1]=Class'SeqEvent_TakeDamage'
    SupportedEvents[2]=Class'SeqEvent_R6LookedAt'
}