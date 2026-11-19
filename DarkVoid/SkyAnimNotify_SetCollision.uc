class SkyAnimNotify_SetCollision extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bCollideActors;
var() bool bBlockActors;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Pawn P;

    P = Pawn(Owner);
    // End:0x36
    if(P != none)
    {
        P.SetCollision(bCollideActors, bBlockActors);
    }
    //return;    
}
