class CCLookAtRulePlayer extends CCLookAtRuleBase
    native
    editinlinenew
    hidecategories(Object,Object);

var(Player) CCTarget EditorTarget;
var(Player) array<Vector> ChildTargets;
var(Player) bool bOnlyUseChildTargets;

// Export UCCLookAtRulePlayer::execCameraOffsetToWorld(FFrame&, void* const)
native function Vector CameraOffsetToWorld(Vector CameraLocation, Rotator CameraRotation, Vector Offset);

// Export UCCLookAtRulePlayer::execEvaluateNative(FFrame&, void* const)
native function EvaluateNative(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl);

event Evaluate(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl)
{
    EvaluateNative(Performer, RulesControl, PAControl);
    //return;    
}

event bool EditTarget(CCTarget Target)
{
    local int Index, ChildIndex;

    Index = InStr(string(Target.Id), ".");
    // End:0xB9
    if(Index > 0)
    {
        // End:0xB6
        if(name(Left(string(Target.Id), Index)) == self.Name)
        {
            ChildIndex = int(Right(string(Target.Id), (Len(string(Target.Id)) - Index) - 1));
            ChildTargets[ChildIndex] = Target.Position - EditorTarget.Position;
            return true;
        }        
    }
    else
    {
        // End:0xE4
        if(Target.Id == self.Name)
        {
            EditorTarget = Target;
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    EditorTarget=(Id="Undefined",Position=(X=0.0000000,Y=0.0000000,Z=0.0000000),Space=5,SpaceBoneName="Root",actorName="None",Weight=1.0000000,bIsEditable=true,EditorColor=(R=128,G=255,B=255,A=255))
}