class R6SpawnableEmitter extends Emitter
    native
    notplaceable
    hidecategories(lighting);

var bool m_bUsePool;
var bool m_bIsInPool;

function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
    // End:0x11
    if(bDestroyOnSystemFinish)
    {
        m_bLifeSpanDontDeleteWhileRender = false;
    }
    OnParticleSystemFinished(FinishedComponent);
    return;
}

defaultproperties
{
    bNoDelete=false
    m_bLifeSpanDontDeleteWhileRender=true
    RemoteRole=0
    LifeSpan=30.0000000
}