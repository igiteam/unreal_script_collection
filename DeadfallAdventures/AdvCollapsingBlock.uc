class AdvCollapsingBlock extends Actor
    placeable
    hidecategories(Navigation)
    classgroup(Adventurer);

var() export editinline StaticMeshComponent BlockMesh;
var const editconst export editinline DynamicLightEnvironmentComponent LightEnvironment;
var protected bool bMoving;
var() protected bool bStayAtDestination;
var protected Vector DestinationLocation;
var protected Vector BaseLocation;
var() protected float ToDestinationLocationTime;
var() protected float ToBaseLocationTime;
var protected float MovementTime;
var() private const float ZDifference;
var private Actor LastBumped;
var() protected float ExecutionDelayTime;
var() protected float DestinationDelayTime;
var protected float DelayTime;

function PostBeginPlay()
{
    super.PostBeginPlay();
    BaseLocation = Location;
    DestinationLocation = Location;
    DestinationLocation.Z += ZDifference;
    DelayTime = ExecutionDelayTime;
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    // End:0x46
    if((Pawn(Other) != none) && !bIsMoving)
    {
        LastBumped = Other;
        Activate();
    }
    //return;    
}

function Activate()
{
    //return;    
}

auto state Idle
{
    ignores TakeDamage;

    function Tick(float DeltaTime)
    {
        // End:0x45
        if(bMoving)
        {
            // End:0x31
            if(DelayTime <= 0.0000000)
            {
                GotoState('MoveToDestination');                
            }
            else
            {
                DelayTime -= DeltaTime;
            }
        }
        //return;        
    }

    function Activate()
    {
        bMoving = true;
        DelayTime = ExecutionDelayTime;
        MovementTime = 0.0000000;
        //return;        
    }
Begin:

    bMoving = false;
    stop;                
}

state MoveToDestination
{
    ignores TakeDamage;

    function Tick(float DeltaTime)
    {
        local float Alpha;
        local Vector CurrentLocation;

        bMoving = true;
        MovementTime += DeltaTime;
        Alpha = MovementTime / ToDestinationLocationTime;
        // End:0x60
        if(Alpha >= 1.0000000)
        {
            Alpha = 1.0000000;
        }
        CurrentLocation = VLerp(BaseLocation, DestinationLocation, Alpha);
        Move(CurrentLocation - Location);
        // End:0xC7
        if(Alpha >= 1.0000000)
        {
            GotoState('AtDestination');
        }
        //return;        
    }
    stop;    
}

state AtDestination
{
    ignores TakeDamage;

    function Tick(float DeltaTime)
    {
        // End:0x46
        if((DelayTime <= float(0)) && !bStayAtDestination)
        {
            MovementTime = ToBaseLocationTime;
            GotoState('MoveToBase');            
        }
        else
        {
            DelayTime -= DeltaTime;
        }
        //return;        
    }
Begin:

    DelayTime = DestinationDelayTime;
    stop;                    
}

state MoveToBase
{
    ignores TakeDamage;

    function Tick(float DeltaTime)
    {
        local float Alpha;
        local Vector CurrentLocation;

        bMoving = true;
        MovementTime -= DeltaTime;
        Alpha = MovementTime / ToBaseLocationTime;
        // End:0x60
        if(Alpha <= 0.0000000)
        {
            Alpha = 0.0000000;
        }
        CurrentLocation = VLerp(BaseLocation, DestinationLocation, Alpha);
        Move(CurrentLocation - Location);
        // End:0x10D
        if(Alpha <= 0.0000000)
        {
            // End:0xFF
            if((LastBumped != none) && LastBumped.Base == self)
            {
                GotoState('MoveToDestination');                
            }
            else
            {
                GotoState('Idle');
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvCollapsingBlock.Mesh'
    begin object name=Mesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'EngineMeshes.Cube'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvCollapsingBlock.MyLightEnvironment'
        AlwaysCheckCollision=true
        Scale=0.5000000
    end object
    BlockMesh=Mesh
    // Reference: DynamicLightEnvironmentComponent'Default__AdvCollapsingBlock.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=MyLightEnvironment
    ToDestinationLocationTime=2.0000000
    ToBaseLocationTime=2.0000000
    DestinationDelayTime=1.0000000
    Components[0]=MyLightEnvironment
    Components[1]=Mesh
    Physics=EPhysics.PHYS_Interpolating
    CollisionType=ECollisionType.COLLIDE_BlockAll
    BlockRigidBody=true
    bCollideActors=true
    bBlockActors=true
    CollisionComponent=Mesh
}