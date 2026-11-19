class AdvWeap_DP27_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var EvilSkelControl_SpinControl MagSkelControl;
var bool MagSleepState;

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

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPawn P;
        local bool bSuppressDrop;

        super.BeginState(PreviousStateName);
        // End:0x4C
        if(WorldInfo.GRI.IsMultiplayerGame())
        {
            return;
        }
        bSuppressDrop = (EvilInvManager.PendingWeapon == none) || EvilInvManager.PendingWeapon.bMeleeWeapon;
        P = EvilPawn(Instigator);
        // End:0x118
        if((P != none) && !bSuppressDrop)
        {
            P.TossInventory(self);
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

        super.BeginState(PreviousStateName);
        // End:0x4C
        if(WorldInfo.GRI.IsMultiplayerGame())
        {
            return;
        }
        bSuppressDrop = (EvilInvManager.PendingWeapon == none) || EvilInvManager.PendingWeapon.bMeleeWeapon;
        P = EvilPawn(Instigator);
        // End:0x10E
        if((P != none) && !bSuppressDrop)
        {
            P.TossInventory(self);
        }
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x66
        if(MagSkelControl == none)
        {
            MagSkelControl = EvilSkelControl_SpinControl(SkeletalMeshComponent(Mesh).FindSkelControl('magazynek'));
        }
        MagSleepState = false;
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        super(EvilWeap_Base).Tick(DeltaTime);
        // End:0x104
        if(MagSkelControl != none)
        {
            // End:0x99
            if(MagSleepState)
            {
                // End:0x8A
                if(MagSkelControl.DegreesPerSecond > float(0))
                {
                    MagSkelControl.DegreesPerSecond -= (DeltaTime * float(8000));                    
                }
                else
                {
                    MagSleepState = false;
                }                
            }
            else
            {
                // End:0xF8
                if(MagSkelControl.DegreesPerSecond < float(300))
                {
                    MagSkelControl.DegreesPerSecond += (DeltaTime * float(5000));                    
                }
                else
                {
                    MagSleepState = true;
                }
            }
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x46
        if(MagSkelControl != none)
        {
            MagSkelControl.DegreesPerSecond = 0.0000000;
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    bPurchasedWeaponDLC=false
    WeaponStatMP_Damage=6
    WeaponStatMP_Accuracy=3
    WeaponStatMP_Magazines=7
    WeaponStatMP_ReloadSpeed=3
    EWeaponType=WeaponType.TYPE_HMG
    FlashlightBaseSpotlightOffset=(X=-10.0000000,Y=-16.0000000,Z=-25.0000000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-300,Yaw=150,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-10.0000000,Y=-16.0000000,Z=0.0000000)
    BothHandWeapon=true
    bFastRepeater=true
    DefaultAmmoCount=141
    MaxAmmoCount=141
    MagazineAmmoCount=47
    MagazineMaxAmmoCount=47
    WeaponHitRange=9000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    MoveSpreadMultiplier=1.6000000
    MinReloadPct=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_DP27_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="DP-27 Ammo"
    ReloadTime=2.5000000
    MovementSpeedModifier=0.7000000
    InventoryGroup=3
    ZoomedTargetFOV=50.0000000
    ZoomedMeshTranslation=(X=-36.0759000,Y=-10.3524000,Z=5.0935000)
    ZoomedMeshRotation=(Pitch=-46,Yaw=112,Roll=289)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.8000000
    // Reference: AudioComponent'Default__AdvWeap_DP27_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_DP27_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    BackForceVector=(X=-0.4000000,Y=0.0400000,Z=0.2000000)
    BackForceMax=(X=15.0000000,Y=1.0000000,Z=3.0000000)
    RecoilMax=3000.0000000
    WeaponName="DP27"
    PlayerViewOffset=(X=18.5308000,Y=5.4038000,Z=-8.7500000)
    PlayerRotationOffset=(Pitch=-699,Yaw=-118,Roll=-351)
    CurrentRating=0.8000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.6000000
    PutDownTime=0.6000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_DP27_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.8000000
    ItemName="DP-27"
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_DP27_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}