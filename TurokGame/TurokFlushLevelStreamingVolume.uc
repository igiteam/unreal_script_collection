class TurokFlushLevelStreamingVolume extends Volume
    native
    hidecategories(Navigation,Object,Movement,Display);

// Export UTurokFlushLevelStreamingVolume::execFlushLevelStreaming(FFrame&, void* const)
native simulated function FlushLevelStreaming();

simulated event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
{
    // End:0x1A
    if(TurokPawnPlayer(Other) != none)
    {
        FlushLevelStreaming();
    }
    //return;    
}

simulated event UnTouch(@NULL Other)
{
    //return;    
}

defaultproperties
{
    // Reference: BrushComponent'Default__TurokFlushLevelStreamingVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}