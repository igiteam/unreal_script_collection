class WeaponAccuracyComponent extends ActorComponent
    native;

enum EPenaltyCurveType
{
    CURVE_LINEAR,                   // 0
    CURVE_SLOW,                     // 1
    CURVE_FAST,                     // 2
    CURVE_CONSTANT,                 // 3
    CURVE_MAX                       // 4
};

var private native const Pointer pimpl_;
var EALAWeapon mWeapon;
var(EALATuning) AccuracyTuning AccuracyParams;
var(EALATuning) WeaponAccuracyComponent.EPenaltyCurveType PronePenaltyCurve;
var(EALATuning) WeaponAccuracyComponent.EPenaltyCurveType CrouchPenaltyCurve;
var(EALATuning) WeaponAccuracyComponent.EPenaltyCurveType RunPenaltyCurve;
var(EALATuning) WeaponAccuracyComponent.EPenaltyCurveType TurnPenaltyCurve;
var(EALATuning) WeaponAccuracyComponent.EPenaltyCurveType BasePenaltyCurve;
var(EALATuning) float PronePenaltyMin;
var(EALATuning) float PronePenaltyMax;
var(EALATuning) Vector DebugPos;
var(EALATuning) bool bUpdateDebug;

simulated function Tick(float DeltaTime)
{
    TickInternal(DeltaTime);
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos, out int foundBase)
{
    local float radialSpread, spreadDistance;
    local Vector at, Up, Right, pos;
    local Rotator Rot;
    local float Distance;
    local Color C;

    AccuracyGetSpreadMultiplier(radialSpread, spreadDistance);
    mWeapon.Instigator.Controller.GetPlayerViewPoint(pos, Rot);
    GetAxes(Rot, at, Up, Right);
    Distance = 32000.0000000;
    Up *= (radialSpread * Distance);
    Right *= (radialSpread * Distance);
    pos += ((at * Distance) * spreadDistance);
    C = MakeColor(50, 155, 100);
    DrawLine3d2d(pos + Right, (pos + (0.7070000 * Right)) + (0.7070000 * Up), C, HUD);
    DrawLine3d2d(pos + Up, (pos + (0.7070000 * Right)) + (0.7070000 * Up), C, HUD);
    DrawLine3d2d(pos - Right, (pos - (0.7070000 * Right)) + (0.7070000 * Up), C, HUD);
    DrawLine3d2d(pos + Up, (pos - (0.7070000 * Right)) + (0.7070000 * Up), C, HUD);
    DrawLine3d2d(pos + Right, (pos + (0.7070000 * Right)) - (0.7070000 * Up), C, HUD);
    DrawLine3d2d(pos - Up, (pos + (0.7070000 * Right)) - (0.7070000 * Up), C, HUD);
    DrawLine3d2d(pos - Right, (pos - (0.7070000 * Right)) - (0.7070000 * Up), C, HUD);
    DrawLine3d2d(pos - Up, (pos - (0.7070000 * Right)) - (0.7070000 * Up), C, HUD);
    // End:0x2EB
    if(bUpdateDebug)
    {
        DebugPos = HUD.Canvas.Project(DebugPos);
    }
    bUpdateDebug = false;
    HUD.Draw2DLine(int(DebugPos.X - float(3)), int(DebugPos.Y), int(DebugPos.X + float(3)), int(DebugPos.Y), MakeColor(0, byte(255), byte(255), byte(255)));
    HUD.Draw2DLine(int(DebugPos.X), int(DebugPos.Y - float(3)), int(DebugPos.X), int(DebugPos.Y + float(3)), MakeColor(0, byte(255), byte(255), byte(255)));
    //return;    
}

simulated function DrawLine3d2d(Vector v1, Vector v2, Color C, HUD HUD)
{
    v1 = HUD.Canvas.Project(v1);
    v2 = HUD.Canvas.Project(v2);
    HUD.Draw2DLine(int(v1.X), int(v1.Y), int(v2.X), int(v2.Y), C);
    //return;    
}

// Export UWeaponAccuracyComponent::execNormalDistribution(FFrame&, void* const)
native simulated function float NormalDistribution(float Num);

// Export UWeaponAccuracyComponent::execTickInternal(FFrame&, void* const)
native simulated function TickInternal(float DeltaTime);

// Export UWeaponAccuracyComponent::execOnJumpPressed(FFrame&, void* const)
native simulated function OnJumpPressed();

// Export UWeaponAccuracyComponent::execOnSetRelativeVelocity(FFrame&, void* const)
native simulated function OnSetRelativeVelocity(float Velocity);

// Export UWeaponAccuracyComponent::execOnSetYawVelocity(FFrame&, void* const)
native simulated function OnSetYawVelocity(float Velocity);

// Export UWeaponAccuracyComponent::execOnSetPitchVelocity(FFrame&, void* const)
native simulated function OnSetPitchVelocity(float Velocity);

// Export UWeaponAccuracyComponent::execAccuracyGetSpreadMultiplier(FFrame&, void* const)
native simulated function AccuracyGetSpreadMultiplier(out float multiplier, out float Distance);

// Export UWeaponAccuracyComponent::execUpdateAccuracy(FFrame&, void* const)
native simulated function UpdateAccuracy();

// Export UWeaponAccuracyComponent::execAddSpread(FFrame&, void* const)
native simulated function Rotator AddSpread(Rotator BaseAim);

simulated event MOHAPlayerPawn.EPlayerStance GetStance()
{
    // End:0x29
    if((mWeapon == none) || MOHAPlayerPawn(mWeapon.Instigator) == none)
    {
        return 0;
    }
    return MOHAPlayerPawn(mWeapon.Instigator).eCurrentStance;
    //return ReturnValue;    
}

simulated event bool IsFiring()
{
    // End:0x0D
    if(mWeapon == none)
    {
        return false;
    }
    return mWeapon.IsFiring();
    //return ReturnValue;    
}

simulated event bool IsFalling()
{
    // End:0x28
    if((mWeapon == none) || MOHAPlayerPawn(mWeapon.Instigator) == none)
    {
        return false;
    }
    return int(MOHAPlayerPawn(mWeapon.Instigator).Physics) == int(2);
    //return ReturnValue;    
}

defaultproperties
{
    AccuracyParams=(CrouchPenaltyMin=1.0000000,CrouchPenaltyMax=1.0000000,RunPenalty=1.0000000,JumpPenalty=1.0000000,TurnPenaltyMax=1.0000000,BasePenaltyMin=1.0000000,BasePenaltyMax=1.0000000,BasePenaltyRange=1.0000000,AccuracyDistance=160.0000000,AccuracyRecoveryScalar=1.0000000)
    PronePenaltyCurve=1
    TurnPenaltyCurve=1
    BasePenaltyCurve=2
    PronePenaltyMax=2.0000000
}