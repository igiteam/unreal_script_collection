class EvilCreature_Worm_Base extends EvilCreatureWalking
    config(Game)
    hidecategories(Navigation);

var() export editinline PointLightComponent TailLight;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    Mesh.AttachComponent(TailLight, 'joint8');
    //return;    
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Health -= Damage;
    // End:0x9A
    if(Health < 0)
    {
        // End:0x7A
        if(TailLight != none)
        {
            TailLight.SetLightProperties(0.0000000);
            TailLight.SetEnabled(false);
        }
        // End:0x9A
        if(!IsInState('Dead'))
        {
            GotoState('Dead');
        }
    }
    //return;    
}

auto state Idle
{
    ignores Bump, HitWall;

    simulated function Tick(float Delta)
    {
        IdleTimer -= Delta;
        //return;        
    }
    stop;    
}

defaultproperties
{
    MinTravelTime=5.0000000
    MaxTravelTime=10.0000000
    Speed=32.0000000
    RunTimer=2.0000000
    IdleTimer=5.0000000
    AccelRate=8.0000000
    Health=200
    // Reference: SkeletalMeshComponent'Default__EvilCreature_Worm_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilCreature_Worm_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__EvilCreature_Worm_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__EvilCreature_Worm_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[0]=MyLightEnvironment
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=WPawnSkeletalMeshComponent
    Physics=EPhysics.PHYS_None
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=8192,Yaw=16384,Roll=8192)
}