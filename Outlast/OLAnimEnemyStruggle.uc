
class OLAnimEnemyStruggle extends AnimNodeBlendList
	native(Anim);

enum EStruggleAnimPhase
{
	SAP_StartIdle,
	SAP_Entry,
	SAP_Cycle,
	SAP_Success,
	SAP_Fail,
	SAP_SuccessIdle,
};

cpptext
{
	virtual void OnBecomeRelevant();
	void SetPhase(EStruggleAnimPhase phase, const FStruggleConfig& cfg);
};

defaultproperties
{
	NodeName="EnemyStruggle"
	CategoryDesc="Outlast"

	bFixNumChildren=true
	Children(0)=(Name="StartIdle")
	Children(1)=(Name="Entry")
	Children(2)=(Name="Cycle")
	Children(3)=(Name="Success")
	Children(4)=(Name="Fail")
	Children(5)=(Name="SuccessIdle")
}
