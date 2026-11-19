class TPTuneData extends TPTuneDataBase
	native;



//
// Structures
//
struct native BoneInfo
{
	var() const editconst	Name	BoneName;	// Generated list of bone names.
	var()					bool	Included;	// Whether or not this bone is included in the bone group.

	structdefaultproperties
	{
		BoneName=""
		Included=false
	}
};

struct native BonesPerGroupInfo
{
	var()								Name				Group;		// Friendly name for this list of bones.
	var()	editinline	editfixedsize	array<BoneInfo>		BoneData;	// List of bones bone names and whether or not they are included in the set.

	structdefaultproperties
	{
		Group=""
		BoneData.Empty()
	}
};

struct native BoneGroupsPerSkeletalMeshInfo
{
	var() const array<BonesPerGroupInfo>	BonePerGroupData;	// List of all of the bones included in this group.
	var() const	SkeletalMesh				SkeletalMesh;		// Skeletal mesh we use to determine bone names.

	structdefaultproperties
	{
		BonePerGroupData.Empty()
		SkeletalMesh=None
	}
};

struct native SkeletalMeshBoneGroupInfo
{
	var() const array<BoneGroupsPerSkeletalMeshInfo>	BoneGroupsPerSkeletalMeshData;	// List of bone groups for each skeletal mesh.
	var() const	bool									changeToReport;					// Change to run the report.
	var() const	bool									changeToValidate;				// Change to check for errors.

	structdefaultproperties
	{
		BoneGroupsPerSkeletalMeshData.Empty();
		changeToReport=false;
		changeToValidate=false
	}
};

//
// How fast people move when in different movement modes
//
struct native MoveSpeedInfo
{
	var() const float defaultSpeed;
	var() const float walkSpeed;
	var() const float sprintSpeed;
	var() const float crouchRunSpeed;

	structdefaultproperties
	{
		defaultSpeed=350;
		walkSpeed=100;
		sprintSpeed=500;
		crouchRunSpeed=200;
	}
};

//
// How fast objects can rotate.
//
struct native RotRateInfo
{
	var() const float pitchDegPerSec;
	var() const float rollDegPerSec;
	var() const float yawDegPerSec;

	structdefaultproperties
	{
		pitchDegPerSec=25;
		rollDegPerSec=0;
		yawDegPerSec=200;
	}
};


//
// Face FX structures
//
struct native FaceFXAnimInfo
{
	var()	array<String>	AngeloAnimNames;
	var()	array<String>	CallahanAnimNames;
	var()	array<String>	GermanAAnimNames;
	var()	array<String>	GermanBAnimNames;
	var()	array<String>	GermanCAnimNames;
	var()	array<String>	GermanDAnimNames;
	var()	array<String>	NationalGuardAAnimNames;
	var()	array<String>	NationalGuardBAnimNames;
	var()	array<String>	NationalGuardCAnimNames;
	var()	array<String>	NationalGuardDAnimNames;
	var()	array<String>	NationalGuardEAnimNames;
	var()	bool			RespectDelay;
	var()	String			SetGroup;
	var()	FaceFXAnimSet	SetRef;


	structdefaultproperties
	{
		RespectDelay=true
		SetGroup="FFX_AnimSet"
		SetRef=FaceFXAnimSet'CHA_FFX.FFX_AnimSet'
	}
};

struct native FaceFXTuneInfo
{
	var()	const	float	Delay;
	var()	const	float	PlayOnOtherPawnMaxDist;

	structdefaultproperties
	{
		Delay=10
		PlayOnOtherPawnMaxDist=2000
	}
};

struct native FaceFXStringInfo
{
	var()	const	FaceFXAnimInfo	FaceFXCombatData;
	var()	const	FaceFXAnimInfo	FaceFXGrenadeData;
	var()	const	FaceFXAnimInfo	FaceFXHitReactionData;
	var()	const	FaceFXAnimInfo	FaceFXManDownData;
	var()	const	FaceFXAnimInfo	FaceFXMeleeData;
	var()	const	FaceFXAnimInfo	FaceFXPlayerReloadData;
	var()	const	FaceFXAnimInfo	FaceFXReloadingData;
	var()	const	FaceFXAnimInfo	FaceFXTakeCoverData;
	var()	const	FaceFXAnimInfo	FaceFXTargetDownData;

