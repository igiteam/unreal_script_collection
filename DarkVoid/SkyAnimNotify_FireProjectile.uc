class SkyAnimNotify_FireProjectile extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x71
    if(((P != none) && P.Weapon != none) && SkyWeapon(P.Weapon) != none)
    {
        SkyWeapon(P.Weapon).FireProjectile();
    }
    //return;    
}
