class AnimTree extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

struct SkelControlListHead
{
    var name BoneName;
    var export editinline SkelControlBase ControlHead;
    var int DrawY;

    structdefaultproperties
    {
        BoneName="None"
        ControlHead=none
        DrawY=0
    }
};

var export editinline array<export editinline MorphNodeBase> RootMorphNodes;
var export editinline array<export editinline SkelControlListHead> SkelControlLists;
var int MorphConnDrawY;
var transient bool bBeingEdited;
var() SkeletalMesh PreviewSkelMesh;
var() SkeletalMesh SocketSkelMesh;
var() StaticMesh SocketStaticMesh;
var() name SocketName;
var() array<AnimSet> PreviewAnimSets;
var() R6CharacterTemplate PreviewCharacterTemplate;
var SkeletalMesh PreviewSkelAux1;
var SkeletalMesh PreviewSkelAux2;
var SkeletalMesh PreviewSkelAux3;
var SkeletalMesh PreviewSkelAux4;
var SkeletalMesh PreviewArmorSkelCompAux1;
var SkeletalMesh PreviewArmorSkelCompAux2;
var SkeletalMesh PreviewArmorSkelCompAux3;
var SkeletalMesh PreviewArmorSkelCompAux4;
var SkeletalMesh PreviewArmorSkelCompAux5;
var SkeletalMesh PreviewArmorSkelCompAux6;
var SkeletalMesh PreviewArmorSkelCompAux7;
var() array<MorphTargetSet> PreviewMorphSets;
var Vector PreviewCamPos;
var Rotator PreviewCamRot;
var Vector PreviewFloorPos;
var int PreviewFloorYaw;
var array<R6TreeComment> m_Comments;
var() bool m_bApplyComBalance;
var transient array<BoneAtom> m_COMReferencePoseAtoms;
var transient array<int> m_COMReferencePoseAtomsIndex;

// Export UAnimTree::execFindSkelControl(FFrame&, void* const)
native final function SkelControlBase FindSkelControl(name InControlName);

// Export UAnimTree::execFindMorphNode(FFrame&, void* const)
native final function MorphNodeBase FindMorphNode(name InNodeName);

defaultproperties
{
    Children[0]=(Name="Child",Anim=none,m_iAnimLeafIndex=-1,Weight=1.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    bFixNumChildren=true
}