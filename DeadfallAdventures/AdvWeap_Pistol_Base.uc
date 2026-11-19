class AdvWeap_Pistol_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var transient float thresholdPlayPistolSnd;

simulated function PlayWeaponEquip()
{
    local AdvPawn P;

    P = AdvPawn(Instigator);
    // End:0x8A
    if(WeaponEquipAnim != 'None')
    {
        PlayWeaponAnim(WeaponEquipAnim, EquipTime, EquipAnimBlendTimes.BlendIn, EquipAnimBlendTimes.BlendOut);
    }
    // End:0x109
    if((ArmsEquipAnim != 'None') && ArmsAnimSet != none)
    {
        PlayArmAnim(ArmsEquipAnim, EquipTime, EquipAnimBlendTimes.BlendIn, EquipAnimBlendTimes.BlendOut);
    }
    // End:0x1E1
    if((WeaponEquipSnd != none) && WorldInfo.TimeSeconds > float(3))
    {
        // End:0x1A4
        if(Abs(WorldInfo.TimeSeconds - P.lastPistolEquipOrPutDownSnd) > thresholdPlayPistolSnd)
        {
            WeaponPlaySound(WeaponEquipSnd,, true);
        }
        P.lastPistolEquipOrPutDownSnd = WorldInfo.TimeSeconds;
    }
    //return;    
}

simulated function PlayWeaponPutDown()
{
    local AdvPlayerPawn P;

    P = AdvPlayerPawn(Instigator);
    // End:0x8A
    if(WeaponPutDownAnim != 'None')
    {
        PlayWeaponAnim(WeaponPutDownAnim, PutDownTime, PutDownAnimBlendTimes.BlendIn, PutDownAnimBlendTimes.BlendOut);
    }
    // End:0x109
    if((ArmsPutDownAnim != 'None') && ArmsAnimSet != none)
    {
        PlayArmAnim(ArmsPutDownAnim, PutDownTime, PutDownAnimBlendTimes.BlendIn, PutDownAnimBlendTimes.BlendOut);
    }
    // End:0x204
    if((WeaponPutDownSnd != none) && (EvilInvManager.PendingWeapon != none) || EvilInvManager.PendingWeaponLeft != none)
    {
        // End:0x1C7
        if(Abs(WorldInfo.TimeSeconds - P.lastPistolEquipOrPutDownSnd) > thresholdPlayPistolSnd)
        {
            WeaponPlaySound(WeaponPutDownSnd);
        }
        P.lastPistolEquipOrPutDownSnd = WorldInfo.TimeSeconds;
    }
    //return;    
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    local EvilTouchPickUp_Base tmpPickup;

    // End:0x5F
    if(AmmoCount == 0)
    {
        tmpPickup = PickupArchetype;
        PickupArchetype = none;
        super.DropFrom(StartLocation, StartVelocity);
        PickupArchetype = tmpPickup;        
    }
    else
    {
        super.DropFrom(StartLocation, StartVelocity);
    }
    //return;    
}

simulated function bool ShouldRefire()
{
    return false;
    //return ReturnValue;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPawn P;
        local bool bSuppressDrop;
        local EvilWeap_Base Weap, WeapLeft;

        super.BeginState(PreviousStateName);
        // End:0x4C
        if(WorldInfo.GRI.IsMultiplayerGame())
        {
            return;
        }
        bSuppressDrop = ((EvilInvManager.PendingWeapon == none) || EvilInvManager.PendingWeapon.bMeleeWeapon) || HasAnyShareAmmo();
        P = EvilPawn(Instigator);
        // End:0x24E
        if((P != none) && !bSuppressDrop)
        {
            P.TossInventory(self);
            Weap = EvilInventoryManager(P.InvManager).HasWeaponWithInventoryGroup(int(InventoryGroup));
            // End:0x244
            if((Weap != none) && Weap.DefaultInfiniteWeapon)
            {
                Weap.bSelectable = true;
                WeapLeft = EvilWeap_Base(P.FindInventoryType(Weap.OffHandWeaponClass));
                // End:0x244
                if(WeapLeft != none)
                {
                    WeapLeft.bSelectable = true;
                }
            }
            WeaponIsDown();
        }
        //return;        
    }
    stop;    
}

simulated state WeaponAbortEquip
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPawn P;
        local bool bSuppressDrop;
        local EvilWeap_Base Weap, WeapLeft;

        super.BeginState(PreviousStateName);
        // End:0x4C
        if(WorldInfo.GRI.IsMultiplayerGame())
        {
            return;
        }
        bSuppressDrop = ((EvilInvManager.PendingWeapon == none) || EvilInvManager.PendingWeapon.bMeleeWeapon) || HasAnyShareAmmo();
        P = EvilPawn(Instigator);
        // End:0x244
        if((P != none) && !bSuppressDrop)
        {
            P.TossInventory(self);
            Weap = EvilInventoryManager(P.InvManager).HasWeaponWithInventoryGroup(int(InventoryGroup));
            // End:0x244
            if((Weap != none) && Weap.DefaultInfiniteWeapon)
            {
                Weap.bSelectable = true;
                WeapLeft = EvilWeap_Base(P.FindInventoryType(Weap.OffHandWeaponClass));
                // End:0x244
                if(WeapLeft != none)
                {
                    WeapLeft.bSelectable = true;
                }
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    thresholdPlayPistolSnd=0.2000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Pistol_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__AdvWeap_Pistol_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Pistol_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Pistol_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Pistol_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}