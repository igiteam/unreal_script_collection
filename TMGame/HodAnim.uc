class HodAnim extends HodObject
	native(TG);

var bool NotFirstTime;

var float standRangeSq;

var float min_sniper_burst_delay_time;
var float max_sniper_burst_delay_time;

var array<int> semiFireNumShots;
var array<int> fastBurstFireNumShots;
var array<int> burstFireNumShots;

var int combatMemoryTimeConst;
var int combatMemoryTimeRand;
var float coverCrouchLeanPitch;

var array<ApproachTypes> approach_types;

var array<TransAngle> coverTransAngles;
var array<TransDist> coverTransDist;
var array<TransDist> coverTransPreDist;
var array<TransAnim> coverTrans;
var array<TransSplit> coverTransSplit;

var array<TransAngle> coverExitAngles;
var array<TransDist> coverExitDist;
var array<TransDist> coverExitPostDist;
var array<TransAnim> coverExit;
var array<TransSplit> coverExitSplit;

var float longestExposedApproachDist;

var array<name> idleAnimTransitionIn;
var array<AnimSetArray> idleAnimArray;
var array<AnimWeightSetArray> idleAnimWeights;

var int animFlagNameIndex;

var DelegateShootEnemyWrapper shootEnemyWrapper_func;

var float run_accuracy;

var float meleeRange;
var float meleeRangeSq;
var float chargeRangeSq;
var float chargeLongRangeSq;

var name scriptChange;

var bool throwGrenadeAtPlayerASAP;

var DelegatePainTest pain_test;

var int numDeathsUntilCrawlingPain;
var int numDeathsUntilCornerGrenadeDeath;

var int lastCarExplosionTime;
var float lastCarExplosionRange;
var vector lastCarExplosionDamageLocation;
var vector lastCarExplosionLocation;

var int lastUpwardsDeathTime;
var bool maymoveCheckEnabled;

var int numGrenadesInProgressTowardsPlayer;

function Construct()
{
	// need fix
}

function bool HandleNoteTrack(name note, name flagName)
{
	// need fixed
	//assert (false);
	return false;
}

