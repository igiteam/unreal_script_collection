class SkyAnimNotify_SetHidden extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bHidden;
var() float RevertTime;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    Owner.SetHidden(bHidden);
    // End:0x69
    if(RevertTime > float(0))
    {
        // End:0x4C
        if(bHidden)
        {
            Owner.SetTimer(RevertTime, false, 'TimedShow');            
        }
        else
        {
            Owner.SetTimer(RevertTime, false, 'TimedHide');
        }
    }
    //return;    
}
