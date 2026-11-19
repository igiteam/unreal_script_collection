class TurokHitReaction extends ActorComponent
    native
    hidecategories(Object);

enum ECompassDirection
{
    ECD_N,                          // 0
    ECD_NW,                         // 1
    ECD_W,                          // 2
    ECD_SW,                         // 3
    ECD_S,                          // 4
    ECD_SE,                         // 5
    ECD_E,                          // 6
    ECD_NE,                         // 7
    ECD_MAX                         // 8
};

var() export editinline array mSettings;
var float mShakerStartTime;
var int mShotsTaken;
var int mInitialDamageTaken;
var byte mCurrentDirection;
var @NULL mGroggyShake;
var() export editinline @NULL mFXHitReactions;
var() const float mBigHitDamage;
var() const float mGroggyPercentageEnable;
var() const float mKnockdownDamage;
var() const export editinline @NULL mGroggyShakeSettings;
var() float mGroggyMinPercentage;
var() float mCurrentGroggyPercentage;
var() float mGroggyDecayRate;
var() float mGroggyHealthRecover;
var bool mbEnable;

static function bool IsImportantReaction(int Damage)
{
    // End:0x13
    if(float(Damage) > default.mBigHitDamage)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Init()
{
    // DebugMode: 0
    assert(TurokPlayerController(Owner) != none);
    // DebugMode: 0
    assert(TurokPlayerController(Owner).IsLocalPlayerController());
    // DebugMode: 0
    assert(mGroggyShake == none);
    mGroggyShake = new (Owner) Class'TurokParametricShake';
    CopyGroggySettings();
    mGroggyShake.Init();
    // DebugMode: 0
    assert(mFXHitReactions == none);
    mFXHitReactions = new (Owner) Class'TurokPlayerFXHitReactions';
    mFXHitReactions.Init(PlayerController(Owner), self);
    //return;    
}

event Update(float Delta)
{
    local @NULL PlayerCam;

    PlayerCam = PlayerController(Owner).PlayerCamera;
    // End:0x41
    if(PlayerCam.CameraStyle == 'DebugCam')
    {
        Clear();
        return;
    }
    // End:0x62
    if(mbEnable)
    {
        mFXHitReactions.Update(Delta);
    }
    //return;    
}

event Clear()
{
    // End:0x1E
    if(mGroggyShake != none)
    {
        mGroggyShake.RemoveModifier();
    }
    // End:0x3C
    if(mFXHitReactions != none)
    {
        mFXHitReactions.StopAllScreenFX();
    }
    //return;    
}

function UnInit()
{
    // End:0x25
    if(mGroggyShake != none)
    {
        mGroggyShake.RemoveModifier();
        mGroggyShake = none;
    }
    // End:0x4A
    if(mFXHitReactions != none)
    {
        mFXHitReactions.UnInit();
        mFXHitReactions = none;
    }
    //return;    
}

function UpdateGroggy(float Delta)
{
    local float PreComp;
    local @NULL ControlledPawn;

    PreComp = mCurrentGroggyPercentage;
    mCurrentGroggyPercentage -= (Delta * mGroggyDecayRate);
    mCurrentGroggyPercentage = FClamp(mCurrentGroggyPercentage, 0.0000000, 1.0000000);
    ControlledPawn = TurokPawnPlayer(PlayerController(Owner).Pawn);
    // End:0xBC
    if(((ControlledPawn != none) && ControlledPawn.mbGroggySoundIsPlaying) && (float(ControlledPawn.Health) / float(ControlledPawn.mDefaultHealth)) > ControlledPawn.mPawnDamageBreathingEnable)
    {
        ControlledPawn.StopGroggySound();
    }
    // End:0x12B
    if(((ControlledPawn != none) && PreComp > 0.0000000) && mCurrentGroggyPercentage == 0.0000000)
    {
        DetachGroggyShaker();
        ControlledPawn.EnableRegenHealth(true);
        ControlledPawn.Health = int(float(ControlledPawn.mDefaultHealth) * mGroggyHealthRecover);
    }
    //return;    
}

function NotifyDamageTaken(@NULL InstigatedBy, int Damage, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, @NULL hitFromLocation)
{
    local @NULL PC;

    PC = PlayerController(Owner);
    // End:0x45
    if(PC.IsLocalPlayerController())
    {
        PlayHitReaction(PC, Damage, HitLocation, Momentum, DamageType);
    }
    UpdateGroggyTimer(TurokPawn(PC.Pawn));
    //return;    
}

function float GetGroggyIntensity()
{
    return mCurrentGroggyPercentage;
    //return ReturnValue;    
}

function float GetEffectsIntensity()
{
    local @NULL PlayerCam, Shaker;
    local float Intensity;

    PlayerCam = PlayerController(Owner).PlayerCamera;
    // End:0x47
    if(Class'TurokCameraModifier'.static.IsAttached(PlayerCam, Class'TurokHitReactShake', Shaker) == false)
    {
        return 0.0000000;
    }
    Intensity = Shaker.DistanceAt(Shaker.PercentageComplete()) / FindDirectionComponent(mCurrentDirection).MaxAngle;
    Intensity = FClamp(Intensity, 0.0000000, 1.0000000);
    return Intensity;
    //return ReturnValue;    
}

private final function PlayHitReaction(@NULL PC, int Damage, @NULL HitLocation, @NULL Momentum, class<Class> DamageType)
{
    local byte CompassDirection;
    local @NULL PlayerCam, Shaker, MomentumPlayerSpace, Settings, tPawnPlayer;

    PlayerCam = PC.PlayerCamera;
    // End:0x32
    if(PlayerCam.CameraStyle == 'DebugCam')
    {
        return;
    }
    Momentum *= float(-1);
    MomentumPlayerSpace = QuatRotateVector(QuatFromRotator(PC.Pawn.GetBaseAimRotation() * float(-1)), Momentum);
    SnapToCompassDir(MomentumPlayerSpace, CompassDirection);
    Settings = FindDirectionComponent(CompassDirection);
    // End:0x2D2
    if(((float(Damage) >= Settings.MinDamage) && mbEnable == true) && mCurrentGroggyPercentage <= 0.0000000)
    {
        // End:0x135
        if(Class'TurokCameraModifier'.static.IsAttached(PlayerCam, Class'TurokHitReactShake', Shaker) == false)
        {
            Shaker = CreateNewShake(CompassDirection, MomentumPlayerSpace, Damage);
            Shaker.AddCameraModifier(PlayerCam);            
        }
        else
        {
            UpdateShaker(Shaker, CompassDirection, MomentumPlayerSpace, Damage);
        }
        Shaker.CapToDistance(Settings.MaxAngle);
        // End:0x1D4
        if((TurokPawn(PC.Pawn) != none) && (float(PC.Pawn.Health) / float(TurokPawn(PC.Pawn).mDefaultHealth)) < mGroggyPercentageEnable)
        {
            AttachGroggyShaker();
        }
        tPawnPlayer = TurokPawnPlayer(PlayerController(Owner).Pawn);
        // End:0x25E
        if((tPawnPlayer != none) && (float(PC.Pawn.Health) / float(TurokPawn(PC.Pawn).mDefaultHealth)) <= tPawnPlayer.mPawnDamageBreathingEnable)
        {
            tPawnPlayer.PlayGroggySound();
        }
        // End:0x28A
        if(DamageType == Class'TurokDamageTypeKnife')
        {
            mFXHitReactions.RegisterNewHit(2, Momentum);            
        }
        else
        {
            // End:0x2B8
            if(float(Damage) >= mBigHitDamage)
            {
                mFXHitReactions.RegisterNewHit(0, Momentum);                
            }
            else
            {
                mFXHitReactions.RegisterNewHit(1, Momentum);
            }
        }
    }
    //return;    
}

private final function CopyGroggySettings()
{
    mGroggyShake.mShakeComponent.mParams = mGroggyShakeSettings.mParams;
    //return;    
}

private final function AttachGroggyShaker()
{
    // End:0x5D
    if(mGroggyShake.CameraOwner != PlayerController(Owner).PlayerCamera)
    {
        mGroggyShake.mPlayMode = 1;
        mGroggyShake.AddCameraModifier(PlayerController(Owner).PlayerCamera);
    }
    //return;    
}

private final function DetachGroggyShaker()
{
    // End:0x1C
    if(mGroggyShake != none)
    {
        mGroggyShake.mPlayMode = 0;
    }
    //return;    
}

private final function UpdateShaker(@NULL Shaker, byte Dir, @NULL Momentum, int Damage)
{
    local editinline @NULL Settings;
    local float CurrentTime;
    local @NULL DampenedAmplitudes, Amplitudes;
    local float CurrentDampen, DampenRecovery, AmplitudesSize;

    Settings = FindDirectionComponent(Dir);
    CurrentTime = PlayerController(Owner).Pawn.WorldTime();
    // End:0xAF
    if((int(Dir) != int(mCurrentDirection)) && Damage > mInitialDamageTaken)
    {
        Shaker.RemoveModifier();
        Shaker = CreateNewShake(Dir, Momentum, Damage);
        Shaker.AddCameraModifier(PlayerController(Owner).PlayerCamera);        
    }
    else
    {
        // End:0x1DB
        if(int(Dir) == int(mCurrentDirection))
        {
            Amplitudes = ComputeShakeAmplitudes(Dir, Momentum, Damage);
            AmplitudesSize = VSize(Amplitudes);
            // End:0xFB
            if(AmplitudesSize == 0.0000000)
            {
                return;
            }
            CurrentDampen = 1.0000000 - (Settings.MovementDampen * float(mShotsTaken));
            DampenRecovery = Settings.MovementDampenRecover * (CurrentTime - mShakerStartTime);
            CurrentDampen += DampenRecovery;
            CurrentDampen = (((CurrentDampen * AmplitudesSize) < Settings.MinMoveAmount) ? Settings.MinMoveAmount / AmplitudesSize : CurrentDampen);
            CurrentDampen = ((CurrentDampen > 1.0000000) ? 1.0000000 : CurrentDampen);
            DampenedAmplitudes = Amplitudes * CurrentDampen;
            Shaker.AddShakeDistance(VSize(DampenedAmplitudes));
        }
    }
    mShotsTaken++;
    //return;    
}

private final function @NULL CreateNewShake(byte Dir, @NULL Momentum, int Damage)
{
    local @NULL Shakey, Settings, Amplitudes;

    Settings = FindDirectionComponent(Dir);
    Amplitudes = ComputeShakeAmplitudes(Dir, Momentum, Damage);
    Shakey = new Class'TurokHitReactShake';
    Shakey.mLifeTime = Settings.RecoveryTime;
    Shakey.InitReactShake(Amplitudes.Z, Amplitudes.Y, Amplitudes.X);
    mShakerStartTime = PlayerController(Owner).Pawn.WorldTime();
    mShotsTaken = 1;
    mInitialDamageTaken = Damage;
    mCurrentDirection = Dir;
    return Shakey;
    //return ReturnValue;    
}

private final function @NULL ComputeShakeAmplitudes(byte Dir, @NULL Momentum, int Damage)
{
    local float TotalEnergy, RollAmp, PitchAmp, YawAmp;
    local editinline @NULL Settings, Ret;
    local float Cap;

    Settings = FindDirectionComponent(Dir);
    RollAmp = 0.0000000;
    PitchAmp = 0.0000000;
    YawAmp = 0.0000000;
    Damage = ((float(Damage) > Settings.MaxDamage) ? int(Settings.MaxDamage) : Damage);
    TotalEnergy = Settings.MaxAngle * (float(Damage) / Settings.MaxDamage);
    RollAmp = (TotalEnergy * Settings.MovementAnglesPercentages.X) + (TotalEnergy * RandRange(-Settings.MovementAnglesVariance.X, Settings.MovementAnglesVariance.X));
    YawAmp = (TotalEnergy * Settings.MovementAnglesPercentages.Y) + (TotalEnergy * RandRange(-Settings.MovementAnglesVariance.Y, Settings.MovementAnglesVariance.Y));
    PitchAmp = (TotalEnergy * Settings.MovementAnglesPercentages.Z) + (TotalEnergy * RandRange(-Settings.MovementAnglesVariance.Z, Settings.MovementAnglesVariance.Z));
    Cap = TotalEnergy / ((Abs(RollAmp) + Abs(YawAmp)) + Abs(PitchAmp));
    Ret.X = YawAmp * Cap;
    Ret.Y = PitchAmp * Cap;
    Ret.Z = RollAmp * Cap;
    return Ret;
    //return ReturnValue;    
}

private final function @NULL FindDirectionComponent(byte Dir)
{
    local int I;
    local editinline @NULL Ret;

    Ret = mSettings[0];
    I = 0;
    J0x14:

    // End:0x61 [Loop If]
    if(I < mSettings.Length)
    {
        // End:0x57
        if(int(mSettings[I].Direction) == int(Dir))
        {
            Ret = mSettings[I];
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    return Ret;
    //return ReturnValue;    
}

private final function @NULL SnapToCompassDir(@NULL Dir, out byte CompassDir)
{
    local @NULL Ret;
    local float VectorComponents[8];
    local byte CompassEnums[8];
    local @NULL TempVec;
    local float HighestDot;
    local int I;

    VectorComponents[0] = 1.0000000;
    VectorComponents[1] = 0.7070000;
    VectorComponents[2] = 0.0000000;
    VectorComponents[3] = -0.7070000;
    VectorComponents[4] = -1.0000000;
    VectorComponents[5] = -0.7070000;
    VectorComponents[6] = 0.0000000;
    VectorComponents[7] = 0.7070000;
    CompassEnums[0] = 0;
    CompassEnums[1] = 1;
    CompassEnums[2] = 2;
    CompassEnums[3] = 3;
    CompassEnums[4] = 4;
    CompassEnums[5] = 5;
    CompassEnums[6] = 6;
    CompassEnums[7] = 7;
    Ret = vect(1.0000000, 0.0000000, 0.0000000);
    HighestDot = 0.0000000;
    I = 0;
    J0xE9:

    // End:0x1A6 [Loop If]
    if(I < 8)
    {
        TempVec.X = VectorComponents[int(float(I) % float(8))];
        TempVec.Y = VectorComponents[int(float(I + 2) % float(8))];
        TempVec.Z = 0.0000000;
        // End:0x19C
        if((Dir Dot TempVec) > HighestDot)
        {
            Ret = TempVec;
            CompassDir = CompassEnums[I];
            HighestDot = Dir Dot TempVec;
        }
        I++;
        // [Loop Continue]
        goto J0xE9;
    }
    return Ret;
    //return ReturnValue;    
}

private final function UpdateGroggyTimer(@NULL Pawn)
{
    local float GroggyPer;

    // End:0x2E
    if((float(Pawn.Health) / float(Pawn.mDefaultHealth)) >= mGroggyPercentageEnable)
    {
        return;
    }
    GroggyPer = 1.0000000 - (float(Pawn.Health) / (mGroggyPercentageEnable * float(Pawn.mDefaultHealth)));
    // End:0x92
    if((GroggyPer > mGroggyMinPercentage) && GroggyPer > mCurrentGroggyPercentage)
    {
        mCurrentGroggyPercentage = GroggyPer;        
    }
    else
    {
        mCurrentGroggyPercentage = FMax(mGroggyMinPercentage, mCurrentGroggyPercentage);
    }
    // End:0xCD
    if(TurokPawnPlayer(Pawn) != none)
    {
        TurokPawnPlayer(Pawn).EnableRegenHealth(false);
    }
    //return;    
}

defaultproperties
{
    mSettings=/* Array type was not detected. */
    mBigHitDamage=30.0000000
    mGroggyPercentageEnable=0.5000000
    // Reference: TurokParametricShakeComponent'Default__TurokHitReaction.ShakeComponent'
    begin object name=ShakeComponent class=Class'TurokParametricShakeComponent'
        mParams=(mRollAmplitude=1.0000000,mRollFrequency=2.0000000,mPitchAmplitude=0.7500000,mPitchFrequency=1.0000000,mYawAmplitude=0.0000000,mYawFrequency=0.0000000,mXAmplitude=0.0000000,mXFrequency=0.0000000,mYAmplitude=0.0000000,mYFrequency=0.0000000,mZAmplitude=0.0000000,mZFrequency=0.0000000)
    end object
    mGroggyShakeSettings=ShakeComponent
    mGroggyMinPercentage=0.3000000
    mGroggyDecayRate=0.1100000
    mGroggyHealthRecover=0.8000000
    mbEnable=true
}