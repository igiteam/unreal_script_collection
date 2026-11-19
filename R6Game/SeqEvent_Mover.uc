class SeqEvent_Mover extends SequenceEvent
    native
    hidecategories(Object,SequenceEvent);

var() float StayOpenTime;

event RegisterEvent()
{
    local InterpActor Mover;

    Mover = InterpActor(Originator);
    // End:0x2F
    if(Mover != none)
    {
        Mover.StayOpenTime = StayOpenTime;
    }
    return;
}

function NotifyEncroachingOn(Actor Hit)
{
    local SeqVar_Object ObjVar;
    local array<int> ActivateIndices;

    ActivateIndices[0] = 3;
    // End:0x58
    if(CheckActivate(Originator, Instigator, false, ActivateIndices))
    {
        // End:0x57
        foreach LinkedVariables(Class'SeqVar_Object', ObjVar, "Actor Hit")
        {
            ObjVar.ObjValue = Hit;            
        }        
    }
    return;
}

function NotifyAttached(Actor other)
{
    local array<int> ActivateIndices;

    // End:0x46
    if((Pawn(other) != none) && IsZero(Originator.Velocity))
    {
        ActivateIndices[0] = 0;
        CheckActivate(Originator, other, false, ActivateIndices);
    }
    return;
}

function NotifyDetached(Actor other)
{
    local Pawn P;
    local array<int> ActivateIndices;

    // End:0x2A
    if(Originator == none)
    {
        WarnInternal("Originator mover missing");        
    }
    else
    {
        // End:0x78
        if(Pawn(other) != none)
        {
            // End:0x57
            foreach Originator.BasedActors(Class'Pawn', P)
            {                
                return;                
            }            
            ActivateIndices[0] = 1;
            CheckActivate(Originator, Instigator, false, ActivateIndices);
        }
    }
    return;
}

function NotifyFinishedOpen()
{
    local array<int> ActivateIndices;

    ActivateIndices[0] = 2;
    CheckActivate(Originator, Instigator, false, ActivateIndices);
    return;
}

defaultproperties
{
    StayOpenTime=1.5000000
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks[0]=(Links=none,LinkDesc="Pawn Attached",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Pawn Detached",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Open Finished",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="Hit Actor",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Actor Hit",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Mover"
    ObjCategory="Physics"
}