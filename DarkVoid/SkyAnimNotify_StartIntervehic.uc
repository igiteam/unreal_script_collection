class SkyAnimNotify_StartIntervehic extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x2F
    if(P != none)
    {
        P.JumpVehicle();
    }
    //return;    
}
