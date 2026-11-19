class MOHAItemPickupFactory extends PickupFactory
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force);

var const localized string PickupMessage;
var() float RespawnTime;
var bool bPersistent;
var export editinline CylinderComponent TriggerCollision;
var export editinline DynamicLightEnvironmentComponent LightEnvComponent;

static simulated function UpdateHUD(MOHAHUD H)
{
    //return;    
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return default.PickupMessage;
    //return ReturnValue;    
}

function SpawnCopyFor(Pawn Recipient)
{
    // End:0x99
    if(PlayerController(Recipient.Controller) != none)
    {
        PlayerController(Recipient.Controller).ReceiveLocalizedMessage(MessageClass,,,, Class);
        // End:0x99
        if(MOHAHUD(PlayerController(Recipient.Controller).myHUD) != none)
        {
            UpdateHUD(MOHAHUD(PlayerController(Recipient.Controller).myHUD));
        }
    }
    //return;    
}

function SetRespawn()
{
    // End:0x57
    if(!bPersistent)
    {
        // End:0x49
        if((RespawnTime >= 0.0000000) && WorldInfo.Game.ShouldRespawn(self))
        {
            StartSleeping();            
        }
        else
        {
            GotoState('Disabled');
        }
    }
    //return;    
}

function float GetRespawnTime()
{
    return RespawnTime;
    //return ReturnValue;    
}

simulated function SetPickupMesh()
{
    super.SetPickupMesh();
    PickupMesh.SetLightEnvironment(self.LightEnvComponent);
    //return;    
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        // End:0x4F
        if(((Other == none) || !Other.bCanPickupInventory) || (Other.DrivenVehicle == none) && Other.Controller == none)
        {
            return false;
        }
        // End:0x8D
        if((PickupMesh == none) || !FastTrace(Other.Location, PickupMesh.Bounds.Origin))
        {
            return false;
        }
        // End:0xB9
        if(WorldInfo.Game.PickupQuery(Other, InventoryType, self))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;

        P = Pawn(Other);
        // End:0x55
        if((P != none) && ValidTouch(P))
        {
            GiveTo(P);
            // End:0x55
            if(bPersistent)
            {
                GotoState('Touched');
            }
        }
        //return;        
    }

    function CheckTouching()
    {
        local Pawn P;

        // End:0x49
        if(!bPersistent)
        {
            // End:0x48
            foreach TouchingActors(Class'Engine.Pawn', P)
            {
                Touch(P, none, Location, Normal(Location - P.Location));                
            }            
        }
        //return;        
    }
    stop;    
}

state Touched
{
    event UnTouch(Actor Other)
    {
        super(Actor).UnTouch(Other);
        GotoState('ResetTouched');
        //return;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;

        super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
        P = Pawn(Other);
        // End:0x43
        if(P != none)
        {
            GotoState('ResetTouched');
        }
        //return;        
    }
Begin:

    Sleep(1.0000000);
    GotoState('Pickup');
    stop;        
}

state ResetTouched
{Begin:

    GotoState('Touched');
    stop;        
}

defaultproperties
{
    RespawnTime=-1.0000000
    // Reference: CylinderComponent'Default__MOHAItemPickupFactory.ExtraCollision'
    begin object name=ExtraCollision class=Class'Engine.CylinderComponent'
        CollisionHeight=80.0000000
        CollisionRadius=40.0000000
        CollideActors=true
    end object
    TriggerCollision=ExtraCollision
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAItemPickupFactory.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvComponent=MyLightEnvironment
    InventoryType=Class'Engine.Inventory'
    bNotBased=true
    // Reference: CylinderComponent'Default__MOHAItemPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=1.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAItemPickupFactory.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAItemPickupFactory.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAItemPickupFactory.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAItemPickupFactory.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    Components[6]=ExtraCollision
    CollisionComponent=CollisionCylinder
}