class SkyAnimNodeScaleRateBySpeed extends AnimNodeScaleRateBySpeed
    native;

var() bool bUseAngularSpeed;
var() bool bUseAcceleration;
var() bool bIgnoreX;
var() bool bIgnoreY;
var() bool bIgnoreZ;
var() bool bUseActualVelocity;
var Rotator LastRotation;
var() float MaxScale;
