class EvilAIReactChan_Damage extends EvilAIReactChannel;

var Pawn DamageInstigator;
var class<EvilDmgType_Base> DamageType;
var bool bDirectDamage;
var TraceHitInfo HitInfo;
var Vector LastInstigatorLoc;
var float DamageAmt;
