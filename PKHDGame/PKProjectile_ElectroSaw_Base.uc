class PKProjectile_ElectroSaw_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

struct TElectroHitInfo
{
    var export editinline ParticleSystemComponent BeamEmitter;
    var PKPawn LinkedTo;

    structdefaultproperties
    {
        BeamEmitter=none
        LinkedTo=none
    }
};

var() export editinline StaticMeshComponent Mesh;
var array<name> AcceptedBoneNames;
var() float ElectroDamage;
var() float ElectroDamageInterval;
var() float ElectroDamageDistance;
var() ParticleSystem BeamTemplate;
var() name EndPointParamName;
var array<TElectroHitInfo> ElectroHits;

simulated function RepInit()
{
    super.RepInit();
    DamageVSPlayer = int(Damage);
    SetTimer(ElectroDamageInterval, true, 'DoElectroDamage');
    //return;    
}

simulated function DoElectroDamage()
{
    local PKPawn Other;
    local int I;
    local bool bFound;
    local TElectroHitInfo ElectroHitInfo;

    // End:0x23
    if(bExploded)
    {
        ClearTimer('DoElectroDamage');
        return;
    }
    // End:0x1E3
    foreach OverlappingActors(Class'PKPawn', Other, ElectroDamageDistance,, true)
    {
        bFound = false;
        I = 0;
        J0x64:

        // End:0xCD [Loop If]
        if(I < ElectroHits.Length)
        {
            // End:0xBF
            if(ElectroHits[I].LinkedTo == Other)
            {
                bFound = true;
                // [Explicit Break]
                goto J0xCD;
            }
            I++;
            // [Loop Continue]
            goto J0x64;
        }
        J0xCD:

        // End:0x1E2
        if(((!bFound && Other.IsAliveAndWell()) && Other != Instigator) && !WorldInfo.GRI.IsCoopMultiplayerGame() || EqualEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none)))
        {
            ElectroHitInfo.LinkedTo = Other;
            ElectroHitInfo.BeamEmitter = AddBeamEmitter();
            ElectroHits.AddItem(ElectroHitInfo);
        }        
    }    
    // End:0x49E
    foreach ElectroHits(ElectroHitInfo)
    {
        // End:0x400
        if(((ElectroHitInfo.LinkedTo != none) && ElectroHitInfo.LinkedTo.IsAliveAndWell()) && VSize(ElectroHitInfo.LinkedTo.Location - Location) < ElectroDamageDistance)
        {
            // End:0x328
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(ElectroHitInfo.LinkedTo);
            }
            ElectroHitInfo.LinkedTo.TakeDamage(int(ElectroDamage), Instigator.Controller, ElectroHitInfo.LinkedTo.Location, Normal(ElectroHitInfo.LinkedTo.Location - Location), MyDamageType,, self);            
        }
        else
        {
            // End:0x487
            if(ElectroHitInfo.BeamEmitter != none)
            {
                ElectroHitInfo.BeamEmitter.SetHidden(true);
                ElectroHitInfo.BeamEmitter.DeactivateSystem();
            }
            ElectroHits.RemoveItem(ElectroHitInfo);
        }        
    }    
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local TElectroHitInfo ElectroHitInfo;

    super.Tick(DeltaTime);
    // End:0x14D
    foreach ElectroHits(ElectroHitInfo)
    {
        // End:0x14C
        if((ElectroHitInfo.LinkedTo != none) && ElectroHitInfo.BeamEmitter != none)
        {
            ElectroHitInfo.BeamEmitter.SetRotation(Rotator(ElectroHitInfo.LinkedTo.Location - Location));
            ElectroHitInfo.BeamEmitter.SetVectorParameter(EndPointParamName, ElectroHitInfo.LinkedTo.Location);
        }        
    }    
    //return;    
}

