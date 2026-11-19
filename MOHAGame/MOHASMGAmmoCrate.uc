class MOHASMGAmmoCrate extends MOHASMGAmmoPickup
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    bPersistent=true
    // Reference: CylinderComponent'Default__MOHASMGAmmoCrate.ExtraCollision'
    begin object name=ExtraCollision
    end object
    TriggerCollision=ExtraCollision
    // Reference: DynamicLightEnvironmentComponent'Default__MOHASMGAmmoCrate.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__MOHASMGAmmoCrate.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHASMGAmmoCrate.MyLightEnvironment'
    end object
    PickupMesh=MeshComponentA
    // Reference: CylinderComponent'Default__MOHASMGAmmoCrate.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHASMGAmmoCrate.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHASMGAmmoCrate.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHASMGAmmoCrate.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHASMGAmmoCrate.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    Components[6]=ExtraCollision
    Components[7]=MeshComponentA
    bBlockActors=true
    CollisionComponent=CollisionCylinder
}