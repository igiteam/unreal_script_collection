class SPWingBuffetVolume extends PhysicsVolume
    native;

var float m_totalTimeAlive;
var ScreenShakeStruct m_playerShake;

// Export USPWingBuffetVolume::execUpdateVolume(FFrame&, void* const)
native final function UpdateVolume(float DeltaTime);

// Export USPWingBuffetVolume::execGetZoneVelocity(FFrame&, void* const)
native function Vector GetZoneVelocity(optional Actor Target);

event Tick(float DeltaTime)
{
    UpdateVolume(DeltaTime);
    //return;    
}
