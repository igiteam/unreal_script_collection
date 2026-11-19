class SkySecondaryWSM extends SkyWeaponStateMachine
    native;

// Export USkySecondaryWSM::execAllowAttachmentNotifies(FFrame&, void* const)
native function bool AllowAttachmentNotifies();

// Export USkySecondaryWSM::execAllowingManualTransitions(FFrame&, void* const)
native function bool AllowingManualTransitions();
