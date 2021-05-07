#!/usr/bin/env python
from pprint import pprint

ds = []
lolo = {
    'current_position': (40, 40),
    'next_position': (120, 80),
    'sprite_image': range(200),
    'collision': True
}

heart1 = {
    'current_position': (40, 40),
    'next_position': (120, 80),
    'sprite_image': range(200),
    'collision': True
}

heart2 = {
    'current_position': (40, 40),
    'next_position': (120, 80),
    'sprite_image': range(200),
    'collision': True
}

snake = {
    'current_position': (40, 40),
    'next_position': (120, 80),
    'sprite_image': range(200),
    'collision': True
}

ds.append(lolo)
ds.append(heart1)
ds.append(heart2)
ds.append(snake)
pprint(ds)
