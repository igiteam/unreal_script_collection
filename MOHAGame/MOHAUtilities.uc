class MOHAUtilities extends Actor
    native
    notplaceable
    hidecategories(Navigation);

// Export UMOHAUtilities::execLagValue(FFrame&, void* const)
native static function float LagValue(float fCurrentValue, float fTargetValue, float fRestoreForce, float fDeltaTime);

// Export UMOHAUtilities::execLagVec(FFrame&, void* const)
native static function Vector LagVec(Vector vCurrentValue, Vector vTargetValue, float fRestoreForce, float fDeltaTime);

// Export UMOHAUtilities::execLagValue_Constant(FFrame&, void* const)
native static function float LagValue_Constant(float fCurrentValue, float fTargetValue, float fRestoreRate, float fDeltaTime);

// Export UMOHAUtilities::execRotateVector(FFrame&, void* const)
native static function Vector RotateVector(Vector vVec, Rotator rRot);

// Export UMOHAUtilities::execInverseRotateVector(FFrame&, void* const)
native static function Vector InverseRotateVector(Vector vVec, Rotator rRot);

// Export UMOHAUtilities::execIsEditorActive(FFrame&, void* const)
native static function bool IsEditorActive();

// Export UMOHAUtilities::execGetAiLodAwake(FFrame&, void* const)
native static function bool GetAiLodAwake(Actor A);

// Export UMOHAUtilities::execGetAiLodAnimated(FFrame&, void* const)
native static function bool GetAiLodAnimated(Actor A);

// Export UMOHAUtilities::execGetAiLodIsClose(FFrame&, void* const)
native static function bool GetAiLodIsClose(Actor A);

// Export UMOHAUtilities::execGetAiLodIsMid(FFrame&, void* const)
native static function bool GetAiLodIsMid(Actor A);

// Export UMOHAUtilities::execGetAiLodIsLong(FFrame&, void* const)
native static function bool GetAiLodIsLong(Actor A);

// Export UMOHAUtilities::execGetAiLodDistance(FFrame&, void* const)
native static function float GetAiLodDistance(Actor A);

// Export UMOHAUtilities::execSendPathFinderEvent(FFrame&, void* const)
native static function SendPathFinderEvent(int iEventID);

// Export UMOHAUtilities::execIsParentedByBone(FFrame&, void* const)
native static function bool IsParentedByBone(SkeletalMeshComponent Mesh, name BoneName, name TargetBoneName);

// Export UMOHAUtilities::execWrapAngles(FFrame&, void* const)
native static function WrapAngles(out int iOldValue, int iNewValue);

// Export UMOHAUtilities::execLagRot(FFrame&, void* const)
native static function int LagRot(int NewValue, int OldValue, float RestoreForce, float DeltaTime);

// Export UMOHAUtilities::execLerpAngle(FFrame&, void* const)
native static function float LerpAngle(float fNewValue, float fOldValue, float fPercent);

// Export UMOHAUtilities::execLerpRot(FFrame&, void* const)
native static function Rotator LerpRot(Rotator rNewRot, Rotator rOldRot, float fPercent);

// Export UMOHAUtilities::execLagRot_Const(FFrame&, void* const)
native static function int LagRot_Const(int NewValue, int OldValue, float RestoreRate, float DeltaTime);

// Export UMOHAUtilities::execGetWorldInfo(FFrame&, void* const)
native static function WorldInfo GetWorldInfo();

// Export UMOHAUtilities::execGetClosetPointOnRootBodyBoxElem0(FFrame&, void* const)
native static function Vector GetClosetPointOnRootBodyBoxElem0(Actor A);

// Export UMOHAUtilities::execShellJumpToPosition(FFrame&, void* const)
native static function bool ShellJumpToPosition(MOHAIncludeClass.EShellStartPosition startPos);

// Export UMOHAUtilities::execStartCPUTrace(FFrame&, void* const)
native function StartCPUTrace(coerce string Filename);

// Export UMOHAUtilities::execStopCPUTrace(FFrame&, void* const)
native function StopCPUTrace();

static function AssignVector(out Vector vVec, float X, float Y, float Z)
{
    vVec.X = X;
    vVec.Y = Y;
    vVec.Z = Z;
    //return;    
}

static function AssignRotator(out Rotator rRot, float fPitch, float fYaw, float fRoll)
{
    rRot.Pitch = int(fPitch);
    rRot.Yaw = int(fYaw);
    rRot.Roll = int(fRoll);
    //return;    
}

static function bool MatchingDamageType(array< class<DamageType> > MyDamageTypes, class<DamageType> DamageType)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x39 [Loop If]
    if(I < MyDamageTypes.Length)
    {
        // End:0x2F
        if(ClassIsChildOf(DamageType, MyDamageTypes[I]))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

static function MOHAPlayerController GetLocalPlayerController(Actor Source)
{
    local PlayerController PC;

    // End:0x24
    foreach Source.LocalPlayerControllers(PC)
    {        
        return MOHAPlayerController(PC);        
    }    
    return none;
    //return ReturnValue;    
}

static function ActivateSequenceEventsOfType(WorldInfo WI, class<SequenceEvent> SeqType, Actor Originator, Actor InInstigator)
{
    local array<SequenceEvent> Objects;
    local int idx;
    local SequenceEvent SeqObj;

    // End:0xA6
    if(WI.GetGameSequence() != none)
    {
        WI.GetGameSequence().FindSeqObjectsByClass(SeqType, true, Objects);
        idx = 0;
        J0x40:

        // End:0xA6 [Loop If]
        if(idx < Objects.Length)
        {
            SeqObj = Objects[idx];
            // End:0x9C
            if((SeqObj != none) && SeqObj.CheckActivate(Originator, InInstigator))
            {
                SeqObj.PopulateLinkedVariableValues();
            }
            idx++;
            // [Loop Continue]
            goto J0x40;
        }
    }
    //return;    
}

defaultproperties
{
    CollisionType=0
}