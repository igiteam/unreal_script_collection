class EvilCreature extends Pawn
    config(Game)
    hidecategories(Navigation);

var float MinTravelTime;
var float MaxTravelTime;
var float Speed;
var float MinSize;
var float MaxSize;
var Rotator MyDesiredRotation;
var Vector DesiredLocation;
var bool bFoundSpot;
var bool bReactToNoise;
var float RunTimer;
var float IdleTimer;
var int PanicRange;
var Vector PanicSource;
var Vector LastLocation;
var UDKAnimBlendBase BaseBlendNode;
var() EvilCreatureArea MyArea;
var int StopFailureCounter;
var EvilCreatureRoamVolume LastVolume;
var float LastVolumeBoundaryCrossTime;
var float TimeInsideVolumes;
var float TimeOutsideVolumes;
var float VolumeCoverage;
var float MaxVisionDistance;
var EvilAI_Creature MyCreatureController;

simulated function PostBeginPlay()
{
    local float RandVal;

    super.PostBeginPlay();
    SetDrawScale(RandRange(MinSize, MaxSize));
    RandVal = RandRange(0.5000000, 1.5000000);
    RotationRate *= (RandVal * (Speed / default.Speed));
    DesiredSpeed *= RandVal;
    bRollToDesired = true;
    //return;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);
    self.MyCreatureController = EvilAI_Creature(self.Controller);
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);
    // End:0x65
    if(SkelComp == Mesh)
    {
        BaseBlendNode = UDKAnimBlendBase(SkelComp.FindAnimNode('BaseBlendNode'));
    }
    //return;    
}

function SetSpeed(float DeltaTime)
{
    // End:0x39
    if(Speed > DesiredSpeed)
    {
        Speed -= (AccelRate * DeltaTime);        
    }
    else
    {
        // End:0x6F
        if(Speed < DesiredSpeed)
        {
            Speed += (AccelRate * DeltaTime);
        }
    }
    //return;    
}

function ResetTimers()
{
    IdleTimer = RandRange(default.IdleTimer * 0.5000000, default.IdleTimer * 1.5000000);
    RunTimer = RandRange(default.RunTimer * 0.5000000, default.RunTimer * 1.5000000);
    //return;    
}

static function Vector GetRandomRoamPoint(EvilCreatureArea Area, optional Vector PawnExtents)
{
    local EvilCreatureRoamVolume CRV;

    CRV = Area.Volumes[Rand(Area.Volumes.Length)];
    // End:0x68
    if(CRV == none)
    {
        return vect(0.0000000, 0.0000000, 0.0000000);
    }
    return CRV.GetRandomRoamPoint(PawnExtents);
    //return ReturnValue;    
}

function Vector GetAccessibleRoamPoint()
{
    local EvilCreatureRoamVolume CRV;
    local bool Found;
    local float D, Dist;
    local Vector Retval, TestPoint;
    local int I;

    // End:0x12D
    if((LastVolume == none) && MyArea != none)
    {
        Found = false;
        Dist = 10000000000000.0000000;
        // End:0x10C
        foreach MyArea.Volumes(CRV)
        {
            // End:0x99
            if(CRV.Encompasses(self))
            {
                Found = true;                
            }
            else
            {
                D = VSizeSq(CRV.Location - Location);
                // End:0x10B
                if(Dist > D)
                {
                    Dist = D;
                    LastVolume = CRV;
                }                
            }
        }        
        // End:0x12D
        if(Found)
        {
            LastVolume = CRV;
        }
    }
    // End:0x18D
    if(LastVolume == none)
    {
        // End:0x176
        if(MyArea != none)
        {
            return GetRandomRoamPoint(MyArea, self.GetCollisionExtent());
        }
        return self.Location;
    }
    I = 0;
    J0x198:

    // End:0x2A0 [Loop If]
    if(I < 10)
    {
        CRV = LastVolume.AdjacentVolumes[Rand(LastVolume.AdjacentVolumes.Length)];
        Retval = CRV.GetRandomRoamPoint(self.GetCollisionExtent());
        TestPoint = Retval - Normal(Retval - Location);
        // End:0x292
        if(LastVolume.EncompassesPoint(TestPoint))
        {
            return Retval;
        }
        ++I;
        // [Loop Continue]
        goto J0x198;
    }
    return Retval;
    //return ReturnValue;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x2E
    if(MyArea != none)
    {
        MyArea.SpawnCreatures();
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

simulated event Destroyed()
{
    // End:0x2E
    if(MyArea != none)
    {
        MyArea.SpawnCreatures();
    }
    super.Destroyed();
    //return;    
}

simulated function Tick(float Delta)
{
    // End:0x14
    if(MyArea == none)
    {
        Destroy();
        return;
    }
    super(Actor).Tick(Delta);
    //return;    
}

auto state Idle
{Begin:

    ResetTimers();
    stop;        
}

state RunAway
{Begin:

    ResetTimers();
    stop;        
}

state Run
{Begin:

    ResetTimers();
    stop;        
}

state Stop
{    stop;    
}

state Attack
{    stop;    
}

defaultproperties
{
    bReactToNoise=true
    MaxVisionDistance=1000.0000000
    bAmbientCreature=true
    ControllerClass=Class'EvilAI_Creature'
    // Reference: SkeletalMeshComponent'Default__EvilCreature.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent class=Class'Engine.SkeletalMeshComponent'
        MinDistFactorForKinematicUpdate=0.2000000
        bUpdateSkelWhenNotRendered=false
        bIgnoreControllersWhenNotRendered=true
        bHasPhysicsAssetInstance=true
        bOverrideAttachmentOwnerVisibility=true
        bChartDistanceFactor=true
        bCacheAnimSequenceNodes=false
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilCreature.MyLightEnvironment'
        RBChannel=ERBCollisionChannel.RBCC_Untitled3
        RBDominanceGroup=20
        bOwnerNoSee=true
        BlockRigidBody=true
        RBCollideWithChannels=(Untitled3=true)
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__EvilCreature.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__EvilCreature.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[0]=MyLightEnvironment
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=WPawnSkeletalMeshComponent
    Physics=EPhysics.PHYS_Walking
    bIgnoreEncroachers=true
    CollisionComponent=CollisionCylinder
}