
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00007797          	auipc	a5,0x7
      12:	63a78793          	addi	a5,a5,1594 # 7648 <malloc+0x2696>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	2e1040ef          	jal	4b26 <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	04a50513          	addi	a0,a0,74 # 50b0 <malloc+0xfe>
      6e:	691040ef          	jal	4efe <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	273040ef          	jal	4ae6 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	0000a797          	auipc	a5,0xa
      7c:	4f078793          	addi	a5,a5,1264 # a568 <uninit>
      80:	0000d697          	auipc	a3,0xd
      84:	bf868693          	addi	a3,a3,-1032 # cc78 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	03050513          	addi	a0,a0,48 # 50d0 <malloc+0x11e>
      a8:	657040ef          	jal	4efe <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	239040ef          	jal	4ae6 <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	02850513          	addi	a0,a0,40 # 50e8 <malloc+0x136>
      c8:	25f040ef          	jal	4b26 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	23f040ef          	jal	4b0e <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	03250513          	addi	a0,a0,50 # 5108 <malloc+0x156>
      de:	249040ef          	jal	4b26 <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	ffe50513          	addi	a0,a0,-2 # 50f0 <malloc+0x13e>
      fa:	605040ef          	jal	4efe <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	1e7040ef          	jal	4ae6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	01250513          	addi	a0,a0,18 # 5118 <malloc+0x166>
     10e:	5f1040ef          	jal	4efe <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	1d3040ef          	jal	4ae6 <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	01850513          	addi	a0,a0,24 # 5140 <malloc+0x18e>
     130:	207040ef          	jal	4b36 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	00850513          	addi	a0,a0,8 # 5140 <malloc+0x18e>
     140:	1e7040ef          	jal	4b26 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	00858593          	addi	a1,a1,8 # 5150 <malloc+0x19e>
     150:	1b7040ef          	jal	4b06 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	fe850513          	addi	a0,a0,-24 # 5140 <malloc+0x18e>
     160:	1c7040ef          	jal	4b26 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	ff058593          	addi	a1,a1,-16 # 5158 <malloc+0x1a6>
     170:	8526                	mv	a0,s1
     172:	195040ef          	jal	4b06 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	fc450513          	addi	a0,a0,-60 # 5140 <malloc+0x18e>
     184:	1b3040ef          	jal	4b36 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	185040ef          	jal	4b0e <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	17f040ef          	jal	4b0e <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	fba50513          	addi	a0,a0,-70 # 5160 <malloc+0x1ae>
     1ae:	551040ef          	jal	4efe <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	133040ef          	jal	4ae6 <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	143040ef          	jal	4b26 <open>
    close(fd);
     1e8:	127040ef          	jal	4b0e <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	125040ef          	jal	4b36 <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	f4450513          	addi	a0,a0,-188 # 5188 <malloc+0x1d6>
     24c:	0eb040ef          	jal	4b36 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	f34a8a93          	addi	s5,s5,-204 # 5188 <malloc+0x1d6>
      int cc = write(fd, buf, sz);
     25c:	0000da17          	auipc	s4,0xd
     260:	a1ca0a13          	addi	s4,s4,-1508 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x5b5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	0b7040ef          	jal	4b26 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	089040ef          	jal	4b06 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	079040ef          	jal	4b06 <write>
      if(cc != sz){
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	077040ef          	jal	4b0e <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	099040ef          	jal	4b36 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	ed650513          	addi	a0,a0,-298 # 5198 <malloc+0x1e6>
     2ca:	435040ef          	jal	4efe <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	017040ef          	jal	4ae6 <exit>
      if(cc != sz){
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	edc50513          	addi	a0,a0,-292 # 51b8 <malloc+0x206>
     2e4:	41b040ef          	jal	4efe <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	7fc040ef          	jal	4ae6 <exit>

00000000000002ee <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2ee:	7179                	addi	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     2fe:	00005517          	auipc	a0,0x5
     302:	ed250513          	addi	a0,a0,-302 # 51d0 <malloc+0x21e>
     306:	031040ef          	jal	4b36 <unlink>
     30a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	ec298993          	addi	s3,s3,-318 # 51d0 <malloc+0x21e>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	005040ef          	jal	4b26 <open>
     326:	84aa                	mv	s1,a0
    if(fd < 0){
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	7d6040ef          	jal	4b06 <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	7d8040ef          	jal	4b0e <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	7fa040ef          	jal	4b36 <unlink>
  for(int i = 0; i < assumed_free; i++){
     340:	397d                	addiw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	e8650513          	addi	a0,a0,-378 # 51d0 <malloc+0x21e>
     352:	7d4040ef          	jal	4b26 <open>
     356:	84aa                	mv	s1,a0
  if(fd < 0){
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	dfa58593          	addi	a1,a1,-518 # 5158 <malloc+0x1a6>
     366:	7a0040ef          	jal	4b06 <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	e8050513          	addi	a0,a0,-384 # 51f0 <malloc+0x23e>
     378:	387040ef          	jal	4efe <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	768040ef          	jal	4ae6 <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	e5650513          	addi	a0,a0,-426 # 51d8 <malloc+0x226>
     38a:	375040ef          	jal	4efe <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	756040ef          	jal	4ae6 <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	e4450513          	addi	a0,a0,-444 # 51d8 <malloc+0x226>
     39c:	363040ef          	jal	4efe <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	744040ef          	jal	4ae6 <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	766040ef          	jal	4b0e <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	e2450513          	addi	a0,a0,-476 # 51d0 <malloc+0x21e>
     3b4:	782040ef          	jal	4b36 <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	72c040ef          	jal	4ae6 <exit>

00000000000003be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3be:	715d                	addi	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3ce:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d2:	40000993          	li	s3,1024
    name[0] = 'z';
     3d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3de:	41f4d71b          	sraiw	a4,s1,0x1f
     3e2:	01b7571b          	srliw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraiw	a3,a5,0x5
     3ee:	0306869b          	addiw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f6:	8bfd                	andi	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addiw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     406:	fb040513          	addi	a0,s0,-80
     40a:	72c040ef          	jal	4b36 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	addi	a0,s0,-80
     416:	710040ef          	jal	4b26 <open>
    if(fd < 0){
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     41e:	6f0040ef          	jal	4b0e <close>
  for(int i = 0; i < nzz; i++){
     422:	2485                	addiw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     42e:	40000993          	li	s3,1024
    name[0] = 'z';
     432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43a:	41f4d71b          	sraiw	a4,s1,0x1f
     43e:	01b7571b          	srliw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraiw	a3,a5,0x5
     44a:	0306869b          	addiw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     452:	8bfd                	andi	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addiw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     45e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     462:	fb040513          	addi	a0,s0,-80
     466:	6d0040ef          	jal	4b36 <unlink>
  for(int i = 0; i < nzz; i++){
     46a:	2485                	addiw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
  }
}
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	addi	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
{
     47e:	7159                	addi	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     490:	00007797          	auipc	a5,0x7
     494:	1b878793          	addi	a5,a5,440 # 7648 <malloc+0x2696>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4b6:	f9840913          	addi	s2,s0,-104
     4ba:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4be:	00005a17          	auipc	s4,0x5
     4c2:	d42a0a13          	addi	s4,s4,-702 # 5200 <malloc+0x24e>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	656040ef          	jal	4b26 <open>
     4d4:	84aa                	mv	s1,a0
    if(fd < 0){
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	628040ef          	jal	4b06 <write>
    if(n >= 0){
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	626040ef          	jal	4b0e <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	648040ef          	jal	4b36 <unlink>
    n = write(1, (char*)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	60e040ef          	jal	4b06 <write>
    if(n > 0){
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if(pipe(fds) < 0){
     500:	f9040513          	addi	a0,s0,-112
     504:	5f2040ef          	jal	4af6 <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	5f2040ef          	jal	4b06 <write>
    if(n > 0){
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	5ee040ef          	jal	4b0e <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	5e6040ef          	jal	4b0e <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     52c:	0921                	addi	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
}
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	addi	sp,sp,112
     542:	8082                	ret
      printf("open(copyin1) failed\n");
     544:	00005517          	auipc	a0,0x5
     548:	cc450513          	addi	a0,a0,-828 # 5208 <malloc+0x256>
     54c:	1b3040ef          	jal	4efe <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	594040ef          	jal	4ae6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	cc650513          	addi	a0,a0,-826 # 5220 <malloc+0x26e>
     562:	19d040ef          	jal	4efe <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	57e040ef          	jal	4ae6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	ce050513          	addi	a0,a0,-800 # 5250 <malloc+0x29e>
     578:	187040ef          	jal	4efe <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	568040ef          	jal	4ae6 <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	cfe50513          	addi	a0,a0,-770 # 5280 <malloc+0x2ce>
     58a:	175040ef          	jal	4efe <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	556040ef          	jal	4ae6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	cf850513          	addi	a0,a0,-776 # 5290 <malloc+0x2de>
     5a0:	15f040ef          	jal	4efe <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	540040ef          	jal	4ae6 <exit>

00000000000005aa <copyout>:
{
     5aa:	7119                	addi	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	addi	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5be:	00007797          	auipc	a5,0x7
     5c2:	08a78793          	addi	a5,a5,138 # 7648 <malloc+0x2696>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5ea:	f9040913          	addi	s2,s0,-112
     5ee:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	ccea0a13          	addi	s4,s4,-818 # 52c0 <malloc+0x30e>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	b5ea8a93          	addi	s5,s5,-1186 # 5158 <malloc+0x1a6>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	51c040ef          	jal	4b26 <open>
     60e:	84aa                	mv	s1,a0
    if(fd < 0){
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	4e6040ef          	jal	4afe <read>
    if(n > 0){
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	4ec040ef          	jal	4b0e <close>
    if(pipe(fds) < 0){
     626:	f8840513          	addi	a0,s0,-120
     62a:	4cc040ef          	jal	4af6 <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	4cc040ef          	jal	4b06 <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	4b2040ef          	jal	4afe <read>
    if(n > 0){
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	4b6040ef          	jal	4b0e <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	4ae040ef          	jal	4b0e <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     664:	0921                	addi	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
}
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	addi	sp,sp,128
     67c:	8082                	ret
      printf("open(README) failed\n");
     67e:	00005517          	auipc	a0,0x5
     682:	c4a50513          	addi	a0,a0,-950 # 52c8 <malloc+0x316>
     686:	079040ef          	jal	4efe <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	45a040ef          	jal	4ae6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	c4c50513          	addi	a0,a0,-948 # 52e0 <malloc+0x32e>
     69c:	063040ef          	jal	4efe <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	444040ef          	jal	4ae6 <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	bda50513          	addi	a0,a0,-1062 # 5280 <malloc+0x2ce>
     6ae:	051040ef          	jal	4efe <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	432040ef          	jal	4ae6 <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	c5850513          	addi	a0,a0,-936 # 5310 <malloc+0x35e>
     6c0:	03f040ef          	jal	4efe <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	420040ef          	jal	4ae6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	c5a50513          	addi	a0,a0,-934 # 5328 <malloc+0x376>
     6d6:	029040ef          	jal	4efe <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	40a040ef          	jal	4ae6 <exit>

00000000000006e0 <truncate1>:
{
     6e0:	711d                	addi	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	addi	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	a4c50513          	addi	a0,a0,-1460 # 5140 <malloc+0x18e>
     6fc:	43a040ef          	jal	4b36 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	a3c50513          	addi	a0,a0,-1476 # 5140 <malloc+0x18e>
     70c:	41a040ef          	jal	4b26 <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	a3c58593          	addi	a1,a1,-1476 # 5150 <malloc+0x19e>
     71c:	3ea040ef          	jal	4b06 <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	3ec040ef          	jal	4b0e <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	a1850513          	addi	a0,a0,-1512 # 5140 <malloc+0x18e>
     730:	3f6040ef          	jal	4b26 <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	addi	a1,s0,-96
     73e:	3c0040ef          	jal	4afe <read>
  if(n != 4){
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	9f450513          	addi	a0,a0,-1548 # 5140 <malloc+0x18e>
     754:	3d2040ef          	jal	4b26 <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	9e450513          	addi	a0,a0,-1564 # 5140 <malloc+0x18e>
     764:	3c2040ef          	jal	4b26 <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	addi	a1,s0,-96
     772:	38c040ef          	jal	4afe <read>
     776:	8a2a                	mv	s4,a0
  if(n != 0){
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	addi	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	37a040ef          	jal	4afe <read>
     788:	8a2a                	mv	s4,a0
  if(n != 0){
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	c2a58593          	addi	a1,a1,-982 # 53b8 <malloc+0x406>
     796:	854e                	mv	a0,s3
     798:	36e040ef          	jal	4b06 <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	addi	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	358040ef          	jal	4afe <read>
  if(n != 6){
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	addi	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	344040ef          	jal	4afe <read>
  if(n != 2){
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	97c50513          	addi	a0,a0,-1668 # 5140 <malloc+0x18e>
     7cc:	36a040ef          	jal	4b36 <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	33c040ef          	jal	4b0e <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	336040ef          	jal	4b0e <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	330040ef          	jal	4b0e <close>
}
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	addi	sp,sp,96
     7f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	b6050513          	addi	a0,a0,-1184 # 5358 <malloc+0x3a6>
     800:	6fe040ef          	jal	4efe <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	2e0040ef          	jal	4ae6 <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	b6c50513          	addi	a0,a0,-1172 # 5378 <malloc+0x3c6>
     814:	6ea040ef          	jal	4efe <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	b6c50513          	addi	a0,a0,-1172 # 5388 <malloc+0x3d6>
     824:	6da040ef          	jal	4efe <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	2bc040ef          	jal	4ae6 <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	b7850513          	addi	a0,a0,-1160 # 53a8 <malloc+0x3f6>
     838:	6c6040ef          	jal	4efe <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	b4850513          	addi	a0,a0,-1208 # 5388 <malloc+0x3d6>
     848:	6b6040ef          	jal	4efe <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	298040ef          	jal	4ae6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	b6a50513          	addi	a0,a0,-1174 # 53c0 <malloc+0x40e>
     85e:	6a0040ef          	jal	4efe <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	282040ef          	jal	4ae6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	b7450513          	addi	a0,a0,-1164 # 53e0 <malloc+0x42e>
     874:	68a040ef          	jal	4efe <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	26c040ef          	jal	4ae6 <exit>

000000000000087e <writetest>:
{
     87e:	7139                	addi	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	addi	s0,sp,64
     892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	b6850513          	addi	a0,a0,-1176 # 5400 <malloc+0x44e>
     8a0:	286040ef          	jal	4b26 <open>
  if(fd < 0){
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ac:	00005997          	auipc	s3,0x5
     8b0:	b7c98993          	addi	s3,s3,-1156 # 5428 <malloc+0x476>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	baca8a93          	addi	s5,s5,-1108 # 5460 <malloc+0x4ae>
  for(i = 0; i < N; i++){
     8bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	240040ef          	jal	4b06 <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	230040ef          	jal	4b06 <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for(i = 0; i < N; i++){
     8e0:	2485                	addiw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	226040ef          	jal	4b0e <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	b1250513          	addi	a0,a0,-1262 # 5400 <malloc+0x44e>
     8f6:	230040ef          	jal	4b26 <open>
     8fa:	84aa                	mv	s1,a0
  if(fd < 0){
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     900:	7d000613          	li	a2,2000
     904:	0000c597          	auipc	a1,0xc
     908:	37458593          	addi	a1,a1,884 # cc78 <buf>
     90c:	1f2040ef          	jal	4afe <read>
  if(i != N*SZ*2){
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	1f4040ef          	jal	4b0e <close>
  if(unlink("small") < 0){
     91e:	00005517          	auipc	a0,0x5
     922:	ae250513          	addi	a0,a0,-1310 # 5400 <malloc+0x44e>
     926:	210040ef          	jal	4b36 <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
}
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	addi	sp,sp,64
     940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	ac450513          	addi	a0,a0,-1340 # 5408 <malloc+0x456>
     94c:	5b2040ef          	jal	4efe <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	194040ef          	jal	4ae6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	ade50513          	addi	a0,a0,-1314 # 5438 <malloc+0x486>
     962:	59c040ef          	jal	4efe <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	17e040ef          	jal	4ae6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	b0050513          	addi	a0,a0,-1280 # 5470 <malloc+0x4be>
     978:	586040ef          	jal	4efe <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	168040ef          	jal	4ae6 <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	b1450513          	addi	a0,a0,-1260 # 5498 <malloc+0x4e6>
     98c:	572040ef          	jal	4efe <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	154040ef          	jal	4ae6 <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	b2050513          	addi	a0,a0,-1248 # 54b8 <malloc+0x506>
     9a0:	55e040ef          	jal	4efe <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	140040ef          	jal	4ae6 <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	b2450513          	addi	a0,a0,-1244 # 54d0 <malloc+0x51e>
     9b4:	54a040ef          	jal	4efe <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	12c040ef          	jal	4ae6 <exit>

00000000000009be <writebig>:
{
     9be:	7139                	addi	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	addi	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	b1a50513          	addi	a0,a0,-1254 # 54f0 <malloc+0x53e>
     9de:	148040ef          	jal	4b26 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000c917          	auipc	s2,0xc
     9ea:	29290913          	addi	s2,s2,658 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054463          	bltz	a0,a5a <writebig+0x9c>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	104040ef          	jal	4b06 <write>
     a06:	40000793          	li	a5,1024
     a0a:	06f51263          	bne	a0,a5,a6e <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a0e:	2485                	addiw	s1,s1,1
     a10:	ff4493e3          	bne	s1,s4,9f6 <writebig+0x38>
  close(fd);
     a14:	854e                	mv	a0,s3
     a16:	0f8040ef          	jal	4b0e <close>
  fd = open("big", O_RDONLY);
     a1a:	4581                	li	a1,0
     a1c:	00005517          	auipc	a0,0x5
     a20:	ad450513          	addi	a0,a0,-1324 # 54f0 <malloc+0x53e>
     a24:	102040ef          	jal	4b26 <open>
     a28:	89aa                	mv	s3,a0
  n = 0;
     a2a:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2c:	0000c917          	auipc	s2,0xc
     a30:	24c90913          	addi	s2,s2,588 # cc78 <buf>
  if(fd < 0){
     a34:	04054863          	bltz	a0,a84 <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a38:	40000613          	li	a2,1024
     a3c:	85ca                	mv	a1,s2
     a3e:	854e                	mv	a0,s3
     a40:	0be040ef          	jal	4afe <read>
    if(i == 0){
     a44:	c931                	beqz	a0,a98 <writebig+0xda>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	08f51a63          	bne	a0,a5,ade <writebig+0x120>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0a969163          	bne	a3,s1,af4 <writebig+0x136>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	b7c5                	j	a38 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	a9c50513          	addi	a0,a0,-1380 # 54f8 <malloc+0x546>
     a64:	49a040ef          	jal	4efe <printf>
    exit(1);
     a68:	4505                	li	a0,1
     a6a:	07c040ef          	jal	4ae6 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a6e:	8626                	mv	a2,s1
     a70:	85d6                	mv	a1,s5
     a72:	00005517          	auipc	a0,0x5
     a76:	aa650513          	addi	a0,a0,-1370 # 5518 <malloc+0x566>
     a7a:	484040ef          	jal	4efe <printf>
      exit(1);
     a7e:	4505                	li	a0,1
     a80:	066040ef          	jal	4ae6 <exit>
    printf("%s: error: open big failed!\n", s);
     a84:	85d6                	mv	a1,s5
     a86:	00005517          	auipc	a0,0x5
     a8a:	aba50513          	addi	a0,a0,-1350 # 5540 <malloc+0x58e>
     a8e:	470040ef          	jal	4efe <printf>
    exit(1);
     a92:	4505                	li	a0,1
     a94:	052040ef          	jal	4ae6 <exit>
      if(n != MAXFILE){
     a98:	10c00793          	li	a5,268
     a9c:	02f49663          	bne	s1,a5,ac8 <writebig+0x10a>
  close(fd);
     aa0:	854e                	mv	a0,s3
     aa2:	06c040ef          	jal	4b0e <close>
  if(unlink("big") < 0){
     aa6:	00005517          	auipc	a0,0x5
     aaa:	a4a50513          	addi	a0,a0,-1462 # 54f0 <malloc+0x53e>
     aae:	088040ef          	jal	4b36 <unlink>
     ab2:	04054c63          	bltz	a0,b0a <writebig+0x14c>
}
     ab6:	70e2                	ld	ra,56(sp)
     ab8:	7442                	ld	s0,48(sp)
     aba:	74a2                	ld	s1,40(sp)
     abc:	7902                	ld	s2,32(sp)
     abe:	69e2                	ld	s3,24(sp)
     ac0:	6a42                	ld	s4,16(sp)
     ac2:	6aa2                	ld	s5,8(sp)
     ac4:	6121                	addi	sp,sp,64
     ac6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ac8:	8626                	mv	a2,s1
     aca:	85d6                	mv	a1,s5
     acc:	00005517          	auipc	a0,0x5
     ad0:	a9450513          	addi	a0,a0,-1388 # 5560 <malloc+0x5ae>
     ad4:	42a040ef          	jal	4efe <printf>
        exit(1);
     ad8:	4505                	li	a0,1
     ada:	00c040ef          	jal	4ae6 <exit>
      printf("%s: read failed %d\n", s, i);
     ade:	862a                	mv	a2,a0
     ae0:	85d6                	mv	a1,s5
     ae2:	00005517          	auipc	a0,0x5
     ae6:	aa650513          	addi	a0,a0,-1370 # 5588 <malloc+0x5d6>
     aea:	414040ef          	jal	4efe <printf>
      exit(1);
     aee:	4505                	li	a0,1
     af0:	7f7030ef          	jal	4ae6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     af4:	8626                	mv	a2,s1
     af6:	85d6                	mv	a1,s5
     af8:	00005517          	auipc	a0,0x5
     afc:	aa850513          	addi	a0,a0,-1368 # 55a0 <malloc+0x5ee>
     b00:	3fe040ef          	jal	4efe <printf>
      exit(1);
     b04:	4505                	li	a0,1
     b06:	7e1030ef          	jal	4ae6 <exit>
    printf("%s: unlink big failed\n", s);
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	abc50513          	addi	a0,a0,-1348 # 55c8 <malloc+0x616>
     b14:	3ea040ef          	jal	4efe <printf>
    exit(1);
     b18:	4505                	li	a0,1
     b1a:	7cd030ef          	jal	4ae6 <exit>

0000000000000b1e <unlinkread>:
{
     b1e:	7179                	addi	sp,sp,-48
     b20:	f406                	sd	ra,40(sp)
     b22:	f022                	sd	s0,32(sp)
     b24:	ec26                	sd	s1,24(sp)
     b26:	e84a                	sd	s2,16(sp)
     b28:	e44e                	sd	s3,8(sp)
     b2a:	1800                	addi	s0,sp,48
     b2c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b2e:	20200593          	li	a1,514
     b32:	00005517          	auipc	a0,0x5
     b36:	aae50513          	addi	a0,a0,-1362 # 55e0 <malloc+0x62e>
     b3a:	7ed030ef          	jal	4b26 <open>
  if(fd < 0){
     b3e:	0a054f63          	bltz	a0,bfc <unlinkread+0xde>
     b42:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b44:	4615                	li	a2,5
     b46:	00005597          	auipc	a1,0x5
     b4a:	aca58593          	addi	a1,a1,-1334 # 5610 <malloc+0x65e>
     b4e:	7b9030ef          	jal	4b06 <write>
  close(fd);
     b52:	8526                	mv	a0,s1
     b54:	7bb030ef          	jal	4b0e <close>
  fd = open("unlinkread", O_RDWR);
     b58:	4589                	li	a1,2
     b5a:	00005517          	auipc	a0,0x5
     b5e:	a8650513          	addi	a0,a0,-1402 # 55e0 <malloc+0x62e>
     b62:	7c5030ef          	jal	4b26 <open>
     b66:	84aa                	mv	s1,a0
  if(fd < 0){
     b68:	0a054463          	bltz	a0,c10 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b6c:	00005517          	auipc	a0,0x5
     b70:	a7450513          	addi	a0,a0,-1420 # 55e0 <malloc+0x62e>
     b74:	7c3030ef          	jal	4b36 <unlink>
     b78:	e555                	bnez	a0,c24 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7a:	20200593          	li	a1,514
     b7e:	00005517          	auipc	a0,0x5
     b82:	a6250513          	addi	a0,a0,-1438 # 55e0 <malloc+0x62e>
     b86:	7a1030ef          	jal	4b26 <open>
     b8a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b8c:	460d                	li	a2,3
     b8e:	00005597          	auipc	a1,0x5
     b92:	aca58593          	addi	a1,a1,-1334 # 5658 <malloc+0x6a6>
     b96:	771030ef          	jal	4b06 <write>
  close(fd1);
     b9a:	854a                	mv	a0,s2
     b9c:	773030ef          	jal	4b0e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba0:	660d                	lui	a2,0x3
     ba2:	0000c597          	auipc	a1,0xc
     ba6:	0d658593          	addi	a1,a1,214 # cc78 <buf>
     baa:	8526                	mv	a0,s1
     bac:	753030ef          	jal	4afe <read>
     bb0:	4795                	li	a5,5
     bb2:	08f51363          	bne	a0,a5,c38 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bb6:	0000c717          	auipc	a4,0xc
     bba:	0c274703          	lbu	a4,194(a4) # cc78 <buf>
     bbe:	06800793          	li	a5,104
     bc2:	08f71563          	bne	a4,a5,c4c <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bc6:	4629                	li	a2,10
     bc8:	0000c597          	auipc	a1,0xc
     bcc:	0b058593          	addi	a1,a1,176 # cc78 <buf>
     bd0:	8526                	mv	a0,s1
     bd2:	735030ef          	jal	4b06 <write>
     bd6:	47a9                	li	a5,10
     bd8:	08f51463          	bne	a0,a5,c60 <unlinkread+0x142>
  close(fd);
     bdc:	8526                	mv	a0,s1
     bde:	731030ef          	jal	4b0e <close>
  unlink("unlinkread");
     be2:	00005517          	auipc	a0,0x5
     be6:	9fe50513          	addi	a0,a0,-1538 # 55e0 <malloc+0x62e>
     bea:	74d030ef          	jal	4b36 <unlink>
}
     bee:	70a2                	ld	ra,40(sp)
     bf0:	7402                	ld	s0,32(sp)
     bf2:	64e2                	ld	s1,24(sp)
     bf4:	6942                	ld	s2,16(sp)
     bf6:	69a2                	ld	s3,8(sp)
     bf8:	6145                	addi	sp,sp,48
     bfa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     bfc:	85ce                	mv	a1,s3
     bfe:	00005517          	auipc	a0,0x5
     c02:	9f250513          	addi	a0,a0,-1550 # 55f0 <malloc+0x63e>
     c06:	2f8040ef          	jal	4efe <printf>
    exit(1);
     c0a:	4505                	li	a0,1
     c0c:	6db030ef          	jal	4ae6 <exit>
    printf("%s: open unlinkread failed\n", s);
     c10:	85ce                	mv	a1,s3
     c12:	00005517          	auipc	a0,0x5
     c16:	a0650513          	addi	a0,a0,-1530 # 5618 <malloc+0x666>
     c1a:	2e4040ef          	jal	4efe <printf>
    exit(1);
     c1e:	4505                	li	a0,1
     c20:	6c7030ef          	jal	4ae6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c24:	85ce                	mv	a1,s3
     c26:	00005517          	auipc	a0,0x5
     c2a:	a1250513          	addi	a0,a0,-1518 # 5638 <malloc+0x686>
     c2e:	2d0040ef          	jal	4efe <printf>
    exit(1);
     c32:	4505                	li	a0,1
     c34:	6b3030ef          	jal	4ae6 <exit>
    printf("%s: unlinkread read failed", s);
     c38:	85ce                	mv	a1,s3
     c3a:	00005517          	auipc	a0,0x5
     c3e:	a2650513          	addi	a0,a0,-1498 # 5660 <malloc+0x6ae>
     c42:	2bc040ef          	jal	4efe <printf>
    exit(1);
     c46:	4505                	li	a0,1
     c48:	69f030ef          	jal	4ae6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c4c:	85ce                	mv	a1,s3
     c4e:	00005517          	auipc	a0,0x5
     c52:	a3250513          	addi	a0,a0,-1486 # 5680 <malloc+0x6ce>
     c56:	2a8040ef          	jal	4efe <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	68b030ef          	jal	4ae6 <exit>
    printf("%s: unlinkread write failed\n", s);
     c60:	85ce                	mv	a1,s3
     c62:	00005517          	auipc	a0,0x5
     c66:	a3e50513          	addi	a0,a0,-1474 # 56a0 <malloc+0x6ee>
     c6a:	294040ef          	jal	4efe <printf>
    exit(1);
     c6e:	4505                	li	a0,1
     c70:	677030ef          	jal	4ae6 <exit>

0000000000000c74 <linktest>:
{
     c74:	1101                	addi	sp,sp,-32
     c76:	ec06                	sd	ra,24(sp)
     c78:	e822                	sd	s0,16(sp)
     c7a:	e426                	sd	s1,8(sp)
     c7c:	e04a                	sd	s2,0(sp)
     c7e:	1000                	addi	s0,sp,32
     c80:	892a                	mv	s2,a0
  unlink("lf1");
     c82:	00005517          	auipc	a0,0x5
     c86:	a3e50513          	addi	a0,a0,-1474 # 56c0 <malloc+0x70e>
     c8a:	6ad030ef          	jal	4b36 <unlink>
  unlink("lf2");
     c8e:	00005517          	auipc	a0,0x5
     c92:	a3a50513          	addi	a0,a0,-1478 # 56c8 <malloc+0x716>
     c96:	6a1030ef          	jal	4b36 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9a:	20200593          	li	a1,514
     c9e:	00005517          	auipc	a0,0x5
     ca2:	a2250513          	addi	a0,a0,-1502 # 56c0 <malloc+0x70e>
     ca6:	681030ef          	jal	4b26 <open>
  if(fd < 0){
     caa:	0c054f63          	bltz	a0,d88 <linktest+0x114>
     cae:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb0:	4615                	li	a2,5
     cb2:	00005597          	auipc	a1,0x5
     cb6:	95e58593          	addi	a1,a1,-1698 # 5610 <malloc+0x65e>
     cba:	64d030ef          	jal	4b06 <write>
     cbe:	4795                	li	a5,5
     cc0:	0cf51e63          	bne	a0,a5,d9c <linktest+0x128>
  close(fd);
     cc4:	8526                	mv	a0,s1
     cc6:	649030ef          	jal	4b0e <close>
  if(link("lf1", "lf2") < 0){
     cca:	00005597          	auipc	a1,0x5
     cce:	9fe58593          	addi	a1,a1,-1538 # 56c8 <malloc+0x716>
     cd2:	00005517          	auipc	a0,0x5
     cd6:	9ee50513          	addi	a0,a0,-1554 # 56c0 <malloc+0x70e>
     cda:	66d030ef          	jal	4b46 <link>
     cde:	0c054963          	bltz	a0,db0 <linktest+0x13c>
  unlink("lf1");
     ce2:	00005517          	auipc	a0,0x5
     ce6:	9de50513          	addi	a0,a0,-1570 # 56c0 <malloc+0x70e>
     cea:	64d030ef          	jal	4b36 <unlink>
  if(open("lf1", 0) >= 0){
     cee:	4581                	li	a1,0
     cf0:	00005517          	auipc	a0,0x5
     cf4:	9d050513          	addi	a0,a0,-1584 # 56c0 <malloc+0x70e>
     cf8:	62f030ef          	jal	4b26 <open>
     cfc:	0c055463          	bgez	a0,dc4 <linktest+0x150>
  fd = open("lf2", 0);
     d00:	4581                	li	a1,0
     d02:	00005517          	auipc	a0,0x5
     d06:	9c650513          	addi	a0,a0,-1594 # 56c8 <malloc+0x716>
     d0a:	61d030ef          	jal	4b26 <open>
     d0e:	84aa                	mv	s1,a0
  if(fd < 0){
     d10:	0c054463          	bltz	a0,dd8 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d14:	660d                	lui	a2,0x3
     d16:	0000c597          	auipc	a1,0xc
     d1a:	f6258593          	addi	a1,a1,-158 # cc78 <buf>
     d1e:	5e1030ef          	jal	4afe <read>
     d22:	4795                	li	a5,5
     d24:	0cf51463          	bne	a0,a5,dec <linktest+0x178>
  close(fd);
     d28:	8526                	mv	a0,s1
     d2a:	5e5030ef          	jal	4b0e <close>
  if(link("lf2", "lf2") >= 0){
     d2e:	00005597          	auipc	a1,0x5
     d32:	99a58593          	addi	a1,a1,-1638 # 56c8 <malloc+0x716>
     d36:	852e                	mv	a0,a1
     d38:	60f030ef          	jal	4b46 <link>
     d3c:	0c055263          	bgez	a0,e00 <linktest+0x18c>
  unlink("lf2");
     d40:	00005517          	auipc	a0,0x5
     d44:	98850513          	addi	a0,a0,-1656 # 56c8 <malloc+0x716>
     d48:	5ef030ef          	jal	4b36 <unlink>
  if(link("lf2", "lf1") >= 0){
     d4c:	00005597          	auipc	a1,0x5
     d50:	97458593          	addi	a1,a1,-1676 # 56c0 <malloc+0x70e>
     d54:	00005517          	auipc	a0,0x5
     d58:	97450513          	addi	a0,a0,-1676 # 56c8 <malloc+0x716>
     d5c:	5eb030ef          	jal	4b46 <link>
     d60:	0a055a63          	bgez	a0,e14 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d64:	00005597          	auipc	a1,0x5
     d68:	95c58593          	addi	a1,a1,-1700 # 56c0 <malloc+0x70e>
     d6c:	00005517          	auipc	a0,0x5
     d70:	a6450513          	addi	a0,a0,-1436 # 57d0 <malloc+0x81e>
     d74:	5d3030ef          	jal	4b46 <link>
     d78:	0a055863          	bgez	a0,e28 <linktest+0x1b4>
}
     d7c:	60e2                	ld	ra,24(sp)
     d7e:	6442                	ld	s0,16(sp)
     d80:	64a2                	ld	s1,8(sp)
     d82:	6902                	ld	s2,0(sp)
     d84:	6105                	addi	sp,sp,32
     d86:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d88:	85ca                	mv	a1,s2
     d8a:	00005517          	auipc	a0,0x5
     d8e:	94650513          	addi	a0,a0,-1722 # 56d0 <malloc+0x71e>
     d92:	16c040ef          	jal	4efe <printf>
    exit(1);
     d96:	4505                	li	a0,1
     d98:	54f030ef          	jal	4ae6 <exit>
    printf("%s: write lf1 failed\n", s);
     d9c:	85ca                	mv	a1,s2
     d9e:	00005517          	auipc	a0,0x5
     da2:	94a50513          	addi	a0,a0,-1718 # 56e8 <malloc+0x736>
     da6:	158040ef          	jal	4efe <printf>
    exit(1);
     daa:	4505                	li	a0,1
     dac:	53b030ef          	jal	4ae6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db0:	85ca                	mv	a1,s2
     db2:	00005517          	auipc	a0,0x5
     db6:	94e50513          	addi	a0,a0,-1714 # 5700 <malloc+0x74e>
     dba:	144040ef          	jal	4efe <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	527030ef          	jal	4ae6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc4:	85ca                	mv	a1,s2
     dc6:	00005517          	auipc	a0,0x5
     dca:	95a50513          	addi	a0,a0,-1702 # 5720 <malloc+0x76e>
     dce:	130040ef          	jal	4efe <printf>
    exit(1);
     dd2:	4505                	li	a0,1
     dd4:	513030ef          	jal	4ae6 <exit>
    printf("%s: open lf2 failed\n", s);
     dd8:	85ca                	mv	a1,s2
     dda:	00005517          	auipc	a0,0x5
     dde:	97650513          	addi	a0,a0,-1674 # 5750 <malloc+0x79e>
     de2:	11c040ef          	jal	4efe <printf>
    exit(1);
     de6:	4505                	li	a0,1
     de8:	4ff030ef          	jal	4ae6 <exit>
    printf("%s: read lf2 failed\n", s);
     dec:	85ca                	mv	a1,s2
     dee:	00005517          	auipc	a0,0x5
     df2:	97a50513          	addi	a0,a0,-1670 # 5768 <malloc+0x7b6>
     df6:	108040ef          	jal	4efe <printf>
    exit(1);
     dfa:	4505                	li	a0,1
     dfc:	4eb030ef          	jal	4ae6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e00:	85ca                	mv	a1,s2
     e02:	00005517          	auipc	a0,0x5
     e06:	97e50513          	addi	a0,a0,-1666 # 5780 <malloc+0x7ce>
     e0a:	0f4040ef          	jal	4efe <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	4d7030ef          	jal	4ae6 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e14:	85ca                	mv	a1,s2
     e16:	00005517          	auipc	a0,0x5
     e1a:	99250513          	addi	a0,a0,-1646 # 57a8 <malloc+0x7f6>
     e1e:	0e0040ef          	jal	4efe <printf>
    exit(1);
     e22:	4505                	li	a0,1
     e24:	4c3030ef          	jal	4ae6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e28:	85ca                	mv	a1,s2
     e2a:	00005517          	auipc	a0,0x5
     e2e:	9ae50513          	addi	a0,a0,-1618 # 57d8 <malloc+0x826>
     e32:	0cc040ef          	jal	4efe <printf>
    exit(1);
     e36:	4505                	li	a0,1
     e38:	4af030ef          	jal	4ae6 <exit>

0000000000000e3c <validatetest>:
{
     e3c:	7139                	addi	sp,sp,-64
     e3e:	fc06                	sd	ra,56(sp)
     e40:	f822                	sd	s0,48(sp)
     e42:	f426                	sd	s1,40(sp)
     e44:	f04a                	sd	s2,32(sp)
     e46:	ec4e                	sd	s3,24(sp)
     e48:	e852                	sd	s4,16(sp)
     e4a:	e456                	sd	s5,8(sp)
     e4c:	e05a                	sd	s6,0(sp)
     e4e:	0080                	addi	s0,sp,64
     e50:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e52:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e54:	00005997          	auipc	s3,0x5
     e58:	9a498993          	addi	s3,s3,-1628 # 57f8 <malloc+0x846>
     e5c:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e5e:	6a85                	lui	s5,0x1
     e60:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e64:	85a6                	mv	a1,s1
     e66:	854e                	mv	a0,s3
     e68:	4df030ef          	jal	4b46 <link>
     e6c:	01251f63          	bne	a0,s2,e8a <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e70:	94d6                	add	s1,s1,s5
     e72:	ff4499e3          	bne	s1,s4,e64 <validatetest+0x28>
}
     e76:	70e2                	ld	ra,56(sp)
     e78:	7442                	ld	s0,48(sp)
     e7a:	74a2                	ld	s1,40(sp)
     e7c:	7902                	ld	s2,32(sp)
     e7e:	69e2                	ld	s3,24(sp)
     e80:	6a42                	ld	s4,16(sp)
     e82:	6aa2                	ld	s5,8(sp)
     e84:	6b02                	ld	s6,0(sp)
     e86:	6121                	addi	sp,sp,64
     e88:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8a:	85da                	mv	a1,s6
     e8c:	00005517          	auipc	a0,0x5
     e90:	97c50513          	addi	a0,a0,-1668 # 5808 <malloc+0x856>
     e94:	06a040ef          	jal	4efe <printf>
      exit(1);
     e98:	4505                	li	a0,1
     e9a:	44d030ef          	jal	4ae6 <exit>

0000000000000e9e <bigdir>:
{
     e9e:	715d                	addi	sp,sp,-80
     ea0:	e486                	sd	ra,72(sp)
     ea2:	e0a2                	sd	s0,64(sp)
     ea4:	fc26                	sd	s1,56(sp)
     ea6:	f84a                	sd	s2,48(sp)
     ea8:	f44e                	sd	s3,40(sp)
     eaa:	f052                	sd	s4,32(sp)
     eac:	ec56                	sd	s5,24(sp)
     eae:	e85a                	sd	s6,16(sp)
     eb0:	0880                	addi	s0,sp,80
     eb2:	89aa                	mv	s3,a0
  unlink("bd");
     eb4:	00005517          	auipc	a0,0x5
     eb8:	97450513          	addi	a0,a0,-1676 # 5828 <malloc+0x876>
     ebc:	47b030ef          	jal	4b36 <unlink>
  fd = open("bd", O_CREATE);
     ec0:	20000593          	li	a1,512
     ec4:	00005517          	auipc	a0,0x5
     ec8:	96450513          	addi	a0,a0,-1692 # 5828 <malloc+0x876>
     ecc:	45b030ef          	jal	4b26 <open>
  if(fd < 0){
     ed0:	0c054163          	bltz	a0,f92 <bigdir+0xf4>
  close(fd);
     ed4:	43b030ef          	jal	4b0e <close>
  for(i = 0; i < N; i++){
     ed8:	4901                	li	s2,0
    name[0] = 'x';
     eda:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ede:	00005a17          	auipc	s4,0x5
     ee2:	94aa0a13          	addi	s4,s4,-1718 # 5828 <malloc+0x876>
  for(i = 0; i < N; i++){
     ee6:	1f400b13          	li	s6,500
    name[0] = 'x';
     eea:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     eee:	41f9571b          	sraiw	a4,s2,0x1f
     ef2:	01a7571b          	srliw	a4,a4,0x1a
     ef6:	012707bb          	addw	a5,a4,s2
     efa:	4067d69b          	sraiw	a3,a5,0x6
     efe:	0306869b          	addiw	a3,a3,48
     f02:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f06:	03f7f793          	andi	a5,a5,63
     f0a:	9f99                	subw	a5,a5,a4
     f0c:	0307879b          	addiw	a5,a5,48
     f10:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f14:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f18:	fb040593          	addi	a1,s0,-80
     f1c:	8552                	mv	a0,s4
     f1e:	429030ef          	jal	4b46 <link>
     f22:	84aa                	mv	s1,a0
     f24:	e149                	bnez	a0,fa6 <bigdir+0x108>
  for(i = 0; i < N; i++){
     f26:	2905                	addiw	s2,s2,1
     f28:	fd6911e3          	bne	s2,s6,eea <bigdir+0x4c>
  unlink("bd");
     f2c:	00005517          	auipc	a0,0x5
     f30:	8fc50513          	addi	a0,a0,-1796 # 5828 <malloc+0x876>
     f34:	403030ef          	jal	4b36 <unlink>
    name[0] = 'x';
     f38:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f3c:	1f400a13          	li	s4,500
    name[0] = 'x';
     f40:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f44:	41f4d71b          	sraiw	a4,s1,0x1f
     f48:	01a7571b          	srliw	a4,a4,0x1a
     f4c:	009707bb          	addw	a5,a4,s1
     f50:	4067d69b          	sraiw	a3,a5,0x6
     f54:	0306869b          	addiw	a3,a3,48
     f58:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f5c:	03f7f793          	andi	a5,a5,63
     f60:	9f99                	subw	a5,a5,a4
     f62:	0307879b          	addiw	a5,a5,48
     f66:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f6e:	fb040513          	addi	a0,s0,-80
     f72:	3c5030ef          	jal	4b36 <unlink>
     f76:	e529                	bnez	a0,fc0 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f78:	2485                	addiw	s1,s1,1
     f7a:	fd4493e3          	bne	s1,s4,f40 <bigdir+0xa2>
}
     f7e:	60a6                	ld	ra,72(sp)
     f80:	6406                	ld	s0,64(sp)
     f82:	74e2                	ld	s1,56(sp)
     f84:	7942                	ld	s2,48(sp)
     f86:	79a2                	ld	s3,40(sp)
     f88:	7a02                	ld	s4,32(sp)
     f8a:	6ae2                	ld	s5,24(sp)
     f8c:	6b42                	ld	s6,16(sp)
     f8e:	6161                	addi	sp,sp,80
     f90:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f92:	85ce                	mv	a1,s3
     f94:	00005517          	auipc	a0,0x5
     f98:	89c50513          	addi	a0,a0,-1892 # 5830 <malloc+0x87e>
     f9c:	763030ef          	jal	4efe <printf>
    exit(1);
     fa0:	4505                	li	a0,1
     fa2:	345030ef          	jal	4ae6 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fa6:	fb040693          	addi	a3,s0,-80
     faa:	864a                	mv	a2,s2
     fac:	85ce                	mv	a1,s3
     fae:	00005517          	auipc	a0,0x5
     fb2:	8a250513          	addi	a0,a0,-1886 # 5850 <malloc+0x89e>
     fb6:	749030ef          	jal	4efe <printf>
      exit(1);
     fba:	4505                	li	a0,1
     fbc:	32b030ef          	jal	4ae6 <exit>
      printf("%s: bigdir unlink failed", s);
     fc0:	85ce                	mv	a1,s3
     fc2:	00005517          	auipc	a0,0x5
     fc6:	8b650513          	addi	a0,a0,-1866 # 5878 <malloc+0x8c6>
     fca:	735030ef          	jal	4efe <printf>
      exit(1);
     fce:	4505                	li	a0,1
     fd0:	317030ef          	jal	4ae6 <exit>

0000000000000fd4 <pgbug>:
{
     fd4:	7179                	addi	sp,sp,-48
     fd6:	f406                	sd	ra,40(sp)
     fd8:	f022                	sd	s0,32(sp)
     fda:	ec26                	sd	s1,24(sp)
     fdc:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fde:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe2:	00008497          	auipc	s1,0x8
     fe6:	01e48493          	addi	s1,s1,30 # 9000 <big>
     fea:	fd840593          	addi	a1,s0,-40
     fee:	6088                	ld	a0,0(s1)
     ff0:	32f030ef          	jal	4b1e <exec>
  pipe(big);
     ff4:	6088                	ld	a0,0(s1)
     ff6:	301030ef          	jal	4af6 <pipe>
  exit(0);
     ffa:	4501                	li	a0,0
     ffc:	2eb030ef          	jal	4ae6 <exit>

0000000000001000 <badarg>:
{
    1000:	7139                	addi	sp,sp,-64
    1002:	fc06                	sd	ra,56(sp)
    1004:	f822                	sd	s0,48(sp)
    1006:	f426                	sd	s1,40(sp)
    1008:	f04a                	sd	s2,32(sp)
    100a:	ec4e                	sd	s3,24(sp)
    100c:	0080                	addi	s0,sp,64
    100e:	64b1                	lui	s1,0xc
    1010:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1014:	597d                	li	s2,-1
    1016:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    101a:	00004997          	auipc	s3,0x4
    101e:	0ce98993          	addi	s3,s3,206 # 50e8 <malloc+0x136>
    argv[0] = (char*)0xffffffff;
    1022:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1026:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102a:	fc040593          	addi	a1,s0,-64
    102e:	854e                	mv	a0,s3
    1030:	2ef030ef          	jal	4b1e <exec>
  for(int i = 0; i < 50000; i++){
    1034:	34fd                	addiw	s1,s1,-1
    1036:	f4f5                	bnez	s1,1022 <badarg+0x22>
  exit(0);
    1038:	4501                	li	a0,0
    103a:	2ad030ef          	jal	4ae6 <exit>

000000000000103e <copyinstr2>:
{
    103e:	7155                	addi	sp,sp,-208
    1040:	e586                	sd	ra,200(sp)
    1042:	e1a2                	sd	s0,192(sp)
    1044:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1046:	f6840793          	addi	a5,s0,-152
    104a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    104e:	07800713          	li	a4,120
    1052:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1056:	0785                	addi	a5,a5,1
    1058:	fed79de3          	bne	a5,a3,1052 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    105c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1060:	f6840513          	addi	a0,s0,-152
    1064:	2d3030ef          	jal	4b36 <unlink>
  if(ret != -1){
    1068:	57fd                	li	a5,-1
    106a:	0cf51363          	bne	a0,a5,1130 <copyinstr2+0xf2>
  int fd = open(b, O_CREATE | O_WRONLY);
    106e:	20100593          	li	a1,513
    1072:	f6840513          	addi	a0,s0,-152
    1076:	2b1030ef          	jal	4b26 <open>
  if(fd != -1){
    107a:	57fd                	li	a5,-1
    107c:	0cf51663          	bne	a0,a5,1148 <copyinstr2+0x10a>
  ret = link(b, b);
    1080:	f6840593          	addi	a1,s0,-152
    1084:	852e                	mv	a0,a1
    1086:	2c1030ef          	jal	4b46 <link>
  if(ret != -1){
    108a:	57fd                	li	a5,-1
    108c:	0cf51a63          	bne	a0,a5,1160 <copyinstr2+0x122>
  char *args[] = { "xx", 0 };
    1090:	00006797          	auipc	a5,0x6
    1094:	a7878793          	addi	a5,a5,-1416 # 6b08 <malloc+0x1b56>
    1098:	f4f43c23          	sd	a5,-168(s0)
    109c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a0:	f5840593          	addi	a1,s0,-168
    10a4:	f6840513          	addi	a0,s0,-152
    10a8:	277030ef          	jal	4b1e <exec>
  if(ret != -1){
    10ac:	57fd                	li	a5,-1
    10ae:	0cf51663          	bne	a0,a5,117a <copyinstr2+0x13c>
  int pid = fork(1);
    10b2:	4505                	li	a0,1
    10b4:	22b030ef          	jal	4ade <fork>
  if(pid < 0){
    10b8:	0c054d63          	bltz	a0,1192 <copyinstr2+0x154>
  if(pid == 0){
    10bc:	0e051863          	bnez	a0,11ac <copyinstr2+0x16e>
    10c0:	00008797          	auipc	a5,0x8
    10c4:	4a078793          	addi	a5,a5,1184 # 9560 <big.0>
    10c8:	00009697          	auipc	a3,0x9
    10cc:	49868693          	addi	a3,a3,1176 # a560 <big.0+0x1000>
      big[i] = 'x';
    10d0:	07800713          	li	a4,120
    10d4:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10d8:	0785                	addi	a5,a5,1
    10da:	fed79de3          	bne	a5,a3,10d4 <copyinstr2+0x96>
    big[PGSIZE] = '\0';
    10de:	00009797          	auipc	a5,0x9
    10e2:	48078123          	sb	zero,1154(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e6:	00006797          	auipc	a5,0x6
    10ea:	56278793          	addi	a5,a5,1378 # 7648 <malloc+0x2696>
    10ee:	6fb0                	ld	a2,88(a5)
    10f0:	73b4                	ld	a3,96(a5)
    10f2:	77b8                	ld	a4,104(a5)
    10f4:	7bbc                	ld	a5,112(a5)
    10f6:	f2c43823          	sd	a2,-208(s0)
    10fa:	f2d43c23          	sd	a3,-200(s0)
    10fe:	f4e43023          	sd	a4,-192(s0)
    1102:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1106:	f3040593          	addi	a1,s0,-208
    110a:	00004517          	auipc	a0,0x4
    110e:	fde50513          	addi	a0,a0,-34 # 50e8 <malloc+0x136>
    1112:	20d030ef          	jal	4b1e <exec>
    if(ret != -1){
    1116:	57fd                	li	a5,-1
    1118:	08f50663          	beq	a0,a5,11a4 <copyinstr2+0x166>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111c:	55fd                	li	a1,-1
    111e:	00005517          	auipc	a0,0x5
    1122:	80250513          	addi	a0,a0,-2046 # 5920 <malloc+0x96e>
    1126:	5d9030ef          	jal	4efe <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	1bb030ef          	jal	4ae6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1130:	862a                	mv	a2,a0
    1132:	f6840593          	addi	a1,s0,-152
    1136:	00004517          	auipc	a0,0x4
    113a:	76250513          	addi	a0,a0,1890 # 5898 <malloc+0x8e6>
    113e:	5c1030ef          	jal	4efe <printf>
    exit(1);
    1142:	4505                	li	a0,1
    1144:	1a3030ef          	jal	4ae6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1148:	862a                	mv	a2,a0
    114a:	f6840593          	addi	a1,s0,-152
    114e:	00004517          	auipc	a0,0x4
    1152:	76a50513          	addi	a0,a0,1898 # 58b8 <malloc+0x906>
    1156:	5a9030ef          	jal	4efe <printf>
    exit(1);
    115a:	4505                	li	a0,1
    115c:	18b030ef          	jal	4ae6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1160:	86aa                	mv	a3,a0
    1162:	f6840613          	addi	a2,s0,-152
    1166:	85b2                	mv	a1,a2
    1168:	00004517          	auipc	a0,0x4
    116c:	77050513          	addi	a0,a0,1904 # 58d8 <malloc+0x926>
    1170:	58f030ef          	jal	4efe <printf>
    exit(1);
    1174:	4505                	li	a0,1
    1176:	171030ef          	jal	4ae6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    117a:	567d                	li	a2,-1
    117c:	f6840593          	addi	a1,s0,-152
    1180:	00004517          	auipc	a0,0x4
    1184:	78050513          	addi	a0,a0,1920 # 5900 <malloc+0x94e>
    1188:	577030ef          	jal	4efe <printf>
    exit(1);
    118c:	4505                	li	a0,1
    118e:	159030ef          	jal	4ae6 <exit>
    printf("fork failed\n");
    1192:	00006517          	auipc	a0,0x6
    1196:	f5650513          	addi	a0,a0,-170 # 70e8 <malloc+0x2136>
    119a:	565030ef          	jal	4efe <printf>
    exit(1);
    119e:	4505                	li	a0,1
    11a0:	147030ef          	jal	4ae6 <exit>
    exit(747); // OK
    11a4:	2eb00513          	li	a0,747
    11a8:	13f030ef          	jal	4ae6 <exit>
  int st = 0;
    11ac:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11b0:	f5440513          	addi	a0,s0,-172
    11b4:	13b030ef          	jal	4aee <wait>
  if(st != 747){
    11b8:	f5442703          	lw	a4,-172(s0)
    11bc:	2eb00793          	li	a5,747
    11c0:	00f71663          	bne	a4,a5,11cc <copyinstr2+0x18e>
}
    11c4:	60ae                	ld	ra,200(sp)
    11c6:	640e                	ld	s0,192(sp)
    11c8:	6169                	addi	sp,sp,208
    11ca:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11cc:	00004517          	auipc	a0,0x4
    11d0:	77c50513          	addi	a0,a0,1916 # 5948 <malloc+0x996>
    11d4:	52b030ef          	jal	4efe <printf>
    exit(1);
    11d8:	4505                	li	a0,1
    11da:	10d030ef          	jal	4ae6 <exit>

00000000000011de <truncate3>:
{
    11de:	7159                	addi	sp,sp,-112
    11e0:	f486                	sd	ra,104(sp)
    11e2:	f0a2                	sd	s0,96(sp)
    11e4:	e8ca                	sd	s2,80(sp)
    11e6:	1880                	addi	s0,sp,112
    11e8:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11ea:	60100593          	li	a1,1537
    11ee:	00004517          	auipc	a0,0x4
    11f2:	f5250513          	addi	a0,a0,-174 # 5140 <malloc+0x18e>
    11f6:	131030ef          	jal	4b26 <open>
    11fa:	115030ef          	jal	4b0e <close>
  pid = fork(1);
    11fe:	4505                	li	a0,1
    1200:	0df030ef          	jal	4ade <fork>
  if(pid < 0){
    1204:	06054663          	bltz	a0,1270 <truncate3+0x92>
  if(pid == 0){
    1208:	e55d                	bnez	a0,12b6 <truncate3+0xd8>
    120a:	eca6                	sd	s1,88(sp)
    120c:	e4ce                	sd	s3,72(sp)
    120e:	e0d2                	sd	s4,64(sp)
    1210:	fc56                	sd	s5,56(sp)
    1212:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1216:	00004a17          	auipc	s4,0x4
    121a:	f2aa0a13          	addi	s4,s4,-214 # 5140 <malloc+0x18e>
      int n = write(fd, "1234567890", 10);
    121e:	00004a97          	auipc	s5,0x4
    1222:	78aa8a93          	addi	s5,s5,1930 # 59a8 <malloc+0x9f6>
      int fd = open("truncfile", O_WRONLY);
    1226:	4585                	li	a1,1
    1228:	8552                	mv	a0,s4
    122a:	0fd030ef          	jal	4b26 <open>
    122e:	84aa                	mv	s1,a0
      if(fd < 0){
    1230:	04054e63          	bltz	a0,128c <truncate3+0xae>
      int n = write(fd, "1234567890", 10);
    1234:	4629                	li	a2,10
    1236:	85d6                	mv	a1,s5
    1238:	0cf030ef          	jal	4b06 <write>
      if(n != 10){
    123c:	47a9                	li	a5,10
    123e:	06f51163          	bne	a0,a5,12a0 <truncate3+0xc2>
      close(fd);
    1242:	8526                	mv	a0,s1
    1244:	0cb030ef          	jal	4b0e <close>
      fd = open("truncfile", O_RDONLY);
    1248:	4581                	li	a1,0
    124a:	8552                	mv	a0,s4
    124c:	0db030ef          	jal	4b26 <open>
    1250:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1252:	02000613          	li	a2,32
    1256:	f9840593          	addi	a1,s0,-104
    125a:	0a5030ef          	jal	4afe <read>
      close(fd);
    125e:	8526                	mv	a0,s1
    1260:	0af030ef          	jal	4b0e <close>
    for(int i = 0; i < 100; i++){
    1264:	39fd                	addiw	s3,s3,-1
    1266:	fc0990e3          	bnez	s3,1226 <truncate3+0x48>
    exit(0);
    126a:	4501                	li	a0,0
    126c:	07b030ef          	jal	4ae6 <exit>
    1270:	eca6                	sd	s1,88(sp)
    1272:	e4ce                	sd	s3,72(sp)
    1274:	e0d2                	sd	s4,64(sp)
    1276:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1278:	85ca                	mv	a1,s2
    127a:	00004517          	auipc	a0,0x4
    127e:	6fe50513          	addi	a0,a0,1790 # 5978 <malloc+0x9c6>
    1282:	47d030ef          	jal	4efe <printf>
    exit(1);
    1286:	4505                	li	a0,1
    1288:	05f030ef          	jal	4ae6 <exit>
        printf("%s: open failed\n", s);
    128c:	85ca                	mv	a1,s2
    128e:	00004517          	auipc	a0,0x4
    1292:	70250513          	addi	a0,a0,1794 # 5990 <malloc+0x9de>
    1296:	469030ef          	jal	4efe <printf>
        exit(1);
    129a:	4505                	li	a0,1
    129c:	04b030ef          	jal	4ae6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    12a0:	862a                	mv	a2,a0
    12a2:	85ca                	mv	a1,s2
    12a4:	00004517          	auipc	a0,0x4
    12a8:	71450513          	addi	a0,a0,1812 # 59b8 <malloc+0xa06>
    12ac:	453030ef          	jal	4efe <printf>
        exit(1);
    12b0:	4505                	li	a0,1
    12b2:	035030ef          	jal	4ae6 <exit>
    12b6:	eca6                	sd	s1,88(sp)
    12b8:	e4ce                	sd	s3,72(sp)
    12ba:	e0d2                	sd	s4,64(sp)
    12bc:	fc56                	sd	s5,56(sp)
    12be:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12c2:	00004a17          	auipc	s4,0x4
    12c6:	e7ea0a13          	addi	s4,s4,-386 # 5140 <malloc+0x18e>
    int n = write(fd, "xxx", 3);
    12ca:	00004a97          	auipc	s5,0x4
    12ce:	70ea8a93          	addi	s5,s5,1806 # 59d8 <malloc+0xa26>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12d2:	60100593          	li	a1,1537
    12d6:	8552                	mv	a0,s4
    12d8:	04f030ef          	jal	4b26 <open>
    12dc:	84aa                	mv	s1,a0
    if(fd < 0){
    12de:	02054d63          	bltz	a0,1318 <truncate3+0x13a>
    int n = write(fd, "xxx", 3);
    12e2:	460d                	li	a2,3
    12e4:	85d6                	mv	a1,s5
    12e6:	021030ef          	jal	4b06 <write>
    if(n != 3){
    12ea:	478d                	li	a5,3
    12ec:	04f51063          	bne	a0,a5,132c <truncate3+0x14e>
    close(fd);
    12f0:	8526                	mv	a0,s1
    12f2:	01d030ef          	jal	4b0e <close>
  for(int i = 0; i < 150; i++){
    12f6:	39fd                	addiw	s3,s3,-1
    12f8:	fc099de3          	bnez	s3,12d2 <truncate3+0xf4>
  wait(&xstatus);
    12fc:	fbc40513          	addi	a0,s0,-68
    1300:	7ee030ef          	jal	4aee <wait>
  unlink("truncfile");
    1304:	00004517          	auipc	a0,0x4
    1308:	e3c50513          	addi	a0,a0,-452 # 5140 <malloc+0x18e>
    130c:	02b030ef          	jal	4b36 <unlink>
  exit(xstatus);
    1310:	fbc42503          	lw	a0,-68(s0)
    1314:	7d2030ef          	jal	4ae6 <exit>
      printf("%s: open failed\n", s);
    1318:	85ca                	mv	a1,s2
    131a:	00004517          	auipc	a0,0x4
    131e:	67650513          	addi	a0,a0,1654 # 5990 <malloc+0x9de>
    1322:	3dd030ef          	jal	4efe <printf>
      exit(1);
    1326:	4505                	li	a0,1
    1328:	7be030ef          	jal	4ae6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    132c:	862a                	mv	a2,a0
    132e:	85ca                	mv	a1,s2
    1330:	00004517          	auipc	a0,0x4
    1334:	6b050513          	addi	a0,a0,1712 # 59e0 <malloc+0xa2e>
    1338:	3c7030ef          	jal	4efe <printf>
      exit(1);
    133c:	4505                	li	a0,1
    133e:	7a8030ef          	jal	4ae6 <exit>

0000000000001342 <exectest>:
{
    1342:	715d                	addi	sp,sp,-80
    1344:	e486                	sd	ra,72(sp)
    1346:	e0a2                	sd	s0,64(sp)
    1348:	f84a                	sd	s2,48(sp)
    134a:	0880                	addi	s0,sp,80
    134c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    134e:	00004797          	auipc	a5,0x4
    1352:	d9a78793          	addi	a5,a5,-614 # 50e8 <malloc+0x136>
    1356:	fcf43023          	sd	a5,-64(s0)
    135a:	00004797          	auipc	a5,0x4
    135e:	6a678793          	addi	a5,a5,1702 # 5a00 <malloc+0xa4e>
    1362:	fcf43423          	sd	a5,-56(s0)
    1366:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    136a:	00004517          	auipc	a0,0x4
    136e:	69e50513          	addi	a0,a0,1694 # 5a08 <malloc+0xa56>
    1372:	7c4030ef          	jal	4b36 <unlink>
  pid = fork(1);
    1376:	4505                	li	a0,1
    1378:	766030ef          	jal	4ade <fork>
  if(pid < 0) {
    137c:	02054f63          	bltz	a0,13ba <exectest+0x78>
    1380:	fc26                	sd	s1,56(sp)
    1382:	84aa                	mv	s1,a0
  if(pid == 0) {
    1384:	e935                	bnez	a0,13f8 <exectest+0xb6>
    close(1);
    1386:	4505                	li	a0,1
    1388:	786030ef          	jal	4b0e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    138c:	20100593          	li	a1,513
    1390:	00004517          	auipc	a0,0x4
    1394:	67850513          	addi	a0,a0,1656 # 5a08 <malloc+0xa56>
    1398:	78e030ef          	jal	4b26 <open>
    if(fd < 0) {
    139c:	02054a63          	bltz	a0,13d0 <exectest+0x8e>
    if(fd != 1) {
    13a0:	4785                	li	a5,1
    13a2:	04f50163          	beq	a0,a5,13e4 <exectest+0xa2>
      printf("%s: wrong fd\n", s);
    13a6:	85ca                	mv	a1,s2
    13a8:	00004517          	auipc	a0,0x4
    13ac:	68050513          	addi	a0,a0,1664 # 5a28 <malloc+0xa76>
    13b0:	34f030ef          	jal	4efe <printf>
      exit(1);
    13b4:	4505                	li	a0,1
    13b6:	730030ef          	jal	4ae6 <exit>
    13ba:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    13bc:	85ca                	mv	a1,s2
    13be:	00004517          	auipc	a0,0x4
    13c2:	5ba50513          	addi	a0,a0,1466 # 5978 <malloc+0x9c6>
    13c6:	339030ef          	jal	4efe <printf>
     exit(1);
    13ca:	4505                	li	a0,1
    13cc:	71a030ef          	jal	4ae6 <exit>
      printf("%s: create failed\n", s);
    13d0:	85ca                	mv	a1,s2
    13d2:	00004517          	auipc	a0,0x4
    13d6:	63e50513          	addi	a0,a0,1598 # 5a10 <malloc+0xa5e>
    13da:	325030ef          	jal	4efe <printf>
      exit(1);
    13de:	4505                	li	a0,1
    13e0:	706030ef          	jal	4ae6 <exit>
    if(exec("echo", echoargv) < 0){
    13e4:	fc040593          	addi	a1,s0,-64
    13e8:	00004517          	auipc	a0,0x4
    13ec:	d0050513          	addi	a0,a0,-768 # 50e8 <malloc+0x136>
    13f0:	72e030ef          	jal	4b1e <exec>
    13f4:	00054d63          	bltz	a0,140e <exectest+0xcc>
  if (wait(&xstatus) != pid) {
    13f8:	fdc40513          	addi	a0,s0,-36
    13fc:	6f2030ef          	jal	4aee <wait>
    1400:	02951163          	bne	a0,s1,1422 <exectest+0xe0>
  if(xstatus != 0)
    1404:	fdc42503          	lw	a0,-36(s0)
    1408:	c50d                	beqz	a0,1432 <exectest+0xf0>
    exit(xstatus);
    140a:	6dc030ef          	jal	4ae6 <exit>
      printf("%s: exec echo failed\n", s);
    140e:	85ca                	mv	a1,s2
    1410:	00004517          	auipc	a0,0x4
    1414:	62850513          	addi	a0,a0,1576 # 5a38 <malloc+0xa86>
    1418:	2e7030ef          	jal	4efe <printf>
      exit(1);
    141c:	4505                	li	a0,1
    141e:	6c8030ef          	jal	4ae6 <exit>
    printf("%s: wait failed!\n", s);
    1422:	85ca                	mv	a1,s2
    1424:	00004517          	auipc	a0,0x4
    1428:	62c50513          	addi	a0,a0,1580 # 5a50 <malloc+0xa9e>
    142c:	2d3030ef          	jal	4efe <printf>
    1430:	bfd1                	j	1404 <exectest+0xc2>
  fd = open("echo-ok", O_RDONLY);
    1432:	4581                	li	a1,0
    1434:	00004517          	auipc	a0,0x4
    1438:	5d450513          	addi	a0,a0,1492 # 5a08 <malloc+0xa56>
    143c:	6ea030ef          	jal	4b26 <open>
  if(fd < 0) {
    1440:	02054463          	bltz	a0,1468 <exectest+0x126>
  if (read(fd, buf, 2) != 2) {
    1444:	4609                	li	a2,2
    1446:	fb840593          	addi	a1,s0,-72
    144a:	6b4030ef          	jal	4afe <read>
    144e:	4789                	li	a5,2
    1450:	02f50663          	beq	a0,a5,147c <exectest+0x13a>
    printf("%s: read failed\n", s);
    1454:	85ca                	mv	a1,s2
    1456:	00004517          	auipc	a0,0x4
    145a:	06250513          	addi	a0,a0,98 # 54b8 <malloc+0x506>
    145e:	2a1030ef          	jal	4efe <printf>
    exit(1);
    1462:	4505                	li	a0,1
    1464:	682030ef          	jal	4ae6 <exit>
    printf("%s: open failed\n", s);
    1468:	85ca                	mv	a1,s2
    146a:	00004517          	auipc	a0,0x4
    146e:	52650513          	addi	a0,a0,1318 # 5990 <malloc+0x9de>
    1472:	28d030ef          	jal	4efe <printf>
    exit(1);
    1476:	4505                	li	a0,1
    1478:	66e030ef          	jal	4ae6 <exit>
  unlink("echo-ok");
    147c:	00004517          	auipc	a0,0x4
    1480:	58c50513          	addi	a0,a0,1420 # 5a08 <malloc+0xa56>
    1484:	6b2030ef          	jal	4b36 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1488:	fb844703          	lbu	a4,-72(s0)
    148c:	04f00793          	li	a5,79
    1490:	00f71863          	bne	a4,a5,14a0 <exectest+0x15e>
    1494:	fb944703          	lbu	a4,-71(s0)
    1498:	04b00793          	li	a5,75
    149c:	00f70c63          	beq	a4,a5,14b4 <exectest+0x172>
    printf("%s: wrong output\n", s);
    14a0:	85ca                	mv	a1,s2
    14a2:	00004517          	auipc	a0,0x4
    14a6:	5c650513          	addi	a0,a0,1478 # 5a68 <malloc+0xab6>
    14aa:	255030ef          	jal	4efe <printf>
    exit(1);
    14ae:	4505                	li	a0,1
    14b0:	636030ef          	jal	4ae6 <exit>
    exit(0);
    14b4:	4501                	li	a0,0
    14b6:	630030ef          	jal	4ae6 <exit>

00000000000014ba <pipe1>:
{
    14ba:	711d                	addi	sp,sp,-96
    14bc:	ec86                	sd	ra,88(sp)
    14be:	e8a2                	sd	s0,80(sp)
    14c0:	fc4e                	sd	s3,56(sp)
    14c2:	1080                	addi	s0,sp,96
    14c4:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    14c6:	fa840513          	addi	a0,s0,-88
    14ca:	62c030ef          	jal	4af6 <pipe>
    14ce:	e935                	bnez	a0,1542 <pipe1+0x88>
    14d0:	e4a6                	sd	s1,72(sp)
    14d2:	f852                	sd	s4,48(sp)
    14d4:	84aa                	mv	s1,a0
  pid = fork(1);
    14d6:	4505                	li	a0,1
    14d8:	606030ef          	jal	4ade <fork>
    14dc:	8a2a                	mv	s4,a0
  if(pid == 0){
    14de:	c151                	beqz	a0,1562 <pipe1+0xa8>
  } else if(pid > 0){
    14e0:	14a05e63          	blez	a0,163c <pipe1+0x182>
    14e4:	e0ca                	sd	s2,64(sp)
    14e6:	f456                	sd	s5,40(sp)
    close(fds[1]);
    14e8:	fac42503          	lw	a0,-84(s0)
    14ec:	622030ef          	jal	4b0e <close>
    total = 0;
    14f0:	8a26                	mv	s4,s1
    cc = 1;
    14f2:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    14f4:	0000ba97          	auipc	s5,0xb
    14f8:	784a8a93          	addi	s5,s5,1924 # cc78 <buf>
    14fc:	864a                	mv	a2,s2
    14fe:	85d6                	mv	a1,s5
    1500:	fa842503          	lw	a0,-88(s0)
    1504:	5fa030ef          	jal	4afe <read>
    1508:	0ea05a63          	blez	a0,15fc <pipe1+0x142>
      for(i = 0; i < n; i++){
    150c:	0000b717          	auipc	a4,0xb
    1510:	76c70713          	addi	a4,a4,1900 # cc78 <buf>
    1514:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1518:	00074683          	lbu	a3,0(a4)
    151c:	0ff4f793          	zext.b	a5,s1
    1520:	2485                	addiw	s1,s1,1
    1522:	0af69d63          	bne	a3,a5,15dc <pipe1+0x122>
      for(i = 0; i < n; i++){
    1526:	0705                	addi	a4,a4,1
    1528:	fec498e3          	bne	s1,a2,1518 <pipe1+0x5e>
      total += n;
    152c:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1530:	0019179b          	slliw	a5,s2,0x1
    1534:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    1538:	670d                	lui	a4,0x3
    153a:	fd2771e3          	bgeu	a4,s2,14fc <pipe1+0x42>
        cc = sizeof(buf);
    153e:	690d                	lui	s2,0x3
    1540:	bf75                	j	14fc <pipe1+0x42>
    1542:	e4a6                	sd	s1,72(sp)
    1544:	e0ca                	sd	s2,64(sp)
    1546:	f852                	sd	s4,48(sp)
    1548:	f456                	sd	s5,40(sp)
    154a:	f05a                	sd	s6,32(sp)
    154c:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    154e:	85ce                	mv	a1,s3
    1550:	00004517          	auipc	a0,0x4
    1554:	53050513          	addi	a0,a0,1328 # 5a80 <malloc+0xace>
    1558:	1a7030ef          	jal	4efe <printf>
    exit(1);
    155c:	4505                	li	a0,1
    155e:	588030ef          	jal	4ae6 <exit>
    1562:	e0ca                	sd	s2,64(sp)
    1564:	f456                	sd	s5,40(sp)
    1566:	f05a                	sd	s6,32(sp)
    1568:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    156a:	fa842503          	lw	a0,-88(s0)
    156e:	5a0030ef          	jal	4b0e <close>
    for(n = 0; n < N; n++){
    1572:	0000bb17          	auipc	s6,0xb
    1576:	706b0b13          	addi	s6,s6,1798 # cc78 <buf>
    157a:	416004bb          	negw	s1,s6
    157e:	0ff4f493          	zext.b	s1,s1
    1582:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1586:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1588:	6a85                	lui	s5,0x1
    158a:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xeb>
{
    158e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1590:	0097873b          	addw	a4,a5,s1
    1594:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1598:	0785                	addi	a5,a5,1
    159a:	ff279be3          	bne	a5,s2,1590 <pipe1+0xd6>
    159e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    15a2:	40900613          	li	a2,1033
    15a6:	85de                	mv	a1,s7
    15a8:	fac42503          	lw	a0,-84(s0)
    15ac:	55a030ef          	jal	4b06 <write>
    15b0:	40900793          	li	a5,1033
    15b4:	00f51a63          	bne	a0,a5,15c8 <pipe1+0x10e>
    for(n = 0; n < N; n++){
    15b8:	24a5                	addiw	s1,s1,9
    15ba:	0ff4f493          	zext.b	s1,s1
    15be:	fd5a18e3          	bne	s4,s5,158e <pipe1+0xd4>
    exit(0);
    15c2:	4501                	li	a0,0
    15c4:	522030ef          	jal	4ae6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    15c8:	85ce                	mv	a1,s3
    15ca:	00004517          	auipc	a0,0x4
    15ce:	4ce50513          	addi	a0,a0,1230 # 5a98 <malloc+0xae6>
    15d2:	12d030ef          	jal	4efe <printf>
        exit(1);
    15d6:	4505                	li	a0,1
    15d8:	50e030ef          	jal	4ae6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15dc:	85ce                	mv	a1,s3
    15de:	00004517          	auipc	a0,0x4
    15e2:	4d250513          	addi	a0,a0,1234 # 5ab0 <malloc+0xafe>
    15e6:	119030ef          	jal	4efe <printf>
          return;
    15ea:	64a6                	ld	s1,72(sp)
    15ec:	6906                	ld	s2,64(sp)
    15ee:	7a42                	ld	s4,48(sp)
    15f0:	7aa2                	ld	s5,40(sp)
}
    15f2:	60e6                	ld	ra,88(sp)
    15f4:	6446                	ld	s0,80(sp)
    15f6:	79e2                	ld	s3,56(sp)
    15f8:	6125                	addi	sp,sp,96
    15fa:	8082                	ret
    if(total != N * SZ){
    15fc:	6785                	lui	a5,0x1
    15fe:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xeb>
    1602:	00fa0f63          	beq	s4,a5,1620 <pipe1+0x166>
    1606:	f05a                	sd	s6,32(sp)
    1608:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    160a:	8652                	mv	a2,s4
    160c:	85ce                	mv	a1,s3
    160e:	00004517          	auipc	a0,0x4
    1612:	4ba50513          	addi	a0,a0,1210 # 5ac8 <malloc+0xb16>
    1616:	0e9030ef          	jal	4efe <printf>
      exit(1);
    161a:	4505                	li	a0,1
    161c:	4ca030ef          	jal	4ae6 <exit>
    1620:	f05a                	sd	s6,32(sp)
    1622:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1624:	fa842503          	lw	a0,-88(s0)
    1628:	4e6030ef          	jal	4b0e <close>
    wait(&xstatus);
    162c:	fa440513          	addi	a0,s0,-92
    1630:	4be030ef          	jal	4aee <wait>
    exit(xstatus);
    1634:	fa442503          	lw	a0,-92(s0)
    1638:	4ae030ef          	jal	4ae6 <exit>
    163c:	e0ca                	sd	s2,64(sp)
    163e:	f456                	sd	s5,40(sp)
    1640:	f05a                	sd	s6,32(sp)
    1642:	ec5e                	sd	s7,24(sp)
    printf("%s: fork(1) failed\n", s);
    1644:	85ce                	mv	a1,s3
    1646:	00004517          	auipc	a0,0x4
    164a:	4a250513          	addi	a0,a0,1186 # 5ae8 <malloc+0xb36>
    164e:	0b1030ef          	jal	4efe <printf>
    exit(1);
    1652:	4505                	li	a0,1
    1654:	492030ef          	jal	4ae6 <exit>

0000000000001658 <exitwait>:
{
    1658:	7139                	addi	sp,sp,-64
    165a:	fc06                	sd	ra,56(sp)
    165c:	f822                	sd	s0,48(sp)
    165e:	f426                	sd	s1,40(sp)
    1660:	f04a                	sd	s2,32(sp)
    1662:	ec4e                	sd	s3,24(sp)
    1664:	e852                	sd	s4,16(sp)
    1666:	0080                	addi	s0,sp,64
    1668:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    166a:	4901                	li	s2,0
    166c:	06400993          	li	s3,100
    pid = fork(1);
    1670:	4505                	li	a0,1
    1672:	46c030ef          	jal	4ade <fork>
    1676:	84aa                	mv	s1,a0
    if(pid < 0){
    1678:	02054863          	bltz	a0,16a8 <exitwait+0x50>
    if(pid){
    167c:	c525                	beqz	a0,16e4 <exitwait+0x8c>
      if(wait(&xstate) != pid){
    167e:	fcc40513          	addi	a0,s0,-52
    1682:	46c030ef          	jal	4aee <wait>
    1686:	02951b63          	bne	a0,s1,16bc <exitwait+0x64>
      if(i != xstate) {
    168a:	fcc42783          	lw	a5,-52(s0)
    168e:	05279163          	bne	a5,s2,16d0 <exitwait+0x78>
  for(i = 0; i < 100; i++){
    1692:	2905                	addiw	s2,s2,1 # 3001 <subdir+0x3ed>
    1694:	fd391ee3          	bne	s2,s3,1670 <exitwait+0x18>
}
    1698:	70e2                	ld	ra,56(sp)
    169a:	7442                	ld	s0,48(sp)
    169c:	74a2                	ld	s1,40(sp)
    169e:	7902                	ld	s2,32(sp)
    16a0:	69e2                	ld	s3,24(sp)
    16a2:	6a42                	ld	s4,16(sp)
    16a4:	6121                	addi	sp,sp,64
    16a6:	8082                	ret
      printf("%s: fork 5failed\n", s);
    16a8:	85d2                	mv	a1,s4
    16aa:	00004517          	auipc	a0,0x4
    16ae:	45650513          	addi	a0,a0,1110 # 5b00 <malloc+0xb4e>
    16b2:	04d030ef          	jal	4efe <printf>
      exit(1);
    16b6:	4505                	li	a0,1
    16b8:	42e030ef          	jal	4ae6 <exit>
        printf("%s: wait wrong pid\n", s);
    16bc:	85d2                	mv	a1,s4
    16be:	00004517          	auipc	a0,0x4
    16c2:	45a50513          	addi	a0,a0,1114 # 5b18 <malloc+0xb66>
    16c6:	039030ef          	jal	4efe <printf>
        exit(1);
    16ca:	4505                	li	a0,1
    16cc:	41a030ef          	jal	4ae6 <exit>
        printf("%s: wait wrong exit status\n", s);
    16d0:	85d2                	mv	a1,s4
    16d2:	00004517          	auipc	a0,0x4
    16d6:	45e50513          	addi	a0,a0,1118 # 5b30 <malloc+0xb7e>
    16da:	025030ef          	jal	4efe <printf>
        exit(1);
    16de:	4505                	li	a0,1
    16e0:	406030ef          	jal	4ae6 <exit>
      exit(i);
    16e4:	854a                	mv	a0,s2
    16e6:	400030ef          	jal	4ae6 <exit>

00000000000016ea <twochildren>:
{
    16ea:	1101                	addi	sp,sp,-32
    16ec:	ec06                	sd	ra,24(sp)
    16ee:	e822                	sd	s0,16(sp)
    16f0:	e426                	sd	s1,8(sp)
    16f2:	e04a                	sd	s2,0(sp)
    16f4:	1000                	addi	s0,sp,32
    16f6:	892a                	mv	s2,a0
    16f8:	3e800493          	li	s1,1000
    int pid1 = fork(1);
    16fc:	4505                	li	a0,1
    16fe:	3e0030ef          	jal	4ade <fork>
    if(pid1 < 0){
    1702:	02054763          	bltz	a0,1730 <twochildren+0x46>
    if(pid1 == 0){
    1706:	cd1d                	beqz	a0,1744 <twochildren+0x5a>
      int pid2 = fork(1);
    1708:	4505                	li	a0,1
    170a:	3d4030ef          	jal	4ade <fork>
      if(pid2 < 0){
    170e:	02054d63          	bltz	a0,1748 <twochildren+0x5e>
      if(pid2 == 0){
    1712:	c529                	beqz	a0,175c <twochildren+0x72>
        wait(0);
    1714:	4501                	li	a0,0
    1716:	3d8030ef          	jal	4aee <wait>
        wait(0);
    171a:	4501                	li	a0,0
    171c:	3d2030ef          	jal	4aee <wait>
  for(int i = 0; i < 1000; i++){
    1720:	34fd                	addiw	s1,s1,-1
    1722:	fce9                	bnez	s1,16fc <twochildren+0x12>
}
    1724:	60e2                	ld	ra,24(sp)
    1726:	6442                	ld	s0,16(sp)
    1728:	64a2                	ld	s1,8(sp)
    172a:	6902                	ld	s2,0(sp)
    172c:	6105                	addi	sp,sp,32
    172e:	8082                	ret
      printf("%s: fork7 failed\n", s);
    1730:	85ca                	mv	a1,s2
    1732:	00004517          	auipc	a0,0x4
    1736:	41e50513          	addi	a0,a0,1054 # 5b50 <malloc+0xb9e>
    173a:	7c4030ef          	jal	4efe <printf>
      exit(1);
    173e:	4505                	li	a0,1
    1740:	3a6030ef          	jal	4ae6 <exit>
      exit(0);
    1744:	3a2030ef          	jal	4ae6 <exit>
        printf("%s: fork8 failed\n", s);
    1748:	85ca                	mv	a1,s2
    174a:	00004517          	auipc	a0,0x4
    174e:	41e50513          	addi	a0,a0,1054 # 5b68 <malloc+0xbb6>
    1752:	7ac030ef          	jal	4efe <printf>
        exit(1);
    1756:	4505                	li	a0,1
    1758:	38e030ef          	jal	4ae6 <exit>
        exit(0);
    175c:	38a030ef          	jal	4ae6 <exit>

0000000000001760 <forkfork>:
{
    1760:	7179                	addi	sp,sp,-48
    1762:	f406                	sd	ra,40(sp)
    1764:	f022                	sd	s0,32(sp)
    1766:	ec26                	sd	s1,24(sp)
    1768:	1800                	addi	s0,sp,48
    176a:	84aa                	mv	s1,a0
    int pid = fork(1);
    176c:	4505                	li	a0,1
    176e:	370030ef          	jal	4ade <fork>
    if(pid < 0){
    1772:	02054c63          	bltz	a0,17aa <forkfork+0x4a>
    if(pid == 0){
    1776:	c521                	beqz	a0,17be <forkfork+0x5e>
    int pid = fork(1);
    1778:	4505                	li	a0,1
    177a:	364030ef          	jal	4ade <fork>
    if(pid < 0){
    177e:	02054663          	bltz	a0,17aa <forkfork+0x4a>
    if(pid == 0){
    1782:	cd15                	beqz	a0,17be <forkfork+0x5e>
    wait(&xstatus);
    1784:	fdc40513          	addi	a0,s0,-36
    1788:	366030ef          	jal	4aee <wait>
    if(xstatus != 0) {
    178c:	fdc42783          	lw	a5,-36(s0)
    1790:	efa1                	bnez	a5,17e8 <forkfork+0x88>
    wait(&xstatus);
    1792:	fdc40513          	addi	a0,s0,-36
    1796:	358030ef          	jal	4aee <wait>
    if(xstatus != 0) {
    179a:	fdc42783          	lw	a5,-36(s0)
    179e:	e7a9                	bnez	a5,17e8 <forkfork+0x88>
}
    17a0:	70a2                	ld	ra,40(sp)
    17a2:	7402                	ld	s0,32(sp)
    17a4:	64e2                	ld	s1,24(sp)
    17a6:	6145                	addi	sp,sp,48
    17a8:	8082                	ret
      printf("%s: fork9 failed", s);
    17aa:	85a6                	mv	a1,s1
    17ac:	00004517          	auipc	a0,0x4
    17b0:	3d450513          	addi	a0,a0,980 # 5b80 <malloc+0xbce>
    17b4:	74a030ef          	jal	4efe <printf>
      exit(1);
    17b8:	4505                	li	a0,1
    17ba:	32c030ef          	jal	4ae6 <exit>
{
    17be:	0c800493          	li	s1,200
        int pid1 = fork(1);
    17c2:	4505                	li	a0,1
    17c4:	31a030ef          	jal	4ade <fork>
        if(pid1 < 0){
    17c8:	00054b63          	bltz	a0,17de <forkfork+0x7e>
        if(pid1 == 0){
    17cc:	cd01                	beqz	a0,17e4 <forkfork+0x84>
        wait(0);
    17ce:	4501                	li	a0,0
    17d0:	31e030ef          	jal	4aee <wait>
      for(int j = 0; j < 200; j++){
    17d4:	34fd                	addiw	s1,s1,-1
    17d6:	f4f5                	bnez	s1,17c2 <forkfork+0x62>
      exit(0);
    17d8:	4501                	li	a0,0
    17da:	30c030ef          	jal	4ae6 <exit>
          exit(1);
    17de:	4505                	li	a0,1
    17e0:	306030ef          	jal	4ae6 <exit>
          exit(0);
    17e4:	302030ef          	jal	4ae6 <exit>
      printf("%s: fork in child failed", s);
    17e8:	85a6                	mv	a1,s1
    17ea:	00004517          	auipc	a0,0x4
    17ee:	3ae50513          	addi	a0,a0,942 # 5b98 <malloc+0xbe6>
    17f2:	70c030ef          	jal	4efe <printf>
      exit(1);
    17f6:	4505                	li	a0,1
    17f8:	2ee030ef          	jal	4ae6 <exit>

00000000000017fc <reparent2>:
{
    17fc:	1101                	addi	sp,sp,-32
    17fe:	ec06                	sd	ra,24(sp)
    1800:	e822                	sd	s0,16(sp)
    1802:	e426                	sd	s1,8(sp)
    1804:	1000                	addi	s0,sp,32
    1806:	32000493          	li	s1,800
    int pid1 = fork(1);
    180a:	4505                	li	a0,1
    180c:	2d2030ef          	jal	4ade <fork>
    if(pid1 < 0){
    1810:	00054b63          	bltz	a0,1826 <reparent2+0x2a>
    if(pid1 == 0){
    1814:	c115                	beqz	a0,1838 <reparent2+0x3c>
    wait(0);
    1816:	4501                	li	a0,0
    1818:	2d6030ef          	jal	4aee <wait>
  for(int i = 0; i < 800; i++){
    181c:	34fd                	addiw	s1,s1,-1
    181e:	f4f5                	bnez	s1,180a <reparent2+0xe>
  exit(0);
    1820:	4501                	li	a0,0
    1822:	2c4030ef          	jal	4ae6 <exit>
      printf("fork11 failed\n");
    1826:	00004517          	auipc	a0,0x4
    182a:	39250513          	addi	a0,a0,914 # 5bb8 <malloc+0xc06>
    182e:	6d0030ef          	jal	4efe <printf>
      exit(1);
    1832:	4505                	li	a0,1
    1834:	2b2030ef          	jal	4ae6 <exit>
      fork(1);
    1838:	4505                	li	a0,1
    183a:	2a4030ef          	jal	4ade <fork>
      fork(1);
    183e:	4505                	li	a0,1
    1840:	29e030ef          	jal	4ade <fork>
      exit(0);
    1844:	4501                	li	a0,0
    1846:	2a0030ef          	jal	4ae6 <exit>

000000000000184a <createdelete>:
{
    184a:	7175                	addi	sp,sp,-144
    184c:	e506                	sd	ra,136(sp)
    184e:	e122                	sd	s0,128(sp)
    1850:	fca6                	sd	s1,120(sp)
    1852:	f8ca                	sd	s2,112(sp)
    1854:	f4ce                	sd	s3,104(sp)
    1856:	f0d2                	sd	s4,96(sp)
    1858:	ecd6                	sd	s5,88(sp)
    185a:	e8da                	sd	s6,80(sp)
    185c:	e4de                	sd	s7,72(sp)
    185e:	e0e2                	sd	s8,64(sp)
    1860:	fc66                	sd	s9,56(sp)
    1862:	0900                	addi	s0,sp,144
    1864:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1866:	4901                	li	s2,0
    1868:	4991                	li	s3,4
    pid = fork(1);
    186a:	4505                	li	a0,1
    186c:	272030ef          	jal	4ade <fork>
    1870:	84aa                	mv	s1,a0
    if(pid < 0){
    1872:	02054d63          	bltz	a0,18ac <createdelete+0x62>
    if(pid == 0){
    1876:	c529                	beqz	a0,18c0 <createdelete+0x76>
  for(pi = 0; pi < NCHILD; pi++){
    1878:	2905                	addiw	s2,s2,1
    187a:	ff3918e3          	bne	s2,s3,186a <createdelete+0x20>
    187e:	4491                	li	s1,4
    wait(&xstatus);
    1880:	f7c40513          	addi	a0,s0,-132
    1884:	26a030ef          	jal	4aee <wait>
    if(xstatus != 0)
    1888:	f7c42903          	lw	s2,-132(s0)
    188c:	0a091e63          	bnez	s2,1948 <createdelete+0xfe>
  for(pi = 0; pi < NCHILD; pi++){
    1890:	34fd                	addiw	s1,s1,-1
    1892:	f4fd                	bnez	s1,1880 <createdelete+0x36>
  name[0] = name[1] = name[2] = 0;
    1894:	f8040123          	sb	zero,-126(s0)
    1898:	03000993          	li	s3,48
    189c:	5a7d                	li	s4,-1
    189e:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    18a2:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    18a4:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    18a6:	07400a93          	li	s5,116
    18aa:	aa39                	j	19c8 <createdelete+0x17e>
      printf("%s: fork13 failed\n", s);
    18ac:	85e6                	mv	a1,s9
    18ae:	00004517          	auipc	a0,0x4
    18b2:	31a50513          	addi	a0,a0,794 # 5bc8 <malloc+0xc16>
    18b6:	648030ef          	jal	4efe <printf>
      exit(1);
    18ba:	4505                	li	a0,1
    18bc:	22a030ef          	jal	4ae6 <exit>
      name[0] = 'p' + pi;
    18c0:	0709091b          	addiw	s2,s2,112
    18c4:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    18c8:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    18cc:	4951                	li	s2,20
    18ce:	a831                	j	18ea <createdelete+0xa0>
          printf("%s: create failed\n", s);
    18d0:	85e6                	mv	a1,s9
    18d2:	00004517          	auipc	a0,0x4
    18d6:	13e50513          	addi	a0,a0,318 # 5a10 <malloc+0xa5e>
    18da:	624030ef          	jal	4efe <printf>
          exit(1);
    18de:	4505                	li	a0,1
    18e0:	206030ef          	jal	4ae6 <exit>
      for(i = 0; i < N; i++){
    18e4:	2485                	addiw	s1,s1,1
    18e6:	05248e63          	beq	s1,s2,1942 <createdelete+0xf8>
        name[1] = '0' + i;
    18ea:	0304879b          	addiw	a5,s1,48
    18ee:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18f2:	20200593          	li	a1,514
    18f6:	f8040513          	addi	a0,s0,-128
    18fa:	22c030ef          	jal	4b26 <open>
        if(fd < 0){
    18fe:	fc0549e3          	bltz	a0,18d0 <createdelete+0x86>
        close(fd);
    1902:	20c030ef          	jal	4b0e <close>
        if(i > 0 && (i % 2 ) == 0){
    1906:	10905063          	blez	s1,1a06 <createdelete+0x1bc>
    190a:	0014f793          	andi	a5,s1,1
    190e:	fbf9                	bnez	a5,18e4 <createdelete+0x9a>
          name[1] = '0' + (i / 2);
    1910:	01f4d79b          	srliw	a5,s1,0x1f
    1914:	9fa5                	addw	a5,a5,s1
    1916:	4017d79b          	sraiw	a5,a5,0x1
    191a:	0307879b          	addiw	a5,a5,48
    191e:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1922:	f8040513          	addi	a0,s0,-128
    1926:	210030ef          	jal	4b36 <unlink>
    192a:	fa055de3          	bgez	a0,18e4 <createdelete+0x9a>
            printf("%s: unlink failed\n", s);
    192e:	85e6                	mv	a1,s9
    1930:	00004517          	auipc	a0,0x4
    1934:	2b050513          	addi	a0,a0,688 # 5be0 <malloc+0xc2e>
    1938:	5c6030ef          	jal	4efe <printf>
            exit(1);
    193c:	4505                	li	a0,1
    193e:	1a8030ef          	jal	4ae6 <exit>
      exit(0);
    1942:	4501                	li	a0,0
    1944:	1a2030ef          	jal	4ae6 <exit>
      exit(1);
    1948:	4505                	li	a0,1
    194a:	19c030ef          	jal	4ae6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    194e:	f8040613          	addi	a2,s0,-128
    1952:	85e6                	mv	a1,s9
    1954:	00004517          	auipc	a0,0x4
    1958:	2a450513          	addi	a0,a0,676 # 5bf8 <malloc+0xc46>
    195c:	5a2030ef          	jal	4efe <printf>
        exit(1);
    1960:	4505                	li	a0,1
    1962:	184030ef          	jal	4ae6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1966:	034bfb63          	bgeu	s7,s4,199c <createdelete+0x152>
      if(fd >= 0)
    196a:	02055663          	bgez	a0,1996 <createdelete+0x14c>
    for(pi = 0; pi < NCHILD; pi++){
    196e:	2485                	addiw	s1,s1,1
    1970:	0ff4f493          	zext.b	s1,s1
    1974:	05548263          	beq	s1,s5,19b8 <createdelete+0x16e>
      name[0] = 'p' + pi;
    1978:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    197c:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1980:	4581                	li	a1,0
    1982:	f8040513          	addi	a0,s0,-128
    1986:	1a0030ef          	jal	4b26 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    198a:	00090463          	beqz	s2,1992 <createdelete+0x148>
    198e:	fd2b5ce3          	bge	s6,s2,1966 <createdelete+0x11c>
    1992:	fa054ee3          	bltz	a0,194e <createdelete+0x104>
        close(fd);
    1996:	178030ef          	jal	4b0e <close>
    199a:	bfd1                	j	196e <createdelete+0x124>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    199c:	fc0549e3          	bltz	a0,196e <createdelete+0x124>
        printf("%s: oops createdelete %s did exist\n", s, name);
    19a0:	f8040613          	addi	a2,s0,-128
    19a4:	85e6                	mv	a1,s9
    19a6:	00004517          	auipc	a0,0x4
    19aa:	27a50513          	addi	a0,a0,634 # 5c20 <malloc+0xc6e>
    19ae:	550030ef          	jal	4efe <printf>
        exit(1);
    19b2:	4505                	li	a0,1
    19b4:	132030ef          	jal	4ae6 <exit>
  for(i = 0; i < N; i++){
    19b8:	2905                	addiw	s2,s2,1
    19ba:	2a05                	addiw	s4,s4,1
    19bc:	2985                	addiw	s3,s3,1
    19be:	0ff9f993          	zext.b	s3,s3
    19c2:	47d1                	li	a5,20
    19c4:	02f90863          	beq	s2,a5,19f4 <createdelete+0x1aa>
    for(pi = 0; pi < NCHILD; pi++){
    19c8:	84e2                	mv	s1,s8
    19ca:	b77d                	j	1978 <createdelete+0x12e>
  for(i = 0; i < N; i++){
    19cc:	2905                	addiw	s2,s2,1
    19ce:	0ff97913          	zext.b	s2,s2
    19d2:	03490c63          	beq	s2,s4,1a0a <createdelete+0x1c0>
  name[0] = name[1] = name[2] = 0;
    19d6:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    19d8:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    19dc:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    19e0:	f8040513          	addi	a0,s0,-128
    19e4:	152030ef          	jal	4b36 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19e8:	2485                	addiw	s1,s1,1
    19ea:	0ff4f493          	zext.b	s1,s1
    19ee:	ff3495e3          	bne	s1,s3,19d8 <createdelete+0x18e>
    19f2:	bfe9                	j	19cc <createdelete+0x182>
    19f4:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19f8:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19fc:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    1a00:	04400a13          	li	s4,68
    1a04:	bfc9                	j	19d6 <createdelete+0x18c>
      for(i = 0; i < N; i++){
    1a06:	2485                	addiw	s1,s1,1
    1a08:	b5cd                	j	18ea <createdelete+0xa0>
}
    1a0a:	60aa                	ld	ra,136(sp)
    1a0c:	640a                	ld	s0,128(sp)
    1a0e:	74e6                	ld	s1,120(sp)
    1a10:	7946                	ld	s2,112(sp)
    1a12:	79a6                	ld	s3,104(sp)
    1a14:	7a06                	ld	s4,96(sp)
    1a16:	6ae6                	ld	s5,88(sp)
    1a18:	6b46                	ld	s6,80(sp)
    1a1a:	6ba6                	ld	s7,72(sp)
    1a1c:	6c06                	ld	s8,64(sp)
    1a1e:	7ce2                	ld	s9,56(sp)
    1a20:	6149                	addi	sp,sp,144
    1a22:	8082                	ret

0000000000001a24 <linkunlink>:
{
    1a24:	711d                	addi	sp,sp,-96
    1a26:	ec86                	sd	ra,88(sp)
    1a28:	e8a2                	sd	s0,80(sp)
    1a2a:	e4a6                	sd	s1,72(sp)
    1a2c:	e0ca                	sd	s2,64(sp)
    1a2e:	fc4e                	sd	s3,56(sp)
    1a30:	f852                	sd	s4,48(sp)
    1a32:	f456                	sd	s5,40(sp)
    1a34:	f05a                	sd	s6,32(sp)
    1a36:	ec5e                	sd	s7,24(sp)
    1a38:	e862                	sd	s8,16(sp)
    1a3a:	e466                	sd	s9,8(sp)
    1a3c:	1080                	addi	s0,sp,96
    1a3e:	84aa                	mv	s1,a0
  unlink("x");
    1a40:	00003517          	auipc	a0,0x3
    1a44:	71850513          	addi	a0,a0,1816 # 5158 <malloc+0x1a6>
    1a48:	0ee030ef          	jal	4b36 <unlink>
  pid = fork(1);
    1a4c:	4505                	li	a0,1
    1a4e:	090030ef          	jal	4ade <fork>
  if(pid < 0){
    1a52:	02054b63          	bltz	a0,1a88 <linkunlink+0x64>
    1a56:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1a58:	06100913          	li	s2,97
    1a5c:	c111                	beqz	a0,1a60 <linkunlink+0x3c>
    1a5e:	4905                	li	s2,1
    1a60:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a64:	41c65a37          	lui	s4,0x41c65
    1a68:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c551f5>
    1a6c:	698d                	lui	s3,0x3
    1a6e:	0399899b          	addiw	s3,s3,57 # 3039 <subdir+0x425>
    if((x % 3) == 0){
    1a72:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    1a74:	4b85                	li	s7,1
      unlink("x");
    1a76:	00003b17          	auipc	s6,0x3
    1a7a:	6e2b0b13          	addi	s6,s6,1762 # 5158 <malloc+0x1a6>
      link("cat", "x");
    1a7e:	00004c17          	auipc	s8,0x4
    1a82:	1e2c0c13          	addi	s8,s8,482 # 5c60 <malloc+0xcae>
    1a86:	a025                	j	1aae <linkunlink+0x8a>
    printf("%s: fork15 failed\n", s);
    1a88:	85a6                	mv	a1,s1
    1a8a:	00004517          	auipc	a0,0x4
    1a8e:	1be50513          	addi	a0,a0,446 # 5c48 <malloc+0xc96>
    1a92:	46c030ef          	jal	4efe <printf>
    exit(1);
    1a96:	4505                	li	a0,1
    1a98:	04e030ef          	jal	4ae6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a9c:	20200593          	li	a1,514
    1aa0:	855a                	mv	a0,s6
    1aa2:	084030ef          	jal	4b26 <open>
    1aa6:	068030ef          	jal	4b0e <close>
  for(i = 0; i < 100; i++){
    1aaa:	34fd                	addiw	s1,s1,-1
    1aac:	c495                	beqz	s1,1ad8 <linkunlink+0xb4>
    x = x * 1103515245 + 12345;
    1aae:	034907bb          	mulw	a5,s2,s4
    1ab2:	013787bb          	addw	a5,a5,s3
    1ab6:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    1aba:	0357f7bb          	remuw	a5,a5,s5
    1abe:	2781                	sext.w	a5,a5
    1ac0:	dff1                	beqz	a5,1a9c <linkunlink+0x78>
    } else if((x % 3) == 1){
    1ac2:	01778663          	beq	a5,s7,1ace <linkunlink+0xaa>
      unlink("x");
    1ac6:	855a                	mv	a0,s6
    1ac8:	06e030ef          	jal	4b36 <unlink>
    1acc:	bff9                	j	1aaa <linkunlink+0x86>
      link("cat", "x");
    1ace:	85da                	mv	a1,s6
    1ad0:	8562                	mv	a0,s8
    1ad2:	074030ef          	jal	4b46 <link>
    1ad6:	bfd1                	j	1aaa <linkunlink+0x86>
  if(pid)
    1ad8:	020c8263          	beqz	s9,1afc <linkunlink+0xd8>
    wait(0);
    1adc:	4501                	li	a0,0
    1ade:	010030ef          	jal	4aee <wait>
}
    1ae2:	60e6                	ld	ra,88(sp)
    1ae4:	6446                	ld	s0,80(sp)
    1ae6:	64a6                	ld	s1,72(sp)
    1ae8:	6906                	ld	s2,64(sp)
    1aea:	79e2                	ld	s3,56(sp)
    1aec:	7a42                	ld	s4,48(sp)
    1aee:	7aa2                	ld	s5,40(sp)
    1af0:	7b02                	ld	s6,32(sp)
    1af2:	6be2                	ld	s7,24(sp)
    1af4:	6c42                	ld	s8,16(sp)
    1af6:	6ca2                	ld	s9,8(sp)
    1af8:	6125                	addi	sp,sp,96
    1afa:	8082                	ret
    exit(0);
    1afc:	4501                	li	a0,0
    1afe:	7e9020ef          	jal	4ae6 <exit>

0000000000001b02 <forktest>:
{
    1b02:	7179                	addi	sp,sp,-48
    1b04:	f406                	sd	ra,40(sp)
    1b06:	f022                	sd	s0,32(sp)
    1b08:	ec26                	sd	s1,24(sp)
    1b0a:	e84a                	sd	s2,16(sp)
    1b0c:	e44e                	sd	s3,8(sp)
    1b0e:	1800                	addi	s0,sp,48
    1b10:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1b12:	4481                	li	s1,0
    1b14:	3e800913          	li	s2,1000
    pid = fork(1);
    1b18:	4505                	li	a0,1
    1b1a:	7c5020ef          	jal	4ade <fork>
    if(pid < 0)
    1b1e:	06054063          	bltz	a0,1b7e <forktest+0x7c>
    if(pid == 0)
    1b22:	cd11                	beqz	a0,1b3e <forktest+0x3c>
  for(n=0; n<N; n++){
    1b24:	2485                	addiw	s1,s1,1
    1b26:	ff2499e3          	bne	s1,s2,1b18 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1b2a:	85ce                	mv	a1,s3
    1b2c:	00004517          	auipc	a0,0x4
    1b30:	18450513          	addi	a0,a0,388 # 5cb0 <malloc+0xcfe>
    1b34:	3ca030ef          	jal	4efe <printf>
    exit(1);
    1b38:	4505                	li	a0,1
    1b3a:	7ad020ef          	jal	4ae6 <exit>
      exit(0);
    1b3e:	7a9020ef          	jal	4ae6 <exit>
    printf("%s: no fork at all!\n", s);
    1b42:	85ce                	mv	a1,s3
    1b44:	00004517          	auipc	a0,0x4
    1b48:	12450513          	addi	a0,a0,292 # 5c68 <malloc+0xcb6>
    1b4c:	3b2030ef          	jal	4efe <printf>
    exit(1);
    1b50:	4505                	li	a0,1
    1b52:	795020ef          	jal	4ae6 <exit>
      printf("%s: wait stopped early\n", s);
    1b56:	85ce                	mv	a1,s3
    1b58:	00004517          	auipc	a0,0x4
    1b5c:	12850513          	addi	a0,a0,296 # 5c80 <malloc+0xcce>
    1b60:	39e030ef          	jal	4efe <printf>
      exit(1);
    1b64:	4505                	li	a0,1
    1b66:	781020ef          	jal	4ae6 <exit>
    printf("%s: wait got too many\n", s);
    1b6a:	85ce                	mv	a1,s3
    1b6c:	00004517          	auipc	a0,0x4
    1b70:	12c50513          	addi	a0,a0,300 # 5c98 <malloc+0xce6>
    1b74:	38a030ef          	jal	4efe <printf>
    exit(1);
    1b78:	4505                	li	a0,1
    1b7a:	76d020ef          	jal	4ae6 <exit>
  if (n == 0) {
    1b7e:	d0f1                	beqz	s1,1b42 <forktest+0x40>
  for(; n > 0; n--){
    1b80:	00905963          	blez	s1,1b92 <forktest+0x90>
    if(wait(0) < 0){
    1b84:	4501                	li	a0,0
    1b86:	769020ef          	jal	4aee <wait>
    1b8a:	fc0546e3          	bltz	a0,1b56 <forktest+0x54>
  for(; n > 0; n--){
    1b8e:	34fd                	addiw	s1,s1,-1
    1b90:	f8f5                	bnez	s1,1b84 <forktest+0x82>
  if(wait(0) != -1){
    1b92:	4501                	li	a0,0
    1b94:	75b020ef          	jal	4aee <wait>
    1b98:	57fd                	li	a5,-1
    1b9a:	fcf518e3          	bne	a0,a5,1b6a <forktest+0x68>
}
    1b9e:	70a2                	ld	ra,40(sp)
    1ba0:	7402                	ld	s0,32(sp)
    1ba2:	64e2                	ld	s1,24(sp)
    1ba4:	6942                	ld	s2,16(sp)
    1ba6:	69a2                	ld	s3,8(sp)
    1ba8:	6145                	addi	sp,sp,48
    1baa:	8082                	ret

0000000000001bac <kernmem>:
{
    1bac:	715d                	addi	sp,sp,-80
    1bae:	e486                	sd	ra,72(sp)
    1bb0:	e0a2                	sd	s0,64(sp)
    1bb2:	fc26                	sd	s1,56(sp)
    1bb4:	f84a                	sd	s2,48(sp)
    1bb6:	f44e                	sd	s3,40(sp)
    1bb8:	f052                	sd	s4,32(sp)
    1bba:	ec56                	sd	s5,24(sp)
    1bbc:	0880                	addi	s0,sp,80
    1bbe:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bc0:	4485                	li	s1,1
    1bc2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1bc4:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bc6:	69b1                	lui	s3,0xc
    1bc8:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    1bcc:	1003d937          	lui	s2,0x1003d
    1bd0:	090e                	slli	s2,s2,0x3
    1bd2:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork(1);
    1bd6:	4505                	li	a0,1
    1bd8:	707020ef          	jal	4ade <fork>
    if(pid < 0){
    1bdc:	02054763          	bltz	a0,1c0a <kernmem+0x5e>
    if(pid == 0){
    1be0:	cd1d                	beqz	a0,1c1e <kernmem+0x72>
    wait(&xstatus);
    1be2:	fbc40513          	addi	a0,s0,-68
    1be6:	709020ef          	jal	4aee <wait>
    if(xstatus != -1)  // did kernel kill child?
    1bea:	fbc42783          	lw	a5,-68(s0)
    1bee:	05479563          	bne	a5,s4,1c38 <kernmem+0x8c>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bf2:	94ce                	add	s1,s1,s3
    1bf4:	ff2491e3          	bne	s1,s2,1bd6 <kernmem+0x2a>
}
    1bf8:	60a6                	ld	ra,72(sp)
    1bfa:	6406                	ld	s0,64(sp)
    1bfc:	74e2                	ld	s1,56(sp)
    1bfe:	7942                	ld	s2,48(sp)
    1c00:	79a2                	ld	s3,40(sp)
    1c02:	7a02                	ld	s4,32(sp)
    1c04:	6ae2                	ld	s5,24(sp)
    1c06:	6161                	addi	sp,sp,80
    1c08:	8082                	ret
      printf("%s: fork17 failed\n", s);
    1c0a:	85d6                	mv	a1,s5
    1c0c:	00004517          	auipc	a0,0x4
    1c10:	0cc50513          	addi	a0,a0,204 # 5cd8 <malloc+0xd26>
    1c14:	2ea030ef          	jal	4efe <printf>
      exit(1);
    1c18:	4505                	li	a0,1
    1c1a:	6cd020ef          	jal	4ae6 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1c1e:	0004c683          	lbu	a3,0(s1)
    1c22:	8626                	mv	a2,s1
    1c24:	85d6                	mv	a1,s5
    1c26:	00004517          	auipc	a0,0x4
    1c2a:	0ca50513          	addi	a0,a0,202 # 5cf0 <malloc+0xd3e>
    1c2e:	2d0030ef          	jal	4efe <printf>
      exit(1);
    1c32:	4505                	li	a0,1
    1c34:	6b3020ef          	jal	4ae6 <exit>
      exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	6ad020ef          	jal	4ae6 <exit>

0000000000001c3e <MAXVAplus>:
{
    1c3e:	7179                	addi	sp,sp,-48
    1c40:	f406                	sd	ra,40(sp)
    1c42:	f022                	sd	s0,32(sp)
    1c44:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c46:	4785                	li	a5,1
    1c48:	179a                	slli	a5,a5,0x26
    1c4a:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c4e:	fd843783          	ld	a5,-40(s0)
    1c52:	cf8d                	beqz	a5,1c8c <MAXVAplus+0x4e>
    1c54:	ec26                	sd	s1,24(sp)
    1c56:	e84a                	sd	s2,16(sp)
    1c58:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c5a:	54fd                	li	s1,-1
    pid = fork(1);
    1c5c:	4505                	li	a0,1
    1c5e:	681020ef          	jal	4ade <fork>
    if(pid < 0){
    1c62:	02054963          	bltz	a0,1c94 <MAXVAplus+0x56>
    if(pid == 0){
    1c66:	c129                	beqz	a0,1ca8 <MAXVAplus+0x6a>
    wait(&xstatus);
    1c68:	fd440513          	addi	a0,s0,-44
    1c6c:	683020ef          	jal	4aee <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c70:	fd442783          	lw	a5,-44(s0)
    1c74:	04979c63          	bne	a5,s1,1ccc <MAXVAplus+0x8e>
  for( ; a != 0; a <<= 1){
    1c78:	fd843783          	ld	a5,-40(s0)
    1c7c:	0786                	slli	a5,a5,0x1
    1c7e:	fcf43c23          	sd	a5,-40(s0)
    1c82:	fd843783          	ld	a5,-40(s0)
    1c86:	fbf9                	bnez	a5,1c5c <MAXVAplus+0x1e>
    1c88:	64e2                	ld	s1,24(sp)
    1c8a:	6942                	ld	s2,16(sp)
}
    1c8c:	70a2                	ld	ra,40(sp)
    1c8e:	7402                	ld	s0,32(sp)
    1c90:	6145                	addi	sp,sp,48
    1c92:	8082                	ret
      printf("%s: fork 18failed\n", s);
    1c94:	85ca                	mv	a1,s2
    1c96:	00004517          	auipc	a0,0x4
    1c9a:	07a50513          	addi	a0,a0,122 # 5d10 <malloc+0xd5e>
    1c9e:	260030ef          	jal	4efe <printf>
      exit(1);
    1ca2:	4505                	li	a0,1
    1ca4:	643020ef          	jal	4ae6 <exit>
      *(char*)a = 99;
    1ca8:	fd843783          	ld	a5,-40(s0)
    1cac:	06300713          	li	a4,99
    1cb0:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1cb4:	fd843603          	ld	a2,-40(s0)
    1cb8:	85ca                	mv	a1,s2
    1cba:	00004517          	auipc	a0,0x4
    1cbe:	06e50513          	addi	a0,a0,110 # 5d28 <malloc+0xd76>
    1cc2:	23c030ef          	jal	4efe <printf>
      exit(1);
    1cc6:	4505                	li	a0,1
    1cc8:	61f020ef          	jal	4ae6 <exit>
      exit(1);
    1ccc:	4505                	li	a0,1
    1cce:	619020ef          	jal	4ae6 <exit>

0000000000001cd2 <stacktest>:
{
    1cd2:	7179                	addi	sp,sp,-48
    1cd4:	f406                	sd	ra,40(sp)
    1cd6:	f022                	sd	s0,32(sp)
    1cd8:	ec26                	sd	s1,24(sp)
    1cda:	1800                	addi	s0,sp,48
    1cdc:	84aa                	mv	s1,a0
  pid = fork(1);
    1cde:	4505                	li	a0,1
    1ce0:	5ff020ef          	jal	4ade <fork>
  if(pid == 0) {
    1ce4:	cd11                	beqz	a0,1d00 <stacktest+0x2e>
  } else if(pid < 0){
    1ce6:	02054c63          	bltz	a0,1d1e <stacktest+0x4c>
  wait(&xstatus);
    1cea:	fdc40513          	addi	a0,s0,-36
    1cee:	601020ef          	jal	4aee <wait>
  if(xstatus == -1)  // kernel killed child?
    1cf2:	fdc42503          	lw	a0,-36(s0)
    1cf6:	57fd                	li	a5,-1
    1cf8:	02f50d63          	beq	a0,a5,1d32 <stacktest+0x60>
    exit(xstatus);
    1cfc:	5eb020ef          	jal	4ae6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1d00:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1d02:	77fd                	lui	a5,0xfffff
    1d04:	97ba                	add	a5,a5,a4
    1d06:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    1d0a:	85a6                	mv	a1,s1
    1d0c:	00004517          	auipc	a0,0x4
    1d10:	03450513          	addi	a0,a0,52 # 5d40 <malloc+0xd8e>
    1d14:	1ea030ef          	jal	4efe <printf>
    exit(1);
    1d18:	4505                	li	a0,1
    1d1a:	5cd020ef          	jal	4ae6 <exit>
    printf("%s: fork11111 failed\n", s);
    1d1e:	85a6                	mv	a1,s1
    1d20:	00004517          	auipc	a0,0x4
    1d24:	04850513          	addi	a0,a0,72 # 5d68 <malloc+0xdb6>
    1d28:	1d6030ef          	jal	4efe <printf>
    exit(1);
    1d2c:	4505                	li	a0,1
    1d2e:	5b9020ef          	jal	4ae6 <exit>
    exit(0);
    1d32:	4501                	li	a0,0
    1d34:	5b3020ef          	jal	4ae6 <exit>

0000000000001d38 <nowrite>:
{
    1d38:	7159                	addi	sp,sp,-112
    1d3a:	f486                	sd	ra,104(sp)
    1d3c:	f0a2                	sd	s0,96(sp)
    1d3e:	eca6                	sd	s1,88(sp)
    1d40:	e8ca                	sd	s2,80(sp)
    1d42:	e4ce                	sd	s3,72(sp)
    1d44:	1880                	addi	s0,sp,112
    1d46:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1d48:	00006797          	auipc	a5,0x6
    1d4c:	90078793          	addi	a5,a5,-1792 # 7648 <malloc+0x2696>
    1d50:	7788                	ld	a0,40(a5)
    1d52:	7b8c                	ld	a1,48(a5)
    1d54:	7f90                	ld	a2,56(a5)
    1d56:	63b4                	ld	a3,64(a5)
    1d58:	67b8                	ld	a4,72(a5)
    1d5a:	6bbc                	ld	a5,80(a5)
    1d5c:	f8a43c23          	sd	a0,-104(s0)
    1d60:	fab43023          	sd	a1,-96(s0)
    1d64:	fac43423          	sd	a2,-88(s0)
    1d68:	fad43823          	sd	a3,-80(s0)
    1d6c:	fae43c23          	sd	a4,-72(s0)
    1d70:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d74:	4481                	li	s1,0
    1d76:	4919                	li	s2,6
    pid = fork(1);
    1d78:	4505                	li	a0,1
    1d7a:	565020ef          	jal	4ade <fork>
    if(pid == 0) {
    1d7e:	c105                	beqz	a0,1d9e <nowrite+0x66>
    } else if(pid < 0){
    1d80:	04054263          	bltz	a0,1dc4 <nowrite+0x8c>
    wait(&xstatus);
    1d84:	fcc40513          	addi	a0,s0,-52
    1d88:	567020ef          	jal	4aee <wait>
    if(xstatus == 0){
    1d8c:	fcc42783          	lw	a5,-52(s0)
    1d90:	c7a1                	beqz	a5,1dd8 <nowrite+0xa0>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d92:	2485                	addiw	s1,s1,1
    1d94:	ff2492e3          	bne	s1,s2,1d78 <nowrite+0x40>
  exit(0);
    1d98:	4501                	li	a0,0
    1d9a:	54d020ef          	jal	4ae6 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d9e:	048e                	slli	s1,s1,0x3
    1da0:	fd048793          	addi	a5,s1,-48
    1da4:	008784b3          	add	s1,a5,s0
    1da8:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1dac:	47a9                	li	a5,10
    1dae:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1db0:	85ce                	mv	a1,s3
    1db2:	00004517          	auipc	a0,0x4
    1db6:	fce50513          	addi	a0,a0,-50 # 5d80 <malloc+0xdce>
    1dba:	144030ef          	jal	4efe <printf>
      exit(0);
    1dbe:	4501                	li	a0,0
    1dc0:	527020ef          	jal	4ae6 <exit>
      printf("%s: fork19 failed\n", s);
    1dc4:	85ce                	mv	a1,s3
    1dc6:	00004517          	auipc	a0,0x4
    1dca:	fda50513          	addi	a0,a0,-38 # 5da0 <malloc+0xdee>
    1dce:	130030ef          	jal	4efe <printf>
      exit(1);
    1dd2:	4505                	li	a0,1
    1dd4:	513020ef          	jal	4ae6 <exit>
      exit(1);
    1dd8:	4505                	li	a0,1
    1dda:	50d020ef          	jal	4ae6 <exit>

0000000000001dde <manywrites>:
{
    1dde:	711d                	addi	sp,sp,-96
    1de0:	ec86                	sd	ra,88(sp)
    1de2:	e8a2                	sd	s0,80(sp)
    1de4:	e4a6                	sd	s1,72(sp)
    1de6:	e0ca                	sd	s2,64(sp)
    1de8:	fc4e                	sd	s3,56(sp)
    1dea:	f456                	sd	s5,40(sp)
    1dec:	1080                	addi	s0,sp,96
    1dee:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1df0:	4981                	li	s3,0
    1df2:	4911                	li	s2,4
    int pid = fork(1);
    1df4:	4505                	li	a0,1
    1df6:	4e9020ef          	jal	4ade <fork>
    1dfa:	84aa                	mv	s1,a0
    if(pid < 0){
    1dfc:	02054963          	bltz	a0,1e2e <manywrites+0x50>
    if(pid == 0){
    1e00:	c139                	beqz	a0,1e46 <manywrites+0x68>
  for(int ci = 0; ci < nchildren; ci++){
    1e02:	2985                	addiw	s3,s3,1
    1e04:	ff2998e3          	bne	s3,s2,1df4 <manywrites+0x16>
    1e08:	f852                	sd	s4,48(sp)
    1e0a:	f05a                	sd	s6,32(sp)
    1e0c:	ec5e                	sd	s7,24(sp)
    1e0e:	4491                	li	s1,4
    int st = 0;
    1e10:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1e14:	fa840513          	addi	a0,s0,-88
    1e18:	4d7020ef          	jal	4aee <wait>
    if(st != 0)
    1e1c:	fa842503          	lw	a0,-88(s0)
    1e20:	0c051863          	bnez	a0,1ef0 <manywrites+0x112>
  for(int ci = 0; ci < nchildren; ci++){
    1e24:	34fd                	addiw	s1,s1,-1
    1e26:	f4ed                	bnez	s1,1e10 <manywrites+0x32>
  exit(0);
    1e28:	4501                	li	a0,0
    1e2a:	4bd020ef          	jal	4ae6 <exit>
    1e2e:	f852                	sd	s4,48(sp)
    1e30:	f05a                	sd	s6,32(sp)
    1e32:	ec5e                	sd	s7,24(sp)
      printf("fork24 failed\n");
    1e34:	00004517          	auipc	a0,0x4
    1e38:	f8450513          	addi	a0,a0,-124 # 5db8 <malloc+0xe06>
    1e3c:	0c2030ef          	jal	4efe <printf>
      exit(1);
    1e40:	4505                	li	a0,1
    1e42:	4a5020ef          	jal	4ae6 <exit>
    1e46:	f852                	sd	s4,48(sp)
    1e48:	f05a                	sd	s6,32(sp)
    1e4a:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    1e4c:	06200793          	li	a5,98
    1e50:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1e54:	0619879b          	addiw	a5,s3,97
    1e58:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1e5c:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e60:	fa840513          	addi	a0,s0,-88
    1e64:	4d3020ef          	jal	4b36 <unlink>
    1e68:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e6a:	0000bb17          	auipc	s6,0xb
    1e6e:	e0eb0b13          	addi	s6,s6,-498 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1e72:	8a26                	mv	s4,s1
    1e74:	0209c863          	bltz	s3,1ea4 <manywrites+0xc6>
          int fd = open(name, O_CREATE | O_RDWR);
    1e78:	20200593          	li	a1,514
    1e7c:	fa840513          	addi	a0,s0,-88
    1e80:	4a7020ef          	jal	4b26 <open>
    1e84:	892a                	mv	s2,a0
          if(fd < 0){
    1e86:	02054d63          	bltz	a0,1ec0 <manywrites+0xe2>
          int cc = write(fd, buf, sz);
    1e8a:	660d                	lui	a2,0x3
    1e8c:	85da                	mv	a1,s6
    1e8e:	479020ef          	jal	4b06 <write>
          if(cc != sz){
    1e92:	678d                	lui	a5,0x3
    1e94:	04f51263          	bne	a0,a5,1ed8 <manywrites+0xfa>
          close(fd);
    1e98:	854a                	mv	a0,s2
    1e9a:	475020ef          	jal	4b0e <close>
        for(int i = 0; i < ci+1; i++){
    1e9e:	2a05                	addiw	s4,s4,1
    1ea0:	fd49dce3          	bge	s3,s4,1e78 <manywrites+0x9a>
        unlink(name);
    1ea4:	fa840513          	addi	a0,s0,-88
    1ea8:	48f020ef          	jal	4b36 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1eac:	3bfd                	addiw	s7,s7,-1
    1eae:	fc0b92e3          	bnez	s7,1e72 <manywrites+0x94>
      unlink(name);
    1eb2:	fa840513          	addi	a0,s0,-88
    1eb6:	481020ef          	jal	4b36 <unlink>
      exit(0);
    1eba:	4501                	li	a0,0
    1ebc:	42b020ef          	jal	4ae6 <exit>
            printf("%s: cannot create %s\n", s, name);
    1ec0:	fa840613          	addi	a2,s0,-88
    1ec4:	85d6                	mv	a1,s5
    1ec6:	00004517          	auipc	a0,0x4
    1eca:	f0250513          	addi	a0,a0,-254 # 5dc8 <malloc+0xe16>
    1ece:	030030ef          	jal	4efe <printf>
            exit(1);
    1ed2:	4505                	li	a0,1
    1ed4:	413020ef          	jal	4ae6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1ed8:	86aa                	mv	a3,a0
    1eda:	660d                	lui	a2,0x3
    1edc:	85d6                	mv	a1,s5
    1ede:	00003517          	auipc	a0,0x3
    1ee2:	2da50513          	addi	a0,a0,730 # 51b8 <malloc+0x206>
    1ee6:	018030ef          	jal	4efe <printf>
            exit(1);
    1eea:	4505                	li	a0,1
    1eec:	3fb020ef          	jal	4ae6 <exit>
      exit(st);
    1ef0:	3f7020ef          	jal	4ae6 <exit>

0000000000001ef4 <copyinstr3>:
{
    1ef4:	7179                	addi	sp,sp,-48
    1ef6:	f406                	sd	ra,40(sp)
    1ef8:	f022                	sd	s0,32(sp)
    1efa:	ec26                	sd	s1,24(sp)
    1efc:	1800                	addi	s0,sp,48
  sbrk(8192);
    1efe:	6509                	lui	a0,0x2
    1f00:	46f020ef          	jal	4b6e <sbrk>
  uint64 top = (uint64) sbrk(0);
    1f04:	4501                	li	a0,0
    1f06:	469020ef          	jal	4b6e <sbrk>
  if((top % PGSIZE) != 0){
    1f0a:	03451793          	slli	a5,a0,0x34
    1f0e:	e7bd                	bnez	a5,1f7c <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1f10:	4501                	li	a0,0
    1f12:	45d020ef          	jal	4b6e <sbrk>
  if(top % PGSIZE){
    1f16:	03451793          	slli	a5,a0,0x34
    1f1a:	ebad                	bnez	a5,1f8c <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1f1c:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x7>
  *b = 'x';
    1f20:	07800793          	li	a5,120
    1f24:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1f28:	8526                	mv	a0,s1
    1f2a:	40d020ef          	jal	4b36 <unlink>
  if(ret != -1){
    1f2e:	57fd                	li	a5,-1
    1f30:	06f51763          	bne	a0,a5,1f9e <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1f34:	20100593          	li	a1,513
    1f38:	8526                	mv	a0,s1
    1f3a:	3ed020ef          	jal	4b26 <open>
  if(fd != -1){
    1f3e:	57fd                	li	a5,-1
    1f40:	06f51a63          	bne	a0,a5,1fb4 <copyinstr3+0xc0>
  ret = link(b, b);
    1f44:	85a6                	mv	a1,s1
    1f46:	8526                	mv	a0,s1
    1f48:	3ff020ef          	jal	4b46 <link>
  if(ret != -1){
    1f4c:	57fd                	li	a5,-1
    1f4e:	06f51e63          	bne	a0,a5,1fca <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1f52:	00005797          	auipc	a5,0x5
    1f56:	bb678793          	addi	a5,a5,-1098 # 6b08 <malloc+0x1b56>
    1f5a:	fcf43823          	sd	a5,-48(s0)
    1f5e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f62:	fd040593          	addi	a1,s0,-48
    1f66:	8526                	mv	a0,s1
    1f68:	3b7020ef          	jal	4b1e <exec>
  if(ret != -1){
    1f6c:	57fd                	li	a5,-1
    1f6e:	06f51a63          	bne	a0,a5,1fe2 <copyinstr3+0xee>
}
    1f72:	70a2                	ld	ra,40(sp)
    1f74:	7402                	ld	s0,32(sp)
    1f76:	64e2                	ld	s1,24(sp)
    1f78:	6145                	addi	sp,sp,48
    1f7a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f7c:	0347d513          	srli	a0,a5,0x34
    1f80:	6785                	lui	a5,0x1
    1f82:	40a7853b          	subw	a0,a5,a0
    1f86:	3e9020ef          	jal	4b6e <sbrk>
    1f8a:	b759                	j	1f10 <copyinstr3+0x1c>
    printf("oops\n");
    1f8c:	00004517          	auipc	a0,0x4
    1f90:	e5450513          	addi	a0,a0,-428 # 5de0 <malloc+0xe2e>
    1f94:	76b020ef          	jal	4efe <printf>
    exit(1);
    1f98:	4505                	li	a0,1
    1f9a:	34d020ef          	jal	4ae6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f9e:	862a                	mv	a2,a0
    1fa0:	85a6                	mv	a1,s1
    1fa2:	00004517          	auipc	a0,0x4
    1fa6:	8f650513          	addi	a0,a0,-1802 # 5898 <malloc+0x8e6>
    1faa:	755020ef          	jal	4efe <printf>
    exit(1);
    1fae:	4505                	li	a0,1
    1fb0:	337020ef          	jal	4ae6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1fb4:	862a                	mv	a2,a0
    1fb6:	85a6                	mv	a1,s1
    1fb8:	00004517          	auipc	a0,0x4
    1fbc:	90050513          	addi	a0,a0,-1792 # 58b8 <malloc+0x906>
    1fc0:	73f020ef          	jal	4efe <printf>
    exit(1);
    1fc4:	4505                	li	a0,1
    1fc6:	321020ef          	jal	4ae6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1fca:	86aa                	mv	a3,a0
    1fcc:	8626                	mv	a2,s1
    1fce:	85a6                	mv	a1,s1
    1fd0:	00004517          	auipc	a0,0x4
    1fd4:	90850513          	addi	a0,a0,-1784 # 58d8 <malloc+0x926>
    1fd8:	727020ef          	jal	4efe <printf>
    exit(1);
    1fdc:	4505                	li	a0,1
    1fde:	309020ef          	jal	4ae6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1fe2:	567d                	li	a2,-1
    1fe4:	85a6                	mv	a1,s1
    1fe6:	00004517          	auipc	a0,0x4
    1fea:	91a50513          	addi	a0,a0,-1766 # 5900 <malloc+0x94e>
    1fee:	711020ef          	jal	4efe <printf>
    exit(1);
    1ff2:	4505                	li	a0,1
    1ff4:	2f3020ef          	jal	4ae6 <exit>

0000000000001ff8 <rwsbrk>:
{
    1ff8:	1101                	addi	sp,sp,-32
    1ffa:	ec06                	sd	ra,24(sp)
    1ffc:	e822                	sd	s0,16(sp)
    1ffe:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2000:	6509                	lui	a0,0x2
    2002:	36d020ef          	jal	4b6e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2006:	57fd                	li	a5,-1
    2008:	04f50a63          	beq	a0,a5,205c <rwsbrk+0x64>
    200c:	e426                	sd	s1,8(sp)
    200e:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2010:	7579                	lui	a0,0xffffe
    2012:	35d020ef          	jal	4b6e <sbrk>
    2016:	57fd                	li	a5,-1
    2018:	04f50d63          	beq	a0,a5,2072 <rwsbrk+0x7a>
    201c:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    201e:	20100593          	li	a1,513
    2022:	00004517          	auipc	a0,0x4
    2026:	dfe50513          	addi	a0,a0,-514 # 5e20 <malloc+0xe6e>
    202a:	2fd020ef          	jal	4b26 <open>
    202e:	892a                	mv	s2,a0
  if(fd < 0){
    2030:	04054b63          	bltz	a0,2086 <rwsbrk+0x8e>
  n = write(fd, (void*)(a+4096), 1024);
    2034:	6785                	lui	a5,0x1
    2036:	94be                	add	s1,s1,a5
    2038:	40000613          	li	a2,1024
    203c:	85a6                	mv	a1,s1
    203e:	2c9020ef          	jal	4b06 <write>
    2042:	862a                	mv	a2,a0
  if(n >= 0){
    2044:	04054a63          	bltz	a0,2098 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    2048:	85a6                	mv	a1,s1
    204a:	00004517          	auipc	a0,0x4
    204e:	df650513          	addi	a0,a0,-522 # 5e40 <malloc+0xe8e>
    2052:	6ad020ef          	jal	4efe <printf>
    exit(1);
    2056:	4505                	li	a0,1
    2058:	28f020ef          	jal	4ae6 <exit>
    205c:	e426                	sd	s1,8(sp)
    205e:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2060:	00004517          	auipc	a0,0x4
    2064:	d8850513          	addi	a0,a0,-632 # 5de8 <malloc+0xe36>
    2068:	697020ef          	jal	4efe <printf>
    exit(1);
    206c:	4505                	li	a0,1
    206e:	279020ef          	jal	4ae6 <exit>
    2072:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2074:	00004517          	auipc	a0,0x4
    2078:	d8c50513          	addi	a0,a0,-628 # 5e00 <malloc+0xe4e>
    207c:	683020ef          	jal	4efe <printf>
    exit(1);
    2080:	4505                	li	a0,1
    2082:	265020ef          	jal	4ae6 <exit>
    printf("open(rwsbrk) failed\n");
    2086:	00004517          	auipc	a0,0x4
    208a:	da250513          	addi	a0,a0,-606 # 5e28 <malloc+0xe76>
    208e:	671020ef          	jal	4efe <printf>
    exit(1);
    2092:	4505                	li	a0,1
    2094:	253020ef          	jal	4ae6 <exit>
  close(fd);
    2098:	854a                	mv	a0,s2
    209a:	275020ef          	jal	4b0e <close>
  unlink("rwsbrk");
    209e:	00004517          	auipc	a0,0x4
    20a2:	d8250513          	addi	a0,a0,-638 # 5e20 <malloc+0xe6e>
    20a6:	291020ef          	jal	4b36 <unlink>
  fd = open("README", O_RDONLY);
    20aa:	4581                	li	a1,0
    20ac:	00003517          	auipc	a0,0x3
    20b0:	21450513          	addi	a0,a0,532 # 52c0 <malloc+0x30e>
    20b4:	273020ef          	jal	4b26 <open>
    20b8:	892a                	mv	s2,a0
  if(fd < 0){
    20ba:	02054363          	bltz	a0,20e0 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+4096), 10);
    20be:	4629                	li	a2,10
    20c0:	85a6                	mv	a1,s1
    20c2:	23d020ef          	jal	4afe <read>
    20c6:	862a                	mv	a2,a0
  if(n >= 0){
    20c8:	02054563          	bltz	a0,20f2 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    20cc:	85a6                	mv	a1,s1
    20ce:	00004517          	auipc	a0,0x4
    20d2:	da250513          	addi	a0,a0,-606 # 5e70 <malloc+0xebe>
    20d6:	629020ef          	jal	4efe <printf>
    exit(1);
    20da:	4505                	li	a0,1
    20dc:	20b020ef          	jal	4ae6 <exit>
    printf("open(rwsbrk) failed\n");
    20e0:	00004517          	auipc	a0,0x4
    20e4:	d4850513          	addi	a0,a0,-696 # 5e28 <malloc+0xe76>
    20e8:	617020ef          	jal	4efe <printf>
    exit(1);
    20ec:	4505                	li	a0,1
    20ee:	1f9020ef          	jal	4ae6 <exit>
  close(fd);
    20f2:	854a                	mv	a0,s2
    20f4:	21b020ef          	jal	4b0e <close>
  exit(0);
    20f8:	4501                	li	a0,0
    20fa:	1ed020ef          	jal	4ae6 <exit>

00000000000020fe <sbrkbasic>:
{
    20fe:	7139                	addi	sp,sp,-64
    2100:	fc06                	sd	ra,56(sp)
    2102:	f822                	sd	s0,48(sp)
    2104:	ec4e                	sd	s3,24(sp)
    2106:	0080                	addi	s0,sp,64
    2108:	89aa                	mv	s3,a0
  pid = fork(1);
    210a:	4505                	li	a0,1
    210c:	1d3020ef          	jal	4ade <fork>
  if(pid < 0){
    2110:	02054b63          	bltz	a0,2146 <sbrkbasic+0x48>
  if(pid == 0){
    2114:	e939                	bnez	a0,216a <sbrkbasic+0x6c>
    a = sbrk(TOOMUCH);
    2116:	40000537          	lui	a0,0x40000
    211a:	255020ef          	jal	4b6e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    211e:	57fd                	li	a5,-1
    2120:	02f50f63          	beq	a0,a5,215e <sbrkbasic+0x60>
    2124:	f426                	sd	s1,40(sp)
    2126:	f04a                	sd	s2,32(sp)
    2128:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    212a:	400007b7          	lui	a5,0x40000
    212e:	97aa                	add	a5,a5,a0
      *b = 99;
    2130:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2134:	6705                	lui	a4,0x1
      *b = 99;
    2136:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    213a:	953a                	add	a0,a0,a4
    213c:	fef51de3          	bne	a0,a5,2136 <sbrkbasic+0x38>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	1a5020ef          	jal	4ae6 <exit>
    2146:	f426                	sd	s1,40(sp)
    2148:	f04a                	sd	s2,32(sp)
    214a:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    214c:	00004517          	auipc	a0,0x4
    2150:	d4c50513          	addi	a0,a0,-692 # 5e98 <malloc+0xee6>
    2154:	5ab020ef          	jal	4efe <printf>
    exit(1);
    2158:	4505                	li	a0,1
    215a:	18d020ef          	jal	4ae6 <exit>
    215e:	f426                	sd	s1,40(sp)
    2160:	f04a                	sd	s2,32(sp)
    2162:	e852                	sd	s4,16(sp)
      exit(0);
    2164:	4501                	li	a0,0
    2166:	181020ef          	jal	4ae6 <exit>
  wait(&xstatus);
    216a:	fcc40513          	addi	a0,s0,-52
    216e:	181020ef          	jal	4aee <wait>
  if(xstatus == 1){
    2172:	fcc42703          	lw	a4,-52(s0)
    2176:	4785                	li	a5,1
    2178:	00f70e63          	beq	a4,a5,2194 <sbrkbasic+0x96>
    217c:	f426                	sd	s1,40(sp)
    217e:	f04a                	sd	s2,32(sp)
    2180:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    2182:	4501                	li	a0,0
    2184:	1eb020ef          	jal	4b6e <sbrk>
    2188:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    218a:	4901                	li	s2,0
    218c:	6a05                	lui	s4,0x1
    218e:	388a0a13          	addi	s4,s4,904 # 1388 <exectest+0x46>
    2192:	a839                	j	21b0 <sbrkbasic+0xb2>
    2194:	f426                	sd	s1,40(sp)
    2196:	f04a                	sd	s2,32(sp)
    2198:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    219a:	85ce                	mv	a1,s3
    219c:	00004517          	auipc	a0,0x4
    21a0:	d1c50513          	addi	a0,a0,-740 # 5eb8 <malloc+0xf06>
    21a4:	55b020ef          	jal	4efe <printf>
    exit(1);
    21a8:	4505                	li	a0,1
    21aa:	13d020ef          	jal	4ae6 <exit>
    21ae:	84be                	mv	s1,a5
    b = sbrk(1);
    21b0:	4505                	li	a0,1
    21b2:	1bd020ef          	jal	4b6e <sbrk>
    if(b != a){
    21b6:	04951363          	bne	a0,s1,21fc <sbrkbasic+0xfe>
    *b = 1;
    21ba:	4785                	li	a5,1
    21bc:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    21c0:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    21c4:	2905                	addiw	s2,s2,1
    21c6:	ff4914e3          	bne	s2,s4,21ae <sbrkbasic+0xb0>
  pid = fork(1);
    21ca:	4505                	li	a0,1
    21cc:	113020ef          	jal	4ade <fork>
    21d0:	892a                	mv	s2,a0
  if(pid < 0){
    21d2:	04054263          	bltz	a0,2216 <sbrkbasic+0x118>
  c = sbrk(1);
    21d6:	4505                	li	a0,1
    21d8:	197020ef          	jal	4b6e <sbrk>
  c = sbrk(1);
    21dc:	4505                	li	a0,1
    21de:	191020ef          	jal	4b6e <sbrk>
  if(c != a + 1){
    21e2:	0489                	addi	s1,s1,2
    21e4:	04a48363          	beq	s1,a0,222a <sbrkbasic+0x12c>
    printf("%s: sbrk test failed post-fork\n", s);
    21e8:	85ce                	mv	a1,s3
    21ea:	00004517          	auipc	a0,0x4
    21ee:	d2e50513          	addi	a0,a0,-722 # 5f18 <malloc+0xf66>
    21f2:	50d020ef          	jal	4efe <printf>
    exit(1);
    21f6:	4505                	li	a0,1
    21f8:	0ef020ef          	jal	4ae6 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    21fc:	872a                	mv	a4,a0
    21fe:	86a6                	mv	a3,s1
    2200:	864a                	mv	a2,s2
    2202:	85ce                	mv	a1,s3
    2204:	00004517          	auipc	a0,0x4
    2208:	cd450513          	addi	a0,a0,-812 # 5ed8 <malloc+0xf26>
    220c:	4f3020ef          	jal	4efe <printf>
      exit(1);
    2210:	4505                	li	a0,1
    2212:	0d5020ef          	jal	4ae6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2216:	85ce                	mv	a1,s3
    2218:	00004517          	auipc	a0,0x4
    221c:	ce050513          	addi	a0,a0,-800 # 5ef8 <malloc+0xf46>
    2220:	4df020ef          	jal	4efe <printf>
    exit(1);
    2224:	4505                	li	a0,1
    2226:	0c1020ef          	jal	4ae6 <exit>
  if(pid == 0)
    222a:	00091563          	bnez	s2,2234 <sbrkbasic+0x136>
    exit(0);
    222e:	4501                	li	a0,0
    2230:	0b7020ef          	jal	4ae6 <exit>
  wait(&xstatus);
    2234:	fcc40513          	addi	a0,s0,-52
    2238:	0b7020ef          	jal	4aee <wait>
  exit(xstatus);
    223c:	fcc42503          	lw	a0,-52(s0)
    2240:	0a7020ef          	jal	4ae6 <exit>

0000000000002244 <sbrkmuch>:
{
    2244:	7179                	addi	sp,sp,-48
    2246:	f406                	sd	ra,40(sp)
    2248:	f022                	sd	s0,32(sp)
    224a:	ec26                	sd	s1,24(sp)
    224c:	e84a                	sd	s2,16(sp)
    224e:	e44e                	sd	s3,8(sp)
    2250:	e052                	sd	s4,0(sp)
    2252:	1800                	addi	s0,sp,48
    2254:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2256:	4501                	li	a0,0
    2258:	117020ef          	jal	4b6e <sbrk>
    225c:	892a                	mv	s2,a0
  a = sbrk(0);
    225e:	4501                	li	a0,0
    2260:	10f020ef          	jal	4b6e <sbrk>
    2264:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2266:	06400537          	lui	a0,0x6400
    226a:	9d05                	subw	a0,a0,s1
    226c:	103020ef          	jal	4b6e <sbrk>
  if (p != a) {
    2270:	0aa49463          	bne	s1,a0,2318 <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    2274:	4501                	li	a0,0
    2276:	0f9020ef          	jal	4b6e <sbrk>
    227a:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    227c:	00a4f963          	bgeu	s1,a0,228e <sbrkmuch+0x4a>
    *pp = 1;
    2280:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2282:	6705                	lui	a4,0x1
    *pp = 1;
    2284:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2288:	94ba                	add	s1,s1,a4
    228a:	fef4ede3          	bltu	s1,a5,2284 <sbrkmuch+0x40>
  *lastaddr = 99;
    228e:	064007b7          	lui	a5,0x6400
    2292:	06300713          	li	a4,99
    2296:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    229a:	4501                	li	a0,0
    229c:	0d3020ef          	jal	4b6e <sbrk>
    22a0:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    22a2:	757d                	lui	a0,0xfffff
    22a4:	0cb020ef          	jal	4b6e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    22a8:	57fd                	li	a5,-1
    22aa:	08f50163          	beq	a0,a5,232c <sbrkmuch+0xe8>
  c = sbrk(0);
    22ae:	4501                	li	a0,0
    22b0:	0bf020ef          	jal	4b6e <sbrk>
  if(c != a - PGSIZE){
    22b4:	77fd                	lui	a5,0xfffff
    22b6:	97a6                	add	a5,a5,s1
    22b8:	08f51463          	bne	a0,a5,2340 <sbrkmuch+0xfc>
  a = sbrk(0);
    22bc:	4501                	li	a0,0
    22be:	0b1020ef          	jal	4b6e <sbrk>
    22c2:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    22c4:	6505                	lui	a0,0x1
    22c6:	0a9020ef          	jal	4b6e <sbrk>
    22ca:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    22cc:	08a49663          	bne	s1,a0,2358 <sbrkmuch+0x114>
    22d0:	4501                	li	a0,0
    22d2:	09d020ef          	jal	4b6e <sbrk>
    22d6:	6785                	lui	a5,0x1
    22d8:	97a6                	add	a5,a5,s1
    22da:	06f51f63          	bne	a0,a5,2358 <sbrkmuch+0x114>
  if(*lastaddr == 99){
    22de:	064007b7          	lui	a5,0x6400
    22e2:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    22e6:	06300793          	li	a5,99
    22ea:	08f70363          	beq	a4,a5,2370 <sbrkmuch+0x12c>
  a = sbrk(0);
    22ee:	4501                	li	a0,0
    22f0:	07f020ef          	jal	4b6e <sbrk>
    22f4:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    22f6:	4501                	li	a0,0
    22f8:	077020ef          	jal	4b6e <sbrk>
    22fc:	40a9053b          	subw	a0,s2,a0
    2300:	06f020ef          	jal	4b6e <sbrk>
  if(c != a){
    2304:	08a49063          	bne	s1,a0,2384 <sbrkmuch+0x140>
}
    2308:	70a2                	ld	ra,40(sp)
    230a:	7402                	ld	s0,32(sp)
    230c:	64e2                	ld	s1,24(sp)
    230e:	6942                	ld	s2,16(sp)
    2310:	69a2                	ld	s3,8(sp)
    2312:	6a02                	ld	s4,0(sp)
    2314:	6145                	addi	sp,sp,48
    2316:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2318:	85ce                	mv	a1,s3
    231a:	00004517          	auipc	a0,0x4
    231e:	c1e50513          	addi	a0,a0,-994 # 5f38 <malloc+0xf86>
    2322:	3dd020ef          	jal	4efe <printf>
    exit(1);
    2326:	4505                	li	a0,1
    2328:	7be020ef          	jal	4ae6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    232c:	85ce                	mv	a1,s3
    232e:	00004517          	auipc	a0,0x4
    2332:	c5250513          	addi	a0,a0,-942 # 5f80 <malloc+0xfce>
    2336:	3c9020ef          	jal	4efe <printf>
    exit(1);
    233a:	4505                	li	a0,1
    233c:	7aa020ef          	jal	4ae6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2340:	86aa                	mv	a3,a0
    2342:	8626                	mv	a2,s1
    2344:	85ce                	mv	a1,s3
    2346:	00004517          	auipc	a0,0x4
    234a:	c5a50513          	addi	a0,a0,-934 # 5fa0 <malloc+0xfee>
    234e:	3b1020ef          	jal	4efe <printf>
    exit(1);
    2352:	4505                	li	a0,1
    2354:	792020ef          	jal	4ae6 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    2358:	86d2                	mv	a3,s4
    235a:	8626                	mv	a2,s1
    235c:	85ce                	mv	a1,s3
    235e:	00004517          	auipc	a0,0x4
    2362:	c8250513          	addi	a0,a0,-894 # 5fe0 <malloc+0x102e>
    2366:	399020ef          	jal	4efe <printf>
    exit(1);
    236a:	4505                	li	a0,1
    236c:	77a020ef          	jal	4ae6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2370:	85ce                	mv	a1,s3
    2372:	00004517          	auipc	a0,0x4
    2376:	c9e50513          	addi	a0,a0,-866 # 6010 <malloc+0x105e>
    237a:	385020ef          	jal	4efe <printf>
    exit(1);
    237e:	4505                	li	a0,1
    2380:	766020ef          	jal	4ae6 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2384:	86aa                	mv	a3,a0
    2386:	8626                	mv	a2,s1
    2388:	85ce                	mv	a1,s3
    238a:	00004517          	auipc	a0,0x4
    238e:	cbe50513          	addi	a0,a0,-834 # 6048 <malloc+0x1096>
    2392:	36d020ef          	jal	4efe <printf>
    exit(1);
    2396:	4505                	li	a0,1
    2398:	74e020ef          	jal	4ae6 <exit>

000000000000239c <sbrkarg>:
{
    239c:	7179                	addi	sp,sp,-48
    239e:	f406                	sd	ra,40(sp)
    23a0:	f022                	sd	s0,32(sp)
    23a2:	ec26                	sd	s1,24(sp)
    23a4:	e84a                	sd	s2,16(sp)
    23a6:	e44e                	sd	s3,8(sp)
    23a8:	1800                	addi	s0,sp,48
    23aa:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    23ac:	6505                	lui	a0,0x1
    23ae:	7c0020ef          	jal	4b6e <sbrk>
    23b2:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    23b4:	20100593          	li	a1,513
    23b8:	00004517          	auipc	a0,0x4
    23bc:	cb850513          	addi	a0,a0,-840 # 6070 <malloc+0x10be>
    23c0:	766020ef          	jal	4b26 <open>
    23c4:	84aa                	mv	s1,a0
  unlink("sbrk");
    23c6:	00004517          	auipc	a0,0x4
    23ca:	caa50513          	addi	a0,a0,-854 # 6070 <malloc+0x10be>
    23ce:	768020ef          	jal	4b36 <unlink>
  if(fd < 0)  {
    23d2:	0204c963          	bltz	s1,2404 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    23d6:	6605                	lui	a2,0x1
    23d8:	85ca                	mv	a1,s2
    23da:	8526                	mv	a0,s1
    23dc:	72a020ef          	jal	4b06 <write>
    23e0:	02054c63          	bltz	a0,2418 <sbrkarg+0x7c>
  close(fd);
    23e4:	8526                	mv	a0,s1
    23e6:	728020ef          	jal	4b0e <close>
  a = sbrk(PGSIZE);
    23ea:	6505                	lui	a0,0x1
    23ec:	782020ef          	jal	4b6e <sbrk>
  if(pipe((int *) a) != 0){
    23f0:	706020ef          	jal	4af6 <pipe>
    23f4:	ed05                	bnez	a0,242c <sbrkarg+0x90>
}
    23f6:	70a2                	ld	ra,40(sp)
    23f8:	7402                	ld	s0,32(sp)
    23fa:	64e2                	ld	s1,24(sp)
    23fc:	6942                	ld	s2,16(sp)
    23fe:	69a2                	ld	s3,8(sp)
    2400:	6145                	addi	sp,sp,48
    2402:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2404:	85ce                	mv	a1,s3
    2406:	00004517          	auipc	a0,0x4
    240a:	c7250513          	addi	a0,a0,-910 # 6078 <malloc+0x10c6>
    240e:	2f1020ef          	jal	4efe <printf>
    exit(1);
    2412:	4505                	li	a0,1
    2414:	6d2020ef          	jal	4ae6 <exit>
    printf("%s: write sbrk failed\n", s);
    2418:	85ce                	mv	a1,s3
    241a:	00004517          	auipc	a0,0x4
    241e:	c7650513          	addi	a0,a0,-906 # 6090 <malloc+0x10de>
    2422:	2dd020ef          	jal	4efe <printf>
    exit(1);
    2426:	4505                	li	a0,1
    2428:	6be020ef          	jal	4ae6 <exit>
    printf("%s: pipe() failed\n", s);
    242c:	85ce                	mv	a1,s3
    242e:	00003517          	auipc	a0,0x3
    2432:	65250513          	addi	a0,a0,1618 # 5a80 <malloc+0xace>
    2436:	2c9020ef          	jal	4efe <printf>
    exit(1);
    243a:	4505                	li	a0,1
    243c:	6aa020ef          	jal	4ae6 <exit>

0000000000002440 <argptest>:
{
    2440:	1101                	addi	sp,sp,-32
    2442:	ec06                	sd	ra,24(sp)
    2444:	e822                	sd	s0,16(sp)
    2446:	e426                	sd	s1,8(sp)
    2448:	e04a                	sd	s2,0(sp)
    244a:	1000                	addi	s0,sp,32
    244c:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    244e:	4581                	li	a1,0
    2450:	00004517          	auipc	a0,0x4
    2454:	c5850513          	addi	a0,a0,-936 # 60a8 <malloc+0x10f6>
    2458:	6ce020ef          	jal	4b26 <open>
  if (fd < 0) {
    245c:	02054563          	bltz	a0,2486 <argptest+0x46>
    2460:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2462:	4501                	li	a0,0
    2464:	70a020ef          	jal	4b6e <sbrk>
    2468:	567d                	li	a2,-1
    246a:	fff50593          	addi	a1,a0,-1
    246e:	8526                	mv	a0,s1
    2470:	68e020ef          	jal	4afe <read>
  close(fd);
    2474:	8526                	mv	a0,s1
    2476:	698020ef          	jal	4b0e <close>
}
    247a:	60e2                	ld	ra,24(sp)
    247c:	6442                	ld	s0,16(sp)
    247e:	64a2                	ld	s1,8(sp)
    2480:	6902                	ld	s2,0(sp)
    2482:	6105                	addi	sp,sp,32
    2484:	8082                	ret
    printf("%s: open failed\n", s);
    2486:	85ca                	mv	a1,s2
    2488:	00003517          	auipc	a0,0x3
    248c:	50850513          	addi	a0,a0,1288 # 5990 <malloc+0x9de>
    2490:	26f020ef          	jal	4efe <printf>
    exit(1);
    2494:	4505                	li	a0,1
    2496:	650020ef          	jal	4ae6 <exit>

000000000000249a <sbrkbugs>:
{
    249a:	1141                	addi	sp,sp,-16
    249c:	e406                	sd	ra,8(sp)
    249e:	e022                	sd	s0,0(sp)
    24a0:	0800                	addi	s0,sp,16
  int pid = fork(1);
    24a2:	4505                	li	a0,1
    24a4:	63a020ef          	jal	4ade <fork>
  if(pid < 0){
    24a8:	00054c63          	bltz	a0,24c0 <sbrkbugs+0x26>
  if(pid == 0){
    24ac:	e11d                	bnez	a0,24d2 <sbrkbugs+0x38>
    int sz = (uint64) sbrk(0);
    24ae:	6c0020ef          	jal	4b6e <sbrk>
    sbrk(-sz);
    24b2:	40a0053b          	negw	a0,a0
    24b6:	6b8020ef          	jal	4b6e <sbrk>
    exit(0);
    24ba:	4501                	li	a0,0
    24bc:	62a020ef          	jal	4ae6 <exit>
    printf("fork20 failed\n");
    24c0:	00004517          	auipc	a0,0x4
    24c4:	bf050513          	addi	a0,a0,-1040 # 60b0 <malloc+0x10fe>
    24c8:	237020ef          	jal	4efe <printf>
    exit(1);
    24cc:	4505                	li	a0,1
    24ce:	618020ef          	jal	4ae6 <exit>
  wait(0);
    24d2:	4501                	li	a0,0
    24d4:	61a020ef          	jal	4aee <wait>
  pid = fork(1);
    24d8:	4505                	li	a0,1
    24da:	604020ef          	jal	4ade <fork>
  if(pid < 0){
    24de:	00054f63          	bltz	a0,24fc <sbrkbugs+0x62>
  if(pid == 0){
    24e2:	e515                	bnez	a0,250e <sbrkbugs+0x74>
    int sz = (uint64) sbrk(0);
    24e4:	68a020ef          	jal	4b6e <sbrk>
    sbrk(-(sz - 3500));
    24e8:	6785                	lui	a5,0x1
    24ea:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x138>
    24ee:	40a7853b          	subw	a0,a5,a0
    24f2:	67c020ef          	jal	4b6e <sbrk>
    exit(0);
    24f6:	4501                	li	a0,0
    24f8:	5ee020ef          	jal	4ae6 <exit>
    printf("fork21 failed\n");
    24fc:	00004517          	auipc	a0,0x4
    2500:	bc450513          	addi	a0,a0,-1084 # 60c0 <malloc+0x110e>
    2504:	1fb020ef          	jal	4efe <printf>
    exit(1);
    2508:	4505                	li	a0,1
    250a:	5dc020ef          	jal	4ae6 <exit>
  wait(0);
    250e:	4501                	li	a0,0
    2510:	5de020ef          	jal	4aee <wait>
  pid = fork(1);
    2514:	4505                	li	a0,1
    2516:	5c8020ef          	jal	4ade <fork>
  if(pid < 0){
    251a:	02054263          	bltz	a0,253e <sbrkbugs+0xa4>
  if(pid == 0){
    251e:	e90d                	bnez	a0,2550 <sbrkbugs+0xb6>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2520:	64e020ef          	jal	4b6e <sbrk>
    2524:	67ad                	lui	a5,0xb
    2526:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    252a:	40a7853b          	subw	a0,a5,a0
    252e:	640020ef          	jal	4b6e <sbrk>
    sbrk(-10);
    2532:	5559                	li	a0,-10
    2534:	63a020ef          	jal	4b6e <sbrk>
    exit(0);
    2538:	4501                	li	a0,0
    253a:	5ac020ef          	jal	4ae6 <exit>
    printf("fork22 failed\n");
    253e:	00004517          	auipc	a0,0x4
    2542:	b9250513          	addi	a0,a0,-1134 # 60d0 <malloc+0x111e>
    2546:	1b9020ef          	jal	4efe <printf>
    exit(1);
    254a:	4505                	li	a0,1
    254c:	59a020ef          	jal	4ae6 <exit>
  wait(0);
    2550:	4501                	li	a0,0
    2552:	59c020ef          	jal	4aee <wait>
  exit(0);
    2556:	4501                	li	a0,0
    2558:	58e020ef          	jal	4ae6 <exit>

000000000000255c <sbrklast>:
{
    255c:	7179                	addi	sp,sp,-48
    255e:	f406                	sd	ra,40(sp)
    2560:	f022                	sd	s0,32(sp)
    2562:	ec26                	sd	s1,24(sp)
    2564:	e84a                	sd	s2,16(sp)
    2566:	e44e                	sd	s3,8(sp)
    2568:	e052                	sd	s4,0(sp)
    256a:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    256c:	4501                	li	a0,0
    256e:	600020ef          	jal	4b6e <sbrk>
  if((top % 4096) != 0)
    2572:	03451793          	slli	a5,a0,0x34
    2576:	ebad                	bnez	a5,25e8 <sbrklast+0x8c>
  sbrk(4096);
    2578:	6505                	lui	a0,0x1
    257a:	5f4020ef          	jal	4b6e <sbrk>
  sbrk(10);
    257e:	4529                	li	a0,10
    2580:	5ee020ef          	jal	4b6e <sbrk>
  sbrk(-20);
    2584:	5531                	li	a0,-20
    2586:	5e8020ef          	jal	4b6e <sbrk>
  top = (uint64) sbrk(0);
    258a:	4501                	li	a0,0
    258c:	5e2020ef          	jal	4b6e <sbrk>
    2590:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2592:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x122>
  p[0] = 'x';
    2596:	07800a13          	li	s4,120
    259a:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    259e:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    25a2:	20200593          	li	a1,514
    25a6:	854a                	mv	a0,s2
    25a8:	57e020ef          	jal	4b26 <open>
    25ac:	89aa                	mv	s3,a0
  write(fd, p, 1);
    25ae:	4605                	li	a2,1
    25b0:	85ca                	mv	a1,s2
    25b2:	554020ef          	jal	4b06 <write>
  close(fd);
    25b6:	854e                	mv	a0,s3
    25b8:	556020ef          	jal	4b0e <close>
  fd = open(p, O_RDWR);
    25bc:	4589                	li	a1,2
    25be:	854a                	mv	a0,s2
    25c0:	566020ef          	jal	4b26 <open>
  p[0] = '\0';
    25c4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    25c8:	4605                	li	a2,1
    25ca:	85ca                	mv	a1,s2
    25cc:	532020ef          	jal	4afe <read>
  if(p[0] != 'x')
    25d0:	fc04c783          	lbu	a5,-64(s1)
    25d4:	03479263          	bne	a5,s4,25f8 <sbrklast+0x9c>
}
    25d8:	70a2                	ld	ra,40(sp)
    25da:	7402                	ld	s0,32(sp)
    25dc:	64e2                	ld	s1,24(sp)
    25de:	6942                	ld	s2,16(sp)
    25e0:	69a2                	ld	s3,8(sp)
    25e2:	6a02                	ld	s4,0(sp)
    25e4:	6145                	addi	sp,sp,48
    25e6:	8082                	ret
    sbrk(4096 - (top % 4096));
    25e8:	0347d513          	srli	a0,a5,0x34
    25ec:	6785                	lui	a5,0x1
    25ee:	40a7853b          	subw	a0,a5,a0
    25f2:	57c020ef          	jal	4b6e <sbrk>
    25f6:	b749                	j	2578 <sbrklast+0x1c>
    exit(1);
    25f8:	4505                	li	a0,1
    25fa:	4ec020ef          	jal	4ae6 <exit>

00000000000025fe <sbrk8000>:
{
    25fe:	1141                	addi	sp,sp,-16
    2600:	e406                	sd	ra,8(sp)
    2602:	e022                	sd	s0,0(sp)
    2604:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2606:	80000537          	lui	a0,0x80000
    260a:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    260c:	562020ef          	jal	4b6e <sbrk>
  volatile char *top = sbrk(0);
    2610:	4501                	li	a0,0
    2612:	55c020ef          	jal	4b6e <sbrk>
  *(top-1) = *(top-1) + 1;
    2616:	fff54783          	lbu	a5,-1(a0)
    261a:	2785                	addiw	a5,a5,1 # 1001 <badarg+0x1>
    261c:	0ff7f793          	zext.b	a5,a5
    2620:	fef50fa3          	sb	a5,-1(a0)
}
    2624:	60a2                	ld	ra,8(sp)
    2626:	6402                	ld	s0,0(sp)
    2628:	0141                	addi	sp,sp,16
    262a:	8082                	ret

000000000000262c <execout>:
{
    262c:	715d                	addi	sp,sp,-80
    262e:	e486                	sd	ra,72(sp)
    2630:	e0a2                	sd	s0,64(sp)
    2632:	fc26                	sd	s1,56(sp)
    2634:	f84a                	sd	s2,48(sp)
    2636:	f44e                	sd	s3,40(sp)
    2638:	f052                	sd	s4,32(sp)
    263a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    263c:	4901                	li	s2,0
    263e:	49bd                	li	s3,15
    int pid = fork(1);
    2640:	4505                	li	a0,1
    2642:	49c020ef          	jal	4ade <fork>
    2646:	84aa                	mv	s1,a0
    if(pid < 0){
    2648:	00054c63          	bltz	a0,2660 <execout+0x34>
    } else if(pid == 0){
    264c:	c11d                	beqz	a0,2672 <execout+0x46>
      wait((int*)0);
    264e:	4501                	li	a0,0
    2650:	49e020ef          	jal	4aee <wait>
  for(int avail = 0; avail < 15; avail++){
    2654:	2905                	addiw	s2,s2,1
    2656:	ff3915e3          	bne	s2,s3,2640 <execout+0x14>
  exit(0);
    265a:	4501                	li	a0,0
    265c:	48a020ef          	jal	4ae6 <exit>
      printf("fork25 failed\n");
    2660:	00004517          	auipc	a0,0x4
    2664:	a8050513          	addi	a0,a0,-1408 # 60e0 <malloc+0x112e>
    2668:	097020ef          	jal	4efe <printf>
      exit(1);
    266c:	4505                	li	a0,1
    266e:	478020ef          	jal	4ae6 <exit>
        if(a == 0xffffffffffffffffLL)
    2672:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2674:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2676:	6505                	lui	a0,0x1
    2678:	4f6020ef          	jal	4b6e <sbrk>
        if(a == 0xffffffffffffffffLL)
    267c:	01350763          	beq	a0,s3,268a <execout+0x5e>
        *(char*)(a + 4096 - 1) = 1;
    2680:	6785                	lui	a5,0x1
    2682:	97aa                	add	a5,a5,a0
    2684:	ff478fa3          	sb	s4,-1(a5) # fff <pgbug+0x2b>
      while(1){
    2688:	b7fd                	j	2676 <execout+0x4a>
      for(int i = 0; i < avail; i++)
    268a:	01205863          	blez	s2,269a <execout+0x6e>
        sbrk(-4096);
    268e:	757d                	lui	a0,0xfffff
    2690:	4de020ef          	jal	4b6e <sbrk>
      for(int i = 0; i < avail; i++)
    2694:	2485                	addiw	s1,s1,1
    2696:	ff249ce3          	bne	s1,s2,268e <execout+0x62>
      close(1);
    269a:	4505                	li	a0,1
    269c:	472020ef          	jal	4b0e <close>
      char *args[] = { "echo", "x", 0 };
    26a0:	00003517          	auipc	a0,0x3
    26a4:	a4850513          	addi	a0,a0,-1464 # 50e8 <malloc+0x136>
    26a8:	faa43c23          	sd	a0,-72(s0)
    26ac:	00003797          	auipc	a5,0x3
    26b0:	aac78793          	addi	a5,a5,-1364 # 5158 <malloc+0x1a6>
    26b4:	fcf43023          	sd	a5,-64(s0)
    26b8:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    26bc:	fb840593          	addi	a1,s0,-72
    26c0:	45e020ef          	jal	4b1e <exec>
      exit(0);
    26c4:	4501                	li	a0,0
    26c6:	420020ef          	jal	4ae6 <exit>

00000000000026ca <fourteen>:
{
    26ca:	1101                	addi	sp,sp,-32
    26cc:	ec06                	sd	ra,24(sp)
    26ce:	e822                	sd	s0,16(sp)
    26d0:	e426                	sd	s1,8(sp)
    26d2:	1000                	addi	s0,sp,32
    26d4:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    26d6:	00004517          	auipc	a0,0x4
    26da:	bea50513          	addi	a0,a0,-1046 # 62c0 <malloc+0x130e>
    26de:	470020ef          	jal	4b4e <mkdir>
    26e2:	e555                	bnez	a0,278e <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    26e4:	00004517          	auipc	a0,0x4
    26e8:	a3450513          	addi	a0,a0,-1484 # 6118 <malloc+0x1166>
    26ec:	462020ef          	jal	4b4e <mkdir>
    26f0:	e94d                	bnez	a0,27a2 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    26f2:	20000593          	li	a1,512
    26f6:	00004517          	auipc	a0,0x4
    26fa:	a7a50513          	addi	a0,a0,-1414 # 6170 <malloc+0x11be>
    26fe:	428020ef          	jal	4b26 <open>
  if(fd < 0){
    2702:	0a054a63          	bltz	a0,27b6 <fourteen+0xec>
  close(fd);
    2706:	408020ef          	jal	4b0e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    270a:	4581                	li	a1,0
    270c:	00004517          	auipc	a0,0x4
    2710:	adc50513          	addi	a0,a0,-1316 # 61e8 <malloc+0x1236>
    2714:	412020ef          	jal	4b26 <open>
  if(fd < 0){
    2718:	0a054963          	bltz	a0,27ca <fourteen+0x100>
  close(fd);
    271c:	3f2020ef          	jal	4b0e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2720:	00004517          	auipc	a0,0x4
    2724:	b3850513          	addi	a0,a0,-1224 # 6258 <malloc+0x12a6>
    2728:	426020ef          	jal	4b4e <mkdir>
    272c:	c94d                	beqz	a0,27de <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    272e:	00004517          	auipc	a0,0x4
    2732:	b8250513          	addi	a0,a0,-1150 # 62b0 <malloc+0x12fe>
    2736:	418020ef          	jal	4b4e <mkdir>
    273a:	cd45                	beqz	a0,27f2 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    273c:	00004517          	auipc	a0,0x4
    2740:	b7450513          	addi	a0,a0,-1164 # 62b0 <malloc+0x12fe>
    2744:	3f2020ef          	jal	4b36 <unlink>
  unlink("12345678901234/12345678901234");
    2748:	00004517          	auipc	a0,0x4
    274c:	b1050513          	addi	a0,a0,-1264 # 6258 <malloc+0x12a6>
    2750:	3e6020ef          	jal	4b36 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2754:	00004517          	auipc	a0,0x4
    2758:	a9450513          	addi	a0,a0,-1388 # 61e8 <malloc+0x1236>
    275c:	3da020ef          	jal	4b36 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2760:	00004517          	auipc	a0,0x4
    2764:	a1050513          	addi	a0,a0,-1520 # 6170 <malloc+0x11be>
    2768:	3ce020ef          	jal	4b36 <unlink>
  unlink("12345678901234/123456789012345");
    276c:	00004517          	auipc	a0,0x4
    2770:	9ac50513          	addi	a0,a0,-1620 # 6118 <malloc+0x1166>
    2774:	3c2020ef          	jal	4b36 <unlink>
  unlink("12345678901234");
    2778:	00004517          	auipc	a0,0x4
    277c:	b4850513          	addi	a0,a0,-1208 # 62c0 <malloc+0x130e>
    2780:	3b6020ef          	jal	4b36 <unlink>
}
    2784:	60e2                	ld	ra,24(sp)
    2786:	6442                	ld	s0,16(sp)
    2788:	64a2                	ld	s1,8(sp)
    278a:	6105                	addi	sp,sp,32
    278c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    278e:	85a6                	mv	a1,s1
    2790:	00004517          	auipc	a0,0x4
    2794:	96050513          	addi	a0,a0,-1696 # 60f0 <malloc+0x113e>
    2798:	766020ef          	jal	4efe <printf>
    exit(1);
    279c:	4505                	li	a0,1
    279e:	348020ef          	jal	4ae6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    27a2:	85a6                	mv	a1,s1
    27a4:	00004517          	auipc	a0,0x4
    27a8:	99450513          	addi	a0,a0,-1644 # 6138 <malloc+0x1186>
    27ac:	752020ef          	jal	4efe <printf>
    exit(1);
    27b0:	4505                	li	a0,1
    27b2:	334020ef          	jal	4ae6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    27b6:	85a6                	mv	a1,s1
    27b8:	00004517          	auipc	a0,0x4
    27bc:	9e850513          	addi	a0,a0,-1560 # 61a0 <malloc+0x11ee>
    27c0:	73e020ef          	jal	4efe <printf>
    exit(1);
    27c4:	4505                	li	a0,1
    27c6:	320020ef          	jal	4ae6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    27ca:	85a6                	mv	a1,s1
    27cc:	00004517          	auipc	a0,0x4
    27d0:	a4c50513          	addi	a0,a0,-1460 # 6218 <malloc+0x1266>
    27d4:	72a020ef          	jal	4efe <printf>
    exit(1);
    27d8:	4505                	li	a0,1
    27da:	30c020ef          	jal	4ae6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    27de:	85a6                	mv	a1,s1
    27e0:	00004517          	auipc	a0,0x4
    27e4:	a9850513          	addi	a0,a0,-1384 # 6278 <malloc+0x12c6>
    27e8:	716020ef          	jal	4efe <printf>
    exit(1);
    27ec:	4505                	li	a0,1
    27ee:	2f8020ef          	jal	4ae6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    27f2:	85a6                	mv	a1,s1
    27f4:	00004517          	auipc	a0,0x4
    27f8:	adc50513          	addi	a0,a0,-1316 # 62d0 <malloc+0x131e>
    27fc:	702020ef          	jal	4efe <printf>
    exit(1);
    2800:	4505                	li	a0,1
    2802:	2e4020ef          	jal	4ae6 <exit>

0000000000002806 <diskfull>:
{
    2806:	b8010113          	addi	sp,sp,-1152
    280a:	46113c23          	sd	ra,1144(sp)
    280e:	46813823          	sd	s0,1136(sp)
    2812:	46913423          	sd	s1,1128(sp)
    2816:	47213023          	sd	s2,1120(sp)
    281a:	45313c23          	sd	s3,1112(sp)
    281e:	45413823          	sd	s4,1104(sp)
    2822:	45513423          	sd	s5,1096(sp)
    2826:	45613023          	sd	s6,1088(sp)
    282a:	43713c23          	sd	s7,1080(sp)
    282e:	43813823          	sd	s8,1072(sp)
    2832:	43913423          	sd	s9,1064(sp)
    2836:	48010413          	addi	s0,sp,1152
    283a:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    283c:	00004517          	auipc	a0,0x4
    2840:	acc50513          	addi	a0,a0,-1332 # 6308 <malloc+0x1356>
    2844:	2f2020ef          	jal	4b36 <unlink>
    2848:	03000993          	li	s3,48
    name[0] = 'b';
    284c:	06200b13          	li	s6,98
    name[1] = 'i';
    2850:	06900a93          	li	s5,105
    name[2] = 'g';
    2854:	06700a13          	li	s4,103
    2858:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    285c:	07f00c13          	li	s8,127
    2860:	aab9                	j	29be <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    2862:	b8040613          	addi	a2,s0,-1152
    2866:	85e6                	mv	a1,s9
    2868:	00004517          	auipc	a0,0x4
    286c:	ab050513          	addi	a0,a0,-1360 # 6318 <malloc+0x1366>
    2870:	68e020ef          	jal	4efe <printf>
      break;
    2874:	a039                	j	2882 <diskfull+0x7c>
        close(fd);
    2876:	854a                	mv	a0,s2
    2878:	296020ef          	jal	4b0e <close>
    close(fd);
    287c:	854a                	mv	a0,s2
    287e:	290020ef          	jal	4b0e <close>
  for(int i = 0; i < nzz; i++){
    2882:	4481                	li	s1,0
    name[0] = 'z';
    2884:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2888:	08000993          	li	s3,128
    name[0] = 'z';
    288c:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2890:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2894:	41f4d71b          	sraiw	a4,s1,0x1f
    2898:	01b7571b          	srliw	a4,a4,0x1b
    289c:	009707bb          	addw	a5,a4,s1
    28a0:	4057d69b          	sraiw	a3,a5,0x5
    28a4:	0306869b          	addiw	a3,a3,48
    28a8:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    28ac:	8bfd                	andi	a5,a5,31
    28ae:	9f99                	subw	a5,a5,a4
    28b0:	0307879b          	addiw	a5,a5,48
    28b4:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    28b8:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28bc:	ba040513          	addi	a0,s0,-1120
    28c0:	276020ef          	jal	4b36 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    28c4:	60200593          	li	a1,1538
    28c8:	ba040513          	addi	a0,s0,-1120
    28cc:	25a020ef          	jal	4b26 <open>
    if(fd < 0)
    28d0:	00054763          	bltz	a0,28de <diskfull+0xd8>
    close(fd);
    28d4:	23a020ef          	jal	4b0e <close>
  for(int i = 0; i < nzz; i++){
    28d8:	2485                	addiw	s1,s1,1
    28da:	fb3499e3          	bne	s1,s3,288c <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    28de:	00004517          	auipc	a0,0x4
    28e2:	a2a50513          	addi	a0,a0,-1494 # 6308 <malloc+0x1356>
    28e6:	268020ef          	jal	4b4e <mkdir>
    28ea:	12050063          	beqz	a0,2a0a <diskfull+0x204>
  unlink("diskfulldir");
    28ee:	00004517          	auipc	a0,0x4
    28f2:	a1a50513          	addi	a0,a0,-1510 # 6308 <malloc+0x1356>
    28f6:	240020ef          	jal	4b36 <unlink>
  for(int i = 0; i < nzz; i++){
    28fa:	4481                	li	s1,0
    name[0] = 'z';
    28fc:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2900:	08000993          	li	s3,128
    name[0] = 'z';
    2904:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2908:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    290c:	41f4d71b          	sraiw	a4,s1,0x1f
    2910:	01b7571b          	srliw	a4,a4,0x1b
    2914:	009707bb          	addw	a5,a4,s1
    2918:	4057d69b          	sraiw	a3,a5,0x5
    291c:	0306869b          	addiw	a3,a3,48
    2920:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2924:	8bfd                	andi	a5,a5,31
    2926:	9f99                	subw	a5,a5,a4
    2928:	0307879b          	addiw	a5,a5,48
    292c:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2930:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2934:	ba040513          	addi	a0,s0,-1120
    2938:	1fe020ef          	jal	4b36 <unlink>
  for(int i = 0; i < nzz; i++){
    293c:	2485                	addiw	s1,s1,1
    293e:	fd3493e3          	bne	s1,s3,2904 <diskfull+0xfe>
    2942:	03000493          	li	s1,48
    name[0] = 'b';
    2946:	06200a93          	li	s5,98
    name[1] = 'i';
    294a:	06900a13          	li	s4,105
    name[2] = 'g';
    294e:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    2952:	07f00913          	li	s2,127
    name[0] = 'b';
    2956:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    295a:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    295e:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    2962:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    2966:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    296a:	ba040513          	addi	a0,s0,-1120
    296e:	1c8020ef          	jal	4b36 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2972:	2485                	addiw	s1,s1,1
    2974:	0ff4f493          	zext.b	s1,s1
    2978:	fd249fe3          	bne	s1,s2,2956 <diskfull+0x150>
}
    297c:	47813083          	ld	ra,1144(sp)
    2980:	47013403          	ld	s0,1136(sp)
    2984:	46813483          	ld	s1,1128(sp)
    2988:	46013903          	ld	s2,1120(sp)
    298c:	45813983          	ld	s3,1112(sp)
    2990:	45013a03          	ld	s4,1104(sp)
    2994:	44813a83          	ld	s5,1096(sp)
    2998:	44013b03          	ld	s6,1088(sp)
    299c:	43813b83          	ld	s7,1080(sp)
    29a0:	43013c03          	ld	s8,1072(sp)
    29a4:	42813c83          	ld	s9,1064(sp)
    29a8:	48010113          	addi	sp,sp,1152
    29ac:	8082                	ret
    close(fd);
    29ae:	854a                	mv	a0,s2
    29b0:	15e020ef          	jal	4b0e <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    29b4:	2985                	addiw	s3,s3,1
    29b6:	0ff9f993          	zext.b	s3,s3
    29ba:	ed8984e3          	beq	s3,s8,2882 <diskfull+0x7c>
    name[0] = 'b';
    29be:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    29c2:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    29c6:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    29ca:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    29ce:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    29d2:	b8040513          	addi	a0,s0,-1152
    29d6:	160020ef          	jal	4b36 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29da:	60200593          	li	a1,1538
    29de:	b8040513          	addi	a0,s0,-1152
    29e2:	144020ef          	jal	4b26 <open>
    29e6:	892a                	mv	s2,a0
    if(fd < 0){
    29e8:	e6054de3          	bltz	a0,2862 <diskfull+0x5c>
    29ec:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    29ee:	40000613          	li	a2,1024
    29f2:	ba040593          	addi	a1,s0,-1120
    29f6:	854a                	mv	a0,s2
    29f8:	10e020ef          	jal	4b06 <write>
    29fc:	40000793          	li	a5,1024
    2a00:	e6f51be3          	bne	a0,a5,2876 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    2a04:	34fd                	addiw	s1,s1,-1
    2a06:	f4e5                	bnez	s1,29ee <diskfull+0x1e8>
    2a08:	b75d                	j	29ae <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2a0a:	85e6                	mv	a1,s9
    2a0c:	00004517          	auipc	a0,0x4
    2a10:	92c50513          	addi	a0,a0,-1748 # 6338 <malloc+0x1386>
    2a14:	4ea020ef          	jal	4efe <printf>
    2a18:	bdd9                	j	28ee <diskfull+0xe8>

0000000000002a1a <iputtest>:
{
    2a1a:	1101                	addi	sp,sp,-32
    2a1c:	ec06                	sd	ra,24(sp)
    2a1e:	e822                	sd	s0,16(sp)
    2a20:	e426                	sd	s1,8(sp)
    2a22:	1000                	addi	s0,sp,32
    2a24:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2a26:	00004517          	auipc	a0,0x4
    2a2a:	94250513          	addi	a0,a0,-1726 # 6368 <malloc+0x13b6>
    2a2e:	120020ef          	jal	4b4e <mkdir>
    2a32:	02054f63          	bltz	a0,2a70 <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2a36:	00004517          	auipc	a0,0x4
    2a3a:	93250513          	addi	a0,a0,-1742 # 6368 <malloc+0x13b6>
    2a3e:	118020ef          	jal	4b56 <chdir>
    2a42:	04054163          	bltz	a0,2a84 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2a46:	00004517          	auipc	a0,0x4
    2a4a:	96250513          	addi	a0,a0,-1694 # 63a8 <malloc+0x13f6>
    2a4e:	0e8020ef          	jal	4b36 <unlink>
    2a52:	04054363          	bltz	a0,2a98 <iputtest+0x7e>
  if(chdir("/") < 0){
    2a56:	00004517          	auipc	a0,0x4
    2a5a:	98250513          	addi	a0,a0,-1662 # 63d8 <malloc+0x1426>
    2a5e:	0f8020ef          	jal	4b56 <chdir>
    2a62:	04054563          	bltz	a0,2aac <iputtest+0x92>
}
    2a66:	60e2                	ld	ra,24(sp)
    2a68:	6442                	ld	s0,16(sp)
    2a6a:	64a2                	ld	s1,8(sp)
    2a6c:	6105                	addi	sp,sp,32
    2a6e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2a70:	85a6                	mv	a1,s1
    2a72:	00004517          	auipc	a0,0x4
    2a76:	8fe50513          	addi	a0,a0,-1794 # 6370 <malloc+0x13be>
    2a7a:	484020ef          	jal	4efe <printf>
    exit(1);
    2a7e:	4505                	li	a0,1
    2a80:	066020ef          	jal	4ae6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2a84:	85a6                	mv	a1,s1
    2a86:	00004517          	auipc	a0,0x4
    2a8a:	90250513          	addi	a0,a0,-1790 # 6388 <malloc+0x13d6>
    2a8e:	470020ef          	jal	4efe <printf>
    exit(1);
    2a92:	4505                	li	a0,1
    2a94:	052020ef          	jal	4ae6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a98:	85a6                	mv	a1,s1
    2a9a:	00004517          	auipc	a0,0x4
    2a9e:	91e50513          	addi	a0,a0,-1762 # 63b8 <malloc+0x1406>
    2aa2:	45c020ef          	jal	4efe <printf>
    exit(1);
    2aa6:	4505                	li	a0,1
    2aa8:	03e020ef          	jal	4ae6 <exit>
    printf("%s: chdir / failed\n", s);
    2aac:	85a6                	mv	a1,s1
    2aae:	00004517          	auipc	a0,0x4
    2ab2:	93250513          	addi	a0,a0,-1742 # 63e0 <malloc+0x142e>
    2ab6:	448020ef          	jal	4efe <printf>
    exit(1);
    2aba:	4505                	li	a0,1
    2abc:	02a020ef          	jal	4ae6 <exit>

0000000000002ac0 <exitiputtest>:
{
    2ac0:	7179                	addi	sp,sp,-48
    2ac2:	f406                	sd	ra,40(sp)
    2ac4:	f022                	sd	s0,32(sp)
    2ac6:	ec26                	sd	s1,24(sp)
    2ac8:	1800                	addi	s0,sp,48
    2aca:	84aa                	mv	s1,a0
  pid = fork(1);
    2acc:	4505                	li	a0,1
    2ace:	010020ef          	jal	4ade <fork>
  if(pid < 0){
    2ad2:	02054e63          	bltz	a0,2b0e <exitiputtest+0x4e>
  if(pid == 0){
    2ad6:	e541                	bnez	a0,2b5e <exitiputtest+0x9e>
    if(mkdir("iputdir") < 0){
    2ad8:	00004517          	auipc	a0,0x4
    2adc:	89050513          	addi	a0,a0,-1904 # 6368 <malloc+0x13b6>
    2ae0:	06e020ef          	jal	4b4e <mkdir>
    2ae4:	02054f63          	bltz	a0,2b22 <exitiputtest+0x62>
    if(chdir("iputdir") < 0){
    2ae8:	00004517          	auipc	a0,0x4
    2aec:	88050513          	addi	a0,a0,-1920 # 6368 <malloc+0x13b6>
    2af0:	066020ef          	jal	4b56 <chdir>
    2af4:	04054163          	bltz	a0,2b36 <exitiputtest+0x76>
    if(unlink("../iputdir") < 0){
    2af8:	00004517          	auipc	a0,0x4
    2afc:	8b050513          	addi	a0,a0,-1872 # 63a8 <malloc+0x13f6>
    2b00:	036020ef          	jal	4b36 <unlink>
    2b04:	04054363          	bltz	a0,2b4a <exitiputtest+0x8a>
    exit(0);
    2b08:	4501                	li	a0,0
    2b0a:	7dd010ef          	jal	4ae6 <exit>
    printf("%s: fork failed\n", s);
    2b0e:	85a6                	mv	a1,s1
    2b10:	00003517          	auipc	a0,0x3
    2b14:	e6850513          	addi	a0,a0,-408 # 5978 <malloc+0x9c6>
    2b18:	3e6020ef          	jal	4efe <printf>
    exit(1);
    2b1c:	4505                	li	a0,1
    2b1e:	7c9010ef          	jal	4ae6 <exit>
      printf("%s: mkdir failed\n", s);
    2b22:	85a6                	mv	a1,s1
    2b24:	00004517          	auipc	a0,0x4
    2b28:	84c50513          	addi	a0,a0,-1972 # 6370 <malloc+0x13be>
    2b2c:	3d2020ef          	jal	4efe <printf>
      exit(1);
    2b30:	4505                	li	a0,1
    2b32:	7b5010ef          	jal	4ae6 <exit>
      printf("%s: child chdir failed\n", s);
    2b36:	85a6                	mv	a1,s1
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	8c050513          	addi	a0,a0,-1856 # 63f8 <malloc+0x1446>
    2b40:	3be020ef          	jal	4efe <printf>
      exit(1);
    2b44:	4505                	li	a0,1
    2b46:	7a1010ef          	jal	4ae6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2b4a:	85a6                	mv	a1,s1
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	86c50513          	addi	a0,a0,-1940 # 63b8 <malloc+0x1406>
    2b54:	3aa020ef          	jal	4efe <printf>
      exit(1);
    2b58:	4505                	li	a0,1
    2b5a:	78d010ef          	jal	4ae6 <exit>
  wait(&xstatus);
    2b5e:	fdc40513          	addi	a0,s0,-36
    2b62:	78d010ef          	jal	4aee <wait>
  exit(xstatus);
    2b66:	fdc42503          	lw	a0,-36(s0)
    2b6a:	77d010ef          	jal	4ae6 <exit>

0000000000002b6e <dirtest>:
{
    2b6e:	1101                	addi	sp,sp,-32
    2b70:	ec06                	sd	ra,24(sp)
    2b72:	e822                	sd	s0,16(sp)
    2b74:	e426                	sd	s1,8(sp)
    2b76:	1000                	addi	s0,sp,32
    2b78:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2b7a:	00004517          	auipc	a0,0x4
    2b7e:	89650513          	addi	a0,a0,-1898 # 6410 <malloc+0x145e>
    2b82:	7cd010ef          	jal	4b4e <mkdir>
    2b86:	02054f63          	bltz	a0,2bc4 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2b8a:	00004517          	auipc	a0,0x4
    2b8e:	88650513          	addi	a0,a0,-1914 # 6410 <malloc+0x145e>
    2b92:	7c5010ef          	jal	4b56 <chdir>
    2b96:	04054163          	bltz	a0,2bd8 <dirtest+0x6a>
  if(chdir("..") < 0){
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	89650513          	addi	a0,a0,-1898 # 6430 <malloc+0x147e>
    2ba2:	7b5010ef          	jal	4b56 <chdir>
    2ba6:	04054363          	bltz	a0,2bec <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2baa:	00004517          	auipc	a0,0x4
    2bae:	86650513          	addi	a0,a0,-1946 # 6410 <malloc+0x145e>
    2bb2:	785010ef          	jal	4b36 <unlink>
    2bb6:	04054563          	bltz	a0,2c00 <dirtest+0x92>
}
    2bba:	60e2                	ld	ra,24(sp)
    2bbc:	6442                	ld	s0,16(sp)
    2bbe:	64a2                	ld	s1,8(sp)
    2bc0:	6105                	addi	sp,sp,32
    2bc2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2bc4:	85a6                	mv	a1,s1
    2bc6:	00003517          	auipc	a0,0x3
    2bca:	7aa50513          	addi	a0,a0,1962 # 6370 <malloc+0x13be>
    2bce:	330020ef          	jal	4efe <printf>
    exit(1);
    2bd2:	4505                	li	a0,1
    2bd4:	713010ef          	jal	4ae6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2bd8:	85a6                	mv	a1,s1
    2bda:	00004517          	auipc	a0,0x4
    2bde:	83e50513          	addi	a0,a0,-1986 # 6418 <malloc+0x1466>
    2be2:	31c020ef          	jal	4efe <printf>
    exit(1);
    2be6:	4505                	li	a0,1
    2be8:	6ff010ef          	jal	4ae6 <exit>
    printf("%s: chdir .. failed\n", s);
    2bec:	85a6                	mv	a1,s1
    2bee:	00004517          	auipc	a0,0x4
    2bf2:	84a50513          	addi	a0,a0,-1974 # 6438 <malloc+0x1486>
    2bf6:	308020ef          	jal	4efe <printf>
    exit(1);
    2bfa:	4505                	li	a0,1
    2bfc:	6eb010ef          	jal	4ae6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2c00:	85a6                	mv	a1,s1
    2c02:	00004517          	auipc	a0,0x4
    2c06:	84e50513          	addi	a0,a0,-1970 # 6450 <malloc+0x149e>
    2c0a:	2f4020ef          	jal	4efe <printf>
    exit(1);
    2c0e:	4505                	li	a0,1
    2c10:	6d7010ef          	jal	4ae6 <exit>

0000000000002c14 <subdir>:
{
    2c14:	1101                	addi	sp,sp,-32
    2c16:	ec06                	sd	ra,24(sp)
    2c18:	e822                	sd	s0,16(sp)
    2c1a:	e426                	sd	s1,8(sp)
    2c1c:	e04a                	sd	s2,0(sp)
    2c1e:	1000                	addi	s0,sp,32
    2c20:	892a                	mv	s2,a0
  unlink("ff");
    2c22:	00004517          	auipc	a0,0x4
    2c26:	97650513          	addi	a0,a0,-1674 # 6598 <malloc+0x15e6>
    2c2a:	70d010ef          	jal	4b36 <unlink>
  if(mkdir("dd") != 0){
    2c2e:	00004517          	auipc	a0,0x4
    2c32:	83a50513          	addi	a0,a0,-1990 # 6468 <malloc+0x14b6>
    2c36:	719010ef          	jal	4b4e <mkdir>
    2c3a:	2e051263          	bnez	a0,2f1e <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2c3e:	20200593          	li	a1,514
    2c42:	00004517          	auipc	a0,0x4
    2c46:	84650513          	addi	a0,a0,-1978 # 6488 <malloc+0x14d6>
    2c4a:	6dd010ef          	jal	4b26 <open>
    2c4e:	84aa                	mv	s1,a0
  if(fd < 0){
    2c50:	2e054163          	bltz	a0,2f32 <subdir+0x31e>
  write(fd, "ff", 2);
    2c54:	4609                	li	a2,2
    2c56:	00004597          	auipc	a1,0x4
    2c5a:	94258593          	addi	a1,a1,-1726 # 6598 <malloc+0x15e6>
    2c5e:	6a9010ef          	jal	4b06 <write>
  close(fd);
    2c62:	8526                	mv	a0,s1
    2c64:	6ab010ef          	jal	4b0e <close>
  if(unlink("dd") >= 0){
    2c68:	00004517          	auipc	a0,0x4
    2c6c:	80050513          	addi	a0,a0,-2048 # 6468 <malloc+0x14b6>
    2c70:	6c7010ef          	jal	4b36 <unlink>
    2c74:	2c055963          	bgez	a0,2f46 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	86850513          	addi	a0,a0,-1944 # 64e0 <malloc+0x152e>
    2c80:	6cf010ef          	jal	4b4e <mkdir>
    2c84:	2c051b63          	bnez	a0,2f5a <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2c88:	20200593          	li	a1,514
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	87c50513          	addi	a0,a0,-1924 # 6508 <malloc+0x1556>
    2c94:	693010ef          	jal	4b26 <open>
    2c98:	84aa                	mv	s1,a0
  if(fd < 0){
    2c9a:	2c054a63          	bltz	a0,2f6e <subdir+0x35a>
  write(fd, "FF", 2);
    2c9e:	4609                	li	a2,2
    2ca0:	00004597          	auipc	a1,0x4
    2ca4:	89858593          	addi	a1,a1,-1896 # 6538 <malloc+0x1586>
    2ca8:	65f010ef          	jal	4b06 <write>
  close(fd);
    2cac:	8526                	mv	a0,s1
    2cae:	661010ef          	jal	4b0e <close>
  fd = open("dd/dd/../ff", 0);
    2cb2:	4581                	li	a1,0
    2cb4:	00004517          	auipc	a0,0x4
    2cb8:	88c50513          	addi	a0,a0,-1908 # 6540 <malloc+0x158e>
    2cbc:	66b010ef          	jal	4b26 <open>
    2cc0:	84aa                	mv	s1,a0
  if(fd < 0){
    2cc2:	2c054063          	bltz	a0,2f82 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2cc6:	660d                	lui	a2,0x3
    2cc8:	0000a597          	auipc	a1,0xa
    2ccc:	fb058593          	addi	a1,a1,-80 # cc78 <buf>
    2cd0:	62f010ef          	jal	4afe <read>
  if(cc != 2 || buf[0] != 'f'){
    2cd4:	4789                	li	a5,2
    2cd6:	2cf51063          	bne	a0,a5,2f96 <subdir+0x382>
    2cda:	0000a717          	auipc	a4,0xa
    2cde:	f9e74703          	lbu	a4,-98(a4) # cc78 <buf>
    2ce2:	06600793          	li	a5,102
    2ce6:	2af71863          	bne	a4,a5,2f96 <subdir+0x382>
  close(fd);
    2cea:	8526                	mv	a0,s1
    2cec:	623010ef          	jal	4b0e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2cf0:	00004597          	auipc	a1,0x4
    2cf4:	8a058593          	addi	a1,a1,-1888 # 6590 <malloc+0x15de>
    2cf8:	00004517          	auipc	a0,0x4
    2cfc:	81050513          	addi	a0,a0,-2032 # 6508 <malloc+0x1556>
    2d00:	647010ef          	jal	4b46 <link>
    2d04:	2a051363          	bnez	a0,2faa <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2d08:	00004517          	auipc	a0,0x4
    2d0c:	80050513          	addi	a0,a0,-2048 # 6508 <malloc+0x1556>
    2d10:	627010ef          	jal	4b36 <unlink>
    2d14:	2a051563          	bnez	a0,2fbe <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d18:	4581                	li	a1,0
    2d1a:	00003517          	auipc	a0,0x3
    2d1e:	7ee50513          	addi	a0,a0,2030 # 6508 <malloc+0x1556>
    2d22:	605010ef          	jal	4b26 <open>
    2d26:	2a055663          	bgez	a0,2fd2 <subdir+0x3be>
  if(chdir("dd") != 0){
    2d2a:	00003517          	auipc	a0,0x3
    2d2e:	73e50513          	addi	a0,a0,1854 # 6468 <malloc+0x14b6>
    2d32:	625010ef          	jal	4b56 <chdir>
    2d36:	2a051863          	bnez	a0,2fe6 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	8ee50513          	addi	a0,a0,-1810 # 6628 <malloc+0x1676>
    2d42:	615010ef          	jal	4b56 <chdir>
    2d46:	2a051a63          	bnez	a0,2ffa <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2d4a:	00004517          	auipc	a0,0x4
    2d4e:	90e50513          	addi	a0,a0,-1778 # 6658 <malloc+0x16a6>
    2d52:	605010ef          	jal	4b56 <chdir>
    2d56:	2a051c63          	bnez	a0,300e <subdir+0x3fa>
  if(chdir("./..") != 0){
    2d5a:	00004517          	auipc	a0,0x4
    2d5e:	93650513          	addi	a0,a0,-1738 # 6690 <malloc+0x16de>
    2d62:	5f5010ef          	jal	4b56 <chdir>
    2d66:	2a051e63          	bnez	a0,3022 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2d6a:	4581                	li	a1,0
    2d6c:	00004517          	auipc	a0,0x4
    2d70:	82450513          	addi	a0,a0,-2012 # 6590 <malloc+0x15de>
    2d74:	5b3010ef          	jal	4b26 <open>
    2d78:	84aa                	mv	s1,a0
  if(fd < 0){
    2d7a:	2a054e63          	bltz	a0,3036 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2d7e:	660d                	lui	a2,0x3
    2d80:	0000a597          	auipc	a1,0xa
    2d84:	ef858593          	addi	a1,a1,-264 # cc78 <buf>
    2d88:	577010ef          	jal	4afe <read>
    2d8c:	4789                	li	a5,2
    2d8e:	2af51e63          	bne	a0,a5,304a <subdir+0x436>
  close(fd);
    2d92:	8526                	mv	a0,s1
    2d94:	57b010ef          	jal	4b0e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d98:	4581                	li	a1,0
    2d9a:	00003517          	auipc	a0,0x3
    2d9e:	76e50513          	addi	a0,a0,1902 # 6508 <malloc+0x1556>
    2da2:	585010ef          	jal	4b26 <open>
    2da6:	2a055c63          	bgez	a0,305e <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2daa:	20200593          	li	a1,514
    2dae:	00004517          	auipc	a0,0x4
    2db2:	97250513          	addi	a0,a0,-1678 # 6720 <malloc+0x176e>
    2db6:	571010ef          	jal	4b26 <open>
    2dba:	2a055c63          	bgez	a0,3072 <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2dbe:	20200593          	li	a1,514
    2dc2:	00004517          	auipc	a0,0x4
    2dc6:	98e50513          	addi	a0,a0,-1650 # 6750 <malloc+0x179e>
    2dca:	55d010ef          	jal	4b26 <open>
    2dce:	2a055c63          	bgez	a0,3086 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2dd2:	20000593          	li	a1,512
    2dd6:	00003517          	auipc	a0,0x3
    2dda:	69250513          	addi	a0,a0,1682 # 6468 <malloc+0x14b6>
    2dde:	549010ef          	jal	4b26 <open>
    2de2:	2a055c63          	bgez	a0,309a <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2de6:	4589                	li	a1,2
    2de8:	00003517          	auipc	a0,0x3
    2dec:	68050513          	addi	a0,a0,1664 # 6468 <malloc+0x14b6>
    2df0:	537010ef          	jal	4b26 <open>
    2df4:	2a055d63          	bgez	a0,30ae <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2df8:	4585                	li	a1,1
    2dfa:	00003517          	auipc	a0,0x3
    2dfe:	66e50513          	addi	a0,a0,1646 # 6468 <malloc+0x14b6>
    2e02:	525010ef          	jal	4b26 <open>
    2e06:	2a055e63          	bgez	a0,30c2 <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2e0a:	00004597          	auipc	a1,0x4
    2e0e:	9d658593          	addi	a1,a1,-1578 # 67e0 <malloc+0x182e>
    2e12:	00004517          	auipc	a0,0x4
    2e16:	90e50513          	addi	a0,a0,-1778 # 6720 <malloc+0x176e>
    2e1a:	52d010ef          	jal	4b46 <link>
    2e1e:	2a050c63          	beqz	a0,30d6 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2e22:	00004597          	auipc	a1,0x4
    2e26:	9be58593          	addi	a1,a1,-1602 # 67e0 <malloc+0x182e>
    2e2a:	00004517          	auipc	a0,0x4
    2e2e:	92650513          	addi	a0,a0,-1754 # 6750 <malloc+0x179e>
    2e32:	515010ef          	jal	4b46 <link>
    2e36:	2a050a63          	beqz	a0,30ea <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2e3a:	00003597          	auipc	a1,0x3
    2e3e:	75658593          	addi	a1,a1,1878 # 6590 <malloc+0x15de>
    2e42:	00003517          	auipc	a0,0x3
    2e46:	64650513          	addi	a0,a0,1606 # 6488 <malloc+0x14d6>
    2e4a:	4fd010ef          	jal	4b46 <link>
    2e4e:	2a050863          	beqz	a0,30fe <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2e52:	00004517          	auipc	a0,0x4
    2e56:	8ce50513          	addi	a0,a0,-1842 # 6720 <malloc+0x176e>
    2e5a:	4f5010ef          	jal	4b4e <mkdir>
    2e5e:	2a050a63          	beqz	a0,3112 <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2e62:	00004517          	auipc	a0,0x4
    2e66:	8ee50513          	addi	a0,a0,-1810 # 6750 <malloc+0x179e>
    2e6a:	4e5010ef          	jal	4b4e <mkdir>
    2e6e:	2a050c63          	beqz	a0,3126 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2e72:	00003517          	auipc	a0,0x3
    2e76:	71e50513          	addi	a0,a0,1822 # 6590 <malloc+0x15de>
    2e7a:	4d5010ef          	jal	4b4e <mkdir>
    2e7e:	2a050e63          	beqz	a0,313a <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2e82:	00004517          	auipc	a0,0x4
    2e86:	8ce50513          	addi	a0,a0,-1842 # 6750 <malloc+0x179e>
    2e8a:	4ad010ef          	jal	4b36 <unlink>
    2e8e:	2c050063          	beqz	a0,314e <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e92:	00004517          	auipc	a0,0x4
    2e96:	88e50513          	addi	a0,a0,-1906 # 6720 <malloc+0x176e>
    2e9a:	49d010ef          	jal	4b36 <unlink>
    2e9e:	2c050263          	beqz	a0,3162 <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2ea2:	00003517          	auipc	a0,0x3
    2ea6:	5e650513          	addi	a0,a0,1510 # 6488 <malloc+0x14d6>
    2eaa:	4ad010ef          	jal	4b56 <chdir>
    2eae:	2c050463          	beqz	a0,3176 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2eb2:	00004517          	auipc	a0,0x4
    2eb6:	a7e50513          	addi	a0,a0,-1410 # 6930 <malloc+0x197e>
    2eba:	49d010ef          	jal	4b56 <chdir>
    2ebe:	2c050663          	beqz	a0,318a <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2ec2:	00003517          	auipc	a0,0x3
    2ec6:	6ce50513          	addi	a0,a0,1742 # 6590 <malloc+0x15de>
    2eca:	46d010ef          	jal	4b36 <unlink>
    2ece:	2c051863          	bnez	a0,319e <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2ed2:	00003517          	auipc	a0,0x3
    2ed6:	5b650513          	addi	a0,a0,1462 # 6488 <malloc+0x14d6>
    2eda:	45d010ef          	jal	4b36 <unlink>
    2ede:	2c051a63          	bnez	a0,31b2 <subdir+0x59e>
  if(unlink("dd") == 0){
    2ee2:	00003517          	auipc	a0,0x3
    2ee6:	58650513          	addi	a0,a0,1414 # 6468 <malloc+0x14b6>
    2eea:	44d010ef          	jal	4b36 <unlink>
    2eee:	2c050c63          	beqz	a0,31c6 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2ef2:	00004517          	auipc	a0,0x4
    2ef6:	aae50513          	addi	a0,a0,-1362 # 69a0 <malloc+0x19ee>
    2efa:	43d010ef          	jal	4b36 <unlink>
    2efe:	2c054e63          	bltz	a0,31da <subdir+0x5c6>
  if(unlink("dd") < 0){
    2f02:	00003517          	auipc	a0,0x3
    2f06:	56650513          	addi	a0,a0,1382 # 6468 <malloc+0x14b6>
    2f0a:	42d010ef          	jal	4b36 <unlink>
    2f0e:	2e054063          	bltz	a0,31ee <subdir+0x5da>
}
    2f12:	60e2                	ld	ra,24(sp)
    2f14:	6442                	ld	s0,16(sp)
    2f16:	64a2                	ld	s1,8(sp)
    2f18:	6902                	ld	s2,0(sp)
    2f1a:	6105                	addi	sp,sp,32
    2f1c:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2f1e:	85ca                	mv	a1,s2
    2f20:	00003517          	auipc	a0,0x3
    2f24:	55050513          	addi	a0,a0,1360 # 6470 <malloc+0x14be>
    2f28:	7d7010ef          	jal	4efe <printf>
    exit(1);
    2f2c:	4505                	li	a0,1
    2f2e:	3b9010ef          	jal	4ae6 <exit>
    printf("%s: create dd/ff failed\n", s);
    2f32:	85ca                	mv	a1,s2
    2f34:	00003517          	auipc	a0,0x3
    2f38:	55c50513          	addi	a0,a0,1372 # 6490 <malloc+0x14de>
    2f3c:	7c3010ef          	jal	4efe <printf>
    exit(1);
    2f40:	4505                	li	a0,1
    2f42:	3a5010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2f46:	85ca                	mv	a1,s2
    2f48:	00003517          	auipc	a0,0x3
    2f4c:	56850513          	addi	a0,a0,1384 # 64b0 <malloc+0x14fe>
    2f50:	7af010ef          	jal	4efe <printf>
    exit(1);
    2f54:	4505                	li	a0,1
    2f56:	391010ef          	jal	4ae6 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2f5a:	85ca                	mv	a1,s2
    2f5c:	00003517          	auipc	a0,0x3
    2f60:	58c50513          	addi	a0,a0,1420 # 64e8 <malloc+0x1536>
    2f64:	79b010ef          	jal	4efe <printf>
    exit(1);
    2f68:	4505                	li	a0,1
    2f6a:	37d010ef          	jal	4ae6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2f6e:	85ca                	mv	a1,s2
    2f70:	00003517          	auipc	a0,0x3
    2f74:	5a850513          	addi	a0,a0,1448 # 6518 <malloc+0x1566>
    2f78:	787010ef          	jal	4efe <printf>
    exit(1);
    2f7c:	4505                	li	a0,1
    2f7e:	369010ef          	jal	4ae6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2f82:	85ca                	mv	a1,s2
    2f84:	00003517          	auipc	a0,0x3
    2f88:	5cc50513          	addi	a0,a0,1484 # 6550 <malloc+0x159e>
    2f8c:	773010ef          	jal	4efe <printf>
    exit(1);
    2f90:	4505                	li	a0,1
    2f92:	355010ef          	jal	4ae6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f96:	85ca                	mv	a1,s2
    2f98:	00003517          	auipc	a0,0x3
    2f9c:	5d850513          	addi	a0,a0,1496 # 6570 <malloc+0x15be>
    2fa0:	75f010ef          	jal	4efe <printf>
    exit(1);
    2fa4:	4505                	li	a0,1
    2fa6:	341010ef          	jal	4ae6 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2faa:	85ca                	mv	a1,s2
    2fac:	00003517          	auipc	a0,0x3
    2fb0:	5f450513          	addi	a0,a0,1524 # 65a0 <malloc+0x15ee>
    2fb4:	74b010ef          	jal	4efe <printf>
    exit(1);
    2fb8:	4505                	li	a0,1
    2fba:	32d010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2fbe:	85ca                	mv	a1,s2
    2fc0:	00003517          	auipc	a0,0x3
    2fc4:	60850513          	addi	a0,a0,1544 # 65c8 <malloc+0x1616>
    2fc8:	737010ef          	jal	4efe <printf>
    exit(1);
    2fcc:	4505                	li	a0,1
    2fce:	319010ef          	jal	4ae6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2fd2:	85ca                	mv	a1,s2
    2fd4:	00003517          	auipc	a0,0x3
    2fd8:	61450513          	addi	a0,a0,1556 # 65e8 <malloc+0x1636>
    2fdc:	723010ef          	jal	4efe <printf>
    exit(1);
    2fe0:	4505                	li	a0,1
    2fe2:	305010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd failed\n", s);
    2fe6:	85ca                	mv	a1,s2
    2fe8:	00003517          	auipc	a0,0x3
    2fec:	62850513          	addi	a0,a0,1576 # 6610 <malloc+0x165e>
    2ff0:	70f010ef          	jal	4efe <printf>
    exit(1);
    2ff4:	4505                	li	a0,1
    2ff6:	2f1010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2ffa:	85ca                	mv	a1,s2
    2ffc:	00003517          	auipc	a0,0x3
    3000:	63c50513          	addi	a0,a0,1596 # 6638 <malloc+0x1686>
    3004:	6fb010ef          	jal	4efe <printf>
    exit(1);
    3008:	4505                	li	a0,1
    300a:	2dd010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    300e:	85ca                	mv	a1,s2
    3010:	00003517          	auipc	a0,0x3
    3014:	65850513          	addi	a0,a0,1624 # 6668 <malloc+0x16b6>
    3018:	6e7010ef          	jal	4efe <printf>
    exit(1);
    301c:	4505                	li	a0,1
    301e:	2c9010ef          	jal	4ae6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3022:	85ca                	mv	a1,s2
    3024:	00003517          	auipc	a0,0x3
    3028:	67450513          	addi	a0,a0,1652 # 6698 <malloc+0x16e6>
    302c:	6d3010ef          	jal	4efe <printf>
    exit(1);
    3030:	4505                	li	a0,1
    3032:	2b5010ef          	jal	4ae6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3036:	85ca                	mv	a1,s2
    3038:	00003517          	auipc	a0,0x3
    303c:	67850513          	addi	a0,a0,1656 # 66b0 <malloc+0x16fe>
    3040:	6bf010ef          	jal	4efe <printf>
    exit(1);
    3044:	4505                	li	a0,1
    3046:	2a1010ef          	jal	4ae6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    304a:	85ca                	mv	a1,s2
    304c:	00003517          	auipc	a0,0x3
    3050:	68450513          	addi	a0,a0,1668 # 66d0 <malloc+0x171e>
    3054:	6ab010ef          	jal	4efe <printf>
    exit(1);
    3058:	4505                	li	a0,1
    305a:	28d010ef          	jal	4ae6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    305e:	85ca                	mv	a1,s2
    3060:	00003517          	auipc	a0,0x3
    3064:	69050513          	addi	a0,a0,1680 # 66f0 <malloc+0x173e>
    3068:	697010ef          	jal	4efe <printf>
    exit(1);
    306c:	4505                	li	a0,1
    306e:	279010ef          	jal	4ae6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3072:	85ca                	mv	a1,s2
    3074:	00003517          	auipc	a0,0x3
    3078:	6bc50513          	addi	a0,a0,1724 # 6730 <malloc+0x177e>
    307c:	683010ef          	jal	4efe <printf>
    exit(1);
    3080:	4505                	li	a0,1
    3082:	265010ef          	jal	4ae6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3086:	85ca                	mv	a1,s2
    3088:	00003517          	auipc	a0,0x3
    308c:	6d850513          	addi	a0,a0,1752 # 6760 <malloc+0x17ae>
    3090:	66f010ef          	jal	4efe <printf>
    exit(1);
    3094:	4505                	li	a0,1
    3096:	251010ef          	jal	4ae6 <exit>
    printf("%s: create dd succeeded!\n", s);
    309a:	85ca                	mv	a1,s2
    309c:	00003517          	auipc	a0,0x3
    30a0:	6e450513          	addi	a0,a0,1764 # 6780 <malloc+0x17ce>
    30a4:	65b010ef          	jal	4efe <printf>
    exit(1);
    30a8:	4505                	li	a0,1
    30aa:	23d010ef          	jal	4ae6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    30ae:	85ca                	mv	a1,s2
    30b0:	00003517          	auipc	a0,0x3
    30b4:	6f050513          	addi	a0,a0,1776 # 67a0 <malloc+0x17ee>
    30b8:	647010ef          	jal	4efe <printf>
    exit(1);
    30bc:	4505                	li	a0,1
    30be:	229010ef          	jal	4ae6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    30c2:	85ca                	mv	a1,s2
    30c4:	00003517          	auipc	a0,0x3
    30c8:	6fc50513          	addi	a0,a0,1788 # 67c0 <malloc+0x180e>
    30cc:	633010ef          	jal	4efe <printf>
    exit(1);
    30d0:	4505                	li	a0,1
    30d2:	215010ef          	jal	4ae6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    30d6:	85ca                	mv	a1,s2
    30d8:	00003517          	auipc	a0,0x3
    30dc:	71850513          	addi	a0,a0,1816 # 67f0 <malloc+0x183e>
    30e0:	61f010ef          	jal	4efe <printf>
    exit(1);
    30e4:	4505                	li	a0,1
    30e6:	201010ef          	jal	4ae6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    30ea:	85ca                	mv	a1,s2
    30ec:	00003517          	auipc	a0,0x3
    30f0:	72c50513          	addi	a0,a0,1836 # 6818 <malloc+0x1866>
    30f4:	60b010ef          	jal	4efe <printf>
    exit(1);
    30f8:	4505                	li	a0,1
    30fa:	1ed010ef          	jal	4ae6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    30fe:	85ca                	mv	a1,s2
    3100:	00003517          	auipc	a0,0x3
    3104:	74050513          	addi	a0,a0,1856 # 6840 <malloc+0x188e>
    3108:	5f7010ef          	jal	4efe <printf>
    exit(1);
    310c:	4505                	li	a0,1
    310e:	1d9010ef          	jal	4ae6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3112:	85ca                	mv	a1,s2
    3114:	00003517          	auipc	a0,0x3
    3118:	75450513          	addi	a0,a0,1876 # 6868 <malloc+0x18b6>
    311c:	5e3010ef          	jal	4efe <printf>
    exit(1);
    3120:	4505                	li	a0,1
    3122:	1c5010ef          	jal	4ae6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3126:	85ca                	mv	a1,s2
    3128:	00003517          	auipc	a0,0x3
    312c:	76050513          	addi	a0,a0,1888 # 6888 <malloc+0x18d6>
    3130:	5cf010ef          	jal	4efe <printf>
    exit(1);
    3134:	4505                	li	a0,1
    3136:	1b1010ef          	jal	4ae6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    313a:	85ca                	mv	a1,s2
    313c:	00003517          	auipc	a0,0x3
    3140:	76c50513          	addi	a0,a0,1900 # 68a8 <malloc+0x18f6>
    3144:	5bb010ef          	jal	4efe <printf>
    exit(1);
    3148:	4505                	li	a0,1
    314a:	19d010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    314e:	85ca                	mv	a1,s2
    3150:	00003517          	auipc	a0,0x3
    3154:	78050513          	addi	a0,a0,1920 # 68d0 <malloc+0x191e>
    3158:	5a7010ef          	jal	4efe <printf>
    exit(1);
    315c:	4505                	li	a0,1
    315e:	189010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3162:	85ca                	mv	a1,s2
    3164:	00003517          	auipc	a0,0x3
    3168:	78c50513          	addi	a0,a0,1932 # 68f0 <malloc+0x193e>
    316c:	593010ef          	jal	4efe <printf>
    exit(1);
    3170:	4505                	li	a0,1
    3172:	175010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3176:	85ca                	mv	a1,s2
    3178:	00003517          	auipc	a0,0x3
    317c:	79850513          	addi	a0,a0,1944 # 6910 <malloc+0x195e>
    3180:	57f010ef          	jal	4efe <printf>
    exit(1);
    3184:	4505                	li	a0,1
    3186:	161010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    318a:	85ca                	mv	a1,s2
    318c:	00003517          	auipc	a0,0x3
    3190:	7ac50513          	addi	a0,a0,1964 # 6938 <malloc+0x1986>
    3194:	56b010ef          	jal	4efe <printf>
    exit(1);
    3198:	4505                	li	a0,1
    319a:	14d010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    319e:	85ca                	mv	a1,s2
    31a0:	00003517          	auipc	a0,0x3
    31a4:	42850513          	addi	a0,a0,1064 # 65c8 <malloc+0x1616>
    31a8:	557010ef          	jal	4efe <printf>
    exit(1);
    31ac:	4505                	li	a0,1
    31ae:	139010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    31b2:	85ca                	mv	a1,s2
    31b4:	00003517          	auipc	a0,0x3
    31b8:	7a450513          	addi	a0,a0,1956 # 6958 <malloc+0x19a6>
    31bc:	543010ef          	jal	4efe <printf>
    exit(1);
    31c0:	4505                	li	a0,1
    31c2:	125010ef          	jal	4ae6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    31c6:	85ca                	mv	a1,s2
    31c8:	00003517          	auipc	a0,0x3
    31cc:	7b050513          	addi	a0,a0,1968 # 6978 <malloc+0x19c6>
    31d0:	52f010ef          	jal	4efe <printf>
    exit(1);
    31d4:	4505                	li	a0,1
    31d6:	111010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    31da:	85ca                	mv	a1,s2
    31dc:	00003517          	auipc	a0,0x3
    31e0:	7cc50513          	addi	a0,a0,1996 # 69a8 <malloc+0x19f6>
    31e4:	51b010ef          	jal	4efe <printf>
    exit(1);
    31e8:	4505                	li	a0,1
    31ea:	0fd010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd failed\n", s);
    31ee:	85ca                	mv	a1,s2
    31f0:	00003517          	auipc	a0,0x3
    31f4:	7d850513          	addi	a0,a0,2008 # 69c8 <malloc+0x1a16>
    31f8:	507010ef          	jal	4efe <printf>
    exit(1);
    31fc:	4505                	li	a0,1
    31fe:	0e9010ef          	jal	4ae6 <exit>

0000000000003202 <rmdot>:
{
    3202:	1101                	addi	sp,sp,-32
    3204:	ec06                	sd	ra,24(sp)
    3206:	e822                	sd	s0,16(sp)
    3208:	e426                	sd	s1,8(sp)
    320a:	1000                	addi	s0,sp,32
    320c:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    320e:	00003517          	auipc	a0,0x3
    3212:	7d250513          	addi	a0,a0,2002 # 69e0 <malloc+0x1a2e>
    3216:	139010ef          	jal	4b4e <mkdir>
    321a:	e53d                	bnez	a0,3288 <rmdot+0x86>
  if(chdir("dots") != 0){
    321c:	00003517          	auipc	a0,0x3
    3220:	7c450513          	addi	a0,a0,1988 # 69e0 <malloc+0x1a2e>
    3224:	133010ef          	jal	4b56 <chdir>
    3228:	e935                	bnez	a0,329c <rmdot+0x9a>
  if(unlink(".") == 0){
    322a:	00002517          	auipc	a0,0x2
    322e:	5a650513          	addi	a0,a0,1446 # 57d0 <malloc+0x81e>
    3232:	105010ef          	jal	4b36 <unlink>
    3236:	cd2d                	beqz	a0,32b0 <rmdot+0xae>
  if(unlink("..") == 0){
    3238:	00003517          	auipc	a0,0x3
    323c:	1f850513          	addi	a0,a0,504 # 6430 <malloc+0x147e>
    3240:	0f7010ef          	jal	4b36 <unlink>
    3244:	c141                	beqz	a0,32c4 <rmdot+0xc2>
  if(chdir("/") != 0){
    3246:	00003517          	auipc	a0,0x3
    324a:	19250513          	addi	a0,a0,402 # 63d8 <malloc+0x1426>
    324e:	109010ef          	jal	4b56 <chdir>
    3252:	e159                	bnez	a0,32d8 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3254:	00003517          	auipc	a0,0x3
    3258:	7f450513          	addi	a0,a0,2036 # 6a48 <malloc+0x1a96>
    325c:	0db010ef          	jal	4b36 <unlink>
    3260:	c551                	beqz	a0,32ec <rmdot+0xea>
  if(unlink("dots/..") == 0){
    3262:	00004517          	auipc	a0,0x4
    3266:	80e50513          	addi	a0,a0,-2034 # 6a70 <malloc+0x1abe>
    326a:	0cd010ef          	jal	4b36 <unlink>
    326e:	c949                	beqz	a0,3300 <rmdot+0xfe>
  if(unlink("dots") != 0){
    3270:	00003517          	auipc	a0,0x3
    3274:	77050513          	addi	a0,a0,1904 # 69e0 <malloc+0x1a2e>
    3278:	0bf010ef          	jal	4b36 <unlink>
    327c:	ed41                	bnez	a0,3314 <rmdot+0x112>
}
    327e:	60e2                	ld	ra,24(sp)
    3280:	6442                	ld	s0,16(sp)
    3282:	64a2                	ld	s1,8(sp)
    3284:	6105                	addi	sp,sp,32
    3286:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3288:	85a6                	mv	a1,s1
    328a:	00003517          	auipc	a0,0x3
    328e:	75e50513          	addi	a0,a0,1886 # 69e8 <malloc+0x1a36>
    3292:	46d010ef          	jal	4efe <printf>
    exit(1);
    3296:	4505                	li	a0,1
    3298:	04f010ef          	jal	4ae6 <exit>
    printf("%s: chdir dots failed\n", s);
    329c:	85a6                	mv	a1,s1
    329e:	00003517          	auipc	a0,0x3
    32a2:	76250513          	addi	a0,a0,1890 # 6a00 <malloc+0x1a4e>
    32a6:	459010ef          	jal	4efe <printf>
    exit(1);
    32aa:	4505                	li	a0,1
    32ac:	03b010ef          	jal	4ae6 <exit>
    printf("%s: rm . worked!\n", s);
    32b0:	85a6                	mv	a1,s1
    32b2:	00003517          	auipc	a0,0x3
    32b6:	76650513          	addi	a0,a0,1894 # 6a18 <malloc+0x1a66>
    32ba:	445010ef          	jal	4efe <printf>
    exit(1);
    32be:	4505                	li	a0,1
    32c0:	027010ef          	jal	4ae6 <exit>
    printf("%s: rm .. worked!\n", s);
    32c4:	85a6                	mv	a1,s1
    32c6:	00003517          	auipc	a0,0x3
    32ca:	76a50513          	addi	a0,a0,1898 # 6a30 <malloc+0x1a7e>
    32ce:	431010ef          	jal	4efe <printf>
    exit(1);
    32d2:	4505                	li	a0,1
    32d4:	013010ef          	jal	4ae6 <exit>
    printf("%s: chdir / failed\n", s);
    32d8:	85a6                	mv	a1,s1
    32da:	00003517          	auipc	a0,0x3
    32de:	10650513          	addi	a0,a0,262 # 63e0 <malloc+0x142e>
    32e2:	41d010ef          	jal	4efe <printf>
    exit(1);
    32e6:	4505                	li	a0,1
    32e8:	7fe010ef          	jal	4ae6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    32ec:	85a6                	mv	a1,s1
    32ee:	00003517          	auipc	a0,0x3
    32f2:	76250513          	addi	a0,a0,1890 # 6a50 <malloc+0x1a9e>
    32f6:	409010ef          	jal	4efe <printf>
    exit(1);
    32fa:	4505                	li	a0,1
    32fc:	7ea010ef          	jal	4ae6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3300:	85a6                	mv	a1,s1
    3302:	00003517          	auipc	a0,0x3
    3306:	77650513          	addi	a0,a0,1910 # 6a78 <malloc+0x1ac6>
    330a:	3f5010ef          	jal	4efe <printf>
    exit(1);
    330e:	4505                	li	a0,1
    3310:	7d6010ef          	jal	4ae6 <exit>
    printf("%s: unlink dots failed!\n", s);
    3314:	85a6                	mv	a1,s1
    3316:	00003517          	auipc	a0,0x3
    331a:	78250513          	addi	a0,a0,1922 # 6a98 <malloc+0x1ae6>
    331e:	3e1010ef          	jal	4efe <printf>
    exit(1);
    3322:	4505                	li	a0,1
    3324:	7c2010ef          	jal	4ae6 <exit>

0000000000003328 <dirfile>:
{
    3328:	1101                	addi	sp,sp,-32
    332a:	ec06                	sd	ra,24(sp)
    332c:	e822                	sd	s0,16(sp)
    332e:	e426                	sd	s1,8(sp)
    3330:	e04a                	sd	s2,0(sp)
    3332:	1000                	addi	s0,sp,32
    3334:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3336:	20000593          	li	a1,512
    333a:	00003517          	auipc	a0,0x3
    333e:	77e50513          	addi	a0,a0,1918 # 6ab8 <malloc+0x1b06>
    3342:	7e4010ef          	jal	4b26 <open>
  if(fd < 0){
    3346:	0c054563          	bltz	a0,3410 <dirfile+0xe8>
  close(fd);
    334a:	7c4010ef          	jal	4b0e <close>
  if(chdir("dirfile") == 0){
    334e:	00003517          	auipc	a0,0x3
    3352:	76a50513          	addi	a0,a0,1898 # 6ab8 <malloc+0x1b06>
    3356:	001010ef          	jal	4b56 <chdir>
    335a:	c569                	beqz	a0,3424 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    335c:	4581                	li	a1,0
    335e:	00003517          	auipc	a0,0x3
    3362:	7a250513          	addi	a0,a0,1954 # 6b00 <malloc+0x1b4e>
    3366:	7c0010ef          	jal	4b26 <open>
  if(fd >= 0){
    336a:	0c055763          	bgez	a0,3438 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    336e:	20000593          	li	a1,512
    3372:	00003517          	auipc	a0,0x3
    3376:	78e50513          	addi	a0,a0,1934 # 6b00 <malloc+0x1b4e>
    337a:	7ac010ef          	jal	4b26 <open>
  if(fd >= 0){
    337e:	0c055763          	bgez	a0,344c <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    3382:	00003517          	auipc	a0,0x3
    3386:	77e50513          	addi	a0,a0,1918 # 6b00 <malloc+0x1b4e>
    338a:	7c4010ef          	jal	4b4e <mkdir>
    338e:	0c050963          	beqz	a0,3460 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    3392:	00003517          	auipc	a0,0x3
    3396:	76e50513          	addi	a0,a0,1902 # 6b00 <malloc+0x1b4e>
    339a:	79c010ef          	jal	4b36 <unlink>
    339e:	0c050b63          	beqz	a0,3474 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    33a2:	00003597          	auipc	a1,0x3
    33a6:	75e58593          	addi	a1,a1,1886 # 6b00 <malloc+0x1b4e>
    33aa:	00002517          	auipc	a0,0x2
    33ae:	f1650513          	addi	a0,a0,-234 # 52c0 <malloc+0x30e>
    33b2:	794010ef          	jal	4b46 <link>
    33b6:	0c050963          	beqz	a0,3488 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    33ba:	00003517          	auipc	a0,0x3
    33be:	6fe50513          	addi	a0,a0,1790 # 6ab8 <malloc+0x1b06>
    33c2:	774010ef          	jal	4b36 <unlink>
    33c6:	0c051b63          	bnez	a0,349c <dirfile+0x174>
  fd = open(".", O_RDWR);
    33ca:	4589                	li	a1,2
    33cc:	00002517          	auipc	a0,0x2
    33d0:	40450513          	addi	a0,a0,1028 # 57d0 <malloc+0x81e>
    33d4:	752010ef          	jal	4b26 <open>
  if(fd >= 0){
    33d8:	0c055c63          	bgez	a0,34b0 <dirfile+0x188>
  fd = open(".", 0);
    33dc:	4581                	li	a1,0
    33de:	00002517          	auipc	a0,0x2
    33e2:	3f250513          	addi	a0,a0,1010 # 57d0 <malloc+0x81e>
    33e6:	740010ef          	jal	4b26 <open>
    33ea:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    33ec:	4605                	li	a2,1
    33ee:	00002597          	auipc	a1,0x2
    33f2:	d6a58593          	addi	a1,a1,-662 # 5158 <malloc+0x1a6>
    33f6:	710010ef          	jal	4b06 <write>
    33fa:	0ca04563          	bgtz	a0,34c4 <dirfile+0x19c>
  close(fd);
    33fe:	8526                	mv	a0,s1
    3400:	70e010ef          	jal	4b0e <close>
}
    3404:	60e2                	ld	ra,24(sp)
    3406:	6442                	ld	s0,16(sp)
    3408:	64a2                	ld	s1,8(sp)
    340a:	6902                	ld	s2,0(sp)
    340c:	6105                	addi	sp,sp,32
    340e:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3410:	85ca                	mv	a1,s2
    3412:	00003517          	auipc	a0,0x3
    3416:	6ae50513          	addi	a0,a0,1710 # 6ac0 <malloc+0x1b0e>
    341a:	2e5010ef          	jal	4efe <printf>
    exit(1);
    341e:	4505                	li	a0,1
    3420:	6c6010ef          	jal	4ae6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3424:	85ca                	mv	a1,s2
    3426:	00003517          	auipc	a0,0x3
    342a:	6ba50513          	addi	a0,a0,1722 # 6ae0 <malloc+0x1b2e>
    342e:	2d1010ef          	jal	4efe <printf>
    exit(1);
    3432:	4505                	li	a0,1
    3434:	6b2010ef          	jal	4ae6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3438:	85ca                	mv	a1,s2
    343a:	00003517          	auipc	a0,0x3
    343e:	6d650513          	addi	a0,a0,1750 # 6b10 <malloc+0x1b5e>
    3442:	2bd010ef          	jal	4efe <printf>
    exit(1);
    3446:	4505                	li	a0,1
    3448:	69e010ef          	jal	4ae6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    344c:	85ca                	mv	a1,s2
    344e:	00003517          	auipc	a0,0x3
    3452:	6c250513          	addi	a0,a0,1730 # 6b10 <malloc+0x1b5e>
    3456:	2a9010ef          	jal	4efe <printf>
    exit(1);
    345a:	4505                	li	a0,1
    345c:	68a010ef          	jal	4ae6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3460:	85ca                	mv	a1,s2
    3462:	00003517          	auipc	a0,0x3
    3466:	6d650513          	addi	a0,a0,1750 # 6b38 <malloc+0x1b86>
    346a:	295010ef          	jal	4efe <printf>
    exit(1);
    346e:	4505                	li	a0,1
    3470:	676010ef          	jal	4ae6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3474:	85ca                	mv	a1,s2
    3476:	00003517          	auipc	a0,0x3
    347a:	6ea50513          	addi	a0,a0,1770 # 6b60 <malloc+0x1bae>
    347e:	281010ef          	jal	4efe <printf>
    exit(1);
    3482:	4505                	li	a0,1
    3484:	662010ef          	jal	4ae6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3488:	85ca                	mv	a1,s2
    348a:	00003517          	auipc	a0,0x3
    348e:	6fe50513          	addi	a0,a0,1790 # 6b88 <malloc+0x1bd6>
    3492:	26d010ef          	jal	4efe <printf>
    exit(1);
    3496:	4505                	li	a0,1
    3498:	64e010ef          	jal	4ae6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    349c:	85ca                	mv	a1,s2
    349e:	00003517          	auipc	a0,0x3
    34a2:	71250513          	addi	a0,a0,1810 # 6bb0 <malloc+0x1bfe>
    34a6:	259010ef          	jal	4efe <printf>
    exit(1);
    34aa:	4505                	li	a0,1
    34ac:	63a010ef          	jal	4ae6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    34b0:	85ca                	mv	a1,s2
    34b2:	00003517          	auipc	a0,0x3
    34b6:	71e50513          	addi	a0,a0,1822 # 6bd0 <malloc+0x1c1e>
    34ba:	245010ef          	jal	4efe <printf>
    exit(1);
    34be:	4505                	li	a0,1
    34c0:	626010ef          	jal	4ae6 <exit>
    printf("%s: write . succeeded!\n", s);
    34c4:	85ca                	mv	a1,s2
    34c6:	00003517          	auipc	a0,0x3
    34ca:	73250513          	addi	a0,a0,1842 # 6bf8 <malloc+0x1c46>
    34ce:	231010ef          	jal	4efe <printf>
    exit(1);
    34d2:	4505                	li	a0,1
    34d4:	612010ef          	jal	4ae6 <exit>

00000000000034d8 <iref>:
{
    34d8:	7139                	addi	sp,sp,-64
    34da:	fc06                	sd	ra,56(sp)
    34dc:	f822                	sd	s0,48(sp)
    34de:	f426                	sd	s1,40(sp)
    34e0:	f04a                	sd	s2,32(sp)
    34e2:	ec4e                	sd	s3,24(sp)
    34e4:	e852                	sd	s4,16(sp)
    34e6:	e456                	sd	s5,8(sp)
    34e8:	e05a                	sd	s6,0(sp)
    34ea:	0080                	addi	s0,sp,64
    34ec:	8b2a                	mv	s6,a0
    34ee:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    34f2:	00003a17          	auipc	s4,0x3
    34f6:	71ea0a13          	addi	s4,s4,1822 # 6c10 <malloc+0x1c5e>
    mkdir("");
    34fa:	00003497          	auipc	s1,0x3
    34fe:	21e48493          	addi	s1,s1,542 # 6718 <malloc+0x1766>
    link("README", "");
    3502:	00002a97          	auipc	s5,0x2
    3506:	dbea8a93          	addi	s5,s5,-578 # 52c0 <malloc+0x30e>
    fd = open("xx", O_CREATE);
    350a:	00003997          	auipc	s3,0x3
    350e:	5fe98993          	addi	s3,s3,1534 # 6b08 <malloc+0x1b56>
    3512:	a835                	j	354e <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    3514:	85da                	mv	a1,s6
    3516:	00003517          	auipc	a0,0x3
    351a:	70250513          	addi	a0,a0,1794 # 6c18 <malloc+0x1c66>
    351e:	1e1010ef          	jal	4efe <printf>
      exit(1);
    3522:	4505                	li	a0,1
    3524:	5c2010ef          	jal	4ae6 <exit>
      printf("%s: chdir irefd failed\n", s);
    3528:	85da                	mv	a1,s6
    352a:	00003517          	auipc	a0,0x3
    352e:	70650513          	addi	a0,a0,1798 # 6c30 <malloc+0x1c7e>
    3532:	1cd010ef          	jal	4efe <printf>
      exit(1);
    3536:	4505                	li	a0,1
    3538:	5ae010ef          	jal	4ae6 <exit>
      close(fd);
    353c:	5d2010ef          	jal	4b0e <close>
    3540:	a82d                	j	357a <iref+0xa2>
    unlink("xx");
    3542:	854e                	mv	a0,s3
    3544:	5f2010ef          	jal	4b36 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3548:	397d                	addiw	s2,s2,-1
    354a:	04090263          	beqz	s2,358e <iref+0xb6>
    if(mkdir("irefd") != 0){
    354e:	8552                	mv	a0,s4
    3550:	5fe010ef          	jal	4b4e <mkdir>
    3554:	f161                	bnez	a0,3514 <iref+0x3c>
    if(chdir("irefd") != 0){
    3556:	8552                	mv	a0,s4
    3558:	5fe010ef          	jal	4b56 <chdir>
    355c:	f571                	bnez	a0,3528 <iref+0x50>
    mkdir("");
    355e:	8526                	mv	a0,s1
    3560:	5ee010ef          	jal	4b4e <mkdir>
    link("README", "");
    3564:	85a6                	mv	a1,s1
    3566:	8556                	mv	a0,s5
    3568:	5de010ef          	jal	4b46 <link>
    fd = open("", O_CREATE);
    356c:	20000593          	li	a1,512
    3570:	8526                	mv	a0,s1
    3572:	5b4010ef          	jal	4b26 <open>
    if(fd >= 0)
    3576:	fc0553e3          	bgez	a0,353c <iref+0x64>
    fd = open("xx", O_CREATE);
    357a:	20000593          	li	a1,512
    357e:	854e                	mv	a0,s3
    3580:	5a6010ef          	jal	4b26 <open>
    if(fd >= 0)
    3584:	fa054fe3          	bltz	a0,3542 <iref+0x6a>
      close(fd);
    3588:	586010ef          	jal	4b0e <close>
    358c:	bf5d                	j	3542 <iref+0x6a>
    358e:	03300493          	li	s1,51
    chdir("..");
    3592:	00003997          	auipc	s3,0x3
    3596:	e9e98993          	addi	s3,s3,-354 # 6430 <malloc+0x147e>
    unlink("irefd");
    359a:	00003917          	auipc	s2,0x3
    359e:	67690913          	addi	s2,s2,1654 # 6c10 <malloc+0x1c5e>
    chdir("..");
    35a2:	854e                	mv	a0,s3
    35a4:	5b2010ef          	jal	4b56 <chdir>
    unlink("irefd");
    35a8:	854a                	mv	a0,s2
    35aa:	58c010ef          	jal	4b36 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    35ae:	34fd                	addiw	s1,s1,-1
    35b0:	f8ed                	bnez	s1,35a2 <iref+0xca>
  chdir("/");
    35b2:	00003517          	auipc	a0,0x3
    35b6:	e2650513          	addi	a0,a0,-474 # 63d8 <malloc+0x1426>
    35ba:	59c010ef          	jal	4b56 <chdir>
}
    35be:	70e2                	ld	ra,56(sp)
    35c0:	7442                	ld	s0,48(sp)
    35c2:	74a2                	ld	s1,40(sp)
    35c4:	7902                	ld	s2,32(sp)
    35c6:	69e2                	ld	s3,24(sp)
    35c8:	6a42                	ld	s4,16(sp)
    35ca:	6aa2                	ld	s5,8(sp)
    35cc:	6b02                	ld	s6,0(sp)
    35ce:	6121                	addi	sp,sp,64
    35d0:	8082                	ret

00000000000035d2 <openiputtest>:
{
    35d2:	7179                	addi	sp,sp,-48
    35d4:	f406                	sd	ra,40(sp)
    35d6:	f022                	sd	s0,32(sp)
    35d8:	ec26                	sd	s1,24(sp)
    35da:	1800                	addi	s0,sp,48
    35dc:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    35de:	00003517          	auipc	a0,0x3
    35e2:	66a50513          	addi	a0,a0,1642 # 6c48 <malloc+0x1c96>
    35e6:	568010ef          	jal	4b4e <mkdir>
    35ea:	02054b63          	bltz	a0,3620 <openiputtest+0x4e>
  pid = fork(1);
    35ee:	4505                	li	a0,1
    35f0:	4ee010ef          	jal	4ade <fork>
  if(pid < 0){
    35f4:	04054063          	bltz	a0,3634 <openiputtest+0x62>
  if(pid == 0){
    35f8:	e939                	bnez	a0,364e <openiputtest+0x7c>
    int fd = open("oidir", O_RDWR);
    35fa:	4589                	li	a1,2
    35fc:	00003517          	auipc	a0,0x3
    3600:	64c50513          	addi	a0,a0,1612 # 6c48 <malloc+0x1c96>
    3604:	522010ef          	jal	4b26 <open>
    if(fd >= 0){
    3608:	04054063          	bltz	a0,3648 <openiputtest+0x76>
      printf("%s: open directory for write succeeded\n", s);
    360c:	85a6                	mv	a1,s1
    360e:	00003517          	auipc	a0,0x3
    3612:	65a50513          	addi	a0,a0,1626 # 6c68 <malloc+0x1cb6>
    3616:	0e9010ef          	jal	4efe <printf>
      exit(1);
    361a:	4505                	li	a0,1
    361c:	4ca010ef          	jal	4ae6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3620:	85a6                	mv	a1,s1
    3622:	00003517          	auipc	a0,0x3
    3626:	62e50513          	addi	a0,a0,1582 # 6c50 <malloc+0x1c9e>
    362a:	0d5010ef          	jal	4efe <printf>
    exit(1);
    362e:	4505                	li	a0,1
    3630:	4b6010ef          	jal	4ae6 <exit>
    printf("%s: fork failed\n", s);
    3634:	85a6                	mv	a1,s1
    3636:	00002517          	auipc	a0,0x2
    363a:	34250513          	addi	a0,a0,834 # 5978 <malloc+0x9c6>
    363e:	0c1010ef          	jal	4efe <printf>
    exit(1);
    3642:	4505                	li	a0,1
    3644:	4a2010ef          	jal	4ae6 <exit>
    exit(0);
    3648:	4501                	li	a0,0
    364a:	49c010ef          	jal	4ae6 <exit>
  sleep(1);
    364e:	4505                	li	a0,1
    3650:	526010ef          	jal	4b76 <sleep>
  if(unlink("oidir") != 0){
    3654:	00003517          	auipc	a0,0x3
    3658:	5f450513          	addi	a0,a0,1524 # 6c48 <malloc+0x1c96>
    365c:	4da010ef          	jal	4b36 <unlink>
    3660:	c919                	beqz	a0,3676 <openiputtest+0xa4>
    printf("%s: unlink failed\n", s);
    3662:	85a6                	mv	a1,s1
    3664:	00002517          	auipc	a0,0x2
    3668:	57c50513          	addi	a0,a0,1404 # 5be0 <malloc+0xc2e>
    366c:	093010ef          	jal	4efe <printf>
    exit(1);
    3670:	4505                	li	a0,1
    3672:	474010ef          	jal	4ae6 <exit>
  wait(&xstatus);
    3676:	fdc40513          	addi	a0,s0,-36
    367a:	474010ef          	jal	4aee <wait>
  exit(xstatus);
    367e:	fdc42503          	lw	a0,-36(s0)
    3682:	464010ef          	jal	4ae6 <exit>

0000000000003686 <forkforkfork>:
{
    3686:	1101                	addi	sp,sp,-32
    3688:	ec06                	sd	ra,24(sp)
    368a:	e822                	sd	s0,16(sp)
    368c:	e426                	sd	s1,8(sp)
    368e:	1000                	addi	s0,sp,32
    3690:	84aa                	mv	s1,a0
  unlink("stopforking");
    3692:	00003517          	auipc	a0,0x3
    3696:	5fe50513          	addi	a0,a0,1534 # 6c90 <malloc+0x1cde>
    369a:	49c010ef          	jal	4b36 <unlink>
  int pid = fork(1);
    369e:	4505                	li	a0,1
    36a0:	43e010ef          	jal	4ade <fork>
  if(pid < 0){
    36a4:	02054b63          	bltz	a0,36da <forkforkfork+0x54>
  if(pid == 0){
    36a8:	c139                	beqz	a0,36ee <forkforkfork+0x68>
  sleep(20); // two seconds
    36aa:	4551                	li	a0,20
    36ac:	4ca010ef          	jal	4b76 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    36b0:	20200593          	li	a1,514
    36b4:	00003517          	auipc	a0,0x3
    36b8:	5dc50513          	addi	a0,a0,1500 # 6c90 <malloc+0x1cde>
    36bc:	46a010ef          	jal	4b26 <open>
    36c0:	44e010ef          	jal	4b0e <close>
  wait(0);
    36c4:	4501                	li	a0,0
    36c6:	428010ef          	jal	4aee <wait>
  sleep(10); // one second
    36ca:	4529                	li	a0,10
    36cc:	4aa010ef          	jal	4b76 <sleep>
}
    36d0:	60e2                	ld	ra,24(sp)
    36d2:	6442                	ld	s0,16(sp)
    36d4:	64a2                	ld	s1,8(sp)
    36d6:	6105                	addi	sp,sp,32
    36d8:	8082                	ret
    printf("%s: fork10 failed", s);
    36da:	85a6                	mv	a1,s1
    36dc:	00003517          	auipc	a0,0x3
    36e0:	5c450513          	addi	a0,a0,1476 # 6ca0 <malloc+0x1cee>
    36e4:	01b010ef          	jal	4efe <printf>
    exit(1);
    36e8:	4505                	li	a0,1
    36ea:	3fc010ef          	jal	4ae6 <exit>
      int fd = open("stopforking", 0);
    36ee:	00003497          	auipc	s1,0x3
    36f2:	5a248493          	addi	s1,s1,1442 # 6c90 <malloc+0x1cde>
    36f6:	4581                	li	a1,0
    36f8:	8526                	mv	a0,s1
    36fa:	42c010ef          	jal	4b26 <open>
      if(fd >= 0){
    36fe:	02055263          	bgez	a0,3722 <forkforkfork+0x9c>
      if(fork(1) < 0){
    3702:	4505                	li	a0,1
    3704:	3da010ef          	jal	4ade <fork>
    3708:	fe0557e3          	bgez	a0,36f6 <forkforkfork+0x70>
        close(open("stopforking", O_CREATE|O_RDWR));
    370c:	20200593          	li	a1,514
    3710:	00003517          	auipc	a0,0x3
    3714:	58050513          	addi	a0,a0,1408 # 6c90 <malloc+0x1cde>
    3718:	40e010ef          	jal	4b26 <open>
    371c:	3f2010ef          	jal	4b0e <close>
    3720:	bfd9                	j	36f6 <forkforkfork+0x70>
        exit(0);
    3722:	4501                	li	a0,0
    3724:	3c2010ef          	jal	4ae6 <exit>

0000000000003728 <killstatus>:
{
    3728:	7139                	addi	sp,sp,-64
    372a:	fc06                	sd	ra,56(sp)
    372c:	f822                	sd	s0,48(sp)
    372e:	f426                	sd	s1,40(sp)
    3730:	f04a                	sd	s2,32(sp)
    3732:	ec4e                	sd	s3,24(sp)
    3734:	e852                	sd	s4,16(sp)
    3736:	0080                	addi	s0,sp,64
    3738:	8a2a                	mv	s4,a0
    373a:	06400913          	li	s2,100
    if(xst != -1) {
    373e:	59fd                	li	s3,-1
    int pid1 = fork(1);
    3740:	4505                	li	a0,1
    3742:	39c010ef          	jal	4ade <fork>
    3746:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3748:	02054763          	bltz	a0,3776 <killstatus+0x4e>
    if(pid1 == 0){
    374c:	cd1d                	beqz	a0,378a <killstatus+0x62>
    sleep(1);
    374e:	4505                	li	a0,1
    3750:	426010ef          	jal	4b76 <sleep>
    kill(pid1);
    3754:	8526                	mv	a0,s1
    3756:	3c0010ef          	jal	4b16 <kill>
    wait(&xst);
    375a:	fcc40513          	addi	a0,s0,-52
    375e:	390010ef          	jal	4aee <wait>
    if(xst != -1) {
    3762:	fcc42783          	lw	a5,-52(s0)
    3766:	03379563          	bne	a5,s3,3790 <killstatus+0x68>
  for(int i = 0; i < 100; i++){
    376a:	397d                	addiw	s2,s2,-1
    376c:	fc091ae3          	bnez	s2,3740 <killstatus+0x18>
  exit(0);
    3770:	4501                	li	a0,0
    3772:	374010ef          	jal	4ae6 <exit>
      printf("%s: fork2 failed\n", s);
    3776:	85d2                	mv	a1,s4
    3778:	00003517          	auipc	a0,0x3
    377c:	54050513          	addi	a0,a0,1344 # 6cb8 <malloc+0x1d06>
    3780:	77e010ef          	jal	4efe <printf>
      exit(1);
    3784:	4505                	li	a0,1
    3786:	360010ef          	jal	4ae6 <exit>
        getpid();
    378a:	3dc010ef          	jal	4b66 <getpid>
      while(1) {
    378e:	bff5                	j	378a <killstatus+0x62>
       printf("%s: status should be -1\n", s);
    3790:	85d2                	mv	a1,s4
    3792:	00003517          	auipc	a0,0x3
    3796:	53e50513          	addi	a0,a0,1342 # 6cd0 <malloc+0x1d1e>
    379a:	764010ef          	jal	4efe <printf>
       exit(1);
    379e:	4505                	li	a0,1
    37a0:	346010ef          	jal	4ae6 <exit>

00000000000037a4 <preempt>:
{
    37a4:	7139                	addi	sp,sp,-64
    37a6:	fc06                	sd	ra,56(sp)
    37a8:	f822                	sd	s0,48(sp)
    37aa:	f426                	sd	s1,40(sp)
    37ac:	f04a                	sd	s2,32(sp)
    37ae:	ec4e                	sd	s3,24(sp)
    37b0:	e852                	sd	s4,16(sp)
    37b2:	0080                	addi	s0,sp,64
    37b4:	892a                	mv	s2,a0
  pid1 = fork(1);
    37b6:	4505                	li	a0,1
    37b8:	326010ef          	jal	4ade <fork>
  if(pid1 < 0) {
    37bc:	00054563          	bltz	a0,37c6 <preempt+0x22>
    37c0:	84aa                	mv	s1,a0
  if(pid1 == 0)
    37c2:	ed01                	bnez	a0,37da <preempt+0x36>
    for(;;)
    37c4:	a001                	j	37c4 <preempt+0x20>
    printf("%s: fork3 failed", s);
    37c6:	85ca                	mv	a1,s2
    37c8:	00003517          	auipc	a0,0x3
    37cc:	52850513          	addi	a0,a0,1320 # 6cf0 <malloc+0x1d3e>
    37d0:	72e010ef          	jal	4efe <printf>
    exit(1);
    37d4:	4505                	li	a0,1
    37d6:	310010ef          	jal	4ae6 <exit>
  pid2 = fork(1);
    37da:	4505                	li	a0,1
    37dc:	302010ef          	jal	4ade <fork>
    37e0:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    37e2:	00054463          	bltz	a0,37ea <preempt+0x46>
  if(pid2 == 0)
    37e6:	ed01                	bnez	a0,37fe <preempt+0x5a>
    for(;;)
    37e8:	a001                	j	37e8 <preempt+0x44>
    printf("%s: fork4 failed\n", s);
    37ea:	85ca                	mv	a1,s2
    37ec:	00003517          	auipc	a0,0x3
    37f0:	51c50513          	addi	a0,a0,1308 # 6d08 <malloc+0x1d56>
    37f4:	70a010ef          	jal	4efe <printf>
    exit(1);
    37f8:	4505                	li	a0,1
    37fa:	2ec010ef          	jal	4ae6 <exit>
  pipe(pfds);
    37fe:	fc840513          	addi	a0,s0,-56
    3802:	2f4010ef          	jal	4af6 <pipe>
  pid3 = fork(1);
    3806:	4505                	li	a0,1
    3808:	2d6010ef          	jal	4ade <fork>
    380c:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    380e:	02054863          	bltz	a0,383e <preempt+0x9a>
  if(pid3 == 0){
    3812:	e921                	bnez	a0,3862 <preempt+0xbe>
    close(pfds[0]);
    3814:	fc842503          	lw	a0,-56(s0)
    3818:	2f6010ef          	jal	4b0e <close>
    if(write(pfds[1], "x", 1) != 1)
    381c:	4605                	li	a2,1
    381e:	00002597          	auipc	a1,0x2
    3822:	93a58593          	addi	a1,a1,-1734 # 5158 <malloc+0x1a6>
    3826:	fcc42503          	lw	a0,-52(s0)
    382a:	2dc010ef          	jal	4b06 <write>
    382e:	4785                	li	a5,1
    3830:	02f51163          	bne	a0,a5,3852 <preempt+0xae>
    close(pfds[1]);
    3834:	fcc42503          	lw	a0,-52(s0)
    3838:	2d6010ef          	jal	4b0e <close>
    for(;;)
    383c:	a001                	j	383c <preempt+0x98>
     printf("%s: fork5 failed\n", s);
    383e:	85ca                	mv	a1,s2
    3840:	00003517          	auipc	a0,0x3
    3844:	4e050513          	addi	a0,a0,1248 # 6d20 <malloc+0x1d6e>
    3848:	6b6010ef          	jal	4efe <printf>
     exit(1);
    384c:	4505                	li	a0,1
    384e:	298010ef          	jal	4ae6 <exit>
      printf("%s: preempt write error", s);
    3852:	85ca                	mv	a1,s2
    3854:	00003517          	auipc	a0,0x3
    3858:	4e450513          	addi	a0,a0,1252 # 6d38 <malloc+0x1d86>
    385c:	6a2010ef          	jal	4efe <printf>
    3860:	bfd1                	j	3834 <preempt+0x90>
  close(pfds[1]);
    3862:	fcc42503          	lw	a0,-52(s0)
    3866:	2a8010ef          	jal	4b0e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    386a:	660d                	lui	a2,0x3
    386c:	00009597          	auipc	a1,0x9
    3870:	40c58593          	addi	a1,a1,1036 # cc78 <buf>
    3874:	fc842503          	lw	a0,-56(s0)
    3878:	286010ef          	jal	4afe <read>
    387c:	4785                	li	a5,1
    387e:	02f50163          	beq	a0,a5,38a0 <preempt+0xfc>
    printf("%s: preempt read error", s);
    3882:	85ca                	mv	a1,s2
    3884:	00003517          	auipc	a0,0x3
    3888:	4cc50513          	addi	a0,a0,1228 # 6d50 <malloc+0x1d9e>
    388c:	672010ef          	jal	4efe <printf>
}
    3890:	70e2                	ld	ra,56(sp)
    3892:	7442                	ld	s0,48(sp)
    3894:	74a2                	ld	s1,40(sp)
    3896:	7902                	ld	s2,32(sp)
    3898:	69e2                	ld	s3,24(sp)
    389a:	6a42                	ld	s4,16(sp)
    389c:	6121                	addi	sp,sp,64
    389e:	8082                	ret
  close(pfds[0]);
    38a0:	fc842503          	lw	a0,-56(s0)
    38a4:	26a010ef          	jal	4b0e <close>
  printf("kill... ");
    38a8:	00003517          	auipc	a0,0x3
    38ac:	4c050513          	addi	a0,a0,1216 # 6d68 <malloc+0x1db6>
    38b0:	64e010ef          	jal	4efe <printf>
  kill(pid1);
    38b4:	8526                	mv	a0,s1
    38b6:	260010ef          	jal	4b16 <kill>
  kill(pid2);
    38ba:	854e                	mv	a0,s3
    38bc:	25a010ef          	jal	4b16 <kill>
  kill(pid3);
    38c0:	8552                	mv	a0,s4
    38c2:	254010ef          	jal	4b16 <kill>
  printf("wait... ");
    38c6:	00003517          	auipc	a0,0x3
    38ca:	4b250513          	addi	a0,a0,1202 # 6d78 <malloc+0x1dc6>
    38ce:	630010ef          	jal	4efe <printf>
  wait(0);
    38d2:	4501                	li	a0,0
    38d4:	21a010ef          	jal	4aee <wait>
  wait(0);
    38d8:	4501                	li	a0,0
    38da:	214010ef          	jal	4aee <wait>
  wait(0);
    38de:	4501                	li	a0,0
    38e0:	20e010ef          	jal	4aee <wait>
    38e4:	b775                	j	3890 <preempt+0xec>

00000000000038e6 <reparent>:
{
    38e6:	7179                	addi	sp,sp,-48
    38e8:	f406                	sd	ra,40(sp)
    38ea:	f022                	sd	s0,32(sp)
    38ec:	ec26                	sd	s1,24(sp)
    38ee:	e84a                	sd	s2,16(sp)
    38f0:	e44e                	sd	s3,8(sp)
    38f2:	e052                	sd	s4,0(sp)
    38f4:	1800                	addi	s0,sp,48
    38f6:	89aa                	mv	s3,a0
  int master_pid = getpid();
    38f8:	26e010ef          	jal	4b66 <getpid>
    38fc:	8a2a                	mv	s4,a0
    38fe:	0c800913          	li	s2,200
    int pid = fork(1);
    3902:	4505                	li	a0,1
    3904:	1da010ef          	jal	4ade <fork>
    3908:	84aa                	mv	s1,a0
    if(pid < 0){
    390a:	00054e63          	bltz	a0,3926 <reparent+0x40>
    if(pid){
    390e:	c121                	beqz	a0,394e <reparent+0x68>
      if(wait(0) != pid){
    3910:	4501                	li	a0,0
    3912:	1dc010ef          	jal	4aee <wait>
    3916:	02951263          	bne	a0,s1,393a <reparent+0x54>
  for(int i = 0; i < 200; i++){
    391a:	397d                	addiw	s2,s2,-1
    391c:	fe0913e3          	bnez	s2,3902 <reparent+0x1c>
  exit(0);
    3920:	4501                	li	a0,0
    3922:	1c4010ef          	jal	4ae6 <exit>
      printf("%s: fork6 failed\n", s);
    3926:	85ce                	mv	a1,s3
    3928:	00003517          	auipc	a0,0x3
    392c:	46050513          	addi	a0,a0,1120 # 6d88 <malloc+0x1dd6>
    3930:	5ce010ef          	jal	4efe <printf>
      exit(1);
    3934:	4505                	li	a0,1
    3936:	1b0010ef          	jal	4ae6 <exit>
        printf("%s: wait wrong pid\n", s);
    393a:	85ce                	mv	a1,s3
    393c:	00002517          	auipc	a0,0x2
    3940:	1dc50513          	addi	a0,a0,476 # 5b18 <malloc+0xb66>
    3944:	5ba010ef          	jal	4efe <printf>
        exit(1);
    3948:	4505                	li	a0,1
    394a:	19c010ef          	jal	4ae6 <exit>
      int pid2 = fork(1);
    394e:	4505                	li	a0,1
    3950:	18e010ef          	jal	4ade <fork>
      if(pid2 < 0){
    3954:	00054563          	bltz	a0,395e <reparent+0x78>
      exit(0);
    3958:	4501                	li	a0,0
    395a:	18c010ef          	jal	4ae6 <exit>
        kill(master_pid);
    395e:	8552                	mv	a0,s4
    3960:	1b6010ef          	jal	4b16 <kill>
        exit(1);
    3964:	4505                	li	a0,1
    3966:	180010ef          	jal	4ae6 <exit>

000000000000396a <sbrkfail>:
{
    396a:	7119                	addi	sp,sp,-128
    396c:	fc86                	sd	ra,120(sp)
    396e:	f8a2                	sd	s0,112(sp)
    3970:	f4a6                	sd	s1,104(sp)
    3972:	f0ca                	sd	s2,96(sp)
    3974:	ecce                	sd	s3,88(sp)
    3976:	e8d2                	sd	s4,80(sp)
    3978:	e4d6                	sd	s5,72(sp)
    397a:	0100                	addi	s0,sp,128
    397c:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    397e:	fb040513          	addi	a0,s0,-80
    3982:	174010ef          	jal	4af6 <pipe>
    3986:	e901                	bnez	a0,3996 <sbrkfail+0x2c>
    3988:	f8040493          	addi	s1,s0,-128
    398c:	fa840993          	addi	s3,s0,-88
    3990:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3992:	5a7d                	li	s4,-1
    3994:	a0a1                	j	39dc <sbrkfail+0x72>
    printf("%s: pipe() failed\n", s);
    3996:	85d6                	mv	a1,s5
    3998:	00002517          	auipc	a0,0x2
    399c:	0e850513          	addi	a0,a0,232 # 5a80 <malloc+0xace>
    39a0:	55e010ef          	jal	4efe <printf>
    exit(1);
    39a4:	4505                	li	a0,1
    39a6:	140010ef          	jal	4ae6 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    39aa:	1c4010ef          	jal	4b6e <sbrk>
    39ae:	064007b7          	lui	a5,0x6400
    39b2:	40a7853b          	subw	a0,a5,a0
    39b6:	1b8010ef          	jal	4b6e <sbrk>
      write(fds[1], "x", 1);
    39ba:	4605                	li	a2,1
    39bc:	00001597          	auipc	a1,0x1
    39c0:	79c58593          	addi	a1,a1,1948 # 5158 <malloc+0x1a6>
    39c4:	fb442503          	lw	a0,-76(s0)
    39c8:	13e010ef          	jal	4b06 <write>
      for(;;) sleep(1000);
    39cc:	3e800513          	li	a0,1000
    39d0:	1a6010ef          	jal	4b76 <sleep>
    39d4:	bfe5                	j	39cc <sbrkfail+0x62>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    39d6:	0911                	addi	s2,s2,4
    39d8:	03390263          	beq	s2,s3,39fc <sbrkfail+0x92>
    if((pids[i] = fork(1)) == 0){
    39dc:	4505                	li	a0,1
    39de:	100010ef          	jal	4ade <fork>
    39e2:	00a92023          	sw	a0,0(s2)
    39e6:	d171                	beqz	a0,39aa <sbrkfail+0x40>
    if(pids[i] != -1)
    39e8:	ff4507e3          	beq	a0,s4,39d6 <sbrkfail+0x6c>
      read(fds[0], &scratch, 1);
    39ec:	4605                	li	a2,1
    39ee:	faf40593          	addi	a1,s0,-81
    39f2:	fb042503          	lw	a0,-80(s0)
    39f6:	108010ef          	jal	4afe <read>
    39fa:	bff1                	j	39d6 <sbrkfail+0x6c>
  c = sbrk(PGSIZE);
    39fc:	6505                	lui	a0,0x1
    39fe:	170010ef          	jal	4b6e <sbrk>
    3a02:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3a04:	597d                	li	s2,-1
    3a06:	a021                	j	3a0e <sbrkfail+0xa4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3a08:	0491                	addi	s1,s1,4
    3a0a:	01348b63          	beq	s1,s3,3a20 <sbrkfail+0xb6>
    if(pids[i] == -1)
    3a0e:	4088                	lw	a0,0(s1)
    3a10:	ff250ce3          	beq	a0,s2,3a08 <sbrkfail+0x9e>
    kill(pids[i]);
    3a14:	102010ef          	jal	4b16 <kill>
    wait(0);
    3a18:	4501                	li	a0,0
    3a1a:	0d4010ef          	jal	4aee <wait>
    3a1e:	b7ed                	j	3a08 <sbrkfail+0x9e>
  if(c == (char*)0xffffffffffffffffL){
    3a20:	57fd                	li	a5,-1
    3a22:	02fa0e63          	beq	s4,a5,3a5e <sbrkfail+0xf4>
  pid = fork(1);
    3a26:	4505                	li	a0,1
    3a28:	0b6010ef          	jal	4ade <fork>
    3a2c:	84aa                	mv	s1,a0
  if(pid < 0){
    3a2e:	04054263          	bltz	a0,3a72 <sbrkfail+0x108>
  if(pid == 0){
    3a32:	c931                	beqz	a0,3a86 <sbrkfail+0x11c>
  wait(&xstatus);
    3a34:	fbc40513          	addi	a0,s0,-68
    3a38:	0b6010ef          	jal	4aee <wait>
  if(xstatus != -1 && xstatus != 2)
    3a3c:	fbc42783          	lw	a5,-68(s0)
    3a40:	577d                	li	a4,-1
    3a42:	00e78563          	beq	a5,a4,3a4c <sbrkfail+0xe2>
    3a46:	4709                	li	a4,2
    3a48:	06e79d63          	bne	a5,a4,3ac2 <sbrkfail+0x158>
}
    3a4c:	70e6                	ld	ra,120(sp)
    3a4e:	7446                	ld	s0,112(sp)
    3a50:	74a6                	ld	s1,104(sp)
    3a52:	7906                	ld	s2,96(sp)
    3a54:	69e6                	ld	s3,88(sp)
    3a56:	6a46                	ld	s4,80(sp)
    3a58:	6aa6                	ld	s5,72(sp)
    3a5a:	6109                	addi	sp,sp,128
    3a5c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3a5e:	85d6                	mv	a1,s5
    3a60:	00003517          	auipc	a0,0x3
    3a64:	34050513          	addi	a0,a0,832 # 6da0 <malloc+0x1dee>
    3a68:	496010ef          	jal	4efe <printf>
    exit(1);
    3a6c:	4505                	li	a0,1
    3a6e:	078010ef          	jal	4ae6 <exit>
    printf("%s: fork19 failed\n", s);
    3a72:	85d6                	mv	a1,s5
    3a74:	00002517          	auipc	a0,0x2
    3a78:	32c50513          	addi	a0,a0,812 # 5da0 <malloc+0xdee>
    3a7c:	482010ef          	jal	4efe <printf>
    exit(1);
    3a80:	4505                	li	a0,1
    3a82:	064010ef          	jal	4ae6 <exit>
    a = sbrk(0);
    3a86:	4501                	li	a0,0
    3a88:	0e6010ef          	jal	4b6e <sbrk>
    3a8c:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3a8e:	3e800537          	lui	a0,0x3e800
    3a92:	0dc010ef          	jal	4b6e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a96:	87ca                	mv	a5,s2
    3a98:	3e800737          	lui	a4,0x3e800
    3a9c:	993a                	add	s2,s2,a4
    3a9e:	6705                	lui	a4,0x1
      n += *(a+i);
    3aa0:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    3aa4:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3aa6:	97ba                	add	a5,a5,a4
    3aa8:	fef91ce3          	bne	s2,a5,3aa0 <sbrkfail+0x136>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3aac:	8626                	mv	a2,s1
    3aae:	85d6                	mv	a1,s5
    3ab0:	00003517          	auipc	a0,0x3
    3ab4:	31050513          	addi	a0,a0,784 # 6dc0 <malloc+0x1e0e>
    3ab8:	446010ef          	jal	4efe <printf>
    exit(1);
    3abc:	4505                	li	a0,1
    3abe:	028010ef          	jal	4ae6 <exit>
    exit(1);
    3ac2:	4505                	li	a0,1
    3ac4:	022010ef          	jal	4ae6 <exit>

0000000000003ac8 <mem>:
{
    3ac8:	7139                	addi	sp,sp,-64
    3aca:	fc06                	sd	ra,56(sp)
    3acc:	f822                	sd	s0,48(sp)
    3ace:	f426                	sd	s1,40(sp)
    3ad0:	f04a                	sd	s2,32(sp)
    3ad2:	ec4e                	sd	s3,24(sp)
    3ad4:	0080                	addi	s0,sp,64
    3ad6:	89aa                	mv	s3,a0
  if((pid = fork(1)) == 0){
    3ad8:	4505                	li	a0,1
    3ada:	004010ef          	jal	4ade <fork>
    m1 = 0;
    3ade:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3ae0:	6909                	lui	s2,0x2
    3ae2:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0x47>
  if((pid = fork(1)) == 0){
    3ae6:	cd11                	beqz	a0,3b02 <mem+0x3a>
    wait(&xstatus);
    3ae8:	fcc40513          	addi	a0,s0,-52
    3aec:	002010ef          	jal	4aee <wait>
    if(xstatus == -1){
    3af0:	fcc42503          	lw	a0,-52(s0)
    3af4:	57fd                	li	a5,-1
    3af6:	04f50363          	beq	a0,a5,3b3c <mem+0x74>
    exit(xstatus);
    3afa:	7ed000ef          	jal	4ae6 <exit>
      *(char**)m2 = m1;
    3afe:	e104                	sd	s1,0(a0)
      m1 = m2;
    3b00:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3b02:	854a                	mv	a0,s2
    3b04:	4ae010ef          	jal	4fb2 <malloc>
    3b08:	f97d                	bnez	a0,3afe <mem+0x36>
    while(m1){
    3b0a:	c491                	beqz	s1,3b16 <mem+0x4e>
      m2 = *(char**)m1;
    3b0c:	8526                	mv	a0,s1
    3b0e:	6084                	ld	s1,0(s1)
      free(m1);
    3b10:	420010ef          	jal	4f30 <free>
    while(m1){
    3b14:	fce5                	bnez	s1,3b0c <mem+0x44>
    m1 = malloc(1024*20);
    3b16:	6515                	lui	a0,0x5
    3b18:	49a010ef          	jal	4fb2 <malloc>
    if(m1 == 0){
    3b1c:	c511                	beqz	a0,3b28 <mem+0x60>
    free(m1);
    3b1e:	412010ef          	jal	4f30 <free>
    exit(0);
    3b22:	4501                	li	a0,0
    3b24:	7c3000ef          	jal	4ae6 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3b28:	85ce                	mv	a1,s3
    3b2a:	00003517          	auipc	a0,0x3
    3b2e:	2c650513          	addi	a0,a0,710 # 6df0 <malloc+0x1e3e>
    3b32:	3cc010ef          	jal	4efe <printf>
      exit(1);
    3b36:	4505                	li	a0,1
    3b38:	7af000ef          	jal	4ae6 <exit>
      exit(0);
    3b3c:	4501                	li	a0,0
    3b3e:	7a9000ef          	jal	4ae6 <exit>

0000000000003b42 <sharedfd>:
{
    3b42:	7159                	addi	sp,sp,-112
    3b44:	f486                	sd	ra,104(sp)
    3b46:	f0a2                	sd	s0,96(sp)
    3b48:	e0d2                	sd	s4,64(sp)
    3b4a:	1880                	addi	s0,sp,112
    3b4c:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3b4e:	00003517          	auipc	a0,0x3
    3b52:	2c250513          	addi	a0,a0,706 # 6e10 <malloc+0x1e5e>
    3b56:	7e1000ef          	jal	4b36 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3b5a:	20200593          	li	a1,514
    3b5e:	00003517          	auipc	a0,0x3
    3b62:	2b250513          	addi	a0,a0,690 # 6e10 <malloc+0x1e5e>
    3b66:	7c1000ef          	jal	4b26 <open>
  if(fd < 0){
    3b6a:	04054963          	bltz	a0,3bbc <sharedfd+0x7a>
    3b6e:	eca6                	sd	s1,88(sp)
    3b70:	e8ca                	sd	s2,80(sp)
    3b72:	e4ce                	sd	s3,72(sp)
    3b74:	fc56                	sd	s5,56(sp)
    3b76:	f85a                	sd	s6,48(sp)
    3b78:	f45e                	sd	s7,40(sp)
    3b7a:	892a                	mv	s2,a0
  pid = fork(1);
    3b7c:	4505                	li	a0,1
    3b7e:	761000ef          	jal	4ade <fork>
    3b82:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3b84:	07000593          	li	a1,112
    3b88:	e119                	bnez	a0,3b8e <sharedfd+0x4c>
    3b8a:	06300593          	li	a1,99
    3b8e:	4629                	li	a2,10
    3b90:	fa040513          	addi	a0,s0,-96
    3b94:	565000ef          	jal	48f8 <memset>
    3b98:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3b9c:	4629                	li	a2,10
    3b9e:	fa040593          	addi	a1,s0,-96
    3ba2:	854a                	mv	a0,s2
    3ba4:	763000ef          	jal	4b06 <write>
    3ba8:	47a9                	li	a5,10
    3baa:	02f51963          	bne	a0,a5,3bdc <sharedfd+0x9a>
  for(i = 0; i < N; i++){
    3bae:	34fd                	addiw	s1,s1,-1
    3bb0:	f4f5                	bnez	s1,3b9c <sharedfd+0x5a>
  if(pid == 0) {
    3bb2:	02099f63          	bnez	s3,3bf0 <sharedfd+0xae>
    exit(0);
    3bb6:	4501                	li	a0,0
    3bb8:	72f000ef          	jal	4ae6 <exit>
    3bbc:	eca6                	sd	s1,88(sp)
    3bbe:	e8ca                	sd	s2,80(sp)
    3bc0:	e4ce                	sd	s3,72(sp)
    3bc2:	fc56                	sd	s5,56(sp)
    3bc4:	f85a                	sd	s6,48(sp)
    3bc6:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3bc8:	85d2                	mv	a1,s4
    3bca:	00003517          	auipc	a0,0x3
    3bce:	25650513          	addi	a0,a0,598 # 6e20 <malloc+0x1e6e>
    3bd2:	32c010ef          	jal	4efe <printf>
    exit(1);
    3bd6:	4505                	li	a0,1
    3bd8:	70f000ef          	jal	4ae6 <exit>
      printf("%s: write sharedfd failed\n", s);
    3bdc:	85d2                	mv	a1,s4
    3bde:	00003517          	auipc	a0,0x3
    3be2:	26a50513          	addi	a0,a0,618 # 6e48 <malloc+0x1e96>
    3be6:	318010ef          	jal	4efe <printf>
      exit(1);
    3bea:	4505                	li	a0,1
    3bec:	6fb000ef          	jal	4ae6 <exit>
    wait(&xstatus);
    3bf0:	f9c40513          	addi	a0,s0,-100
    3bf4:	6fb000ef          	jal	4aee <wait>
    if(xstatus != 0)
    3bf8:	f9c42983          	lw	s3,-100(s0)
    3bfc:	00098563          	beqz	s3,3c06 <sharedfd+0xc4>
      exit(xstatus);
    3c00:	854e                	mv	a0,s3
    3c02:	6e5000ef          	jal	4ae6 <exit>
  close(fd);
    3c06:	854a                	mv	a0,s2
    3c08:	707000ef          	jal	4b0e <close>
  fd = open("sharedfd", 0);
    3c0c:	4581                	li	a1,0
    3c0e:	00003517          	auipc	a0,0x3
    3c12:	20250513          	addi	a0,a0,514 # 6e10 <malloc+0x1e5e>
    3c16:	711000ef          	jal	4b26 <open>
    3c1a:	8baa                	mv	s7,a0
  nc = np = 0;
    3c1c:	8ace                	mv	s5,s3
  if(fd < 0){
    3c1e:	02054363          	bltz	a0,3c44 <sharedfd+0x102>
    3c22:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3c26:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3c2a:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3c2e:	4629                	li	a2,10
    3c30:	fa040593          	addi	a1,s0,-96
    3c34:	855e                	mv	a0,s7
    3c36:	6c9000ef          	jal	4afe <read>
    3c3a:	02a05b63          	blez	a0,3c70 <sharedfd+0x12e>
    3c3e:	fa040793          	addi	a5,s0,-96
    3c42:	a839                	j	3c60 <sharedfd+0x11e>
    printf("%s: cannot open sharedfd for reading\n", s);
    3c44:	85d2                	mv	a1,s4
    3c46:	00003517          	auipc	a0,0x3
    3c4a:	22250513          	addi	a0,a0,546 # 6e68 <malloc+0x1eb6>
    3c4e:	2b0010ef          	jal	4efe <printf>
    exit(1);
    3c52:	4505                	li	a0,1
    3c54:	693000ef          	jal	4ae6 <exit>
        nc++;
    3c58:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3c5a:	0785                	addi	a5,a5,1
    3c5c:	fd2789e3          	beq	a5,s2,3c2e <sharedfd+0xec>
      if(buf[i] == 'c')
    3c60:	0007c703          	lbu	a4,0(a5)
    3c64:	fe970ae3          	beq	a4,s1,3c58 <sharedfd+0x116>
      if(buf[i] == 'p')
    3c68:	ff6719e3          	bne	a4,s6,3c5a <sharedfd+0x118>
        np++;
    3c6c:	2a85                	addiw	s5,s5,1
    3c6e:	b7f5                	j	3c5a <sharedfd+0x118>
  close(fd);
    3c70:	855e                	mv	a0,s7
    3c72:	69d000ef          	jal	4b0e <close>
  unlink("sharedfd");
    3c76:	00003517          	auipc	a0,0x3
    3c7a:	19a50513          	addi	a0,a0,410 # 6e10 <malloc+0x1e5e>
    3c7e:	6b9000ef          	jal	4b36 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3c82:	6789                	lui	a5,0x2
    3c84:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x46>
    3c88:	00f99763          	bne	s3,a5,3c96 <sharedfd+0x154>
    3c8c:	6789                	lui	a5,0x2
    3c8e:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x46>
    3c92:	00fa8c63          	beq	s5,a5,3caa <sharedfd+0x168>
    printf("%s: nc/np test fails\n", s);
    3c96:	85d2                	mv	a1,s4
    3c98:	00003517          	auipc	a0,0x3
    3c9c:	1f850513          	addi	a0,a0,504 # 6e90 <malloc+0x1ede>
    3ca0:	25e010ef          	jal	4efe <printf>
    exit(1);
    3ca4:	4505                	li	a0,1
    3ca6:	641000ef          	jal	4ae6 <exit>
    exit(0);
    3caa:	4501                	li	a0,0
    3cac:	63b000ef          	jal	4ae6 <exit>

0000000000003cb0 <fourfiles>:
{
    3cb0:	7135                	addi	sp,sp,-160
    3cb2:	ed06                	sd	ra,152(sp)
    3cb4:	e922                	sd	s0,144(sp)
    3cb6:	e526                	sd	s1,136(sp)
    3cb8:	e14a                	sd	s2,128(sp)
    3cba:	fcce                	sd	s3,120(sp)
    3cbc:	f8d2                	sd	s4,112(sp)
    3cbe:	f4d6                	sd	s5,104(sp)
    3cc0:	f0da                	sd	s6,96(sp)
    3cc2:	ecde                	sd	s7,88(sp)
    3cc4:	e8e2                	sd	s8,80(sp)
    3cc6:	e4e6                	sd	s9,72(sp)
    3cc8:	e0ea                	sd	s10,64(sp)
    3cca:	fc6e                	sd	s11,56(sp)
    3ccc:	1100                	addi	s0,sp,160
    3cce:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3cd0:	00003797          	auipc	a5,0x3
    3cd4:	1d878793          	addi	a5,a5,472 # 6ea8 <malloc+0x1ef6>
    3cd8:	f6f43823          	sd	a5,-144(s0)
    3cdc:	00003797          	auipc	a5,0x3
    3ce0:	1d478793          	addi	a5,a5,468 # 6eb0 <malloc+0x1efe>
    3ce4:	f6f43c23          	sd	a5,-136(s0)
    3ce8:	00003797          	auipc	a5,0x3
    3cec:	1d078793          	addi	a5,a5,464 # 6eb8 <malloc+0x1f06>
    3cf0:	f8f43023          	sd	a5,-128(s0)
    3cf4:	00003797          	auipc	a5,0x3
    3cf8:	1cc78793          	addi	a5,a5,460 # 6ec0 <malloc+0x1f0e>
    3cfc:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3d00:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3d04:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3d06:	4481                	li	s1,0
    3d08:	4a11                	li	s4,4
    fname = names[pi];
    3d0a:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3d0e:	854e                	mv	a0,s3
    3d10:	627000ef          	jal	4b36 <unlink>
    pid = fork(1);
    3d14:	4505                	li	a0,1
    3d16:	5c9000ef          	jal	4ade <fork>
    if(pid < 0){
    3d1a:	02054e63          	bltz	a0,3d56 <fourfiles+0xa6>
    if(pid == 0){
    3d1e:	c531                	beqz	a0,3d6a <fourfiles+0xba>
  for(pi = 0; pi < NCHILD; pi++){
    3d20:	2485                	addiw	s1,s1,1
    3d22:	0921                	addi	s2,s2,8
    3d24:	ff4493e3          	bne	s1,s4,3d0a <fourfiles+0x5a>
    3d28:	4491                	li	s1,4
    wait(&xstatus);
    3d2a:	f6c40513          	addi	a0,s0,-148
    3d2e:	5c1000ef          	jal	4aee <wait>
    if(xstatus != 0)
    3d32:	f6c42a83          	lw	s5,-148(s0)
    3d36:	0a0a9463          	bnez	s5,3dde <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
    3d3a:	34fd                	addiw	s1,s1,-1
    3d3c:	f4fd                	bnez	s1,3d2a <fourfiles+0x7a>
    3d3e:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3d42:	00009a17          	auipc	s4,0x9
    3d46:	f36a0a13          	addi	s4,s4,-202 # cc78 <buf>
    if(total != N*SZ){
    3d4a:	6d05                	lui	s10,0x1
    3d4c:	770d0d13          	addi	s10,s10,1904 # 1770 <forkfork+0x10>
  for(i = 0; i < NCHILD; i++){
    3d50:	03400d93          	li	s11,52
    3d54:	a0ed                	j	3e3e <fourfiles+0x18e>
      printf("%s: fork12 failed\n", s);
    3d56:	85e6                	mv	a1,s9
    3d58:	00003517          	auipc	a0,0x3
    3d5c:	17050513          	addi	a0,a0,368 # 6ec8 <malloc+0x1f16>
    3d60:	19e010ef          	jal	4efe <printf>
      exit(1);
    3d64:	4505                	li	a0,1
    3d66:	581000ef          	jal	4ae6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3d6a:	20200593          	li	a1,514
    3d6e:	854e                	mv	a0,s3
    3d70:	5b7000ef          	jal	4b26 <open>
    3d74:	892a                	mv	s2,a0
      if(fd < 0){
    3d76:	04054163          	bltz	a0,3db8 <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
    3d7a:	1f400613          	li	a2,500
    3d7e:	0304859b          	addiw	a1,s1,48
    3d82:	00009517          	auipc	a0,0x9
    3d86:	ef650513          	addi	a0,a0,-266 # cc78 <buf>
    3d8a:	36f000ef          	jal	48f8 <memset>
    3d8e:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3d90:	00009997          	auipc	s3,0x9
    3d94:	ee898993          	addi	s3,s3,-280 # cc78 <buf>
    3d98:	1f400613          	li	a2,500
    3d9c:	85ce                	mv	a1,s3
    3d9e:	854a                	mv	a0,s2
    3da0:	567000ef          	jal	4b06 <write>
    3da4:	85aa                	mv	a1,a0
    3da6:	1f400793          	li	a5,500
    3daa:	02f51163          	bne	a0,a5,3dcc <fourfiles+0x11c>
      for(i = 0; i < N; i++){
    3dae:	34fd                	addiw	s1,s1,-1
    3db0:	f4e5                	bnez	s1,3d98 <fourfiles+0xe8>
      exit(0);
    3db2:	4501                	li	a0,0
    3db4:	533000ef          	jal	4ae6 <exit>
        printf("%s: create failed\n", s);
    3db8:	85e6                	mv	a1,s9
    3dba:	00002517          	auipc	a0,0x2
    3dbe:	c5650513          	addi	a0,a0,-938 # 5a10 <malloc+0xa5e>
    3dc2:	13c010ef          	jal	4efe <printf>
        exit(1);
    3dc6:	4505                	li	a0,1
    3dc8:	51f000ef          	jal	4ae6 <exit>
          printf("write failed %d\n", n);
    3dcc:	00003517          	auipc	a0,0x3
    3dd0:	11450513          	addi	a0,a0,276 # 6ee0 <malloc+0x1f2e>
    3dd4:	12a010ef          	jal	4efe <printf>
          exit(1);
    3dd8:	4505                	li	a0,1
    3dda:	50d000ef          	jal	4ae6 <exit>
      exit(xstatus);
    3dde:	8556                	mv	a0,s5
    3de0:	507000ef          	jal	4ae6 <exit>
          printf("%s: wrong char\n", s);
    3de4:	85e6                	mv	a1,s9
    3de6:	00003517          	auipc	a0,0x3
    3dea:	11250513          	addi	a0,a0,274 # 6ef8 <malloc+0x1f46>
    3dee:	110010ef          	jal	4efe <printf>
          exit(1);
    3df2:	4505                	li	a0,1
    3df4:	4f3000ef          	jal	4ae6 <exit>
      total += n;
    3df8:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3dfc:	660d                	lui	a2,0x3
    3dfe:	85d2                	mv	a1,s4
    3e00:	854e                	mv	a0,s3
    3e02:	4fd000ef          	jal	4afe <read>
    3e06:	02a05063          	blez	a0,3e26 <fourfiles+0x176>
    3e0a:	00009797          	auipc	a5,0x9
    3e0e:	e6e78793          	addi	a5,a5,-402 # cc78 <buf>
    3e12:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3e16:	0007c703          	lbu	a4,0(a5)
    3e1a:	fc9715e3          	bne	a4,s1,3de4 <fourfiles+0x134>
      for(j = 0; j < n; j++){
    3e1e:	0785                	addi	a5,a5,1
    3e20:	fed79be3          	bne	a5,a3,3e16 <fourfiles+0x166>
    3e24:	bfd1                	j	3df8 <fourfiles+0x148>
    close(fd);
    3e26:	854e                	mv	a0,s3
    3e28:	4e7000ef          	jal	4b0e <close>
    if(total != N*SZ){
    3e2c:	03a91463          	bne	s2,s10,3e54 <fourfiles+0x1a4>
    unlink(fname);
    3e30:	8562                	mv	a0,s8
    3e32:	505000ef          	jal	4b36 <unlink>
  for(i = 0; i < NCHILD; i++){
    3e36:	0ba1                	addi	s7,s7,8
    3e38:	2b05                	addiw	s6,s6,1
    3e3a:	03bb0763          	beq	s6,s11,3e68 <fourfiles+0x1b8>
    fname = names[i];
    3e3e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3e42:	4581                	li	a1,0
    3e44:	8562                	mv	a0,s8
    3e46:	4e1000ef          	jal	4b26 <open>
    3e4a:	89aa                	mv	s3,a0
    total = 0;
    3e4c:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    3e4e:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e52:	b76d                	j	3dfc <fourfiles+0x14c>
      printf("wrong length %d\n", total);
    3e54:	85ca                	mv	a1,s2
    3e56:	00003517          	auipc	a0,0x3
    3e5a:	0b250513          	addi	a0,a0,178 # 6f08 <malloc+0x1f56>
    3e5e:	0a0010ef          	jal	4efe <printf>
      exit(1);
    3e62:	4505                	li	a0,1
    3e64:	483000ef          	jal	4ae6 <exit>
}
    3e68:	60ea                	ld	ra,152(sp)
    3e6a:	644a                	ld	s0,144(sp)
    3e6c:	64aa                	ld	s1,136(sp)
    3e6e:	690a                	ld	s2,128(sp)
    3e70:	79e6                	ld	s3,120(sp)
    3e72:	7a46                	ld	s4,112(sp)
    3e74:	7aa6                	ld	s5,104(sp)
    3e76:	7b06                	ld	s6,96(sp)
    3e78:	6be6                	ld	s7,88(sp)
    3e7a:	6c46                	ld	s8,80(sp)
    3e7c:	6ca6                	ld	s9,72(sp)
    3e7e:	6d06                	ld	s10,64(sp)
    3e80:	7de2                	ld	s11,56(sp)
    3e82:	610d                	addi	sp,sp,160
    3e84:	8082                	ret

0000000000003e86 <concreate>:
{
    3e86:	7135                	addi	sp,sp,-160
    3e88:	ed06                	sd	ra,152(sp)
    3e8a:	e922                	sd	s0,144(sp)
    3e8c:	e526                	sd	s1,136(sp)
    3e8e:	e14a                	sd	s2,128(sp)
    3e90:	fcce                	sd	s3,120(sp)
    3e92:	f8d2                	sd	s4,112(sp)
    3e94:	f4d6                	sd	s5,104(sp)
    3e96:	f0da                	sd	s6,96(sp)
    3e98:	ecde                	sd	s7,88(sp)
    3e9a:	1100                	addi	s0,sp,160
    3e9c:	89aa                	mv	s3,a0
  file[0] = 'C';
    3e9e:	04300793          	li	a5,67
    3ea2:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3ea6:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3eaa:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3eac:	4a8d                	li	s5,3
      link("C0", file);
    3eae:	00003b17          	auipc	s6,0x3
    3eb2:	072b0b13          	addi	s6,s6,114 # 6f20 <malloc+0x1f6e>
  for(i = 0; i < N; i++){
    3eb6:	02800a13          	li	s4,40
    3eba:	a425                	j	40e2 <concreate+0x25c>
      link("C0", file);
    3ebc:	fa840593          	addi	a1,s0,-88
    3ec0:	855a                	mv	a0,s6
    3ec2:	485000ef          	jal	4b46 <link>
    if(pid == 0) {
    3ec6:	a419                	j	40cc <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    3ec8:	4795                	li	a5,5
    3eca:	02f9693b          	remw	s2,s2,a5
    3ece:	4785                	li	a5,1
    3ed0:	02f90563          	beq	s2,a5,3efa <concreate+0x74>
      fd = open(file, O_CREATE | O_RDWR);
    3ed4:	20200593          	li	a1,514
    3ed8:	fa840513          	addi	a0,s0,-88
    3edc:	44b000ef          	jal	4b26 <open>
      if(fd < 0){
    3ee0:	1e055163          	bgez	a0,40c2 <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3ee4:	fa840593          	addi	a1,s0,-88
    3ee8:	00003517          	auipc	a0,0x3
    3eec:	04050513          	addi	a0,a0,64 # 6f28 <malloc+0x1f76>
    3ef0:	00e010ef          	jal	4efe <printf>
        exit(1);
    3ef4:	4505                	li	a0,1
    3ef6:	3f1000ef          	jal	4ae6 <exit>
      link("C0", file);
    3efa:	fa840593          	addi	a1,s0,-88
    3efe:	00003517          	auipc	a0,0x3
    3f02:	02250513          	addi	a0,a0,34 # 6f20 <malloc+0x1f6e>
    3f06:	441000ef          	jal	4b46 <link>
      exit(0);
    3f0a:	4501                	li	a0,0
    3f0c:	3db000ef          	jal	4ae6 <exit>
        exit(1);
    3f10:	4505                	li	a0,1
    3f12:	3d5000ef          	jal	4ae6 <exit>
  memset(fa, 0, sizeof(fa));
    3f16:	02800613          	li	a2,40
    3f1a:	4581                	li	a1,0
    3f1c:	f8040513          	addi	a0,s0,-128
    3f20:	1d9000ef          	jal	48f8 <memset>
  fd = open(".", 0);
    3f24:	4581                	li	a1,0
    3f26:	00002517          	auipc	a0,0x2
    3f2a:	8aa50513          	addi	a0,a0,-1878 # 57d0 <malloc+0x81e>
    3f2e:	3f9000ef          	jal	4b26 <open>
    3f32:	892a                	mv	s2,a0
  n = 0;
    3f34:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3f36:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3f3a:	02700b13          	li	s6,39
      fa[i] = 1;
    3f3e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3f40:	4641                	li	a2,16
    3f42:	f7040593          	addi	a1,s0,-144
    3f46:	854a                	mv	a0,s2
    3f48:	3b7000ef          	jal	4afe <read>
    3f4c:	06a05a63          	blez	a0,3fc0 <concreate+0x13a>
    if(de.inum == 0)
    3f50:	f7045783          	lhu	a5,-144(s0)
    3f54:	d7f5                	beqz	a5,3f40 <concreate+0xba>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3f56:	f7244783          	lbu	a5,-142(s0)
    3f5a:	ff4793e3          	bne	a5,s4,3f40 <concreate+0xba>
    3f5e:	f7444783          	lbu	a5,-140(s0)
    3f62:	fff9                	bnez	a5,3f40 <concreate+0xba>
      i = de.name[1] - '0';
    3f64:	f7344783          	lbu	a5,-141(s0)
    3f68:	fd07879b          	addiw	a5,a5,-48
    3f6c:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3f70:	02eb6063          	bltu	s6,a4,3f90 <concreate+0x10a>
      if(fa[i]){
    3f74:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x112>
    3f78:	97a2                	add	a5,a5,s0
    3f7a:	fd07c783          	lbu	a5,-48(a5)
    3f7e:	e78d                	bnez	a5,3fa8 <concreate+0x122>
      fa[i] = 1;
    3f80:	fb070793          	addi	a5,a4,-80
    3f84:	00878733          	add	a4,a5,s0
    3f88:	fd770823          	sb	s7,-48(a4)
      n++;
    3f8c:	2a85                	addiw	s5,s5,1
    3f8e:	bf4d                	j	3f40 <concreate+0xba>
        printf("%s: concreate weird file %s\n", s, de.name);
    3f90:	f7240613          	addi	a2,s0,-142
    3f94:	85ce                	mv	a1,s3
    3f96:	00003517          	auipc	a0,0x3
    3f9a:	fb250513          	addi	a0,a0,-78 # 6f48 <malloc+0x1f96>
    3f9e:	761000ef          	jal	4efe <printf>
        exit(1);
    3fa2:	4505                	li	a0,1
    3fa4:	343000ef          	jal	4ae6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3fa8:	f7240613          	addi	a2,s0,-142
    3fac:	85ce                	mv	a1,s3
    3fae:	00003517          	auipc	a0,0x3
    3fb2:	fba50513          	addi	a0,a0,-70 # 6f68 <malloc+0x1fb6>
    3fb6:	749000ef          	jal	4efe <printf>
        exit(1);
    3fba:	4505                	li	a0,1
    3fbc:	32b000ef          	jal	4ae6 <exit>
  close(fd);
    3fc0:	854a                	mv	a0,s2
    3fc2:	34d000ef          	jal	4b0e <close>
  if(n != N){
    3fc6:	02800793          	li	a5,40
    3fca:	00fa9663          	bne	s5,a5,3fd6 <concreate+0x150>
    if(((i % 3) == 0 && pid == 0) ||
    3fce:	4a8d                	li	s5,3
  for(i = 0; i < N; i++){
    3fd0:	02800a13          	li	s4,40
    3fd4:	a079                	j	4062 <concreate+0x1dc>
    printf("%s: concreate not enough files in directory listing\n", s);
    3fd6:	85ce                	mv	a1,s3
    3fd8:	00003517          	auipc	a0,0x3
    3fdc:	fb850513          	addi	a0,a0,-72 # 6f90 <malloc+0x1fde>
    3fe0:	71f000ef          	jal	4efe <printf>
    exit(1);
    3fe4:	4505                	li	a0,1
    3fe6:	301000ef          	jal	4ae6 <exit>
      printf("%s: fork14 failed\n", s);
    3fea:	85ce                	mv	a1,s3
    3fec:	00003517          	auipc	a0,0x3
    3ff0:	fdc50513          	addi	a0,a0,-36 # 6fc8 <malloc+0x2016>
    3ff4:	70b000ef          	jal	4efe <printf>
      exit(1);
    3ff8:	4505                	li	a0,1
    3ffa:	2ed000ef          	jal	4ae6 <exit>
      close(open(file, 0));
    3ffe:	4581                	li	a1,0
    4000:	fa840513          	addi	a0,s0,-88
    4004:	323000ef          	jal	4b26 <open>
    4008:	307000ef          	jal	4b0e <close>
      close(open(file, 0));
    400c:	4581                	li	a1,0
    400e:	fa840513          	addi	a0,s0,-88
    4012:	315000ef          	jal	4b26 <open>
    4016:	2f9000ef          	jal	4b0e <close>
      close(open(file, 0));
    401a:	4581                	li	a1,0
    401c:	fa840513          	addi	a0,s0,-88
    4020:	307000ef          	jal	4b26 <open>
    4024:	2eb000ef          	jal	4b0e <close>
      close(open(file, 0));
    4028:	4581                	li	a1,0
    402a:	fa840513          	addi	a0,s0,-88
    402e:	2f9000ef          	jal	4b26 <open>
    4032:	2dd000ef          	jal	4b0e <close>
      close(open(file, 0));
    4036:	4581                	li	a1,0
    4038:	fa840513          	addi	a0,s0,-88
    403c:	2eb000ef          	jal	4b26 <open>
    4040:	2cf000ef          	jal	4b0e <close>
      close(open(file, 0));
    4044:	4581                	li	a1,0
    4046:	fa840513          	addi	a0,s0,-88
    404a:	2dd000ef          	jal	4b26 <open>
    404e:	2c1000ef          	jal	4b0e <close>
    if(pid == 0)
    4052:	06090563          	beqz	s2,40bc <concreate+0x236>
      wait(0);
    4056:	4501                	li	a0,0
    4058:	297000ef          	jal	4aee <wait>
  for(i = 0; i < N; i++){
    405c:	2485                	addiw	s1,s1,1
    405e:	0b448d63          	beq	s1,s4,4118 <concreate+0x292>
    file[1] = '0' + i;
    4062:	0304879b          	addiw	a5,s1,48
    4066:	faf404a3          	sb	a5,-87(s0)
    pid = fork(1);
    406a:	4505                	li	a0,1
    406c:	273000ef          	jal	4ade <fork>
    4070:	892a                	mv	s2,a0
    if(pid < 0){
    4072:	f6054ce3          	bltz	a0,3fea <concreate+0x164>
    if(((i % 3) == 0 && pid == 0) ||
    4076:	0354e73b          	remw	a4,s1,s5
    407a:	00a767b3          	or	a5,a4,a0
    407e:	2781                	sext.w	a5,a5
    4080:	dfbd                	beqz	a5,3ffe <concreate+0x178>
    4082:	4785                	li	a5,1
    4084:	00f71363          	bne	a4,a5,408a <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    4088:	f93d                	bnez	a0,3ffe <concreate+0x178>
      unlink(file);
    408a:	fa840513          	addi	a0,s0,-88
    408e:	2a9000ef          	jal	4b36 <unlink>
      unlink(file);
    4092:	fa840513          	addi	a0,s0,-88
    4096:	2a1000ef          	jal	4b36 <unlink>
      unlink(file);
    409a:	fa840513          	addi	a0,s0,-88
    409e:	299000ef          	jal	4b36 <unlink>
      unlink(file);
    40a2:	fa840513          	addi	a0,s0,-88
    40a6:	291000ef          	jal	4b36 <unlink>
      unlink(file);
    40aa:	fa840513          	addi	a0,s0,-88
    40ae:	289000ef          	jal	4b36 <unlink>
      unlink(file);
    40b2:	fa840513          	addi	a0,s0,-88
    40b6:	281000ef          	jal	4b36 <unlink>
    40ba:	bf61                	j	4052 <concreate+0x1cc>
      exit(0);
    40bc:	4501                	li	a0,0
    40be:	229000ef          	jal	4ae6 <exit>
      close(fd);
    40c2:	24d000ef          	jal	4b0e <close>
    if(pid == 0) {
    40c6:	b591                	j	3f0a <concreate+0x84>
      close(fd);
    40c8:	247000ef          	jal	4b0e <close>
      wait(&xstatus);
    40cc:	f6c40513          	addi	a0,s0,-148
    40d0:	21f000ef          	jal	4aee <wait>
      if(xstatus != 0)
    40d4:	f6c42483          	lw	s1,-148(s0)
    40d8:	e2049ce3          	bnez	s1,3f10 <concreate+0x8a>
  for(i = 0; i < N; i++){
    40dc:	2905                	addiw	s2,s2,1
    40de:	e3490ce3          	beq	s2,s4,3f16 <concreate+0x90>
    file[1] = '0' + i;
    40e2:	0309079b          	addiw	a5,s2,48
    40e6:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    40ea:	fa840513          	addi	a0,s0,-88
    40ee:	249000ef          	jal	4b36 <unlink>
    pid = fork(1);
    40f2:	4505                	li	a0,1
    40f4:	1eb000ef          	jal	4ade <fork>
    if(pid && (i % 3) == 1){
    40f8:	dc0508e3          	beqz	a0,3ec8 <concreate+0x42>
    40fc:	035967bb          	remw	a5,s2,s5
    4100:	4705                	li	a4,1
    4102:	dae78de3          	beq	a5,a4,3ebc <concreate+0x36>
      fd = open(file, O_CREATE | O_RDWR);
    4106:	20200593          	li	a1,514
    410a:	fa840513          	addi	a0,s0,-88
    410e:	219000ef          	jal	4b26 <open>
      if(fd < 0){
    4112:	fa055be3          	bgez	a0,40c8 <concreate+0x242>
    4116:	b3f9                	j	3ee4 <concreate+0x5e>
}
    4118:	60ea                	ld	ra,152(sp)
    411a:	644a                	ld	s0,144(sp)
    411c:	64aa                	ld	s1,136(sp)
    411e:	690a                	ld	s2,128(sp)
    4120:	79e6                	ld	s3,120(sp)
    4122:	7a46                	ld	s4,112(sp)
    4124:	7aa6                	ld	s5,104(sp)
    4126:	7b06                	ld	s6,96(sp)
    4128:	6be6                	ld	s7,88(sp)
    412a:	610d                	addi	sp,sp,160
    412c:	8082                	ret

000000000000412e <bigfile>:
{
    412e:	7139                	addi	sp,sp,-64
    4130:	fc06                	sd	ra,56(sp)
    4132:	f822                	sd	s0,48(sp)
    4134:	f426                	sd	s1,40(sp)
    4136:	f04a                	sd	s2,32(sp)
    4138:	ec4e                	sd	s3,24(sp)
    413a:	e852                	sd	s4,16(sp)
    413c:	e456                	sd	s5,8(sp)
    413e:	0080                	addi	s0,sp,64
    4140:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4142:	00003517          	auipc	a0,0x3
    4146:	e9e50513          	addi	a0,a0,-354 # 6fe0 <malloc+0x202e>
    414a:	1ed000ef          	jal	4b36 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    414e:	20200593          	li	a1,514
    4152:	00003517          	auipc	a0,0x3
    4156:	e8e50513          	addi	a0,a0,-370 # 6fe0 <malloc+0x202e>
    415a:	1cd000ef          	jal	4b26 <open>
    415e:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4160:	4481                	li	s1,0
    memset(buf, i, SZ);
    4162:	00009917          	auipc	s2,0x9
    4166:	b1690913          	addi	s2,s2,-1258 # cc78 <buf>
  for(i = 0; i < N; i++){
    416a:	4a51                	li	s4,20
  if(fd < 0){
    416c:	08054663          	bltz	a0,41f8 <bigfile+0xca>
    memset(buf, i, SZ);
    4170:	25800613          	li	a2,600
    4174:	85a6                	mv	a1,s1
    4176:	854a                	mv	a0,s2
    4178:	780000ef          	jal	48f8 <memset>
    if(write(fd, buf, SZ) != SZ){
    417c:	25800613          	li	a2,600
    4180:	85ca                	mv	a1,s2
    4182:	854e                	mv	a0,s3
    4184:	183000ef          	jal	4b06 <write>
    4188:	25800793          	li	a5,600
    418c:	08f51063          	bne	a0,a5,420c <bigfile+0xde>
  for(i = 0; i < N; i++){
    4190:	2485                	addiw	s1,s1,1
    4192:	fd449fe3          	bne	s1,s4,4170 <bigfile+0x42>
  close(fd);
    4196:	854e                	mv	a0,s3
    4198:	177000ef          	jal	4b0e <close>
  fd = open("bigfile.dat", 0);
    419c:	4581                	li	a1,0
    419e:	00003517          	auipc	a0,0x3
    41a2:	e4250513          	addi	a0,a0,-446 # 6fe0 <malloc+0x202e>
    41a6:	181000ef          	jal	4b26 <open>
    41aa:	8a2a                	mv	s4,a0
  total = 0;
    41ac:	4981                	li	s3,0
  for(i = 0; ; i++){
    41ae:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    41b0:	00009917          	auipc	s2,0x9
    41b4:	ac890913          	addi	s2,s2,-1336 # cc78 <buf>
  if(fd < 0){
    41b8:	06054463          	bltz	a0,4220 <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    41bc:	12c00613          	li	a2,300
    41c0:	85ca                	mv	a1,s2
    41c2:	8552                	mv	a0,s4
    41c4:	13b000ef          	jal	4afe <read>
    if(cc < 0){
    41c8:	06054663          	bltz	a0,4234 <bigfile+0x106>
    if(cc == 0)
    41cc:	c155                	beqz	a0,4270 <bigfile+0x142>
    if(cc != SZ/2){
    41ce:	12c00793          	li	a5,300
    41d2:	06f51b63          	bne	a0,a5,4248 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    41d6:	01f4d79b          	srliw	a5,s1,0x1f
    41da:	9fa5                	addw	a5,a5,s1
    41dc:	4017d79b          	sraiw	a5,a5,0x1
    41e0:	00094703          	lbu	a4,0(s2)
    41e4:	06f71c63          	bne	a4,a5,425c <bigfile+0x12e>
    41e8:	12b94703          	lbu	a4,299(s2)
    41ec:	06f71863          	bne	a4,a5,425c <bigfile+0x12e>
    total += cc;
    41f0:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    41f4:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    41f6:	b7d9                	j	41bc <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    41f8:	85d6                	mv	a1,s5
    41fa:	00003517          	auipc	a0,0x3
    41fe:	df650513          	addi	a0,a0,-522 # 6ff0 <malloc+0x203e>
    4202:	4fd000ef          	jal	4efe <printf>
    exit(1);
    4206:	4505                	li	a0,1
    4208:	0df000ef          	jal	4ae6 <exit>
      printf("%s: write bigfile failed\n", s);
    420c:	85d6                	mv	a1,s5
    420e:	00003517          	auipc	a0,0x3
    4212:	e0250513          	addi	a0,a0,-510 # 7010 <malloc+0x205e>
    4216:	4e9000ef          	jal	4efe <printf>
      exit(1);
    421a:	4505                	li	a0,1
    421c:	0cb000ef          	jal	4ae6 <exit>
    printf("%s: cannot open bigfile\n", s);
    4220:	85d6                	mv	a1,s5
    4222:	00003517          	auipc	a0,0x3
    4226:	e0e50513          	addi	a0,a0,-498 # 7030 <malloc+0x207e>
    422a:	4d5000ef          	jal	4efe <printf>
    exit(1);
    422e:	4505                	li	a0,1
    4230:	0b7000ef          	jal	4ae6 <exit>
      printf("%s: read bigfile failed\n", s);
    4234:	85d6                	mv	a1,s5
    4236:	00003517          	auipc	a0,0x3
    423a:	e1a50513          	addi	a0,a0,-486 # 7050 <malloc+0x209e>
    423e:	4c1000ef          	jal	4efe <printf>
      exit(1);
    4242:	4505                	li	a0,1
    4244:	0a3000ef          	jal	4ae6 <exit>
      printf("%s: short read bigfile\n", s);
    4248:	85d6                	mv	a1,s5
    424a:	00003517          	auipc	a0,0x3
    424e:	e2650513          	addi	a0,a0,-474 # 7070 <malloc+0x20be>
    4252:	4ad000ef          	jal	4efe <printf>
      exit(1);
    4256:	4505                	li	a0,1
    4258:	08f000ef          	jal	4ae6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    425c:	85d6                	mv	a1,s5
    425e:	00003517          	auipc	a0,0x3
    4262:	e2a50513          	addi	a0,a0,-470 # 7088 <malloc+0x20d6>
    4266:	499000ef          	jal	4efe <printf>
      exit(1);
    426a:	4505                	li	a0,1
    426c:	07b000ef          	jal	4ae6 <exit>
  close(fd);
    4270:	8552                	mv	a0,s4
    4272:	09d000ef          	jal	4b0e <close>
  if(total != N*SZ){
    4276:	678d                	lui	a5,0x3
    4278:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x2cc>
    427c:	02f99163          	bne	s3,a5,429e <bigfile+0x170>
  unlink("bigfile.dat");
    4280:	00003517          	auipc	a0,0x3
    4284:	d6050513          	addi	a0,a0,-672 # 6fe0 <malloc+0x202e>
    4288:	0af000ef          	jal	4b36 <unlink>
}
    428c:	70e2                	ld	ra,56(sp)
    428e:	7442                	ld	s0,48(sp)
    4290:	74a2                	ld	s1,40(sp)
    4292:	7902                	ld	s2,32(sp)
    4294:	69e2                	ld	s3,24(sp)
    4296:	6a42                	ld	s4,16(sp)
    4298:	6aa2                	ld	s5,8(sp)
    429a:	6121                	addi	sp,sp,64
    429c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    429e:	85d6                	mv	a1,s5
    42a0:	00003517          	auipc	a0,0x3
    42a4:	e0850513          	addi	a0,a0,-504 # 70a8 <malloc+0x20f6>
    42a8:	457000ef          	jal	4efe <printf>
    exit(1);
    42ac:	4505                	li	a0,1
    42ae:	039000ef          	jal	4ae6 <exit>

00000000000042b2 <bigargtest>:
{
    42b2:	7121                	addi	sp,sp,-448
    42b4:	ff06                	sd	ra,440(sp)
    42b6:	fb22                	sd	s0,432(sp)
    42b8:	f726                	sd	s1,424(sp)
    42ba:	0380                	addi	s0,sp,448
    42bc:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    42be:	00003517          	auipc	a0,0x3
    42c2:	e0a50513          	addi	a0,a0,-502 # 70c8 <malloc+0x2116>
    42c6:	071000ef          	jal	4b36 <unlink>
  pid = fork(1);
    42ca:	4505                	li	a0,1
    42cc:	013000ef          	jal	4ade <fork>
  if(pid == 0){
    42d0:	c915                	beqz	a0,4304 <bigargtest+0x52>
  } else if(pid < 0){
    42d2:	08054a63          	bltz	a0,4366 <bigargtest+0xb4>
  wait(&xstatus);
    42d6:	fdc40513          	addi	a0,s0,-36
    42da:	015000ef          	jal	4aee <wait>
  if(xstatus != 0)
    42de:	fdc42503          	lw	a0,-36(s0)
    42e2:	ed41                	bnez	a0,437a <bigargtest+0xc8>
  fd = open("bigarg-ok", 0);
    42e4:	4581                	li	a1,0
    42e6:	00003517          	auipc	a0,0x3
    42ea:	de250513          	addi	a0,a0,-542 # 70c8 <malloc+0x2116>
    42ee:	039000ef          	jal	4b26 <open>
  if(fd < 0){
    42f2:	08054663          	bltz	a0,437e <bigargtest+0xcc>
  close(fd);
    42f6:	019000ef          	jal	4b0e <close>
}
    42fa:	70fa                	ld	ra,440(sp)
    42fc:	745a                	ld	s0,432(sp)
    42fe:	74ba                	ld	s1,424(sp)
    4300:	6139                	addi	sp,sp,448
    4302:	8082                	ret
    memset(big, ' ', sizeof(big));
    4304:	19000613          	li	a2,400
    4308:	02000593          	li	a1,32
    430c:	e4840513          	addi	a0,s0,-440
    4310:	5e8000ef          	jal	48f8 <memset>
    big[sizeof(big)-1] = '\0';
    4314:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    4318:	00005797          	auipc	a5,0x5
    431c:	14878793          	addi	a5,a5,328 # 9460 <args.1>
    4320:	00005697          	auipc	a3,0x5
    4324:	23868693          	addi	a3,a3,568 # 9558 <args.1+0xf8>
      args[i] = big;
    4328:	e4840713          	addi	a4,s0,-440
    432c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    432e:	07a1                	addi	a5,a5,8
    4330:	fed79ee3          	bne	a5,a3,432c <bigargtest+0x7a>
    args[MAXARG-1] = 0;
    4334:	00005597          	auipc	a1,0x5
    4338:	12c58593          	addi	a1,a1,300 # 9460 <args.1>
    433c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    4340:	00001517          	auipc	a0,0x1
    4344:	da850513          	addi	a0,a0,-600 # 50e8 <malloc+0x136>
    4348:	7d6000ef          	jal	4b1e <exec>
    fd = open("bigarg-ok", O_CREATE);
    434c:	20000593          	li	a1,512
    4350:	00003517          	auipc	a0,0x3
    4354:	d7850513          	addi	a0,a0,-648 # 70c8 <malloc+0x2116>
    4358:	7ce000ef          	jal	4b26 <open>
    close(fd);
    435c:	7b2000ef          	jal	4b0e <close>
    exit(0);
    4360:	4501                	li	a0,0
    4362:	784000ef          	jal	4ae6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    4366:	85a6                	mv	a1,s1
    4368:	00003517          	auipc	a0,0x3
    436c:	d7050513          	addi	a0,a0,-656 # 70d8 <malloc+0x2126>
    4370:	38f000ef          	jal	4efe <printf>
    exit(1);
    4374:	4505                	li	a0,1
    4376:	770000ef          	jal	4ae6 <exit>
    exit(xstatus);
    437a:	76c000ef          	jal	4ae6 <exit>
    printf("%s: bigarg test failed!\n", s);
    437e:	85a6                	mv	a1,s1
    4380:	00003517          	auipc	a0,0x3
    4384:	d7850513          	addi	a0,a0,-648 # 70f8 <malloc+0x2146>
    4388:	377000ef          	jal	4efe <printf>
    exit(1);
    438c:	4505                	li	a0,1
    438e:	758000ef          	jal	4ae6 <exit>

0000000000004392 <fsfull>:
{
    4392:	7135                	addi	sp,sp,-160
    4394:	ed06                	sd	ra,152(sp)
    4396:	e922                	sd	s0,144(sp)
    4398:	e526                	sd	s1,136(sp)
    439a:	e14a                	sd	s2,128(sp)
    439c:	fcce                	sd	s3,120(sp)
    439e:	f8d2                	sd	s4,112(sp)
    43a0:	f4d6                	sd	s5,104(sp)
    43a2:	f0da                	sd	s6,96(sp)
    43a4:	ecde                	sd	s7,88(sp)
    43a6:	e8e2                	sd	s8,80(sp)
    43a8:	e4e6                	sd	s9,72(sp)
    43aa:	e0ea                	sd	s10,64(sp)
    43ac:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    43ae:	00003517          	auipc	a0,0x3
    43b2:	d6a50513          	addi	a0,a0,-662 # 7118 <malloc+0x2166>
    43b6:	349000ef          	jal	4efe <printf>
  for(nfiles = 0; ; nfiles++){
    43ba:	4481                	li	s1,0
    name[0] = 'f';
    43bc:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    43c0:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    43c4:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    43c8:	4b29                	li	s6,10
    printf("writing %s\n", name);
    43ca:	00003c97          	auipc	s9,0x3
    43ce:	d5ec8c93          	addi	s9,s9,-674 # 7128 <malloc+0x2176>
    name[0] = 'f';
    43d2:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    43d6:	0384c7bb          	divw	a5,s1,s8
    43da:	0307879b          	addiw	a5,a5,48
    43de:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    43e2:	0384e7bb          	remw	a5,s1,s8
    43e6:	0377c7bb          	divw	a5,a5,s7
    43ea:	0307879b          	addiw	a5,a5,48
    43ee:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    43f2:	0374e7bb          	remw	a5,s1,s7
    43f6:	0367c7bb          	divw	a5,a5,s6
    43fa:	0307879b          	addiw	a5,a5,48
    43fe:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4402:	0364e7bb          	remw	a5,s1,s6
    4406:	0307879b          	addiw	a5,a5,48
    440a:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    440e:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    4412:	f6040593          	addi	a1,s0,-160
    4416:	8566                	mv	a0,s9
    4418:	2e7000ef          	jal	4efe <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    441c:	20200593          	li	a1,514
    4420:	f6040513          	addi	a0,s0,-160
    4424:	702000ef          	jal	4b26 <open>
    4428:	892a                	mv	s2,a0
    if(fd < 0){
    442a:	08055f63          	bgez	a0,44c8 <fsfull+0x136>
      printf("open %s failed\n", name);
    442e:	f6040593          	addi	a1,s0,-160
    4432:	00003517          	auipc	a0,0x3
    4436:	d0650513          	addi	a0,a0,-762 # 7138 <malloc+0x2186>
    443a:	2c5000ef          	jal	4efe <printf>
  while(nfiles >= 0){
    443e:	0604c163          	bltz	s1,44a0 <fsfull+0x10e>
    name[0] = 'f';
    4442:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4446:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    444a:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    444e:	4929                	li	s2,10
  while(nfiles >= 0){
    4450:	5afd                	li	s5,-1
    name[0] = 'f';
    4452:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4456:	0344c7bb          	divw	a5,s1,s4
    445a:	0307879b          	addiw	a5,a5,48
    445e:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4462:	0344e7bb          	remw	a5,s1,s4
    4466:	0337c7bb          	divw	a5,a5,s3
    446a:	0307879b          	addiw	a5,a5,48
    446e:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4472:	0334e7bb          	remw	a5,s1,s3
    4476:	0327c7bb          	divw	a5,a5,s2
    447a:	0307879b          	addiw	a5,a5,48
    447e:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4482:	0324e7bb          	remw	a5,s1,s2
    4486:	0307879b          	addiw	a5,a5,48
    448a:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    448e:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4492:	f6040513          	addi	a0,s0,-160
    4496:	6a0000ef          	jal	4b36 <unlink>
    nfiles--;
    449a:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    449c:	fb549be3          	bne	s1,s5,4452 <fsfull+0xc0>
  printf("fsfull test finished\n");
    44a0:	00003517          	auipc	a0,0x3
    44a4:	cb850513          	addi	a0,a0,-840 # 7158 <malloc+0x21a6>
    44a8:	257000ef          	jal	4efe <printf>
}
    44ac:	60ea                	ld	ra,152(sp)
    44ae:	644a                	ld	s0,144(sp)
    44b0:	64aa                	ld	s1,136(sp)
    44b2:	690a                	ld	s2,128(sp)
    44b4:	79e6                	ld	s3,120(sp)
    44b6:	7a46                	ld	s4,112(sp)
    44b8:	7aa6                	ld	s5,104(sp)
    44ba:	7b06                	ld	s6,96(sp)
    44bc:	6be6                	ld	s7,88(sp)
    44be:	6c46                	ld	s8,80(sp)
    44c0:	6ca6                	ld	s9,72(sp)
    44c2:	6d06                	ld	s10,64(sp)
    44c4:	610d                	addi	sp,sp,160
    44c6:	8082                	ret
    int total = 0;
    44c8:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    44ca:	00008a97          	auipc	s5,0x8
    44ce:	7aea8a93          	addi	s5,s5,1966 # cc78 <buf>
      if(cc < BSIZE)
    44d2:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    44d6:	40000613          	li	a2,1024
    44da:	85d6                	mv	a1,s5
    44dc:	854a                	mv	a0,s2
    44de:	628000ef          	jal	4b06 <write>
      if(cc < BSIZE)
    44e2:	00aa5563          	bge	s4,a0,44ec <fsfull+0x15a>
      total += cc;
    44e6:	00a989bb          	addw	s3,s3,a0
    while(1){
    44ea:	b7f5                	j	44d6 <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    44ec:	85ce                	mv	a1,s3
    44ee:	00003517          	auipc	a0,0x3
    44f2:	c5a50513          	addi	a0,a0,-934 # 7148 <malloc+0x2196>
    44f6:	209000ef          	jal	4efe <printf>
    close(fd);
    44fa:	854a                	mv	a0,s2
    44fc:	612000ef          	jal	4b0e <close>
    if(total == 0)
    4500:	f2098fe3          	beqz	s3,443e <fsfull+0xac>
  for(nfiles = 0; ; nfiles++){
    4504:	2485                	addiw	s1,s1,1
    4506:	b5f1                	j	43d2 <fsfull+0x40>

0000000000004508 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4508:	7179                	addi	sp,sp,-48
    450a:	f406                	sd	ra,40(sp)
    450c:	f022                	sd	s0,32(sp)
    450e:	ec26                	sd	s1,24(sp)
    4510:	e84a                	sd	s2,16(sp)
    4512:	1800                	addi	s0,sp,48
    4514:	84aa                	mv	s1,a0
    4516:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4518:	00003517          	auipc	a0,0x3
    451c:	c5850513          	addi	a0,a0,-936 # 7170 <malloc+0x21be>
    4520:	1df000ef          	jal	4efe <printf>
  if((pid = fork(1)) < 0) {
    4524:	4505                	li	a0,1
    4526:	5b8000ef          	jal	4ade <fork>
    452a:	02054a63          	bltz	a0,455e <run+0x56>
    printf("runtest: fork85 error\n");
    exit(1);
  }
  if(pid == 0) {
    452e:	c129                	beqz	a0,4570 <run+0x68>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4530:	fdc40513          	addi	a0,s0,-36
    4534:	5ba000ef          	jal	4aee <wait>
    if(xstatus != 0) 
    4538:	fdc42783          	lw	a5,-36(s0)
    453c:	cf9d                	beqz	a5,457a <run+0x72>
      printf("FAILED\n");
    453e:	00003517          	auipc	a0,0x3
    4542:	c5a50513          	addi	a0,a0,-934 # 7198 <malloc+0x21e6>
    4546:	1b9000ef          	jal	4efe <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    454a:	fdc42503          	lw	a0,-36(s0)
  }
}
    454e:	00153513          	seqz	a0,a0
    4552:	70a2                	ld	ra,40(sp)
    4554:	7402                	ld	s0,32(sp)
    4556:	64e2                	ld	s1,24(sp)
    4558:	6942                	ld	s2,16(sp)
    455a:	6145                	addi	sp,sp,48
    455c:	8082                	ret
    printf("runtest: fork85 error\n");
    455e:	00003517          	auipc	a0,0x3
    4562:	c2250513          	addi	a0,a0,-990 # 7180 <malloc+0x21ce>
    4566:	199000ef          	jal	4efe <printf>
    exit(1);
    456a:	4505                	li	a0,1
    456c:	57a000ef          	jal	4ae6 <exit>
    f(s);
    4570:	854a                	mv	a0,s2
    4572:	9482                	jalr	s1
    exit(0);
    4574:	4501                	li	a0,0
    4576:	570000ef          	jal	4ae6 <exit>
      printf("OK\n");
    457a:	00003517          	auipc	a0,0x3
    457e:	c2650513          	addi	a0,a0,-986 # 71a0 <malloc+0x21ee>
    4582:	17d000ef          	jal	4efe <printf>
    4586:	b7d1                	j	454a <run+0x42>

0000000000004588 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4588:	7139                	addi	sp,sp,-64
    458a:	fc06                	sd	ra,56(sp)
    458c:	f822                	sd	s0,48(sp)
    458e:	f04a                	sd	s2,32(sp)
    4590:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    4592:	00853903          	ld	s2,8(a0)
    4596:	06090463          	beqz	s2,45fe <runtests+0x76>
    459a:	f426                	sd	s1,40(sp)
    459c:	ec4e                	sd	s3,24(sp)
    459e:	e852                	sd	s4,16(sp)
    45a0:	e456                	sd	s5,8(sp)
    45a2:	84aa                	mv	s1,a0
    45a4:	89ae                	mv	s3,a1
    45a6:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    45a8:	4a89                	li	s5,2
    45aa:	a031                	j	45b6 <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    45ac:	04c1                	addi	s1,s1,16
    45ae:	0084b903          	ld	s2,8(s1)
    45b2:	02090c63          	beqz	s2,45ea <runtests+0x62>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    45b6:	00098763          	beqz	s3,45c4 <runtests+0x3c>
    45ba:	85ce                	mv	a1,s3
    45bc:	854a                	mv	a0,s2
    45be:	2e4000ef          	jal	48a2 <strcmp>
    45c2:	f56d                	bnez	a0,45ac <runtests+0x24>
      if(!run(t->f, t->s)){
    45c4:	85ca                	mv	a1,s2
    45c6:	6088                	ld	a0,0(s1)
    45c8:	f41ff0ef          	jal	4508 <run>
    45cc:	f165                	bnez	a0,45ac <runtests+0x24>
        if(continuous != 2){
    45ce:	fd5a0fe3          	beq	s4,s5,45ac <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    45d2:	00003517          	auipc	a0,0x3
    45d6:	bd650513          	addi	a0,a0,-1066 # 71a8 <malloc+0x21f6>
    45da:	125000ef          	jal	4efe <printf>
          return 1;
    45de:	4505                	li	a0,1
    45e0:	74a2                	ld	s1,40(sp)
    45e2:	69e2                	ld	s3,24(sp)
    45e4:	6a42                	ld	s4,16(sp)
    45e6:	6aa2                	ld	s5,8(sp)
    45e8:	a031                	j	45f4 <runtests+0x6c>
        }
      }
    }
  }
  return 0;
    45ea:	4501                	li	a0,0
    45ec:	74a2                	ld	s1,40(sp)
    45ee:	69e2                	ld	s3,24(sp)
    45f0:	6a42                	ld	s4,16(sp)
    45f2:	6aa2                	ld	s5,8(sp)
}
    45f4:	70e2                	ld	ra,56(sp)
    45f6:	7442                	ld	s0,48(sp)
    45f8:	7902                	ld	s2,32(sp)
    45fa:	6121                	addi	sp,sp,64
    45fc:	8082                	ret
  return 0;
    45fe:	4501                	li	a0,0
    4600:	bfd5                	j	45f4 <runtests+0x6c>

0000000000004602 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4602:	7139                	addi	sp,sp,-64
    4604:	fc06                	sd	ra,56(sp)
    4606:	f822                	sd	s0,48(sp)
    4608:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    460a:	fc840513          	addi	a0,s0,-56
    460e:	4e8000ef          	jal	4af6 <pipe>
    4612:	04054f63          	bltz	a0,4670 <countfree+0x6e>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork(1);
    4616:	4505                	li	a0,1
    4618:	4c6000ef          	jal	4ade <fork>

  if(pid < 0){
    461c:	06054663          	bltz	a0,4688 <countfree+0x86>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4620:	e159                	bnez	a0,46a6 <countfree+0xa4>
    4622:	f426                	sd	s1,40(sp)
    4624:	f04a                	sd	s2,32(sp)
    4626:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    4628:	fc842503          	lw	a0,-56(s0)
    462c:	4e2000ef          	jal	4b0e <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4630:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4632:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4634:	00001997          	auipc	s3,0x1
    4638:	b2498993          	addi	s3,s3,-1244 # 5158 <malloc+0x1a6>
      uint64 a = (uint64) sbrk(4096);
    463c:	6505                	lui	a0,0x1
    463e:	530000ef          	jal	4b6e <sbrk>
      if(a == 0xffffffffffffffff){
    4642:	05250f63          	beq	a0,s2,46a0 <countfree+0x9e>
      *(char *)(a + 4096 - 1) = 1;
    4646:	6785                	lui	a5,0x1
    4648:	97aa                	add	a5,a5,a0
    464a:	fe978fa3          	sb	s1,-1(a5) # fff <pgbug+0x2b>
      if(write(fds[1], "x", 1) != 1){
    464e:	8626                	mv	a2,s1
    4650:	85ce                	mv	a1,s3
    4652:	fcc42503          	lw	a0,-52(s0)
    4656:	4b0000ef          	jal	4b06 <write>
    465a:	fe9501e3          	beq	a0,s1,463c <countfree+0x3a>
        printf("write() failed in countfree()\n");
    465e:	00003517          	auipc	a0,0x3
    4662:	ba250513          	addi	a0,a0,-1118 # 7200 <malloc+0x224e>
    4666:	099000ef          	jal	4efe <printf>
        exit(1);
    466a:	4505                	li	a0,1
    466c:	47a000ef          	jal	4ae6 <exit>
    4670:	f426                	sd	s1,40(sp)
    4672:	f04a                	sd	s2,32(sp)
    4674:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    4676:	00003517          	auipc	a0,0x3
    467a:	b4a50513          	addi	a0,a0,-1206 # 71c0 <malloc+0x220e>
    467e:	081000ef          	jal	4efe <printf>
    exit(1);
    4682:	4505                	li	a0,1
    4684:	462000ef          	jal	4ae6 <exit>
    4688:	f426                	sd	s1,40(sp)
    468a:	f04a                	sd	s2,32(sp)
    468c:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    468e:	00003517          	auipc	a0,0x3
    4692:	b5250513          	addi	a0,a0,-1198 # 71e0 <malloc+0x222e>
    4696:	069000ef          	jal	4efe <printf>
    exit(1);
    469a:	4505                	li	a0,1
    469c:	44a000ef          	jal	4ae6 <exit>
      }
    }

    exit(0);
    46a0:	4501                	li	a0,0
    46a2:	444000ef          	jal	4ae6 <exit>
    46a6:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    46a8:	fcc42503          	lw	a0,-52(s0)
    46ac:	462000ef          	jal	4b0e <close>

  int n = 0;
    46b0:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    46b2:	4605                	li	a2,1
    46b4:	fc740593          	addi	a1,s0,-57
    46b8:	fc842503          	lw	a0,-56(s0)
    46bc:	442000ef          	jal	4afe <read>
    if(cc < 0){
    46c0:	00054563          	bltz	a0,46ca <countfree+0xc8>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    46c4:	cd11                	beqz	a0,46e0 <countfree+0xde>
      break;
    n += 1;
    46c6:	2485                	addiw	s1,s1,1
  while(1){
    46c8:	b7ed                	j	46b2 <countfree+0xb0>
    46ca:	f04a                	sd	s2,32(sp)
    46cc:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    46ce:	00003517          	auipc	a0,0x3
    46d2:	b5250513          	addi	a0,a0,-1198 # 7220 <malloc+0x226e>
    46d6:	029000ef          	jal	4efe <printf>
      exit(1);
    46da:	4505                	li	a0,1
    46dc:	40a000ef          	jal	4ae6 <exit>
  }

  close(fds[0]);
    46e0:	fc842503          	lw	a0,-56(s0)
    46e4:	42a000ef          	jal	4b0e <close>
  wait((int*)0);
    46e8:	4501                	li	a0,0
    46ea:	404000ef          	jal	4aee <wait>
  
  return n;
}
    46ee:	8526                	mv	a0,s1
    46f0:	74a2                	ld	s1,40(sp)
    46f2:	70e2                	ld	ra,56(sp)
    46f4:	7442                	ld	s0,48(sp)
    46f6:	6121                	addi	sp,sp,64
    46f8:	8082                	ret

00000000000046fa <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    46fa:	711d                	addi	sp,sp,-96
    46fc:	ec86                	sd	ra,88(sp)
    46fe:	e8a2                	sd	s0,80(sp)
    4700:	e4a6                	sd	s1,72(sp)
    4702:	e0ca                	sd	s2,64(sp)
    4704:	fc4e                	sd	s3,56(sp)
    4706:	f852                	sd	s4,48(sp)
    4708:	f456                	sd	s5,40(sp)
    470a:	f05a                	sd	s6,32(sp)
    470c:	ec5e                	sd	s7,24(sp)
    470e:	e862                	sd	s8,16(sp)
    4710:	e466                	sd	s9,8(sp)
    4712:	e06a                	sd	s10,0(sp)
    4714:	1080                	addi	s0,sp,96
    4716:	8aaa                	mv	s5,a0
    4718:	892e                	mv	s2,a1
    471a:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    471c:	00003b97          	auipc	s7,0x3
    4720:	b24b8b93          	addi	s7,s7,-1244 # 7240 <malloc+0x228e>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    4724:	00005b17          	auipc	s6,0x5
    4728:	8ecb0b13          	addi	s6,s6,-1812 # 9010 <quicktests>
      if(continuous != 2) {
    472c:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    472e:	00005c17          	auipc	s8,0x5
    4732:	cb2c0c13          	addi	s8,s8,-846 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    4736:	00003d17          	auipc	s10,0x3
    473a:	b22d0d13          	addi	s10,s10,-1246 # 7258 <malloc+0x22a6>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    473e:	00003c97          	auipc	s9,0x3
    4742:	b3ac8c93          	addi	s9,s9,-1222 # 7278 <malloc+0x22c6>
    4746:	a819                	j	475c <drivetests+0x62>
        printf("usertests slow tests starting\n");
    4748:	856a                	mv	a0,s10
    474a:	7b4000ef          	jal	4efe <printf>
    474e:	a80d                	j	4780 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    4750:	eb3ff0ef          	jal	4602 <countfree>
    4754:	04954063          	blt	a0,s1,4794 <drivetests+0x9a>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    4758:	04090963          	beqz	s2,47aa <drivetests+0xb0>
    printf("usertests starting\n");
    475c:	855e                	mv	a0,s7
    475e:	7a0000ef          	jal	4efe <printf>
    int free0 = countfree();
    4762:	ea1ff0ef          	jal	4602 <countfree>
    4766:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    4768:	864a                	mv	a2,s2
    476a:	85ce                	mv	a1,s3
    476c:	855a                	mv	a0,s6
    476e:	e1bff0ef          	jal	4588 <runtests>
    4772:	c119                	beqz	a0,4778 <drivetests+0x7e>
      if(continuous != 2) {
    4774:	03491963          	bne	s2,s4,47a6 <drivetests+0xac>
    if(!quick) {
    4778:	fc0a9ce3          	bnez	s5,4750 <drivetests+0x56>
      if (justone == 0)
    477c:	fc0986e3          	beqz	s3,4748 <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    4780:	864a                	mv	a2,s2
    4782:	85ce                	mv	a1,s3
    4784:	8562                	mv	a0,s8
    4786:	e03ff0ef          	jal	4588 <runtests>
    478a:	d179                	beqz	a0,4750 <drivetests+0x56>
        if(continuous != 2) {
    478c:	fd4902e3          	beq	s2,s4,4750 <drivetests+0x56>
          return 1;
    4790:	4505                	li	a0,1
    4792:	a829                	j	47ac <drivetests+0xb2>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4794:	8626                	mv	a2,s1
    4796:	85aa                	mv	a1,a0
    4798:	8566                	mv	a0,s9
    479a:	764000ef          	jal	4efe <printf>
      if(continuous != 2) {
    479e:	fb490fe3          	beq	s2,s4,475c <drivetests+0x62>
        return 1;
    47a2:	4505                	li	a0,1
    47a4:	a021                	j	47ac <drivetests+0xb2>
        return 1;
    47a6:	4505                	li	a0,1
    47a8:	a011                	j	47ac <drivetests+0xb2>
  return 0;
    47aa:	854a                	mv	a0,s2
}
    47ac:	60e6                	ld	ra,88(sp)
    47ae:	6446                	ld	s0,80(sp)
    47b0:	64a6                	ld	s1,72(sp)
    47b2:	6906                	ld	s2,64(sp)
    47b4:	79e2                	ld	s3,56(sp)
    47b6:	7a42                	ld	s4,48(sp)
    47b8:	7aa2                	ld	s5,40(sp)
    47ba:	7b02                	ld	s6,32(sp)
    47bc:	6be2                	ld	s7,24(sp)
    47be:	6c42                	ld	s8,16(sp)
    47c0:	6ca2                	ld	s9,8(sp)
    47c2:	6d02                	ld	s10,0(sp)
    47c4:	6125                	addi	sp,sp,96
    47c6:	8082                	ret

00000000000047c8 <main>:

int
main(int argc, char *argv[])
{
    47c8:	1101                	addi	sp,sp,-32
    47ca:	ec06                	sd	ra,24(sp)
    47cc:	e822                	sd	s0,16(sp)
    47ce:	e426                	sd	s1,8(sp)
    47d0:	e04a                	sd	s2,0(sp)
    47d2:	1000                	addi	s0,sp,32
    47d4:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    47d6:	4789                	li	a5,2
    47d8:	00f50f63          	beq	a0,a5,47f6 <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    47dc:	4785                	li	a5,1
    47de:	06a7c063          	blt	a5,a0,483e <main+0x76>
  char *justone = 0;
    47e2:	4901                	li	s2,0
  int quick = 0;
    47e4:	4501                	li	a0,0
  int continuous = 0;
    47e6:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    47e8:	864a                	mv	a2,s2
    47ea:	f11ff0ef          	jal	46fa <drivetests>
    47ee:	c935                	beqz	a0,4862 <main+0x9a>
    exit(1);
    47f0:	4505                	li	a0,1
    47f2:	2f4000ef          	jal	4ae6 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    47f6:	0085b903          	ld	s2,8(a1)
    47fa:	00003597          	auipc	a1,0x3
    47fe:	aae58593          	addi	a1,a1,-1362 # 72a8 <malloc+0x22f6>
    4802:	854a                	mv	a0,s2
    4804:	09e000ef          	jal	48a2 <strcmp>
    4808:	85aa                	mv	a1,a0
    480a:	c139                	beqz	a0,4850 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    480c:	00003597          	auipc	a1,0x3
    4810:	aa458593          	addi	a1,a1,-1372 # 72b0 <malloc+0x22fe>
    4814:	854a                	mv	a0,s2
    4816:	08c000ef          	jal	48a2 <strcmp>
    481a:	cd15                	beqz	a0,4856 <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    481c:	00003597          	auipc	a1,0x3
    4820:	a9c58593          	addi	a1,a1,-1380 # 72b8 <malloc+0x2306>
    4824:	854a                	mv	a0,s2
    4826:	07c000ef          	jal	48a2 <strcmp>
    482a:	c90d                	beqz	a0,485c <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
    482c:	00094703          	lbu	a4,0(s2)
    4830:	02d00793          	li	a5,45
    4834:	00f70563          	beq	a4,a5,483e <main+0x76>
  int quick = 0;
    4838:	4501                	li	a0,0
  int continuous = 0;
    483a:	4581                	li	a1,0
    483c:	b775                	j	47e8 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    483e:	00003517          	auipc	a0,0x3
    4842:	a8250513          	addi	a0,a0,-1406 # 72c0 <malloc+0x230e>
    4846:	6b8000ef          	jal	4efe <printf>
    exit(1);
    484a:	4505                	li	a0,1
    484c:	29a000ef          	jal	4ae6 <exit>
  char *justone = 0;
    4850:	4901                	li	s2,0
    quick = 1;
    4852:	4505                	li	a0,1
    4854:	bf51                	j	47e8 <main+0x20>
  char *justone = 0;
    4856:	4901                	li	s2,0
    continuous = 1;
    4858:	4585                	li	a1,1
    485a:	b779                	j	47e8 <main+0x20>
    continuous = 2;
    485c:	85a6                	mv	a1,s1
  char *justone = 0;
    485e:	4901                	li	s2,0
    4860:	b761                	j	47e8 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4862:	00003517          	auipc	a0,0x3
    4866:	a8e50513          	addi	a0,a0,-1394 # 72f0 <malloc+0x233e>
    486a:	694000ef          	jal	4efe <printf>
  exit(0);
    486e:	4501                	li	a0,0
    4870:	276000ef          	jal	4ae6 <exit>

0000000000004874 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    4874:	1141                	addi	sp,sp,-16
    4876:	e406                	sd	ra,8(sp)
    4878:	e022                	sd	s0,0(sp)
    487a:	0800                	addi	s0,sp,16
  extern int main();
  main();
    487c:	f4dff0ef          	jal	47c8 <main>
  exit(0);
    4880:	4501                	li	a0,0
    4882:	264000ef          	jal	4ae6 <exit>

0000000000004886 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4886:	1141                	addi	sp,sp,-16
    4888:	e422                	sd	s0,8(sp)
    488a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    488c:	87aa                	mv	a5,a0
    488e:	0585                	addi	a1,a1,1
    4890:	0785                	addi	a5,a5,1
    4892:	fff5c703          	lbu	a4,-1(a1)
    4896:	fee78fa3          	sb	a4,-1(a5)
    489a:	fb75                	bnez	a4,488e <strcpy+0x8>
    ;
  return os;
}
    489c:	6422                	ld	s0,8(sp)
    489e:	0141                	addi	sp,sp,16
    48a0:	8082                	ret

00000000000048a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    48a2:	1141                	addi	sp,sp,-16
    48a4:	e422                	sd	s0,8(sp)
    48a6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    48a8:	00054783          	lbu	a5,0(a0)
    48ac:	cb91                	beqz	a5,48c0 <strcmp+0x1e>
    48ae:	0005c703          	lbu	a4,0(a1)
    48b2:	00f71763          	bne	a4,a5,48c0 <strcmp+0x1e>
    p++, q++;
    48b6:	0505                	addi	a0,a0,1
    48b8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    48ba:	00054783          	lbu	a5,0(a0)
    48be:	fbe5                	bnez	a5,48ae <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    48c0:	0005c503          	lbu	a0,0(a1)
}
    48c4:	40a7853b          	subw	a0,a5,a0
    48c8:	6422                	ld	s0,8(sp)
    48ca:	0141                	addi	sp,sp,16
    48cc:	8082                	ret

00000000000048ce <strlen>:

uint
strlen(const char *s)
{
    48ce:	1141                	addi	sp,sp,-16
    48d0:	e422                	sd	s0,8(sp)
    48d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    48d4:	00054783          	lbu	a5,0(a0)
    48d8:	cf91                	beqz	a5,48f4 <strlen+0x26>
    48da:	0505                	addi	a0,a0,1
    48dc:	87aa                	mv	a5,a0
    48de:	86be                	mv	a3,a5
    48e0:	0785                	addi	a5,a5,1
    48e2:	fff7c703          	lbu	a4,-1(a5)
    48e6:	ff65                	bnez	a4,48de <strlen+0x10>
    48e8:	40a6853b          	subw	a0,a3,a0
    48ec:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    48ee:	6422                	ld	s0,8(sp)
    48f0:	0141                	addi	sp,sp,16
    48f2:	8082                	ret
  for(n = 0; s[n]; n++)
    48f4:	4501                	li	a0,0
    48f6:	bfe5                	j	48ee <strlen+0x20>

00000000000048f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    48f8:	1141                	addi	sp,sp,-16
    48fa:	e422                	sd	s0,8(sp)
    48fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    48fe:	ca19                	beqz	a2,4914 <memset+0x1c>
    4900:	87aa                	mv	a5,a0
    4902:	1602                	slli	a2,a2,0x20
    4904:	9201                	srli	a2,a2,0x20
    4906:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    490a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    490e:	0785                	addi	a5,a5,1
    4910:	fee79de3          	bne	a5,a4,490a <memset+0x12>
  }
  return dst;
}
    4914:	6422                	ld	s0,8(sp)
    4916:	0141                	addi	sp,sp,16
    4918:	8082                	ret

000000000000491a <strchr>:

char*
strchr(const char *s, char c)
{
    491a:	1141                	addi	sp,sp,-16
    491c:	e422                	sd	s0,8(sp)
    491e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4920:	00054783          	lbu	a5,0(a0)
    4924:	cb99                	beqz	a5,493a <strchr+0x20>
    if(*s == c)
    4926:	00f58763          	beq	a1,a5,4934 <strchr+0x1a>
  for(; *s; s++)
    492a:	0505                	addi	a0,a0,1
    492c:	00054783          	lbu	a5,0(a0)
    4930:	fbfd                	bnez	a5,4926 <strchr+0xc>
      return (char*)s;
  return 0;
    4932:	4501                	li	a0,0
}
    4934:	6422                	ld	s0,8(sp)
    4936:	0141                	addi	sp,sp,16
    4938:	8082                	ret
  return 0;
    493a:	4501                	li	a0,0
    493c:	bfe5                	j	4934 <strchr+0x1a>

000000000000493e <gets>:

char*
gets(char *buf, int max)
{
    493e:	711d                	addi	sp,sp,-96
    4940:	ec86                	sd	ra,88(sp)
    4942:	e8a2                	sd	s0,80(sp)
    4944:	e4a6                	sd	s1,72(sp)
    4946:	e0ca                	sd	s2,64(sp)
    4948:	fc4e                	sd	s3,56(sp)
    494a:	f852                	sd	s4,48(sp)
    494c:	f456                	sd	s5,40(sp)
    494e:	f05a                	sd	s6,32(sp)
    4950:	ec5e                	sd	s7,24(sp)
    4952:	1080                	addi	s0,sp,96
    4954:	8baa                	mv	s7,a0
    4956:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4958:	892a                	mv	s2,a0
    495a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    495c:	4aa9                	li	s5,10
    495e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4960:	89a6                	mv	s3,s1
    4962:	2485                	addiw	s1,s1,1
    4964:	0344d663          	bge	s1,s4,4990 <gets+0x52>
    cc = read(0, &c, 1);
    4968:	4605                	li	a2,1
    496a:	faf40593          	addi	a1,s0,-81
    496e:	4501                	li	a0,0
    4970:	18e000ef          	jal	4afe <read>
    if(cc < 1)
    4974:	00a05e63          	blez	a0,4990 <gets+0x52>
    buf[i++] = c;
    4978:	faf44783          	lbu	a5,-81(s0)
    497c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4980:	01578763          	beq	a5,s5,498e <gets+0x50>
    4984:	0905                	addi	s2,s2,1
    4986:	fd679de3          	bne	a5,s6,4960 <gets+0x22>
    buf[i++] = c;
    498a:	89a6                	mv	s3,s1
    498c:	a011                	j	4990 <gets+0x52>
    498e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4990:	99de                	add	s3,s3,s7
    4992:	00098023          	sb	zero,0(s3)
  return buf;
}
    4996:	855e                	mv	a0,s7
    4998:	60e6                	ld	ra,88(sp)
    499a:	6446                	ld	s0,80(sp)
    499c:	64a6                	ld	s1,72(sp)
    499e:	6906                	ld	s2,64(sp)
    49a0:	79e2                	ld	s3,56(sp)
    49a2:	7a42                	ld	s4,48(sp)
    49a4:	7aa2                	ld	s5,40(sp)
    49a6:	7b02                	ld	s6,32(sp)
    49a8:	6be2                	ld	s7,24(sp)
    49aa:	6125                	addi	sp,sp,96
    49ac:	8082                	ret

00000000000049ae <stat>:

int
stat(const char *n, struct stat *st)
{
    49ae:	1101                	addi	sp,sp,-32
    49b0:	ec06                	sd	ra,24(sp)
    49b2:	e822                	sd	s0,16(sp)
    49b4:	e04a                	sd	s2,0(sp)
    49b6:	1000                	addi	s0,sp,32
    49b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    49ba:	4581                	li	a1,0
    49bc:	16a000ef          	jal	4b26 <open>
  if(fd < 0)
    49c0:	02054263          	bltz	a0,49e4 <stat+0x36>
    49c4:	e426                	sd	s1,8(sp)
    49c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    49c8:	85ca                	mv	a1,s2
    49ca:	174000ef          	jal	4b3e <fstat>
    49ce:	892a                	mv	s2,a0
  close(fd);
    49d0:	8526                	mv	a0,s1
    49d2:	13c000ef          	jal	4b0e <close>
  return r;
    49d6:	64a2                	ld	s1,8(sp)
}
    49d8:	854a                	mv	a0,s2
    49da:	60e2                	ld	ra,24(sp)
    49dc:	6442                	ld	s0,16(sp)
    49de:	6902                	ld	s2,0(sp)
    49e0:	6105                	addi	sp,sp,32
    49e2:	8082                	ret
    return -1;
    49e4:	597d                	li	s2,-1
    49e6:	bfcd                	j	49d8 <stat+0x2a>

00000000000049e8 <atoi>:

int
atoi(const char *s)
{
    49e8:	1141                	addi	sp,sp,-16
    49ea:	e422                	sd	s0,8(sp)
    49ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    49ee:	00054683          	lbu	a3,0(a0)
    49f2:	fd06879b          	addiw	a5,a3,-48
    49f6:	0ff7f793          	zext.b	a5,a5
    49fa:	4625                	li	a2,9
    49fc:	02f66863          	bltu	a2,a5,4a2c <atoi+0x44>
    4a00:	872a                	mv	a4,a0
  n = 0;
    4a02:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4a04:	0705                	addi	a4,a4,1
    4a06:	0025179b          	slliw	a5,a0,0x2
    4a0a:	9fa9                	addw	a5,a5,a0
    4a0c:	0017979b          	slliw	a5,a5,0x1
    4a10:	9fb5                	addw	a5,a5,a3
    4a12:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4a16:	00074683          	lbu	a3,0(a4)
    4a1a:	fd06879b          	addiw	a5,a3,-48
    4a1e:	0ff7f793          	zext.b	a5,a5
    4a22:	fef671e3          	bgeu	a2,a5,4a04 <atoi+0x1c>
  return n;
}
    4a26:	6422                	ld	s0,8(sp)
    4a28:	0141                	addi	sp,sp,16
    4a2a:	8082                	ret
  n = 0;
    4a2c:	4501                	li	a0,0
    4a2e:	bfe5                	j	4a26 <atoi+0x3e>

0000000000004a30 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4a30:	1141                	addi	sp,sp,-16
    4a32:	e422                	sd	s0,8(sp)
    4a34:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4a36:	02b57463          	bgeu	a0,a1,4a5e <memmove+0x2e>
    while(n-- > 0)
    4a3a:	00c05f63          	blez	a2,4a58 <memmove+0x28>
    4a3e:	1602                	slli	a2,a2,0x20
    4a40:	9201                	srli	a2,a2,0x20
    4a42:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4a46:	872a                	mv	a4,a0
      *dst++ = *src++;
    4a48:	0585                	addi	a1,a1,1
    4a4a:	0705                	addi	a4,a4,1
    4a4c:	fff5c683          	lbu	a3,-1(a1)
    4a50:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4a54:	fef71ae3          	bne	a4,a5,4a48 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4a58:	6422                	ld	s0,8(sp)
    4a5a:	0141                	addi	sp,sp,16
    4a5c:	8082                	ret
    dst += n;
    4a5e:	00c50733          	add	a4,a0,a2
    src += n;
    4a62:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4a64:	fec05ae3          	blez	a2,4a58 <memmove+0x28>
    4a68:	fff6079b          	addiw	a5,a2,-1 # 2fff <subdir+0x3eb>
    4a6c:	1782                	slli	a5,a5,0x20
    4a6e:	9381                	srli	a5,a5,0x20
    4a70:	fff7c793          	not	a5,a5
    4a74:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4a76:	15fd                	addi	a1,a1,-1
    4a78:	177d                	addi	a4,a4,-1
    4a7a:	0005c683          	lbu	a3,0(a1)
    4a7e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4a82:	fee79ae3          	bne	a5,a4,4a76 <memmove+0x46>
    4a86:	bfc9                	j	4a58 <memmove+0x28>

0000000000004a88 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4a88:	1141                	addi	sp,sp,-16
    4a8a:	e422                	sd	s0,8(sp)
    4a8c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4a8e:	ca05                	beqz	a2,4abe <memcmp+0x36>
    4a90:	fff6069b          	addiw	a3,a2,-1
    4a94:	1682                	slli	a3,a3,0x20
    4a96:	9281                	srli	a3,a3,0x20
    4a98:	0685                	addi	a3,a3,1
    4a9a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4a9c:	00054783          	lbu	a5,0(a0)
    4aa0:	0005c703          	lbu	a4,0(a1)
    4aa4:	00e79863          	bne	a5,a4,4ab4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4aa8:	0505                	addi	a0,a0,1
    p2++;
    4aaa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4aac:	fed518e3          	bne	a0,a3,4a9c <memcmp+0x14>
  }
  return 0;
    4ab0:	4501                	li	a0,0
    4ab2:	a019                	j	4ab8 <memcmp+0x30>
      return *p1 - *p2;
    4ab4:	40e7853b          	subw	a0,a5,a4
}
    4ab8:	6422                	ld	s0,8(sp)
    4aba:	0141                	addi	sp,sp,16
    4abc:	8082                	ret
  return 0;
    4abe:	4501                	li	a0,0
    4ac0:	bfe5                	j	4ab8 <memcmp+0x30>

0000000000004ac2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4ac2:	1141                	addi	sp,sp,-16
    4ac4:	e406                	sd	ra,8(sp)
    4ac6:	e022                	sd	s0,0(sp)
    4ac8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4aca:	f67ff0ef          	jal	4a30 <memmove>
}
    4ace:	60a2                	ld	ra,8(sp)
    4ad0:	6402                	ld	s0,0(sp)
    4ad2:	0141                	addi	sp,sp,16
    4ad4:	8082                	ret

0000000000004ad6 <forkprio>:



.global forkprio
forkprio:
  li a7, SYS_forkprio
    4ad6:	48d9                	li	a7,22
  ecall
    4ad8:	00000073          	ecall
  ret
    4adc:	8082                	ret

0000000000004ade <fork>:



.global fork
fork:
 li a7, SYS_fork
    4ade:	4885                	li	a7,1
 ecall
    4ae0:	00000073          	ecall
 ret
    4ae4:	8082                	ret

0000000000004ae6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4ae6:	4889                	li	a7,2
 ecall
    4ae8:	00000073          	ecall
 ret
    4aec:	8082                	ret

0000000000004aee <wait>:
.global wait
wait:
 li a7, SYS_wait
    4aee:	488d                	li	a7,3
 ecall
    4af0:	00000073          	ecall
 ret
    4af4:	8082                	ret

0000000000004af6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4af6:	4891                	li	a7,4
 ecall
    4af8:	00000073          	ecall
 ret
    4afc:	8082                	ret

0000000000004afe <read>:
.global read
read:
 li a7, SYS_read
    4afe:	4895                	li	a7,5
 ecall
    4b00:	00000073          	ecall
 ret
    4b04:	8082                	ret

0000000000004b06 <write>:
.global write
write:
 li a7, SYS_write
    4b06:	48c1                	li	a7,16
 ecall
    4b08:	00000073          	ecall
 ret
    4b0c:	8082                	ret

0000000000004b0e <close>:
.global close
close:
 li a7, SYS_close
    4b0e:	48d5                	li	a7,21
 ecall
    4b10:	00000073          	ecall
 ret
    4b14:	8082                	ret

0000000000004b16 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4b16:	4899                	li	a7,6
 ecall
    4b18:	00000073          	ecall
 ret
    4b1c:	8082                	ret

0000000000004b1e <exec>:
.global exec
exec:
 li a7, SYS_exec
    4b1e:	489d                	li	a7,7
 ecall
    4b20:	00000073          	ecall
 ret
    4b24:	8082                	ret

0000000000004b26 <open>:
.global open
open:
 li a7, SYS_open
    4b26:	48bd                	li	a7,15
 ecall
    4b28:	00000073          	ecall
 ret
    4b2c:	8082                	ret

0000000000004b2e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4b2e:	48c5                	li	a7,17
 ecall
    4b30:	00000073          	ecall
 ret
    4b34:	8082                	ret

0000000000004b36 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4b36:	48c9                	li	a7,18
 ecall
    4b38:	00000073          	ecall
 ret
    4b3c:	8082                	ret

0000000000004b3e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4b3e:	48a1                	li	a7,8
 ecall
    4b40:	00000073          	ecall
 ret
    4b44:	8082                	ret

0000000000004b46 <link>:
.global link
link:
 li a7, SYS_link
    4b46:	48cd                	li	a7,19
 ecall
    4b48:	00000073          	ecall
 ret
    4b4c:	8082                	ret

0000000000004b4e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4b4e:	48d1                	li	a7,20
 ecall
    4b50:	00000073          	ecall
 ret
    4b54:	8082                	ret

0000000000004b56 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4b56:	48a5                	li	a7,9
 ecall
    4b58:	00000073          	ecall
 ret
    4b5c:	8082                	ret

0000000000004b5e <dup>:
.global dup
dup:
 li a7, SYS_dup
    4b5e:	48a9                	li	a7,10
 ecall
    4b60:	00000073          	ecall
 ret
    4b64:	8082                	ret

0000000000004b66 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4b66:	48ad                	li	a7,11
 ecall
    4b68:	00000073          	ecall
 ret
    4b6c:	8082                	ret

0000000000004b6e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4b6e:	48b1                	li	a7,12
 ecall
    4b70:	00000073          	ecall
 ret
    4b74:	8082                	ret

0000000000004b76 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4b76:	48b5                	li	a7,13
 ecall
    4b78:	00000073          	ecall
 ret
    4b7c:	8082                	ret

0000000000004b7e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4b7e:	48b9                	li	a7,14
 ecall
    4b80:	00000073          	ecall
 ret
    4b84:	8082                	ret

0000000000004b86 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4b86:	1101                	addi	sp,sp,-32
    4b88:	ec06                	sd	ra,24(sp)
    4b8a:	e822                	sd	s0,16(sp)
    4b8c:	1000                	addi	s0,sp,32
    4b8e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4b92:	4605                	li	a2,1
    4b94:	fef40593          	addi	a1,s0,-17
    4b98:	f6fff0ef          	jal	4b06 <write>
}
    4b9c:	60e2                	ld	ra,24(sp)
    4b9e:	6442                	ld	s0,16(sp)
    4ba0:	6105                	addi	sp,sp,32
    4ba2:	8082                	ret

0000000000004ba4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4ba4:	7139                	addi	sp,sp,-64
    4ba6:	fc06                	sd	ra,56(sp)
    4ba8:	f822                	sd	s0,48(sp)
    4baa:	f426                	sd	s1,40(sp)
    4bac:	0080                	addi	s0,sp,64
    4bae:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4bb0:	c299                	beqz	a3,4bb6 <printint+0x12>
    4bb2:	0805c963          	bltz	a1,4c44 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4bb6:	2581                	sext.w	a1,a1
  neg = 0;
    4bb8:	4881                	li	a7,0
    4bba:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4bbe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4bc0:	2601                	sext.w	a2,a2
    4bc2:	00003517          	auipc	a0,0x3
    4bc6:	afe50513          	addi	a0,a0,-1282 # 76c0 <digits>
    4bca:	883a                	mv	a6,a4
    4bcc:	2705                	addiw	a4,a4,1
    4bce:	02c5f7bb          	remuw	a5,a1,a2
    4bd2:	1782                	slli	a5,a5,0x20
    4bd4:	9381                	srli	a5,a5,0x20
    4bd6:	97aa                	add	a5,a5,a0
    4bd8:	0007c783          	lbu	a5,0(a5)
    4bdc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4be0:	0005879b          	sext.w	a5,a1
    4be4:	02c5d5bb          	divuw	a1,a1,a2
    4be8:	0685                	addi	a3,a3,1
    4bea:	fec7f0e3          	bgeu	a5,a2,4bca <printint+0x26>
  if(neg)
    4bee:	00088c63          	beqz	a7,4c06 <printint+0x62>
    buf[i++] = '-';
    4bf2:	fd070793          	addi	a5,a4,-48
    4bf6:	00878733          	add	a4,a5,s0
    4bfa:	02d00793          	li	a5,45
    4bfe:	fef70823          	sb	a5,-16(a4)
    4c02:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4c06:	02e05a63          	blez	a4,4c3a <printint+0x96>
    4c0a:	f04a                	sd	s2,32(sp)
    4c0c:	ec4e                	sd	s3,24(sp)
    4c0e:	fc040793          	addi	a5,s0,-64
    4c12:	00e78933          	add	s2,a5,a4
    4c16:	fff78993          	addi	s3,a5,-1
    4c1a:	99ba                	add	s3,s3,a4
    4c1c:	377d                	addiw	a4,a4,-1
    4c1e:	1702                	slli	a4,a4,0x20
    4c20:	9301                	srli	a4,a4,0x20
    4c22:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4c26:	fff94583          	lbu	a1,-1(s2)
    4c2a:	8526                	mv	a0,s1
    4c2c:	f5bff0ef          	jal	4b86 <putc>
  while(--i >= 0)
    4c30:	197d                	addi	s2,s2,-1
    4c32:	ff391ae3          	bne	s2,s3,4c26 <printint+0x82>
    4c36:	7902                	ld	s2,32(sp)
    4c38:	69e2                	ld	s3,24(sp)
}
    4c3a:	70e2                	ld	ra,56(sp)
    4c3c:	7442                	ld	s0,48(sp)
    4c3e:	74a2                	ld	s1,40(sp)
    4c40:	6121                	addi	sp,sp,64
    4c42:	8082                	ret
    x = -xx;
    4c44:	40b005bb          	negw	a1,a1
    neg = 1;
    4c48:	4885                	li	a7,1
    x = -xx;
    4c4a:	bf85                	j	4bba <printint+0x16>

0000000000004c4c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4c4c:	711d                	addi	sp,sp,-96
    4c4e:	ec86                	sd	ra,88(sp)
    4c50:	e8a2                	sd	s0,80(sp)
    4c52:	e0ca                	sd	s2,64(sp)
    4c54:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4c56:	0005c903          	lbu	s2,0(a1)
    4c5a:	26090863          	beqz	s2,4eca <vprintf+0x27e>
    4c5e:	e4a6                	sd	s1,72(sp)
    4c60:	fc4e                	sd	s3,56(sp)
    4c62:	f852                	sd	s4,48(sp)
    4c64:	f456                	sd	s5,40(sp)
    4c66:	f05a                	sd	s6,32(sp)
    4c68:	ec5e                	sd	s7,24(sp)
    4c6a:	e862                	sd	s8,16(sp)
    4c6c:	e466                	sd	s9,8(sp)
    4c6e:	8b2a                	mv	s6,a0
    4c70:	8a2e                	mv	s4,a1
    4c72:	8bb2                	mv	s7,a2
  state = 0;
    4c74:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4c76:	4481                	li	s1,0
    4c78:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4c7a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4c7e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4c82:	06c00c93          	li	s9,108
    4c86:	a005                	j	4ca6 <vprintf+0x5a>
        putc(fd, c0);
    4c88:	85ca                	mv	a1,s2
    4c8a:	855a                	mv	a0,s6
    4c8c:	efbff0ef          	jal	4b86 <putc>
    4c90:	a019                	j	4c96 <vprintf+0x4a>
    } else if(state == '%'){
    4c92:	03598263          	beq	s3,s5,4cb6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    4c96:	2485                	addiw	s1,s1,1
    4c98:	8726                	mv	a4,s1
    4c9a:	009a07b3          	add	a5,s4,s1
    4c9e:	0007c903          	lbu	s2,0(a5)
    4ca2:	20090c63          	beqz	s2,4eba <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    4ca6:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4caa:	fe0994e3          	bnez	s3,4c92 <vprintf+0x46>
      if(c0 == '%'){
    4cae:	fd579de3          	bne	a5,s5,4c88 <vprintf+0x3c>
        state = '%';
    4cb2:	89be                	mv	s3,a5
    4cb4:	b7cd                	j	4c96 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4cb6:	00ea06b3          	add	a3,s4,a4
    4cba:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4cbe:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4cc0:	c681                	beqz	a3,4cc8 <vprintf+0x7c>
    4cc2:	9752                	add	a4,a4,s4
    4cc4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4cc8:	03878f63          	beq	a5,s8,4d06 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    4ccc:	05978963          	beq	a5,s9,4d1e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4cd0:	07500713          	li	a4,117
    4cd4:	0ee78363          	beq	a5,a4,4dba <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4cd8:	07800713          	li	a4,120
    4cdc:	12e78563          	beq	a5,a4,4e06 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4ce0:	07000713          	li	a4,112
    4ce4:	14e78a63          	beq	a5,a4,4e38 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4ce8:	07300713          	li	a4,115
    4cec:	18e78a63          	beq	a5,a4,4e80 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4cf0:	02500713          	li	a4,37
    4cf4:	04e79563          	bne	a5,a4,4d3e <vprintf+0xf2>
        putc(fd, '%');
    4cf8:	02500593          	li	a1,37
    4cfc:	855a                	mv	a0,s6
    4cfe:	e89ff0ef          	jal	4b86 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4d02:	4981                	li	s3,0
    4d04:	bf49                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4d06:	008b8913          	addi	s2,s7,8
    4d0a:	4685                	li	a3,1
    4d0c:	4629                	li	a2,10
    4d0e:	000ba583          	lw	a1,0(s7)
    4d12:	855a                	mv	a0,s6
    4d14:	e91ff0ef          	jal	4ba4 <printint>
    4d18:	8bca                	mv	s7,s2
      state = 0;
    4d1a:	4981                	li	s3,0
    4d1c:	bfad                	j	4c96 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    4d1e:	06400793          	li	a5,100
    4d22:	02f68963          	beq	a3,a5,4d54 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4d26:	06c00793          	li	a5,108
    4d2a:	04f68263          	beq	a3,a5,4d6e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    4d2e:	07500793          	li	a5,117
    4d32:	0af68063          	beq	a3,a5,4dd2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    4d36:	07800793          	li	a5,120
    4d3a:	0ef68263          	beq	a3,a5,4e1e <vprintf+0x1d2>
        putc(fd, '%');
    4d3e:	02500593          	li	a1,37
    4d42:	855a                	mv	a0,s6
    4d44:	e43ff0ef          	jal	4b86 <putc>
        putc(fd, c0);
    4d48:	85ca                	mv	a1,s2
    4d4a:	855a                	mv	a0,s6
    4d4c:	e3bff0ef          	jal	4b86 <putc>
      state = 0;
    4d50:	4981                	li	s3,0
    4d52:	b791                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d54:	008b8913          	addi	s2,s7,8
    4d58:	4685                	li	a3,1
    4d5a:	4629                	li	a2,10
    4d5c:	000ba583          	lw	a1,0(s7)
    4d60:	855a                	mv	a0,s6
    4d62:	e43ff0ef          	jal	4ba4 <printint>
        i += 1;
    4d66:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d68:	8bca                	mv	s7,s2
      state = 0;
    4d6a:	4981                	li	s3,0
        i += 1;
    4d6c:	b72d                	j	4c96 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4d6e:	06400793          	li	a5,100
    4d72:	02f60763          	beq	a2,a5,4da0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4d76:	07500793          	li	a5,117
    4d7a:	06f60963          	beq	a2,a5,4dec <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4d7e:	07800793          	li	a5,120
    4d82:	faf61ee3          	bne	a2,a5,4d3e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d86:	008b8913          	addi	s2,s7,8
    4d8a:	4681                	li	a3,0
    4d8c:	4641                	li	a2,16
    4d8e:	000ba583          	lw	a1,0(s7)
    4d92:	855a                	mv	a0,s6
    4d94:	e11ff0ef          	jal	4ba4 <printint>
        i += 2;
    4d98:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d9a:	8bca                	mv	s7,s2
      state = 0;
    4d9c:	4981                	li	s3,0
        i += 2;
    4d9e:	bde5                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4da0:	008b8913          	addi	s2,s7,8
    4da4:	4685                	li	a3,1
    4da6:	4629                	li	a2,10
    4da8:	000ba583          	lw	a1,0(s7)
    4dac:	855a                	mv	a0,s6
    4dae:	df7ff0ef          	jal	4ba4 <printint>
        i += 2;
    4db2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4db4:	8bca                	mv	s7,s2
      state = 0;
    4db6:	4981                	li	s3,0
        i += 2;
    4db8:	bdf9                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    4dba:	008b8913          	addi	s2,s7,8
    4dbe:	4681                	li	a3,0
    4dc0:	4629                	li	a2,10
    4dc2:	000ba583          	lw	a1,0(s7)
    4dc6:	855a                	mv	a0,s6
    4dc8:	dddff0ef          	jal	4ba4 <printint>
    4dcc:	8bca                	mv	s7,s2
      state = 0;
    4dce:	4981                	li	s3,0
    4dd0:	b5d9                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4dd2:	008b8913          	addi	s2,s7,8
    4dd6:	4681                	li	a3,0
    4dd8:	4629                	li	a2,10
    4dda:	000ba583          	lw	a1,0(s7)
    4dde:	855a                	mv	a0,s6
    4de0:	dc5ff0ef          	jal	4ba4 <printint>
        i += 1;
    4de4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4de6:	8bca                	mv	s7,s2
      state = 0;
    4de8:	4981                	li	s3,0
        i += 1;
    4dea:	b575                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4dec:	008b8913          	addi	s2,s7,8
    4df0:	4681                	li	a3,0
    4df2:	4629                	li	a2,10
    4df4:	000ba583          	lw	a1,0(s7)
    4df8:	855a                	mv	a0,s6
    4dfa:	dabff0ef          	jal	4ba4 <printint>
        i += 2;
    4dfe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4e00:	8bca                	mv	s7,s2
      state = 0;
    4e02:	4981                	li	s3,0
        i += 2;
    4e04:	bd49                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    4e06:	008b8913          	addi	s2,s7,8
    4e0a:	4681                	li	a3,0
    4e0c:	4641                	li	a2,16
    4e0e:	000ba583          	lw	a1,0(s7)
    4e12:	855a                	mv	a0,s6
    4e14:	d91ff0ef          	jal	4ba4 <printint>
    4e18:	8bca                	mv	s7,s2
      state = 0;
    4e1a:	4981                	li	s3,0
    4e1c:	bdad                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4e1e:	008b8913          	addi	s2,s7,8
    4e22:	4681                	li	a3,0
    4e24:	4641                	li	a2,16
    4e26:	000ba583          	lw	a1,0(s7)
    4e2a:	855a                	mv	a0,s6
    4e2c:	d79ff0ef          	jal	4ba4 <printint>
        i += 1;
    4e30:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4e32:	8bca                	mv	s7,s2
      state = 0;
    4e34:	4981                	li	s3,0
        i += 1;
    4e36:	b585                	j	4c96 <vprintf+0x4a>
    4e38:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    4e3a:	008b8d13          	addi	s10,s7,8
    4e3e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4e42:	03000593          	li	a1,48
    4e46:	855a                	mv	a0,s6
    4e48:	d3fff0ef          	jal	4b86 <putc>
  putc(fd, 'x');
    4e4c:	07800593          	li	a1,120
    4e50:	855a                	mv	a0,s6
    4e52:	d35ff0ef          	jal	4b86 <putc>
    4e56:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4e58:	00003b97          	auipc	s7,0x3
    4e5c:	868b8b93          	addi	s7,s7,-1944 # 76c0 <digits>
    4e60:	03c9d793          	srli	a5,s3,0x3c
    4e64:	97de                	add	a5,a5,s7
    4e66:	0007c583          	lbu	a1,0(a5)
    4e6a:	855a                	mv	a0,s6
    4e6c:	d1bff0ef          	jal	4b86 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4e70:	0992                	slli	s3,s3,0x4
    4e72:	397d                	addiw	s2,s2,-1
    4e74:	fe0916e3          	bnez	s2,4e60 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    4e78:	8bea                	mv	s7,s10
      state = 0;
    4e7a:	4981                	li	s3,0
    4e7c:	6d02                	ld	s10,0(sp)
    4e7e:	bd21                	j	4c96 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    4e80:	008b8993          	addi	s3,s7,8
    4e84:	000bb903          	ld	s2,0(s7)
    4e88:	00090f63          	beqz	s2,4ea6 <vprintf+0x25a>
        for(; *s; s++)
    4e8c:	00094583          	lbu	a1,0(s2)
    4e90:	c195                	beqz	a1,4eb4 <vprintf+0x268>
          putc(fd, *s);
    4e92:	855a                	mv	a0,s6
    4e94:	cf3ff0ef          	jal	4b86 <putc>
        for(; *s; s++)
    4e98:	0905                	addi	s2,s2,1
    4e9a:	00094583          	lbu	a1,0(s2)
    4e9e:	f9f5                	bnez	a1,4e92 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4ea0:	8bce                	mv	s7,s3
      state = 0;
    4ea2:	4981                	li	s3,0
    4ea4:	bbcd                	j	4c96 <vprintf+0x4a>
          s = "(null)";
    4ea6:	00002917          	auipc	s2,0x2
    4eaa:	79a90913          	addi	s2,s2,1946 # 7640 <malloc+0x268e>
        for(; *s; s++)
    4eae:	02800593          	li	a1,40
    4eb2:	b7c5                	j	4e92 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4eb4:	8bce                	mv	s7,s3
      state = 0;
    4eb6:	4981                	li	s3,0
    4eb8:	bbf9                	j	4c96 <vprintf+0x4a>
    4eba:	64a6                	ld	s1,72(sp)
    4ebc:	79e2                	ld	s3,56(sp)
    4ebe:	7a42                	ld	s4,48(sp)
    4ec0:	7aa2                	ld	s5,40(sp)
    4ec2:	7b02                	ld	s6,32(sp)
    4ec4:	6be2                	ld	s7,24(sp)
    4ec6:	6c42                	ld	s8,16(sp)
    4ec8:	6ca2                	ld	s9,8(sp)
    }
  }
}
    4eca:	60e6                	ld	ra,88(sp)
    4ecc:	6446                	ld	s0,80(sp)
    4ece:	6906                	ld	s2,64(sp)
    4ed0:	6125                	addi	sp,sp,96
    4ed2:	8082                	ret

0000000000004ed4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    4ed4:	715d                	addi	sp,sp,-80
    4ed6:	ec06                	sd	ra,24(sp)
    4ed8:	e822                	sd	s0,16(sp)
    4eda:	1000                	addi	s0,sp,32
    4edc:	e010                	sd	a2,0(s0)
    4ede:	e414                	sd	a3,8(s0)
    4ee0:	e818                	sd	a4,16(s0)
    4ee2:	ec1c                	sd	a5,24(s0)
    4ee4:	03043023          	sd	a6,32(s0)
    4ee8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    4eec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4ef0:	8622                	mv	a2,s0
    4ef2:	d5bff0ef          	jal	4c4c <vprintf>
}
    4ef6:	60e2                	ld	ra,24(sp)
    4ef8:	6442                	ld	s0,16(sp)
    4efa:	6161                	addi	sp,sp,80
    4efc:	8082                	ret

0000000000004efe <printf>:

void
printf(const char *fmt, ...)
{
    4efe:	711d                	addi	sp,sp,-96
    4f00:	ec06                	sd	ra,24(sp)
    4f02:	e822                	sd	s0,16(sp)
    4f04:	1000                	addi	s0,sp,32
    4f06:	e40c                	sd	a1,8(s0)
    4f08:	e810                	sd	a2,16(s0)
    4f0a:	ec14                	sd	a3,24(s0)
    4f0c:	f018                	sd	a4,32(s0)
    4f0e:	f41c                	sd	a5,40(s0)
    4f10:	03043823          	sd	a6,48(s0)
    4f14:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4f18:	00840613          	addi	a2,s0,8
    4f1c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4f20:	85aa                	mv	a1,a0
    4f22:	4505                	li	a0,1
    4f24:	d29ff0ef          	jal	4c4c <vprintf>
}
    4f28:	60e2                	ld	ra,24(sp)
    4f2a:	6442                	ld	s0,16(sp)
    4f2c:	6125                	addi	sp,sp,96
    4f2e:	8082                	ret

0000000000004f30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4f30:	1141                	addi	sp,sp,-16
    4f32:	e422                	sd	s0,8(sp)
    4f34:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4f36:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4f3a:	00004797          	auipc	a5,0x4
    4f3e:	5167b783          	ld	a5,1302(a5) # 9450 <freep>
    4f42:	a02d                	j	4f6c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4f44:	4618                	lw	a4,8(a2)
    4f46:	9f2d                	addw	a4,a4,a1
    4f48:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4f4c:	6398                	ld	a4,0(a5)
    4f4e:	6310                	ld	a2,0(a4)
    4f50:	a83d                	j	4f8e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4f52:	ff852703          	lw	a4,-8(a0)
    4f56:	9f31                	addw	a4,a4,a2
    4f58:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    4f5a:	ff053683          	ld	a3,-16(a0)
    4f5e:	a091                	j	4fa2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4f60:	6398                	ld	a4,0(a5)
    4f62:	00e7e463          	bltu	a5,a4,4f6a <free+0x3a>
    4f66:	00e6ea63          	bltu	a3,a4,4f7a <free+0x4a>
{
    4f6a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4f6c:	fed7fae3          	bgeu	a5,a3,4f60 <free+0x30>
    4f70:	6398                	ld	a4,0(a5)
    4f72:	00e6e463          	bltu	a3,a4,4f7a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4f76:	fee7eae3          	bltu	a5,a4,4f6a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    4f7a:	ff852583          	lw	a1,-8(a0)
    4f7e:	6390                	ld	a2,0(a5)
    4f80:	02059813          	slli	a6,a1,0x20
    4f84:	01c85713          	srli	a4,a6,0x1c
    4f88:	9736                	add	a4,a4,a3
    4f8a:	fae60de3          	beq	a2,a4,4f44 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    4f8e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4f92:	4790                	lw	a2,8(a5)
    4f94:	02061593          	slli	a1,a2,0x20
    4f98:	01c5d713          	srli	a4,a1,0x1c
    4f9c:	973e                	add	a4,a4,a5
    4f9e:	fae68ae3          	beq	a3,a4,4f52 <free+0x22>
    p->s.ptr = bp->s.ptr;
    4fa2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    4fa4:	00004717          	auipc	a4,0x4
    4fa8:	4af73623          	sd	a5,1196(a4) # 9450 <freep>
}
    4fac:	6422                	ld	s0,8(sp)
    4fae:	0141                	addi	sp,sp,16
    4fb0:	8082                	ret

0000000000004fb2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4fb2:	7139                	addi	sp,sp,-64
    4fb4:	fc06                	sd	ra,56(sp)
    4fb6:	f822                	sd	s0,48(sp)
    4fb8:	f426                	sd	s1,40(sp)
    4fba:	ec4e                	sd	s3,24(sp)
    4fbc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4fbe:	02051493          	slli	s1,a0,0x20
    4fc2:	9081                	srli	s1,s1,0x20
    4fc4:	04bd                	addi	s1,s1,15
    4fc6:	8091                	srli	s1,s1,0x4
    4fc8:	0014899b          	addiw	s3,s1,1
    4fcc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    4fce:	00004517          	auipc	a0,0x4
    4fd2:	48253503          	ld	a0,1154(a0) # 9450 <freep>
    4fd6:	c915                	beqz	a0,500a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4fd8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4fda:	4798                	lw	a4,8(a5)
    4fdc:	08977a63          	bgeu	a4,s1,5070 <malloc+0xbe>
    4fe0:	f04a                	sd	s2,32(sp)
    4fe2:	e852                	sd	s4,16(sp)
    4fe4:	e456                	sd	s5,8(sp)
    4fe6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    4fe8:	8a4e                	mv	s4,s3
    4fea:	0009871b          	sext.w	a4,s3
    4fee:	6685                	lui	a3,0x1
    4ff0:	00d77363          	bgeu	a4,a3,4ff6 <malloc+0x44>
    4ff4:	6a05                	lui	s4,0x1
    4ff6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    4ffa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4ffe:	00004917          	auipc	s2,0x4
    5002:	45290913          	addi	s2,s2,1106 # 9450 <freep>
  if(p == (char*)-1)
    5006:	5afd                	li	s5,-1
    5008:	a081                	j	5048 <malloc+0x96>
    500a:	f04a                	sd	s2,32(sp)
    500c:	e852                	sd	s4,16(sp)
    500e:	e456                	sd	s5,8(sp)
    5010:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5012:	0000b797          	auipc	a5,0xb
    5016:	c6678793          	addi	a5,a5,-922 # fc78 <base>
    501a:	00004717          	auipc	a4,0x4
    501e:	42f73b23          	sd	a5,1078(a4) # 9450 <freep>
    5022:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5024:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5028:	b7c1                	j	4fe8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    502a:	6398                	ld	a4,0(a5)
    502c:	e118                	sd	a4,0(a0)
    502e:	a8a9                	j	5088 <malloc+0xd6>
  hp->s.size = nu;
    5030:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5034:	0541                	addi	a0,a0,16
    5036:	efbff0ef          	jal	4f30 <free>
  return freep;
    503a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    503e:	c12d                	beqz	a0,50a0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5040:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5042:	4798                	lw	a4,8(a5)
    5044:	02977263          	bgeu	a4,s1,5068 <malloc+0xb6>
    if(p == freep)
    5048:	00093703          	ld	a4,0(s2)
    504c:	853e                	mv	a0,a5
    504e:	fef719e3          	bne	a4,a5,5040 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    5052:	8552                	mv	a0,s4
    5054:	b1bff0ef          	jal	4b6e <sbrk>
  if(p == (char*)-1)
    5058:	fd551ce3          	bne	a0,s5,5030 <malloc+0x7e>
        return 0;
    505c:	4501                	li	a0,0
    505e:	7902                	ld	s2,32(sp)
    5060:	6a42                	ld	s4,16(sp)
    5062:	6aa2                	ld	s5,8(sp)
    5064:	6b02                	ld	s6,0(sp)
    5066:	a03d                	j	5094 <malloc+0xe2>
    5068:	7902                	ld	s2,32(sp)
    506a:	6a42                	ld	s4,16(sp)
    506c:	6aa2                	ld	s5,8(sp)
    506e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5070:	fae48de3          	beq	s1,a4,502a <malloc+0x78>
        p->s.size -= nunits;
    5074:	4137073b          	subw	a4,a4,s3
    5078:	c798                	sw	a4,8(a5)
        p += p->s.size;
    507a:	02071693          	slli	a3,a4,0x20
    507e:	01c6d713          	srli	a4,a3,0x1c
    5082:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5084:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5088:	00004717          	auipc	a4,0x4
    508c:	3ca73423          	sd	a0,968(a4) # 9450 <freep>
      return (void*)(p + 1);
    5090:	01078513          	addi	a0,a5,16
  }
}
    5094:	70e2                	ld	ra,56(sp)
    5096:	7442                	ld	s0,48(sp)
    5098:	74a2                	ld	s1,40(sp)
    509a:	69e2                	ld	s3,24(sp)
    509c:	6121                	addi	sp,sp,64
    509e:	8082                	ret
    50a0:	7902                	ld	s2,32(sp)
    50a2:	6a42                	ld	s4,16(sp)
    50a4:	6aa2                	ld	s5,8(sp)
    50a6:	6b02                	ld	s6,0(sp)
    50a8:	b7f5                	j	5094 <malloc+0xe2>
