class UTRotatingDroppedPickup extends UTDroppedPickup
    hidecategories(Navigation);

var() float YawRotationRate;

simulated event Tick(float DeltaTime)
{
    local Rotator NewRotation;

    // End:0x186
    if(((PickupMesh != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && (WorldInfo.TimeSeconds - LastRenderTime) < 0.2000000)
    {
        NewRotation = PickupMesh.Rotation;
        NewRotation.Yaw += int(DeltaTime * YawRotationRate);
        PickupMesh.SetRotation(NewRotation);
        // End:0x186
        if(PickupParticles != none)
        {
            NewRotation = PickupParticles.Rotation;
            NewRotation.Yaw += int(DeltaTime * YawRotationRate);
            PickupParticles.SetRotation(NewRotation);
        }
    }
    //return;    
}

defaultproperties
{
    YawRotationRate=32768.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__UTRotatingDroppedPickup.DroppedPickupLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'DroppedPickupLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__UTDroppedPickup.DroppedPickupLightEnvironment'
    begin object name="DroppedPickupLightEnvironment"
    end object
    MyLightEnvironment=DroppedPickupLightEnvironment
    Components[0]=none
    // Reference: CylinderComponent'Default__UTRotatingDroppedPickup.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__UTDroppedPickup.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    Components[1]=CollisionCylinder
    Components[2]=DroppedPickupLightEnvironment
    CollisionComponent=CollisionCylinder
}