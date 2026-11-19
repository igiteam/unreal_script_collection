class SkyAnimNotify_AddRadialImpulse extends AnimNotify_Scripted
    native
    config(Engine)
    editinlinenew
    collapsecategories;

var() name Location;
var() float Radius;
var() float Strength;
var() PrimitiveComponent.ERadialImpulseFalloff Falloff;
var() bool bVelChange;
