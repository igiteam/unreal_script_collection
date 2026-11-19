class SkyAnimNotify_Sound extends SkyAnimNotify_Reversible
    native
    config(Engine)
    editinlinenew
    collapsecategories;

var() SoundCue Sound;
var() float Volume;
var() float Pitch;
var() float FadeOutTime;
var() array<string> WillVOSoundGroups;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x35
    if(SP != none)
    {
        SP.PlaySoundNotify(self, AnimSeqInstigator);
    }
    super(AnimNotify_Scripted).Notify(Owner, AnimSeqInstigator);
    //return;    
}

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x35
    if(SP != none)
    {
        SP.StopSoundNotify(self, AnimSeqInstigator);
    }
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}
