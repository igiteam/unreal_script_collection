class SeqAct_RotateActor extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var Actor ActorToRotate;
var() Rotator ResetRotation;
var() Rotator SolvedRotation;
var() float AngleEasy;
var() float AngleMedium;
var() float AngleHard;
var() bool bRotateInstant;
var() bool bShortestPath;
var bool bResetFired;
var() Vector X;
var() Vector Y;
var() Vector Z;
var transient float Angle;
var() float UpperLimitForDotProduct;
var() float LowerLimitForDotProduct;
var() float SlerpingTimeModifier;
var transient float SlerpingTime;
var transient Quat StartQuat;
var transient Quat InterpolatedQuat;
var transient Quat FinishQuat;
var transient Rotator StartR;
var transient Rotator FinishR;
var transient Rotator InterpolatedR;
var transient Rotator ToMultR;

event Activated()
{
    local Quat QuatToMultiply;

    PublishLinkedVariableValues();
    // End:0x28B
    if(ActorToRotate != none)
    {
        Angle = DetermineTheAngle(GetPuzzleDifficultyLevel());
        bResetFired = false;
        // End:0x8E
        if(InputLinks[0].bHasImpulse)
        {
            QuatToMultiply = QuatFromAxisAndAngle(X, Angle);            
        }
        else
        {
            // End:0xDB
            if(InputLinks[1].bHasImpulse)
            {
                QuatToMultiply = QuatFromAxisAndAngle(X, -Angle);                
            }
            else
            {
                // End:0x127
                if(InputLinks[2].bHasImpulse)
                {
                    QuatToMultiply = QuatFromAxisAndAngle(Z, Angle);                    
                }
                else
                {
                    // End:0x175
                    if(InputLinks[3].bHasImpulse)
                    {
                        QuatToMultiply = QuatFromAxisAndAngle(Z, -Angle);                        
                    }
                    else
                    {
                        // End:0x1A6
                        if(InputLinks[4].bHasImpulse)
                        {
                            bResetFired = true;
                            return;
                        }
                    }
                }
            }
        }
        StartQuat = QuatFromRotator(ActorToRotate.Rotation);
        FinishQuat = QuatProduct(QuatToMultiply, StartQuat);
        ToMultR = QuatToRotator(QuatToMultiply);
        FinishR = SnapRotation(QuatToRotator(FinishQuat));
        FinishQuat = QuatFromRotator(FinishR);
        StartR = QuatToRotator(StartQuat);
        SlerpingTime = 0.0000000;
    }
    //return;    
}

event bool Update(float DeltaTime)
{
    local float dotProduct;

    // End:0x1F
    if(ActorToRotate == none)
    {
        ActivateOutputLink(1);
        return false;        
    }
    else
    {
        // End:0x4F
        if(bResetFired)
        {
            ActorToRotate.SetRotation(ResetRotation);
            return false;
        }
    }
    super.Update(DeltaTime);
    SlerpingTime += ((DeltaTime * SlerpingTimeModifier) * (AngleEasy / (Angle * 57.2957800)));
    InterpolatedQuat = QuatSlerp(StartQuat, FinishQuat, SlerpingTime, bShortestPath);
    dotProduct = QuatDot(InterpolatedQuat, FinishQuat);
    dotProduct = Abs(dotProduct);
    // End:0x21C
    if(((dotProduct <= UpperLimitForDotProduct) && dotProduct >= LowerLimitForDotProduct) || bRotateInstant)
    {
        bAborted = false;
        ActorToRotate.SetRotation(FinishR);
        // End:0x203
        if((QuatDot(QuatFromRotator(FinishR), QuatFromRotator(SolvedRotation)) <= 1.0700000) && QuatDot(QuatFromRotator(FinishR), QuatFromRotator(SolvedRotation)) >= 0.9300000)
        {
            ActivateOutputLink(2);            
        }
        else
        {
            ActivateOutputLink(0);
            ActivateOutputLink(3);
        }
        return false;
    }
    ActorToRotate.SetRotation(QuatToRotator(InterpolatedQuat));
    return true;
    //return ReturnValue;    
}

function EvilTypesNative.EDifficultyLevel GetPuzzleDifficultyLevel()
{
    local SeqVar_Object ObjVar;
    local AdvPlayerPawn P;
    local AdvPlayerController PC;

    // End:0xCF
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        P = AdvPlayerPawn(ObjVar.GetObjectValue());
        // End:0x6D
        if(P == none)
        {
            continue;            
        }
        PC = AdvPlayerController(P.Controller);
        // End:0xCE
        if(PC != none)
        {            
            return PC.GetPuzzleDifficultyLevel();
        }        
    }    
    //return ReturnValue;    
}

