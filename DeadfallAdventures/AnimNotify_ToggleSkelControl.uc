class AnimNotify_ToggleSkelControl extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() name SkelControlName;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local editinline SkeletalMeshComponent OwnerMesh;
    local SkelControlBase SkelControl;

    super.Notify(Owner, AnimSeqInstigator);
    // End:0xD4
    foreach Owner.ComponentList(Class'Engine.SkeletalMeshComponent', OwnerMesh)
    {
        SkelControl = OwnerMesh.FindSkelControl(SkelControlName);
        // End:0xD3
        if(SkelControl != none)
        {
            SkelControl.SetSkelControlActive(SkelControl.ControlStrength == float(0));
        }        
    }    
    //return;    
}
