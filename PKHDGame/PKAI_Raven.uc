class PKAI_Raven extends PKAIController
    config(AI)
    hidecategories(Navigation);

var float LastFlyDir;
var float RotSum;
var bool bShouldChangeDir;
var bool bUseBumpHitNormal;
var Vector BumpHitNormal;
var float LastLandingTime;
var config float FlyHeightDown;
var config float FlyHeightUp;
var PKPawn_Raven_Base MyPKPawn_Raven_Base;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    MyPKPawn_Raven_Base = PKPawn_Raven_Base(MyPKPawn);
    //return;    
}

function float GetAltitude()
{
    return MyPKPawn.Location.Z - PossessLocation.Z;
    //return ReturnValue;    
}

function NotifyBumpLevel(Vector HitLocation, Vector HitNormal)
{
    super.NotifyBumpLevel(HitLocation, HitNormal);
    // End:0xC9
    if(((FRand() < 0.8000000) && LastLandingTime < (WorldInfo.TimeSeconds + 1.0000000)) && (HitNormal Dot vect(0.0000000, 0.0000000, 1.0000000)) < 0.9800000)
    {
        StopLatentExecution();
        MyPKPawn.ZeroMovementVariables();
        MyPKPawn.SetMovementPhysics();
    }
    // End:0xF1
    if(Abs(LastFlyDir) < (1.0000000 * 0.0174533))
    {
        bShouldChangeDir = true;
    }
    bUseBumpHitNormal = true;
    BumpHitNormal = HitNormal;
    //return;    
}

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    // End:0xC7
    if((((FRand() < 0.8000000) && LastLandingTime < (WorldInfo.TimeSeconds + 1.0000000)) && Pawn(Other) == none) && (HitNormal Dot vect(0.0000000, 0.0000000, 1.0000000)) < 0.9800000)
    {
        StopLatentExecution();
        MyPKPawn.ZeroMovementVariables();
        MyPKPawn.SetMovementPhysics();
    }
    // End:0xEF
    if(Abs(LastFlyDir) < (1.0000000 * 0.0174533))
    {
        bShouldChangeDir = true;
    }
    bUseBumpHitNormal = true;
    BumpHitNormal = HitNormal;
    return super.NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

function Vector GetFlyPointByAngle(float YawAngle, float StrafeDistance, optional float StrafeAngleOffset, optional Actor InFocus, optional Rotator StrafeBaseRotation, optional bool bOverrideBaseRotation)
{
    local Vector Z, StrafeDir, StrafePoint;
    local Rotator StrafeRotation;

    // End:0x4D
    if(InFocus == none)
    {
        // End:0x4A
        if(!bOverrideBaseRotation)
        {
            StrafeBaseRotation = MyEvilPawn.Rotation;
        }        
    }
    else
    {
        StrafeBaseRotation = Rotator(Normal(InFocus.Location - MyEvilPawn.Location));
    }
    Z = GetRotatorAxis(StrafeBaseRotation, 2);
    StrafeRotation = QuatToRotator(QuatFromAxisAndAngle(Z, YawAngle)) + StrafeBaseRotation;
    StrafeDir = Normal(Vector(StrafeRotation));
    StrafePoint = MyEvilPawn.Location + (StrafeDir * StrafeDistance);
    return StrafePoint;
    //return ReturnValue;    
}

function ChangeDir()
{
    // End:0x78
    if((Abs(LastFlyDir) < (1.0000000 * 0.0174533)) && Abs(float(NormalizeRotAxis(MyPKPawn.Rotation.Pitch))) < float(4096))
    {
        bShouldChangeDir = true;        
    }
    else
    {
        SetTimer(0.5000000, false, GetFuncName(), self);
    }
    //return;    
}

