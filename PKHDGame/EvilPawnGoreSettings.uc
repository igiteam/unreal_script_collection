class EvilPawnGoreSettings extends Object;

struct _GoreBreakableJoints
{
    var() const editconst EvilTypes.EBodyParts Type;
    var() name BreakableConstraintName;
    var() float MomentumScale;
    var() float DamageMod;
    var() array<EvilGib> Gibs;
    var() array<int> MaterialsIndicesToHide;
    var() array<int> BonesIndicesToHide;
    var() bool bHeadShot;
    var() ParticleSystem BloodFountainFX;
    var() ParticleSystem BloodFountainFX_NoGore;
    var() ParticleSystem DetachFX;
    var() ParticleSystem DetachFX_NoGore;
    var() SoundCue DetachSound;
    var() int Health;
    var() bool bShouldPlayDeathAnimationToRagdoll;
    var() int RelyOnMaterialIndex;

    structdefaultproperties
    {
        Type=EBodyParts.BP_Head
        BreakableConstraintName="None"
        MomentumScale=0.0100000
        DamageMod=1.0000000
        Gibs=none
        MaterialsIndicesToHide=none
        BonesIndicesToHide=none
        bHeadShot=false
        BloodFountainFX=none
        BloodFountainFX_NoGore=none
        DetachFX=none
        DetachFX_NoGore=none
        DetachSound=none
        Health=100
        bShouldPlayDeathAnimationToRagdoll=true
        RelyOnMaterialIndex=-1
    }
};

struct LodMaterialInfo
{
    var() int MaterialIndex;
    var() Material LodMaterial;

    structdefaultproperties
    {
        MaterialIndex=0
        LodMaterial=none
    }
};

var() EvilGoreToDmgTypeSettings Parameters;
var() array<_GoreBreakableJoints> GoreBreakableJoints;
var() array<name> AdditionalInstantGibConstraintNames;
var() int GoreMeshLOD;
var() PhysicsAsset GoreMeshPhysicsAsset;
var() SkeletalMesh AlternateSkeletalMesh;
var() array<LodMaterialInfo> GoreLodMaterials;
var() ParticleSystem InstantGibParticle;
var() float InstantGibParticleScale;

simulated function GetClassification(class<EvilDmgType_Base> EvilDmgType, out _PawnParameters retParameters, out _GibsParameters gibRetParameters)
{
    local ParametersBallistic Ballistic;
    local ParametersExplosion Explosion;

    // End:0x11
    if(EvilDmgType == none)
    {
        return;
    }
    // End:0x46E
    if(int(EvilDmgType.default.ImpactTypeBallisticID) != int(0))
    {
        // End:0xBB
        if(Parameters.BallisticParameters[int(EvilDmgType.default.ImpactTypeBallisticID)].bGetParametersFromDefault)
        {
            Ballistic = Parameters.DefaultBallisticParameters;            
        }
        else
        {
            Ballistic = Parameters.BallisticParameters[int(EvilDmgType.default.ImpactTypeBallisticID)];
        }
        retParameters.bIsValid = true;
        retParameters.bRagdoll = Ballistic.PawnParameters.bRagdoll;
        retParameters.bSpawnGibs = Ballistic.PawnParameters.bSpawnGibs;
        retParameters.InstaGibChance = Ballistic.PawnParameters.InstaGibChance;
        retParameters.InstaGibRange = Ballistic.PawnParameters.InstaGibRange;
        retParameters.HitClassification = Ballistic.PawnParameters.HitClassification;
        retParameters.DeathAnimClassification = Ballistic.PawnParameters.DeathAnimClassification;
        retParameters.RagdollMomentumScale = Ballistic.PawnParameters.RagdollMomentumScale;
        gibRetParameters.AngularVariationFactor = Ballistic.GibParameters.AngularVariationFactor;
        gibRetParameters.LinearVariationFactor = Ballistic.GibParameters.LinearVariationFactor;
        gibRetParameters.MomentumScale = Ballistic.GibParameters.MomentumScale;
        gibRetParameters.UpVectorScale = Ballistic.GibParameters.UpVectorScale;        
    }
    else
    {
        // End:0x8CB
        if(int(EvilDmgType.default.ImpactTypeExplosionID) != int(0))
        {
            // End:0x518
            if(Parameters.ExplosionParameters[int(EvilDmgType.default.ImpactTypeExplosionID)].bGetParametersFromDefault)
            {
                Explosion = Parameters.DefaultExplosionParameters;                
            }
            else
            {
                Explosion = Parameters.ExplosionParameters[int(EvilDmgType.default.ImpactTypeExplosionID)];
            }
            retParameters.bIsValid = true;
            retParameters.bRagdoll = Explosion.PawnParameters.bRagdoll;
            retParameters.bSpawnGibs = Explosion.PawnParameters.bSpawnGibs;
            retParameters.InstaGibChance = Explosion.PawnParameters.InstaGibChance;
            retParameters.InstaGibRange = Explosion.PawnParameters.InstaGibRange;
            retParameters.HitClassification = Explosion.PawnParameters.HitClassification;
            retParameters.DeathAnimClassification = Explosion.PawnParameters.DeathAnimClassification;
            retParameters.RagdollMomentumScale = Explosion.PawnParameters.RagdollMomentumScale;
            gibRetParameters.AngularVariationFactor = Explosion.GibParameters.AngularVariationFactor;
            gibRetParameters.LinearVariationFactor = Explosion.GibParameters.LinearVariationFactor;
            gibRetParameters.MomentumScale = Explosion.GibParameters.MomentumScale;
            gibRetParameters.UpVectorScale = Explosion.GibParameters.UpVectorScale;            
        }
        else
        {
            retParameters.bIsValid = false;
        }
    }
    //return;    
}

