class SPGameDifficultyTuneWeapons extends SPGameDifficultyTune
    native
    editinlinenew;

struct native SPWeaponGamePadParams
{
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float ZoomedTurnSpeedScalePct;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() bool bTargetAdhesionEnabled;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetAdhesionTimeMax;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetAdhesionDistanceMax;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetAdhesionAimDistY;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetAdhesionAimDistZ;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() Vector2D TargetAdhesionScaleRange;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetAdhesionScaleAmountMin;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetAdhesionTargetVelocityMin;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetAdhesionPlayerVelocityMin;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetAdhesionZoomedBoostValue;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() bool bTargetFrictionEnabled;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetFrictionDistanceMin;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetFrictionDistanceMax;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() Vector TargetFrictionOffset;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetFrictionDistancePeak;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetFrictionPeakRadiusScale;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetFrictionPeakHeightScale;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() Vector2D TargetFrictionMultiplierRange;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TargetFrictionZoomedBoostValue;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() InterpCurveFloat TargetFrictionDistanceCurve;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() editinline ForceFeedbackWaveform Fire_ForceFeedbackWaveform;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float WalkSpeedScale;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() float TurnSpeedScale;

    structdefaultproperties
    {
        ZoomedTurnSpeedScalePct=0.8500000
        bTargetAdhesionEnabled=true
        TargetAdhesionTimeMax=0.0000000
        TargetAdhesionDistanceMax=2000.0000000
        TargetAdhesionAimDistY=128.0000000
        TargetAdhesionAimDistZ=96.0000000
        TargetAdhesionScaleRange=(X=0.3000000,Y=2.8500000)
        TargetAdhesionScaleAmountMin=0.0000000
        TargetAdhesionTargetVelocityMin=0.0000000
        TargetAdhesionPlayerVelocityMin=0.0000000
        TargetAdhesionZoomedBoostValue=0.2500000
        bTargetFrictionEnabled=true
        TargetFrictionDistanceMin=320.0000000
        TargetFrictionDistanceMax=3000.0000000
        TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=32.0000000)
        TargetFrictionDistancePeak=1500.0000000
        TargetFrictionPeakRadiusScale=1.0000000
        TargetFrictionPeakHeightScale=0.2000000
        TargetFrictionMultiplierRange=(X=0.3000000,Y=0.4000000)
        TargetFrictionZoomedBoostValue=0.2500000
        TargetFrictionDistanceCurve=(Points=/* Array type was not detected. */,InterpMethod=IMT_UseFixedTangentEvalAndNewAutoTangents)
        Fire_ForceFeedbackWaveform=none
        WalkSpeedScale=1.0000000
        TurnSpeedScale=1.0000000
    }
};

struct native RecoilGroupData
{
    /** Need to breakdown by mode; */
    var() RecoilData Normal;
    /** Need to breakdown by mode; */
    var() RecoilData Crouched;
    /** Need to breakdown by mode; */
    var() RecoilData DownSite;
    /** Need to breakdown by mode; */
    var() RecoilData CrouchedDownSite;
    /** Need to breakdown by mode; */
    var() float CrouchedShakeScale;
    /** Need to breakdown by mode; */
    var() float DownSiteShakeScale;
    /** Need to breakdown by mode; */
    var() float CrouchedDownSiteShakeScale;

    structdefaultproperties
    {
        Normal=(PitchImpactAngle=0.0000000,YawImpactAngle=0.0000000,RandPitchImpactAngle=0.0000000,RandYawImpactAngle=0.0000000,EffectImpulseTime=0.0000000,EffectRecoverTime=0.0000000)
        Crouched=(PitchImpactAngle=0.0000000,YawImpactAngle=0.0000000,RandPitchImpactAngle=0.0000000,RandYawImpactAngle=0.0000000,EffectImpulseTime=0.0000000,EffectRecoverTime=0.0000000)
        DownSite=(PitchImpactAngle=0.0000000,YawImpactAngle=0.0000000,RandPitchImpactAngle=0.0000000,RandYawImpactAngle=0.0000000,EffectImpulseTime=0.0000000,EffectRecoverTime=0.0000000)
        CrouchedDownSite=(PitchImpactAngle=0.0000000,YawImpactAngle=0.0000000,RandPitchImpactAngle=0.0000000,RandYawImpactAngle=0.0000000,EffectImpulseTime=0.0000000,EffectRecoverTime=0.0000000)
        CrouchedShakeScale=0.0000000
        DownSiteShakeScale=0.0000000
        CrouchedDownSiteShakeScale=0.0000000
    }
};

struct native SpreadData
{
    var() float StoppedSpreadValue;
    var() float FullSpeedSpreadValue;

    structdefaultproperties
    {
        StoppedSpreadValue=0.0000000
        FullSpeedSpreadValue=0.0000000
    }
};

struct native SpreadGroupData
{
    /** Need to breakdown by mode; */
    var() SpreadData Normal;
    /** Need to breakdown by mode; */
    var() SpreadData Crouched;
    /** Need to breakdown by mode; */
    var() SpreadData DownSite;
    /** Need to breakdown by mode; */
    var() SpreadData CrouchedDownSite;
    /** Also if crouched down site */
    var() SpreadData FirstShotDownSite;
    /** Minumum Delta Time since last shot to be considered a first shot */
    var() float FirstShotMinDeltaTime;

    structdefaultproperties
    {
        Normal=(StoppedSpreadValue=0.0000000,FullSpeedSpreadValue=0.0000000)
        Crouched=(StoppedSpreadValue=0.0000000,FullSpeedSpreadValue=0.0000000)
        DownSite=(StoppedSpreadValue=0.0000000,FullSpeedSpreadValue=0.0000000)
        CrouchedDownSite=(StoppedSpreadValue=0.0000000,FullSpeedSpreadValue=0.0000000)
        FirstShotDownSite=(StoppedSpreadValue=0.0000000,FullSpeedSpreadValue=0.0000000)
        FirstShotMinDeltaTime=2.0000000
    }
};

struct native SPWeaponData
{
    var() SPWeaponGamePadParams GameControllerParams;

