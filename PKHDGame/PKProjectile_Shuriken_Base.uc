class PKProjectile_Shuriken_Base extends EvilProjectile_Pinnable_Base
    abstract
    hidecategories(Navigation);

var() float CustomExploTime;
var repnotify bool bCustomExploded;
var EvilExplosion CustomExplosionArchetype;
var class<DamageType> MyDamageTypeCustomExplo;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        bCustomExploded;
}

simulated function RepInit()
{
    super.RepInit();
    CustomExploTime = default.CustomExploTime;
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local PKPawn P;
    local name BoneName;
    local Vector besthitloc;
    local TraceHitInfo THitInfo;

    P = PKPawn(Other);
    // End:0x57A
    if(((PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier) && ((P == none) || P.bBlockActors) || P.bCanBePinned)
    {
        // End:0x14E
        if(((P != none) && WorldInfo.GRI.IsCoopMultiplayerGame()) && NotEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none)))
        {
            bIsManuallyAttached = true;
        }
        // End:0x24C
        if((P != none) && !bIsManuallyAttached)
        {
            // End:0x1AF
            if(P.CanPlayDirectHitByProjectile())
            {
                P.DirectHitByProjectile();
            }
            Class'PainWeap_Base'.static.FindNearestBone(P, HitLocation, BoneName, besthitloc, AcceptedBoneNames);
            SetBase(P,, P.Mesh, BoneName);
            SetCollision(false, false);
            Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        }
        // End:0x55C
        if(Damage > float(0))
        {
            Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
            // End:0x31A
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Other);
            }
            // End:0x3A9
            if(NotEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none)))
            {
                Other.TakeDamage(DamageVSPlayer, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);                
            }
            else
            {
                Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);
                // End:0x55C
                if((P != none) && P.Health <= 0)
                {
                    P.CustomGravityScaling = 0.5000000;
                    P.Knockdown(vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000));
                    P.Mesh.AddForce((((MomentumTransfer * Normal(Velocity)) + (VRand() * float(50000))) + vect(0.0000000, 0.0000000, 50000.0000000)) / P.Mass, HitLocation + (VRand() * float(5000)), THitInfo.BoneName);
                }
            }
        }
        SpawnExplosionEffects(HitLocation, HitNormal);
        return;
    }
    super.ProcessTouch(Other, HitLocation, HitNormal);
    //return;    
}

simulated function CustomExplosion()
{
    MyDamageType = MyDamageTypeCustomExplo;
    ExplosionArchetype = CustomExplosionArchetype;
    bIsManuallyAttached = true;
    bWaitForEffects = true;
    Explode(Location, Normal(Velocity));
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(EvilProjectile_Base).Tick(DeltaTime);
    // End:0x120
    if(((bInit && CustomExploTime > float(0)) && !bShuttingDown || ((PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier) && int(Role) == int(ROLE_Authority))
    {
        CustomExploTime -= DeltaTime;
        // End:0x120
        if(CustomExploTime <= float(0))
        {
            CustomExplosion();
            bCustomExploded = true;
        }
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'bCustomExploded')
    {
        CustomExplosion();        
    }
    else
    {
        super(EvilProjectile_Base).ReplicatedEvent(VarName);
    }
    //return;    
}

defaultproperties
{
    CustomExploTime=0.6600000
    MyDamageTypeCustomExplo=Class'PKDmgType_ShurikenExplo'
    // Reference: EvilDissolvingStaticMeshComponent'Default__PKProjectile_Shuriken_Base.StaticMesh'
    // Archetype: EvilDissolvingStaticMeshComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    CustomGravityScaling=0.1000000
    Speed=3920.0000000
    MaxSpeed=3920.0000000
    MyDamageType=Class'PKDmgType_Shuriken'
    // Reference: CylinderComponent'Default__PKProjectile_Shuriken_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=CollisionCylinder
}