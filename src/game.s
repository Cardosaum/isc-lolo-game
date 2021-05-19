.include "macros.s"

.data
.include "../sprites/lolo_l.data"
.include "../sprites/lolo_l_1.data"
.include "../sprites/lolo_l_2.data"
.include "../sprites/lolo_l_3.data"
.include "../sprites/lolo_l_4.data"
.include "../sprites/lolo_n.data"
.include "../sprites/lolo_n_1.data"
.include "../sprites/lolo_n_2.data"
.include "../sprites/lolo_n_3.data"
.include "../sprites/lolo_n_4.data"
.include "../sprites/lolo_r.data"
.include "../sprites/lolo_r_1.data"
.include "../sprites/lolo_r_2.data"
.include "../sprites/lolo_r_3.data"
.include "../sprites/lolo_r_4.data"
.include "../sprites/lolo_u.data"
.include "../sprites/lolo_u_1.data"
.include "../sprites/lolo_u_2.data"
.include "../sprites/lolo_u_3.data"
.include "../sprites/lolo_u_4.data"
.include "../sprites/lolo_combined.data"
.include "../sprites/map/map.data"
.include "../sprites/map_1.data"
.include "../sprites/chest_closed.data"
.include "../sprites/heart.data"
.include "../sprites/snake_l_1.data"
.include "../sprites/snake_l_2.data"
.include "../sprites/snake_r_1.data"
.include "../sprites/snake_r_2.data"
.include "../sprites/blocks/ground.data"
.include "../sprites/life_number_5.data"
.include "../sprites/life_number_4.data"
.include "../sprites/life_number_3.data"
.include "../sprites/life_number_2.data"
.include "../sprites/life_number_1.data"
.include "../sprites/life_number_0.data"
.include "constants.data"
.include "map_matrix_1x1.data"
.include "../sprites/map_castle.data"
.include "../sprites/lolo_castle_up_0.data"
.include "../sprites/lolo_castle_up_1.data"
.include "../sprites/lolo_castle_up_2.data"
.include "../sprites/lolo_castle_up_3.data"
.include "../sprites/menu_option_1.data"
.include "../sprites/menu_option_2.data"

.text
MAIN:
    init()
    jal MENU_INTERFACE
    #sleep(2000)
    #jal READ_CASTLE_DYNAMIC_MAP
    #sleep(10000)
    #jal GAME_LOLO_LOOP
    #sleep(10000)
    
    init_map_1()
    lolo_life_print()
    #jal READ_CASTLE_DYNAMIC_MAP
    #jal GAME_LOLO_INTRO
    keyboard_input()
    #sleep(200000)
    exit()


.include "ui.s"
.include "keyboard.s"
.include "utils.s"
.include "colisions.s"
.include "print_sprites.s"
.include "proc_life_lolo.s"
.include "initialize_dynamic_sprites.s"
#.include "read_map_matrix.s"
.include "castle.s"
.include "start.s"
.include "print_raw_combined_sprite.s"
.include "music.s"
