class TurokFEPauseOptionsOverlay extends TurokUISceneController
    native;

const PAUSE_OPTIONS_OVERLAY_FADE_IN_SCRIPT_NAME = "FadeIn";
const PAUSE_OPTIONS_OVERLAY_FADE_OUT_SCRIPT_NAME = "FadeOut";

var @NULL m_OverlayParent;

// Export UTurokFEPauseOptionsOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEPauseOptionsOverlay::execCloseMenu(FFrame&, void* const)
native function CloseMenu();

// Export UTurokFEPauseOptionsOverlay::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

// Export UTurokFEPauseOptionsOverlay::execSetOverlayParent(FFrame&, void* const)
native function SetOverlayParent(@NULL pOverlayParent);
