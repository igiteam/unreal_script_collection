class SeqAct_SetAIPawnParams extends SequenceAction
    hidecategories(Object);

var() bool bIgnoreAffordance;
var() bool bInvincible;
var() bool bNoHitReactions;
var() bool bNoRagdoll;
var() float NPCtoNPCDamageMult;
var() float GrenadeThrowPercent;
var() float GrenadeThrowAccuracy;
var() float GrenadeAccuracyRadius;

defaultproperties
{
    bNoHitReactions=true
    NPCtoNPCDamageMult=0.2500000
    GrenadeThrowPercent=25.0000000
    GrenadeThrowAccuracy=1.0000000
    GrenadeAccuracyRadius=1000.0000000
    ObjName="Set AI Pawn Paramaters"
    ObjCategory="Kynapse AI"
}