class SkyAnimNotify_PlaySoundGroupCue extends AnimNotify_Scripted
    native
    config(Engine)
    editinlinenew
    collapsecategories;

var() protectedwrite name CueMemberName;
var(Testing) editoronly SkyPawnSoundGroup TestSoundGroup;
var() array<string> WillVOSoundGroups;

// Export USkyAnimNotify_PlaySoundGroupCue::execGetSoundCue(FFrame&, void* const)
native function SoundCue GetSoundCue(SkyPawnSoundGroup Group, SkyPawn Pawn);