    structdefaultproperties
    {
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.8500000,bTargetAdhesionEnabled=true,TargetAdhesionTimeMax=0.0000000,TargetAdhesionDistanceMax=2000.0000000,TargetAdhesionAimDistY=128.0000000,TargetAdhesionAimDistZ=96.0000000,TargetAdhesionScaleRange=(X=0.3000000,Y=2.8500000),TargetAdhesionScaleAmountMin=0.0000000,TargetAdhesionTargetVelocityMin=0.0000000,TargetAdhesionPlayerVelocityMin=0.0000000,TargetAdhesionZoomedBoostValue=0.2500000,bTargetFrictionEnabled=true,TargetFrictionDistanceMin=320.0000000,TargetFrictionDistanceMax=3000.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=32.0000000),TargetFrictionDistancePeak=1500.0000000,TargetFrictionPeakRadiusScale=1.0000000,TargetFrictionPeakHeightScale=0.2000000,TargetFrictionMultiplierRange=(X=0.3000000,Y=0.4000000),TargetFrictionZoomedBoostValue=0.2500000,TargetFrictionDistanceCurve=(Points=/* Array type was not detected. */,InterpMethod=IMT_UseFixedTangentEvalAndNewAutoTangents),Fire_ForceFeedbackWaveform=none,WalkSpeedScale=1.0000000,TurnSpeedScale=1.0000000)
    }
};

struct native GDShotgunData extends SPWeaponData
{
    /** Shotgun DECLARATIONS */
    var() const float Damage;
    /** Shotgun DECLARATIONS */
    var() const float NPCDamage;
    /** Shotgun DECLARATIONS */
    var() const int AmmoCount;
    /** Shotgun DECLARATIONS */
    var() const int MaxAmmoCount;
    /** Shotgun DECLARATIONS */
    var() const int magazineSize;
    /** Shotgun DECLARATIONS */
    var() const int ammoInMagazine;
    /** Shotgun DECLARATIONS */
    var() const float FireInterval;
    /** Shotgun DECLARATIONS */
    var() const int NumPellets;
    /** Shotgun DECLARATIONS */
    var() const float NPCNumPellets;
    /** Shotgun DECLARATIONS */
    var() const float LookDownSiteSideShiftRange;
    /** Shotgun DECLARATIONS */
    var() const float LookDownSiteSideShiftSpeed;
    /** Shotgun DECLARATIONS */
    var() const float LookDownSiteUpShiftRange;
    /** Shotgun DECLARATIONS */
    var() const float LookDownSiteUpShiftSpeed;
    /** Shotgun DECLARATIONS */
    var() const float SideShiftRange;
    /** Shotgun DECLARATIONS */
    var() const float SideShiftSpeed;
    /** Shotgun DECLARATIONS */
    var() const float UpShiftRange;
    /** Shotgun DECLARATIONS */
    var() const float UpShiftSpeed;
    /** Shotgun DECLARATIONS */
    var() const float MuzzleFlashLightValue;
    /** Shotgun DECLARATIONS */
    var() const float MuzzleFlashLightFadeSpeed;
    /** Shotgun DECLARATIONS */
    var() const float ADSFireInterval;
    /** Shotgun DECLARATIONS */
    var() const float ReticleSpreadScale;
    /** Shotgun DECLARATIONS// shellcasings */
    var(ShellCasing) const Rotator InitialShellRotation;
    /** Shotgun DECLARATIONS// shellcasings */
    var(ShellCasing) const float InitialRotationalRate;
    /** Shotgun DECLARATIONS// shellcasings */
    var(ShellCasing) const float VelocitySpeedScaler;
    /** Shotgun DECLARATIONS// shellcasings */
    var(ShellCasing) const float ZShellArch;

    structdefaultproperties
    {
        Damage=14.0000000
        NPCDamage=30.0000000
        AmmoCount=96
        MaxAmmoCount=96
        magazineSize=6
        ammoInMagazine=6
        FireInterval=0.5000000
        NumPellets=10
        NPCNumPellets=3.0000000
        LookDownSiteSideShiftRange=2.0000000
        LookDownSiteSideShiftSpeed=0.0100000
        LookDownSiteUpShiftRange=2.0000000
        LookDownSiteUpShiftSpeed=0.0100000
        SideShiftRange=2.0000000
        SideShiftSpeed=0.0900000
        UpShiftRange=2.0000000
        UpShiftSpeed=0.0800000
        MuzzleFlashLightValue=1.0000000
        MuzzleFlashLightFadeSpeed=0.5000000
        ADSFireInterval=0.5000000
        ReticleSpreadScale=0.1500000
        InitialRotationalRate=32500.0000000
        VelocitySpeedScaler=1.2000000
        ZShellArch=100.0000000
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.0000000,bTargetAdhesionEnabled=false,TargetAdhesionDistanceMax=0.0000000,TargetAdhesionAimDistY=0.0000000,TargetAdhesionAimDistZ=0.0000000,TargetAdhesionScaleRange=(X=0.0000000,Y=0.0000000),TargetAdhesionZoomedBoostValue=0.0000000,bTargetFrictionEnabled=false,TargetFrictionDistanceMin=0.0000000,TargetFrictionDistanceMax=0.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetFrictionDistancePeak=0.0000000,TargetFrictionPeakRadiusScale=0.0000000,TargetFrictionPeakHeightScale=0.0000000,TargetFrictionMultiplierRange=(X=0.0000000,Y=0.0000000),TargetFrictionZoomedBoostValue=0.0000000,TargetFrictionDistanceCurve=(Points=none),WalkSpeedScale=0.0000000,TurnSpeedScale=0.0000000)
    }
};

