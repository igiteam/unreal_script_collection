class MOHAMKIIFragGrenadePickup extends MOHAAmmoPickupFactory
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    AmmoAmount=5
    AmmoClass=Class'MOHAMKIIFragGrenadeAmmoClass'
    // Reference: CylinderComponent'Default__MOHAMKIIFragGrenadePickup.ExtraCollision'
    begin object name=ExtraCollision
    end object
    TriggerCollision=ExtraCollision
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAMKIIFragGrenadePickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__MOHAMKIIFragGrenadePickup.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAMKIIFragGrenadePickup.MyLightEnvironment'
    end object
    PickupMesh=MeshComponentA
    // Reference: CylinderComponent'Default__MOHAMKIIFragGrenadePickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAMKIIFragGrenadePickup.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAMKIIFragGrenadePickup.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAMKIIFragGrenadePickup.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAMKIIFragGrenadePickup.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    Components[6]=ExtraCollision
    Components[7]=MeshComponentA
    CollisionComponent=CollisionCylinder
    CollisionType=0
}