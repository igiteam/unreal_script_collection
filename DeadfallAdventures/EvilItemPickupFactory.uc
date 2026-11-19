class EvilItemPickupFactory extends EvilPickupFactory
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force,Display,Collision,PickupFactory);

var SoundCue PickupSound;
var const localized string PickupMessage;
var float RespawnTime;
var const localized string UseHintMessage;

simulated function InitializePickup()
{
    InitPickupMeshEffects();
    //return;    
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return default.PickupMessage;
    //return ReturnValue;    
}

function SpawnCopyFor(Pawn Recipient)
{
    Recipient.PlaySound(PickupSound);
    Recipient.MakeNoise(0.2000000);
    // End:0xCA
    if(PlayerController(Recipient.Controller) != none)
    {
        PlayerController(Recipient.Controller).ReceiveLocalizedMessage(MessageClass,,,, Class);
    }
    //return;    
}

function SetRespawn()
{
    // End:0x45
    if(WorldInfo.Game.ShouldRespawn(self))
    {
        StartSleeping();        
    }
    else
    {
        GotoState('Disabled');
    }
    //return;    
}

function float GetRespawnTime()
{
    return RespawnTime;
    //return ReturnValue;    
}

function float BotDesireability(Pawn P, Controller C)
{
    return 0.0000000;
    //return ReturnValue;    
}

defaultproperties
{
    RespawnTime=30.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__EvilItemPickupFactory.PickupLightEnvironment'
    begin object name=PickupLightEnvironment
    end object
    LightEnvironment=PickupLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__EvilItemPickupFactory.ForceFeedbackWaveformPickUp'
    begin object name=ForceFeedbackWaveformPickUp
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    // Reference: StaticMeshComponent'Default__EvilItemPickupFactory.BaseMeshComp'
    begin object name=BaseMeshComp
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilItemPickupFactory.PickupLightEnvironment'
    end object
    BaseMesh=BaseMeshComp
    InventoryType=Class'UTPickupInventory'
    // Reference: CylinderComponent'Default__EvilItemPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=PickupLightEnvironment
    Components[3]=BaseMeshComp
    CollisionComponent=CollisionCylinder
    MessageClass=Class'EvilPickupMessage'
}