	structdefaultproperties
	{
		FaceFXCombatData={(
							AngeloAnimNames=			(
															"AI_Combat_01_Angelo_01",
															"AI_Combat_01_Angelo_02",
															"AI_Combat_01_Angelo_03",
															"AI_Combat_02_Angelo_01",
															"AI_Combat_02_Angelo_02",
															"AI_Combat_02_Angelo_03",
															"AI_Combat_03_Angelo_01",
															"AI_Combat_03_Angelo_02",
															"AI_Combat_03_Angelo_03",
															"AI_Combat_04_Angelo_01",
															"AI_Combat_04_Angelo_02",
															"AI_Combat_04_Angelo_03",
															"AI_Combat_05_Angelo_01",
															"AI_Combat_05_Angelo_02",
															"AI_Combat_05_Angelo_03",
															"AI_Combat_06_Angelo_01",
															"AI_Combat_06_Angelo_02",
															"AI_Combat_06_Angelo_03",
														),
							CallahanAnimNames=			(
															"AI_Combat_01_Callahan_01",
															"AI_Combat_01_Callahan_02",
															"AI_Combat_01_Callahan_03",
															"AI_Combat_02_Callahan_01",
															"AI_Combat_02_Callahan_02",
															"AI_Combat_02_Callahan_03",
															"AI_Combat_03_Callahan_01",
															"AI_Combat_03_Callahan_02",
															"AI_Combat_03_Callahan_03",
															"AI_Combat_04_Callahan_01",
															"AI_Combat_04_Callahan_02",
															"AI_Combat_04_Callahan_03",
															"AI_Combat_05_Callahan_01",
															"AI_Combat_05_Callahan_02",
															"AI_Combat_05_Callahan_03",
															"AI_Combat_06_Callahan_01",
															"AI_Combat_06_Callahan_02",
															"AI_Combat_06_Callahan_03",
														),
							GermanAAnimNames=			(
															"AI_Combat_01_German_A_01",
															"AI_Combat_01_German_A_02",
															"AI_Combat_01_German_A_03",
															"AI_Combat_02_German_A_01",
															"AI_Combat_02_German_A_02",
															"AI_Combat_02_German_A_03",
															"AI_Combat_03_German_A_01",
															"AI_Combat_03_German_A_02",
															"AI_Combat_03_German_A_03",
															"AI_Combat_04_German_A_01",
															"AI_Combat_04_German_A_02",
															"AI_Combat_04_German_A_03",
															"AI_Combat_05_German_A_01",
															"AI_Combat_05_German_A_02",
															"AI_Combat_05_German_A_03",
															"AI_Combat_06_German_A_01",
															"AI_Combat_06_German_A_02",
															"AI_Combat_06_German_A_03",
															"AI_Combat_07_German_A_01",
															"AI_Combat_07_German_A_02",
															"AI_Combat_07_German_A_03",
															"AI_Combat_08_German_A_01",
															"AI_Combat_08_German_A_02",
															"AI_Combat_08_German_A_03",
															"AI_Combat_09_German_A_01",
															"AI_Combat_09_German_A_02",
															"AI_Combat_09_German_A_03",
														),
							GermanBAnimNames=			(
															"AI_Combat_01_German_B_01",
															"AI_Combat_01_German_B_02",
															"AI_Combat_01_German_B_03",
															"AI_Combat_02_German_B_01",
															"AI_Combat_02_German_B_02",
															"AI_Combat_02_German_B_03",
															"AI_Combat_03_German_B_01",
															"AI_Combat_03_German_B_02",
															"AI_Combat_03_German_B_03",
															"AI_Combat_04_German_B_01",
															"AI_Combat_04_German_B_02",
															"AI_Combat_04_German_B_03",
															"AI_Combat_05_German_B_01",
															"AI_Combat_05_German_B_02",
															"AI_Combat_05_German_B_03",
															"AI_Combat_06_German_B_01",
															"AI_Combat_06_German_B_02",
															"AI_Combat_06_German_B_03",
															"AI_Combat_07_German_B_01",
															"AI_Combat_07_German_B_02",
															"AI_Combat_07_German_B_03",
															"AI_Combat_08_German_B_01",
															"AI_Combat_08_German_B_02",
															"AI_Combat_08_German_B_03",
															"AI_Combat_09_German_B_01",
															"AI_Combat_09_German_B_02",
															"AI_Combat_09_German_B_03",
														),
							GermanCAnimNames=			(
															"AI_Combat_01_German_C_01",
															"AI_Combat_01_German_C_02",
															"AI_Combat_01_German_C_03",
															"AI_Combat_02_German_C_01",
															"AI_Combat_02_German_C_02",
															"AI_Combat_02_German_C_03",
															"AI_Combat_03_German_C_01",
															"AI_Combat_03_German_C_02",
															"AI_Combat_03_German_C_03",
															"AI_Combat_04_German_C_01",
															"AI_Combat_04_German_C_02",
															"AI_Combat_04_German_C_03",
															"AI_Combat_05_German_C_01",
															"AI_Combat_05_German_C_02",
															"AI_Combat_05_German_C_03",
															"AI_Combat_06_German_C_01",
															"AI_Combat_06_German_C_02",
															"AI_Combat_06_German_C_03",
															"AI_Combat_07_German_C_01",
															"AI_Combat_07_German_C_02",
															"AI_Combat_07_German_C_03",
															"AI_Combat_08_German_C_01",
															"AI_Combat_08_German_C_02",
															"AI_Combat_08_German_C_03",
															"AI_Combat_09_German_C_01",
															"AI_Combat_09_German_C_02",
															"AI_Combat_09_German_C_03",
														),
							GermanDAnimNames=			(
															"AI_Combat_01_German_D_01",
															"AI_Combat_01_German_D_02",
															"AI_Combat_01_German_D_03",
															"AI_Combat_02_German_D_01",
															"AI_Combat_02_German_D_02",
															"AI_Combat_02_German_D_03",
															"AI_Combat_03_German_D_01",
															"AI_Combat_03_German_D_02",
															"AI_Combat_03_German_D_03",
															"AI_Combat_04_German_D_01",
															"AI_Combat_04_German_D_02",
															"AI_Combat_04_German_D_03",
															"AI_Combat_05_German_D_01",
															"AI_Combat_05_German_D_02",
															"AI_Combat_05_German_D_03",
															"AI_Combat_06_German_D_01",
															"AI_Combat_06_German_D_02",
															"AI_Combat_06_German_D_03",
															"AI_Combat_07_German_D_01",
															"AI_Combat_07_German_D_02",
															"AI_Combat_07_German_D_03",
															"AI_Combat_08_German_D_01",
															"AI_Combat_08_German_D_02",
															"AI_Combat_08_German_D_03",
															"AI_Combat_09_German_D_01",
															"AI_Combat_09_German_D_02",
															"AI_Combat_09_German_D_03",
														),
							NationalGuardAAnimNames=	(
															"AI_Combat_01_NatGuard_A_01",
															"AI_Combat_01_NatGuard_A_02",
															"AI_Combat_01_NatGuard_A_03",
															"AI_Combat_02_NatGuard_A_01",
															"AI_Combat_02_NatGuard_A_02",
															"AI_Combat_02_NatGuard_A_03",
															"AI_Combat_03_NatGuard_A_01",
															"AI_Combat_03_NatGuard_A_02",
															"AI_Combat_03_NatGuard_A_03",
															"AI_Combat_04_NatGuard_A_01",
															"AI_Combat_04_NatGuard_A_02",
															"AI_Combat_04_NatGuard_A_03",
															"AI_Combat_05_NatGuard_A_01",
															"AI_Combat_05_NatGuard_A_02",
															"AI_Combat_05_NatGuard_A_03",
															"AI_Combat_06_NatGuard_A_01",
															"AI_Combat_06_NatGuard_A_02",
															"AI_Combat_06_NatGuard_A_03",
														),
							NationalGuardBAnimNames=	(
															"AI_Combat_01_NatGuard_B_01",
															"AI_Combat_01_NatGuard_B_02",
															"AI_Combat_01_NatGuard_B_03",
															"AI_Combat_02_NatGuard_B_01",
															"AI_Combat_02_NatGuard_B_02",
															"AI_Combat_02_NatGuard_B_03",
															"AI_Combat_03_NatGuard_B_01",
															"AI_Combat_03_NatGuard_B_02",
															"AI_Combat_03_NatGuard_B_03",
															"AI_Combat_04_NatGuard_B_01",
															"AI_Combat_04_NatGuard_B_02",
															"AI_Combat_04_NatGuard_B_03",
															"AI_Combat_05_NatGuard_B_01",
															"AI_Combat_05_NatGuard_B_02",
															"AI_Combat_05_NatGuard_B_03",
															"AI_Combat_06_NatGuard_B_01",
															"AI_Combat_06_NatGuard_B_02",
															"AI_Combat_06_NatGuard_B_03",
														),
							NationalGuardCAnimNames=	(
															"AI_Combat_01_NatGuard_C_01",
															"AI_Combat_01_NatGuard_C_02",
															"AI_Combat_01_NatGuard_C_03",
															"AI_Combat_02_NatGuard_C_01",
															"AI_Combat_02_NatGuard_C_02",
															"AI_Combat_02_NatGuard_C_03",
															"AI_Combat_03_NatGuard_C_01",
															"AI_Combat_03_NatGuard_C_02",
															"AI_Combat_03_NatGuard_C_03",
															"AI_Combat_04_NatGuard_C_01",
															"AI_Combat_04_NatGuard_C_02",
															"AI_Combat_04_NatGuard_C_03",
															"AI_Combat_05_NatGuard_C_01",
															"AI_Combat_05_NatGuard_C_02",
															"AI_Combat_05_NatGuard_C_03",
															"AI_Combat_06_NatGuard_C_01",
															"AI_Combat_06_NatGuard_C_02",
															"AI_Combat_06_NatGuard_C_03",
														),
							NationalGuardDAnimNames=	(
															"AI_Combat_01_NatGuard_D_01",
															"AI_Combat_01_NatGuard_D_02",
															"AI_Combat_01_NatGuard_D_03",
															"AI_Combat_02_NatGuard_D_01",
															"AI_Combat_02_NatGuard_D_02",
															"AI_Combat_02_NatGuard_D_03",
															"AI_Combat_03_NatGuard_D_01",
															"AI_Combat_03_NatGuard_D_02",
															"AI_Combat_03_NatGuard_D_03",
															"AI_Combat_04_NatGuard_D_01",
															"AI_Combat_04_NatGuard_D_02",
															"AI_Combat_04_NatGuard_D_03",
															"AI_Combat_05_NatGuard_D_01",
															"AI_Combat_05_NatGuard_D_02",
															"AI_Combat_05_NatGuard_D_03",
															"AI_Combat_06_NatGuard_D_01",
															"AI_Combat_06_NatGuard_D_02",
															"AI_Combat_06_NatGuard_D_03",
														),
							NationalGuardEAnimNames=	(
															"AI_Combat_01_NatGuard_E_01",
															"AI_Combat_01_NatGuard_E_02",
															"AI_Combat_02_NatGuard_E_01",
															"AI_Combat_02_NatGuard_E_02",
															"AI_Combat_02_NatGuard_E_03",
															"AI_Combat_03_NatGuard_E_01",
															"AI_Combat_03_NatGuard_E_02",
															"AI_Combat_03_NatGuard_E_03",
															"AI_Combat_04_NatGuard_E_01",
															"AI_Combat_04_NatGuard_E_02",
															"AI_Combat_04_NatGuard_E_03",
															"AI_Combat_05_NatGuard_E_01",
															"AI_Combat_05_NatGuard_E_02",
															"AI_Combat_05_NatGuard_E_03",
															"AI_Combat_06_NatGuard_E_01",
															"AI_Combat_06_NatGuard_E_02",
															"AI_Combat_06_NatGuard_E_03",
														)
		)}

		FaceFXGrenadeData={(
							AngeloAnimNames=			(
															"AI_Grenade_01_Angelo_01",
															"AI_Grenade_01_Angelo_02",
															"AI_Grenade_01_Angelo_03",
															"AI_Grenade_02_Angelo_01",
															"AI_Grenade_02_Angelo_02",
															"AI_Grenade_02_Angelo_03",
															"AI_Grenade_03_Angelo_01",
															"AI_Grenade_03_Angelo_02",
															"AI_Grenade_03_Angelo_03",
														),
							CallahanAnimNames=			(
															"AI_Grenade_01_Callahan_01",
															"AI_Grenade_01_Callahan_02",
															"AI_Grenade_01_Callahan_03",
															"AI_Grenade_02_Callahan_01",
															"AI_Grenade_02_Callahan_02",
															"AI_Grenade_02_Callahan_03",
															"AI_Grenade_03_Callahan_01",
															"AI_Grenade_03_Callahan_02",
															"AI_Grenade_03_Callahan_03",
														),
							GermanAAnimNames=			(
															"AI_Grenade_01_German_A_01",
															"AI_Grenade_01_German_A_02",
															"AI_Grenade_01_German_A_03",
														),
							GermanBAnimNames=			(
															"AI_Grenade_01_German_B_01",
															"AI_Grenade_01_German_B_02",
															"AI_Grenade_01_German_B_03",
														),
							GermanCAnimNames=			(
															"AI_Grenade_01_German_C_01",
															"AI_Grenade_01_German_C_02",
															"AI_Grenade_01_German_C_03",
														),
							GermanDAnimNames=			(
															"AI_Grenade_01_German_D_01",
															"AI_Grenade_01_German_D_02",
															"AI_Grenade_01_German_D_03",
														),
							NationalGuardAAnimNames=	(
															"AI_Grenade_01_NatGuard_A_01",
															"AI_Grenade_01_NatGuard_A_02",
															"AI_Grenade_01_NatGuard_A_03",
															"AI_Grenade_02_NatGuard_A_01",
															"AI_Grenade_02_NatGuard_A_02",
															"AI_Grenade_02_NatGuard_A_03",
															"AI_Grenade_03_NatGuard_A_01",
															"AI_Grenade_03_NatGuard_A_02",
															"AI_Grenade_03_NatGuard_A_03",
														),
							NationalGuardBAnimNames=	(
															"AI_Grenade_01_NatGuard_B_01",
															"AI_Grenade_01_NatGuard_B_02",
															"AI_Grenade_01_NatGuard_B_03",
															"AI_Grenade_02_NatGuard_B_01",
															"AI_Grenade_02_NatGuard_B_02",
															"AI_Grenade_02_NatGuard_B_03",
															"AI_Grenade_03_NatGuard_B_01",
															"AI_Grenade_03_NatGuard_B_02",
															"AI_Grenade_03_NatGuard_B_03",
														),
							NationalGuardCAnimNames=	(
															"AI_Grenade_01_NatGuard_C_01",
															"AI_Grenade_01_NatGuard_C_02",
															"AI_Grenade_01_NatGuard_C_03",
															"AI_Grenade_02_NatGuard_C_01",
															"AI_Grenade_02_NatGuard_C_02",
															"AI_Grenade_02_NatGuard_C_03",
															"AI_Grenade_03_NatGuard_C_01",
															"AI_Grenade_03_NatGuard_C_02",
															"AI_Grenade_03_NatGuard_C_03",
														),
							NationalGuardDAnimNames=	(
															"AI_Grenade_01_NatGuard_D_01",
															"AI_Grenade_01_NatGuard_D_02",
															"AI_Grenade_01_NatGuard_D_03",
															"AI_Grenade_02_NatGuard_D_01",
															"AI_Grenade_02_NatGuard_D_02",
															"AI_Grenade_02_NatGuard_D_03",
															"AI_Grenade_03_NatGuard_D_01",
															"AI_Grenade_03_NatGuard_D_02",
															"AI_Grenade_03_NatGuard_D_03",
														),
							NationalGuardEAnimNames=	(
															"AI_Grenade_01_NatGuard_E_01",
															"AI_Grenade_01_NatGuard_E_02",
															"AI_Grenade_01_NatGuard_E_03",
															"AI_Grenade_02_NatGuard_E_01",
															"AI_Grenade_02_NatGuard_E_02",
															"AI_Grenade_02_NatGuard_E_03",
															"AI_Grenade_03_NatGuard_E_01",
															"AI_Grenade_03_NatGuard_E_02",
															"AI_Grenade_03_NatGuard_E_03",
														)
		)}

		FaceFXHitReactionData={(
							AngeloAnimNames=			(
															"VOCAL_HR_Bullet_Angelo_01",
															"VOCAL_HR_Bullet_Angelo_02",
															"VOCAL_HR_Bullet_Angelo_03",
															"VOCAL_HR_Bullet_Angelo_04",
															"VOCAL_HR_Bullet_Angelo_05",
															"VOCAL_HR_Bullet_Angelo_06",
															"VOCAL_HR_Bullet_Angelo_07",
															"VOCAL_HR_Bullet_Angelo_08",
															"VOCAL_HR_Bullet_Angelo_09",
															"VOCAL_HR_Bullet_Angelo_10",
														),
							CallahanAnimNames=			(
															"VOCAL_HR_Bullet_Callahan_01",
															"VOCAL_HR_Bullet_Callahan_02",
															"VOCAL_HR_Bullet_Callahan_03",
															"VOCAL_HR_Bullet_Callahan_04",
															"VOCAL_HR_Bullet_Callahan_05",
															"VOCAL_HR_Bullet_Callahan_06",
															"VOCAL_HR_Bullet_Callahan_07",
															"VOCAL_HR_Bullet_Callahan_08",
															"VOCAL_HR_Bullet_Callahan_09",
															"VOCAL_HR_Bullet_Callahan_10",
														),
							GermanAAnimNames=			(
															"VOCAL_HR_Bullet_German_A_01",
															"VOCAL_HR_Bullet_German_A_02",
															"VOCAL_HR_Bullet_German_A_03",
															"VOCAL_HR_Bullet_German_A_04",
															"VOCAL_HR_Bullet_German_A_05",
															"VOCAL_HR_Bullet_German_A_06",
															"VOCAL_HR_Bullet_German_A_07",
															"VOCAL_HR_Bullet_German_A_08",
															"VOCAL_HR_Bullet_German_A_09",
															"VOCAL_HR_Bullet_German_A_10",
														),
							GermanBAnimNames=			(
															"VOCAL_HR_Bullet_German_B_01",
															"VOCAL_HR_Bullet_German_B_02",
															"VOCAL_HR_Bullet_German_B_03",
															"VOCAL_HR_Bullet_German_B_04",
															"VOCAL_HR_Bullet_German_B_05",
															"VOCAL_HR_Bullet_German_B_06",
															"VOCAL_HR_Bullet_German_B_07",
															"VOCAL_HR_Bullet_German_B_08",
															"VOCAL_HR_Bullet_German_B_09",
															"VOCAL_HR_Bullet_German_B_10",
														),
							GermanCAnimNames=			(
															"VOCAL_HR_Bullet_German_C_01",
															"VOCAL_HR_Bullet_German_C_02",
															"VOCAL_HR_Bullet_German_C_03",
															"VOCAL_HR_Bullet_German_C_04",
															"VOCAL_HR_Bullet_German_C_05",
															"VOCAL_HR_Bullet_German_C_06",
															"VOCAL_HR_Bullet_German_C_07",
															"VOCAL_HR_Bullet_German_C_08",
															"VOCAL_HR_Bullet_German_C_09",
															"VOCAL_HR_Bullet_German_C_10",
														),
							GermanDAnimNames=			(
															"VOCAL_HR_Bullet_German_D_01",
															"VOCAL_HR_Bullet_German_D_02",
															"VOCAL_HR_Bullet_German_D_03",
															"VOCAL_HR_Bullet_German_D_04",
															"VOCAL_HR_Bullet_German_D_05",
															"VOCAL_HR_Bullet_German_D_06",
															"VOCAL_HR_Bullet_German_D_07",
															"VOCAL_HR_Bullet_German_D_08",
															"VOCAL_HR_Bullet_German_D_09",
															"VOCAL_HR_Bullet_German_D_10",
														),
							NationalGuardAAnimNames=	(
															"VOCAL_HR_Bullet_NatGuard_A_01",
															"VOCAL_HR_Bullet_NatGuard_A_02",
															"VOCAL_HR_Bullet_NatGuard_A_03",
															"VOCAL_HR_Bullet_NatGuard_A_04",
															"VOCAL_HR_Bullet_NatGuard_A_05",
															"VOCAL_HR_Bullet_NatGuard_A_06",
															"VOCAL_HR_Bullet_NatGuard_A_07",
															"VOCAL_HR_Bullet_NatGuard_A_08",
															"VOCAL_HR_Bullet_NatGuard_A_09",
															"VOCAL_HR_Bullet_NatGuard_A_10",
														),
							NationalGuardBAnimNames=	(
															"VOCAL_HR_Bullet_NatGuard_B_01",
															"VOCAL_HR_Bullet_NatGuard_B_02",
															"VOCAL_HR_Bullet_NatGuard_B_03",
															"VOCAL_HR_Bullet_NatGuard_B_04",
															"VOCAL_HR_Bullet_NatGuard_B_05",
															"VOCAL_HR_Bullet_NatGuard_B_06",
															"VOCAL_HR_Bullet_NatGuard_B_07",
															"VOCAL_HR_Bullet_NatGuard_B_08",
															"VOCAL_HR_Bullet_NatGuard_B_09",
															"VOCAL_HR_Bullet_NatGuard_B_10",
														),
							NationalGuardCAnimNames=	(
															"VOCAL_HR_Bullet_NatGuard_C_01",
															"VOCAL_HR_Bullet_NatGuard_C_02",
															"VOCAL_HR_Bullet_NatGuard_C_03",
															"VOCAL_HR_Bullet_NatGuard_C_04",
															"VOCAL_HR_Bullet_NatGuard_C_05",
															"VOCAL_HR_Bullet_NatGuard_C_06",
															"VOCAL_HR_Bullet_NatGuard_C_07",
															"VOCAL_HR_Bullet_NatGuard_C_08",
															"VOCAL_HR_Bullet_NatGuard_C_09",
															"VOCAL_HR_Bullet_NatGuard_C_10",
														),
							NationalGuardDAnimNames=	(
															"VOCAL_HR_Bullet_NatGuard_D_01",
															"VOCAL_HR_Bullet_NatGuard_D_02",
															"VOCAL_HR_Bullet_NatGuard_D_03",
															"VOCAL_HR_Bullet_NatGuard_D_04",
															"VOCAL_HR_Bullet_NatGuard_D_05",
															"VOCAL_HR_Bullet_NatGuard_D_06",
															"VOCAL_HR_Bullet_NatGuard_D_07",
															"VOCAL_HR_Bullet_NatGuard_D_08",
															"VOCAL_HR_Bullet_NatGuard_D_09",
															"VOCAL_HR_Bullet_NatGuard_D_10",
														),
							NationalGuardEAnimNames=	(
															"VOCAL_HR_Bullet_NatGuard_E_01",
															"VOCAL_HR_Bullet_NatGuard_E_02",
															"VOCAL_HR_Bullet_NatGuard_E_03",
															"VOCAL_HR_Bullet_NatGuard_E_04",
															"VOCAL_HR_Bullet_NatGuard_E_05",
															"VOCAL_HR_Bullet_NatGuard_E_06",
															"VOCAL_HR_Bullet_NatGuard_E_07",
															"VOCAL_HR_Bullet_NatGuard_E_08",
															"VOCAL_HR_Bullet_NatGuard_E_09",
															"VOCAL_HR_Bullet_NatGuard_E_10",
														),

							RespectDelay=false
		)}

		FaceFXManDownData={(
							AngeloAnimNames=			(
															"AI_ManDown_01_Angelo_01",
															"AI_ManDown_01_Angelo_02",
															"AI_ManDown_01_Angelo_03",
															"AI_ManDown_02_Angelo_01",
															"AI_ManDown_02_Angelo_02",
															"AI_ManDown_02_Angelo_03",
															"AI_ManDown_03_Angelo_01",
															"AI_ManDown_03_Angelo_02",
															"AI_ManDown_03_Angelo_03",
														),
							CallahanAnimNames=			(
															"AI_ManDown_01_Callahan_01",
															"AI_ManDown_01_Callahan_02",
															"AI_ManDown_01_Callahan_03",
															"AI_ManDown_02_Callahan_01",
															"AI_ManDown_02_Callahan_02",
															"AI_ManDown_02_Callahan_03",
															"AI_ManDown_03_Callahan_01",
															"AI_ManDown_03_Callahan_02",
															"AI_ManDown_03_Callahan_03",
														),
							GermanAAnimNames=			(
														),
							GermanBAnimNames=			(
														),
							GermanCAnimNames=			(
														),
							GermanDAnimNames=			(
														),
							NationalGuardAAnimNames=	(
															"AI_ManDown_01_NatGuard_A_01",
															"AI_ManDown_01_NatGuard_A_02",
															"AI_ManDown_01_NatGuard_A_03",
															"AI_ManDown_02_NatGuard_A_01",
															"AI_ManDown_02_NatGuard_A_02",
															"AI_ManDown_02_NatGuard_A_03",
															"AI_ManDown_03_NatGuard_A_01",
															"AI_ManDown_03_NatGuard_A_02",
															"AI_ManDown_04_NatGuard_A_03",
														),
							NationalGuardBAnimNames=	(
															"AI_ManDown_01_NatGuard_B_01",
															"AI_ManDown_01_NatGuard_B_02",
															"AI_ManDown_01_NatGuard_B_03",
															"AI_ManDown_02_NatGuard_B_01",
															"AI_ManDown_02_NatGuard_B_02",
															"AI_ManDown_02_NatGuard_B_03",
															"AI_ManDown_03_NatGuard_B_01",
															"AI_ManDown_03_NatGuard_B_02",
															"AI_ManDown_04_NatGuard_B_03",
														),
							NationalGuardCAnimNames=	(
															"AI_ManDown_01_NatGuard_C_01",
															"AI_ManDown_01_NatGuard_C_02",
															"AI_ManDown_01_NatGuard_C_03",
															"AI_ManDown_02_NatGuard_C_01",
															"AI_ManDown_02_NatGuard_C_02",
															"AI_ManDown_02_NatGuard_C_03",
															"AI_ManDown_03_NatGuard_C_01",
															"AI_ManDown_03_NatGuard_C_02",
															"AI_ManDown_04_NatGuard_C_03",
														),
							NationalGuardDAnimNames=	(
															"AI_ManDown_01_NatGuard_D_01",
															"AI_ManDown_01_NatGuard_D_02",
															"AI_ManDown_01_NatGuard_D_03",
															"AI_ManDown_02_NatGuard_D_01",
															"AI_ManDown_02_NatGuard_D_02",
															"AI_ManDown_02_NatGuard_D_03",
															"AI_ManDown_03_NatGuard_D_01",
															"AI_ManDown_03_NatGuard_D_02",
															"AI_ManDown_04_NatGuard_D_03",
														),
							NationalGuardEAnimNames=	(
															"AI_ManDown_01_NatGuard_E_01",
															"AI_ManDown_01_NatGuard_E_02",
															"AI_ManDown_01_NatGuard_E_03",
															"AI_ManDown_02_NatGuard_E_01",
															"AI_ManDown_02_NatGuard_E_02",
															"AI_ManDown_02_NatGuard_E_03",
															"AI_ManDown_03_NatGuard_E_01",
															"AI_ManDown_03_NatGuard_E_02",
															"AI_ManDown_04_NatGuard_E_03",
														)
		)}

		FaceFXMeleeData={(
							AngeloAnimNames=			(
															"AI_Combat_05_Angelo_01",
															"AI_Combat_05_Angelo_02",
															"AI_Combat_05_Angelo_03",
															"AI_Combat_06_Angelo_01",
															"AI_Combat_06_Angelo_02",
															"AI_Combat_06_Angelo_03",
														),
							CallahanAnimNames=			(
															"AI_Combat_05_Callahan_01",
															"AI_Combat_05_Callahan_02",
															"AI_Combat_05_Callahan_03",
															"AI_Combat_06_Callahan_01",
															"AI_Combat_06_Callahan_02",
															"AI_Combat_06_Callahan_03",
														),
							GermanAAnimNames=			(
															"AI_Combat_09_German_A_01",
															"AI_Combat_09_German_A_02",
															"AI_Combat_09_German_A_03",
														),
							GermanBAnimNames=			(
															"AI_Combat_09_German_B_01",
															"AI_Combat_09_German_B_02",
															"AI_Combat_09_German_B_03",
														),
							GermanCAnimNames=			(
															"AI_Combat_09_German_C_01",
															"AI_Combat_09_German_C_02",
															"AI_Combat_09_German_C_03",
														),
							GermanDAnimNames=			(
															"AI_Combat_09_German_D_01",
															"AI_Combat_09_German_D_02",
															"AI_Combat_09_German_D_03",
														),
							NationalGuardAAnimNames=	(
															"AI_Combat_05_NatGuard_A_01",
															"AI_Combat_05_NatGuard_A_02",
															"AI_Combat_05_NatGuard_A_03",
															"AI_Combat_06_NatGuard_A_01",
															"AI_Combat_06_NatGuard_A_02",
															"AI_Combat_06_NatGuard_A_03",
														),
							NationalGuardBAnimNames=	(
															"AI_Combat_05_NatGuard_B_01",
															"AI_Combat_05_NatGuard_B_02",
															"AI_Combat_05_NatGuard_B_03",
															"AI_Combat_06_NatGuard_B_01",
															"AI_Combat_06_NatGuard_B_02",
															"AI_Combat_06_NatGuard_B_03",
														),
							NationalGuardCAnimNames=	(
															"AI_Combat_05_NatGuard_C_01",
															"AI_Combat_05_NatGuard_C_02",
															"AI_Combat_05_NatGuard_C_03",
															"AI_Combat_06_NatGuard_C_01",
															"AI_Combat_06_NatGuard_C_02",
															"AI_Combat_06_NatGuard_C_03",
														),
							NationalGuardDAnimNames=	(
															"AI_Combat_05_NatGuard_D_01",
															"AI_Combat_05_NatGuard_D_02",
															"AI_Combat_05_NatGuard_D_03",
															"AI_Combat_06_NatGuard_D_01",
															"AI_Combat_06_NatGuard_D_02",
															"AI_Combat_06_NatGuard_D_03",
														),
							NationalGuardEAnimNames=	(
															"AI_Combat_05_NatGuard_E_01",
															"AI_Combat_05_NatGuard_E_02",
															"AI_Combat_05_NatGuard_E_03",
															"AI_Combat_06_NatGuard_E_01",
															"AI_Combat_06_NatGuard_E_02",
															"AI_Combat_06_NatGuard_E_03",
														)
		)}

		FaceFXPlayerReloadData={(
							AngeloAnimNames=			(
														),
							CallahanAnimNames=			(
														),
							GermanAAnimNames=			(
															"AI_PlayerReload_01_German_A_01",
															"AI_PlayerReload_01_German_A_02",
															"AI_PlayerReload_01_German_A_03",
															"AI_PlayerReload_02_German_A_01",
															"AI_PlayerReload_02_German_A_02",
															"AI_PlayerReload_02_German_A_03",
															"AI_PlayerReload_03_German_A_01",
															"AI_PlayerReload_03_German_A_02",
															"AI_PlayerReload_03_German_A_03",
															"AI_PlayerReload_04_German_A_01",
															"AI_PlayerReload_04_German_A_02",
															"AI_PlayerReload_04_German_A_03",
														),
							GermanBAnimNames=			(
															"AI_PlayerReload_01_German_B_01",
															"AI_PlayerReload_01_German_B_02",
															"AI_PlayerReload_01_German_B_03",
															"AI_PlayerReload_02_German_B_01",
															"AI_PlayerReload_02_German_B_02",
															"AI_PlayerReload_02_German_B_03",
															"AI_PlayerReload_03_German_B_01",
															"AI_PlayerReload_03_German_B_02",
															"AI_PlayerReload_03_German_B_03",
															"AI_PlayerReload_04_German_B_01",
															"AI_PlayerReload_04_German_B_02",
															"AI_PlayerReload_04_German_B_03",
														),
							GermanCAnimNames=			(
															"AI_PlayerReload_01_German_C_01",
															"AI_PlayerReload_01_German_C_02",
															"AI_PlayerReload_01_German_C_03",
															"AI_PlayerReload_02_German_C_01",
															"AI_PlayerReload_02_German_C_02",
															"AI_PlayerReload_02_German_C_03",
															"AI_PlayerReload_03_German_C_01",
															"AI_PlayerReload_03_German_C_02",
															"AI_PlayerReload_03_German_C_03",
															"AI_PlayerReload_04_German_C_01",
															"AI_PlayerReload_04_German_C_02",
															"AI_PlayerReload_04_German_C_03",
														),
							GermanDAnimNames=			(
															"AI_PlayerReload_01_German_D_01",
															"AI_PlayerReload_01_German_D_02",
															"AI_PlayerReload_01_German_D_03",
															"AI_PlayerReload_02_German_D_01",
															"AI_PlayerReload_02_German_D_02",
															"AI_PlayerReload_02_German_D_03",
															"AI_PlayerReload_03_German_D_01",
															"AI_PlayerReload_03_German_D_02",
															"AI_PlayerReload_03_German_D_03",
															"AI_PlayerReload_04_German_D_01",
															"AI_PlayerReload_04_German_D_02",
															"AI_PlayerReload_04_German_D_03",
														),
							NationalGuardAAnimNames=	(
														),
							NationalGuardBAnimNames=	(
														),
							NationalGuardCAnimNames=	(
														),
							NationalGuardDAnimNames=	(
														),
							NationalGuardEAnimNames=	(
														)
		)}

		FaceFXReloadingData={(
							AngeloAnimNames=			(
															"AI_Reload_01_Angelo_01",
															"AI_Reload_01_Angelo_02",
															"AI_Reload_01_Angelo_03",
															"AI_Reload_02_Angelo_01",
															"AI_Reload_02_Angelo_02",
															"AI_Reload_02_Angelo_03",
															"AI_Reload_03_Angelo_01",
															"AI_Reload_03_Angelo_02",
															"AI_Reload_03_Angelo_03",
															"AI_Reload_04_Angelo_01",
															"AI_Reload_04_Angelo_02",
															"AI_Reload_04_Angelo_03",
														),
							CallahanAnimNames=			(
															"AI_Reload_01_Callahan_01",
															"AI_Reload_01_Callahan_02",
															"AI_Reload_01_Callahan_03",
															"AI_Reload_02_Callahan_01",
															"AI_Reload_02_Callahan_02",
															"AI_Reload_02_Callahan_03",
															"AI_Reload_03_Callahan_01",
															"AI_Reload_03_Callahan_02",
															"AI_Reload_03_Callahan_03",
															"AI_Reload_04_Callahan_01",
															"AI_Reload_04_Callahan_02",
															"AI_Reload_04_Callahan_03",
														),
							GermanAAnimNames=			(
															"AI_Reload_01_German_A_01",
															"AI_Reload_01_German_A_02",
															"AI_Reload_01_German_A_03",
															"AI_Reload_02_German_A_01",
															"AI_Reload_02_German_A_02",
															"AI_Reload_02_German_A_03",
															"AI_Reload_03_German_A_01",
															"AI_Reload_03_German_A_02",
															"AI_Reload_03_German_A_03",
															"AI_Reload_04_German_A_01",
															"AI_Reload_04_German_A_02",
															"AI_Reload_04_German_A_03",
														),
							GermanBAnimNames=			(
															"AI_Reload_01_German_B_01",
															"AI_Reload_01_German_B_02",
															"AI_Reload_01_German_B_03",
															"AI_Reload_02_German_B_01",
															"AI_Reload_02_German_B_02",
															"AI_Reload_02_German_B_03",
															"AI_Reload_03_German_B_01",
															"AI_Reload_03_German_B_02",
															"AI_Reload_03_German_B_03",
															"AI_Reload_04_German_B_01",
															"AI_Reload_04_German_B_02",
															"AI_Reload_04_German_B_03",
														),
							GermanCAnimNames=			(
															"AI_Reload_01_German_C_01",
															"AI_Reload_01_German_C_02",
															"AI_Reload_01_German_C_03",
															"AI_Reload_02_German_C_01",
															"AI_Reload_02_German_C_02",
															"AI_Reload_02_German_C_03",
															"AI_Reload_03_German_C_01",
															"AI_Reload_03_German_C_02",
															"AI_Reload_03_German_C_03",
															"AI_Reload_04_German_C_01",
															"AI_Reload_04_German_C_02",
															"AI_Reload_04_German_C_03",
														),
							GermanDAnimNames=			(
															"AI_Reload_01_German_D_01",
															"AI_Reload_01_German_D_02",
															"AI_Reload_01_German_D_03",
															"AI_Reload_02_German_D_01",
															"AI_Reload_02_German_D_02",
															"AI_Reload_02_German_D_03",
															"AI_Reload_03_German_D_01",
															"AI_Reload_03_German_D_02",
															"AI_Reload_03_German_D_03",
															"AI_Reload_04_German_D_01",
															"AI_Reload_04_German_D_02",
															"AI_Reload_04_German_D_03",
														),
							NationalGuardAAnimNames=	(
															"AI_Reload_01_NatGuard_A_01",
															"AI_Reload_01_NatGuard_A_02",
															"AI_Reload_01_NatGuard_A_03",
															"AI_Reload_02_NatGuard_A_01",
															"AI_Reload_02_NatGuard_A_02",
															"AI_Reload_02_NatGuard_A_03",
															"AI_Reload_03_NatGuard_A_01",
															"AI_Reload_03_NatGuard_A_02",
															"AI_Reload_03_NatGuard_A_03",
															"AI_Reload_04_NatGuard_A_01",
															"AI_Reload_04_NatGuard_A_02",
															"AI_Reload_04_NatGuard_A_03",
															),
							NationalGuardBAnimNames=	(
															"AI_Reload_01_NatGuard_B_01",
															"AI_Reload_01_NatGuard_B_02",
															"AI_Reload_01_NatGuard_B_03",
															"AI_Reload_02_NatGuard_B_01",
															"AI_Reload_02_NatGuard_B_02",
															"AI_Reload_02_NatGuard_B_03",
															"AI_Reload_03_NatGuard_B_01",
															"AI_Reload_03_NatGuard_B_02",
															"AI_Reload_03_NatGuard_B_03",
															"AI_Reload_04_NatGuard_B_01",
															"AI_Reload_04_NatGuard_B_02",
															"AI_Reload_04_NatGuard_B_03",
														),
							NationalGuardCAnimNames=	(
															"AI_Reload_01_NatGuard_C_01",
															"AI_Reload_01_NatGuard_C_02",
															"AI_Reload_01_NatGuard_C_03",
															"AI_Reload_02_NatGuard_C_01",
															"AI_Reload_02_NatGuard_C_02",
															"AI_Reload_02_NatGuard_C_03",
															"AI_Reload_03_NatGuard_C_01",
															"AI_Reload_03_NatGuard_C_02",
															"AI_Reload_03_NatGuard_C_03",
															"AI_Reload_04_NatGuard_C_01",
															"AI_Reload_04_NatGuard_C_02",
															"AI_Reload_04_NatGuard_C_03",
														),
							NationalGuardDAnimNames=	(
															"AI_Reload_01_NatGuard_D_01",
															"AI_Reload_01_NatGuard_D_02",
															"AI_Reload_01_NatGuard_D_03",
															"AI_Reload_02_NatGuard_D_01",
															"AI_Reload_02_NatGuard_D_02",
															"AI_Reload_02_NatGuard_D_03",
															"AI_Reload_03_NatGuard_D_01",
															"AI_Reload_03_NatGuard_D_02",
															"AI_Reload_03_NatGuard_D_03",
															"AI_Reload_04_NatGuard_D_01",
															"AI_Reload_04_NatGuard_D_02",
															"AI_Reload_04_NatGuard_D_03",
														),
							NationalGuardEAnimNames=	(
															"AI_Reload_01_NatGuard_E_01",
															"AI_Reload_01_NatGuard_E_02",
															"AI_Reload_01_NatGuard_E_03",
															"AI_Reload_02_NatGuard_E_01",
															"AI_Reload_02_NatGuard_E_02",
															"AI_Reload_02_NatGuard_E_03",
															"AI_Reload_03_NatGuard_E_01",
															"AI_Reload_03_NatGuard_E_02",
															"AI_Reload_03_NatGuard_E_03",
															"AI_Reload_04_NatGuard_E_01",
															"AI_Reload_04_NatGuard_E_02",
															"AI_Reload_04_NatGuard_E_03",
														)
		)}

		FaceFXTakeCoverData={(
							AngeloAnimNames=			(
															"AI_Cover_01_Angelo_01",
															"AI_Cover_01_Angelo_02",
															"AI_Cover_01_Angelo_03",
															"AI_Cover_02_Angelo_01",
															"AI_Cover_02_Angelo_02",
															"AI_Cover_02_Angelo_03",
														),
							CallahanAnimNames=			(
															"AI_Cover_01_Callahan_01",
															"AI_Cover_01_Callahan_02",
															"AI_Cover_01_Callahan_03",
															"AI_Cover_02_Callahan_01",
															"AI_Cover_02_Callahan_02",
															"AI_Cover_02_Callahan_03",
															"AI_Cover_03_Callahan_01",
															"AI_Cover_03_Callahan_02",
															"AI_Cover_03_Callahan_03",
															"AI_Cover_04_Callahan_01",
															"AI_Cover_04_Callahan_02",
															"AI_Cover_04_Callahan_03",
														),
							GermanAAnimNames=			(
															"AI_Cover_01_German_A_01",
															"AI_Cover_01_German_A_02",
															"AI_Cover_01_German_A_03",
															"AI_Cover_02_German_A_01",
															"AI_Cover_02_German_A_02",
															"AI_Cover_02_German_A_03",
															"AI_Cover_03_German_A_01",
															"AI_Cover_03_German_A_02",
															"AI_Cover_03_German_A_03",
															"AI_Cover_04_German_A_01",
															"AI_Cover_04_German_A_02",
															"AI_Cover_04_German_A_03",
														),
							GermanBAnimNames=			(
															"AI_Cover_01_German_B_01",
															"AI_Cover_01_German_B_02",
															"AI_Cover_01_German_B_03",
															"AI_Cover_02_German_B_01",
															"AI_Cover_02_German_B_02",
															"AI_Cover_02_German_B_03",
															"AI_Cover_03_German_B_01",
															"AI_Cover_03_German_B_02",
															"AI_Cover_03_German_B_03",
															"AI_Cover_04_German_B_01",
															"AI_Cover_04_German_B_02",
															"AI_Cover_04_German_B_03",
														),
							GermanCAnimNames=			(
															"AI_Cover_01_German_C_01",
															"AI_Cover_01_German_C_02",
															"AI_Cover_01_German_C_03",
															"AI_Cover_02_German_C_01",
															"AI_Cover_02_German_C_02",
															"AI_Cover_02_German_C_03",
															"AI_Cover_03_German_C_01",
															"AI_Cover_03_German_C_02",
															"AI_Cover_03_German_C_03",
															"AI_Cover_04_German_C_01",
															"AI_Cover_04_German_C_02",
															"AI_Cover_04_German_C_03",
														),
							GermanDAnimNames=			(
															"AI_Cover_01_German_D_01",
															"AI_Cover_01_German_D_02",
															"AI_Cover_01_German_D_03",
															"AI_Cover_02_German_D_01",
															"AI_Cover_02_German_D_02",
															"AI_Cover_02_German_D_03",
															"AI_Cover_03_German_D_01",
															"AI_Cover_03_German_D_02",
															"AI_Cover_03_German_D_03",
															"AI_Cover_04_German_D_01",
															"AI_Cover_04_German_D_02",
															"AI_Cover_04_German_D_03",
														),
							NationalGuardAAnimNames=	(
															"AI_Cover_01_NatGuard_A_01",
															"AI_Cover_01_NatGuard_A_02",
															"AI_Cover_01_NatGuard_A_03",
															"AI_Cover_02_NatGuard_A_01",
															"AI_Cover_02_NatGuard_A_02",
															"AI_Cover_02_NatGuard_A_03",
															"AI_Cover_03_NatGuard_A_01",
															"AI_Cover_03_NatGuard_A_02",
															"AI_Cover_03_NatGuard_A_03",
															"AI_Cover_04_NatGuard_A_01",
															"AI_Cover_04_NatGuard_A_02",
															"AI_Cover_04_NatGuard_A_03",
															),
							NationalGuardBAnimNames=	(
															"AI_Cover_01_NatGuard_B_01",
															"AI_Cover_01_NatGuard_B_02",
															"AI_Cover_01_NatGuard_B_03",
															"AI_Cover_02_NatGuard_B_01",
															"AI_Cover_02_NatGuard_B_02",
															"AI_Cover_02_NatGuard_B_03",
															"AI_Cover_03_NatGuard_B_01",
															"AI_Cover_03_NatGuard_B_02",
															"AI_Cover_03_NatGuard_B_03",
															"AI_Cover_04_NatGuard_B_01",
															"AI_Cover_04_NatGuard_B_02",
															"AI_Cover_04_NatGuard_B_03",
														),
							NationalGuardCAnimNames=	(
															"AI_Cover_01_NatGuard_C_01",
															"AI_Cover_01_NatGuard_C_02",
															"AI_Cover_01_NatGuard_C_03",
															"AI_Cover_02_NatGuard_C_01",
															"AI_Cover_02_NatGuard_C_02",
															"AI_Cover_02_NatGuard_C_03",
															"AI_Cover_03_NatGuard_C_01",
															"AI_Cover_03_NatGuard_C_02",
															"AI_Cover_03_NatGuard_C_03",
															"AI_Cover_04_NatGuard_C_01",
															"AI_Cover_04_NatGuard_C_02",
															"AI_Cover_04_NatGuard_C_03",
														),
							NationalGuardDAnimNames=	(
															"AI_Cover_01_NatGuard_D_01",
															"AI_Cover_01_NatGuard_D_02",
															"AI_Cover_01_NatGuard_D_03",
															"AI_Cover_02_NatGuard_D_01",
															"AI_Cover_02_NatGuard_D_02",
															"AI_Cover_02_NatGuard_D_03",
															"AI_Cover_03_NatGuard_D_01",
															"AI_Cover_03_NatGuard_D_02",
															"AI_Cover_03_NatGuard_D_03",
															"AI_Cover_04_NatGuard_D_01",
															"AI_Cover_04_NatGuard_D_02",
															"AI_Cover_04_NatGuard_D_03",
														),
							NationalGuardEAnimNames=	(
															"AI_Cover_01_NatGuard_E_01",
															"AI_Cover_01_NatGuard_E_02",
															"AI_Cover_01_NatGuard_E_03",
															"AI_Cover_02_NatGuard_E_01",
															"AI_Cover_02_NatGuard_E_02",
															"AI_Cover_02_NatGuard_E_03",
															"AI_Cover_03_NatGuard_E_01",
															"AI_Cover_03_NatGuard_E_02",
															"AI_Cover_03_NatGuard_E_03",
															"AI_Cover_04_NatGuard_E_01",
															"AI_Cover_04_NatGuard_E_02",
															"AI_Cover_04_NatGuard_E_03",
														)
		)}

		FaceFXTargetDownData={(
							AngeloAnimNames=			(
															"AI_Target_01_Angelo_01",
															"AI_Target_01_Angelo_02",
															"AI_Target_01_Angelo_03",
															"AI_Target_02_Angelo_01",
															"AI_Target_02_Angelo_02",
															"AI_Target_02_Angelo_01",
															"AI_Target_03_Angelo_01",
															"AI_Target_03_Angelo_02",
															"AI_Target_03_Angelo_03",
														),
							CallahanAnimNames=			(
															"AI_Target_01_Callahan_01",
															"AI_Target_01_Callahan_02",
															"AI_Target_01_Callahan_03",
															"AI_Target_02_Callahan_01",
															"AI_Target_02_Callahan_02",
															"AI_Target_02_Callahan_03",
															"AI_Target_03_Callahan_01",
															"AI_Target_03_Callahan_02",
															"AI_Target_03_Callahan_03",
														),
							GermanAAnimNames=			(
														),
							GermanBAnimNames=			(
														),
							GermanCAnimNames=			(
														),
							GermanDAnimNames=			(
														),
							NationalGuardAAnimNames=	(
															"AI_Target_01_NatGuard_A_01",
															"AI_Target_01_NatGuard_A_02",
															"AI_Target_01_NatGuard_A_03",
															"AI_Target_02_NatGuard_A_01",
															"AI_Target_02_NatGuard_A_02",
															"AI_Target_02_NatGuard_A_03",
															"AI_Target_03_NatGuard_A_01",
															"AI_Target_03_NatGuard_A_02",
															"AI_Target_03_NatGuard_A_03",
															),
							NationalGuardBAnimNames=	(
															"AI_Target_01_NatGuard_B_01",
															"AI_Target_01_NatGuard_B_02",
															"AI_Target_01_NatGuard_B_03",
															"AI_Target_02_NatGuard_B_01",
															"AI_Target_02_NatGuard_B_02",
															"AI_Target_02_NatGuard_B_03",
															"AI_Target_03_NatGuard_B_01",
															"AI_Target_03_NatGuard_B_02",
															"AI_Target_03_NatGuard_B_03",
														),
							NationalGuardCAnimNames=	(
															"AI_Target_01_NatGuard_C_01",
															"AI_Target_01_NatGuard_C_02",
															"AI_Target_01_NatGuard_C_03",
															"AI_Target_02_NatGuard_C_01",
															"AI_Target_02_NatGuard_C_02",
															"AI_Target_02_NatGuard_C_03",
															"AI_Target_03_NatGuard_C_01",
															"AI_Target_03_NatGuard_C_02",
															"AI_Target_03_NatGuard_C_03",
														),
							NationalGuardDAnimNames=	(
															"AI_Target_01_NatGuard_D_01",
															"AI_Target_01_NatGuard_D_02",
															"AI_Target_01_NatGuard_D_03",
															"AI_Target_02_NatGuard_D_01",
															"AI_Target_02_NatGuard_D_02",
															"AI_Target_02_NatGuard_D_03",
															"AI_Target_03_NatGuard_D_01",
															"AI_Target_03_NatGuard_D_02",
															"AI_Target_03_NatGuard_D_03",
														),
							NationalGuardEAnimNames=	(
															"AI_Target_01_NatGuard_E_01",
															"AI_Target_01_NatGuard_E_02",
															"AI_Target_01_NatGuard_E_03",
															"AI_Target_02_NatGuard_E_01",
															"AI_Target_02_NatGuard_E_02",
															"AI_Target_02_NatGuard_E_03",
															"AI_Target_03_NatGuard_E_01",
															"AI_Target_03_NatGuard_E_02",
															"AI_Target_03_NatGuard_E_03",
														)
		)}
	}
};

