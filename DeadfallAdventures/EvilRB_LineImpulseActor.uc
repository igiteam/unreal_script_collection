class EvilRB_LineImpulseActor extends RB_LineImpulseActor
    native(Physics)
    hidecategories(Navigation);

// Export UEvilRB_LineImpulseActor::execFireLineImpulse(FFrame&, void* const)
native function FireLineImpulse();
