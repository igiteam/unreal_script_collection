class SeqAct_SpGetObjFromList extends SequenceAction
    abstract
    native;

struct native MemberInfo
{
    var Actor member;
    var bool matched;
    var bool selected;

    structdefaultproperties
    {
        member=none
        matched=false
        selected=false
    }
};

var array<Actor> ActorList;
var array<MemberInfo> storedMembers;
var array<MemberInfo> newMembers;
