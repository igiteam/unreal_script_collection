class FHAmmo_SprayPaintCan extends UTAmmo_LinkGun;


// Decompiled with UE Explorer.
defaultproperties
{
    TargetWeapon=Class'FHWeap_SprayPaintCan'
    PickupSound=SoundCue'SprayCanPackage.SprayCanCue'
    RespawnTime=1000000000.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__FHAmmo_SprayPaintCan.PickupLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTAmmo_LinkGun.PickupLightEnvironment'
    begin object name="PickupLightEnvironment"
    end object
    LightEnvironment=PickupLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__FHAmmo_SprayPaintCan.ForceFeedbackWaveformPickUp'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTAmmo_LinkGun.ForceFeedbackWaveformPickUp'
    begin object name="ForceFeedbackWaveformPickUp"
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    // Reference: StaticMeshComponent'Default__FHAmmo_SprayPaintCan.BaseMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BaseMeshComp'
    // Archetype: StaticMeshComponent'UTGame.Default__UTAmmo_LinkGun.BaseMeshComp'
    begin object name="BaseMeshComp"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__FHAmmo_SprayPaintCan.PickupLightEnvironment'
    end object
    BaseMesh=BaseMeshComp
    // Reference: StaticMeshComponent'Default__FHAmmo_SprayPaintCan.AmmoMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'AmmoMeshComp'
    // Archetype: StaticMeshComponent'UTGame.Default__UTAmmo_LinkGun.AmmoMeshComp'
    begin object name="AmmoMeshComp"
        StaticMesh=StaticMesh'SprayCanPackage.SprayCanStaticMesh'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__FHAmmo_SprayPaintCan.PickupLightEnvironment'
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    end object
    PickupMesh=AmmoMeshComp
    // Reference: CylinderComponent'Default__FHAmmo_SprayPaintCan.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UTGame.Default__UTAmmo_LinkGun.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionRadius=50.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__FHAmmo_SprayPaintCan.PathRenderer'
    // Archetype: PathRenderingComponent'UTGame.Default__UTAmmo_LinkGun.PathRenderer'
    begin object name="PathRenderer"
        ReplacementPrimitive=none
    end object
    Components[1]=PathRenderer
    Components[2]=PickupLightEnvironment
    Components[3]=BaseMeshComp
    Components[4]=AmmoMeshComp
    CollisionComponent=CollisionCylinder
}