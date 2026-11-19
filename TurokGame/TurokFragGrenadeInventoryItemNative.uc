class TurokFragGrenadeInventoryItemNative extends TurokGrenadeInventoryItem
    config(Game)
    hidecategories(Navigation);

function GivenTo(@NULL thisPawn, optional bool bDoNotActivate)
{
    local @NULL invMan;

    invMan = TurokInventoryManager(thisPawn.InvManager);
    // End:0x3D
    if(invMan != none)
    {
        invMan.OnPickupAmmo(Class'TurokAmmoPoolGrenade');
    }
    super(TurokInventory).GivenTo(thisPawn, bDoNotActivate);
    //return;    
}

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokFragGrenadeInventoryItemNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}