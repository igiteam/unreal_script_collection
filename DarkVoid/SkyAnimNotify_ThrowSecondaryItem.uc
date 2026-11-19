class SkyAnimNotify_ThrowSecondaryItem extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x5D
    if((P != none) && SkySecondaryItem(P.SecondaryWeapon) != none)
    {
        SkySecondaryItem(P.SecondaryWeapon).Release();        
    }
    else
    {
        P.ClientMessage("Failed to throw secondary item.");
    }
    //return;    
}
