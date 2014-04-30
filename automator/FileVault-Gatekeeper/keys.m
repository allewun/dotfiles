#import <Carbon/Carbon.h>
// `keys` utility for checking whether a modifier key is held
// From <http://lists.apple.com/archives/applescript-users/2009/Sep/msg00374.html>
//
// $ clang keys.m -framework Carbon -o keys
 
int main (int argc, const char * argv[]) {
    unsigned int modifiers = GetCurrentKeyModifiers();
 
    if (argc == 1)
        printf("%d\n", modifiers);
 
    else {
 
        int i, result = 1;
        for (i = 1; i < argc; ++i) {
 
            if (0 == strcmp(argv[i], "shift"))
                result = result && (modifiers & shiftKey);
 
            else if (0 == strcmp(argv[i], "option"))
                result = result && (modifiers & optionKey);
 
            else if (0 == strcmp(argv[i], "cmd"))
                result = result && (modifiers & cmdKey);
 
            else if (0 == strcmp(argv[i], "control"))
                result = result && (modifiers & controlKey);
 
            else if (0 == strcmp(argv[i], "capslock"))
                result = result && (modifiers & alphaLock);
 
        }
        printf("%d\n", result);
    }
    return 0;
}