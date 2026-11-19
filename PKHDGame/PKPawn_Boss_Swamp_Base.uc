class PKPawn_Boss_Swamp_Base extends PKPawn_Boss_Base
    abstract
    config(Pawn)
    hidecategories(Navigation);

var repnotify bool bVulnerable;
var bool bAttackedByPlayer;
var bool bStartExtinguishing;
var bool bIsCurrentyExtinguishing;
var bool bFirstPhaseOver;
var PKItem_Boss_Swamp_Bubble_Base BubbleToExtinguish;
var Vector MoveTarget;
var int MoveTargetReachDistance;
var class<PKItem_Boss_Swamp_Bubble_Base> BubbleActorClass;
var class<PKItem_Boss_Swamp_Tentacle_Base> TentacleActorClass;
var class<PKItem_Boss_Swamp_Firefly_Base> FireflyActorClass;
var class<PKItem_Boss_Swamp_Fireball_Base> FireballActorClass;
var class<PKItem_Boss_Swamp_Flying_Bubble_Base> FlyingBubbleActorClass;
var config int BubbleDamage;
var config int BubbleDamageToPlayer;
var config int BubbleDamageRadius;
var config int TentacleDamage;
var config int TentacleDamageRadius;
var config float TentacleSuckChance;
var config int FireballDamage;
var config int FireBallDamageRadius;

replication
{
    // Pos:0x000
    if(bNetDirty)
        bVulnerable;
}

simulated event PostBeginPlay()
{
    MoveTarget = Location;
    super(PKPawn).PostBeginPlay();
    //return;    
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x99
    if((bVulnerable && InstigatedBy != none) && InstigatedBy.IsPlayerOwned())
    {
        bAttackedByPlayer = true;
        super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    //return;    
}

function Extinguish()
{
    BubbleToExtinguish.Extinguish();
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local PKItem_Boss_Base_Item Item;

    // End:0x32
    foreach DynamicActors(Class'PKItem_Boss_Base_Item', Item)
    {
        Item.Destroy();        
    }    
    CallKismetEvent(Class'SeqEvent_BossKilled', 0);
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function TakeBubbleDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    bAttackedByPlayer = true;
    // End:0x7C
    if(float(Health) > (float(HealthMax) * 0.7500000))
    {
        TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);        
    }
    else
    {
        bFirstPhaseOver = true;
    }
    //return;    
}

function CreateTentacleOneHand()
{
    PKAI_Boss_Swamp(Controller).CreateTentacle(0.0000000);
    //return;    
}

function CreateTentacleTwoHands()
{
    PKAI_Boss_Swamp(Controller).CreateTentacle(0.0000000);
    PKAI_Boss_Swamp(Controller).CreateTentacle(0.7000000);
    //return;    
}

function CreateFireball()
{
    PKAI_Boss_Swamp(Controller).CreateFireball();
    //return;    
}

function GatherFireflies()
{
    PKAI_Boss_Swamp(Controller).GatherFireflies();
    //return;    
}

function ThrowBubble()
{
    local Vector BubbleSpawnPosition;
    local PKItem_Boss_Swamp_Bubble_Base Bubble;

    BubbleSpawnPosition = (Location + (vect(0.0000000, 0.0000000, 1.0000000) * float(512))) + (Normal(Vector(Rotation)) * float(64));
    Bubble = Spawn(BubbleActorClass,,, BubbleSpawnPosition);
    Bubble.SwampBoss = self;
    Bubble.BubbleType = 2;
    Bubble.SetDrawScale(0.5000000);
    Bubble.Velocity = Normal((Controller.Enemy.Location + (vect(0.0000000, 0.0000000, 1.0000000) * float(128))) - Bubble.Location) * float(2000);
    Bubble.bBurnable = false;
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x62
        case 'bVulnerable':
            // End:0x47
            if(bVulnerable)
            {
                SetParameterForAllMaterials('BossState', 0.5000000);                
            }
            else
            {
                SetParameterForAllMaterials('BossState', 0.0000000);
            }
            // End:0x78
            break;
        // End:0xFFFF
        default:
            super(PKPawn).ReplicatedEvent(VarName);
            break;
    }
    //return;    
}

function bool IsStillWalking()
{
    return VSize2D(MoveTarget - Location) > float(MoveTargetReachDistance);
    //return ReturnValue;    
}

function SetMovePoint(Vector MoveLocation, int ReachDistance)
{
    MoveTarget = MoveLocation;
    MoveTargetReachDistance = ReachDistance;
    //return;    
}

function AbortMoving()
{
    MoveTarget = Location;
    //return;    
}

protected simulated function ProcessMovementMode(float DeltaSeconds)
{
    //return;    
}

simulated function Tick(float Delta)
{
    local float anglefix;

    // End:0x244
    if(IsStillWalking())
    {
        anglefix = float(Clamp(int((float(3500) - VSize2D(PKAI_Boss_Swamp(MyPKAI).MapCenter - Location)) / float(10)), -10, 10));
        // End:0x90
        if(int(CurrentMoveMode) != int(1))
        {
            ChangeMoveMode(1);
        }
        Mesh.RootMotionMode = 2;
        // End:0x15C
        if(PKAI_Boss_Swamp(MyPKAI).bClockwise)
        {
            SetDesiredRotation(MakeRotator(0, int(float(Rotator(PKAI_Boss_Swamp(MyPKAI).MapCenter - Location).Yaw) - ((anglefix + float(90)) * 182.0444000)), 0));            
        }
        else
        {
            SetDesiredRotation(MakeRotator(0, int(float(Rotator(PKAI_Boss_Swamp(MyPKAI).MapCenter - Location).Yaw) + ((anglefix + float(90)) * 182.0444000)), 0));
        }
        Velocity = Vector(DesiredRotation) * GroundSpeed;
        PKAI_Boss_Swamp(MyPKAI).SetFocalPoint(Location + (Vector(DesiredRotation) * float(1024)));        
    }
    else
    {
        // End:0x265
        if(int(CurrentMoveMode) != int(0))
        {
            ChangeMoveMode(0);
        }
    }
    super.Tick(Delta);
    //return;    
}

defaultproperties
{
    MoveTargetReachDistance=512
    BubbleDamage=256
    BubbleDamageToPlayer=40
    BubbleDamageRadius=1536
    TentacleDamage=25
    TentacleDamageRadius=512
    FireballDamage=40
    FireBallDamageRadius=512
    bIsBoss=true
    bThrowSoul=false
    bCanBeFrozen=false
    bHasTIPAnims90Deg=true
    // Reference: StaticMeshComponent'Default__PKPawn_Boss_Swamp_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn_Boss_Base.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_Boss_Swamp_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn_Boss_Base.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    DefaultHealth=8000.0000000
    PawnActionClasses=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Swamp_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_Boss_Swamp_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn_Boss_Base.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    HeadBone="k_glowa"
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Boss_Swamp_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Boss_Swamp_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Boss_Swamp_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    MaxLeanRoll=0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Swamp_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_Boss_Swamp_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Swamp_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_Boss_Swamp_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    MaxStepHeight=200.0000000
    bReplicateHealthToAll=true
    SightRadius=102400.0000000
    Mass=10000.0000000
    GroundSpeed=2048.0000000
    // Reference: SkeletalMeshComponent'Default__PKPawn_Boss_Swamp_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Swamp_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_Boss_Swamp_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn_Boss_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_Boss_Swamp_Base.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPawn_Boss_Base.FaceAudioComponent'
    begin object name="FaceAudioComponent"
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    CollisionComponent=CollisionCylinder
}