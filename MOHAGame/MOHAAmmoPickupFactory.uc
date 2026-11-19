class MOHAAmmoPickupFactory extends MOHAItemPickupFactory
    hidecategories(Navigation,Lighting,LightColor,Force);

var() int AmmoAmount;
var() class<EALAAmmoInventoryClass> AmmoClass;

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2A
    if(VarName == 'AmmoClassClass')
    {
        AmmoClassChanged();
        SetPickupMesh();        
    }
    else
    {
        super(PickupFactory).ReplicatedEvent(VarName);
    }
    //return;    
}

static simulated function UpdateHUD(MOHAHUD H)
{
    super.UpdateHUD(H);
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    // End:0x45
    if(MOHAInventoryManager(Recipient.InvManager) != none)
    {
        MOHAInventoryManager(Recipient.InvManager).AddReserveAmmo(AmmoClass, AmmoAmount);
    }
    super.SpawnCopyFor(Recipient);
    //return;    
}

simulated function SetPickupMesh()
{
    StaticMeshComponent(PickupMesh).SetStaticMesh(StaticMeshComponent(AmmoClass.default.DroppedPickupMesh).StaticMesh);
    //return;    
}

function PickedUpBy(Pawn P)
{
    local MOHAPlayerPawn PlayerPawn;

    PlayerPawn = MOHAPlayerPawn(P);
    // End:0x43
    if(PlayerPawn != none)
    {
        MOHAPlayerController(PlayerPawn.Controller).NotifyPickupAmmoClass(0, AmmoClass);
    }
    super(PickupFactory).PickedUpBy(P);
    //return;    
}

simulated function AmmoClassChanged()
{
    InventoryType = AmmoClass;
    //return;    
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        // End:0x12
        if(!super.ValidTouch(Other))
        {
            return false;
        }
        // End:0x52
        if(MOHAInventoryManager(Other.InvManager) != none)
        {
            return MOHAInventoryManager(Other.InvManager).NeedsAmmo(AmmoClass);
        }
        return true;
        //return ReturnValue;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;

        P = Pawn(Other);
        // End:0xB8
        if((((P != none) && P.Controller != none) && P.Controller.IsA('PlayerController')) && !ValidTouch(P))
        {
            // End:0xB8
            if(MOHAHUD(PlayerController(P.Controller).myHUD) != none)
            {
                MOHAPlayerController(P.Controller).NotifyPickupFailureAmmoClass(0, AmmoClass);
            }
        }
        super.Touch(Other, OtherComp, HitLocation, HitNormal);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__MOHAAmmoPickupFactory.ExtraCollision'
    begin object name=ExtraCollision
    end object
    TriggerCollision=ExtraCollision
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAAmmoPickupFactory.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__MOHAAmmoPickupFactory.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.Ammo_PickUp'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAAmmoPickupFactory.MyLightEnvironment'
        CastShadow=true
    end object
    PickupMesh=MeshComponentA
    // Reference: CylinderComponent'Default__MOHAAmmoPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAAmmoPickupFactory.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAAmmoPickupFactory.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAAmmoPickupFactory.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAAmmoPickupFactory.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    Components[6]=ExtraCollision
    Components[7]=MeshComponentA
    CollisionComponent=CollisionCylinder
    CollisionType=7
}