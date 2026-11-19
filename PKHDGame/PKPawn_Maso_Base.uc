class PKPawn_Maso_Base extends PKPawn
    config(Pawn)
    hidecategories(Navigation);

var EvilExplosion ExplosionArchetype;
var EvilExplosion ExplosionTemplate;

function int GetShootAnimPackedIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x53
    if(EvilWeap_Base(Weapon) != none)
    {
        AST = ((EvilWeap_Base(Weapon).bFastRepeater) ? 54 : 58);
    }
    // End:0x6E
    if((AST_GetAnimCount(AST)) < 1)
    {
        return 0;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x92
    if((HitInfo.BoneName == 'Weapon') || ClassIsChildOf(DamageType, Class'PKDmgType_Flamer'))
    {
        super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);        
    }
    else
    {
        // End:0x152
        if(HitInfo.BoneName == 'None')
        {
            super.TakeDamage(int(float(Damage) / FMax(VSize(HitLocation - Mesh.GetBoneLocation('Weapon', 0)) * 0.0050000, 1.0000000)), EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);            
        }
        else
        {
            super.TakeDamage(0, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        }
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local EvilExplosionActor ExplosionActor;
    local Vector ExplosionPosition;

    // End:0x19D
    if(ExplosionArchetype != none)
    {
        ExplosionPosition = Mesh.GetBoneLocation('Gun');
        TryDetachLimb(1, Class'EvilGame.EvilDmgType_Base', ExplosionPosition, vect(0.0000000, 0.0000000, 0.0000000), 'RightForeArm', true);
        TryDetachLimb(1, Class'EvilGame.EvilDmgType_Base', ExplosionPosition, vect(0.0000000, 0.0000000, 0.0000000), 'LeftForeArm', true);
        ExplosionActor = Spawn(Class'EvilGame.EvilExplosionActor', self,, ExplosionPosition, MakeRotator(0, 0, 0));
        ExplosionTemplate = new (self) ExplosionArchetype.Class (ExplosionArchetype);
        ExplosionTemplate.HitNormal = Normal(Vector(Rotation));
        ExplosionTemplate.HitActor = Instigator;
        ExplosionActor.Explode(ExplosionTemplate);
        ExplosionTemplate = none;
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function bool HasValidDamage(int Damage, optional class<DamageType> DamageType)
{
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    EnableGibWhenHPBelowFactor=-59.0000000
    // Reference: StaticMeshComponent'Default__PKPawn_Maso_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_Maso_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    bCanThrowGrenade=true
    CharacterFootStepType=ECharacterFootStepType.CFST_Maso
    DefaultHealth=80.0000000
    GrenadeSocket="MuzzleFlashSocket"
    PawnActionClasses=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_Maso_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_Maso_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Maso_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Maso_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Maso_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_Maso_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_Maso_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_Maso_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_Maso_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    Mass=120.0000000
    // Reference: SkeletalMeshComponent'Default__PKPawn_Maso_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_Maso_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_Maso_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_Maso_Base.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPawn.FaceAudioComponent'
    begin object name="FaceAudioComponent"
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
}