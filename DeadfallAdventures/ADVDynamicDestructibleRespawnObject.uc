class ADVDynamicDestructibleRespawnObject extends ADVDynamicDestructibleObject
    hidecategories(Navigation);

var() float RespawnTime;
var() ParticleSystem RespawnParticle;
var float FadeInState;

simulated event PostBeginPlay()
{
    local AdvGRI GRI;

    super.PostBeginPlay();
    // End:0xA7
    if(int(Role) == int(ROLE_Authority))
    {
        GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
        // End:0xA7
        if((GRI != none) && GRI.bTraps == false)
        {
            bCanBeDamaged = false;
        }
    }
    //return;    
}

protected simulated function ApplyDamageMod(int ModIdx)
{
    super(EvilDynamicDestructibleObject).ApplyDamageMod(ModIdx);
    // End:0x87
    if(int(WorldInfo.NetMode) < int(NM_Client))
    {
        // End:0x87
        if(ModIdx == (DamageMods.Length - 1))
        {
            // End:0x87
            if(!IsTimerActive('Reset'))
            {
                SetTimer(RespawnTime, false, 'Reset');
            }
        }
    }
    //return;    
}

simulated function SetFloatMaterialsParam(name ParamName, float paramVal)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x6C [Loop If]
    if(I < InstanceMaterials.Length)
    {
        InstanceMaterials[I].SetScalarParameterValue(ParamName, paramVal);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function UnDestroy()
{
    super.UnDestroy();
    FadeInState = 0.0000000;
    SetFloatMaterialsParam('DissolveAmount', FadeInState);
    // End:0x8F
    if(RespawnParticle != none)
    {
        WorldInfo.MyEmitterPool.SpawnEmitter(RespawnParticle, Location);
    }
    SetTimer(0.0500000, true, 'FadeIn');
    //return;    
}

simulated function FadeIn()
{
    FadeInState += (float(2) * WorldInfo.DeltaSeconds);
    SetFloatMaterialsParam('DissolveAmount', FadeInState);
    // End:0x70
    if(FadeInState > float(1))
    {
        ClearTimer('FadeIn');
    }
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x13
    if(!bCanBeDamaged)
    {
        return;
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

defaultproperties
{
    RespawnTime=10.0000000
    // Reference: AudioComponent'Default__ADVDynamicDestructibleRespawnObject.BurningAudioComponent0'
    begin object name=BurningAudioComponent0
    end object
    BurningAudioComp=BurningAudioComponent0
    // Reference: StaticMeshComponent'Default__ADVDynamicDestructibleRespawnObject.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__ADVDynamicDestructibleRespawnObject.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: SkeletalMeshComponent'Default__ADVDynamicDestructibleRespawnObject.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__ADVDynamicDestructibleRespawnObject.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__ADVDynamicDestructibleRespawnObject.MyLightEnvironment'
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__ADVDynamicDestructibleRespawnObject.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: RB_RadialImpulseComponent'Default__ADVDynamicDestructibleRespawnObject.ImpulseComponent0'
    begin object name=ImpulseComponent0
        ReplacementPrimitive=none
    end object
    RadialImpulseComponent=ImpulseComponent0
    // Reference: SpriteComponent'Default__ADVDynamicDestructibleRespawnObject.Sprite'
    begin object name=Sprite
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=MyLightEnvironment
    Components[2]=SkeletalMeshComponent0
    Components[3]=StaticMeshComponent0
    Components[4]=BurningAudioComponent0
    bCanBeDamaged=true
    CollisionComponent=StaticMeshComponent0
}