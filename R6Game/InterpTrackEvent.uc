class InterpTrackEvent extends InterpTrack
    native
    collapsecategories
    hidecategories(Object);

struct EventTrackKey
{
    var float Time;
    var() name EventName;

    structdefaultproperties
    {
        Time=0.0000000
        EventName="None"
    }
};

var array<EventTrackKey> EventTrack;
var() bool bFireEventsWhenForwards;
var() bool bFireEventsWhenBackwards;

defaultproperties
{
    bFireEventsWhenForwards=true
    bFireEventsWhenBackwards=true
    TrackInstClass=Class'InterpTrackInstEvent'
    TrackTitle="Event"
}