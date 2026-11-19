class NavAct_PlayExploreAnim extends NavAct_PlayCustomAnim
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EPOI_ExploreAnimType
{
    POI_TypeNone,                   // 0
    POI_WatchWall,                  // 1
    POI_Crouching,                  // 2
    POI_PointAtWall,                // 3
    POI_PointAtFloor,               // 4
    POI_PointAtCeiling,             // 5
    POI_ReadFromTablet,             // 6
    POI_MAX                         // 7
};

enum EPOI_ExploreAnim
{
    POI_AnimNone,                   // 0
    POI_Tourist1_WatchWall1,        // 1
    POI_Tourist1_WatchWall2,        // 2
    POI_Tourist1_WatchWall3,        // 3
    POI_Tourist1_WatchWall4,        // 4
    POI_Tourist1_Crouching1,        // 5
    POI_Tourist1_Crouching2,        // 6
    POI_Tourist1_Crouching3,        // 7
    POI_Tourist1_PointAtWall1,      // 8
    POI_Tourist1_PointAtWall2,      // 9
    POI_Tourist1_PointAtWall3,      // 10
    POI_Tourist1_PointAtWall4,      // 11
    POI_Tourist1_PointAtFloor1,     // 12
    POI_Tourist1_PointAtCeiling1,   // 13
    POI_Tourist1_PointAtCeiling2,   // 14
    POI_Tourist1_PointAtCeiling3,   // 15
    POI_Tourist1_PointAtCeiling4,   // 16
    POI_Tourist1_ReadFromTablet1,   // 17
    POI_Tourist1_ReadFromTablet2,   // 18
    POI_Tourist1_ReadFromTablet3,   // 19
    POI_MAX                         // 20
};

var array<string> ExploreAnimNames;
var() NavAct_PlayExploreAnim.EPOI_ExploreAnimType ExploreAnimType;
var() NavAct_PlayExploreAnim.EPOI_ExploreAnim ExploreAnim;

function int GetAnimationIndex()
{
    // End:0x29
    if(int(ExploreAnim) != int(0))
    {
        return int(ExploreAnim) - int(1);        
    }
    else
    {
        // End:0xA3
        if(int(ExploreAnimType) != int(0))
        {
            switch(ExploreAnimType)
            {
                // End:0x5D
                case 1:
                    return 0 + Rand(4);
                // End:0x6B
                case 2:
                    return 4 + Rand(3);
                // End:0x79
                case 3:
                    return 7 + Rand(4);
                // End:0x81
                case 4:
                    return 11;
                // End:0x8F
                case 5:
                    return 12 + Rand(4);
                // End:0x9D
                case 6:
                    return 16 + Rand(3);
                // End:0xFFFF
                default:
                    // End:0xA9
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
        AnimName = name(ExploreAnimNames[AnimationNameIndex]);
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
    ExploreAnimNames[0]="Tourist1_WatchWall1"
    ExploreAnimNames[1]="Tourist1_WatchWall2"
    ExploreAnimNames[2]="Tourist1_WatchWall3"
    ExploreAnimNames[3]="Tourist1_WatchWall4"
    ExploreAnimNames[4]="Tourist1_Crouching1"
    ExploreAnimNames[5]="Tourist1_Crouching2"
    ExploreAnimNames[6]="Tourist1_Crouching3"
    ExploreAnimNames[7]="Tourist1_PointAtWall1"
    ExploreAnimNames[8]="Tourist1_PointAtWall2"
    ExploreAnimNames[9]="Tourist1_PointAtWall3"
    ExploreAnimNames[10]="Tourist1_PointAtWall4"
    ExploreAnimNames[11]="Tourist1_PointAtFloor1"
    ExploreAnimNames[12]="Tourist1_PointAtCeiling1"
    ExploreAnimNames[13]="Tourist1_PointAtCeiling2"
    ExploreAnimNames[14]="Tourist1_PointAtCeiling3"
    ExploreAnimNames[15]="Tourist1_PointAtCeiling4"
    ExploreAnimNames[16]="Tourist1_ReadFromTablet1"
    ExploreAnimNames[17]="Tourist1_ReadFromTablet2"
    ExploreAnimNames[18]="Tourist1_ReadFromTablet3"
}