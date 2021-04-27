from PIL import Image
from pprint import pprint

# a1 = cwidth
# a2 = iwidth
# a3 = iheight
# a4 = base pixel (position)
# a5 = base image address
# s1 = iwidth*iheight (area to print)
# s2 = x
# s3 = y
# s5 = frame address
# t1 = n
# t2 = (current pixel to print)
# t3 = main_counter
# t4 = tmp var to load and store pixel data

li t1,0 # initialize n to zero
li s2,a4 # initialize x to position
li s3,a4 # initialize y to position
mulu s1,a2,a3 # get area of the image to print
LOOP:
addi t3,t3,1 # add counter
add t2,a4,s2 # position + x
mulu t3,s3,a1 # y * cwidth
add t2,t2,t3 # position + (y*cwidth) + x
lw t4,(a5) # load pixel to store in frame
sw t4,t2(s5) # print pixel position t2
addi a5,a5,4 # set next pixel to read
addi t1,t1,1 # increment n by one (n += 1)
beq t1,a2,GET_PIXEL_NEXT_LINE # n reached the last pixel of this line,
                              # get position of pixel in next line
beq t3,s1,EXIT_LOOP # we are done, exit procedure
addi s2,s2,1 # increment x by one (x += 1)
j LOOP

GET_PIXEL_NEXT_LINE:
li t1,0
li s2,0
addi s3,s3,1
j LOOP



def p(cwidth, cheight, iwidth, iheight, position):
    img = Image.new('RGB', (cwidth, cheight))
    n = 0
    pos = []
    x = position
    y = position
    for i in range(iwidth*iheight):
        pos.append((x, y))
        print(position + (y*cwidth) + x)
        img.putpixel((x,y), (255, 0, 255))
        n += 1
        if n == iwidth:
            y += 1
            x = 0
            n = 0
        else:
            x += 1
    # pprint(pos)
    # print(len(pos))
    # print(img.tobytes())
    img.save('lolo.png')
    return img

lolo = p(320, 240, 16, 16, 0)
# lolo = p(320, 240, 320, 240, 0)
# lolo.show()
