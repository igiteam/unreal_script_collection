class TurokAnimNotify_PawnEndFiring extends AnimNotify_Scripted
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

event Notify(@NULL Owner, @NULL SkelComponent)
{
    // End:0x28
    if(TurokPawn(Owner) != none)
    {
        TurokPawn(Owner).StopFiring();
    }
    //return;    
}
