class PKProjectile_SoulSawCombo_Base extends EvilProjectile_Pinnable_Base
    abstract
    hidecategories(Navigation);

var() export editinline SkeletalMeshComponent SkelMesh;

simulated function RepInit()
{
    super.RepInit();
    SkelMesh.PlayAnim('Spin',, true);
    //return;    
}

simulated function SpawnFlightEffects()
{
    // End:0x7A
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        super(EvilProjectile_Base).SpawnFlightEffects();
        // End:0x7A
        if(ProjEffects != none)
        {
            ProjEffects.SetRotation(MakeRotator(0, 0, int(float(90) * 182.0444000)));
        }
    }
    //return;    
}

simulated function ReSpawnFlightEffects()
{
    // End:0x7A
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        super(EvilProjectile_Base).ReSpawnFlightEffects();
        // End:0x7A
        if(ProjEffects != none)
        {
            ProjEffects.SetRotation(MakeRotator(0, 0, int(float(90) * 182.0444000)));
        }
    }
    //return;    
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
    local PKPawn Victim;
    local int CaptureCount;

    super(EvilProjectile_Base).SpawnExplosionEffects(HitLocation, HitNormal);
    // End:0x50
    if(bInWater && ExplosionWaterArchetype != none)
    {
        ExplosionTemplate = ExplosionWaterArchetype;        
    }
    else
    {
        ExplosionTemplate = ExplosionArchetype;
    }
    SkelMesh.PlayAnim('Spin_Stop',,, false);
    CaptureCount = 0;
    // End:0x243
    foreach CollidingActors(Class'PKPawn', Victim, ExplosionTemplate.DamageRadius, HitLocation + (HitNormal * float(20)), ExplosionTemplate.bUseOverlapCheck)
    {
        // End:0x22F
        if((EvilAIController(Victim.Controller) != none) && Victim.IsAliveAndWell())
        {
            // End:0x22F
            if(Victim.SetCapturedEnemy(20.0000000, Instigator))
            {
                Victim.StartFullBodyHitEffect(2, true);
                CaptureCount++;
                // End:0x22F
                if((PainGRI_SP(WorldInfo.GRI) != none) && PainGRI_SP(WorldInfo.GRI).ChapterNum <= 4)
                {
                    // End:0x243
                    break;
                }
            }
        }
        // End:0x242
        if(CaptureCount > 2)
        {
            // End:0x243
            break;
        }        
    }    
    ExplosionTemplate = none;
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PKProjectile_SoulSawCombo_Base.SkeletalMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMesh'
    begin object name="SkeletalMesh" class=Class'Engine.SkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    SkelMesh=SkeletalMesh
    // Reference: EvilDissolvingStaticMeshComponent'Default__PKProjectile_SoulSawCombo_Base.StaticMesh'
    // Archetype: EvilDissolvingStaticMeshComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    CustomGravityScaling=0.5000000
    Speed=4000.0000000
    MaxSpeed=4000.0000000
    MyDamageType=Class'PKDmgType_SoulSawCombo'
    // Reference: CylinderComponent'Default__PKProjectile_SoulSawCombo_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    Components[2]=SkeletalMesh
    CollisionComponent=CollisionCylinder
}