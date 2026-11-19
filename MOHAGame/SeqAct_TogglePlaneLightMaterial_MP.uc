class SeqAct_TogglePlaneLightMaterial_MP extends SequenceAction
    hidecategories(Object);

enum enumPlaneLightMaterial_MP
{
    All_OFF,                        // 0
    Green_ON,                       // 1
    Red_ON,                         // 2
    enumPlaneLightMaterial_MP_MAX   // 3
};

var() SeqAct_TogglePlaneLightMaterial_MP.enumPlaneLightMaterial_MP activity;

defaultproperties
{
    ObjName="TogglePlaneLightMaterial"
    ObjCategory="Objective Airborne - ITP"
}