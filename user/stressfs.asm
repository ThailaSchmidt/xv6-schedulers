
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	92a78793          	addi	a5,a5,-1750 # 940 <malloc+0x128>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	8e450513          	addi	a0,a0,-1820 # 910 <malloc+0xf8>
  34:	730000ef          	jal	764 <printf>
  memset(data, 'a', sizeof(data));
  38:	20000613          	li	a2,512
  3c:	06100593          	li	a1,97
  40:	dd040513          	addi	a0,s0,-560
  44:	11a000ef          	jal	15e <memset>

  for(i = 0; i < 4; i++)
  48:	4481                	li	s1,0
  4a:	4911                	li	s2,4
    if(fork(1) > 0)
  4c:	4505                	li	a0,1
  4e:	2f6000ef          	jal	344 <fork>
  52:	00a04563          	bgtz	a0,5c <main+0x5c>
  for(i = 0; i < 4; i++)
  56:	2485                	addiw	s1,s1,1
  58:	ff249ae3          	bne	s1,s2,4c <main+0x4c>
      break;

  printf("write %d\n", i);
  5c:	85a6                	mv	a1,s1
  5e:	00001517          	auipc	a0,0x1
  62:	8ca50513          	addi	a0,a0,-1846 # 928 <malloc+0x110>
  66:	6fe000ef          	jal	764 <printf>

  path[8] += i;
  6a:	fd844783          	lbu	a5,-40(s0)
  6e:	9fa5                	addw	a5,a5,s1
  70:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  74:	20200593          	li	a1,514
  78:	fd040513          	addi	a0,s0,-48
  7c:	310000ef          	jal	38c <open>
  80:	892a                	mv	s2,a0
  82:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  84:	20000613          	li	a2,512
  88:	dd040593          	addi	a1,s0,-560
  8c:	854a                	mv	a0,s2
  8e:	2de000ef          	jal	36c <write>
  for(i = 0; i < 20; i++)
  92:	34fd                	addiw	s1,s1,-1
  94:	f8e5                	bnez	s1,84 <main+0x84>
  close(fd);
  96:	854a                	mv	a0,s2
  98:	2dc000ef          	jal	374 <close>

  printf("read\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	89c50513          	addi	a0,a0,-1892 # 938 <malloc+0x120>
  a4:	6c0000ef          	jal	764 <printf>

  fd = open(path, O_RDONLY);
  a8:	4581                	li	a1,0
  aa:	fd040513          	addi	a0,s0,-48
  ae:	2de000ef          	jal	38c <open>
  b2:	892a                	mv	s2,a0
  b4:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  b6:	20000613          	li	a2,512
  ba:	dd040593          	addi	a1,s0,-560
  be:	854a                	mv	a0,s2
  c0:	2a4000ef          	jal	364 <read>
  for (i = 0; i < 20; i++)
  c4:	34fd                	addiw	s1,s1,-1
  c6:	f8e5                	bnez	s1,b6 <main+0xb6>
  close(fd);
  c8:	854a                	mv	a0,s2
  ca:	2aa000ef          	jal	374 <close>

  wait(0);
  ce:	4501                	li	a0,0
  d0:	284000ef          	jal	354 <wait>

  exit(0);
  d4:	4501                	li	a0,0
  d6:	276000ef          	jal	34c <exit>

00000000000000da <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  extern int main();
  main();
  e2:	f1fff0ef          	jal	0 <main>
  exit(0);
  e6:	4501                	li	a0,0
  e8:	264000ef          	jal	34c <exit>

00000000000000ec <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e422                	sd	s0,8(sp)
  f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f2:	87aa                	mv	a5,a0
  f4:	0585                	addi	a1,a1,1
  f6:	0785                	addi	a5,a5,1
  f8:	fff5c703          	lbu	a4,-1(a1)
  fc:	fee78fa3          	sb	a4,-1(a5)
 100:	fb75                	bnez	a4,f4 <strcpy+0x8>
    ;
  return os;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10e:	00054783          	lbu	a5,0(a0)
 112:	cb91                	beqz	a5,126 <strcmp+0x1e>
 114:	0005c703          	lbu	a4,0(a1)
 118:	00f71763          	bne	a4,a5,126 <strcmp+0x1e>
    p++, q++;
 11c:	0505                	addi	a0,a0,1
 11e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	fbe5                	bnez	a5,114 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 126:	0005c503          	lbu	a0,0(a1)
}
 12a:	40a7853b          	subw	a0,a5,a0
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strlen>:

