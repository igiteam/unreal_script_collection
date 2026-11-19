class HodAI extends HodSentient
	native(TG)
	dependson(general_human);

var bool ignore_pain;
var float in_combat_time;
var bool toggle_combat;
var TGAnimNodeHuman human_anim;
var TGAnimNodeSequence custom_slot[2];
var array<TGAnimNodeSequence> combatrun_forward;
var array<TGAnimNodeSequence> walk_and_run_loops;
var array<TGAnimNodeSequence> exposed_modern;
var array<TGAnimNodeSequence> stand_and_crouch;
var array<TGAnimNodeSequence> misc_modern;
var array<TGAnimNodeSequence> corner;
var array<TGAnimNodeSequence> turret;

var animscripts_init animscripts_init;
var animscripts_shared animscripts_shared;
var animscripts_utility animscripts_utility;
var animscripts_combat_utility animscripts_combat_utility;
var animscripts_trans animscripts_trans;
var animscripts_squadmanager animscripts_squadmanager;
var animscripts_run animscripts_run;
var animscripts_walk animscripts_walk;
var animscripts_cover_prone animscripts_cover_prone;
var animscripts_cover_arrival animscripts_cover_arrival;
var animscripts_corner animscripts_corner;
var animscripts_shoot_behavior animscripts_shoot_behavior;
var animscripts_weaponList animscripts_weaponList;
var animscripts_cover_behavior animscripts_cover_behavior;
var animscripts_cover_wall animscripts_cover_wall;

var animscripts_corner current_corner_script;

var animscripts_stop animscripts_stop;
var animscripts_move animscripts_move;
var animscripts_combat animscripts_combat;
var animscripts_melee animscripts_melee;
var animscripts_cover_crouch animscripts_cover_crouch;
var animscripts_cover_stand animscripts_cover_stand;
var animscripts_cover_right animscripts_cover_right;
var animscripts_cover_left animscripts_cover_left;
var animscripts_pain animscripts_pain;
var animscripts_death animscripts_death;

var maps__gameskill maps__gameskill;

// delegate
// handle note tracks
var NoteTracksPostCallback_HandlePutaway NoteTracksPostCallback_HandlePutaway;
var NoteTracksPostCallback_HandlePickup NoteTracksPostCallback_HandlePickup;

// death function
var DeathFunc_RPGDeath DeathFunc_RPGDeath;

// can stop function
var CanStop_ReturnTrue CanStop_ReturnTrue;
var CanStop_CanStopPeeking CanStop_CanStopPeeking;

var CoreAnimNotify anim_notify;

struct native AIArrayStruct
{
	var array<HodAI> data;
};

struct cover_behavior_callback
{
	var CBCMainLoopStart mainLoopStart;
	var CBCReload reload;
	var CBCLeaveCoverAndShoot leaveCoverAndShoot;
	var CBCLook	look;
	var CBCFastlook fastlook;
	var CBCIdle idle;
	var CBCFlinch flinch;
	var CBCGrenade grenade;
	var CBCGrenade grenadehidden;
	var CBCBlindfire blindfire;
};
var cover_wall_CBCreload cover_wall_CBCreload;
var cover_wall_CBCleaveCoverAndShoot cover_wall_CBCleaveCoverAndShoot;
var cover_wall_CBClook cover_wall_CBClook;
var cover_wall_CBCfastlook cover_wall_CBCfastlook;
var cover_wall_CBCidle cover_wall_CBCidle;
var cover_wall_CBCflinch cover_wall_CBCflinch;
var cover_wall_CBCgrenade cover_wall_CBCgrenade;
var cover_wall_CBCgrenadehidden cover_wall_CBCgrenadehidden;
var cover_wall_CBCblindfire cover_wall_CBCblindfire;

var corner_CBCmainLoopStart corner_CBCmainLoopStart;
var corner_CBCReload corner_CBCReload;
var corner_CBCleaveCoverAndShoot corner_CBCleaveCoverAndShoot;
var corner_CBClook corner_CBClook;
var corner_CBCfastlook corner_CBCfastlook;
var corner_CBCidle corner_CBCidle;
var corner_CBCgrenade corner_CBCgrenade;
var corner_CBCgrenadehidden corner_CBCgrenadehidden;
var corner_CBCblindfire corner_CBCblindfire;


var name pose;
var name movement;

var HodSentient enemy;
var HodNode coverNode;
var HodNode node;
var HodNode prevNode;

var name coverType;

var(Kismet) name run_combatanim;
var(Kismet) name run_noncombatanim;
var(Kismet) name crouchrun_combatanim;
var(Kismet) name walk_combatanim;
var(Kismet) name walk_combatanim2;
var(Kismet) name walk_noncombatanim;
var(Kismet) name walk_noncombatanim2;
var(Kismet) name deathanim;
var(Kismet) name deathanimloop;

var(Kismet) bool skipDeathAnim;

var(Kismet) bool alwaysRunForward;
var(Kismet) float moveplaybackrate;
var float animplaybackrate;

var(Kismet) bool sprint;

var bool cqb_track_thread;
var bool shoot_while_moving_thread;

var(Kismet) bool fixedNode;

var bool keepClaimedNodeInGoal;
var bool keepClaimedNode;

var name weapon;
var name primaryweapon;
var name secondaryweapon;
var name grenadeweapon;

var name sidearm;
var bool forceSideArm;

var bool isSniper;
var(Kismet) bool dontShootWhileMoving;
var bool grenade;

var bool longDeathStarting;

var bool suppressed;
var bool finishedReload;

var int missedSightChecks;
var name desired_anim_pose;

var vector pathGoalPos;
var name moveMode;
var bool exitingCover;
var(Kismet) bool disableExits;

var vector lookaheaddir;
var vector lookforward;

var bool goodShootPosValid;
var vector goodShootPos;

var vector coverExitPos;

var float turnThreshold;

var float rightAimLimit;
var float leftAimLimit;
var float upAimLimit;
var float downAimLimit;

var float turnleft180limit;
var float turnright180limit;
var float turnleft90limit;
var float turnright90limit;

var int reacquire_state;

var bool noreload;
var int bulletsinclip;

var bool holdingWeapon;

var int nextCheatTime;

var int lastStoppedTime;

var bool fastStand;
var bool requestArrivalNotify;
var vector coverEnterPos;
var bool disableArrivals;
var int approachNumber;
var name approachType;

var bool isturning;
var bool turnLastResort;

var float previousPitchDelta;
var bool twitchallowed;

var name shootObjective;
var HodEntity shootEnt;
var vector shootPos;
var name shootStyle;
var bool fastBurst;
var bool shouldReturnToCover;
var bool changingCoverPos;

var HodEntity lastMissedEnemy;

var int sniperShotCount;
var int sniperHitCount;

var float suppressionMeter;
var float suppressionThreshold;

var int coverPosEstablishedTime;
var int ambushEndTime;

var vector couldntSeeEnemyPos;
var bool provideCoveringFire;

var vector lastEnemyOrigin;
var vector lastEnemySightPos;
var vector lastEnemySightPosOld;
var vector lastEnemySightPosSelfOrigin;

var vector shootEntVelocity;

var DelegateDeathFunc deathFunction;
var DelegateDeathAnimScript DeathAnimScript;
var name swapAnim;
var name lastWeapon;

var float aimThresholdYaw;
var float aimThresholdPitch;

var float accuracy;
var float baseAccuracy;

var bool disableMelee;
var float enemyDistanceSq;
var int lastMeleeGiveUpTime;
var int giveUpOnMeleeTime;

var bool fastCrouch;
var bool cqbwalking;

var int seekOutEnemyTime;
var bool idlingAtCover;

var int lastSuppressionTime;
var int suppressionStart;

var bool flinching;
var bool disable_blindfire;

var name damageLocation;
var float damageTaken;
var name damageWeapon;
var float damageyaw;

var bool mayDoUpwardsDeath;

var bool dieQuietly;

var bool magic_bullet_shield;

var name cornerDirection;
var bool isshooting;
var bool tracking;
var bool cornerAiming;
var bool haveGoneToCover;
var float hideyawoffset;
var float desiredAngle;
var float ABangleCutoff;
var name spot;

