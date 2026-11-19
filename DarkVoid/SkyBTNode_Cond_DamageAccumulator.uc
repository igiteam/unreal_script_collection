class SkyBTNode_Cond_DamageAccumulator extends SkyBTNode_Leaf_Condition
    native;

var(Damage) float DamageAmount;
var(Damage) bool bIsDamagePercent;
var(Damage) SkyBTNode.E_MeOrEnemy DamageSource;
var float StartingHealth;
