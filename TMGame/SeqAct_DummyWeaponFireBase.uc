//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SeqAct_DummyWeaponFireBase extends SeqAct_Latent
abstract
native;

/** Number of shots to fire in sequence */
var() int				ShotsToFire;

/** internal, number of shots that have been fired */
var protected int		ShotsFired;

/** TRUE to keep shooting forever (ignore ShotsToFire) */
var() bool				bShootUntilStopped;

/** Shooting inaccuracy, in degrees */
var() float				InaccuracyDegrees;

/** Which firing mode to fire the weapon. */
var() byte				FiringMode;

/** True if weapon is trying to fire, false if not (e.g. in a delay) */
var bool				bFiring;

/** true if action was stopped via the Stop input */
var protected bool		bStopped;

/** true if action finished naturally */
var protected bool		bFinished;

/** if TRUE, do not play any weapon-fire-related audio (incl impacts) */
var() bool				bSuppressAudio;

/** if TRUE, do not show weapon muzzle flash */
var() bool				bSuppressMuzzleFlash;

/** if TRUE, do not show weapon tracers if appropriate */
var() bool				bSuppressTracers;

var() int				NewDamage;
var() int               NewFireRate;

/** actor where the weapon fire is coming from */
var Actor TheOrigin;

/** target actor for the weapon fire */
var Actor TheTarget;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Enumerate the supported objet list cycle methods */
enum DummyFireObjectCyclingMethod
{
	/** move through targets array in order */
	DFOCM_Sequential,

	/** choose targets randomly.  can result in a target chosen multiple times in a row */
	DFOCM_Random,

	// support random without repeats?
};

/** Convenient wrapper for parameters used to define behavior when dealing with multiple objects */
struct native DummyFireObjectListParams
{
	/** Range, in seconds, for how long to fire at each target. */
	var() const vector2d						SecondsPerObject;

	/**
	 * Range, in seconds, for how long to wait between stopping using
	 * one object and starting to use another.  Object is considered NULL during this period.
	 */
	var() const vector2d						ObjectChangeDelay;

	/** Target cycling method, affects how targets are chosen */
	var() const DummyFireObjectCyclingMethod	CyclingMethod;

	/** Internal.  Seconds until next object change. */
	var float							TimeUntilObjectChange;

	/** Internal.  True if a delay is active.  Current object is considered to be NULL. */
	var bool							bDelay;

	/** Internal.  Seconds until delay is finished and we move onto the next object. */
	var float							DelayTimeRemaining;

	/** Internal.  Index of current object that we're using. */
	var int								CurrentObjIdx;

	structdefaultproperties
	{
		SecondsPerObject=(X=1.f,Y=2.f)
		ObjectChangeDelay=(X=0.5f,Y=1.5f)
		CyclingMethod=DFOCM_Sequential
	}
};

/** Parameters defining multiple-target behavior.  No effect if only 1 target actor is specified. */
var() protected DummyFireObjectListParams MultipleTargetParams;

/** Parameters defining multiple-source behavior.  No effect if only 1 origin actor is specified.  */
var() protected DummyFireObjectListParams MultipleOriginParams;


final native function bool UpdateOriginTarget(float DeltaTime);


