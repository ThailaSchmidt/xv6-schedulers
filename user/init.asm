
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8f250513          	addi	a0,a0,-1806 # 900 <malloc+0x104>
  16:	35a000ef          	jal	370 <open>
  1a:	04054663          	bltz	a0,66 <main+0x66>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	388000ef          	jal	3a8 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	382000ef          	jal	3a8 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	8de90913          	addi	s2,s2,-1826 # 908 <malloc+0x10c>
  32:	854a                	mv	a0,s2
  34:	714000ef          	jal	748 <printf>
    pid = fork(1);
  38:	4505                	li	a0,1
  3a:	2ee000ef          	jal	328 <fork>
  3e:	84aa                	mv	s1,a0
    if(pid < 0){
  40:	04054363          	bltz	a0,86 <main+0x86>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  44:	c931                	beqz	a0,98 <main+0x98>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  46:	4501                	li	a0,0
  48:	2f0000ef          	jal	338 <wait>
      if(wpid == pid){
  4c:	fea483e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  50:	fe055be3          	bgez	a0,46 <main+0x46>
        printf("init: wait returned an error\n");
  54:	00001517          	auipc	a0,0x1
  58:	90450513          	addi	a0,a0,-1788 # 958 <malloc+0x15c>
  5c:	6ec000ef          	jal	748 <printf>
        exit(1);
  60:	4505                	li	a0,1
  62:	2ce000ef          	jal	330 <exit>
    mknod("console", CONSOLE, 0);
  66:	4601                	li	a2,0
  68:	4585                	li	a1,1
  6a:	00001517          	auipc	a0,0x1
  6e:	89650513          	addi	a0,a0,-1898 # 900 <malloc+0x104>
  72:	306000ef          	jal	378 <mknod>
    open("console", O_RDWR);
  76:	4589                	li	a1,2
  78:	00001517          	auipc	a0,0x1
  7c:	88850513          	addi	a0,a0,-1912 # 900 <malloc+0x104>
  80:	2f0000ef          	jal	370 <open>
  84:	bf69                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  86:	00001517          	auipc	a0,0x1
  8a:	89a50513          	addi	a0,a0,-1894 # 920 <malloc+0x124>
  8e:	6ba000ef          	jal	748 <printf>
      exit(1);
  92:	4505                	li	a0,1
  94:	29c000ef          	jal	330 <exit>
      exec("sh", argv);
  98:	00001597          	auipc	a1,0x1
  9c:	f6858593          	addi	a1,a1,-152 # 1000 <argv>
  a0:	00001517          	auipc	a0,0x1
  a4:	89850513          	addi	a0,a0,-1896 # 938 <malloc+0x13c>
  a8:	2c0000ef          	jal	368 <exec>
      printf("init: exec sh failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	89450513          	addi	a0,a0,-1900 # 940 <malloc+0x144>
  b4:	694000ef          	jal	748 <printf>
      exit(1);
  b8:	4505                	li	a0,1
  ba:	276000ef          	jal	330 <exit>

00000000000000be <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  be:	1141                	addi	sp,sp,-16
  c0:	e406                	sd	ra,8(sp)
  c2:	e022                	sd	s0,0(sp)
  c4:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c6:	f3bff0ef          	jal	0 <main>
  exit(0);
  ca:	4501                	li	a0,0
  cc:	264000ef          	jal	330 <exit>

00000000000000d0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d6:	87aa                	mv	a5,a0
  d8:	0585                	addi	a1,a1,1
  da:	0785                	addi	a5,a5,1
  dc:	fff5c703          	lbu	a4,-1(a1)
  e0:	fee78fa3          	sb	a4,-1(a5)
  e4:	fb75                	bnez	a4,d8 <strcpy+0x8>
    ;
  return os;
}
  e6:	6422                	ld	s0,8(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e422                	sd	s0,8(sp)
  f0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f2:	00054783          	lbu	a5,0(a0)
  f6:	cb91                	beqz	a5,10a <strcmp+0x1e>
  f8:	0005c703          	lbu	a4,0(a1)
  fc:	00f71763          	bne	a4,a5,10a <strcmp+0x1e>
    p++, q++;
 100:	0505                	addi	a0,a0,1
 102:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 104:	00054783          	lbu	a5,0(a0)
 108:	fbe5                	bnez	a5,f8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 10a:	0005c503          	lbu	a0,0(a1)
}
 10e:	40a7853b          	subw	a0,a5,a0
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strlen>:

uint
strlen(const char *s)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cf91                	beqz	a5,13e <strlen+0x26>
 124:	0505                	addi	a0,a0,1
 126:	87aa                	mv	a5,a0
 128:	86be                	mv	a3,a5
 12a:	0785                	addi	a5,a5,1
 12c:	fff7c703          	lbu	a4,-1(a5)
 130:	ff65                	bnez	a4,128 <strlen+0x10>
 132:	40a6853b          	subw	a0,a3,a0
 136:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  for(n = 0; s[n]; n++)
 13e:	4501                	li	a0,0
 140:	bfe5                	j	138 <strlen+0x20>

0000000000000142 <memset>:

void*
memset(void *dst, int c, uint n)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 148:	ca19                	beqz	a2,15e <memset+0x1c>
 14a:	87aa                	mv	a5,a0
 14c:	1602                	slli	a2,a2,0x20
 14e:	9201                	srli	a2,a2,0x20
 150:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 154:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 158:	0785                	addi	a5,a5,1
 15a:	fee79de3          	bne	a5,a4,154 <memset+0x12>
  }
  return dst;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strchr>:

char*
strchr(const char *s, char c)
{
 164:	1141                	addi	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	addi	s0,sp,16
  for(; *s; s++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cb99                	beqz	a5,184 <strchr+0x20>
    if(*s == c)
 170:	00f58763          	beq	a1,a5,17e <strchr+0x1a>
  for(; *s; s++)
 174:	0505                	addi	a0,a0,1
 176:	00054783          	lbu	a5,0(a0)
 17a:	fbfd                	bnez	a5,170 <strchr+0xc>
      return (char*)s;
  return 0;
 17c:	4501                	li	a0,0
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret
  return 0;
 184:	4501                	li	a0,0
 186:	bfe5                	j	17e <strchr+0x1a>

0000000000000188 <gets>:

char*
gets(char *buf, int max)
{
 188:	711d                	addi	sp,sp,-96
 18a:	ec86                	sd	ra,88(sp)
 18c:	e8a2                	sd	s0,80(sp)
 18e:	e4a6                	sd	s1,72(sp)
 190:	e0ca                	sd	s2,64(sp)
 192:	fc4e                	sd	s3,56(sp)
 194:	f852                	sd	s4,48(sp)
 196:	f456                	sd	s5,40(sp)
 198:	f05a                	sd	s6,32(sp)
 19a:	ec5e                	sd	s7,24(sp)
 19c:	1080                	addi	s0,sp,96
 19e:	8baa                	mv	s7,a0
 1a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a2:	892a                	mv	s2,a0
 1a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a6:	4aa9                	li	s5,10
 1a8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1aa:	89a6                	mv	s3,s1
 1ac:	2485                	addiw	s1,s1,1
 1ae:	0344d663          	bge	s1,s4,1da <gets+0x52>
    cc = read(0, &c, 1);
 1b2:	4605                	li	a2,1
 1b4:	faf40593          	addi	a1,s0,-81
 1b8:	4501                	li	a0,0
 1ba:	18e000ef          	jal	348 <read>
    if(cc < 1)
 1be:	00a05e63          	blez	a0,1da <gets+0x52>
    buf[i++] = c;
 1c2:	faf44783          	lbu	a5,-81(s0)
 1c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ca:	01578763          	beq	a5,s5,1d8 <gets+0x50>
 1ce:	0905                	addi	s2,s2,1
 1d0:	fd679de3          	bne	a5,s6,1aa <gets+0x22>
    buf[i++] = c;
 1d4:	89a6                	mv	s3,s1
 1d6:	a011                	j	1da <gets+0x52>
 1d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1da:	99de                	add	s3,s3,s7
 1dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e0:	855e                	mv	a0,s7
 1e2:	60e6                	ld	ra,88(sp)
 1e4:	6446                	ld	s0,80(sp)
 1e6:	64a6                	ld	s1,72(sp)
 1e8:	6906                	ld	s2,64(sp)
 1ea:	79e2                	ld	s3,56(sp)
 1ec:	7a42                	ld	s4,48(sp)
 1ee:	7aa2                	ld	s5,40(sp)
 1f0:	7b02                	ld	s6,32(sp)
 1f2:	6be2                	ld	s7,24(sp)
 1f4:	6125                	addi	sp,sp,96
 1f6:	8082                	ret

00000000000001f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f8:	1101                	addi	sp,sp,-32
 1fa:	ec06                	sd	ra,24(sp)
 1fc:	e822                	sd	s0,16(sp)
 1fe:	e04a                	sd	s2,0(sp)
 200:	1000                	addi	s0,sp,32
 202:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 204:	4581                	li	a1,0
 206:	16a000ef          	jal	370 <open>
  if(fd < 0)
 20a:	02054263          	bltz	a0,22e <stat+0x36>
 20e:	e426                	sd	s1,8(sp)
 210:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 212:	85ca                	mv	a1,s2
 214:	174000ef          	jal	388 <fstat>
 218:	892a                	mv	s2,a0
  close(fd);
 21a:	8526                	mv	a0,s1
 21c:	13c000ef          	jal	358 <close>
  return r;
 220:	64a2                	ld	s1,8(sp)
}
 222:	854a                	mv	a0,s2
 224:	60e2                	ld	ra,24(sp)
 226:	6442                	ld	s0,16(sp)
 228:	6902                	ld	s2,0(sp)
 22a:	6105                	addi	sp,sp,32
 22c:	8082                	ret
    return -1;
 22e:	597d                	li	s2,-1
 230:	bfcd                	j	222 <stat+0x2a>

0000000000000232 <atoi>:

int
atoi(const char *s)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 238:	00054683          	lbu	a3,0(a0)
 23c:	fd06879b          	addiw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	4625                	li	a2,9
 246:	02f66863          	bltu	a2,a5,276 <atoi+0x44>
 24a:	872a                	mv	a4,a0
  n = 0;
 24c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 24e:	0705                	addi	a4,a4,1
 250:	0025179b          	slliw	a5,a0,0x2
 254:	9fa9                	addw	a5,a5,a0
 256:	0017979b          	slliw	a5,a5,0x1
 25a:	9fb5                	addw	a5,a5,a3
 25c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 260:	00074683          	lbu	a3,0(a4)
 264:	fd06879b          	addiw	a5,a3,-48
 268:	0ff7f793          	zext.b	a5,a5
 26c:	fef671e3          	bgeu	a2,a5,24e <atoi+0x1c>
  return n;
}
 270:	6422                	ld	s0,8(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
  n = 0;
 276:	4501                	li	a0,0
 278:	bfe5                	j	270 <atoi+0x3e>

000000000000027a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 280:	02b57463          	bgeu	a0,a1,2a8 <memmove+0x2e>
    while(n-- > 0)
 284:	00c05f63          	blez	a2,2a2 <memmove+0x28>
 288:	1602                	slli	a2,a2,0x20
 28a:	9201                	srli	a2,a2,0x20
 28c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 290:	872a                	mv	a4,a0
      *dst++ = *src++;
 292:	0585                	addi	a1,a1,1
 294:	0705                	addi	a4,a4,1
 296:	fff5c683          	lbu	a3,-1(a1)
 29a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29e:	fef71ae3          	bne	a4,a5,292 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
    dst += n;
 2a8:	00c50733          	add	a4,a0,a2
    src += n;
 2ac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ae:	fec05ae3          	blez	a2,2a2 <memmove+0x28>
 2b2:	fff6079b          	addiw	a5,a2,-1
 2b6:	1782                	slli	a5,a5,0x20
 2b8:	9381                	srli	a5,a5,0x20
 2ba:	fff7c793          	not	a5,a5
 2be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c0:	15fd                	addi	a1,a1,-1
 2c2:	177d                	addi	a4,a4,-1
 2c4:	0005c683          	lbu	a3,0(a1)
 2c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2cc:	fee79ae3          	bne	a5,a4,2c0 <memmove+0x46>
 2d0:	bfc9                	j	2a2 <memmove+0x28>

00000000000002d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d8:	ca05                	beqz	a2,308 <memcmp+0x36>
 2da:	fff6069b          	addiw	a3,a2,-1
 2de:	1682                	slli	a3,a3,0x20
 2e0:	9281                	srli	a3,a3,0x20
 2e2:	0685                	addi	a3,a3,1
 2e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	0005c703          	lbu	a4,0(a1)
 2ee:	00e79863          	bne	a5,a4,2fe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f2:	0505                	addi	a0,a0,1
    p2++;
 2f4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f6:	fed518e3          	bne	a0,a3,2e6 <memcmp+0x14>
  }
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	a019                	j	302 <memcmp+0x30>
      return *p1 - *p2;
 2fe:	40e7853b          	subw	a0,a5,a4
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
  return 0;
 308:	4501                	li	a0,0
 30a:	bfe5                	j	302 <memcmp+0x30>

000000000000030c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 314:	f67ff0ef          	jal	27a <memmove>
}
 318:	60a2                	ld	ra,8(sp)
 31a:	6402                	ld	s0,0(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <forkprio>:



.global forkprio
forkprio:
  li a7, SYS_forkprio
 320:	48d9                	li	a7,22
  ecall
 322:	00000073          	ecall
  ret
 326:	8082                	ret

0000000000000328 <fork>:



.global fork
fork:
 li a7, SYS_fork
 328:	4885                	li	a7,1
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <exit>:
.global exit
exit:
 li a7, SYS_exit
 330:	4889                	li	a7,2
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <wait>:
.global wait
wait:
 li a7, SYS_wait
 338:	488d                	li	a7,3
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 340:	4891                	li	a7,4
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <read>:
.global read
read:
 li a7, SYS_read
 348:	4895                	li	a7,5
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <write>:
.global write
write:
 li a7, SYS_write
 350:	48c1                	li	a7,16
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <close>:
.global close
close:
 li a7, SYS_close
 358:	48d5                	li	a7,21
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <kill>:
.global kill
kill:
 li a7, SYS_kill
 360:	4899                	li	a7,6
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <exec>:
.global exec
exec:
 li a7, SYS_exec
 368:	489d                	li	a7,7
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <open>:
.global open
open:
 li a7, SYS_open
 370:	48bd                	li	a7,15
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 378:	48c5                	li	a7,17
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 380:	48c9                	li	a7,18
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 388:	48a1                	li	a7,8
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <link>:
.global link
link:
 li a7, SYS_link
 390:	48cd                	li	a7,19
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 398:	48d1                	li	a7,20
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a0:	48a5                	li	a7,9
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a8:	48a9                	li	a7,10
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b0:	48ad                	li	a7,11
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b8:	48b1                	li	a7,12
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c0:	48b5                	li	a7,13
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c8:	48b9                	li	a7,14
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d0:	1101                	addi	sp,sp,-32
 3d2:	ec06                	sd	ra,24(sp)
 3d4:	e822                	sd	s0,16(sp)
 3d6:	1000                	addi	s0,sp,32
 3d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3dc:	4605                	li	a2,1
 3de:	fef40593          	addi	a1,s0,-17
 3e2:	f6fff0ef          	jal	350 <write>
}
 3e6:	60e2                	ld	ra,24(sp)
 3e8:	6442                	ld	s0,16(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret

00000000000003ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ee:	7139                	addi	sp,sp,-64
 3f0:	fc06                	sd	ra,56(sp)
 3f2:	f822                	sd	s0,48(sp)
 3f4:	f426                	sd	s1,40(sp)
 3f6:	0080                	addi	s0,sp,64
 3f8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fa:	c299                	beqz	a3,400 <printint+0x12>
 3fc:	0805c963          	bltz	a1,48e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 400:	2581                	sext.w	a1,a1
  neg = 0;
 402:	4881                	li	a7,0
 404:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 408:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 40a:	2601                	sext.w	a2,a2
 40c:	00000517          	auipc	a0,0x0
 410:	57450513          	addi	a0,a0,1396 # 980 <digits>
 414:	883a                	mv	a6,a4
 416:	2705                	addiw	a4,a4,1
 418:	02c5f7bb          	remuw	a5,a1,a2
 41c:	1782                	slli	a5,a5,0x20
 41e:	9381                	srli	a5,a5,0x20
 420:	97aa                	add	a5,a5,a0
 422:	0007c783          	lbu	a5,0(a5)
 426:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 42a:	0005879b          	sext.w	a5,a1
 42e:	02c5d5bb          	divuw	a1,a1,a2
 432:	0685                	addi	a3,a3,1
 434:	fec7f0e3          	bgeu	a5,a2,414 <printint+0x26>
  if(neg)
 438:	00088c63          	beqz	a7,450 <printint+0x62>
    buf[i++] = '-';
 43c:	fd070793          	addi	a5,a4,-48
 440:	00878733          	add	a4,a5,s0
 444:	02d00793          	li	a5,45
 448:	fef70823          	sb	a5,-16(a4)
 44c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 450:	02e05a63          	blez	a4,484 <printint+0x96>
 454:	f04a                	sd	s2,32(sp)
 456:	ec4e                	sd	s3,24(sp)
 458:	fc040793          	addi	a5,s0,-64
 45c:	00e78933          	add	s2,a5,a4
 460:	fff78993          	addi	s3,a5,-1
 464:	99ba                	add	s3,s3,a4
 466:	377d                	addiw	a4,a4,-1
 468:	1702                	slli	a4,a4,0x20
 46a:	9301                	srli	a4,a4,0x20
 46c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 470:	fff94583          	lbu	a1,-1(s2)
 474:	8526                	mv	a0,s1
 476:	f5bff0ef          	jal	3d0 <putc>
  while(--i >= 0)
 47a:	197d                	addi	s2,s2,-1
 47c:	ff391ae3          	bne	s2,s3,470 <printint+0x82>
 480:	7902                	ld	s2,32(sp)
 482:	69e2                	ld	s3,24(sp)
}
 484:	70e2                	ld	ra,56(sp)
 486:	7442                	ld	s0,48(sp)
 488:	74a2                	ld	s1,40(sp)
 48a:	6121                	addi	sp,sp,64
 48c:	8082                	ret
    x = -xx;
 48e:	40b005bb          	negw	a1,a1
    neg = 1;
 492:	4885                	li	a7,1
    x = -xx;
 494:	bf85                	j	404 <printint+0x16>

0000000000000496 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 496:	711d                	addi	sp,sp,-96
 498:	ec86                	sd	ra,88(sp)
 49a:	e8a2                	sd	s0,80(sp)
 49c:	e0ca                	sd	s2,64(sp)
 49e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a0:	0005c903          	lbu	s2,0(a1)
 4a4:	26090863          	beqz	s2,714 <vprintf+0x27e>
 4a8:	e4a6                	sd	s1,72(sp)
 4aa:	fc4e                	sd	s3,56(sp)
 4ac:	f852                	sd	s4,48(sp)
 4ae:	f456                	sd	s5,40(sp)
 4b0:	f05a                	sd	s6,32(sp)
 4b2:	ec5e                	sd	s7,24(sp)
 4b4:	e862                	sd	s8,16(sp)
 4b6:	e466                	sd	s9,8(sp)
 4b8:	8b2a                	mv	s6,a0
 4ba:	8a2e                	mv	s4,a1
 4bc:	8bb2                	mv	s7,a2
  state = 0;
 4be:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4c0:	4481                	li	s1,0
 4c2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4cc:	06c00c93          	li	s9,108
 4d0:	a005                	j	4f0 <vprintf+0x5a>
        putc(fd, c0);
 4d2:	85ca                	mv	a1,s2
 4d4:	855a                	mv	a0,s6
 4d6:	efbff0ef          	jal	3d0 <putc>
 4da:	a019                	j	4e0 <vprintf+0x4a>
    } else if(state == '%'){
 4dc:	03598263          	beq	s3,s5,500 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4e0:	2485                	addiw	s1,s1,1
 4e2:	8726                	mv	a4,s1
 4e4:	009a07b3          	add	a5,s4,s1
 4e8:	0007c903          	lbu	s2,0(a5)
 4ec:	20090c63          	beqz	s2,704 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4f0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f4:	fe0994e3          	bnez	s3,4dc <vprintf+0x46>
      if(c0 == '%'){
 4f8:	fd579de3          	bne	a5,s5,4d2 <vprintf+0x3c>
        state = '%';
 4fc:	89be                	mv	s3,a5
 4fe:	b7cd                	j	4e0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 500:	00ea06b3          	add	a3,s4,a4
 504:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 508:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 50a:	c681                	beqz	a3,512 <vprintf+0x7c>
 50c:	9752                	add	a4,a4,s4
 50e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 512:	03878f63          	beq	a5,s8,550 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 516:	05978963          	beq	a5,s9,568 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 51a:	07500713          	li	a4,117
 51e:	0ee78363          	beq	a5,a4,604 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 522:	07800713          	li	a4,120
 526:	12e78563          	beq	a5,a4,650 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 52a:	07000713          	li	a4,112
 52e:	14e78a63          	beq	a5,a4,682 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 532:	07300713          	li	a4,115
 536:	18e78a63          	beq	a5,a4,6ca <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 53a:	02500713          	li	a4,37
 53e:	04e79563          	bne	a5,a4,588 <vprintf+0xf2>
        putc(fd, '%');
 542:	02500593          	li	a1,37
 546:	855a                	mv	a0,s6
 548:	e89ff0ef          	jal	3d0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bf49                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 550:	008b8913          	addi	s2,s7,8
 554:	4685                	li	a3,1
 556:	4629                	li	a2,10
 558:	000ba583          	lw	a1,0(s7)
 55c:	855a                	mv	a0,s6
 55e:	e91ff0ef          	jal	3ee <printint>
 562:	8bca                	mv	s7,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	bfad                	j	4e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 568:	06400793          	li	a5,100
 56c:	02f68963          	beq	a3,a5,59e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 570:	06c00793          	li	a5,108
 574:	04f68263          	beq	a3,a5,5b8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 578:	07500793          	li	a5,117
 57c:	0af68063          	beq	a3,a5,61c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 580:	07800793          	li	a5,120
 584:	0ef68263          	beq	a3,a5,668 <vprintf+0x1d2>
        putc(fd, '%');
 588:	02500593          	li	a1,37
 58c:	855a                	mv	a0,s6
 58e:	e43ff0ef          	jal	3d0 <putc>
        putc(fd, c0);
 592:	85ca                	mv	a1,s2
 594:	855a                	mv	a0,s6
 596:	e3bff0ef          	jal	3d0 <putc>
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b791                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	008b8913          	addi	s2,s7,8
 5a2:	4685                	li	a3,1
 5a4:	4629                	li	a2,10
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	e43ff0ef          	jal	3ee <printint>
        i += 1;
 5b0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
        i += 1;
 5b6:	b72d                	j	4e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b8:	06400793          	li	a5,100
 5bc:	02f60763          	beq	a2,a5,5ea <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5c0:	07500793          	li	a5,117
 5c4:	06f60963          	beq	a2,a5,636 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5c8:	07800793          	li	a5,120
 5cc:	faf61ee3          	bne	a2,a5,588 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4641                	li	a2,16
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	e11ff0ef          	jal	3ee <printint>
        i += 2;
 5e2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
        i += 2;
 5e8:	bde5                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	008b8913          	addi	s2,s7,8
 5ee:	4685                	li	a3,1
 5f0:	4629                	li	a2,10
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	df7ff0ef          	jal	3ee <printint>
        i += 2;
 5fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
        i += 2;
 602:	bdf9                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 604:	008b8913          	addi	s2,s7,8
 608:	4681                	li	a3,0
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	dddff0ef          	jal	3ee <printint>
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
 61a:	b5d9                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	008b8913          	addi	s2,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000ba583          	lw	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	dc5ff0ef          	jal	3ee <printint>
        i += 1;
 62e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
        i += 1;
 634:	b575                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	008b8913          	addi	s2,s7,8
 63a:	4681                	li	a3,0
 63c:	4629                	li	a2,10
 63e:	000ba583          	lw	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	dabff0ef          	jal	3ee <printint>
        i += 2;
 648:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 2;
 64e:	bd49                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 650:	008b8913          	addi	s2,s7,8
 654:	4681                	li	a3,0
 656:	4641                	li	a2,16
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	d91ff0ef          	jal	3ee <printint>
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
 666:	bdad                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	008b8913          	addi	s2,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000ba583          	lw	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	d79ff0ef          	jal	3ee <printint>
        i += 1;
 67a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 1;
 680:	b585                	j	4e0 <vprintf+0x4a>
 682:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 684:	008b8d13          	addi	s10,s7,8
 688:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 68c:	03000593          	li	a1,48
 690:	855a                	mv	a0,s6
 692:	d3fff0ef          	jal	3d0 <putc>
  putc(fd, 'x');
 696:	07800593          	li	a1,120
 69a:	855a                	mv	a0,s6
 69c:	d35ff0ef          	jal	3d0 <putc>
 6a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a2:	00000b97          	auipc	s7,0x0
 6a6:	2deb8b93          	addi	s7,s7,734 # 980 <digits>
 6aa:	03c9d793          	srli	a5,s3,0x3c
 6ae:	97de                	add	a5,a5,s7
 6b0:	0007c583          	lbu	a1,0(a5)
 6b4:	855a                	mv	a0,s6
 6b6:	d1bff0ef          	jal	3d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ba:	0992                	slli	s3,s3,0x4
 6bc:	397d                	addiw	s2,s2,-1
 6be:	fe0916e3          	bnez	s2,6aa <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6c2:	8bea                	mv	s7,s10
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	6d02                	ld	s10,0(sp)
 6c8:	bd21                	j	4e0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	008b8993          	addi	s3,s7,8
 6ce:	000bb903          	ld	s2,0(s7)
 6d2:	00090f63          	beqz	s2,6f0 <vprintf+0x25a>
        for(; *s; s++)
 6d6:	00094583          	lbu	a1,0(s2)
 6da:	c195                	beqz	a1,6fe <vprintf+0x268>
          putc(fd, *s);
 6dc:	855a                	mv	a0,s6
 6de:	cf3ff0ef          	jal	3d0 <putc>
        for(; *s; s++)
 6e2:	0905                	addi	s2,s2,1
 6e4:	00094583          	lbu	a1,0(s2)
 6e8:	f9f5                	bnez	a1,6dc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6ea:	8bce                	mv	s7,s3
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bbcd                	j	4e0 <vprintf+0x4a>
          s = "(null)";
 6f0:	00000917          	auipc	s2,0x0
 6f4:	28890913          	addi	s2,s2,648 # 978 <malloc+0x17c>
        for(; *s; s++)
 6f8:	02800593          	li	a1,40
 6fc:	b7c5                	j	6dc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6fe:	8bce                	mv	s7,s3
      state = 0;
 700:	4981                	li	s3,0
 702:	bbf9                	j	4e0 <vprintf+0x4a>
 704:	64a6                	ld	s1,72(sp)
 706:	79e2                	ld	s3,56(sp)
 708:	7a42                	ld	s4,48(sp)
 70a:	7aa2                	ld	s5,40(sp)
 70c:	7b02                	ld	s6,32(sp)
 70e:	6be2                	ld	s7,24(sp)
 710:	6c42                	ld	s8,16(sp)
 712:	6ca2                	ld	s9,8(sp)
    }
  }
}
 714:	60e6                	ld	ra,88(sp)
 716:	6446                	ld	s0,80(sp)
 718:	6906                	ld	s2,64(sp)
 71a:	6125                	addi	sp,sp,96
 71c:	8082                	ret

