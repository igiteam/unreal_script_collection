class AdvProjectile_Bolt extends EvilProjectile_Base
    hidecategories(Navigation);

var Vector InitialLocation;
var() export editinline StaticMeshComponent Mesh;
var array<name> AcceptedBoneNames;
var() bool bCanPinToPawns;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    InitialLocation = Location;
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local editinline ParticleSystemComponent ImpactEffectComponent;
    local editinline StaticMeshComponent SMC;
    local name BoneName;
    local EvilPawn P;
    local Rotator boneSpaceRot;
    local Vector boneSpacePos, bonePos, dirFromHitLocToBonePos, besthitloc;

    // End:0x51
    if(NotEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none)) && VSize(InitialLocation - Location) > DamageVSPlayerDistance)
    {
        return;
    }
    P = EvilPawn(Other);
    // End:0x63C
    if(P != none)
    {
        Class'EvilGame.EvilWeap_Base'.static.FindNearestBone(P, HitLocation, BoneName, besthitloc, AcceptedBoneNames);
        HitLocation = besthitloc;
        bonePos = P.Mesh.GetBoneLocation(BoneName, 0);
        dirFromHitLocToBonePos = bonePos - HitLocation;
        dirFromHitLocToBonePos *= 0.8000000;
        HitLocation += dirFromHitLocToBonePos;
        P.Mesh.TransformToBoneSpace(BoneName, HitLocation, Rotation, boneSpacePos, boneSpaceRot);
        // End:0x335
        if(P.CanPlayDirectHitByProjectile() && bCanPinToPawns)
        {
            SMC = new (Other) Class'AdvStaticMeshComponent_Bolt';
            SMC.SetStaticMesh(Mesh.StaticMesh);
            SMC.SetLightEnvironment(P.LightEnvironment);
            SMC.SetScale(DrawScale);
            SMC.SetAbsolute(,,, true);
            P.Mesh.AttachComponent(SMC, BoneName, boneSpacePos, boneSpaceRot);
        }
        // End:0x480
        if(EqualEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none)) && P.CanPlayHitImpactEffects())
        {
            ImpactEffectComponent = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(ParticleSystem'ps_Blood.Effects.ps_Bloodhit_RedKolek');
            ImpactEffectComponent.SetRotation(Rotation);
            P.Mesh.AttachComponent(ImpactEffectComponent, BoneName, boneSpacePos);
            ImpactEffectComponent.ActivateSystem();
        }
        Other.TakeDamage(int(((NotEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none))) ? float(DamageVSPlayer) : Damage)), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
        // End:0x626
        if((P.Health <= 0) && EqualEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none)))
        {
            // End:0x626
            if(P.CanBeKnockedDown())
            {
                P.Knockdown(vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000));
                P.Mesh.AddForce((MomentumTransfer * Normal(Velocity)) * float(600), HitLocation, BoneName);
            }
        }
        bSuppressExplosionFX = true;
        ShutDown();
    }
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvProjectile_Bolt.StaticMesh'
    begin object name=StaticMesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'ch_aztec_mummy_002.Mesh.sk_en_spear_01'
        ReplacementPrimitive=none
        AlwaysCheckCollision=true
        BlockActors=false
        BlockZeroExtent=false
    end object
    Mesh=StaticMesh
    AcceptedBoneNames[0]="Hips"
    AcceptedBoneNames[1]="Spine"
    AcceptedBoneNames[2]="Spine1"
    bCanPinToPawns=true
    ExplosionArchetype=EvilExplosion'adv_ps_CustomAction.Archetypes.ar_Spear'
    BaseTrackingStrength=100.0000000
    MomentumTransfer=1.0000000
    MyDamageType=Class'AdvDmgType_TrapBolt'
    // Reference: CylinderComponent'Default__AdvProjectile_Bolt.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=StaticMesh
}