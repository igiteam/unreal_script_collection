class WhizComponent extends ActorComponent
    native;

var private native const Pointer mpAdapter;
var private Vector m_position;
var private float m_radiusSquared;
var bool doTest;
var float test_speed;
var SoundCue test_sound;
var float WhizDuration;

// Export UWhizComponent::execOnWhizEvent(FFrame&, void* const)
native function OnWhizEvent(Vector From, Vector To, float Speed, SoundCue Sound);

// Export UWhizComponent::execSetSphereRadius(FFrame&, void* const)
native function SetSphereRadius(float Radius);

// Export UWhizComponent::execTick(FFrame&, void* const)
native function Tick(float DeltaTime);

// Export UWhizComponent::execRegisterWhiz(FFrame&, void* const)
native function RegisterWhiz();

defaultproperties
{
    m_radiusSquared=250000.0000000
    test_speed=5000.0000000
    test_sound=SoundCue'Aud_GCm_FakeWAV.Bullets.Bullet_Whiz_BY'
    WhizDuration=0.5000000
}