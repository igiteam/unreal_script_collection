class TurokMPWeaponPickupNative extends TurokMPPickupFactory
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer,Multiplayer);

struct native WeaponOffset
{
    var() byte WeaponType;
    var() @NULL Translation;
    var() @NULL Rotation;

    structdefaultproperties
    {
        WeaponType=0
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

var(Multiplayer) protected const int mSpawnRating;
var(Multiplayer) protected duplicatetransient const transient array mWeaponOffsets;
var(Multiplayer) protected const export editinline @NULL mWeaponRackMesh;

simulated function InitializePickup()
{
    local @NULL GI;
    local class<Class> WeapPickupClass;

    // End:0x72
    if(int(Role) == int(ROLE_Authority))
    {
        GI = TurokMPGame(WorldInfo.Game);
        // End:0x6A
        if((GI != none) && GI.GetWeaponPickupClass(WeapPickupClass, mSpawnRating))
        {
            InventoryType = WeapPickupClass;
            super(PickupFactory).InitializePickup();            
        }
        else
        {
            mEnabled = false;
        }
    }
    //return;    
}

simulated function SetPickupMesh()
{
    local int I;

    super(PickupFactory).SetPickupMesh();
    // End:0xC7
    if(PickupMesh != none)
    {
        PickupMesh.SetTickGroup(3);
        I = 0;
        J0x29:

        // End:0xC7 [Loop If]
        if(I < mWeaponOffsets.Length)
        {
            // End:0xBD
            if(int(mWeaponOffsets[I].WeaponType) == int(class<TurokWeapon>(InventoryType).default.mWeaponType))
            {
                PickupMesh.SetTranslation(mWeaponOffsets[I].Translation);
                PickupMesh.SetRotation(mWeaponOffsets[I].Rotation);
                // [Explicit Break]
                goto J0xC7;
            }
            ++I;
            // [Loop Continue]
            goto J0x29;
        }
    }
    J0xC7:

    //return;    
}

function SetRespawn()
{
    //return;    
}

function SpawnCopyFor(@NULL Recipient)
{
    local @NULL mgr, Weapon;
    local class<Class> AmmoPool;

    mgr = TurokInventoryManager(Recipient.InvManager);
    // End:0x171
    if(mgr.ShouldPickupWeapon(class<TurokWeapon>(InventoryType)))
    {
        Weapon = TurokWeapon(__NFUN_278__(InventoryType));
        // End:0x16E
        if(Weapon != none)
        {
            AmmoPool = class<TurokWeapon>(InventoryType).default.mAmmoPoolClass;
            // End:0xC0
            if(AmmoPool != none)
            {
                Weapon.mAmmoPoolPickupCount = AmmoPool.default.mAmmoMaximum;
                Weapon.mCurrentClipAmmo = class<TurokWeapon>(InventoryType).default.mMaxClipAmmo;
            }
            AmmoPool = class<TurokWeapon>(InventoryType).default.mAltAmmoClass;
            // End:0x123
            if(AmmoPool != none)
            {
                Weapon.mAltAmmoPoolPickupCount = AmmoPool.default.mAmmoMaximum;
                Weapon.mCurrentClipAltAmmo = class<TurokWeapon>(InventoryType).default.mMaxClipAltAmmo;
            }
            Weapon.SetMPPickupFactory(self);
            Weapon.GiveTo(Recipient);
            Weapon.AnnouncePickup(Recipient);
            DisablePickup();
        }        
    }
    else
    {
        // End:0x225
        if(mgr.ShouldPickupWeaponAmmo(class<TurokWeapon>(InventoryType)))
        {
            AmmoPool = class<TurokWeapon>(InventoryType).default.mAltAmmoClass;
            // End:0x1DB
            if(AmmoPool != none)
            {
                mgr.AddAmmoToPool(AmmoPool, AmmoPool.default.mAmmoMaximum);
            }
            AmmoPool = class<TurokWeapon>(InventoryType).default.mAmmoPoolClass;
            // End:0x225
            if(AmmoPool != none)
            {
                mgr.AddAmmoToPool(AmmoPool, AmmoPool.default.mAmmoMaximum);
            }
        }
    }
    //return;    
}

defaultproperties
{
    mSpawnRating=1
    // Reference: StaticMeshComponent'Default__TurokMPWeaponPickupNative.WeaponRackMeshComponent'
    begin object name=WeaponRackMeshComponent class=Class'Engine.StaticMeshComponent'
        DisableRigidBodySupport=true
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        LightingChannels=(bInitialized=true,Static=true)
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        TickGroup=3
    end object
    mWeaponRackMesh=WeaponRackMeshComponent
    // Reference: TurokMPGameModeRestriction'Default__TurokMPWeaponPickupNative.GameModeRestriction0'
    begin object name=GameModeRestriction0
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPWeaponPickupNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__TurokMPWeaponPickupNative.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=40.0000000
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPWeaponPickupNative.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPWeaponPickupNative.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPWeaponPickupNative.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPWeaponPickupNative.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[3]=PathRenderer
    Components[4]=MyLightEnvironment
    Components[5]=WeaponRackMeshComponent
    CollisionComponent=CollisionCylinder
    mSnapOffset=(X=0.0000000,Y=0.0000000,Z=-20.0000000)
}