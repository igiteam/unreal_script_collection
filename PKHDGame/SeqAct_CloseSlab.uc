class SeqAct_CloseSlab extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var array<bool> PlayerCrossed;
var Actor EnterInstigator;
var Actor ExitInstigator;
var() bool bEnabled;
var() bool bAutoDisable;

function int GetPlayerCount()
{
    local PlayerController PC;
    local int Count;

    Count = 0;
    // End:0x83
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x82
        if(PC.bIsPlayer)
        {
            Count++;
        }        
    }    
    return Count;
    //return ReturnValue;    
}

function int GetPlayerIndex(Pawn P)
{
    local PlayerController PC;
    local int Index;

    Index = 0;
    // End:0xBC
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xB0
        if(PC.bIsPlayer && PC.Pawn == P)
        {            
            return Index;
        }
        Index++;        
    }    
    return -1;
    //return ReturnValue;    
}

function SetPlayerCrossed(int Index, bool Value)
{
    J0x00:
    // End:0x29 [Loop If]
    if(Index >= PlayerCrossed.Length)
    {
        PlayerCrossed.AddItem(false);
        // [Loop Continue]
        goto J0x00;
    }
    PlayerCrossed[Index] = Value;
    //return;    
}

function bool HasPlayerCrossed(int Index)
{
    // End:0x1A
    if(Index >= PlayerCrossed.Length)
    {
        return false;
    }
    return PlayerCrossed[Index];
    //return ReturnValue;    
}

event Activated()
{
    local bool Result;
    local Pawn ThePawn;
    local int Index;

    Result = false;
    // End:0x3D
    if(InputLinks[0].bHasImpulse)
    {
        bEnabled = true;        
    }
    else
    {
        // End:0x6E
        if(InputLinks[1].bHasImpulse)
        {
            bEnabled = false;            
        }
        else
        {
            // End:0x123
            if(InputLinks[2].bHasImpulse && bEnabled)
            {
                ThePawn = Pawn(EnterInstigator);
                // End:0x120
                if((ThePawn != none) && ThePawn.IsPlayerPawn())
                {
                    Index = GetPlayerIndex(ThePawn);
                    SetPlayerCrossed(Index, false);
                }                
            }
            else
            {
                // End:0x261
                if(InputLinks[3].bHasImpulse && bEnabled)
                {
                    Result = true;
                    ThePawn = Pawn(ExitInstigator);
                    // End:0x239
                    if((ThePawn != none) && ThePawn.IsPlayerPawn())
                    {
                        Index = GetPlayerIndex(ThePawn);
                        SetPlayerCrossed(Index, true);
                        Index = 0;
                        J0x1EC:

                        // End:0x239 [Loop If]
                        if(Index < (GetPlayerCount()))
                        {
                            // End:0x22B
                            if(!HasPlayerCrossed(Index))
                            {
                                Result = false;
                                // [Explicit Break]
                                goto J0x239;
                            }
                            ++Index;
                            // [Loop Continue]
                            goto J0x1EC;
                        }
                    }
                    J0x239:

                    // End:0x261
                    if(Result && bAutoDisable)
                    {
                        bEnabled = false;
                    }
                }
            }
        }
    }
    OutputLinks[0].bHasImpulse = Result;
    //return;    
}

defaultproperties
{
    bEnabled=true
    bAutoDisable=true
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Before Slab Trigger",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[3]=(LinkDesc="After Slab Trigger",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Before Slab Instigator",LinkVar="None",PropertyName="EnterInstigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="After Slab Instigator",LinkVar="None",PropertyName="ExitInstigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Close Slab"
}