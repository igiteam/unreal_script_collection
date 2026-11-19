class SkyAnimNodeAimOffsetTurret extends SkyAnimNodeAimOffset
    native;

var() name AimBoneName;
var() name ReferenceBoneName;
var() bool bReverseFacing;
var() float MaxSpeed;
var transient float AllowedMoveDist;
var transient Vector2D LastAim;
