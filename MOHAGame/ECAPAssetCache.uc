class ECAPAssetCache extends Object
    native
    editinlinenew
    hidecategories(Object);

struct native ECAPAssetCacheBlendRegion
{
    var private native name CachedBoneNamea;
    var private native name CachedBoneNameb;
    var private native int BoneIndexa;
    var private native int BoneIndexb;
};

var native array<ECAPAssetCacheBlendRegion> aRegions;
var native Pointer CachedSkeletalMeshPointer;
var private native int MaterialSlotID;
