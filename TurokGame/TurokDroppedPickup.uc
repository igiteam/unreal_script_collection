class TurokDroppedPickup extends DroppedPickup
    native
    hidecategories(Navigation);

var protected export editinline @NULL mCylinderCollision;
var(Sound) float mCollisionVelocityMinVol;
var(Sound) float mCollisionVelocityMaxVol;
var private export editinline @NULL mSoundController;
var private @NULL mBodyFallSndCue;
var private export editinline @NULL mStaticPickupMesh;

// Export UTurokDroppedPickup::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

// Export UTurokDroppedPickup::execInitDroppingState(FFrame&, void* const)
protected native function InitDroppingState(@NULL PickupMesh);

// Export UTurokDroppedPickup::execInitPickupState(FFrame&, void* const)
protected native function InitPickupState();

event PostSaveGameRestore()
{
    // DebugMode: 0
    assert(InventoryClass != none);
    // DebugMode: 0
    assert(Inventory != none);
    SetPickupMesh(InventoryClass.default.DroppedPickupMesh);
    GoToPickupState();
    //return;    
}

simulated event SetPickupMesh(@NULL PickupMesh)
{
    // DebugMode: 0
    assert(PickupMesh != none);
    mStaticPickupMesh = StaticMeshComponent(PickupMesh.Clone(self));
    mStaticPickupMesh.SetLightEnvironment(LightEnvironment);
    mStaticPickupMesh.ScriptRigidBodyCollisionThreshold = 10.0000000;
    mStaticPickupMesh.SetNotifyRigidBodyCollision(true);
    // DebugMode: 0
    assert(mStaticPickupMesh != none);
    AttachComponent(mStaticPickupMesh);
    InitDroppingState(mStaticPickupMesh);
    //return;    
}

simulated event Destroyed()
{
    ClearTimer('RigidBodyPhysTimer');
    super.Destroyed();
    //return;    
}

simulated event FellOutOfWorld(class<Class> dmgType)
{
    super(Actor).FellOutOfWorld(dmgType);
    //return;    
}

simulated event Landed(@NULL HitNormal, @NULL FloorActor)
{
    SetTimer(0.1000000, false, 'RigidBodyPhysTimer');
    SetPhysics(10);
    InitDroppingState(mStaticPickupMesh);
    bCollideWorld = true;
    //return;    
}

simulated function RigidBodyPhysTimer()
{
    GoToPickupState();
    bCollideWorld = false;
    //return;    
}

simulated event GoToPickupState()
{
    mCylinderCollision.SetSize(20.0000000, 66.0000000);
    InitPickupState();
    GotoState('Pickup');
    //return;    
}

function GiveTo(@NULL P)
{
    local @NULL invMan, TPC, turokWeap;
    local bool shouldPickup;

    // DebugMode: 0
    assert(Inventory != none);
    shouldPickup = false;
    invMan = TurokInventoryManager(P.InvManager);
    // End:0x12C
    if(invMan != none)
    {
        turokWeap = TurokWeapon(Inventory);
        // End:0xEA
        if(turokWeap != none)
        {
            // End:0x8B
            if(invMan.ShouldPickupWeaponAmmo(class<TurokWeapon>(InventoryClass)))
            {
                turokWeap.GiveWeaponAmmo(invMan);
            }
            // End:0xE7
            if(invMan.ShouldPickupWeapon(class<TurokWeapon>(InventoryClass)))
            {
                shouldPickup = true;
                TPC = TurokPlayerController(P.Controller);
                // End:0xE7
                if(TPC != none)
                {
                    TPC.mPickupMiniGunSentry = none;
                }
            }            
        }
        else
        {
            // End:0x114
            if(invMan.FindInventoryType(InventoryClass) == none)
            {
                shouldPickup = true;                
            }
            else
            {
                // End:0x12C
                if(class<TurokGrenadeInventoryItem>(InventoryClass) != none)
                {
                    shouldPickup = true;
                }
            }
        }
    }
    // End:0x19E
    if(shouldPickup)
    {
        Inventory.SetTickGroup(Inventory.default.TickGroup);
        Inventory.super(Inventory).GiveTo(P);
        Inventory.AnnouncePickup(P, self.Class);
        Inventory = none;
        PickedUpBy(P);
    }
    //return;    
}

simulated event RigidBodyCollision(@NULL pHitComponent, @NULL pOtherComponent, const out array pContactInfos, int ContactIndex)
{
    local float velMag;
    local @NULL relVel, velocity0, velocity1;
    local float Volume;

    super(Actor).RigidBodyCollision(pHitComponent, pOtherComponent, pContactInfos, ContactIndex);
    velocity1 = pContactInfos[0].ContactVelocity[1];
    velocity0 = pContactInfos[0].ContactVelocity[0];
    relVel = velocity1 - velocity0;
    velMag = VSize(relVel);
    Volume = FClamp(velMag - mCollisionVelocityMinVol, 0.0000000, mCollisionVelocityMaxVol - mCollisionVelocityMinVol) / (mCollisionVelocityMaxVol - mCollisionVelocityMinVol);
    // End:0xB6
    if((pHitComponent != none) && pOtherComponent != none)
    {
    }
    // End:0x10E
    if(Volume > float(0))
    {
        mSoundController.AddLimitedSound('BodyFall', 0.5000000);
        mSoundController.TryPlayLimitedSound('BodyFall', mBodyFallSndCue, Location,,,, Volume);
    }
    //return;    
}

