class MOHAStickGrenadePickup extends MOHAAmmoPickupFactory
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    AmmoAmount=5
    AmmoClass=Class'MOHAStickGrenadeAmmoClass'
    // Reference: CylinderComponent'Default__MOHAStickGrenadePickup.ExtraCollision'
    begin object name=ExtraCollision
    end object
    TriggerCollision=ExtraCollision
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAStickGrenadePickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__MOHAStickGrenadePickup.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAStickGrenadePickup.MyLightEnvironment'
    end object
    PickupMesh=MeshComponentA
    // Reference: CylinderComponent'Default__MOHAStickGrenadePickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAStickGrenadePickup.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAStickGrenadePickup.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAStickGrenadePickup.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAStickGrenadePickup.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    Components[6]=ExtraCollision
    Components[7]=MeshComponentA
    CollisionComponent=CollisionCylinder
    CollisionType=0
}