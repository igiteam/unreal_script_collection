class SkyAnimNotify_ThrowAirRemote extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x5D
    if((P != none) && SkyItem_AirRemote(P.SecondaryWeapon) != none)
    {
        SkyItem_AirRemote(P.SecondaryWeapon).Release();        
    }
    else
    {
        P.ClientMessage("Failed to throw air remote.");
    }
    //return;    
}
