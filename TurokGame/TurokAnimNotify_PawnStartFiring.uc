class TurokAnimNotify_PawnStartFiring extends AnimNotify_Scripted
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

event Notify(@NULL Owner, @NULL SkelComponent)
{
    // End:0x29
    if(TurokPawn(Owner) != none)
    {
        TurokPawn(Owner).BotFire(false);
    }
    //return;    
}