var float oldGrenAwareness;
var float grenadeawareness;

var bool isHoldingGrenade;


// internal used
struct native AnimModeStruct
{
	var name mode;
};

var AnimModeStruct anim_mode;
var TGPawn pawn;
var HodNode ReacquireNode;
var HodNode BestCoverNode;
var DynamicAnchor dynamicAnchor;
var Actor ReacquirePath;
var name PendingState;
var bool MoveToEnemy;

var bool DoingMove;
var bool AllowRequiredMove;

enum EHodCombatMood
{
	HCM_Normal,
	HCM_Ambush,
};

var EHodCombatMood kCombatMood;
var int FireNumShots[5];
var bool UseFireNumShots;
var float BurstDelayMin;
var float BurstDelayMax;
var bool UseBurstDelayRange;
var bool EnableShootWhenDied;

var CoreTask hod_state;

function Construct()
{
	Super.Construct();

	animscripts_init = new(self) class'animscripts_init';
	animscripts_run = new(self) class'animscripts_run';
	animscripts_walk = new(self) class'animscripts_walk';
	animscripts_shared = new(self) class'animscripts_shared';
	animscripts_utility = new(self) class'animscripts_utility';
	animscripts_combat_utility = new(self) class'animscripts_combat_utility';
	animscripts_cover_prone = new(self) class'animscripts_cover_prone';
	animscripts_trans = new(self) class'animscripts_trans';
	animscripts_squadmanager = new(self) class'animscripts_squadmanager';
	animscripts_cover_arrival = new(self) class'animscripts_cover_arrival';
	animscripts_corner = new(self) class'animscripts_corner';
	animscripts_shoot_behavior = new(self) class'animscripts_shoot_behavior';
	animscripts_weaponList = new(self) class'animscripts_weaponList';
	animscripts_cover_behavior = new(self) class'animscripts_cover_behavior';
	animscripts_cover_wall = new(self) class'animscripts_cover_wall';

	animscripts_stop = new(self) class'animscripts_stop';
	animscripts_move = new(self) class'animscripts_move';
	animscripts_combat = new(self) class'animscripts_combat';
	animscripts_melee = new(self) class'animscripts_melee';
	animscripts_cover_crouch = new(self) class'animscripts_cover_crouch';
	animscripts_cover_stand = new(self) class'animscripts_cover_stand';
	animscripts_cover_left = new(self) class'animscripts_cover_left';
	animscripts_cover_right = new(self) class'animscripts_cover_right';
	animscripts_pain = new(self) class'animscripts_pain';
	animscripts_death = new(self) class'animscripts_death';

	cover_wall_CBCreload = new(self) class'cover_wall_CBCreload';
	cover_wall_CBCleaveCoverAndShoot = new(self) class'cover_wall_CBCleaveCoverAndShoot';
	cover_wall_CBClook = new(self) class'cover_wall_CBClook';
	cover_wall_CBCfastlook = new(self) class'cover_wall_CBCfastlook';
	cover_wall_CBCidle = new(self) class'cover_wall_CBCidle';
	cover_wall_CBCflinch = new(self) class'cover_wall_CBCflinch';
	cover_wall_CBCgrenade = new(self) class'cover_wall_CBCgrenade';
	cover_wall_CBCgrenadehidden = new(self) class'cover_wall_CBCgrenadehidden';
	cover_wall_CBCblindfire = new(self) class'cover_wall_CBCblindfire';

	corner_CBCmainLoopStart = new(self) class'corner_CBCmainLoopStart';
	corner_CBCReload = new(self) class'corner_CBCReload';
	corner_CBCleaveCoverAndShoot = new(self) class'corner_CBCleaveCoverAndShoot';
	corner_CBClook = new(self) class'corner_CBClook';
	corner_CBCfastlook = new(self) class'corner_CBCfastlook';
	corner_CBCidle = new(self) class'corner_CBCidle';
	corner_CBCgrenade = new(self) class'corner_CBCgrenade';
	corner_CBCgrenadehidden = new(self) class'corner_CBCgrenadehidden';
	corner_CBCblindfire = new(self) class'corner_CBCblindfire';

	maps__gameskill = new(self) class'maps__gameskill';

	NoteTracksPostCallback_HandlePutaway = new(self) class'NoteTracksPostCallback_HandlePutaway';
	NoteTracksPostCallback_HandlePickup = new(self) class'NoteTracksPostCallback_HandlePickup';

	DeathFunc_RPGDeath = new(self) class'DeathFunc_RPGDeath';

	CanStop_ReturnTrue = new(self) class'CanStop_ReturnTrue';
	CanStop_CanStopPeeking = new(self) class'CanStop_CanStopPeeking';

	anim_notify = new class'CoreAnimNotify';

	coverNode = HodNode(NewObject(class'HodNode'));
	node = HodNode(NewObject(class'HodNode'));
	prevNode = HodNode(NewObject(class'HodNode'));
	ReacquireNode = HodNode(NewObject(class'HodNode'));
	BestCoverNode = HodNode(NewObject(class'HodNode'));

	pathGoalPos = invalid_vector;
	coverEnterPos = invalid_vector;
	ambushEndTime = invalid_time;
	lastMeleeGiveUpTime = invalid_time;
	flashendtime = time_undefined;

	shootPos = vec_undefined;
	lastEnemySightPosOld = vec_undefined;

	a.shouldResetGiveUpOnSuppressionTimer = true;

	bulletsInClip = -1;

	sniperShotCount = 0;
	sniperHitCount = 0;

	damageWeapon = 'none';

	oldGrenAwareness = float_undefined;

	ResetAnimArray();

	kCombatMood = HCM_Normal;
	FireNumShots[0] = 1;
	FireNumShots[1] = 3;
	FireNumShots[2] = 5;
	FireNumShots[3] = 9;
	FireNumShots[4] = 12;

	BurstDelayMin = 0.1;
	BurstDelayMax = 0.35;
	holdingWeapon = true;

	animscripts_move.walk_noncombatanim_rate = 1.f;
	animscripts_move.walk_noncombatanim2_rate = 1.f;
	animscripts_move.walk_combatanim_rate = 1.f;
	animscripts_move.walk_combatanim2_rate = 1.f;
	animscripts_move.run_combatanim_rate = 1.f;
	animscripts_move.run_noncombatanim_rate = 1.f;
	animscripts_move.crouchrun_combatanim_rate = 1.f;

	in_combat_time = -100;
}

function Initialize(TGPawn inPawn)
{
	self.weapon = 'mp5';
	//self.secondaryweapon = 'colt45';
	//self.sidearm = 'colt45';

	pawn = inPawn;
	human_anim = TGAnimNodeHuman(pawn.Mesh.FindAnimNode('root'));
	custom_slot[0] = TGAnimNodeSequence(pawn.Mesh.FindAnimNode('custom_slot1'));
	custom_slot[1] = TGAnimNodeSequence(pawn.Mesh.FindAnimNode('custom_slot2'));

	combatrun_forward.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('combatrun_forward_slot1')));
	combatrun_forward.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('combatrun_forward_slot2')));
	combatrun_forward.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('combatrun_forward_slot3')));
	combatrun_forward.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('combatrun_forward_slot4')));

	walk_and_run_loops.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('walk_and_run_loops_slot1')));
	walk_and_run_loops.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('walk_and_run_loops_slot2')));
	walk_and_run_loops.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('walk_and_run_loops_slot3')));
	walk_and_run_loops.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('walk_and_run_loops_slot4')));

	exposed_modern.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('exposed_modern_slot1')));
	exposed_modern.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('exposed_modern_slot2')));
	exposed_modern.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('exposed_modern_slot3')));
	exposed_modern.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('exposed_modern_slot4')));

	stand_and_crouch.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('stand_and_crouch_slot1')));
	stand_and_crouch.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('stand_and_crouch_slot2')));
	stand_and_crouch.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('stand_and_crouch_slot3')));
	stand_and_crouch.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('stand_and_crouch_slot4')));

	misc_modern.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('misc_modern_slot1')));
	misc_modern.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('misc_modern_slot2')));
	misc_modern.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('misc_modern_slot3')));
	misc_modern.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('misc_modern_slot4')));

	corner.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('corner_slot1')));
	corner.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('corner_slot2')));
	corner.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('corner_slot3')));
	corner.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('corner_slot4')));

	turret.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('turret_slot1')));
	turret.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('turret_slot2')));
	turret.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('turret_slot3')));
	turret.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('turret_slot4')));
	turret.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('turret_slot5')));
	turret.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('turret_slot6')));
	turret.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('turret_slot7')));
	turret.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('turret_slot8')));

	animscripts_init.trans_anim.AddItem(TGAnimNodeSequence(pawn.Mesh.FindAnimNode('trans_anim')));
	OrientMode('face default');
	animscripts_init.main();

	run (new(self) class'HodAI_SelectEnemy', true);
	run (new(self) class'HodAI_LastSightUpdater', true);
	run (new(self) class'HodAI_TrackSuppression', true);
}

