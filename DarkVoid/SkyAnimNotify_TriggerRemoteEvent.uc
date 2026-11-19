class SkyAnimNotify_TriggerRemoteEvent extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() name Event;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyInteractor SI;

    SI = SkyInteractor(Owner);
    // End:0x3E
    if(SI != none)
    {
        SI.TriggerRemoteEvent(Event, Owner, Owner);
    }
    //return;    
}