struct native GDAssaultRifleData extends SPWeaponData
{
    /** AssaultRifle DECLARATIONS */
    var() const float Damage;
    /** AssaultRifle DECLARATIONS */
    var() const int AmmoCount;
    /** AssaultRifle DECLARATIONS */
    var() const int MaxAmmoCount;
    /** AssaultRifle DECLARATIONS */
    var() const int magazineSize;
    /** AssaultRifle DECLARATIONS */
    var() const int ammoInMagazine;
    /** AssaultRifle DECLARATIONS */
    var() const float LookDownSiteFOV;
    /** AssaultRifle DECLARATIONS */
    var() const float WorldLookDownSiteFOV;
    /** AssaultRifle DECLARATIONS */
    var() const float WeaponDampValue;
    /** AssaultRifle DECLARATIONS */
    var() const int ScopeDamage;
    /** AssaultRifle DECLARATIONS */
    var() const int RoundsPerMinute;
    /** AssaultRifle DECLARATIONS */
    var() const float MuzzleFlashLightValue;
    /** AssaultRifle DECLARATIONS */
    var() const float MuzzleFlashLightFadeSpeed;
    /** AssaultRifle DECLARATIONS */
    var() const float SideShiftRange;
    /** AssaultRifle DECLARATIONS */
    var() const float SideShiftSpeed;
    /** AssaultRifle DECLARATIONS */
    var() const float UpShiftRange;
    /** AssaultRifle DECLARATIONS */
    var() const float UpShiftSpeed;
    /** AssaultRifle DECLARATIONS// shellcasings */
    var(ShellCasing) const Rotator InitialShellRotation;
    /** AssaultRifle DECLARATIONS// shellcasings */
    var(ShellCasing) const float InitialRotationalRate;
    /** AssaultRifle DECLARATIONS// shellcasings */
    var(ShellCasing) const float VelocitySpeedScaler;
    /** AssaultRifle DECLARATIONS// shellcasings */
    var(ShellCasing) const float ZShellArch;

    structdefaultproperties
    {
        Damage=22.0000000
        AmmoCount=300
        MaxAmmoCount=300
        magazineSize=30
        ammoInMagazine=30
        LookDownSiteFOV=10.0000000
        WorldLookDownSiteFOV=10.0000000
        WeaponDampValue=0.1000000
        ScopeDamage=30
        RoundsPerMinute=750
        MuzzleFlashLightValue=1.0000000
        MuzzleFlashLightFadeSpeed=0.2000000
        SideShiftRange=2.0000000
        SideShiftSpeed=0.0900000
        UpShiftRange=2.0000000
        UpShiftSpeed=0.0800000
        InitialRotationalRate=32500.0000000
        VelocitySpeedScaler=1.2000000
        ZShellArch=100.0000000
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.0000000,bTargetAdhesionEnabled=false,TargetAdhesionDistanceMax=0.0000000,TargetAdhesionAimDistY=0.0000000,TargetAdhesionAimDistZ=0.0000000,TargetAdhesionScaleRange=(X=0.0000000,Y=0.0000000),TargetAdhesionZoomedBoostValue=0.0000000,bTargetFrictionEnabled=false,TargetFrictionDistanceMin=0.0000000,TargetFrictionDistanceMax=0.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetFrictionDistancePeak=0.0000000,TargetFrictionPeakRadiusScale=0.0000000,TargetFrictionPeakHeightScale=0.0000000,TargetFrictionMultiplierRange=(X=0.0000000,Y=0.0000000),TargetFrictionZoomedBoostValue=0.0000000,TargetFrictionDistanceCurve=(Points=none),WalkSpeedScale=0.0000000,TurnSpeedScale=0.0000000)
    }
};

struct native GDSawData extends SPWeaponData
{
    /** Saw DECLARATIONS */
    var() const float Damage;
    /** Saw DECLARATIONS */
    var() const int AmmoCount;
    /** Saw DECLARATIONS */
    var() const int MaxAmmoCount;
    /** Saw DECLARATIONS */
    var() const int magazineSize;
    /** Saw DECLARATIONS */
    var() const int ammoInMagazine;
    /** Saw DECLARATIONS */
    var() const int RoundsPerMinute;
    /** Saw DECLARATIONS */
    var() const float LookDownSiteSideShiftRange;
    /** Saw DECLARATIONS */
    var() const float LookDownSiteSideShiftSpeed;
    /** Saw DECLARATIONS */
    var() const float LookDownSiteUpShiftRange;
    /** Saw DECLARATIONS */
    var() const float LookDownSiteUpShiftSpeed;
    /** Saw DECLARATIONS */
    var() const float SideShiftRange;
    /** Saw DECLARATIONS */
    var() const float SideShiftSpeed;
    /** Saw DECLARATIONS */
    var() const float UpShiftRange;
    /** Saw DECLARATIONS */
    var() const float UpShiftSpeed;
    /** Saw DECLARATIONS */
    var() const float MuzzleFlashLightValue;
    /** Saw DECLARATIONS */
    var() const float MuzzleFlashLightFadeSpeed;
    /** Saw DECLARATIONS// shellcasings */
    var(ShellCasing) const Rotator InitialShellRotation;
    /** Saw DECLARATIONS// shellcasings */
    var(ShellCasing) const float InitialRotationalRate;
    /** Saw DECLARATIONS// shellcasings */
    var(ShellCasing) const float VelocitySpeedScaler;
    /** Saw DECLARATIONS// shellcasings */
    var(ShellCasing) const float ZShellArch;

    structdefaultproperties
    {
        Damage=25.0000000
        AmmoCount=400
        MaxAmmoCount=400
        magazineSize=200
        ammoInMagazine=200
        RoundsPerMinute=725
        LookDownSiteSideShiftRange=2.0000000
        LookDownSiteSideShiftSpeed=0.0100000
        LookDownSiteUpShiftRange=2.0000000
        LookDownSiteUpShiftSpeed=0.0100000
        SideShiftRange=2.0000000
        SideShiftSpeed=0.0800000
        UpShiftRange=2.0000000
        UpShiftSpeed=0.0700000
        MuzzleFlashLightValue=1.0000000
        MuzzleFlashLightFadeSpeed=0.2000000
        InitialRotationalRate=32500.0000000
        VelocitySpeedScaler=1.2000000
        ZShellArch=100.0000000
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.0000000,bTargetAdhesionEnabled=false,TargetAdhesionDistanceMax=0.0000000,TargetAdhesionAimDistY=0.0000000,TargetAdhesionAimDistZ=0.0000000,TargetAdhesionScaleRange=(X=0.0000000,Y=0.0000000),TargetAdhesionZoomedBoostValue=0.0000000,bTargetFrictionEnabled=false,TargetFrictionDistanceMin=0.0000000,TargetFrictionDistanceMax=0.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetFrictionDistancePeak=0.0000000,TargetFrictionPeakRadiusScale=0.0000000,TargetFrictionPeakHeightScale=0.0000000,TargetFrictionMultiplierRange=(X=0.0000000,Y=0.0000000),TargetFrictionZoomedBoostValue=0.0000000,TargetFrictionDistanceCurve=(Points=none),WalkSpeedScale=0.0000000,TurnSpeedScale=0.0000000)
    }
};

