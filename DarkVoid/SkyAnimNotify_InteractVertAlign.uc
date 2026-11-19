class SkyAnimNotify_InteractVertAlign extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() float TravelTime;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x92
    if(P != none)
    {
        // End:0x56
        if(P.IsInteracting())
        {
            P.AutomoveTarget = P.GetInteractionPartner();
        }
        // End:0x92
        if(P.AutomoveTarget != none)
        {
            P.bAutomoveAlignVerticallyWithTarget = true;
            P.Automove_TranslateTime = TravelTime;
        }
    }
    //return;    
}
