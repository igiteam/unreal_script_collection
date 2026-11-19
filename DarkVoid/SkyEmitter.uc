class SkyEmitter extends Emitter
    native;

var transient bool bSkyPoolActive;

// Export USkyEmitter::execSetNoDelete(FFrame&, void* const)
native final function SetNoDelete(bool bNewNoDelete);

// Export USkyEmitter::execInitForPooling(FFrame&, void* const)
native simulated function InitForPooling(ParticleSystem PSC);

// Export USkyEmitter::execDestroyFromPooling(FFrame&, void* const)
native simulated function DestroyFromPooling();

// Export USkyEmitter::execIsPoolAvailable(FFrame&, void* const)
native simulated function bool IsPoolAvailable();

// Export USkyEmitter::execInit(FFrame&, void* const)
native simulated function Init(optional bool bUseParticleSystemLifeSpan);

// Export USkyEmitter::execReset(FFrame&, void* const)
native simulated function Reset();

// Export USkyEmitter::execSetTemplate(FFrame&, void* const)
native simulated function SetTemplate(ParticleSystem NewTemplate, optional bool bDestroyOnFinish);

simulated function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
    // End:0x16
    if(bNoDelete)
    {
        Reset();        
    }
    else
    {
        super.OnParticleSystemFinished(FinishedComponent);
    }
    //return;    
}

simulated event AttachTo(Pawn P, name NewBoneName)
{
    // End:0x21
    if(NewBoneName == 'None')
    {
        SetBase(P);        
    }
    else
    {
        SetBase(P,, P.Mesh, NewBoneName);
    }
    //return;    
}

simulated function PawnBaseDied()
{
    // End:0x1B
    if(ParticleSystemComponent != none)
    {
        ParticleSystemComponent.DeactivateSystem();
    }
    //return;    
}

// Export USkyEmitter::execHandleLifeSpanExpired(FFrame&, void* const)
native simulated function HandleLifeSpanExpired();