struct native NPC_AccuracyInfo
{
	var() Float	AI_Base_Acc_Standing; // Accuracy: Standing
	var() Float	AI_Base_Acc_BlindFire; // Accuracy: Blind firing
	var() Float	AI_Base_Acc_Target; // Accuracy modifier: targeting mode

	// Accuracy modifiers
	var() Float	AI_Mod_Acc_Move; // Accuracy modifier: moving
	var() Float	AI_Mod_Acc_TargMove; // Accuracy modifier: enemy moving

	// Accuracy Range Modifiers
	var() Float	AI_ModRng_Short;
	var() Float	AI_ModRng_Medium;
	var() Float	AI_ModRng_Long;
	var() Float	EnemyDistance_Short;
	var() Float	EnemyDistance_Medium;

	structdefaultproperties
	{
	// Base Inaccuracy
		AI_Base_Acc_Standing	= 0.2f
		AI_Base_Acc_BlindFire	= 1.0f
		AI_Base_Acc_Target		= 0.05f

		// Accuracy modifiers
		AI_Mod_Acc_Move				= 0.16f
		AI_Mod_Acc_TargMove			= 0.1f

		// Accuracy Range Modifiers
		AI_ModRng_Short				= -0.15f
		AI_ModRng_Medium			= -0.05f
		AI_ModRng_Long				= -0.00f
		EnemyDistance_Short			= 950.f
		EnemyDistance_Medium		= 2000.f
	}
};