function vector GetShootAtPos()
{
	return GetEye();
}

function Actor GetActor()
{
	return pawn;
}

function DoStopCoweringFunc()
{
	local delegate<FuncStopCowering> func;
	func = a.stopCowering;
	if (func != none)
		func();
}

function DoPostScriptFunc(name animscript)
{
	local delegate<FuncPostScript> func;
	func = a.postScriptFunc;
	if (func != none)
		func(animscript);
}

function DoNothing();

function bool IsPlayer(HodEntity ent)
{
	return ent == level.player;
}

function bool _HandleNoteTrack(name note, name flagName)
{
	switch (note)
	{
	case name("anim_pose = stand"): return animscripts_shared.noteTrackPoseStand(note, flagName);
	case name("anim_pose = crouch"): return animscripts_shared.noteTrackPoseCrouch(note, flagName);
	case name("anim_pose = prone"): return animscripts_shared.noteTrackPoseProne(note, flagName);
	case name("anim_pose = crawl"): return animscripts_shared.noteTrackPoseCrawl(note, flagName);
	//case 'anim_pose = back': return animscripts_shared.noteTrackPoseBack(note, flagName);

	case name("anim_movement = stop"): return animscripts_shared.noteTrackMovementStop(note, flagName);
	case name("anim_movement = walk"): return animscripts_shared.noteTrackMovementWalk(note, flagName);
	case name("anim_movement = run"): return animscripts_shared.noteTrackMovementRun(note, flagName);

	//case 'anim_aiming = 1': return animscripts_shared.noteTrackAlertnessAiming(note, flagName);
	//case 'anim_aiming = 0': return animscripts_shared.noteTrackAlertnessAlert(note, flagName);
	//case 'anim_alertness = causal': return animscripts_shared.noteTrackAlertnessCasual(note, flagName);
	//case 'anim_alertness = alert': return animscripts_shared.noteTrackAlertnessAlert(note, flagName);
	//case 'anim_alertness = aiming': return animscripts_shared.noteTrackAlertnessAiming(note, flagName);
	//
	//case 'gunhand = (gunhand)_left': return animscripts_shared.noteTrackGunhand(note, flagName);
	//case 'anim_gunhand = left': return animscripts_shared.noteTrackGunhand(note, flagName);
	//case 'gunhand = (gunhand)_right': return animscripts_shared.noteTrackGunhand(note, flagName);
	//case 'anim_gunhand = right': return animscripts_shared.noteTrackGunhand(note, flagName);
	//case 'anim_gunhand = none': return animscripts_shared.noteTrackGunhand(note, flagName);
	//case 'gun drop': return animscripts_shared.noteTrackGunDrop(note, flagName);
	case 'dropgun': return animscripts_shared.noteTrackGunDrop(note, flagName);

	//case 'gun_2_chest': return animscripts_shared.noteTrackGunToChest(note, flagName);
	//case 'gun_2_back': return animscripts_shared.noteTrackGunToBack(note, flagName);
	//case 'pistol_pickup': return animscripts_shared.noteTrackPistolPickup(note, flagName);
	//case 'pistol_putaway': return animscripts_shared.noteTrackPistolPutaway(note, flagName);
	//case 'drop clip': return animscripts_shared.noteTrackDropClip(note, flagName);
	//case 'refill clip': return animscripts_shared.noteTrackRefillClip(note, flagName);
	case 'reload done': return animscripts_shared.noteTrackRefillClip(note, flagName);
	//case 'load_shell': return animscripts_shared.noteTrackLoadShell(note, flagName);
	//case 'pistol_rechamber': return animscripts_shared.noteTrackPistolRechamber(note, flagName);
	//
	//case 'gravity on': return animscripts_shared.noteTrackGravity(note, flagName);
	//case 'gravity off': return animscripts_shared.noteTrackGravity(note, flagName);

	//case 'bodyfall large': return animscripts_shared.noteTrackBodyFall(note, flagName);
	//case 'bodyfall small': return animscripts_shared.noteTrackBodyFall(note, flagName);
	//
	//case 'footstep': return animscripts_shared.noteTrackFootStep(note, flagName);
	//case 'step': return animscripts_shared.noteTrackFootStep(note, flagName);
	//case 'footstep_right_large': return animscripts_shared.noteTrackFootStep(note, flagName);
	//case 'footstep_right_small': return animscripts_shared.noteTrackFootStep(note, flagName);
	//case 'footstep_left_large': return animscripts_shared.noteTrackFootStep(note, flagName);
	//case 'footstep_left_small': return animscripts_shared.noteTrackFootStep(note, flagName);
	//case 'footscrape': return animscripts_shared.noteTrackFootScrape(note, flagName);
	//case 'land': return animscripts_shared.noteTrackLand(note, flagName);
	//
	//case 'laser_on': return animscripts_shared.noteTrackLaser(note, flagName);
	//case 'laser_off': return animscripts_shared.noteTrackLaser(note, flagName);
	//
	case 'start_ragdoll': return animscripts_shared.noteTrackStartRagdoll(note, flagName);

	//case 'fire': return animscripts_shared.noteTrackFire(note, flagName);
	case 'fire_spray': return animscripts_shared.noteTrackFireSpray(note, flagName);

	default:
		break;
	}

	return false;
}

//function bool ReacquireEnemy(bool ignoreSuppression)
//{
//}

// weapon
function name GetWeaponModel(name iWeapon)
{
	// need fixed
	//assert (false);
	switch (iWeapon)
	{
	case 'mp5':	return 'mp5 model';
	case 'R95':	return 'R95 model';
	case 'S88':	return 'S88 model';
	}
	return '';
}

function int WeaponClipSize(name iWeapon)
{
	// need fixed
	//assert (false);
	return 30;
}

function name WeaponClass(name iWeapon)
{
	// need fixed
	switch (iWeapon)
	{
	case 'mp5':
		return 'smg';

	case 'R95':
		return 'rifle';

	case 'S88':
		return 'rifle';

	case 'grenade':
		return 'grenade';
	}
	return '';
}

function bool WeaponIsSemiAuto(name iWeapon)
{
	switch (iWeapon)
	{
	case 'mp5':
	case 'R95':
		return false;
	case 'S88':
		return true;
	}
	return false;
}

function bool WeaponIsBoltAction(name iWeapon)
{
	return false;
}

function float WeaponFireTime(name iWeapon)
{
	switch (iWeapon)
	{
	case 'S88':
		return 1.0;
	}

	return 0.1;
}

// sentient

function vector GetEye()
{
	local vector lEye;
	lEye = gettagorigin('tag_eye');
	if (!vec_isdefined(lEye))
		lEye = pawn.GetPawnViewLocation();
	return lEye;
}

function float GetClosestEnemySqDist()
{
	if (animscripts_utility.IsValidEnemy(enemy))
	{
		// need fix
		return DistanceSquared(origin, enemy.origin);
	}
	return -1;
}

function bool IsAlive(HodEntity entity)
{
	// need fix
	//assert (false);
	return true;
}

function bool IsSentient(HodEntity entity)
{
	return HodSentient(entity) != none;
}

