class MOHAHealthPickupFactory extends MOHAItemPickupFactory
    hidecategories(Navigation,Lighting,LightColor,Force);

simulated function InitializePickup()
{
    //return;    
}

static simulated function UpdateHUD(MOHAHUD H)
{
    super.UpdateHUD(H);
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    local float fHealAmount;

    fHealAmount = float(HealAmount(Recipient));
    Recipient.SetHealth(int(float(Recipient.Health) + fHealAmount));
    // End:0x79
    if(MOHAPlayerPawn(Recipient) != none)
    {
        MOHAPlayerPawn(Recipient).HealthManager.GotHealth(fHealAmount);
    }
    // End:0xB6
    if(MOHAPlayerController(Recipient.Controller) != none)
    {
        MOHAPlayerController(Recipient.Controller).NotifyPickup(2);
    }
    super.SpawnCopyFor(Recipient);
    //return;    
}

function int HealAmount(Pawn Recipient)
{
    local int iHealAmount, iSegmentSize;

    // End:0x92
    if(MOHAPlayerPawn(Recipient) != none)
    {
        iSegmentSize = MOHAPlayerPawn(Recipient).HealthManager.SegmentSize;
        // End:0x61
        if((float(Recipient.Health) % float(iSegmentSize)) == float(0))
        {
            iHealAmount = iSegmentSize;            
        }
        else
        {
            iHealAmount = int(float(2 * iSegmentSize) - (float(Recipient.Health) % float(iSegmentSize)));
        }        
    }
    else
    {
        iHealAmount = 0;
    }
    return Clamp(Recipient.default.Health - Recipient.Health, 0, iHealAmount);
    //return ReturnValue;    
}

function bool ShouldHeal(Pawn Other)
{
    return (HealAmount(Other)) > 0;
    //return ReturnValue;    
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
        return ShouldHeal(Other);
        //return ReturnValue;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;

        P = Pawn(Other);
        // End:0xB4
        if((((P != none) && P.Controller != none) && P.Controller.IsA('PlayerController')) && !ValidTouch(P))
        {
            // End:0xB4
            if(MOHAHUD(PlayerController(P.Controller).myHUD) != none)
            {
                MOHAPlayerController(P.Controller).NotifyPickupFailure(2);
            }
        }
        super.Touch(Other, OtherComp, HitLocation, HitNormal);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__MOHAHealthPickupFactory.ExtraCollision'
    begin object name=ExtraCollision
    end object
    TriggerCollision=ExtraCollision
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAHealthPickupFactory.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__MOHAHealthPickupFactory.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.Pickup_Health_Generic'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAHealthPickupFactory.MyLightEnvironment'
        CastShadow=true
    end object
    PickupMesh=MeshComponentA
    // Reference: CylinderComponent'Default__MOHAHealthPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAHealthPickupFactory.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAHealthPickupFactory.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAHealthPickupFactory.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAHealthPickupFactory.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    Components[6]=ExtraCollision
    Components[7]=MeshComponentA
    CollisionComponent=CollisionCylinder
    CollisionType=7
}