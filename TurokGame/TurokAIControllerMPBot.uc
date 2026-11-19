class TurokAIControllerMPBot extends TurokAIControllerHumanNpc
    native
    hidecategories(Navigation);

// Export UTurokAIControllerMPBot::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

event Possess(@NULL inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    // End:0x2A
    if(inPawn != none)
    {
        GotoState('ActionPlanner');
    }
    //return;    
}

event UnPossess()
{
    super(Controller).UnPossess();
    // End:0x1F
    if(Pawn == none)
    {
        GotoState('Dead');
    }
    //return;    
}

auto state Dead
{
    function BeginState(name PreviousState)
    {
        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        //return;        
    }
    stop;    
}

defaultproperties
{
    bIsPlayer=true
    // Reference: SpriteComponent'Default__TurokAIControllerMPBot.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}