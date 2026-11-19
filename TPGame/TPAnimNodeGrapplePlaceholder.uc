class TPAnimNodeGrapplePlaceholder extends AnimNodeSequence
    hidecategories(Display)
    hidecategories(Synch)
    hidecategories(AnimNodeSequence);

enum eXboxDPad {XboxDUp, XboxDDown, XboxDLeft, XboxDRight, XboxDAll};

struct AnimPair
{
    var() name PlayerAnim;
    var() name OpponentAnim;
    var() array<name> Exclusions;
};

struct Struggles
{
    var() AnimPair           AnimNameStruggle;
    var() array<AnimPair>    AnimNameBreak;
    var() array<AnimPair>    AnimNameKill;
};

struct Transitions
{
    var() AnimPair         AnimNameTrans;
    var() float            PositionOffset;
    var() array<Struggles> Struggle;

    structdefaultproperties
    {
        //From Maya
        PositionOffset=116.65f
    }
};

var(Front)  array<Transitions> FrontTransition;
var(Back)   array<Transitions> BackTransition;
var(Pistol) array<Transitions> PistolTransition;

