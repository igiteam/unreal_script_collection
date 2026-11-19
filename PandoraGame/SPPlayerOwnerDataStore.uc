class SPPlayerOwnerDataStore extends PlayerOwnerDataStore
    transient;

final function CreateCurrentWeaponDataProvider(SPWeapon Weapon)
{
    // End:0x4E
    if(Weapon != none)
    {
        // End:0x31
        if(CurrentWeapon == none)
        {
            CurrentWeapon = new ProviderTypes.CurrentWeaponDataProviderClass;
        }
        // End:0x4B
        if(!CurrentWeapon.BindProviderInstance(Weapon))
        {
        }        
    }
    //return;    
}