auto state DropWait
{
    function bool ValidTouch(@NULL Other)
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state Pickup
{
    function BeginState(name PreviousStateName)
    {
        local @NULL MPGame, W;

        MPGame = TurokMPGame(WorldInfo.Game);
        // End:0x66
        if(MPGame != none)
        {
            LifeSpan = MPGame.GetInventoryRespawnTime(Inventory.Class);
            LifeSpan = float(Max(int(1.1000000), int(LifeSpan)));            
        }
        else
        {
            bDistanceStasis = true;
            W = TurokWeapon(Inventory);
            // End:0xFE
            if(W != none)
            {
                // End:0xFE
                if((((int(W.mWeaponType) == int(9)) || int(W.mWeaponType) == int(3)) || int(W.mWeaponType) == int(17)) || int(W.mWeaponType) == int(12))
                {
                    LifeSpan = 0.0000000;
                }
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        local @NULL P;

        // End:0x20
        foreach TouchingActors(Class'TurokPawnPlayer', P)
        {
            UnTouch(P);            
        }        
        //return;        
    }

    function bool ValidTouch(@NULL Other)
    {
        // End:0x85
        if((((((Other == none) || !Other.bCanPickupInventory) || Other.Controller == none) || Other.DrivenVehicle != none) || Other.IsInState('CannedAnimation')) || Other.IsInState('CinematicState'))
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
    {
        local @NULL P, invMan, Weapon;
        local bool pickupOK;

        P = Pawn(Other);
        // End:0x25F
        if((P != none) && ValidTouch(P))
        {
            invMan = TurokInventoryManager(P.InvManager);
            // End:0x1AE
            if((class<TurokWeapon>(InventoryClass) != none) && invMan.ShouldPickupWeaponAmmo(class<TurokWeapon>(InventoryClass)))
            {
                Weapon = TurokWeapon(Inventory);
                // End:0x11C
                if(Weapon.default.mAmmoPoolClass != none)
                {
                    Weapon.mAmmoPoolPickupCount -= invMan.AddAmmoToPool(Weapon.mAmmoPoolClass, Weapon.mAmmoPoolPickupCount);
                    Weapon.mCurrentClipAmmo -= invMan.AddAmmoToPool(Weapon.mAmmoPoolClass, Weapon.mCurrentClipAmmo);
                }
                // End:0x1AE
                if(Weapon.default.mAltAmmoClass != none)
                {
                    Weapon.mAltAmmoPoolPickupCount -= invMan.AddAmmoToPool(Weapon.mAltAmmoClass, Weapon.mAltAmmoPoolPickupCount);
                    Weapon.mCurrentClipAltAmmo -= invMan.AddAmmoToPool(Weapon.mAltAmmoClass, Weapon.mCurrentClipAltAmmo);
                }
            }
            invMan.ResetPickedUpAmmoOnly();
            pickupOK = WorldInfo.Game.PickupQuery(P, InventoryClass, self);
            // End:0x207
            if(pickupOK)
            {
                GiveTo(P);
            }
            // End:0x25F
            if((pickupOK == false) || invMan.PickedUpAmmoOnly())
            {
                // End:0x25F
                if(invMan.ShouldPromptToDropItem(InventoryClass))
                {
                    invMan.StartPromptToDropItem(self, InventoryClass);
                }
            }
        }
        //return;        
    }

    event UnTouch(@NULL Other)
    {
        local @NULL Player, invMan;

        Player = TurokPawnPlayer(Other);
        // End:0x53
        if(Player != none)
        {
            invMan = TurokInventoryManager(Player.InvManager);
            // End:0x53
            if(invMan != none)
            {
                invMan.EndPromptToDropItem(self);
            }
        }
        //return;        
    }
    stop;    
}

state FadeOut
{
    function bool ValidTouch(@NULL Other)
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__TurokDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=4.0000000
        CollisionRadius=4.0000000
    end object
    mCylinderCollision=CollisionCylinder
    mCollisionVelocityMinVol=25.0000000
    mCollisionVelocityMaxVol=300.0000000
    // Reference: TurokSoundController'Default__TurokDroppedPickup.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent class=Class'TurokSoundController'
        mLimitedSounds=/* Array type was not detected. */
    end object
    mSoundController=TurokSoundControllerComponent
    mBodyFallSndCue=SoundCue'SndWeapGunHandling.GunDrop'
    // Reference: DynamicLightEnvironmentComponent'Default__TurokDroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    bUpdateSimulatedPosition=true
    bNetInitialRotation=true
    bReplicateRigidBodyLocation=true
    bNoEncroachCheck=true
    bRenderStasis=true
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=TurokSoundControllerComponent
    Physics=2
    NetUpdateFrequency=5.0000000
    LifeSpan=180.0000000
    DrawScale=1.2000000
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=0,Yaw=0,Roll=0)
    DesiredRotation=(Pitch=0,Yaw=0,Roll=0)
}