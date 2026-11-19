class EvilArmorPickupFactory extends EvilItemPickupFactory
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force,Display,Collision,PickupFactory)
    classgroup(Pickups,Armor);

var int ShieldAmount;

static simulated function UpdateHUD(UTHUD H)
{
    super(EvilPickupFactory).UpdateHUD(H);
    H.LastArmorPickupTime = H.LastPickupTime;
    //return;    
}

simulated function PostBeginPlay()
{
    // End:0x19
    if(!bPickupHidden)
    {
        SetPickupVisible();
    }
    super(EvilPickupFactory).PostBeginPlay();
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    // End:0x1A
    if(UTPawn(Recipient) == none)
    {
        return;
    }
    // End:0x8E
    if(EvilPlayerReplicationInfo(Recipient.PlayerReplicationInfo) != none)
    {
        EvilPlayerReplicationInfo(Recipient.PlayerReplicationInfo).IncrementPickupStat(GetPickupStatName());
    }
    Recipient.MakeNoise(0.2000000);
    AddShieldStrength(UTPawn(Recipient));
    super.SpawnCopyFor(Recipient);
    //return;    
}

function int CanUseShield(UTPawn P)
{
    return 0;
    //return ReturnValue;    
}

function AddShieldStrength(UTPawn P)
{
    //return;    
}

auto state Pickup
{
    function float DetourWeight(Pawn P, float PathWeight)
    {
        local float Need;
        local UTPawn Other;

        Other = UTPawn(P);
        // End:0x31
        if(Other == none)
        {
            return 0.0000000;
        }
        Need = float(CanUseShield(Other));
        // End:0xB5
        if(Need <= float(0))
        {
            // End:0xAC
            if(!WorldInfo.Game.bTeamGame)
            {
                Need = 0.5000000;                
            }
            else
            {
                return 0.0000000;
            }            
        }
        else
        {
            // End:0x108
            if(!WorldInfo.Game.bTeamGame)
            {
                Need = FMax(Need, 0.6000000);
            }
        }
        return ((0.0130000 * MaxDesireability) * Need) / PathWeight;
        //return ReturnValue;        
    }

    function bool ValidTouch(Pawn Other)
    {
        // End:0x1A
        if(!super.ValidTouch(Other))
        {
            return false;
        }
        return ((CanUseShield(UTPawn(Other))) > 0) || !WorldInfo.Game.bTeamGame;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    ShieldAmount=20
    // Reference: DynamicLightEnvironmentComponent'Default__EvilArmorPickupFactory.PickupLightEnvironment'
    begin object name=PickupLightEnvironment
    end object
    LightEnvironment=PickupLightEnvironment
    PickupStatName="PICKUPS_ARMOR"
    // Reference: ForceFeedbackWaveform'Default__EvilArmorPickupFactory.ForceFeedbackWaveformPickUp'
    begin object name=ForceFeedbackWaveformPickUp
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    bRotatingPickup=true
    // Reference: StaticMeshComponent'Default__EvilArmorPickupFactory.BaseMeshComp'
    begin object name=BaseMeshComp
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilArmorPickupFactory.PickupLightEnvironment'
    end object
    BaseMesh=BaseMeshComp
    BaseBrightEmissive=(R=25.0000000,G=25.0000000,B=1.0000000,A=1.0000000)
    BaseDimEmissive=(R=1.0000000,G=1.0000000,B=0.0100000,A=1.0000000)
    YawRotationRate=24000.0000000
    bPredictRespawns=true
    MaxDesireability=1.5000000
    // Reference: StaticMeshComponent'Default__EvilArmorPickupFactory.ArmorPickUpComp'
    begin object name=ArmorPickUpComp class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilArmorPickupFactory.PickupLightEnvironment'
        MaxDrawDistance=8000.0000000
        CachedMaxDrawDistance=8000.0000000
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        CollideActors=false
    end object
    PickupMesh=ArmorPickUpComp
    // Reference: CylinderComponent'Default__EvilArmorPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=PickupLightEnvironment
    Components[3]=BaseMeshComp
    Components[4]=ArmorPickUpComp
    CollisionComponent=CollisionCylinder
}