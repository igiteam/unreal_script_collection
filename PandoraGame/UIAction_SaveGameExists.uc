class UIAction_SaveGameExists extends UIAction
    native;

/** The save game filename to check to see if it exists. */
var() string Filename;
var int bIsDone;
var int bExists;
var int bIsDamaged;