function float DetermineTheAngle(EvilTypesNative.EDifficultyLevel PDL)
{
    local float Ang;

    switch(PDL)
    {
        // End:0x2E
        case 0:
            Ang = AngleEasy;
            // End:0x7D
            break;
        // End:0x49
        case 1:
            Ang = AngleMedium;
            // End:0x7D
            break;
        // End:0x64
        case 2:
            Ang = AngleHard;
            // End:0x7D
            break;
        // End:0xFFFF
        default:
            Ang = AngleEasy;
            // End:0x7D
            break;
            break;
    }
    return Ang *= 0.0174533;
    //return ReturnValue;    
}

function Rotator SnapRotation(Rotator RotationToSnap)
{
    local int UnrRotSnappedAngle;

    UnrRotSnappedAngle = SnapAngle(RotationToSnap.Yaw);
    RotationToSnap.Yaw = UnrRotSnappedAngle;
    UnrRotSnappedAngle = SnapAngle(RotationToSnap.Pitch);
    RotationToSnap.Pitch = UnrRotSnappedAngle;
    UnrRotSnappedAngle = SnapAngle(RotationToSnap.Roll);
    RotationToSnap.Roll = UnrRotSnappedAngle;
    return RotationToSnap;
    //return ReturnValue;    
}

function int SnapAngle(int AngleToSnap)
{
    // End:0x54
    if((float(AngleToSnap) <= (float(20) * 182.0444000)) && float(AngleToSnap) >= (float(340) * 182.0444000))
    {
        AngleToSnap = int(float(0) * 182.0444000);        
    }
    else
    {
        // End:0xA6
        if((float(AngleToSnap) <= (float(110) * 182.0444000)) && float(AngleToSnap) >= (float(70) * 182.0444000))
        {
            AngleToSnap = int(float(90) * 182.0444000);            
        }
        else
        {
            // End:0xF8
            if((float(AngleToSnap) <= (float(200) * 182.0444000)) && float(AngleToSnap) >= (float(160) * 182.0444000))
            {
                AngleToSnap = int(float(180) * 182.0444000);                
            }
            else
            {
                // End:0x150
                if((float(AngleToSnap) <= (float(290) * 182.0444000)) && float(AngleToSnap) >= (float(250) * 182.0444000))
                {
                    AngleToSnap = int(float(270) * 182.0444000);                    
                }
                else
                {
                    // End:0x1A2
                    if((float(AngleToSnap) < (float(70) * 182.0444000)) && float(AngleToSnap) > (float(20) * 182.0444000))
                    {
                        AngleToSnap = int(float(45) * 182.0444000);                        
                    }
                    else
                    {
                        // End:0x1F4
                        if((float(AngleToSnap) < (float(160) * 182.0444000)) && float(AngleToSnap) > (float(110) * 182.0444000))
                        {
                            AngleToSnap = int(float(135) * 182.0444000);                            
                        }
                        else
                        {
                            // End:0x246
                            if((float(AngleToSnap) < (float(250) * 182.0444000)) && float(AngleToSnap) > (float(200) * 182.0444000))
                            {
                                AngleToSnap = int(float(225) * 182.0444000);                                
                            }
                            else
                            {
                                // End:0x29E
                                if((float(AngleToSnap) < (float(340) * 182.0444000)) && float(AngleToSnap) > (float(290) * 182.0444000))
                                {
                                    AngleToSnap = int(float(315) * 182.0444000);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return AngleToSnap;
    //return ReturnValue;    
}

defaultproperties
{
    AngleEasy=90.0000000
    AngleMedium=90.0000000
    AngleHard=45.0000000
    bShortestPath=true
    X=(X=1.0000000,Y=0.0000000,Z=0.0000000)
    Y=(X=0.0000000,Y=1.0000000,Z=0.0000000)
    Z=(X=0.0000000,Y=0.0000000,Z=1.0000000)
    UpperLimitForDotProduct=1.0008000
    LowerLimitForDotProduct=0.9991000
    SlerpingTimeModifier=1.0000000
    bCallHandler=false
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Top->Down",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Down->Top",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Left->Right",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[3]=(LinkDesc="Right->Left",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[4]=(LinkDesc="Reset rotation",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Solved",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[3]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Actor",LinkVar="None",PropertyName="ActorToRotate",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Rotate Actor"
}