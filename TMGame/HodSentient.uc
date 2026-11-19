class HodSentient extends HodActor
	native(TG);

var int flashendtime;
var name flashingTeam;
var name team;
var float health;
var float maxHealth;
var bool isReloading;


struct native AnimArrayStruct
{
	var array<name> data;
};

struct native _a
{
	var name script;
	var name desired_script;
	var name current_script;

	var name pose;
	var name stance;
	var name movement;
	var name alertness;
	var name state;
	var name special;
	var name forced_cover;

	var name arrivalType;
	var name coverMode;
	var name cornerMode;

	var array<name> weaponPos;

	var bool suppressingEnemy;
	var bool disableLongDeath;
	var bool disablePain;
	var int painTime;
	var bool nextStandingHitDying;

	var float lookangle;

	var int combatEndTime;
	var int lastShootTime;
	var int nextGrenadeTryTime;
	var bool magicReloadWhenReachEnemy;

	var int scriptStartTime;

	var name combatRunAnim;

	var bool mayOnlyDie;
	var bool nodeath;
	var bool atConcealmentNode;

	var float aimweight;
	var float aimweight_start;
	var float aimweight_end;
	var float aimweight_transframes;
	var float aimweight_t;

	var int runLoopCount;

	var vector lastEnemyPos;
	var int lastEnemyTime;

	var bool shouldResetGiveUpOnSuppressionTimer;
	var int giveUpOnSuppressionTime;

	var delegate<FuncPostScript> postScriptFunc;
	var delegate<FuncStopCowering> stopCowering;

	var array<AnimArrayStruct> array;

	var bool exposedReloading;
	var int lookForNewCoverTime;

	var int idleSet;
	var name meleeState;

	var bool laserOn;

	var int nextGiveUpOnEnemyTime;
	var int dontCrouchTime;
	var int missTime;
	var int missTimeDebounce;

	var int rockets;
	var bool rocketVisible;

	var int needsToRechamber;

	var int allowedPartialReloadOnTheRunTime;

	var HodSentient personImMeleeing;
	var HodSentient personMeleeingMe;

	var name crouchRunAnim;
	var bool standIdleThread;

	var int getBoredOfThisNodeTime;
	var bool idlingAtCover;

	var int lastEncounterTime;
};
var _a a;

delegate FuncPostScript(name animscript);
delegate FuncStopCowering();


function Construct()
{
	health = 100;
	maxHealth = 100;
}

function name GetStance()
{
	return a.pose;
}

/*
=============
///ScriptDocBegin
"Name: isFlashed()"
"Summary: Returns true if the player or an AI is flashed"
"Module: Utility"
"CallOn: An AI"
"Example: flashed = level.price isflashed();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
function bool isFlashed()
{
	if ( !time_isdefined( self.flashEndTime ) )
		return false;
	
	return gettime() < self.flashEndTime;
}


function vector GetEye();
