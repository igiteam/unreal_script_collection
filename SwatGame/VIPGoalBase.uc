class VIPGoalBase extends RWOSupport.ReactiveStaticMesh
    implements IUseArchetype
    abstract;


// Executes only on the server.
event Touch( Actor Other )
{
    local SwatPlayer ThePlayer;

    mplog( self$"---VIPGoalBase::Touch(). Other="$Other );

    // If Other is a SwatPlayer and is the VIP, trigger the game event.
    ThePlayer = SwatPlayer(Other);
    if ( ThePlayer != None && ThePlayer.IsTheVIP() )
    {
        mplog( "The VIP has reached the goal." );

        // Send the game event.
        SwatGameInfo(Level.Game).GameEvents.VIPReachedGoal.Triggered( ThePlayer );
    }
}


// IUseArchetype implementation
function InitializeFromSpawner(Spawner Spawner);
function Internal_InitializeFromArchetypeInstance(ArchetypeInstance Instance);  //TMC Implementers: FINAL, please
function InitializeFromArchetypeInstance();














// Decompiled with UE Explorer.
defaultproperties
{
    bNoDelete=false
    RemoteRole=1
    bBlockZeroExtentTraces=false
    bTriggerEffectEventsBeforeGameStarts=true
}