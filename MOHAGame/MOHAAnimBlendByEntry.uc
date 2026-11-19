class MOHAAnimBlendByEntry extends MOHAAnimBlendByAngle
    native
    hidecategories(Object,Object,Object);

var() bool UseActorRotationForAngle;

// Export UMOHAAnimBlendByEntry::execGetEntryDistance(FFrame&, void* const)
native function float GetEntryDistance();
