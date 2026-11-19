class SkyAnimNotify_ThrowDynamite extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x3A
    if((P != none) && SkyItem_Dynamite(P.SecondaryWeapon) != none)
    {        
    }
    else
    {
        P.ClientMessage("Failed to throw dynamite.");
    }
    //return;    
}
