class EvilCreature_Spider_Base extends EvilCreatureWalking
    config(Game)
    hidecategories(Navigation);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetCollisionType(1);
    //return;    
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Health -= Damage;
    // End:0x45
    if(Health < 0)
    {
        // End:0x45
        if(!IsInState('Dead'))
        {
            GotoState('Dead');
        }
    }
    //return;    
}

defaultproperties
{
    MinTravelTime=5.0000000
    MaxTravelTime=10.0000000
    Speed=200.0000000
    RunTimer=3.0000000
    IdleTimer=2.0000000
    AccelRate=8.0000000
    Health=200
    // Reference: SkeletalMeshComponent'Default__EvilCreature_Spider_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__EvilCreatureWalking.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilCreature_Spider_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__EvilCreature_Spider_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilCreatureWalking.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__EvilCreature_Spider_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilCreatureWalking.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    Components[0]=MyLightEnvironment
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=WPawnSkeletalMeshComponent
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=8192,Yaw=16384,Roll=8192)
}