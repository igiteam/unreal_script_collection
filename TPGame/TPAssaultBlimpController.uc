class TPAssaultBlimpController extends TPAIController
    dependson(TPAssaultBlimp_Persistent)
	native;


var TPSkelControlPlayerPitch skel_GunPitch;
var int                      GunPitchDir;

var TPAssaultBlimp_Persistent      Blimp;

var SeqAct_PlayPerformance   PlayPerf;

var SeqAct_ZepFireAtTarget   FireSeqAction;

var float                    Timer;
var float                    CheckTime;
var int                      CheckIndexL;
var int                      CheckIndexR;

var SeqAct_BlimpNaziFactory  NaziFactory;

var TPSkelControlPlayerPitch skel_Spotlight_R_Oscillate;
var TPSkelControlPlayerYaw skel_Spotlight_R_Pivot;
var TPSkelControlPlayerPitch skel_Spotlight_L_Oscillate;
var TPSkelControlPlayerYaw skel_Spotlight_L_Pivot;

var int						 Spotlight_R_Osc_Dir;
var int						 Spotlight_R_Piv_Dir;
var int						 Spotlight_L_Osc_Dir;
var int						 Spotlight_L_Piv_Dir;
var Actor					 Spotlight_R_LookTarget;
var Actor					 Spotlight_L_LookTarget;
var float					 Spotlight_R_RecentlySaw;
var float					 Spotlight_L_RecentlySaw;
// var float					 SpotlightRememberPlayerTime;
// 
// var float					 SpotlightSearchSpeed;
// var float					 SpotlightSeekSpeed;

//var int CurrentMuzzle;

var float OverheatTime;
var float CooldownTime;
var float CurrOverheatTime;
var float CurrCooldownTime;
var Float LastAlarmTime;

var Actor CurrentTurretTarget;
var float TurretRefireTimer;
var float CurrentTurretRefire;
var bool bTurretShootingAtTarget;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	super.Possess(aPawn,bVehicleTransition);

    skel_GunPitch = TPSkelControlPlayerPitch(Pawn.Mesh.FindSkelControl('GunSkelPitch'));
	if (skel_GunPitch == None)
    {
		;
    }
    else
    {
        skel_GunPitch.SetSkelControlActive(true);
        skel_GunPitch.ControlStrength = 1.0;
    }

	Blimp = TPAssaultBlimp_Persistent(aPawn);
    if (Blimp == None)
    {
        ;
    }

	skel_Spotlight_R_Oscillate = TPSkelControlPlayerPitch(Pawn.Mesh.FindSkelControl('R_LightOscillate'));
	skel_Spotlight_R_Pivot = TPSkelControlPlayerYaw(Pawn.Mesh.FindSkelControl('R_LightPivot'));
	skel_Spotlight_L_Oscillate = TPSkelControlPlayerPitch(Pawn.Mesh.FindSkelControl('L_LightOscillate'));
	skel_Spotlight_L_Pivot = TPSkelControlPlayerYaw(Pawn.Mesh.FindSkelControl('L_LightPivot'));

	SetSpotlightSkelControls(Blimp.SpotlightBehavior);

    PlayPerf = new class'SeqAct_PlayPerformance';
    PlayPerf.PerformanceAnimTree = Blimp.PerfAnimTree;
}

simulated function Destroyed()
{
	// Clear the various controllers
	skel_Spotlight_R_Oscillate.SetSkelControlActive(false);
	skel_Spotlight_R_Oscillate = None;
		
	skel_Spotlight_R_Pivot.SetSkelControlActive(false);
	skel_Spotlight_R_Pivot = None;
		
	skel_Spotlight_L_Oscillate.SetSkelControlActive(false);
	skel_Spotlight_L_Oscillate = None;
		
	skel_Spotlight_L_Pivot.SetSkelControlActive(false);
	skel_Spotlight_L_Pivot = None;
	
	Super.Destroyed();
}

