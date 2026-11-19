class SPConditionEvaluate_AntRotationSpeed extends SPConditionEvaluate_AngleRange
    native
    editinlinenew
    collapsecategories;

function bool EvaluteWithActor(Actor Actor)
{
    local int wAngle;
    local SPSkeletalMeshActorMATSMover Ant;

    Ant = SPSkeletalMeshActorMATSMover(Actor);
    // End:0x1D
    if(Ant == none)
    {
        return false;
    }
    wAngle = 0;
    switch(m_RotAxis)
    {
        // End:0x54
        case 0:
            wAngle = Ant.spAngularVelocity.Pitch;
            // End:0xA7
            break;
        // End:0x7C
        case 1:
            wAngle = Ant.spAngularVelocity.Yaw;
            // End:0xA7
            break;
        // End:0xA4
        case 2:
            wAngle = Ant.spAngularVelocity.Roll;
            // End:0xA7
            break;
        // End:0xFFFF
        default:
            break;
    }
    return CompareAngle(wAngle);
    //return ReturnValue;    
}

function bool EvaluteWithSPAnimConditionalSwitchNode(SPAnimConditionalSwitchNode Node)
{
    switch(m_RotAxis)
    {
        // End:0x3D
        case 0:
            return CompareAngle(Node.EditorPreview.rotationSpeed.Pitch);
        // End:0x72
        case 1:
            return CompareAngle(Node.EditorPreview.rotationSpeed.Yaw);
        // End:0xA7
        case 2:
            return CompareAngle(Node.EditorPreview.rotationSpeed.Roll);
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}
