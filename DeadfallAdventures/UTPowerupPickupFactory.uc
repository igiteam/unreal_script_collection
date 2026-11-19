class UTPowerupPickupFactory extends EvilPickupFactory
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force,Display,Collision,PickupFactory);

simulated function AddWeaponOverlay(UTGameReplicationInfo GRI)
{
    local class<UTInventory> UTInvClass;

    UTInvClass = class<UTInventory>(InventoryType);
    // End:0x53
    if(UTInvClass != none)
    {
        UTInvClass.static.AddWeaponOverlay(GRI);
    }
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    // End:0x74
    if(EvilPlayerReplicationInfo(Recipient.PlayerReplicationInfo) != none)
    {
        EvilPlayerReplicationInfo(Recipient.PlayerReplicationInfo).IncrementPickupStat(GetPickupStatName());
    }
    Recipient.MakeNoise(0.5000000);
    super(PickupFactory).SpawnCopyFor(Recipient);
    //return;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__UTPowerupPickupFactory.PickupLightEnvironment'
    begin object name=PickupLightEnvironment
    end object
    LightEnvironment=PickupLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__UTPowerupPickupFactory.ForceFeedbackWaveformPickUp'
    begin object name=ForceFeedbackWaveformPickUp
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    bRotatingPickup=true
    // Reference: StaticMeshComponent'Default__UTPowerupPickupFactory.BaseMeshComp'
    begin object name=BaseMeshComp
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__UTPowerupPickupFactory.PickupLightEnvironment'
    end object
    BaseMesh=BaseMeshComp
    bIsSuperItem=true
    // Reference: CylinderComponent'Default__UTPowerupPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=PickupLightEnvironment
    Components[3]=BaseMeshComp
    bMovable=true
    CollisionComponent=CollisionCylinder
}