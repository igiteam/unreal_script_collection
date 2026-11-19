class SeqAct_HideMaterials extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() array<int> MaterialIndexes;
var() array<int> TorsoMaterialIndexes;
var array<SkeletalMeshActor> CinematicSkeletonActors;

event Activated()
{
    local int I, J;
    local editinline SkeletalMeshComponent Mesh;

    I = 0;
    J0x0B:

    // End:0x126 [Loop If]
    if(I < CinematicSkeletonActors.Length)
    {
        Mesh = CinematicSkeletonActors[I].SkeletalMeshComponent;
        J = 0;
        J0x60:

        // End:0xBA [Loop If]
        if(J < MaterialIndexes.Length)
        {
            Mesh.ShowMaterialSection(MaterialIndexes[J], false, 0);
            J++;
            // [Loop Continue]
            goto J0x60;
        }
        // End:0x118
        if(SkeletalMeshActorMAT(CinematicSkeletonActors[I]) != none)
        {
            SkeletalMeshActorMAT(CinematicSkeletonActors[I]).ShowMaterials(MaterialIndexes, false);
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="SkeletalMeshActors",LinkVar="None",PropertyName="CinematicSkeletonActors",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="HideMaterials"
}