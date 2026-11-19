class SeqAct_SPSetKrakenTentacleAnimations extends SequenceAction;

enum AnimDescriptor
{
    DESC_Right,                     // 0
    DESC_Left,                      // 1
    DESC_MAX                        // 2
};

var() SeqAct_SPSetKrakenTentacleAnimations.AnimDescriptor AnimationDirection;