struct native CoverShiftTuneInfo
{
	var () const vector m_StandingHidingLeftShift;
	var () const vector m_StandingHidingRightShift;
	var () const vector m_StandingHidingMiddleShift;

	var () const vector m_StandingFiringLeftShift;
	var () const vector m_StandingFiringRightShift;
	var () const vector m_StandingFiringMiddleShift;

	var () const vector m_StandingBlindFiringLeftShift;
	var () const vector m_StandingBlindFiringRightShift;
	var () const vector m_StandingBlindFiringMiddleShift;

	var () const vector m_StandingPeekLeftShift;
	var () const vector m_StandingPeekRightShift;
	var () const vector m_StandingPeekMiddleShift;

	// Low Cover
	var () const vector m_MedCoverHidingLeftShift;
	var () const vector m_MedCoverHidingRightShift;
	var () const vector m_MedCoverHidingMiddleShift;

	var () const vector m_MedCoverFiringLeftShift;
	var () const vector m_MedCoverFiringRightShift;
	var () const vector m_MedCoverFiringUpShift;

	var () const vector m_MedCoverBlindFiringLeftShift;
	var () const vector m_MedCoverBlindFiringRightShift;
	var () const vector m_MedCoverBlindFiringUpShift;

	var () const vector m_MedCoverPeekLeftShift;
	var () const vector m_MedCoverPeekRightShift;
	var () const vector m_MedCoverPeekupShift;

