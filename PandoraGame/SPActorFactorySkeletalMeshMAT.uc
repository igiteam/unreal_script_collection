class SPActorFactorySkeletalMeshMAT extends ActorFactorySkeletalMeshMAT
    native
    config(Editor)
    editinlinenew
    collapsecategories;

var() PhysicsAsset PhysicsAsset;
/** [X, Y, Z] axes */
var() AnimNodeSequence.ERootBoneAxis AnimSeqRootBoneOption[3];
var() AnimNodeSequence.ERootBoneAxis AnimSeqRootBoneYawOption;
var() AnimNodeSequence.ERootBoneAxis AnimSeqRootBonePitchOption;
var() AnimNodeSequence.ERootBoneAxis AnimSeqRootBoneRollOption;
var() PrimitiveComponent.ERBCollisionChannel RBChannel;
var() array<AnimSet> AnimSets;
var() const AnimTree AnimTreeTemplate;
var() SPRandomPedProfile PedProfile;
