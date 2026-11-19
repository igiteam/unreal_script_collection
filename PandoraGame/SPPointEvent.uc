class SPPointEvent extends Object;

var float Points;
var private Controller Scorer;

function ApplyPoints()
{
    //return;    
}

static function float GetPoints()
{
    return default.Points;
    //return ReturnValue;    
}

function Controller GetScorer()
{
    return Scorer;
    //return ReturnValue;    
}

function SetScorer(Controller theScorer)
{
    Scorer = theScorer;
    //return;    
}
