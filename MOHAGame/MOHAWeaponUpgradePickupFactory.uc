class MOHAWeaponUpgradePickupFactory extends MOHAItemPickupFactory
    hidecategories(Navigation,Lighting,LightColor,Force);

var() MOHAIncludeClass.EWeaponType WeaponType;

simulated function InitializePickup()
{
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    super.SpawnCopyFor(Recipient);
    //return;    
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        local MOHAPlayerPawn myMohaPawn;

        // End:0x12
        if(!super.ValidTouch(Other))
        {
            return false;
        }
        myMohaPawn = MOHAPlayerPawn(Other);
        // End:0x51
        if(myMohaPawn != none)
        {
            MOHAPlayerController(myMohaPawn.Controller).NotifyPickup(1);
        }
        return false;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__MOHAWeaponUpgradePickupFactory.ExtraCollision'
    begin object name=ExtraCollision
    end object
    TriggerCollision=ExtraCollision
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAWeaponUpgradePickupFactory.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__MOHAWeaponUpgradePickupFactory.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.Weapon_Supply_Crate'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAWeaponUpgradePickupFactory.MyLightEnvironment'
        CastShadow=true
    end object
    PickupMesh=MeshComponentA
    // Reference: CylinderComponent'Default__MOHAWeaponUpgradePickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAWeaponUpgradePickupFactory.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAWeaponUpgradePickupFactory.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAWeaponUpgradePickupFactory.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAWeaponUpgradePickupFactory.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    Components[6]=ExtraCollision
    Components[7]=MeshComponentA
    CollisionComponent=CollisionCylinder
    CollisionType=0
}