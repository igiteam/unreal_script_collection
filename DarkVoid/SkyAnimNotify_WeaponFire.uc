class SkyAnimNotify_WeaponFire extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() int FireMode;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x4D
    if((P != none) && P.Weapon != none)
    {
        P.StartFire(byte(FireMode));
    }
    //return;    
}