private static final function EvilGib SpawnOneGib(EvilGib GibArchetype, Actor Owner, Vector SpawnLocation)
{
    local EvilGib Gib;

    Gib = Owner.Spawn(GibArchetype.Class, Owner,, SpawnLocation, Owner.Rotation, GibArchetype);
    Gib.SetDrawScale(Owner.DrawScale);
    return Gib;
    //return ReturnValue;    
}

private static final function bool SpawnGibsFromBallistic(const out EvilGoreToDmgTypeSettings GibsInfo, const out array<EvilGib> Gibs, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation, Vector Momentum, Actor Owner)
{
    local EvilGib Gib;
    local int I;
    local ParametersBallistic BallisticParameters;

    // End:0x81
    if(GibsInfo.BallisticParameters[int(EvilDamageType.default.ImpactTypeBallisticID)].bGetParametersFromDefault)
    {
        BallisticParameters = GibsInfo.DefaultBallisticParameters;        
    }
    else
    {
        BallisticParameters = GibsInfo.BallisticParameters[int(EvilDamageType.default.ImpactTypeBallisticID)];
    }
    // End:0x101
    if(!BallisticParameters.PawnParameters.bSpawnGibs)
    {
        return false;
    }
    I = 0;
    J0x10C:

    // End:0x380 [Loop If]
    if(I < Gibs.Length)
    {
        Gib = SpawnOneGib(Gibs[I], Owner, HitLocation);
        Gib.Velocity = (((Momentum * BallisticParameters.GibParameters.MomentumScale) * Gib.MomentumScale) + (VRand() * BallisticParameters.GibParameters.LinearVariationFactor)) + (vect(0.0000000, 0.0000000, 1.0000000) * BallisticParameters.GibParameters.UpVectorScale);
        Gib.GibMeshComp.WakeRigidBody();
        Gib.GibMeshComp.SetRBLinearVelocity(Gib.Velocity, false);
        // End:0x372
        if(BallisticParameters.GibParameters.AngularVariationFactor > float(0))
        {
            Gib.GibMeshComp.SetRBAngularVelocity(VRand() * BallisticParameters.GibParameters.AngularVariationFactor, false);
        }
        I++;
        // [Loop Continue]
        goto J0x10C;
    }
    return true;
    //return ReturnValue;    
}

private static final function bool SpawnGibsFromExplosion(const out EvilGoreToDmgTypeSettings GibsInfo, const out array<EvilGib> Gibs, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation, Vector Momentum, Actor Owner)
{
    local EvilGib Gib;
    local int I;
    local ParametersExplosion ExplosionParameters;
    local editinline ParticleSystemComponent Effect;

    // End:0x81
    if(GibsInfo.ExplosionParameters[int(EvilDamageType.default.ImpactTypeExplosionID)].bGetParametersFromDefault)
    {
        ExplosionParameters = GibsInfo.DefaultExplosionParameters;        
    }
    else
    {
        ExplosionParameters = GibsInfo.ExplosionParameters[int(EvilDamageType.default.ImpactTypeExplosionID)];
    }
    // End:0x101
    if(!ExplosionParameters.PawnParameters.bSpawnGibs)
    {
        return false;
    }
    I = 0;
    J0x10C:

    // End:0x409 [Loop If]
    if(I < Gibs.Length)
    {
        Gib = SpawnOneGib(Gibs[I], Owner, HitLocation);
        Gib.Velocity = ((Momentum * ExplosionParameters.GibParameters.MomentumScale) + (VRand() * ExplosionParameters.GibParameters.LinearVariationFactor)) + (vect(0.0000000, 0.0000000, 1.0000000) * ExplosionParameters.GibParameters.UpVectorScale);
        Gib.GibMeshComp.WakeRigidBody();
        Gib.GibMeshComp.SetRBLinearVelocity(Gib.Velocity, false);
        // End:0x35C
        if(EvilDamageType.default.GibTrail != none)
        {
            Effect = new (Gib) Class'UTParticleSystemComponent';
            Effect.SetTemplate(EvilDamageType.default.GibTrail);
            Gib.AttachComponent(Effect);
        }
        // End:0x3FB
        if(ExplosionParameters.GibParameters.AngularVariationFactor > float(0))
        {
            Gib.GibMeshComp.SetRBAngularVelocity(VRand() * ExplosionParameters.GibParameters.AngularVariationFactor, false);
        }
        I++;
        // [Loop Continue]
        goto J0x10C;
    }
    return true;
    //return ReturnValue;    
}

