class EvilCreatureWalking extends EvilCreature
    config(Game)
    hidecategories(Navigation);

enum ECreatureWalkingBlendIndices
{
    CWBI_Idle,                      // 0
    CWBI_Walk,                      // 1
    CWBI_Dead,                      // 2
    CWBI_MAX                        // 3
};

var Vector RunAwayFrom;
var() float RunAwayFromDistance;
var bool bShouldRunAway;

function Vector GetAccessibleRoamPoint()
{
    local EvilCreatureRoamVolume CRV, FoundCRV;
    local float outsideDistance, D;
    local Vector hl, hn, Destination;

    outsideDistance = 10000000000000.0000000;
    // End:0x13A
    foreach self.MyArea.Volumes(CRV)
    {
        // End:0x70
        if(!CRV.bGroundVolume)
        {
            continue;            
        }
        else
        {
            // End:0xB8
            if(CRV.Encompasses(self))
            {
                FoundCRV = CRV;
                outsideDistance = 0.0000000;                
            }
            else
            {
                D = Abs(VSize(CRV.Location - self.Location));
                // End:0x139
                if(outsideDistance > D)
                {
                    FoundCRV = CRV;
                    outsideDistance = D;
                }                
            }
        }
    }    
    // End:0x185
    if(FoundCRV == none)
    {
        return GetRandomRoamPoint(self.MyArea, self.GetCollisionExtent());        
    }
    else
    {
        Destination = FoundCRV.GetRandomRoamPoint(self.GetCollisionExtent());
    }
    // End:0x226
    if(Trace(hl, hn, Destination, self.Location, true, self.GetCollisionExtent()) != none)
    {
        return hl;        
    }
    else
    {
        return Destination;
    }
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
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

simulated function Tick(float Delta)
{
    // End:0xA3
    if(self.bShouldRunAway && Abs(VSize(self.RunAwayFrom - self.Location)) <= self.RunAwayFromDistance)
    {
        // End:0xA3
        if(!self.IsInState('RunAway'))
        {
            self.GotoState('RunAway');
        }
    }
    //return;    
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

function PlayDead()
{
    Mesh.SetNotifyRigidBodyCollision(true);
    Mesh.ScriptRigidBodyCollisionThreshold = 1000.0000000;
    StopAllAnimations();
    CollisionComponent = Mesh;
    Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
    // End:0xE7
    if(Mesh.bNotUpdatingKinematicDueToDistance)
    {
        Mesh.ForceSkelUpdate();
        Mesh.UpdateRBBonesFromSpaceBases(true, true);
    }
    Mesh.PhysicsWeight = 5.0000000;
    SetPhysics(10);
    Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
    Mesh.SetRBChannel(16);
    Mesh.SetRBCollidesWithChannel(2, false);
    Mesh.WakeRigidBody();
    //return;    
}

function SetMovementAnimation(optional EvilCreatureWalking.ECreatureWalkingBlendIndices animation = 0)
{
    self.BaseBlendNode.SetActiveChild(int(animation), self.BaseBlendNode.BlendTime);
    //return;    
}

auto state Idle
{
    ignores Bump, HitWall;

    function SetMovementPhysics()
    {
        self.Velocity.X = 0.0000000;
        self.Velocity.Y = 0.0000000;
        self.SetPhysics(1);
        //return;        
    }

    simulated function Tick(float Delta)
    {
        global.Tick(Delta);
        self.IdleTimer -= Delta;
        // End:0x6D
        if(self.IdleTimer <= float(0))
        {
            self.GotoState('Run');
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        self.SetMovementAnimation(0);
        self.SetMovementPhysics();
        self.RotationRate = MakeRotator(0, 0, 0);
        self.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        self.AccelRate = default.AccelRate;
        self.Speed = default.Speed * 0.5000000;
        //return;        
    }
Begin:

    ResetTimers();
    stop;        
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
        self.SetMovementAnimation(1);
        self.SetMovementPhysics();
        self.DesiredSpeed = default.Speed;
        self.ChangeMovementDirection();
        //return;        
    }
Begin:

    ResetTimers();
    stop;        
}

state RunAway
{
    simulated function Tick(float Delta)
    {
        global.Tick(Delta);
        // End:0xE3
        if(Abs(VSize(self.RunAwayFrom - self.Location)) <= self.RunAwayFromDistance)
        {
            self.ChangeMovementDirection();
            self.SetSpeed(Delta);
            self.Velocity = Normal(Vector(self.Rotation)) * self.Speed;            
        }
        else
        {
            self.GotoState('Run');
        }
        //return;        
    }

    function ChangeMovementDirection()
    {
        local Rotator Rot;

        Rot = Rotator(Normal(self.RunAwayFrom - self.Location) * float(-1));
        Rot.Pitch = 0;
        Rot.Roll = 0;
        self.ResetDesiredRotation();
        self.SetRotation(Rot);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        self.SetMovementAnimation(1);
        self.SetMovementPhysics();
        self.DesiredSpeed = default.Speed;
        //return;        
    }
Begin:

    ResetTimers();
    stop;        
}

state Dead
{
    function SetMovementPhysics()
    {
        self.Velocity.X = 0.0000000;
        self.Velocity.Y = 0.0000000;
        self.SetPhysics(1);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        self.SetMovementPhysics();
        self.SetCollisionType(1);
        self.SetMovementAnimation(2);
        //return;        
    }
Begin:

    ResetTimers();
    stop;        
}

defaultproperties
{
    RunAwayFromDistance=200.0000000
    // Reference: SkeletalMeshComponent'Default__EvilCreatureWalking.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__EvilCreature.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilCreatureWalking.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__EvilCreatureWalking.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilCreature.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__EvilCreatureWalking.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilCreature.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    Components[0]=MyLightEnvironment
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=WPawnSkeletalMeshComponent
    CollisionComponent=CollisionCylinder
}