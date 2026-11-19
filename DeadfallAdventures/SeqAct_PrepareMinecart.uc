class SeqAct_PrepareMinecart extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor.EPhysics newPhysics;
var Actor Instigator;
var Actor Target;

event Activated()
{
    local EvilPlayer_interface EPI;
    local EvilPawn P;

    EPI = EvilPlayer_interface(Instigator);
    // End:0x17B
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        P = EPI.GetPlayerPawn();
        P.SetPhysics(newPhysics);
        P.ZeroMovementVariables();
        P.SetCollision(false, false);
        P.bCollideWorld = false;
        // End:0x17B
        if(Target != none)
        {
            P.SetLocation(Target.Location);
            EvilPlayerController(P.Controller).SetRotation(Target.Rotation);
        }
    }
    //return;    
}

defaultproperties
{
    newPhysics=EPhysics.PHYS_Interpolating
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Prepare Minecart"
}