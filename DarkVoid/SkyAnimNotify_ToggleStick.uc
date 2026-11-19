class SkyAnimNotify_ToggleStick extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bStickActive;
var() bool bLookActive;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Pawn P;

    P = Pawn(Owner);
    // End:0x8F
    if((P != none) && PlayerController(P.Controller) != none)
    {
        PlayerController(P.Controller).IgnoreMoveInput(!bStickActive);
        PlayerController(P.Controller).IgnoreLookInput(!bLookActive);
    }
    //return;    
}
