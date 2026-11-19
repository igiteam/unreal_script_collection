class TurokDroppedBombPickup extends TurokDroppedPickup
    hidecategories(Navigation);

state Pickup
{
    function bool ValidTouch(@NULL pwn)
    {
        // End:0x2C
        if(super.ValidTouch(pwn))
        {
            return TurokBombNative(Inventory).CanBePickedUp(pwn);
        }
        return false;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__TurokDroppedBombPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    mCylinderCollision=CollisionCylinder
    // Reference: TurokSoundController'Default__TurokDroppedBombPickup.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokDroppedBombPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}