final function SetSpringForBone(Name InBoneName, bool bEnable)
{
	local int				BoneIndex;
	local matrix			BoneMatrix;
	local RB_BodyInstance	BoneBody;

	// Filter through sockets and bones. Make sure we have a valid bone name to use.
	InBoneName = pawn.Mesh.GetSocketBoneName(InBoneName);

	if( InBoneName == '' )
	{
		;
		return;
	}

	BoneIndex = pawn.Mesh.MatchRefBone(InBoneName);
	if( BoneIndex != INDEX_NONE )
	{
		BoneMatrix = pawn.Mesh.GetBoneMatrix(BoneIndex);
		BoneBody = pawn.Mesh.FindBodyInstanceNamed(InBoneName);

		if( BoneBody != None )
		{
			BoneBody.EnableBoneSpring(bEnable, bEnable, BoneMatrix);
			if( bEnable )
			{
				BoneBody.OverextensionThreshold	= 50.f;
				BoneBody.SetBoneSpringParams(10000.f, 500.f, 10000.f, 500.f);
				BoneBody.bDisableOnOverExtension = TRUE;
			}
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}

// actor
function StartRagdoll()
{
	SetSpringForBone(pawn.PelvisBoneName, FALSE);
	SetSpringForBone(pawn.RightHandBoneName, FALSE);
	SetSpringForBone(pawn.LeftHandBoneName, FALSE);
	SetSpringForBone(pawn.LeftFootBoneName, FALSE);
	SetSpringForBone(pawn.RightFootBoneName, FALSE);

	pawn.SetPhysics(Phys_Falling);

	// Setup Pawn to be in rag doll physics
	// Turning to Rag Doll
	if( pawn.Physics != PHYS_RigidBody )
	{
		//pawn.SetPhysics(PHYS_RigidBody);

		// Add velocity of base upon death.
		pawn.AddBaseLinearVelocityUponWhenGoingRagDoll();
	}

	// Turn off collision on cylinder component and switch to skeleton physics
	pawn.CollisionComponent = pawn.Mesh;

	// disable unreal collision on ragdolls
	pawn.SetCollision(TRUE, FALSE);

	if( pawn.bEnableEncroachCheckOnRagdoll )
	{
		pawn.bNoEncroachCheck = FALSE;
	}

	// Set Physics weight to 1
	pawn.Mesh.PhysicsWeight = 1.f;

	// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
	pawn.Mesh.SetRBChannel(RBCC_DeadPawn);
	pawn.Mesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);

	// Make sure all bodies are unfixed
	pawn.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);

	// Set physics to NOT be updated from Kinematic data
	pawn.Mesh.bUpdateJointsFromAnimation = FALSE;
	pawn.Mesh.bUpdateKinematicBonesFromAnimation = FALSE;

	// Wake up physics
	pawn.Mesh.WakeRigidBody();

	// If Pawn had broken constraints, then we need to make sure child bodies and joints are not turned back into kinematic state
	if( pawn.bHasBrokenConstraints )
	{
		pawn.Mesh.UpdateMeshForBrokenConstraints();
	}

	// Turn off position motors
	pawn.Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(FALSE, FALSE, pawn.Mesh, TRUE);

	// Turn on velocity motors, to add some joint friction
	pawn.Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(0.f, 0.f, 0.02f, pawn.Mesh, TRUE);
	pawn.Mesh.PhysicsAssetInstance.SetAllMotorsAngularVelocityDrive(TRUE, TRUE, pawn.Mesh, TRUE);

	//clearanim('root', 0);
	//notify ('killanimscript');
	//pawn.StopAllAnimations();

	// Decrease joint limits, to prevent nasty poses once in complete rag doll.
	if( !pawn.bIsGore && pawn.ScaleLimitTimeToGo <= 0 )
	{
		pawn.ReduceConstraintLimits();
	}

	//pawn.Died(pawn.DeathKiller, pawn.DeathDamageType, pawn.DeathHitLocation);
	pawn.SetTimer(5.f, false, 'EndRagDollDeath');
}

function SetFlashBanged(bool iFlashed, optional float iStrength)
{
	// need fix
}

function bool IsSuppressed()
{
	// need fix
	return true;
}

function Teleport(optional vector iPosition = origin, optional Angle iAngles = angles)
{
	SetOrigin(iPosition);

	iAngles.pitch = AngleClamp360(iAngles.pitch);
	iAngles.yaw = AngleClamp360(iAngles.yaw);
	iAngles.roll = AngleClamp360(iAngles.roll);

	pawn.SetRotation(anglestorotator(iAngles));
	pawn.SetDesiredRotation(pawn.rotation);
	angles = rotatortoangles(pawn.rotation);
}

native function vector GetValidArrivalPos(vector iPosition);

function SetRunToPos(vector iPosition)
{
	local vector v;
	v = GetValidArrivalPos(iPosition);
	if (VSize(v) > 0.1)
	{
		pawn.RunToPos(v);
	}
}

function Melee()
{
	pawn.melee();
}

function Shoot(optional float iAccModifier = 1, optional vector iShootOverride = vec_undefined)
{
	pawn.Shoot(iShootOverride);
}

// Does traces to determine how much of the player is visible if the
// player is the actor's enemy. Then modifies the actor's accuracy
// based on the visibility. Should be called before any shoot volley.
function UpdatePlayerSightAccuracy()
{
	// need fix
}

function bool IsInGoal(vector iPosition)
{
	// need fix
	return true;
}

function bool CanShoot(vector pos, optional vector offset)
{
	local vector lStart;
	//local Angle lAngle;
	//local vector lForward;
	//local vector lDirection;

	lStart = GetTagOrigin('tag_flash') + offset;
	//lAngle = GetTagAngles('tag_flash');
	//lForward = anglestoforward(lAngle);

	//lDirection = vectornormalize(pos - lStart);
	//if (vectordot(lDirection, lForward) < 0.9)
	//	return false;

	return SightTracePassed(lStart, pos, false, none);
}

function bool CanAttackEnemyNode()
{
	return true;
}

function StartCoverArrival(vector startPos, float requiredYaw)
{
	angles.yaw = AngleClamp360(requiredYaw);
	teleport(startPos, angles);
	push_state('arrival');
}

function HodNode GetNegotiationStartNode()
{
	return none;
}

function UpdateProne(name animA, name animB, float goalWeight, float goalTime, float rate)
{
	// need fix
	//assert (false);
}

function SetProneAnimNodes(float downAngle, float upAngle, name lowProneAnim, name straightProneAnim, name highProneAnim)
{
	// need fix
	//assert (false);
}

function bool NearNode(HodNode inNode)
{
	if (!node_isdefined(inNode))
		return false;

	if (distancesquared(origin*vect(1, 1, 0), inNode.origin*vect(1, 1, 0)) > 15*15*FInchSq)
		return false;

	if (inNode.origin.z < origin.z - 60*FInch)
		return false;

	if (inNode.origin.z > origin.z + 60*FInch)
		return false;

	// need fix
	//assert (false);
	return true;
}

function FlagEnemyUnattackable()
{
	// need fix
	//assert (false);
}

function bool CheckExposed_Left(HodNode n)
{
	local float lYaw;

	if (DistanceSquared(enemy.origin, origin) < 320 * 320/* * FInchSq*/)
		return true;

	lYaw = n.GetYawToOrigin(enemy.origin);
	return lYaw < -60 || lYaw > 14;
}

function bool CheckExposed_Right(HodNode n)
{
	local float lYaw;

	if (distancesquared(enemy.origin, origin) < 320 * 320/* * finchsq*/)
		return true;

	lYaw = n.GetYawToOrigin(enemy.origin);
	return lYaw > 60 || lYaw < -14;
}

function bool CheckExposed_Crouch(HodNode n)
{
	if (DistanceSquared(enemy.origin, origin) < 320 * 320/* * FInchSq*/ ||
		AbsAngleClamp180(vectortoangles(enemy.origin - origin).yaw - coverNode.angles.yaw) > 45)
	{
		return true;
	}

	return false;
}

