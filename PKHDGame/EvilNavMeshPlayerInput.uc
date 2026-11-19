class EvilNavMeshPlayerInput extends EvilPlayerInput within EvilNavMeshPlayerController
    transient
    config(Input)
    hidecategories(Object,UIRoot);

var bool bRealtimeFocus;
var int CursorVerticalShift;

function Tick(float DeltaTime)
{
    super(Interaction).Tick(DeltaTime);
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

function HandleButtonInput_DPad_Down(bool bPressed, optional bool bDblClickMove)
{
    local EvilAI_ZombieNavMesh AI;

    AI = GetAI();
    // End:0x26
    if(AI == none)
    {
        return;
    }
    // End:0x145
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
        // End:0x1BE
        if(bPressed && bRealtimeFocus == true)
        {
            GetPawn().Goal.Destroy();
            bRealtimeFocus = false;
            AI.Focus = none;
        }
    }
    //return;    
}

function HandleButtonInput_LeftTrigger(bool bPressed, optional bool bDblClickMove)
{
    local EvilAI_ZombieNavMesh AI;
    local EvilPawn P;

    // End:0x130
    if((Outer.PSCSelected != none) && bPressed)
    {
        // End:0x130
        if(Pawn(Outer.CursorBase) == none)
        {
            P = GetPawn();
            // End:0x130
            if(P != none)
            {
                // End:0x130
                if(P.SetGoal(Outer.CursorPosition))
                {
                    AI = EvilAI_ZombieNavMesh(P.Controller);
                    // End:0x130
                    if(AI != none)
                    {
                        AI.GoGoGo(IsButtonActive(7));
                    }
                }
            }
        }
    }
    // End:0x2DC
    if(Pawn(Outer.CursorBase) != none)
    {
        // End:0x1EA
        if(Pawn(Outer.CursorBase).Controller != none)
        {
            Pawn(Outer.CursorBase).Controller.Destroy();
        }
        // End:0x2A6
        if((EvilPawn(Outer.CursorBase) != none) && EvilPawn(Outer.CursorBase).Goal != none)
        {
            EvilPawn(Outer.CursorBase).Goal.Destroy();
        }
        Pawn(Outer.CursorBase).Destroy();
    }
    //return;    
}

function HandleButtonInput_RightStickButton(bool bPressed, optional bool bDblClickMove)
{
    local EvilPawn P;

    // End:0x110
    if(bPressed)
    {
        // End:0x10D
        if(Outer.PSCSelected != none)
        {
            P = EvilPawn(Outer.PSCSelected.Owner);
            P.Controller.NavigationHandle.bUltraVerbosePathDebugging = !P.Controller.NavigationHandle.bUltraVerbosePathDebugging;
        }        
    }
    //return;    
}

function HandleButtonInput_B(bool bPressed, optional bool bDblClickMove)
{
    // End:0x30
    if(bPressed)
    {
        Outer.ToggleSize();        
    }
    //return;    
}

function HandleButtonInput_Y(bool bPressed, optional bool bDblClickMove)
{
    // End:0x2D
    if(bPressed)
    {
        Outer.Use();
    }
    //return;    
}

function HandleButtonInput_X(bool bPressed, optional bool bDblClickMove)
{
    // End:0x92
    if(bPressed && !EvilPawn(Outer.Pawn).bIsJumping)
    {
        EvilGFxHudWrapper(Outer.myHUD).ShowAIDebug();        
    }
    //return;    
}

function HandleButtonInput_RightTrigger(bool bPressed, optional bool bDblClickMove)
{
    Outer.DetachPSCSelected(Pawn(Outer.PSCSelected.Owner));
    // End:0x8C
    if(Pawn(Outer.CursorBase) == none)
    {        
    }
    else
    {
        Outer.AttachPSCSelected(Pawn(Outer.CursorBase), ParticleSystem'ps_CapturedCharacter.Effects.ps_CharacterChosen');
    }
    //return;    
}
