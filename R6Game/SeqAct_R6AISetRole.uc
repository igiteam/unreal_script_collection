class SeqAct_R6AISetRole extends SequenceAction
    native
    hidecategories(Object);

enum EAIRoleType
{
    AIRole_Guard,                   // 0
    AIRole_Patrol,                  // 1
    AIRole_Ambush,                  // 2
    AIRole_Turret,                  // 3
    AIRole_Snipe,                   // 4
    AIRole_Zombie,                  // 5
    AIRole_ActionSpot,              // 6
    AIRole_MAX                      // 7
};

var() SeqAct_R6AISetRole.EAIRoleType m_eRole;
var() bool m_bIsMobile;
var() bool m_bCanBeLeader;
var() bool m_bIsAware;
var(Patrol) bool m_bPatrolLeader;
var() bool m_bNoFeedBack;
var(Patrol) name m_pPatrolName;
var(Patrol) float m_fPatrolFormationDistance;
var(Patrol) float m_fPatrolFormationAngle;
var(Ambush) float m_fAmbushAttackTimeDelay;

defaultproperties
{
    m_bNoFeedBack=true
    m_fAmbushAttackTimeDelay=1.0000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="ActionSpot",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set Role"
    ObjCategory="R6AI"
}