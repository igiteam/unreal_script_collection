class TurokMPObjectiveItemPickup extends TurokMPPickupFactory
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

var(Multiplayer) protected duplicatetransient const transient @NULL mPickupTranslation;
var(Multiplayer) protected duplicatetransient const transient @NULL mPickupRotation;

function SpawnCopyFor(@NULL pwn)
{
    local @NULL Item;

    Item = TurokMPObjectiveItem(__NFUN_278__(InventoryType));
    // End:0x65
    if(Item != none)
    {
        Item.SetMPPickupFactory(self);
        Item.GiveTo(pwn);
        Item.AnnouncePickup(pwn);
    }
    //return;    
}

simulated function SetPickupMesh()
{
    super(PickupFactory).SetPickupMesh();
    // End:0x52
    if(PickupMesh != none)
    {
        PickupMesh.SetTickGroup(3);
        PickupMesh.SetTranslation(mPickupTranslation);
        PickupMesh.SetRotation(mPickupRotation);
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPObjectiveItemPickup.GameModeRestriction0'
    begin object name=GameModeRestriction0
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPObjectiveItemPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__TurokMPObjectiveItemPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPObjectiveItemPickup.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPObjectiveItemPickup.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPObjectiveItemPickup.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPObjectiveItemPickup.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    CollisionComponent=CollisionCylinder
}