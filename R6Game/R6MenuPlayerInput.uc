class R6MenuPlayerInput extends R6PlayerInput within R6PlayerController
    transient
    native
    config(Input);

// Export UR6MenuPlayerInput::execPlayerInput(FFrame&, void* const)
native function PlayerInput(float fDeltaTime);
