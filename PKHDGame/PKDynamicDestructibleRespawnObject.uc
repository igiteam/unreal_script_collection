class PKDynamicDestructibleRespawnObject extends PKDynamicDestructibleObject
    hidecategories(Navigation);

var() float RespawnTime;
var() ParticleSystem RespawnParticle;
var array<MaterialInstanceConstant> InstanceMaterials;
var float FadeInState;

simulated event PostBeginPlay()
{
    local int I, numElems;

    super(EvilDynamicDestructibleObject).PostBeginPlay();
    numElems = StaticMeshComponent.GetNumElements();
    I = 0;
    J0x3E:

    // End:0x98 [Loop If]
    if(I < numElems)
    {
        InstanceMaterials.AddItem(StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I));
        I++;
        // [Loop Continue]
        goto J0x3E;
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
    super(EvilDynamicDestructibleObject).UnDestroy();
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

defaultproperties
{
    RespawnTime=10.0000000
    // Reference: StaticMeshComponent'Default__PKDynamicDestructibleRespawnObject.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Default__PKDynamicDestructibleObject.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKDynamicDestructibleRespawnObject.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: SkeletalMeshComponent'Default__PKDynamicDestructibleRespawnObject.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKDynamicDestructibleObject.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: AnimNodeSequence'Default__PKDynamicDestructibleRespawnObject.SkeletalMeshComponent0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PKDynamicDestructibleObject.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKDynamicDestructibleRespawnObject.MyLightEnvironment'
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PKDynamicDestructibleRespawnObject.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKDynamicDestructibleObject.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: RB_RadialImpulseComponent'Default__PKDynamicDestructibleRespawnObject.ImpulseComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ImpulseComponent0'
    // Archetype: RB_RadialImpulseComponent'Default__PKDynamicDestructibleObject.ImpulseComponent0'
    begin object name="ImpulseComponent0"
        ReplacementPrimitive=none
    end object
    RadialImpulseComponent=ImpulseComponent0
    // Reference: SpriteComponent'Default__PKDynamicDestructibleRespawnObject.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Sprite'
    // Archetype: SpriteComponent'Default__PKDynamicDestructibleObject.Sprite'
    begin object name="Sprite"
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=MyLightEnvironment
    Components[2]=SkeletalMeshComponent0
    Components[3]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}