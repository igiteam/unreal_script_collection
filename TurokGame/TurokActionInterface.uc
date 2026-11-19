interface TurokActionInterface extends Interface
    abstract
    native;

// Export UTurokActionInterface::execSetContextAction(FFrame&, void* const)
native function SetContextAction(@NULL Action);

// Export UTurokActionInterface::execSetActionVolume(FFrame&, void* const)
native function SetActionVolume(@NULL Volume);

// Export UTurokActionInterface::execGetContextAction(FFrame&, void* const)
native function @NULL GetContextAction();