struct native GDHKUMPData extends SPWeaponData
{
    /** HK_UMP DECLARATIONS */
    var() const float Damage;
    /** HK_UMP DECLARATIONS */
    var() const int AmmoCount;
    /** HK_UMP DECLARATIONS */
    var() const int MaxAmmoCount;
    /** HK_UMP DECLARATIONS */
    var() const int magazineSize;
    /** HK_UMP DECLARATIONS */
    var() const int ammoInMagazine;
    /** HK_UMP DECLARATIONS */
    var() const int RoundsPerMinute;
    /** HK_UMP DECLARATIONS */
    var() const float LookDownSiteSideShiftRange;
    /** HK_UMP DECLARATIONS */
    var() const float LookDownSiteSideShiftSpeed;
    /** HK_UMP DECLARATIONS */
    var() const float LookDownSiteUpShiftRange;
    /** HK_UMP DECLARATIONS */
    var() const float LookDownSiteUpShiftSpeed;
    /** HK_UMP DECLARATIONS */
    var() const float SideShiftRange;
    /** HK_UMP DECLARATIONS */
    var() const float SideShiftSpeed;
    /** HK_UMP DECLARATIONS */
    var() const float UpShiftRange;
    /** HK_UMP DECLARATIONS */
    var() const float UpShiftSpeed;
    /** HK_UMP DECLARATIONS */
    var() const float MuzzleFlashLightValue;
    /** HK_UMP DECLARATIONS */
    var() const float MuzzleFlashLightFadeSpeed;
    /** HK_UMP DECLARATIONS// shellcasings */
    var(ShellCasing) const Rotator InitialShellRotation;
    /** HK_UMP DECLARATIONS// shellcasings */
    var(ShellCasing) const float InitialRotationalRate;
    /** HK_UMP DECLARATIONS// shellcasings */
    var(ShellCasing) const float VelocitySpeedScaler;
    /** HK_UMP DECLARATIONS// shellcasings */
    var(ShellCasing) const float ZShellArch;

    structdefaultproperties
    {
        Damage=12.0000000
        AmmoCount=450
        MaxAmmoCount=450
        magazineSize=45
        ammoInMagazine=45
        RoundsPerMinute=1250
        LookDownSiteSideShiftRange=2.0000000
        LookDownSiteSideShiftSpeed=0.0100000
        LookDownSiteUpShiftRange=2.0000000
        LookDownSiteUpShiftSpeed=0.0100000
        SideShiftRange=2.0000000
        SideShiftSpeed=0.0900000
        UpShiftRange=2.0000000
        UpShiftSpeed=0.0800000
        MuzzleFlashLightValue=1.0000000
        MuzzleFlashLightFadeSpeed=0.2000000
        InitialRotationalRate=32500.0000000
        VelocitySpeedScaler=1.2000000
        ZShellArch=100.0000000
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.0000000,bTargetAdhesionEnabled=false,TargetAdhesionDistanceMax=0.0000000,TargetAdhesionAimDistY=0.0000000,TargetAdhesionAimDistZ=0.0000000,TargetAdhesionScaleRange=(X=0.0000000,Y=0.0000000),TargetAdhesionZoomedBoostValue=0.0000000,bTargetFrictionEnabled=false,TargetFrictionDistanceMin=0.0000000,TargetFrictionDistanceMax=0.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetFrictionDistancePeak=0.0000000,TargetFrictionPeakRadiusScale=0.0000000,TargetFrictionPeakHeightScale=0.0000000,TargetFrictionMultiplierRange=(X=0.0000000,Y=0.0000000),TargetFrictionZoomedBoostValue=0.0000000,TargetFrictionDistanceCurve=(Points=none),WalkSpeedScale=0.0000000,TurnSpeedScale=0.0000000)
    }
};

struct native GDFlameThrowerData extends SPWeaponData
{
    /** FlameThrower DECLARATIONS */
    var() const float Damage;
    /** FlameThrower DECLARATIONS */
    var() const int AmmoCount;
    /** FlameThrower DECLARATIONS */
    var() const int MaxAmmoCount;
    /** FlameThrower DECLARATIONS */
    var() const int magazineSize;
    /** FlameThrower DECLARATIONS */
    var() const int ammoInMagazine;
    /** FlameThrower DECLARATIONS */
    var() const float LookDownSiteSideShiftRange;
    /** FlameThrower DECLARATIONS */
    var() const float LookDownSiteSideShiftSpeed;
    /** FlameThrower DECLARATIONS */
    var() const float LookDownSiteUpShiftRange;
    /** FlameThrower DECLARATIONS */
    var() const float LookDownSiteUpShiftSpeed;
    /** FlameThrower DECLARATIONS */
    var() const float SideShiftRange;
    /** FlameThrower DECLARATIONS */
    var() const float SideShiftSpeed;
    /** FlameThrower DECLARATIONS */
    var() const float UpShiftRange;
    /** FlameThrower DECLARATIONS */
    var() const float UpShiftSpeed;

    structdefaultproperties
    {
        Damage=18.0000000
        LookDownSiteSideShiftRange=2.0000000
        LookDownSiteSideShiftSpeed=0.0100000
        LookDownSiteUpShiftRange=2.0000000
        LookDownSiteUpShiftSpeed=0.0100000
        SideShiftRange=1.6500000
        SideShiftSpeed=0.0300000
        UpShiftRange=1.6500000
        UpShiftSpeed=0.0300000
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.0000000,bTargetAdhesionEnabled=false,TargetAdhesionDistanceMax=0.0000000,TargetAdhesionAimDistY=0.0000000,TargetAdhesionAimDistZ=0.0000000,TargetAdhesionScaleRange=(X=0.0000000,Y=0.0000000),TargetAdhesionZoomedBoostValue=0.0000000,bTargetFrictionEnabled=false,TargetFrictionDistanceMin=0.0000000,TargetFrictionDistanceMax=0.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetFrictionDistancePeak=0.0000000,TargetFrictionPeakRadiusScale=0.0000000,TargetFrictionPeakHeightScale=0.0000000,TargetFrictionMultiplierRange=(X=0.0000000,Y=0.0000000),TargetFrictionZoomedBoostValue=0.0000000,TargetFrictionDistanceCurve=(Points=none),WalkSpeedScale=0.0000000,TurnSpeedScale=0.0000000)
    }
};

