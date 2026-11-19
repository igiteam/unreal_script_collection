class SeqAct_ApplyImpulseToKActors extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor Locator;
var() float Momentum;
var() class<EvilDmgType_Base> dmgType;
var array<KActor> ActorTargets;
var array<EvilDynamicDestructibleObject> DynamicDestructibleActorTargets;

event Activated()
{
    local int I;
    local Vector Dir;
    local TraceHitInfo Info;

    I = 0;
    J0x0B:

    // End:0xFA [Loop If]
    if(I < ActorTargets.Length)
    {
        Dir = Normal(ActorTargets[I].Location - Locator.Location);
        ActorTargets[I].ApplyImpulse(Dir, Momentum, ActorTargets[I].Location, Info, dmgType);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x105:

    // End:0x1FB [Loop If]
    if(I < DynamicDestructibleActorTargets.Length)
    {
        Dir = Normal(ActorTargets[I].Location - Locator.Location);
        DynamicDestructibleActorTargets[I].CollisionComponent.AddImpulse(Dir * Momentum, ActorTargets[I].Location);
        I++;
        // [Loop Continue]
        goto J0x105;
    }
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Targets",LinkVar="None",PropertyName="ActorTargets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Dynamic Destructible Targets ",LinkVar="None",PropertyName="DynamicDestructibleActorTargets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Apply Impulse To KActors"
}