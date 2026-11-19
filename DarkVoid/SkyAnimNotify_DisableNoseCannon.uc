class SkyAnimNotify_DisableNoseCannon extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn_Archon SPA;

    SPA = SkyPawn_Archon(Owner);
    // End:0x1D
    if(SPA == none)
    {
        return;
    }
    // End:0x55
    if(SPA.Weapon != none)
    {
        SkyWeap_ArchonBeam(SPA.Weapon).DisableWeapon();
    }
    //return;    
}