	var () float m_MinDistToCoverPositionShift; // how far away does the cover shift position have to be from the pawn's current position to cause a loc change to happen

	var () float m_VerticalShiftOffsetStanding; // this is an additional offset to any of the Z offset from above
	var () float m_VerticalShiftOffsetCrouch; // this is an additional offset to any of the Z offset from above

	structdefaultproperties
	{
		m_StandingHidingLeftShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingHidingRightShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingHidingMiddleShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingFiringLeftShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingFiringRightShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingFiringMiddleShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingBlindFiringLeftShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingBlindFiringRightShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingBlindFiringMiddleShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingPeekLeftShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingPeekRightShift=(X=0.0,Y=0.0,Z=0.0)
		m_StandingPeekMiddleShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverHidingLeftShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverHidingRightShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverHidingMiddleShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverFiringLeftShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverFiringRightShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverFiringUpShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverBlindFiringLeftShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverBlindFiringRightShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverBlindFiringUpShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverPeekLeftShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverPeekRightShift=(X=0.0,Y=0.0,Z=0.0)
		m_MedCoverPeekupShift=(X=0.0,Y=0.0,Z=0.0)
		m_MinDistToCoverPositionShift = 8.0	
		m_VerticalShiftOffsetStanding = 4.0
		m_VerticalShiftOffsetCrouch = -16.0
	}
};

