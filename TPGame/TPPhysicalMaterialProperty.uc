class TPPhysicalMaterialProperty extends PhysicalMaterialPropertyBase
	native
	editinlinenew;


enum ParticleAlignmentMode
{
	AlignToNormal,		//	The particle is aligned to the normal of the surface.
	AlignToIncidence,	//	The particle is aligned to the angle of incidence.
	AlignToReflection	//	The particle is aligned to the angle of reflection.
};

struct native ImpactParticleData
{
	var()	class<TPDamageTypeImpact>	DamageClass;
	var()	ParticleSystem				Particles;
	var()	float						LifeSpan;
	var()	ParticleAlignmentMode		Alignment;
	
};

struct native ExitDecalInfo
{
	var() Material DecalMaterial;		// Decal material for exit bullet hits
	var() float WallThickness;			// How thick the object is that has this material attached to it
	var() float MinSize;				// Min size for the exit decal
	var() float MaxSize;				// Max size for the exit decal
};

struct native DecalMaterialData
{
	var() Material DecalMaterial;			// Material to use for bullet hits
	var() float MinSize;					// Min size for the enter decal
	var() float MaxSize;					// Max size for the enter decal
	var() bool UseExitDecalInfo;			// Whether or not to use the exit decal info
	var() ExitDecalInfo ExitDecalInfo;		// If bUseExitDecalInfo == true then use these properties 
};

// Sounds the grenades make when it hits the Material
struct native GrenadeSoundInfo
{
	var() SoundCue	SoundCue;		
};

//
// All sounds that involved a pawn interacting with the material.
//
struct native PawnSoundInfo
{
	var()	class<TPPawn>	PawnClass;
	var()	SoundCue		BodyFall_SoundCue;
	var()   SoundCue        BodyFallSoft_SoundCue;
	var()   SoundCue        CrouchDown_SoundCue;
	var()   SoundCue        CrouchStep_SoundCue;
	var()   SoundCue        CrouchUp_SoundCue;
	var()   SoundCue        FootRun_SoundCue;
	var()	SoundCue		FootScuff_SoundCue;
	var()	SoundCue		FootStep_SoundCue;
	var()   SoundCue        JumpInit_SoundCue;
	var()   SoundCue        JumpLand_SoundCue;
    var()   SoundCue        FootSprint_SoundCue;
};

// NOTE: Keep this in sync with the above! Ideally we'd use an array above,
// but the struct allows designers to see the entries by name.
// We use the enum to limit code duplication, since you can't pass a struct member name
// as a parameter.
enum PawnSoundType
{
  BodyFall,
  BodyFallSoft,
  CrouchDown,
  CrouchStep,
  CrouchUp,
  FootRun,
  FootScuff,
  FootStep,
  JumpInit,
  JumpLand,
  FootSprint
};


//
// Sounds made when something strikes this material.
//
struct native ImpactSoundInfo
{
	var()	class<TPDamageTypeImpact>	ImpactClass;
	var()	SoundCue						Impact_SoundCue;
};


var() editinline	array<PawnSoundInfo>					PawnSounds;
var() editinline	array<PawnSoundInfo>					ClientPawnSounds;
var() editinline	array<ImpactSoundInfo>					ImpactSounds;
var() editinline	array<ImpactParticleData>				ImpactParticles;
var() editinline	array<DecalMaterialData>				BulletDecals;
var() editinline	array<GrenadeSoundInfo>					GrenadeSounds;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
