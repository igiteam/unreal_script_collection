class SkySplineNotify_RemoteEvent extends SkySplineNotify
    editinlinenew
    collapsecategories;

var() name EventName;

simulated event Activated(Actor Target)
{
    // End:0x38
    if(SkyInteractor(Target) != none)
    {
        SkyInteractor(Target).TriggerRemoteEvent(EventName, Target, Target);
    }
    //return;    
}
