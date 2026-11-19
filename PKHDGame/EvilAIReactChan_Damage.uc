class EvilAIReactChan_Damage extends EvilAIReactChannel;

var Pawn DamageInstigator;
var class<DamageType> DamageType;
var bool bDirectDamage;
var TraceHitInfo HitInfo;
var Vector LastInstigatorLoc;
var float DamageAmt;
