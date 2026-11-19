class AdvProjectile_MummyBolt extends EvilProjectile_Base
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
    // End:0x899
    if(P != none)
    {
        Class'EvilGame.EvilWeap_Base'.static.FindNearestBone(P, HitLocation, BoneName, besthitloc, AcceptedBoneNames);
        HitLocation = besthitloc;
        bonePos = P.Mesh.GetBoneLocation(BoneName, 0);
        dirFromHitLocToBonePos = bonePos - HitLocation;
        dirFromHitLocToBonePos *= 0.8000000;
        HitLocation += dirFromHitLocToBonePos;
        P.Mesh.TransformToBoneSpace(BoneName, HitLocation, Rotation, boneSpacePos, boneSpaceRot);
        // End:0x3B0
        if((P.CanPlayDirectHitByProjectile() && bCanPinToPawns) && !ClassIsChildOf(P.Class, Class'AdvPlayerPawn'))
        {
            SMC = new (Other) Class'AdvStaticMeshComponent_Bolt';
            SMC.SetStaticMesh(Mesh.StaticMesh);
            SMC.SetLightEnvironment(P.LightEnvironment);
            SMC.SetScale(DrawScale);
            SMC.SetAbsolute(,,, true);
            P.Mesh.AttachComponent(SMC, BoneName, boneSpacePos, boneSpaceRot);
            P.SetTimer(AdvPawn(P).MummyBoltLifeTime, false, 'DestroyMummyBolt');
        }
        // End:0x4FB
        if(EqualEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none)) && P.CanPlayHitImpactEffects())
        {
            ImpactEffectComponent = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(ParticleSystem'ps_Blood.Effects.ps_Bloodhit_RedKolek');
            ImpactEffectComponent.SetRotation(Rotation);
            P.Mesh.AttachComponent(ImpactEffectComponent, BoneName, boneSpacePos);
            ImpactEffectComponent.ActivateSystem();
        }
        // End:0x6DD
        if((float(P.Health) - ((NotEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none))) ? float(DamageVSPlayer) : Damage)) <= float(0))
        {
            // End:0x622
            if(AdvPlayerControllerMP(P.Controller) != none)
            {
                AdvPlayerControllerMP(P.Controller).bKilledByTrap = true;
                AdvPlayerControllerMP(P.Controller).TrapKiller = AdvPlayerControllerMP(InstigatorController);                
            }
            else
            {
                // End:0x6DD
                if(AdvAIController(P.Controller) != none)
                {
                    AdvAIController(P.Controller).bKilledByTrap = true;
                    AdvAIController(P.Controller).TrapKiller = AdvPlayerControllerMP(InstigatorController);
                }
            }
        }
        Other.TakeDamage(int(((NotEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none))) ? float(DamageVSPlayer) : Damage)), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
        // End:0x883
        if((P.Health <= 0) && EqualEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none)))
        {
            // End:0x883
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
    // Reference: StaticMeshComponent'Default__AdvProjectile_MummyBolt.StaticMesh'
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
    ExplosionArchetype=EvilExplosion'adv_ps_CustomAction.Archetypes.ar_MummyBolt'
    BaseTrackingStrength=100.0000000
    MomentumTransfer=1.0000000
    MyDamageType=Class'AdvDmgType_TrapBolt'
    // Reference: CylinderComponent'Default__AdvProjectile_MummyBolt.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=StaticMesh
}