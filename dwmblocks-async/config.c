#include "config.h"

#include "block.h"
#include "util.h"

Block blocks[] = {
  //  command   interval signal
    //{"sb-mail",    600,   1 },
    //{"sb-music",   0,     2 },
    {"sb-updates",    1800, 1 },
    {"sb-brightness", 1,    2 },
    {"sb-loadavg",    1,    3 },
    {"sb-memory",     10,   4 },
    {"sb-disk",       1800, 5 },
    //{"sb-mic",      0,    6 },
    //{"sb-record",   0,    7 },
    {"sb-volume",     1,    6 },
    {"sb-wlan",       1,    7 },
    {"sb-battery",    5,    8 },
    {"sb-clock",      60,   9 },
    {"sb-date",       3600, 10},
};

const unsigned short blockCount = LEN(blocks);
