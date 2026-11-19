class SkyAnimNotify_CauseRadiusDamage extends AnimNotify_Scripted
    native
    config(Engine)
    editinlinenew
    collapsecategories;

var() float DamageAmount;
var() float DamageRadius;
var() name DamageOriginSocket;
var() float DamageMomentum;
var() class<SkyDamageType> DamageType;