function bool CheckCoverNode(HodNode n)
{
	if (!node_isdefined(n))
		return false;

	switch (n.type)
	{
	case 'Cover Stand':
		if (animscripts_utility.IsValidEnemy(enemy)/* && CanSee(enemy)*/)
		{
			if (CheckExposed_Crouch(n))
			{
				return false;
			}
		}
		break;

	case 'Cover Crouch':
		if (animscripts_utility.IsValidEnemy(enemy)/* && CanSee(enemy)*/)
		{
			if (CheckExposed_Crouch(n))
			{
				return false;
			}
		}
		break;

	case 'Cover Left':
		if (animscripts_utility.IsValidEnemy(enemy)/* && CanSee(enemy)*/)
		{
			if (CheckExposed_Left(n))
			{
				return false;
			}
		}
		break;

	case 'Cover Right':
		if (animscripts_utility.IsValidEnemy(enemy)/* && CanSee(enemy)*/)
		{
			if (CheckExposed_Right(n))
			{
				return false;
			}
		}
		break;

	default:
		return false;
	}

	return true;
}

function bool UseCoverNode(HodNode n)
{
	local CoverSlotMarker lCoverSlot;

	// need fix
	//assert (false);
	if (!CheckCoverNode(n))
		return false;

	if (n != BestCoverNode)
		return false;

	lCoverSlot = CoverSlotMarker(n.data);
	if (lCoverSlot == none)
		return false;

	if (node_isdefined(covernode) && lCoverSlot == covernode.data)
		return false;

	moveMode = 'run';
	MoveToActor(lCoverSlot);
	//Pawn.MyTGAI.BeginCombatCommand(none, "UseCoverNode");
	Pawn.MyTGAI.bMoveGoalInterruptable = FALSE;
	goto_state('move');
	class'AICmd_MoveToCover'.static.MoveToCover(Pawn.MyTGAI, lCoverSlot.OwningSlot, TRUE, FALSE);

	return true;
}

function HodNode FindBestCoverNode(/*<nodemeaning>, <node>*/)
{
	if (!Pawn.MyTGAI.GetActiveCommand().IsA('HodState_CombatBreaker'))
	{
		BestCoverNode.Set(Pawn.MyTGAI.GetBestCoverNode());
	}
	else
		BestCoverNode.Set(none);
	return BestCoverNode;
}

function bool GetAnglesToLikelyEnemyPath(out Angle iAngle)
{
	if (!animscripts_utility.IsValidEnemy(enemy))
		return false;
	// need fix
	//assert (false);
	iAngle = vectortoangles(lastEnemyOrigin - origin);
	return true;
}

function bool CheckCoverExitPosWithPath(vector exitPos)
{
	// need fix
	//assert (false);
	return true;
}

native function bool MayMoveToPoint(vector position);

native function bool MayMoveFromPointToPoint(vector start, vector end);

function bool CanSee(HodEntity ent)
{
	//local Actor lActor;
	//local Pawn lPawn;

	//lActor = ent.GetActor();
	//lPawn = Pawn(lActor);

	//if (lPawn != none)
	//	return pawn.MyTGAI.CanSee(lPawn);
	local vector lEye;
	local vector lShootAt;

	lEye = GetEye();
	lShootAt = ent.GetShootAtPos();
	//if (vectordot(vectornormalize(lShootAt - lEye), anglestoforward(gettagangles('tag_eye'))) < 0)
	//	return false;

	return SightTracePassed(lEye, lShootAt, true, ent);
}

function bool UseReacquireNode(HodNode n)
{
	// need fix
	//assert (false);
	return false;
}

function HodNode GetReacquireNode()
{
	// need fix
	//assert (false);
	return none;
}

function FindReacquireNode()
{
	ReacquireNode.Set(none);
	// need fix
	//assert (false);
}

function bool ReacquireStep(float iDist)
{
	local vector lPoint;
	local vector lVector;
	local float lDist;
	local float lAngle;
	local vector lExtend;

	//return false;
	if (!animscripts_utility.IsValidEnemy(enemy))
		return false;

	lExtend.x = Pawn.CylinderComponent.CollisionRadius;
	lExtend.y = Pawn.CylinderComponent.CollisionRadius;
	lExtend.z = 0;//Pawn.CylinderComponent.CollisionHeight;

	if (SightTracePassed(GetEye(), enemy.GetShootAtPos(), true, enemy, lExtend * 0.8))
		return true;

	lVector = origin - enemy.origin;
	lDist = length(lVector);
	if (lDist < 120 * FInch)
		return false;

	lAngle = 2 * asin(iDist * 0.5 / lDist);
	lPoint = QuatRotateVector(QuatFromAxisAndAngle(vect(0, 0, 1), lAngle), lVector) + enemy.origin;
	lPoint.z = GetEye().z;
	if (SightTracePassed(lPoint, enemy.GetShootAtPos(), true, enemy, lExtend))
	{
		if (MayMoveToPoint(lPoint))
		{
			moveMode = 'walk';
			MoveToEnemy = true;
			goto_state('move');
			Pawn.ReacquirePosition(lPoint);
			return true;
		}
	}

	lPoint = QuatRotateVector(QuatFromAxisAndAngle(vect(0, 0, 1), -lAngle), lVector) + enemy.origin;
	lPoint.z = GetEye().z;
	if (SightTracePassed(lPoint, enemy.GetShootAtPos(), true, enemy, lExtend))
	{
		if (MayMoveToPoint(lPoint))
		{
			moveMode = 'walk';
			MoveToEnemy = true;
			goto_state('move');
			Pawn.ReacquirePosition(lPoint);
			return true;
		}
	}

	return false;
}

//function SetGoalEntity
function bool ReacquireMove()
{
	// need fix
	//assert (false);
	if (ReacquirePath == none)
		return false;

	moveMode = 'run';
	//Pawn.ReacquirePosition(Enemy.origin);
	//Pawn.MyTGAI.BeginCombatCommand(none, "ReacquireMove");

	if (ReacquirePath == enemy.GetActor())
	{
		if(Pawn.MyTGAI.RouteCache.length > 1)
		{
			Pawn.MyTGAI.RouteCache_RemoveIndex(Pawn.MyTGAI.RouteCache.length - 1, 1);
		}
		else
			return false;
	}
	MoveToActor(Pawn.MyTGAI.RouteCache[Pawn.MyTGAI.RouteCache.length - 1]);
	MoveToEnemy = true;
	goto_state('move');
	Pawn.MyTGAI.SetMoveGoal(Pawn.MyTGAI.RouteCache[Pawn.MyTGAI.RouteCache.length - 1], enemy.GetActor(), true, Pawn.GetCollisionRadius(), true);
	return true;
}

function FindReacquireDirectPath(bool ignoreSuppression)
{
	// need fix
	//assert (false);
	// Try to find path to enemy
	//Pawn.MyTGAI.ClearMovementInfo();
	if (AllowRequiredMove)
		ReacquirePath = Pawn.MyTGAI.GeneratePathTo(enemy.GetActor(),, TRUE);
	else
		ReacquirePath = none;
}

function FindReacquireProximatePath(bool ignoreSuppression)
{
	// need fix
	//assert (false);
	//Pawn.MyTGAI.ClearMovementInfo();
	if (AllowRequiredMove)
		ReacquirePath = Pawn.MyTGAI.GeneratePathTo(enemy.GetActor(),, TRUE);
	else
		ReacquirePath = none;
}

function TrackScriptState(name new_state_name, string reason)
{
	// need fix
	//assert (false);
}

function bool IsStanceAllowed(name stance)
{
	// need fixed
	//assert (false);
	switch (stance)
	{
	case 'stand': return !pawn.notAllowStand;
	case 'crouch': return !pawn.notAllowCrouch;
	case 'prone': return !pawn.notAllowProne;
	default: break;
	}
	return true;
}

// Get the motion angle in degrees for this actor
function float GetMotionAngle()
{
	// need fixed
	//return 0;
	if (length(pawn.Velocity) > 0)
		return AngleClamp180((rotator(pawn.Velocity).yaw - pawn.rotation.yaw) / 182.04);
	return 0;
}


