class SkyPrimaryWSM extends SkyWeaponStateMachine
    native;

// Export USkyPrimaryWSM::execAllowAttachmentNotifies(FFrame&, void* const)
native function bool AllowAttachmentNotifies();

// Export USkyPrimaryWSM::execAllowingManualTransitions(FFrame&, void* const)
native function bool AllowingManualTransitions();
