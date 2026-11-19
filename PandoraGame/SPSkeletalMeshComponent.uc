class SPSkeletalMeshComponent extends SkeletalMeshComponent
    native
    editinlinenew;

/** This changes the FOV used for rendering the skeletal mesh component. A value of 0 means to use the default. */
var() private float FOV;
/** Additional AnimSets array that gets combined with AnimSets on PostLoad */
var() array<AnimSet> UniqueAnimSets;