static function bool SpawnGibs(const out EvilGoreToDmgTypeSettings GibsInfo, const out array<EvilGib> Gibs, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation, Vector Momentum, Actor Owner)
{
    // End:0x1B
    if(EvilDamageType == none)
    {
        ScriptTrace();
        return false;
    }
    // End:0x88
    if(int(EvilDamageType.default.ImpactTypeBallisticID) != int(0))
    {
        return SpawnGibsFromBallistic(GibsInfo, Gibs, EvilDamageType, HitLocation, Momentum, Owner);        
    }
    else
    {
        // End:0xF2
        if(int(EvilDamageType.default.ImpactTypeExplosionID) != int(0))
        {
            return SpawnGibsFromExplosion(GibsInfo, Gibs, EvilDamageType, HitLocation, Momentum, Owner);
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    GoreBreakableJoints[0]=(Type=EBodyParts.BP_Head,BreakableConstraintName="None",MomentumScale=0.0100000,DamageMod=1.0000000,Gibs=none,MaterialsIndicesToHide=none,BonesIndicesToHide=none,bHeadShot=false,BloodFountainFX=none,BloodFountainFX_NoGore=none,DetachFX=none,DetachFX_NoGore=none,DetachSound=none,Health=100,bShouldPlayDeathAnimationToRagdoll=true,RelyOnMaterialIndex=-1)
    GoreBreakableJoints[1]=(Type=EBodyParts.BP_Torso,BreakableConstraintName="None",MomentumScale=0.0100000,DamageMod=1.0000000,Gibs=none,MaterialsIndicesToHide=none,BonesIndicesToHide=none,bHeadShot=false,BloodFountainFX=none,BloodFountainFX_NoGore=none,DetachFX=none,DetachFX_NoGore=none,DetachSound=none,Health=100,bShouldPlayDeathAnimationToRagdoll=true,RelyOnMaterialIndex=-1)
    GoreBreakableJoints[2]=(Type=EBodyParts.BP_LeftLeg,BreakableConstraintName="None",MomentumScale=0.0100000,DamageMod=1.0000000,Gibs=none,MaterialsIndicesToHide=none,BonesIndicesToHide=none,bHeadShot=false,BloodFountainFX=none,BloodFountainFX_NoGore=none,DetachFX=none,DetachFX_NoGore=none,DetachSound=none,Health=100,bShouldPlayDeathAnimationToRagdoll=true,RelyOnMaterialIndex=-1)
    GoreBreakableJoints[3]=(Type=EBodyParts.BP_RightLeg,BreakableConstraintName="None",MomentumScale=0.0100000,DamageMod=1.0000000,Gibs=none,MaterialsIndicesToHide=none,BonesIndicesToHide=none,bHeadShot=false,BloodFountainFX=none,BloodFountainFX_NoGore=none,DetachFX=none,DetachFX_NoGore=none,DetachSound=none,Health=100,bShouldPlayDeathAnimationToRagdoll=true,RelyOnMaterialIndex=-1)
    GoreBreakableJoints[4]=(Type=EBodyParts.BP_LeftArm,BreakableConstraintName="None",MomentumScale=0.0100000,DamageMod=1.0000000,Gibs=none,MaterialsIndicesToHide=none,BonesIndicesToHide=none,bHeadShot=false,BloodFountainFX=none,BloodFountainFX_NoGore=none,DetachFX=none,DetachFX_NoGore=none,DetachSound=none,Health=100,bShouldPlayDeathAnimationToRagdoll=true,RelyOnMaterialIndex=-1)
    GoreBreakableJoints[5]=(Type=EBodyParts.BP_RightArm,BreakableConstraintName="None",MomentumScale=0.0100000,DamageMod=1.0000000,Gibs=none,MaterialsIndicesToHide=none,BonesIndicesToHide=none,bHeadShot=false,BloodFountainFX=none,BloodFountainFX_NoGore=none,DetachFX=none,DetachFX_NoGore=none,DetachSound=none,Health=100,bShouldPlayDeathAnimationToRagdoll=true,RelyOnMaterialIndex=-1)
    GoreMeshLOD=1
    InstantGibParticleScale=1.0000000
}