class Emitter extends Actor
    native
    placeable
    hidecategories(lighting);

enum EEmitterState
{
    EEmitterState_Disabled,         // 0
    EEmitterState_Enabled,          // 1
    EEmitterState_Default,          // 2
    EEmitterState_MAX               // 3
};

var() const editconst export editinline ParticleSystemComponent ParticleSystemComponent;
var bool bDestroyOnSystemFinish;
var() bool m_bPatchForBigExplosionRelevancy;
var Emitter.EEmitterState m_eEnableState;
var Emitter.EEmitterState sm_eEnableState;
var transient R6SoundExplosionParams m_SoundExplosionParams;
var transient bool m_bNoNewParticle;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_eEnableState;
}

// Export UEmitter::execSetTemplate(FFrame&, void* const)
native final function SetTemplate(ParticleSystem NewTemplate, optional bool bDestroyOnFinish);

event PostBeginPlay()
{
    PostBeginPlay();
    // End:0x2B
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        LifeSpan = 0.2000000;
    }
    // End:0x4A
    if(ParticleSystemComponent != none)
    {
        ParticleSystemComponent.__OnSystemFinished__Delegate = OnParticleSystemFinished;
    }
    return;
}

function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
    // End:0x14
    if(bDestroyOnSystemFinish)
    {
        LifeSpan = 0.0001000;
    }
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x4C
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_eEnableState = 1;
        NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        ParticleSystemComponent.ActivateSystem();        
    }
    else
    {
        // End:0x98
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_eEnableState = 0;
            NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            ParticleSystemComponent.DeactivateSystem();            
        }
        else
        {
            // End:0x13E
            if(Action.InputLinks[2].bHasImpulse)
            {
                // End:0x10E
                if(ParticleSystemComponent.bSuppressSpawning || ParticleSystemComponent.EmitterInstances.Length == 0)
                {
                    m_eEnableState = 1;
                    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
                    ParticleSystemComponent.ActivateSystem();                    
                }
                else
                {
                    m_eEnableState = 0;
                    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
                    ParticleSystemComponent.DeactivateSystem();
                }
            }
        }
    }
    return;
}

function SetFloatParameter(name ParameterName, float Param)
{
    // End:0x25
    if(ParticleSystemComponent != none)
    {
        ParticleSystemComponent.SetFloatParameter(ParameterName, Param);
    }
    return;
}

function SetVectorParameter(name ParameterName, Vector Param)
{
    // End:0x25
    if(ParticleSystemComponent != none)
    {
        ParticleSystemComponent.SetVectorParameter(ParameterName, Param);
    }
    return;
}

function SetColorParameter(name ParameterName, Color Param)
{
    // End:0x25
    if(ParticleSystemComponent != none)
    {
        ParticleSystemComponent.SetColorParameter(ParameterName, Param);
    }
    return;
}

function SetExtColorParameter(name ParameterName, byte Red, byte Green, byte Blue, byte Alpha)
{
    local Color C;

    // End:0x65
    if(ParticleSystemComponent != none)
    {
        C.R = Red;
        C.G = Green;
        C.B = Blue;
        C.A = Alpha;
        ParticleSystemComponent.SetColorParameter(ParameterName, C);
    }
    return;
}

function SetActorParameter(name ParameterName, Actor Param)
{
    // End:0x25
    if(ParticleSystemComponent != none)
    {
        ParticleSystemComponent.SetActorParameter(ParameterName, Param);
    }
    return;
}

function OnSetParticleSysParam(SeqAct_SetParticleSysParam Action)
{
    local int idx, ParamIdx;

    // End:0x142
    if((ParticleSystemComponent != none) && Action.InstanceParameters.Length > 0)
    {
        idx = 0;
        J0x29:

        // End:0x142 [Loop If]
        if(idx < Action.InstanceParameters.Length)
        {
            // End:0x138
            if(int(Action.InstanceParameters[idx].ParamType) != int(0))
            {
                ParamIdx = ParticleSystemComponent.InstanceParameters.Find('Name', Action.InstanceParameters[idx].Name);
                // End:0xD5
                if(ParamIdx == -1)
                {
                    ParamIdx = ParticleSystemComponent.InstanceParameters.Length;
                    ParticleSystemComponent.InstanceParameters.Length = ParamIdx + 1;
                }
                ParticleSystemComponent.InstanceParameters[ParamIdx] = Action.InstanceParameters[idx];
                // End:0x138
                if(Action.bOverrideScalar)
                {
                    ParticleSystemComponent.InstanceParameters[ParamIdx].Scalar = Action.ScalarValue;
                }
            }
            idx++;
            // [Loop Continue]
            goto J0x29;
        }
    }
    return;
}

function SaveOriginalData()
{
    SaveOriginalData();
    // End:0x3A
    if(ParticleSystemComponent.bAutoActivate)
    {
        m_eEnableState = 1;
        NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    }
    sm_eEnableState = m_eEnableState;
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    m_eEnableState = sm_eEnableState;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    switch(m_eEnableState)
    {
        // End:0x49
        case 1:
            ParticleSystemComponent.ActivateSystem();
            // End:0x5E
            break;
        // End:0xFFFF
        default:
            ParticleSystemComponent.DeactivateSystem();
            // End:0x5E
            break;
            break;
    }
    return;
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__Emitter.ParticleSystemComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ParticleSystemComponent0" class=Class'ParticleSystemComponent'
        SecondsBeforeInactive=1.0000000
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    m_eEnableState=2
    bNoDelete=true
    bHardAttach=true
    bGameRelevant=true
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__Emitter.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerResource.S_Emitter'
        bIsScreenSizeScaled=true
        ScreenSize=0.0025000
    end object
    Components[0]=Sprite
    Components[1]=ParticleSystemComponent0
    // Reference: ArrowComponent'Default__Emitter.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
        ArrowColor=(R=0,G=255,B=128,A=255)
        ArrowSize=1.5000000
    end object
    Components[2]=ArrowComponent0
    RemoteRole=1
    TickGroup=1
    NetUpdateFrequency=0.1000000
}