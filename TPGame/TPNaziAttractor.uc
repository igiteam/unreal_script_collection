//this is TOTALLY jacked from KryllRepulsor in GoW
class TPNaziAttractor extends Actor
	placeable
	native;

/** Repulsor is spherical, this is the sphere radius. */
var() float		Radius;

/** True if this repulsor is currently active, false otherwise. */
var() bool		bEnabled;

var	private DrawSphereComponent					SphereRenderComponent;
var() float		DoomTimer;
var() float		RefireTimer;
var() int		DamagePerShot;
var float		CurrentRefire;
var PlayerPawn  Player;
var Actor		Target;
var() ParticleSystem MuzzleFlashTemplate;
var() vector	MuzzleFlashOffset;
var() bool		bCheckSight;
var() float		StopShootingTimer;

var SeqAct_ZepFireAtTarget FireSeqAction;

var SoundCue FireEffectSound, StopFireSound;
var AudioComponent FireEffectSoundCmpt;
var bool bAudioAttached;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated function PostBeginPlay()
{
	if (WorldInfo.Game != None)
	{
		TPGameInfo(WorldInfo.Game).RegisterNaziAttractor(self);
	}
	super.PostBeginPlay();
}

simulated event Destroyed()
{
	if (bAudioAttached)
		Player.DetachComponent(FireEffectSoundCmpt);
}

simulated function SetEnabled( bool bNewEnabled )
{
	if( bNewEnabled != bEnabled )
	{
		bEnabled = bNewEnabled;
	}
}

native simulated function SetRadius(float NewRadius);

/** Returns true if TestLoc is inside the repulsor, false otherwise. */
native simulated function bool Encompasses(vector TestLoc);

event NaziAttractorDoom()
{
	//`log("Firing timer!");
	PushState('AttractorDoom');
}

event Tick( float DeltaTime )
{
	local PlayerController PC;

	if (!bEnabled)
		return;

	if (Player == None)
	{
		ForEach LocalPlayerControllers(class'PlayerController', PC)
		{
			Player = PlayerPawn(PC.Pawn);
		}

		return;
	}

	if (Target == None)
		Target = Player;

	if (Target != None)
	{
		if (!bAudioAttached && FireEffectSound != None)
		{
			FireEffectSoundCmpt.SoundCue = FireEffectSound;
			Player.AttachComponent(FireEffectSoundCmpt);
			bAudioAttached=true;
		}

		if (Encompasses(Target.Location))
		{
			if (!IsTimerActive('NaziAttractorDoom'))
			{
                if (Owner.IsA('TPAssaultBlimp_Persistent'))
				{
					TPAssaultBlimpController(TPAssaultBlimp_Persistent(Owner).Controller).PlayBlimpAlarm(Target);
				}
                SetTimer(DoomTimer, false, 'NaziAttractorDoom');
			}
		}
		else if (IsTimerActive('NaziAttractorDoom'))
		{
			ClearTimer('NaziAttractorDoom');
		}
	}
}

simulated function SpawnFireEffect()
{
	local EmitterSpawnable emitter;

	emitter = Spawn( class'EmitterSpawnable', , , Location + MuzzleFlashOffset);
	emitter.SetTemplate( MuzzleFlashTemplate, true );
	emitter.bDestroyOnSystemFinish = true;
	emitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0f;
	emitter.ParticleSystemComponent.ActivateSystem();
}

state AttractorDoom
{
    event PushedState()
    {
        if (Owner.IsA('TPAssaultBlimp_Persistent'))
        {
            FireSeqAction = new class'SeqAct_ZepFireAtTarget';
            FireSeqAction.Targets[0] = Target;
            TPAssaultBlimpController(TPAssaultBlimp_Persistent(Owner).Controller).OnZepFireAtTarget(FireSeqAction);
        }
    }

	event Tick( float DeltaTime )
	{
		local PlayerController blah;
		blah = None;

		if (Target == None)
			Target = Player;

		if (Target != None)
		{
			if (Encompasses(Target.Location))
			{
				if (IsTimerActive('LeaveAttractorDoom'))
				{
					ClearTimer('LeaveAttractorDoom');
				}

				CurrentRefire+=DeltaTime;
				if (CurrentRefire > RefireTimer)
				{
					CurrentRefire=0.0f;
					if (Owner.IsA('TPAssaultBlimp_Persistent'))
					{
                        // do nothing
					}
					else
					{
					    if (!FireEffectSoundCmpt.bWasPlaying)
				            FireEffectSoundCmpt.Play();

						Target.TakeDamage(DamagePerShot, blah, Target.Location, vect(0.0f,0.0f,1.0f), class'TPDamageTypeImpactMP50',,self);
						//Player.PlaySound(SoundCue'S_Dst_Explosions.Scene.Explosion_Blimp_Cue');
						SpawnFireEffect();
					}
				}
			}
			else if (!IsTimerActive('LeaveAttractorDoom'))
			{
				SetTimer(StopShootingTimer, false, 'LeaveAttractorDoom');
			}
		}
	}

	event LeaveAttractorDoom()
	{
		if (FireEffectSoundCmpt.bWasPlaying)
			FireEffectSoundCmpt.Stop();
		Player.PlaySound(StopFireSound);

        if (Owner.IsA('TPAssaultBlimp_Persistent'))
        {
            FireSeqAction = None;
            TPAssaultBlimpController(TPAssaultBlimp_Persistent(Owner).Controller).OnZepStopFire(None);
        }

		PopState();
	}
}



