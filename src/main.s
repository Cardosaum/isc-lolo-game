.data
.include "map.data"        # inclui o .data com a imagem
.include "lolo.data"        # inclui o .data com a imagem

.text
MAIN:
# a1 = cwidth
# a2 = iwidth
# a3 = iheight
# a4 = base pixel (position)
# a5 = base image address
  li a0,0xFF000000
  li a1,320
  li a2,320
  li a3,240
  li a4,0
  la a5,map
  jal RENDER_IMAGE
  li a2,16
  li a3,16
  la a5,lolo
  jal RENDER_IMAGE
  jal EXIT

EXIT:
    li a7, 10
    ecall

#############################
# Start:                    #
# Procedure to render image #
#############################
  # arguments:
  # a0: frame to use (Frame0 or Frame1?)
  #     must be one of this two values
  #     [0xFF000000,0xFF100000]
  # a1: base address of the image
  # a2: which is the base address of the image?
  # a3: postition of the first pixel to print in the frame
  # a4: canvas width
  # a5: canvas height

  # variables:
  # s0: Pixel position in frame
  # t0: base image address
  # t1: images' number of lines
  # t2: images' number of columns
  # t3: counter (when the counter is equal
  #     to the final area 't4' we assume the
  #     rendering process is over)
  # t4: image area (product of t1 over t2: t4 = t1 x t2)
  # t5: temporary variable to load and store pixel data
  # t6: address of the first image pixel
#RENDER_IMAGE:
    #mv s1,ra              # save return address for later
    #add s0,a0,a3          # Select frame (either Frame0 or Frame1)
    #mv t0,a1              # endereço da imagem
    #lw t1,0(t0)           # número de linhas
    #lw t2,4(t0)           # número de colunas
    #li t3,0               # contador
    #mul t4,t1,t2          # numero total de pixels
    #addi t6,t0,8          # primeiro pixel da imagem
    #li s9,0               # column position (1..(t2))
#
#RENDER_IMAGE_LOOP:
    #lw t5,0(t6)           # Coloca a imagem no Frame0
    #sw t5,0(s0)
    #addi t6,t6,4
    #addi s0,s0,4
    #addi t3,t3,1
    #addi s9,s9,1
    #beq s9,t2,RENDER_IMAGE_NEXT_LINE
#RENDER_IMAGE_NEXT_LINE_RETURN:
    #bne t3,t4,RENDER_IMAGE_LOOP
    #ret
#
#RENDER_IMAGE_NEXT_LINE:
    #sub s8,a4,t2
    #add s9,s9,s8
    #li s9,0
    #j RENDER_IMAGE_NEXT_LINE_RETURN


# a0 = Frame address
# a1 = cwidth
# a2 = iwidth
# a3 = iheight
# a4 = base pixel (position)
# a5 = base image address
# s1 = iwidth*iheight (area to print)
# s2 = x
# s3 = y
# s5 = frame address
# s6 = frame position to store pixel
# t1 = n
# t2 = (current pixel to print)
# t3 = main_counter
# t4 = tmp var to load and store pixel data
# t5 = tmp var to load and store pixel data

RENDER_IMAGE:
  li t1,0 # initialize n to zero
  mv s2,a4 # initialize x to position
  mv s3,a4 # initialize y to position
  mul s1,a2,a3 # get area of the image to print
  add s6,a0,a4 # set first pixel position in frame

LOOP:
  addi t3,t3,1 # add counter
  add t2,a4,s2 # position + x
  mul t3,s3,a1 # y * cwidth
  add t2,t2,t3 # position + (y*cwidth) + x
  lw t4,(a5) # load pixel to store in frame
  slli t6,t2,2 # tmp var to adjust word boudary
  add t5,t6,s6 # set pixel position to store
  sw t4,(t5) # print pixel
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

EXIT_LOOP:
  ret

#############################
# End:                      #
# Procedure to render image #
#############################
