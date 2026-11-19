// extend UIEvent if this event should be UI Kismet Event instead of a Level Kismet Event
class FHPlayerDeathEvent extends SequenceEvent;

event Activated() 
{
	LogInternal("deathEvent");
}


// Decompiled with UE Explorer.
defaultproperties
{
    ObjName="FHPlayerDeathEvent"
    ObjCategory="ForeverHunted Events"
}