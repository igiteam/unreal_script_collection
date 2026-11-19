class MOHAWhizManager extends Object
    native;

enum EWhizTypes
{
    WHIZ_NONE,                      // 0
    WHIZBY_EVENT,                   // 1
    GLASSHIT_EVENT,                 // 2
    WHIZ_BLANK,                     // 3
    WHIZ_EXTRA,                     // 4
    EWhizTypes_MAX                  // 5
};

var native const Pointer pimpl_;

// Export UMOHAWhizManager::execUpdate(FFrame&, void* const)
native static function Update(float Time);

// Export UMOHAWhizManager::execReset(FFrame&, void* const)
native static function Reset();