struct native CoverEngagementTuneInfo
{
	var () float m_TimeToWaitBetweenCoverActionChanges;
	var () float m_DistanceToPushDownRangeFromCoverLineOfFireChecks;

	var () float m_DefaultCoverSearchRadius;

	var () float m_TimeToStayBehindCoverAfterLookAndBeforeEngagement;

	var () float m_DistFromSlotToCheckForBlockingNPC;

	var () int m_MaxNumberOfTimeToTryAndMountTurretBeforeSnappingToIt;

	var () float m_MaxTimeToWaitForCoverTransitionToEnd;

	var () int m_MaxDiffInHeadingVsKynapsePathToSprint;

	var () float			m_MinDistanceToCoverForSprinting;	// When the distance left to the cover is greater then this length the NPC will sprint to the cover
	var () float			m_MinDistanceToCoverForRunning;	// When the distance is between this and the m_MinDistanceToCoverForSprinting run. WHen Less do the Crouch Run
	var () float			m_SpeedFactorForCrouchWalkToCover;

	var () float	m_MaxDistAwayFromCoverToStartTransitionInto;
	var () float	m_MinDistAwayFromCoverToStartTransitionInto;

	var () int m_TurnRateCrouchedAtCoverPerHertz;
	var () int m_TurnRateStandAtCoverPerHertz;
	var () int m_MaxSnapRangeForTurnAtCover;

	var () float m_MinDistToSlideIntoCoverCrouched;
	var () float m_MinDistToSlideIntoCoverStanding;

	var () float m_DistToSlideIntoCoverWhileTransInPerUpdate;
	var () float m_DistToSlideIntoCoverWhileInCoverPerUpdate;

	var () float m_TimeToWaitBetweenActoveLookSearches;

	structdefaultproperties
	{
		m_MaxDiffInHeadingVsKynapsePathToSprint = 3000
		m_MinDistanceToCoverForSprinting		= 800.0
		m_MinDistanceToCoverForRunning			= 400.0
		m_SpeedFactorForCrouchWalkToCover		= 2.0
		m_TimeToWaitBetweenCoverActionChanges = 2.0
		m_DistanceToPushDownRangeFromCoverLineOfFireChecks=96.0
		m_DefaultCoverSearchRadius = 1000
		m_TimeToStayBehindCoverAfterLookAndBeforeEngagement = 1.0
		m_DistFromSlotToCheckForBlockingNPC = 100
		m_MaxNumberOfTimeToTryAndMountTurretBeforeSnappingToIt = 3
		m_MaxTimeToWaitForCoverTransitionToEnd = 2.0
		m_MaxDistAwayFromCoverToStartTransitionInto = 140
		m_MinDistAwayFromCoverToStartTransitionInto = 100

		m_TurnRateCrouchedAtCoverPerHertz = 900
		m_TurnRateStandAtCoverPerHertz = 1000
		m_MaxSnapRangeForTurnAtCover = 2000

		m_MinDistToSlideIntoCoverStanding = 75
		m_MinDistToSlideIntoCoverCrouched = 10

		m_DistToSlideIntoCoverWhileTransInPerUpdate = 7
		m_DistToSlideIntoCoverWhileInCoverPerUpdate = 2

		m_TimeToWaitBetweenActoveLookSearches = 0.5
	}
};


struct native EngagementTacInfo
{
	var () float	m_HowMuchCloserDoesAnEnemyHaveToBeToOverrideCurrentEnemy; // to avoid hashing between enemies only switch to a new enemy when the new enemy get this much closer

	var () float	m_HowOfftenToCheckLOS_4_DefaultAttacks;
	var () float	m_HowLongAfterLeftGoodLOF2GiveUpDefaultAttack;

	var () float	m_ZBindHeightDistToCheck;

	var () float	m_HowLongToOpenFieldTacticallyEvadeFromCover;

	var () float	m_ChanceToUseOpenFieldTacticalEvasionPerHit;

	var () float	m_HowOfftenToDetermineIfGoingLow;
	var () int		m_NumOfTimesToTryAndGetBackToCoverAfterStepOut;

	var () float	m_ShortRangeAimedAtDist;
	var () float	m_MedRangeAimedAtDist;
	var () float	m_LongRangeAimedAtDist;

	var () float	m_ChanceToKnowBeingAimedAtInShortRange;
	var () float	m_ChanceToKnowBeingAimedAtInMedRange;
	var () float	m_ChanceToKnowBeingAimedAtInLongRange;

	var () float	m_LengthOfTimeToKnowBeingAimedAt;
	var () float	m_LengthOfTimeToKnowTookHit;

	var () float	m_HowOfftenToDetermineIfBeingAimedAt;

	var () float	m_MinTimeBetweenFreeAttackPostureSwitchs;

	var () float	m_FindHastyCoverTacStepSpeedFactor;
	var () float	m_SliceThePieTacStepSpeedFactor;
	var () float	m_EvadeTacStepSpeedFactor;
	var () float	m_EnageTacStepSpeedFactor;
	var () float	m_StepOutTacStepSpeedFactor;
	var () float	m_MinTimeBetweenPostureChanges;

	var () float	m_MaxTimeToWaitForToStandPostureChangeToFinish;
	var () float	m_MaxTimeToWaitForToPanicStandPostureChangeToFinish;
	var () float	m_MaxTimeToWaitForToCrouchPostureChangeToFinish;

	var () float	m_MaxTimeToWaitForToTransIntoLowCoverToFinish;

	var () float	m_MaxTimeToWaitForToMountLowMGPostureChangeToFinish;

	var () float	m_MaxAngleOffHeadingForRunShot;
	var () float	m_MaxAngleOffHorizonForRunShot;

	var () float	m_OffLineToTurretFactorForCQB;

	var() float		m_TimeAfterLastMeleeChargeFireToGiveUpCharge;

	var () float	m_DeathForceFactor_Sprint;
	var () float	m_DeathForceFactor_Run;
	var () float	m_DeathForceFactor_CrouchRun;

	var () float	m_DeathForceFactor_MeleeCharge;
	var () float	m_DeathForceFactor_RunToTurret;
	var () float	m_DeathForceFactor_RunAwayFromGren;
	var () float	m_DeathForceFactor_RunToGren;

	var () float	m_ChanceToCrouchWhenFreeAttack;
	structdefaultproperties
	{
		m_HowOfftenToCheckLOS_4_DefaultAttacks					=2.0
		m_HowMuchCloserDoesAnEnemyHaveToBeToOverrideCurrentEnemy=200.0
		m_HowLongAfterLeftGoodLOF2GiveUpDefaultAttack			= 2.0
		m_HowLongToOpenFieldTacticallyEvadeFromCover			= 3.0

		m_NumOfTimesToTryAndGetBackToCoverAfterStepOut			= 10

		m_ChanceToUseOpenFieldTacticalEvasionPerHit				= 0.7

		m_HowOfftenToDetermineIfGoingLow						= 2.0

		m_ShortRangeAimedAtDist									= 1500.0
		m_MedRangeAimedAtDist									= 3000.0
		m_LongRangeAimedAtDist									= 6000.0

		m_ChanceToKnowBeingAimedAtInShortRange					= 90.0
		m_ChanceToKnowBeingAimedAtInMedRange					= 80.0
		m_ChanceToKnowBeingAimedAtInLongRange					= 60.0

		m_LengthOfTimeToKnowBeingAimedAt						= 2.0
		m_LengthOfTimeToKnowTookHit								= 2.0

		m_ZBindHeightDistToCheck								= 220.0

		m_MinTimeBetweenFreeAttackPostureSwitchs				= 3.0

		m_FindHastyCoverTacStepSpeedFactor						= 1.0
		m_SliceThePieTacStepSpeedFactor							= 0.8
		m_EvadeTacStepSpeedFactor								= 0.5
		m_EnageTacStepSpeedFactor								= 0.8
		m_StepOutTacStepSpeedFactor								= 1.0
		m_MinTimeBetweenPostureChanges							= 2.0
		m_MaxTimeToWaitForToStandPostureChangeToFinish			= 1.3
		m_MaxTimeToWaitForToCrouchPostureChangeToFinish			= 1.3
		m_MaxTimeToWaitForToTransIntoLowCoverToFinish			= 2.0
		m_MaxTimeToWaitForToMountLowMGPostureChangeToFinish		= 0.7
		m_MaxTimeToWaitForToPanicStandPostureChangeToFinish		= 0.7
		m_MaxAngleOffHeadingForRunShot							= 35
		m_MaxAngleOffHorizonForRunShot							= 35
		m_OffLineToTurretFactorForCQB							= 1.2

		m_TimeAfterLastMeleeChargeFireToGiveUpCharge			= 2.0

		m_DeathForceFactor_Sprint								= 50000
		m_DeathForceFactor_Run									= 35000
		m_DeathForceFactor_CrouchRun							= 30000

		m_DeathForceFactor_MeleeCharge							= 38000
		m_DeathForceFactor_RunToTurret							= 30000
		m_DeathForceFactor_RunAwayFromGren						= 40000
		m_DeathForceFactor_RunToGren							= 30000
		m_ChanceToCrouchWhenFreeAttack							= 0.75
	}
};


