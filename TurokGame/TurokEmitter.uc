class TurokEmitter extends Emitter
    native
    hidecategories(Navigation);

var export editinline @NULL mSoundController;
var bool mbTurokEmitterActive;

function DefaultRenderStasis()
{
    //return;    
}

simulated function attachTo(@NULL baseActor, optional name BoneName)
{
    // End:0x22
    if(BoneName == 'None')
    {
        SetBase(baseActor);        
    }
    else
    {
        // End:0x53
        if(Pawn(baseActor) != none)
        {
            SetBase(baseActor,, Pawn(baseActor).Mesh, BoneName);
        }
    }
    //return;    
}

// Export UTurokEmitter::execDisableLights(FFrame&, void* const)
native function DisableLights();

function OnParticleSystemFinished(@NULL FinishedComponent)
{
    DisableLights();
    super.OnParticleSystemFinished(FinishedComponent);
    SetBase(none);
    SetOwner(none);
    Instigator = none;
    mbTurokEmitterActive = false;
    SetTickGroup(3);
    //return;    
}

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokEmitter.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent class=Class'TurokSoundController'
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: ParticleSystemComponent'Default__TurokEmitter.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokEmitter.MyLightEnvironment'
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    bDestroyOnSystemFinish=true
    // Reference: DynamicLightEnvironmentComponent'Default__TurokEmitter.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    bNoDelete=false
    Components[0]=MyLightEnvironment
    Components[1]=ParticleSystemComponent0
    Components[2]=TurokSoundControllerComponent
    RemoteRole=0
}