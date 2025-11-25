
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	1be58593          	addi	a1,a1,446 # 11d0 <malloc+0xfe>
      1a:	4509                	li	a0,2
      1c:	40b000ef          	jal	c26 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	1f3000ef          	jal	a18 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	231000ef          	jal	a5e <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	18c58593          	addi	a1,a1,396 # 11e0 <malloc+0x10e>
      5c:	4509                	li	a0,2
      5e:	797000ef          	jal	ff4 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	3a3000ef          	jal	c06 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork(1);
      70:	4505                	li	a0,1
      72:	38d000ef          	jal	bfe <fork>
  if(pid == -1)
      76:	57fd                	li	a5,-1
      78:	00f50663          	beq	a0,a5,84 <fork1+0x1c>
    panic("fork");
  return pid;
}
      7c:	60a2                	ld	ra,8(sp)
      7e:	6402                	ld	s0,0(sp)
      80:	0141                	addi	sp,sp,16
      82:	8082                	ret
    panic("fork");
      84:	00001517          	auipc	a0,0x1
      88:	16450513          	addi	a0,a0,356 # 11e8 <malloc+0x116>
      8c:	fbfff0ef          	jal	4a <panic>

0000000000000090 <runcmd>:
{
      90:	7179                	addi	sp,sp,-48
      92:	f406                	sd	ra,40(sp)
      94:	f022                	sd	s0,32(sp)
      96:	1800                	addi	s0,sp,48
  if(cmd == 0)
      98:	c115                	beqz	a0,bc <runcmd+0x2c>
      9a:	ec26                	sd	s1,24(sp)
      9c:	84aa                	mv	s1,a0
  switch(cmd->type){
      9e:	4118                	lw	a4,0(a0)
      a0:	4795                	li	a5,5
      a2:	02e7e163          	bltu	a5,a4,c4 <runcmd+0x34>
      a6:	00056783          	lwu	a5,0(a0)
      aa:	078a                	slli	a5,a5,0x2
      ac:	00001717          	auipc	a4,0x1
      b0:	23c70713          	addi	a4,a4,572 # 12e8 <malloc+0x216>
      b4:	97ba                	add	a5,a5,a4
      b6:	439c                	lw	a5,0(a5)
      b8:	97ba                	add	a5,a5,a4
      ba:	8782                	jr	a5
      bc:	ec26                	sd	s1,24(sp)
    exit(1);
      be:	4505                	li	a0,1
      c0:	347000ef          	jal	c06 <exit>
    panic("runcmd");
      c4:	00001517          	auipc	a0,0x1
      c8:	12c50513          	addi	a0,a0,300 # 11f0 <malloc+0x11e>
      cc:	f7fff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      d0:	6508                	ld	a0,8(a0)
      d2:	c105                	beqz	a0,f2 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d4:	00848593          	addi	a1,s1,8
      d8:	367000ef          	jal	c3e <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      dc:	6490                	ld	a2,8(s1)
      de:	00001597          	auipc	a1,0x1
      e2:	11a58593          	addi	a1,a1,282 # 11f8 <malloc+0x126>
      e6:	4509                	li	a0,2
      e8:	70d000ef          	jal	ff4 <fprintf>
  exit(0);
      ec:	4501                	li	a0,0
      ee:	319000ef          	jal	c06 <exit>
      exit(1);
      f2:	4505                	li	a0,1
      f4:	313000ef          	jal	c06 <exit>
    close(rcmd->fd);
      f8:	5148                	lw	a0,36(a0)
      fa:	335000ef          	jal	c2e <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fe:	508c                	lw	a1,32(s1)
     100:	6888                	ld	a0,16(s1)
     102:	345000ef          	jal	c46 <open>
     106:	00054563          	bltz	a0,110 <runcmd+0x80>
    runcmd(rcmd->cmd);
     10a:	6488                	ld	a0,8(s1)
     10c:	f85ff0ef          	jal	90 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     110:	6890                	ld	a2,16(s1)
     112:	00001597          	auipc	a1,0x1
     116:	0f658593          	addi	a1,a1,246 # 1208 <malloc+0x136>
     11a:	4509                	li	a0,2
     11c:	6d9000ef          	jal	ff4 <fprintf>
      exit(1);
     120:	4505                	li	a0,1
     122:	2e5000ef          	jal	c06 <exit>
    if(fork1() == 0)
     126:	f43ff0ef          	jal	68 <fork1>
     12a:	e501                	bnez	a0,132 <runcmd+0xa2>
      runcmd(lcmd->left);
     12c:	6488                	ld	a0,8(s1)
     12e:	f63ff0ef          	jal	90 <runcmd>
    wait(0);
     132:	4501                	li	a0,0
     134:	2db000ef          	jal	c0e <wait>
    runcmd(lcmd->right);
     138:	6888                	ld	a0,16(s1)
     13a:	f57ff0ef          	jal	90 <runcmd>
    if(pipe(p) < 0)
     13e:	fd840513          	addi	a0,s0,-40
     142:	2d5000ef          	jal	c16 <pipe>
     146:	02054763          	bltz	a0,174 <runcmd+0xe4>
    if(fork1() == 0){
     14a:	f1fff0ef          	jal	68 <fork1>
     14e:	e90d                	bnez	a0,180 <runcmd+0xf0>
      close(1);
     150:	4505                	li	a0,1
     152:	2dd000ef          	jal	c2e <close>
      dup(p[1]);
     156:	fdc42503          	lw	a0,-36(s0)
     15a:	325000ef          	jal	c7e <dup>
      close(p[0]);
     15e:	fd842503          	lw	a0,-40(s0)
     162:	2cd000ef          	jal	c2e <close>
      close(p[1]);
     166:	fdc42503          	lw	a0,-36(s0)
     16a:	2c5000ef          	jal	c2e <close>
      runcmd(pcmd->left);
     16e:	6488                	ld	a0,8(s1)
     170:	f21ff0ef          	jal	90 <runcmd>
      panic("pipe");
     174:	00001517          	auipc	a0,0x1
     178:	0a450513          	addi	a0,a0,164 # 1218 <malloc+0x146>
     17c:	ecfff0ef          	jal	4a <panic>
    if(fork1() == 0){
     180:	ee9ff0ef          	jal	68 <fork1>
     184:	e115                	bnez	a0,1a8 <runcmd+0x118>
      close(0);
     186:	2a9000ef          	jal	c2e <close>
      dup(p[0]);
     18a:	fd842503          	lw	a0,-40(s0)
     18e:	2f1000ef          	jal	c7e <dup>
      close(p[0]);
     192:	fd842503          	lw	a0,-40(s0)
     196:	299000ef          	jal	c2e <close>
      close(p[1]);
     19a:	fdc42503          	lw	a0,-36(s0)
     19e:	291000ef          	jal	c2e <close>
      runcmd(pcmd->right);
     1a2:	6888                	ld	a0,16(s1)
     1a4:	eedff0ef          	jal	90 <runcmd>
    close(p[0]);
     1a8:	fd842503          	lw	a0,-40(s0)
     1ac:	283000ef          	jal	c2e <close>
    close(p[1]);
     1b0:	fdc42503          	lw	a0,-36(s0)
     1b4:	27b000ef          	jal	c2e <close>
    wait(0);
     1b8:	4501                	li	a0,0
     1ba:	255000ef          	jal	c0e <wait>
    wait(0);
     1be:	4501                	li	a0,0
     1c0:	24f000ef          	jal	c0e <wait>
    break;
     1c4:	b725                	j	ec <runcmd+0x5c>
    if(fork1() == 0)
     1c6:	ea3ff0ef          	jal	68 <fork1>
     1ca:	f20511e3          	bnez	a0,ec <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1ce:	6488                	ld	a0,8(s1)
     1d0:	ec1ff0ef          	jal	90 <runcmd>

00000000000001d4 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d4:	1101                	addi	sp,sp,-32
     1d6:	ec06                	sd	ra,24(sp)
     1d8:	e822                	sd	s0,16(sp)
     1da:	e426                	sd	s1,8(sp)
     1dc:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1de:	0a800513          	li	a0,168
     1e2:	6f1000ef          	jal	10d2 <malloc>
     1e6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e8:	0a800613          	li	a2,168
     1ec:	4581                	li	a1,0
     1ee:	02b000ef          	jal	a18 <memset>
  cmd->type = EXEC;
     1f2:	4785                	li	a5,1
     1f4:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f6:	8526                	mv	a0,s1
     1f8:	60e2                	ld	ra,24(sp)
     1fa:	6442                	ld	s0,16(sp)
     1fc:	64a2                	ld	s1,8(sp)
     1fe:	6105                	addi	sp,sp,32
     200:	8082                	ret

0000000000000202 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     202:	7139                	addi	sp,sp,-64
     204:	fc06                	sd	ra,56(sp)
     206:	f822                	sd	s0,48(sp)
     208:	f426                	sd	s1,40(sp)
     20a:	f04a                	sd	s2,32(sp)
     20c:	ec4e                	sd	s3,24(sp)
     20e:	e852                	sd	s4,16(sp)
     210:	e456                	sd	s5,8(sp)
     212:	e05a                	sd	s6,0(sp)
     214:	0080                	addi	s0,sp,64
     216:	8b2a                	mv	s6,a0
     218:	8aae                	mv	s5,a1
     21a:	8a32                	mv	s4,a2
     21c:	89b6                	mv	s3,a3
     21e:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     220:	02800513          	li	a0,40
     224:	6af000ef          	jal	10d2 <malloc>
     228:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     22a:	02800613          	li	a2,40
     22e:	4581                	li	a1,0
     230:	7e8000ef          	jal	a18 <memset>
  cmd->type = REDIR;
     234:	4789                	li	a5,2
     236:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     238:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     23c:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     240:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     244:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     248:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     24c:	8526                	mv	a0,s1
     24e:	70e2                	ld	ra,56(sp)
     250:	7442                	ld	s0,48(sp)
     252:	74a2                	ld	s1,40(sp)
     254:	7902                	ld	s2,32(sp)
     256:	69e2                	ld	s3,24(sp)
     258:	6a42                	ld	s4,16(sp)
     25a:	6aa2                	ld	s5,8(sp)
     25c:	6b02                	ld	s6,0(sp)
     25e:	6121                	addi	sp,sp,64
     260:	8082                	ret

0000000000000262 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     262:	7179                	addi	sp,sp,-48
     264:	f406                	sd	ra,40(sp)
     266:	f022                	sd	s0,32(sp)
     268:	ec26                	sd	s1,24(sp)
     26a:	e84a                	sd	s2,16(sp)
     26c:	e44e                	sd	s3,8(sp)
     26e:	1800                	addi	s0,sp,48
     270:	89aa                	mv	s3,a0
     272:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     274:	4561                	li	a0,24
     276:	65d000ef          	jal	10d2 <malloc>
     27a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27c:	4661                	li	a2,24
     27e:	4581                	li	a1,0
     280:	798000ef          	jal	a18 <memset>
  cmd->type = PIPE;
     284:	478d                	li	a5,3
     286:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     288:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     28c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     290:	8526                	mv	a0,s1
     292:	70a2                	ld	ra,40(sp)
     294:	7402                	ld	s0,32(sp)
     296:	64e2                	ld	s1,24(sp)
     298:	6942                	ld	s2,16(sp)
     29a:	69a2                	ld	s3,8(sp)
     29c:	6145                	addi	sp,sp,48
     29e:	8082                	ret

00000000000002a0 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     2a0:	7179                	addi	sp,sp,-48
     2a2:	f406                	sd	ra,40(sp)
     2a4:	f022                	sd	s0,32(sp)
     2a6:	ec26                	sd	s1,24(sp)
     2a8:	e84a                	sd	s2,16(sp)
     2aa:	e44e                	sd	s3,8(sp)
     2ac:	1800                	addi	s0,sp,48
     2ae:	89aa                	mv	s3,a0
     2b0:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b2:	4561                	li	a0,24
     2b4:	61f000ef          	jal	10d2 <malloc>
     2b8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2ba:	4661                	li	a2,24
     2bc:	4581                	li	a1,0
     2be:	75a000ef          	jal	a18 <memset>
  cmd->type = LIST;
     2c2:	4791                	li	a5,4
     2c4:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c6:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2ca:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2ce:	8526                	mv	a0,s1
     2d0:	70a2                	ld	ra,40(sp)
     2d2:	7402                	ld	s0,32(sp)
     2d4:	64e2                	ld	s1,24(sp)
     2d6:	6942                	ld	s2,16(sp)
     2d8:	69a2                	ld	s3,8(sp)
     2da:	6145                	addi	sp,sp,48
     2dc:	8082                	ret

00000000000002de <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2de:	1101                	addi	sp,sp,-32
     2e0:	ec06                	sd	ra,24(sp)
     2e2:	e822                	sd	s0,16(sp)
     2e4:	e426                	sd	s1,8(sp)
     2e6:	e04a                	sd	s2,0(sp)
     2e8:	1000                	addi	s0,sp,32
     2ea:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ec:	4541                	li	a0,16
     2ee:	5e5000ef          	jal	10d2 <malloc>
     2f2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f4:	4641                	li	a2,16
     2f6:	4581                	li	a1,0
     2f8:	720000ef          	jal	a18 <memset>
  cmd->type = BACK;
     2fc:	4795                	li	a5,5
     2fe:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     300:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     304:	8526                	mv	a0,s1
     306:	60e2                	ld	ra,24(sp)
     308:	6442                	ld	s0,16(sp)
     30a:	64a2                	ld	s1,8(sp)
     30c:	6902                	ld	s2,0(sp)
     30e:	6105                	addi	sp,sp,32
     310:	8082                	ret

0000000000000312 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     312:	7139                	addi	sp,sp,-64
     314:	fc06                	sd	ra,56(sp)
     316:	f822                	sd	s0,48(sp)
     318:	f426                	sd	s1,40(sp)
     31a:	f04a                	sd	s2,32(sp)
     31c:	ec4e                	sd	s3,24(sp)
     31e:	e852                	sd	s4,16(sp)
     320:	e456                	sd	s5,8(sp)
     322:	e05a                	sd	s6,0(sp)
     324:	0080                	addi	s0,sp,64
     326:	8a2a                	mv	s4,a0
     328:	892e                	mv	s2,a1
     32a:	8ab2                	mv	s5,a2
     32c:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32e:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     330:	00002997          	auipc	s3,0x2
     334:	cd898993          	addi	s3,s3,-808 # 2008 <whitespace>
     338:	00b4fc63          	bgeu	s1,a1,350 <gettoken+0x3e>
     33c:	0004c583          	lbu	a1,0(s1)
     340:	854e                	mv	a0,s3
     342:	6f8000ef          	jal	a3a <strchr>
     346:	c509                	beqz	a0,350 <gettoken+0x3e>
    s++;
     348:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     34a:	fe9919e3          	bne	s2,s1,33c <gettoken+0x2a>
     34e:	84ca                	mv	s1,s2
  if(q)
     350:	000a8463          	beqz	s5,358 <gettoken+0x46>
    *q = s;
     354:	009ab023          	sd	s1,0(s5)
  ret = *s;
     358:	0004c783          	lbu	a5,0(s1)
     35c:	00078a9b          	sext.w	s5,a5
  switch(*s){
     360:	03c00713          	li	a4,60
     364:	06f76463          	bltu	a4,a5,3cc <gettoken+0xba>
     368:	03a00713          	li	a4,58
     36c:	00f76e63          	bltu	a4,a5,388 <gettoken+0x76>
     370:	cf89                	beqz	a5,38a <gettoken+0x78>
     372:	02600713          	li	a4,38
     376:	00e78963          	beq	a5,a4,388 <gettoken+0x76>
     37a:	fd87879b          	addiw	a5,a5,-40
     37e:	0ff7f793          	zext.b	a5,a5
     382:	4705                	li	a4,1
     384:	06f76b63          	bltu	a4,a5,3fa <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     388:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     38a:	000b0463          	beqz	s6,392 <gettoken+0x80>
    *eq = s;
     38e:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     392:	00002997          	auipc	s3,0x2
     396:	c7698993          	addi	s3,s3,-906 # 2008 <whitespace>
     39a:	0124fc63          	bgeu	s1,s2,3b2 <gettoken+0xa0>
     39e:	0004c583          	lbu	a1,0(s1)
     3a2:	854e                	mv	a0,s3
     3a4:	696000ef          	jal	a3a <strchr>
     3a8:	c509                	beqz	a0,3b2 <gettoken+0xa0>
    s++;
     3aa:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3ac:	fe9919e3          	bne	s2,s1,39e <gettoken+0x8c>
     3b0:	84ca                	mv	s1,s2
  *ps = s;
     3b2:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b6:	8556                	mv	a0,s5
     3b8:	70e2                	ld	ra,56(sp)
     3ba:	7442                	ld	s0,48(sp)
     3bc:	74a2                	ld	s1,40(sp)
     3be:	7902                	ld	s2,32(sp)
     3c0:	69e2                	ld	s3,24(sp)
     3c2:	6a42                	ld	s4,16(sp)
     3c4:	6aa2                	ld	s5,8(sp)
     3c6:	6b02                	ld	s6,0(sp)
     3c8:	6121                	addi	sp,sp,64
     3ca:	8082                	ret
  switch(*s){
     3cc:	03e00713          	li	a4,62
     3d0:	02e79163          	bne	a5,a4,3f2 <gettoken+0xe0>
    s++;
     3d4:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d8:	0014c703          	lbu	a4,1(s1)
     3dc:	03e00793          	li	a5,62
      s++;
     3e0:	0489                	addi	s1,s1,2
      ret = '+';
     3e2:	02b00a93          	li	s5,43
    if(*s == '>'){
     3e6:	faf702e3          	beq	a4,a5,38a <gettoken+0x78>
    s++;
     3ea:	84b6                	mv	s1,a3
  ret = *s;
     3ec:	03e00a93          	li	s5,62
     3f0:	bf69                	j	38a <gettoken+0x78>
  switch(*s){
     3f2:	07c00713          	li	a4,124
     3f6:	f8e789e3          	beq	a5,a4,388 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3fa:	00002997          	auipc	s3,0x2
     3fe:	c0e98993          	addi	s3,s3,-1010 # 2008 <whitespace>
     402:	00002a97          	auipc	s5,0x2
     406:	bfea8a93          	addi	s5,s5,-1026 # 2000 <symbols>
     40a:	0324fd63          	bgeu	s1,s2,444 <gettoken+0x132>
     40e:	0004c583          	lbu	a1,0(s1)
     412:	854e                	mv	a0,s3
     414:	626000ef          	jal	a3a <strchr>
     418:	e11d                	bnez	a0,43e <gettoken+0x12c>
     41a:	0004c583          	lbu	a1,0(s1)
     41e:	8556                	mv	a0,s5
     420:	61a000ef          	jal	a3a <strchr>
     424:	e911                	bnez	a0,438 <gettoken+0x126>
      s++;
     426:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     428:	fe9913e3          	bne	s2,s1,40e <gettoken+0xfc>
  if(eq)
     42c:	84ca                	mv	s1,s2
    ret = 'a';
     42e:	06100a93          	li	s5,97
  if(eq)
     432:	f40b1ee3          	bnez	s6,38e <gettoken+0x7c>
     436:	bfb5                	j	3b2 <gettoken+0xa0>
    ret = 'a';
     438:	06100a93          	li	s5,97
     43c:	b7b9                	j	38a <gettoken+0x78>
     43e:	06100a93          	li	s5,97
     442:	b7a1                	j	38a <gettoken+0x78>
     444:	06100a93          	li	s5,97
  if(eq)
     448:	f40b13e3          	bnez	s6,38e <gettoken+0x7c>
     44c:	b79d                	j	3b2 <gettoken+0xa0>

000000000000044e <peek>:

int
peek(char **ps, char *es, char *toks)
{
     44e:	7139                	addi	sp,sp,-64
     450:	fc06                	sd	ra,56(sp)
     452:	f822                	sd	s0,48(sp)
     454:	f426                	sd	s1,40(sp)
     456:	f04a                	sd	s2,32(sp)
     458:	ec4e                	sd	s3,24(sp)
     45a:	e852                	sd	s4,16(sp)
     45c:	e456                	sd	s5,8(sp)
     45e:	0080                	addi	s0,sp,64
     460:	8a2a                	mv	s4,a0
     462:	892e                	mv	s2,a1
     464:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     466:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     468:	00002997          	auipc	s3,0x2
     46c:	ba098993          	addi	s3,s3,-1120 # 2008 <whitespace>
     470:	00b4fc63          	bgeu	s1,a1,488 <peek+0x3a>
     474:	0004c583          	lbu	a1,0(s1)
     478:	854e                	mv	a0,s3
     47a:	5c0000ef          	jal	a3a <strchr>
     47e:	c509                	beqz	a0,488 <peek+0x3a>
    s++;
     480:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     482:	fe9919e3          	bne	s2,s1,474 <peek+0x26>
     486:	84ca                	mv	s1,s2
  *ps = s;
     488:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     48c:	0004c583          	lbu	a1,0(s1)
     490:	4501                	li	a0,0
     492:	e991                	bnez	a1,4a6 <peek+0x58>
}
     494:	70e2                	ld	ra,56(sp)
     496:	7442                	ld	s0,48(sp)
     498:	74a2                	ld	s1,40(sp)
     49a:	7902                	ld	s2,32(sp)
     49c:	69e2                	ld	s3,24(sp)
     49e:	6a42                	ld	s4,16(sp)
     4a0:	6aa2                	ld	s5,8(sp)
     4a2:	6121                	addi	sp,sp,64
     4a4:	8082                	ret
  return *s && strchr(toks, *s);
     4a6:	8556                	mv	a0,s5
     4a8:	592000ef          	jal	a3a <strchr>
     4ac:	00a03533          	snez	a0,a0
     4b0:	b7d5                	j	494 <peek+0x46>

00000000000004b2 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4b2:	711d                	addi	sp,sp,-96
     4b4:	ec86                	sd	ra,88(sp)
     4b6:	e8a2                	sd	s0,80(sp)
     4b8:	e4a6                	sd	s1,72(sp)
     4ba:	e0ca                	sd	s2,64(sp)
     4bc:	fc4e                	sd	s3,56(sp)
     4be:	f852                	sd	s4,48(sp)
     4c0:	f456                	sd	s5,40(sp)
     4c2:	f05a                	sd	s6,32(sp)
     4c4:	ec5e                	sd	s7,24(sp)
     4c6:	1080                	addi	s0,sp,96
     4c8:	8a2a                	mv	s4,a0
     4ca:	89ae                	mv	s3,a1
     4cc:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4ce:	00001a97          	auipc	s5,0x1
     4d2:	d72a8a93          	addi	s5,s5,-654 # 1240 <malloc+0x16e>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d6:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
     4da:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
     4de:	a00d                	j	500 <parseredirs+0x4e>
      panic("missing file for redirection");
     4e0:	00001517          	auipc	a0,0x1
     4e4:	d4050513          	addi	a0,a0,-704 # 1220 <malloc+0x14e>
     4e8:	b63ff0ef          	jal	4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4ec:	4701                	li	a4,0
     4ee:	4681                	li	a3,0
     4f0:	fa043603          	ld	a2,-96(s0)
     4f4:	fa843583          	ld	a1,-88(s0)
     4f8:	8552                	mv	a0,s4
     4fa:	d09ff0ef          	jal	202 <redircmd>
     4fe:	8a2a                	mv	s4,a0
  while(peek(ps, es, "<>")){
     500:	8656                	mv	a2,s5
     502:	85ca                	mv	a1,s2
     504:	854e                	mv	a0,s3
     506:	f49ff0ef          	jal	44e <peek>
     50a:	c525                	beqz	a0,572 <parseredirs+0xc0>
    tok = gettoken(ps, es, 0, 0);
     50c:	4681                	li	a3,0
     50e:	4601                	li	a2,0
     510:	85ca                	mv	a1,s2
     512:	854e                	mv	a0,s3
     514:	dffff0ef          	jal	312 <gettoken>
     518:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     51a:	fa040693          	addi	a3,s0,-96
     51e:	fa840613          	addi	a2,s0,-88
     522:	85ca                	mv	a1,s2
     524:	854e                	mv	a0,s3
     526:	dedff0ef          	jal	312 <gettoken>
     52a:	fb651be3          	bne	a0,s6,4e0 <parseredirs+0x2e>
    switch(tok){
     52e:	fb748fe3          	beq	s1,s7,4ec <parseredirs+0x3a>
     532:	03e00793          	li	a5,62
     536:	02f48263          	beq	s1,a5,55a <parseredirs+0xa8>
     53a:	02b00793          	li	a5,43
     53e:	fcf491e3          	bne	s1,a5,500 <parseredirs+0x4e>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     542:	4705                	li	a4,1
     544:	20100693          	li	a3,513
     548:	fa043603          	ld	a2,-96(s0)
     54c:	fa843583          	ld	a1,-88(s0)
     550:	8552                	mv	a0,s4
     552:	cb1ff0ef          	jal	202 <redircmd>
     556:	8a2a                	mv	s4,a0
      break;
     558:	b765                	j	500 <parseredirs+0x4e>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     55a:	4705                	li	a4,1
     55c:	60100693          	li	a3,1537
     560:	fa043603          	ld	a2,-96(s0)
     564:	fa843583          	ld	a1,-88(s0)
     568:	8552                	mv	a0,s4
     56a:	c99ff0ef          	jal	202 <redircmd>
     56e:	8a2a                	mv	s4,a0
      break;
     570:	bf41                	j	500 <parseredirs+0x4e>
    }
  }
  return cmd;
}
     572:	8552                	mv	a0,s4
     574:	60e6                	ld	ra,88(sp)
     576:	6446                	ld	s0,80(sp)
     578:	64a6                	ld	s1,72(sp)
     57a:	6906                	ld	s2,64(sp)
     57c:	79e2                	ld	s3,56(sp)
     57e:	7a42                	ld	s4,48(sp)
     580:	7aa2                	ld	s5,40(sp)
     582:	7b02                	ld	s6,32(sp)
     584:	6be2                	ld	s7,24(sp)
     586:	6125                	addi	sp,sp,96
     588:	8082                	ret

000000000000058a <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     58a:	7159                	addi	sp,sp,-112
     58c:	f486                	sd	ra,104(sp)
     58e:	f0a2                	sd	s0,96(sp)
     590:	eca6                	sd	s1,88(sp)
     592:	e0d2                	sd	s4,64(sp)
     594:	fc56                	sd	s5,56(sp)
     596:	1880                	addi	s0,sp,112
     598:	8a2a                	mv	s4,a0
     59a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     59c:	00001617          	auipc	a2,0x1
     5a0:	cac60613          	addi	a2,a2,-852 # 1248 <malloc+0x176>
     5a4:	eabff0ef          	jal	44e <peek>
     5a8:	e915                	bnez	a0,5dc <parseexec+0x52>
     5aa:	e8ca                	sd	s2,80(sp)
     5ac:	e4ce                	sd	s3,72(sp)
     5ae:	f85a                	sd	s6,48(sp)
     5b0:	f45e                	sd	s7,40(sp)
     5b2:	f062                	sd	s8,32(sp)
     5b4:	ec66                	sd	s9,24(sp)
     5b6:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5b8:	c1dff0ef          	jal	1d4 <execcmd>
     5bc:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5be:	8656                	mv	a2,s5
     5c0:	85d2                	mv	a1,s4
     5c2:	ef1ff0ef          	jal	4b2 <parseredirs>
     5c6:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5c8:	008c0913          	addi	s2,s8,8
     5cc:	00001b17          	auipc	s6,0x1
     5d0:	c9cb0b13          	addi	s6,s6,-868 # 1268 <malloc+0x196>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     5d4:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5d8:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     5da:	a815                	j	60e <parseexec+0x84>
    return parseblock(ps, es);
     5dc:	85d6                	mv	a1,s5
     5de:	8552                	mv	a0,s4
     5e0:	170000ef          	jal	750 <parseblock>
     5e4:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5e6:	8526                	mv	a0,s1
     5e8:	70a6                	ld	ra,104(sp)
     5ea:	7406                	ld	s0,96(sp)
     5ec:	64e6                	ld	s1,88(sp)
     5ee:	6a06                	ld	s4,64(sp)
     5f0:	7ae2                	ld	s5,56(sp)
     5f2:	6165                	addi	sp,sp,112
     5f4:	8082                	ret
      panic("syntax");
     5f6:	00001517          	auipc	a0,0x1
     5fa:	c5a50513          	addi	a0,a0,-934 # 1250 <malloc+0x17e>
     5fe:	a4dff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     602:	8656                	mv	a2,s5
     604:	85d2                	mv	a1,s4
     606:	8526                	mv	a0,s1
     608:	eabff0ef          	jal	4b2 <parseredirs>
     60c:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     60e:	865a                	mv	a2,s6
     610:	85d6                	mv	a1,s5
     612:	8552                	mv	a0,s4
     614:	e3bff0ef          	jal	44e <peek>
     618:	ed15                	bnez	a0,654 <parseexec+0xca>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     61a:	f9040693          	addi	a3,s0,-112
     61e:	f9840613          	addi	a2,s0,-104
     622:	85d6                	mv	a1,s5
     624:	8552                	mv	a0,s4
     626:	cedff0ef          	jal	312 <gettoken>
     62a:	c50d                	beqz	a0,654 <parseexec+0xca>
    if(tok != 'a')
     62c:	fd9515e3          	bne	a0,s9,5f6 <parseexec+0x6c>
    cmd->argv[argc] = q;
     630:	f9843783          	ld	a5,-104(s0)
     634:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     638:	f9043783          	ld	a5,-112(s0)
     63c:	04f93823          	sd	a5,80(s2)
    argc++;
     640:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     642:	0921                	addi	s2,s2,8
     644:	fb799fe3          	bne	s3,s7,602 <parseexec+0x78>
      panic("too many args");
     648:	00001517          	auipc	a0,0x1
     64c:	c1050513          	addi	a0,a0,-1008 # 1258 <malloc+0x186>
     650:	9fbff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     654:	098e                	slli	s3,s3,0x3
     656:	9c4e                	add	s8,s8,s3
     658:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     65c:	040c3c23          	sd	zero,88(s8)
     660:	6946                	ld	s2,80(sp)
     662:	69a6                	ld	s3,72(sp)
     664:	7b42                	ld	s6,48(sp)
     666:	7ba2                	ld	s7,40(sp)
     668:	7c02                	ld	s8,32(sp)
     66a:	6ce2                	ld	s9,24(sp)
  return ret;
     66c:	bfad                	j	5e6 <parseexec+0x5c>

000000000000066e <parsepipe>:
{
     66e:	7179                	addi	sp,sp,-48
     670:	f406                	sd	ra,40(sp)
     672:	f022                	sd	s0,32(sp)
     674:	ec26                	sd	s1,24(sp)
     676:	e84a                	sd	s2,16(sp)
     678:	e44e                	sd	s3,8(sp)
     67a:	1800                	addi	s0,sp,48
     67c:	892a                	mv	s2,a0
     67e:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     680:	f0bff0ef          	jal	58a <parseexec>
     684:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     686:	00001617          	auipc	a2,0x1
     68a:	bea60613          	addi	a2,a2,-1046 # 1270 <malloc+0x19e>
     68e:	85ce                	mv	a1,s3
     690:	854a                	mv	a0,s2
     692:	dbdff0ef          	jal	44e <peek>
     696:	e909                	bnez	a0,6a8 <parsepipe+0x3a>
}
     698:	8526                	mv	a0,s1
     69a:	70a2                	ld	ra,40(sp)
     69c:	7402                	ld	s0,32(sp)
     69e:	64e2                	ld	s1,24(sp)
     6a0:	6942                	ld	s2,16(sp)
     6a2:	69a2                	ld	s3,8(sp)
     6a4:	6145                	addi	sp,sp,48
     6a6:	8082                	ret
    gettoken(ps, es, 0, 0);
     6a8:	4681                	li	a3,0
     6aa:	4601                	li	a2,0
     6ac:	85ce                	mv	a1,s3
     6ae:	854a                	mv	a0,s2
     6b0:	c63ff0ef          	jal	312 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6b4:	85ce                	mv	a1,s3
     6b6:	854a                	mv	a0,s2
     6b8:	fb7ff0ef          	jal	66e <parsepipe>
     6bc:	85aa                	mv	a1,a0
     6be:	8526                	mv	a0,s1
     6c0:	ba3ff0ef          	jal	262 <pipecmd>
     6c4:	84aa                	mv	s1,a0
  return cmd;
     6c6:	bfc9                	j	698 <parsepipe+0x2a>

00000000000006c8 <parseline>:
{
     6c8:	7179                	addi	sp,sp,-48
     6ca:	f406                	sd	ra,40(sp)
     6cc:	f022                	sd	s0,32(sp)
     6ce:	ec26                	sd	s1,24(sp)
     6d0:	e84a                	sd	s2,16(sp)
     6d2:	e44e                	sd	s3,8(sp)
     6d4:	e052                	sd	s4,0(sp)
     6d6:	1800                	addi	s0,sp,48
     6d8:	892a                	mv	s2,a0
     6da:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6dc:	f93ff0ef          	jal	66e <parsepipe>
     6e0:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6e2:	00001a17          	auipc	s4,0x1
     6e6:	b96a0a13          	addi	s4,s4,-1130 # 1278 <malloc+0x1a6>
     6ea:	a819                	j	700 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     6ec:	4681                	li	a3,0
     6ee:	4601                	li	a2,0
     6f0:	85ce                	mv	a1,s3
     6f2:	854a                	mv	a0,s2
     6f4:	c1fff0ef          	jal	312 <gettoken>
    cmd = backcmd(cmd);
     6f8:	8526                	mv	a0,s1
     6fa:	be5ff0ef          	jal	2de <backcmd>
     6fe:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     700:	8652                	mv	a2,s4
     702:	85ce                	mv	a1,s3
     704:	854a                	mv	a0,s2
     706:	d49ff0ef          	jal	44e <peek>
     70a:	f16d                	bnez	a0,6ec <parseline+0x24>
  if(peek(ps, es, ";")){
     70c:	00001617          	auipc	a2,0x1
     710:	b7460613          	addi	a2,a2,-1164 # 1280 <malloc+0x1ae>
     714:	85ce                	mv	a1,s3
     716:	854a                	mv	a0,s2
     718:	d37ff0ef          	jal	44e <peek>
     71c:	e911                	bnez	a0,730 <parseline+0x68>
}
     71e:	8526                	mv	a0,s1
     720:	70a2                	ld	ra,40(sp)
     722:	7402                	ld	s0,32(sp)
     724:	64e2                	ld	s1,24(sp)
     726:	6942                	ld	s2,16(sp)
     728:	69a2                	ld	s3,8(sp)
     72a:	6a02                	ld	s4,0(sp)
     72c:	6145                	addi	sp,sp,48
     72e:	8082                	ret
    gettoken(ps, es, 0, 0);
     730:	4681                	li	a3,0
     732:	4601                	li	a2,0
     734:	85ce                	mv	a1,s3
     736:	854a                	mv	a0,s2
     738:	bdbff0ef          	jal	312 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     73c:	85ce                	mv	a1,s3
     73e:	854a                	mv	a0,s2
     740:	f89ff0ef          	jal	6c8 <parseline>
     744:	85aa                	mv	a1,a0
     746:	8526                	mv	a0,s1
     748:	b59ff0ef          	jal	2a0 <listcmd>
     74c:	84aa                	mv	s1,a0
  return cmd;
     74e:	bfc1                	j	71e <parseline+0x56>

0000000000000750 <parseblock>:
{
     750:	7179                	addi	sp,sp,-48
     752:	f406                	sd	ra,40(sp)
     754:	f022                	sd	s0,32(sp)
     756:	ec26                	sd	s1,24(sp)
     758:	e84a                	sd	s2,16(sp)
     75a:	e44e                	sd	s3,8(sp)
     75c:	1800                	addi	s0,sp,48
     75e:	84aa                	mv	s1,a0
     760:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     762:	00001617          	auipc	a2,0x1
     766:	ae660613          	addi	a2,a2,-1306 # 1248 <malloc+0x176>
     76a:	ce5ff0ef          	jal	44e <peek>
     76e:	c539                	beqz	a0,7bc <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     770:	4681                	li	a3,0
     772:	4601                	li	a2,0
     774:	85ca                	mv	a1,s2
     776:	8526                	mv	a0,s1
     778:	b9bff0ef          	jal	312 <gettoken>
  cmd = parseline(ps, es);
     77c:	85ca                	mv	a1,s2
     77e:	8526                	mv	a0,s1
     780:	f49ff0ef          	jal	6c8 <parseline>
     784:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     786:	00001617          	auipc	a2,0x1
     78a:	b1260613          	addi	a2,a2,-1262 # 1298 <malloc+0x1c6>
     78e:	85ca                	mv	a1,s2
     790:	8526                	mv	a0,s1
     792:	cbdff0ef          	jal	44e <peek>
     796:	c90d                	beqz	a0,7c8 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     798:	4681                	li	a3,0
     79a:	4601                	li	a2,0
     79c:	85ca                	mv	a1,s2
     79e:	8526                	mv	a0,s1
     7a0:	b73ff0ef          	jal	312 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7a4:	864a                	mv	a2,s2
     7a6:	85a6                	mv	a1,s1
     7a8:	854e                	mv	a0,s3
     7aa:	d09ff0ef          	jal	4b2 <parseredirs>
}
     7ae:	70a2                	ld	ra,40(sp)
     7b0:	7402                	ld	s0,32(sp)
     7b2:	64e2                	ld	s1,24(sp)
     7b4:	6942                	ld	s2,16(sp)
     7b6:	69a2                	ld	s3,8(sp)
     7b8:	6145                	addi	sp,sp,48
     7ba:	8082                	ret
    panic("parseblock");
     7bc:	00001517          	auipc	a0,0x1
     7c0:	acc50513          	addi	a0,a0,-1332 # 1288 <malloc+0x1b6>
     7c4:	887ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7c8:	00001517          	auipc	a0,0x1
     7cc:	ad850513          	addi	a0,a0,-1320 # 12a0 <malloc+0x1ce>
     7d0:	87bff0ef          	jal	4a <panic>

00000000000007d4 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7d4:	1101                	addi	sp,sp,-32
     7d6:	ec06                	sd	ra,24(sp)
     7d8:	e822                	sd	s0,16(sp)
     7da:	e426                	sd	s1,8(sp)
     7dc:	1000                	addi	s0,sp,32
     7de:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7e0:	c131                	beqz	a0,824 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7e2:	4118                	lw	a4,0(a0)
     7e4:	4795                	li	a5,5
     7e6:	02e7ef63          	bltu	a5,a4,824 <nulterminate+0x50>
     7ea:	00056783          	lwu	a5,0(a0)
     7ee:	078a                	slli	a5,a5,0x2
     7f0:	00001717          	auipc	a4,0x1
     7f4:	b1070713          	addi	a4,a4,-1264 # 1300 <malloc+0x22e>
     7f8:	97ba                	add	a5,a5,a4
     7fa:	439c                	lw	a5,0(a5)
     7fc:	97ba                	add	a5,a5,a4
     7fe:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     800:	651c                	ld	a5,8(a0)
     802:	c38d                	beqz	a5,824 <nulterminate+0x50>
     804:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     808:	67b8                	ld	a4,72(a5)
     80a:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     80e:	07a1                	addi	a5,a5,8
     810:	ff87b703          	ld	a4,-8(a5)
     814:	fb75                	bnez	a4,808 <nulterminate+0x34>
     816:	a039                	j	824 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     818:	6508                	ld	a0,8(a0)
     81a:	fbbff0ef          	jal	7d4 <nulterminate>
    *rcmd->efile = 0;
     81e:	6c9c                	ld	a5,24(s1)
     820:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     824:	8526                	mv	a0,s1
     826:	60e2                	ld	ra,24(sp)
     828:	6442                	ld	s0,16(sp)
     82a:	64a2                	ld	s1,8(sp)
     82c:	6105                	addi	sp,sp,32
     82e:	8082                	ret
    nulterminate(pcmd->left);
     830:	6508                	ld	a0,8(a0)
     832:	fa3ff0ef          	jal	7d4 <nulterminate>
    nulterminate(pcmd->right);
     836:	6888                	ld	a0,16(s1)
     838:	f9dff0ef          	jal	7d4 <nulterminate>
    break;
     83c:	b7e5                	j	824 <nulterminate+0x50>
    nulterminate(lcmd->left);
     83e:	6508                	ld	a0,8(a0)
     840:	f95ff0ef          	jal	7d4 <nulterminate>
    nulterminate(lcmd->right);
     844:	6888                	ld	a0,16(s1)
     846:	f8fff0ef          	jal	7d4 <nulterminate>
    break;
     84a:	bfe9                	j	824 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     84c:	6508                	ld	a0,8(a0)
     84e:	f87ff0ef          	jal	7d4 <nulterminate>
    break;
     852:	bfc9                	j	824 <nulterminate+0x50>

0000000000000854 <parsecmd>:
{
     854:	7179                	addi	sp,sp,-48
     856:	f406                	sd	ra,40(sp)
     858:	f022                	sd	s0,32(sp)
     85a:	ec26                	sd	s1,24(sp)
     85c:	e84a                	sd	s2,16(sp)
     85e:	1800                	addi	s0,sp,48
     860:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     864:	84aa                	mv	s1,a0
     866:	188000ef          	jal	9ee <strlen>
     86a:	1502                	slli	a0,a0,0x20
     86c:	9101                	srli	a0,a0,0x20
     86e:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     870:	85a6                	mv	a1,s1
     872:	fd840513          	addi	a0,s0,-40
     876:	e53ff0ef          	jal	6c8 <parseline>
     87a:	892a                	mv	s2,a0
  peek(&s, es, "");
     87c:	00001617          	auipc	a2,0x1
     880:	95c60613          	addi	a2,a2,-1700 # 11d8 <malloc+0x106>
     884:	85a6                	mv	a1,s1
     886:	fd840513          	addi	a0,s0,-40
     88a:	bc5ff0ef          	jal	44e <peek>
  if(s != es){
     88e:	fd843603          	ld	a2,-40(s0)
     892:	00961c63          	bne	a2,s1,8aa <parsecmd+0x56>
  nulterminate(cmd);
     896:	854a                	mv	a0,s2
     898:	f3dff0ef          	jal	7d4 <nulterminate>
}
     89c:	854a                	mv	a0,s2
     89e:	70a2                	ld	ra,40(sp)
     8a0:	7402                	ld	s0,32(sp)
     8a2:	64e2                	ld	s1,24(sp)
     8a4:	6942                	ld	s2,16(sp)
     8a6:	6145                	addi	sp,sp,48
     8a8:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8aa:	00001597          	auipc	a1,0x1
     8ae:	a0e58593          	addi	a1,a1,-1522 # 12b8 <malloc+0x1e6>
     8b2:	4509                	li	a0,2
     8b4:	740000ef          	jal	ff4 <fprintf>
    panic("syntax");
     8b8:	00001517          	auipc	a0,0x1
     8bc:	99850513          	addi	a0,a0,-1640 # 1250 <malloc+0x17e>
     8c0:	f8aff0ef          	jal	4a <panic>

00000000000008c4 <main>:
{
     8c4:	7179                	addi	sp,sp,-48
     8c6:	f406                	sd	ra,40(sp)
     8c8:	f022                	sd	s0,32(sp)
     8ca:	ec26                	sd	s1,24(sp)
     8cc:	e84a                	sd	s2,16(sp)
     8ce:	e44e                	sd	s3,8(sp)
     8d0:	e052                	sd	s4,0(sp)
     8d2:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     8d4:	00001497          	auipc	s1,0x1
     8d8:	9f448493          	addi	s1,s1,-1548 # 12c8 <malloc+0x1f6>
     8dc:	4589                	li	a1,2
     8de:	8526                	mv	a0,s1
     8e0:	366000ef          	jal	c46 <open>
     8e4:	00054763          	bltz	a0,8f2 <main+0x2e>
    if(fd >= 3){
     8e8:	4789                	li	a5,2
     8ea:	fea7d9e3          	bge	a5,a0,8dc <main+0x18>
      close(fd);
     8ee:	340000ef          	jal	c2e <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     8f2:	00001497          	auipc	s1,0x1
     8f6:	72e48493          	addi	s1,s1,1838 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     8fa:	06300913          	li	s2,99
     8fe:	02000993          	li	s3,32
     902:	a039                	j	910 <main+0x4c>
    if(fork1() == 0)
     904:	f64ff0ef          	jal	68 <fork1>
     908:	c93d                	beqz	a0,97e <main+0xba>
    wait(0);
     90a:	4501                	li	a0,0
     90c:	302000ef          	jal	c0e <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     910:	06400593          	li	a1,100
     914:	8526                	mv	a0,s1
     916:	eeaff0ef          	jal	0 <getcmd>
     91a:	06054a63          	bltz	a0,98e <main+0xca>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     91e:	0004c783          	lbu	a5,0(s1)
     922:	ff2791e3          	bne	a5,s2,904 <main+0x40>
     926:	0014c703          	lbu	a4,1(s1)
     92a:	06400793          	li	a5,100
     92e:	fcf71be3          	bne	a4,a5,904 <main+0x40>
     932:	0024c783          	lbu	a5,2(s1)
     936:	fd3797e3          	bne	a5,s3,904 <main+0x40>
      buf[strlen(buf)-1] = 0;  // chop \n
     93a:	00001a17          	auipc	s4,0x1
     93e:	6e6a0a13          	addi	s4,s4,1766 # 2020 <buf.0>
     942:	8552                	mv	a0,s4
     944:	0aa000ef          	jal	9ee <strlen>
     948:	fff5079b          	addiw	a5,a0,-1
     94c:	1782                	slli	a5,a5,0x20
     94e:	9381                	srli	a5,a5,0x20
     950:	9a3e                	add	s4,s4,a5
     952:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     956:	00001517          	auipc	a0,0x1
     95a:	6cd50513          	addi	a0,a0,1741 # 2023 <buf.0+0x3>
     95e:	318000ef          	jal	c76 <chdir>
     962:	fa0557e3          	bgez	a0,910 <main+0x4c>
        fprintf(2, "cannot cd %s\n", buf+3);
     966:	00001617          	auipc	a2,0x1
     96a:	6bd60613          	addi	a2,a2,1725 # 2023 <buf.0+0x3>
     96e:	00001597          	auipc	a1,0x1
     972:	96258593          	addi	a1,a1,-1694 # 12d0 <malloc+0x1fe>
     976:	4509                	li	a0,2
     978:	67c000ef          	jal	ff4 <fprintf>
     97c:	bf51                	j	910 <main+0x4c>
      runcmd(parsecmd(buf));
     97e:	00001517          	auipc	a0,0x1
     982:	6a250513          	addi	a0,a0,1698 # 2020 <buf.0>
     986:	ecfff0ef          	jal	854 <parsecmd>
     98a:	f06ff0ef          	jal	90 <runcmd>
  exit(0);
     98e:	4501                	li	a0,0
     990:	276000ef          	jal	c06 <exit>

0000000000000994 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     994:	1141                	addi	sp,sp,-16
     996:	e406                	sd	ra,8(sp)
     998:	e022                	sd	s0,0(sp)
     99a:	0800                	addi	s0,sp,16
  extern int main();
  main();
     99c:	f29ff0ef          	jal	8c4 <main>
  exit(0);
     9a0:	4501                	li	a0,0
     9a2:	264000ef          	jal	c06 <exit>

00000000000009a6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9a6:	1141                	addi	sp,sp,-16
     9a8:	e422                	sd	s0,8(sp)
     9aa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9ac:	87aa                	mv	a5,a0
     9ae:	0585                	addi	a1,a1,1
     9b0:	0785                	addi	a5,a5,1
     9b2:	fff5c703          	lbu	a4,-1(a1)
     9b6:	fee78fa3          	sb	a4,-1(a5)
     9ba:	fb75                	bnez	a4,9ae <strcpy+0x8>
    ;
  return os;
}
     9bc:	6422                	ld	s0,8(sp)
     9be:	0141                	addi	sp,sp,16
     9c0:	8082                	ret

00000000000009c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9c2:	1141                	addi	sp,sp,-16
     9c4:	e422                	sd	s0,8(sp)
     9c6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9c8:	00054783          	lbu	a5,0(a0)
     9cc:	cb91                	beqz	a5,9e0 <strcmp+0x1e>
     9ce:	0005c703          	lbu	a4,0(a1)
     9d2:	00f71763          	bne	a4,a5,9e0 <strcmp+0x1e>
    p++, q++;
     9d6:	0505                	addi	a0,a0,1
     9d8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9da:	00054783          	lbu	a5,0(a0)
     9de:	fbe5                	bnez	a5,9ce <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9e0:	0005c503          	lbu	a0,0(a1)
}
     9e4:	40a7853b          	subw	a0,a5,a0
     9e8:	6422                	ld	s0,8(sp)
     9ea:	0141                	addi	sp,sp,16
     9ec:	8082                	ret

00000000000009ee <strlen>:

uint
strlen(const char *s)
{
     9ee:	1141                	addi	sp,sp,-16
     9f0:	e422                	sd	s0,8(sp)
     9f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9f4:	00054783          	lbu	a5,0(a0)
     9f8:	cf91                	beqz	a5,a14 <strlen+0x26>
     9fa:	0505                	addi	a0,a0,1
     9fc:	87aa                	mv	a5,a0
     9fe:	86be                	mv	a3,a5
     a00:	0785                	addi	a5,a5,1
     a02:	fff7c703          	lbu	a4,-1(a5)
     a06:	ff65                	bnez	a4,9fe <strlen+0x10>
     a08:	40a6853b          	subw	a0,a3,a0
     a0c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a0e:	6422                	ld	s0,8(sp)
     a10:	0141                	addi	sp,sp,16
     a12:	8082                	ret
  for(n = 0; s[n]; n++)
     a14:	4501                	li	a0,0
     a16:	bfe5                	j	a0e <strlen+0x20>

0000000000000a18 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a18:	1141                	addi	sp,sp,-16
     a1a:	e422                	sd	s0,8(sp)
     a1c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a1e:	ca19                	beqz	a2,a34 <memset+0x1c>
     a20:	87aa                	mv	a5,a0
     a22:	1602                	slli	a2,a2,0x20
     a24:	9201                	srli	a2,a2,0x20
     a26:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a2a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a2e:	0785                	addi	a5,a5,1
     a30:	fee79de3          	bne	a5,a4,a2a <memset+0x12>
  }
  return dst;
}
     a34:	6422                	ld	s0,8(sp)
     a36:	0141                	addi	sp,sp,16
     a38:	8082                	ret

0000000000000a3a <strchr>:

char*
strchr(const char *s, char c)
{
     a3a:	1141                	addi	sp,sp,-16
     a3c:	e422                	sd	s0,8(sp)
     a3e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a40:	00054783          	lbu	a5,0(a0)
     a44:	cb99                	beqz	a5,a5a <strchr+0x20>
    if(*s == c)
     a46:	00f58763          	beq	a1,a5,a54 <strchr+0x1a>
  for(; *s; s++)
     a4a:	0505                	addi	a0,a0,1
     a4c:	00054783          	lbu	a5,0(a0)
     a50:	fbfd                	bnez	a5,a46 <strchr+0xc>
      return (char*)s;
  return 0;
     a52:	4501                	li	a0,0
}
     a54:	6422                	ld	s0,8(sp)
     a56:	0141                	addi	sp,sp,16
     a58:	8082                	ret
  return 0;
     a5a:	4501                	li	a0,0
     a5c:	bfe5                	j	a54 <strchr+0x1a>

0000000000000a5e <gets>:

char*
gets(char *buf, int max)
{
     a5e:	711d                	addi	sp,sp,-96
     a60:	ec86                	sd	ra,88(sp)
     a62:	e8a2                	sd	s0,80(sp)
     a64:	e4a6                	sd	s1,72(sp)
     a66:	e0ca                	sd	s2,64(sp)
     a68:	fc4e                	sd	s3,56(sp)
     a6a:	f852                	sd	s4,48(sp)
     a6c:	f456                	sd	s5,40(sp)
     a6e:	f05a                	sd	s6,32(sp)
     a70:	ec5e                	sd	s7,24(sp)
     a72:	1080                	addi	s0,sp,96
     a74:	8baa                	mv	s7,a0
     a76:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a78:	892a                	mv	s2,a0
     a7a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a7c:	4aa9                	li	s5,10
     a7e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a80:	89a6                	mv	s3,s1
     a82:	2485                	addiw	s1,s1,1
     a84:	0344d663          	bge	s1,s4,ab0 <gets+0x52>
    cc = read(0, &c, 1);
     a88:	4605                	li	a2,1
     a8a:	faf40593          	addi	a1,s0,-81
     a8e:	4501                	li	a0,0
     a90:	18e000ef          	jal	c1e <read>
    if(cc < 1)
     a94:	00a05e63          	blez	a0,ab0 <gets+0x52>
    buf[i++] = c;
     a98:	faf44783          	lbu	a5,-81(s0)
     a9c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     aa0:	01578763          	beq	a5,s5,aae <gets+0x50>
     aa4:	0905                	addi	s2,s2,1
     aa6:	fd679de3          	bne	a5,s6,a80 <gets+0x22>
    buf[i++] = c;
     aaa:	89a6                	mv	s3,s1
     aac:	a011                	j	ab0 <gets+0x52>
     aae:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ab0:	99de                	add	s3,s3,s7
     ab2:	00098023          	sb	zero,0(s3)
  return buf;
}
     ab6:	855e                	mv	a0,s7
     ab8:	60e6                	ld	ra,88(sp)
     aba:	6446                	ld	s0,80(sp)
     abc:	64a6                	ld	s1,72(sp)
     abe:	6906                	ld	s2,64(sp)
     ac0:	79e2                	ld	s3,56(sp)
     ac2:	7a42                	ld	s4,48(sp)
     ac4:	7aa2                	ld	s5,40(sp)
     ac6:	7b02                	ld	s6,32(sp)
     ac8:	6be2                	ld	s7,24(sp)
     aca:	6125                	addi	sp,sp,96
     acc:	8082                	ret

0000000000000ace <stat>:

int
stat(const char *n, struct stat *st)
{
     ace:	1101                	addi	sp,sp,-32
     ad0:	ec06                	sd	ra,24(sp)
     ad2:	e822                	sd	s0,16(sp)
     ad4:	e04a                	sd	s2,0(sp)
     ad6:	1000                	addi	s0,sp,32
     ad8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ada:	4581                	li	a1,0
     adc:	16a000ef          	jal	c46 <open>
  if(fd < 0)
     ae0:	02054263          	bltz	a0,b04 <stat+0x36>
     ae4:	e426                	sd	s1,8(sp)
     ae6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ae8:	85ca                	mv	a1,s2
     aea:	174000ef          	jal	c5e <fstat>
     aee:	892a                	mv	s2,a0
  close(fd);
     af0:	8526                	mv	a0,s1
     af2:	13c000ef          	jal	c2e <close>
  return r;
     af6:	64a2                	ld	s1,8(sp)
}
     af8:	854a                	mv	a0,s2
     afa:	60e2                	ld	ra,24(sp)
     afc:	6442                	ld	s0,16(sp)
     afe:	6902                	ld	s2,0(sp)
     b00:	6105                	addi	sp,sp,32
     b02:	8082                	ret
    return -1;
     b04:	597d                	li	s2,-1
     b06:	bfcd                	j	af8 <stat+0x2a>

0000000000000b08 <atoi>:

int
atoi(const char *s)
{
     b08:	1141                	addi	sp,sp,-16
     b0a:	e422                	sd	s0,8(sp)
     b0c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b0e:	00054683          	lbu	a3,0(a0)
     b12:	fd06879b          	addiw	a5,a3,-48
     b16:	0ff7f793          	zext.b	a5,a5
     b1a:	4625                	li	a2,9
     b1c:	02f66863          	bltu	a2,a5,b4c <atoi+0x44>
     b20:	872a                	mv	a4,a0
  n = 0;
     b22:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b24:	0705                	addi	a4,a4,1
     b26:	0025179b          	slliw	a5,a0,0x2
     b2a:	9fa9                	addw	a5,a5,a0
     b2c:	0017979b          	slliw	a5,a5,0x1
     b30:	9fb5                	addw	a5,a5,a3
     b32:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b36:	00074683          	lbu	a3,0(a4)
     b3a:	fd06879b          	addiw	a5,a3,-48
     b3e:	0ff7f793          	zext.b	a5,a5
     b42:	fef671e3          	bgeu	a2,a5,b24 <atoi+0x1c>
  return n;
}
     b46:	6422                	ld	s0,8(sp)
     b48:	0141                	addi	sp,sp,16
     b4a:	8082                	ret
  n = 0;
     b4c:	4501                	li	a0,0
     b4e:	bfe5                	j	b46 <atoi+0x3e>

0000000000000b50 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b50:	1141                	addi	sp,sp,-16
     b52:	e422                	sd	s0,8(sp)
     b54:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b56:	02b57463          	bgeu	a0,a1,b7e <memmove+0x2e>
    while(n-- > 0)
     b5a:	00c05f63          	blez	a2,b78 <memmove+0x28>
     b5e:	1602                	slli	a2,a2,0x20
     b60:	9201                	srli	a2,a2,0x20
     b62:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b66:	872a                	mv	a4,a0
      *dst++ = *src++;
     b68:	0585                	addi	a1,a1,1
     b6a:	0705                	addi	a4,a4,1
     b6c:	fff5c683          	lbu	a3,-1(a1)
     b70:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b74:	fef71ae3          	bne	a4,a5,b68 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b78:	6422                	ld	s0,8(sp)
     b7a:	0141                	addi	sp,sp,16
     b7c:	8082                	ret
    dst += n;
     b7e:	00c50733          	add	a4,a0,a2
    src += n;
     b82:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b84:	fec05ae3          	blez	a2,b78 <memmove+0x28>
     b88:	fff6079b          	addiw	a5,a2,-1
     b8c:	1782                	slli	a5,a5,0x20
     b8e:	9381                	srli	a5,a5,0x20
     b90:	fff7c793          	not	a5,a5
     b94:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b96:	15fd                	addi	a1,a1,-1
     b98:	177d                	addi	a4,a4,-1
     b9a:	0005c683          	lbu	a3,0(a1)
     b9e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ba2:	fee79ae3          	bne	a5,a4,b96 <memmove+0x46>
     ba6:	bfc9                	j	b78 <memmove+0x28>

0000000000000ba8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ba8:	1141                	addi	sp,sp,-16
     baa:	e422                	sd	s0,8(sp)
     bac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bae:	ca05                	beqz	a2,bde <memcmp+0x36>
     bb0:	fff6069b          	addiw	a3,a2,-1
     bb4:	1682                	slli	a3,a3,0x20
     bb6:	9281                	srli	a3,a3,0x20
     bb8:	0685                	addi	a3,a3,1
     bba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bbc:	00054783          	lbu	a5,0(a0)
     bc0:	0005c703          	lbu	a4,0(a1)
     bc4:	00e79863          	bne	a5,a4,bd4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bc8:	0505                	addi	a0,a0,1
    p2++;
     bca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bcc:	fed518e3          	bne	a0,a3,bbc <memcmp+0x14>
  }
  return 0;
     bd0:	4501                	li	a0,0
     bd2:	a019                	j	bd8 <memcmp+0x30>
      return *p1 - *p2;
     bd4:	40e7853b          	subw	a0,a5,a4
}
     bd8:	6422                	ld	s0,8(sp)
     bda:	0141                	addi	sp,sp,16
     bdc:	8082                	ret
  return 0;
     bde:	4501                	li	a0,0
     be0:	bfe5                	j	bd8 <memcmp+0x30>

0000000000000be2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     be2:	1141                	addi	sp,sp,-16
     be4:	e406                	sd	ra,8(sp)
     be6:	e022                	sd	s0,0(sp)
     be8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bea:	f67ff0ef          	jal	b50 <memmove>
}
     bee:	60a2                	ld	ra,8(sp)
     bf0:	6402                	ld	s0,0(sp)
     bf2:	0141                	addi	sp,sp,16
     bf4:	8082                	ret

0000000000000bf6 <forkprio>:



.global forkprio
forkprio:
  li a7, SYS_forkprio
     bf6:	48d9                	li	a7,22
  ecall
     bf8:	00000073          	ecall
  ret
     bfc:	8082                	ret

0000000000000bfe <fork>:



.global fork
fork:
 li a7, SYS_fork
     bfe:	4885                	li	a7,1
 ecall
     c00:	00000073          	ecall
 ret
     c04:	8082                	ret

0000000000000c06 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c06:	4889                	li	a7,2
 ecall
     c08:	00000073          	ecall
 ret
     c0c:	8082                	ret

0000000000000c0e <wait>:
.global wait
wait:
 li a7, SYS_wait
     c0e:	488d                	li	a7,3
 ecall
     c10:	00000073          	ecall
 ret
     c14:	8082                	ret

0000000000000c16 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c16:	4891                	li	a7,4
 ecall
     c18:	00000073          	ecall
 ret
     c1c:	8082                	ret

0000000000000c1e <read>:
.global read
read:
 li a7, SYS_read
     c1e:	4895                	li	a7,5
 ecall
     c20:	00000073          	ecall
 ret
     c24:	8082                	ret

0000000000000c26 <write>:
.global write
write:
 li a7, SYS_write
     c26:	48c1                	li	a7,16
 ecall
     c28:	00000073          	ecall
 ret
     c2c:	8082                	ret

0000000000000c2e <close>:
.global close
close:
 li a7, SYS_close
     c2e:	48d5                	li	a7,21
 ecall
     c30:	00000073          	ecall
 ret
     c34:	8082                	ret

0000000000000c36 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c36:	4899                	li	a7,6
 ecall
     c38:	00000073          	ecall
 ret
     c3c:	8082                	ret

0000000000000c3e <exec>:
.global exec
exec:
 li a7, SYS_exec
     c3e:	489d                	li	a7,7
 ecall
     c40:	00000073          	ecall
 ret
     c44:	8082                	ret

0000000000000c46 <open>:
.global open
open:
 li a7, SYS_open
     c46:	48bd                	li	a7,15
 ecall
     c48:	00000073          	ecall
 ret
     c4c:	8082                	ret

0000000000000c4e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c4e:	48c5                	li	a7,17
 ecall
     c50:	00000073          	ecall
 ret
     c54:	8082                	ret

0000000000000c56 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c56:	48c9                	li	a7,18
 ecall
     c58:	00000073          	ecall
 ret
     c5c:	8082                	ret

0000000000000c5e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c5e:	48a1                	li	a7,8
 ecall
     c60:	00000073          	ecall
 ret
     c64:	8082                	ret

0000000000000c66 <link>:
.global link
link:
 li a7, SYS_link
     c66:	48cd                	li	a7,19
 ecall
     c68:	00000073          	ecall
 ret
     c6c:	8082                	ret

0000000000000c6e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c6e:	48d1                	li	a7,20
 ecall
     c70:	00000073          	ecall
 ret
     c74:	8082                	ret

0000000000000c76 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c76:	48a5                	li	a7,9
 ecall
     c78:	00000073          	ecall
 ret
     c7c:	8082                	ret

0000000000000c7e <dup>:
.global dup
dup:
 li a7, SYS_dup
     c7e:	48a9                	li	a7,10
 ecall
     c80:	00000073          	ecall
 ret
     c84:	8082                	ret

0000000000000c86 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c86:	48ad                	li	a7,11
 ecall
     c88:	00000073          	ecall
 ret
     c8c:	8082                	ret

0000000000000c8e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c8e:	48b1                	li	a7,12
 ecall
     c90:	00000073          	ecall
 ret
     c94:	8082                	ret

0000000000000c96 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c96:	48b5                	li	a7,13
 ecall
     c98:	00000073          	ecall
 ret
     c9c:	8082                	ret

0000000000000c9e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c9e:	48b9                	li	a7,14
 ecall
     ca0:	00000073          	ecall
 ret
     ca4:	8082                	ret

0000000000000ca6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ca6:	1101                	addi	sp,sp,-32
     ca8:	ec06                	sd	ra,24(sp)
     caa:	e822                	sd	s0,16(sp)
     cac:	1000                	addi	s0,sp,32
     cae:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     cb2:	4605                	li	a2,1
     cb4:	fef40593          	addi	a1,s0,-17
     cb8:	f6fff0ef          	jal	c26 <write>
}
     cbc:	60e2                	ld	ra,24(sp)
     cbe:	6442                	ld	s0,16(sp)
     cc0:	6105                	addi	sp,sp,32
     cc2:	8082                	ret

0000000000000cc4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     cc4:	7139                	addi	sp,sp,-64
     cc6:	fc06                	sd	ra,56(sp)
     cc8:	f822                	sd	s0,48(sp)
     cca:	f426                	sd	s1,40(sp)
     ccc:	0080                	addi	s0,sp,64
     cce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cd0:	c299                	beqz	a3,cd6 <printint+0x12>
     cd2:	0805c963          	bltz	a1,d64 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     cd6:	2581                	sext.w	a1,a1
  neg = 0;
     cd8:	4881                	li	a7,0
     cda:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     cde:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ce0:	2601                	sext.w	a2,a2
     ce2:	00000517          	auipc	a0,0x0
     ce6:	63650513          	addi	a0,a0,1590 # 1318 <digits>
     cea:	883a                	mv	a6,a4
     cec:	2705                	addiw	a4,a4,1
     cee:	02c5f7bb          	remuw	a5,a1,a2
     cf2:	1782                	slli	a5,a5,0x20
     cf4:	9381                	srli	a5,a5,0x20
     cf6:	97aa                	add	a5,a5,a0
     cf8:	0007c783          	lbu	a5,0(a5)
     cfc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d00:	0005879b          	sext.w	a5,a1
     d04:	02c5d5bb          	divuw	a1,a1,a2
     d08:	0685                	addi	a3,a3,1
     d0a:	fec7f0e3          	bgeu	a5,a2,cea <printint+0x26>
  if(neg)
     d0e:	00088c63          	beqz	a7,d26 <printint+0x62>
    buf[i++] = '-';
     d12:	fd070793          	addi	a5,a4,-48
     d16:	00878733          	add	a4,a5,s0
     d1a:	02d00793          	li	a5,45
     d1e:	fef70823          	sb	a5,-16(a4)
     d22:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d26:	02e05a63          	blez	a4,d5a <printint+0x96>
     d2a:	f04a                	sd	s2,32(sp)
     d2c:	ec4e                	sd	s3,24(sp)
     d2e:	fc040793          	addi	a5,s0,-64
     d32:	00e78933          	add	s2,a5,a4
     d36:	fff78993          	addi	s3,a5,-1
     d3a:	99ba                	add	s3,s3,a4
     d3c:	377d                	addiw	a4,a4,-1
     d3e:	1702                	slli	a4,a4,0x20
     d40:	9301                	srli	a4,a4,0x20
     d42:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d46:	fff94583          	lbu	a1,-1(s2)
     d4a:	8526                	mv	a0,s1
     d4c:	f5bff0ef          	jal	ca6 <putc>
  while(--i >= 0)
     d50:	197d                	addi	s2,s2,-1
     d52:	ff391ae3          	bne	s2,s3,d46 <printint+0x82>
     d56:	7902                	ld	s2,32(sp)
     d58:	69e2                	ld	s3,24(sp)
}
     d5a:	70e2                	ld	ra,56(sp)
     d5c:	7442                	ld	s0,48(sp)
     d5e:	74a2                	ld	s1,40(sp)
     d60:	6121                	addi	sp,sp,64
     d62:	8082                	ret
    x = -xx;
     d64:	40b005bb          	negw	a1,a1
    neg = 1;
     d68:	4885                	li	a7,1
    x = -xx;
     d6a:	bf85                	j	cda <printint+0x16>

0000000000000d6c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d6c:	711d                	addi	sp,sp,-96
     d6e:	ec86                	sd	ra,88(sp)
     d70:	e8a2                	sd	s0,80(sp)
     d72:	e0ca                	sd	s2,64(sp)
     d74:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d76:	0005c903          	lbu	s2,0(a1)
     d7a:	26090863          	beqz	s2,fea <vprintf+0x27e>
     d7e:	e4a6                	sd	s1,72(sp)
     d80:	fc4e                	sd	s3,56(sp)
     d82:	f852                	sd	s4,48(sp)
     d84:	f456                	sd	s5,40(sp)
     d86:	f05a                	sd	s6,32(sp)
     d88:	ec5e                	sd	s7,24(sp)
     d8a:	e862                	sd	s8,16(sp)
     d8c:	e466                	sd	s9,8(sp)
     d8e:	8b2a                	mv	s6,a0
     d90:	8a2e                	mv	s4,a1
     d92:	8bb2                	mv	s7,a2
  state = 0;
     d94:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d96:	4481                	li	s1,0
     d98:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d9a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d9e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     da2:	06c00c93          	li	s9,108
     da6:	a005                	j	dc6 <vprintf+0x5a>
        putc(fd, c0);
     da8:	85ca                	mv	a1,s2
     daa:	855a                	mv	a0,s6
     dac:	efbff0ef          	jal	ca6 <putc>
     db0:	a019                	j	db6 <vprintf+0x4a>
    } else if(state == '%'){
     db2:	03598263          	beq	s3,s5,dd6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     db6:	2485                	addiw	s1,s1,1
     db8:	8726                	mv	a4,s1
     dba:	009a07b3          	add	a5,s4,s1
     dbe:	0007c903          	lbu	s2,0(a5)
     dc2:	20090c63          	beqz	s2,fda <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     dc6:	0009079b          	sext.w	a5,s2
    if(state == 0){
     dca:	fe0994e3          	bnez	s3,db2 <vprintf+0x46>
      if(c0 == '%'){
     dce:	fd579de3          	bne	a5,s5,da8 <vprintf+0x3c>
        state = '%';
     dd2:	89be                	mv	s3,a5
     dd4:	b7cd                	j	db6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     dd6:	00ea06b3          	add	a3,s4,a4
     dda:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     dde:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     de0:	c681                	beqz	a3,de8 <vprintf+0x7c>
     de2:	9752                	add	a4,a4,s4
     de4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     de8:	03878f63          	beq	a5,s8,e26 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     dec:	05978963          	beq	a5,s9,e3e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     df0:	07500713          	li	a4,117
     df4:	0ee78363          	beq	a5,a4,eda <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     df8:	07800713          	li	a4,120
     dfc:	12e78563          	beq	a5,a4,f26 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e00:	07000713          	li	a4,112
     e04:	14e78a63          	beq	a5,a4,f58 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     e08:	07300713          	li	a4,115
     e0c:	18e78a63          	beq	a5,a4,fa0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e10:	02500713          	li	a4,37
     e14:	04e79563          	bne	a5,a4,e5e <vprintf+0xf2>
        putc(fd, '%');
     e18:	02500593          	li	a1,37
     e1c:	855a                	mv	a0,s6
     e1e:	e89ff0ef          	jal	ca6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e22:	4981                	li	s3,0
     e24:	bf49                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e26:	008b8913          	addi	s2,s7,8
     e2a:	4685                	li	a3,1
     e2c:	4629                	li	a2,10
     e2e:	000ba583          	lw	a1,0(s7)
     e32:	855a                	mv	a0,s6
     e34:	e91ff0ef          	jal	cc4 <printint>
     e38:	8bca                	mv	s7,s2
      state = 0;
     e3a:	4981                	li	s3,0
     e3c:	bfad                	j	db6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     e3e:	06400793          	li	a5,100
     e42:	02f68963          	beq	a3,a5,e74 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e46:	06c00793          	li	a5,108
     e4a:	04f68263          	beq	a3,a5,e8e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     e4e:	07500793          	li	a5,117
     e52:	0af68063          	beq	a3,a5,ef2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     e56:	07800793          	li	a5,120
     e5a:	0ef68263          	beq	a3,a5,f3e <vprintf+0x1d2>
        putc(fd, '%');
     e5e:	02500593          	li	a1,37
     e62:	855a                	mv	a0,s6
     e64:	e43ff0ef          	jal	ca6 <putc>
        putc(fd, c0);
     e68:	85ca                	mv	a1,s2
     e6a:	855a                	mv	a0,s6
     e6c:	e3bff0ef          	jal	ca6 <putc>
      state = 0;
     e70:	4981                	li	s3,0
     e72:	b791                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e74:	008b8913          	addi	s2,s7,8
     e78:	4685                	li	a3,1
     e7a:	4629                	li	a2,10
     e7c:	000ba583          	lw	a1,0(s7)
     e80:	855a                	mv	a0,s6
     e82:	e43ff0ef          	jal	cc4 <printint>
        i += 1;
     e86:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e88:	8bca                	mv	s7,s2
      state = 0;
     e8a:	4981                	li	s3,0
        i += 1;
     e8c:	b72d                	j	db6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e8e:	06400793          	li	a5,100
     e92:	02f60763          	beq	a2,a5,ec0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e96:	07500793          	li	a5,117
     e9a:	06f60963          	beq	a2,a5,f0c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e9e:	07800793          	li	a5,120
     ea2:	faf61ee3          	bne	a2,a5,e5e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ea6:	008b8913          	addi	s2,s7,8
     eaa:	4681                	li	a3,0
     eac:	4641                	li	a2,16
     eae:	000ba583          	lw	a1,0(s7)
     eb2:	855a                	mv	a0,s6
     eb4:	e11ff0ef          	jal	cc4 <printint>
        i += 2;
     eb8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     eba:	8bca                	mv	s7,s2
      state = 0;
     ebc:	4981                	li	s3,0
        i += 2;
     ebe:	bde5                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ec0:	008b8913          	addi	s2,s7,8
     ec4:	4685                	li	a3,1
     ec6:	4629                	li	a2,10
     ec8:	000ba583          	lw	a1,0(s7)
     ecc:	855a                	mv	a0,s6
     ece:	df7ff0ef          	jal	cc4 <printint>
        i += 2;
     ed2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     ed4:	8bca                	mv	s7,s2
      state = 0;
     ed6:	4981                	li	s3,0
        i += 2;
     ed8:	bdf9                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     eda:	008b8913          	addi	s2,s7,8
     ede:	4681                	li	a3,0
     ee0:	4629                	li	a2,10
     ee2:	000ba583          	lw	a1,0(s7)
     ee6:	855a                	mv	a0,s6
     ee8:	dddff0ef          	jal	cc4 <printint>
     eec:	8bca                	mv	s7,s2
      state = 0;
     eee:	4981                	li	s3,0
     ef0:	b5d9                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ef2:	008b8913          	addi	s2,s7,8
     ef6:	4681                	li	a3,0
     ef8:	4629                	li	a2,10
     efa:	000ba583          	lw	a1,0(s7)
     efe:	855a                	mv	a0,s6
     f00:	dc5ff0ef          	jal	cc4 <printint>
        i += 1;
     f04:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f06:	8bca                	mv	s7,s2
      state = 0;
     f08:	4981                	li	s3,0
        i += 1;
     f0a:	b575                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f0c:	008b8913          	addi	s2,s7,8
     f10:	4681                	li	a3,0
     f12:	4629                	li	a2,10
     f14:	000ba583          	lw	a1,0(s7)
     f18:	855a                	mv	a0,s6
     f1a:	dabff0ef          	jal	cc4 <printint>
        i += 2;
     f1e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f20:	8bca                	mv	s7,s2
      state = 0;
     f22:	4981                	li	s3,0
        i += 2;
     f24:	bd49                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     f26:	008b8913          	addi	s2,s7,8
     f2a:	4681                	li	a3,0
     f2c:	4641                	li	a2,16
     f2e:	000ba583          	lw	a1,0(s7)
     f32:	855a                	mv	a0,s6
     f34:	d91ff0ef          	jal	cc4 <printint>
     f38:	8bca                	mv	s7,s2
      state = 0;
     f3a:	4981                	li	s3,0
     f3c:	bdad                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f3e:	008b8913          	addi	s2,s7,8
     f42:	4681                	li	a3,0
     f44:	4641                	li	a2,16
     f46:	000ba583          	lw	a1,0(s7)
     f4a:	855a                	mv	a0,s6
     f4c:	d79ff0ef          	jal	cc4 <printint>
        i += 1;
     f50:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f52:	8bca                	mv	s7,s2
      state = 0;
     f54:	4981                	li	s3,0
        i += 1;
     f56:	b585                	j	db6 <vprintf+0x4a>
     f58:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     f5a:	008b8d13          	addi	s10,s7,8
     f5e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f62:	03000593          	li	a1,48
     f66:	855a                	mv	a0,s6
     f68:	d3fff0ef          	jal	ca6 <putc>
  putc(fd, 'x');
     f6c:	07800593          	li	a1,120
     f70:	855a                	mv	a0,s6
     f72:	d35ff0ef          	jal	ca6 <putc>
     f76:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f78:	00000b97          	auipc	s7,0x0
     f7c:	3a0b8b93          	addi	s7,s7,928 # 1318 <digits>
     f80:	03c9d793          	srli	a5,s3,0x3c
     f84:	97de                	add	a5,a5,s7
     f86:	0007c583          	lbu	a1,0(a5)
     f8a:	855a                	mv	a0,s6
     f8c:	d1bff0ef          	jal	ca6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f90:	0992                	slli	s3,s3,0x4
     f92:	397d                	addiw	s2,s2,-1
     f94:	fe0916e3          	bnez	s2,f80 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
     f98:	8bea                	mv	s7,s10
      state = 0;
     f9a:	4981                	li	s3,0
     f9c:	6d02                	ld	s10,0(sp)
     f9e:	bd21                	j	db6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
     fa0:	008b8993          	addi	s3,s7,8
     fa4:	000bb903          	ld	s2,0(s7)
     fa8:	00090f63          	beqz	s2,fc6 <vprintf+0x25a>
        for(; *s; s++)
     fac:	00094583          	lbu	a1,0(s2)
     fb0:	c195                	beqz	a1,fd4 <vprintf+0x268>
          putc(fd, *s);
     fb2:	855a                	mv	a0,s6
     fb4:	cf3ff0ef          	jal	ca6 <putc>
        for(; *s; s++)
     fb8:	0905                	addi	s2,s2,1
     fba:	00094583          	lbu	a1,0(s2)
     fbe:	f9f5                	bnez	a1,fb2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     fc0:	8bce                	mv	s7,s3
      state = 0;
     fc2:	4981                	li	s3,0
     fc4:	bbcd                	j	db6 <vprintf+0x4a>
          s = "(null)";
     fc6:	00000917          	auipc	s2,0x0
     fca:	31a90913          	addi	s2,s2,794 # 12e0 <malloc+0x20e>
        for(; *s; s++)
     fce:	02800593          	li	a1,40
     fd2:	b7c5                	j	fb2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     fd4:	8bce                	mv	s7,s3
      state = 0;
     fd6:	4981                	li	s3,0
     fd8:	bbf9                	j	db6 <vprintf+0x4a>
     fda:	64a6                	ld	s1,72(sp)
     fdc:	79e2                	ld	s3,56(sp)
     fde:	7a42                	ld	s4,48(sp)
     fe0:	7aa2                	ld	s5,40(sp)
     fe2:	7b02                	ld	s6,32(sp)
     fe4:	6be2                	ld	s7,24(sp)
     fe6:	6c42                	ld	s8,16(sp)
     fe8:	6ca2                	ld	s9,8(sp)
    }
  }
}
     fea:	60e6                	ld	ra,88(sp)
     fec:	6446                	ld	s0,80(sp)
     fee:	6906                	ld	s2,64(sp)
     ff0:	6125                	addi	sp,sp,96
     ff2:	8082                	ret

0000000000000ff4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     ff4:	715d                	addi	sp,sp,-80
     ff6:	ec06                	sd	ra,24(sp)
     ff8:	e822                	sd	s0,16(sp)
     ffa:	1000                	addi	s0,sp,32
     ffc:	e010                	sd	a2,0(s0)
     ffe:	e414                	sd	a3,8(s0)
    1000:	e818                	sd	a4,16(s0)
    1002:	ec1c                	sd	a5,24(s0)
    1004:	03043023          	sd	a6,32(s0)
    1008:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    100c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1010:	8622                	mv	a2,s0
    1012:	d5bff0ef          	jal	d6c <vprintf>
}
    1016:	60e2                	ld	ra,24(sp)
    1018:	6442                	ld	s0,16(sp)
    101a:	6161                	addi	sp,sp,80
    101c:	8082                	ret

000000000000101e <printf>:

void
printf(const char *fmt, ...)
{
    101e:	711d                	addi	sp,sp,-96
    1020:	ec06                	sd	ra,24(sp)
    1022:	e822                	sd	s0,16(sp)
    1024:	1000                	addi	s0,sp,32
    1026:	e40c                	sd	a1,8(s0)
    1028:	e810                	sd	a2,16(s0)
    102a:	ec14                	sd	a3,24(s0)
    102c:	f018                	sd	a4,32(s0)
    102e:	f41c                	sd	a5,40(s0)
    1030:	03043823          	sd	a6,48(s0)
    1034:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1038:	00840613          	addi	a2,s0,8
    103c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1040:	85aa                	mv	a1,a0
    1042:	4505                	li	a0,1
    1044:	d29ff0ef          	jal	d6c <vprintf>
}
    1048:	60e2                	ld	ra,24(sp)
    104a:	6442                	ld	s0,16(sp)
    104c:	6125                	addi	sp,sp,96
    104e:	8082                	ret

0000000000001050 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1050:	1141                	addi	sp,sp,-16
    1052:	e422                	sd	s0,8(sp)
    1054:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1056:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    105a:	00001797          	auipc	a5,0x1
    105e:	fb67b783          	ld	a5,-74(a5) # 2010 <freep>
    1062:	a02d                	j	108c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1064:	4618                	lw	a4,8(a2)
    1066:	9f2d                	addw	a4,a4,a1
    1068:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    106c:	6398                	ld	a4,0(a5)
    106e:	6310                	ld	a2,0(a4)
    1070:	a83d                	j	10ae <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1072:	ff852703          	lw	a4,-8(a0)
    1076:	9f31                	addw	a4,a4,a2
    1078:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    107a:	ff053683          	ld	a3,-16(a0)
    107e:	a091                	j	10c2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1080:	6398                	ld	a4,0(a5)
    1082:	00e7e463          	bltu	a5,a4,108a <free+0x3a>
    1086:	00e6ea63          	bltu	a3,a4,109a <free+0x4a>
{
    108a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    108c:	fed7fae3          	bgeu	a5,a3,1080 <free+0x30>
    1090:	6398                	ld	a4,0(a5)
    1092:	00e6e463          	bltu	a3,a4,109a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1096:	fee7eae3          	bltu	a5,a4,108a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    109a:	ff852583          	lw	a1,-8(a0)
    109e:	6390                	ld	a2,0(a5)
    10a0:	02059813          	slli	a6,a1,0x20
    10a4:	01c85713          	srli	a4,a6,0x1c
    10a8:	9736                	add	a4,a4,a3
    10aa:	fae60de3          	beq	a2,a4,1064 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    10ae:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    10b2:	4790                	lw	a2,8(a5)
    10b4:	02061593          	slli	a1,a2,0x20
    10b8:	01c5d713          	srli	a4,a1,0x1c
    10bc:	973e                	add	a4,a4,a5
    10be:	fae68ae3          	beq	a3,a4,1072 <free+0x22>
    p->s.ptr = bp->s.ptr;
    10c2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    10c4:	00001717          	auipc	a4,0x1
    10c8:	f4f73623          	sd	a5,-180(a4) # 2010 <freep>
}
    10cc:	6422                	ld	s0,8(sp)
    10ce:	0141                	addi	sp,sp,16
    10d0:	8082                	ret

00000000000010d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10d2:	7139                	addi	sp,sp,-64
    10d4:	fc06                	sd	ra,56(sp)
    10d6:	f822                	sd	s0,48(sp)
    10d8:	f426                	sd	s1,40(sp)
    10da:	ec4e                	sd	s3,24(sp)
    10dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10de:	02051493          	slli	s1,a0,0x20
    10e2:	9081                	srli	s1,s1,0x20
    10e4:	04bd                	addi	s1,s1,15
    10e6:	8091                	srli	s1,s1,0x4
    10e8:	0014899b          	addiw	s3,s1,1
    10ec:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    10ee:	00001517          	auipc	a0,0x1
    10f2:	f2253503          	ld	a0,-222(a0) # 2010 <freep>
    10f6:	c915                	beqz	a0,112a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10fa:	4798                	lw	a4,8(a5)
    10fc:	08977a63          	bgeu	a4,s1,1190 <malloc+0xbe>
    1100:	f04a                	sd	s2,32(sp)
    1102:	e852                	sd	s4,16(sp)
    1104:	e456                	sd	s5,8(sp)
    1106:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1108:	8a4e                	mv	s4,s3
    110a:	0009871b          	sext.w	a4,s3
    110e:	6685                	lui	a3,0x1
    1110:	00d77363          	bgeu	a4,a3,1116 <malloc+0x44>
    1114:	6a05                	lui	s4,0x1
    1116:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    111a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    111e:	00001917          	auipc	s2,0x1
    1122:	ef290913          	addi	s2,s2,-270 # 2010 <freep>
  if(p == (char*)-1)
    1126:	5afd                	li	s5,-1
    1128:	a081                	j	1168 <malloc+0x96>
    112a:	f04a                	sd	s2,32(sp)
    112c:	e852                	sd	s4,16(sp)
    112e:	e456                	sd	s5,8(sp)
    1130:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1132:	00001797          	auipc	a5,0x1
    1136:	f5678793          	addi	a5,a5,-170 # 2088 <base>
    113a:	00001717          	auipc	a4,0x1
    113e:	ecf73b23          	sd	a5,-298(a4) # 2010 <freep>
    1142:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1144:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1148:	b7c1                	j	1108 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    114a:	6398                	ld	a4,0(a5)
    114c:	e118                	sd	a4,0(a0)
    114e:	a8a9                	j	11a8 <malloc+0xd6>
  hp->s.size = nu;
    1150:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1154:	0541                	addi	a0,a0,16
    1156:	efbff0ef          	jal	1050 <free>
  return freep;
    115a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    115e:	c12d                	beqz	a0,11c0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1160:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1162:	4798                	lw	a4,8(a5)
    1164:	02977263          	bgeu	a4,s1,1188 <malloc+0xb6>
    if(p == freep)
    1168:	00093703          	ld	a4,0(s2)
    116c:	853e                	mv	a0,a5
    116e:	fef719e3          	bne	a4,a5,1160 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1172:	8552                	mv	a0,s4
    1174:	b1bff0ef          	jal	c8e <sbrk>
  if(p == (char*)-1)
    1178:	fd551ce3          	bne	a0,s5,1150 <malloc+0x7e>
        return 0;
    117c:	4501                	li	a0,0
    117e:	7902                	ld	s2,32(sp)
    1180:	6a42                	ld	s4,16(sp)
    1182:	6aa2                	ld	s5,8(sp)
    1184:	6b02                	ld	s6,0(sp)
    1186:	a03d                	j	11b4 <malloc+0xe2>
    1188:	7902                	ld	s2,32(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1190:	fae48de3          	beq	s1,a4,114a <malloc+0x78>
        p->s.size -= nunits;
    1194:	4137073b          	subw	a4,a4,s3
    1198:	c798                	sw	a4,8(a5)
        p += p->s.size;
    119a:	02071693          	slli	a3,a4,0x20
    119e:	01c6d713          	srli	a4,a3,0x1c
    11a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    11a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    11a8:	00001717          	auipc	a4,0x1
    11ac:	e6a73423          	sd	a0,-408(a4) # 2010 <freep>
      return (void*)(p + 1);
    11b0:	01078513          	addi	a0,a5,16
  }
}
    11b4:	70e2                	ld	ra,56(sp)
    11b6:	7442                	ld	s0,48(sp)
    11b8:	74a2                	ld	s1,40(sp)
    11ba:	69e2                	ld	s3,24(sp)
    11bc:	6121                	addi	sp,sp,64
    11be:	8082                	ret
    11c0:	7902                	ld	s2,32(sp)
    11c2:	6a42                	ld	s4,16(sp)
    11c4:	6aa2                	ld	s5,8(sp)
    11c6:	6b02                	ld	s6,0(sp)
    11c8:	b7f5                	j	11b4 <malloc+0xe2>
