class SkyAnimNotify_DodgeInteruptible extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bInteruptible;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x32
    if(P != none)
    {
        P.bDodgeInteruptible = bInteruptible;
    }
    //return;    
}
