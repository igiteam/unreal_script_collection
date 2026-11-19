class AdvInventoryItem_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPawn P;

        super.BeginState(PreviousStateName);
        P = EvilPawn(Owner);
        // End:0xF5
        if((P != none) && (P.EvilInvManager.PendingWeaponLeft == none) || !ClassIsChildOf(P.EvilInvManager.PendingWeaponLeft.Class, Class'AdvInventoryItem_Base'))
        {
            P.SetBlockingInventoryClass(none, true);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    bSelectable=false
    bDisplayCrosshair=false
    LockerAmmoCount=99
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvInventoryItem_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AttachmentClass=Class'AdvInventoryItemAttachment_Base'
    // Reference: AudioComponent'Default__AdvInventoryItem_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvInventoryItem_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    CurrentRating=0.0000000
    AmmoCount=99
    WeaponFireTypes=/* Array type was not detected. */
    bCanThrow=false
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvInventoryItem_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.0000000
    MaxDesireability=0.0000000
    // Reference: SkeletalMeshComponent'Default__AdvInventoryItem_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}