struct native GrenadeUseInfo
{
	var () float					m_WhatIsToCloseToThrowGren;
	var () float					m_WhatIsToFarToThrowGren;

	var () float					m_WhatIsTheMinRangeForFriendsToEnemyToThrowGren;

	var () float					m_VeryShortRangeEnd;
	var () float					m_ShortRangeEnd;
	var () float					m_MedRangeEnd;
	var () float					m_LongRangeEnd;
	var () float					m_VeryLongRangeEnd;
	var () float					m_SuperHeroLongRangeEnd;


	var () float					m_VeryShortRangeSpeed;
	var () float					m_ShortRangeSpeed;
	var () float					m_MedRangeSpeed;
	var () float					m_LongRangeSpeed;
	var () float					m_VeryLongRangeSpeed;
	var () float					m_SuperHeroLongRangeSpeed;

	var () float					m_DefaultFuseTime;

	var () float					m_DistAwayForGoodThrowImpactPoint;

	var () float					m_Dist2TargetsLeftForAlternateGrenTarget;
	var () float					m_Dist2TargetsRightForAlternateGrenTarget;
	var () float					m_Dist2TargetsForwardForAlternateGrenTarget;
	var () float					m_Dist2TargetsBackForAlternateGrenTarget;

	var () float					m_Dist2StepLeftForAlternateGrenTarget;
	var () float					m_Dist2StepRightForAlternateGrenTarget;
	var () float					m_Dist2StepForwardForAlternateGrenTarget;
	var () float					m_Dist2StepBackForAlternateGrenTarget;

	var () vector					m_ThrowFromBodySpotOffset; // used to check the throwing locaiton of where the gren will be released not the pawns center.
	var () vector					m_ThrowFromBodySpotOffsetStandLeftCover; // used to check the throwing locaiton of where the gren will be released not the pawns center.
	var () vector					m_ThrowFromBodySpotOffsetStandRightCover; // used to check the throwing locaiton of where the gren will be released not the pawns center.
	var () vector					m_ThrowFromBodySpotOffsetCrouchCover; // used to check the throwing locaiton of where the gren will be released not the pawns center.

	var () float					m_ZBindHeightDistToCheck;
	var () vector					m_GrenadeVolumeForThrowCalc;
	var () float					m_GrenadeThrowArcStepTimeSize;
	var () float					m_ErrorDistWhenSideSteppngToGrenThrowLoc;
	var () float					m_StepingToTheLeftBodyThrowSpotCalcErrorCorrection;
	var () float					m_StepingToTheRightBodyThrowSpotCalcErrorCorrection;

	var () float					m_ZDiffUpDownFloatFactor;
	var () float					m_TimeToWaitForGrenadeThrowAnimToEnd;

	var () float					m_MaxDeltaForThrowBackGrenBeforeAdjustMove;
	var () float					m_HowCloseToThrowBackGrenToPickUpAndThrowBack;

	var () float					m_TimeToAddToThrowBackGren;

	var () float					m_HowLongToWaitToCancelThrowBack;

	var () float					m_MaxTimeReactingToInitialGrenadeOut;
	var () float					m_MaxDelayTimeBeforeReactingToInitialGrenadeOut;

	var () float					m_MaxDelayTimeAfterCoweringFromGrenade;

	var () float					m_MaxDistFromGrenToJumpOverCoverToGetAway;

	var () float					m_DesiredDistToRunawayFromGren;

	var () float					m_MaxAngleToEnemyToTossBackTooInDegrees;

	var () float					m_TimeToWaitBetweenTaskThrowTries;

	structdefaultproperties
	{
		m_WhatIsToCloseToThrowGren								= 500.0
		m_WhatIsToFarToThrowGren								= 3000.0
		m_WhatIsTheMinRangeForFriendsToEnemyToThrowGren			= 300.0

		m_VeryShortRangeEnd										= 500
		m_ShortRangeEnd											= 700
		m_MedRangeEnd											= 1200
		m_LongRangeEnd											= 2000
		m_VeryLongRangeEnd										= 3000
		m_SuperHeroLongRangeEnd									= 5000

		m_VeryShortRangeSpeed									= 1200
		m_ShortRangeSpeed										= 1400
		m_MedRangeSpeed											= 1700
		m_LongRangeSpeed										= 2200
		m_VeryLongRangeSpeed									= 2700
		m_SuperHeroLongRangeSpeed								= 3500

		m_DefaultFuseTime										= 4.0f
		m_DistAwayForGoodThrowImpactPoint						= 200
		m_Dist2TargetsLeftForAlternateGrenTarget				= 200
		m_Dist2TargetsRightForAlternateGrenTarget				= 200
		m_Dist2TargetsForwardForAlternateGrenTarget				= 200
		m_Dist2TargetsBackForAlternateGrenTarget				= 200
		m_Dist2StepLeftForAlternateGrenTarget					= 300
		m_Dist2StepRightForAlternateGrenTarget					= 300
		m_Dist2StepForwardForAlternateGrenTarget				= 300
		m_Dist2StepBackForAlternateGrenTarget					= 300

		m_ThrowFromBodySpotOffset=(X=40.0,Y=40.0,Z=100.0)
		m_ThrowFromBodySpotOffsetStandLeftCover=(X=-85,Y=50,Z=75)
		m_ThrowFromBodySpotOffsetStandRightCover=(X=-85,Y=-50,Z=75)
		m_ThrowFromBodySpotOffsetCrouchCover=(X=-60.0,Y=-23.0,Z=24.0)
		m_ZBindHeightDistToCheck								= 120.0
		m_GrenadeVolumeForThrowCalc=(X=30.0,Y=30.0,Z=79.0)
		m_GrenadeThrowArcStepTimeSize							= 0.125
		m_ErrorDistWhenSideSteppngToGrenThrowLoc				= 100.0
		m_StepingToTheLeftBodyThrowSpotCalcErrorCorrection		= 40.0
		m_StepingToTheRightBodyThrowSpotCalcErrorCorrection		= -40.0

		m_ZDiffUpDownFloatFactor								= 0.55
		m_TimeToWaitForGrenadeThrowAnimToEnd					= 5.0

		m_MaxDeltaForThrowBackGrenBeforeAdjustMove				= 20
		m_HowCloseToThrowBackGrenToPickUpAndThrowBack			= 100
		m_TimeToAddToThrowBackGren								= 0.5
		m_HowLongToWaitToCancelThrowBack						= 3.0
		m_MaxTimeReactingToInitialGrenadeOut					= 2.0
		m_MaxDelayTimeBeforeReactingToInitialGrenadeOut			= 0.2
		m_MaxDistFromGrenToJumpOverCoverToGetAway				= 1000
		m_DesiredDistToRunawayFromGren							= 1000
		m_MaxAngleToEnemyToTossBackTooInDegrees					= 60.0
		m_MaxDelayTimeAfterCoweringFromGrenade					= 0.1
		m_TimeToWaitBetweenTaskThrowTries						= 1.0
	}
};

struct native AimingAngleInfoByWeaponType
{
	var () float m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees;	// half angle of maximum firing angle set by animTree
	var () float m_MaxHalfVerticalFiringAngleStandingInOpenInDegrees;		// half vertical of maximum firing angle set by animTree
	var () float m_MaxHalfHorizontalFiringAngleCrouchInOpenInDegrees;	// half angle of maximum firing angle set by animTree
	var () float m_MaxHalfVerticalFiringAngleCrouchInOpenInDegrees;		// half vertical of maximum firing angle set by animTree

	var () float m_MaxHalfHorizontalFiringAngleStandingAtCoverInDegrees;	// half angle of maximum firing angle set by animTree
	var () float m_MaxHalfVerticalFiringAngleStandingAtCoverInDegrees;		// half vertical of maximum firing angle set by animTree
	var () float m_MaxHalfHorizontalFiringAngleCrouchAtCoverInDegrees;	// half angle of maximum firing angle set by animTree
	var () float m_MaxHalfVerticalFiringAngleCrouchAtCoverInDegrees;		// half vertical of maximum firing angle set by animTree
};

struct native AimingAngleInfo
{
	var () AimingAngleInfoByWeaponType m_AimingAngleInfoForSMGs;
	var () AimingAngleInfoByWeaponType m_AimingAngleInfoForPistols;
	var () AimingAngleInfoByWeaponType m_AimingAngleInfoForRifles;
	var () AimingAngleInfoByWeaponType m_AimingAngleInfoForPanzers;
	var () AimingAngleInfoByWeaponType m_AimingAngleInfoForGrenades;
	var () AimingAngleInfoByWeaponType m_AimingAngleInfoForSniperRifles;
	var () AimingAngleInfoByWeaponType m_AimingAngleInfoForUnclassified;

	var () int	m_MinDiffInDesiredRotVsPawnRotForAimUpdate;

	var () float	m_ErrorRangeForSniperTrackWaypointSwitchingSq;


	structdefaultproperties
	{
		m_MinDiffInDesiredRotVsPawnRotForAimUpdate				= 12000
		m_ErrorRangeForSniperTrackWaypointSwitchingSq			= 2500.0

		m_AimingAngleInfoForSMGs = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInDegrees = 45.0 )}

		m_AimingAngleInfoForPistols = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInDegrees = 45.0 )}

		m_AimingAngleInfoForRifles = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInDegrees = 45.0 )}

		m_AimingAngleInfoForPanzers = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInDegrees = 45.0 )}


		m_AimingAngleInfoForGrenades = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInDegrees = 45.0,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInDegrees = 45.0,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInDegrees = 45.0 )}


		m_AimingAngleInfoForSniperRifles = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees = 90.0,
												m_MaxHalfVerticalFiringAngleStandingInOpenInDegrees = 45.0,
												m_MaxHalfHorizontalFiringAngleCrouchInOpenInDegrees = 90.0,
												m_MaxHalfVerticalFiringAngleCrouchInOpenInDegrees = 45.0,
												m_MaxHalfHorizontalFiringAngleStandingAtCoverInDegrees = 90.0,
												m_MaxHalfVerticalFiringAngleStandingAtCoverInDegrees = 45.0,
												m_MaxHalfHorizontalFiringAngleCrouchAtCoverInDegrees = 90.0,
												m_MaxHalfVerticalFiringAngleCrouchAtCoverInDegrees = 45.0 )}

		m_AimingAngleInfoForUnclassified = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees = 50.0,
												m_MaxHalfVerticalFiringAngleStandingInOpenInDegrees = 45.0,
												m_MaxHalfHorizontalFiringAngleCrouchInOpenInDegrees = 45.0,
												m_MaxHalfVerticalFiringAngleCrouchInOpenInDegrees = 45.0,
												m_MaxHalfHorizontalFiringAngleStandingAtCoverInDegrees = 45.0,
												m_MaxHalfVerticalFiringAngleStandingAtCoverInDegrees = 45.0,
												m_MaxHalfHorizontalFiringAngleCrouchAtCoverInDegrees = 45.0,
												m_MaxHalfVerticalFiringAngleCrouchAtCoverInDegrees = 45.0 )}

	}
};

