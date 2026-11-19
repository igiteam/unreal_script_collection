class R6CameraRecoilModifier extends R6CameraModifier
    native;

var int m_iRecoilPitch;
var float m_fRecoilModifiedPitchVel;
var int m_iRecoilModifiedPitch;
var int m_iRecoilYaw;
var R6Weapon m_RecoilWeapon;
var bool m_bAddRecoil;

// Export UR6CameraRecoilModifier::execSetRecoilWeapon(FFrame&, void* const)
native function SetRecoilWeapon(R6Weapon recoilWeapon);

// Export UR6CameraRecoilModifier::execAddRecoil(FFrame&, void* const)
native function AddRecoil();