struct native GDRocketLauncherData extends SPWeaponData
{
    /** RocketLauncher DECLARATIONS */
    var() const float Damage;
    /** RocketLauncher DECLARATIONS */
    var() const float DamageRadius;
    /** RocketLauncher DECLARATIONS */
    var() const float PlayerOnlyDamage;
    /** RocketLauncher DECLARATIONS */
    var() const float PlayerOnlyRadius;
    /** RocketLauncher DECLARATIONS */
    var() const int AmmoCount;
    /** RocketLauncher DECLARATIONS */
    var() const int MaxAmmoCount;
    /** RocketLauncher DECLARATIONS */
    var() const int magazineSize;
    /** RocketLauncher DECLARATIONS */
    var() const int ammoInMagazine;
    /** RocketLauncher DECLARATIONS */
    var() const float LookDownSiteSideShiftRange;
    /** RocketLauncher DECLARATIONS */
    var() const float LookDownSiteSideShiftSpeed;
    /** RocketLauncher DECLARATIONS */
    var() const float LookDownSiteUpShiftRange;
    /** RocketLauncher DECLARATIONS */
    var() const float LookDownSiteUpShiftSpeed;
    /** RocketLauncher DECLARATIONS */
    var() const float SideShiftRange;
    /** RocketLauncher DECLARATIONS */
    var() const float SideShiftSpeed;
    /** RocketLauncher DECLARATIONS */
    var() const float UpShiftRange;
    /** RocketLauncher DECLARATIONS */
    var() const float UpShiftSpeed;
    /** RocketLauncher DECLARATIONS */
    var(LockOn) const float TimeRequiredToLock;
    /** RocketLauncher DECLARATIONS */
    var(LockOn) const float TimeTargetCanBeLostWithoutLoosingLock;
    /** RocketLauncher DECLARATIONS */
    var(LockOn) const float TargetRadiusMultiplier;
    /** RocketLauncher DECLARATIONS */
    var(LockOn) const float LockOnSpriteScreenSize;

    structdefaultproperties
    {
        Damage=800.0000000
        DamageRadius=800.0000000
        PlayerOnlyDamage=50.0000000
        PlayerOnlyRadius=300.0000000
        AmmoCount=6
        MaxAmmoCount=12
        magazineSize=1
        ammoInMagazine=1
        LookDownSiteSideShiftRange=2.0000000
        LookDownSiteSideShiftSpeed=0.0100000
        LookDownSiteUpShiftRange=2.0000000
        LookDownSiteUpShiftSpeed=0.0100000
        SideShiftRange=1.0000000
        SideShiftSpeed=0.0300000
        UpShiftRange=1.0000000
        UpShiftSpeed=0.0300000
        TimeRequiredToLock=2.0000000
        TimeTargetCanBeLostWithoutLoosingLock=1.0000000
        TargetRadiusMultiplier=1.0000000
        LockOnSpriteScreenSize=128.0000000
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.0000000,bTargetAdhesionEnabled=false,TargetAdhesionDistanceMax=0.0000000,TargetAdhesionAimDistY=0.0000000,TargetAdhesionAimDistZ=0.0000000,TargetAdhesionScaleRange=(X=0.0000000,Y=0.0000000),TargetAdhesionZoomedBoostValue=0.0000000,bTargetFrictionEnabled=false,TargetFrictionDistanceMin=0.0000000,TargetFrictionDistanceMax=0.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetFrictionDistancePeak=0.0000000,TargetFrictionPeakRadiusScale=0.0000000,TargetFrictionPeakHeightScale=0.0000000,TargetFrictionMultiplierRange=(X=0.0000000,Y=0.0000000),TargetFrictionZoomedBoostValue=0.0000000,TargetFrictionDistanceCurve=(Points=none),WalkSpeedScale=0.0000000,TurnSpeedScale=0.0000000)
    }
};

struct native GDDesertEagleData extends SPWeaponData
{
    /** DesertEagle DECLARATIONS */
    var() const float Damage;
    /** DesertEagle DECLARATIONS */
    var() const int AmmoCount;
    /** DesertEagle DECLARATIONS */
    var() const int MaxAmmoCount;
    /** DesertEagle DECLARATIONS */
    var() const int magazineSize;
    /** DesertEagle DECLARATIONS */
    var() const int ammoInMagazine;
    /** DesertEagle DECLARATIONS */
    var() const float FireInterval;
    /** DesertEagle DECLARATIONS */
    var() const float LookDownSiteSideShiftRange;
    /** DesertEagle DECLARATIONS */
    var() const float LookDownSiteSideShiftSpeed;
    /** DesertEagle DECLARATIONS */
    var() const float LookDownSiteUpShiftRange;
    /** DesertEagle DECLARATIONS */
    var() const float LookDownSiteUpShiftSpeed;
    /** DesertEagle DECLARATIONS */
    var() const float SideShiftRange;
    /** DesertEagle DECLARATIONS */
    var() const float SideShiftSpeed;
    /** DesertEagle DECLARATIONS */
    var() const float UpShiftRange;
    /** DesertEagle DECLARATIONS */
    var() const float UpShiftSpeed;
    /** DesertEagle DECLARATIONS */
    var() const float MuzzleFlashLightValue;
    /** DesertEagle DECLARATIONS */
    var() const float MuzzleFlashLightFadeSpeed;
    /** DesertEagle DECLARATIONS */
    var() const float ADSFireInterval;
    /** DesertEagle DECLARATIONS// shellcasings */
    var(ShellCasing) const Rotator InitialShellRotation;
    /** DesertEagle DECLARATIONS// shellcasings */
    var(ShellCasing) const float InitialRotationalRate;
    /** DesertEagle DECLARATIONS// shellcasings */
    var(ShellCasing) const float VelocitySpeedScaler;
    /** DesertEagle DECLARATIONS// shellcasings */
    var(ShellCasing) const float ZShellArch;

