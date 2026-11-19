class SeqAct_SetFocusDir extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor Instigator;
var Actor Target;
var Vector Direction;
var() bool bGetCurrentRotation;
var() float AngleLimit;
var() float InterpSpeed;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x19C
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x19B
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
        {
            P = EvilPawn(ObjVar.GetObjectValue());
            // End:0xBF
            if(P != none)
            {
                PC = EvilPlayerController(P.Controller);
            }
            // End:0x19A
            if(PC != none)
            {
                // End:0x108
                if(bGetCurrentRotation)
                {
                    Direction = Vector(PC.Rotation);                    
                }
                else
                {
                    Direction = Normal(Target.Location - P.Location);
                }
                PC.SetFocusDir(true, Direction, InterpSpeed,, 2, Cos(AngleLimit * 0.0174533));
            }            
        }        
    }
    //return;    
}

defaultproperties
{
    bGetCurrentRotation=true
    InterpSpeed=1.0000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Set Focus Dir"
}