function AnimMode(name iMode, optional bool iClearPath = false)
{
	// need fixed
	pawn.ZeroMovementVariables();
	anim_mode.mode = iMode;
	switch (iMode)
	{
		// The animation's angle and position deltas will be used, and gravity will pull the entity down.
	case 'gravity':
		pawn.Mesh.RootMotionRotationMode = RMRM_RotateActor;
		pawn.Mesh.RootMotionMode = RMM_Accel;
		break;

		// The animation's angle and position deltas will be used, gravity is ignored.
	case 'nogravity':
		pawn.SetPhysics(Phys_Flying);
		pawn.Mesh.RootMotionRotationMode = RMRM_RotateActor;
		pawn.Mesh.RootMotionMode = RMM_Accel;
		break;

		// The animation's angle deltas will be used. The position will be fixed. Gravity is effective.
	case 'angle deltas':
		pawn.Mesh.RootMotionRotationMode = RMRM_RotateActor;
		pawn.Mesh.RootMotionMode = RMM_Ignore;
		break;

		// Just like 'gravity' mode, but only the Z(up and down) of the entity's position will change.
	case 'zonly_physics':
		pawn.Mesh.RootMotionRotationMode = RMRM_RotateActor;
		pawn.Mesh.RootMotionMode = RMM_Accel;
		break;

		// Use default animmode behavior (i.e. code controls the movement)
	case 'none':
		pawn.Mesh.RootMotionRotationMode = RMRM_Ignore;
		pawn.Mesh.RootMotionMode = RMM_Ignore;
		break;
	case 'normal':
	default:
		pawn.Mesh.RootMotionRotationMode = RMRM_Ignore;
		pawn.Mesh.RootMotionMode = RMM_Velocity;
		break;
	}
}


function OrientMode(name mode, optional float iA = 0, optional float b = 0, optional float c = 0)
{
	local OrientMode_FaceAngle lFaceAngle;

	notify ('orient_mode_changed');

	switch (mode)
	{
	case 'face angle':
		lFaceAngle = new(self) class'OrientMode_FaceAngle';
		lFaceAngle.iAngle = AngleClamp180(iA - angles.yaw);
		run (lFaceAngle, true);
		break;

	case 'face motion':
		run (new(self) class'OrientMode_FaceMotion', true);
		break;

	case 'face enemy':
		run (new(self) class'OrientMode_FaceEnemy', true);
		break;

	case 'face default':
		run (new(self) class'OrientMode_FaceDefault', true);
		break;

	case 'face current':
		run (new(self) class'OrientMode_FaceCurrent', true);
		break;

	default:
		break;
	}
}

function FaceEnemy(float iDelta)
{
	angles.yaw = AngleClamp360(fixedTurn(pawn.Rotation.yaw, rotator(enemy.origin - origin).yaw, iDelta * 60000) / 182.04);
	pawn.SetRotation(anglestorotator(angles));
	pawn.SetDesiredRotation(pawn.rotation);
	angles = rotatortoangles(pawn.rotation);
}

function FaceMotion(float iDelta)
{
	angles.yaw = AngleClamp360(fixedTurn(pawn.Rotation.yaw, rotator(pawn.Velocity).yaw, iDelta * 60000) / 182.04);
	//angles.yaw = rotator(pawn.Velocity).yaw / 182.04;
	pawn.SetRotation(anglestorotator(angles));
	pawn.SetDesiredRotation(pawn.rotation);
	angles = rotatortoangles(pawn.rotation);
}

// set the actor to exit the prone position
function ExitProne(float time)
{
	// need fixed
	//assert (false);
}

function EnterProne(float time)
{
	local HodAI_EnterProne task;
	task = new(self) class'HodAI_EnterProne';
	task.iTime = time;
	run (task, true);
	// need fixed
	//assert (false);
}

// entity
function vector BulletSpread(vector iStart, vector iEnd, int iSpread)
{
	// need fixed
	return iEnd;
}

function TraceInfo BulletTrace(vector StartTrace, vector EndTrace, bool hit_charactor, optional HodEntity ignoreEntity = none)
{
	local Actor HitActor;
    local vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
	local bool result;
	local Actor ignore_actor;
	local TraceInfo ret;

	if (ignoreEntity != none)
		ignore_actor = ignoreEntity.GetActor();

	result = true;
	foreach pawn.TraceActors(class'Actor', HitActor, HitLocation, HitNormal, EndTrace, StartTrace, vect(0, 0, 0), HitInfo, TRACEFLAG_Bullet)
	{
		if (ignore_actor == HitActor)
			continue;

		if (!hit_charactor)
		{
			if (HDBasePawn(HitActor) != none)
				continue;
		}

		result = false;
		break;
	}

	if (!result)
	{
		ret.position = HitLocation;
	}
	else
	{
		ret.position = EndTrace;
	}

	return ret;
}

function bool SightTracePassed(vector StartTrace, vector EndTrace, bool hit_charactor, optional HodEntity ignoreEntity = none, optional vector iExtend = vect(0, 0, 0))
{
	local Actor HitActor;
    local vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
	local bool result;
	local Actor ignore_actor;

	if (ignoreEntity != none)
		ignore_actor = ignoreEntity.GetActor();

	result = true;
	foreach pawn.TraceActors(class'Actor', HitActor, HitLocation, HitNormal, EndTrace, StartTrace, iExtend, HitInfo, TRACEFLAG_Bullet)
	{
		if (ignore_actor == HitActor)
			continue;

		if (Trigger(HitActor) != none)
			continue;

		if (Vehicle(HitActor) != none)
			if (ignore_actor == Vehicle(HitActor).driver)
				continue;

		if (!hit_charactor)
		{
			if (HDBasePawn(HitActor) != none)
				continue;
		}

		result = false;
		break;
	}

	return result;
}

function DoDamage(float damage, vector position, optional HodEntity attacker, optional HodEntity inflictor)
{
	// need fixed
	assert(false);
}

function vector GetTagOrigin(name tagName)
{
	local vector outLocation;
	local Rotator outRotation;
	local SkeletalMeshComponent skelMesh;

	outLocation = vec_undefined;

	switch (tagName)
	{
	case 'tag_weapon':
	case 'tag_flash':
		skelMesh = SkeletalMeshComponent(pawn.MyTGWeapon.Mesh);
		break;

	default:
		skelMesh = pawn.Mesh;
		break;
	}

	if (skelMesh != none)
		skelMesh.GetSocketWorldLocationAndRotation(tagName, outLocation, outRotation, 0);

	return outLocation;
}

function Angle GetTagAngles(name tagName)
{
	local vector outLocation;
	local Rotator outRotation;
	local Angle ret;
	local SkeletalMeshComponent skelMesh;

	switch (tagName)
	{
	case 'tag_weapon':
	case 'tag_flash':
		skelMesh = SkeletalMeshComponent(pawn.MyTGWeapon.Mesh);
		break;

	default:
		skelMesh = pawn.Mesh;
		break;
	}

	if (skelMesh != none && skelMesh.GetSocketWorldLocationAndRotation(tagName, outLocation, outRotation, 0))
		ret = RotatorToAngles(outRotation);
	return ret;
}

function float GetAnimLength(name anim)
{
	return human_anim.TGetAnimLength(anim);
}

function vector GetMoveDelta(name anim, float startTime, float endTime)
{
	return human_anim.TGetMoveDelta(anim, startTime, endTime);
}

function float GetAngleDelta(name anim, float startTime, float endTime)
{
	return human_anim.TGetAngleDelta(anim, startTime, endTime);
}

function bool AnimHasNoteTrack(name anim, name note_track, optional float startTime = 0.f, optional float endTime = 1.f)
{
	return human_anim.TAnimHasNoteTrack(anim, note_track, startTime, endTime);
}

function float GetAnimTime(name anim)
{
	return human_anim.TGetAnimTime(anim);
}

function SetAnim(name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnim(ha, weight, time, rate);
}

function SetAnimKnob(name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimKnob(ha, weight, time, rate);
}

function SetAnimKnobAll(name ha, name root, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimKnobAll(ha, root, weight, time, rate);
}

function SetAnimKnobAllLimited(name ha, name root, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimKnobAllLimited(ha, root, weight, time, rate);
}

