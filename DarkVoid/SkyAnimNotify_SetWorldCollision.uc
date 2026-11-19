class SkyAnimNotify_SetWorldCollision extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bEnable;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Pawn P;

    P = Pawn(Owner);
    // End:0x32
    if(P != none)
    {
        P.bCollideWorld = bEnable;
    }
    //return;    
}
