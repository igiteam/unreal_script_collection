/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMPawnSoundGroup extends Object
	abstract
	dependson(TMPhysicalMaterialProperty);

var SoundCue DodgeSound;
var SoundCue DoubleJumpSound;
var SoundCue DefaultJumpingSound;
var SoundCue LandSound;
var SoundCue FallingDamageLandSound;
var SoundCue DyingSound;
var SoundCue HitSounds[3];
var SoundCue FemaleHitSounds[3];
var SoundCue GibSound;
var SoundCue DrownSound;
var SoundCue GaspSound;
var SoundCue GNWalkSound;
var SoundCue GNCrouchSound;
var SoundCue GNCrawlSound;

struct FootstepSoundInfo
{
	var name MaterialType;
	var SoundCue Sound;
};
/** footstep sound effect to play per material type */
var array<FootstepSoundInfo> FootstepSounds;

/** footstep sound effect to play per material type */
var array<FootstepSoundInfo> CrouchedFootstepSounds;

/** default footstep sound used when a given material type is not found in the list */
var SoundCue DefaultFootstepSound;

var array<FootstepSoundInfo> JumpingSounds;

var array<FootstepSoundInfo> LandingSounds;
var SoundCue DefaultLandingSound;

// The following are /body/ sounds, not vocals:
/* sound for regular bullet hits on the body */
var SoundCue BulletImpactSound;
/* sound from being crushed, such as by a vehicle */
var SoundCue CrushedSound;
/* sound when the body is gibbed*/
var SoundCue BodyExplosionSound;
var SoundCue InstagibSound;

static function PlayInstagibSound(Pawn P)
{
	P.Playsound(Default.InstagibSound, false, true);
}

static function PlayBulletImpact(Pawn P)
{
	P.PlaySound(Default.BulletImpactSound, false, true);
}

static function PlayCrushedSound(Pawn P)
{
	P.PlaySound(Default.CrushedSound,false,true);
}

static function PlayBodyExplosion(Pawn P)
{
	P.PlaySound(Default.CrushedSound,false,true);
}

static function PlayDodgeSound(Pawn P)
{
	P.PlaySound(Default.DodgeSound, false, true);
}

static function PlayDoubleJumpSound(Pawn P)
{
	P.PlaySound(Default.DoubleJumpSound, false, true);
}

static function PlayJumpSound(Pawn P)
{
	P.PlaySound(Default.DefaultJumpingSound, false, true);
}

static function PlayLandSound(Pawn P)
{
    //    PlayOwnedSound(GetSound(EST_Land), SLOT_Interact, FMin(1,-0.3 * P.Velocity.Z/P.JumpZ));
	P.PlaySound(Default.LandSound, false, true);
}

static function PlayFallingDamageLandSound(Pawn P)
{
	P.PlaySound(Default.FallingDamageLandSound, false, true);
}

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	local int i;

	i = default.FootstepSounds.Find('MaterialType', MaterialType);
	return (i == -1 || MaterialType=='') ? default.DefaultFootstepSound : default.FootstepSounds[i].Sound; // checking for a '' material in case of empty array elements
}

static function SoundCue GetCrouchedFootstepSound(int FootDown, name MaterialType)
{
	local int i;

	i = default.CrouchedFootstepSounds.Find('MaterialType', MaterialType);
	return (i == -1 || MaterialType=='') ? default.DefaultFootstepSound : default.FootstepSounds[i].Sound; // checking for a '' material in case of empty array elements
}

static function SoundCue GetJumpSound(name MaterialType)
{
	local int i;
	i = default.JumpingSounds.Find('MaterialType', MaterialType);
	return (i == -1 || MaterialType=='') ? default.DefaultJumpingSound : default.JumpingSounds[i].Sound; // checking for a '' material in case of empty array elements
}

static function SoundCue GetLandSound(name MaterialType)
{
	local int i;
	i = default.LandingSounds.Find('MaterialType', MaterialType);
	return (i == -1 || MaterialType=='') ? default.DefaultLandingSound : default.LandingSounds[i].Sound; // checking for a '' material in case of empty array elements
}

static function PlayDyingSound(Pawn P)
{
	P.PlaySound(Default.DyingSound);
}

/** play sound when taking a hit
 * this sound should be played replicated
 */
static function PlayTakeHitSound(Pawn P, int Damage)
{
	local int HitSoundIndex;
	local int Gender;
	local int Character;

	if ( P.Health > 0.5 * P.HealthMax )
	{
		HitSoundIndex = (Damage < 20) ? 0 : 1;
	}
	else
	{
		HitSoundIndex = (Damage < 20) ? 1 : 2;
	}
	Character = TMPlayerReplicationInfo(P.Controller.PlayerReplicationInfo ).Character;
	Gender = ( Character > 3 && Character < 8 ) ? 1 : 0;
	if(Gender == 1)
    	P.PlaySound(default.FemaleHitSounds[HitSoundIndex]);
    else
        P.PlaySound(default.HitSounds[HitSoundIndex]);
}

static function PlayGibSound(Pawn P)
{
	P.PlaySound(default.GibSound, true);
}

static function PlayGaspSound(Pawn P)
{
	P.PlaySound(default.GaspSound, true);
}

static function PlayDrownSound(Pawn P)
{
	P.PlaySound(default.DrownSound, true);
}

