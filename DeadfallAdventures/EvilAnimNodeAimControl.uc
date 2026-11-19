class EvilAnimNodeAimControl extends UDKAnimBlendBase
    hidecategories(Object,Object,Object,Object);

var EvilPawn MyEvilPawn;
var int YawDelta;
var int PitchDelta;
var() Vector2D AimOffset;
var() float AimSpeedModifier;
var() float AimIdleSpeedModifier;
var() Vector2D MaxAimRotation;
var() float UpdateAimDelta;
var() float ActualAimDelta;

event OnInit()
{
    super(AnimNode).OnInit();
    MyEvilPawn = EvilPawn(SkelComponent.Owner);
    // End:0x61
    if(AimIdleSpeedModifier <= 0.0000000)
    {
        AimIdleSpeedModifier = AimSpeedModifier;
    }
    //return;    
}

simulated event TickAnim(float DeltaSeconds)
{
    local AnimNodeAimOffset AimNode;

    // End:0x3C
    if((MyEvilPawn == none) || int(MyEvilPawn.RequestedAimZone) == int(0))
    {
        return;
    }
    CheckAimNode(MyEvilPawn, AimNode);
    // End:0x5EC
    if(AimNode != none)
    {
        // End:0x325
        if(((MyEvilPawn.IsAiming() || MyEvilPawn.IsFiring()) || int(MyEvilPawn.PawnAction) == 11) || MyEvilPawn.IsRidingRailCar())
        {
            CheckAimDelta(MyEvilPawn, MyEvilPawn.AimRotation, YawDelta, PitchDelta, AimNode);
            MyEvilPawn.AimOffsetPct.X = FInterpEaseIn(AimNode.Aim.X, FClamp(AimNode.Aim.X + (float(YawDelta) / MaxAimRotation.X), -1.0000000, 1.0000000), DeltaSeconds, 1.0000000 / AimSpeedModifier);
            MyEvilPawn.AimOffsetPct.Y = FInterpEaseIn(AimNode.Aim.Y, FClamp(AimNode.Aim.Y + (float(PitchDelta) / MaxAimRotation.Y), -1.0000000, 1.0000000), DeltaSeconds, 1.0000000 / AimSpeedModifier);            
        }
        else
        {
            YawDelta = Class'EvilAnim_TurnInPlace'.static.CheckYawDelta(MyEvilPawn, MyEvilPawn.AimRotation.Yaw, AimNode);
            PitchDelta = Class'EvilAnim_TurnInPlace'.static.CheckPitchDelta(MyEvilPawn, MyEvilPawn.AimRotation.Pitch, AimNode);
            MyEvilPawn.AimOffsetPct.X = FInterpEaseIn(AimNode.Aim.X, AimOffset.X + FClamp(float(YawDelta) / MaxAimRotation.X, -1.0000000, 1.0000000), DeltaSeconds, 1.0000000 / AimIdleSpeedModifier);
            MyEvilPawn.AimOffsetPct.Y = FInterpEaseIn(AimNode.Aim.Y, AimOffset.Y + FClamp(float(PitchDelta) / MaxAimRotation.Y, -1.0000000, 1.0000000), DeltaSeconds, 1.0000000 / AimIdleSpeedModifier);
        }
        AimNode.Aim = MyEvilPawn.AimOffsetPct;
    }
    UpdateAim(DeltaSeconds, MyEvilPawn.RequestedAimZone);
    //return;    
}

static function int CheckAimDelta(EvilPawn P, Rotator DesRot, optional out int OutYawDelta, optional out int outPitchDelta, optional out AnimNodeAimOffset AimNode)
{
    local Rotator AdjustedAim;

    CheckAimNode(P, AimNode);
    AdjustedAim = Normalize(P.GetAdjustedAimFor(P.Weapon, vect(0.0000000, 0.0000000, 0.0000000)));
    OutYawDelta = NormalizeRotAxis(DesRot.Yaw - AdjustedAim.Yaw);
    outPitchDelta = NormalizeRotAxis(DesRot.Pitch - AdjustedAim.Pitch);
    return OutYawDelta;
    //return ReturnValue;    
}

static function bool CheckAimNode(EvilPawn P, out AnimNodeAimOffset AimNode)
{
    local AnimNodeAimOffset TempAimNode;

    // End:0x85
    if((P.RelevantAimNode != none) && P.RelevantAimNode.bRelevant)
    {
        AimNode = P.RelevantAimNode;
    }
    // End:0x13F
    if(AimNode == none)
    {
        // End:0xF6
        foreach P.EvilAimNodes(TempAimNode)
        {
            // End:0xF5
            if(TempAimNode.bRelevant)
            {
                AimNode = TempAimNode;
            }            
        }        
        // End:0x13F
        if(AimNode == none)
        {
            AimNode = P.AimNode;
            // End:0x13F
            if(AimNode == none)
            {
                return false;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function UpdateAim(float DeltaTime, optional EvilTypes.EAimZone InAimZone = 0)
{
    ActualAimDelta += DeltaTime;
    // End:0xAC
    if((MyEvilPawn.MyEvilAI != none) && ActualAimDelta >= UpdateAimDelta)
    {
        MyEvilPawn.MyEvilAI.UpdateAim(DeltaTime, InAimZone);
        ActualAimDelta = 0.0000000;
    }
    //return;    
}

defaultproperties
{
    AimSpeedModifier=4.0000000
    MaxAimRotation=(X=16384.0000000,Y=16384.0000000)
    UpdateAimDelta=0.5000000
    bTickAnimInScript=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
    bCallScriptEventOnInit=true
    bCallScriptEventOnBecomeRelevant=true
    bCallScriptEventOnCeaseRelevant=true
    NodeName="EvilAnimNodeAimControl"
}