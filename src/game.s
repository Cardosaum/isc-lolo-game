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
.include "../sprites/map_level_1.data"
.include "../sprites/map_level_2.data"
.include "../sprites/map_level_3.data"
.include "../sprites/map_level_4.data"
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
.include "sprites_correspondences.data"
.include "music.data"
.include "map_matrix_1x1.data"
.include "../sprites/map_castle.data"
.include "../sprites/lolo_castle_up_0.data"
.include "../sprites/lolo_castle_up_1.data"
.include "../sprites/lolo_castle_up_2.data"
.include "../sprites/lolo_castle_up_3.data"
.include "../sprites/menu_option_1.data"
.include "../sprites/menu_option_2.data"
.include "../sprites/door_open.data"
.include "../sprites/door_closed.data"


.text
MAIN:
    init()
    jal MENU_INTERFACE
    #init_map_1()
    init_map(map_level_3,MAP_3_MATRIX)
    lolo_life_print()
    lolo_shot_print()
    lolo_map_print_test_heart()
    #lolo_life_print()
    #jal READ_CASTLE_DYNAMIC_MAP
    #jal GAME_LOLO_LOOP
    #jal PLAY_MUSIC
    #lolo_shot_print()
    #lolo_map_1_print_test_heart()
    #lolo_map_1_heart_reset()
    #lolo_map_1_heart_counter()
    #jal LOLO_MAP_1_PRINT_TEST_HEART
    #sleep(1000)
    #lolo_map_1_heart_reset()
    #jal LOLO_MAP_1_PRINT_TEST_HEART
    #lolo_map_1_heart_reset()
    #jal LOLO_MAP_1_PRINT_TEST_HEART

    keyboard_input()

    #sleep(200000)
    exit()


.include "ui.s"
.include "keyboard.s"
.include "utils.s"
.include "colisions.s"
.include "print_sprites.s"
.include "proc_life_power_lolo.s"
.include "proc_lolo_heart.s"
.include "initialize_dynamic_sprites.s"
#.include "read_map_matrix.s"
.include "castle.s"
.include "start.s"
.include "print_raw_combined_sprite.s"
.include "keyboard_input_key_movement.s"
.include "music.s"
.include "swap_frames.s"
.include "read_and_print_map_matrix_dynamic_sprites.s"
.include "heart_check_colision.s"
.include "select_map_matrix.s"