000000000000071e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71e:	715d                	addi	sp,sp,-80
 720:	ec06                	sd	ra,24(sp)
 722:	e822                	sd	s0,16(sp)
 724:	1000                	addi	s0,sp,32
 726:	e010                	sd	a2,0(s0)
 728:	e414                	sd	a3,8(s0)
 72a:	e818                	sd	a4,16(s0)
 72c:	ec1c                	sd	a5,24(s0)
 72e:	03043023          	sd	a6,32(s0)
 732:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 736:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73a:	8622                	mv	a2,s0
 73c:	d5bff0ef          	jal	496 <vprintf>
}
 740:	60e2                	ld	ra,24(sp)
 742:	6442                	ld	s0,16(sp)
 744:	6161                	addi	sp,sp,80
 746:	8082                	ret

0000000000000748 <printf>:

void
printf(const char *fmt, ...)
{
 748:	711d                	addi	sp,sp,-96
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	e40c                	sd	a1,8(s0)
 752:	e810                	sd	a2,16(s0)
 754:	ec14                	sd	a3,24(s0)
 756:	f018                	sd	a4,32(s0)
 758:	f41c                	sd	a5,40(s0)
 75a:	03043823          	sd	a6,48(s0)
 75e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 762:	00840613          	addi	a2,s0,8
 766:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76a:	85aa                	mv	a1,a0
 76c:	4505                	li	a0,1
 76e:	d29ff0ef          	jal	496 <vprintf>
}
 772:	60e2                	ld	ra,24(sp)
 774:	6442                	ld	s0,16(sp)
 776:	6125                	addi	sp,sp,96
 778:	8082                	ret