function SetAnimKnobAllLimitedRestart(name ha, name root, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimKnobAllLimitedRestart(ha, root, weight, time, rate);
}

function SetAnimKnobAllRestart(name ha, name root, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimKnobAllRestart(ha, root, weight, time, rate);
}

function SetAnimKnobLimited(name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimKnobLimited(ha, weight, time, rate);
}

function SetAnimKnobLimitedRestart(name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimKnobLimitedRestart(ha, weight, time, rate);
}

function SetAnimKnobRestart(name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimKnobRestart(ha, weight, time, rate);
}

function SetAnimLimited(name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimLimited(ha, weight, time, rate);
}

function SetAnimLimitedRestart(name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimLimitedRestart(ha, weight, time, rate);
}

function SetAnimRestart(name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetAnimRestart(ha, weight, time, rate);
}

function SetFlaggedAnim(name notify, name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnim(notify, ha, weight, time, rate);
}

function SetFlaggedAnimKnob(name notify, name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimKnob(notify, ha, weight, time, rate);
}

function SetFlaggedAnimKnobAll(name notify, name ha, name root, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimKnobAll(notify, ha, root, weight, time, rate);
}

function SetFlaggedAnimKnobAllLimited(name notify, name ha, name root, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimKnobAllLimited(notify, ha, root, weight, time, rate);
}

function SetFlaggedAnimKnobAllLimitedRestart(name notify, name ha, name root, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimKnobAllLimitedRestart(notify, ha, root, weight, time, rate);
}

function SetFlaggedAnimKnobAllRestart(name notify, name ha, name root, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimKnobAllRestart(notify, ha, root, weight, time, rate);
}

function SetFlaggedAnimKnobLimited(name notify, name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimKnobLimited(notify, ha, weight, time, rate);
}

function SetFlaggedAnimKnobLimitedRestart(name notify, name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimKnobLimitedRestart(notify, ha, weight, time, rate);
}

function SetFlaggedAnimKnobRestart(name notify, name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimKnobRestart(notify, ha, weight, time, rate);
}

function SetFlaggedAnimLimited(name notify, name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimLimited(notify, ha, weight, time, rate);
}

function SetFlaggedAnimLimitedRestart(name notify, name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimLimitedRestart(notify, ha, weight, time, rate);
}

function SetFlaggedAnimRestart(name notify, name ha, float weight = 1.0, float time = 0.2, float rate = 1.0)
{
	human_anim.TSetFlaggedAnimRestart(notify, ha, weight, time, rate);
}

function ClearAnim(name ha, float time)
{
	human_anim.TClearAnim(ha, time);
}

function name SetCustomAnim(array<TGAnimNodeSequence> slots, name ha, optional float rate = 1.0, optional bool iLoop = false)
{
	local int i;
	for (i = 0; i < slots.length; i ++)
	{
		if (slots[i].AnimName == ha && slots[i].RateModifier == rate  && slots[i].bLooping == iLoop)
			break;
	}

	if (i >= slots.length)
	{
		for (i = 0; i < slots.length; i ++)
		{
			if (!slots[i].IsActive())
				break;
		}
	}

	if (i >= slots.length)
		i = 0;

	slots[i].SetAnimName(ha);
	slots[i].RateModifier = rate;
	slots[i].bLooping = iLoop;

	return slots[i].NodeName;
}

// enter
function SetOrigin(vector iPosition)
{
	//iPosition.z += Pawn.CylinderComponent.CollisionHeight * 0.5;
	Pawn.Move(iPosition - origin);
	origin = Pawn.Location;
	origin.z -= Pawn.CylinderComponent.CollisionHeight;
}

function NotifySuppressed()
{
	suppressionMeter = FMin(suppressionMeter + 0.15, 1.0);
	notify ('suppression');
}

function DoTurret()
{
	local HodAI_DoTurret task;

	task = new(self) class'HodAI_DoTurret';
	run (task, true);

}

function DoMelee(HodState_Melee iState)
{
	local HodAI_DoMelee task;
	task = new(self) class'HodAI_DoMelee';
	task.iState = iState;
	run (task, true);
}

function DoPain(HodState_Pain iState)
{
	local HodAI_DoPain task;
	task = new(self) class'HodAI_DoPain';
	task.iState = iState;
	run (task, true);
}

function DoDeath(optional HodState_Death iState)
{
	local HodAI_DoDeath task;
	task = new(self) class'HodAI_DoDeath';
	task.iState = iState;
	run (task, true);
}

function DoCover(HodState_Cover iState)
{
	local HodAI_DoCover task;
	task = new(self) class'HodAI_DoCover';
	task.iState = iState;
	run (task, true);
}

function DoExposed(HodState_Exposed iState)
{
	local HodAI_DoExposed task;
	task = new(self) class'HodAI_DoExposed';
	task.iState = iState;
	run (task, true);
}

function DoMove(optional HodState_Move iState)
{
	local HodAI_DoMove task;
	task = new(self) class'HodAI_DoMove';
	task.iState = iState;
	run (task, true);
}

function DoArrival(HodState_Arrival iState)
{
	local HodAI_DoArrival task;
	task = new(self) class'HodAI_DoArrival';
	task.iState = iState;
	run (task, true);
}

function DoCombatBreaker(HodState_CombatBreaker iState)
{
	local HodAI_DoCombatBreaker task;
	task = new(self) class'HodAI_DoCombatBreaker';
	task.iState = iState;
	run (task, true);
}

function DoCustomAnim(HodState_CustomAnim iState)
{
	local HodAI_DoCustomAnim task;
	task = new(self) class'HodAI_DoCustomAnim';
	task.iState = iState;
	run (task, true);
}

function DoNegotiation(HodState_Negotiation iState)
{
	local HodAI_DoNegotiation task;
	task = new(self) class'HodAI_DoNegotiation';
	task.iState = iState;
	run (task, true);
}

function goto_state(name iState)
{
	if (pawn.MyTGAI != none)
	{
		pawn.MyTGAI.AbortCommand(pawn.MyTGAI.CommandList);
		assert (!pawn.MyTGAI.GetActiveCommand().isA('HodState_Pain'));
	}

	//notify ('killanimscript');

	switch (iState)
	{
	case 'exposed':
		class'HodState_Exposed'.static.Start(self);
		break;

	case 'cover':
		class'HodState_Cover'.static.Start(self);
		break;

	case 'move':
		class'HodState_Move'.static.Start(self);
		break;

	case 'death':
		//assert (pawn.MyTGAI == none);
		class'HodState_Death'.static.Start(self);
		break;

	case 'pain':
		class'HodState_Pain'.static.Start(self);
		break;

	case 'melee':
		class'HodState_Melee'.static.Start(self);
		break;

	default:
		assert(false);
	}
}

function push_state(name iState)
{
	//notify ('killanimscript');
	switch (iState)
	{
	//case 'pain':
	//	class'HodState_Pain'.static.Start(self);
	//	break;

	case 'arrival':
		class'HodState_Arrival'.static.Start(self);
		break;

	case 'combat_breaker':
		class'HodState_CombatBreaker'.static.Start(self);
		break;

	default:
		assert(false);
	}
}

function CheckMoveTransition()
{
	if (Pawn.MyTGAI != none)
		Pawn.MyTGAI.CheckMoveTransition();
}


function DoScript(name script)
{
	return;
}

function EnterState(name InState)
{
}

function MoveToActor(Actor iActor)
{
	if (node_isdefined(node))
		prevNode.Set(pawn.anchor);
	node.Set(iActor);
	pathGoalPos = node.origin;
}

function MoveToPoint(vector iPoint)
{
	if (node_isdefined(node))
		prevNode.Set(pawn.anchor);
	node.Set(none);
	pathGoalPos = iPoint;
}

function ReachGoal(optional Actor iActor, optional vector iPoint = vec_undefined)
{
	if ((node_isdefined(node) && iActor != none && node.data == iActor) ||
		(!node_isdefined(node) && vec_isdefined(iPoint) && iPoint == pathGoalPos))
		pathGoalPos = invalid_vector;
}