uint
strlen(const char *s)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cf91                	beqz	a5,15a <strlen+0x26>
 140:	0505                	addi	a0,a0,1
 142:	87aa                	mv	a5,a0
 144:	86be                	mv	a3,a5
 146:	0785                	addi	a5,a5,1
 148:	fff7c703          	lbu	a4,-1(a5)
 14c:	ff65                	bnez	a4,144 <strlen+0x10>
 14e:	40a6853b          	subw	a0,a3,a0
 152:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret
  for(n = 0; s[n]; n++)
 15a:	4501                	li	a0,0
 15c:	bfe5                	j	154 <strlen+0x20>

000000000000015e <memset>:

void*
memset(void *dst, int c, uint n)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 164:	ca19                	beqz	a2,17a <memset+0x1c>
 166:	87aa                	mv	a5,a0
 168:	1602                	slli	a2,a2,0x20
 16a:	9201                	srli	a2,a2,0x20
 16c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 170:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 174:	0785                	addi	a5,a5,1
 176:	fee79de3          	bne	a5,a4,170 <memset+0x12>
  }
  return dst;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

0000000000000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  for(; *s; s++)
 186:	00054783          	lbu	a5,0(a0)
 18a:	cb99                	beqz	a5,1a0 <strchr+0x20>
    if(*s == c)
 18c:	00f58763          	beq	a1,a5,19a <strchr+0x1a>
  for(; *s; s++)
 190:	0505                	addi	a0,a0,1
 192:	00054783          	lbu	a5,0(a0)
 196:	fbfd                	bnez	a5,18c <strchr+0xc>
      return (char*)s;
  return 0;
 198:	4501                	li	a0,0
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret
  return 0;
 1a0:	4501                	li	a0,0
 1a2:	bfe5                	j	19a <strchr+0x1a>

00000000000001a4 <gets>:

