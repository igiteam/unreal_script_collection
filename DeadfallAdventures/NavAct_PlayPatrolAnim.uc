class NavAct_PlayPatrolAnim extends NavAct_PlayCustomAnim
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EPOI_PatrolAnimType
{
    POI_TypeNone,                   // 0
    POI_Overwatch,                  // 1
    POI_Talking,                    // 2
    POI_Relaxed,                    // 3
    POI_MAX                         // 4
};

enum EPOI_PatrolAnim
{
    POI_AnimNone,                   // 0
    POI_Patrol_Overwatch1,          // 1
    POI_Patrol_Overwatch2,          // 2
    POI_Patrol_Overwatch3,          // 3
    POI_Patrol_Talking1,            // 4
    POI_Patrol_Talking2,            // 5
    POI_Patrol_Talking3,            // 6
    POI_IdleRelaxed1,               // 7
    POI_IdleRelaxed2,               // 8
    POI_IdleRelaxed3,               // 9
    POI_IdleRelaxed4,               // 10
    POI_MAX                         // 11
};

var array<string> PatrolAnimNames;
var() NavAct_PlayPatrolAnim.EPOI_PatrolAnimType PatrolAnimType;
var NavAct_PlayPatrolAnim.EPOI_PatrolAnim PatrolAnim;

function int GetAnimationIndex()
{
    // End:0x29
    if(int(PatrolAnim) != int(0))
    {
        return int(PatrolAnim) - int(1);        
    }
    else
    {
        // End:0x7F
        if(int(PatrolAnimType) != int(0))
        {
            switch(PatrolAnimType)
            {
                // End:0x5D
                case 1:
                    return 0 + Rand(6);
                // End:0x6B
                case 2:
                    return 6 + Rand(8);
                // End:0x79
                case 3:
                    return 14 + Rand(4);
                // End:0xFFFF
                default:
                    // End:0x85
                    break;
                    break;
            }
        }
        return -1;
    }
    //return ReturnValue;    
}

function bool InitNavAction(EvilPawn InMyEvilPawn)
{
    local int AnimationNameIndex;

    AnimationNameIndex = GetAnimationIndex();
    // End:0x59
    if(AnimationNameIndex >= 0)
    {
        AnimName = name(PatrolAnimNames[AnimationNameIndex]);
        return super(ENA_PlayCustomAnim).InitNavAction(InMyEvilPawn);        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

defaultproperties
{
    PatrolAnimNames[0]="Patrol_Overwatch1"
    PatrolAnimNames[1]="Patrol_Overwatch2"
    PatrolAnimNames[2]="Patrol_Overwatch3"
    PatrolAnimNames[3]="Patrol_Overwatch1"
    PatrolAnimNames[4]="Patrol_Overwatch2"
    PatrolAnimNames[5]="Patrol_Overwatch3"
    PatrolAnimNames[6]="Patrol_Talking1"
    PatrolAnimNames[7]="Patrol_Talking2"
    PatrolAnimNames[8]="Patrol_Talking3"
    PatrolAnimNames[9]="Patrol_Talking1"
    PatrolAnimNames[10]="Patrol_Talking2"
    PatrolAnimNames[11]="Patrol_Talking3"
    PatrolAnimNames[12]="Patrol_Talking1"
    PatrolAnimNames[13]="Patrol_Talking2"
    PatrolAnimNames[14]="IdleRelaxed1"
    PatrolAnimNames[15]="IdleRelaxed2"
    PatrolAnimNames[16]="IdleRelaxed3"
    PatrolAnimNames[17]="IdleRelaxed4"
    PatrolAnimNames[18]="IdleRelaxed1"
    PatrolAnimNames[19]="IdleRelaxed2"
    PatrolAnimNames[20]="IdleRelaxed3"
    PatrolAnimNames[21]="IdleRelaxed4"
}