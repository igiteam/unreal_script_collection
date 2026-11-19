class MOHAShellProjectile extends Projectile
    native
    hidecategories(Navigation);

var() float bounceDamping;
var float CustomGravityScale;
var export editinline StaticMeshComponent ProjectileMesh;

function InitRotator(Rotator Direction)
{
    SetRotation(Direction);
    Velocity = Speed * Vector(Direction);
    //return;    
}

function Init(Vector Direction)
{
    Velocity = Speed * Direction;
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    ImpactedActor = Wall;
    Velocity = bounceDamping * ((((Velocity Dot HitNormal) * HitNormal) * -2.0000000) + Velocity);
    Speed = VSize(Velocity);
    //return;    
}

simulated function Timer()
{
    // End:0x1C
    if(ProjectileMesh != none)
    {
        ProjectileMesh.SetDepthPriorityGroup(1);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    SetTimer(0.2500000);
    //return;    
}

defaultproperties
{
    bounceDamping=0.1500000
    // Reference: StaticMeshComponent'Default__MOHAShellProjectile.ProjectileMesh'
    begin object name=ProjectileMesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'GCm_Wpn_US_Thompson.StaticMesh.US_thompson_shell'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAShellProjectile.MyLightEnvironment'
        DepthPriorityGroup=2
        bCastDynamicShadow=false
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
        CollideActors=false
        BlockRigidBody=false
        NoPhysx=true
    end object
    ProjectileMesh=ProjectileMesh
    Speed=1000.0000000
    // Reference: CylinderComponent'Default__MOHAShellProjectile.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAShellProjectile.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAShellProjectile.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[2]=MyLightEnvironment
    Components[3]=ProjectileMesh
    Physics=2
    RemoteRole=0
    ActorType=14
    bCollideActors=false
    bCollideWorld=false
    bBounce=true
    LifeSpan=7.0000000
    DrawScale3D=(X=1.3000000,Y=1.3000000,Z=1.3000000)
    CollisionComponent=CollisionCylinder
}