char*
gets(char *buf, int max)
{
 1a4:	711d                	addi	sp,sp,-96
 1a6:	ec86                	sd	ra,88(sp)
 1a8:	e8a2                	sd	s0,80(sp)
 1aa:	e4a6                	sd	s1,72(sp)
 1ac:	e0ca                	sd	s2,64(sp)
 1ae:	fc4e                	sd	s3,56(sp)
 1b0:	f852                	sd	s4,48(sp)
 1b2:	f456                	sd	s5,40(sp)
 1b4:	f05a                	sd	s6,32(sp)
 1b6:	ec5e                	sd	s7,24(sp)
 1b8:	1080                	addi	s0,sp,96
 1ba:	8baa                	mv	s7,a0
 1bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	892a                	mv	s2,a0
 1c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c2:	4aa9                	li	s5,10
 1c4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c6:	89a6                	mv	s3,s1
 1c8:	2485                	addiw	s1,s1,1
 1ca:	0344d663          	bge	s1,s4,1f6 <gets+0x52>
    cc = read(0, &c, 1);
 1ce:	4605                	li	a2,1
 1d0:	faf40593          	addi	a1,s0,-81
 1d4:	4501                	li	a0,0
 1d6:	18e000ef          	jal	364 <read>
    if(cc < 1)
 1da:	00a05e63          	blez	a0,1f6 <gets+0x52>
    buf[i++] = c;
 1de:	faf44783          	lbu	a5,-81(s0)
 1e2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e6:	01578763          	beq	a5,s5,1f4 <gets+0x50>
 1ea:	0905                	addi	s2,s2,1
 1ec:	fd679de3          	bne	a5,s6,1c6 <gets+0x22>
    buf[i++] = c;
 1f0:	89a6                	mv	s3,s1
 1f2:	a011                	j	1f6 <gets+0x52>
 1f4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f6:	99de                	add	s3,s3,s7
 1f8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1fc:	855e                	mv	a0,s7
 1fe:	60e6                	ld	ra,88(sp)
 200:	6446                	ld	s0,80(sp)
 202:	64a6                	ld	s1,72(sp)
 204:	6906                	ld	s2,64(sp)
 206:	79e2                	ld	s3,56(sp)
 208:	7a42                	ld	s4,48(sp)
 20a:	7aa2                	ld	s5,40(sp)
 20c:	7b02                	ld	s6,32(sp)
 20e:	6be2                	ld	s7,24(sp)
 210:	6125                	addi	sp,sp,96
 212:	8082                	ret

0000000000000214 <stat>:

int
stat(const char *n, struct stat *st)
{
 214:	1101                	addi	sp,sp,-32
 216:	ec06                	sd	ra,24(sp)
 218:	e822                	sd	s0,16(sp)
 21a:	e04a                	sd	s2,0(sp)
 21c:	1000                	addi	s0,sp,32
 21e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 220:	4581                	li	a1,0
 222:	16a000ef          	jal	38c <open>
  if(fd < 0)
 226:	02054263          	bltz	a0,24a <stat+0x36>
 22a:	e426                	sd	s1,8(sp)
 22c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22e:	85ca                	mv	a1,s2
 230:	174000ef          	jal	3a4 <fstat>
 234:	892a                	mv	s2,a0
  close(fd);
 236:	8526                	mv	a0,s1
 238:	13c000ef          	jal	374 <close>
  return r;
 23c:	64a2                	ld	s1,8(sp)
}
 23e:	854a                	mv	a0,s2
 240:	60e2                	ld	ra,24(sp)
 242:	6442                	ld	s0,16(sp)
 244:	6902                	ld	s2,0(sp)
 246:	6105                	addi	sp,sp,32
 248:	8082                	ret
    return -1;
 24a:	597d                	li	s2,-1
 24c:	bfcd                	j	23e <stat+0x2a>

000000000000024e <atoi>:

int
atoi(const char *s)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 254:	00054683          	lbu	a3,0(a0)
 258:	fd06879b          	addiw	a5,a3,-48
 25c:	0ff7f793          	zext.b	a5,a5
 260:	4625                	li	a2,9
 262:	02f66863          	bltu	a2,a5,292 <atoi+0x44>
 266:	872a                	mv	a4,a0
  n = 0;
 268:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 26a:	0705                	addi	a4,a4,1
 26c:	0025179b          	slliw	a5,a0,0x2
 270:	9fa9                	addw	a5,a5,a0
 272:	0017979b          	slliw	a5,a5,0x1
 276:	9fb5                	addw	a5,a5,a3
 278:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27c:	00074683          	lbu	a3,0(a4)
 280:	fd06879b          	addiw	a5,a3,-48
 284:	0ff7f793          	zext.b	a5,a5
 288:	fef671e3          	bgeu	a2,a5,26a <atoi+0x1c>
  return n;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret
  n = 0;
 292:	4501                	li	a0,0
 294:	bfe5                	j	28c <atoi+0x3e>

0000000000000296 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29c:	02b57463          	bgeu	a0,a1,2c4 <memmove+0x2e>
    while(n-- > 0)
 2a0:	00c05f63          	blez	a2,2be <memmove+0x28>
 2a4:	1602                	slli	a2,a2,0x20
 2a6:	9201                	srli	a2,a2,0x20
 2a8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ae:	0585                	addi	a1,a1,1
 2b0:	0705                	addi	a4,a4,1
 2b2:	fff5c683          	lbu	a3,-1(a1)
 2b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ba:	fef71ae3          	bne	a4,a5,2ae <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
    dst += n;
 2c4:	00c50733          	add	a4,a0,a2
    src += n;
 2c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ca:	fec05ae3          	blez	a2,2be <memmove+0x28>
 2ce:	fff6079b          	addiw	a5,a2,-1
 2d2:	1782                	slli	a5,a5,0x20
 2d4:	9381                	srli	a5,a5,0x20
 2d6:	fff7c793          	not	a5,a5
 2da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2dc:	15fd                	addi	a1,a1,-1
 2de:	177d                	addi	a4,a4,-1
 2e0:	0005c683          	lbu	a3,0(a1)
 2e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e8:	fee79ae3          	bne	a5,a4,2dc <memmove+0x46>
 2ec:	bfc9                	j	2be <memmove+0x28>

00000000000002ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f4:	ca05                	beqz	a2,324 <memcmp+0x36>
 2f6:	fff6069b          	addiw	a3,a2,-1
 2fa:	1682                	slli	a3,a3,0x20
 2fc:	9281                	srli	a3,a3,0x20
 2fe:	0685                	addi	a3,a3,1
 300:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 302:	00054783          	lbu	a5,0(a0)
 306:	0005c703          	lbu	a4,0(a1)
 30a:	00e79863          	bne	a5,a4,31a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 30e:	0505                	addi	a0,a0,1
    p2++;
 310:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 312:	fed518e3          	bne	a0,a3,302 <memcmp+0x14>
  }
  return 0;
 316:	4501                	li	a0,0
 318:	a019                	j	31e <memcmp+0x30>
      return *p1 - *p2;
 31a:	40e7853b          	subw	a0,a5,a4
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
  return 0;
 324:	4501                	li	a0,0
 326:	bfe5                	j	31e <memcmp+0x30>

