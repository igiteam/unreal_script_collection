class R6DeadBody extends R6SpawnableKAsset
    native
    hidecategories(lighting);

var() SkeletalMesh m_pSkeletalMesh;
var() PhysicsAsset m_pPhysicsAsset;
var() /*0x10000000-0x00000000*/ name m_AnimSeqName;
var() float m_fAngularSleepSpeed;
var() float m_fLinearSleepSpeed;
var bool m_bWasStable;

defaultproperties
{
    m_fAngularSleepSpeed=1.0000000
    m_fLinearSleepSpeed=2.0000000
    // Reference: SkeletalMeshComponent'Default__R6DeadBody.SkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SkelMesh" class=Class'Engine.SkeletalMeshComponent'
        AnimTreeTemplate=AnimTree'AnimTreeRagdoll.AnimTreeRagdoll'
        PhysicsWeight=1.0000000
        AnimSets[0]=AnimSet'Anims_Dead_Civilians.Death_Poses'
        AnimSets[1]=AnimSet'Anims_General_Hands.Death.Male'
    end object
    SkeletalMeshComponent=SkelMesh
    bStasis=true
    Components[0]=SkelMesh
    CollisionComponent=SkelMesh
}