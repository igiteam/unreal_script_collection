class SkyAnimBlendBySpeed extends SkyAnimBlendBase
    native;

var() bool bIgnoreX;
var() bool bIgnoreY;
var() bool bIgnoreZ;
var() bool bUseAngularSpeed;
var() bool bUseAcceleration;
var() bool bContinuousBlend;
var() bool bUseActualVelocity;
var Rotator LastRotation;
var float Speed;