0000000000000328 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e406                	sd	ra,8(sp)
 32c:	e022                	sd	s0,0(sp)
 32e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 330:	f67ff0ef          	jal	296 <memmove>
}
 334:	60a2                	ld	ra,8(sp)
 336:	6402                	ld	s0,0(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret

000000000000033c <forkprio>:



.global forkprio
forkprio:
  li a7, SYS_forkprio
 33c:	48d9                	li	a7,22
  ecall
 33e:	00000073          	ecall
  ret
 342:	8082                	ret

0000000000000344 <fork>:



.global fork
fork:
 li a7, SYS_fork
 344:	4885                	li	a7,1
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exit>:
.global exit
exit:
 li a7, SYS_exit
 34c:	4889                	li	a7,2
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <wait>:
.global wait
wait:
 li a7, SYS_wait
 354:	488d                	li	a7,3
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35c:	4891                	li	a7,4
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <read>:
.global read
read:
 li a7, SYS_read
 364:	4895                	li	a7,5
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <write>:
.global write
write:
 li a7, SYS_write
 36c:	48c1                	li	a7,16
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <close>:
.global close
close:
 li a7, SYS_close
 374:	48d5                	li	a7,21
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <kill>:
.global kill
kill:
 li a7, SYS_kill
 37c:	4899                	li	a7,6
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <exec>:
.global exec
exec:
 li a7, SYS_exec
 384:	489d                	li	a7,7
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <open>:
.global open
open:
 li a7, SYS_open
 38c:	48bd                	li	a7,15
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 394:	48c5                	li	a7,17
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39c:	48c9                	li	a7,18
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a4:	48a1                	li	a7,8
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <link>:
.global link
link:
 li a7, SYS_link
 3ac:	48cd                	li	a7,19
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b4:	48d1                	li	a7,20
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3bc:	48a5                	li	a7,9
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c4:	48a9                	li	a7,10
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3cc:	48ad                	li	a7,11
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d4:	48b1                	li	a7,12
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3dc:	48b5                	li	a7,13
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e4:	48b9                	li	a7,14
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ec:	1101                	addi	sp,sp,-32
 3ee:	ec06                	sd	ra,24(sp)
 3f0:	e822                	sd	s0,16(sp)
 3f2:	1000                	addi	s0,sp,32
 3f4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f8:	4605                	li	a2,1
 3fa:	fef40593          	addi	a1,s0,-17
 3fe:	f6fff0ef          	jal	36c <write>
}
 402:	60e2                	ld	ra,24(sp)
 404:	6442                	ld	s0,16(sp)
 406:	6105                	addi	sp,sp,32
 408:	8082                	ret

000000000000040a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40a:	7139                	addi	sp,sp,-64
 40c:	fc06                	sd	ra,56(sp)
 40e:	f822                	sd	s0,48(sp)
 410:	f426                	sd	s1,40(sp)
 412:	0080                	addi	s0,sp,64
 414:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 416:	c299                	beqz	a3,41c <printint+0x12>
 418:	0805c963          	bltz	a1,4aa <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 41c:	2581                	sext.w	a1,a1
  neg = 0;
 41e:	4881                	li	a7,0
 420:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 424:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 426:	2601                	sext.w	a2,a2
 428:	00000517          	auipc	a0,0x0
 42c:	53050513          	addi	a0,a0,1328 # 958 <digits>
 430:	883a                	mv	a6,a4
 432:	2705                	addiw	a4,a4,1
 434:	02c5f7bb          	remuw	a5,a1,a2
 438:	1782                	slli	a5,a5,0x20
 43a:	9381                	srli	a5,a5,0x20
 43c:	97aa                	add	a5,a5,a0
 43e:	0007c783          	lbu	a5,0(a5)
 442:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 446:	0005879b          	sext.w	a5,a1
 44a:	02c5d5bb          	divuw	a1,a1,a2
 44e:	0685                	addi	a3,a3,1
 450:	fec7f0e3          	bgeu	a5,a2,430 <printint+0x26>
  if(neg)
 454:	00088c63          	beqz	a7,46c <printint+0x62>
    buf[i++] = '-';
 458:	fd070793          	addi	a5,a4,-48
 45c:	00878733          	add	a4,a5,s0
 460:	02d00793          	li	a5,45
 464:	fef70823          	sb	a5,-16(a4)
 468:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 46c:	02e05a63          	blez	a4,4a0 <printint+0x96>
 470:	f04a                	sd	s2,32(sp)
 472:	ec4e                	sd	s3,24(sp)
 474:	fc040793          	addi	a5,s0,-64
 478:	00e78933          	add	s2,a5,a4
 47c:	fff78993          	addi	s3,a5,-1
 480:	99ba                	add	s3,s3,a4
 482:	377d                	addiw	a4,a4,-1
 484:	1702                	slli	a4,a4,0x20
 486:	9301                	srli	a4,a4,0x20
 488:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48c:	fff94583          	lbu	a1,-1(s2)
 490:	8526                	mv	a0,s1
 492:	f5bff0ef          	jal	3ec <putc>
  while(--i >= 0)
 496:	197d                	addi	s2,s2,-1
 498:	ff391ae3          	bne	s2,s3,48c <printint+0x82>
 49c:	7902                	ld	s2,32(sp)
 49e:	69e2                	ld	s3,24(sp)
}
 4a0:	70e2                	ld	ra,56(sp)
 4a2:	7442                	ld	s0,48(sp)
 4a4:	74a2                	ld	s1,40(sp)
 4a6:	6121                	addi	sp,sp,64
 4a8:	8082                	ret
    x = -xx;
 4aa:	40b005bb          	negw	a1,a1
    neg = 1;
 4ae:	4885                	li	a7,1
    x = -xx;
 4b0:	bf85                	j	420 <printint+0x16>

