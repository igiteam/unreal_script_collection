class SkyAnimNotify_LockStick extends SkyAnimNotify_Reversible
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bStickLocked;
var() bool bZeroInputOnLock;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Pawn P;

    P = Pawn(Owner);
    // End:0x66
    if((P != none) && SkyPlayerController(P.Controller) != none)
    {
        SkyPlayerController(P.Controller).LockMoveInput(bStickLocked, bZeroInputOnLock);
    }
    super(AnimNotify_Scripted).Notify(Owner, AnimSeqInstigator);
    //return;    
}

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Pawn P;
    local SkyPlayerController PCtrl;

    P = Pawn(Owner);
    // End:0x5D
    if(P != none)
    {
        PCtrl = SkyPlayerController(P.Controller);
        // End:0x5D
        if(PCtrl != none)
        {
            PCtrl.LockMoveInput(!bStickLocked);
        }
    }
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}
