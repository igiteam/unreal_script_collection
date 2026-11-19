class UTEmitter extends Emitter
    hidecategories(Navigation);

static final function ParticleSystem GetTemplateForDistance(const out array<DistanceBasedParticleTemplate> TemplateList, Vector SpawnLocation, WorldInfo WI)
{
    local PlayerController PC;
    local int I;
    local float Dist;

    // End:0x3D
    if((TemplateList.Length == 0) || int(WI.NetMode) == int(NM_DedicatedServer))
    {
        return none;
    }
    Dist = TemplateList[0].MinDistance * 10.0000000;
    // End:0x116
    foreach WI.LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        Dist = FMin(Dist, VSize(PC.ViewTarget.Location - SpawnLocation) * PC.LODDistanceFactor);        
    }    
    I = 0;
    J0x122:

    // End:0x1A3 [Loop If]
    if(I < TemplateList.Length)
    {
        // End:0x195
        if(Dist >= TemplateList[I].MinDistance)
        {
            return TemplateList[I].Template;
        }
        I++;
        // [Loop Continue]
        goto J0x122;
    }
    return none;
    //return ReturnValue;    
}

simulated event SetTemplate(ParticleSystem NewTemplate, optional bool bDestroyOnFinish)
{
    local PlayerController PC;
    local int LODLevel;

    super.SetTemplate(NewTemplate, bDestroyOnFinish);
    // End:0x1FB
    if(NewTemplate != none)
    {
        // End:0x5D
        if(WorldInfo.bDropDetail)
        {
            LODLevel = 1;            
        }
        else
        {
            // End:0x1D3
            if(NewTemplate.LODDistances.Length > 1)
            {
                LODLevel = 1;
                // End:0x1D2
                foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
                {
                    // End:0x1D1
                    if(((PC.ViewTarget != none) && (VSize(PC.ViewTarget.Location - Location) * PC.LODDistanceFactor) < NewTemplate.LODDistances[1]) && (Vector(PC.Rotation) Dot (Location - PC.ViewTarget.Location)) >= 0.0000000)
                    {
                        LODLevel = 0;
                        // End:0x1D2
                        break;
                    }                    
                }                
            }
        }
        ParticleSystemComponent.SetLODLevel(LODLevel);
    }
    //return;    
}

function SetLightEnvironment(LightEnvironmentComponent Light)
{
    // End:0x37
    if(ParticleSystemComponent != none)
    {
        ParticleSystemComponent.super(UTEmitter).SetLightEnvironment(Light);
    }
    //return;    
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__UTEmitter.ParticleSystemComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ParticleSystemComponent0'
    // Archetype: ParticleSystemComponent'Engine.Default__Emitter.ParticleSystemComponent0'
    begin object name="ParticleSystemComponent0"
        bOverrideLODMethod=true
        SecondsBeforeInactive=0.0000000
        LODMethod=ParticleSystemLODMethod.PARTICLESYSTEMLODMETHOD_DirectSet
        ReplacementPrimitive=none
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    bDestroyOnSystemFinish=true
    Components[0]=ParticleSystemComponent0
    bNoDelete=false
    LifeSpan=7.0000000
}