function DetectCadaver(bool iEnable)
{
	local HodAI_DetectCadaver task;
	task = new(self) class'HodAI_DetectCadaver';
	task.iEnable = iEnable;
	run (task, true);
}

function ApproachGoal(optional Actor iActor, optional vector iPoint = vec_undefined)
{
	if ((node_isdefined(node) && iActor != none && node.data == iActor) ||
		(!node_isdefined(node) && vec_isdefined(iPoint) && iPoint == pathGoalPos))
		run (new(self) class'HodAI_CoverApproach', true);
}

function int GetUniqueID()
{
	++ animscripts_utility.unique_id;
	return animscripts_utility.unique_id;
}

function ResetAnimArray()
{
	a.array.Remove(0, a.array.length);
	a.array.Add(anim_array_element_count);
}

function SetAnimArray(name n, name anim)
{
	assert (AnimArrayID(n) < a.array.length);
	a.array[AnimArrayID(n)].data.AddItem(anim);
}

function SetAnimArrayE(name n, name anim)
{
	local int lId;
	lId = AnimArrayID(n);
	assert (lId < a.array.length);
	a.array[lId].data.Remove(0, a.array[lId].data.length);
	a.array[lId].data.AddItem(anim);
}

function int AnimArrayID(name iType)
{
	switch (iType)
	{
		
		





case 'add_aim_up': return anim_array_add_aim_up;
case 'add_aim_down': return anim_array_add_aim_down;
case 'add_aim_left': return anim_array_add_aim_left;
case 'add_aim_right': return anim_array_add_aim_right;

case 'fire': return anim_array_fire;
case 'straight_level': return anim_array_straight_level;
case 'reload': return anim_array_reload;
case 'reload_crouchhide': return anim_array_reload_crouchhide;

case 'exposed_idle': return anim_array_exposed_idle;

case 'idle1': return anim_array_idle1;
case 'idle2': return anim_array_idle2;
case 'idle3': return anim_array_idle3;

case 'single': return anim_array_single;

case 'semi2': return anim_array_semi2;
case 'semi3': return anim_array_semi3;
case 'semi4': return anim_array_semi4;
case 'semi5': return anim_array_semi5;

case 'burst2': return anim_array_burst2;
case 'burst3': return anim_array_burst3;
case 'burst4': return anim_array_burst4;
case 'burst5': return anim_array_burst5;
case 'burst6': return anim_array_burst6;

case 'crouch_2_stand': return anim_array_crouch_2_stand;
case 'crouch_2_prone': return anim_array_crouch_2_prone;
case 'stand_2_crouch': return anim_array_stand_2_crouch;
case 'stand_2_prone': return anim_array_stand_2_prone;
case 'prone_2_crouch': return anim_array_prone_2_crouch;
case 'prone_2_stand': return anim_array_prone_2_stand;

case 'turn_left_45': return anim_array_turn_left_45;
case 'turn_left_90': return anim_array_turn_left_90;
case 'turn_left_135': return anim_array_turn_left_135;
case 'turn_left_180': return anim_array_turn_left_180;
case 'turn_right_45': return anim_array_turn_right_45;
case 'turn_right_90': return anim_array_turn_right_90;
case 'turn_right_135': return anim_array_turn_right_135;
case 'turn_right_180': return anim_array_turn_right_180;

case 'add_turn_aim_up': return anim_array_add_turn_aim_up;
case 'add_turn_aim_down': return anim_array_add_turn_aim_down;
case 'add_turn_aim_left': return anim_array_add_turn_aim_left;
case 'add_turn_aim_right': return anim_array_add_turn_aim_right;

case 'look': return anim_array_look;
case 'hide_to_look': return anim_array_hide_to_look;
case 'look_idle': return anim_array_look_idle;
case 'look_to_hide': return anim_array_look_to_hide;
case 'look_to_hide_fast': return anim_array_look_to_hide_fast;

case 'grenade_safe': return anim_array_grenade_safe;
case 'grenade_exposed': return anim_array_grenade_exposed;

case 'prone_idle': return anim_array_prone_idle;

case 'stand_2_prone_firing': return anim_array_stand_2_prone_firing;
case 'crouch_2_prone_firing': return anim_array_crouch_2_prone_firing;
case 'prone_2_stand_firing': return anim_array_prone_2_stand_firing;
case 'prone_2_crouch_firing': return anim_array_prone_2_crouch_firing;

case 'hide_idle': return anim_array_hide_idle;
case 'hide_idle_twitch': return anim_array_hide_idle_twitch;
case 'hide_idle_flinch': return anim_array_hide_idle_flinch;

case 'hide_2_crouch': return anim_array_hide_2_crouch;
case 'hide_2_stand': return anim_array_hide_2_stand;
case 'hide_2_lean': return anim_array_hide_2_lean;

case 'crouch_2_hide': return anim_array_crouch_2_hide;
case 'stand_2_hide': return anim_array_stand_2_hide;
case 'lean_2_hide': return anim_array_lean_2_hide;

case 'crouch_aim': return anim_array_crouch_aim;
case 'stand_aim': return anim_array_stand_aim;
case 'lean_aim': return anim_array_lean_aim;

case 'blind_fire': return anim_array_blind_fire;
case 'rambo': return anim_array_rambo;

case 'lean_aim_straight': return anim_array_lean_aim_straight;
case 'lean_aim_left': return anim_array_lean_aim_left;
case 'lean_aim_right': return anim_array_lean_aim_right;
case 'lean_aim_up': return anim_array_lean_aim_up;
case 'lean_aim_down': return anim_array_lean_aim_down;
case 'lean_reload': return anim_array_lean_reload;
case 'lean_idle': return anim_array_lean_idle;
case 'lean_single': return anim_array_lean_single;
case 'lean_fire': return anim_array_lean_fire;

case 'hide_to_A': return anim_array_hide_to_A;
case 'hide_to_B': return anim_array_hide_to_B;
case 'A_to_hide': return anim_array_A_to_hide;
case 'A_to_B': return anim_array_A_to_B;
case 'B_to_hide': return anim_array_B_to_hide;
case 'B_to_A': return anim_array_B_to_A;
case 'lean_to_hide': return anim_array_lean_to_hide;
case 'hide_to_lean': return anim_array_hide_to_lean;

case 'stance_change': return anim_array_stance_change;
case 'B_to_hide_reload': return anim_array_B_to_hide_reload;















	

#linenumber 1970;

	default: break;
	}

	return anim_array_element_count;
}


function int NodeTypeID(name iType)
{
	switch (iType)
	{
	case 'Cover Left': return 0;
	case 'Cover Left Wide': return 1;
	case 'Cover Right': return 2;
	case 'Cover Right Wide': return 3;
	case 'Cover Crouch': return 4;
	case 'Conceal Crouch': return 5;
	case 'Cover Crouch Window': return 6;
	case 'Cover Stand': return 7;
	case 'Conceal Stand': return 8;
	case 'Cover Prone': return 9;
	case 'Conceal Prone': return 10;
	case 'Path': return 11;
	case 'Guard': return 12;

	default: break;
	}

	assert(false);
	return -1;
}

function int TransTypeID(name iType)
{
	switch (iType)
	{
	case 'left': return 0;
	case 'right': return 1;
	case 'left_crouch': return 2;
	case 'right_crouch': return 3;
	case 'crouch': return 4;
	case 'stand': return 5;
	case 'exposed': return 6;
	case 'exposed_crouch': return 7;
	case 'stand_saw': return 8;
	case 'prone_saw': return 9;
	case 'crouch_saw': return 10;
	case 'wall_over_40': return 11;

	default: break;
	}

	assert(false);
	return -1;
}

function int PoseID(name iType)
{
	switch (iType)
	{
	case 'stand': return 0;
	case 'crouch': return 1;
	case 'prone': return 2;

	default: break;
	}

	assert (false);
	return -1;
}

function int WeaponPoseID(name iType)
{
	switch (iType)
	{
	case 'left': return 0;
	case 'right': return 1;
	case 'chest': return 2;
	case 'back': return 3;

	default: break;
	}

	assert (false);
	return -1;
}