000000000000077a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77a:	1141                	addi	sp,sp,-16
 77c:	e422                	sd	s0,8(sp)
 77e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 780:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 784:	00001797          	auipc	a5,0x1
 788:	88c7b783          	ld	a5,-1908(a5) # 1010 <freep>
 78c:	a02d                	j	7b6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 78e:	4618                	lw	a4,8(a2)
 790:	9f2d                	addw	a4,a4,a1
 792:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	6398                	ld	a4,0(a5)
 798:	6310                	ld	a2,0(a4)
 79a:	a83d                	j	7d8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 79c:	ff852703          	lw	a4,-8(a0)
 7a0:	9f31                	addw	a4,a4,a2
 7a2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a4:	ff053683          	ld	a3,-16(a0)
 7a8:	a091                	j	7ec <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7aa:	6398                	ld	a4,0(a5)
 7ac:	00e7e463          	bltu	a5,a4,7b4 <free+0x3a>
 7b0:	00e6ea63          	bltu	a3,a4,7c4 <free+0x4a>
{
 7b4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b6:	fed7fae3          	bgeu	a5,a3,7aa <free+0x30>
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e6e463          	bltu	a3,a4,7c4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c0:	fee7eae3          	bltu	a5,a4,7b4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7c4:	ff852583          	lw	a1,-8(a0)
 7c8:	6390                	ld	a2,0(a5)
 7ca:	02059813          	slli	a6,a1,0x20
 7ce:	01c85713          	srli	a4,a6,0x1c
 7d2:	9736                	add	a4,a4,a3
 7d4:	fae60de3          	beq	a2,a4,78e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7d8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7dc:	4790                	lw	a2,8(a5)
 7de:	02061593          	slli	a1,a2,0x20
 7e2:	01c5d713          	srli	a4,a1,0x1c
 7e6:	973e                	add	a4,a4,a5
 7e8:	fae68ae3          	beq	a3,a4,79c <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ec:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ee:	00001717          	auipc	a4,0x1
 7f2:	82f73123          	sd	a5,-2014(a4) # 1010 <freep>
}
 7f6:	6422                	ld	s0,8(sp)
 7f8:	0141                	addi	sp,sp,16
 7fa:	8082                	ret

