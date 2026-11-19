class SeqAct_SPControlBackupLoadingScenePersistent extends SequenceAction
    abstract
    native;

/** The UIScene loading screen */
var() UIScene LoadingUIScene;
/** Controls whether or not to hav the texture streaming delay that will keep the movie playing for some seconds after disabling the backup loading movie */
var() bool bPauseAfterDisable;
