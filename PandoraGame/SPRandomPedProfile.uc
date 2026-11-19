class SPRandomPedProfile extends Object
    native
    editinlinenew;

struct native MtlCategory
{
    var() const name MtlCatName;
    var() array<MaterialInterface> Mtls;

    structdefaultproperties
    {
        MtlCatName="None"
        Mtls=none
    }
};

struct native PedCandidate
{
    /** The mesh to use with this particular pedestrian candidate */
    var() SkeletalMesh SkelMesh;
    /** The dismembered mesh to use with this particular pedestrian candidate */
    var(Dismemberment) SkeletalMesh DismemberedSkelMesh;
    /** The name of the material category to use for this material slot in the mesh */
    var() array<name> MtlCategories;

    structdefaultproperties
    {
        SkelMesh=none
        DismemberedSkelMesh=none
        MtlCategories=none
    }
};

/** List of pedestrian candidates to choose from */
var() array<PedCandidate> PedCandidates;
/** List of material categories that the pedestrian candidates can choose from    when defining their material slots */
var() array<MtlCategory> MtlCategories;
