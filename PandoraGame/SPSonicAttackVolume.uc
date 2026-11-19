class SPSonicAttackVolume extends SPWingBuffetVolume
    native;

var SPNariAIController myNari;

// Export USPSonicAttackVolume::execUpdateSonicVolume(FFrame&, void* const)
native final function UpdateSonicVolume(float DeltaTime);

// Export USPSonicAttackVolume::execTouchActor(FFrame&, void* const)
native function TouchActor(Actor Touched, Vector HitLocation);

event Tick(float DeltaTime)
{
    UpdateSonicVolume(DeltaTime);
    //return;    
}
