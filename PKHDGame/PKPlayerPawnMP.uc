class PKPlayerPawnMP extends PKPlayerPawn
    config(Pawn)
    hidecategories(Navigation);

var float ShockTimeRemaining;

function ThrowWeaponOnDeath()
{
    ThrowActiveWeapon();
    //return;    
}

function StartPlayerShock(float Duration, optional float speedReductionScale = 1.0000000)
{
    ShockTimeRemaining = Duration;
    ClientStartPlayerShock();
    bJumpCapable = false;
    bCanBunnyHop = false;
    bIsBunnyHop = false;
    // End:0xA3
    if((int(Physics) == int(1)) && GameClass != none)
    {
        GroundSpeed = GameClass.default.PlayerSpeed * speedReductionScale;
    }
    //return;    
}

reliable client simulated function ClientStartPlayerShock(optional float speedReductionScale = 1.0000000)
{
    // End:0x99
    if(int(Role) < int(ROLE_Authority))
    {
        bJumpCapable = false;
        bCanBunnyHop = false;
        bIsBunnyHop = false;
        // End:0x99
        if((int(Physics) == int(1)) && GameClass != none)
        {
            GroundSpeed = GameClass.default.PlayerSpeed * speedReductionScale;
        }
    }
    GetPC().GetPlayerHitEffects().PlayCameraShakes(0.5000000);
    //return;    
}

function StopPlayerShock()
{
    ShockTimeRemaining = 0.0000000;
    ClientStopPlayerShock();
    bJumpCapable = true;
    // End:0x72
    if((int(Physics) == int(1)) && GameClass != none)
    {
        GroundSpeed = GameClass.default.PlayerSpeed;
    }
    //return;    
}

reliable client simulated function ClientStopPlayerShock()
{
    // End:0x6D
    if(int(Role) < int(ROLE_Authority))
    {
        bJumpCapable = true;
        // End:0x6D
        if((int(Physics) == int(1)) && GameClass != none)
        {
            GroundSpeed = GameClass.default.PlayerSpeed;
        }
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x54
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x54
        if(ShockTimeRemaining > float(0))
        {
            ShockTimeRemaining -= DeltaTime;
            // End:0x54
            if(ShockTimeRemaining <= float(0))
            {
                StopPlayerShock();
            }
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local class<PKDmgType_Base> PKDmg;

    // End:0xC7
    if(int(Role) == int(ROLE_Authority))
    {
        PKDmg = class<PKDmgType_Base>(DamageType);
        // End:0xC7
        if(((PKDmg != none) && PKDmg.default.ShockPlayerDuration > float(0)) && CanBeDamagedBy(EventInstigator))
        {
            StartPlayerShock(PKDmg.default.ShockPlayerDuration, PKDmg.default.ShockPlayerSpeedReductionScale);
        }
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

defaultproperties
{
    bThrowSoul=true
    bThrowRedSoul=true
    RedSoulItemClass=Class'PainItem_PlayerEnergyRed'
    // Reference: StaticMeshComponent'Default__PKPlayerPawnMP.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPlayerPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPlayerPawnMP.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPlayerPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    // Reference: DynamicLightEnvironmentComponent'Default__PKPlayerPawnMP.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPlayerPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPlayerPawnMP.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__PKPlayerPawnMP.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPlayerPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPlayerPawnMP.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPlayerPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPlayerPawnMP.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPlayerPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPlayerPawnMP.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPlayerPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPlayerPawnMP.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPlayerPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPlayerPawnMP.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPlayerPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPlayerPawnMP.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPlayerPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__PKPlayerPawnMP.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPlayerPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPlayerPawnMP.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPlayerPawnMP.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPlayerPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPlayerPawnMP.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPlayerPawn.FaceAudioComponent'
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
}