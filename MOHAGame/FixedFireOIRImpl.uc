class FixedFireOIRImpl extends PawnOwnedOIRImpl
    native
    implements(OIREventListener);

var Vector vPointTarget;

// Export UFixedFireOIRImpl::execGetPointAbsoluteRotation(FFrame&, void* const)
native function bool GetPointAbsoluteRotation(out Rotator absAimRot);

function name GetFixedFireSpecificPose()
{
    local Vector HiLoc, LowLoc;
    local name HighBoneName, LowBoneName, DesiredPose;
    local float CrouchMaxDistance;

    CrouchMaxDistance = 80.0000000;
    HighBoneName = 'Hips';
    LowBoneName = 'Root';
    DesiredPose = 'Stand_Center';
    // End:0xED
    if(OwningPawn != none)
    {
        // End:0xC9
        if(OwningPawn.PlayByPostureOverride == 0)
        {
            HiLoc = OwningPawn.Mesh.GetBoneLocation(HighBoneName, 1);
            LowLoc = OwningPawn.Mesh.GetBoneLocation(LowBoneName, 1);
            // End:0xC6
            if(VSize(HiLoc - LowLoc) <= CrouchMaxDistance)
            {
                DesiredPose = 'Crouch_Center';
            }            
        }
        else
        {
            // End:0xED
            if(OwningPawn.PlayByPostureOverride == 2)
            {
                DesiredPose = 'Crouch_Center';
            }
        }
    }
    return DesiredPose;
    //return ReturnValue;    
}

function name GetActivityPose(name InName)
{
    // End:0x22
    if(vPointTarget == vect(0.0000000, 0.0000000, 0.0000000))
    {
        return GetFixedFireSpecificPose();
    }
    switch(GetQuadrantFromPoint(vPointTarget))
    {
        // End:0x41
        case 0:
            return 'Forward';
        // End:0x4F
        case 1:
            return 'Left';
        // End:0x5E
        case 2:
            return 'back';
        // End:0x6D
        case 3:
            return 'Right';
        // End:0xFFFF
        default:
            return 'Forward';
            break;
    }
    //return ReturnValue;    
}

function int GetQuadrantFromPoint(Vector vTarget)
{
    local int Index;
    local Rotator targetOrientation, myRotation;
    local int DeltaYaw, quadrantSize;

    Index = 0;
    myRotation = OwningPawn.GetBaseAimRotation();
    // End:0x6E
    if((OwningPawn.ActiveOIR != none) && OwningPawn.ActiveOIR.m_bPawnIsAttached)
    {
        myRotation = OwningPawn.ActiveOIR.Rotation;
    }
    quadrantSize = 65536 / 4;
    targetOrientation = Rotator(vTarget - OwningPawn.Location);
    DeltaYaw = int(FindDeltaAngle(float(targetOrientation.Yaw) * 0.0000959, float(myRotation.Yaw) * 0.0000959) / 0.0000959);
    DeltaYaw += (quadrantSize / 2);
    // End:0x106
    if(DeltaYaw < 0)
    {
        DeltaYaw += 65536;
    }
    Index = DeltaYaw / quadrantSize;
    // End:0x12B
    if(Index > 4)
    {
        Index = 0;
    }
    return Index;
    //return ReturnValue;    
}

function ResetPointTarget()
{
    vPointTarget = default.vPointTarget;
    //return;    
}

function SetPointTarget(Vector newPointTarget)
{
    vPointTarget = newPointTarget;
    //return;    
}

function OnEntryFinish()
{
    //return;    
}

function OnExitBegin()
{
    //return;    
}

function OnAttach()
{
    //return;    
}

function OnDetach()
{
    //return;    
}

function bool OnPreAttachUpdateOIRRotation()
{
    OwningPawn.UpdateFixedFireRotation(OwningPawn.ActiveOIR.Location);
    OwningPawn.ActiveOIR.Rotation = Rotation;
    return true;
    //return ReturnValue;    
}

function bool IsDifferentOIR(Object ActiveOIR, bool bAnimsChanged)
{
    local Vector pos;
    local float maxHeightDiff, heightDiff;

    // End:0x0B
    if(bAnimsChanged)
    {
        return true;
    }
    // End:0x2F
    if(NotEqual_InterfaceInterface(OirInstance(ActiveOIR).OIRParent, OIROwnerInterface(self)))
    {
        return true;
    }
    // End:0x6F
    if(bSetInPlace && OwningPawn != none)
    {
        pos = MOHAAIController(OwningPawn.Controller).GetPathablePosition();        
    }
    else
    {
        pos = Position;
    }
    heightDiff = Abs(OirInstance(ActiveOIR).Location.Z - pos.Z);
    maxHeightDiff = (2.0000000 * OwningPawn.MaxStepHeight) + 2.0000000;
    // End:0x10F
    if((heightDiff > maxHeightDiff) || VSizeSq2D(OirInstance(ActiveOIR).Location - pos) > 50.0000000)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    OIRAnimSet=AnimSet'Anim_AI_FixedFireAnimSet.AnimSet.FixedFireAnimSet_Rifle'
    OIRAnimTree=AnimTree'Anim_AI_FixedFire.FixedFire_Rifle'
}