function Vector GetRandomLocation(float Radius, optional bool bOverrideStartLocation, optional Vector StartLocation)
{
    local Vector DestLocation, DestLocationAlt;
    local float Dir;
    local Rotator BaseRotation;

    // End:0x5D8
    if(int(MyPKPawn.Physics) == int(4))
    {
        // End:0x62
        if(!bOverrideStartLocation)
        {
            StartLocation = MyPKPawn.Location;
        }
        BaseRotation = Normalize(MyPKPawn.Rotation);
        // End:0x208
        if(Abs(LastFlyDir) < (1.0000000 * 0.0174533))
        {
            // End:0x205
            if(bShouldChangeDir || (FRand() < 0.1000000) && Abs(float(NormalizeRotAxis(MyPKPawn.Rotation.Pitch))) < float(8192))
            {
                // End:0x196
                if(FRand() < 0.5000000)
                {
                    // End:0x158
                    if((FRand() < 0.2000000) || bUseBumpHitNormal)
                    {
                        Dir = 180.0000000 * 0.0174533;                        
                    }
                    else
                    {
                        // End:0x17D
                        if(FRand() < 0.5000000)
                        {
                            Dir = 90.0000000 * 0.0174533;                            
                        }
                        else
                        {
                            Dir = 45.0000000 * 0.0174533;
                        }
                    }                    
                }
                else
                {
                    // End:0x1CA
                    if((FRand() < 0.2000000) || bUseBumpHitNormal)
                    {
                        Dir = -180.0000000 * 0.0174533;                        
                    }
                    else
                    {
                        // End:0x1EF
                        if(FRand() < 0.5000000)
                        {
                            Dir = -90.0000000 * 0.0174533;                            
                        }
                        else
                        {
                            Dir = -45.0000000 * 0.0174533;
                        }
                    }
                }
            }            
        }
        // End:0x2FD
        if((GetAltitude()) < RandRange(FlyHeightDown, FlyHeightUp))
        {
            // End:0x2FA
            if((NormalizeRotAxis(MyPKPawn.Rotation.Pitch) < -2048) || ((GetAltitude()) < (FlyHeightDown * 1.2000000)) && NormalizeRotAxis(MyPKPawn.Rotation.Pitch) < 0)
            {
                BaseRotation.Pitch = 0;
            }            
        }
        else
        {
            // End:0x3DF
            if((GetAltitude()) > FlyHeightUp)
            {
                // End:0x3DC
                if((NormalizeRotAxis(MyPKPawn.Rotation.Pitch) > 2048) || ((GetAltitude()) > (FlyHeightUp * 1.2000000)) && NormalizeRotAxis(MyPKPawn.Rotation.Pitch) > 0)
                {
                    BaseRotation.Pitch = 0;
                }                
            }
        }
        DestLocation = GetFlyPointByAngle(Dir, Radius,,, BaseRotation, true);
        DestLocationAlt = GetFlyPointByAngle(-Dir, Radius,,, BaseRotation, true);
        // End:0x580
        if((Normal(DestLocation - MyPKPawn.Location) Dot Normal(PossessLocation - MyPKPawn.Location)) < (Normal(DestLocationAlt - MyPKPawn.Location) Dot Normal(PossessLocation - MyPKPawn.Location)))
        {
            Dir = -Dir;
            // End:0x56A
            if(!PointReachable(DestLocationAlt))
            {
                Dir = -Dir;
                DestLocation = GetFlyPointByAngle(Dir, Radius,,, BaseRotation, true);                
            }
            else
            {
                DestLocation = DestLocationAlt;
            }            
        }
        else
        {
            // End:0x5D8
            if(!PointReachable(DestLocation))
            {
                Dir = -Dir;
                DestLocation = GetFlyPointByAngle(Dir, Radius,,, BaseRotation, true);
            }
        }
    }
    LastFlyDir = Dir;
    RotSum += LastFlyDir;
    // End:0x67B
    if(Abs(RotSum) >= (1.0000000 * 0.0174533))
    {
        LastFlyDir = 0.0000000;
        RotSum = 0.0000000;
        bShouldChangeDir = false;
        ClearTimer('ChangeDir', self);
        SetTimer(RandRange(1.0000000, 1.5000000), false, 'ChangeDir', self);
    }
    bUseBumpHitNormal = false;
    return DestLocation;
    //return ReturnValue;    
}

function bool ProcessStimulus(Pawn P, EvilAIController.EPerceptionType Pt, optional name EventName)
{
    //return ReturnValue;    
}

defaultproperties
{
    FlyHeightDown=200.0000000
    FlyHeightUp=300.0000000
    GuardRange=1000.0000000
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Raven'
    MeleeCommand=none
    MoveCommand=Class'EvilGame.EvilAICmd_FlyToGoal'
    // Reference: EvilAIReactManager'Default__PKAI_Raven.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}