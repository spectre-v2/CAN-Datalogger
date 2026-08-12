#pragma once

#include <stdio.h>

#if defined(DEBUGMSG) || defined(DEBUG)
    #define debugmsg(source, ...) do { \
        printf("[%s] ", source); \
        printf(__VA_ARGS__); \
        printf("\n"); \
    } while (0)
#else
    #define debugmsg(...) do { } while (0)
#endif