simulated function ParticleSystemComponent AddBeamEmitter()
{
    local editinline ParticleSystemComponent BeamEmitter;

    // End:0x143
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x143
        if(BeamTemplate != none)
        {
            BeamEmitter = new (Outer) Class'EvilGame.UTParticleSystemComponent';
            BeamEmitter.SetTemplate(BeamTemplate);
            BeamEmitter.SetTickGroup(3);
            BeamEmitter.bUpdateComponentInTick = true;
            BeamEmitter.SetIgnoreOwnerHidden(true);
            AttachComponent(BeamEmitter);
            BeamEmitter.SetAbsolute(,, true);
            BeamEmitter.SetTranslation(vect(0.0000000, 0.0000000, 10.0000000));
        }
    }
    return BeamEmitter;
    //return ReturnValue;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local PKPawn P;
    local name BoneName;
    local Vector besthitloc;
    local TraceHitInfo THitInfo;

    P = PKPawn(Other);
    // End:0x91
    if(((P != none) && WorldInfo.GRI.IsCoopMultiplayerGame()) && NotEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none)))
    {
        return;
    }
    // End:0x161
    if(P != none)
    {
        // End:0xE1
        if(P.CanPlayDirectHitByProjectile())
        {
            P.DirectHitByProjectile();
        }
        Class'PainWeap_Base'.static.FindNearestBone(P, HitLocation, BoneName, besthitloc, AcceptedBoneNames);
        SetBase(P,, P.Mesh, BoneName);
    }
    // End:0x4D3
    if(((Damage > float(0)) && !ClassIsChildOf(Other.Class, Class'EvilGame.EvilDestructibleObject')) && !ClassIsChildOf(Other.Class, Class'EvilGame.EvilDynamicDestructibleObject'))
    {
        Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
        // End:0x291
        if(EvilWeap_Base(Instigator.Weapon) != none)
        {
            EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Other);
        }
        // End:0x320
        if(NotEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none)))
        {
            Other.TakeDamage(DamageVSPlayer, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);            
        }
        else
        {
            Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);
            // End:0x4D3
            if((P != none) && P.Health <= 0)
            {
                P.CustomGravityScaling = 0.5000000;
                P.Knockdown(vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000));
                P.Mesh.AddForce((((MomentumTransfer * Normal(Velocity)) + (VRand() * float(50000))) + vect(0.0000000, 0.0000000, 50000.0000000)) / P.Mass, HitLocation + (VRand() * float(5000)), THitInfo.BoneName);
            }
        }
    }
    // End:0x534
    if(ClassIsChildOf(Other.Class, Class'EvilGame.EvilDestructibleObject') || ClassIsChildOf(Other.Class, Class'EvilGame.EvilDynamicDestructibleObject'))
    {
        SetPhysics(0);
    }
    SetCollision(false, false);
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    // End:0x83
    if(ClassIsChildOf(Wall.Class, Class'EvilGame.EvilDestructibleObject') || ClassIsChildOf(Wall.Class, Class'EvilGame.EvilDynamicDestructibleObject'))
    {
        super(Actor).HitWall(HitNormal, Wall, WallComp);
        return;
    }
    // End:0xD8
    if(Wall.bStatic)
    {
        SetPhysics(0);
        SetCollision(false, false);
        super(Actor).HitWall(HitNormal, Wall, WallComp);        
    }
    else
    {
        super.HitWall(HitNormal, Wall, WallComp);
    }
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PKProjectile_ElectroSaw_Base.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    begin object name="StaticMesh" class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    Mesh=StaticMesh
    ElectroDamage=10.0000000
    ElectroDamageInterval=0.0660000
    ElectroDamageDistance=400.0000000
    TimeToExplode=4.5000000
    Speed=2600.0000000
    MaxSpeed=2600.0000000
    MyDamageType=Class'PKDmgType_ElectroSaw'
    // Reference: CylinderComponent'Default__PKProjectile_ElectroSaw_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    bNetTemporary=false
    LifeSpan=10.0000000
    CollisionComponent=CollisionCylinder
}