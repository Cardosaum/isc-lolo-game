.include "macros.s"

.data
.include "../sprites/lolo/lolo_l.data"
.include "../sprites/lolo/lolo_n.data"
.include "../sprites/lolo/lolo_r.data"
.include "../sprites/lolo/lolo_u.data"
.include "../sprites/map/map.data"
.include "../sprites/map_1.data"
.include "../sprites/blocks/ground.data"
.include "constants.data"
.include "map_matrix_320x240.data"

.text
MAIN:
    init()

    keyboard_input()
    exit()


.include "ui.s"
.include "keyboard.s"
.include "utils.s"
.include "colisions.s"
.include "print_sprites.s"