    structdefaultproperties
    {
        Damage=100.0000000
        AmmoCount=45
        MaxAmmoCount=45
        magazineSize=15
        ammoInMagazine=15
        FireInterval=0.4000000
        LookDownSiteSideShiftRange=2.0000000
        LookDownSiteSideShiftSpeed=0.0100000
        LookDownSiteUpShiftRange=2.0000000
        LookDownSiteUpShiftSpeed=0.0100000
        SideShiftRange=2.0000000
        SideShiftSpeed=0.0900000
        UpShiftRange=2.0000000
        UpShiftSpeed=0.0800000
        MuzzleFlashLightValue=1.0000000
        MuzzleFlashLightFadeSpeed=0.5000000
        ADSFireInterval=0.4000000
        InitialRotationalRate=32500.0000000
        VelocitySpeedScaler=1.2000000
        ZShellArch=100.0000000
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.0000000,bTargetAdhesionEnabled=false,TargetAdhesionDistanceMax=0.0000000,TargetAdhesionAimDistY=0.0000000,TargetAdhesionAimDistZ=0.0000000,TargetAdhesionScaleRange=(X=0.0000000,Y=0.0000000),TargetAdhesionZoomedBoostValue=0.0000000,bTargetFrictionEnabled=false,TargetFrictionDistanceMin=0.0000000,TargetFrictionDistanceMax=0.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetFrictionDistancePeak=0.0000000,TargetFrictionPeakRadiusScale=0.0000000,TargetFrictionPeakHeightScale=0.0000000,TargetFrictionMultiplierRange=(X=0.0000000,Y=0.0000000),TargetFrictionZoomedBoostValue=0.0000000,TargetFrictionDistanceCurve=(Points=none),WalkSpeedScale=0.0000000,TurnSpeedScale=0.0000000)
    }
};

struct native GDNineMMData extends SPWeaponData
{
    /** NineMM DECLARATIONS */
    var() const float Damage;
    /** NineMM DECLARATIONS */
    var() const int AmmoCount;
    /** NineMM DECLARATIONS */
    var() const int MaxAmmoCount;
    /** NineMM DECLARATIONS */
    var() const int magazineSize;
    /** NineMM DECLARATIONS */
    var() const int ammoInMagazine;
    /** NineMM DECLARATIONS */
    var() const float FireInterval;
    /** NineMM DECLARATIONS */
    var() const float LookDownSiteSideShiftRange;
    /** NineMM DECLARATIONS */
    var() const float LookDownSiteSideShiftSpeed;
    /** NineMM DECLARATIONS */
    var() const float LookDownSiteUpShiftRange;
    /** NineMM DECLARATIONS */
    var() const float LookDownSiteUpShiftSpeed;
    /** NineMM DECLARATIONS */
    var() const float SideShiftRange;
    /** NineMM DECLARATIONS */
    var() const float SideShiftSpeed;
    /** NineMM DECLARATIONS */
    var() const float UpShiftRange;
    /** NineMM DECLARATIONS */
    var() const float UpShiftSpeed;
    /** NineMM DECLARATIONS */
    var() const float MuzzleFlashLightValue;
    /** NineMM DECLARATIONS */
    var() const float MuzzleFlashLightFadeSpeed;
    /** NineMM DECLARATIONS */
    var() const float ADSFireInterval;
    /** NineMM DECLARATIONS// shellcasings */
    var(ShellCasing) const Rotator InitialShellRotation;
    /** NineMM DECLARATIONS// shellcasings */
    var(ShellCasing) const float InitialRotationalRate;
    /** NineMM DECLARATIONS// shellcasings */
    var(ShellCasing) const float VelocitySpeedScaler;
    /** NineMM DECLARATIONS// shellcasings */
    var(ShellCasing) const float ZShellArch;

    structdefaultproperties
    {
        Damage=30.0000000
        AmmoCount=100
        MaxAmmoCount=100
        magazineSize=15
        ammoInMagazine=15
        FireInterval=0.1000000
        LookDownSiteSideShiftRange=2.0000000
        LookDownSiteSideShiftSpeed=0.0100000
        LookDownSiteUpShiftRange=2.0000000
        LookDownSiteUpShiftSpeed=0.0100000
        SideShiftRange=2.0000000
        SideShiftSpeed=0.0900000
        UpShiftRange=2.0000000
        UpShiftSpeed=0.0800000
        MuzzleFlashLightValue=1.0000000
        MuzzleFlashLightFadeSpeed=0.5000000
        ADSFireInterval=0.1000000
        InitialRotationalRate=32500.0000000
        VelocitySpeedScaler=1.2000000
        ZShellArch=100.0000000
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.0000000,bTargetAdhesionEnabled=false,TargetAdhesionDistanceMax=0.0000000,TargetAdhesionAimDistY=0.0000000,TargetAdhesionAimDistZ=0.0000000,TargetAdhesionScaleRange=(X=0.0000000,Y=0.0000000),TargetAdhesionZoomedBoostValue=0.0000000,bTargetFrictionEnabled=false,TargetFrictionDistanceMin=0.0000000,TargetFrictionDistanceMax=0.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetFrictionDistancePeak=0.0000000,TargetFrictionPeakRadiusScale=0.0000000,TargetFrictionPeakHeightScale=0.0000000,TargetFrictionMultiplierRange=(X=0.0000000,Y=0.0000000),TargetFrictionZoomedBoostValue=0.0000000,TargetFrictionDistanceCurve=(Points=none),WalkSpeedScale=0.0000000,TurnSpeedScale=0.0000000)
    }
};

struct native GDFireAxeData extends SPWeaponData
{
    /** FireAxe DECLARATIONS */
    var() const float Damage;
    /** FireAxe DECLARATIONS */
    var() const float HitImpulse;
    /** FireAxe DECLARATIONS */
    var() const float HitImpulseSuper;
    /** FireAxe DECLARATIONS */
    var() const float HitImpulseStatic;
    /** FireAxe DECLARATIONS */
    var() const float SlomoSpeed;
    /** FireAxe DECLARATIONS */
    var() const float SlomoDuration;
    /** FireAxe DECLARATIONS */
    var() const float SlomoStartDelay;
    /** FireAxe DECLARATIONS */
    var() const float ZImpulseNormal;
    /** FireAxe DECLARATIONS */
    var() const float ZImpulseSuper;
    /** FireAxe DECLARATIONS */
    var() const float SideShiftRange;
    /** FireAxe DECLARATIONS */
    var() const float SideShiftSpeed;
    /** FireAxe DECLARATIONS */
    var() const float UpShiftRange;
    /** FireAxe DECLARATIONS */
    var() const float UpShiftSpeed;
    /** range the player can attack */
    var() const float AttackDistance;
    /**  
     *additional length to the striking distance when attacking downwards (so you can hit the ground without giving the player
     *   a ridiculously long attack reach
     */
    var() const float ExtraLengthWhenAttackingDown;