struct native AimingAngleInfoByWeaponTypeConverted
{
	var int m_MaxHalfHorizontalFiringAngleStandingInOpenInUU;	// half angle of maximum firing angle set by animTree
	var int m_MaxHalfVerticalFiringAngleStandingInOpenInUU;		// half vertical of maximum firing angle set by animTree
	var int m_MaxHalfHorizontalFiringAngleCrouchInOpenInUU;	// half angle of maximum firing angle set by animTree
	var int m_MaxHalfVerticalFiringAngleCrouchInOpenInUU;		// half vertical of maximum firing angle set by animTree

	var int m_MaxHalfHorizontalFiringAngleStandingAtCoverInUU;	// half angle of maximum firing angle set by animTree
	var int m_MaxHalfVerticalFiringAngleStandingAtCoverInUU;		// half vertical of maximum firing angle set by animTree
	var int m_MaxHalfHorizontalFiringAngleCrouchAtCoverInUU;	// half angle of maximum firing angle set by animTree
	var int m_MaxHalfVerticalFiringAngleCrouchAtCoverInUU;		// half vertical of maximum firing angle set by animTree
};

struct native AimingAngleInfoConverted
{
	var AimingAngleInfoByWeaponTypeConverted m_AimingAngleInfoForSMGs;
	var AimingAngleInfoByWeaponTypeConverted m_AimingAngleInfoForPistols;
	var AimingAngleInfoByWeaponTypeConverted m_AimingAngleInfoForRifles;
	var AimingAngleInfoByWeaponTypeConverted m_AimingAngleInfoForPanzers;
	var AimingAngleInfoByWeaponTypeConverted m_AimingAngleInfoForGrenades;
	var AimingAngleInfoByWeaponTypeConverted m_AimingAngleInfoForSniperRifles;
	var AimingAngleInfoByWeaponTypeConverted m_AimingAngleInfoForUnclassified;

	var int	m_MaxAngleOffHeadingForRunShotInUU;
	var int	m_MaxAngleOffHorizonForRunShotInUU;

	var int	m_MaxAngleOffHeadingForNPCBlimpShotInUU;
	var int	m_MaxAngleOffHorizonForNPCBlimpShotInUU;

	var int	m_MaxAngleToEnemyToTossBackTooInUU;

	structdefaultproperties
	{
		m_MaxAngleOffHeadingForRunShotInUU = 8192
		m_MaxAngleOffHorizonForRunShotInUU = 8192
		m_MaxAngleOffHeadingForNPCBlimpShotInUU = 13400
		m_MaxAngleOffHorizonForNPCBlimpShotInUU = 13400
		m_MaxAngleToEnemyToTossBackTooInUU = 10923

		m_AimingAngleInfoForSMGs = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInUU = 8192 )}


		m_AimingAngleInfoForPistols = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInUU = 8192 )}


		m_AimingAngleInfoForRifles = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInUU = 8192 )}




		m_AimingAngleInfoForPanzers = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInUU = 8192 )}


		m_AimingAngleInfoForGrenades = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInUU = 8192 )}


		m_AimingAngleInfoForSniperRifles = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInUU = 8192,
												m_MaxHalfVerticalFiringAngleStandingInOpenInUU = 8192,
												m_MaxHalfHorizontalFiringAngleCrouchInOpenInUU = 8192,
												m_MaxHalfVerticalFiringAngleCrouchInOpenInUU = 8192,
												m_MaxHalfHorizontalFiringAngleStandingAtCoverInUU = 8192,
												m_MaxHalfVerticalFiringAngleStandingAtCoverInUU = 8192,
												m_MaxHalfHorizontalFiringAngleCrouchAtCoverInUU = 8192,
												m_MaxHalfVerticalFiringAngleCrouchAtCoverInUU = 8192 )}


		m_AimingAngleInfoForUnclassified = {(	m_MaxHalfHorizontalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchInOpenInUU = 8192,
										m_MaxHalfHorizontalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleStandingAtCoverInUU = 8192,
										m_MaxHalfHorizontalFiringAngleCrouchAtCoverInUU = 8192,
										m_MaxHalfVerticalFiringAngleCrouchAtCoverInUU = 8192 )}

	}

};

struct native DebugDrawInfo
{
	var () bool		m_bDisplayTacticalStepAimRays;
	var () bool		m_bDisplayCanFireAtTargetFromPointAimRays;

	var () bool		m_bDrawAimmingLines;
	var () bool		m_bDisplayGrenadeThrowArcs;

	var () bool		m_bDisplayHitPoints;

	var () float	m_HowOfftenToClearCanFireRays;
	var		float	m_LastTimeClearedCanFireRays;


	var () float	m_GrenDisplayPlayerTextOffSetX;
	var () float	m_GrenDisplayPlayerTextOffSetY;

	var () color	m_GrenDisplayPlayerTextColor;

	var () color	m_AimMaxLeftDisplayLineColor;
	var () color	m_AimMaxRightDisplayLineColor;

	var () color	m_AimStartWeaponTraceLocation2TargetAimLocationDisplayLineColor;
	var () color	m_AimPawnsWepLevelStartTraceLocation2TargetAimLocationDisplayLineColor;
	var () color	m_AimPawnsLoc2TargetLocationDisplayLineColor;
	var () color	m_AimPawnsViewPoint2TargetAimLocationDisplayLineColor;


	structdefaultproperties
	{
		m_bDrawAimmingLines										= false
		m_bDisplayGrenadeThrowArcs								= false
		m_bDisplayTacticalStepAimRays							= false
		m_bDisplayCanFireAtTargetFromPointAimRays				= false
		m_bDisplayHitPoints										= false
		m_HowOfftenToClearCanFireRays							= 1.0
		m_LastTimeClearedCanFireRays							= -1.0
		m_GrenDisplayPlayerTextOffSetX							= 10
		m_GrenDisplayPlayerTextOffSetY							= 10
		m_GrenDisplayPlayerTextColor							= (R=0,G=255,B=0,A=255)
		m_AimMaxLeftDisplayLineColor							= (R=255,G=100,B=0,A=255)
		m_AimMaxRightDisplayLineColor							= (R=255,G=0,B=255,A=255)

		m_AimStartWeaponTraceLocation2TargetAimLocationDisplayLineColor = (R=255,G=0,B=0,A=255)
		m_AimPawnsWepLevelStartTraceLocation2TargetAimLocationDisplayLineColor = (R=0,G=255,B=0,A=255)
		m_AimPawnsLoc2TargetLocationDisplayLineColor = (R=0,G=0,B=255,A=255)
		m_AimPawnsViewPoint2TargetAimLocationDisplayLineColor = (R=255,G=255,B=0,A=255)
	}

};

struct native IdleAlertInfo
{
	var () float	m_MinRangeForHighAlert;
	var () float	m_MinRangeForMedAlert;

	structdefaultproperties
	{
		m_MinRangeForHighAlert								= 1000
		m_MinRangeForMedAlert								= 2500
	}

};

struct native SensingInfo
{
	var () bool						m_bIgnoreAudioSensingIfCurrentEnemy;
	var () float					m_MinSoundOverLapTimeInSeconds;
	var () float					m_MaxSoundOverLapTimeInSeconds;

	var () float					m_ProximateSoundThreshold;

	var () float					m_SightDuration;/** How long a player remains visible without new updates */
	var () float					m_NoiseDuration;/** How long a player remains audible without new updates */
	var () float					m_ThreatDuration;/** How long a Danger Event remains a Threat without new updates */

	structdefaultproperties
	{
		m_bIgnoreAudioSensingIfCurrentEnemy							= true;
		m_MinSoundOverLapTimeInSeconds								= 0.5f
		m_MaxSoundOverLapTimeInSeconds								= 1.0f
		m_ProximateSoundThreshold									= 50.0f
		m_SightDuration												= 10.0f
		m_NoiseDuration												= 15.0f
		m_ThreatDuration											= 20.0f
	}
};

struct native VehicleInfo
{
	var () float					m_BlimpSpotlightThresholdForSeek;
	var () float					m_BlimpSpotlightBlindAngleDot;


	structdefaultproperties
	{
		m_BlimpSpotlightThresholdForSeek		= 0.05f
		m_BlimpSpotlightBlindAngleDot			= -0.92f
	}
};

//
// Variables
//
var(BoneGroups)		const SkeletalMeshBoneGroupInfo		SkeletalMeshBoneGroupData;

var(Civilian)		const MoveSpeedInfo					CivilianMoveData;
var(Civilian)		const MoveSpeedInfo					Civilian2MoveData;
var(Civilian)		const MoveSpeedInfo					Civilian3MoveData;
var(Civilian)		const MoveSpeedInfo					Civilian4MoveData;
var(Civilian)		const MoveSpeedInfo					CivilianDriverMoveData;
var(Civilian)		const MoveSpeedInfo					CivilianGimpMoveData;
var(Einstein)		const MoveSpeedInfo					EinsteinMoveData;
var(Partisan)		const MoveSpeedInfo					PartisanMoveData;
var(Player)			const MoveSpeedInfo					PlayerMoveData;
var(TPPawn)			const MoveSpeedInfo					TPPawnMoveData;
var(Wehrmacht)		const MoveSpeedInfo					WehrmachtMoveData;
var(TPAIController)	const RotRateInfo					StationaryRotRateData;
var(TPAIController)	const CoverShiftTuneInfo			CoverShiftTuneData;
var(TPAIController)	const CoverEngagementTuneInfo		CoverEngagementTuneData;
var(TPAIController)	const GrenadeUseInfo				GrenadeUseData;
var(TPAIController)	const EngagementTacInfo				EngagementTacData;
var(TPAIController)	const AimingAngleInfo				AimingAngleData;
var(TPAIController)	const SensingInfo					SensingData;
var						  AimingAngleInfoConverted		m_AimingAngleDataConverted;
var						  bool							m_AimingAnglesCoverted;
var(TPAIController) DebugDrawInfo						DebugDrawData;
var(TPAIController) const IdleAlertInfo					IdleAlertData;
var(TPAIController)	const NPC_AccuracyInfo				NPC_AccuracyData;

var(VehicleAI)		const VehicleInfo					VehicleData;

var(FaceFX)			const FaceFXStringInfo				FaceFXStringData;
var(FaceFX)			const FaceFXTuneInfo				FaceFXTuneData;

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