00000000000007fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fc:	7139                	addi	sp,sp,-64
 7fe:	fc06                	sd	ra,56(sp)
 800:	f822                	sd	s0,48(sp)
 802:	f426                	sd	s1,40(sp)
 804:	ec4e                	sd	s3,24(sp)
 806:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 808:	02051493          	slli	s1,a0,0x20
 80c:	9081                	srli	s1,s1,0x20
 80e:	04bd                	addi	s1,s1,15
 810:	8091                	srli	s1,s1,0x4
 812:	0014899b          	addiw	s3,s1,1
 816:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 818:	00000517          	auipc	a0,0x0
 81c:	7f853503          	ld	a0,2040(a0) # 1010 <freep>
 820:	c915                	beqz	a0,854 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 822:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 824:	4798                	lw	a4,8(a5)
 826:	08977a63          	bgeu	a4,s1,8ba <malloc+0xbe>
 82a:	f04a                	sd	s2,32(sp)
 82c:	e852                	sd	s4,16(sp)
 82e:	e456                	sd	s5,8(sp)
 830:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 832:	8a4e                	mv	s4,s3
 834:	0009871b          	sext.w	a4,s3
 838:	6685                	lui	a3,0x1
 83a:	00d77363          	bgeu	a4,a3,840 <malloc+0x44>
 83e:	6a05                	lui	s4,0x1
 840:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 844:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 848:	00000917          	auipc	s2,0x0
 84c:	7c890913          	addi	s2,s2,1992 # 1010 <freep>
  if(p == (char*)-1)
 850:	5afd                	li	s5,-1
 852:	a081                	j	892 <malloc+0x96>
 854:	f04a                	sd	s2,32(sp)
 856:	e852                	sd	s4,16(sp)
 858:	e456                	sd	s5,8(sp)
 85a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 85c:	00000797          	auipc	a5,0x0
 860:	7c478793          	addi	a5,a5,1988 # 1020 <base>
 864:	00000717          	auipc	a4,0x0
 868:	7af73623          	sd	a5,1964(a4) # 1010 <freep>
 86c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 86e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 872:	b7c1                	j	832 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 874:	6398                	ld	a4,0(a5)
 876:	e118                	sd	a4,0(a0)
 878:	a8a9                	j	8d2 <malloc+0xd6>
  hp->s.size = nu;
 87a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 87e:	0541                	addi	a0,a0,16
 880:	efbff0ef          	jal	77a <free>
  return freep;
 884:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 888:	c12d                	beqz	a0,8ea <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88c:	4798                	lw	a4,8(a5)
 88e:	02977263          	bgeu	a4,s1,8b2 <malloc+0xb6>
    if(p == freep)
 892:	00093703          	ld	a4,0(s2)
 896:	853e                	mv	a0,a5
 898:	fef719e3          	bne	a4,a5,88a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 89c:	8552                	mv	a0,s4
 89e:	b1bff0ef          	jal	3b8 <sbrk>
  if(p == (char*)-1)
 8a2:	fd551ce3          	bne	a0,s5,87a <malloc+0x7e>
        return 0;
 8a6:	4501                	li	a0,0
 8a8:	7902                	ld	s2,32(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
 8b0:	a03d                	j	8de <malloc+0xe2>
 8b2:	7902                	ld	s2,32(sp)
 8b4:	6a42                	ld	s4,16(sp)
 8b6:	6aa2                	ld	s5,8(sp)
 8b8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ba:	fae48de3          	beq	s1,a4,874 <malloc+0x78>
        p->s.size -= nunits;
 8be:	4137073b          	subw	a4,a4,s3
 8c2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c4:	02071693          	slli	a3,a4,0x20
 8c8:	01c6d713          	srli	a4,a3,0x1c
 8cc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ce:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72a73f23          	sd	a0,1854(a4) # 1010 <freep>
      return (void*)(p + 1);
 8da:	01078513          	addi	a0,a5,16
  }
}
 8de:	70e2                	ld	ra,56(sp)
 8e0:	7442                	ld	s0,48(sp)
 8e2:	74a2                	ld	s1,40(sp)
 8e4:	69e2                	ld	s3,24(sp)
 8e6:	6121                	addi	sp,sp,64
 8e8:	8082                	ret
 8ea:	7902                	ld	s2,32(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
 8f2:	b7f5                	j	8de <malloc+0xe2>
