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
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilPickupFactory.PickupLightEnvironment'
    begin object name="PickupLightEnvironment"
    end object
    LightEnvironment=PickupLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__UTPowerupPickupFactory.ForceFeedbackWaveformPickUp'
    // Archetype: ForceFeedbackWaveform'Default__EvilPickupFactory.ForceFeedbackWaveformPickUp'
    begin object name="ForceFeedbackWaveformPickUp"
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    bRotatingPickup=true
    // Reference: StaticMeshComponent'Default__UTPowerupPickupFactory.BaseMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BaseMeshComp'
    // Archetype: StaticMeshComponent'Default__EvilPickupFactory.BaseMeshComp'
    begin object name="BaseMeshComp"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__UTPowerupPickupFactory.PickupLightEnvironment'
    end object
    BaseMesh=BaseMeshComp
    bIsSuperItem=true
    // Reference: CylinderComponent'Default__UTPowerupPickupFactory.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilPickupFactory.CollisionCylinder'
    begin object name="CollisionCylinder"
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