function SetSpotlightSkelControls(ESpotlightBehavior SpotlightBehavior)
{
	if (SpotlightBehavior != Spotlight_NONE)
	{
		skel_Spotlight_R_Oscillate.SetSkelControlActive(true);
		skel_Spotlight_R_Oscillate.ControlStrength = 1.0;
		skel_Spotlight_R_Oscillate.BoneRotation.Pitch = -80;
		
		skel_Spotlight_R_Pivot.SetSkelControlActive(true);
		skel_Spotlight_R_Pivot.ControlStrength = 1.0;
		
		skel_Spotlight_L_Oscillate.SetSkelControlActive(true);
		skel_Spotlight_L_Oscillate.ControlStrength = 1.0;
		skel_Spotlight_L_Oscillate.BoneRotation.Pitch = -80;
		
		skel_Spotlight_L_Pivot.SetSkelControlActive(true);
		skel_Spotlight_L_Pivot.ControlStrength = 1.0;
	}
	else
	{
		skel_Spotlight_R_Oscillate.SetSkelControlActive(false);
		skel_Spotlight_R_Pivot.SetSkelControlActive(false);
		
		skel_Spotlight_L_Oscillate.SetSkelControlActive(false);
		skel_Spotlight_L_Pivot.SetSkelControlActive(false);
	}
}

function OnBlimpGunner(SeqAct_BlimpGunner Act)
{
    switch (Act.Gunner)
    {
        case BG_Blimp:
            Blimp.BlimpGunner.OnPhantomGunner(Act);
            Blimp.BlimpGunner.GunFireSound=Blimp.GunSound;
            break;
        case BG_MountedL:
            Blimp.MountedGunnerL.OnPhantomGunner(Act);
            Blimp.BlimpGunner.GunFireSound=Blimp.GunSound;
            break;
    }
}

function OnBlimpNaziFactory (SeqAct_BlimpNaziFactory Act)
{
    // Log a warning if NaziFactory is replaced before
    // the current one has finished
    if (NaziFactory != None)
    {
        ;
    }

    NaziFactory = Act;
}

native final function OnBlimpNazisModifierProcess( SeqAct_BlimpNaziModifier Act );


function OnBlimpNaziModifier(SeqAct_BlimpNaziModifier Act)
{
	OnBlimpNazisModifierProcess(Act);
}

native final function OnBlimpNazisProcess( SeqAct_BlimpNazis Act );

function OnBlimpNazis(SeqAct_BlimpNazis Act)
{
	OnBlimpNazisProcess(Act);
}

native function bool SpawnGunner(class<WehrmachtPawn> WehrType, ABS_Side Side, out WehrmachtPawn SpawnTarget);

native final function ProcessBlimpForKilling( float DeltaTime );

native final function MuzzleFlashTimer();

auto state Patroling
{
    function Tick (float DeltaTime)
    {
		FindPlayerController();

		//`log(" ChadAI - Blimp: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TPAssaultBlimpController::Tick m_ThePlayerController: " @ m_ThePlayerController @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		ProcessBlimpForKilling( DeltaTime );
    }
}

function OnZepFireAtTarget(SeqAct_ZepFireAtTarget Action)
{
	local array<Object> myTarget;
	Action.GetObjectVars(myTarget,"Attack Target");

    if (myTarget.Length == 0)  // i.e. If targets were set in script
        myTarget = Action.Targets;

    if (myTarget.Length > 0)
	{
        FireSeqAction = Action;

		//`log("Setting RightTarget to"@RightTarget[0]);
		if (myTarget[0].IsA('Controller'))
			myTarget[0] = Controller(myTarget[0]).Pawn;

		CurrentTurretTarget = Actor(myTarget[0]);
		bTurretShootingAtTarget = true;
		CurrOverheatTime = 0.0f;
		CurrCooldownTime = 0.0f;
        m_bCoolDown        = false;
        OverheatTime     = FireSeqAction.GetOverheatTime();
        CooldownTime     = FireSeqAction.GetCooldownTime();
	}
}

function OnZepStopFire(SeqAct_ZepStopFire Action)
{
    FireSeqAction = None;
	bTurretShootingAtTarget = false;
}

function PlayBlimpAlarm(Actor BlimpTarget)
{
	if (WorldInfo.TimeSeconds - LastAlarmTime > 8.75f) // The magic number here is the length of the alarm sound
	{
		BlimpTarget.PlaySound(Blimp.AlarmSound);
		LastAlarmTime = WorldInfo.TimeSeconds;
	}
}

