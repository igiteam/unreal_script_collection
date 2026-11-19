class SPConditionEvaluate_Angle extends SPConditionEvaluate
    abstract
    editinlinenew
    collapsecategories;

/** `define SPLOG(t)  `LOG("SPConditionEvaluate_AngleRange: " $ `t) STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() float m_AngleLimitInDegrees;

function float UnwindDegree(float A)
{
    J0x00:
    // End:0x1F [Loop If]
    if(A > float(180))
    {
        A -= float(360);
        // [Loop Continue]
        goto J0x00;
    }
    J0x1F:

    // End:0x41 [Loop If]
    if(A < float(-180))
    {
        A += float(360);
        // [Loop Continue]
        goto J0x1F;
    }
    return A;
    //return ReturnValue;    
}

function int AngleLimitInWangles()
{
    local float Angle;
    local int wAngle;

    Angle = UnwindDegree(m_AngleLimitInDegrees);
    wAngle = NormalizeRotAxis(int((Angle * 65536.0000000) / 360.0000000));
    return wAngle;
    //return ReturnValue;    
}

function int AntYawRate(Actor Actor)
{
    local int wAngle;
    local SPSkeletalMeshActorMATSMover Ant;

    // End:0x0D
    if(Actor == none)
    {
        return 0;
    }
    Ant = SPSkeletalMeshActorMATSMover(Actor);
    // End:0x2A
    if(Ant == none)
    {
        return 0;
    }
    wAngle = Ant.spAngularVelocity.Yaw;
    return wAngle;
    //return ReturnValue;    
}

function int NodeYawRate(SPAnimConditionalSwitchNode Node)
{
    // End:0x0D
    if(Node == none)
    {
        return 0;
    }
    return Node.EditorPreview.rotationSpeed.Yaw;
    //return ReturnValue;    
}
