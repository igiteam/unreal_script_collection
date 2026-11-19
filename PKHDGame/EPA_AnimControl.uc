class EPA_AnimControl extends EvilPawnAction;

function bool CanOverrideActionWith(byte NewAction)
{
    return false;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return true;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    PawnOwner.MyEvilAI.ReactionManager.SuppressAllReactions();
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.MyEvilAI.ReactionManager.UnSuppressAllReactions();
    //return;    
}

defaultproperties
{
    DefaultAICommand=Class'EvilAICmd_Base_PushedByPawnAction'
    bDisableAI=true
    bDisableCollision=true
    bDisablePhysics=true
}