    structdefaultproperties
    {
        Damage=150.0000000
        HitImpulse=10000.0000000
        HitImpulseSuper=15000.0000000
        HitImpulseStatic=3000.0000000
        SlomoSpeed=0.1000000
        SlomoDuration=0.1000000
        ZImpulseNormal=0.7000000
        ZImpulseSuper=1.0000000
        SideShiftRange=1.6500000
        SideShiftSpeed=0.0900000
        UpShiftRange=1.6500000
        UpShiftSpeed=0.0800000
        AttackDistance=175.0000000
        ExtraLengthWhenAttackingDown=100.0000000
        GameControllerParams=(ZoomedTurnSpeedScalePct=0.0000000,bTargetAdhesionEnabled=false,TargetAdhesionDistanceMax=0.0000000,TargetAdhesionAimDistY=0.0000000,TargetAdhesionAimDistZ=0.0000000,TargetAdhesionScaleRange=(X=0.0000000,Y=0.0000000),TargetAdhesionZoomedBoostValue=0.0000000,bTargetFrictionEnabled=false,TargetFrictionDistanceMin=0.0000000,TargetFrictionDistanceMax=0.0000000,TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetFrictionDistancePeak=0.0000000,TargetFrictionPeakRadiusScale=0.0000000,TargetFrictionPeakHeightScale=0.0000000,TargetFrictionMultiplierRange=(X=0.0000000,Y=0.0000000),TargetFrictionZoomedBoostValue=0.0000000,TargetFrictionDistanceCurve=(Points=none),WalkSpeedScale=0.0000000,TurnSpeedScale=0.0000000)
    }
};

struct native GDGrenadeData
{
    /** Grenade DECLARATIONS */
    var() const float VelocityScaler;
    /** Grenade DECLARATIONS */
    var() const float GravityScaler;
    /** Grenade DECLARATIONS */
    var() const float LifeSpan;
    /** Grenade DECLARATIONS */
    var() const int MaxCount;
    /** Grenade DECLARATIONS */
    var() const float ExplosionDamage;
    /** Grenade DECLARATIONS */
    var() const float ExplosionRadius;
    /** Grenade DECLARATIONS */
    var() const float ImpulseStrength;
    /** Grenade DECLARATIONS */
    var() const float PlayerOnlyRadius;
    /** Grenade DECLARATIONS */
    var() const float PlayerOnlyDamage;
    /** this value gets added to the damage radius of the grenade and is used to alert AI's within this radius to the presence of the grenade */
    var() const float AdditionalAIAlertRadius;

    structdefaultproperties
    {
        VelocityScaler=1.2000000
        GravityScaler=450.0000000
        LifeSpan=3.0000000
        MaxCount=10
        ExplosionDamage=500.0000000
        ExplosionRadius=500.0000000
        ImpulseStrength=30000.0000000
        PlayerOnlyRadius=300.0000000
        PlayerOnlyDamage=30.0000000
        AdditionalAIAlertRadius=200.0000000
    }
};

struct native GDFlareData
{
    /** Flare DECLARATIONS */
    var() const float VelocityScaler;
    /** Flare DECLARATIONS */
    var() const float GravityScaler;
    /** Flare DECLARATIONS */
    var() const float LifeSpan;
    /** Flare DECLARATIONS */
    var() const int MaxCount;

    structdefaultproperties
    {
        VelocityScaler=1.2000000
        GravityScaler=450.0000000
        LifeSpan=3.0000000
        MaxCount=10
    }
};

struct native GDTaserGrenadeData
{
    /** Taser Grenade DECLARATIONS */
    var() const float VelocityScaler;
    /** Taser Grenade DECLARATIONS */
    var() const float GravityScaler;
    /** Taser Grenade DECLARATIONS */
    var() const float LifeSpan;
    /** Taser Grenade DECLARATIONS */
    var() const int MaxCount;

    structdefaultproperties
    {
        VelocityScaler=1.2000000
        GravityScaler=450.0000000
        LifeSpan=3.0000000
        MaxCount=10
    }
};

struct native GDMolotovData
{
    /** Molotov DECLARATIONS */
    var() const float VelocityScaler;
    /** Molotov DECLARATIONS */
    var() const float GravityScaler;
    /** Molotov DECLARATIONS */
    var() const float LifeSpan;
    /** Radius of fire damage */
    var() const float FireRadius;
    /** How long the fire lasts by default */
    var() const float DefaultFireBurnTime;
    /** How long the fire lasts against creatures */
    var() const float FireBurnTimeVsCreatures;
    /** How long the fire lasts against humans (really just player since I think we are going to make fire always kill humans) */
    var() const float FireBurnTimeVsHumans;
    /** Fire damage dont to KActos */
    var() const float DamageVSKactors;
    /** Fire damage dont to Creatures */
    var() const float DamageVSCreatures;
    /** Fire damage dont to Humans */
    var() const float DamageVSHumans;
    /** Fire damage dont to Humans */
    var() const int MaxCount;
    /** Initial Explosion damage done (separate from fire damage) */
    var() const float ExplosionDamage;
    /** Radius of explosion damage */
    var() const float ExplosionRadius;
    /** Impulse strenght of explosion */
    var() const float ImpulseStrength;

    structdefaultproperties
    {
        VelocityScaler=1.2000000
        GravityScaler=450.0000000
        LifeSpan=3.0000000
        FireRadius=200.0000000
        DefaultFireBurnTime=8.0000000
        FireBurnTimeVsCreatures=8.0000000
        FireBurnTimeVsHumans=8.0000000
        DamageVSKactors=20.0000000
        DamageVSCreatures=70.0000000
        DamageVSHumans=70.0000000
        MaxCount=10
        ExplosionDamage=10.0000000
        ExplosionRadius=200.0000000
        ImpulseStrength=100.0000000
    }
};

