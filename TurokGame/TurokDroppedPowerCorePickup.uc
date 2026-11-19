class TurokDroppedPowerCorePickup extends TurokDroppedPickup
    hidecategories(Navigation);

simulated event GoToPickupState()
{
    mCylinderCollision.SetSize(40.0000000, 60.0000000);
    InitPickupState();
    GotoState('Pickup');
    //return;    
}

function GiveTo(@NULL pwn)
{
    local @NULL mgr, powerCore;

    powerCore = TurokMPObjectiveItemPowerCoreNative(Inventory);
    // End:0xD3
    if(powerCore != none)
    {
        // End:0x91
        if(powerCore.CanBePickedUp(pwn))
        {
            mgr = TurokInventoryManager(pwn.InvManager);
            // End:0x8E
            if(mgr != none)
            {
                Inventory.super(Inventory).GiveTo(pwn);
                Inventory.AnnouncePickup(pwn);
                Inventory = none;
            }            
        }
        else
        {
            // DebugMode: 0
            assert(powerCore.GetMPPickupFactory() != none);
            powerCore.GetMPPickupFactory().EnablePickup();
            Inventory = none;
        }
    }
    PickedUpBy(pwn);
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__TurokDroppedPowerCorePickup.CollisionCylinder'
    begin object name=CollisionCylinder
        Translation=(X=0.0000000,Y=0.0000000,Z=20.0000000)
    end object
    mCylinderCollision=CollisionCylinder
    // Reference: TurokSoundController'Default__TurokDroppedPowerCorePickup.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokDroppedPowerCorePickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}