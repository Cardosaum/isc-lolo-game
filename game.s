.data
    .include "lolo.data"
    .include "map.data"
    .include "macros.s"

.text
MAIN:
    init()
    print_pixel(0, 0, 100)
    print_pixel(100, 0, 100)
    print_pixel(100, 100, 100)
    print_pixel(320, 240, 100)
    exit()
