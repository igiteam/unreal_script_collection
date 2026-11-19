class SPRandomPedPersistent extends CivilianStandardPawnPersistent
    native
    config(Game);

/** BIG NOTE: this class should not reference any assets directly!!!!BIG NOTE: this class should not reference any assets directly!!!!BIG NOTE: this class should not reference any assets directly!!!!BIG NOTE: this class should not reference any assets directly!!!!BIG NOTE: this class should not reference any assets directly!!!!BIG NOTE: this class should not reference any assets directly!!!!BIG NOTE: this class should not reference any assets directly!!!! INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS List of pedestrian profile objects to choose from */
var() SPRandomPedProfile PedProfile;
var() transient bool bClickToRegenerate;
var() bool bUseUserCombination;
/** Used to allow the user to specify a specific skeletal mesh candidate */
var() int UserSkelMeshID;
/** Used to allow the user to specify a specific character NATIVE FUNCTION DECLARATIONS */
var() array<int> UserMtlCombinationID;

// Export USPRandomPedPersistent::execSetupMesh(FFrame&, void* const)
native function SetupMesh(bool bForceReattach);
