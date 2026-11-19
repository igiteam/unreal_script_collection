class EvilNavMeshPlayerInput extends EvilPlayerInput within EvilNavMeshPlayerController
    transient
    config(Input)
    hidecategories(Object,UIRoot);

var bool bRealtimeFocus;
var int CursorVerticalShift;

function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x8D
    if(bRealtimeFocus && (GetPawn()) != none)
    {
        GetPawn().Goal.SetLocation(Outer.CursorPosition + vect(0.0000000, 0.0000000, 100.0000000));
    }
    //return;    
}

function EvilPawn GetPawn()
{
    // End:0x26
    if(Outer.PSCSelected == none)
    {
        return none;
    }
    return EvilPawn(Pawn(Outer.PSCSelected.Owner));
    //return ReturnValue;    
}

function EvilAI_ZombieNavMesh GetAI()
{
    local EvilPawn P;

    P = GetPawn();
    return ((P == none) ? none : EvilAI_ZombieNavMesh(P.Controller));
    //return ReturnValue;    
}

function bool HandleButtonInput_DPad_Down(bool bPressed)
{
    local EvilAI_ZombieNavMesh AI;

    AI = GetAI();
    // End:0x25
    if(AI == none)
    {
        return true;
    }
    // End:0x144
    if(bPressed && bRealtimeFocus == false)
    {
        GetPawn().SetGoal(Outer.CursorPosition);
        GetPawn().Goal.DisableAutoDestory = true;
        AI.Focus = GetPawn().Goal;
        AI.ShotTargetActor = GetPawn().Goal;
        bRealtimeFocus = true;        
    }
    else
    {
        // End:0x1BD
        if(bPressed && bRealtimeFocus == true)
        {
            GetPawn().Goal.Destroy();
            bRealtimeFocus = false;
            AI.Focus = none;
        }
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_DPad_Down(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_LeftTrigger(bool bPressed)
{
    local EvilAI_ZombieNavMesh AI;
    local EvilPawn P;

    // End:0x12F
    if((Outer.PSCSelected != none) && bPressed)
    {
        // End:0x12F
        if(Pawn(Outer.CursorBase) == none)
        {
            P = GetPawn();
            // End:0x12F
            if(P != none)
            {
                // End:0x12F
                if(P.SetGoal(Outer.CursorPosition))
                {
                    AI = EvilAI_ZombieNavMesh(P.Controller);
                    // End:0x12F
                    if(AI != none)
                    {
                        AI.GoGoGo(IsButtonActive(7));
                    }
                }
            }
        }
    }
    // End:0x2DB
    if(Pawn(Outer.CursorBase) != none)
    {
        // End:0x1E9
        if(Pawn(Outer.CursorBase).Controller != none)
        {
            Pawn(Outer.CursorBase).Controller.Destroy();
        }
        // End:0x2A5
        if((EvilPawn(Outer.CursorBase) != none) && EvilPawn(Outer.CursorBase).Goal != none)
        {
            EvilPawn(Outer.CursorBase).Goal.Destroy();
        }
        Pawn(Outer.CursorBase).Destroy();
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_LeftTrigger(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_RightStickButton(bool bPressed)
{
    local EvilPawn P;

    // End:0x10F
    if(bPressed)
    {
        // End:0x10C
        if(Outer.PSCSelected != none)
        {
            P = EvilPawn(Outer.PSCSelected.Owner);
            P.Controller.NavigationHandle.bUltraVerbosePathDebugging = !P.Controller.NavigationHandle.bUltraVerbosePathDebugging;
        }        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_RightStickButton(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_B(bool bPressed)
{
    // End:0x2F
    if(bPressed)
    {
        Outer.ToggleSize();        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_B(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_Y(bool bPressed)
{
    // End:0x2C
    if(bPressed)
    {
        Outer.Use();
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_Y(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_X(bool bPressed)
{
    // End:0x91
    if(bPressed && !EvilPawn(Outer.Pawn).bIsJumping)
    {
        EvilGFxHudWrapper(Outer.myHUD).ShowAIDebug();        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_X(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_RightTrigger(bool bPressed)
{
    Outer.DetachPSCSelected(Pawn(Outer.PSCSelected.Owner));
    // End:0x8B
    if(Pawn(Outer.CursorBase) == none)
    {        
    }
    else
    {
        Outer.AttachPSCSelected(Pawn(Outer.CursorBase), ParticleSystem'ps_CapturedCharacter.Effects.ps_CharacterChosen');
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_RightTrigger(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}
