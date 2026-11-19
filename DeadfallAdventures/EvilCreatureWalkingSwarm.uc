class EvilCreatureWalkingSwarm extends EvilCreature
    config(Game)
    hidecategories(Navigation);

enum ECreatureSwarmWalkingBlendIndices
{
    CWSBI_Idle,                     // 0
    CWSBI_Walk,                     // 1
    CWSBI_Run,                      // 2
    CWSBI_Attack,                   // 3
    CWSBI_Dead,                     // 4
    CWSBI_MAX                       // 5
};

var float AttackDistance;
var float AttackDelay;
var float CurrentAttackDelayTimer;
var float DeathTimer;
var float TimeToLive;
var bool bHadFirstEnemy;
var float jumpAngle;

function Vector GetAccessibleRoamPoint()
{
    return self.Location;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    self.AttackDelay = default.AttackDelay * RandRange(0.7500000, 1.2500000);
    self.TimeToLive = default.TimeToLive * RandRange(0.9000000, 1.1000000);
    //return;    
}

function SetMovementPhysics()
{
    self.SetPhysics(1);
    //return;    
}

function ChangeMovementDirection()
{
    //return;    
}

function bool IsInRangeToAttack()
{
    // End:0xA8
    if(self.MyCreatureController.HasEnemy())
    {
        // End:0xA8
        if(Abs(VSize(self.Location - self.MyCreatureController.Enemy.Location)) <= self.AttackDistance)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function PreparePawnForRagdoll()
{
    // End:0x28F
    if(InitRagdoll())
    {
        // End:0x133
        if(Mesh.PhysicsAssetInstance != none)
        {
            Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(false, false, Mesh, true);
            Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(0.0000000, 0.0000000, 0.0040000, Mesh, true);
            Mesh.PhysicsAssetInstance.SetAllMotorsAngularVelocityDrive(true, true, Mesh, true);
            Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        }
        Mesh.SetTickGroup(2);
        SetTickGroup(2);
        Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        Mesh.bUpdateKinematicBonesFromAnimation = false;
        Mesh.bUpdateJointsFromAnimation = false;
        Mesh.bUpdateKinematicBonesFromAnimation = false;
        StopAllAnimations();
        SetCollision(true, true);
        Mesh.PhysicsWeight = 5.0000000;
        Mesh.WakeRigidBody();
        Mesh.SetRBChannel(16);
        Mesh.SetRBCollidesWithChannel(2, false);
    }
    //return;    
}

simulated function StopAllAnimations()
{
    local AnimNodeSequence SeqNode;

    // End:0x56
    foreach Mesh.AllAnimNodes(Class'Engine.AnimNodeSequence', SeqNode)
    {
        SeqNode.bPlaying = false;        
    }    
    // End:0x14B
    if(!AnimTree(Mesh.Animations).bUseSavedPose)
    {
        AnimTree(Mesh.Animations).SetUseSavedPose(true);
        AnimTree(Mesh.Animations).Children[0].Anim = none;
        Mesh.bUpdateSkelWhenNotRendered = false;
    }
    //return;    
}

function SetMovementAnimation(optional EvilCreatureWalkingSwarm.ECreatureSwarmWalkingBlendIndices animation = 0)
{
    self.BaseBlendNode.SetActiveChild(int(animation), self.BaseBlendNode.BlendTime);
    //return;    
}

function bool GetUnstuckLocation()
{
    local float MinRadius;
    local array<Vector> Locations;
    local int Idx;
    local bool bLocationChanged;

    bLocationChanged = false;
    MinRadius = (GetCollisionRadius()) * float(2);
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(Location, 200.0000000, GetCollisionExtent(), false, Locations, 10, MinRadius);
    Idx = 0;
    J0x7E:

    // End:0xDF [Loop If]
    if(Idx < Locations.Length)
    {
        ZeroMovementVariables();
        bLocationChanged = SetLocation(Locations[Idx]);
        // End:0xD1
        if(bLocationChanged)
        {
            // [Explicit Break]
            goto J0xDF;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x7E;
    }
    J0xDF:

    return Locations.Length > 0;
    //return ReturnValue;    
}

state Run
{
    simulated function Tick(float Delta)
    {
        local Vector hl, hn;
        local float distanceFromObject;

        global.Tick(Delta);
        distanceFromObject = 100.0000000;
        // End:0xC1
        if(Trace(hl, hn, self.Location + (Normal(Vector(self.Rotation)) * distanceFromObject), self.Location, true, self.GetCollisionExtent()) != none)
        {
            self.ChangeMovementDirection();
        }
        self.SetSpeed(Delta);
        self.Velocity = Normal(Vector(self.Rotation)) * self.Speed;
        self.RunTimer -= Delta;
        // End:0x184
        if(self.RunTimer <= float(0))
        {
            self.GotoState('Idle');
        }
        //return;        
    }

    function ChangeMovementDirection()
    {
        local Vector roamPoint;
        local Rotator Rot;

        roamPoint = self.GetAccessibleRoamPoint();
        Rot = Rotator(roamPoint - self.Location);
        Rot.Pitch = 0;
        Rot.Roll = 0;
        self.ResetDesiredRotation();
        self.SetDesiredRotation(Rot, true, true, 1.0000000);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        ResetTimers();
        self.SetMovementAnimation(1);
        self.SetMovementPhysics();
        self.DesiredSpeed = default.Speed;
        self.ChangeMovementDirection();
        //return;        
    }
Begin:

    // End:0x30
    if(MyCreatureController.HasEnemy())
    {
        GotoState('Attack');
    }
    Sleep(0.5000000);
    goto 'Begin';
    stop;        
}

state Fall
{
    function BeginState(name PreviousStateName)
    {
        self.SetMovementAnimation(2);
        //return;        
    }
Begin:

    ZeroMovementVariables();
    SetPhysics(2);
    GotoState('Idle');
    stop;            
}

defaultproperties
{
    AttackDistance=100.0000000
    AttackDelay=1.5000000
    TimeToLive=15.0000000
    Speed=1000.0000000
    bReactToNoise=false
    // Reference: SkeletalMeshComponent'Default__EvilCreatureWalkingSwarm.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilCreatureWalkingSwarm.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__EvilCreatureWalkingSwarm.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__EvilCreatureWalkingSwarm.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[0]=MyLightEnvironment
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=WPawnSkeletalMeshComponent
    CollisionComponent=CollisionCylinder
}