class SkyAnimNotify_Damage extends AnimNotify_Scripted
    native
    config(Engine)
    editinlinenew
    collapsecategories;

var() float Damage;
var() name DamageBone;
var() Vector DamageOffset;
var() Vector DamageMomentum;
var() class<SkyDamageType> DamageType;
var() bool bUseInteractionPartnerAsInstigator;
