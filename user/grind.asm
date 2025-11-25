
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	f99ff0ef          	jal	0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	addi	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7119                	addi	sp,sp,-128
      76:	fc86                	sd	ra,120(sp)
      78:	f8a2                	sd	s0,112(sp)
      7a:	f4a6                	sd	s1,104(sp)
      7c:	e4d6                	sd	s5,72(sp)
      7e:	0100                	addi	s0,sp,128
      80:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      82:	4501                	li	a0,0
      84:	379000ef          	jal	bfc <sbrk>
      88:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      8a:	00001517          	auipc	a0,0x1
      8e:	0b650513          	addi	a0,a0,182 # 1140 <malloc+0x100>
      92:	34b000ef          	jal	bdc <mkdir>
  if(chdir("grindir") != 0){
      96:	00001517          	auipc	a0,0x1
      9a:	0aa50513          	addi	a0,a0,170 # 1140 <malloc+0x100>
      9e:	347000ef          	jal	be4 <chdir>
      a2:	cd19                	beqz	a0,c0 <go+0x4c>
      a4:	f0ca                	sd	s2,96(sp)
      a6:	ecce                	sd	s3,88(sp)
      a8:	e8d2                	sd	s4,80(sp)
      aa:	e0da                	sd	s6,64(sp)
      ac:	fc5e                	sd	s7,56(sp)
    printf("grind: chdir grindir failed\n");
      ae:	00001517          	auipc	a0,0x1
      b2:	09a50513          	addi	a0,a0,154 # 1148 <malloc+0x108>
      b6:	6d7000ef          	jal	f8c <printf>
    exit(1);
      ba:	4505                	li	a0,1
      bc:	2b9000ef          	jal	b74 <exit>
      c0:	f0ca                	sd	s2,96(sp)
      c2:	ecce                	sd	s3,88(sp)
      c4:	e8d2                	sd	s4,80(sp)
      c6:	e0da                	sd	s6,64(sp)
      c8:	fc5e                	sd	s7,56(sp)
  }
  chdir("/");
      ca:	00001517          	auipc	a0,0x1
      ce:	0a650513          	addi	a0,a0,166 # 1170 <malloc+0x130>
      d2:	313000ef          	jal	be4 <chdir>
      d6:	00001997          	auipc	s3,0x1
      da:	0aa98993          	addi	s3,s3,170 # 1180 <malloc+0x140>
      de:	c489                	beqz	s1,e8 <go+0x74>
      e0:	00001997          	auipc	s3,0x1
      e4:	09898993          	addi	s3,s3,152 # 1178 <malloc+0x138>
  uint64 iters = 0;
      e8:	4481                	li	s1,0
  int fd = -1;
      ea:	5a7d                	li	s4,-1
      ec:	00001917          	auipc	s2,0x1
      f0:	36490913          	addi	s2,s2,868 # 1450 <malloc+0x410>
      f4:	a819                	j	10a <go+0x96>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
      f6:	20200593          	li	a1,514
      fa:	00001517          	auipc	a0,0x1
      fe:	08e50513          	addi	a0,a0,142 # 1188 <malloc+0x148>
     102:	2b3000ef          	jal	bb4 <open>
     106:	297000ef          	jal	b9c <close>
    iters++;
     10a:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     10c:	1f400793          	li	a5,500
     110:	02f4f7b3          	remu	a5,s1,a5
     114:	e791                	bnez	a5,120 <go+0xac>
      write(1, which_child?"B":"A", 1);
     116:	4605                	li	a2,1
     118:	85ce                	mv	a1,s3
     11a:	4505                	li	a0,1
     11c:	279000ef          	jal	b94 <write>
    int what = rand() % 23;
     120:	f39ff0ef          	jal	58 <rand>
     124:	47dd                	li	a5,23
     126:	02f5653b          	remw	a0,a0,a5
     12a:	0005071b          	sext.w	a4,a0
     12e:	47d9                	li	a5,22
     130:	fce7ede3          	bltu	a5,a4,10a <go+0x96>
     134:	02051793          	slli	a5,a0,0x20
     138:	01e7d513          	srli	a0,a5,0x1e
     13c:	954a                	add	a0,a0,s2
     13e:	411c                	lw	a5,0(a0)
     140:	97ca                	add	a5,a5,s2
     142:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     144:	20200593          	li	a1,514
     148:	00001517          	auipc	a0,0x1
     14c:	05050513          	addi	a0,a0,80 # 1198 <malloc+0x158>
     150:	265000ef          	jal	bb4 <open>
     154:	249000ef          	jal	b9c <close>
     158:	bf4d                	j	10a <go+0x96>
    } else if(what == 3){
      unlink("grindir/../a");
     15a:	00001517          	auipc	a0,0x1
     15e:	02e50513          	addi	a0,a0,46 # 1188 <malloc+0x148>
     162:	263000ef          	jal	bc4 <unlink>
     166:	b755                	j	10a <go+0x96>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     168:	00001517          	auipc	a0,0x1
     16c:	fd850513          	addi	a0,a0,-40 # 1140 <malloc+0x100>
     170:	275000ef          	jal	be4 <chdir>
     174:	ed11                	bnez	a0,190 <go+0x11c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     176:	00001517          	auipc	a0,0x1
     17a:	03a50513          	addi	a0,a0,58 # 11b0 <malloc+0x170>
     17e:	247000ef          	jal	bc4 <unlink>
      chdir("/");
     182:	00001517          	auipc	a0,0x1
     186:	fee50513          	addi	a0,a0,-18 # 1170 <malloc+0x130>
     18a:	25b000ef          	jal	be4 <chdir>
     18e:	bfb5                	j	10a <go+0x96>
        printf("grind: chdir grindir failed\n");
     190:	00001517          	auipc	a0,0x1
     194:	fb850513          	addi	a0,a0,-72 # 1148 <malloc+0x108>
     198:	5f5000ef          	jal	f8c <printf>
        exit(1);
     19c:	4505                	li	a0,1
     19e:	1d7000ef          	jal	b74 <exit>
    } else if(what == 5){
      close(fd);
     1a2:	8552                	mv	a0,s4
     1a4:	1f9000ef          	jal	b9c <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1a8:	20200593          	li	a1,514
     1ac:	00001517          	auipc	a0,0x1
     1b0:	00c50513          	addi	a0,a0,12 # 11b8 <malloc+0x178>
     1b4:	201000ef          	jal	bb4 <open>
     1b8:	8a2a                	mv	s4,a0
     1ba:	bf81                	j	10a <go+0x96>
    } else if(what == 6){
      close(fd);
     1bc:	8552                	mv	a0,s4
     1be:	1df000ef          	jal	b9c <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     1c2:	20200593          	li	a1,514
     1c6:	00001517          	auipc	a0,0x1
     1ca:	00250513          	addi	a0,a0,2 # 11c8 <malloc+0x188>
     1ce:	1e7000ef          	jal	bb4 <open>
     1d2:	8a2a                	mv	s4,a0
     1d4:	bf1d                	j	10a <go+0x96>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     1d6:	3e700613          	li	a2,999
     1da:	00002597          	auipc	a1,0x2
     1de:	e4658593          	addi	a1,a1,-442 # 2020 <buf.0>
     1e2:	8552                	mv	a0,s4
     1e4:	1b1000ef          	jal	b94 <write>
     1e8:	b70d                	j	10a <go+0x96>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     1ea:	3e700613          	li	a2,999
     1ee:	00002597          	auipc	a1,0x2
     1f2:	e3258593          	addi	a1,a1,-462 # 2020 <buf.0>
     1f6:	8552                	mv	a0,s4
     1f8:	195000ef          	jal	b8c <read>
     1fc:	b739                	j	10a <go+0x96>
    } else if(what == 9){
      mkdir("grindir/../a");
     1fe:	00001517          	auipc	a0,0x1
     202:	f8a50513          	addi	a0,a0,-118 # 1188 <malloc+0x148>
     206:	1d7000ef          	jal	bdc <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	fd250513          	addi	a0,a0,-46 # 11e0 <malloc+0x1a0>
     216:	19f000ef          	jal	bb4 <open>
     21a:	183000ef          	jal	b9c <close>
      unlink("a/a");
     21e:	00001517          	auipc	a0,0x1
     222:	fd250513          	addi	a0,a0,-46 # 11f0 <malloc+0x1b0>
     226:	19f000ef          	jal	bc4 <unlink>
     22a:	b5c5                	j	10a <go+0x96>
    } else if(what == 10){
      mkdir("/../b");
     22c:	00001517          	auipc	a0,0x1
     230:	fcc50513          	addi	a0,a0,-52 # 11f8 <malloc+0x1b8>
     234:	1a9000ef          	jal	bdc <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     238:	20200593          	li	a1,514
     23c:	00001517          	auipc	a0,0x1
     240:	fc450513          	addi	a0,a0,-60 # 1200 <malloc+0x1c0>
     244:	171000ef          	jal	bb4 <open>
     248:	155000ef          	jal	b9c <close>
      unlink("b/b");
     24c:	00001517          	auipc	a0,0x1
     250:	fc450513          	addi	a0,a0,-60 # 1210 <malloc+0x1d0>
     254:	171000ef          	jal	bc4 <unlink>
     258:	bd4d                	j	10a <go+0x96>
    } else if(what == 11){
      unlink("b");
     25a:	00001517          	auipc	a0,0x1
     25e:	fbe50513          	addi	a0,a0,-66 # 1218 <malloc+0x1d8>
     262:	163000ef          	jal	bc4 <unlink>
      link("../grindir/./../a", "../b");
     266:	00001597          	auipc	a1,0x1
     26a:	f4a58593          	addi	a1,a1,-182 # 11b0 <malloc+0x170>
     26e:	00001517          	auipc	a0,0x1
     272:	fb250513          	addi	a0,a0,-78 # 1220 <malloc+0x1e0>
     276:	15f000ef          	jal	bd4 <link>
     27a:	bd41                	j	10a <go+0x96>
    } else if(what == 12){
      unlink("../grindir/../a");
     27c:	00001517          	auipc	a0,0x1
     280:	fbc50513          	addi	a0,a0,-68 # 1238 <malloc+0x1f8>
     284:	141000ef          	jal	bc4 <unlink>
      link(".././b", "/grindir/../a");
     288:	00001597          	auipc	a1,0x1
     28c:	f3058593          	addi	a1,a1,-208 # 11b8 <malloc+0x178>
     290:	00001517          	auipc	a0,0x1
     294:	fb850513          	addi	a0,a0,-72 # 1248 <malloc+0x208>
     298:	13d000ef          	jal	bd4 <link>
     29c:	b5bd                	j	10a <go+0x96>
    } else if(what == 13){
      int pid = fork(1);
     29e:	4505                	li	a0,1
     2a0:	0cd000ef          	jal	b6c <fork>
      if(pid == 0){
     2a4:	c519                	beqz	a0,2b2 <go+0x23e>
        exit(0);
      } else if(pid < 0){
     2a6:	00054863          	bltz	a0,2b6 <go+0x242>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2aa:	4501                	li	a0,0
     2ac:	0d1000ef          	jal	b7c <wait>
     2b0:	bda9                	j	10a <go+0x96>
        exit(0);
     2b2:	0c3000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     2b6:	00001517          	auipc	a0,0x1
     2ba:	f9a50513          	addi	a0,a0,-102 # 1250 <malloc+0x210>
     2be:	4cf000ef          	jal	f8c <printf>
        exit(1);
     2c2:	4505                	li	a0,1
     2c4:	0b1000ef          	jal	b74 <exit>
    } else if(what == 14){
      int pid = fork(1);
     2c8:	4505                	li	a0,1
     2ca:	0a3000ef          	jal	b6c <fork>
      if(pid == 0){
     2ce:	c519                	beqz	a0,2dc <go+0x268>
        fork(1);
        fork(1);
        exit(0);
      } else if(pid < 0){
     2d0:	00054f63          	bltz	a0,2ee <go+0x27a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2d4:	4501                	li	a0,0
     2d6:	0a7000ef          	jal	b7c <wait>
     2da:	bd05                	j	10a <go+0x96>
        fork(1);
     2dc:	4505                	li	a0,1
     2de:	08f000ef          	jal	b6c <fork>
        fork(1);
     2e2:	4505                	li	a0,1
     2e4:	089000ef          	jal	b6c <fork>
        exit(0);
     2e8:	4501                	li	a0,0
     2ea:	08b000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     2ee:	00001517          	auipc	a0,0x1
     2f2:	f6250513          	addi	a0,a0,-158 # 1250 <malloc+0x210>
     2f6:	497000ef          	jal	f8c <printf>
        exit(1);
     2fa:	4505                	li	a0,1
     2fc:	079000ef          	jal	b74 <exit>
    } else if(what == 15){
      sbrk(6011);
     300:	6505                	lui	a0,0x1
     302:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x2cb>
     306:	0f7000ef          	jal	bfc <sbrk>
     30a:	b501                	j	10a <go+0x96>
    } else if(what == 16){
      if(sbrk(0) > break0)
     30c:	4501                	li	a0,0
     30e:	0ef000ef          	jal	bfc <sbrk>
     312:	deaafce3          	bgeu	s5,a0,10a <go+0x96>
        sbrk(-(sbrk(0) - break0));
     316:	4501                	li	a0,0
     318:	0e5000ef          	jal	bfc <sbrk>
     31c:	40aa853b          	subw	a0,s5,a0
     320:	0dd000ef          	jal	bfc <sbrk>
     324:	b3dd                	j	10a <go+0x96>
    } else if(what == 17){
      int pid = fork(1);
     326:	4505                	li	a0,1
     328:	045000ef          	jal	b6c <fork>
     32c:	8b2a                	mv	s6,a0
      if(pid == 0){
     32e:	c10d                	beqz	a0,350 <go+0x2dc>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     330:	02054d63          	bltz	a0,36a <go+0x2f6>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     334:	00001517          	auipc	a0,0x1
     338:	f3c50513          	addi	a0,a0,-196 # 1270 <malloc+0x230>
     33c:	0a9000ef          	jal	be4 <chdir>
     340:	ed15                	bnez	a0,37c <go+0x308>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     342:	855a                	mv	a0,s6
     344:	061000ef          	jal	ba4 <kill>
      wait(0);
     348:	4501                	li	a0,0
     34a:	033000ef          	jal	b7c <wait>
     34e:	bb75                	j	10a <go+0x96>
        close(open("a", O_CREATE|O_RDWR));
     350:	20200593          	li	a1,514
     354:	00001517          	auipc	a0,0x1
     358:	f1450513          	addi	a0,a0,-236 # 1268 <malloc+0x228>
     35c:	059000ef          	jal	bb4 <open>
     360:	03d000ef          	jal	b9c <close>
        exit(0);
     364:	4501                	li	a0,0
     366:	00f000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     36a:	00001517          	auipc	a0,0x1
     36e:	ee650513          	addi	a0,a0,-282 # 1250 <malloc+0x210>
     372:	41b000ef          	jal	f8c <printf>
        exit(1);
     376:	4505                	li	a0,1
     378:	7fc000ef          	jal	b74 <exit>
        printf("grind: chdir failed\n");
     37c:	00001517          	auipc	a0,0x1
     380:	f0450513          	addi	a0,a0,-252 # 1280 <malloc+0x240>
     384:	409000ef          	jal	f8c <printf>
        exit(1);
     388:	4505                	li	a0,1
     38a:	7ea000ef          	jal	b74 <exit>
    } else if(what == 18){
      int pid = fork(1);
     38e:	4505                	li	a0,1
     390:	7dc000ef          	jal	b6c <fork>
      if(pid == 0){
     394:	c519                	beqz	a0,3a2 <go+0x32e>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     396:	00054d63          	bltz	a0,3b0 <go+0x33c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     39a:	4501                	li	a0,0
     39c:	7e0000ef          	jal	b7c <wait>
     3a0:	b3ad                	j	10a <go+0x96>
        kill(getpid());
     3a2:	053000ef          	jal	bf4 <getpid>
     3a6:	7fe000ef          	jal	ba4 <kill>
        exit(0);
     3aa:	4501                	li	a0,0
     3ac:	7c8000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     3b0:	00001517          	auipc	a0,0x1
     3b4:	ea050513          	addi	a0,a0,-352 # 1250 <malloc+0x210>
     3b8:	3d5000ef          	jal	f8c <printf>
        exit(1);
     3bc:	4505                	li	a0,1
     3be:	7b6000ef          	jal	b74 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     3c2:	f9840513          	addi	a0,s0,-104
     3c6:	7be000ef          	jal	b84 <pipe>
     3ca:	02054463          	bltz	a0,3f2 <go+0x37e>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork(1);
     3ce:	4505                	li	a0,1
     3d0:	79c000ef          	jal	b6c <fork>
      if(pid == 0){
     3d4:	c905                	beqz	a0,404 <go+0x390>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     3d6:	08054463          	bltz	a0,45e <go+0x3ea>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     3da:	f9842503          	lw	a0,-104(s0)
     3de:	7be000ef          	jal	b9c <close>
      close(fds[1]);
     3e2:	f9c42503          	lw	a0,-100(s0)
     3e6:	7b6000ef          	jal	b9c <close>
      wait(0);
     3ea:	4501                	li	a0,0
     3ec:	790000ef          	jal	b7c <wait>
     3f0:	bb29                	j	10a <go+0x96>
        printf("grind: pipe failed\n");
     3f2:	00001517          	auipc	a0,0x1
     3f6:	ea650513          	addi	a0,a0,-346 # 1298 <malloc+0x258>
     3fa:	393000ef          	jal	f8c <printf>
        exit(1);
     3fe:	4505                	li	a0,1
     400:	774000ef          	jal	b74 <exit>
        fork(1);
     404:	4505                	li	a0,1
     406:	766000ef          	jal	b6c <fork>
        fork(1);
     40a:	4505                	li	a0,1
     40c:	760000ef          	jal	b6c <fork>
        if(write(fds[1], "x", 1) != 1)
     410:	4605                	li	a2,1
     412:	00001597          	auipc	a1,0x1
     416:	e9e58593          	addi	a1,a1,-354 # 12b0 <malloc+0x270>
     41a:	f9c42503          	lw	a0,-100(s0)
     41e:	776000ef          	jal	b94 <write>
     422:	4785                	li	a5,1
     424:	00f51f63          	bne	a0,a5,442 <go+0x3ce>
        if(read(fds[0], &c, 1) != 1)
     428:	4605                	li	a2,1
     42a:	f9040593          	addi	a1,s0,-112
     42e:	f9842503          	lw	a0,-104(s0)
     432:	75a000ef          	jal	b8c <read>
     436:	4785                	li	a5,1
     438:	00f51c63          	bne	a0,a5,450 <go+0x3dc>
        exit(0);
     43c:	4501                	li	a0,0
     43e:	736000ef          	jal	b74 <exit>
          printf("grind: pipe write failed\n");
     442:	00001517          	auipc	a0,0x1
     446:	e7650513          	addi	a0,a0,-394 # 12b8 <malloc+0x278>
     44a:	343000ef          	jal	f8c <printf>
     44e:	bfe9                	j	428 <go+0x3b4>
          printf("grind: pipe read failed\n");
     450:	00001517          	auipc	a0,0x1
     454:	e8850513          	addi	a0,a0,-376 # 12d8 <malloc+0x298>
     458:	335000ef          	jal	f8c <printf>
     45c:	b7c5                	j	43c <go+0x3c8>
        printf("grind: fork failed\n");
     45e:	00001517          	auipc	a0,0x1
     462:	df250513          	addi	a0,a0,-526 # 1250 <malloc+0x210>
     466:	327000ef          	jal	f8c <printf>
        exit(1);
     46a:	4505                	li	a0,1
     46c:	708000ef          	jal	b74 <exit>
    } else if(what == 20){
      int pid = fork(1);
     470:	4505                	li	a0,1
     472:	6fa000ef          	jal	b6c <fork>
      if(pid == 0){
     476:	c519                	beqz	a0,484 <go+0x410>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     478:	04054f63          	bltz	a0,4d6 <go+0x462>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     47c:	4501                	li	a0,0
     47e:	6fe000ef          	jal	b7c <wait>
     482:	b161                	j	10a <go+0x96>
        unlink("a");
     484:	00001517          	auipc	a0,0x1
     488:	de450513          	addi	a0,a0,-540 # 1268 <malloc+0x228>
     48c:	738000ef          	jal	bc4 <unlink>
        mkdir("a");
     490:	00001517          	auipc	a0,0x1
     494:	dd850513          	addi	a0,a0,-552 # 1268 <malloc+0x228>
     498:	744000ef          	jal	bdc <mkdir>
        chdir("a");
     49c:	00001517          	auipc	a0,0x1
     4a0:	dcc50513          	addi	a0,a0,-564 # 1268 <malloc+0x228>
     4a4:	740000ef          	jal	be4 <chdir>
        unlink("../a");
     4a8:	00001517          	auipc	a0,0x1
     4ac:	e5050513          	addi	a0,a0,-432 # 12f8 <malloc+0x2b8>
     4b0:	714000ef          	jal	bc4 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     4b4:	20200593          	li	a1,514
     4b8:	00001517          	auipc	a0,0x1
     4bc:	df850513          	addi	a0,a0,-520 # 12b0 <malloc+0x270>
     4c0:	6f4000ef          	jal	bb4 <open>
        unlink("x");
     4c4:	00001517          	auipc	a0,0x1
     4c8:	dec50513          	addi	a0,a0,-532 # 12b0 <malloc+0x270>
     4cc:	6f8000ef          	jal	bc4 <unlink>
        exit(0);
     4d0:	4501                	li	a0,0
     4d2:	6a2000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     4d6:	00001517          	auipc	a0,0x1
     4da:	d7a50513          	addi	a0,a0,-646 # 1250 <malloc+0x210>
     4de:	2af000ef          	jal	f8c <printf>
        exit(1);
     4e2:	4505                	li	a0,1
     4e4:	690000ef          	jal	b74 <exit>
    } else if(what == 21){
      unlink("c");
     4e8:	00001517          	auipc	a0,0x1
     4ec:	e1850513          	addi	a0,a0,-488 # 1300 <malloc+0x2c0>
     4f0:	6d4000ef          	jal	bc4 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     4f4:	20200593          	li	a1,514
     4f8:	00001517          	auipc	a0,0x1
     4fc:	e0850513          	addi	a0,a0,-504 # 1300 <malloc+0x2c0>
     500:	6b4000ef          	jal	bb4 <open>
     504:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     506:	04054763          	bltz	a0,554 <go+0x4e0>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     50a:	4605                	li	a2,1
     50c:	00001597          	auipc	a1,0x1
     510:	da458593          	addi	a1,a1,-604 # 12b0 <malloc+0x270>
     514:	680000ef          	jal	b94 <write>
     518:	4785                	li	a5,1
     51a:	04f51663          	bne	a0,a5,566 <go+0x4f2>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     51e:	f9840593          	addi	a1,s0,-104
     522:	855a                	mv	a0,s6
     524:	6a8000ef          	jal	bcc <fstat>
     528:	e921                	bnez	a0,578 <go+0x504>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     52a:	fa843583          	ld	a1,-88(s0)
     52e:	4785                	li	a5,1
     530:	04f59d63          	bne	a1,a5,58a <go+0x516>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     534:	f9c42583          	lw	a1,-100(s0)
     538:	0c800793          	li	a5,200
     53c:	06b7e163          	bltu	a5,a1,59e <go+0x52a>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     540:	855a                	mv	a0,s6
     542:	65a000ef          	jal	b9c <close>
      unlink("c");
     546:	00001517          	auipc	a0,0x1
     54a:	dba50513          	addi	a0,a0,-582 # 1300 <malloc+0x2c0>
     54e:	676000ef          	jal	bc4 <unlink>
     552:	be65                	j	10a <go+0x96>
        printf("grind: create c failed\n");
     554:	00001517          	auipc	a0,0x1
     558:	db450513          	addi	a0,a0,-588 # 1308 <malloc+0x2c8>
     55c:	231000ef          	jal	f8c <printf>
        exit(1);
     560:	4505                	li	a0,1
     562:	612000ef          	jal	b74 <exit>
        printf("grind: write c failed\n");
     566:	00001517          	auipc	a0,0x1
     56a:	dba50513          	addi	a0,a0,-582 # 1320 <malloc+0x2e0>
     56e:	21f000ef          	jal	f8c <printf>
        exit(1);
     572:	4505                	li	a0,1
     574:	600000ef          	jal	b74 <exit>
        printf("grind: fstat failed\n");
     578:	00001517          	auipc	a0,0x1
     57c:	dc050513          	addi	a0,a0,-576 # 1338 <malloc+0x2f8>
     580:	20d000ef          	jal	f8c <printf>
        exit(1);
     584:	4505                	li	a0,1
     586:	5ee000ef          	jal	b74 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     58a:	2581                	sext.w	a1,a1
     58c:	00001517          	auipc	a0,0x1
     590:	dc450513          	addi	a0,a0,-572 # 1350 <malloc+0x310>
     594:	1f9000ef          	jal	f8c <printf>
        exit(1);
     598:	4505                	li	a0,1
     59a:	5da000ef          	jal	b74 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     59e:	00001517          	auipc	a0,0x1
     5a2:	dda50513          	addi	a0,a0,-550 # 1378 <malloc+0x338>
     5a6:	1e7000ef          	jal	f8c <printf>
        exit(1);
     5aa:	4505                	li	a0,1
     5ac:	5c8000ef          	jal	b74 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     5b0:	f8840513          	addi	a0,s0,-120
     5b4:	5d0000ef          	jal	b84 <pipe>
     5b8:	0a054763          	bltz	a0,666 <go+0x5f2>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     5bc:	f9040513          	addi	a0,s0,-112
     5c0:	5c4000ef          	jal	b84 <pipe>
     5c4:	0a054b63          	bltz	a0,67a <go+0x606>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork(1);
     5c8:	4505                	li	a0,1
     5ca:	5a2000ef          	jal	b6c <fork>
      if(pid1 == 0){
     5ce:	c161                	beqz	a0,68e <go+0x61a>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     5d0:	14054363          	bltz	a0,716 <go+0x6a2>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork(1);
     5d4:	4505                	li	a0,1
     5d6:	596000ef          	jal	b6c <fork>
      if(pid2 == 0){
     5da:	14050863          	beqz	a0,72a <go+0x6b6>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     5de:	1e054663          	bltz	a0,7ca <go+0x756>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     5e2:	f8842503          	lw	a0,-120(s0)
     5e6:	5b6000ef          	jal	b9c <close>
      close(aa[1]);
     5ea:	f8c42503          	lw	a0,-116(s0)
     5ee:	5ae000ef          	jal	b9c <close>
      close(bb[1]);
     5f2:	f9442503          	lw	a0,-108(s0)
     5f6:	5a6000ef          	jal	b9c <close>
      char buf[4] = { 0, 0, 0, 0 };
     5fa:	f8042023          	sw	zero,-128(s0)
      read(bb[0], buf+0, 1);
     5fe:	4605                	li	a2,1
     600:	f8040593          	addi	a1,s0,-128
     604:	f9042503          	lw	a0,-112(s0)
     608:	584000ef          	jal	b8c <read>
      read(bb[0], buf+1, 1);
     60c:	4605                	li	a2,1
     60e:	f8140593          	addi	a1,s0,-127
     612:	f9042503          	lw	a0,-112(s0)
     616:	576000ef          	jal	b8c <read>
      read(bb[0], buf+2, 1);
     61a:	4605                	li	a2,1
     61c:	f8240593          	addi	a1,s0,-126
     620:	f9042503          	lw	a0,-112(s0)
     624:	568000ef          	jal	b8c <read>
      close(bb[0]);
     628:	f9042503          	lw	a0,-112(s0)
     62c:	570000ef          	jal	b9c <close>
      int st1, st2;
      wait(&st1);
     630:	f8440513          	addi	a0,s0,-124
     634:	548000ef          	jal	b7c <wait>
      wait(&st2);
     638:	f9840513          	addi	a0,s0,-104
     63c:	540000ef          	jal	b7c <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     640:	f8442783          	lw	a5,-124(s0)
     644:	f9842b83          	lw	s7,-104(s0)
     648:	0177eb33          	or	s6,a5,s7
     64c:	180b1963          	bnez	s6,7de <go+0x76a>
     650:	00001597          	auipc	a1,0x1
     654:	dc858593          	addi	a1,a1,-568 # 1418 <malloc+0x3d8>
     658:	f8040513          	addi	a0,s0,-128
     65c:	2d4000ef          	jal	930 <strcmp>
     660:	aa0505e3          	beqz	a0,10a <go+0x96>
     664:	aab5                	j	7e0 <go+0x76c>
        fprintf(2, "grind: pipe failed\n");
     666:	00001597          	auipc	a1,0x1
     66a:	c3258593          	addi	a1,a1,-974 # 1298 <malloc+0x258>
     66e:	4509                	li	a0,2
     670:	0f3000ef          	jal	f62 <fprintf>
        exit(1);
     674:	4505                	li	a0,1
     676:	4fe000ef          	jal	b74 <exit>
        fprintf(2, "grind: pipe failed\n");
     67a:	00001597          	auipc	a1,0x1
     67e:	c1e58593          	addi	a1,a1,-994 # 1298 <malloc+0x258>
     682:	4509                	li	a0,2
     684:	0df000ef          	jal	f62 <fprintf>
        exit(1);
     688:	4505                	li	a0,1
     68a:	4ea000ef          	jal	b74 <exit>
        close(bb[0]);
     68e:	f9042503          	lw	a0,-112(s0)
     692:	50a000ef          	jal	b9c <close>
        close(bb[1]);
     696:	f9442503          	lw	a0,-108(s0)
     69a:	502000ef          	jal	b9c <close>
        close(aa[0]);
     69e:	f8842503          	lw	a0,-120(s0)
     6a2:	4fa000ef          	jal	b9c <close>
        close(1);
     6a6:	4505                	li	a0,1
     6a8:	4f4000ef          	jal	b9c <close>
        if(dup(aa[1]) != 1){
     6ac:	f8c42503          	lw	a0,-116(s0)
     6b0:	53c000ef          	jal	bec <dup>
     6b4:	4785                	li	a5,1
     6b6:	00f50c63          	beq	a0,a5,6ce <go+0x65a>
          fprintf(2, "grind: dup failed\n");
     6ba:	00001597          	auipc	a1,0x1
     6be:	ce658593          	addi	a1,a1,-794 # 13a0 <malloc+0x360>
     6c2:	4509                	li	a0,2
     6c4:	09f000ef          	jal	f62 <fprintf>
          exit(1);
     6c8:	4505                	li	a0,1
     6ca:	4aa000ef          	jal	b74 <exit>
        close(aa[1]);
     6ce:	f8c42503          	lw	a0,-116(s0)
     6d2:	4ca000ef          	jal	b9c <close>
        char *args[3] = { "echo", "hi", 0 };
     6d6:	00001797          	auipc	a5,0x1
     6da:	ce278793          	addi	a5,a5,-798 # 13b8 <malloc+0x378>
     6de:	f8f43c23          	sd	a5,-104(s0)
     6e2:	00001797          	auipc	a5,0x1
     6e6:	cde78793          	addi	a5,a5,-802 # 13c0 <malloc+0x380>
     6ea:	faf43023          	sd	a5,-96(s0)
     6ee:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
     6f2:	f9840593          	addi	a1,s0,-104
     6f6:	00001517          	auipc	a0,0x1
     6fa:	cd250513          	addi	a0,a0,-814 # 13c8 <malloc+0x388>
     6fe:	4ae000ef          	jal	bac <exec>
        fprintf(2, "grind: echo: not found\n");
     702:	00001597          	auipc	a1,0x1
     706:	cd658593          	addi	a1,a1,-810 # 13d8 <malloc+0x398>
     70a:	4509                	li	a0,2
     70c:	057000ef          	jal	f62 <fprintf>
        exit(2);
     710:	4509                	li	a0,2
     712:	462000ef          	jal	b74 <exit>
        fprintf(2, "grind: fork failed\n");
     716:	00001597          	auipc	a1,0x1
     71a:	b3a58593          	addi	a1,a1,-1222 # 1250 <malloc+0x210>
     71e:	4509                	li	a0,2
     720:	043000ef          	jal	f62 <fprintf>
        exit(3);
     724:	450d                	li	a0,3
     726:	44e000ef          	jal	b74 <exit>
        close(aa[1]);
     72a:	f8c42503          	lw	a0,-116(s0)
     72e:	46e000ef          	jal	b9c <close>
        close(bb[0]);
     732:	f9042503          	lw	a0,-112(s0)
     736:	466000ef          	jal	b9c <close>
        close(0);
     73a:	4501                	li	a0,0
     73c:	460000ef          	jal	b9c <close>
        if(dup(aa[0]) != 0){
     740:	f8842503          	lw	a0,-120(s0)
     744:	4a8000ef          	jal	bec <dup>
     748:	c919                	beqz	a0,75e <go+0x6ea>
          fprintf(2, "grind: dup failed\n");
     74a:	00001597          	auipc	a1,0x1
     74e:	c5658593          	addi	a1,a1,-938 # 13a0 <malloc+0x360>
     752:	4509                	li	a0,2
     754:	00f000ef          	jal	f62 <fprintf>
          exit(4);
     758:	4511                	li	a0,4
     75a:	41a000ef          	jal	b74 <exit>
        close(aa[0]);
     75e:	f8842503          	lw	a0,-120(s0)
     762:	43a000ef          	jal	b9c <close>
        close(1);
     766:	4505                	li	a0,1
     768:	434000ef          	jal	b9c <close>
        if(dup(bb[1]) != 1){
     76c:	f9442503          	lw	a0,-108(s0)
     770:	47c000ef          	jal	bec <dup>
     774:	4785                	li	a5,1
     776:	00f50c63          	beq	a0,a5,78e <go+0x71a>
          fprintf(2, "grind: dup failed\n");
     77a:	00001597          	auipc	a1,0x1
     77e:	c2658593          	addi	a1,a1,-986 # 13a0 <malloc+0x360>
     782:	4509                	li	a0,2
     784:	7de000ef          	jal	f62 <fprintf>
          exit(5);
     788:	4515                	li	a0,5
     78a:	3ea000ef          	jal	b74 <exit>
        close(bb[1]);
     78e:	f9442503          	lw	a0,-108(s0)
     792:	40a000ef          	jal	b9c <close>
        char *args[2] = { "cat", 0 };
     796:	00001797          	auipc	a5,0x1
     79a:	c5a78793          	addi	a5,a5,-934 # 13f0 <malloc+0x3b0>
     79e:	f8f43c23          	sd	a5,-104(s0)
     7a2:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
     7a6:	f9840593          	addi	a1,s0,-104
     7aa:	00001517          	auipc	a0,0x1
     7ae:	c4e50513          	addi	a0,a0,-946 # 13f8 <malloc+0x3b8>
     7b2:	3fa000ef          	jal	bac <exec>
        fprintf(2, "grind: cat: not found\n");
     7b6:	00001597          	auipc	a1,0x1
     7ba:	c4a58593          	addi	a1,a1,-950 # 1400 <malloc+0x3c0>
     7be:	4509                	li	a0,2
     7c0:	7a2000ef          	jal	f62 <fprintf>
        exit(6);
     7c4:	4519                	li	a0,6
     7c6:	3ae000ef          	jal	b74 <exit>
        fprintf(2, "grind: fork failed\n");
     7ca:	00001597          	auipc	a1,0x1
     7ce:	a8658593          	addi	a1,a1,-1402 # 1250 <malloc+0x210>
     7d2:	4509                	li	a0,2
     7d4:	78e000ef          	jal	f62 <fprintf>
        exit(7);
     7d8:	451d                	li	a0,7
     7da:	39a000ef          	jal	b74 <exit>
     7de:	8b3e                	mv	s6,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     7e0:	f8040693          	addi	a3,s0,-128
     7e4:	865e                	mv	a2,s7
     7e6:	85da                	mv	a1,s6
     7e8:	00001517          	auipc	a0,0x1
     7ec:	c3850513          	addi	a0,a0,-968 # 1420 <malloc+0x3e0>
     7f0:	79c000ef          	jal	f8c <printf>
        exit(1);
     7f4:	4505                	li	a0,1
     7f6:	37e000ef          	jal	b74 <exit>

00000000000007fa <iter>:
  }
}

void
iter()
{
     7fa:	7179                	addi	sp,sp,-48
     7fc:	f406                	sd	ra,40(sp)
     7fe:	f022                	sd	s0,32(sp)
     800:	1800                	addi	s0,sp,48
  unlink("a");
     802:	00001517          	auipc	a0,0x1
     806:	a6650513          	addi	a0,a0,-1434 # 1268 <malloc+0x228>
     80a:	3ba000ef          	jal	bc4 <unlink>
  unlink("b");
     80e:	00001517          	auipc	a0,0x1
     812:	a0a50513          	addi	a0,a0,-1526 # 1218 <malloc+0x1d8>
     816:	3ae000ef          	jal	bc4 <unlink>
  
  int pid1 = fork(1);
     81a:	4505                	li	a0,1
     81c:	350000ef          	jal	b6c <fork>
  if(pid1 < 0){
     820:	02054163          	bltz	a0,842 <iter+0x48>
     824:	ec26                	sd	s1,24(sp)
     826:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     828:	e905                	bnez	a0,858 <iter+0x5e>
     82a:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     82c:	00001717          	auipc	a4,0x1
     830:	7d470713          	addi	a4,a4,2004 # 2000 <rand_next>
     834:	631c                	ld	a5,0(a4)
     836:	01f7c793          	xori	a5,a5,31
     83a:	e31c                	sd	a5,0(a4)
    go(0);
     83c:	4501                	li	a0,0
     83e:	837ff0ef          	jal	74 <go>
     842:	ec26                	sd	s1,24(sp)
     844:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     846:	00001517          	auipc	a0,0x1
     84a:	a0a50513          	addi	a0,a0,-1526 # 1250 <malloc+0x210>
     84e:	73e000ef          	jal	f8c <printf>
    exit(1);
     852:	4505                	li	a0,1
     854:	320000ef          	jal	b74 <exit>
     858:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork(1);
     85a:	4505                	li	a0,1
     85c:	310000ef          	jal	b6c <fork>
     860:	892a                	mv	s2,a0
  if(pid2 < 0){
     862:	02054063          	bltz	a0,882 <iter+0x88>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     866:	e51d                	bnez	a0,894 <iter+0x9a>
    rand_next ^= 7177;
     868:	00001697          	auipc	a3,0x1
     86c:	79868693          	addi	a3,a3,1944 # 2000 <rand_next>
     870:	629c                	ld	a5,0(a3)
     872:	6709                	lui	a4,0x2
     874:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x759>
     878:	8fb9                	xor	a5,a5,a4
     87a:	e29c                	sd	a5,0(a3)
    go(1);
     87c:	4505                	li	a0,1
     87e:	ff6ff0ef          	jal	74 <go>
    printf("grind: fork failed\n");
     882:	00001517          	auipc	a0,0x1
     886:	9ce50513          	addi	a0,a0,-1586 # 1250 <malloc+0x210>
     88a:	702000ef          	jal	f8c <printf>
    exit(1);
     88e:	4505                	li	a0,1
     890:	2e4000ef          	jal	b74 <exit>
    exit(0);
  }

  int st1 = -1;
     894:	57fd                	li	a5,-1
     896:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     89a:	fdc40513          	addi	a0,s0,-36
     89e:	2de000ef          	jal	b7c <wait>
  if(st1 != 0){
     8a2:	fdc42783          	lw	a5,-36(s0)
     8a6:	eb99                	bnez	a5,8bc <iter+0xc2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     8a8:	57fd                	li	a5,-1
     8aa:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     8ae:	fd840513          	addi	a0,s0,-40
     8b2:	2ca000ef          	jal	b7c <wait>

  exit(0);
     8b6:	4501                	li	a0,0
     8b8:	2bc000ef          	jal	b74 <exit>
    kill(pid1);
     8bc:	8526                	mv	a0,s1
     8be:	2e6000ef          	jal	ba4 <kill>
    kill(pid2);
     8c2:	854a                	mv	a0,s2
     8c4:	2e0000ef          	jal	ba4 <kill>
     8c8:	b7c5                	j	8a8 <iter+0xae>

00000000000008ca <main>:
}

int
main()
{
     8ca:	1101                	addi	sp,sp,-32
     8cc:	ec06                	sd	ra,24(sp)
     8ce:	e822                	sd	s0,16(sp)
     8d0:	e426                	sd	s1,8(sp)
     8d2:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     8d4:	00001497          	auipc	s1,0x1
     8d8:	72c48493          	addi	s1,s1,1836 # 2000 <rand_next>
     8dc:	a809                	j	8ee <main+0x24>
      iter();
     8de:	f1dff0ef          	jal	7fa <iter>
    sleep(20);
     8e2:	4551                	li	a0,20
     8e4:	320000ef          	jal	c04 <sleep>
    rand_next += 1;
     8e8:	609c                	ld	a5,0(s1)
     8ea:	0785                	addi	a5,a5,1
     8ec:	e09c                	sd	a5,0(s1)
    int pid = fork(1);
     8ee:	4505                	li	a0,1
     8f0:	27c000ef          	jal	b6c <fork>
    if(pid == 0){
     8f4:	d56d                	beqz	a0,8de <main+0x14>
    if(pid > 0){
     8f6:	fea056e3          	blez	a0,8e2 <main+0x18>
      wait(0);
     8fa:	4501                	li	a0,0
     8fc:	280000ef          	jal	b7c <wait>
     900:	b7cd                	j	8e2 <main+0x18>

0000000000000902 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     902:	1141                	addi	sp,sp,-16
     904:	e406                	sd	ra,8(sp)
     906:	e022                	sd	s0,0(sp)
     908:	0800                	addi	s0,sp,16
  extern int main();
  main();
     90a:	fc1ff0ef          	jal	8ca <main>
  exit(0);
     90e:	4501                	li	a0,0
     910:	264000ef          	jal	b74 <exit>

0000000000000914 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     914:	1141                	addi	sp,sp,-16
     916:	e422                	sd	s0,8(sp)
     918:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     91a:	87aa                	mv	a5,a0
     91c:	0585                	addi	a1,a1,1
     91e:	0785                	addi	a5,a5,1
     920:	fff5c703          	lbu	a4,-1(a1)
     924:	fee78fa3          	sb	a4,-1(a5)
     928:	fb75                	bnez	a4,91c <strcpy+0x8>
    ;
  return os;
}
     92a:	6422                	ld	s0,8(sp)
     92c:	0141                	addi	sp,sp,16
     92e:	8082                	ret

0000000000000930 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     930:	1141                	addi	sp,sp,-16
     932:	e422                	sd	s0,8(sp)
     934:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     936:	00054783          	lbu	a5,0(a0)
     93a:	cb91                	beqz	a5,94e <strcmp+0x1e>
     93c:	0005c703          	lbu	a4,0(a1)
     940:	00f71763          	bne	a4,a5,94e <strcmp+0x1e>
    p++, q++;
     944:	0505                	addi	a0,a0,1
     946:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     948:	00054783          	lbu	a5,0(a0)
     94c:	fbe5                	bnez	a5,93c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     94e:	0005c503          	lbu	a0,0(a1)
}
     952:	40a7853b          	subw	a0,a5,a0
     956:	6422                	ld	s0,8(sp)
     958:	0141                	addi	sp,sp,16
     95a:	8082                	ret

000000000000095c <strlen>:

uint
strlen(const char *s)
{
     95c:	1141                	addi	sp,sp,-16
     95e:	e422                	sd	s0,8(sp)
     960:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     962:	00054783          	lbu	a5,0(a0)
     966:	cf91                	beqz	a5,982 <strlen+0x26>
     968:	0505                	addi	a0,a0,1
     96a:	87aa                	mv	a5,a0
     96c:	86be                	mv	a3,a5
     96e:	0785                	addi	a5,a5,1
     970:	fff7c703          	lbu	a4,-1(a5)
     974:	ff65                	bnez	a4,96c <strlen+0x10>
     976:	40a6853b          	subw	a0,a3,a0
     97a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     97c:	6422                	ld	s0,8(sp)
     97e:	0141                	addi	sp,sp,16
     980:	8082                	ret
  for(n = 0; s[n]; n++)
     982:	4501                	li	a0,0
     984:	bfe5                	j	97c <strlen+0x20>

0000000000000986 <memset>:

void*
memset(void *dst, int c, uint n)
{
     986:	1141                	addi	sp,sp,-16
     988:	e422                	sd	s0,8(sp)
     98a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     98c:	ca19                	beqz	a2,9a2 <memset+0x1c>
     98e:	87aa                	mv	a5,a0
     990:	1602                	slli	a2,a2,0x20
     992:	9201                	srli	a2,a2,0x20
     994:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     998:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     99c:	0785                	addi	a5,a5,1
     99e:	fee79de3          	bne	a5,a4,998 <memset+0x12>
  }
  return dst;
}
     9a2:	6422                	ld	s0,8(sp)
     9a4:	0141                	addi	sp,sp,16
     9a6:	8082                	ret

00000000000009a8 <strchr>:

char*
strchr(const char *s, char c)
{
     9a8:	1141                	addi	sp,sp,-16
     9aa:	e422                	sd	s0,8(sp)
     9ac:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9ae:	00054783          	lbu	a5,0(a0)
     9b2:	cb99                	beqz	a5,9c8 <strchr+0x20>
    if(*s == c)
     9b4:	00f58763          	beq	a1,a5,9c2 <strchr+0x1a>
  for(; *s; s++)
     9b8:	0505                	addi	a0,a0,1
     9ba:	00054783          	lbu	a5,0(a0)
     9be:	fbfd                	bnez	a5,9b4 <strchr+0xc>
      return (char*)s;
  return 0;
     9c0:	4501                	li	a0,0
}
     9c2:	6422                	ld	s0,8(sp)
     9c4:	0141                	addi	sp,sp,16
     9c6:	8082                	ret
  return 0;
     9c8:	4501                	li	a0,0
     9ca:	bfe5                	j	9c2 <strchr+0x1a>

00000000000009cc <gets>:

char*
gets(char *buf, int max)
{
     9cc:	711d                	addi	sp,sp,-96
     9ce:	ec86                	sd	ra,88(sp)
     9d0:	e8a2                	sd	s0,80(sp)
     9d2:	e4a6                	sd	s1,72(sp)
     9d4:	e0ca                	sd	s2,64(sp)
     9d6:	fc4e                	sd	s3,56(sp)
     9d8:	f852                	sd	s4,48(sp)
     9da:	f456                	sd	s5,40(sp)
     9dc:	f05a                	sd	s6,32(sp)
     9de:	ec5e                	sd	s7,24(sp)
     9e0:	1080                	addi	s0,sp,96
     9e2:	8baa                	mv	s7,a0
     9e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9e6:	892a                	mv	s2,a0
     9e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9ea:	4aa9                	li	s5,10
     9ec:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9ee:	89a6                	mv	s3,s1
     9f0:	2485                	addiw	s1,s1,1
     9f2:	0344d663          	bge	s1,s4,a1e <gets+0x52>
    cc = read(0, &c, 1);
     9f6:	4605                	li	a2,1
     9f8:	faf40593          	addi	a1,s0,-81
     9fc:	4501                	li	a0,0
     9fe:	18e000ef          	jal	b8c <read>
    if(cc < 1)
     a02:	00a05e63          	blez	a0,a1e <gets+0x52>
    buf[i++] = c;
     a06:	faf44783          	lbu	a5,-81(s0)
     a0a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a0e:	01578763          	beq	a5,s5,a1c <gets+0x50>
     a12:	0905                	addi	s2,s2,1
     a14:	fd679de3          	bne	a5,s6,9ee <gets+0x22>
    buf[i++] = c;
     a18:	89a6                	mv	s3,s1
     a1a:	a011                	j	a1e <gets+0x52>
     a1c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a1e:	99de                	add	s3,s3,s7
     a20:	00098023          	sb	zero,0(s3)
  return buf;
}
     a24:	855e                	mv	a0,s7
     a26:	60e6                	ld	ra,88(sp)
     a28:	6446                	ld	s0,80(sp)
     a2a:	64a6                	ld	s1,72(sp)
     a2c:	6906                	ld	s2,64(sp)
     a2e:	79e2                	ld	s3,56(sp)
     a30:	7a42                	ld	s4,48(sp)
     a32:	7aa2                	ld	s5,40(sp)
     a34:	7b02                	ld	s6,32(sp)
     a36:	6be2                	ld	s7,24(sp)
     a38:	6125                	addi	sp,sp,96
     a3a:	8082                	ret

0000000000000a3c <stat>:

int
stat(const char *n, struct stat *st)
{
     a3c:	1101                	addi	sp,sp,-32
     a3e:	ec06                	sd	ra,24(sp)
     a40:	e822                	sd	s0,16(sp)
     a42:	e04a                	sd	s2,0(sp)
     a44:	1000                	addi	s0,sp,32
     a46:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a48:	4581                	li	a1,0
     a4a:	16a000ef          	jal	bb4 <open>
  if(fd < 0)
     a4e:	02054263          	bltz	a0,a72 <stat+0x36>
     a52:	e426                	sd	s1,8(sp)
     a54:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a56:	85ca                	mv	a1,s2
     a58:	174000ef          	jal	bcc <fstat>
     a5c:	892a                	mv	s2,a0
  close(fd);
     a5e:	8526                	mv	a0,s1
     a60:	13c000ef          	jal	b9c <close>
  return r;
     a64:	64a2                	ld	s1,8(sp)
}
     a66:	854a                	mv	a0,s2
     a68:	60e2                	ld	ra,24(sp)
     a6a:	6442                	ld	s0,16(sp)
     a6c:	6902                	ld	s2,0(sp)
     a6e:	6105                	addi	sp,sp,32
     a70:	8082                	ret
    return -1;
     a72:	597d                	li	s2,-1
     a74:	bfcd                	j	a66 <stat+0x2a>

0000000000000a76 <atoi>:

int
atoi(const char *s)
{
     a76:	1141                	addi	sp,sp,-16
     a78:	e422                	sd	s0,8(sp)
     a7a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a7c:	00054683          	lbu	a3,0(a0)
     a80:	fd06879b          	addiw	a5,a3,-48
     a84:	0ff7f793          	zext.b	a5,a5
     a88:	4625                	li	a2,9
     a8a:	02f66863          	bltu	a2,a5,aba <atoi+0x44>
     a8e:	872a                	mv	a4,a0
  n = 0;
     a90:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a92:	0705                	addi	a4,a4,1
     a94:	0025179b          	slliw	a5,a0,0x2
     a98:	9fa9                	addw	a5,a5,a0
     a9a:	0017979b          	slliw	a5,a5,0x1
     a9e:	9fb5                	addw	a5,a5,a3
     aa0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     aa4:	00074683          	lbu	a3,0(a4)
     aa8:	fd06879b          	addiw	a5,a3,-48
     aac:	0ff7f793          	zext.b	a5,a5
     ab0:	fef671e3          	bgeu	a2,a5,a92 <atoi+0x1c>
  return n;
}
     ab4:	6422                	ld	s0,8(sp)
     ab6:	0141                	addi	sp,sp,16
     ab8:	8082                	ret
  n = 0;
     aba:	4501                	li	a0,0
     abc:	bfe5                	j	ab4 <atoi+0x3e>

0000000000000abe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     abe:	1141                	addi	sp,sp,-16
     ac0:	e422                	sd	s0,8(sp)
     ac2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     ac4:	02b57463          	bgeu	a0,a1,aec <memmove+0x2e>
    while(n-- > 0)
     ac8:	00c05f63          	blez	a2,ae6 <memmove+0x28>
     acc:	1602                	slli	a2,a2,0x20
     ace:	9201                	srli	a2,a2,0x20
     ad0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ad4:	872a                	mv	a4,a0
      *dst++ = *src++;
     ad6:	0585                	addi	a1,a1,1
     ad8:	0705                	addi	a4,a4,1
     ada:	fff5c683          	lbu	a3,-1(a1)
     ade:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ae2:	fef71ae3          	bne	a4,a5,ad6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ae6:	6422                	ld	s0,8(sp)
     ae8:	0141                	addi	sp,sp,16
     aea:	8082                	ret
    dst += n;
     aec:	00c50733          	add	a4,a0,a2
    src += n;
     af0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     af2:	fec05ae3          	blez	a2,ae6 <memmove+0x28>
     af6:	fff6079b          	addiw	a5,a2,-1
     afa:	1782                	slli	a5,a5,0x20
     afc:	9381                	srli	a5,a5,0x20
     afe:	fff7c793          	not	a5,a5
     b02:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b04:	15fd                	addi	a1,a1,-1
     b06:	177d                	addi	a4,a4,-1
     b08:	0005c683          	lbu	a3,0(a1)
     b0c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b10:	fee79ae3          	bne	a5,a4,b04 <memmove+0x46>
     b14:	bfc9                	j	ae6 <memmove+0x28>

0000000000000b16 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b16:	1141                	addi	sp,sp,-16
     b18:	e422                	sd	s0,8(sp)
     b1a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b1c:	ca05                	beqz	a2,b4c <memcmp+0x36>
     b1e:	fff6069b          	addiw	a3,a2,-1
     b22:	1682                	slli	a3,a3,0x20
     b24:	9281                	srli	a3,a3,0x20
     b26:	0685                	addi	a3,a3,1
     b28:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b2a:	00054783          	lbu	a5,0(a0)
     b2e:	0005c703          	lbu	a4,0(a1)
     b32:	00e79863          	bne	a5,a4,b42 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b36:	0505                	addi	a0,a0,1
    p2++;
     b38:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b3a:	fed518e3          	bne	a0,a3,b2a <memcmp+0x14>
  }
  return 0;
     b3e:	4501                	li	a0,0
     b40:	a019                	j	b46 <memcmp+0x30>
      return *p1 - *p2;
     b42:	40e7853b          	subw	a0,a5,a4
}
     b46:	6422                	ld	s0,8(sp)
     b48:	0141                	addi	sp,sp,16
     b4a:	8082                	ret
  return 0;
     b4c:	4501                	li	a0,0
     b4e:	bfe5                	j	b46 <memcmp+0x30>

0000000000000b50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b50:	1141                	addi	sp,sp,-16
     b52:	e406                	sd	ra,8(sp)
     b54:	e022                	sd	s0,0(sp)
     b56:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b58:	f67ff0ef          	jal	abe <memmove>
}
     b5c:	60a2                	ld	ra,8(sp)
     b5e:	6402                	ld	s0,0(sp)
     b60:	0141                	addi	sp,sp,16
     b62:	8082                	ret

0000000000000b64 <forkprio>:



.global forkprio
forkprio:
  li a7, SYS_forkprio
     b64:	48d9                	li	a7,22
  ecall
     b66:	00000073          	ecall
  ret
     b6a:	8082                	ret

0000000000000b6c <fork>:



.global fork
fork:
 li a7, SYS_fork
     b6c:	4885                	li	a7,1
 ecall
     b6e:	00000073          	ecall
 ret
     b72:	8082                	ret

0000000000000b74 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b74:	4889                	li	a7,2
 ecall
     b76:	00000073          	ecall
 ret
     b7a:	8082                	ret

0000000000000b7c <wait>:
.global wait
wait:
 li a7, SYS_wait
     b7c:	488d                	li	a7,3
 ecall
     b7e:	00000073          	ecall
 ret
     b82:	8082                	ret

0000000000000b84 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b84:	4891                	li	a7,4
 ecall
     b86:	00000073          	ecall
 ret
     b8a:	8082                	ret

0000000000000b8c <read>:
.global read
read:
 li a7, SYS_read
     b8c:	4895                	li	a7,5
 ecall
     b8e:	00000073          	ecall
 ret
     b92:	8082                	ret

0000000000000b94 <write>:
.global write
write:
 li a7, SYS_write
     b94:	48c1                	li	a7,16
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <close>:
.global close
close:
 li a7, SYS_close
     b9c:	48d5                	li	a7,21
 ecall
     b9e:	00000073          	ecall
 ret
     ba2:	8082                	ret

0000000000000ba4 <kill>:
.global kill
kill:
 li a7, SYS_kill
     ba4:	4899                	li	a7,6
 ecall
     ba6:	00000073          	ecall
 ret
     baa:	8082                	ret

0000000000000bac <exec>:
.global exec
exec:
 li a7, SYS_exec
     bac:	489d                	li	a7,7
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <open>:
.global open
open:
 li a7, SYS_open
     bb4:	48bd                	li	a7,15
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bbc:	48c5                	li	a7,17
 ecall
     bbe:	00000073          	ecall
 ret
     bc2:	8082                	ret

0000000000000bc4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bc4:	48c9                	li	a7,18
 ecall
     bc6:	00000073          	ecall
 ret
     bca:	8082                	ret

0000000000000bcc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bcc:	48a1                	li	a7,8
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <link>:
.global link
link:
 li a7, SYS_link
     bd4:	48cd                	li	a7,19
 ecall
     bd6:	00000073          	ecall
 ret
     bda:	8082                	ret

0000000000000bdc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bdc:	48d1                	li	a7,20
 ecall
     bde:	00000073          	ecall
 ret
     be2:	8082                	ret

0000000000000be4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     be4:	48a5                	li	a7,9
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <dup>:
.global dup
dup:
 li a7, SYS_dup
     bec:	48a9                	li	a7,10
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bf4:	48ad                	li	a7,11
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bfc:	48b1                	li	a7,12
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c04:	48b5                	li	a7,13
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c0c:	48b9                	li	a7,14
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c14:	1101                	addi	sp,sp,-32
     c16:	ec06                	sd	ra,24(sp)
     c18:	e822                	sd	s0,16(sp)
     c1a:	1000                	addi	s0,sp,32
     c1c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c20:	4605                	li	a2,1
     c22:	fef40593          	addi	a1,s0,-17
     c26:	f6fff0ef          	jal	b94 <write>
}
     c2a:	60e2                	ld	ra,24(sp)
     c2c:	6442                	ld	s0,16(sp)
     c2e:	6105                	addi	sp,sp,32
     c30:	8082                	ret

0000000000000c32 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c32:	7139                	addi	sp,sp,-64
     c34:	fc06                	sd	ra,56(sp)
     c36:	f822                	sd	s0,48(sp)
     c38:	f426                	sd	s1,40(sp)
     c3a:	0080                	addi	s0,sp,64
     c3c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c3e:	c299                	beqz	a3,c44 <printint+0x12>
     c40:	0805c963          	bltz	a1,cd2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c44:	2581                	sext.w	a1,a1
  neg = 0;
     c46:	4881                	li	a7,0
     c48:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c4c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c4e:	2601                	sext.w	a2,a2
     c50:	00001517          	auipc	a0,0x1
     c54:	86050513          	addi	a0,a0,-1952 # 14b0 <digits>
     c58:	883a                	mv	a6,a4
     c5a:	2705                	addiw	a4,a4,1
     c5c:	02c5f7bb          	remuw	a5,a1,a2
     c60:	1782                	slli	a5,a5,0x20
     c62:	9381                	srli	a5,a5,0x20
     c64:	97aa                	add	a5,a5,a0
     c66:	0007c783          	lbu	a5,0(a5)
     c6a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c6e:	0005879b          	sext.w	a5,a1
     c72:	02c5d5bb          	divuw	a1,a1,a2
     c76:	0685                	addi	a3,a3,1
     c78:	fec7f0e3          	bgeu	a5,a2,c58 <printint+0x26>
  if(neg)
     c7c:	00088c63          	beqz	a7,c94 <printint+0x62>
    buf[i++] = '-';
     c80:	fd070793          	addi	a5,a4,-48
     c84:	00878733          	add	a4,a5,s0
     c88:	02d00793          	li	a5,45
     c8c:	fef70823          	sb	a5,-16(a4)
     c90:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c94:	02e05a63          	blez	a4,cc8 <printint+0x96>
     c98:	f04a                	sd	s2,32(sp)
     c9a:	ec4e                	sd	s3,24(sp)
     c9c:	fc040793          	addi	a5,s0,-64
     ca0:	00e78933          	add	s2,a5,a4
     ca4:	fff78993          	addi	s3,a5,-1
     ca8:	99ba                	add	s3,s3,a4
     caa:	377d                	addiw	a4,a4,-1
     cac:	1702                	slli	a4,a4,0x20
     cae:	9301                	srli	a4,a4,0x20
     cb0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cb4:	fff94583          	lbu	a1,-1(s2)
     cb8:	8526                	mv	a0,s1
     cba:	f5bff0ef          	jal	c14 <putc>
  while(--i >= 0)
     cbe:	197d                	addi	s2,s2,-1
     cc0:	ff391ae3          	bne	s2,s3,cb4 <printint+0x82>
     cc4:	7902                	ld	s2,32(sp)
     cc6:	69e2                	ld	s3,24(sp)
}
     cc8:	70e2                	ld	ra,56(sp)
     cca:	7442                	ld	s0,48(sp)
     ccc:	74a2                	ld	s1,40(sp)
     cce:	6121                	addi	sp,sp,64
     cd0:	8082                	ret
    x = -xx;
     cd2:	40b005bb          	negw	a1,a1
    neg = 1;
     cd6:	4885                	li	a7,1
    x = -xx;
     cd8:	bf85                	j	c48 <printint+0x16>

0000000000000cda <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cda:	711d                	addi	sp,sp,-96
     cdc:	ec86                	sd	ra,88(sp)
     cde:	e8a2                	sd	s0,80(sp)
     ce0:	e0ca                	sd	s2,64(sp)
     ce2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ce4:	0005c903          	lbu	s2,0(a1)
     ce8:	26090863          	beqz	s2,f58 <vprintf+0x27e>
     cec:	e4a6                	sd	s1,72(sp)
     cee:	fc4e                	sd	s3,56(sp)
     cf0:	f852                	sd	s4,48(sp)
     cf2:	f456                	sd	s5,40(sp)
     cf4:	f05a                	sd	s6,32(sp)
     cf6:	ec5e                	sd	s7,24(sp)
     cf8:	e862                	sd	s8,16(sp)
     cfa:	e466                	sd	s9,8(sp)
     cfc:	8b2a                	mv	s6,a0
     cfe:	8a2e                	mv	s4,a1
     d00:	8bb2                	mv	s7,a2
  state = 0;
     d02:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d04:	4481                	li	s1,0
     d06:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d08:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d0c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d10:	06c00c93          	li	s9,108
     d14:	a005                	j	d34 <vprintf+0x5a>
        putc(fd, c0);
     d16:	85ca                	mv	a1,s2
     d18:	855a                	mv	a0,s6
     d1a:	efbff0ef          	jal	c14 <putc>
     d1e:	a019                	j	d24 <vprintf+0x4a>
    } else if(state == '%'){
     d20:	03598263          	beq	s3,s5,d44 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     d24:	2485                	addiw	s1,s1,1
     d26:	8726                	mv	a4,s1
     d28:	009a07b3          	add	a5,s4,s1
     d2c:	0007c903          	lbu	s2,0(a5)
     d30:	20090c63          	beqz	s2,f48 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     d34:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d38:	fe0994e3          	bnez	s3,d20 <vprintf+0x46>
      if(c0 == '%'){
     d3c:	fd579de3          	bne	a5,s5,d16 <vprintf+0x3c>
        state = '%';
     d40:	89be                	mv	s3,a5
     d42:	b7cd                	j	d24 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     d44:	00ea06b3          	add	a3,s4,a4
     d48:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     d4c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     d4e:	c681                	beqz	a3,d56 <vprintf+0x7c>
     d50:	9752                	add	a4,a4,s4
     d52:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     d56:	03878f63          	beq	a5,s8,d94 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     d5a:	05978963          	beq	a5,s9,dac <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d5e:	07500713          	li	a4,117
     d62:	0ee78363          	beq	a5,a4,e48 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     d66:	07800713          	li	a4,120
     d6a:	12e78563          	beq	a5,a4,e94 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     d6e:	07000713          	li	a4,112
     d72:	14e78a63          	beq	a5,a4,ec6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     d76:	07300713          	li	a4,115
     d7a:	18e78a63          	beq	a5,a4,f0e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     d7e:	02500713          	li	a4,37
     d82:	04e79563          	bne	a5,a4,dcc <vprintf+0xf2>
        putc(fd, '%');
     d86:	02500593          	li	a1,37
     d8a:	855a                	mv	a0,s6
     d8c:	e89ff0ef          	jal	c14 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     d90:	4981                	li	s3,0
     d92:	bf49                	j	d24 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     d94:	008b8913          	addi	s2,s7,8
     d98:	4685                	li	a3,1
     d9a:	4629                	li	a2,10
     d9c:	000ba583          	lw	a1,0(s7)
     da0:	855a                	mv	a0,s6
     da2:	e91ff0ef          	jal	c32 <printint>
     da6:	8bca                	mv	s7,s2
      state = 0;
     da8:	4981                	li	s3,0
     daa:	bfad                	j	d24 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     dac:	06400793          	li	a5,100
     db0:	02f68963          	beq	a3,a5,de2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     db4:	06c00793          	li	a5,108
     db8:	04f68263          	beq	a3,a5,dfc <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     dbc:	07500793          	li	a5,117
     dc0:	0af68063          	beq	a3,a5,e60 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     dc4:	07800793          	li	a5,120
     dc8:	0ef68263          	beq	a3,a5,eac <vprintf+0x1d2>
        putc(fd, '%');
     dcc:	02500593          	li	a1,37
     dd0:	855a                	mv	a0,s6
     dd2:	e43ff0ef          	jal	c14 <putc>
        putc(fd, c0);
     dd6:	85ca                	mv	a1,s2
     dd8:	855a                	mv	a0,s6
     dda:	e3bff0ef          	jal	c14 <putc>
      state = 0;
     dde:	4981                	li	s3,0
     de0:	b791                	j	d24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     de2:	008b8913          	addi	s2,s7,8
     de6:	4685                	li	a3,1
     de8:	4629                	li	a2,10
     dea:	000ba583          	lw	a1,0(s7)
     dee:	855a                	mv	a0,s6
     df0:	e43ff0ef          	jal	c32 <printint>
        i += 1;
     df4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     df6:	8bca                	mv	s7,s2
      state = 0;
     df8:	4981                	li	s3,0
        i += 1;
     dfa:	b72d                	j	d24 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     dfc:	06400793          	li	a5,100
     e00:	02f60763          	beq	a2,a5,e2e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e04:	07500793          	li	a5,117
     e08:	06f60963          	beq	a2,a5,e7a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e0c:	07800793          	li	a5,120
     e10:	faf61ee3          	bne	a2,a5,dcc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e14:	008b8913          	addi	s2,s7,8
     e18:	4681                	li	a3,0
     e1a:	4641                	li	a2,16
     e1c:	000ba583          	lw	a1,0(s7)
     e20:	855a                	mv	a0,s6
     e22:	e11ff0ef          	jal	c32 <printint>
        i += 2;
     e26:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e28:	8bca                	mv	s7,s2
      state = 0;
     e2a:	4981                	li	s3,0
        i += 2;
     e2c:	bde5                	j	d24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e2e:	008b8913          	addi	s2,s7,8
     e32:	4685                	li	a3,1
     e34:	4629                	li	a2,10
     e36:	000ba583          	lw	a1,0(s7)
     e3a:	855a                	mv	a0,s6
     e3c:	df7ff0ef          	jal	c32 <printint>
        i += 2;
     e40:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e42:	8bca                	mv	s7,s2
      state = 0;
     e44:	4981                	li	s3,0
        i += 2;
     e46:	bdf9                	j	d24 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     e48:	008b8913          	addi	s2,s7,8
     e4c:	4681                	li	a3,0
     e4e:	4629                	li	a2,10
     e50:	000ba583          	lw	a1,0(s7)
     e54:	855a                	mv	a0,s6
     e56:	dddff0ef          	jal	c32 <printint>
     e5a:	8bca                	mv	s7,s2
      state = 0;
     e5c:	4981                	li	s3,0
     e5e:	b5d9                	j	d24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e60:	008b8913          	addi	s2,s7,8
     e64:	4681                	li	a3,0
     e66:	4629                	li	a2,10
     e68:	000ba583          	lw	a1,0(s7)
     e6c:	855a                	mv	a0,s6
     e6e:	dc5ff0ef          	jal	c32 <printint>
        i += 1;
     e72:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     e74:	8bca                	mv	s7,s2
      state = 0;
     e76:	4981                	li	s3,0
        i += 1;
     e78:	b575                	j	d24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e7a:	008b8913          	addi	s2,s7,8
     e7e:	4681                	li	a3,0
     e80:	4629                	li	a2,10
     e82:	000ba583          	lw	a1,0(s7)
     e86:	855a                	mv	a0,s6
     e88:	dabff0ef          	jal	c32 <printint>
        i += 2;
     e8c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     e8e:	8bca                	mv	s7,s2
      state = 0;
     e90:	4981                	li	s3,0
        i += 2;
     e92:	bd49                	j	d24 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     e94:	008b8913          	addi	s2,s7,8
     e98:	4681                	li	a3,0
     e9a:	4641                	li	a2,16
     e9c:	000ba583          	lw	a1,0(s7)
     ea0:	855a                	mv	a0,s6
     ea2:	d91ff0ef          	jal	c32 <printint>
     ea6:	8bca                	mv	s7,s2
      state = 0;
     ea8:	4981                	li	s3,0
     eaa:	bdad                	j	d24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     eac:	008b8913          	addi	s2,s7,8
     eb0:	4681                	li	a3,0
     eb2:	4641                	li	a2,16
     eb4:	000ba583          	lw	a1,0(s7)
     eb8:	855a                	mv	a0,s6
     eba:	d79ff0ef          	jal	c32 <printint>
        i += 1;
     ebe:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     ec0:	8bca                	mv	s7,s2
      state = 0;
     ec2:	4981                	li	s3,0
        i += 1;
     ec4:	b585                	j	d24 <vprintf+0x4a>
     ec6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     ec8:	008b8d13          	addi	s10,s7,8
     ecc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     ed0:	03000593          	li	a1,48
     ed4:	855a                	mv	a0,s6
     ed6:	d3fff0ef          	jal	c14 <putc>
  putc(fd, 'x');
     eda:	07800593          	li	a1,120
     ede:	855a                	mv	a0,s6
     ee0:	d35ff0ef          	jal	c14 <putc>
     ee4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ee6:	00000b97          	auipc	s7,0x0
     eea:	5cab8b93          	addi	s7,s7,1482 # 14b0 <digits>
     eee:	03c9d793          	srli	a5,s3,0x3c
     ef2:	97de                	add	a5,a5,s7
     ef4:	0007c583          	lbu	a1,0(a5)
     ef8:	855a                	mv	a0,s6
     efa:	d1bff0ef          	jal	c14 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     efe:	0992                	slli	s3,s3,0x4
     f00:	397d                	addiw	s2,s2,-1
     f02:	fe0916e3          	bnez	s2,eee <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
     f06:	8bea                	mv	s7,s10
      state = 0;
     f08:	4981                	li	s3,0
     f0a:	6d02                	ld	s10,0(sp)
     f0c:	bd21                	j	d24 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
     f0e:	008b8993          	addi	s3,s7,8
     f12:	000bb903          	ld	s2,0(s7)
     f16:	00090f63          	beqz	s2,f34 <vprintf+0x25a>
        for(; *s; s++)
     f1a:	00094583          	lbu	a1,0(s2)
     f1e:	c195                	beqz	a1,f42 <vprintf+0x268>
          putc(fd, *s);
     f20:	855a                	mv	a0,s6
     f22:	cf3ff0ef          	jal	c14 <putc>
        for(; *s; s++)
     f26:	0905                	addi	s2,s2,1
     f28:	00094583          	lbu	a1,0(s2)
     f2c:	f9f5                	bnez	a1,f20 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     f2e:	8bce                	mv	s7,s3
      state = 0;
     f30:	4981                	li	s3,0
     f32:	bbcd                	j	d24 <vprintf+0x4a>
          s = "(null)";
     f34:	00000917          	auipc	s2,0x0
     f38:	51490913          	addi	s2,s2,1300 # 1448 <malloc+0x408>
        for(; *s; s++)
     f3c:	02800593          	li	a1,40
     f40:	b7c5                	j	f20 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     f42:	8bce                	mv	s7,s3
      state = 0;
     f44:	4981                	li	s3,0
     f46:	bbf9                	j	d24 <vprintf+0x4a>
     f48:	64a6                	ld	s1,72(sp)
     f4a:	79e2                	ld	s3,56(sp)
     f4c:	7a42                	ld	s4,48(sp)
     f4e:	7aa2                	ld	s5,40(sp)
     f50:	7b02                	ld	s6,32(sp)
     f52:	6be2                	ld	s7,24(sp)
     f54:	6c42                	ld	s8,16(sp)
     f56:	6ca2                	ld	s9,8(sp)
    }
  }
}
     f58:	60e6                	ld	ra,88(sp)
     f5a:	6446                	ld	s0,80(sp)
     f5c:	6906                	ld	s2,64(sp)
     f5e:	6125                	addi	sp,sp,96
     f60:	8082                	ret

0000000000000f62 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f62:	715d                	addi	sp,sp,-80
     f64:	ec06                	sd	ra,24(sp)
     f66:	e822                	sd	s0,16(sp)
     f68:	1000                	addi	s0,sp,32
     f6a:	e010                	sd	a2,0(s0)
     f6c:	e414                	sd	a3,8(s0)
     f6e:	e818                	sd	a4,16(s0)
     f70:	ec1c                	sd	a5,24(s0)
     f72:	03043023          	sd	a6,32(s0)
     f76:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f7a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f7e:	8622                	mv	a2,s0
     f80:	d5bff0ef          	jal	cda <vprintf>
}
     f84:	60e2                	ld	ra,24(sp)
     f86:	6442                	ld	s0,16(sp)
     f88:	6161                	addi	sp,sp,80
     f8a:	8082                	ret

0000000000000f8c <printf>:

void
printf(const char *fmt, ...)
{
     f8c:	711d                	addi	sp,sp,-96
     f8e:	ec06                	sd	ra,24(sp)
     f90:	e822                	sd	s0,16(sp)
     f92:	1000                	addi	s0,sp,32
     f94:	e40c                	sd	a1,8(s0)
     f96:	e810                	sd	a2,16(s0)
     f98:	ec14                	sd	a3,24(s0)
     f9a:	f018                	sd	a4,32(s0)
     f9c:	f41c                	sd	a5,40(s0)
     f9e:	03043823          	sd	a6,48(s0)
     fa2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     fa6:	00840613          	addi	a2,s0,8
     faa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     fae:	85aa                	mv	a1,a0
     fb0:	4505                	li	a0,1
     fb2:	d29ff0ef          	jal	cda <vprintf>
}
     fb6:	60e2                	ld	ra,24(sp)
     fb8:	6442                	ld	s0,16(sp)
     fba:	6125                	addi	sp,sp,96
     fbc:	8082                	ret

0000000000000fbe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     fbe:	1141                	addi	sp,sp,-16
     fc0:	e422                	sd	s0,8(sp)
     fc2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     fc4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fc8:	00001797          	auipc	a5,0x1
     fcc:	0487b783          	ld	a5,72(a5) # 2010 <freep>
     fd0:	a02d                	j	ffa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     fd2:	4618                	lw	a4,8(a2)
     fd4:	9f2d                	addw	a4,a4,a1
     fd6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     fda:	6398                	ld	a4,0(a5)
     fdc:	6310                	ld	a2,0(a4)
     fde:	a83d                	j	101c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     fe0:	ff852703          	lw	a4,-8(a0)
     fe4:	9f31                	addw	a4,a4,a2
     fe6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     fe8:	ff053683          	ld	a3,-16(a0)
     fec:	a091                	j	1030 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fee:	6398                	ld	a4,0(a5)
     ff0:	00e7e463          	bltu	a5,a4,ff8 <free+0x3a>
     ff4:	00e6ea63          	bltu	a3,a4,1008 <free+0x4a>
{
     ff8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ffa:	fed7fae3          	bgeu	a5,a3,fee <free+0x30>
     ffe:	6398                	ld	a4,0(a5)
    1000:	00e6e463          	bltu	a3,a4,1008 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1004:	fee7eae3          	bltu	a5,a4,ff8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1008:	ff852583          	lw	a1,-8(a0)
    100c:	6390                	ld	a2,0(a5)
    100e:	02059813          	slli	a6,a1,0x20
    1012:	01c85713          	srli	a4,a6,0x1c
    1016:	9736                	add	a4,a4,a3
    1018:	fae60de3          	beq	a2,a4,fd2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    101c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1020:	4790                	lw	a2,8(a5)
    1022:	02061593          	slli	a1,a2,0x20
    1026:	01c5d713          	srli	a4,a1,0x1c
    102a:	973e                	add	a4,a4,a5
    102c:	fae68ae3          	beq	a3,a4,fe0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1030:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1032:	00001717          	auipc	a4,0x1
    1036:	fcf73f23          	sd	a5,-34(a4) # 2010 <freep>
}
    103a:	6422                	ld	s0,8(sp)
    103c:	0141                	addi	sp,sp,16
    103e:	8082                	ret

0000000000001040 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1040:	7139                	addi	sp,sp,-64
    1042:	fc06                	sd	ra,56(sp)
    1044:	f822                	sd	s0,48(sp)
    1046:	f426                	sd	s1,40(sp)
    1048:	ec4e                	sd	s3,24(sp)
    104a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    104c:	02051493          	slli	s1,a0,0x20
    1050:	9081                	srli	s1,s1,0x20
    1052:	04bd                	addi	s1,s1,15
    1054:	8091                	srli	s1,s1,0x4
    1056:	0014899b          	addiw	s3,s1,1
    105a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    105c:	00001517          	auipc	a0,0x1
    1060:	fb453503          	ld	a0,-76(a0) # 2010 <freep>
    1064:	c915                	beqz	a0,1098 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1066:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1068:	4798                	lw	a4,8(a5)
    106a:	08977a63          	bgeu	a4,s1,10fe <malloc+0xbe>
    106e:	f04a                	sd	s2,32(sp)
    1070:	e852                	sd	s4,16(sp)
    1072:	e456                	sd	s5,8(sp)
    1074:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1076:	8a4e                	mv	s4,s3
    1078:	0009871b          	sext.w	a4,s3
    107c:	6685                	lui	a3,0x1
    107e:	00d77363          	bgeu	a4,a3,1084 <malloc+0x44>
    1082:	6a05                	lui	s4,0x1
    1084:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1088:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    108c:	00001917          	auipc	s2,0x1
    1090:	f8490913          	addi	s2,s2,-124 # 2010 <freep>
  if(p == (char*)-1)
    1094:	5afd                	li	s5,-1
    1096:	a081                	j	10d6 <malloc+0x96>
    1098:	f04a                	sd	s2,32(sp)
    109a:	e852                	sd	s4,16(sp)
    109c:	e456                	sd	s5,8(sp)
    109e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    10a0:	00001797          	auipc	a5,0x1
    10a4:	36878793          	addi	a5,a5,872 # 2408 <base>
    10a8:	00001717          	auipc	a4,0x1
    10ac:	f6f73423          	sd	a5,-152(a4) # 2010 <freep>
    10b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    10b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    10b6:	b7c1                	j	1076 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    10b8:	6398                	ld	a4,0(a5)
    10ba:	e118                	sd	a4,0(a0)
    10bc:	a8a9                	j	1116 <malloc+0xd6>
  hp->s.size = nu;
    10be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    10c2:	0541                	addi	a0,a0,16
    10c4:	efbff0ef          	jal	fbe <free>
  return freep;
    10c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    10cc:	c12d                	beqz	a0,112e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10d0:	4798                	lw	a4,8(a5)
    10d2:	02977263          	bgeu	a4,s1,10f6 <malloc+0xb6>
    if(p == freep)
    10d6:	00093703          	ld	a4,0(s2)
    10da:	853e                	mv	a0,a5
    10dc:	fef719e3          	bne	a4,a5,10ce <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    10e0:	8552                	mv	a0,s4
    10e2:	b1bff0ef          	jal	bfc <sbrk>
  if(p == (char*)-1)
    10e6:	fd551ce3          	bne	a0,s5,10be <malloc+0x7e>
        return 0;
    10ea:	4501                	li	a0,0
    10ec:	7902                	ld	s2,32(sp)
    10ee:	6a42                	ld	s4,16(sp)
    10f0:	6aa2                	ld	s5,8(sp)
    10f2:	6b02                	ld	s6,0(sp)
    10f4:	a03d                	j	1122 <malloc+0xe2>
    10f6:	7902                	ld	s2,32(sp)
    10f8:	6a42                	ld	s4,16(sp)
    10fa:	6aa2                	ld	s5,8(sp)
    10fc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    10fe:	fae48de3          	beq	s1,a4,10b8 <malloc+0x78>
        p->s.size -= nunits;
    1102:	4137073b          	subw	a4,a4,s3
    1106:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1108:	02071693          	slli	a3,a4,0x20
    110c:	01c6d713          	srli	a4,a3,0x1c
    1110:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1112:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1116:	00001717          	auipc	a4,0x1
    111a:	eea73d23          	sd	a0,-262(a4) # 2010 <freep>
      return (void*)(p + 1);
    111e:	01078513          	addi	a0,a5,16
  }
}
    1122:	70e2                	ld	ra,56(sp)
    1124:	7442                	ld	s0,48(sp)
    1126:	74a2                	ld	s1,40(sp)
    1128:	69e2                	ld	s3,24(sp)
    112a:	6121                	addi	sp,sp,64
    112c:	8082                	ret
    112e:	7902                	ld	s2,32(sp)
    1130:	6a42                	ld	s4,16(sp)
    1132:	6aa2                	ld	s5,8(sp)
    1134:	6b02                	ld	s6,0(sp)
    1136:	b7f5                	j	1122 <malloc+0xe2>
