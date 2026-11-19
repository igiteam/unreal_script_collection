class AdvFlashlight_GlowablePoint_base extends AdvFlashlight_GlowableElement_base
    abstract
    hidecategories(Navigation);

var int ConnectedPointsCount;
var ParticleSystem BeamTemplate;
var export editinline array<export editinline ParticleSystemComponent> BeamEmitters;

simulated function AddBeamEmitterTo(DynamicSMActor DynamicActor)
{
    local int I;

    // End:0x284
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        I = 0;
        J0x34:

        // End:0x284 [Loop If]
        if(I < ConnectedPointsCount)
        {
            // End:0x276
            if(BeamEmitters[I] == none)
            {
                // End:0x273
                if(BeamTemplate != none)
                {
                    BeamEmitters[I] = new (Outer) Class'EvilGame.UTParticleSystemComponent';
                    BeamEmitters[I].SetDepthPriorityGroup(2);
                    BeamEmitters[I].SetTemplate(BeamTemplate);
                    BeamEmitters[I].SetHidden(false);
                    BeamEmitters[I].SetIgnoreOwnerHidden(true);
                    self.AttachComponent(BeamEmitters[I]);
                    BeamEmitters[I].SetRotation(Rotator(DynamicActor.Location - Location));
                    BeamEmitters[I].SetVectorParameter('LinkBeamEnd', DynamicActor.Location);
                    BeamEmitters[I].SetScale(0.1000000);
                    BeamEmitters[I].DeactivateSystem();
                }
                // [Explicit Break]
                goto J0x284;
            }
            ++I;
            // [Loop Continue]
            goto J0x34;
        }
    }
    J0x284:

    //return;    
}

function ActivateBeams()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x74 [Loop If]
    if(I < BeamEmitters.Length)
    {
        // End:0x66
        if(BeamEmitters[I] != none)
        {
            BeamEmitters[I].ActivateSystem();
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    bIsBeamEmitterActive = true;
    //return;    
}

function DeactivateBeams()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x73 [Loop If]
    if(I < BeamEmitters.Length)
    {
        // End:0x65
        if(BeamEmitters[I] != none)
        {
            BeamEmitters[I].DeactivateSystem();
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    bIsBeamEmitterActive = false;
    //return;    
}

simulated function TurnOff()
{
    super.TurnOff();
    DeactivateBeams();
    //return;    
}

defaultproperties
{
    // Reference: AudioComponent'Default__AdvFlashlight_GlowablePoint_base.LightAudioComponent0'
    begin object name=LightAudioComponent0
    end object
    LightSoundComponent=LightAudioComponent0
    // Reference: AudioComponent'Default__AdvFlashlight_GlowablePoint_base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    // Reference: ParticleSystemComponent'Default__AdvFlashlight_GlowablePoint_base.FireParticles'
    begin object name=FireParticles
        ReplacementPrimitive=none
    end object
    Glow=FireParticles
    // Reference: StaticMeshComponent'Default__AdvFlashlight_GlowablePoint_base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvFlashlight_GlowablePoint_base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvFlashlight_GlowablePoint_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=FireParticles
    Components[3]=LightAudioComponent0
    Components[4]=SizzleAudioComponent0
    CollisionComponent=StaticMeshComponent0
}