class SeqAct_UnlockAchievement extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() PKAchievements.EPKGameAchievements AchievementId;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Unlock",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Unlock Achievement"
}