class SeqAct_LeaveMinecart extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor.EPhysics newPhysics;
var Actor Instigator;

event Activated()
{
    local EvilPlayer_interface EPI;
    local EvilPawn P;

    EPI = EvilPlayer_interface(Instigator);
    // End:0xE2
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        P = EPI.GetPlayerPawn();
        P.SetPhysics(newPhysics);
        P.ZeroMovementVariables();
        P.SetCollision(true, true);
        P.bCollideWorld = true;
    }
    //return;    
}

defaultproperties
{
    newPhysics=EPhysics.PHYS_Interpolating
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Leave Minecart"
}