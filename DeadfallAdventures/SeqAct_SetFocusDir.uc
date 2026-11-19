class SeqAct_SetFocusDir extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor Instigator;
var Actor Target;
var() bool bGetCurrentRotation;
var() float AngleLimit;
var() float InterpSpeed;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x18B
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x187
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
        {
            P = EvilPawn(ObjVar.GetObjectValue());
            // End:0xBF
            if(P != none)
            {
                PC = EvilPlayerController(P.Controller);
            }
            // End:0x186
            if(PC != none)
            {
                // End:0x13D
                if(bGetCurrentRotation)
                {
                    PC.SetFocusDir(true, Vector(PC.Rotation), InterpSpeed,, 2, Cos(AngleLimit * 0.0174533));
                    // End:0x186
                    continue;
                }
                PC.SetFocusActor(true, Target, InterpSpeed,, 2, Cos(AngleLimit * 0.0174533));
            }            
        }                
    }
    else
    {
        // End:0x27D
        if(InputLinks[1].bHasImpulse)
        {
            // End:0x27C
            foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
            {
                P = EvilPawn(ObjVar.GetObjectValue());
                // End:0x24A
                if(P != none)
                {
                    PC = EvilPlayerController(P.Controller);
                }
                // End:0x27B
                if(PC != none)
                {
                    PC.ClearFocus(true);
                }                
            }            
        }
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    bGetCurrentRotation=true
    InterpSpeed=1.0000000
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Set Focus Dir"
}