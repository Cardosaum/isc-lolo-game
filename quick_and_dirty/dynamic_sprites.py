#!/usr/bin/env python
from pprint import pprint

ds = []
lolo = {
    'current_position': (40, 40),
    'next_position': (120, 80),
    'sprite_image': range(200)
}

heart = {
    'current_position': (60, 30),
    'next_position': (60, 30),
    'sprite_image': range(200)
}

ds.append(lolo)
ds.append(heart)
print(len(ds))
print(ds)
