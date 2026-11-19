class PKItem_Boss_Alastor_Statue_Base extends PKDestructibleObject
    hidecategories(Navigation);

var() export editinline SkeletalMeshComponent StatueMesh;
var EvilPawn HealTarget;
var int LoopIndex;
var export editinline ParticleSystemComponent Particles;
var repnotify bool bParticlesActive;

replication
{
    // Pos:0x000
    if(bNetDirty)
        HealTarget, bParticlesActive;
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x46
        case 'bParticlesActive':
            // End:0x39
            if(bParticlesActive)
            {
                ShowParticles();                
            }
            else
            {
                HideParticles();
            }
            // End:0x5C
            break;
        // End:0xFFFF
        default:
            super(EvilDestructibleObject).ReplicatedEvent(VarName);
            break;
    }
    //return;    
}

function Heal(EvilPawn _HealTarget)
{
    HealTarget = _HealTarget;
    // End:0x2E
    if(IsAlive())
    {
        GotoState('Healing');
    }
    //return;    
}

simulated function ShowParticles()
{
    // End:0x20
    if(int(Role) == int(ROLE_Authority))
    {
        bParticlesActive = true;
    }
    Particles = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'ps_ch_Alastor.Effects.ps_ch_EnergyRevival', Location + (vect(0.0000000, 0.0000000, 1.0000000) * float(640)));
    Particles.SetRotation(Rotator(HealTarget.Location - Location));
    Particles.SetVectorParameter('LinkBeamEnd', HealTarget.Mesh.GetBoneLocation('Spine'));
    Particles.SetScale(1.0000000);
    //return;    
}

simulated function HideParticles()
{
    // End:0x20
    if(int(Role) == int(ROLE_Authority))
    {
        bParticlesActive = false;
    }
    Particles.DeactivateSystem();
    //return;    
}

simulated event Destroyed()
{
    Particles.DeactivateSystem();
    //return;    
}

state Healing
{
    event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        HideParticles();
        super(EvilDestructibleObject).TakeDamage(64, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        //return;        
    }
Begin:

    bLimitDamageTypes = false;
    ShowParticles();
    Sleep(0.1000000);
    PKPawn_Boss_Alastor_Base(HealTarget).ShowFullBodyHealEffect();
    LoopIndex = 0;
    J0x51:

    // End:0x111 [Loop If]
    if(LoopIndex < 75)
    {
        // End:0x73
        if(!IsAlive())
        {
            // [Explicit Break]
            goto J0x111;
        }
        Particles.SetVectorParameter('LinkBeamEnd', HealTarget.Mesh.GetBoneLocation('Spine'));
        HealTarget.Health += 5;
        Sleep(0.0700000);
        LoopIndex++;
        // [Loop Continue]
        goto J0x51;
    }
    J0x111:

    bLimitDamageTypes = true;
    HideParticles();
    stop;                    
}

defaultproperties
{
    // Reference: AudioComponent'Default__PKItem_Boss_Alastor_Statue_Base.AmbientSoundComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'AmbientSoundComponent0'
    // Archetype: AudioComponent'Default__PKDestructibleObject.AmbientSoundComponent0'
    begin object name="AmbientSoundComponent0"
    end object
    AmbientSoundComponent=AmbientSoundComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PKItem_Boss_Alastor_Statue_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKDestructibleObject.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: DynamicLightEnvironmentComponent'Default__PKItem_Boss_Alastor_Statue_Base.MyLightEnvironment2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment2'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKDestructibleObject.MyLightEnvironment2'
    begin object name="MyLightEnvironment2"
    end object
    LightEnvironmentToUseForActorSpawnParams=MyLightEnvironment2
}