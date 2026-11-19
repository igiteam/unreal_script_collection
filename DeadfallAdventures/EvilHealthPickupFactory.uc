class EvilHealthPickupFactory extends EvilItemPickupFactory
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force,Display,Collision,PickupFactory)
    classgroup(Pickups,Health);

var int HealingAmount;
var bool bSuperHeal;

static simulated function UpdateHUD(UTHUD H)
{
    super(EvilPickupFactory).UpdateHUD(H);
    H.LastHealthPickupTime = H.LastPickupTime;
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    Recipient.Health += (HealAmount(Recipient));
    // End:0xA7
    if(EvilPlayerReplicationInfo(Recipient.PlayerReplicationInfo) != none)
    {
        EvilPlayerReplicationInfo(Recipient.PlayerReplicationInfo).IncrementPickupStat(GetPickupStatName());
    }
    super.SpawnCopyFor(Recipient);
    //return;    
}

function int HealAmount(Pawn Recipient)
{
    local UTPawn UTP;

    // End:0x8D
    if(bSuperHeal)
    {
        UTP = UTPawn(Recipient);
        // End:0x8D
        if(UTP != none)
        {
            return int(FClamp(float(UTP.SuperHealthMax - Recipient.Health), 0.0000000, float(HealingAmount)));
        }
    }
    return int(FClamp(float(Recipient.HealthMax - Recipient.Health), 0.0000000, float(HealingAmount)));
    //return ReturnValue;    
}

auto state Pickup
{
    function float DetourWeight(Pawn Other, float PathWeight)
    {
        local int Heal;

        Heal = HealAmount(Other);
        return (0.0200000 * float(Heal)) / PathWeight;
        //return ReturnValue;        
    }

    function bool ValidTouch(Pawn Other)
    {
        // End:0x1A
        if(!super.ValidTouch(Other))
        {
            return false;
        }
        // End:0x64
        if(bSuperHeal && !WorldInfo.Game.bTeamGame)
        {
            return true;
        }
        return (HealAmount(Other)) > 0;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    HealingAmount=20
    // Reference: DynamicLightEnvironmentComponent'Default__EvilHealthPickupFactory.PickupLightEnvironment'
    begin object name=PickupLightEnvironment
    end object
    LightEnvironment=PickupLightEnvironment
    PickupStatName="PICKUPS_HEALTH"
    // Reference: ForceFeedbackWaveform'Default__EvilHealthPickupFactory.ForceFeedbackWaveformPickUp'
    begin object name=ForceFeedbackWaveformPickUp
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    // Reference: StaticMeshComponent'Default__EvilHealthPickupFactory.BaseMeshComp'
    begin object name=BaseMeshComp
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilHealthPickupFactory.PickupLightEnvironment'
    end object
    BaseMesh=BaseMeshComp
    BaseBrightEmissive=(R=2.0000000,G=50.0000000,B=10.0000000,A=1.0000000)
    BaseDimEmissive=(R=0.2000000,G=5.0000000,B=1.0000000,A=0.0000000)
    MaxDesireability=0.7000000
    // Reference: StaticMeshComponent'Default__EvilHealthPickupFactory.HealthPickUpMesh'
    begin object name=HealthPickUpMesh class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilHealthPickupFactory.PickupLightEnvironment'
        MaxDrawDistance=4500.0000000
        CachedMaxDrawDistance=4500.0000000
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        CollideActors=false
        BlockActors=false
        BlockRigidBody=false
    end object
    PickupMesh=HealthPickUpMesh
    // Reference: CylinderComponent'Default__EvilHealthPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=PickupLightEnvironment
    Components[3]=BaseMeshComp
    Components[4]=HealthPickUpMesh
    CollisionComponent=CollisionCylinder
}