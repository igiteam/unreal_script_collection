class AnimNotify_HurtRadius extends AnimNotify
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() class<DamageType> DamageType;
var() float DamageAmount;
var() float DamageRadius;
var() float DamageMomentum;
var() name SocketName;
var() bool bDrawDebugSphere;

defaultproperties
{
    DamageType=Class'Engine.DamageType'
    DamageAmount=100.0000000
    DamageRadius=100.0000000
    DamageMomentum=5000.0000000
}