00000000000004b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b2:	711d                	addi	sp,sp,-96
 4b4:	ec86                	sd	ra,88(sp)
 4b6:	e8a2                	sd	s0,80(sp)
 4b8:	e0ca                	sd	s2,64(sp)
 4ba:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4bc:	0005c903          	lbu	s2,0(a1)
 4c0:	26090863          	beqz	s2,730 <vprintf+0x27e>
 4c4:	e4a6                	sd	s1,72(sp)
 4c6:	fc4e                	sd	s3,56(sp)
 4c8:	f852                	sd	s4,48(sp)
 4ca:	f456                	sd	s5,40(sp)
 4cc:	f05a                	sd	s6,32(sp)
 4ce:	ec5e                	sd	s7,24(sp)
 4d0:	e862                	sd	s8,16(sp)
 4d2:	e466                	sd	s9,8(sp)
 4d4:	8b2a                	mv	s6,a0
 4d6:	8a2e                	mv	s4,a1
 4d8:	8bb2                	mv	s7,a2
  state = 0;
 4da:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4dc:	4481                	li	s1,0
 4de:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e8:	06c00c93          	li	s9,108
 4ec:	a005                	j	50c <vprintf+0x5a>
        putc(fd, c0);
 4ee:	85ca                	mv	a1,s2
 4f0:	855a                	mv	a0,s6
 4f2:	efbff0ef          	jal	3ec <putc>
 4f6:	a019                	j	4fc <vprintf+0x4a>
    } else if(state == '%'){
 4f8:	03598263          	beq	s3,s5,51c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4fc:	2485                	addiw	s1,s1,1
 4fe:	8726                	mv	a4,s1
 500:	009a07b3          	add	a5,s4,s1
 504:	0007c903          	lbu	s2,0(a5)
 508:	20090c63          	beqz	s2,720 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 50c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 510:	fe0994e3          	bnez	s3,4f8 <vprintf+0x46>
      if(c0 == '%'){
 514:	fd579de3          	bne	a5,s5,4ee <vprintf+0x3c>
        state = '%';
 518:	89be                	mv	s3,a5
 51a:	b7cd                	j	4fc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 51c:	00ea06b3          	add	a3,s4,a4
 520:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 524:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 526:	c681                	beqz	a3,52e <vprintf+0x7c>
 528:	9752                	add	a4,a4,s4
 52a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 52e:	03878f63          	beq	a5,s8,56c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 532:	05978963          	beq	a5,s9,584 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 536:	07500713          	li	a4,117
 53a:	0ee78363          	beq	a5,a4,620 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 53e:	07800713          	li	a4,120
 542:	12e78563          	beq	a5,a4,66c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 546:	07000713          	li	a4,112
 54a:	14e78a63          	beq	a5,a4,69e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 54e:	07300713          	li	a4,115
 552:	18e78a63          	beq	a5,a4,6e6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 556:	02500713          	li	a4,37
 55a:	04e79563          	bne	a5,a4,5a4 <vprintf+0xf2>
        putc(fd, '%');
 55e:	02500593          	li	a1,37
 562:	855a                	mv	a0,s6
 564:	e89ff0ef          	jal	3ec <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 568:	4981                	li	s3,0
 56a:	bf49                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 56c:	008b8913          	addi	s2,s7,8
 570:	4685                	li	a3,1
 572:	4629                	li	a2,10
 574:	000ba583          	lw	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	e91ff0ef          	jal	40a <printint>
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	bfad                	j	4fc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 584:	06400793          	li	a5,100
 588:	02f68963          	beq	a3,a5,5ba <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 58c:	06c00793          	li	a5,108
 590:	04f68263          	beq	a3,a5,5d4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 594:	07500793          	li	a5,117
 598:	0af68063          	beq	a3,a5,638 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 59c:	07800793          	li	a5,120
 5a0:	0ef68263          	beq	a3,a5,684 <vprintf+0x1d2>
        putc(fd, '%');
 5a4:	02500593          	li	a1,37
 5a8:	855a                	mv	a0,s6
 5aa:	e43ff0ef          	jal	3ec <putc>
        putc(fd, c0);
 5ae:	85ca                	mv	a1,s2
 5b0:	855a                	mv	a0,s6
 5b2:	e3bff0ef          	jal	3ec <putc>
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b791                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	008b8913          	addi	s2,s7,8
 5be:	4685                	li	a3,1
 5c0:	4629                	li	a2,10
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e43ff0ef          	jal	40a <printint>
        i += 1;
 5cc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
        i += 1;
 5d2:	b72d                	j	4fc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d4:	06400793          	li	a5,100
 5d8:	02f60763          	beq	a2,a5,606 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5dc:	07500793          	li	a5,117
 5e0:	06f60963          	beq	a2,a5,652 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5e4:	07800793          	li	a5,120
 5e8:	faf61ee3          	bne	a2,a5,5a4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4641                	li	a2,16
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	e11ff0ef          	jal	40a <printint>
        i += 2;
 5fe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 600:	8bca                	mv	s7,s2
      state = 0;
 602:	4981                	li	s3,0
        i += 2;
 604:	bde5                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	008b8913          	addi	s2,s7,8
 60a:	4685                	li	a3,1
 60c:	4629                	li	a2,10
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	df7ff0ef          	jal	40a <printint>
        i += 2;
 618:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61a:	8bca                	mv	s7,s2
      state = 0;
 61c:	4981                	li	s3,0
        i += 2;
 61e:	bdf9                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 620:	008b8913          	addi	s2,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	dddff0ef          	jal	40a <printint>
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
 636:	b5d9                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	008b8913          	addi	s2,s7,8
 63c:	4681                	li	a3,0
 63e:	4629                	li	a2,10
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	dc5ff0ef          	jal	40a <printint>
        i += 1;
 64a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
        i += 1;
 650:	b575                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	008b8913          	addi	s2,s7,8
 656:	4681                	li	a3,0
 658:	4629                	li	a2,10
 65a:	000ba583          	lw	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	dabff0ef          	jal	40a <printint>
        i += 2;
 664:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
        i += 2;
 66a:	bd49                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 66c:	008b8913          	addi	s2,s7,8
 670:	4681                	li	a3,0
 672:	4641                	li	a2,16
 674:	000ba583          	lw	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	d91ff0ef          	jal	40a <printint>
 67e:	8bca                	mv	s7,s2
      state = 0;
 680:	4981                	li	s3,0
 682:	bdad                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	008b8913          	addi	s2,s7,8
 688:	4681                	li	a3,0
 68a:	4641                	li	a2,16
 68c:	000ba583          	lw	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	d79ff0ef          	jal	40a <printint>
        i += 1;
 696:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 698:	8bca                	mv	s7,s2
      state = 0;
 69a:	4981                	li	s3,0
        i += 1;
 69c:	b585                	j	4fc <vprintf+0x4a>
 69e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a0:	008b8d13          	addi	s10,s7,8
 6a4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a8:	03000593          	li	a1,48
 6ac:	855a                	mv	a0,s6
 6ae:	d3fff0ef          	jal	3ec <putc>
  putc(fd, 'x');
 6b2:	07800593          	li	a1,120
 6b6:	855a                	mv	a0,s6
 6b8:	d35ff0ef          	jal	3ec <putc>
 6bc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6be:	00000b97          	auipc	s7,0x0
 6c2:	29ab8b93          	addi	s7,s7,666 # 958 <digits>
 6c6:	03c9d793          	srli	a5,s3,0x3c
 6ca:	97de                	add	a5,a5,s7
 6cc:	0007c583          	lbu	a1,0(a5)
 6d0:	855a                	mv	a0,s6
 6d2:	d1bff0ef          	jal	3ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d6:	0992                	slli	s3,s3,0x4
 6d8:	397d                	addiw	s2,s2,-1
 6da:	fe0916e3          	bnez	s2,6c6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6de:	8bea                	mv	s7,s10
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	6d02                	ld	s10,0(sp)
 6e4:	bd21                	j	4fc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6e6:	008b8993          	addi	s3,s7,8
 6ea:	000bb903          	ld	s2,0(s7)
 6ee:	00090f63          	beqz	s2,70c <vprintf+0x25a>
        for(; *s; s++)
 6f2:	00094583          	lbu	a1,0(s2)
 6f6:	c195                	beqz	a1,71a <vprintf+0x268>
          putc(fd, *s);
 6f8:	855a                	mv	a0,s6
 6fa:	cf3ff0ef          	jal	3ec <putc>
        for(; *s; s++)
 6fe:	0905                	addi	s2,s2,1
 700:	00094583          	lbu	a1,0(s2)
 704:	f9f5                	bnez	a1,6f8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 706:	8bce                	mv	s7,s3
      state = 0;
 708:	4981                	li	s3,0
 70a:	bbcd                	j	4fc <vprintf+0x4a>
          s = "(null)";
 70c:	00000917          	auipc	s2,0x0
 710:	24490913          	addi	s2,s2,580 # 950 <malloc+0x138>
        for(; *s; s++)
 714:	02800593          	li	a1,40
 718:	b7c5                	j	6f8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 71a:	8bce                	mv	s7,s3
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bbf9                	j	4fc <vprintf+0x4a>
 720:	64a6                	ld	s1,72(sp)
 722:	79e2                	ld	s3,56(sp)
 724:	7a42                	ld	s4,48(sp)
 726:	7aa2                	ld	s5,40(sp)
 728:	7b02                	ld	s6,32(sp)
 72a:	6be2                	ld	s7,24(sp)
 72c:	6c42                	ld	s8,16(sp)
 72e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 730:	60e6                	ld	ra,88(sp)
 732:	6446                	ld	s0,80(sp)
 734:	6906                	ld	s2,64(sp)
 736:	6125                	addi	sp,sp,96
 738:	8082                	ret

000000000000073a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73a:	715d                	addi	sp,sp,-80
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e010                	sd	a2,0(s0)
 744:	e414                	sd	a3,8(s0)
 746:	e818                	sd	a4,16(s0)
 748:	ec1c                	sd	a5,24(s0)
 74a:	03043023          	sd	a6,32(s0)
 74e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 756:	8622                	mv	a2,s0
 758:	d5bff0ef          	jal	4b2 <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6161                	addi	sp,sp,80
 762:	8082                	ret

0000000000000764 <printf>:

void
printf(const char *fmt, ...)
{
 764:	711d                	addi	sp,sp,-96
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e40c                	sd	a1,8(s0)
 76e:	e810                	sd	a2,16(s0)
 770:	ec14                	sd	a3,24(s0)
 772:	f018                	sd	a4,32(s0)
 774:	f41c                	sd	a5,40(s0)
 776:	03043823          	sd	a6,48(s0)
 77a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77e:	00840613          	addi	a2,s0,8
 782:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 786:	85aa                	mv	a1,a0
 788:	4505                	li	a0,1
 78a:	d29ff0ef          	jal	4b2 <vprintf>
}
 78e:	60e2                	ld	ra,24(sp)
 790:	6442                	ld	s0,16(sp)
 792:	6125                	addi	sp,sp,96
 794:	8082                	ret

0000000000000796 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 796:	1141                	addi	sp,sp,-16
 798:	e422                	sd	s0,8(sp)
 79a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	00001797          	auipc	a5,0x1
 7a4:	8607b783          	ld	a5,-1952(a5) # 1000 <freep>
 7a8:	a02d                	j	7d2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7aa:	4618                	lw	a4,8(a2)
 7ac:	9f2d                	addw	a4,a4,a1
 7ae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	6310                	ld	a2,0(a4)
 7b6:	a83d                	j	7f4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b8:	ff852703          	lw	a4,-8(a0)
 7bc:	9f31                	addw	a4,a4,a2
 7be:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c0:	ff053683          	ld	a3,-16(a0)
 7c4:	a091                	j	808 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e7e463          	bltu	a5,a4,7d0 <free+0x3a>
 7cc:	00e6ea63          	bltu	a3,a4,7e0 <free+0x4a>
{
 7d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d2:	fed7fae3          	bgeu	a5,a3,7c6 <free+0x30>
 7d6:	6398                	ld	a4,0(a5)
 7d8:	00e6e463          	bltu	a3,a4,7e0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	fee7eae3          	bltu	a5,a4,7d0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7e0:	ff852583          	lw	a1,-8(a0)
 7e4:	6390                	ld	a2,0(a5)
 7e6:	02059813          	slli	a6,a1,0x20
 7ea:	01c85713          	srli	a4,a6,0x1c
 7ee:	9736                	add	a4,a4,a3
 7f0:	fae60de3          	beq	a2,a4,7aa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f8:	4790                	lw	a2,8(a5)
 7fa:	02061593          	slli	a1,a2,0x20
 7fe:	01c5d713          	srli	a4,a1,0x1c
 802:	973e                	add	a4,a4,a5
 804:	fae68ae3          	beq	a3,a4,7b8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 808:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80a:	00000717          	auipc	a4,0x0
 80e:	7ef73b23          	sd	a5,2038(a4) # 1000 <freep>
}
 812:	6422                	ld	s0,8(sp)
 814:	0141                	addi	sp,sp,16
 816:	8082                	ret

0000000000000818 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 818:	7139                	addi	sp,sp,-64
 81a:	fc06                	sd	ra,56(sp)
 81c:	f822                	sd	s0,48(sp)
 81e:	f426                	sd	s1,40(sp)
 820:	ec4e                	sd	s3,24(sp)
 822:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 824:	02051493          	slli	s1,a0,0x20
 828:	9081                	srli	s1,s1,0x20
 82a:	04bd                	addi	s1,s1,15
 82c:	8091                	srli	s1,s1,0x4
 82e:	0014899b          	addiw	s3,s1,1
 832:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 834:	00000517          	auipc	a0,0x0
 838:	7cc53503          	ld	a0,1996(a0) # 1000 <freep>
 83c:	c915                	beqz	a0,870 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 840:	4798                	lw	a4,8(a5)
 842:	08977a63          	bgeu	a4,s1,8d6 <malloc+0xbe>
 846:	f04a                	sd	s2,32(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 84e:	8a4e                	mv	s4,s3
 850:	0009871b          	sext.w	a4,s3
 854:	6685                	lui	a3,0x1
 856:	00d77363          	bgeu	a4,a3,85c <malloc+0x44>
 85a:	6a05                	lui	s4,0x1
 85c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 860:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 864:	00000917          	auipc	s2,0x0
 868:	79c90913          	addi	s2,s2,1948 # 1000 <freep>
  if(p == (char*)-1)
 86c:	5afd                	li	s5,-1
 86e:	a081                	j	8ae <malloc+0x96>
 870:	f04a                	sd	s2,32(sp)
 872:	e852                	sd	s4,16(sp)
 874:	e456                	sd	s5,8(sp)
 876:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 878:	00000797          	auipc	a5,0x0
 87c:	79878793          	addi	a5,a5,1944 # 1010 <base>
 880:	00000717          	auipc	a4,0x0
 884:	78f73023          	sd	a5,1920(a4) # 1000 <freep>
 888:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88e:	b7c1                	j	84e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 890:	6398                	ld	a4,0(a5)
 892:	e118                	sd	a4,0(a0)
 894:	a8a9                	j	8ee <malloc+0xd6>
  hp->s.size = nu;
 896:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89a:	0541                	addi	a0,a0,16
 89c:	efbff0ef          	jal	796 <free>
  return freep;
 8a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a4:	c12d                	beqz	a0,906 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a8:	4798                	lw	a4,8(a5)
 8aa:	02977263          	bgeu	a4,s1,8ce <malloc+0xb6>
    if(p == freep)
 8ae:	00093703          	ld	a4,0(s2)
 8b2:	853e                	mv	a0,a5
 8b4:	fef719e3          	bne	a4,a5,8a6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8b8:	8552                	mv	a0,s4
 8ba:	b1bff0ef          	jal	3d4 <sbrk>
  if(p == (char*)-1)
 8be:	fd551ce3          	bne	a0,s5,896 <malloc+0x7e>
        return 0;
 8c2:	4501                	li	a0,0
 8c4:	7902                	ld	s2,32(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
 8cc:	a03d                	j	8fa <malloc+0xe2>
 8ce:	7902                	ld	s2,32(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d6:	fae48de3          	beq	s1,a4,890 <malloc+0x78>
        p->s.size -= nunits;
 8da:	4137073b          	subw	a4,a4,s3
 8de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e0:	02071693          	slli	a3,a4,0x20
 8e4:	01c6d713          	srli	a4,a3,0x1c
 8e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70a73923          	sd	a0,1810(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f6:	01078513          	addi	a0,a5,16
  }
}
 8fa:	70e2                	ld	ra,56(sp)
 8fc:	7442                	ld	s0,48(sp)
 8fe:	74a2                	ld	s1,40(sp)
 900:	69e2                	ld	s3,24(sp)
 902:	6121                	addi	sp,sp,64
 904:	8082                	ret
 906:	7902                	ld	s2,32(sp)
 908:	6a42                	ld	s4,16(sp)
 90a:	6aa2                	ld	s5,8(sp)
 90c:	6b02                	ld	s6,0(sp)
 90e:	b7f5                	j	8fa <malloc+0xe2>
