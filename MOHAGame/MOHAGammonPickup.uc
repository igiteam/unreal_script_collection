class MOHAGammonPickup extends MOHAAmmoPickupFactory
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    AmmoAmount=5
    AmmoClass=Class'MOHAGammonGrenadeAmmoClass'
    // Reference: CylinderComponent'Default__MOHAGammonPickup.ExtraCollision'
    begin object name=ExtraCollision
    end object
    TriggerCollision=ExtraCollision
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAGammonPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__MOHAGammonPickup.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAGammonPickup.MyLightEnvironment'
    end object
    PickupMesh=MeshComponentA
    // Reference: CylinderComponent'Default__MOHAGammonPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAGammonPickup.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAGammonPickup.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAGammonPickup.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAGammonPickup.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    Components[6]=ExtraCollision
    Components[7]=MeshComponentA
    CollisionComponent=CollisionCylinder
    CollisionType=0
}