struct native GDAmmoBoxData
{
    /** Ammo Box DECLARATIONS */
    var() const int AssaultRifleBoxAmmoCount;
    /** Ammo Box DECLARATIONS */
    var() const int SawBoxAmmoCount;
    /** Ammo Box DECLARATIONS */
    var() const int DesertEagleBoxAmmoCount;
    /** Ammo Box DECLARATIONS */
    var() const int ShotgunBoxAmmoCount;
    /** Ammo Box DECLARATIONS */
    var() const int HKUMPBoxAmmoCount;
    /** Ammo Box DECLARATIONS */
    var() const int NineMMBoxAmmoCount;
    /** Ammo Box DECLARATIONS */
    var() const int RocketBoxAmmoCountUnlimited;
    /** Ammo Box DECLARATIONS */
    var() const int GrenadeBoxAmmoCount;

    structdefaultproperties
    {
        AssaultRifleBoxAmmoCount=100
        SawBoxAmmoCount=200
        DesertEagleBoxAmmoCount=20
        ShotgunBoxAmmoCount=20
        HKUMPBoxAmmoCount=80
        NineMMBoxAmmoCount=20
        RocketBoxAmmoCountUnlimited=10000
        GrenadeBoxAmmoCount=6
    }
};

struct native GDSmallAmmoTypeData
{
    /** Small Ammo Type DECLARATIONS */
    var() const int AssaultRifleAmmoCount;
    /** Small Ammo Type DECLARATIONS */
    var() const int SawAmmoCount;
    /** Small Ammo Type DECLARATIONS */
    var() const int DesertEagleAmmoCount;
    /** Small Ammo Type DECLARATIONS */
    var() const int ShotgunAmmoCount;
    /** Small Ammo Type DECLARATIONS */
    var() const int HKUMPAmmoCount;
    /** Small Ammo Type DECLARATIONS */
    var() const int NineMMAmmoCount;
    /** Small Ammo Type DECLARATIONS */
    var() const int RocketAmmoCount;
    /** Small Ammo Type DECLARATIONS */
    var() const int FlameAmmoCount;

    structdefaultproperties
    {
        AssaultRifleAmmoCount=200
        SawAmmoCount=300
        DesertEagleAmmoCount=20
        ShotgunAmmoCount=20
        HKUMPAmmoCount=100
        NineMMAmmoCount=20
        RocketAmmoCount=5
        FlameAmmoCount=300
    }
};

struct native GDLargeAmmoTypeData
{
    /** Large Ammo Type DECLARATIONS */
    var() const int AssaultRifleAmmoCount;
    /** Large Ammo Type DECLARATIONS */
    var() const int SawAmmoCount;
    /** Large Ammo Type DECLARATIONS */
    var() const int DesertEagleAmmoCount;
    /** Large Ammo Type DECLARATIONS */
    var() const int ShotgunAmmoCount;
    /** Large Ammo Type DECLARATIONS */
    var() const int HKUMPAmmoCount;
    /** Large Ammo Type DECLARATIONS */
    var() const int NineMMAmmoCount;

    structdefaultproperties
    {
        AssaultRifleAmmoCount=100
        SawAmmoCount=150
        DesertEagleAmmoCount=20
        ShotgunAmmoCount=20
        HKUMPAmmoCount=100
        NineMMAmmoCount=20
    }
};

struct native GDGrenadeTypeData
{
    /** Large Ammo Type DECLARATIONS */
    var() const int GrenadesMaxCount;

    structdefaultproperties
    {
        GrenadesMaxCount=25
    }
};

/** VARIABLE DECLARATIONS */
var(shotgun) const GDShotgunData GDShotgunParams;
var(shotgun) const RecoilGroupData GDShotgunRecoilParams;
var(shotgun) const SpreadGroupData GDShotgunSpreadParams;
var(AssaultRifle) const GDAssaultRifleData GDAssaultRifleParams;
var(AssaultRifle) const RecoilGroupData GDAssaultRifleRecoilParams;
var(AssaultRifle) const SpreadGroupData GDAssaultRifleSpreadParams;
var(Saw) const GDSawData GDSawParams;
var(Saw) const RecoilGroupData GDSawRecoilParams;
var(Saw) const SpreadGroupData GDSawSpreadParams;
var(HK_UMP) const GDHKUMPData GDHKUMPParams;
var(HK_UMP) const RecoilGroupData GDHKUMPRecoilParams;
var(HK_UMP) const SpreadGroupData GDHKUMPSpreadParams;
var(FlameThrower) const GDFlameThrowerData GDFlameThrowerParams;
var(FlameThrower) const RecoilGroupData GDFlameThrowerRecoilParams;
var(FlameThrower) const SpreadGroupData GDFlameThrowerSpreadParams;
var(RocketLauncher) const GDRocketLauncherData GDRocketLauncherParams;
var(RocketLauncher) const RecoilGroupData GDRocketLauncherRecoilParams;
var(RocketLauncher) const SpreadGroupData GDRocketLauncherSpreadParams;
var(DesertEagle) const GDDesertEagleData GDDesertEagleParams;
var(DesertEagle) const RecoilGroupData GDDesertEagleRecoilParams;
var(DesertEagle) const SpreadGroupData GDDesertEagleSpreadParams;
var(NineMM) const GDNineMMData GDNineMMParams;
var(NineMM) const RecoilGroupData GDNineMMRecoilParams;
var(NineMM) const SpreadGroupData GDNineMMSpreadParams;
var(FireAxe) const GDFireAxeData GDFireAxeParams;
var(DummyWeapon) const SPWeaponGamePadParams GDDummyWeaponParams;
var(Grenade) const GDGrenadeData GDGrenadeParams;
var(Flare) const GDFlareData GDFlareParams;
var(TaserGrenade) const GDTaserGrenadeData GDTaserGrenadeParams;
var(Molotov) const GDMolotovData GDMolotovParams;
var(AmmoBoxes) const GDAmmoBoxData GDAmmoBoxParams;
var(SmallAmmoType) const GDSmallAmmoTypeData GDSmallAmmoTypeParams;
var(LargeAmmoType) const GDLargeAmmoTypeData GDLargeAmmoTypeParams;
var(GrenadesType) const GDGrenadeTypeData GDGrenadeTypeParams;
