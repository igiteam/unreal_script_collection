class TurokMPAmmoCrateNative extends TurokMPPickupFactory
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer,Multiplayer);

var(Pickup) @NULL PickupSound;

simulated event SetInitialState()
{
    EnablePickup();
    SetPickupVisible();
    //return;    
}

state Pickup
{
    event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
    {
        local @NULL MPGame, TP, TPInv, W;
        local class<Class> ammoPoolClass, grenadeClass;
        local int grenadeCount, I;

        MPGame = TurokMPGame(WorldInfo.Game);
        // End:0x26
        if(MPGame == none)
        {
            return;
        }
        TP = TurokPawnPlayer(Other);
        // End:0x1F9
        if(TP != none)
        {
            TPInv = TurokInventoryManager(TP.InvManager);
            // End:0x67
            if(TPInv == none)
            {
                return;
            }
            // End:0x139
            foreach TPInv.InventoryActors(Class'TurokWeapon', W)
            {
                ammoPoolClass = W.GetAmmoPoolClass();
                // End:0xEE
                if(ammoPoolClass != none)
                {
                    W.AddAmmo(ammoPoolClass.default.mAmmoMaximum);
                    TPInv.AddAmmoToPool(ammoPoolClass, ammoPoolClass.default.mAmmoMaximum);
                }
                ammoPoolClass = W.GetAltAmmoPoolClass();
                // End:0x138
                if(ammoPoolClass != none)
                {
                    TPInv.AddAmmoToPool(ammoPoolClass, ammoPoolClass.default.mAmmoMaximum);
                }                
            }            
            // End:0x1E1
            if(MPGame.AllowGrenades)
            {
                grenadeClass = MPGame.GetGrenadeType();
                // DebugMode: 0
                assert(grenadeClass != none);
                grenadeCount = TPInv.GetInventoryCount(grenadeClass);
                I = 0;
                J0x196:

                // End:0x1E1 [Loop If]
                if(I < (MPGame.NumStartingGrenades - grenadeCount))
                {
                    TP.InvManager.CreateInventory(grenadeClass, true);
                    ++I;
                    // [Loop Continue]
                    goto J0x196;
                }
            }
            TP.PlaySound(PickupSound);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPAmmoCrateNative.GameModeRestriction0'
    begin object name=GameModeRestriction0
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: StaticMeshComponent'Default__TurokMPAmmoCrateNative.AmmoCrateMesh'
    begin object name=AmmoCrateMesh class=Class'Engine.StaticMeshComponent'
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        LightingChannels=(bInitialized=true,Static=true)
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
    end object
    PickupMesh=AmmoCrateMesh
    LightEnvironment=none
    // Reference: CylinderComponent'Default__TurokMPAmmoCrateNative.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=40.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPAmmoCrateNative.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPAmmoCrateNative.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bStatic=true
    bBlockActors=true
    Components[0]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPAmmoCrateNative.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPAmmoCrateNative.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[3]=PathRenderer
    Components[4]=AmmoCrateMesh
    RemoteRole=0
    CollisionComponent=CollisionCylinder
}