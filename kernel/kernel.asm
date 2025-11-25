
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	32013103          	ld	sp,800(sp) # 8000a320 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdad3f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de278793          	addi	a5,a5,-542 # 80000e62 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	496020ef          	jal	80002590 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	035000ef          	jal	8000093a <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00012517          	auipc	a0,0x12
    80000158:	22c50513          	addi	a0,a0,556 # 80012380 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	22048493          	addi	s1,s1,544 # 80012380 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	2b090913          	addi	s2,s2,688 # 80012418 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	1fb010ef          	jal	80001b7a <myproc>
    80000184:	29e020ef          	jal	80002422 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	05c020ef          	jal	800021ea <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	1e070713          	addi	a4,a4,480 # 80012380 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	374020ef          	jal	80002546 <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00012517          	auipc	a0,0x12
    800001ee:	19650513          	addi	a0,a0,406 # 80012380 <cons>
    800001f2:	29b000ef          	jal	80000c8c <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00012717          	auipc	a4,0x12
    80000218:	20f72223          	sw	a5,516(a4) # 80012418 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	15650513          	addi	a0,a0,342 # 80012380 <cons>
    80000232:	25b000ef          	jal	80000c8c <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	604000ef          	jal	80000854 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	5f6000ef          	jal	80000854 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5ee000ef          	jal	80000854 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5e8000ef          	jal	80000854 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	00012517          	auipc	a0,0x12
    80000282:	10250513          	addi	a0,a0,258 # 80012380 <cons>
    80000286:	16f000ef          	jal	80000bf4 <acquire>

  switch(c){
    8000028a:	47d5                	li	a5,21
    8000028c:	08f48f63          	beq	s1,a5,8000032a <consoleintr+0xb8>
    80000290:	0297c563          	blt	a5,s1,800002ba <consoleintr+0x48>
    80000294:	47a1                	li	a5,8
    80000296:	0ef48463          	beq	s1,a5,8000037e <consoleintr+0x10c>
    8000029a:	47c1                	li	a5,16
    8000029c:	10f49563          	bne	s1,a5,800003a6 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002a0:	33a020ef          	jal	800025da <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	00012517          	auipc	a0,0x12
    800002a8:	0dc50513          	addi	a0,a0,220 # 80012380 <cons>
    800002ac:	1e1000ef          	jal	80000c8c <release>
}
    800002b0:	60e2                	ld	ra,24(sp)
    800002b2:	6442                	ld	s0,16(sp)
    800002b4:	64a2                	ld	s1,8(sp)
    800002b6:	6105                	addi	sp,sp,32
    800002b8:	8082                	ret
  switch(c){
    800002ba:	07f00793          	li	a5,127
    800002be:	0cf48063          	beq	s1,a5,8000037e <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002c2:	00012717          	auipc	a4,0x12
    800002c6:	0be70713          	addi	a4,a4,190 # 80012380 <cons>
    800002ca:	0a072783          	lw	a5,160(a4)
    800002ce:	09872703          	lw	a4,152(a4)
    800002d2:	9f99                	subw	a5,a5,a4
    800002d4:	07f00713          	li	a4,127
    800002d8:	fcf766e3          	bltu	a4,a5,800002a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002dc:	47b5                	li	a5,13
    800002de:	0cf48763          	beq	s1,a5,800003ac <consoleintr+0x13a>
      consputc(c);
    800002e2:	8526                	mv	a0,s1
    800002e4:	f5dff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002e8:	00012797          	auipc	a5,0x12
    800002ec:	09878793          	addi	a5,a5,152 # 80012380 <cons>
    800002f0:	0a07a683          	lw	a3,160(a5)
    800002f4:	0016871b          	addiw	a4,a3,1
    800002f8:	0007061b          	sext.w	a2,a4
    800002fc:	0ae7a023          	sw	a4,160(a5)
    80000300:	07f6f693          	andi	a3,a3,127
    80000304:	97b6                	add	a5,a5,a3
    80000306:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000030a:	47a9                	li	a5,10
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000310:	4791                	li	a5,4
    80000312:	0cf48263          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000316:	00012797          	auipc	a5,0x12
    8000031a:	1027a783          	lw	a5,258(a5) # 80012418 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	00012717          	auipc	a4,0x12
    80000330:	05470713          	addi	a4,a4,84 # 80012380 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	00012497          	auipc	s1,0x12
    80000340:	04448493          	addi	s1,s1,68 # 80012380 <cons>
    while(cons.e != cons.w &&
    80000344:	4929                	li	s2,10
    80000346:	02f70863          	beq	a4,a5,80000376 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	37fd                	addiw	a5,a5,-1
    8000034c:	07f7f713          	andi	a4,a5,127
    80000350:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000352:	01874703          	lbu	a4,24(a4)
    80000356:	03270263          	beq	a4,s2,8000037a <consoleintr+0x108>
      cons.e--;
    8000035a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000035e:	10000513          	li	a0,256
    80000362:	edfff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000366:	0a04a783          	lw	a5,160(s1)
    8000036a:	09c4a703          	lw	a4,156(s1)
    8000036e:	fcf71ee3          	bne	a4,a5,8000034a <consoleintr+0xd8>
    80000372:	6902                	ld	s2,0(sp)
    80000374:	bf05                	j	800002a4 <consoleintr+0x32>
    80000376:	6902                	ld	s2,0(sp)
    80000378:	b735                	j	800002a4 <consoleintr+0x32>
    8000037a:	6902                	ld	s2,0(sp)
    8000037c:	b725                	j	800002a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000037e:	00012717          	auipc	a4,0x12
    80000382:	00270713          	addi	a4,a4,2 # 80012380 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	00012717          	auipc	a4,0x12
    80000398:	08f72623          	sw	a5,140(a4) # 80012420 <cons+0xa0>
      consputc(BACKSPACE);
    8000039c:	10000513          	li	a0,256
    800003a0:	ea1ff0ef          	jal	80000240 <consputc>
    800003a4:	b701                	j	800002a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003a6:	ee048fe3          	beqz	s1,800002a4 <consoleintr+0x32>
    800003aa:	bf21                	j	800002c2 <consoleintr+0x50>
      consputc(c);
    800003ac:	4529                	li	a0,10
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b2:	00012797          	auipc	a5,0x12
    800003b6:	fce78793          	addi	a5,a5,-50 # 80012380 <cons>
    800003ba:	0a07a703          	lw	a4,160(a5)
    800003be:	0017069b          	addiw	a3,a4,1
    800003c2:	0006861b          	sext.w	a2,a3
    800003c6:	0ad7a023          	sw	a3,160(a5)
    800003ca:	07f77713          	andi	a4,a4,127
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	4729                	li	a4,10
    800003d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003d6:	00012797          	auipc	a5,0x12
    800003da:	04c7a323          	sw	a2,70(a5) # 8001241c <cons+0x9c>
        wakeup(&cons.r);
    800003de:	00012517          	auipc	a0,0x12
    800003e2:	03a50513          	addi	a0,a0,58 # 80012418 <cons+0x98>
    800003e6:	651010ef          	jal	80002236 <wakeup>
    800003ea:	bd6d                	j	800002a4 <consoleintr+0x32>

00000000800003ec <consoleinit>:

void
consoleinit(void)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e406                	sd	ra,8(sp)
    800003f0:	e022                	sd	s0,0(sp)
    800003f2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003f4:	00007597          	auipc	a1,0x7
    800003f8:	c0c58593          	addi	a1,a1,-1012 # 80007000 <etext>
    800003fc:	00012517          	auipc	a0,0x12
    80000400:	f8450513          	addi	a0,a0,-124 # 80012380 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00022797          	auipc	a5,0x22
    80000410:	51c78793          	addi	a5,a5,1308 # 80022928 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
}
    80000428:	60a2                	ld	ra,8(sp)
    8000042a:	6402                	ld	s0,0(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret

0000000080000430 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000430:	7179                	addi	sp,sp,-48
    80000432:	f406                	sd	ra,40(sp)
    80000434:	f022                	sd	s0,32(sp)
    80000436:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000438:	c219                	beqz	a2,8000043e <printint+0xe>
    8000043a:	08054063          	bltz	a0,800004ba <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000043e:	4881                	li	a7,0
    80000440:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000444:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000446:	00007617          	auipc	a2,0x7
    8000044a:	35a60613          	addi	a2,a2,858 # 800077a0 <digits>
    8000044e:	883e                	mv	a6,a5
    80000450:	2785                	addiw	a5,a5,1
    80000452:	02b57733          	remu	a4,a0,a1
    80000456:	9732                	add	a4,a4,a2
    80000458:	00074703          	lbu	a4,0(a4)
    8000045c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000460:	872a                	mv	a4,a0
    80000462:	02b55533          	divu	a0,a0,a1
    80000466:	0685                	addi	a3,a3,1
    80000468:	feb773e3          	bgeu	a4,a1,8000044e <printint+0x1e>

  if(sign)
    8000046c:	00088a63          	beqz	a7,80000480 <printint+0x50>
    buf[i++] = '-';
    80000470:	1781                	addi	a5,a5,-32
    80000472:	97a2                	add	a5,a5,s0
    80000474:	02d00713          	li	a4,45
    80000478:	fee78823          	sb	a4,-16(a5)
    8000047c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000480:	02f05963          	blez	a5,800004b2 <printint+0x82>
    80000484:	ec26                	sd	s1,24(sp)
    80000486:	e84a                	sd	s2,16(sp)
    80000488:	fd040713          	addi	a4,s0,-48
    8000048c:	00f704b3          	add	s1,a4,a5
    80000490:	fff70913          	addi	s2,a4,-1
    80000494:	993e                	add	s2,s2,a5
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	1782                	slli	a5,a5,0x20
    8000049a:	9381                	srli	a5,a5,0x20
    8000049c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a0:	fff4c503          	lbu	a0,-1(s1)
    800004a4:	d9dff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004a8:	14fd                	addi	s1,s1,-1
    800004aa:	ff249be3          	bne	s1,s2,800004a0 <printint+0x70>
    800004ae:	64e2                	ld	s1,24(sp)
    800004b0:	6942                	ld	s2,16(sp)
}
    800004b2:	70a2                	ld	ra,40(sp)
    800004b4:	7402                	ld	s0,32(sp)
    800004b6:	6145                	addi	sp,sp,48
    800004b8:	8082                	ret
    x = -xx;
    800004ba:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004be:	4885                	li	a7,1
    x = -xx;
    800004c0:	b741                	j	80000440 <printint+0x10>

00000000800004c2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004c2:	7155                	addi	sp,sp,-208
    800004c4:	e506                	sd	ra,136(sp)
    800004c6:	e122                	sd	s0,128(sp)
    800004c8:	f0d2                	sd	s4,96(sp)
    800004ca:	0900                	addi	s0,sp,144
    800004cc:	8a2a                	mv	s4,a0
    800004ce:	e40c                	sd	a1,8(s0)
    800004d0:	e810                	sd	a2,16(s0)
    800004d2:	ec14                	sd	a3,24(s0)
    800004d4:	f018                	sd	a4,32(s0)
    800004d6:	f41c                	sd	a5,40(s0)
    800004d8:	03043823          	sd	a6,48(s0)
    800004dc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004e0:	00012797          	auipc	a5,0x12
    800004e4:	f607a783          	lw	a5,-160(a5) # 80012440 <pr+0x18>
    800004e8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004ec:	e3a1                	bnez	a5,8000052c <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004ee:	00840793          	addi	a5,s0,8
    800004f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	26050763          	beqz	a0,80000768 <printf+0x2a6>
    800004fe:	fca6                	sd	s1,120(sp)
    80000500:	f8ca                	sd	s2,112(sp)
    80000502:	f4ce                	sd	s3,104(sp)
    80000504:	ecd6                	sd	s5,88(sp)
    80000506:	e8da                	sd	s6,80(sp)
    80000508:	e0e2                	sd	s8,64(sp)
    8000050a:	fc66                	sd	s9,56(sp)
    8000050c:	f86a                	sd	s10,48(sp)
    8000050e:	f46e                	sd	s11,40(sp)
    80000510:	4981                	li	s3,0
    if(cx != '%'){
    80000512:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000516:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000051a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000051e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000522:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000526:	07000d93          	li	s11,112
    8000052a:	a815                	j	8000055e <printf+0x9c>
    acquire(&pr.lock);
    8000052c:	00012517          	auipc	a0,0x12
    80000530:	efc50513          	addi	a0,a0,-260 # 80012428 <pr>
    80000534:	6c0000ef          	jal	80000bf4 <acquire>
  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000540:	000a4503          	lbu	a0,0(s4)
    80000544:	fd4d                	bnez	a0,800004fe <printf+0x3c>
    80000546:	a481                	j	80000786 <printf+0x2c4>
      consputc(cx);
    80000548:	cf9ff0ef          	jal	80000240 <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050b63          	beqz	a0,80000750 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x86>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090163          	beqz	s2,80000750 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xc0>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690763          	beq	s2,s6,800005b0 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890163          	beq	s2,s8,800005c8 <printf+0x106>
    } else if(c0 == 'u'){
    8000058a:	0d990b63          	beq	s2,s9,80000660 <printf+0x19e>
    } else if(c0 == 'x'){
    8000058e:	13a90163          	beq	s2,s10,800006b0 <printf+0x1ee>
    } else if(c0 == 'p'){
    80000592:	13b90b63          	beq	s2,s11,800006c8 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000596:	07300793          	li	a5,115
    8000059a:	16f90a63          	beq	s2,a5,8000070e <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000059e:	1b590463          	beq	s2,s5,80000746 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005a2:	8556                	mv	a0,s5
    800005a4:	c9dff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005a8:	854a                	mv	a0,s2
    800005aa:	c97ff0ef          	jal	80000240 <consputc>
    800005ae:	b745                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005b0:	f8843783          	ld	a5,-120(s0)
    800005b4:	00878713          	addi	a4,a5,8
    800005b8:	f8e43423          	sd	a4,-120(s0)
    800005bc:	4605                	li	a2,1
    800005be:	45a9                	li	a1,10
    800005c0:	4388                	lw	a0,0(a5)
    800005c2:	e6fff0ef          	jal	80000430 <printint>
    800005c6:	b761                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c8:	03678663          	beq	a5,s6,800005f4 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005cc:	05878263          	beq	a5,s8,80000610 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d0:	0b978463          	beq	a5,s9,80000678 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d4:	fda797e3          	bne	a5,s10,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4601                	li	a2,0
    800005e6:	45c1                	li	a1,16
    800005e8:	6388                	ld	a0,0(a5)
    800005ea:	e47ff0ef          	jal	80000430 <printint>
      i += 1;
    800005ee:	0029849b          	addiw	s1,s3,2
    800005f2:	bfb1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005f4:	f8843783          	ld	a5,-120(s0)
    800005f8:	00878713          	addi	a4,a5,8
    800005fc:	f8e43423          	sd	a4,-120(s0)
    80000600:	4605                	li	a2,1
    80000602:	45a9                	li	a1,10
    80000604:	6388                	ld	a0,0(a5)
    80000606:	e2bff0ef          	jal	80000430 <printint>
      i += 1;
    8000060a:	0029849b          	addiw	s1,s3,2
    8000060e:	b781                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000610:	06400793          	li	a5,100
    80000614:	02f68863          	beq	a3,a5,80000644 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000618:	07500793          	li	a5,117
    8000061c:	06f68c63          	beq	a3,a5,80000694 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000620:	07800793          	li	a5,120
    80000624:	f6f69fe3          	bne	a3,a5,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000628:	f8843783          	ld	a5,-120(s0)
    8000062c:	00878713          	addi	a4,a5,8
    80000630:	f8e43423          	sd	a4,-120(s0)
    80000634:	4601                	li	a2,0
    80000636:	45c1                	li	a1,16
    80000638:	6388                	ld	a0,0(a5)
    8000063a:	df7ff0ef          	jal	80000430 <printint>
      i += 2;
    8000063e:	0039849b          	addiw	s1,s3,3
    80000642:	b731                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	45a9                	li	a1,10
    80000654:	6388                	ld	a0,0(a5)
    80000656:	ddbff0ef          	jal	80000430 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bdc5                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4601                	li	a2,0
    8000066e:	45a9                	li	a1,10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	dbfff0ef          	jal	80000430 <printint>
    80000676:	bde1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4601                	li	a2,0
    80000686:	45a9                	li	a1,10
    80000688:	6388                	ld	a0,0(a5)
    8000068a:	da7ff0ef          	jal	80000430 <printint>
      i += 1;
    8000068e:	0029849b          	addiw	s1,s3,2
    80000692:	bd75                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	d8bff0ef          	jal	80000430 <printint>
      i += 2;
    800006aa:	0039849b          	addiw	s1,s3,3
    800006ae:	b545                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45c1                	li	a1,16
    800006c0:	4388                	lw	a0,0(a5)
    800006c2:	d6fff0ef          	jal	80000430 <printint>
    800006c6:	b561                	j	8000054e <printf+0x8c>
    800006c8:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006ca:	f8843783          	ld	a5,-120(s0)
    800006ce:	00878713          	addi	a4,a5,8
    800006d2:	f8e43423          	sd	a4,-120(s0)
    800006d6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006da:	03000513          	li	a0,48
    800006de:	b63ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	b5bff0ef          	jal	80000240 <consputc>
    800006ea:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ec:	00007b97          	auipc	s7,0x7
    800006f0:	0b4b8b93          	addi	s7,s7,180 # 800077a0 <digits>
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b43ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x232>
    8000070a:	6ba6                	ld	s7,72(sp)
    8000070c:	b589                	j	8000054e <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000070e:	f8843783          	ld	a5,-120(s0)
    80000712:	00878713          	addi	a4,a5,8
    80000716:	f8e43423          	sd	a4,-120(s0)
    8000071a:	0007b903          	ld	s2,0(a5)
    8000071e:	00090d63          	beqz	s2,80000738 <printf+0x276>
      for(; *s; s++)
    80000722:	00094503          	lbu	a0,0(s2)
    80000726:	e20504e3          	beqz	a0,8000054e <printf+0x8c>
        consputc(*s);
    8000072a:	b17ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f97d                	bnez	a0,8000072a <printf+0x268>
    80000736:	bd21                	j	8000054e <printf+0x8c>
        s = "(null)";
    80000738:	00007917          	auipc	s2,0x7
    8000073c:	8d090913          	addi	s2,s2,-1840 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7dd                	j	8000072a <printf+0x268>
      consputc('%');
    80000746:	02500513          	li	a0,37
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	b501                	j	8000054e <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000750:	f7843783          	ld	a5,-136(s0)
    80000754:	e385                	bnez	a5,80000774 <printf+0x2b2>
    80000756:	74e6                	ld	s1,120(sp)
    80000758:	7946                	ld	s2,112(sp)
    8000075a:	79a6                	ld	s3,104(sp)
    8000075c:	6ae6                	ld	s5,88(sp)
    8000075e:	6b46                	ld	s6,80(sp)
    80000760:	6c06                	ld	s8,64(sp)
    80000762:	7ce2                	ld	s9,56(sp)
    80000764:	7d42                	ld	s10,48(sp)
    80000766:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000768:	4501                	li	a0,0
    8000076a:	60aa                	ld	ra,136(sp)
    8000076c:	640a                	ld	s0,128(sp)
    8000076e:	7a06                	ld	s4,96(sp)
    80000770:	6169                	addi	sp,sp,208
    80000772:	8082                	ret
    80000774:	74e6                	ld	s1,120(sp)
    80000776:	7946                	ld	s2,112(sp)
    80000778:	79a6                	ld	s3,104(sp)
    8000077a:	6ae6                	ld	s5,88(sp)
    8000077c:	6b46                	ld	s6,80(sp)
    8000077e:	6c06                	ld	s8,64(sp)
    80000780:	7ce2                	ld	s9,56(sp)
    80000782:	7d42                	ld	s10,48(sp)
    80000784:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000786:	00012517          	auipc	a0,0x12
    8000078a:	ca250513          	addi	a0,a0,-862 # 80012428 <pr>
    8000078e:	4fe000ef          	jal	80000c8c <release>
    80000792:	bfd9                	j	80000768 <printf+0x2a6>

0000000080000794 <panic>:

void
panic(char *s)
{
    80000794:	1101                	addi	sp,sp,-32
    80000796:	ec06                	sd	ra,24(sp)
    80000798:	e822                	sd	s0,16(sp)
    8000079a:	e426                	sd	s1,8(sp)
    8000079c:	1000                	addi	s0,sp,32
    8000079e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007a0:	00012797          	auipc	a5,0x12
    800007a4:	ca07a023          	sw	zero,-864(a5) # 80012440 <pr+0x18>
  printf("panic: ");
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	87050513          	addi	a0,a0,-1936 # 80007018 <etext+0x18>
    800007b0:	d13ff0ef          	jal	800004c2 <printf>
  printf("%s\n", s);
    800007b4:	85a6                	mv	a1,s1
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86a50513          	addi	a0,a0,-1942 # 80007020 <etext+0x20>
    800007be:	d05ff0ef          	jal	800004c2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	4785                	li	a5,1
    800007c4:	0000a717          	auipc	a4,0xa
    800007c8:	b6f72e23          	sw	a5,-1156(a4) # 8000a340 <panicked>
  for(;;)
    800007cc:	a001                	j	800007cc <panic+0x38>

00000000800007ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007d8:	00012497          	auipc	s1,0x12
    800007dc:	c5048493          	addi	s1,s1,-944 # 80012428 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38a000ef          	jal	80000b74 <initlock>
  pr.locking = 1;
    800007ee:	4785                	li	a5,1
    800007f0:	cc9c                	sw	a5,24(s1)
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00006597          	auipc	a1,0x6
    8000083c:	7f858593          	addi	a1,a1,2040 # 80007030 <etext+0x30>
    80000840:	00012517          	auipc	a0,0x12
    80000844:	c0850513          	addi	a0,a0,-1016 # 80012448 <uart_tx_lock>
    80000848:	32c000ef          	jal	80000b74 <initlock>
}
    8000084c:	60a2                	ld	ra,8(sp)
    8000084e:	6402                	ld	s0,0(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
    8000085e:	84aa                	mv	s1,a0
  push_off();
    80000860:	354000ef          	jal	80000bb4 <push_off>

  if(panicked){
    80000864:	0000a797          	auipc	a5,0xa
    80000868:	adc7a783          	lw	a5,-1316(a5) # 8000a340 <panicked>
    8000086c:	e795                	bnez	a5,80000898 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	3ae000ef          	jal	80000c38 <pop_off>
}
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    for(;;)
    80000898:	a001                	j	80000898 <uartputc_sync+0x44>

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	0000a797          	auipc	a5,0xa
    8000089e:	aae7b783          	ld	a5,-1362(a5) # 8000a348 <uart_tx_r>
    800008a2:	0000a717          	auipc	a4,0xa
    800008a6:	aae73703          	ld	a4,-1362(a4) # 8000a350 <uart_tx_w>
    800008aa:	08f70263          	beq	a4,a5,8000092e <uartstart+0x94>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c2:	10000937          	lui	s2,0x10000
    800008c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c8:	00012a97          	auipc	s5,0x12
    800008cc:	b80a8a93          	addi	s5,s5,-1152 # 80012448 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	0000a497          	auipc	s1,0xa
    800008d4:	a7848493          	addi	s1,s1,-1416 # 8000a348 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	0000a997          	auipc	s3,0xa
    800008e0:	a7498993          	addi	s3,s3,-1420 # 8000a350 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e4:	00094703          	lbu	a4,0(s2)
    800008e8:	02077713          	andi	a4,a4,32
    800008ec:	c71d                	beqz	a4,8000091a <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ee:	01f7f713          	andi	a4,a5,31
    800008f2:	9756                	add	a4,a4,s5
    800008f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008f8:	0785                	addi	a5,a5,1
    800008fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008fc:	8526                	mv	a0,s1
    800008fe:	139010ef          	jal	80002236 <wakeup>
    WriteReg(THR, c);
    80000902:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000906:	609c                	ld	a5,0(s1)
    80000908:	0009b703          	ld	a4,0(s3)
    8000090c:	fcf71ce3          	bne	a4,a5,800008e4 <uartstart+0x4a>
      ReadReg(ISR);
    80000910:	100007b7          	lui	a5,0x10000
    80000914:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000916:	0007c783          	lbu	a5,0(a5)
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
      ReadReg(ISR);
    8000092e:	100007b7          	lui	a5,0x10000
    80000932:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000934:	0007c783          	lbu	a5,0(a5)
      return;
    80000938:	8082                	ret

000000008000093a <uartputc>:
{
    8000093a:	7179                	addi	sp,sp,-48
    8000093c:	f406                	sd	ra,40(sp)
    8000093e:	f022                	sd	s0,32(sp)
    80000940:	ec26                	sd	s1,24(sp)
    80000942:	e84a                	sd	s2,16(sp)
    80000944:	e44e                	sd	s3,8(sp)
    80000946:	e052                	sd	s4,0(sp)
    80000948:	1800                	addi	s0,sp,48
    8000094a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000094c:	00012517          	auipc	a0,0x12
    80000950:	afc50513          	addi	a0,a0,-1284 # 80012448 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	0000a797          	auipc	a5,0xa
    8000095c:	9e87a783          	lw	a5,-1560(a5) # 8000a340 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	0000a717          	auipc	a4,0xa
    80000966:	9ee73703          	ld	a4,-1554(a4) # 8000a350 <uart_tx_w>
    8000096a:	0000a797          	auipc	a5,0xa
    8000096e:	9de7b783          	ld	a5,-1570(a5) # 8000a348 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	00012997          	auipc	s3,0x12
    8000097a:	ad298993          	addi	s3,s3,-1326 # 80012448 <uart_tx_lock>
    8000097e:	0000a497          	auipc	s1,0xa
    80000982:	9ca48493          	addi	s1,s1,-1590 # 8000a348 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	0000a917          	auipc	s2,0xa
    8000098a:	9ca90913          	addi	s2,s2,-1590 # 8000a350 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	055010ef          	jal	800021ea <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	00012497          	auipc	s1,0x12
    800009ac:	aa048493          	addi	s1,s1,-1376 # 80012448 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	0000a797          	auipc	a5,0xa
    800009c0:	98e7ba23          	sd	a4,-1644(a5) # 8000a350 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c2000ef          	jal	80000c8c <release>
}
    800009ce:	70a2                	ld	ra,40(sp)
    800009d0:	7402                	ld	s0,32(sp)
    800009d2:	64e2                	ld	s1,24(sp)
    800009d4:	6942                	ld	s2,16(sp)
    800009d6:	69a2                	ld	s3,8(sp)
    800009d8:	6a02                	ld	s4,0(sp)
    800009da:	6145                	addi	sp,sp,48
    800009dc:	8082                	ret
    for(;;)
    800009de:	a001                	j	800009de <uartputc+0xa4>

00000000800009e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e0:	1141                	addi	sp,sp,-16
    800009e2:	e422                	sd	s0,8(sp)
    800009e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e6:	100007b7          	lui	a5,0x10000
    800009ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009ec:	0007c783          	lbu	a5,0(a5)
    800009f0:	8b85                	andi	a5,a5,1
    800009f2:	cb81                	beqz	a5,80000a02 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009fc:	6422                	ld	s0,8(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	bfe5                	j	800009fc <uartgetc+0x1c>

0000000080000a06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a06:	1101                	addi	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a10:	54fd                	li	s1,-1
    80000a12:	a019                	j	80000a18 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a14:	85fff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a18:	fc9ff0ef          	jal	800009e0 <uartgetc>
    if(c == -1)
    80000a1c:	fe951ce3          	bne	a0,s1,80000a14 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	00012497          	auipc	s1,0x12
    80000a24:	a2848493          	addi	s1,s1,-1496 # 80012448 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1ca000ef          	jal	80000bf4 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	258000ef          	jal	80000c8c <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	e7a9                	bnez	a5,80000a9c <kfree+0x5a>
    80000a54:	84aa                	mv	s1,a0
    80000a56:	00023797          	auipc	a5,0x23
    80000a5a:	06a78793          	addi	a5,a5,106 # 80023ac0 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	47c5                	li	a5,17
    80000a64:	07ee                	slli	a5,a5,0x1b
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25a000ef          	jal	80000cc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	00012917          	auipc	s2,0x12
    80000a76:	a0e90913          	addi	s2,s2,-1522 # 80012480 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	178000ef          	jal	80000bf4 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	200000ef          	jal	80000c8c <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret
    panic("kfree");
    80000a9c:	00006517          	auipc	a0,0x6
    80000aa0:	59c50513          	addi	a0,a0,1436 # 80007038 <etext+0x38>
    80000aa4:	cf1ff0ef          	jal	80000794 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab8:	00e504b3          	add	s1,a0,a4
    80000abc:	777d                	lui	a4,0xfffff
    80000abe:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94be                	add	s1,s1,a5
    80000ac2:	0295e263          	bltu	a1,s1,80000ae6 <freerange+0x3e>
    80000ac6:	e84a                	sd	s2,16(sp)
    80000ac8:	e44e                	sd	s3,8(sp)
    80000aca:	e052                	sd	s4,0(sp)
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	f6dff0ef          	jal	80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe997be3          	bgeu	s2,s1,80000ad2 <freerange+0x2a>
    80000ae0:	6942                	ld	s2,16(sp)
    80000ae2:	69a2                	ld	s3,8(sp)
    80000ae4:	6a02                	ld	s4,0(sp)
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00006597          	auipc	a1,0x6
    80000afc:	54858593          	addi	a1,a1,1352 # 80007040 <etext+0x40>
    80000b00:	00012517          	auipc	a0,0x12
    80000b04:	98050513          	addi	a0,a0,-1664 # 80012480 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00023517          	auipc	a0,0x23
    80000b14:	fb050513          	addi	a0,a0,-80 # 80023ac0 <end>
    80000b18:	f91ff0ef          	jal	80000aa8 <freerange>
}
    80000b1c:	60a2                	ld	ra,8(sp)
    80000b1e:	6402                	ld	s0,0(sp)
    80000b20:	0141                	addi	sp,sp,16
    80000b22:	8082                	ret

0000000080000b24 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b24:	1101                	addi	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2e:	00012497          	auipc	s1,0x12
    80000b32:	95248493          	addi	s1,s1,-1710 # 80012480 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	00012517          	auipc	a0,0x12
    80000b46:	93e50513          	addi	a0,a0,-1730 # 80012480 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	140000ef          	jal	80000c8c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4595                	li	a1,5
    80000b54:	8526                	mv	a0,s1
    80000b56:	172000ef          	jal	80000cc8 <memset>
  return (void*)r;
}
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
  release(&kmem.lock);
    80000b66:	00012517          	auipc	a0,0x12
    80000b6a:	91a50513          	addi	a0,a0,-1766 # 80012480 <kmem>
    80000b6e:	11e000ef          	jal	80000c8c <release>
  if(r)
    80000b72:	b7e5                	j	80000b5a <kalloc+0x36>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	7c1000ef          	jal	80001b5e <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	793000ef          	jal	80001b5e <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	78b000ef          	jal	80001b5e <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	2785                	addiw	a5,a5,1
    80000bdc:	dd3c                	sw	a5,120(a0)
}
    80000bde:	60e2                	ld	ra,24(sp)
    80000be0:	6442                	ld	s0,16(sp)
    80000be2:	64a2                	ld	s1,8(sp)
    80000be4:	6105                	addi	sp,sp,32
    80000be6:	8082                	ret
    mycpu()->intena = old;
    80000be8:	777000ef          	jal	80001b5e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8085                	srli	s1,s1,0x1
    80000bee:	8885                	andi	s1,s1,1
    80000bf0:	dd64                	sw	s1,124(a0)
    80000bf2:	b7cd                	j	80000bd4 <push_off+0x20>

0000000080000bf4 <acquire>:
{
    80000bf4:	1101                	addi	sp,sp,-32
    80000bf6:	ec06                	sd	ra,24(sp)
    80000bf8:	e822                	sd	s0,16(sp)
    80000bfa:	e426                	sd	s1,8(sp)
    80000bfc:	1000                	addi	s0,sp,32
    80000bfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c00:	fb5ff0ef          	jal	80000bb4 <push_off>
  if(holding(lk))
    80000c04:	8526                	mv	a0,s1
    80000c06:	f85ff0ef          	jal	80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0a:	4705                	li	a4,1
  if(holding(lk))
    80000c0c:	e105                	bnez	a0,80000c2c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0e:	87ba                	mv	a5,a4
    80000c10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c14:	2781                	sext.w	a5,a5
    80000c16:	ffe5                	bnez	a5,80000c0e <acquire+0x1a>
  __sync_synchronize();
    80000c18:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c1c:	743000ef          	jal	80001b5e <mycpu>
    80000c20:	e888                	sd	a0,16(s1)
}
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    panic("acquire");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	41c50513          	addi	a0,a0,1052 # 80007048 <etext+0x48>
    80000c34:	b61ff0ef          	jal	80000794 <panic>

0000000080000c38 <pop_off>:

void
pop_off(void)
{
    80000c38:	1141                	addi	sp,sp,-16
    80000c3a:	e406                	sd	ra,8(sp)
    80000c3c:	e022                	sd	s0,0(sp)
    80000c3e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c40:	71f000ef          	jal	80001b5e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4a:	e78d                	bnez	a5,80000c74 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	5d3c                	lw	a5,120(a0)
    80000c4e:	02f05963          	blez	a5,80000c80 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	37fd                	addiw	a5,a5,-1
    80000c54:	0007871b          	sext.w	a4,a5
    80000c58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5a:	eb09                	bnez	a4,80000c6c <pop_off+0x34>
    80000c5c:	5d7c                	lw	a5,124(a0)
    80000c5e:	c799                	beqz	a5,80000c6c <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6c:	60a2                	ld	ra,8(sp)
    80000c6e:	6402                	ld	s0,0(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret
    panic("pop_off - interruptible");
    80000c74:	00006517          	auipc	a0,0x6
    80000c78:	3dc50513          	addi	a0,a0,988 # 80007050 <etext+0x50>
    80000c7c:	b19ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c80:	00006517          	auipc	a0,0x6
    80000c84:	3e850513          	addi	a0,a0,1000 # 80007068 <etext+0x68>
    80000c88:	b0dff0ef          	jal	80000794 <panic>

0000000080000c8c <release>:
{
    80000c8c:	1101                	addi	sp,sp,-32
    80000c8e:	ec06                	sd	ra,24(sp)
    80000c90:	e822                	sd	s0,16(sp)
    80000c92:	e426                	sd	s1,8(sp)
    80000c94:	1000                	addi	s0,sp,32
    80000c96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c98:	ef3ff0ef          	jal	80000b8a <holding>
    80000c9c:	c105                	beqz	a0,80000cbc <release+0x30>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000ca6:	0310000f          	fence	rw,w
    80000caa:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cae:	f8bff0ef          	jal	80000c38 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00006517          	auipc	a0,0x6
    80000cc0:	3b450513          	addi	a0,a0,948 # 80007070 <etext+0x70>
    80000cc4:	ad1ff0ef          	jal	80000794 <panic>

0000000080000cc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1c>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x12>
  }
  return dst;
}
    80000ce4:	6422                	ld	s0,8(sp)
    80000ce6:	0141                	addi	sp,sp,16
    80000ce8:	8082                	ret

0000000080000cea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf0:	ca05                	beqz	a2,80000d20 <memcmp+0x36>
    80000cf2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf6:	1682                	slli	a3,a3,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	0685                	addi	a3,a3,1
    80000cfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfe:	00054783          	lbu	a5,0(a0)
    80000d02:	0005c703          	lbu	a4,0(a1)
    80000d06:	00e79863          	bne	a5,a4,80000d16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0a:	0505                	addi	a0,a0,1
    80000d0c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0e:	fed518e3          	bne	a0,a3,80000cfe <memcmp+0x14>
  }

  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a019                	j	80000d1a <memcmp+0x30>
      return *s1 - *s2;
    80000d16:	40e7853b          	subw	a0,a5,a4
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret
  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	bfe5                	j	80000d1a <memcmp+0x30>

0000000080000d24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2a:	c205                	beqz	a2,80000d4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2c:	02a5e263          	bltu	a1,a0,80000d50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d30:	1602                	slli	a2,a2,0x20
    80000d32:	9201                	srli	a2,a2,0x20
    80000d34:	00c587b3          	add	a5,a1,a2
{
    80000d38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3a:	0585                	addi	a1,a1,1
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb541>
    80000d3e:	fff5c683          	lbu	a3,-1(a1)
    80000d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d46:	feb79ae3          	bne	a5,a1,80000d3a <memmove+0x16>

  return dst;
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  if(s < d && s + n > d){
    80000d50:	02061693          	slli	a3,a2,0x20
    80000d54:	9281                	srli	a3,a3,0x20
    80000d56:	00d58733          	add	a4,a1,a3
    80000d5a:	fce57be3          	bgeu	a0,a4,80000d30 <memmove+0xc>
    d += n;
    80000d5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	fff7c793          	not	a5,a5
    80000d6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	16fd                	addi	a3,a3,-1
    80000d72:	00074603          	lbu	a2,0(a4)
    80000d76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7a:	fef71ae3          	bne	a4,a5,80000d6e <memmove+0x4a>
    80000d7e:	b7f1                	j	80000d4a <memmove+0x26>

0000000080000d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e406                	sd	ra,8(sp)
    80000d84:	e022                	sd	s0,0(sp)
    80000d86:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d88:	f9dff0ef          	jal	80000d24 <memmove>
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d94:	1141                	addi	sp,sp,-16
    80000d96:	e422                	sd	s0,8(sp)
    80000d98:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9a:	ce11                	beqz	a2,80000db6 <strncmp+0x22>
    80000d9c:	00054783          	lbu	a5,0(a0)
    80000da0:	cf89                	beqz	a5,80000dba <strncmp+0x26>
    80000da2:	0005c703          	lbu	a4,0(a1)
    80000da6:	00f71a63          	bne	a4,a5,80000dba <strncmp+0x26>
    n--, p++, q++;
    80000daa:	367d                	addiw	a2,a2,-1
    80000dac:	0505                	addi	a0,a0,1
    80000dae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db0:	f675                	bnez	a2,80000d9c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db2:	4501                	li	a0,0
    80000db4:	a801                	j	80000dc4 <strncmp+0x30>
    80000db6:	4501                	li	a0,0
    80000db8:	a031                	j	80000dc4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	86b2                	mv	a3,a2
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	02d05563          	blez	a3,80000e00 <strncpy+0x36>
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	fee78fa3          	sb	a4,-1(a5)
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	f775                	bnez	a4,80000dd2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de8:	873e                	mv	a4,a5
    80000dea:	9fb5                	addw	a5,a5,a3
    80000dec:	37fd                	addiw	a5,a5,-1
    80000dee:	00c05963          	blez	a2,80000e00 <strncpy+0x36>
    *s++ = 0;
    80000df2:	0705                	addi	a4,a4,1
    80000df4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df8:	40e786bb          	subw	a3,a5,a4
    80000dfc:	fed04be3          	bgtz	a3,80000df2 <strncpy+0x28>
  return os;
}
    80000e00:	6422                	ld	s0,8(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e422                	sd	s0,8(sp)
    80000e0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0c:	02c05363          	blez	a2,80000e32 <safestrcpy+0x2c>
    80000e10:	fff6069b          	addiw	a3,a2,-1
    80000e14:	1682                	slli	a3,a3,0x20
    80000e16:	9281                	srli	a3,a3,0x20
    80000e18:	96ae                	add	a3,a3,a1
    80000e1a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1c:	00d58963          	beq	a1,a3,80000e2e <safestrcpy+0x28>
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fff5c703          	lbu	a4,-1(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	fb65                	bnez	a4,80000e1c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <strlen>:

int
strlen(const char *s)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf91                	beqz	a5,80000e5e <strlen+0x26>
    80000e44:	0505                	addi	a0,a0,1
    80000e46:	87aa                	mv	a5,a0
    80000e48:	86be                	mv	a3,a5
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fff7c703          	lbu	a4,-1(a5)
    80000e50:	ff65                	bnez	a4,80000e48 <strlen+0x10>
    80000e52:	40a6853b          	subw	a0,a3,a0
    80000e56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5e:	4501                	li	a0,0
    80000e60:	bfe5                	j	80000e58 <strlen+0x20>

0000000080000e62 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6a:	4e5000ef          	jal	80001b4e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	00009717          	auipc	a4,0x9
    80000e72:	4ea70713          	addi	a4,a4,1258 # 8000a358 <started>
  if(cpuid() == 0){
    80000e76:	c51d                	beqz	a0,80000ea4 <main+0x42>
    while(started == 0)
    80000e78:	431c                	lw	a5,0(a4)
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dff5                	beqz	a5,80000e78 <main+0x16>
      ;
    __sync_synchronize();
    80000e7e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e82:	4cd000ef          	jal	80001b4e <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	21050513          	addi	a0,a0,528 # 80007098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	080000ef          	jal	80000f14 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	075010ef          	jal	8000270c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	72c040ef          	jal	800055c8 <plicinithart>
  }

  scheduler();        
    80000ea0:	347000ef          	jal	800019e6 <scheduler>
    consoleinit();
    80000ea4:	d48ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000ea8:	927ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eac:	00006517          	auipc	a0,0x6
    80000eb0:	1cc50513          	addi	a0,a0,460 # 80007078 <etext+0x78>
    80000eb4:	e0eff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eb8:	00006517          	auipc	a0,0x6
    80000ebc:	1c850513          	addi	a0,a0,456 # 80007080 <etext+0x80>
    80000ec0:	e02ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec4:	00006517          	auipc	a0,0x6
    80000ec8:	1b450513          	addi	a0,a0,436 # 80007078 <etext+0x78>
    80000ecc:	df6ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed0:	c21ff0ef          	jal	80000af0 <kinit>
    kvminit();       // create kernel page table
    80000ed4:	2ca000ef          	jal	8000119e <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	03c000ef          	jal	80000f14 <kvminithart>
    procinit();      // process table
    80000edc:	3bd000ef          	jal	80001a98 <procinit>
    trapinit();      // trap vectors
    80000ee0:	009010ef          	jal	800026e8 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	029010ef          	jal	8000270c <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	6c6040ef          	jal	800055ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	6dc040ef          	jal	800055c8 <plicinithart>
    binit();         // buffer cache
    80000ef0:	67f010ef          	jal	80002d6e <binit>
    iinit();         // inode table
    80000ef4:	470020ef          	jal	80003364 <iinit>
    fileinit();      // file table
    80000ef8:	21c030ef          	jal	80004114 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	7bc040ef          	jal	800056b8 <virtio_disk_init>
    userinit();      // first user process
    80000f00:	03c010ef          	jal	80001f3c <userinit>
    __sync_synchronize();
    80000f04:	0330000f          	fence	rw,rw
    started = 1;
    80000f08:	4785                	li	a5,1
    80000f0a:	00009717          	auipc	a4,0x9
    80000f0e:	44f72723          	sw	a5,1102(a4) # 8000a358 <started>
    80000f12:	b779                	j	80000ea0 <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	00009797          	auipc	a5,0x9
    80000f22:	4427b783          	ld	a5,1090(a5) # 8000a360 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3c:	7139                	addi	sp,sp,-64
    80000f3e:	fc06                	sd	ra,56(sp)
    80000f40:	f822                	sd	s0,48(sp)
    80000f42:	f426                	sd	s1,40(sp)
    80000f44:	f04a                	sd	s2,32(sp)
    80000f46:	ec4e                	sd	s3,24(sp)
    80000f48:	e852                	sd	s4,16(sp)
    80000f4a:	e456                	sd	s5,8(sp)
    80000f4c:	e05a                	sd	s6,0(sp)
    80000f4e:	0080                	addi	s0,sp,64
    80000f50:	84aa                	mv	s1,a0
    80000f52:	89ae                	mv	s3,a1
    80000f54:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f56:	57fd                	li	a5,-1
    80000f58:	83e9                	srli	a5,a5,0x1a
    80000f5a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f5c:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f5e:	02b7fc63          	bgeu	a5,a1,80000f96 <walk+0x5a>
    panic("walk");
    80000f62:	00006517          	auipc	a0,0x6
    80000f66:	14e50513          	addi	a0,a0,334 # 800070b0 <etext+0xb0>
    80000f6a:	82bff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f6e:	060a8263          	beqz	s5,80000fd2 <walk+0x96>
    80000f72:	bb3ff0ef          	jal	80000b24 <kalloc>
    80000f76:	84aa                	mv	s1,a0
    80000f78:	c139                	beqz	a0,80000fbe <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	4581                	li	a1,0
    80000f7e:	d4bff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f82:	00c4d793          	srli	a5,s1,0xc
    80000f86:	07aa                	slli	a5,a5,0xa
    80000f88:	0017e793          	ori	a5,a5,1
    80000f8c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f90:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb537>
    80000f92:	036a0063          	beq	s4,s6,80000fb2 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f96:	0149d933          	srl	s2,s3,s4
    80000f9a:	1ff97913          	andi	s2,s2,511
    80000f9e:	090e                	slli	s2,s2,0x3
    80000fa0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa2:	00093483          	ld	s1,0(s2)
    80000fa6:	0014f793          	andi	a5,s1,1
    80000faa:	d3f1                	beqz	a5,80000f6e <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fac:	80a9                	srli	s1,s1,0xa
    80000fae:	04b2                	slli	s1,s1,0xc
    80000fb0:	b7c5                	j	80000f90 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb2:	00c9d513          	srli	a0,s3,0xc
    80000fb6:	1ff57513          	andi	a0,a0,511
    80000fba:	050e                	slli	a0,a0,0x3
    80000fbc:	9526                	add	a0,a0,s1
}
    80000fbe:	70e2                	ld	ra,56(sp)
    80000fc0:	7442                	ld	s0,48(sp)
    80000fc2:	74a2                	ld	s1,40(sp)
    80000fc4:	7902                	ld	s2,32(sp)
    80000fc6:	69e2                	ld	s3,24(sp)
    80000fc8:	6a42                	ld	s4,16(sp)
    80000fca:	6aa2                	ld	s5,8(sp)
    80000fcc:	6b02                	ld	s6,0(sp)
    80000fce:	6121                	addi	sp,sp,64
    80000fd0:	8082                	ret
        return 0;
    80000fd2:	4501                	li	a0,0
    80000fd4:	b7ed                	j	80000fbe <walk+0x82>

0000000080000fd6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fd6:	57fd                	li	a5,-1
    80000fd8:	83e9                	srli	a5,a5,0x1a
    80000fda:	00b7f463          	bgeu	a5,a1,80000fe2 <walkaddr+0xc>
    return 0;
    80000fde:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe0:	8082                	ret
{
    80000fe2:	1141                	addi	sp,sp,-16
    80000fe4:	e406                	sd	ra,8(sp)
    80000fe6:	e022                	sd	s0,0(sp)
    80000fe8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fea:	4601                	li	a2,0
    80000fec:	f51ff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80000ff0:	c105                	beqz	a0,80001010 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000ff2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000ff4:	0117f693          	andi	a3,a5,17
    80000ff8:	4745                	li	a4,17
    return 0;
    80000ffa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000ffc:	00e68663          	beq	a3,a4,80001008 <walkaddr+0x32>
}
    80001000:	60a2                	ld	ra,8(sp)
    80001002:	6402                	ld	s0,0(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
  pa = PTE2PA(*pte);
    80001008:	83a9                	srli	a5,a5,0xa
    8000100a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000100e:	bfcd                	j	80001000 <walkaddr+0x2a>
    return 0;
    80001010:	4501                	li	a0,0
    80001012:	b7fd                	j	80001000 <walkaddr+0x2a>

0000000080001014 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001014:	715d                	addi	sp,sp,-80
    80001016:	e486                	sd	ra,72(sp)
    80001018:	e0a2                	sd	s0,64(sp)
    8000101a:	fc26                	sd	s1,56(sp)
    8000101c:	f84a                	sd	s2,48(sp)
    8000101e:	f44e                	sd	s3,40(sp)
    80001020:	f052                	sd	s4,32(sp)
    80001022:	ec56                	sd	s5,24(sp)
    80001024:	e85a                	sd	s6,16(sp)
    80001026:	e45e                	sd	s7,8(sp)
    80001028:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000102a:	03459793          	slli	a5,a1,0x34
    8000102e:	e7a9                	bnez	a5,80001078 <mappages+0x64>
    80001030:	8aaa                	mv	s5,a0
    80001032:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001034:	03461793          	slli	a5,a2,0x34
    80001038:	e7b1                	bnez	a5,80001084 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    8000103a:	ca39                	beqz	a2,80001090 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000103c:	77fd                	lui	a5,0xfffff
    8000103e:	963e                	add	a2,a2,a5
    80001040:	00b609b3          	add	s3,a2,a1
  a = va;
    80001044:	892e                	mv	s2,a1
    80001046:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000104a:	6b85                	lui	s7,0x1
    8000104c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	4605                	li	a2,1
    80001052:	85ca                	mv	a1,s2
    80001054:	8556                	mv	a0,s5
    80001056:	ee7ff0ef          	jal	80000f3c <walk>
    8000105a:	c539                	beqz	a0,800010a8 <mappages+0x94>
    if(*pte & PTE_V)
    8000105c:	611c                	ld	a5,0(a0)
    8000105e:	8b85                	andi	a5,a5,1
    80001060:	ef95                	bnez	a5,8000109c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001062:	80b1                	srli	s1,s1,0xc
    80001064:	04aa                	slli	s1,s1,0xa
    80001066:	0164e4b3          	or	s1,s1,s6
    8000106a:	0014e493          	ori	s1,s1,1
    8000106e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001070:	05390863          	beq	s2,s3,800010c0 <mappages+0xac>
    a += PGSIZE;
    80001074:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001076:	bfd9                	j	8000104c <mappages+0x38>
    panic("mappages: va not aligned");
    80001078:	00006517          	auipc	a0,0x6
    8000107c:	04050513          	addi	a0,a0,64 # 800070b8 <etext+0xb8>
    80001080:	f14ff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    80001084:	00006517          	auipc	a0,0x6
    80001088:	05450513          	addi	a0,a0,84 # 800070d8 <etext+0xd8>
    8000108c:	f08ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    80001090:	00006517          	auipc	a0,0x6
    80001094:	06850513          	addi	a0,a0,104 # 800070f8 <etext+0xf8>
    80001098:	efcff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    8000109c:	00006517          	auipc	a0,0x6
    800010a0:	06c50513          	addi	a0,a0,108 # 80007108 <etext+0x108>
    800010a4:	ef0ff0ef          	jal	80000794 <panic>
      return -1;
    800010a8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010aa:	60a6                	ld	ra,72(sp)
    800010ac:	6406                	ld	s0,64(sp)
    800010ae:	74e2                	ld	s1,56(sp)
    800010b0:	7942                	ld	s2,48(sp)
    800010b2:	79a2                	ld	s3,40(sp)
    800010b4:	7a02                	ld	s4,32(sp)
    800010b6:	6ae2                	ld	s5,24(sp)
    800010b8:	6b42                	ld	s6,16(sp)
    800010ba:	6ba2                	ld	s7,8(sp)
    800010bc:	6161                	addi	sp,sp,80
    800010be:	8082                	ret
  return 0;
    800010c0:	4501                	li	a0,0
    800010c2:	b7e5                	j	800010aa <mappages+0x96>

00000000800010c4 <kvmmap>:
{
    800010c4:	1141                	addi	sp,sp,-16
    800010c6:	e406                	sd	ra,8(sp)
    800010c8:	e022                	sd	s0,0(sp)
    800010ca:	0800                	addi	s0,sp,16
    800010cc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010ce:	86b2                	mv	a3,a2
    800010d0:	863e                	mv	a2,a5
    800010d2:	f43ff0ef          	jal	80001014 <mappages>
    800010d6:	e509                	bnez	a0,800010e0 <kvmmap+0x1c>
}
    800010d8:	60a2                	ld	ra,8(sp)
    800010da:	6402                	ld	s0,0(sp)
    800010dc:	0141                	addi	sp,sp,16
    800010de:	8082                	ret
    panic("kvmmap");
    800010e0:	00006517          	auipc	a0,0x6
    800010e4:	03850513          	addi	a0,a0,56 # 80007118 <etext+0x118>
    800010e8:	eacff0ef          	jal	80000794 <panic>

00000000800010ec <kvmmake>:
{
    800010ec:	1101                	addi	sp,sp,-32
    800010ee:	ec06                	sd	ra,24(sp)
    800010f0:	e822                	sd	s0,16(sp)
    800010f2:	e426                	sd	s1,8(sp)
    800010f4:	e04a                	sd	s2,0(sp)
    800010f6:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010f8:	a2dff0ef          	jal	80000b24 <kalloc>
    800010fc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fe:	6605                	lui	a2,0x1
    80001100:	4581                	li	a1,0
    80001102:	bc7ff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001106:	4719                	li	a4,6
    80001108:	6685                	lui	a3,0x1
    8000110a:	10000637          	lui	a2,0x10000
    8000110e:	100005b7          	lui	a1,0x10000
    80001112:	8526                	mv	a0,s1
    80001114:	fb1ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001118:	4719                	li	a4,6
    8000111a:	6685                	lui	a3,0x1
    8000111c:	10001637          	lui	a2,0x10001
    80001120:	100015b7          	lui	a1,0x10001
    80001124:	8526                	mv	a0,s1
    80001126:	f9fff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000112a:	4719                	li	a4,6
    8000112c:	040006b7          	lui	a3,0x4000
    80001130:	0c000637          	lui	a2,0xc000
    80001134:	0c0005b7          	lui	a1,0xc000
    80001138:	8526                	mv	a0,s1
    8000113a:	f8bff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000113e:	00006917          	auipc	s2,0x6
    80001142:	ec290913          	addi	s2,s2,-318 # 80007000 <etext>
    80001146:	4729                	li	a4,10
    80001148:	80006697          	auipc	a3,0x80006
    8000114c:	eb868693          	addi	a3,a3,-328 # 7000 <_entry-0x7fff9000>
    80001150:	4605                	li	a2,1
    80001152:	067e                	slli	a2,a2,0x1f
    80001154:	85b2                	mv	a1,a2
    80001156:	8526                	mv	a0,s1
    80001158:	f6dff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000115c:	46c5                	li	a3,17
    8000115e:	06ee                	slli	a3,a3,0x1b
    80001160:	4719                	li	a4,6
    80001162:	412686b3          	sub	a3,a3,s2
    80001166:	864a                	mv	a2,s2
    80001168:	85ca                	mv	a1,s2
    8000116a:	8526                	mv	a0,s1
    8000116c:	f59ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001170:	4729                	li	a4,10
    80001172:	6685                	lui	a3,0x1
    80001174:	00005617          	auipc	a2,0x5
    80001178:	e8c60613          	addi	a2,a2,-372 # 80006000 <_trampoline>
    8000117c:	040005b7          	lui	a1,0x4000
    80001180:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001182:	05b2                	slli	a1,a1,0xc
    80001184:	8526                	mv	a0,s1
    80001186:	f3fff0ef          	jal	800010c4 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118a:	8526                	mv	a0,s1
    8000118c:	075000ef          	jal	80001a00 <proc_mapstacks>
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <kvminit>:
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e406                	sd	ra,8(sp)
    800011a2:	e022                	sd	s0,0(sp)
    800011a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a6:	f47ff0ef          	jal	800010ec <kvmmake>
    800011aa:	00009797          	auipc	a5,0x9
    800011ae:	1aa7bb23          	sd	a0,438(a5) # 8000a360 <kernel_pagetable>
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ba:	715d                	addi	sp,sp,-80
    800011bc:	e486                	sd	ra,72(sp)
    800011be:	e0a2                	sd	s0,64(sp)
    800011c0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c2:	03459793          	slli	a5,a1,0x34
    800011c6:	e39d                	bnez	a5,800011ec <uvmunmap+0x32>
    800011c8:	f84a                	sd	s2,48(sp)
    800011ca:	f44e                	sd	s3,40(sp)
    800011cc:	f052                	sd	s4,32(sp)
    800011ce:	ec56                	sd	s5,24(sp)
    800011d0:	e85a                	sd	s6,16(sp)
    800011d2:	e45e                	sd	s7,8(sp)
    800011d4:	8a2a                	mv	s4,a0
    800011d6:	892e                	mv	s2,a1
    800011d8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011da:	0632                	slli	a2,a2,0xc
    800011dc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e2:	6b05                	lui	s6,0x1
    800011e4:	0735ff63          	bgeu	a1,s3,80001262 <uvmunmap+0xa8>
    800011e8:	fc26                	sd	s1,56(sp)
    800011ea:	a0a9                	j	80001234 <uvmunmap+0x7a>
    800011ec:	fc26                	sd	s1,56(sp)
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800011fa:	00006517          	auipc	a0,0x6
    800011fe:	f2650513          	addi	a0,a0,-218 # 80007120 <etext+0x120>
    80001202:	d92ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    80001206:	00006517          	auipc	a0,0x6
    8000120a:	f3250513          	addi	a0,a0,-206 # 80007138 <etext+0x138>
    8000120e:	d86ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001212:	00006517          	auipc	a0,0x6
    80001216:	f3650513          	addi	a0,a0,-202 # 80007148 <etext+0x148>
    8000121a:	d7aff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    8000121e:	00006517          	auipc	a0,0x6
    80001222:	f4250513          	addi	a0,a0,-190 # 80007160 <etext+0x160>
    80001226:	d6eff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000122a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000122e:	995a                	add	s2,s2,s6
    80001230:	03397863          	bgeu	s2,s3,80001260 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001234:	4601                	li	a2,0
    80001236:	85ca                	mv	a1,s2
    80001238:	8552                	mv	a0,s4
    8000123a:	d03ff0ef          	jal	80000f3c <walk>
    8000123e:	84aa                	mv	s1,a0
    80001240:	d179                	beqz	a0,80001206 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001242:	6108                	ld	a0,0(a0)
    80001244:	00157793          	andi	a5,a0,1
    80001248:	d7e9                	beqz	a5,80001212 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000124a:	3ff57793          	andi	a5,a0,1023
    8000124e:	fd7788e3          	beq	a5,s7,8000121e <uvmunmap+0x64>
    if(do_free){
    80001252:	fc0a8ce3          	beqz	s5,8000122a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001256:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001258:	0532                	slli	a0,a0,0xc
    8000125a:	fe8ff0ef          	jal	80000a42 <kfree>
    8000125e:	b7f1                	j	8000122a <uvmunmap+0x70>
    80001260:	74e2                	ld	s1,56(sp)
    80001262:	7942                	ld	s2,48(sp)
    80001264:	79a2                	ld	s3,40(sp)
    80001266:	7a02                	ld	s4,32(sp)
    80001268:	6ae2                	ld	s5,24(sp)
    8000126a:	6b42                	ld	s6,16(sp)
    8000126c:	6ba2                	ld	s7,8(sp)
  }
}
    8000126e:	60a6                	ld	ra,72(sp)
    80001270:	6406                	ld	s0,64(sp)
    80001272:	6161                	addi	sp,sp,80
    80001274:	8082                	ret

0000000080001276 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001276:	1101                	addi	sp,sp,-32
    80001278:	ec06                	sd	ra,24(sp)
    8000127a:	e822                	sd	s0,16(sp)
    8000127c:	e426                	sd	s1,8(sp)
    8000127e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001280:	8a5ff0ef          	jal	80000b24 <kalloc>
    80001284:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001286:	c509                	beqz	a0,80001290 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001288:	6605                	lui	a2,0x1
    8000128a:	4581                	li	a1,0
    8000128c:	a3dff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret

000000008000129c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000129c:	7179                	addi	sp,sp,-48
    8000129e:	f406                	sd	ra,40(sp)
    800012a0:	f022                	sd	s0,32(sp)
    800012a2:	ec26                	sd	s1,24(sp)
    800012a4:	e84a                	sd	s2,16(sp)
    800012a6:	e44e                	sd	s3,8(sp)
    800012a8:	e052                	sd	s4,0(sp)
    800012aa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012ac:	6785                	lui	a5,0x1
    800012ae:	04f67063          	bgeu	a2,a5,800012ee <uvmfirst+0x52>
    800012b2:	8a2a                	mv	s4,a0
    800012b4:	89ae                	mv	s3,a1
    800012b6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012b8:	86dff0ef          	jal	80000b24 <kalloc>
    800012bc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012be:	6605                	lui	a2,0x1
    800012c0:	4581                	li	a1,0
    800012c2:	a07ff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012c6:	4779                	li	a4,30
    800012c8:	86ca                	mv	a3,s2
    800012ca:	6605                	lui	a2,0x1
    800012cc:	4581                	li	a1,0
    800012ce:	8552                	mv	a0,s4
    800012d0:	d45ff0ef          	jal	80001014 <mappages>
  memmove(mem, src, sz);
    800012d4:	8626                	mv	a2,s1
    800012d6:	85ce                	mv	a1,s3
    800012d8:	854a                	mv	a0,s2
    800012da:	a4bff0ef          	jal	80000d24 <memmove>
}
    800012de:	70a2                	ld	ra,40(sp)
    800012e0:	7402                	ld	s0,32(sp)
    800012e2:	64e2                	ld	s1,24(sp)
    800012e4:	6942                	ld	s2,16(sp)
    800012e6:	69a2                	ld	s3,8(sp)
    800012e8:	6a02                	ld	s4,0(sp)
    800012ea:	6145                	addi	sp,sp,48
    800012ec:	8082                	ret
    panic("uvmfirst: more than a page");
    800012ee:	00006517          	auipc	a0,0x6
    800012f2:	e8a50513          	addi	a0,a0,-374 # 80007178 <etext+0x178>
    800012f6:	c9eff0ef          	jal	80000794 <panic>

00000000800012fa <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001304:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001306:	00b67d63          	bgeu	a2,a1,80001320 <uvmdealloc+0x26>
    8000130a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000130c:	6785                	lui	a5,0x1
    8000130e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001310:	00f60733          	add	a4,a2,a5
    80001314:	76fd                	lui	a3,0xfffff
    80001316:	8f75                	and	a4,a4,a3
    80001318:	97ae                	add	a5,a5,a1
    8000131a:	8ff5                	and	a5,a5,a3
    8000131c:	00f76863          	bltu	a4,a5,8000132c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001320:	8526                	mv	a0,s1
    80001322:	60e2                	ld	ra,24(sp)
    80001324:	6442                	ld	s0,16(sp)
    80001326:	64a2                	ld	s1,8(sp)
    80001328:	6105                	addi	sp,sp,32
    8000132a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000132c:	8f99                	sub	a5,a5,a4
    8000132e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001330:	4685                	li	a3,1
    80001332:	0007861b          	sext.w	a2,a5
    80001336:	85ba                	mv	a1,a4
    80001338:	e83ff0ef          	jal	800011ba <uvmunmap>
    8000133c:	b7d5                	j	80001320 <uvmdealloc+0x26>

000000008000133e <uvmalloc>:
  if(newsz < oldsz)
    8000133e:	08b66f63          	bltu	a2,a1,800013dc <uvmalloc+0x9e>
{
    80001342:	7139                	addi	sp,sp,-64
    80001344:	fc06                	sd	ra,56(sp)
    80001346:	f822                	sd	s0,48(sp)
    80001348:	ec4e                	sd	s3,24(sp)
    8000134a:	e852                	sd	s4,16(sp)
    8000134c:	e456                	sd	s5,8(sp)
    8000134e:	0080                	addi	s0,sp,64
    80001350:	8aaa                	mv	s5,a0
    80001352:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001354:	6785                	lui	a5,0x1
    80001356:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001358:	95be                	add	a1,a1,a5
    8000135a:	77fd                	lui	a5,0xfffff
    8000135c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001360:	08c9f063          	bgeu	s3,a2,800013e0 <uvmalloc+0xa2>
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	e05a                	sd	s6,0(sp)
    8000136a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000136c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001370:	fb4ff0ef          	jal	80000b24 <kalloc>
    80001374:	84aa                	mv	s1,a0
    if(mem == 0){
    80001376:	c515                	beqz	a0,800013a2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	94dff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001380:	875a                	mv	a4,s6
    80001382:	86a6                	mv	a3,s1
    80001384:	6605                	lui	a2,0x1
    80001386:	85ca                	mv	a1,s2
    80001388:	8556                	mv	a0,s5
    8000138a:	c8bff0ef          	jal	80001014 <mappages>
    8000138e:	e915                	bnez	a0,800013c2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001390:	6785                	lui	a5,0x1
    80001392:	993e                	add	s2,s2,a5
    80001394:	fd496ee3          	bltu	s2,s4,80001370 <uvmalloc+0x32>
  return newsz;
    80001398:	8552                	mv	a0,s4
    8000139a:	74a2                	ld	s1,40(sp)
    8000139c:	7902                	ld	s2,32(sp)
    8000139e:	6b02                	ld	s6,0(sp)
    800013a0:	a811                	j	800013b4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013a2:	864e                	mv	a2,s3
    800013a4:	85ca                	mv	a1,s2
    800013a6:	8556                	mv	a0,s5
    800013a8:	f53ff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013ac:	4501                	li	a0,0
    800013ae:	74a2                	ld	s1,40(sp)
    800013b0:	7902                	ld	s2,32(sp)
    800013b2:	6b02                	ld	s6,0(sp)
}
    800013b4:	70e2                	ld	ra,56(sp)
    800013b6:	7442                	ld	s0,48(sp)
    800013b8:	69e2                	ld	s3,24(sp)
    800013ba:	6a42                	ld	s4,16(sp)
    800013bc:	6aa2                	ld	s5,8(sp)
    800013be:	6121                	addi	sp,sp,64
    800013c0:	8082                	ret
      kfree(mem);
    800013c2:	8526                	mv	a0,s1
    800013c4:	e7eff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013c8:	864e                	mv	a2,s3
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8556                	mv	a0,s5
    800013ce:	f2dff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013d2:	4501                	li	a0,0
    800013d4:	74a2                	ld	s1,40(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	6b02                	ld	s6,0(sp)
    800013da:	bfe9                	j	800013b4 <uvmalloc+0x76>
    return oldsz;
    800013dc:	852e                	mv	a0,a1
}
    800013de:	8082                	ret
  return newsz;
    800013e0:	8532                	mv	a0,a2
    800013e2:	bfc9                	j	800013b4 <uvmalloc+0x76>

00000000800013e4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
    800013f4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013f6:	84aa                	mv	s1,a0
    800013f8:	6905                	lui	s2,0x1
    800013fa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013fc:	4985                	li	s3,1
    800013fe:	a819                	j	80001414 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001400:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001402:	00c79513          	slli	a0,a5,0xc
    80001406:	fdfff0ef          	jal	800013e4 <freewalk>
      pagetable[i] = 0;
    8000140a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000140e:	04a1                	addi	s1,s1,8
    80001410:	01248f63          	beq	s1,s2,8000142e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001414:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001416:	00f7f713          	andi	a4,a5,15
    8000141a:	ff3703e3          	beq	a4,s3,80001400 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000141e:	8b85                	andi	a5,a5,1
    80001420:	d7fd                	beqz	a5,8000140e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001422:	00006517          	auipc	a0,0x6
    80001426:	d7650513          	addi	a0,a0,-650 # 80007198 <etext+0x198>
    8000142a:	b6aff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    8000142e:	8552                	mv	a0,s4
    80001430:	e12ff0ef          	jal	80000a42 <kfree>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6a02                	ld	s4,0(sp)
    80001440:	6145                	addi	sp,sp,48
    80001442:	8082                	ret

0000000080001444 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001444:	1101                	addi	sp,sp,-32
    80001446:	ec06                	sd	ra,24(sp)
    80001448:	e822                	sd	s0,16(sp)
    8000144a:	e426                	sd	s1,8(sp)
    8000144c:	1000                	addi	s0,sp,32
    8000144e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001450:	e989                	bnez	a1,80001462 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001452:	8526                	mv	a0,s1
    80001454:	f91ff0ef          	jal	800013e4 <freewalk>
}
    80001458:	60e2                	ld	ra,24(sp)
    8000145a:	6442                	ld	s0,16(sp)
    8000145c:	64a2                	ld	s1,8(sp)
    8000145e:	6105                	addi	sp,sp,32
    80001460:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001462:	6785                	lui	a5,0x1
    80001464:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001466:	95be                	add	a1,a1,a5
    80001468:	4685                	li	a3,1
    8000146a:	00c5d613          	srli	a2,a1,0xc
    8000146e:	4581                	li	a1,0
    80001470:	d4bff0ef          	jal	800011ba <uvmunmap>
    80001474:	bff9                	j	80001452 <uvmfree+0xe>

0000000080001476 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001476:	c65d                	beqz	a2,80001524 <uvmcopy+0xae>
{
    80001478:	715d                	addi	sp,sp,-80
    8000147a:	e486                	sd	ra,72(sp)
    8000147c:	e0a2                	sd	s0,64(sp)
    8000147e:	fc26                	sd	s1,56(sp)
    80001480:	f84a                	sd	s2,48(sp)
    80001482:	f44e                	sd	s3,40(sp)
    80001484:	f052                	sd	s4,32(sp)
    80001486:	ec56                	sd	s5,24(sp)
    80001488:	e85a                	sd	s6,16(sp)
    8000148a:	e45e                	sd	s7,8(sp)
    8000148c:	0880                	addi	s0,sp,80
    8000148e:	8b2a                	mv	s6,a0
    80001490:	8aae                	mv	s5,a1
    80001492:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001494:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001496:	4601                	li	a2,0
    80001498:	85ce                	mv	a1,s3
    8000149a:	855a                	mv	a0,s6
    8000149c:	aa1ff0ef          	jal	80000f3c <walk>
    800014a0:	c121                	beqz	a0,800014e0 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014a2:	6118                	ld	a4,0(a0)
    800014a4:	00177793          	andi	a5,a4,1
    800014a8:	c3b1                	beqz	a5,800014ec <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014aa:	00a75593          	srli	a1,a4,0xa
    800014ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014b2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014b6:	e6eff0ef          	jal	80000b24 <kalloc>
    800014ba:	892a                	mv	s2,a0
    800014bc:	c129                	beqz	a0,800014fe <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014be:	6605                	lui	a2,0x1
    800014c0:	85de                	mv	a1,s7
    800014c2:	863ff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014c6:	8726                	mv	a4,s1
    800014c8:	86ca                	mv	a3,s2
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ce                	mv	a1,s3
    800014ce:	8556                	mv	a0,s5
    800014d0:	b45ff0ef          	jal	80001014 <mappages>
    800014d4:	e115                	bnez	a0,800014f8 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014d6:	6785                	lui	a5,0x1
    800014d8:	99be                	add	s3,s3,a5
    800014da:	fb49eee3          	bltu	s3,s4,80001496 <uvmcopy+0x20>
    800014de:	a805                	j	8000150e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014e0:	00006517          	auipc	a0,0x6
    800014e4:	cc850513          	addi	a0,a0,-824 # 800071a8 <etext+0x1a8>
    800014e8:	aacff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    800014ec:	00006517          	auipc	a0,0x6
    800014f0:	cdc50513          	addi	a0,a0,-804 # 800071c8 <etext+0x1c8>
    800014f4:	aa0ff0ef          	jal	80000794 <panic>
      kfree(mem);
    800014f8:	854a                	mv	a0,s2
    800014fa:	d48ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014fe:	4685                	li	a3,1
    80001500:	00c9d613          	srli	a2,s3,0xc
    80001504:	4581                	li	a1,0
    80001506:	8556                	mv	a0,s5
    80001508:	cb3ff0ef          	jal	800011ba <uvmunmap>
  return -1;
    8000150c:	557d                	li	a0,-1
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret

0000000080001528 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001530:	4601                	li	a2,0
    80001532:	a0bff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80001536:	c901                	beqz	a0,80001546 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001538:	611c                	ld	a5,0(a0)
    8000153a:	9bbd                	andi	a5,a5,-17
    8000153c:	e11c                	sd	a5,0(a0)
}
    8000153e:	60a2                	ld	ra,8(sp)
    80001540:	6402                	ld	s0,0(sp)
    80001542:	0141                	addi	sp,sp,16
    80001544:	8082                	ret
    panic("uvmclear");
    80001546:	00006517          	auipc	a0,0x6
    8000154a:	ca250513          	addi	a0,a0,-862 # 800071e8 <etext+0x1e8>
    8000154e:	a46ff0ef          	jal	80000794 <panic>

0000000080001552 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001552:	cad1                	beqz	a3,800015e6 <copyout+0x94>
{
    80001554:	711d                	addi	sp,sp,-96
    80001556:	ec86                	sd	ra,88(sp)
    80001558:	e8a2                	sd	s0,80(sp)
    8000155a:	e4a6                	sd	s1,72(sp)
    8000155c:	fc4e                	sd	s3,56(sp)
    8000155e:	f456                	sd	s5,40(sp)
    80001560:	f05a                	sd	s6,32(sp)
    80001562:	ec5e                	sd	s7,24(sp)
    80001564:	1080                	addi	s0,sp,96
    80001566:	8baa                	mv	s7,a0
    80001568:	8aae                	mv	s5,a1
    8000156a:	8b32                	mv	s6,a2
    8000156c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000156e:	74fd                	lui	s1,0xfffff
    80001570:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001572:	57fd                	li	a5,-1
    80001574:	83e9                	srli	a5,a5,0x1a
    80001576:	0697ea63          	bltu	a5,s1,800015ea <copyout+0x98>
    8000157a:	e0ca                	sd	s2,64(sp)
    8000157c:	f852                	sd	s4,48(sp)
    8000157e:	e862                	sd	s8,16(sp)
    80001580:	e466                	sd	s9,8(sp)
    80001582:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001584:	4cd5                	li	s9,21
    80001586:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001588:	8c3e                	mv	s8,a5
    8000158a:	a025                	j	800015b2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000158c:	83a9                	srli	a5,a5,0xa
    8000158e:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001590:	409a8533          	sub	a0,s5,s1
    80001594:	0009061b          	sext.w	a2,s2
    80001598:	85da                	mv	a1,s6
    8000159a:	953e                	add	a0,a0,a5
    8000159c:	f88ff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015a0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015a4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015a6:	02098963          	beqz	s3,800015d8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015aa:	054c6263          	bltu	s8,s4,800015ee <copyout+0x9c>
    800015ae:	84d2                	mv	s1,s4
    800015b0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015b2:	4601                	li	a2,0
    800015b4:	85a6                	mv	a1,s1
    800015b6:	855e                	mv	a0,s7
    800015b8:	985ff0ef          	jal	80000f3c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015bc:	c121                	beqz	a0,800015fc <copyout+0xaa>
    800015be:	611c                	ld	a5,0(a0)
    800015c0:	0157f713          	andi	a4,a5,21
    800015c4:	05971b63          	bne	a4,s9,8000161a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015c8:	01a48a33          	add	s4,s1,s10
    800015cc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015d0:	fb29fee3          	bgeu	s3,s2,8000158c <copyout+0x3a>
    800015d4:	894e                	mv	s2,s3
    800015d6:	bf5d                	j	8000158c <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015d8:	4501                	li	a0,0
    800015da:	6906                	ld	s2,64(sp)
    800015dc:	7a42                	ld	s4,48(sp)
    800015de:	6c42                	ld	s8,16(sp)
    800015e0:	6ca2                	ld	s9,8(sp)
    800015e2:	6d02                	ld	s10,0(sp)
    800015e4:	a015                	j	80001608 <copyout+0xb6>
    800015e6:	4501                	li	a0,0
}
    800015e8:	8082                	ret
      return -1;
    800015ea:	557d                	li	a0,-1
    800015ec:	a831                	j	80001608 <copyout+0xb6>
    800015ee:	557d                	li	a0,-1
    800015f0:	6906                	ld	s2,64(sp)
    800015f2:	7a42                	ld	s4,48(sp)
    800015f4:	6c42                	ld	s8,16(sp)
    800015f6:	6ca2                	ld	s9,8(sp)
    800015f8:	6d02                	ld	s10,0(sp)
    800015fa:	a039                	j	80001608 <copyout+0xb6>
      return -1;
    800015fc:	557d                	li	a0,-1
    800015fe:	6906                	ld	s2,64(sp)
    80001600:	7a42                	ld	s4,48(sp)
    80001602:	6c42                	ld	s8,16(sp)
    80001604:	6ca2                	ld	s9,8(sp)
    80001606:	6d02                	ld	s10,0(sp)
}
    80001608:	60e6                	ld	ra,88(sp)
    8000160a:	6446                	ld	s0,80(sp)
    8000160c:	64a6                	ld	s1,72(sp)
    8000160e:	79e2                	ld	s3,56(sp)
    80001610:	7aa2                	ld	s5,40(sp)
    80001612:	7b02                	ld	s6,32(sp)
    80001614:	6be2                	ld	s7,24(sp)
    80001616:	6125                	addi	sp,sp,96
    80001618:	8082                	ret
      return -1;
    8000161a:	557d                	li	a0,-1
    8000161c:	6906                	ld	s2,64(sp)
    8000161e:	7a42                	ld	s4,48(sp)
    80001620:	6c42                	ld	s8,16(sp)
    80001622:	6ca2                	ld	s9,8(sp)
    80001624:	6d02                	ld	s10,0(sp)
    80001626:	b7cd                	j	80001608 <copyout+0xb6>

0000000080001628 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001628:	c6a5                	beqz	a3,80001690 <copyin+0x68>
{
    8000162a:	715d                	addi	sp,sp,-80
    8000162c:	e486                	sd	ra,72(sp)
    8000162e:	e0a2                	sd	s0,64(sp)
    80001630:	fc26                	sd	s1,56(sp)
    80001632:	f84a                	sd	s2,48(sp)
    80001634:	f44e                	sd	s3,40(sp)
    80001636:	f052                	sd	s4,32(sp)
    80001638:	ec56                	sd	s5,24(sp)
    8000163a:	e85a                	sd	s6,16(sp)
    8000163c:	e45e                	sd	s7,8(sp)
    8000163e:	e062                	sd	s8,0(sp)
    80001640:	0880                	addi	s0,sp,80
    80001642:	8b2a                	mv	s6,a0
    80001644:	8a2e                	mv	s4,a1
    80001646:	8c32                	mv	s8,a2
    80001648:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000164a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000164c:	6a85                	lui	s5,0x1
    8000164e:	a00d                	j	80001670 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001650:	018505b3          	add	a1,a0,s8
    80001654:	0004861b          	sext.w	a2,s1
    80001658:	412585b3          	sub	a1,a1,s2
    8000165c:	8552                	mv	a0,s4
    8000165e:	ec6ff0ef          	jal	80000d24 <memmove>

    len -= n;
    80001662:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001666:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001668:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000166c:	02098063          	beqz	s3,8000168c <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001670:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001674:	85ca                	mv	a1,s2
    80001676:	855a                	mv	a0,s6
    80001678:	95fff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    8000167c:	cd01                	beqz	a0,80001694 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000167e:	418904b3          	sub	s1,s2,s8
    80001682:	94d6                	add	s1,s1,s5
    if(n > len)
    80001684:	fc99f6e3          	bgeu	s3,s1,80001650 <copyin+0x28>
    80001688:	84ce                	mv	s1,s3
    8000168a:	b7d9                	j	80001650 <copyin+0x28>
  }
  return 0;
    8000168c:	4501                	li	a0,0
    8000168e:	a021                	j	80001696 <copyin+0x6e>
    80001690:	4501                	li	a0,0
}
    80001692:	8082                	ret
      return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6c02                	ld	s8,0(sp)
    800016aa:	6161                	addi	sp,sp,80
    800016ac:	8082                	ret

00000000800016ae <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ae:	c6dd                	beqz	a3,8000175c <copyinstr+0xae>
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	0880                	addi	s0,sp,80
    800016c6:	8a2a                	mv	s4,a0
    800016c8:	8b2e                	mv	s6,a1
    800016ca:	8bb2                	mv	s7,a2
    800016cc:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ce:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016d0:	6985                	lui	s3,0x1
    800016d2:	a825                	j	8000170a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016d4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016d8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016da:	37fd                	addiw	a5,a5,-1
    800016dc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6161                	addi	sp,sp,80
    800016f4:	8082                	ret
    800016f6:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800016fa:	9742                	add	a4,a4,a6
      --max;
    800016fc:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001700:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001704:	04e58463          	beq	a1,a4,8000174c <copyinstr+0x9e>
{
    80001708:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000170a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000170e:	85a6                	mv	a1,s1
    80001710:	8552                	mv	a0,s4
    80001712:	8c5ff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    80001716:	cd0d                	beqz	a0,80001750 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001718:	417486b3          	sub	a3,s1,s7
    8000171c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000171e:	00d97363          	bgeu	s2,a3,80001724 <copyinstr+0x76>
    80001722:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001724:	955e                	add	a0,a0,s7
    80001726:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001728:	c695                	beqz	a3,80001754 <copyinstr+0xa6>
    8000172a:	87da                	mv	a5,s6
    8000172c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000172e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001732:	96da                	add	a3,a3,s6
    80001734:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001736:	00f60733          	add	a4,a2,a5
    8000173a:	00074703          	lbu	a4,0(a4)
    8000173e:	db59                	beqz	a4,800016d4 <copyinstr+0x26>
        *dst = *p;
    80001740:	00e78023          	sb	a4,0(a5)
      dst++;
    80001744:	0785                	addi	a5,a5,1
    while(n > 0){
    80001746:	fed797e3          	bne	a5,a3,80001734 <copyinstr+0x86>
    8000174a:	b775                	j	800016f6 <copyinstr+0x48>
    8000174c:	4781                	li	a5,0
    8000174e:	b771                	j	800016da <copyinstr+0x2c>
      return -1;
    80001750:	557d                	li	a0,-1
    80001752:	b779                	j	800016e0 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001754:	6b85                	lui	s7,0x1
    80001756:	9ba6                	add	s7,s7,s1
    80001758:	87da                	mv	a5,s6
    8000175a:	b77d                	j	80001708 <copyinstr+0x5a>
  int got_null = 0;
    8000175c:	4781                	li	a5,0
  if(got_null){
    8000175e:	37fd                	addiw	a5,a5,-1
    80001760:	0007851b          	sext.w	a0,a5
}
    80001764:	8082                	ret

0000000080001766 <rand_lottery>:
int last_index[4] = {0, 0, 0, 0};

// gera um numero aleatorio 
static unsigned int seed = 123456;

int rand_lottery() {
    80001766:	1141                	addi	sp,sp,-16
    80001768:	e422                	sd	s0,8(sp)
    8000176a:	0800                	addi	s0,sp,16
  seed = seed * 1103515245 + 1248345;
    8000176c:	00009717          	auipc	a4,0x9
    80001770:	b6c70713          	addi	a4,a4,-1172 # 8000a2d8 <seed>
    80001774:	431c                	lw	a5,0(a4)
    80001776:	41c65537          	lui	a0,0x41c65
    8000177a:	e6d5051b          	addiw	a0,a0,-403 # 41c64e6d <_entry-0x3e39b193>
    8000177e:	02f5053b          	mulw	a0,a0,a5
    80001782:	001317b7          	lui	a5,0x131
    80001786:	c597879b          	addiw	a5,a5,-935 # 130c59 <_entry-0x7fecf3a7>
    8000178a:	9d3d                	addw	a0,a0,a5
    8000178c:	c308                	sw	a0,0(a4)
  return (seed / 65536) % 32768;
    8000178e:	1506                	slli	a0,a0,0x21
}
    80001790:	9145                	srli	a0,a0,0x31
    80001792:	6422                	ld	s0,8(sp)
    80001794:	0141                	addi	sp,sp,16
    80001796:	8082                	ret

0000000080001798 <sorteio_prioridade>:
  CLASS_2,
  CLASS_3   
};

//SORTEIO
enum priority_class sorteio_prioridade(void) {
    80001798:	1141                	addi	sp,sp,-16
    8000179a:	e406                	sd	ra,8(sp)
    8000179c:	e022                	sd	s0,0(sp)
    8000179e:	0800                	addi	s0,sp,16
  int total = CLASS_0_BILHETES + CLASS_1_BILHETES + CLASS_2_BILHETES + CLASS_3_BILHETES;
  int sorteio = rand_lottery() % total;
    800017a0:	fc7ff0ef          	jal	80001766 <rand_lottery>
    800017a4:	47b1                	li	a5,12
    800017a6:	02f567bb          	remw	a5,a0,a5

  if (sorteio < CLASS_0_BILHETES)
    800017aa:	4715                	li	a4,5
    return CLASS_0;
    800017ac:	4501                	li	a0,0
  if (sorteio < CLASS_0_BILHETES)
    800017ae:	00f75a63          	bge	a4,a5,800017c2 <sorteio_prioridade+0x2a>
  else if (sorteio < CLASS_0_BILHETES + CLASS_1_BILHETES)
    800017b2:	4721                	li	a4,8
    return CLASS_1;
    800017b4:	4505                	li	a0,1
  else if (sorteio < CLASS_0_BILHETES + CLASS_1_BILHETES)
    800017b6:	00f75663          	bge	a4,a5,800017c2 <sorteio_prioridade+0x2a>
  else if (sorteio < CLASS_0_BILHETES + CLASS_1_BILHETES + CLASS_2_BILHETES)
    800017ba:	4529                	li	a0,10
    return CLASS_2;
    800017bc:	00f52533          	slt	a0,a0,a5
    800017c0:	0509                	addi	a0,a0,2
  else
    return CLASS_3;
}
    800017c2:	60a2                	ld	ra,8(sp)
    800017c4:	6402                	ld	s0,0(sp)
    800017c6:	0141                	addi	sp,sp,16
    800017c8:	8082                	ret

00000000800017ca <scheduler_loteria>:
      scheduler_stride();
    }  
  }
}
///////trabalho1
void scheduler_loteria(void) {
    800017ca:	7119                	addi	sp,sp,-128
    800017cc:	fc86                	sd	ra,120(sp)
    800017ce:	f8a2                	sd	s0,112(sp)
    800017d0:	f4a6                	sd	s1,104(sp)
    800017d2:	f0ca                	sd	s2,96(sp)
    800017d4:	ecce                	sd	s3,88(sp)
    800017d6:	e8d2                	sd	s4,80(sp)
    800017d8:	e4d6                	sd	s5,72(sp)
    800017da:	e0da                	sd	s6,64(sp)
    800017dc:	fc5e                	sd	s7,56(sp)
    800017de:	f862                	sd	s8,48(sp)
    800017e0:	f466                	sd	s9,40(sp)
    800017e2:	f06a                	sd	s10,32(sp)
    800017e4:	ec6e                	sd	s11,24(sp)
    800017e6:	0100                	addi	s0,sp,128
  asm volatile("mv %0, tp" : "=r" (x) );
    800017e8:	8792                	mv	a5,tp
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
    800017ea:	2781                	sext.w	a5,a5
        swtch(&c->context, &p->context);
    800017ec:	00779693          	slli	a3,a5,0x7
    800017f0:	00011717          	auipc	a4,0x11
    800017f4:	cb870713          	addi	a4,a4,-840 # 800124a8 <cpus+0x8>
    800017f8:	9736                	add	a4,a4,a3
    800017fa:	f8e43423          	sd	a4,-120(s0)
    800017fe:	17800b93          	li	s7,376
      p = &proc[idx];
    80001802:	00011b17          	auipc	s6,0x11
    80001806:	0deb0b13          	addi	s6,s6,222 # 800128e0 <proc>
      if (p->state == RUNNABLE && p->classe == classe_atual) { //só roda se RUNNABLE e pertence a classe sorteada
    8000180a:	4c8d                	li	s9,3
        c->proc = p;
    8000180c:	00011717          	auipc	a4,0x11
    80001810:	c9470713          	addi	a4,a4,-876 # 800124a0 <cpus>
    80001814:	00d707b3          	add	a5,a4,a3
    80001818:	f8f43023          	sd	a5,-128(s0)
    8000181c:	a841                	j	800018ac <scheduler_loteria+0xe2>
        release(&p->lock);  // <<<<<<
    8000181e:	854e                	mv	a0,s3
    80001820:	c6cff0ef          	jal	80000c8c <release>
    for (i = 0; i < NPROC; i++) {
    80001824:	2905                	addiw	s2,s2,1
    80001826:	09890363          	beq	s2,s8,800018ac <scheduler_loteria+0xe2>
      int idx = (start + i) % NPROC;
    8000182a:	41f9579b          	sraiw	a5,s2,0x1f
    8000182e:	01a7d79b          	srliw	a5,a5,0x1a
    80001832:	012784bb          	addw	s1,a5,s2
    80001836:	03f4f493          	andi	s1,s1,63
    8000183a:	9c9d                	subw	s1,s1,a5
    8000183c:	00048a1b          	sext.w	s4,s1
      p = &proc[idx];
    80001840:	037a0ab3          	mul	s5,s4,s7
    80001844:	016a89b3          	add	s3,s5,s6
      acquire(&p->lock);
    80001848:	854e                	mv	a0,s3
    8000184a:	baaff0ef          	jal	80000bf4 <acquire>
      if (p->state == RUNNABLE && p->classe == classe_atual) { //só roda se RUNNABLE e pertence a classe sorteada
    8000184e:	0189a783          	lw	a5,24(s3) # 1018 <_entry-0x7fffefe8>
    80001852:	fd9796e3          	bne	a5,s9,8000181e <scheduler_loteria+0x54>
    80001856:	0349a783          	lw	a5,52(s3)
    8000185a:	fda792e3          	bne	a5,s10,8000181e <scheduler_loteria+0x54>
        p->state = RUNNING; //executa o processo
    8000185e:	4791                	li	a5,4
    80001860:	00f9ac23          	sw	a5,24(s3)
        c->proc = p;
    80001864:	f8043903          	ld	s2,-128(s0)
    80001868:	01393023          	sd	s3,0(s2)
        swtch(&c->context, &p->context);
    8000186c:	070a8593          	addi	a1,s5,112 # fffffffffffff070 <end+0xffffffff7ffdb5b0>
    80001870:	95da                	add	a1,a1,s6
    80001872:	f8843503          	ld	a0,-120(s0)
    80001876:	609000ef          	jal	8000267e <swtch>
        c->proc = 0;
    8000187a:	00093023          	sd	zero,0(s2)
        release(&p->lock);
    8000187e:	854e                	mv	a0,s3
    80001880:	c0cff0ef          	jal	80000c8c <release>
        last_index[classe_atual] = (idx + 1) % NPROC;
    80001884:	020d9793          	slli	a5,s11,0x20
    80001888:	01e7dd93          	srli	s11,a5,0x1e
    8000188c:	00011797          	auipc	a5,0x11
    80001890:	c1478793          	addi	a5,a5,-1004 # 800124a0 <cpus>
    80001894:	9dbe                	add	s11,s11,a5
    80001896:	2485                	addiw	s1,s1,1 # fffffffffffff001 <end+0xffffffff7ffdb541>
    80001898:	41f4d71b          	sraiw	a4,s1,0x1f
    8000189c:	01a7571b          	srliw	a4,a4,0x1a
    800018a0:	9cb9                	addw	s1,s1,a4
    800018a2:	03f4f793          	andi	a5,s1,63
    800018a6:	9f99                	subw	a5,a5,a4
    800018a8:	40fda023          	sw	a5,1024(s11)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800018b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018b4:	10079073          	csrw	sstatus,a5
    classe_atual = sorteio_prioridade();
    800018b8:	ee1ff0ef          	jal	80001798 <sorteio_prioridade>
    800018bc:	8daa                	mv	s11,a0
    int start = last_index[classe_atual]; //round robin
    800018be:	02051713          	slli	a4,a0,0x20
    800018c2:	01e75793          	srli	a5,a4,0x1e
    800018c6:	00011717          	auipc	a4,0x11
    800018ca:	bda70713          	addi	a4,a4,-1062 # 800124a0 <cpus>
    800018ce:	97ba                	add	a5,a5,a4
    800018d0:	4007a903          	lw	s2,1024(a5)
    800018d4:	04090c1b          	addiw	s8,s2,64
      if (p->state == RUNNABLE && p->classe == classe_atual) { //só roda se RUNNABLE e pertence a classe sorteada
    800018d8:	00050d1b          	sext.w	s10,a0
    800018dc:	b7b9                	j	8000182a <scheduler_loteria+0x60>

00000000800018de <scheduler_stride>:
void scheduler_stride(void) {
    800018de:	7159                	addi	sp,sp,-112
    800018e0:	f486                	sd	ra,104(sp)
    800018e2:	f0a2                	sd	s0,96(sp)
    800018e4:	eca6                	sd	s1,88(sp)
    800018e6:	e8ca                	sd	s2,80(sp)
    800018e8:	e4ce                	sd	s3,72(sp)
    800018ea:	e0d2                	sd	s4,64(sp)
    800018ec:	fc56                	sd	s5,56(sp)
    800018ee:	f85a                	sd	s6,48(sp)
    800018f0:	f45e                	sd	s7,40(sp)
    800018f2:	f062                	sd	s8,32(sp)
    800018f4:	ec66                	sd	s9,24(sp)
    800018f6:	e86a                	sd	s10,16(sp)
    800018f8:	e46e                	sd	s11,8(sp)
    800018fa:	1880                	addi	s0,sp,112
  asm volatile("mv %0, tp" : "=r" (x) );
    800018fc:	8792                	mv	a5,tp
  int id = r_tp();
    800018fe:	2781                	sext.w	a5,a5
      swtch(&c->context, &min_pass_proc->context);
    80001900:	00779c93          	slli	s9,a5,0x7
    80001904:	00011717          	auipc	a4,0x11
    80001908:	ba470713          	addi	a4,a4,-1116 # 800124a8 <cpus+0x8>
    8000190c:	9cba                	add	s9,s9,a4
    8000190e:	00017a97          	auipc	s5,0x17
    80001912:	dd2a8a93          	addi	s5,s5,-558 # 800186e0 <tickslock>
    min_pass_proc = 0;
    80001916:	4c01                	li	s8,0
      if (p->state == RUNNABLE) {
    80001918:	4a0d                	li	s4,3
          printf("min pass=%d pid=%d\n", min_pass_proc->pass, min_pass_proc->pid);
    8000191a:	00006b17          	auipc	s6,0x6
    8000191e:	8deb0b13          	addi	s6,s6,-1826 # 800071f8 <etext+0x1f8>
      min_pass_proc->state = RUNNING;
    80001922:	4d91                	li	s11,4
      c->proc = min_pass_proc;
    80001924:	079e                	slli	a5,a5,0x7
    80001926:	00011b97          	auipc	s7,0x11
    8000192a:	b7ab8b93          	addi	s7,s7,-1158 # 800124a0 <cpus>
    8000192e:	9bbe                	add	s7,s7,a5
      printf("soma do passo: %d\n", min_pass_proc->pass);
    80001930:	00006d17          	auipc	s10,0x6
    80001934:	8e0d0d13          	addi	s10,s10,-1824 # 80007210 <etext+0x210>
    80001938:	a859                	j	800019ce <scheduler_stride+0xf0>
            release(&min_pass_proc->lock);
    8000193a:	854e                	mv	a0,s3
    8000193c:	b50ff0ef          	jal	80000c8c <release>
          printf("min pass=%d pid=%d\n", min_pass_proc->pass, min_pass_proc->pid);
    80001940:	03092603          	lw	a2,48(s2)
    80001944:	04092583          	lw	a1,64(s2)
    80001948:	855a                	mv	a0,s6
    8000194a:	b79fe0ef          	jal	800004c2 <printf>
          min_pass_proc = p;
    8000194e:	89ca                	mv	s3,s2
    for (int i = 0; i < NPROC; i++) {
    80001950:	17848493          	addi	s1,s1,376
    80001954:	05548463          	beq	s1,s5,8000199c <scheduler_stride+0xbe>
      p = &proc[i];
    80001958:	8926                	mv	s2,s1
      acquire(&p->lock);
    8000195a:	8526                	mv	a0,s1
    8000195c:	a98ff0ef          	jal	80000bf4 <acquire>
      if (p->state == RUNNABLE) {
    80001960:	4c9c                	lw	a5,24(s1)
    80001962:	03479463          	bne	a5,s4,8000198a <scheduler_stride+0xac>
        if (min_pass_proc == 0 
    80001966:	fc098de3          	beqz	s3,80001940 <scheduler_stride+0x62>
          || p->pass < min_pass_proc->pass 
    8000196a:	40b8                	lw	a4,64(s1)
    8000196c:	0409a783          	lw	a5,64(s3)
    80001970:	fcf745e3          	blt	a4,a5,8000193a <scheduler_stride+0x5c>
          || (p->pass == min_pass_proc->pass && p->pid > min_pass_proc->pid)) {
    80001974:	00f71763          	bne	a4,a5,80001982 <scheduler_stride+0xa4>
    80001978:	5898                	lw	a4,48(s1)
    8000197a:	0309a783          	lw	a5,48(s3)
    8000197e:	fae7cee3          	blt	a5,a4,8000193a <scheduler_stride+0x5c>
          release(&p->lock);
    80001982:	854a                	mv	a0,s2
    80001984:	b08ff0ef          	jal	80000c8c <release>
    80001988:	b7e1                	j	80001950 <scheduler_stride+0x72>
        release(&p->lock);
    8000198a:	8526                	mv	a0,s1
    8000198c:	b00ff0ef          	jal	80000c8c <release>
    for (int i = 0; i < NPROC; i++) {
    80001990:	17848493          	addi	s1,s1,376
    80001994:	fd5492e3          	bne	s1,s5,80001958 <scheduler_stride+0x7a>
    if (min_pass_proc) {
    80001998:	02098b63          	beqz	s3,800019ce <scheduler_stride+0xf0>
      min_pass_proc->state = RUNNING;
    8000199c:	01b9ac23          	sw	s11,24(s3)
      c->proc = min_pass_proc;
    800019a0:	013bb023          	sd	s3,0(s7)
      swtch(&c->context, &min_pass_proc->context);
    800019a4:	07098593          	addi	a1,s3,112
    800019a8:	8566                	mv	a0,s9
    800019aa:	4d5000ef          	jal	8000267e <swtch>
      c->proc = 0;
    800019ae:	000bb023          	sd	zero,0(s7)
      min_pass_proc->pass += min_pass_proc->stride;
    800019b2:	0409a783          	lw	a5,64(s3)
    800019b6:	03c9a583          	lw	a1,60(s3)
    800019ba:	9dbd                	addw	a1,a1,a5
    800019bc:	04b9a023          	sw	a1,64(s3)
      printf("soma do passo: %d\n", min_pass_proc->pass);
    800019c0:	2581                	sext.w	a1,a1
    800019c2:	856a                	mv	a0,s10
    800019c4:	afffe0ef          	jal	800004c2 <printf>
      release(&min_pass_proc->lock);
    800019c8:	854e                	mv	a0,s3
    800019ca:	ac2ff0ef          	jal	80000c8c <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800019d2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019d6:	10079073          	csrw	sstatus,a5
    for (int i = 0; i < NPROC; i++) {
    800019da:	00011497          	auipc	s1,0x11
    800019de:	f0648493          	addi	s1,s1,-250 # 800128e0 <proc>
    min_pass_proc = 0;
    800019e2:	89e2                	mv	s3,s8
    800019e4:	bf95                	j	80001958 <scheduler_stride+0x7a>

00000000800019e6 <scheduler>:
void scheduler(void) {
    800019e6:	1141                	addi	sp,sp,-16
    800019e8:	e406                	sd	ra,8(sp)
    800019ea:	e022                	sd	s0,0(sp)
    800019ec:	0800                	addi	s0,sp,16
    if (scheduler_mode == 0){
    800019ee:	00009797          	auipc	a5,0x9
    800019f2:	8e67a783          	lw	a5,-1818(a5) # 8000a2d4 <scheduler_mode>
    800019f6:	e399                	bnez	a5,800019fc <scheduler+0x16>
      scheduler_loteria();
    800019f8:	dd3ff0ef          	jal	800017ca <scheduler_loteria>
      scheduler_stride();
    800019fc:	ee3ff0ef          	jal	800018de <scheduler_stride>

0000000080001a00 <proc_mapstacks>:
{
    80001a00:	7139                	addi	sp,sp,-64
    80001a02:	fc06                	sd	ra,56(sp)
    80001a04:	f822                	sd	s0,48(sp)
    80001a06:	f426                	sd	s1,40(sp)
    80001a08:	f04a                	sd	s2,32(sp)
    80001a0a:	ec4e                	sd	s3,24(sp)
    80001a0c:	e852                	sd	s4,16(sp)
    80001a0e:	e456                	sd	s5,8(sp)
    80001a10:	e05a                	sd	s6,0(sp)
    80001a12:	0080                	addi	s0,sp,64
    80001a14:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a16:	00011497          	auipc	s1,0x11
    80001a1a:	eca48493          	addi	s1,s1,-310 # 800128e0 <proc>
    uint64 va = KSTACK((int) (p - proc));
    80001a1e:	8b26                	mv	s6,s1
    80001a20:	00a36937          	lui	s2,0xa36
    80001a24:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001a28:	0932                	slli	s2,s2,0xc
    80001a2a:	46d90913          	addi	s2,s2,1133
    80001a2e:	0936                	slli	s2,s2,0xd
    80001a30:	df590913          	addi	s2,s2,-523
    80001a34:	093a                	slli	s2,s2,0xe
    80001a36:	6cf90913          	addi	s2,s2,1743
    80001a3a:	040009b7          	lui	s3,0x4000
    80001a3e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a40:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a42:	00017a97          	auipc	s5,0x17
    80001a46:	c9ea8a93          	addi	s5,s5,-866 # 800186e0 <tickslock>
    char *pa = kalloc();
    80001a4a:	8daff0ef          	jal	80000b24 <kalloc>
    80001a4e:	862a                	mv	a2,a0
    if(pa == 0)
    80001a50:	cd15                	beqz	a0,80001a8c <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80001a52:	416485b3          	sub	a1,s1,s6
    80001a56:	858d                	srai	a1,a1,0x3
    80001a58:	032585b3          	mul	a1,a1,s2
    80001a5c:	2585                	addiw	a1,a1,1
    80001a5e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a62:	4719                	li	a4,6
    80001a64:	6685                	lui	a3,0x1
    80001a66:	40b985b3          	sub	a1,s3,a1
    80001a6a:	8552                	mv	a0,s4
    80001a6c:	e58ff0ef          	jal	800010c4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a70:	17848493          	addi	s1,s1,376
    80001a74:	fd549be3          	bne	s1,s5,80001a4a <proc_mapstacks+0x4a>
}
    80001a78:	70e2                	ld	ra,56(sp)
    80001a7a:	7442                	ld	s0,48(sp)
    80001a7c:	74a2                	ld	s1,40(sp)
    80001a7e:	7902                	ld	s2,32(sp)
    80001a80:	69e2                	ld	s3,24(sp)
    80001a82:	6a42                	ld	s4,16(sp)
    80001a84:	6aa2                	ld	s5,8(sp)
    80001a86:	6b02                	ld	s6,0(sp)
    80001a88:	6121                	addi	sp,sp,64
    80001a8a:	8082                	ret
      panic("kalloc");
    80001a8c:	00005517          	auipc	a0,0x5
    80001a90:	79c50513          	addi	a0,a0,1948 # 80007228 <etext+0x228>
    80001a94:	d01fe0ef          	jal	80000794 <panic>

0000000080001a98 <procinit>:
{
    80001a98:	7139                	addi	sp,sp,-64
    80001a9a:	fc06                	sd	ra,56(sp)
    80001a9c:	f822                	sd	s0,48(sp)
    80001a9e:	f426                	sd	s1,40(sp)
    80001aa0:	f04a                	sd	s2,32(sp)
    80001aa2:	ec4e                	sd	s3,24(sp)
    80001aa4:	e852                	sd	s4,16(sp)
    80001aa6:	e456                	sd	s5,8(sp)
    80001aa8:	e05a                	sd	s6,0(sp)
    80001aaa:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    80001aac:	00005597          	auipc	a1,0x5
    80001ab0:	78458593          	addi	a1,a1,1924 # 80007230 <etext+0x230>
    80001ab4:	00011517          	auipc	a0,0x11
    80001ab8:	dfc50513          	addi	a0,a0,-516 # 800128b0 <pid_lock>
    80001abc:	8b8ff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001ac0:	00005597          	auipc	a1,0x5
    80001ac4:	77858593          	addi	a1,a1,1912 # 80007238 <etext+0x238>
    80001ac8:	00011517          	auipc	a0,0x11
    80001acc:	e0050513          	addi	a0,a0,-512 # 800128c8 <wait_lock>
    80001ad0:	8a4ff0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ad4:	00011497          	auipc	s1,0x11
    80001ad8:	e0c48493          	addi	s1,s1,-500 # 800128e0 <proc>
      initlock(&p->lock, "proc");
    80001adc:	00005b17          	auipc	s6,0x5
    80001ae0:	76cb0b13          	addi	s6,s6,1900 # 80007248 <etext+0x248>
      p->kstack = KSTACK((int) (p - proc));
    80001ae4:	8aa6                	mv	s5,s1
    80001ae6:	00a36937          	lui	s2,0xa36
    80001aea:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001aee:	0932                	slli	s2,s2,0xc
    80001af0:	46d90913          	addi	s2,s2,1133
    80001af4:	0936                	slli	s2,s2,0xd
    80001af6:	df590913          	addi	s2,s2,-523
    80001afa:	093a                	slli	s2,s2,0xe
    80001afc:	6cf90913          	addi	s2,s2,1743
    80001b00:	040009b7          	lui	s3,0x4000
    80001b04:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b06:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b08:	00017a17          	auipc	s4,0x17
    80001b0c:	bd8a0a13          	addi	s4,s4,-1064 # 800186e0 <tickslock>
      initlock(&p->lock, "proc");
    80001b10:	85da                	mv	a1,s6
    80001b12:	8526                	mv	a0,s1
    80001b14:	860ff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    80001b18:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001b1c:	415487b3          	sub	a5,s1,s5
    80001b20:	878d                	srai	a5,a5,0x3
    80001b22:	032787b3          	mul	a5,a5,s2
    80001b26:	2785                	addiw	a5,a5,1
    80001b28:	00d7979b          	slliw	a5,a5,0xd
    80001b2c:	40f987b3          	sub	a5,s3,a5
    80001b30:	e8bc                	sd	a5,80(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b32:	17848493          	addi	s1,s1,376
    80001b36:	fd449de3          	bne	s1,s4,80001b10 <procinit+0x78>
}
    80001b3a:	70e2                	ld	ra,56(sp)
    80001b3c:	7442                	ld	s0,48(sp)
    80001b3e:	74a2                	ld	s1,40(sp)
    80001b40:	7902                	ld	s2,32(sp)
    80001b42:	69e2                	ld	s3,24(sp)
    80001b44:	6a42                	ld	s4,16(sp)
    80001b46:	6aa2                	ld	s5,8(sp)
    80001b48:	6b02                	ld	s6,0(sp)
    80001b4a:	6121                	addi	sp,sp,64
    80001b4c:	8082                	ret

0000000080001b4e <cpuid>:
{
    80001b4e:	1141                	addi	sp,sp,-16
    80001b50:	e422                	sd	s0,8(sp)
    80001b52:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b54:	8512                	mv	a0,tp
  return id;
}
    80001b56:	2501                	sext.w	a0,a0
    80001b58:	6422                	ld	s0,8(sp)
    80001b5a:	0141                	addi	sp,sp,16
    80001b5c:	8082                	ret

0000000080001b5e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001b5e:	1141                	addi	sp,sp,-16
    80001b60:	e422                	sd	s0,8(sp)
    80001b62:	0800                	addi	s0,sp,16
    80001b64:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001b66:	2781                	sext.w	a5,a5
    80001b68:	079e                	slli	a5,a5,0x7
  return c;
}
    80001b6a:	00011517          	auipc	a0,0x11
    80001b6e:	93650513          	addi	a0,a0,-1738 # 800124a0 <cpus>
    80001b72:	953e                	add	a0,a0,a5
    80001b74:	6422                	ld	s0,8(sp)
    80001b76:	0141                	addi	sp,sp,16
    80001b78:	8082                	ret

0000000080001b7a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001b7a:	1101                	addi	sp,sp,-32
    80001b7c:	ec06                	sd	ra,24(sp)
    80001b7e:	e822                	sd	s0,16(sp)
    80001b80:	e426                	sd	s1,8(sp)
    80001b82:	1000                	addi	s0,sp,32
  push_off();
    80001b84:	830ff0ef          	jal	80000bb4 <push_off>
    80001b88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001b8a:	2781                	sext.w	a5,a5
    80001b8c:	079e                	slli	a5,a5,0x7
    80001b8e:	00011717          	auipc	a4,0x11
    80001b92:	91270713          	addi	a4,a4,-1774 # 800124a0 <cpus>
    80001b96:	97ba                	add	a5,a5,a4
    80001b98:	6384                	ld	s1,0(a5)
  pop_off();
    80001b9a:	89eff0ef          	jal	80000c38 <pop_off>
  return p;
}
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	60e2                	ld	ra,24(sp)
    80001ba2:	6442                	ld	s0,16(sp)
    80001ba4:	64a2                	ld	s1,8(sp)
    80001ba6:	6105                	addi	sp,sp,32
    80001ba8:	8082                	ret

0000000080001baa <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001baa:	1141                	addi	sp,sp,-16
    80001bac:	e406                	sd	ra,8(sp)
    80001bae:	e022                	sd	s0,0(sp)
    80001bb0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001bb2:	fc9ff0ef          	jal	80001b7a <myproc>
    80001bb6:	8d6ff0ef          	jal	80000c8c <release>

  if (first) {
    80001bba:	00008797          	auipc	a5,0x8
    80001bbe:	7167a783          	lw	a5,1814(a5) # 8000a2d0 <first.1>
    80001bc2:	e799                	bnez	a5,80001bd0 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001bc4:	361000ef          	jal	80002724 <usertrapret>
}
    80001bc8:	60a2                	ld	ra,8(sp)
    80001bca:	6402                	ld	s0,0(sp)
    80001bcc:	0141                	addi	sp,sp,16
    80001bce:	8082                	ret
    fsinit(ROOTDEV);
    80001bd0:	4505                	li	a0,1
    80001bd2:	726010ef          	jal	800032f8 <fsinit>
    first = 0;
    80001bd6:	00008797          	auipc	a5,0x8
    80001bda:	6e07ad23          	sw	zero,1786(a5) # 8000a2d0 <first.1>
    __sync_synchronize();
    80001bde:	0330000f          	fence	rw,rw
    80001be2:	b7cd                	j	80001bc4 <forkret+0x1a>

0000000080001be4 <allocpid>:
{
    80001be4:	1101                	addi	sp,sp,-32
    80001be6:	ec06                	sd	ra,24(sp)
    80001be8:	e822                	sd	s0,16(sp)
    80001bea:	e426                	sd	s1,8(sp)
    80001bec:	e04a                	sd	s2,0(sp)
    80001bee:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001bf0:	00011917          	auipc	s2,0x11
    80001bf4:	cc090913          	addi	s2,s2,-832 # 800128b0 <pid_lock>
    80001bf8:	854a                	mv	a0,s2
    80001bfa:	ffbfe0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    80001bfe:	00008797          	auipc	a5,0x8
    80001c02:	6de78793          	addi	a5,a5,1758 # 8000a2dc <nextpid>
    80001c06:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001c08:	0014871b          	addiw	a4,s1,1
    80001c0c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001c0e:	854a                	mv	a0,s2
    80001c10:	87cff0ef          	jal	80000c8c <release>
}
    80001c14:	8526                	mv	a0,s1
    80001c16:	60e2                	ld	ra,24(sp)
    80001c18:	6442                	ld	s0,16(sp)
    80001c1a:	64a2                	ld	s1,8(sp)
    80001c1c:	6902                	ld	s2,0(sp)
    80001c1e:	6105                	addi	sp,sp,32
    80001c20:	8082                	ret

0000000080001c22 <proc_pagetable>:
{
    80001c22:	1101                	addi	sp,sp,-32
    80001c24:	ec06                	sd	ra,24(sp)
    80001c26:	e822                	sd	s0,16(sp)
    80001c28:	e426                	sd	s1,8(sp)
    80001c2a:	e04a                	sd	s2,0(sp)
    80001c2c:	1000                	addi	s0,sp,32
    80001c2e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001c30:	e46ff0ef          	jal	80001276 <uvmcreate>
    80001c34:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001c36:	cd05                	beqz	a0,80001c6e <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001c38:	4729                	li	a4,10
    80001c3a:	00004697          	auipc	a3,0x4
    80001c3e:	3c668693          	addi	a3,a3,966 # 80006000 <_trampoline>
    80001c42:	6605                	lui	a2,0x1
    80001c44:	040005b7          	lui	a1,0x4000
    80001c48:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c4a:	05b2                	slli	a1,a1,0xc
    80001c4c:	bc8ff0ef          	jal	80001014 <mappages>
    80001c50:	02054663          	bltz	a0,80001c7c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c54:	4719                	li	a4,6
    80001c56:	06893683          	ld	a3,104(s2)
    80001c5a:	6605                	lui	a2,0x1
    80001c5c:	020005b7          	lui	a1,0x2000
    80001c60:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c62:	05b6                	slli	a1,a1,0xd
    80001c64:	8526                	mv	a0,s1
    80001c66:	baeff0ef          	jal	80001014 <mappages>
    80001c6a:	00054f63          	bltz	a0,80001c88 <proc_pagetable+0x66>
}
    80001c6e:	8526                	mv	a0,s1
    80001c70:	60e2                	ld	ra,24(sp)
    80001c72:	6442                	ld	s0,16(sp)
    80001c74:	64a2                	ld	s1,8(sp)
    80001c76:	6902                	ld	s2,0(sp)
    80001c78:	6105                	addi	sp,sp,32
    80001c7a:	8082                	ret
    uvmfree(pagetable, 0);
    80001c7c:	4581                	li	a1,0
    80001c7e:	8526                	mv	a0,s1
    80001c80:	fc4ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001c84:	4481                	li	s1,0
    80001c86:	b7e5                	j	80001c6e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c88:	4681                	li	a3,0
    80001c8a:	4605                	li	a2,1
    80001c8c:	040005b7          	lui	a1,0x4000
    80001c90:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c92:	05b2                	slli	a1,a1,0xc
    80001c94:	8526                	mv	a0,s1
    80001c96:	d24ff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    80001c9a:	4581                	li	a1,0
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	fa6ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001ca2:	4481                	li	s1,0
    80001ca4:	b7e9                	j	80001c6e <proc_pagetable+0x4c>

0000000080001ca6 <proc_freepagetable>:
{
    80001ca6:	1101                	addi	sp,sp,-32
    80001ca8:	ec06                	sd	ra,24(sp)
    80001caa:	e822                	sd	s0,16(sp)
    80001cac:	e426                	sd	s1,8(sp)
    80001cae:	e04a                	sd	s2,0(sp)
    80001cb0:	1000                	addi	s0,sp,32
    80001cb2:	84aa                	mv	s1,a0
    80001cb4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001cb6:	4681                	li	a3,0
    80001cb8:	4605                	li	a2,1
    80001cba:	040005b7          	lui	a1,0x4000
    80001cbe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001cc0:	05b2                	slli	a1,a1,0xc
    80001cc2:	cf8ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001cc6:	4681                	li	a3,0
    80001cc8:	4605                	li	a2,1
    80001cca:	020005b7          	lui	a1,0x2000
    80001cce:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001cd0:	05b6                	slli	a1,a1,0xd
    80001cd2:	8526                	mv	a0,s1
    80001cd4:	ce6ff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    80001cd8:	85ca                	mv	a1,s2
    80001cda:	8526                	mv	a0,s1
    80001cdc:	f68ff0ef          	jal	80001444 <uvmfree>
}
    80001ce0:	60e2                	ld	ra,24(sp)
    80001ce2:	6442                	ld	s0,16(sp)
    80001ce4:	64a2                	ld	s1,8(sp)
    80001ce6:	6902                	ld	s2,0(sp)
    80001ce8:	6105                	addi	sp,sp,32
    80001cea:	8082                	ret

0000000080001cec <freeproc>:
{
    80001cec:	1101                	addi	sp,sp,-32
    80001cee:	ec06                	sd	ra,24(sp)
    80001cf0:	e822                	sd	s0,16(sp)
    80001cf2:	e426                	sd	s1,8(sp)
    80001cf4:	1000                	addi	s0,sp,32
    80001cf6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001cf8:	7528                	ld	a0,104(a0)
    80001cfa:	c119                	beqz	a0,80001d00 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001cfc:	d47fe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001d00:	0604b423          	sd	zero,104(s1)
  if(p->pagetable)
    80001d04:	70a8                	ld	a0,96(s1)
    80001d06:	c501                	beqz	a0,80001d0e <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001d08:	6cac                	ld	a1,88(s1)
    80001d0a:	f9dff0ef          	jal	80001ca6 <proc_freepagetable>
  p->pagetable = 0;
    80001d0e:	0604b023          	sd	zero,96(s1)
  p->sz = 0;
    80001d12:	0404bc23          	sd	zero,88(s1)
  p->pid = 0;
    80001d16:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001d1a:	0404b423          	sd	zero,72(s1)
  p->name[0] = 0;
    80001d1e:	16048423          	sb	zero,360(s1)
  p->chan = 0;
    80001d22:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001d26:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001d2a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001d2e:	0004ac23          	sw	zero,24(s1)
}
    80001d32:	60e2                	ld	ra,24(sp)
    80001d34:	6442                	ld	s0,16(sp)
    80001d36:	64a2                	ld	s1,8(sp)
    80001d38:	6105                	addi	sp,sp,32
    80001d3a:	8082                	ret

0000000080001d3c <allocproc>:
{
    80001d3c:	1101                	addi	sp,sp,-32
    80001d3e:	ec06                	sd	ra,24(sp)
    80001d40:	e822                	sd	s0,16(sp)
    80001d42:	e426                	sd	s1,8(sp)
    80001d44:	e04a                	sd	s2,0(sp)
    80001d46:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d48:	00011497          	auipc	s1,0x11
    80001d4c:	b9848493          	addi	s1,s1,-1128 # 800128e0 <proc>
    80001d50:	00017917          	auipc	s2,0x17
    80001d54:	99090913          	addi	s2,s2,-1648 # 800186e0 <tickslock>
    acquire(&p->lock);
    80001d58:	8526                	mv	a0,s1
    80001d5a:	e9bfe0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80001d5e:	4c9c                	lw	a5,24(s1)
    80001d60:	cb91                	beqz	a5,80001d74 <allocproc+0x38>
      release(&p->lock);
    80001d62:	8526                	mv	a0,s1
    80001d64:	f29fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d68:	17848493          	addi	s1,s1,376
    80001d6c:	ff2496e3          	bne	s1,s2,80001d58 <allocproc+0x1c>
  return 0;
    80001d70:	4481                	li	s1,0
    80001d72:	a099                	j	80001db8 <allocproc+0x7c>
  p->pid = allocpid();
    80001d74:	e71ff0ef          	jal	80001be4 <allocpid>
    80001d78:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001d7a:	4785                	li	a5,1
    80001d7c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001d7e:	da7fe0ef          	jal	80000b24 <kalloc>
    80001d82:	892a                	mv	s2,a0
    80001d84:	f4a8                	sd	a0,104(s1)
    80001d86:	c121                	beqz	a0,80001dc6 <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80001d88:	8526                	mv	a0,s1
    80001d8a:	e99ff0ef          	jal	80001c22 <proc_pagetable>
    80001d8e:	892a                	mv	s2,a0
    80001d90:	f0a8                	sd	a0,96(s1)
  if(p->pagetable == 0){
    80001d92:	c131                	beqz	a0,80001dd6 <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80001d94:	07000613          	li	a2,112
    80001d98:	4581                	li	a1,0
    80001d9a:	07048513          	addi	a0,s1,112
    80001d9e:	f2bfe0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001da2:	00000797          	auipc	a5,0x0
    80001da6:	e0878793          	addi	a5,a5,-504 # 80001baa <forkret>
    80001daa:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001dac:	68bc                	ld	a5,80(s1)
    80001dae:	6705                	lui	a4,0x1
    80001db0:	97ba                	add	a5,a5,a4
    80001db2:	fcbc                	sd	a5,120(s1)
  p->prioridade = 3; // a prioridade mais baixa (classe 3) deve ser o padrão para os processos criados com fork() comum,
    80001db4:	478d                	li	a5,3
    80001db6:	dc9c                	sw	a5,56(s1)
}
    80001db8:	8526                	mv	a0,s1
    80001dba:	60e2                	ld	ra,24(sp)
    80001dbc:	6442                	ld	s0,16(sp)
    80001dbe:	64a2                	ld	s1,8(sp)
    80001dc0:	6902                	ld	s2,0(sp)
    80001dc2:	6105                	addi	sp,sp,32
    80001dc4:	8082                	ret
    freeproc(p);
    80001dc6:	8526                	mv	a0,s1
    80001dc8:	f25ff0ef          	jal	80001cec <freeproc>
    release(&p->lock);
    80001dcc:	8526                	mv	a0,s1
    80001dce:	ebffe0ef          	jal	80000c8c <release>
    return 0;
    80001dd2:	84ca                	mv	s1,s2
    80001dd4:	b7d5                	j	80001db8 <allocproc+0x7c>
    freeproc(p);
    80001dd6:	8526                	mv	a0,s1
    80001dd8:	f15ff0ef          	jal	80001cec <freeproc>
    release(&p->lock);
    80001ddc:	8526                	mv	a0,s1
    80001dde:	eaffe0ef          	jal	80000c8c <release>
    return 0;
    80001de2:	84ca                	mv	s1,s2
    80001de4:	bfd1                	j	80001db8 <allocproc+0x7c>

0000000080001de6 <forkprio>:
int forkprio(int prio) {
    80001de6:	7139                	addi	sp,sp,-64
    80001de8:	fc06                	sd	ra,56(sp)
    80001dea:	f822                	sd	s0,48(sp)
    80001dec:	f04a                	sd	s2,32(sp)
    80001dee:	e456                	sd	s5,8(sp)
    80001df0:	e05a                	sd	s6,0(sp)
    80001df2:	0080                	addi	s0,sp,64
    80001df4:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80001df6:	d85ff0ef          	jal	80001b7a <myproc>
    80001dfa:	8aaa                	mv	s5,a0
    if((np = allocproc()) == 0) {
    80001dfc:	f41ff0ef          	jal	80001d3c <allocproc>
    80001e00:	12050c63          	beqz	a0,80001f38 <forkprio+0x152>
    80001e04:	ec4e                	sd	s3,24(sp)
    80001e06:	89aa                	mv	s3,a0
    np->classe = prio;  // Associa a prioridade
    80001e08:	03652a23          	sw	s6,52(a0)
    if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001e0c:	058ab603          	ld	a2,88(s5)
    80001e10:	712c                	ld	a1,96(a0)
    80001e12:	060ab503          	ld	a0,96(s5)
    80001e16:	e60ff0ef          	jal	80001476 <uvmcopy>
    80001e1a:	04054a63          	bltz	a0,80001e6e <forkprio+0x88>
    80001e1e:	f426                	sd	s1,40(sp)
    80001e20:	e852                	sd	s4,16(sp)
    np->sz = p->sz;
    80001e22:	058ab783          	ld	a5,88(s5)
    80001e26:	04f9bc23          	sd	a5,88(s3)
    *(np->trapframe) = *(p->trapframe);
    80001e2a:	068ab683          	ld	a3,104(s5)
    80001e2e:	87b6                	mv	a5,a3
    80001e30:	0689b703          	ld	a4,104(s3)
    80001e34:	12068693          	addi	a3,a3,288
    80001e38:	0007b803          	ld	a6,0(a5)
    80001e3c:	6788                	ld	a0,8(a5)
    80001e3e:	6b8c                	ld	a1,16(a5)
    80001e40:	6f90                	ld	a2,24(a5)
    80001e42:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001e46:	e708                	sd	a0,8(a4)
    80001e48:	eb0c                	sd	a1,16(a4)
    80001e4a:	ef10                	sd	a2,24(a4)
    80001e4c:	02078793          	addi	a5,a5,32
    80001e50:	02070713          	addi	a4,a4,32
    80001e54:	fed792e3          	bne	a5,a3,80001e38 <forkprio+0x52>
    np->trapframe->a0 = 0;
    80001e58:	0689b783          	ld	a5,104(s3)
    80001e5c:	0607b823          	sd	zero,112(a5)
    for(i = 0; i < NOFILE; i++) {
    80001e60:	0e0a8493          	addi	s1,s5,224
    80001e64:	0e098913          	addi	s2,s3,224
    80001e68:	160a8a13          	addi	s4,s5,352
    80001e6c:	a00d                	j	80001e8e <forkprio+0xa8>
      acquire(&np->lock);  // garante que o lock está seguro
    80001e6e:	854e                	mv	a0,s3
    80001e70:	d85fe0ef          	jal	80000bf4 <acquire>
      freeproc(np);
    80001e74:	854e                	mv	a0,s3
    80001e76:	e77ff0ef          	jal	80001cec <freeproc>
      release(&np->lock);
    80001e7a:	854e                	mv	a0,s3
    80001e7c:	e11fe0ef          	jal	80000c8c <release>
      return -1;
    80001e80:	597d                	li	s2,-1
    80001e82:	69e2                	ld	s3,24(sp)
    80001e84:	a055                	j	80001f28 <forkprio+0x142>
    for(i = 0; i < NOFILE; i++) {
    80001e86:	04a1                	addi	s1,s1,8
    80001e88:	0921                	addi	s2,s2,8
    80001e8a:	01448963          	beq	s1,s4,80001e9c <forkprio+0xb6>
        if(p->ofile[i]) {
    80001e8e:	6088                	ld	a0,0(s1)
    80001e90:	d97d                	beqz	a0,80001e86 <forkprio+0xa0>
            np->ofile[i] = filedup(p->ofile[i]);
    80001e92:	304020ef          	jal	80004196 <filedup>
    80001e96:	00a93023          	sd	a0,0(s2)
    80001e9a:	b7f5                	j	80001e86 <forkprio+0xa0>
    np->cwd = idup(p->cwd);
    80001e9c:	160ab503          	ld	a0,352(s5)
    80001ea0:	656010ef          	jal	800034f6 <idup>
    80001ea4:	16a9b023          	sd	a0,352(s3)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001ea8:	4641                	li	a2,16
    80001eaa:	168a8593          	addi	a1,s5,360
    80001eae:	16898513          	addi	a0,s3,360
    80001eb2:	f55fe0ef          	jal	80000e06 <safestrcpy>
    pid = np->pid;
    80001eb6:	0309a903          	lw	s2,48(s3)
    switch (prio) {
    80001eba:	4785                	li	a5,1
    80001ebc:	03200713          	li	a4,50
    80001ec0:	00fb0e63          	beq	s6,a5,80001edc <forkprio+0xf6>
    80001ec4:	4789                	li	a5,2
    80001ec6:	0fa00713          	li	a4,250
    80001eca:	00fb0963          	beq	s6,a5,80001edc <forkprio+0xf6>
    80001ece:	06400713          	li	a4,100
    80001ed2:	000b0563          	beqz	s6,80001edc <forkprio+0xf6>
    80001ed6:	6709                	lui	a4,0x2
    80001ed8:	71070713          	addi	a4,a4,1808 # 2710 <_entry-0x7fffd8f0>
      np->tickets = 100;
    80001edc:	04e9a223          	sw	a4,68(s3)
    np->stride = 10000 / np->tickets;
    80001ee0:	6789                	lui	a5,0x2
    80001ee2:	7107879b          	addiw	a5,a5,1808 # 2710 <_entry-0x7fffd8f0>
    80001ee6:	02e7c7bb          	divw	a5,a5,a4
    80001eea:	02f9ae23          	sw	a5,60(s3)
    np->pass = 0;
    80001eee:	0409a023          	sw	zero,64(s3)
    release(&np->lock);
    80001ef2:	854e                	mv	a0,s3
    80001ef4:	d99fe0ef          	jal	80000c8c <release>
    acquire(&wait_lock);
    80001ef8:	00011497          	auipc	s1,0x11
    80001efc:	9d048493          	addi	s1,s1,-1584 # 800128c8 <wait_lock>
    80001f00:	8526                	mv	a0,s1
    80001f02:	cf3fe0ef          	jal	80000bf4 <acquire>
    np->parent = p;
    80001f06:	0559b423          	sd	s5,72(s3)
    release(&wait_lock);
    80001f0a:	8526                	mv	a0,s1
    80001f0c:	d81fe0ef          	jal	80000c8c <release>
    acquire(&np->lock);
    80001f10:	854e                	mv	a0,s3
    80001f12:	ce3fe0ef          	jal	80000bf4 <acquire>
    np->state = RUNNABLE;
    80001f16:	478d                	li	a5,3
    80001f18:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    80001f1c:	854e                	mv	a0,s3
    80001f1e:	d6ffe0ef          	jal	80000c8c <release>
    return pid;
    80001f22:	74a2                	ld	s1,40(sp)
    80001f24:	69e2                	ld	s3,24(sp)
    80001f26:	6a42                	ld	s4,16(sp)
}
    80001f28:	854a                	mv	a0,s2
    80001f2a:	70e2                	ld	ra,56(sp)
    80001f2c:	7442                	ld	s0,48(sp)
    80001f2e:	7902                	ld	s2,32(sp)
    80001f30:	6aa2                	ld	s5,8(sp)
    80001f32:	6b02                	ld	s6,0(sp)
    80001f34:	6121                	addi	sp,sp,64
    80001f36:	8082                	ret
        return -1;
    80001f38:	597d                	li	s2,-1
    80001f3a:	b7fd                	j	80001f28 <forkprio+0x142>

0000000080001f3c <userinit>:
{
    80001f3c:	1101                	addi	sp,sp,-32
    80001f3e:	ec06                	sd	ra,24(sp)
    80001f40:	e822                	sd	s0,16(sp)
    80001f42:	e426                	sd	s1,8(sp)
    80001f44:	1000                	addi	s0,sp,32
  p = allocproc();
    80001f46:	df7ff0ef          	jal	80001d3c <allocproc>
    80001f4a:	84aa                	mv	s1,a0
  initproc = p;
    80001f4c:	00008797          	auipc	a5,0x8
    80001f50:	40a7be23          	sd	a0,1052(a5) # 8000a368 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f54:	03400613          	li	a2,52
    80001f58:	00008597          	auipc	a1,0x8
    80001f5c:	38858593          	addi	a1,a1,904 # 8000a2e0 <initcode>
    80001f60:	7128                	ld	a0,96(a0)
    80001f62:	b3aff0ef          	jal	8000129c <uvmfirst>
  p->sz = PGSIZE;
    80001f66:	6785                	lui	a5,0x1
    80001f68:	ecbc                	sd	a5,88(s1)
  p->trapframe->epc = 0;      // user program counter
    80001f6a:	74b8                	ld	a4,104(s1)
    80001f6c:	00073c23          	sd	zero,24(a4)
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001f70:	74b8                	ld	a4,104(s1)
    80001f72:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f74:	4641                	li	a2,16
    80001f76:	00005597          	auipc	a1,0x5
    80001f7a:	2da58593          	addi	a1,a1,730 # 80007250 <etext+0x250>
    80001f7e:	16848513          	addi	a0,s1,360
    80001f82:	e85fe0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80001f86:	00005517          	auipc	a0,0x5
    80001f8a:	2da50513          	addi	a0,a0,730 # 80007260 <etext+0x260>
    80001f8e:	479010ef          	jal	80003c06 <namei>
    80001f92:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80001f96:	478d                	li	a5,3
    80001f98:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001f9a:	8526                	mv	a0,s1
    80001f9c:	cf1fe0ef          	jal	80000c8c <release>
}
    80001fa0:	60e2                	ld	ra,24(sp)
    80001fa2:	6442                	ld	s0,16(sp)
    80001fa4:	64a2                	ld	s1,8(sp)
    80001fa6:	6105                	addi	sp,sp,32
    80001fa8:	8082                	ret

0000000080001faa <growproc>:
{
    80001faa:	1101                	addi	sp,sp,-32
    80001fac:	ec06                	sd	ra,24(sp)
    80001fae:	e822                	sd	s0,16(sp)
    80001fb0:	e426                	sd	s1,8(sp)
    80001fb2:	e04a                	sd	s2,0(sp)
    80001fb4:	1000                	addi	s0,sp,32
    80001fb6:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001fb8:	bc3ff0ef          	jal	80001b7a <myproc>
    80001fbc:	84aa                	mv	s1,a0
  sz = p->sz;
    80001fbe:	6d2c                	ld	a1,88(a0)
  if(n > 0){
    80001fc0:	01204c63          	bgtz	s2,80001fd8 <growproc+0x2e>
  } else if(n < 0){
    80001fc4:	02094463          	bltz	s2,80001fec <growproc+0x42>
  p->sz = sz;
    80001fc8:	ecac                	sd	a1,88(s1)
  return 0;
    80001fca:	4501                	li	a0,0
}
    80001fcc:	60e2                	ld	ra,24(sp)
    80001fce:	6442                	ld	s0,16(sp)
    80001fd0:	64a2                	ld	s1,8(sp)
    80001fd2:	6902                	ld	s2,0(sp)
    80001fd4:	6105                	addi	sp,sp,32
    80001fd6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001fd8:	4691                	li	a3,4
    80001fda:	00b90633          	add	a2,s2,a1
    80001fde:	7128                	ld	a0,96(a0)
    80001fe0:	b5eff0ef          	jal	8000133e <uvmalloc>
    80001fe4:	85aa                	mv	a1,a0
    80001fe6:	f16d                	bnez	a0,80001fc8 <growproc+0x1e>
      return -1;
    80001fe8:	557d                	li	a0,-1
    80001fea:	b7cd                	j	80001fcc <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001fec:	00b90633          	add	a2,s2,a1
    80001ff0:	7128                	ld	a0,96(a0)
    80001ff2:	b08ff0ef          	jal	800012fa <uvmdealloc>
    80001ff6:	85aa                	mv	a1,a0
    80001ff8:	bfc1                	j	80001fc8 <growproc+0x1e>

0000000080001ffa <fork>:
{
    80001ffa:	7139                	addi	sp,sp,-64
    80001ffc:	fc06                	sd	ra,56(sp)
    80001ffe:	f822                	sd	s0,48(sp)
    80002000:	f426                	sd	s1,40(sp)
    80002002:	f04a                	sd	s2,32(sp)
    80002004:	e456                	sd	s5,8(sp)
    80002006:	0080                	addi	s0,sp,64
    80002008:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000200a:	b71ff0ef          	jal	80001b7a <myproc>
    8000200e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80002010:	d2dff0ef          	jal	80001d3c <allocproc>
    80002014:	0e050a63          	beqz	a0,80002108 <fork+0x10e>
    80002018:	ec4e                	sd	s3,24(sp)
    8000201a:	89aa                	mv	s3,a0
  np->classe = class;  // ***onde np é o novo processo (proc*)
    8000201c:	d944                	sw	s1,52(a0)
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000201e:	058ab603          	ld	a2,88(s5)
    80002022:	712c                	ld	a1,96(a0)
    80002024:	060ab503          	ld	a0,96(s5)
    80002028:	c4eff0ef          	jal	80001476 <uvmcopy>
    8000202c:	04054963          	bltz	a0,8000207e <fork+0x84>
    80002030:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80002032:	058ab783          	ld	a5,88(s5)
    80002036:	04f9bc23          	sd	a5,88(s3)
  *(np->trapframe) = *(p->trapframe);
    8000203a:	068ab683          	ld	a3,104(s5)
    8000203e:	87b6                	mv	a5,a3
    80002040:	0689b703          	ld	a4,104(s3)
    80002044:	12068693          	addi	a3,a3,288
    80002048:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000204c:	6788                	ld	a0,8(a5)
    8000204e:	6b8c                	ld	a1,16(a5)
    80002050:	6f90                	ld	a2,24(a5)
    80002052:	01073023          	sd	a6,0(a4)
    80002056:	e708                	sd	a0,8(a4)
    80002058:	eb0c                	sd	a1,16(a4)
    8000205a:	ef10                	sd	a2,24(a4)
    8000205c:	02078793          	addi	a5,a5,32
    80002060:	02070713          	addi	a4,a4,32
    80002064:	fed792e3          	bne	a5,a3,80002048 <fork+0x4e>
  np->trapframe->a0 = 0;
    80002068:	0689b783          	ld	a5,104(s3)
    8000206c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002070:	0e0a8493          	addi	s1,s5,224
    80002074:	0e098913          	addi	s2,s3,224
    80002078:	160a8a13          	addi	s4,s5,352
    8000207c:	a831                	j	80002098 <fork+0x9e>
    freeproc(np);
    8000207e:	854e                	mv	a0,s3
    80002080:	c6dff0ef          	jal	80001cec <freeproc>
    release(&np->lock);
    80002084:	854e                	mv	a0,s3
    80002086:	c07fe0ef          	jal	80000c8c <release>
    return -1;
    8000208a:	597d                	li	s2,-1
    8000208c:	69e2                	ld	s3,24(sp)
    8000208e:	a0ad                	j	800020f8 <fork+0xfe>
  for(i = 0; i < NOFILE; i++)
    80002090:	04a1                	addi	s1,s1,8
    80002092:	0921                	addi	s2,s2,8
    80002094:	01448963          	beq	s1,s4,800020a6 <fork+0xac>
    if(p->ofile[i])
    80002098:	6088                	ld	a0,0(s1)
    8000209a:	d97d                	beqz	a0,80002090 <fork+0x96>
      np->ofile[i] = filedup(p->ofile[i]);
    8000209c:	0fa020ef          	jal	80004196 <filedup>
    800020a0:	00a93023          	sd	a0,0(s2)
    800020a4:	b7f5                	j	80002090 <fork+0x96>
  np->cwd = idup(p->cwd);
    800020a6:	160ab503          	ld	a0,352(s5)
    800020aa:	44c010ef          	jal	800034f6 <idup>
    800020ae:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800020b2:	4641                	li	a2,16
    800020b4:	168a8593          	addi	a1,s5,360
    800020b8:	16898513          	addi	a0,s3,360
    800020bc:	d4bfe0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    800020c0:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800020c4:	854e                	mv	a0,s3
    800020c6:	bc7fe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    800020ca:	00010497          	auipc	s1,0x10
    800020ce:	7fe48493          	addi	s1,s1,2046 # 800128c8 <wait_lock>
    800020d2:	8526                	mv	a0,s1
    800020d4:	b21fe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    800020d8:	0559b423          	sd	s5,72(s3)
  release(&wait_lock);
    800020dc:	8526                	mv	a0,s1
    800020de:	baffe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    800020e2:	854e                	mv	a0,s3
    800020e4:	b11fe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    800020e8:	478d                	li	a5,3
    800020ea:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800020ee:	854e                	mv	a0,s3
    800020f0:	b9dfe0ef          	jal	80000c8c <release>
  return pid;
    800020f4:	69e2                	ld	s3,24(sp)
    800020f6:	6a42                	ld	s4,16(sp)
}
    800020f8:	854a                	mv	a0,s2
    800020fa:	70e2                	ld	ra,56(sp)
    800020fc:	7442                	ld	s0,48(sp)
    800020fe:	74a2                	ld	s1,40(sp)
    80002100:	7902                	ld	s2,32(sp)
    80002102:	6aa2                	ld	s5,8(sp)
    80002104:	6121                	addi	sp,sp,64
    80002106:	8082                	ret
    return -1;
    80002108:	597d                	li	s2,-1
    8000210a:	b7fd                	j	800020f8 <fork+0xfe>

000000008000210c <sched>:
{
    8000210c:	7179                	addi	sp,sp,-48
    8000210e:	f406                	sd	ra,40(sp)
    80002110:	f022                	sd	s0,32(sp)
    80002112:	ec26                	sd	s1,24(sp)
    80002114:	e84a                	sd	s2,16(sp)
    80002116:	e44e                	sd	s3,8(sp)
    80002118:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000211a:	a61ff0ef          	jal	80001b7a <myproc>
    8000211e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002120:	a6bfe0ef          	jal	80000b8a <holding>
    80002124:	c52d                	beqz	a0,8000218e <sched+0x82>
    80002126:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002128:	2781                	sext.w	a5,a5
    8000212a:	079e                	slli	a5,a5,0x7
    8000212c:	00010717          	auipc	a4,0x10
    80002130:	37470713          	addi	a4,a4,884 # 800124a0 <cpus>
    80002134:	97ba                	add	a5,a5,a4
    80002136:	5fb8                	lw	a4,120(a5)
    80002138:	4785                	li	a5,1
    8000213a:	06f71063          	bne	a4,a5,8000219a <sched+0x8e>
  if(p->state == RUNNING)
    8000213e:	4c98                	lw	a4,24(s1)
    80002140:	4791                	li	a5,4
    80002142:	06f70263          	beq	a4,a5,800021a6 <sched+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002146:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000214a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000214c:	e3bd                	bnez	a5,800021b2 <sched+0xa6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000214e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002150:	00010917          	auipc	s2,0x10
    80002154:	35090913          	addi	s2,s2,848 # 800124a0 <cpus>
    80002158:	2781                	sext.w	a5,a5
    8000215a:	079e                	slli	a5,a5,0x7
    8000215c:	97ca                	add	a5,a5,s2
    8000215e:	07c7a983          	lw	s3,124(a5)
    80002162:	8592                	mv	a1,tp
  swtch(&p->context, &mycpu()->context);
    80002164:	2581                	sext.w	a1,a1
    80002166:	059e                	slli	a1,a1,0x7
    80002168:	05a1                	addi	a1,a1,8
    8000216a:	95ca                	add	a1,a1,s2
    8000216c:	07048513          	addi	a0,s1,112
    80002170:	50e000ef          	jal	8000267e <swtch>
    80002174:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002176:	2781                	sext.w	a5,a5
    80002178:	079e                	slli	a5,a5,0x7
    8000217a:	993e                	add	s2,s2,a5
    8000217c:	07392e23          	sw	s3,124(s2)
}
    80002180:	70a2                	ld	ra,40(sp)
    80002182:	7402                	ld	s0,32(sp)
    80002184:	64e2                	ld	s1,24(sp)
    80002186:	6942                	ld	s2,16(sp)
    80002188:	69a2                	ld	s3,8(sp)
    8000218a:	6145                	addi	sp,sp,48
    8000218c:	8082                	ret
    panic("sched p->lock");
    8000218e:	00005517          	auipc	a0,0x5
    80002192:	0da50513          	addi	a0,a0,218 # 80007268 <etext+0x268>
    80002196:	dfefe0ef          	jal	80000794 <panic>
    panic("sched locks");
    8000219a:	00005517          	auipc	a0,0x5
    8000219e:	0de50513          	addi	a0,a0,222 # 80007278 <etext+0x278>
    800021a2:	df2fe0ef          	jal	80000794 <panic>
    panic("sched running");
    800021a6:	00005517          	auipc	a0,0x5
    800021aa:	0e250513          	addi	a0,a0,226 # 80007288 <etext+0x288>
    800021ae:	de6fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    800021b2:	00005517          	auipc	a0,0x5
    800021b6:	0e650513          	addi	a0,a0,230 # 80007298 <etext+0x298>
    800021ba:	ddafe0ef          	jal	80000794 <panic>

00000000800021be <yield>:
{
    800021be:	1101                	addi	sp,sp,-32
    800021c0:	ec06                	sd	ra,24(sp)
    800021c2:	e822                	sd	s0,16(sp)
    800021c4:	e426                	sd	s1,8(sp)
    800021c6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021c8:	9b3ff0ef          	jal	80001b7a <myproc>
    800021cc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021ce:	a27fe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    800021d2:	478d                	li	a5,3
    800021d4:	cc9c                	sw	a5,24(s1)
  sched();
    800021d6:	f37ff0ef          	jal	8000210c <sched>
  release(&p->lock);
    800021da:	8526                	mv	a0,s1
    800021dc:	ab1fe0ef          	jal	80000c8c <release>
}
    800021e0:	60e2                	ld	ra,24(sp)
    800021e2:	6442                	ld	s0,16(sp)
    800021e4:	64a2                	ld	s1,8(sp)
    800021e6:	6105                	addi	sp,sp,32
    800021e8:	8082                	ret

00000000800021ea <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800021ea:	7179                	addi	sp,sp,-48
    800021ec:	f406                	sd	ra,40(sp)
    800021ee:	f022                	sd	s0,32(sp)
    800021f0:	ec26                	sd	s1,24(sp)
    800021f2:	e84a                	sd	s2,16(sp)
    800021f4:	e44e                	sd	s3,8(sp)
    800021f6:	1800                	addi	s0,sp,48
    800021f8:	89aa                	mv	s3,a0
    800021fa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021fc:	97fff0ef          	jal	80001b7a <myproc>
    80002200:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002202:	9f3fe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80002206:	854a                	mv	a0,s2
    80002208:	a85fe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    8000220c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002210:	4789                	li	a5,2
    80002212:	cc9c                	sw	a5,24(s1)

  sched();
    80002214:	ef9ff0ef          	jal	8000210c <sched>

  // Tidy up.
  p->chan = 0;
    80002218:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000221c:	8526                	mv	a0,s1
    8000221e:	a6ffe0ef          	jal	80000c8c <release>
  acquire(lk);
    80002222:	854a                	mv	a0,s2
    80002224:	9d1fe0ef          	jal	80000bf4 <acquire>
}
    80002228:	70a2                	ld	ra,40(sp)
    8000222a:	7402                	ld	s0,32(sp)
    8000222c:	64e2                	ld	s1,24(sp)
    8000222e:	6942                	ld	s2,16(sp)
    80002230:	69a2                	ld	s3,8(sp)
    80002232:	6145                	addi	sp,sp,48
    80002234:	8082                	ret

0000000080002236 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002236:	7139                	addi	sp,sp,-64
    80002238:	fc06                	sd	ra,56(sp)
    8000223a:	f822                	sd	s0,48(sp)
    8000223c:	f426                	sd	s1,40(sp)
    8000223e:	f04a                	sd	s2,32(sp)
    80002240:	ec4e                	sd	s3,24(sp)
    80002242:	e852                	sd	s4,16(sp)
    80002244:	e456                	sd	s5,8(sp)
    80002246:	0080                	addi	s0,sp,64
    80002248:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000224a:	00010497          	auipc	s1,0x10
    8000224e:	69648493          	addi	s1,s1,1686 # 800128e0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002252:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002254:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002256:	00016917          	auipc	s2,0x16
    8000225a:	48a90913          	addi	s2,s2,1162 # 800186e0 <tickslock>
    8000225e:	a801                	j	8000226e <wakeup+0x38>
      }
      release(&p->lock);
    80002260:	8526                	mv	a0,s1
    80002262:	a2bfe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002266:	17848493          	addi	s1,s1,376
    8000226a:	03248263          	beq	s1,s2,8000228e <wakeup+0x58>
    if(p != myproc()){
    8000226e:	90dff0ef          	jal	80001b7a <myproc>
    80002272:	fea48ae3          	beq	s1,a0,80002266 <wakeup+0x30>
      acquire(&p->lock);
    80002276:	8526                	mv	a0,s1
    80002278:	97dfe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000227c:	4c9c                	lw	a5,24(s1)
    8000227e:	ff3791e3          	bne	a5,s3,80002260 <wakeup+0x2a>
    80002282:	709c                	ld	a5,32(s1)
    80002284:	fd479ee3          	bne	a5,s4,80002260 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002288:	0154ac23          	sw	s5,24(s1)
    8000228c:	bfd1                	j	80002260 <wakeup+0x2a>
    }
  }
}
    8000228e:	70e2                	ld	ra,56(sp)
    80002290:	7442                	ld	s0,48(sp)
    80002292:	74a2                	ld	s1,40(sp)
    80002294:	7902                	ld	s2,32(sp)
    80002296:	69e2                	ld	s3,24(sp)
    80002298:	6a42                	ld	s4,16(sp)
    8000229a:	6aa2                	ld	s5,8(sp)
    8000229c:	6121                	addi	sp,sp,64
    8000229e:	8082                	ret

00000000800022a0 <reparent>:
{
    800022a0:	7179                	addi	sp,sp,-48
    800022a2:	f406                	sd	ra,40(sp)
    800022a4:	f022                	sd	s0,32(sp)
    800022a6:	ec26                	sd	s1,24(sp)
    800022a8:	e84a                	sd	s2,16(sp)
    800022aa:	e44e                	sd	s3,8(sp)
    800022ac:	e052                	sd	s4,0(sp)
    800022ae:	1800                	addi	s0,sp,48
    800022b0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022b2:	00010497          	auipc	s1,0x10
    800022b6:	62e48493          	addi	s1,s1,1582 # 800128e0 <proc>
      pp->parent = initproc;
    800022ba:	00008a17          	auipc	s4,0x8
    800022be:	0aea0a13          	addi	s4,s4,174 # 8000a368 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022c2:	00016997          	auipc	s3,0x16
    800022c6:	41e98993          	addi	s3,s3,1054 # 800186e0 <tickslock>
    800022ca:	a029                	j	800022d4 <reparent+0x34>
    800022cc:	17848493          	addi	s1,s1,376
    800022d0:	01348b63          	beq	s1,s3,800022e6 <reparent+0x46>
    if(pp->parent == p){
    800022d4:	64bc                	ld	a5,72(s1)
    800022d6:	ff279be3          	bne	a5,s2,800022cc <reparent+0x2c>
      pp->parent = initproc;
    800022da:	000a3503          	ld	a0,0(s4)
    800022de:	e4a8                	sd	a0,72(s1)
      wakeup(initproc);
    800022e0:	f57ff0ef          	jal	80002236 <wakeup>
    800022e4:	b7e5                	j	800022cc <reparent+0x2c>
}
    800022e6:	70a2                	ld	ra,40(sp)
    800022e8:	7402                	ld	s0,32(sp)
    800022ea:	64e2                	ld	s1,24(sp)
    800022ec:	6942                	ld	s2,16(sp)
    800022ee:	69a2                	ld	s3,8(sp)
    800022f0:	6a02                	ld	s4,0(sp)
    800022f2:	6145                	addi	sp,sp,48
    800022f4:	8082                	ret

00000000800022f6 <exit>:
{
    800022f6:	7179                	addi	sp,sp,-48
    800022f8:	f406                	sd	ra,40(sp)
    800022fa:	f022                	sd	s0,32(sp)
    800022fc:	ec26                	sd	s1,24(sp)
    800022fe:	e84a                	sd	s2,16(sp)
    80002300:	e44e                	sd	s3,8(sp)
    80002302:	e052                	sd	s4,0(sp)
    80002304:	1800                	addi	s0,sp,48
    80002306:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002308:	873ff0ef          	jal	80001b7a <myproc>
    8000230c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000230e:	00008797          	auipc	a5,0x8
    80002312:	05a7b783          	ld	a5,90(a5) # 8000a368 <initproc>
    80002316:	0e050493          	addi	s1,a0,224
    8000231a:	16050913          	addi	s2,a0,352
    8000231e:	00a79f63          	bne	a5,a0,8000233c <exit+0x46>
    panic("init exiting");
    80002322:	00005517          	auipc	a0,0x5
    80002326:	f8e50513          	addi	a0,a0,-114 # 800072b0 <etext+0x2b0>
    8000232a:	c6afe0ef          	jal	80000794 <panic>
      fileclose(f);
    8000232e:	6af010ef          	jal	800041dc <fileclose>
      p->ofile[fd] = 0;
    80002332:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002336:	04a1                	addi	s1,s1,8
    80002338:	01248563          	beq	s1,s2,80002342 <exit+0x4c>
    if(p->ofile[fd]){
    8000233c:	6088                	ld	a0,0(s1)
    8000233e:	f965                	bnez	a0,8000232e <exit+0x38>
    80002340:	bfdd                	j	80002336 <exit+0x40>
  begin_op();
    80002342:	281010ef          	jal	80003dc2 <begin_op>
  iput(p->cwd);
    80002346:	1609b503          	ld	a0,352(s3)
    8000234a:	364010ef          	jal	800036ae <iput>
  end_op();
    8000234e:	2df010ef          	jal	80003e2c <end_op>
  p->cwd = 0;
    80002352:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    80002356:	00010497          	auipc	s1,0x10
    8000235a:	57248493          	addi	s1,s1,1394 # 800128c8 <wait_lock>
    8000235e:	8526                	mv	a0,s1
    80002360:	895fe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    80002364:	854e                	mv	a0,s3
    80002366:	f3bff0ef          	jal	800022a0 <reparent>
  wakeup(p->parent);
    8000236a:	0489b503          	ld	a0,72(s3)
    8000236e:	ec9ff0ef          	jal	80002236 <wakeup>
  acquire(&p->lock);
    80002372:	854e                	mv	a0,s3
    80002374:	881fe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    80002378:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000237c:	4795                	li	a5,5
    8000237e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002382:	8526                	mv	a0,s1
    80002384:	909fe0ef          	jal	80000c8c <release>
  sched();
    80002388:	d85ff0ef          	jal	8000210c <sched>
  panic("zombie exit");
    8000238c:	00005517          	auipc	a0,0x5
    80002390:	f3450513          	addi	a0,a0,-204 # 800072c0 <etext+0x2c0>
    80002394:	c00fe0ef          	jal	80000794 <panic>

0000000080002398 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002398:	7179                	addi	sp,sp,-48
    8000239a:	f406                	sd	ra,40(sp)
    8000239c:	f022                	sd	s0,32(sp)
    8000239e:	ec26                	sd	s1,24(sp)
    800023a0:	e84a                	sd	s2,16(sp)
    800023a2:	e44e                	sd	s3,8(sp)
    800023a4:	1800                	addi	s0,sp,48
    800023a6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023a8:	00010497          	auipc	s1,0x10
    800023ac:	53848493          	addi	s1,s1,1336 # 800128e0 <proc>
    800023b0:	00016997          	auipc	s3,0x16
    800023b4:	33098993          	addi	s3,s3,816 # 800186e0 <tickslock>
    acquire(&p->lock);
    800023b8:	8526                	mv	a0,s1
    800023ba:	83bfe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    800023be:	589c                	lw	a5,48(s1)
    800023c0:	01278b63          	beq	a5,s2,800023d6 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023c4:	8526                	mv	a0,s1
    800023c6:	8c7fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023ca:	17848493          	addi	s1,s1,376
    800023ce:	ff3495e3          	bne	s1,s3,800023b8 <kill+0x20>
  }
  return -1;
    800023d2:	557d                	li	a0,-1
    800023d4:	a819                	j	800023ea <kill+0x52>
      p->killed = 1;
    800023d6:	4785                	li	a5,1
    800023d8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800023da:	4c98                	lw	a4,24(s1)
    800023dc:	4789                	li	a5,2
    800023de:	00f70d63          	beq	a4,a5,800023f8 <kill+0x60>
      release(&p->lock);
    800023e2:	8526                	mv	a0,s1
    800023e4:	8a9fe0ef          	jal	80000c8c <release>
      return 0;
    800023e8:	4501                	li	a0,0
}
    800023ea:	70a2                	ld	ra,40(sp)
    800023ec:	7402                	ld	s0,32(sp)
    800023ee:	64e2                	ld	s1,24(sp)
    800023f0:	6942                	ld	s2,16(sp)
    800023f2:	69a2                	ld	s3,8(sp)
    800023f4:	6145                	addi	sp,sp,48
    800023f6:	8082                	ret
        p->state = RUNNABLE;
    800023f8:	478d                	li	a5,3
    800023fa:	cc9c                	sw	a5,24(s1)
    800023fc:	b7dd                	j	800023e2 <kill+0x4a>

00000000800023fe <setkilled>:

void
setkilled(struct proc *p)
{
    800023fe:	1101                	addi	sp,sp,-32
    80002400:	ec06                	sd	ra,24(sp)
    80002402:	e822                	sd	s0,16(sp)
    80002404:	e426                	sd	s1,8(sp)
    80002406:	1000                	addi	s0,sp,32
    80002408:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000240a:	feafe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    8000240e:	4785                	li	a5,1
    80002410:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002412:	8526                	mv	a0,s1
    80002414:	879fe0ef          	jal	80000c8c <release>
}
    80002418:	60e2                	ld	ra,24(sp)
    8000241a:	6442                	ld	s0,16(sp)
    8000241c:	64a2                	ld	s1,8(sp)
    8000241e:	6105                	addi	sp,sp,32
    80002420:	8082                	ret

0000000080002422 <killed>:

int
killed(struct proc *p)
{
    80002422:	1101                	addi	sp,sp,-32
    80002424:	ec06                	sd	ra,24(sp)
    80002426:	e822                	sd	s0,16(sp)
    80002428:	e426                	sd	s1,8(sp)
    8000242a:	e04a                	sd	s2,0(sp)
    8000242c:	1000                	addi	s0,sp,32
    8000242e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002430:	fc4fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    80002434:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002438:	8526                	mv	a0,s1
    8000243a:	853fe0ef          	jal	80000c8c <release>
  return k;
}
    8000243e:	854a                	mv	a0,s2
    80002440:	60e2                	ld	ra,24(sp)
    80002442:	6442                	ld	s0,16(sp)
    80002444:	64a2                	ld	s1,8(sp)
    80002446:	6902                	ld	s2,0(sp)
    80002448:	6105                	addi	sp,sp,32
    8000244a:	8082                	ret

000000008000244c <wait>:
{
    8000244c:	715d                	addi	sp,sp,-80
    8000244e:	e486                	sd	ra,72(sp)
    80002450:	e0a2                	sd	s0,64(sp)
    80002452:	fc26                	sd	s1,56(sp)
    80002454:	f84a                	sd	s2,48(sp)
    80002456:	f44e                	sd	s3,40(sp)
    80002458:	f052                	sd	s4,32(sp)
    8000245a:	ec56                	sd	s5,24(sp)
    8000245c:	e85a                	sd	s6,16(sp)
    8000245e:	e45e                	sd	s7,8(sp)
    80002460:	e062                	sd	s8,0(sp)
    80002462:	0880                	addi	s0,sp,80
    80002464:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002466:	f14ff0ef          	jal	80001b7a <myproc>
    8000246a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000246c:	00010517          	auipc	a0,0x10
    80002470:	45c50513          	addi	a0,a0,1116 # 800128c8 <wait_lock>
    80002474:	f80fe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    80002478:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000247a:	4a15                	li	s4,5
        havekids = 1;
    8000247c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000247e:	00016997          	auipc	s3,0x16
    80002482:	26298993          	addi	s3,s3,610 # 800186e0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002486:	00010c17          	auipc	s8,0x10
    8000248a:	442c0c13          	addi	s8,s8,1090 # 800128c8 <wait_lock>
    8000248e:	a871                	j	8000252a <wait+0xde>
          pid = pp->pid;
    80002490:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002494:	000b0c63          	beqz	s6,800024ac <wait+0x60>
    80002498:	4691                	li	a3,4
    8000249a:	02c48613          	addi	a2,s1,44
    8000249e:	85da                	mv	a1,s6
    800024a0:	06093503          	ld	a0,96(s2)
    800024a4:	8aeff0ef          	jal	80001552 <copyout>
    800024a8:	02054b63          	bltz	a0,800024de <wait+0x92>
          freeproc(pp);
    800024ac:	8526                	mv	a0,s1
    800024ae:	83fff0ef          	jal	80001cec <freeproc>
          release(&pp->lock);
    800024b2:	8526                	mv	a0,s1
    800024b4:	fd8fe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    800024b8:	00010517          	auipc	a0,0x10
    800024bc:	41050513          	addi	a0,a0,1040 # 800128c8 <wait_lock>
    800024c0:	fccfe0ef          	jal	80000c8c <release>
}
    800024c4:	854e                	mv	a0,s3
    800024c6:	60a6                	ld	ra,72(sp)
    800024c8:	6406                	ld	s0,64(sp)
    800024ca:	74e2                	ld	s1,56(sp)
    800024cc:	7942                	ld	s2,48(sp)
    800024ce:	79a2                	ld	s3,40(sp)
    800024d0:	7a02                	ld	s4,32(sp)
    800024d2:	6ae2                	ld	s5,24(sp)
    800024d4:	6b42                	ld	s6,16(sp)
    800024d6:	6ba2                	ld	s7,8(sp)
    800024d8:	6c02                	ld	s8,0(sp)
    800024da:	6161                	addi	sp,sp,80
    800024dc:	8082                	ret
            release(&pp->lock);
    800024de:	8526                	mv	a0,s1
    800024e0:	facfe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    800024e4:	00010517          	auipc	a0,0x10
    800024e8:	3e450513          	addi	a0,a0,996 # 800128c8 <wait_lock>
    800024ec:	fa0fe0ef          	jal	80000c8c <release>
            return -1;
    800024f0:	59fd                	li	s3,-1
    800024f2:	bfc9                	j	800024c4 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024f4:	17848493          	addi	s1,s1,376
    800024f8:	03348063          	beq	s1,s3,80002518 <wait+0xcc>
      if(pp->parent == p){
    800024fc:	64bc                	ld	a5,72(s1)
    800024fe:	ff279be3          	bne	a5,s2,800024f4 <wait+0xa8>
        acquire(&pp->lock);
    80002502:	8526                	mv	a0,s1
    80002504:	ef0fe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    80002508:	4c9c                	lw	a5,24(s1)
    8000250a:	f94783e3          	beq	a5,s4,80002490 <wait+0x44>
        release(&pp->lock);
    8000250e:	8526                	mv	a0,s1
    80002510:	f7cfe0ef          	jal	80000c8c <release>
        havekids = 1;
    80002514:	8756                	mv	a4,s5
    80002516:	bff9                	j	800024f4 <wait+0xa8>
    if(!havekids || killed(p)){
    80002518:	cf19                	beqz	a4,80002536 <wait+0xea>
    8000251a:	854a                	mv	a0,s2
    8000251c:	f07ff0ef          	jal	80002422 <killed>
    80002520:	e919                	bnez	a0,80002536 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002522:	85e2                	mv	a1,s8
    80002524:	854a                	mv	a0,s2
    80002526:	cc5ff0ef          	jal	800021ea <sleep>
    havekids = 0;
    8000252a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000252c:	00010497          	auipc	s1,0x10
    80002530:	3b448493          	addi	s1,s1,948 # 800128e0 <proc>
    80002534:	b7e1                	j	800024fc <wait+0xb0>
      release(&wait_lock);
    80002536:	00010517          	auipc	a0,0x10
    8000253a:	39250513          	addi	a0,a0,914 # 800128c8 <wait_lock>
    8000253e:	f4efe0ef          	jal	80000c8c <release>
      return -1;
    80002542:	59fd                	li	s3,-1
    80002544:	b741                	j	800024c4 <wait+0x78>

0000000080002546 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002546:	7179                	addi	sp,sp,-48
    80002548:	f406                	sd	ra,40(sp)
    8000254a:	f022                	sd	s0,32(sp)
    8000254c:	ec26                	sd	s1,24(sp)
    8000254e:	e84a                	sd	s2,16(sp)
    80002550:	e44e                	sd	s3,8(sp)
    80002552:	e052                	sd	s4,0(sp)
    80002554:	1800                	addi	s0,sp,48
    80002556:	84aa                	mv	s1,a0
    80002558:	892e                	mv	s2,a1
    8000255a:	89b2                	mv	s3,a2
    8000255c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000255e:	e1cff0ef          	jal	80001b7a <myproc>
  if(user_dst){
    80002562:	cc99                	beqz	s1,80002580 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002564:	86d2                	mv	a3,s4
    80002566:	864e                	mv	a2,s3
    80002568:	85ca                	mv	a1,s2
    8000256a:	7128                	ld	a0,96(a0)
    8000256c:	fe7fe0ef          	jal	80001552 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002570:	70a2                	ld	ra,40(sp)
    80002572:	7402                	ld	s0,32(sp)
    80002574:	64e2                	ld	s1,24(sp)
    80002576:	6942                	ld	s2,16(sp)
    80002578:	69a2                	ld	s3,8(sp)
    8000257a:	6a02                	ld	s4,0(sp)
    8000257c:	6145                	addi	sp,sp,48
    8000257e:	8082                	ret
    memmove((char *)dst, src, len);
    80002580:	000a061b          	sext.w	a2,s4
    80002584:	85ce                	mv	a1,s3
    80002586:	854a                	mv	a0,s2
    80002588:	f9cfe0ef          	jal	80000d24 <memmove>
    return 0;
    8000258c:	8526                	mv	a0,s1
    8000258e:	b7cd                	j	80002570 <either_copyout+0x2a>

0000000080002590 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002590:	7179                	addi	sp,sp,-48
    80002592:	f406                	sd	ra,40(sp)
    80002594:	f022                	sd	s0,32(sp)
    80002596:	ec26                	sd	s1,24(sp)
    80002598:	e84a                	sd	s2,16(sp)
    8000259a:	e44e                	sd	s3,8(sp)
    8000259c:	e052                	sd	s4,0(sp)
    8000259e:	1800                	addi	s0,sp,48
    800025a0:	892a                	mv	s2,a0
    800025a2:	84ae                	mv	s1,a1
    800025a4:	89b2                	mv	s3,a2
    800025a6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025a8:	dd2ff0ef          	jal	80001b7a <myproc>
  if(user_src){
    800025ac:	cc99                	beqz	s1,800025ca <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800025ae:	86d2                	mv	a3,s4
    800025b0:	864e                	mv	a2,s3
    800025b2:	85ca                	mv	a1,s2
    800025b4:	7128                	ld	a0,96(a0)
    800025b6:	872ff0ef          	jal	80001628 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800025ba:	70a2                	ld	ra,40(sp)
    800025bc:	7402                	ld	s0,32(sp)
    800025be:	64e2                	ld	s1,24(sp)
    800025c0:	6942                	ld	s2,16(sp)
    800025c2:	69a2                	ld	s3,8(sp)
    800025c4:	6a02                	ld	s4,0(sp)
    800025c6:	6145                	addi	sp,sp,48
    800025c8:	8082                	ret
    memmove(dst, (char*)src, len);
    800025ca:	000a061b          	sext.w	a2,s4
    800025ce:	85ce                	mv	a1,s3
    800025d0:	854a                	mv	a0,s2
    800025d2:	f52fe0ef          	jal	80000d24 <memmove>
    return 0;
    800025d6:	8526                	mv	a0,s1
    800025d8:	b7cd                	j	800025ba <either_copyin+0x2a>

00000000800025da <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025da:	715d                	addi	sp,sp,-80
    800025dc:	e486                	sd	ra,72(sp)
    800025de:	e0a2                	sd	s0,64(sp)
    800025e0:	fc26                	sd	s1,56(sp)
    800025e2:	f84a                	sd	s2,48(sp)
    800025e4:	f44e                	sd	s3,40(sp)
    800025e6:	f052                	sd	s4,32(sp)
    800025e8:	ec56                	sd	s5,24(sp)
    800025ea:	e85a                	sd	s6,16(sp)
    800025ec:	e45e                	sd	s7,8(sp)
    800025ee:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025f0:	00005517          	auipc	a0,0x5
    800025f4:	a8850513          	addi	a0,a0,-1400 # 80007078 <etext+0x78>
    800025f8:	ecbfd0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025fc:	00010497          	auipc	s1,0x10
    80002600:	44c48493          	addi	s1,s1,1100 # 80012a48 <proc+0x168>
    80002604:	00016917          	auipc	s2,0x16
    80002608:	24490913          	addi	s2,s2,580 # 80018848 <bcache+0x150>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000260c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000260e:	00005997          	auipc	s3,0x5
    80002612:	cc298993          	addi	s3,s3,-830 # 800072d0 <etext+0x2d0>
    printf("%d %s %s", p->pid, state, p->name);
    80002616:	00005a97          	auipc	s5,0x5
    8000261a:	cc2a8a93          	addi	s5,s5,-830 # 800072d8 <etext+0x2d8>
    printf("\n");
    8000261e:	00005a17          	auipc	s4,0x5
    80002622:	a5aa0a13          	addi	s4,s4,-1446 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002626:	00005b97          	auipc	s7,0x5
    8000262a:	192b8b93          	addi	s7,s7,402 # 800077b8 <states.0>
    8000262e:	a829                	j	80002648 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002630:	ec86a583          	lw	a1,-312(a3)
    80002634:	8556                	mv	a0,s5
    80002636:	e8dfd0ef          	jal	800004c2 <printf>
    printf("\n");
    8000263a:	8552                	mv	a0,s4
    8000263c:	e87fd0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002640:	17848493          	addi	s1,s1,376
    80002644:	03248263          	beq	s1,s2,80002668 <procdump+0x8e>
    if(p->state == UNUSED)
    80002648:	86a6                	mv	a3,s1
    8000264a:	eb04a783          	lw	a5,-336(s1)
    8000264e:	dbed                	beqz	a5,80002640 <procdump+0x66>
      state = "???";
    80002650:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002652:	fcfb6fe3          	bltu	s6,a5,80002630 <procdump+0x56>
    80002656:	02079713          	slli	a4,a5,0x20
    8000265a:	01d75793          	srli	a5,a4,0x1d
    8000265e:	97de                	add	a5,a5,s7
    80002660:	6390                	ld	a2,0(a5)
    80002662:	f679                	bnez	a2,80002630 <procdump+0x56>
      state = "???";
    80002664:	864e                	mv	a2,s3
    80002666:	b7e9                	j	80002630 <procdump+0x56>
  }
}
    80002668:	60a6                	ld	ra,72(sp)
    8000266a:	6406                	ld	s0,64(sp)
    8000266c:	74e2                	ld	s1,56(sp)
    8000266e:	7942                	ld	s2,48(sp)
    80002670:	79a2                	ld	s3,40(sp)
    80002672:	7a02                	ld	s4,32(sp)
    80002674:	6ae2                	ld	s5,24(sp)
    80002676:	6b42                	ld	s6,16(sp)
    80002678:	6ba2                	ld	s7,8(sp)
    8000267a:	6161                	addi	sp,sp,80
    8000267c:	8082                	ret

000000008000267e <swtch>:
    8000267e:	00153023          	sd	ra,0(a0)
    80002682:	00253423          	sd	sp,8(a0)
    80002686:	e900                	sd	s0,16(a0)
    80002688:	ed04                	sd	s1,24(a0)
    8000268a:	03253023          	sd	s2,32(a0)
    8000268e:	03353423          	sd	s3,40(a0)
    80002692:	03453823          	sd	s4,48(a0)
    80002696:	03553c23          	sd	s5,56(a0)
    8000269a:	05653023          	sd	s6,64(a0)
    8000269e:	05753423          	sd	s7,72(a0)
    800026a2:	05853823          	sd	s8,80(a0)
    800026a6:	05953c23          	sd	s9,88(a0)
    800026aa:	07a53023          	sd	s10,96(a0)
    800026ae:	07b53423          	sd	s11,104(a0)
    800026b2:	0005b083          	ld	ra,0(a1)
    800026b6:	0085b103          	ld	sp,8(a1)
    800026ba:	6980                	ld	s0,16(a1)
    800026bc:	6d84                	ld	s1,24(a1)
    800026be:	0205b903          	ld	s2,32(a1)
    800026c2:	0285b983          	ld	s3,40(a1)
    800026c6:	0305ba03          	ld	s4,48(a1)
    800026ca:	0385ba83          	ld	s5,56(a1)
    800026ce:	0405bb03          	ld	s6,64(a1)
    800026d2:	0485bb83          	ld	s7,72(a1)
    800026d6:	0505bc03          	ld	s8,80(a1)
    800026da:	0585bc83          	ld	s9,88(a1)
    800026de:	0605bd03          	ld	s10,96(a1)
    800026e2:	0685bd83          	ld	s11,104(a1)
    800026e6:	8082                	ret

00000000800026e8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026e8:	1141                	addi	sp,sp,-16
    800026ea:	e406                	sd	ra,8(sp)
    800026ec:	e022                	sd	s0,0(sp)
    800026ee:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026f0:	00005597          	auipc	a1,0x5
    800026f4:	c2858593          	addi	a1,a1,-984 # 80007318 <etext+0x318>
    800026f8:	00016517          	auipc	a0,0x16
    800026fc:	fe850513          	addi	a0,a0,-24 # 800186e0 <tickslock>
    80002700:	c74fe0ef          	jal	80000b74 <initlock>
}
    80002704:	60a2                	ld	ra,8(sp)
    80002706:	6402                	ld	s0,0(sp)
    80002708:	0141                	addi	sp,sp,16
    8000270a:	8082                	ret

000000008000270c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000270c:	1141                	addi	sp,sp,-16
    8000270e:	e422                	sd	s0,8(sp)
    80002710:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002712:	00003797          	auipc	a5,0x3
    80002716:	e3e78793          	addi	a5,a5,-450 # 80005550 <kernelvec>
    8000271a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000271e:	6422                	ld	s0,8(sp)
    80002720:	0141                	addi	sp,sp,16
    80002722:	8082                	ret

0000000080002724 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002724:	1141                	addi	sp,sp,-16
    80002726:	e406                	sd	ra,8(sp)
    80002728:	e022                	sd	s0,0(sp)
    8000272a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000272c:	c4eff0ef          	jal	80001b7a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002730:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002734:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002736:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000273a:	00004697          	auipc	a3,0x4
    8000273e:	8c668693          	addi	a3,a3,-1850 # 80006000 <_trampoline>
    80002742:	00004717          	auipc	a4,0x4
    80002746:	8be70713          	addi	a4,a4,-1858 # 80006000 <_trampoline>
    8000274a:	8f15                	sub	a4,a4,a3
    8000274c:	040007b7          	lui	a5,0x4000
    80002750:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002752:	07b2                	slli	a5,a5,0xc
    80002754:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002756:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000275a:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000275c:	18002673          	csrr	a2,satp
    80002760:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002762:	7530                	ld	a2,104(a0)
    80002764:	6938                	ld	a4,80(a0)
    80002766:	6585                	lui	a1,0x1
    80002768:	972e                	add	a4,a4,a1
    8000276a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000276c:	7538                	ld	a4,104(a0)
    8000276e:	00000617          	auipc	a2,0x0
    80002772:	11060613          	addi	a2,a2,272 # 8000287e <usertrap>
    80002776:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002778:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000277a:	8612                	mv	a2,tp
    8000277c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000277e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002782:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002786:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000278a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000278e:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002790:	6f18                	ld	a4,24(a4)
    80002792:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002796:	7128                	ld	a0,96(a0)
    80002798:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000279a:	00004717          	auipc	a4,0x4
    8000279e:	90270713          	addi	a4,a4,-1790 # 8000609c <userret>
    800027a2:	8f15                	sub	a4,a4,a3
    800027a4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800027a6:	577d                	li	a4,-1
    800027a8:	177e                	slli	a4,a4,0x3f
    800027aa:	8d59                	or	a0,a0,a4
    800027ac:	9782                	jalr	a5
}
    800027ae:	60a2                	ld	ra,8(sp)
    800027b0:	6402                	ld	s0,0(sp)
    800027b2:	0141                	addi	sp,sp,16
    800027b4:	8082                	ret

00000000800027b6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027b6:	1101                	addi	sp,sp,-32
    800027b8:	ec06                	sd	ra,24(sp)
    800027ba:	e822                	sd	s0,16(sp)
    800027bc:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800027be:	b90ff0ef          	jal	80001b4e <cpuid>
    800027c2:	cd11                	beqz	a0,800027de <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800027c4:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800027c8:	000f4737          	lui	a4,0xf4
    800027cc:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800027d0:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800027d2:	14d79073          	csrw	stimecmp,a5
}
    800027d6:	60e2                	ld	ra,24(sp)
    800027d8:	6442                	ld	s0,16(sp)
    800027da:	6105                	addi	sp,sp,32
    800027dc:	8082                	ret
    800027de:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800027e0:	00016497          	auipc	s1,0x16
    800027e4:	f0048493          	addi	s1,s1,-256 # 800186e0 <tickslock>
    800027e8:	8526                	mv	a0,s1
    800027ea:	c0afe0ef          	jal	80000bf4 <acquire>
    ticks++;
    800027ee:	00008517          	auipc	a0,0x8
    800027f2:	b8250513          	addi	a0,a0,-1150 # 8000a370 <ticks>
    800027f6:	411c                	lw	a5,0(a0)
    800027f8:	2785                	addiw	a5,a5,1
    800027fa:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800027fc:	a3bff0ef          	jal	80002236 <wakeup>
    release(&tickslock);
    80002800:	8526                	mv	a0,s1
    80002802:	c8afe0ef          	jal	80000c8c <release>
    80002806:	64a2                	ld	s1,8(sp)
    80002808:	bf75                	j	800027c4 <clockintr+0xe>

000000008000280a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000280a:	1101                	addi	sp,sp,-32
    8000280c:	ec06                	sd	ra,24(sp)
    8000280e:	e822                	sd	s0,16(sp)
    80002810:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002812:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002816:	57fd                	li	a5,-1
    80002818:	17fe                	slli	a5,a5,0x3f
    8000281a:	07a5                	addi	a5,a5,9
    8000281c:	00f70c63          	beq	a4,a5,80002834 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002820:	57fd                	li	a5,-1
    80002822:	17fe                	slli	a5,a5,0x3f
    80002824:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002826:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002828:	04f70763          	beq	a4,a5,80002876 <devintr+0x6c>
  }
}
    8000282c:	60e2                	ld	ra,24(sp)
    8000282e:	6442                	ld	s0,16(sp)
    80002830:	6105                	addi	sp,sp,32
    80002832:	8082                	ret
    80002834:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002836:	5c7020ef          	jal	800055fc <plic_claim>
    8000283a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000283c:	47a9                	li	a5,10
    8000283e:	00f50963          	beq	a0,a5,80002850 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002842:	4785                	li	a5,1
    80002844:	00f50963          	beq	a0,a5,80002856 <devintr+0x4c>
    return 1;
    80002848:	4505                	li	a0,1
    } else if(irq){
    8000284a:	e889                	bnez	s1,8000285c <devintr+0x52>
    8000284c:	64a2                	ld	s1,8(sp)
    8000284e:	bff9                	j	8000282c <devintr+0x22>
      uartintr();
    80002850:	9b6fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    80002854:	a819                	j	8000286a <devintr+0x60>
      virtio_disk_intr();
    80002856:	26c030ef          	jal	80005ac2 <virtio_disk_intr>
    if(irq)
    8000285a:	a801                	j	8000286a <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000285c:	85a6                	mv	a1,s1
    8000285e:	00005517          	auipc	a0,0x5
    80002862:	ac250513          	addi	a0,a0,-1342 # 80007320 <etext+0x320>
    80002866:	c5dfd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    8000286a:	8526                	mv	a0,s1
    8000286c:	5b1020ef          	jal	8000561c <plic_complete>
    return 1;
    80002870:	4505                	li	a0,1
    80002872:	64a2                	ld	s1,8(sp)
    80002874:	bf65                	j	8000282c <devintr+0x22>
    clockintr();
    80002876:	f41ff0ef          	jal	800027b6 <clockintr>
    return 2;
    8000287a:	4509                	li	a0,2
    8000287c:	bf45                	j	8000282c <devintr+0x22>

000000008000287e <usertrap>:
{
    8000287e:	1101                	addi	sp,sp,-32
    80002880:	ec06                	sd	ra,24(sp)
    80002882:	e822                	sd	s0,16(sp)
    80002884:	e426                	sd	s1,8(sp)
    80002886:	e04a                	sd	s2,0(sp)
    80002888:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000288a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000288e:	1007f793          	andi	a5,a5,256
    80002892:	ef85                	bnez	a5,800028ca <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002894:	00003797          	auipc	a5,0x3
    80002898:	cbc78793          	addi	a5,a5,-836 # 80005550 <kernelvec>
    8000289c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028a0:	adaff0ef          	jal	80001b7a <myproc>
    800028a4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028a6:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028a8:	14102773          	csrr	a4,sepc
    800028ac:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028ae:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028b2:	47a1                	li	a5,8
    800028b4:	02f70163          	beq	a4,a5,800028d6 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800028b8:	f53ff0ef          	jal	8000280a <devintr>
    800028bc:	892a                	mv	s2,a0
    800028be:	c135                	beqz	a0,80002922 <usertrap+0xa4>
  if(killed(p))
    800028c0:	8526                	mv	a0,s1
    800028c2:	b61ff0ef          	jal	80002422 <killed>
    800028c6:	cd1d                	beqz	a0,80002904 <usertrap+0x86>
    800028c8:	a81d                	j	800028fe <usertrap+0x80>
    panic("usertrap: not from user mode");
    800028ca:	00005517          	auipc	a0,0x5
    800028ce:	a7650513          	addi	a0,a0,-1418 # 80007340 <etext+0x340>
    800028d2:	ec3fd0ef          	jal	80000794 <panic>
    if(killed(p))
    800028d6:	b4dff0ef          	jal	80002422 <killed>
    800028da:	e121                	bnez	a0,8000291a <usertrap+0x9c>
    p->trapframe->epc += 4;
    800028dc:	74b8                	ld	a4,104(s1)
    800028de:	6f1c                	ld	a5,24(a4)
    800028e0:	0791                	addi	a5,a5,4
    800028e2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028e8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028ec:	10079073          	csrw	sstatus,a5
    syscall();
    800028f0:	248000ef          	jal	80002b38 <syscall>
  if(killed(p))
    800028f4:	8526                	mv	a0,s1
    800028f6:	b2dff0ef          	jal	80002422 <killed>
    800028fa:	c901                	beqz	a0,8000290a <usertrap+0x8c>
    800028fc:	4901                	li	s2,0
    exit(-1);
    800028fe:	557d                	li	a0,-1
    80002900:	9f7ff0ef          	jal	800022f6 <exit>
  if(which_dev == 2)
    80002904:	4789                	li	a5,2
    80002906:	04f90563          	beq	s2,a5,80002950 <usertrap+0xd2>
  usertrapret();
    8000290a:	e1bff0ef          	jal	80002724 <usertrapret>
}
    8000290e:	60e2                	ld	ra,24(sp)
    80002910:	6442                	ld	s0,16(sp)
    80002912:	64a2                	ld	s1,8(sp)
    80002914:	6902                	ld	s2,0(sp)
    80002916:	6105                	addi	sp,sp,32
    80002918:	8082                	ret
      exit(-1);
    8000291a:	557d                	li	a0,-1
    8000291c:	9dbff0ef          	jal	800022f6 <exit>
    80002920:	bf75                	j	800028dc <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002922:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002926:	5890                	lw	a2,48(s1)
    80002928:	00005517          	auipc	a0,0x5
    8000292c:	a3850513          	addi	a0,a0,-1480 # 80007360 <etext+0x360>
    80002930:	b93fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002934:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002938:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000293c:	00005517          	auipc	a0,0x5
    80002940:	a5450513          	addi	a0,a0,-1452 # 80007390 <etext+0x390>
    80002944:	b7ffd0ef          	jal	800004c2 <printf>
    setkilled(p);
    80002948:	8526                	mv	a0,s1
    8000294a:	ab5ff0ef          	jal	800023fe <setkilled>
    8000294e:	b75d                	j	800028f4 <usertrap+0x76>
    yield();
    80002950:	86fff0ef          	jal	800021be <yield>
    80002954:	bf5d                	j	8000290a <usertrap+0x8c>

0000000080002956 <kerneltrap>:
{
    80002956:	7179                	addi	sp,sp,-48
    80002958:	f406                	sd	ra,40(sp)
    8000295a:	f022                	sd	s0,32(sp)
    8000295c:	ec26                	sd	s1,24(sp)
    8000295e:	e84a                	sd	s2,16(sp)
    80002960:	e44e                	sd	s3,8(sp)
    80002962:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002964:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002968:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000296c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002970:	1004f793          	andi	a5,s1,256
    80002974:	c795                	beqz	a5,800029a0 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002976:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000297a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000297c:	eb85                	bnez	a5,800029ac <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    8000297e:	e8dff0ef          	jal	8000280a <devintr>
    80002982:	c91d                	beqz	a0,800029b8 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002984:	4789                	li	a5,2
    80002986:	04f50a63          	beq	a0,a5,800029da <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000298a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000298e:	10049073          	csrw	sstatus,s1
}
    80002992:	70a2                	ld	ra,40(sp)
    80002994:	7402                	ld	s0,32(sp)
    80002996:	64e2                	ld	s1,24(sp)
    80002998:	6942                	ld	s2,16(sp)
    8000299a:	69a2                	ld	s3,8(sp)
    8000299c:	6145                	addi	sp,sp,48
    8000299e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800029a0:	00005517          	auipc	a0,0x5
    800029a4:	a1850513          	addi	a0,a0,-1512 # 800073b8 <etext+0x3b8>
    800029a8:	dedfd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    800029ac:	00005517          	auipc	a0,0x5
    800029b0:	a3450513          	addi	a0,a0,-1484 # 800073e0 <etext+0x3e0>
    800029b4:	de1fd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029b8:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029bc:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800029c0:	85ce                	mv	a1,s3
    800029c2:	00005517          	auipc	a0,0x5
    800029c6:	a3e50513          	addi	a0,a0,-1474 # 80007400 <etext+0x400>
    800029ca:	af9fd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    800029ce:	00005517          	auipc	a0,0x5
    800029d2:	a5a50513          	addi	a0,a0,-1446 # 80007428 <etext+0x428>
    800029d6:	dbffd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    800029da:	9a0ff0ef          	jal	80001b7a <myproc>
    800029de:	d555                	beqz	a0,8000298a <kerneltrap+0x34>
    yield();
    800029e0:	fdeff0ef          	jal	800021be <yield>
    800029e4:	b75d                	j	8000298a <kerneltrap+0x34>

00000000800029e6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800029e6:	1101                	addi	sp,sp,-32
    800029e8:	ec06                	sd	ra,24(sp)
    800029ea:	e822                	sd	s0,16(sp)
    800029ec:	e426                	sd	s1,8(sp)
    800029ee:	1000                	addi	s0,sp,32
    800029f0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800029f2:	988ff0ef          	jal	80001b7a <myproc>
  switch (n) {
    800029f6:	4795                	li	a5,5
    800029f8:	0497e163          	bltu	a5,s1,80002a3a <argraw+0x54>
    800029fc:	048a                	slli	s1,s1,0x2
    800029fe:	00005717          	auipc	a4,0x5
    80002a02:	dea70713          	addi	a4,a4,-534 # 800077e8 <states.0+0x30>
    80002a06:	94ba                	add	s1,s1,a4
    80002a08:	409c                	lw	a5,0(s1)
    80002a0a:	97ba                	add	a5,a5,a4
    80002a0c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a0e:	753c                	ld	a5,104(a0)
    80002a10:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a12:	60e2                	ld	ra,24(sp)
    80002a14:	6442                	ld	s0,16(sp)
    80002a16:	64a2                	ld	s1,8(sp)
    80002a18:	6105                	addi	sp,sp,32
    80002a1a:	8082                	ret
    return p->trapframe->a1;
    80002a1c:	753c                	ld	a5,104(a0)
    80002a1e:	7fa8                	ld	a0,120(a5)
    80002a20:	bfcd                	j	80002a12 <argraw+0x2c>
    return p->trapframe->a2;
    80002a22:	753c                	ld	a5,104(a0)
    80002a24:	63c8                	ld	a0,128(a5)
    80002a26:	b7f5                	j	80002a12 <argraw+0x2c>
    return p->trapframe->a3;
    80002a28:	753c                	ld	a5,104(a0)
    80002a2a:	67c8                	ld	a0,136(a5)
    80002a2c:	b7dd                	j	80002a12 <argraw+0x2c>
    return p->trapframe->a4;
    80002a2e:	753c                	ld	a5,104(a0)
    80002a30:	6bc8                	ld	a0,144(a5)
    80002a32:	b7c5                	j	80002a12 <argraw+0x2c>
    return p->trapframe->a5;
    80002a34:	753c                	ld	a5,104(a0)
    80002a36:	6fc8                	ld	a0,152(a5)
    80002a38:	bfe9                	j	80002a12 <argraw+0x2c>
  panic("argraw");
    80002a3a:	00005517          	auipc	a0,0x5
    80002a3e:	9fe50513          	addi	a0,a0,-1538 # 80007438 <etext+0x438>
    80002a42:	d53fd0ef          	jal	80000794 <panic>

0000000080002a46 <fetchaddr>:
{
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	e426                	sd	s1,8(sp)
    80002a4e:	e04a                	sd	s2,0(sp)
    80002a50:	1000                	addi	s0,sp,32
    80002a52:	84aa                	mv	s1,a0
    80002a54:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a56:	924ff0ef          	jal	80001b7a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002a5a:	6d3c                	ld	a5,88(a0)
    80002a5c:	02f4f663          	bgeu	s1,a5,80002a88 <fetchaddr+0x42>
    80002a60:	00848713          	addi	a4,s1,8
    80002a64:	02e7e463          	bltu	a5,a4,80002a8c <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a68:	46a1                	li	a3,8
    80002a6a:	8626                	mv	a2,s1
    80002a6c:	85ca                	mv	a1,s2
    80002a6e:	7128                	ld	a0,96(a0)
    80002a70:	bb9fe0ef          	jal	80001628 <copyin>
    80002a74:	00a03533          	snez	a0,a0
    80002a78:	40a00533          	neg	a0,a0
}
    80002a7c:	60e2                	ld	ra,24(sp)
    80002a7e:	6442                	ld	s0,16(sp)
    80002a80:	64a2                	ld	s1,8(sp)
    80002a82:	6902                	ld	s2,0(sp)
    80002a84:	6105                	addi	sp,sp,32
    80002a86:	8082                	ret
    return -1;
    80002a88:	557d                	li	a0,-1
    80002a8a:	bfcd                	j	80002a7c <fetchaddr+0x36>
    80002a8c:	557d                	li	a0,-1
    80002a8e:	b7fd                	j	80002a7c <fetchaddr+0x36>

0000000080002a90 <fetchstr>:
{
    80002a90:	7179                	addi	sp,sp,-48
    80002a92:	f406                	sd	ra,40(sp)
    80002a94:	f022                	sd	s0,32(sp)
    80002a96:	ec26                	sd	s1,24(sp)
    80002a98:	e84a                	sd	s2,16(sp)
    80002a9a:	e44e                	sd	s3,8(sp)
    80002a9c:	1800                	addi	s0,sp,48
    80002a9e:	892a                	mv	s2,a0
    80002aa0:	84ae                	mv	s1,a1
    80002aa2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002aa4:	8d6ff0ef          	jal	80001b7a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002aa8:	86ce                	mv	a3,s3
    80002aaa:	864a                	mv	a2,s2
    80002aac:	85a6                	mv	a1,s1
    80002aae:	7128                	ld	a0,96(a0)
    80002ab0:	bfffe0ef          	jal	800016ae <copyinstr>
    80002ab4:	00054c63          	bltz	a0,80002acc <fetchstr+0x3c>
  return strlen(buf);
    80002ab8:	8526                	mv	a0,s1
    80002aba:	b7efe0ef          	jal	80000e38 <strlen>
}
    80002abe:	70a2                	ld	ra,40(sp)
    80002ac0:	7402                	ld	s0,32(sp)
    80002ac2:	64e2                	ld	s1,24(sp)
    80002ac4:	6942                	ld	s2,16(sp)
    80002ac6:	69a2                	ld	s3,8(sp)
    80002ac8:	6145                	addi	sp,sp,48
    80002aca:	8082                	ret
    return -1;
    80002acc:	557d                	li	a0,-1
    80002ace:	bfc5                	j	80002abe <fetchstr+0x2e>

0000000080002ad0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002ad0:	1101                	addi	sp,sp,-32
    80002ad2:	ec06                	sd	ra,24(sp)
    80002ad4:	e822                	sd	s0,16(sp)
    80002ad6:	e426                	sd	s1,8(sp)
    80002ad8:	1000                	addi	s0,sp,32
    80002ada:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002adc:	f0bff0ef          	jal	800029e6 <argraw>
    80002ae0:	c088                	sw	a0,0(s1)
}
    80002ae2:	60e2                	ld	ra,24(sp)
    80002ae4:	6442                	ld	s0,16(sp)
    80002ae6:	64a2                	ld	s1,8(sp)
    80002ae8:	6105                	addi	sp,sp,32
    80002aea:	8082                	ret

0000000080002aec <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002aec:	1101                	addi	sp,sp,-32
    80002aee:	ec06                	sd	ra,24(sp)
    80002af0:	e822                	sd	s0,16(sp)
    80002af2:	e426                	sd	s1,8(sp)
    80002af4:	1000                	addi	s0,sp,32
    80002af6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002af8:	eefff0ef          	jal	800029e6 <argraw>
    80002afc:	e088                	sd	a0,0(s1)
}
    80002afe:	60e2                	ld	ra,24(sp)
    80002b00:	6442                	ld	s0,16(sp)
    80002b02:	64a2                	ld	s1,8(sp)
    80002b04:	6105                	addi	sp,sp,32
    80002b06:	8082                	ret

0000000080002b08 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b08:	7179                	addi	sp,sp,-48
    80002b0a:	f406                	sd	ra,40(sp)
    80002b0c:	f022                	sd	s0,32(sp)
    80002b0e:	ec26                	sd	s1,24(sp)
    80002b10:	e84a                	sd	s2,16(sp)
    80002b12:	1800                	addi	s0,sp,48
    80002b14:	84ae                	mv	s1,a1
    80002b16:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002b18:	fd840593          	addi	a1,s0,-40
    80002b1c:	fd1ff0ef          	jal	80002aec <argaddr>
  return fetchstr(addr, buf, max);
    80002b20:	864a                	mv	a2,s2
    80002b22:	85a6                	mv	a1,s1
    80002b24:	fd843503          	ld	a0,-40(s0)
    80002b28:	f69ff0ef          	jal	80002a90 <fetchstr>
}
    80002b2c:	70a2                	ld	ra,40(sp)
    80002b2e:	7402                	ld	s0,32(sp)
    80002b30:	64e2                	ld	s1,24(sp)
    80002b32:	6942                	ld	s2,16(sp)
    80002b34:	6145                	addi	sp,sp,48
    80002b36:	8082                	ret

0000000080002b38 <syscall>:
[SYS_forkprio] sys_forkprio,
};

void
syscall(void)
{
    80002b38:	1101                	addi	sp,sp,-32
    80002b3a:	ec06                	sd	ra,24(sp)
    80002b3c:	e822                	sd	s0,16(sp)
    80002b3e:	e426                	sd	s1,8(sp)
    80002b40:	e04a                	sd	s2,0(sp)
    80002b42:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b44:	836ff0ef          	jal	80001b7a <myproc>
    80002b48:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b4a:	06853903          	ld	s2,104(a0)
    80002b4e:	0a893783          	ld	a5,168(s2)
    80002b52:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b56:	37fd                	addiw	a5,a5,-1
    80002b58:	4755                	li	a4,21
    80002b5a:	00f76f63          	bltu	a4,a5,80002b78 <syscall+0x40>
    80002b5e:	00369713          	slli	a4,a3,0x3
    80002b62:	00005797          	auipc	a5,0x5
    80002b66:	c9e78793          	addi	a5,a5,-866 # 80007800 <syscalls>
    80002b6a:	97ba                	add	a5,a5,a4
    80002b6c:	639c                	ld	a5,0(a5)
    80002b6e:	c789                	beqz	a5,80002b78 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002b70:	9782                	jalr	a5
    80002b72:	06a93823          	sd	a0,112(s2)
    80002b76:	a829                	j	80002b90 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b78:	16848613          	addi	a2,s1,360
    80002b7c:	588c                	lw	a1,48(s1)
    80002b7e:	00005517          	auipc	a0,0x5
    80002b82:	8c250513          	addi	a0,a0,-1854 # 80007440 <etext+0x440>
    80002b86:	93dfd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b8a:	74bc                	ld	a5,104(s1)
    80002b8c:	577d                	li	a4,-1
    80002b8e:	fbb8                	sd	a4,112(a5)
  }
}
    80002b90:	60e2                	ld	ra,24(sp)
    80002b92:	6442                	ld	s0,16(sp)
    80002b94:	64a2                	ld	s1,8(sp)
    80002b96:	6902                	ld	s2,0(sp)
    80002b98:	6105                	addi	sp,sp,32
    80002b9a:	8082                	ret

0000000080002b9c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b9c:	1101                	addi	sp,sp,-32
    80002b9e:	ec06                	sd	ra,24(sp)
    80002ba0:	e822                	sd	s0,16(sp)
    80002ba2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002ba4:	fec40593          	addi	a1,s0,-20
    80002ba8:	4501                	li	a0,0
    80002baa:	f27ff0ef          	jal	80002ad0 <argint>
  exit(n);
    80002bae:	fec42503          	lw	a0,-20(s0)
    80002bb2:	f44ff0ef          	jal	800022f6 <exit>
  return 0;  // not reached
}
    80002bb6:	4501                	li	a0,0
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	6105                	addi	sp,sp,32
    80002bbe:	8082                	ret

0000000080002bc0 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002bc0:	1141                	addi	sp,sp,-16
    80002bc2:	e406                	sd	ra,8(sp)
    80002bc4:	e022                	sd	s0,0(sp)
    80002bc6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002bc8:	fb3fe0ef          	jal	80001b7a <myproc>
}
    80002bcc:	5908                	lw	a0,48(a0)
    80002bce:	60a2                	ld	ra,8(sp)
    80002bd0:	6402                	ld	s0,0(sp)
    80002bd2:	0141                	addi	sp,sp,16
    80002bd4:	8082                	ret

0000000080002bd6 <sys_forkprio>:

uint64 sys_forkprio(void) {
    80002bd6:	1101                	addi	sp,sp,-32
    80002bd8:	ec06                	sd	ra,24(sp)
    80002bda:	e822                	sd	s0,16(sp)
    80002bdc:	1000                	addi	s0,sp,32
    int prio;

    // Recebe a prioridade como argumento
   argint(0, &prio);//void
    80002bde:	fec40593          	addi	a1,s0,-20
    80002be2:	4501                	li	a0,0
    80002be4:	eedff0ef          	jal	80002ad0 <argint>

    return forkprio(prio);  
    80002be8:	fec42503          	lw	a0,-20(s0)
    80002bec:	9faff0ef          	jal	80001de6 <forkprio>
}
    80002bf0:	60e2                	ld	ra,24(sp)
    80002bf2:	6442                	ld	s0,16(sp)
    80002bf4:	6105                	addi	sp,sp,32
    80002bf6:	8082                	ret

0000000080002bf8 <sys_fork>:

uint64
sys_fork(void)
{
    80002bf8:	1101                	addi	sp,sp,-32
    80002bfa:	ec06                	sd	ra,24(sp)
    80002bfc:	e822                	sd	s0,16(sp)
    80002bfe:	1000                	addi	s0,sp,32
  int classe;
  argint(0, &classe);
    80002c00:	fec40593          	addi	a1,s0,-20
    80002c04:	4501                	li	a0,0
    80002c06:	ecbff0ef          	jal	80002ad0 <argint>
  return fork(classe);
    80002c0a:	fec42503          	lw	a0,-20(s0)
    80002c0e:	becff0ef          	jal	80001ffa <fork>
}
    80002c12:	60e2                	ld	ra,24(sp)
    80002c14:	6442                	ld	s0,16(sp)
    80002c16:	6105                	addi	sp,sp,32
    80002c18:	8082                	ret

0000000080002c1a <sys_wait>:

uint64
sys_wait(void)
{
    80002c1a:	1101                	addi	sp,sp,-32
    80002c1c:	ec06                	sd	ra,24(sp)
    80002c1e:	e822                	sd	s0,16(sp)
    80002c20:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002c22:	fe840593          	addi	a1,s0,-24
    80002c26:	4501                	li	a0,0
    80002c28:	ec5ff0ef          	jal	80002aec <argaddr>
  return wait(p);
    80002c2c:	fe843503          	ld	a0,-24(s0)
    80002c30:	81dff0ef          	jal	8000244c <wait>
}
    80002c34:	60e2                	ld	ra,24(sp)
    80002c36:	6442                	ld	s0,16(sp)
    80002c38:	6105                	addi	sp,sp,32
    80002c3a:	8082                	ret

0000000080002c3c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c3c:	7179                	addi	sp,sp,-48
    80002c3e:	f406                	sd	ra,40(sp)
    80002c40:	f022                	sd	s0,32(sp)
    80002c42:	ec26                	sd	s1,24(sp)
    80002c44:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002c46:	fdc40593          	addi	a1,s0,-36
    80002c4a:	4501                	li	a0,0
    80002c4c:	e85ff0ef          	jal	80002ad0 <argint>
  addr = myproc()->sz;
    80002c50:	f2bfe0ef          	jal	80001b7a <myproc>
    80002c54:	6d24                	ld	s1,88(a0)
  if(growproc(n) < 0)
    80002c56:	fdc42503          	lw	a0,-36(s0)
    80002c5a:	b50ff0ef          	jal	80001faa <growproc>
    80002c5e:	00054863          	bltz	a0,80002c6e <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002c62:	8526                	mv	a0,s1
    80002c64:	70a2                	ld	ra,40(sp)
    80002c66:	7402                	ld	s0,32(sp)
    80002c68:	64e2                	ld	s1,24(sp)
    80002c6a:	6145                	addi	sp,sp,48
    80002c6c:	8082                	ret
    return -1;
    80002c6e:	54fd                	li	s1,-1
    80002c70:	bfcd                	j	80002c62 <sys_sbrk+0x26>

0000000080002c72 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c72:	7139                	addi	sp,sp,-64
    80002c74:	fc06                	sd	ra,56(sp)
    80002c76:	f822                	sd	s0,48(sp)
    80002c78:	f04a                	sd	s2,32(sp)
    80002c7a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002c7c:	fcc40593          	addi	a1,s0,-52
    80002c80:	4501                	li	a0,0
    80002c82:	e4fff0ef          	jal	80002ad0 <argint>
  if(n < 0)
    80002c86:	fcc42783          	lw	a5,-52(s0)
    80002c8a:	0607c763          	bltz	a5,80002cf8 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002c8e:	00016517          	auipc	a0,0x16
    80002c92:	a5250513          	addi	a0,a0,-1454 # 800186e0 <tickslock>
    80002c96:	f5ffd0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80002c9a:	00007917          	auipc	s2,0x7
    80002c9e:	6d692903          	lw	s2,1750(s2) # 8000a370 <ticks>
  while(ticks - ticks0 < n){
    80002ca2:	fcc42783          	lw	a5,-52(s0)
    80002ca6:	cf8d                	beqz	a5,80002ce0 <sys_sleep+0x6e>
    80002ca8:	f426                	sd	s1,40(sp)
    80002caa:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002cac:	00016997          	auipc	s3,0x16
    80002cb0:	a3498993          	addi	s3,s3,-1484 # 800186e0 <tickslock>
    80002cb4:	00007497          	auipc	s1,0x7
    80002cb8:	6bc48493          	addi	s1,s1,1724 # 8000a370 <ticks>
    if(killed(myproc())){
    80002cbc:	ebffe0ef          	jal	80001b7a <myproc>
    80002cc0:	f62ff0ef          	jal	80002422 <killed>
    80002cc4:	ed0d                	bnez	a0,80002cfe <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002cc6:	85ce                	mv	a1,s3
    80002cc8:	8526                	mv	a0,s1
    80002cca:	d20ff0ef          	jal	800021ea <sleep>
  while(ticks - ticks0 < n){
    80002cce:	409c                	lw	a5,0(s1)
    80002cd0:	412787bb          	subw	a5,a5,s2
    80002cd4:	fcc42703          	lw	a4,-52(s0)
    80002cd8:	fee7e2e3          	bltu	a5,a4,80002cbc <sys_sleep+0x4a>
    80002cdc:	74a2                	ld	s1,40(sp)
    80002cde:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002ce0:	00016517          	auipc	a0,0x16
    80002ce4:	a0050513          	addi	a0,a0,-1536 # 800186e0 <tickslock>
    80002ce8:	fa5fd0ef          	jal	80000c8c <release>
  return 0;
    80002cec:	4501                	li	a0,0
}
    80002cee:	70e2                	ld	ra,56(sp)
    80002cf0:	7442                	ld	s0,48(sp)
    80002cf2:	7902                	ld	s2,32(sp)
    80002cf4:	6121                	addi	sp,sp,64
    80002cf6:	8082                	ret
    n = 0;
    80002cf8:	fc042623          	sw	zero,-52(s0)
    80002cfc:	bf49                	j	80002c8e <sys_sleep+0x1c>
      release(&tickslock);
    80002cfe:	00016517          	auipc	a0,0x16
    80002d02:	9e250513          	addi	a0,a0,-1566 # 800186e0 <tickslock>
    80002d06:	f87fd0ef          	jal	80000c8c <release>
      return -1;
    80002d0a:	557d                	li	a0,-1
    80002d0c:	74a2                	ld	s1,40(sp)
    80002d0e:	69e2                	ld	s3,24(sp)
    80002d10:	bff9                	j	80002cee <sys_sleep+0x7c>

0000000080002d12 <sys_kill>:

uint64
sys_kill(void)
{
    80002d12:	1101                	addi	sp,sp,-32
    80002d14:	ec06                	sd	ra,24(sp)
    80002d16:	e822                	sd	s0,16(sp)
    80002d18:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002d1a:	fec40593          	addi	a1,s0,-20
    80002d1e:	4501                	li	a0,0
    80002d20:	db1ff0ef          	jal	80002ad0 <argint>
  return kill(pid);
    80002d24:	fec42503          	lw	a0,-20(s0)
    80002d28:	e70ff0ef          	jal	80002398 <kill>
}
    80002d2c:	60e2                	ld	ra,24(sp)
    80002d2e:	6442                	ld	s0,16(sp)
    80002d30:	6105                	addi	sp,sp,32
    80002d32:	8082                	ret

0000000080002d34 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d34:	1101                	addi	sp,sp,-32
    80002d36:	ec06                	sd	ra,24(sp)
    80002d38:	e822                	sd	s0,16(sp)
    80002d3a:	e426                	sd	s1,8(sp)
    80002d3c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d3e:	00016517          	auipc	a0,0x16
    80002d42:	9a250513          	addi	a0,a0,-1630 # 800186e0 <tickslock>
    80002d46:	eaffd0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002d4a:	00007497          	auipc	s1,0x7
    80002d4e:	6264a483          	lw	s1,1574(s1) # 8000a370 <ticks>
  release(&tickslock);
    80002d52:	00016517          	auipc	a0,0x16
    80002d56:	98e50513          	addi	a0,a0,-1650 # 800186e0 <tickslock>
    80002d5a:	f33fd0ef          	jal	80000c8c <release>
  return xticks;
}
    80002d5e:	02049513          	slli	a0,s1,0x20
    80002d62:	9101                	srli	a0,a0,0x20
    80002d64:	60e2                	ld	ra,24(sp)
    80002d66:	6442                	ld	s0,16(sp)
    80002d68:	64a2                	ld	s1,8(sp)
    80002d6a:	6105                	addi	sp,sp,32
    80002d6c:	8082                	ret

0000000080002d6e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d6e:	7179                	addi	sp,sp,-48
    80002d70:	f406                	sd	ra,40(sp)
    80002d72:	f022                	sd	s0,32(sp)
    80002d74:	ec26                	sd	s1,24(sp)
    80002d76:	e84a                	sd	s2,16(sp)
    80002d78:	e44e                	sd	s3,8(sp)
    80002d7a:	e052                	sd	s4,0(sp)
    80002d7c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d7e:	00004597          	auipc	a1,0x4
    80002d82:	6e258593          	addi	a1,a1,1762 # 80007460 <etext+0x460>
    80002d86:	00016517          	auipc	a0,0x16
    80002d8a:	97250513          	addi	a0,a0,-1678 # 800186f8 <bcache>
    80002d8e:	de7fd0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d92:	0001e797          	auipc	a5,0x1e
    80002d96:	96678793          	addi	a5,a5,-1690 # 800206f8 <bcache+0x8000>
    80002d9a:	0001e717          	auipc	a4,0x1e
    80002d9e:	bc670713          	addi	a4,a4,-1082 # 80020960 <bcache+0x8268>
    80002da2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002da6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002daa:	00016497          	auipc	s1,0x16
    80002dae:	96648493          	addi	s1,s1,-1690 # 80018710 <bcache+0x18>
    b->next = bcache.head.next;
    80002db2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002db4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002db6:	00004a17          	auipc	s4,0x4
    80002dba:	6b2a0a13          	addi	s4,s4,1714 # 80007468 <etext+0x468>
    b->next = bcache.head.next;
    80002dbe:	2b893783          	ld	a5,696(s2)
    80002dc2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002dc4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002dc8:	85d2                	mv	a1,s4
    80002dca:	01048513          	addi	a0,s1,16
    80002dce:	248010ef          	jal	80004016 <initsleeplock>
    bcache.head.next->prev = b;
    80002dd2:	2b893783          	ld	a5,696(s2)
    80002dd6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002dd8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ddc:	45848493          	addi	s1,s1,1112
    80002de0:	fd349fe3          	bne	s1,s3,80002dbe <binit+0x50>
  }
}
    80002de4:	70a2                	ld	ra,40(sp)
    80002de6:	7402                	ld	s0,32(sp)
    80002de8:	64e2                	ld	s1,24(sp)
    80002dea:	6942                	ld	s2,16(sp)
    80002dec:	69a2                	ld	s3,8(sp)
    80002dee:	6a02                	ld	s4,0(sp)
    80002df0:	6145                	addi	sp,sp,48
    80002df2:	8082                	ret

0000000080002df4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002df4:	7179                	addi	sp,sp,-48
    80002df6:	f406                	sd	ra,40(sp)
    80002df8:	f022                	sd	s0,32(sp)
    80002dfa:	ec26                	sd	s1,24(sp)
    80002dfc:	e84a                	sd	s2,16(sp)
    80002dfe:	e44e                	sd	s3,8(sp)
    80002e00:	1800                	addi	s0,sp,48
    80002e02:	892a                	mv	s2,a0
    80002e04:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002e06:	00016517          	auipc	a0,0x16
    80002e0a:	8f250513          	addi	a0,a0,-1806 # 800186f8 <bcache>
    80002e0e:	de7fd0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e12:	0001e497          	auipc	s1,0x1e
    80002e16:	b9e4b483          	ld	s1,-1122(s1) # 800209b0 <bcache+0x82b8>
    80002e1a:	0001e797          	auipc	a5,0x1e
    80002e1e:	b4678793          	addi	a5,a5,-1210 # 80020960 <bcache+0x8268>
    80002e22:	02f48b63          	beq	s1,a5,80002e58 <bread+0x64>
    80002e26:	873e                	mv	a4,a5
    80002e28:	a021                	j	80002e30 <bread+0x3c>
    80002e2a:	68a4                	ld	s1,80(s1)
    80002e2c:	02e48663          	beq	s1,a4,80002e58 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002e30:	449c                	lw	a5,8(s1)
    80002e32:	ff279ce3          	bne	a5,s2,80002e2a <bread+0x36>
    80002e36:	44dc                	lw	a5,12(s1)
    80002e38:	ff3799e3          	bne	a5,s3,80002e2a <bread+0x36>
      b->refcnt++;
    80002e3c:	40bc                	lw	a5,64(s1)
    80002e3e:	2785                	addiw	a5,a5,1
    80002e40:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e42:	00016517          	auipc	a0,0x16
    80002e46:	8b650513          	addi	a0,a0,-1866 # 800186f8 <bcache>
    80002e4a:	e43fd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002e4e:	01048513          	addi	a0,s1,16
    80002e52:	1fa010ef          	jal	8000404c <acquiresleep>
      return b;
    80002e56:	a889                	j	80002ea8 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e58:	0001e497          	auipc	s1,0x1e
    80002e5c:	b504b483          	ld	s1,-1200(s1) # 800209a8 <bcache+0x82b0>
    80002e60:	0001e797          	auipc	a5,0x1e
    80002e64:	b0078793          	addi	a5,a5,-1280 # 80020960 <bcache+0x8268>
    80002e68:	00f48863          	beq	s1,a5,80002e78 <bread+0x84>
    80002e6c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e6e:	40bc                	lw	a5,64(s1)
    80002e70:	cb91                	beqz	a5,80002e84 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e72:	64a4                	ld	s1,72(s1)
    80002e74:	fee49de3          	bne	s1,a4,80002e6e <bread+0x7a>
  panic("bget: no buffers");
    80002e78:	00004517          	auipc	a0,0x4
    80002e7c:	5f850513          	addi	a0,a0,1528 # 80007470 <etext+0x470>
    80002e80:	915fd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002e84:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e88:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e8c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e90:	4785                	li	a5,1
    80002e92:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e94:	00016517          	auipc	a0,0x16
    80002e98:	86450513          	addi	a0,a0,-1948 # 800186f8 <bcache>
    80002e9c:	df1fd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002ea0:	01048513          	addi	a0,s1,16
    80002ea4:	1a8010ef          	jal	8000404c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ea8:	409c                	lw	a5,0(s1)
    80002eaa:	cb89                	beqz	a5,80002ebc <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002eac:	8526                	mv	a0,s1
    80002eae:	70a2                	ld	ra,40(sp)
    80002eb0:	7402                	ld	s0,32(sp)
    80002eb2:	64e2                	ld	s1,24(sp)
    80002eb4:	6942                	ld	s2,16(sp)
    80002eb6:	69a2                	ld	s3,8(sp)
    80002eb8:	6145                	addi	sp,sp,48
    80002eba:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ebc:	4581                	li	a1,0
    80002ebe:	8526                	mv	a0,s1
    80002ec0:	1f1020ef          	jal	800058b0 <virtio_disk_rw>
    b->valid = 1;
    80002ec4:	4785                	li	a5,1
    80002ec6:	c09c                	sw	a5,0(s1)
  return b;
    80002ec8:	b7d5                	j	80002eac <bread+0xb8>

0000000080002eca <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002eca:	1101                	addi	sp,sp,-32
    80002ecc:	ec06                	sd	ra,24(sp)
    80002ece:	e822                	sd	s0,16(sp)
    80002ed0:	e426                	sd	s1,8(sp)
    80002ed2:	1000                	addi	s0,sp,32
    80002ed4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ed6:	0541                	addi	a0,a0,16
    80002ed8:	1f2010ef          	jal	800040ca <holdingsleep>
    80002edc:	c911                	beqz	a0,80002ef0 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ede:	4585                	li	a1,1
    80002ee0:	8526                	mv	a0,s1
    80002ee2:	1cf020ef          	jal	800058b0 <virtio_disk_rw>
}
    80002ee6:	60e2                	ld	ra,24(sp)
    80002ee8:	6442                	ld	s0,16(sp)
    80002eea:	64a2                	ld	s1,8(sp)
    80002eec:	6105                	addi	sp,sp,32
    80002eee:	8082                	ret
    panic("bwrite");
    80002ef0:	00004517          	auipc	a0,0x4
    80002ef4:	59850513          	addi	a0,a0,1432 # 80007488 <etext+0x488>
    80002ef8:	89dfd0ef          	jal	80000794 <panic>

0000000080002efc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002efc:	1101                	addi	sp,sp,-32
    80002efe:	ec06                	sd	ra,24(sp)
    80002f00:	e822                	sd	s0,16(sp)
    80002f02:	e426                	sd	s1,8(sp)
    80002f04:	e04a                	sd	s2,0(sp)
    80002f06:	1000                	addi	s0,sp,32
    80002f08:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f0a:	01050913          	addi	s2,a0,16
    80002f0e:	854a                	mv	a0,s2
    80002f10:	1ba010ef          	jal	800040ca <holdingsleep>
    80002f14:	c135                	beqz	a0,80002f78 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002f16:	854a                	mv	a0,s2
    80002f18:	17a010ef          	jal	80004092 <releasesleep>

  acquire(&bcache.lock);
    80002f1c:	00015517          	auipc	a0,0x15
    80002f20:	7dc50513          	addi	a0,a0,2012 # 800186f8 <bcache>
    80002f24:	cd1fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002f28:	40bc                	lw	a5,64(s1)
    80002f2a:	37fd                	addiw	a5,a5,-1
    80002f2c:	0007871b          	sext.w	a4,a5
    80002f30:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f32:	e71d                	bnez	a4,80002f60 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f34:	68b8                	ld	a4,80(s1)
    80002f36:	64bc                	ld	a5,72(s1)
    80002f38:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002f3a:	68b8                	ld	a4,80(s1)
    80002f3c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f3e:	0001d797          	auipc	a5,0x1d
    80002f42:	7ba78793          	addi	a5,a5,1978 # 800206f8 <bcache+0x8000>
    80002f46:	2b87b703          	ld	a4,696(a5)
    80002f4a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f4c:	0001e717          	auipc	a4,0x1e
    80002f50:	a1470713          	addi	a4,a4,-1516 # 80020960 <bcache+0x8268>
    80002f54:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f56:	2b87b703          	ld	a4,696(a5)
    80002f5a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f5c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f60:	00015517          	auipc	a0,0x15
    80002f64:	79850513          	addi	a0,a0,1944 # 800186f8 <bcache>
    80002f68:	d25fd0ef          	jal	80000c8c <release>
}
    80002f6c:	60e2                	ld	ra,24(sp)
    80002f6e:	6442                	ld	s0,16(sp)
    80002f70:	64a2                	ld	s1,8(sp)
    80002f72:	6902                	ld	s2,0(sp)
    80002f74:	6105                	addi	sp,sp,32
    80002f76:	8082                	ret
    panic("brelse");
    80002f78:	00004517          	auipc	a0,0x4
    80002f7c:	51850513          	addi	a0,a0,1304 # 80007490 <etext+0x490>
    80002f80:	815fd0ef          	jal	80000794 <panic>

0000000080002f84 <bpin>:

void
bpin(struct buf *b) {
    80002f84:	1101                	addi	sp,sp,-32
    80002f86:	ec06                	sd	ra,24(sp)
    80002f88:	e822                	sd	s0,16(sp)
    80002f8a:	e426                	sd	s1,8(sp)
    80002f8c:	1000                	addi	s0,sp,32
    80002f8e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f90:	00015517          	auipc	a0,0x15
    80002f94:	76850513          	addi	a0,a0,1896 # 800186f8 <bcache>
    80002f98:	c5dfd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80002f9c:	40bc                	lw	a5,64(s1)
    80002f9e:	2785                	addiw	a5,a5,1
    80002fa0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fa2:	00015517          	auipc	a0,0x15
    80002fa6:	75650513          	addi	a0,a0,1878 # 800186f8 <bcache>
    80002faa:	ce3fd0ef          	jal	80000c8c <release>
}
    80002fae:	60e2                	ld	ra,24(sp)
    80002fb0:	6442                	ld	s0,16(sp)
    80002fb2:	64a2                	ld	s1,8(sp)
    80002fb4:	6105                	addi	sp,sp,32
    80002fb6:	8082                	ret

0000000080002fb8 <bunpin>:

void
bunpin(struct buf *b) {
    80002fb8:	1101                	addi	sp,sp,-32
    80002fba:	ec06                	sd	ra,24(sp)
    80002fbc:	e822                	sd	s0,16(sp)
    80002fbe:	e426                	sd	s1,8(sp)
    80002fc0:	1000                	addi	s0,sp,32
    80002fc2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fc4:	00015517          	auipc	a0,0x15
    80002fc8:	73450513          	addi	a0,a0,1844 # 800186f8 <bcache>
    80002fcc:	c29fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002fd0:	40bc                	lw	a5,64(s1)
    80002fd2:	37fd                	addiw	a5,a5,-1
    80002fd4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fd6:	00015517          	auipc	a0,0x15
    80002fda:	72250513          	addi	a0,a0,1826 # 800186f8 <bcache>
    80002fde:	caffd0ef          	jal	80000c8c <release>
}
    80002fe2:	60e2                	ld	ra,24(sp)
    80002fe4:	6442                	ld	s0,16(sp)
    80002fe6:	64a2                	ld	s1,8(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret

0000000080002fec <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002fec:	1101                	addi	sp,sp,-32
    80002fee:	ec06                	sd	ra,24(sp)
    80002ff0:	e822                	sd	s0,16(sp)
    80002ff2:	e426                	sd	s1,8(sp)
    80002ff4:	e04a                	sd	s2,0(sp)
    80002ff6:	1000                	addi	s0,sp,32
    80002ff8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002ffa:	00d5d59b          	srliw	a1,a1,0xd
    80002ffe:	0001e797          	auipc	a5,0x1e
    80003002:	dd67a783          	lw	a5,-554(a5) # 80020dd4 <sb+0x1c>
    80003006:	9dbd                	addw	a1,a1,a5
    80003008:	dedff0ef          	jal	80002df4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000300c:	0074f713          	andi	a4,s1,7
    80003010:	4785                	li	a5,1
    80003012:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003016:	14ce                	slli	s1,s1,0x33
    80003018:	90d9                	srli	s1,s1,0x36
    8000301a:	00950733          	add	a4,a0,s1
    8000301e:	05874703          	lbu	a4,88(a4)
    80003022:	00e7f6b3          	and	a3,a5,a4
    80003026:	c29d                	beqz	a3,8000304c <bfree+0x60>
    80003028:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000302a:	94aa                	add	s1,s1,a0
    8000302c:	fff7c793          	not	a5,a5
    80003030:	8f7d                	and	a4,a4,a5
    80003032:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003036:	711000ef          	jal	80003f46 <log_write>
  brelse(bp);
    8000303a:	854a                	mv	a0,s2
    8000303c:	ec1ff0ef          	jal	80002efc <brelse>
}
    80003040:	60e2                	ld	ra,24(sp)
    80003042:	6442                	ld	s0,16(sp)
    80003044:	64a2                	ld	s1,8(sp)
    80003046:	6902                	ld	s2,0(sp)
    80003048:	6105                	addi	sp,sp,32
    8000304a:	8082                	ret
    panic("freeing free block");
    8000304c:	00004517          	auipc	a0,0x4
    80003050:	44c50513          	addi	a0,a0,1100 # 80007498 <etext+0x498>
    80003054:	f40fd0ef          	jal	80000794 <panic>

0000000080003058 <balloc>:
{
    80003058:	711d                	addi	sp,sp,-96
    8000305a:	ec86                	sd	ra,88(sp)
    8000305c:	e8a2                	sd	s0,80(sp)
    8000305e:	e4a6                	sd	s1,72(sp)
    80003060:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003062:	0001e797          	auipc	a5,0x1e
    80003066:	d5a7a783          	lw	a5,-678(a5) # 80020dbc <sb+0x4>
    8000306a:	0e078f63          	beqz	a5,80003168 <balloc+0x110>
    8000306e:	e0ca                	sd	s2,64(sp)
    80003070:	fc4e                	sd	s3,56(sp)
    80003072:	f852                	sd	s4,48(sp)
    80003074:	f456                	sd	s5,40(sp)
    80003076:	f05a                	sd	s6,32(sp)
    80003078:	ec5e                	sd	s7,24(sp)
    8000307a:	e862                	sd	s8,16(sp)
    8000307c:	e466                	sd	s9,8(sp)
    8000307e:	8baa                	mv	s7,a0
    80003080:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003082:	0001eb17          	auipc	s6,0x1e
    80003086:	d36b0b13          	addi	s6,s6,-714 # 80020db8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000308a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000308c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000308e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003090:	6c89                	lui	s9,0x2
    80003092:	a0b5                	j	800030fe <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003094:	97ca                	add	a5,a5,s2
    80003096:	8e55                	or	a2,a2,a3
    80003098:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000309c:	854a                	mv	a0,s2
    8000309e:	6a9000ef          	jal	80003f46 <log_write>
        brelse(bp);
    800030a2:	854a                	mv	a0,s2
    800030a4:	e59ff0ef          	jal	80002efc <brelse>
  bp = bread(dev, bno);
    800030a8:	85a6                	mv	a1,s1
    800030aa:	855e                	mv	a0,s7
    800030ac:	d49ff0ef          	jal	80002df4 <bread>
    800030b0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800030b2:	40000613          	li	a2,1024
    800030b6:	4581                	li	a1,0
    800030b8:	05850513          	addi	a0,a0,88
    800030bc:	c0dfd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    800030c0:	854a                	mv	a0,s2
    800030c2:	685000ef          	jal	80003f46 <log_write>
  brelse(bp);
    800030c6:	854a                	mv	a0,s2
    800030c8:	e35ff0ef          	jal	80002efc <brelse>
}
    800030cc:	6906                	ld	s2,64(sp)
    800030ce:	79e2                	ld	s3,56(sp)
    800030d0:	7a42                	ld	s4,48(sp)
    800030d2:	7aa2                	ld	s5,40(sp)
    800030d4:	7b02                	ld	s6,32(sp)
    800030d6:	6be2                	ld	s7,24(sp)
    800030d8:	6c42                	ld	s8,16(sp)
    800030da:	6ca2                	ld	s9,8(sp)
}
    800030dc:	8526                	mv	a0,s1
    800030de:	60e6                	ld	ra,88(sp)
    800030e0:	6446                	ld	s0,80(sp)
    800030e2:	64a6                	ld	s1,72(sp)
    800030e4:	6125                	addi	sp,sp,96
    800030e6:	8082                	ret
    brelse(bp);
    800030e8:	854a                	mv	a0,s2
    800030ea:	e13ff0ef          	jal	80002efc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800030ee:	015c87bb          	addw	a5,s9,s5
    800030f2:	00078a9b          	sext.w	s5,a5
    800030f6:	004b2703          	lw	a4,4(s6)
    800030fa:	04eaff63          	bgeu	s5,a4,80003158 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800030fe:	41fad79b          	sraiw	a5,s5,0x1f
    80003102:	0137d79b          	srliw	a5,a5,0x13
    80003106:	015787bb          	addw	a5,a5,s5
    8000310a:	40d7d79b          	sraiw	a5,a5,0xd
    8000310e:	01cb2583          	lw	a1,28(s6)
    80003112:	9dbd                	addw	a1,a1,a5
    80003114:	855e                	mv	a0,s7
    80003116:	cdfff0ef          	jal	80002df4 <bread>
    8000311a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000311c:	004b2503          	lw	a0,4(s6)
    80003120:	000a849b          	sext.w	s1,s5
    80003124:	8762                	mv	a4,s8
    80003126:	fca4f1e3          	bgeu	s1,a0,800030e8 <balloc+0x90>
      m = 1 << (bi % 8);
    8000312a:	00777693          	andi	a3,a4,7
    8000312e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003132:	41f7579b          	sraiw	a5,a4,0x1f
    80003136:	01d7d79b          	srliw	a5,a5,0x1d
    8000313a:	9fb9                	addw	a5,a5,a4
    8000313c:	4037d79b          	sraiw	a5,a5,0x3
    80003140:	00f90633          	add	a2,s2,a5
    80003144:	05864603          	lbu	a2,88(a2)
    80003148:	00c6f5b3          	and	a1,a3,a2
    8000314c:	d5a1                	beqz	a1,80003094 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000314e:	2705                	addiw	a4,a4,1
    80003150:	2485                	addiw	s1,s1,1
    80003152:	fd471ae3          	bne	a4,s4,80003126 <balloc+0xce>
    80003156:	bf49                	j	800030e8 <balloc+0x90>
    80003158:	6906                	ld	s2,64(sp)
    8000315a:	79e2                	ld	s3,56(sp)
    8000315c:	7a42                	ld	s4,48(sp)
    8000315e:	7aa2                	ld	s5,40(sp)
    80003160:	7b02                	ld	s6,32(sp)
    80003162:	6be2                	ld	s7,24(sp)
    80003164:	6c42                	ld	s8,16(sp)
    80003166:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003168:	00004517          	auipc	a0,0x4
    8000316c:	34850513          	addi	a0,a0,840 # 800074b0 <etext+0x4b0>
    80003170:	b52fd0ef          	jal	800004c2 <printf>
  return 0;
    80003174:	4481                	li	s1,0
    80003176:	b79d                	j	800030dc <balloc+0x84>

0000000080003178 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003178:	7179                	addi	sp,sp,-48
    8000317a:	f406                	sd	ra,40(sp)
    8000317c:	f022                	sd	s0,32(sp)
    8000317e:	ec26                	sd	s1,24(sp)
    80003180:	e84a                	sd	s2,16(sp)
    80003182:	e44e                	sd	s3,8(sp)
    80003184:	1800                	addi	s0,sp,48
    80003186:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003188:	47ad                	li	a5,11
    8000318a:	02b7e663          	bltu	a5,a1,800031b6 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000318e:	02059793          	slli	a5,a1,0x20
    80003192:	01e7d593          	srli	a1,a5,0x1e
    80003196:	00b504b3          	add	s1,a0,a1
    8000319a:	0504a903          	lw	s2,80(s1)
    8000319e:	06091a63          	bnez	s2,80003212 <bmap+0x9a>
      addr = balloc(ip->dev);
    800031a2:	4108                	lw	a0,0(a0)
    800031a4:	eb5ff0ef          	jal	80003058 <balloc>
    800031a8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800031ac:	06090363          	beqz	s2,80003212 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800031b0:	0524a823          	sw	s2,80(s1)
    800031b4:	a8b9                	j	80003212 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800031b6:	ff45849b          	addiw	s1,a1,-12
    800031ba:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800031be:	0ff00793          	li	a5,255
    800031c2:	06e7ee63          	bltu	a5,a4,8000323e <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800031c6:	08052903          	lw	s2,128(a0)
    800031ca:	00091d63          	bnez	s2,800031e4 <bmap+0x6c>
      addr = balloc(ip->dev);
    800031ce:	4108                	lw	a0,0(a0)
    800031d0:	e89ff0ef          	jal	80003058 <balloc>
    800031d4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800031d8:	02090d63          	beqz	s2,80003212 <bmap+0x9a>
    800031dc:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800031de:	0929a023          	sw	s2,128(s3)
    800031e2:	a011                	j	800031e6 <bmap+0x6e>
    800031e4:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800031e6:	85ca                	mv	a1,s2
    800031e8:	0009a503          	lw	a0,0(s3)
    800031ec:	c09ff0ef          	jal	80002df4 <bread>
    800031f0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800031f2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800031f6:	02049713          	slli	a4,s1,0x20
    800031fa:	01e75593          	srli	a1,a4,0x1e
    800031fe:	00b784b3          	add	s1,a5,a1
    80003202:	0004a903          	lw	s2,0(s1)
    80003206:	00090e63          	beqz	s2,80003222 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000320a:	8552                	mv	a0,s4
    8000320c:	cf1ff0ef          	jal	80002efc <brelse>
    return addr;
    80003210:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003212:	854a                	mv	a0,s2
    80003214:	70a2                	ld	ra,40(sp)
    80003216:	7402                	ld	s0,32(sp)
    80003218:	64e2                	ld	s1,24(sp)
    8000321a:	6942                	ld	s2,16(sp)
    8000321c:	69a2                	ld	s3,8(sp)
    8000321e:	6145                	addi	sp,sp,48
    80003220:	8082                	ret
      addr = balloc(ip->dev);
    80003222:	0009a503          	lw	a0,0(s3)
    80003226:	e33ff0ef          	jal	80003058 <balloc>
    8000322a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000322e:	fc090ee3          	beqz	s2,8000320a <bmap+0x92>
        a[bn] = addr;
    80003232:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003236:	8552                	mv	a0,s4
    80003238:	50f000ef          	jal	80003f46 <log_write>
    8000323c:	b7f9                	j	8000320a <bmap+0x92>
    8000323e:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003240:	00004517          	auipc	a0,0x4
    80003244:	28850513          	addi	a0,a0,648 # 800074c8 <etext+0x4c8>
    80003248:	d4cfd0ef          	jal	80000794 <panic>

000000008000324c <iget>:
{
    8000324c:	7179                	addi	sp,sp,-48
    8000324e:	f406                	sd	ra,40(sp)
    80003250:	f022                	sd	s0,32(sp)
    80003252:	ec26                	sd	s1,24(sp)
    80003254:	e84a                	sd	s2,16(sp)
    80003256:	e44e                	sd	s3,8(sp)
    80003258:	e052                	sd	s4,0(sp)
    8000325a:	1800                	addi	s0,sp,48
    8000325c:	89aa                	mv	s3,a0
    8000325e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003260:	0001e517          	auipc	a0,0x1e
    80003264:	b7850513          	addi	a0,a0,-1160 # 80020dd8 <itable>
    80003268:	98dfd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    8000326c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000326e:	0001e497          	auipc	s1,0x1e
    80003272:	b8248493          	addi	s1,s1,-1150 # 80020df0 <itable+0x18>
    80003276:	0001f697          	auipc	a3,0x1f
    8000327a:	60a68693          	addi	a3,a3,1546 # 80022880 <log>
    8000327e:	a039                	j	8000328c <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003280:	02090963          	beqz	s2,800032b2 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003284:	08848493          	addi	s1,s1,136
    80003288:	02d48863          	beq	s1,a3,800032b8 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000328c:	449c                	lw	a5,8(s1)
    8000328e:	fef059e3          	blez	a5,80003280 <iget+0x34>
    80003292:	4098                	lw	a4,0(s1)
    80003294:	ff3716e3          	bne	a4,s3,80003280 <iget+0x34>
    80003298:	40d8                	lw	a4,4(s1)
    8000329a:	ff4713e3          	bne	a4,s4,80003280 <iget+0x34>
      ip->ref++;
    8000329e:	2785                	addiw	a5,a5,1
    800032a0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800032a2:	0001e517          	auipc	a0,0x1e
    800032a6:	b3650513          	addi	a0,a0,-1226 # 80020dd8 <itable>
    800032aa:	9e3fd0ef          	jal	80000c8c <release>
      return ip;
    800032ae:	8926                	mv	s2,s1
    800032b0:	a02d                	j	800032da <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032b2:	fbe9                	bnez	a5,80003284 <iget+0x38>
      empty = ip;
    800032b4:	8926                	mv	s2,s1
    800032b6:	b7f9                	j	80003284 <iget+0x38>
  if(empty == 0)
    800032b8:	02090a63          	beqz	s2,800032ec <iget+0xa0>
  ip->dev = dev;
    800032bc:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800032c0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800032c4:	4785                	li	a5,1
    800032c6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800032ca:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800032ce:	0001e517          	auipc	a0,0x1e
    800032d2:	b0a50513          	addi	a0,a0,-1270 # 80020dd8 <itable>
    800032d6:	9b7fd0ef          	jal	80000c8c <release>
}
    800032da:	854a                	mv	a0,s2
    800032dc:	70a2                	ld	ra,40(sp)
    800032de:	7402                	ld	s0,32(sp)
    800032e0:	64e2                	ld	s1,24(sp)
    800032e2:	6942                	ld	s2,16(sp)
    800032e4:	69a2                	ld	s3,8(sp)
    800032e6:	6a02                	ld	s4,0(sp)
    800032e8:	6145                	addi	sp,sp,48
    800032ea:	8082                	ret
    panic("iget: no inodes");
    800032ec:	00004517          	auipc	a0,0x4
    800032f0:	1f450513          	addi	a0,a0,500 # 800074e0 <etext+0x4e0>
    800032f4:	ca0fd0ef          	jal	80000794 <panic>

00000000800032f8 <fsinit>:
fsinit(int dev) {
    800032f8:	7179                	addi	sp,sp,-48
    800032fa:	f406                	sd	ra,40(sp)
    800032fc:	f022                	sd	s0,32(sp)
    800032fe:	ec26                	sd	s1,24(sp)
    80003300:	e84a                	sd	s2,16(sp)
    80003302:	e44e                	sd	s3,8(sp)
    80003304:	1800                	addi	s0,sp,48
    80003306:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003308:	4585                	li	a1,1
    8000330a:	aebff0ef          	jal	80002df4 <bread>
    8000330e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003310:	0001e997          	auipc	s3,0x1e
    80003314:	aa898993          	addi	s3,s3,-1368 # 80020db8 <sb>
    80003318:	02000613          	li	a2,32
    8000331c:	05850593          	addi	a1,a0,88
    80003320:	854e                	mv	a0,s3
    80003322:	a03fd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    80003326:	8526                	mv	a0,s1
    80003328:	bd5ff0ef          	jal	80002efc <brelse>
  if(sb.magic != FSMAGIC)
    8000332c:	0009a703          	lw	a4,0(s3)
    80003330:	102037b7          	lui	a5,0x10203
    80003334:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003338:	02f71063          	bne	a4,a5,80003358 <fsinit+0x60>
  initlog(dev, &sb);
    8000333c:	0001e597          	auipc	a1,0x1e
    80003340:	a7c58593          	addi	a1,a1,-1412 # 80020db8 <sb>
    80003344:	854a                	mv	a0,s2
    80003346:	1f9000ef          	jal	80003d3e <initlog>
}
    8000334a:	70a2                	ld	ra,40(sp)
    8000334c:	7402                	ld	s0,32(sp)
    8000334e:	64e2                	ld	s1,24(sp)
    80003350:	6942                	ld	s2,16(sp)
    80003352:	69a2                	ld	s3,8(sp)
    80003354:	6145                	addi	sp,sp,48
    80003356:	8082                	ret
    panic("invalid file system");
    80003358:	00004517          	auipc	a0,0x4
    8000335c:	19850513          	addi	a0,a0,408 # 800074f0 <etext+0x4f0>
    80003360:	c34fd0ef          	jal	80000794 <panic>

0000000080003364 <iinit>:
{
    80003364:	7179                	addi	sp,sp,-48
    80003366:	f406                	sd	ra,40(sp)
    80003368:	f022                	sd	s0,32(sp)
    8000336a:	ec26                	sd	s1,24(sp)
    8000336c:	e84a                	sd	s2,16(sp)
    8000336e:	e44e                	sd	s3,8(sp)
    80003370:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003372:	00004597          	auipc	a1,0x4
    80003376:	19658593          	addi	a1,a1,406 # 80007508 <etext+0x508>
    8000337a:	0001e517          	auipc	a0,0x1e
    8000337e:	a5e50513          	addi	a0,a0,-1442 # 80020dd8 <itable>
    80003382:	ff2fd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003386:	0001e497          	auipc	s1,0x1e
    8000338a:	a7a48493          	addi	s1,s1,-1414 # 80020e00 <itable+0x28>
    8000338e:	0001f997          	auipc	s3,0x1f
    80003392:	50298993          	addi	s3,s3,1282 # 80022890 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003396:	00004917          	auipc	s2,0x4
    8000339a:	17a90913          	addi	s2,s2,378 # 80007510 <etext+0x510>
    8000339e:	85ca                	mv	a1,s2
    800033a0:	8526                	mv	a0,s1
    800033a2:	475000ef          	jal	80004016 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800033a6:	08848493          	addi	s1,s1,136
    800033aa:	ff349ae3          	bne	s1,s3,8000339e <iinit+0x3a>
}
    800033ae:	70a2                	ld	ra,40(sp)
    800033b0:	7402                	ld	s0,32(sp)
    800033b2:	64e2                	ld	s1,24(sp)
    800033b4:	6942                	ld	s2,16(sp)
    800033b6:	69a2                	ld	s3,8(sp)
    800033b8:	6145                	addi	sp,sp,48
    800033ba:	8082                	ret

00000000800033bc <ialloc>:
{
    800033bc:	7139                	addi	sp,sp,-64
    800033be:	fc06                	sd	ra,56(sp)
    800033c0:	f822                	sd	s0,48(sp)
    800033c2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800033c4:	0001e717          	auipc	a4,0x1e
    800033c8:	a0072703          	lw	a4,-1536(a4) # 80020dc4 <sb+0xc>
    800033cc:	4785                	li	a5,1
    800033ce:	06e7f063          	bgeu	a5,a4,8000342e <ialloc+0x72>
    800033d2:	f426                	sd	s1,40(sp)
    800033d4:	f04a                	sd	s2,32(sp)
    800033d6:	ec4e                	sd	s3,24(sp)
    800033d8:	e852                	sd	s4,16(sp)
    800033da:	e456                	sd	s5,8(sp)
    800033dc:	e05a                	sd	s6,0(sp)
    800033de:	8aaa                	mv	s5,a0
    800033e0:	8b2e                	mv	s6,a1
    800033e2:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800033e4:	0001ea17          	auipc	s4,0x1e
    800033e8:	9d4a0a13          	addi	s4,s4,-1580 # 80020db8 <sb>
    800033ec:	00495593          	srli	a1,s2,0x4
    800033f0:	018a2783          	lw	a5,24(s4)
    800033f4:	9dbd                	addw	a1,a1,a5
    800033f6:	8556                	mv	a0,s5
    800033f8:	9fdff0ef          	jal	80002df4 <bread>
    800033fc:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800033fe:	05850993          	addi	s3,a0,88
    80003402:	00f97793          	andi	a5,s2,15
    80003406:	079a                	slli	a5,a5,0x6
    80003408:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000340a:	00099783          	lh	a5,0(s3)
    8000340e:	cb9d                	beqz	a5,80003444 <ialloc+0x88>
    brelse(bp);
    80003410:	aedff0ef          	jal	80002efc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003414:	0905                	addi	s2,s2,1
    80003416:	00ca2703          	lw	a4,12(s4)
    8000341a:	0009079b          	sext.w	a5,s2
    8000341e:	fce7e7e3          	bltu	a5,a4,800033ec <ialloc+0x30>
    80003422:	74a2                	ld	s1,40(sp)
    80003424:	7902                	ld	s2,32(sp)
    80003426:	69e2                	ld	s3,24(sp)
    80003428:	6a42                	ld	s4,16(sp)
    8000342a:	6aa2                	ld	s5,8(sp)
    8000342c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000342e:	00004517          	auipc	a0,0x4
    80003432:	0ea50513          	addi	a0,a0,234 # 80007518 <etext+0x518>
    80003436:	88cfd0ef          	jal	800004c2 <printf>
  return 0;
    8000343a:	4501                	li	a0,0
}
    8000343c:	70e2                	ld	ra,56(sp)
    8000343e:	7442                	ld	s0,48(sp)
    80003440:	6121                	addi	sp,sp,64
    80003442:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003444:	04000613          	li	a2,64
    80003448:	4581                	li	a1,0
    8000344a:	854e                	mv	a0,s3
    8000344c:	87dfd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    80003450:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003454:	8526                	mv	a0,s1
    80003456:	2f1000ef          	jal	80003f46 <log_write>
      brelse(bp);
    8000345a:	8526                	mv	a0,s1
    8000345c:	aa1ff0ef          	jal	80002efc <brelse>
      return iget(dev, inum);
    80003460:	0009059b          	sext.w	a1,s2
    80003464:	8556                	mv	a0,s5
    80003466:	de7ff0ef          	jal	8000324c <iget>
    8000346a:	74a2                	ld	s1,40(sp)
    8000346c:	7902                	ld	s2,32(sp)
    8000346e:	69e2                	ld	s3,24(sp)
    80003470:	6a42                	ld	s4,16(sp)
    80003472:	6aa2                	ld	s5,8(sp)
    80003474:	6b02                	ld	s6,0(sp)
    80003476:	b7d9                	j	8000343c <ialloc+0x80>

0000000080003478 <iupdate>:
{
    80003478:	1101                	addi	sp,sp,-32
    8000347a:	ec06                	sd	ra,24(sp)
    8000347c:	e822                	sd	s0,16(sp)
    8000347e:	e426                	sd	s1,8(sp)
    80003480:	e04a                	sd	s2,0(sp)
    80003482:	1000                	addi	s0,sp,32
    80003484:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003486:	415c                	lw	a5,4(a0)
    80003488:	0047d79b          	srliw	a5,a5,0x4
    8000348c:	0001e597          	auipc	a1,0x1e
    80003490:	9445a583          	lw	a1,-1724(a1) # 80020dd0 <sb+0x18>
    80003494:	9dbd                	addw	a1,a1,a5
    80003496:	4108                	lw	a0,0(a0)
    80003498:	95dff0ef          	jal	80002df4 <bread>
    8000349c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000349e:	05850793          	addi	a5,a0,88
    800034a2:	40d8                	lw	a4,4(s1)
    800034a4:	8b3d                	andi	a4,a4,15
    800034a6:	071a                	slli	a4,a4,0x6
    800034a8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800034aa:	04449703          	lh	a4,68(s1)
    800034ae:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800034b2:	04649703          	lh	a4,70(s1)
    800034b6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800034ba:	04849703          	lh	a4,72(s1)
    800034be:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800034c2:	04a49703          	lh	a4,74(s1)
    800034c6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800034ca:	44f8                	lw	a4,76(s1)
    800034cc:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800034ce:	03400613          	li	a2,52
    800034d2:	05048593          	addi	a1,s1,80
    800034d6:	00c78513          	addi	a0,a5,12
    800034da:	84bfd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    800034de:	854a                	mv	a0,s2
    800034e0:	267000ef          	jal	80003f46 <log_write>
  brelse(bp);
    800034e4:	854a                	mv	a0,s2
    800034e6:	a17ff0ef          	jal	80002efc <brelse>
}
    800034ea:	60e2                	ld	ra,24(sp)
    800034ec:	6442                	ld	s0,16(sp)
    800034ee:	64a2                	ld	s1,8(sp)
    800034f0:	6902                	ld	s2,0(sp)
    800034f2:	6105                	addi	sp,sp,32
    800034f4:	8082                	ret

00000000800034f6 <idup>:
{
    800034f6:	1101                	addi	sp,sp,-32
    800034f8:	ec06                	sd	ra,24(sp)
    800034fa:	e822                	sd	s0,16(sp)
    800034fc:	e426                	sd	s1,8(sp)
    800034fe:	1000                	addi	s0,sp,32
    80003500:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003502:	0001e517          	auipc	a0,0x1e
    80003506:	8d650513          	addi	a0,a0,-1834 # 80020dd8 <itable>
    8000350a:	eeafd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    8000350e:	449c                	lw	a5,8(s1)
    80003510:	2785                	addiw	a5,a5,1
    80003512:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003514:	0001e517          	auipc	a0,0x1e
    80003518:	8c450513          	addi	a0,a0,-1852 # 80020dd8 <itable>
    8000351c:	f70fd0ef          	jal	80000c8c <release>
}
    80003520:	8526                	mv	a0,s1
    80003522:	60e2                	ld	ra,24(sp)
    80003524:	6442                	ld	s0,16(sp)
    80003526:	64a2                	ld	s1,8(sp)
    80003528:	6105                	addi	sp,sp,32
    8000352a:	8082                	ret

000000008000352c <ilock>:
{
    8000352c:	1101                	addi	sp,sp,-32
    8000352e:	ec06                	sd	ra,24(sp)
    80003530:	e822                	sd	s0,16(sp)
    80003532:	e426                	sd	s1,8(sp)
    80003534:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003536:	cd19                	beqz	a0,80003554 <ilock+0x28>
    80003538:	84aa                	mv	s1,a0
    8000353a:	451c                	lw	a5,8(a0)
    8000353c:	00f05c63          	blez	a5,80003554 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003540:	0541                	addi	a0,a0,16
    80003542:	30b000ef          	jal	8000404c <acquiresleep>
  if(ip->valid == 0){
    80003546:	40bc                	lw	a5,64(s1)
    80003548:	cf89                	beqz	a5,80003562 <ilock+0x36>
}
    8000354a:	60e2                	ld	ra,24(sp)
    8000354c:	6442                	ld	s0,16(sp)
    8000354e:	64a2                	ld	s1,8(sp)
    80003550:	6105                	addi	sp,sp,32
    80003552:	8082                	ret
    80003554:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003556:	00004517          	auipc	a0,0x4
    8000355a:	fda50513          	addi	a0,a0,-38 # 80007530 <etext+0x530>
    8000355e:	a36fd0ef          	jal	80000794 <panic>
    80003562:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003564:	40dc                	lw	a5,4(s1)
    80003566:	0047d79b          	srliw	a5,a5,0x4
    8000356a:	0001e597          	auipc	a1,0x1e
    8000356e:	8665a583          	lw	a1,-1946(a1) # 80020dd0 <sb+0x18>
    80003572:	9dbd                	addw	a1,a1,a5
    80003574:	4088                	lw	a0,0(s1)
    80003576:	87fff0ef          	jal	80002df4 <bread>
    8000357a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000357c:	05850593          	addi	a1,a0,88
    80003580:	40dc                	lw	a5,4(s1)
    80003582:	8bbd                	andi	a5,a5,15
    80003584:	079a                	slli	a5,a5,0x6
    80003586:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003588:	00059783          	lh	a5,0(a1)
    8000358c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003590:	00259783          	lh	a5,2(a1)
    80003594:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003598:	00459783          	lh	a5,4(a1)
    8000359c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800035a0:	00659783          	lh	a5,6(a1)
    800035a4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800035a8:	459c                	lw	a5,8(a1)
    800035aa:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800035ac:	03400613          	li	a2,52
    800035b0:	05b1                	addi	a1,a1,12
    800035b2:	05048513          	addi	a0,s1,80
    800035b6:	f6efd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    800035ba:	854a                	mv	a0,s2
    800035bc:	941ff0ef          	jal	80002efc <brelse>
    ip->valid = 1;
    800035c0:	4785                	li	a5,1
    800035c2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800035c4:	04449783          	lh	a5,68(s1)
    800035c8:	c399                	beqz	a5,800035ce <ilock+0xa2>
    800035ca:	6902                	ld	s2,0(sp)
    800035cc:	bfbd                	j	8000354a <ilock+0x1e>
      panic("ilock: no type");
    800035ce:	00004517          	auipc	a0,0x4
    800035d2:	f6a50513          	addi	a0,a0,-150 # 80007538 <etext+0x538>
    800035d6:	9befd0ef          	jal	80000794 <panic>

00000000800035da <iunlock>:
{
    800035da:	1101                	addi	sp,sp,-32
    800035dc:	ec06                	sd	ra,24(sp)
    800035de:	e822                	sd	s0,16(sp)
    800035e0:	e426                	sd	s1,8(sp)
    800035e2:	e04a                	sd	s2,0(sp)
    800035e4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800035e6:	c505                	beqz	a0,8000360e <iunlock+0x34>
    800035e8:	84aa                	mv	s1,a0
    800035ea:	01050913          	addi	s2,a0,16
    800035ee:	854a                	mv	a0,s2
    800035f0:	2db000ef          	jal	800040ca <holdingsleep>
    800035f4:	cd09                	beqz	a0,8000360e <iunlock+0x34>
    800035f6:	449c                	lw	a5,8(s1)
    800035f8:	00f05b63          	blez	a5,8000360e <iunlock+0x34>
  releasesleep(&ip->lock);
    800035fc:	854a                	mv	a0,s2
    800035fe:	295000ef          	jal	80004092 <releasesleep>
}
    80003602:	60e2                	ld	ra,24(sp)
    80003604:	6442                	ld	s0,16(sp)
    80003606:	64a2                	ld	s1,8(sp)
    80003608:	6902                	ld	s2,0(sp)
    8000360a:	6105                	addi	sp,sp,32
    8000360c:	8082                	ret
    panic("iunlock");
    8000360e:	00004517          	auipc	a0,0x4
    80003612:	f3a50513          	addi	a0,a0,-198 # 80007548 <etext+0x548>
    80003616:	97efd0ef          	jal	80000794 <panic>

000000008000361a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000361a:	7179                	addi	sp,sp,-48
    8000361c:	f406                	sd	ra,40(sp)
    8000361e:	f022                	sd	s0,32(sp)
    80003620:	ec26                	sd	s1,24(sp)
    80003622:	e84a                	sd	s2,16(sp)
    80003624:	e44e                	sd	s3,8(sp)
    80003626:	1800                	addi	s0,sp,48
    80003628:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000362a:	05050493          	addi	s1,a0,80
    8000362e:	08050913          	addi	s2,a0,128
    80003632:	a021                	j	8000363a <itrunc+0x20>
    80003634:	0491                	addi	s1,s1,4
    80003636:	01248b63          	beq	s1,s2,8000364c <itrunc+0x32>
    if(ip->addrs[i]){
    8000363a:	408c                	lw	a1,0(s1)
    8000363c:	dde5                	beqz	a1,80003634 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000363e:	0009a503          	lw	a0,0(s3)
    80003642:	9abff0ef          	jal	80002fec <bfree>
      ip->addrs[i] = 0;
    80003646:	0004a023          	sw	zero,0(s1)
    8000364a:	b7ed                	j	80003634 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000364c:	0809a583          	lw	a1,128(s3)
    80003650:	ed89                	bnez	a1,8000366a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003652:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003656:	854e                	mv	a0,s3
    80003658:	e21ff0ef          	jal	80003478 <iupdate>
}
    8000365c:	70a2                	ld	ra,40(sp)
    8000365e:	7402                	ld	s0,32(sp)
    80003660:	64e2                	ld	s1,24(sp)
    80003662:	6942                	ld	s2,16(sp)
    80003664:	69a2                	ld	s3,8(sp)
    80003666:	6145                	addi	sp,sp,48
    80003668:	8082                	ret
    8000366a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000366c:	0009a503          	lw	a0,0(s3)
    80003670:	f84ff0ef          	jal	80002df4 <bread>
    80003674:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003676:	05850493          	addi	s1,a0,88
    8000367a:	45850913          	addi	s2,a0,1112
    8000367e:	a021                	j	80003686 <itrunc+0x6c>
    80003680:	0491                	addi	s1,s1,4
    80003682:	01248963          	beq	s1,s2,80003694 <itrunc+0x7a>
      if(a[j])
    80003686:	408c                	lw	a1,0(s1)
    80003688:	dde5                	beqz	a1,80003680 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000368a:	0009a503          	lw	a0,0(s3)
    8000368e:	95fff0ef          	jal	80002fec <bfree>
    80003692:	b7fd                	j	80003680 <itrunc+0x66>
    brelse(bp);
    80003694:	8552                	mv	a0,s4
    80003696:	867ff0ef          	jal	80002efc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000369a:	0809a583          	lw	a1,128(s3)
    8000369e:	0009a503          	lw	a0,0(s3)
    800036a2:	94bff0ef          	jal	80002fec <bfree>
    ip->addrs[NDIRECT] = 0;
    800036a6:	0809a023          	sw	zero,128(s3)
    800036aa:	6a02                	ld	s4,0(sp)
    800036ac:	b75d                	j	80003652 <itrunc+0x38>

00000000800036ae <iput>:
{
    800036ae:	1101                	addi	sp,sp,-32
    800036b0:	ec06                	sd	ra,24(sp)
    800036b2:	e822                	sd	s0,16(sp)
    800036b4:	e426                	sd	s1,8(sp)
    800036b6:	1000                	addi	s0,sp,32
    800036b8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800036ba:	0001d517          	auipc	a0,0x1d
    800036be:	71e50513          	addi	a0,a0,1822 # 80020dd8 <itable>
    800036c2:	d32fd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800036c6:	4498                	lw	a4,8(s1)
    800036c8:	4785                	li	a5,1
    800036ca:	02f70063          	beq	a4,a5,800036ea <iput+0x3c>
  ip->ref--;
    800036ce:	449c                	lw	a5,8(s1)
    800036d0:	37fd                	addiw	a5,a5,-1
    800036d2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800036d4:	0001d517          	auipc	a0,0x1d
    800036d8:	70450513          	addi	a0,a0,1796 # 80020dd8 <itable>
    800036dc:	db0fd0ef          	jal	80000c8c <release>
}
    800036e0:	60e2                	ld	ra,24(sp)
    800036e2:	6442                	ld	s0,16(sp)
    800036e4:	64a2                	ld	s1,8(sp)
    800036e6:	6105                	addi	sp,sp,32
    800036e8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800036ea:	40bc                	lw	a5,64(s1)
    800036ec:	d3ed                	beqz	a5,800036ce <iput+0x20>
    800036ee:	04a49783          	lh	a5,74(s1)
    800036f2:	fff1                	bnez	a5,800036ce <iput+0x20>
    800036f4:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800036f6:	01048913          	addi	s2,s1,16
    800036fa:	854a                	mv	a0,s2
    800036fc:	151000ef          	jal	8000404c <acquiresleep>
    release(&itable.lock);
    80003700:	0001d517          	auipc	a0,0x1d
    80003704:	6d850513          	addi	a0,a0,1752 # 80020dd8 <itable>
    80003708:	d84fd0ef          	jal	80000c8c <release>
    itrunc(ip);
    8000370c:	8526                	mv	a0,s1
    8000370e:	f0dff0ef          	jal	8000361a <itrunc>
    ip->type = 0;
    80003712:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003716:	8526                	mv	a0,s1
    80003718:	d61ff0ef          	jal	80003478 <iupdate>
    ip->valid = 0;
    8000371c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003720:	854a                	mv	a0,s2
    80003722:	171000ef          	jal	80004092 <releasesleep>
    acquire(&itable.lock);
    80003726:	0001d517          	auipc	a0,0x1d
    8000372a:	6b250513          	addi	a0,a0,1714 # 80020dd8 <itable>
    8000372e:	cc6fd0ef          	jal	80000bf4 <acquire>
    80003732:	6902                	ld	s2,0(sp)
    80003734:	bf69                	j	800036ce <iput+0x20>

0000000080003736 <iunlockput>:
{
    80003736:	1101                	addi	sp,sp,-32
    80003738:	ec06                	sd	ra,24(sp)
    8000373a:	e822                	sd	s0,16(sp)
    8000373c:	e426                	sd	s1,8(sp)
    8000373e:	1000                	addi	s0,sp,32
    80003740:	84aa                	mv	s1,a0
  iunlock(ip);
    80003742:	e99ff0ef          	jal	800035da <iunlock>
  iput(ip);
    80003746:	8526                	mv	a0,s1
    80003748:	f67ff0ef          	jal	800036ae <iput>
}
    8000374c:	60e2                	ld	ra,24(sp)
    8000374e:	6442                	ld	s0,16(sp)
    80003750:	64a2                	ld	s1,8(sp)
    80003752:	6105                	addi	sp,sp,32
    80003754:	8082                	ret

0000000080003756 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003756:	1141                	addi	sp,sp,-16
    80003758:	e422                	sd	s0,8(sp)
    8000375a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000375c:	411c                	lw	a5,0(a0)
    8000375e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003760:	415c                	lw	a5,4(a0)
    80003762:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003764:	04451783          	lh	a5,68(a0)
    80003768:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000376c:	04a51783          	lh	a5,74(a0)
    80003770:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003774:	04c56783          	lwu	a5,76(a0)
    80003778:	e99c                	sd	a5,16(a1)
}
    8000377a:	6422                	ld	s0,8(sp)
    8000377c:	0141                	addi	sp,sp,16
    8000377e:	8082                	ret

0000000080003780 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003780:	457c                	lw	a5,76(a0)
    80003782:	0ed7eb63          	bltu	a5,a3,80003878 <readi+0xf8>
{
    80003786:	7159                	addi	sp,sp,-112
    80003788:	f486                	sd	ra,104(sp)
    8000378a:	f0a2                	sd	s0,96(sp)
    8000378c:	eca6                	sd	s1,88(sp)
    8000378e:	e0d2                	sd	s4,64(sp)
    80003790:	fc56                	sd	s5,56(sp)
    80003792:	f85a                	sd	s6,48(sp)
    80003794:	f45e                	sd	s7,40(sp)
    80003796:	1880                	addi	s0,sp,112
    80003798:	8b2a                	mv	s6,a0
    8000379a:	8bae                	mv	s7,a1
    8000379c:	8a32                	mv	s4,a2
    8000379e:	84b6                	mv	s1,a3
    800037a0:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800037a2:	9f35                	addw	a4,a4,a3
    return 0;
    800037a4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800037a6:	0cd76063          	bltu	a4,a3,80003866 <readi+0xe6>
    800037aa:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800037ac:	00e7f463          	bgeu	a5,a4,800037b4 <readi+0x34>
    n = ip->size - off;
    800037b0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800037b4:	080a8f63          	beqz	s5,80003852 <readi+0xd2>
    800037b8:	e8ca                	sd	s2,80(sp)
    800037ba:	f062                	sd	s8,32(sp)
    800037bc:	ec66                	sd	s9,24(sp)
    800037be:	e86a                	sd	s10,16(sp)
    800037c0:	e46e                	sd	s11,8(sp)
    800037c2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800037c4:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800037c8:	5c7d                	li	s8,-1
    800037ca:	a80d                	j	800037fc <readi+0x7c>
    800037cc:	020d1d93          	slli	s11,s10,0x20
    800037d0:	020ddd93          	srli	s11,s11,0x20
    800037d4:	05890613          	addi	a2,s2,88
    800037d8:	86ee                	mv	a3,s11
    800037da:	963a                	add	a2,a2,a4
    800037dc:	85d2                	mv	a1,s4
    800037de:	855e                	mv	a0,s7
    800037e0:	d67fe0ef          	jal	80002546 <either_copyout>
    800037e4:	05850763          	beq	a0,s8,80003832 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800037e8:	854a                	mv	a0,s2
    800037ea:	f12ff0ef          	jal	80002efc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800037ee:	013d09bb          	addw	s3,s10,s3
    800037f2:	009d04bb          	addw	s1,s10,s1
    800037f6:	9a6e                	add	s4,s4,s11
    800037f8:	0559f763          	bgeu	s3,s5,80003846 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800037fc:	00a4d59b          	srliw	a1,s1,0xa
    80003800:	855a                	mv	a0,s6
    80003802:	977ff0ef          	jal	80003178 <bmap>
    80003806:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000380a:	c5b1                	beqz	a1,80003856 <readi+0xd6>
    bp = bread(ip->dev, addr);
    8000380c:	000b2503          	lw	a0,0(s6)
    80003810:	de4ff0ef          	jal	80002df4 <bread>
    80003814:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003816:	3ff4f713          	andi	a4,s1,1023
    8000381a:	40ec87bb          	subw	a5,s9,a4
    8000381e:	413a86bb          	subw	a3,s5,s3
    80003822:	8d3e                	mv	s10,a5
    80003824:	2781                	sext.w	a5,a5
    80003826:	0006861b          	sext.w	a2,a3
    8000382a:	faf671e3          	bgeu	a2,a5,800037cc <readi+0x4c>
    8000382e:	8d36                	mv	s10,a3
    80003830:	bf71                	j	800037cc <readi+0x4c>
      brelse(bp);
    80003832:	854a                	mv	a0,s2
    80003834:	ec8ff0ef          	jal	80002efc <brelse>
      tot = -1;
    80003838:	59fd                	li	s3,-1
      break;
    8000383a:	6946                	ld	s2,80(sp)
    8000383c:	7c02                	ld	s8,32(sp)
    8000383e:	6ce2                	ld	s9,24(sp)
    80003840:	6d42                	ld	s10,16(sp)
    80003842:	6da2                	ld	s11,8(sp)
    80003844:	a831                	j	80003860 <readi+0xe0>
    80003846:	6946                	ld	s2,80(sp)
    80003848:	7c02                	ld	s8,32(sp)
    8000384a:	6ce2                	ld	s9,24(sp)
    8000384c:	6d42                	ld	s10,16(sp)
    8000384e:	6da2                	ld	s11,8(sp)
    80003850:	a801                	j	80003860 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003852:	89d6                	mv	s3,s5
    80003854:	a031                	j	80003860 <readi+0xe0>
    80003856:	6946                	ld	s2,80(sp)
    80003858:	7c02                	ld	s8,32(sp)
    8000385a:	6ce2                	ld	s9,24(sp)
    8000385c:	6d42                	ld	s10,16(sp)
    8000385e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003860:	0009851b          	sext.w	a0,s3
    80003864:	69a6                	ld	s3,72(sp)
}
    80003866:	70a6                	ld	ra,104(sp)
    80003868:	7406                	ld	s0,96(sp)
    8000386a:	64e6                	ld	s1,88(sp)
    8000386c:	6a06                	ld	s4,64(sp)
    8000386e:	7ae2                	ld	s5,56(sp)
    80003870:	7b42                	ld	s6,48(sp)
    80003872:	7ba2                	ld	s7,40(sp)
    80003874:	6165                	addi	sp,sp,112
    80003876:	8082                	ret
    return 0;
    80003878:	4501                	li	a0,0
}
    8000387a:	8082                	ret

000000008000387c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000387c:	457c                	lw	a5,76(a0)
    8000387e:	10d7e063          	bltu	a5,a3,8000397e <writei+0x102>
{
    80003882:	7159                	addi	sp,sp,-112
    80003884:	f486                	sd	ra,104(sp)
    80003886:	f0a2                	sd	s0,96(sp)
    80003888:	e8ca                	sd	s2,80(sp)
    8000388a:	e0d2                	sd	s4,64(sp)
    8000388c:	fc56                	sd	s5,56(sp)
    8000388e:	f85a                	sd	s6,48(sp)
    80003890:	f45e                	sd	s7,40(sp)
    80003892:	1880                	addi	s0,sp,112
    80003894:	8aaa                	mv	s5,a0
    80003896:	8bae                	mv	s7,a1
    80003898:	8a32                	mv	s4,a2
    8000389a:	8936                	mv	s2,a3
    8000389c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000389e:	00e687bb          	addw	a5,a3,a4
    800038a2:	0ed7e063          	bltu	a5,a3,80003982 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800038a6:	00043737          	lui	a4,0x43
    800038aa:	0cf76e63          	bltu	a4,a5,80003986 <writei+0x10a>
    800038ae:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800038b0:	0a0b0f63          	beqz	s6,8000396e <writei+0xf2>
    800038b4:	eca6                	sd	s1,88(sp)
    800038b6:	f062                	sd	s8,32(sp)
    800038b8:	ec66                	sd	s9,24(sp)
    800038ba:	e86a                	sd	s10,16(sp)
    800038bc:	e46e                	sd	s11,8(sp)
    800038be:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800038c0:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800038c4:	5c7d                	li	s8,-1
    800038c6:	a825                	j	800038fe <writei+0x82>
    800038c8:	020d1d93          	slli	s11,s10,0x20
    800038cc:	020ddd93          	srli	s11,s11,0x20
    800038d0:	05848513          	addi	a0,s1,88
    800038d4:	86ee                	mv	a3,s11
    800038d6:	8652                	mv	a2,s4
    800038d8:	85de                	mv	a1,s7
    800038da:	953a                	add	a0,a0,a4
    800038dc:	cb5fe0ef          	jal	80002590 <either_copyin>
    800038e0:	05850a63          	beq	a0,s8,80003934 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800038e4:	8526                	mv	a0,s1
    800038e6:	660000ef          	jal	80003f46 <log_write>
    brelse(bp);
    800038ea:	8526                	mv	a0,s1
    800038ec:	e10ff0ef          	jal	80002efc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800038f0:	013d09bb          	addw	s3,s10,s3
    800038f4:	012d093b          	addw	s2,s10,s2
    800038f8:	9a6e                	add	s4,s4,s11
    800038fa:	0569f063          	bgeu	s3,s6,8000393a <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800038fe:	00a9559b          	srliw	a1,s2,0xa
    80003902:	8556                	mv	a0,s5
    80003904:	875ff0ef          	jal	80003178 <bmap>
    80003908:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000390c:	c59d                	beqz	a1,8000393a <writei+0xbe>
    bp = bread(ip->dev, addr);
    8000390e:	000aa503          	lw	a0,0(s5)
    80003912:	ce2ff0ef          	jal	80002df4 <bread>
    80003916:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003918:	3ff97713          	andi	a4,s2,1023
    8000391c:	40ec87bb          	subw	a5,s9,a4
    80003920:	413b06bb          	subw	a3,s6,s3
    80003924:	8d3e                	mv	s10,a5
    80003926:	2781                	sext.w	a5,a5
    80003928:	0006861b          	sext.w	a2,a3
    8000392c:	f8f67ee3          	bgeu	a2,a5,800038c8 <writei+0x4c>
    80003930:	8d36                	mv	s10,a3
    80003932:	bf59                	j	800038c8 <writei+0x4c>
      brelse(bp);
    80003934:	8526                	mv	a0,s1
    80003936:	dc6ff0ef          	jal	80002efc <brelse>
  }

  if(off > ip->size)
    8000393a:	04caa783          	lw	a5,76(s5)
    8000393e:	0327fa63          	bgeu	a5,s2,80003972 <writei+0xf6>
    ip->size = off;
    80003942:	052aa623          	sw	s2,76(s5)
    80003946:	64e6                	ld	s1,88(sp)
    80003948:	7c02                	ld	s8,32(sp)
    8000394a:	6ce2                	ld	s9,24(sp)
    8000394c:	6d42                	ld	s10,16(sp)
    8000394e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003950:	8556                	mv	a0,s5
    80003952:	b27ff0ef          	jal	80003478 <iupdate>

  return tot;
    80003956:	0009851b          	sext.w	a0,s3
    8000395a:	69a6                	ld	s3,72(sp)
}
    8000395c:	70a6                	ld	ra,104(sp)
    8000395e:	7406                	ld	s0,96(sp)
    80003960:	6946                	ld	s2,80(sp)
    80003962:	6a06                	ld	s4,64(sp)
    80003964:	7ae2                	ld	s5,56(sp)
    80003966:	7b42                	ld	s6,48(sp)
    80003968:	7ba2                	ld	s7,40(sp)
    8000396a:	6165                	addi	sp,sp,112
    8000396c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000396e:	89da                	mv	s3,s6
    80003970:	b7c5                	j	80003950 <writei+0xd4>
    80003972:	64e6                	ld	s1,88(sp)
    80003974:	7c02                	ld	s8,32(sp)
    80003976:	6ce2                	ld	s9,24(sp)
    80003978:	6d42                	ld	s10,16(sp)
    8000397a:	6da2                	ld	s11,8(sp)
    8000397c:	bfd1                	j	80003950 <writei+0xd4>
    return -1;
    8000397e:	557d                	li	a0,-1
}
    80003980:	8082                	ret
    return -1;
    80003982:	557d                	li	a0,-1
    80003984:	bfe1                	j	8000395c <writei+0xe0>
    return -1;
    80003986:	557d                	li	a0,-1
    80003988:	bfd1                	j	8000395c <writei+0xe0>

000000008000398a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000398a:	1141                	addi	sp,sp,-16
    8000398c:	e406                	sd	ra,8(sp)
    8000398e:	e022                	sd	s0,0(sp)
    80003990:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003992:	4639                	li	a2,14
    80003994:	c00fd0ef          	jal	80000d94 <strncmp>
}
    80003998:	60a2                	ld	ra,8(sp)
    8000399a:	6402                	ld	s0,0(sp)
    8000399c:	0141                	addi	sp,sp,16
    8000399e:	8082                	ret

00000000800039a0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800039a0:	7139                	addi	sp,sp,-64
    800039a2:	fc06                	sd	ra,56(sp)
    800039a4:	f822                	sd	s0,48(sp)
    800039a6:	f426                	sd	s1,40(sp)
    800039a8:	f04a                	sd	s2,32(sp)
    800039aa:	ec4e                	sd	s3,24(sp)
    800039ac:	e852                	sd	s4,16(sp)
    800039ae:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800039b0:	04451703          	lh	a4,68(a0)
    800039b4:	4785                	li	a5,1
    800039b6:	00f71a63          	bne	a4,a5,800039ca <dirlookup+0x2a>
    800039ba:	892a                	mv	s2,a0
    800039bc:	89ae                	mv	s3,a1
    800039be:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800039c0:	457c                	lw	a5,76(a0)
    800039c2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800039c4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039c6:	e39d                	bnez	a5,800039ec <dirlookup+0x4c>
    800039c8:	a095                	j	80003a2c <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800039ca:	00004517          	auipc	a0,0x4
    800039ce:	b8650513          	addi	a0,a0,-1146 # 80007550 <etext+0x550>
    800039d2:	dc3fc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    800039d6:	00004517          	auipc	a0,0x4
    800039da:	b9250513          	addi	a0,a0,-1134 # 80007568 <etext+0x568>
    800039de:	db7fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039e2:	24c1                	addiw	s1,s1,16
    800039e4:	04c92783          	lw	a5,76(s2)
    800039e8:	04f4f163          	bgeu	s1,a5,80003a2a <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039ec:	4741                	li	a4,16
    800039ee:	86a6                	mv	a3,s1
    800039f0:	fc040613          	addi	a2,s0,-64
    800039f4:	4581                	li	a1,0
    800039f6:	854a                	mv	a0,s2
    800039f8:	d89ff0ef          	jal	80003780 <readi>
    800039fc:	47c1                	li	a5,16
    800039fe:	fcf51ce3          	bne	a0,a5,800039d6 <dirlookup+0x36>
    if(de.inum == 0)
    80003a02:	fc045783          	lhu	a5,-64(s0)
    80003a06:	dff1                	beqz	a5,800039e2 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003a08:	fc240593          	addi	a1,s0,-62
    80003a0c:	854e                	mv	a0,s3
    80003a0e:	f7dff0ef          	jal	8000398a <namecmp>
    80003a12:	f961                	bnez	a0,800039e2 <dirlookup+0x42>
      if(poff)
    80003a14:	000a0463          	beqz	s4,80003a1c <dirlookup+0x7c>
        *poff = off;
    80003a18:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003a1c:	fc045583          	lhu	a1,-64(s0)
    80003a20:	00092503          	lw	a0,0(s2)
    80003a24:	829ff0ef          	jal	8000324c <iget>
    80003a28:	a011                	j	80003a2c <dirlookup+0x8c>
  return 0;
    80003a2a:	4501                	li	a0,0
}
    80003a2c:	70e2                	ld	ra,56(sp)
    80003a2e:	7442                	ld	s0,48(sp)
    80003a30:	74a2                	ld	s1,40(sp)
    80003a32:	7902                	ld	s2,32(sp)
    80003a34:	69e2                	ld	s3,24(sp)
    80003a36:	6a42                	ld	s4,16(sp)
    80003a38:	6121                	addi	sp,sp,64
    80003a3a:	8082                	ret

0000000080003a3c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003a3c:	711d                	addi	sp,sp,-96
    80003a3e:	ec86                	sd	ra,88(sp)
    80003a40:	e8a2                	sd	s0,80(sp)
    80003a42:	e4a6                	sd	s1,72(sp)
    80003a44:	e0ca                	sd	s2,64(sp)
    80003a46:	fc4e                	sd	s3,56(sp)
    80003a48:	f852                	sd	s4,48(sp)
    80003a4a:	f456                	sd	s5,40(sp)
    80003a4c:	f05a                	sd	s6,32(sp)
    80003a4e:	ec5e                	sd	s7,24(sp)
    80003a50:	e862                	sd	s8,16(sp)
    80003a52:	e466                	sd	s9,8(sp)
    80003a54:	1080                	addi	s0,sp,96
    80003a56:	84aa                	mv	s1,a0
    80003a58:	8b2e                	mv	s6,a1
    80003a5a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003a5c:	00054703          	lbu	a4,0(a0)
    80003a60:	02f00793          	li	a5,47
    80003a64:	00f70e63          	beq	a4,a5,80003a80 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003a68:	912fe0ef          	jal	80001b7a <myproc>
    80003a6c:	16053503          	ld	a0,352(a0)
    80003a70:	a87ff0ef          	jal	800034f6 <idup>
    80003a74:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003a76:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003a7a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003a7c:	4b85                	li	s7,1
    80003a7e:	a871                	j	80003b1a <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003a80:	4585                	li	a1,1
    80003a82:	4505                	li	a0,1
    80003a84:	fc8ff0ef          	jal	8000324c <iget>
    80003a88:	8a2a                	mv	s4,a0
    80003a8a:	b7f5                	j	80003a76 <namex+0x3a>
      iunlockput(ip);
    80003a8c:	8552                	mv	a0,s4
    80003a8e:	ca9ff0ef          	jal	80003736 <iunlockput>
      return 0;
    80003a92:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003a94:	8552                	mv	a0,s4
    80003a96:	60e6                	ld	ra,88(sp)
    80003a98:	6446                	ld	s0,80(sp)
    80003a9a:	64a6                	ld	s1,72(sp)
    80003a9c:	6906                	ld	s2,64(sp)
    80003a9e:	79e2                	ld	s3,56(sp)
    80003aa0:	7a42                	ld	s4,48(sp)
    80003aa2:	7aa2                	ld	s5,40(sp)
    80003aa4:	7b02                	ld	s6,32(sp)
    80003aa6:	6be2                	ld	s7,24(sp)
    80003aa8:	6c42                	ld	s8,16(sp)
    80003aaa:	6ca2                	ld	s9,8(sp)
    80003aac:	6125                	addi	sp,sp,96
    80003aae:	8082                	ret
      iunlock(ip);
    80003ab0:	8552                	mv	a0,s4
    80003ab2:	b29ff0ef          	jal	800035da <iunlock>
      return ip;
    80003ab6:	bff9                	j	80003a94 <namex+0x58>
      iunlockput(ip);
    80003ab8:	8552                	mv	a0,s4
    80003aba:	c7dff0ef          	jal	80003736 <iunlockput>
      return 0;
    80003abe:	8a4e                	mv	s4,s3
    80003ac0:	bfd1                	j	80003a94 <namex+0x58>
  len = path - s;
    80003ac2:	40998633          	sub	a2,s3,s1
    80003ac6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003aca:	099c5063          	bge	s8,s9,80003b4a <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003ace:	4639                	li	a2,14
    80003ad0:	85a6                	mv	a1,s1
    80003ad2:	8556                	mv	a0,s5
    80003ad4:	a50fd0ef          	jal	80000d24 <memmove>
    80003ad8:	84ce                	mv	s1,s3
  while(*path == '/')
    80003ada:	0004c783          	lbu	a5,0(s1)
    80003ade:	01279763          	bne	a5,s2,80003aec <namex+0xb0>
    path++;
    80003ae2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003ae4:	0004c783          	lbu	a5,0(s1)
    80003ae8:	ff278de3          	beq	a5,s2,80003ae2 <namex+0xa6>
    ilock(ip);
    80003aec:	8552                	mv	a0,s4
    80003aee:	a3fff0ef          	jal	8000352c <ilock>
    if(ip->type != T_DIR){
    80003af2:	044a1783          	lh	a5,68(s4)
    80003af6:	f9779be3          	bne	a5,s7,80003a8c <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003afa:	000b0563          	beqz	s6,80003b04 <namex+0xc8>
    80003afe:	0004c783          	lbu	a5,0(s1)
    80003b02:	d7dd                	beqz	a5,80003ab0 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003b04:	4601                	li	a2,0
    80003b06:	85d6                	mv	a1,s5
    80003b08:	8552                	mv	a0,s4
    80003b0a:	e97ff0ef          	jal	800039a0 <dirlookup>
    80003b0e:	89aa                	mv	s3,a0
    80003b10:	d545                	beqz	a0,80003ab8 <namex+0x7c>
    iunlockput(ip);
    80003b12:	8552                	mv	a0,s4
    80003b14:	c23ff0ef          	jal	80003736 <iunlockput>
    ip = next;
    80003b18:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003b1a:	0004c783          	lbu	a5,0(s1)
    80003b1e:	01279763          	bne	a5,s2,80003b2c <namex+0xf0>
    path++;
    80003b22:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003b24:	0004c783          	lbu	a5,0(s1)
    80003b28:	ff278de3          	beq	a5,s2,80003b22 <namex+0xe6>
  if(*path == 0)
    80003b2c:	cb8d                	beqz	a5,80003b5e <namex+0x122>
  while(*path != '/' && *path != 0)
    80003b2e:	0004c783          	lbu	a5,0(s1)
    80003b32:	89a6                	mv	s3,s1
  len = path - s;
    80003b34:	4c81                	li	s9,0
    80003b36:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003b38:	01278963          	beq	a5,s2,80003b4a <namex+0x10e>
    80003b3c:	d3d9                	beqz	a5,80003ac2 <namex+0x86>
    path++;
    80003b3e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003b40:	0009c783          	lbu	a5,0(s3)
    80003b44:	ff279ce3          	bne	a5,s2,80003b3c <namex+0x100>
    80003b48:	bfad                	j	80003ac2 <namex+0x86>
    memmove(name, s, len);
    80003b4a:	2601                	sext.w	a2,a2
    80003b4c:	85a6                	mv	a1,s1
    80003b4e:	8556                	mv	a0,s5
    80003b50:	9d4fd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    80003b54:	9cd6                	add	s9,s9,s5
    80003b56:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003b5a:	84ce                	mv	s1,s3
    80003b5c:	bfbd                	j	80003ada <namex+0x9e>
  if(nameiparent){
    80003b5e:	f20b0be3          	beqz	s6,80003a94 <namex+0x58>
    iput(ip);
    80003b62:	8552                	mv	a0,s4
    80003b64:	b4bff0ef          	jal	800036ae <iput>
    return 0;
    80003b68:	4a01                	li	s4,0
    80003b6a:	b72d                	j	80003a94 <namex+0x58>

0000000080003b6c <dirlink>:
{
    80003b6c:	7139                	addi	sp,sp,-64
    80003b6e:	fc06                	sd	ra,56(sp)
    80003b70:	f822                	sd	s0,48(sp)
    80003b72:	f04a                	sd	s2,32(sp)
    80003b74:	ec4e                	sd	s3,24(sp)
    80003b76:	e852                	sd	s4,16(sp)
    80003b78:	0080                	addi	s0,sp,64
    80003b7a:	892a                	mv	s2,a0
    80003b7c:	8a2e                	mv	s4,a1
    80003b7e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003b80:	4601                	li	a2,0
    80003b82:	e1fff0ef          	jal	800039a0 <dirlookup>
    80003b86:	e535                	bnez	a0,80003bf2 <dirlink+0x86>
    80003b88:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b8a:	04c92483          	lw	s1,76(s2)
    80003b8e:	c48d                	beqz	s1,80003bb8 <dirlink+0x4c>
    80003b90:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b92:	4741                	li	a4,16
    80003b94:	86a6                	mv	a3,s1
    80003b96:	fc040613          	addi	a2,s0,-64
    80003b9a:	4581                	li	a1,0
    80003b9c:	854a                	mv	a0,s2
    80003b9e:	be3ff0ef          	jal	80003780 <readi>
    80003ba2:	47c1                	li	a5,16
    80003ba4:	04f51b63          	bne	a0,a5,80003bfa <dirlink+0x8e>
    if(de.inum == 0)
    80003ba8:	fc045783          	lhu	a5,-64(s0)
    80003bac:	c791                	beqz	a5,80003bb8 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bae:	24c1                	addiw	s1,s1,16
    80003bb0:	04c92783          	lw	a5,76(s2)
    80003bb4:	fcf4efe3          	bltu	s1,a5,80003b92 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003bb8:	4639                	li	a2,14
    80003bba:	85d2                	mv	a1,s4
    80003bbc:	fc240513          	addi	a0,s0,-62
    80003bc0:	a0afd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003bc4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bc8:	4741                	li	a4,16
    80003bca:	86a6                	mv	a3,s1
    80003bcc:	fc040613          	addi	a2,s0,-64
    80003bd0:	4581                	li	a1,0
    80003bd2:	854a                	mv	a0,s2
    80003bd4:	ca9ff0ef          	jal	8000387c <writei>
    80003bd8:	1541                	addi	a0,a0,-16
    80003bda:	00a03533          	snez	a0,a0
    80003bde:	40a00533          	neg	a0,a0
    80003be2:	74a2                	ld	s1,40(sp)
}
    80003be4:	70e2                	ld	ra,56(sp)
    80003be6:	7442                	ld	s0,48(sp)
    80003be8:	7902                	ld	s2,32(sp)
    80003bea:	69e2                	ld	s3,24(sp)
    80003bec:	6a42                	ld	s4,16(sp)
    80003bee:	6121                	addi	sp,sp,64
    80003bf0:	8082                	ret
    iput(ip);
    80003bf2:	abdff0ef          	jal	800036ae <iput>
    return -1;
    80003bf6:	557d                	li	a0,-1
    80003bf8:	b7f5                	j	80003be4 <dirlink+0x78>
      panic("dirlink read");
    80003bfa:	00004517          	auipc	a0,0x4
    80003bfe:	97e50513          	addi	a0,a0,-1666 # 80007578 <etext+0x578>
    80003c02:	b93fc0ef          	jal	80000794 <panic>

0000000080003c06 <namei>:

struct inode*
namei(char *path)
{
    80003c06:	1101                	addi	sp,sp,-32
    80003c08:	ec06                	sd	ra,24(sp)
    80003c0a:	e822                	sd	s0,16(sp)
    80003c0c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003c0e:	fe040613          	addi	a2,s0,-32
    80003c12:	4581                	li	a1,0
    80003c14:	e29ff0ef          	jal	80003a3c <namex>
}
    80003c18:	60e2                	ld	ra,24(sp)
    80003c1a:	6442                	ld	s0,16(sp)
    80003c1c:	6105                	addi	sp,sp,32
    80003c1e:	8082                	ret

0000000080003c20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003c20:	1141                	addi	sp,sp,-16
    80003c22:	e406                	sd	ra,8(sp)
    80003c24:	e022                	sd	s0,0(sp)
    80003c26:	0800                	addi	s0,sp,16
    80003c28:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003c2a:	4585                	li	a1,1
    80003c2c:	e11ff0ef          	jal	80003a3c <namex>
}
    80003c30:	60a2                	ld	ra,8(sp)
    80003c32:	6402                	ld	s0,0(sp)
    80003c34:	0141                	addi	sp,sp,16
    80003c36:	8082                	ret

0000000080003c38 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003c38:	1101                	addi	sp,sp,-32
    80003c3a:	ec06                	sd	ra,24(sp)
    80003c3c:	e822                	sd	s0,16(sp)
    80003c3e:	e426                	sd	s1,8(sp)
    80003c40:	e04a                	sd	s2,0(sp)
    80003c42:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003c44:	0001f917          	auipc	s2,0x1f
    80003c48:	c3c90913          	addi	s2,s2,-964 # 80022880 <log>
    80003c4c:	01892583          	lw	a1,24(s2)
    80003c50:	02892503          	lw	a0,40(s2)
    80003c54:	9a0ff0ef          	jal	80002df4 <bread>
    80003c58:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003c5a:	02c92603          	lw	a2,44(s2)
    80003c5e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003c60:	00c05f63          	blez	a2,80003c7e <write_head+0x46>
    80003c64:	0001f717          	auipc	a4,0x1f
    80003c68:	c4c70713          	addi	a4,a4,-948 # 800228b0 <log+0x30>
    80003c6c:	87aa                	mv	a5,a0
    80003c6e:	060a                	slli	a2,a2,0x2
    80003c70:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003c72:	4314                	lw	a3,0(a4)
    80003c74:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003c76:	0711                	addi	a4,a4,4
    80003c78:	0791                	addi	a5,a5,4
    80003c7a:	fec79ce3          	bne	a5,a2,80003c72 <write_head+0x3a>
  }
  bwrite(buf);
    80003c7e:	8526                	mv	a0,s1
    80003c80:	a4aff0ef          	jal	80002eca <bwrite>
  brelse(buf);
    80003c84:	8526                	mv	a0,s1
    80003c86:	a76ff0ef          	jal	80002efc <brelse>
}
    80003c8a:	60e2                	ld	ra,24(sp)
    80003c8c:	6442                	ld	s0,16(sp)
    80003c8e:	64a2                	ld	s1,8(sp)
    80003c90:	6902                	ld	s2,0(sp)
    80003c92:	6105                	addi	sp,sp,32
    80003c94:	8082                	ret

0000000080003c96 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c96:	0001f797          	auipc	a5,0x1f
    80003c9a:	c167a783          	lw	a5,-1002(a5) # 800228ac <log+0x2c>
    80003c9e:	08f05f63          	blez	a5,80003d3c <install_trans+0xa6>
{
    80003ca2:	7139                	addi	sp,sp,-64
    80003ca4:	fc06                	sd	ra,56(sp)
    80003ca6:	f822                	sd	s0,48(sp)
    80003ca8:	f426                	sd	s1,40(sp)
    80003caa:	f04a                	sd	s2,32(sp)
    80003cac:	ec4e                	sd	s3,24(sp)
    80003cae:	e852                	sd	s4,16(sp)
    80003cb0:	e456                	sd	s5,8(sp)
    80003cb2:	e05a                	sd	s6,0(sp)
    80003cb4:	0080                	addi	s0,sp,64
    80003cb6:	8b2a                	mv	s6,a0
    80003cb8:	0001fa97          	auipc	s5,0x1f
    80003cbc:	bf8a8a93          	addi	s5,s5,-1032 # 800228b0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cc0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003cc2:	0001f997          	auipc	s3,0x1f
    80003cc6:	bbe98993          	addi	s3,s3,-1090 # 80022880 <log>
    80003cca:	a829                	j	80003ce4 <install_trans+0x4e>
    brelse(lbuf);
    80003ccc:	854a                	mv	a0,s2
    80003cce:	a2eff0ef          	jal	80002efc <brelse>
    brelse(dbuf);
    80003cd2:	8526                	mv	a0,s1
    80003cd4:	a28ff0ef          	jal	80002efc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cd8:	2a05                	addiw	s4,s4,1
    80003cda:	0a91                	addi	s5,s5,4
    80003cdc:	02c9a783          	lw	a5,44(s3)
    80003ce0:	04fa5463          	bge	s4,a5,80003d28 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003ce4:	0189a583          	lw	a1,24(s3)
    80003ce8:	014585bb          	addw	a1,a1,s4
    80003cec:	2585                	addiw	a1,a1,1
    80003cee:	0289a503          	lw	a0,40(s3)
    80003cf2:	902ff0ef          	jal	80002df4 <bread>
    80003cf6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003cf8:	000aa583          	lw	a1,0(s5)
    80003cfc:	0289a503          	lw	a0,40(s3)
    80003d00:	8f4ff0ef          	jal	80002df4 <bread>
    80003d04:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003d06:	40000613          	li	a2,1024
    80003d0a:	05890593          	addi	a1,s2,88
    80003d0e:	05850513          	addi	a0,a0,88
    80003d12:	812fd0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003d16:	8526                	mv	a0,s1
    80003d18:	9b2ff0ef          	jal	80002eca <bwrite>
    if(recovering == 0)
    80003d1c:	fa0b18e3          	bnez	s6,80003ccc <install_trans+0x36>
      bunpin(dbuf);
    80003d20:	8526                	mv	a0,s1
    80003d22:	a96ff0ef          	jal	80002fb8 <bunpin>
    80003d26:	b75d                	j	80003ccc <install_trans+0x36>
}
    80003d28:	70e2                	ld	ra,56(sp)
    80003d2a:	7442                	ld	s0,48(sp)
    80003d2c:	74a2                	ld	s1,40(sp)
    80003d2e:	7902                	ld	s2,32(sp)
    80003d30:	69e2                	ld	s3,24(sp)
    80003d32:	6a42                	ld	s4,16(sp)
    80003d34:	6aa2                	ld	s5,8(sp)
    80003d36:	6b02                	ld	s6,0(sp)
    80003d38:	6121                	addi	sp,sp,64
    80003d3a:	8082                	ret
    80003d3c:	8082                	ret

0000000080003d3e <initlog>:
{
    80003d3e:	7179                	addi	sp,sp,-48
    80003d40:	f406                	sd	ra,40(sp)
    80003d42:	f022                	sd	s0,32(sp)
    80003d44:	ec26                	sd	s1,24(sp)
    80003d46:	e84a                	sd	s2,16(sp)
    80003d48:	e44e                	sd	s3,8(sp)
    80003d4a:	1800                	addi	s0,sp,48
    80003d4c:	892a                	mv	s2,a0
    80003d4e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003d50:	0001f497          	auipc	s1,0x1f
    80003d54:	b3048493          	addi	s1,s1,-1232 # 80022880 <log>
    80003d58:	00004597          	auipc	a1,0x4
    80003d5c:	83058593          	addi	a1,a1,-2000 # 80007588 <etext+0x588>
    80003d60:	8526                	mv	a0,s1
    80003d62:	e13fc0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003d66:	0149a583          	lw	a1,20(s3)
    80003d6a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003d6c:	0109a783          	lw	a5,16(s3)
    80003d70:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003d72:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003d76:	854a                	mv	a0,s2
    80003d78:	87cff0ef          	jal	80002df4 <bread>
  log.lh.n = lh->n;
    80003d7c:	4d30                	lw	a2,88(a0)
    80003d7e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003d80:	00c05f63          	blez	a2,80003d9e <initlog+0x60>
    80003d84:	87aa                	mv	a5,a0
    80003d86:	0001f717          	auipc	a4,0x1f
    80003d8a:	b2a70713          	addi	a4,a4,-1238 # 800228b0 <log+0x30>
    80003d8e:	060a                	slli	a2,a2,0x2
    80003d90:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003d92:	4ff4                	lw	a3,92(a5)
    80003d94:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003d96:	0791                	addi	a5,a5,4
    80003d98:	0711                	addi	a4,a4,4
    80003d9a:	fec79ce3          	bne	a5,a2,80003d92 <initlog+0x54>
  brelse(buf);
    80003d9e:	95eff0ef          	jal	80002efc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003da2:	4505                	li	a0,1
    80003da4:	ef3ff0ef          	jal	80003c96 <install_trans>
  log.lh.n = 0;
    80003da8:	0001f797          	auipc	a5,0x1f
    80003dac:	b007a223          	sw	zero,-1276(a5) # 800228ac <log+0x2c>
  write_head(); // clear the log
    80003db0:	e89ff0ef          	jal	80003c38 <write_head>
}
    80003db4:	70a2                	ld	ra,40(sp)
    80003db6:	7402                	ld	s0,32(sp)
    80003db8:	64e2                	ld	s1,24(sp)
    80003dba:	6942                	ld	s2,16(sp)
    80003dbc:	69a2                	ld	s3,8(sp)
    80003dbe:	6145                	addi	sp,sp,48
    80003dc0:	8082                	ret

0000000080003dc2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003dc2:	1101                	addi	sp,sp,-32
    80003dc4:	ec06                	sd	ra,24(sp)
    80003dc6:	e822                	sd	s0,16(sp)
    80003dc8:	e426                	sd	s1,8(sp)
    80003dca:	e04a                	sd	s2,0(sp)
    80003dcc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003dce:	0001f517          	auipc	a0,0x1f
    80003dd2:	ab250513          	addi	a0,a0,-1358 # 80022880 <log>
    80003dd6:	e1ffc0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003dda:	0001f497          	auipc	s1,0x1f
    80003dde:	aa648493          	addi	s1,s1,-1370 # 80022880 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003de2:	4979                	li	s2,30
    80003de4:	a029                	j	80003dee <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003de6:	85a6                	mv	a1,s1
    80003de8:	8526                	mv	a0,s1
    80003dea:	c00fe0ef          	jal	800021ea <sleep>
    if(log.committing){
    80003dee:	50dc                	lw	a5,36(s1)
    80003df0:	fbfd                	bnez	a5,80003de6 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003df2:	5098                	lw	a4,32(s1)
    80003df4:	2705                	addiw	a4,a4,1
    80003df6:	0027179b          	slliw	a5,a4,0x2
    80003dfa:	9fb9                	addw	a5,a5,a4
    80003dfc:	0017979b          	slliw	a5,a5,0x1
    80003e00:	54d4                	lw	a3,44(s1)
    80003e02:	9fb5                	addw	a5,a5,a3
    80003e04:	00f95763          	bge	s2,a5,80003e12 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003e08:	85a6                	mv	a1,s1
    80003e0a:	8526                	mv	a0,s1
    80003e0c:	bdefe0ef          	jal	800021ea <sleep>
    80003e10:	bff9                	j	80003dee <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003e12:	0001f517          	auipc	a0,0x1f
    80003e16:	a6e50513          	addi	a0,a0,-1426 # 80022880 <log>
    80003e1a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003e1c:	e71fc0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003e20:	60e2                	ld	ra,24(sp)
    80003e22:	6442                	ld	s0,16(sp)
    80003e24:	64a2                	ld	s1,8(sp)
    80003e26:	6902                	ld	s2,0(sp)
    80003e28:	6105                	addi	sp,sp,32
    80003e2a:	8082                	ret

0000000080003e2c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003e2c:	7139                	addi	sp,sp,-64
    80003e2e:	fc06                	sd	ra,56(sp)
    80003e30:	f822                	sd	s0,48(sp)
    80003e32:	f426                	sd	s1,40(sp)
    80003e34:	f04a                	sd	s2,32(sp)
    80003e36:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003e38:	0001f497          	auipc	s1,0x1f
    80003e3c:	a4848493          	addi	s1,s1,-1464 # 80022880 <log>
    80003e40:	8526                	mv	a0,s1
    80003e42:	db3fc0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003e46:	509c                	lw	a5,32(s1)
    80003e48:	37fd                	addiw	a5,a5,-1
    80003e4a:	0007891b          	sext.w	s2,a5
    80003e4e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003e50:	50dc                	lw	a5,36(s1)
    80003e52:	ef9d                	bnez	a5,80003e90 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003e54:	04091763          	bnez	s2,80003ea2 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003e58:	0001f497          	auipc	s1,0x1f
    80003e5c:	a2848493          	addi	s1,s1,-1496 # 80022880 <log>
    80003e60:	4785                	li	a5,1
    80003e62:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003e64:	8526                	mv	a0,s1
    80003e66:	e27fc0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003e6a:	54dc                	lw	a5,44(s1)
    80003e6c:	04f04b63          	bgtz	a5,80003ec2 <end_op+0x96>
    acquire(&log.lock);
    80003e70:	0001f497          	auipc	s1,0x1f
    80003e74:	a1048493          	addi	s1,s1,-1520 # 80022880 <log>
    80003e78:	8526                	mv	a0,s1
    80003e7a:	d7bfc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003e7e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003e82:	8526                	mv	a0,s1
    80003e84:	bb2fe0ef          	jal	80002236 <wakeup>
    release(&log.lock);
    80003e88:	8526                	mv	a0,s1
    80003e8a:	e03fc0ef          	jal	80000c8c <release>
}
    80003e8e:	a025                	j	80003eb6 <end_op+0x8a>
    80003e90:	ec4e                	sd	s3,24(sp)
    80003e92:	e852                	sd	s4,16(sp)
    80003e94:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003e96:	00003517          	auipc	a0,0x3
    80003e9a:	6fa50513          	addi	a0,a0,1786 # 80007590 <etext+0x590>
    80003e9e:	8f7fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003ea2:	0001f497          	auipc	s1,0x1f
    80003ea6:	9de48493          	addi	s1,s1,-1570 # 80022880 <log>
    80003eaa:	8526                	mv	a0,s1
    80003eac:	b8afe0ef          	jal	80002236 <wakeup>
  release(&log.lock);
    80003eb0:	8526                	mv	a0,s1
    80003eb2:	ddbfc0ef          	jal	80000c8c <release>
}
    80003eb6:	70e2                	ld	ra,56(sp)
    80003eb8:	7442                	ld	s0,48(sp)
    80003eba:	74a2                	ld	s1,40(sp)
    80003ebc:	7902                	ld	s2,32(sp)
    80003ebe:	6121                	addi	sp,sp,64
    80003ec0:	8082                	ret
    80003ec2:	ec4e                	sd	s3,24(sp)
    80003ec4:	e852                	sd	s4,16(sp)
    80003ec6:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ec8:	0001fa97          	auipc	s5,0x1f
    80003ecc:	9e8a8a93          	addi	s5,s5,-1560 # 800228b0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003ed0:	0001fa17          	auipc	s4,0x1f
    80003ed4:	9b0a0a13          	addi	s4,s4,-1616 # 80022880 <log>
    80003ed8:	018a2583          	lw	a1,24(s4)
    80003edc:	012585bb          	addw	a1,a1,s2
    80003ee0:	2585                	addiw	a1,a1,1
    80003ee2:	028a2503          	lw	a0,40(s4)
    80003ee6:	f0ffe0ef          	jal	80002df4 <bread>
    80003eea:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003eec:	000aa583          	lw	a1,0(s5)
    80003ef0:	028a2503          	lw	a0,40(s4)
    80003ef4:	f01fe0ef          	jal	80002df4 <bread>
    80003ef8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003efa:	40000613          	li	a2,1024
    80003efe:	05850593          	addi	a1,a0,88
    80003f02:	05848513          	addi	a0,s1,88
    80003f06:	e1ffc0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80003f0a:	8526                	mv	a0,s1
    80003f0c:	fbffe0ef          	jal	80002eca <bwrite>
    brelse(from);
    80003f10:	854e                	mv	a0,s3
    80003f12:	febfe0ef          	jal	80002efc <brelse>
    brelse(to);
    80003f16:	8526                	mv	a0,s1
    80003f18:	fe5fe0ef          	jal	80002efc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f1c:	2905                	addiw	s2,s2,1
    80003f1e:	0a91                	addi	s5,s5,4
    80003f20:	02ca2783          	lw	a5,44(s4)
    80003f24:	faf94ae3          	blt	s2,a5,80003ed8 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003f28:	d11ff0ef          	jal	80003c38 <write_head>
    install_trans(0); // Now install writes to home locations
    80003f2c:	4501                	li	a0,0
    80003f2e:	d69ff0ef          	jal	80003c96 <install_trans>
    log.lh.n = 0;
    80003f32:	0001f797          	auipc	a5,0x1f
    80003f36:	9607ad23          	sw	zero,-1670(a5) # 800228ac <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003f3a:	cffff0ef          	jal	80003c38 <write_head>
    80003f3e:	69e2                	ld	s3,24(sp)
    80003f40:	6a42                	ld	s4,16(sp)
    80003f42:	6aa2                	ld	s5,8(sp)
    80003f44:	b735                	j	80003e70 <end_op+0x44>

0000000080003f46 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003f46:	1101                	addi	sp,sp,-32
    80003f48:	ec06                	sd	ra,24(sp)
    80003f4a:	e822                	sd	s0,16(sp)
    80003f4c:	e426                	sd	s1,8(sp)
    80003f4e:	e04a                	sd	s2,0(sp)
    80003f50:	1000                	addi	s0,sp,32
    80003f52:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003f54:	0001f917          	auipc	s2,0x1f
    80003f58:	92c90913          	addi	s2,s2,-1748 # 80022880 <log>
    80003f5c:	854a                	mv	a0,s2
    80003f5e:	c97fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003f62:	02c92603          	lw	a2,44(s2)
    80003f66:	47f5                	li	a5,29
    80003f68:	06c7c363          	blt	a5,a2,80003fce <log_write+0x88>
    80003f6c:	0001f797          	auipc	a5,0x1f
    80003f70:	9307a783          	lw	a5,-1744(a5) # 8002289c <log+0x1c>
    80003f74:	37fd                	addiw	a5,a5,-1
    80003f76:	04f65c63          	bge	a2,a5,80003fce <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003f7a:	0001f797          	auipc	a5,0x1f
    80003f7e:	9267a783          	lw	a5,-1754(a5) # 800228a0 <log+0x20>
    80003f82:	04f05c63          	blez	a5,80003fda <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003f86:	4781                	li	a5,0
    80003f88:	04c05f63          	blez	a2,80003fe6 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f8c:	44cc                	lw	a1,12(s1)
    80003f8e:	0001f717          	auipc	a4,0x1f
    80003f92:	92270713          	addi	a4,a4,-1758 # 800228b0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003f96:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f98:	4314                	lw	a3,0(a4)
    80003f9a:	04b68663          	beq	a3,a1,80003fe6 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003f9e:	2785                	addiw	a5,a5,1
    80003fa0:	0711                	addi	a4,a4,4
    80003fa2:	fef61be3          	bne	a2,a5,80003f98 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003fa6:	0621                	addi	a2,a2,8
    80003fa8:	060a                	slli	a2,a2,0x2
    80003faa:	0001f797          	auipc	a5,0x1f
    80003fae:	8d678793          	addi	a5,a5,-1834 # 80022880 <log>
    80003fb2:	97b2                	add	a5,a5,a2
    80003fb4:	44d8                	lw	a4,12(s1)
    80003fb6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	fcbfe0ef          	jal	80002f84 <bpin>
    log.lh.n++;
    80003fbe:	0001f717          	auipc	a4,0x1f
    80003fc2:	8c270713          	addi	a4,a4,-1854 # 80022880 <log>
    80003fc6:	575c                	lw	a5,44(a4)
    80003fc8:	2785                	addiw	a5,a5,1
    80003fca:	d75c                	sw	a5,44(a4)
    80003fcc:	a80d                	j	80003ffe <log_write+0xb8>
    panic("too big a transaction");
    80003fce:	00003517          	auipc	a0,0x3
    80003fd2:	5d250513          	addi	a0,a0,1490 # 800075a0 <etext+0x5a0>
    80003fd6:	fbefc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80003fda:	00003517          	auipc	a0,0x3
    80003fde:	5de50513          	addi	a0,a0,1502 # 800075b8 <etext+0x5b8>
    80003fe2:	fb2fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80003fe6:	00878693          	addi	a3,a5,8
    80003fea:	068a                	slli	a3,a3,0x2
    80003fec:	0001f717          	auipc	a4,0x1f
    80003ff0:	89470713          	addi	a4,a4,-1900 # 80022880 <log>
    80003ff4:	9736                	add	a4,a4,a3
    80003ff6:	44d4                	lw	a3,12(s1)
    80003ff8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003ffa:	faf60fe3          	beq	a2,a5,80003fb8 <log_write+0x72>
  }
  release(&log.lock);
    80003ffe:	0001f517          	auipc	a0,0x1f
    80004002:	88250513          	addi	a0,a0,-1918 # 80022880 <log>
    80004006:	c87fc0ef          	jal	80000c8c <release>
}
    8000400a:	60e2                	ld	ra,24(sp)
    8000400c:	6442                	ld	s0,16(sp)
    8000400e:	64a2                	ld	s1,8(sp)
    80004010:	6902                	ld	s2,0(sp)
    80004012:	6105                	addi	sp,sp,32
    80004014:	8082                	ret

0000000080004016 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004016:	1101                	addi	sp,sp,-32
    80004018:	ec06                	sd	ra,24(sp)
    8000401a:	e822                	sd	s0,16(sp)
    8000401c:	e426                	sd	s1,8(sp)
    8000401e:	e04a                	sd	s2,0(sp)
    80004020:	1000                	addi	s0,sp,32
    80004022:	84aa                	mv	s1,a0
    80004024:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004026:	00003597          	auipc	a1,0x3
    8000402a:	5b258593          	addi	a1,a1,1458 # 800075d8 <etext+0x5d8>
    8000402e:	0521                	addi	a0,a0,8
    80004030:	b45fc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    80004034:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004038:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000403c:	0204a423          	sw	zero,40(s1)
}
    80004040:	60e2                	ld	ra,24(sp)
    80004042:	6442                	ld	s0,16(sp)
    80004044:	64a2                	ld	s1,8(sp)
    80004046:	6902                	ld	s2,0(sp)
    80004048:	6105                	addi	sp,sp,32
    8000404a:	8082                	ret

000000008000404c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000404c:	1101                	addi	sp,sp,-32
    8000404e:	ec06                	sd	ra,24(sp)
    80004050:	e822                	sd	s0,16(sp)
    80004052:	e426                	sd	s1,8(sp)
    80004054:	e04a                	sd	s2,0(sp)
    80004056:	1000                	addi	s0,sp,32
    80004058:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000405a:	00850913          	addi	s2,a0,8
    8000405e:	854a                	mv	a0,s2
    80004060:	b95fc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    80004064:	409c                	lw	a5,0(s1)
    80004066:	c799                	beqz	a5,80004074 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004068:	85ca                	mv	a1,s2
    8000406a:	8526                	mv	a0,s1
    8000406c:	97efe0ef          	jal	800021ea <sleep>
  while (lk->locked) {
    80004070:	409c                	lw	a5,0(s1)
    80004072:	fbfd                	bnez	a5,80004068 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004074:	4785                	li	a5,1
    80004076:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004078:	b03fd0ef          	jal	80001b7a <myproc>
    8000407c:	591c                	lw	a5,48(a0)
    8000407e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004080:	854a                	mv	a0,s2
    80004082:	c0bfc0ef          	jal	80000c8c <release>
}
    80004086:	60e2                	ld	ra,24(sp)
    80004088:	6442                	ld	s0,16(sp)
    8000408a:	64a2                	ld	s1,8(sp)
    8000408c:	6902                	ld	s2,0(sp)
    8000408e:	6105                	addi	sp,sp,32
    80004090:	8082                	ret

0000000080004092 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004092:	1101                	addi	sp,sp,-32
    80004094:	ec06                	sd	ra,24(sp)
    80004096:	e822                	sd	s0,16(sp)
    80004098:	e426                	sd	s1,8(sp)
    8000409a:	e04a                	sd	s2,0(sp)
    8000409c:	1000                	addi	s0,sp,32
    8000409e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800040a0:	00850913          	addi	s2,a0,8
    800040a4:	854a                	mv	a0,s2
    800040a6:	b4ffc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    800040aa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800040ae:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800040b2:	8526                	mv	a0,s1
    800040b4:	982fe0ef          	jal	80002236 <wakeup>
  release(&lk->lk);
    800040b8:	854a                	mv	a0,s2
    800040ba:	bd3fc0ef          	jal	80000c8c <release>
}
    800040be:	60e2                	ld	ra,24(sp)
    800040c0:	6442                	ld	s0,16(sp)
    800040c2:	64a2                	ld	s1,8(sp)
    800040c4:	6902                	ld	s2,0(sp)
    800040c6:	6105                	addi	sp,sp,32
    800040c8:	8082                	ret

00000000800040ca <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800040ca:	7179                	addi	sp,sp,-48
    800040cc:	f406                	sd	ra,40(sp)
    800040ce:	f022                	sd	s0,32(sp)
    800040d0:	ec26                	sd	s1,24(sp)
    800040d2:	e84a                	sd	s2,16(sp)
    800040d4:	1800                	addi	s0,sp,48
    800040d6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800040d8:	00850913          	addi	s2,a0,8
    800040dc:	854a                	mv	a0,s2
    800040de:	b17fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800040e2:	409c                	lw	a5,0(s1)
    800040e4:	ef81                	bnez	a5,800040fc <holdingsleep+0x32>
    800040e6:	4481                	li	s1,0
  release(&lk->lk);
    800040e8:	854a                	mv	a0,s2
    800040ea:	ba3fc0ef          	jal	80000c8c <release>
  return r;
}
    800040ee:	8526                	mv	a0,s1
    800040f0:	70a2                	ld	ra,40(sp)
    800040f2:	7402                	ld	s0,32(sp)
    800040f4:	64e2                	ld	s1,24(sp)
    800040f6:	6942                	ld	s2,16(sp)
    800040f8:	6145                	addi	sp,sp,48
    800040fa:	8082                	ret
    800040fc:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800040fe:	0284a983          	lw	s3,40(s1)
    80004102:	a79fd0ef          	jal	80001b7a <myproc>
    80004106:	5904                	lw	s1,48(a0)
    80004108:	413484b3          	sub	s1,s1,s3
    8000410c:	0014b493          	seqz	s1,s1
    80004110:	69a2                	ld	s3,8(sp)
    80004112:	bfd9                	j	800040e8 <holdingsleep+0x1e>

0000000080004114 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004114:	1141                	addi	sp,sp,-16
    80004116:	e406                	sd	ra,8(sp)
    80004118:	e022                	sd	s0,0(sp)
    8000411a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000411c:	00003597          	auipc	a1,0x3
    80004120:	4cc58593          	addi	a1,a1,1228 # 800075e8 <etext+0x5e8>
    80004124:	0001f517          	auipc	a0,0x1f
    80004128:	8a450513          	addi	a0,a0,-1884 # 800229c8 <ftable>
    8000412c:	a49fc0ef          	jal	80000b74 <initlock>
}
    80004130:	60a2                	ld	ra,8(sp)
    80004132:	6402                	ld	s0,0(sp)
    80004134:	0141                	addi	sp,sp,16
    80004136:	8082                	ret

0000000080004138 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004138:	1101                	addi	sp,sp,-32
    8000413a:	ec06                	sd	ra,24(sp)
    8000413c:	e822                	sd	s0,16(sp)
    8000413e:	e426                	sd	s1,8(sp)
    80004140:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004142:	0001f517          	auipc	a0,0x1f
    80004146:	88650513          	addi	a0,a0,-1914 # 800229c8 <ftable>
    8000414a:	aabfc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000414e:	0001f497          	auipc	s1,0x1f
    80004152:	89248493          	addi	s1,s1,-1902 # 800229e0 <ftable+0x18>
    80004156:	00020717          	auipc	a4,0x20
    8000415a:	82a70713          	addi	a4,a4,-2006 # 80023980 <disk>
    if(f->ref == 0){
    8000415e:	40dc                	lw	a5,4(s1)
    80004160:	cf89                	beqz	a5,8000417a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004162:	02848493          	addi	s1,s1,40
    80004166:	fee49ce3          	bne	s1,a4,8000415e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000416a:	0001f517          	auipc	a0,0x1f
    8000416e:	85e50513          	addi	a0,a0,-1954 # 800229c8 <ftable>
    80004172:	b1bfc0ef          	jal	80000c8c <release>
  return 0;
    80004176:	4481                	li	s1,0
    80004178:	a809                	j	8000418a <filealloc+0x52>
      f->ref = 1;
    8000417a:	4785                	li	a5,1
    8000417c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000417e:	0001f517          	auipc	a0,0x1f
    80004182:	84a50513          	addi	a0,a0,-1974 # 800229c8 <ftable>
    80004186:	b07fc0ef          	jal	80000c8c <release>
}
    8000418a:	8526                	mv	a0,s1
    8000418c:	60e2                	ld	ra,24(sp)
    8000418e:	6442                	ld	s0,16(sp)
    80004190:	64a2                	ld	s1,8(sp)
    80004192:	6105                	addi	sp,sp,32
    80004194:	8082                	ret

0000000080004196 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004196:	1101                	addi	sp,sp,-32
    80004198:	ec06                	sd	ra,24(sp)
    8000419a:	e822                	sd	s0,16(sp)
    8000419c:	e426                	sd	s1,8(sp)
    8000419e:	1000                	addi	s0,sp,32
    800041a0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800041a2:	0001f517          	auipc	a0,0x1f
    800041a6:	82650513          	addi	a0,a0,-2010 # 800229c8 <ftable>
    800041aa:	a4bfc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    800041ae:	40dc                	lw	a5,4(s1)
    800041b0:	02f05063          	blez	a5,800041d0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800041b4:	2785                	addiw	a5,a5,1
    800041b6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800041b8:	0001f517          	auipc	a0,0x1f
    800041bc:	81050513          	addi	a0,a0,-2032 # 800229c8 <ftable>
    800041c0:	acdfc0ef          	jal	80000c8c <release>
  return f;
}
    800041c4:	8526                	mv	a0,s1
    800041c6:	60e2                	ld	ra,24(sp)
    800041c8:	6442                	ld	s0,16(sp)
    800041ca:	64a2                	ld	s1,8(sp)
    800041cc:	6105                	addi	sp,sp,32
    800041ce:	8082                	ret
    panic("filedup");
    800041d0:	00003517          	auipc	a0,0x3
    800041d4:	42050513          	addi	a0,a0,1056 # 800075f0 <etext+0x5f0>
    800041d8:	dbcfc0ef          	jal	80000794 <panic>

00000000800041dc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800041dc:	7139                	addi	sp,sp,-64
    800041de:	fc06                	sd	ra,56(sp)
    800041e0:	f822                	sd	s0,48(sp)
    800041e2:	f426                	sd	s1,40(sp)
    800041e4:	0080                	addi	s0,sp,64
    800041e6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800041e8:	0001e517          	auipc	a0,0x1e
    800041ec:	7e050513          	addi	a0,a0,2016 # 800229c8 <ftable>
    800041f0:	a05fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    800041f4:	40dc                	lw	a5,4(s1)
    800041f6:	04f05a63          	blez	a5,8000424a <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800041fa:	37fd                	addiw	a5,a5,-1
    800041fc:	0007871b          	sext.w	a4,a5
    80004200:	c0dc                	sw	a5,4(s1)
    80004202:	04e04e63          	bgtz	a4,8000425e <fileclose+0x82>
    80004206:	f04a                	sd	s2,32(sp)
    80004208:	ec4e                	sd	s3,24(sp)
    8000420a:	e852                	sd	s4,16(sp)
    8000420c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000420e:	0004a903          	lw	s2,0(s1)
    80004212:	0094ca83          	lbu	s5,9(s1)
    80004216:	0104ba03          	ld	s4,16(s1)
    8000421a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000421e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004222:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004226:	0001e517          	auipc	a0,0x1e
    8000422a:	7a250513          	addi	a0,a0,1954 # 800229c8 <ftable>
    8000422e:	a5ffc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    80004232:	4785                	li	a5,1
    80004234:	04f90063          	beq	s2,a5,80004274 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004238:	3979                	addiw	s2,s2,-2
    8000423a:	4785                	li	a5,1
    8000423c:	0527f563          	bgeu	a5,s2,80004286 <fileclose+0xaa>
    80004240:	7902                	ld	s2,32(sp)
    80004242:	69e2                	ld	s3,24(sp)
    80004244:	6a42                	ld	s4,16(sp)
    80004246:	6aa2                	ld	s5,8(sp)
    80004248:	a00d                	j	8000426a <fileclose+0x8e>
    8000424a:	f04a                	sd	s2,32(sp)
    8000424c:	ec4e                	sd	s3,24(sp)
    8000424e:	e852                	sd	s4,16(sp)
    80004250:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004252:	00003517          	auipc	a0,0x3
    80004256:	3a650513          	addi	a0,a0,934 # 800075f8 <etext+0x5f8>
    8000425a:	d3afc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    8000425e:	0001e517          	auipc	a0,0x1e
    80004262:	76a50513          	addi	a0,a0,1898 # 800229c8 <ftable>
    80004266:	a27fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000426a:	70e2                	ld	ra,56(sp)
    8000426c:	7442                	ld	s0,48(sp)
    8000426e:	74a2                	ld	s1,40(sp)
    80004270:	6121                	addi	sp,sp,64
    80004272:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004274:	85d6                	mv	a1,s5
    80004276:	8552                	mv	a0,s4
    80004278:	336000ef          	jal	800045ae <pipeclose>
    8000427c:	7902                	ld	s2,32(sp)
    8000427e:	69e2                	ld	s3,24(sp)
    80004280:	6a42                	ld	s4,16(sp)
    80004282:	6aa2                	ld	s5,8(sp)
    80004284:	b7dd                	j	8000426a <fileclose+0x8e>
    begin_op();
    80004286:	b3dff0ef          	jal	80003dc2 <begin_op>
    iput(ff.ip);
    8000428a:	854e                	mv	a0,s3
    8000428c:	c22ff0ef          	jal	800036ae <iput>
    end_op();
    80004290:	b9dff0ef          	jal	80003e2c <end_op>
    80004294:	7902                	ld	s2,32(sp)
    80004296:	69e2                	ld	s3,24(sp)
    80004298:	6a42                	ld	s4,16(sp)
    8000429a:	6aa2                	ld	s5,8(sp)
    8000429c:	b7f9                	j	8000426a <fileclose+0x8e>

000000008000429e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000429e:	715d                	addi	sp,sp,-80
    800042a0:	e486                	sd	ra,72(sp)
    800042a2:	e0a2                	sd	s0,64(sp)
    800042a4:	fc26                	sd	s1,56(sp)
    800042a6:	f44e                	sd	s3,40(sp)
    800042a8:	0880                	addi	s0,sp,80
    800042aa:	84aa                	mv	s1,a0
    800042ac:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800042ae:	8cdfd0ef          	jal	80001b7a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800042b2:	409c                	lw	a5,0(s1)
    800042b4:	37f9                	addiw	a5,a5,-2
    800042b6:	4705                	li	a4,1
    800042b8:	04f76063          	bltu	a4,a5,800042f8 <filestat+0x5a>
    800042bc:	f84a                	sd	s2,48(sp)
    800042be:	892a                	mv	s2,a0
    ilock(f->ip);
    800042c0:	6c88                	ld	a0,24(s1)
    800042c2:	a6aff0ef          	jal	8000352c <ilock>
    stati(f->ip, &st);
    800042c6:	fb840593          	addi	a1,s0,-72
    800042ca:	6c88                	ld	a0,24(s1)
    800042cc:	c8aff0ef          	jal	80003756 <stati>
    iunlock(f->ip);
    800042d0:	6c88                	ld	a0,24(s1)
    800042d2:	b08ff0ef          	jal	800035da <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800042d6:	46e1                	li	a3,24
    800042d8:	fb840613          	addi	a2,s0,-72
    800042dc:	85ce                	mv	a1,s3
    800042de:	06093503          	ld	a0,96(s2)
    800042e2:	a70fd0ef          	jal	80001552 <copyout>
    800042e6:	41f5551b          	sraiw	a0,a0,0x1f
    800042ea:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800042ec:	60a6                	ld	ra,72(sp)
    800042ee:	6406                	ld	s0,64(sp)
    800042f0:	74e2                	ld	s1,56(sp)
    800042f2:	79a2                	ld	s3,40(sp)
    800042f4:	6161                	addi	sp,sp,80
    800042f6:	8082                	ret
  return -1;
    800042f8:	557d                	li	a0,-1
    800042fa:	bfcd                	j	800042ec <filestat+0x4e>

00000000800042fc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800042fc:	7179                	addi	sp,sp,-48
    800042fe:	f406                	sd	ra,40(sp)
    80004300:	f022                	sd	s0,32(sp)
    80004302:	e84a                	sd	s2,16(sp)
    80004304:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004306:	00854783          	lbu	a5,8(a0)
    8000430a:	cfd1                	beqz	a5,800043a6 <fileread+0xaa>
    8000430c:	ec26                	sd	s1,24(sp)
    8000430e:	e44e                	sd	s3,8(sp)
    80004310:	84aa                	mv	s1,a0
    80004312:	89ae                	mv	s3,a1
    80004314:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004316:	411c                	lw	a5,0(a0)
    80004318:	4705                	li	a4,1
    8000431a:	04e78363          	beq	a5,a4,80004360 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000431e:	470d                	li	a4,3
    80004320:	04e78763          	beq	a5,a4,8000436e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004324:	4709                	li	a4,2
    80004326:	06e79a63          	bne	a5,a4,8000439a <fileread+0x9e>
    ilock(f->ip);
    8000432a:	6d08                	ld	a0,24(a0)
    8000432c:	a00ff0ef          	jal	8000352c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004330:	874a                	mv	a4,s2
    80004332:	5094                	lw	a3,32(s1)
    80004334:	864e                	mv	a2,s3
    80004336:	4585                	li	a1,1
    80004338:	6c88                	ld	a0,24(s1)
    8000433a:	c46ff0ef          	jal	80003780 <readi>
    8000433e:	892a                	mv	s2,a0
    80004340:	00a05563          	blez	a0,8000434a <fileread+0x4e>
      f->off += r;
    80004344:	509c                	lw	a5,32(s1)
    80004346:	9fa9                	addw	a5,a5,a0
    80004348:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000434a:	6c88                	ld	a0,24(s1)
    8000434c:	a8eff0ef          	jal	800035da <iunlock>
    80004350:	64e2                	ld	s1,24(sp)
    80004352:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004354:	854a                	mv	a0,s2
    80004356:	70a2                	ld	ra,40(sp)
    80004358:	7402                	ld	s0,32(sp)
    8000435a:	6942                	ld	s2,16(sp)
    8000435c:	6145                	addi	sp,sp,48
    8000435e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004360:	6908                	ld	a0,16(a0)
    80004362:	388000ef          	jal	800046ea <piperead>
    80004366:	892a                	mv	s2,a0
    80004368:	64e2                	ld	s1,24(sp)
    8000436a:	69a2                	ld	s3,8(sp)
    8000436c:	b7e5                	j	80004354 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000436e:	02451783          	lh	a5,36(a0)
    80004372:	03079693          	slli	a3,a5,0x30
    80004376:	92c1                	srli	a3,a3,0x30
    80004378:	4725                	li	a4,9
    8000437a:	02d76863          	bltu	a4,a3,800043aa <fileread+0xae>
    8000437e:	0792                	slli	a5,a5,0x4
    80004380:	0001e717          	auipc	a4,0x1e
    80004384:	5a870713          	addi	a4,a4,1448 # 80022928 <devsw>
    80004388:	97ba                	add	a5,a5,a4
    8000438a:	639c                	ld	a5,0(a5)
    8000438c:	c39d                	beqz	a5,800043b2 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000438e:	4505                	li	a0,1
    80004390:	9782                	jalr	a5
    80004392:	892a                	mv	s2,a0
    80004394:	64e2                	ld	s1,24(sp)
    80004396:	69a2                	ld	s3,8(sp)
    80004398:	bf75                	j	80004354 <fileread+0x58>
    panic("fileread");
    8000439a:	00003517          	auipc	a0,0x3
    8000439e:	26e50513          	addi	a0,a0,622 # 80007608 <etext+0x608>
    800043a2:	bf2fc0ef          	jal	80000794 <panic>
    return -1;
    800043a6:	597d                	li	s2,-1
    800043a8:	b775                	j	80004354 <fileread+0x58>
      return -1;
    800043aa:	597d                	li	s2,-1
    800043ac:	64e2                	ld	s1,24(sp)
    800043ae:	69a2                	ld	s3,8(sp)
    800043b0:	b755                	j	80004354 <fileread+0x58>
    800043b2:	597d                	li	s2,-1
    800043b4:	64e2                	ld	s1,24(sp)
    800043b6:	69a2                	ld	s3,8(sp)
    800043b8:	bf71                	j	80004354 <fileread+0x58>

00000000800043ba <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800043ba:	00954783          	lbu	a5,9(a0)
    800043be:	10078b63          	beqz	a5,800044d4 <filewrite+0x11a>
{
    800043c2:	715d                	addi	sp,sp,-80
    800043c4:	e486                	sd	ra,72(sp)
    800043c6:	e0a2                	sd	s0,64(sp)
    800043c8:	f84a                	sd	s2,48(sp)
    800043ca:	f052                	sd	s4,32(sp)
    800043cc:	e85a                	sd	s6,16(sp)
    800043ce:	0880                	addi	s0,sp,80
    800043d0:	892a                	mv	s2,a0
    800043d2:	8b2e                	mv	s6,a1
    800043d4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800043d6:	411c                	lw	a5,0(a0)
    800043d8:	4705                	li	a4,1
    800043da:	02e78763          	beq	a5,a4,80004408 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800043de:	470d                	li	a4,3
    800043e0:	02e78863          	beq	a5,a4,80004410 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800043e4:	4709                	li	a4,2
    800043e6:	0ce79c63          	bne	a5,a4,800044be <filewrite+0x104>
    800043ea:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800043ec:	0ac05863          	blez	a2,8000449c <filewrite+0xe2>
    800043f0:	fc26                	sd	s1,56(sp)
    800043f2:	ec56                	sd	s5,24(sp)
    800043f4:	e45e                	sd	s7,8(sp)
    800043f6:	e062                	sd	s8,0(sp)
    int i = 0;
    800043f8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800043fa:	6b85                	lui	s7,0x1
    800043fc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004400:	6c05                	lui	s8,0x1
    80004402:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004406:	a8b5                	j	80004482 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004408:	6908                	ld	a0,16(a0)
    8000440a:	1fc000ef          	jal	80004606 <pipewrite>
    8000440e:	a04d                	j	800044b0 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004410:	02451783          	lh	a5,36(a0)
    80004414:	03079693          	slli	a3,a5,0x30
    80004418:	92c1                	srli	a3,a3,0x30
    8000441a:	4725                	li	a4,9
    8000441c:	0ad76e63          	bltu	a4,a3,800044d8 <filewrite+0x11e>
    80004420:	0792                	slli	a5,a5,0x4
    80004422:	0001e717          	auipc	a4,0x1e
    80004426:	50670713          	addi	a4,a4,1286 # 80022928 <devsw>
    8000442a:	97ba                	add	a5,a5,a4
    8000442c:	679c                	ld	a5,8(a5)
    8000442e:	c7dd                	beqz	a5,800044dc <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004430:	4505                	li	a0,1
    80004432:	9782                	jalr	a5
    80004434:	a8b5                	j	800044b0 <filewrite+0xf6>
      if(n1 > max)
    80004436:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000443a:	989ff0ef          	jal	80003dc2 <begin_op>
      ilock(f->ip);
    8000443e:	01893503          	ld	a0,24(s2)
    80004442:	8eaff0ef          	jal	8000352c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004446:	8756                	mv	a4,s5
    80004448:	02092683          	lw	a3,32(s2)
    8000444c:	01698633          	add	a2,s3,s6
    80004450:	4585                	li	a1,1
    80004452:	01893503          	ld	a0,24(s2)
    80004456:	c26ff0ef          	jal	8000387c <writei>
    8000445a:	84aa                	mv	s1,a0
    8000445c:	00a05763          	blez	a0,8000446a <filewrite+0xb0>
        f->off += r;
    80004460:	02092783          	lw	a5,32(s2)
    80004464:	9fa9                	addw	a5,a5,a0
    80004466:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000446a:	01893503          	ld	a0,24(s2)
    8000446e:	96cff0ef          	jal	800035da <iunlock>
      end_op();
    80004472:	9bbff0ef          	jal	80003e2c <end_op>

      if(r != n1){
    80004476:	029a9563          	bne	s5,s1,800044a0 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000447a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000447e:	0149da63          	bge	s3,s4,80004492 <filewrite+0xd8>
      int n1 = n - i;
    80004482:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004486:	0004879b          	sext.w	a5,s1
    8000448a:	fafbd6e3          	bge	s7,a5,80004436 <filewrite+0x7c>
    8000448e:	84e2                	mv	s1,s8
    80004490:	b75d                	j	80004436 <filewrite+0x7c>
    80004492:	74e2                	ld	s1,56(sp)
    80004494:	6ae2                	ld	s5,24(sp)
    80004496:	6ba2                	ld	s7,8(sp)
    80004498:	6c02                	ld	s8,0(sp)
    8000449a:	a039                	j	800044a8 <filewrite+0xee>
    int i = 0;
    8000449c:	4981                	li	s3,0
    8000449e:	a029                	j	800044a8 <filewrite+0xee>
    800044a0:	74e2                	ld	s1,56(sp)
    800044a2:	6ae2                	ld	s5,24(sp)
    800044a4:	6ba2                	ld	s7,8(sp)
    800044a6:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800044a8:	033a1c63          	bne	s4,s3,800044e0 <filewrite+0x126>
    800044ac:	8552                	mv	a0,s4
    800044ae:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800044b0:	60a6                	ld	ra,72(sp)
    800044b2:	6406                	ld	s0,64(sp)
    800044b4:	7942                	ld	s2,48(sp)
    800044b6:	7a02                	ld	s4,32(sp)
    800044b8:	6b42                	ld	s6,16(sp)
    800044ba:	6161                	addi	sp,sp,80
    800044bc:	8082                	ret
    800044be:	fc26                	sd	s1,56(sp)
    800044c0:	f44e                	sd	s3,40(sp)
    800044c2:	ec56                	sd	s5,24(sp)
    800044c4:	e45e                	sd	s7,8(sp)
    800044c6:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800044c8:	00003517          	auipc	a0,0x3
    800044cc:	15050513          	addi	a0,a0,336 # 80007618 <etext+0x618>
    800044d0:	ac4fc0ef          	jal	80000794 <panic>
    return -1;
    800044d4:	557d                	li	a0,-1
}
    800044d6:	8082                	ret
      return -1;
    800044d8:	557d                	li	a0,-1
    800044da:	bfd9                	j	800044b0 <filewrite+0xf6>
    800044dc:	557d                	li	a0,-1
    800044de:	bfc9                	j	800044b0 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800044e0:	557d                	li	a0,-1
    800044e2:	79a2                	ld	s3,40(sp)
    800044e4:	b7f1                	j	800044b0 <filewrite+0xf6>

00000000800044e6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800044e6:	7179                	addi	sp,sp,-48
    800044e8:	f406                	sd	ra,40(sp)
    800044ea:	f022                	sd	s0,32(sp)
    800044ec:	ec26                	sd	s1,24(sp)
    800044ee:	e052                	sd	s4,0(sp)
    800044f0:	1800                	addi	s0,sp,48
    800044f2:	84aa                	mv	s1,a0
    800044f4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800044f6:	0005b023          	sd	zero,0(a1)
    800044fa:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800044fe:	c3bff0ef          	jal	80004138 <filealloc>
    80004502:	e088                	sd	a0,0(s1)
    80004504:	c549                	beqz	a0,8000458e <pipealloc+0xa8>
    80004506:	c33ff0ef          	jal	80004138 <filealloc>
    8000450a:	00aa3023          	sd	a0,0(s4)
    8000450e:	cd25                	beqz	a0,80004586 <pipealloc+0xa0>
    80004510:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004512:	e12fc0ef          	jal	80000b24 <kalloc>
    80004516:	892a                	mv	s2,a0
    80004518:	c12d                	beqz	a0,8000457a <pipealloc+0x94>
    8000451a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000451c:	4985                	li	s3,1
    8000451e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004522:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004526:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000452a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000452e:	00003597          	auipc	a1,0x3
    80004532:	0fa58593          	addi	a1,a1,250 # 80007628 <etext+0x628>
    80004536:	e3efc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    8000453a:	609c                	ld	a5,0(s1)
    8000453c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004540:	609c                	ld	a5,0(s1)
    80004542:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004546:	609c                	ld	a5,0(s1)
    80004548:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000454c:	609c                	ld	a5,0(s1)
    8000454e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004552:	000a3783          	ld	a5,0(s4)
    80004556:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000455a:	000a3783          	ld	a5,0(s4)
    8000455e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004562:	000a3783          	ld	a5,0(s4)
    80004566:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000456a:	000a3783          	ld	a5,0(s4)
    8000456e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004572:	4501                	li	a0,0
    80004574:	6942                	ld	s2,16(sp)
    80004576:	69a2                	ld	s3,8(sp)
    80004578:	a01d                	j	8000459e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000457a:	6088                	ld	a0,0(s1)
    8000457c:	c119                	beqz	a0,80004582 <pipealloc+0x9c>
    8000457e:	6942                	ld	s2,16(sp)
    80004580:	a029                	j	8000458a <pipealloc+0xa4>
    80004582:	6942                	ld	s2,16(sp)
    80004584:	a029                	j	8000458e <pipealloc+0xa8>
    80004586:	6088                	ld	a0,0(s1)
    80004588:	c10d                	beqz	a0,800045aa <pipealloc+0xc4>
    fileclose(*f0);
    8000458a:	c53ff0ef          	jal	800041dc <fileclose>
  if(*f1)
    8000458e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004592:	557d                	li	a0,-1
  if(*f1)
    80004594:	c789                	beqz	a5,8000459e <pipealloc+0xb8>
    fileclose(*f1);
    80004596:	853e                	mv	a0,a5
    80004598:	c45ff0ef          	jal	800041dc <fileclose>
  return -1;
    8000459c:	557d                	li	a0,-1
}
    8000459e:	70a2                	ld	ra,40(sp)
    800045a0:	7402                	ld	s0,32(sp)
    800045a2:	64e2                	ld	s1,24(sp)
    800045a4:	6a02                	ld	s4,0(sp)
    800045a6:	6145                	addi	sp,sp,48
    800045a8:	8082                	ret
  return -1;
    800045aa:	557d                	li	a0,-1
    800045ac:	bfcd                	j	8000459e <pipealloc+0xb8>

00000000800045ae <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800045ae:	1101                	addi	sp,sp,-32
    800045b0:	ec06                	sd	ra,24(sp)
    800045b2:	e822                	sd	s0,16(sp)
    800045b4:	e426                	sd	s1,8(sp)
    800045b6:	e04a                	sd	s2,0(sp)
    800045b8:	1000                	addi	s0,sp,32
    800045ba:	84aa                	mv	s1,a0
    800045bc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800045be:	e36fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    800045c2:	02090763          	beqz	s2,800045f0 <pipeclose+0x42>
    pi->writeopen = 0;
    800045c6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800045ca:	21848513          	addi	a0,s1,536
    800045ce:	c69fd0ef          	jal	80002236 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800045d2:	2204b783          	ld	a5,544(s1)
    800045d6:	e785                	bnez	a5,800045fe <pipeclose+0x50>
    release(&pi->lock);
    800045d8:	8526                	mv	a0,s1
    800045da:	eb2fc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    800045de:	8526                	mv	a0,s1
    800045e0:	c62fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    800045e4:	60e2                	ld	ra,24(sp)
    800045e6:	6442                	ld	s0,16(sp)
    800045e8:	64a2                	ld	s1,8(sp)
    800045ea:	6902                	ld	s2,0(sp)
    800045ec:	6105                	addi	sp,sp,32
    800045ee:	8082                	ret
    pi->readopen = 0;
    800045f0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800045f4:	21c48513          	addi	a0,s1,540
    800045f8:	c3ffd0ef          	jal	80002236 <wakeup>
    800045fc:	bfd9                	j	800045d2 <pipeclose+0x24>
    release(&pi->lock);
    800045fe:	8526                	mv	a0,s1
    80004600:	e8cfc0ef          	jal	80000c8c <release>
}
    80004604:	b7c5                	j	800045e4 <pipeclose+0x36>

0000000080004606 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004606:	711d                	addi	sp,sp,-96
    80004608:	ec86                	sd	ra,88(sp)
    8000460a:	e8a2                	sd	s0,80(sp)
    8000460c:	e4a6                	sd	s1,72(sp)
    8000460e:	e0ca                	sd	s2,64(sp)
    80004610:	fc4e                	sd	s3,56(sp)
    80004612:	f852                	sd	s4,48(sp)
    80004614:	f456                	sd	s5,40(sp)
    80004616:	1080                	addi	s0,sp,96
    80004618:	84aa                	mv	s1,a0
    8000461a:	8aae                	mv	s5,a1
    8000461c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000461e:	d5cfd0ef          	jal	80001b7a <myproc>
    80004622:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004624:	8526                	mv	a0,s1
    80004626:	dcefc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    8000462a:	0b405a63          	blez	s4,800046de <pipewrite+0xd8>
    8000462e:	f05a                	sd	s6,32(sp)
    80004630:	ec5e                	sd	s7,24(sp)
    80004632:	e862                	sd	s8,16(sp)
  int i = 0;
    80004634:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004636:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004638:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000463c:	21c48b93          	addi	s7,s1,540
    80004640:	a81d                	j	80004676 <pipewrite+0x70>
      release(&pi->lock);
    80004642:	8526                	mv	a0,s1
    80004644:	e48fc0ef          	jal	80000c8c <release>
      return -1;
    80004648:	597d                	li	s2,-1
    8000464a:	7b02                	ld	s6,32(sp)
    8000464c:	6be2                	ld	s7,24(sp)
    8000464e:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004650:	854a                	mv	a0,s2
    80004652:	60e6                	ld	ra,88(sp)
    80004654:	6446                	ld	s0,80(sp)
    80004656:	64a6                	ld	s1,72(sp)
    80004658:	6906                	ld	s2,64(sp)
    8000465a:	79e2                	ld	s3,56(sp)
    8000465c:	7a42                	ld	s4,48(sp)
    8000465e:	7aa2                	ld	s5,40(sp)
    80004660:	6125                	addi	sp,sp,96
    80004662:	8082                	ret
      wakeup(&pi->nread);
    80004664:	8562                	mv	a0,s8
    80004666:	bd1fd0ef          	jal	80002236 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000466a:	85a6                	mv	a1,s1
    8000466c:	855e                	mv	a0,s7
    8000466e:	b7dfd0ef          	jal	800021ea <sleep>
  while(i < n){
    80004672:	05495b63          	bge	s2,s4,800046c8 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004676:	2204a783          	lw	a5,544(s1)
    8000467a:	d7e1                	beqz	a5,80004642 <pipewrite+0x3c>
    8000467c:	854e                	mv	a0,s3
    8000467e:	da5fd0ef          	jal	80002422 <killed>
    80004682:	f161                	bnez	a0,80004642 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004684:	2184a783          	lw	a5,536(s1)
    80004688:	21c4a703          	lw	a4,540(s1)
    8000468c:	2007879b          	addiw	a5,a5,512
    80004690:	fcf70ae3          	beq	a4,a5,80004664 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004694:	4685                	li	a3,1
    80004696:	01590633          	add	a2,s2,s5
    8000469a:	faf40593          	addi	a1,s0,-81
    8000469e:	0609b503          	ld	a0,96(s3)
    800046a2:	f87fc0ef          	jal	80001628 <copyin>
    800046a6:	03650e63          	beq	a0,s6,800046e2 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800046aa:	21c4a783          	lw	a5,540(s1)
    800046ae:	0017871b          	addiw	a4,a5,1
    800046b2:	20e4ae23          	sw	a4,540(s1)
    800046b6:	1ff7f793          	andi	a5,a5,511
    800046ba:	97a6                	add	a5,a5,s1
    800046bc:	faf44703          	lbu	a4,-81(s0)
    800046c0:	00e78c23          	sb	a4,24(a5)
      i++;
    800046c4:	2905                	addiw	s2,s2,1
    800046c6:	b775                	j	80004672 <pipewrite+0x6c>
    800046c8:	7b02                	ld	s6,32(sp)
    800046ca:	6be2                	ld	s7,24(sp)
    800046cc:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800046ce:	21848513          	addi	a0,s1,536
    800046d2:	b65fd0ef          	jal	80002236 <wakeup>
  release(&pi->lock);
    800046d6:	8526                	mv	a0,s1
    800046d8:	db4fc0ef          	jal	80000c8c <release>
  return i;
    800046dc:	bf95                	j	80004650 <pipewrite+0x4a>
  int i = 0;
    800046de:	4901                	li	s2,0
    800046e0:	b7fd                	j	800046ce <pipewrite+0xc8>
    800046e2:	7b02                	ld	s6,32(sp)
    800046e4:	6be2                	ld	s7,24(sp)
    800046e6:	6c42                	ld	s8,16(sp)
    800046e8:	b7dd                	j	800046ce <pipewrite+0xc8>

00000000800046ea <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800046ea:	715d                	addi	sp,sp,-80
    800046ec:	e486                	sd	ra,72(sp)
    800046ee:	e0a2                	sd	s0,64(sp)
    800046f0:	fc26                	sd	s1,56(sp)
    800046f2:	f84a                	sd	s2,48(sp)
    800046f4:	f44e                	sd	s3,40(sp)
    800046f6:	f052                	sd	s4,32(sp)
    800046f8:	ec56                	sd	s5,24(sp)
    800046fa:	0880                	addi	s0,sp,80
    800046fc:	84aa                	mv	s1,a0
    800046fe:	892e                	mv	s2,a1
    80004700:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004702:	c78fd0ef          	jal	80001b7a <myproc>
    80004706:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004708:	8526                	mv	a0,s1
    8000470a:	ceafc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000470e:	2184a703          	lw	a4,536(s1)
    80004712:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004716:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000471a:	02f71563          	bne	a4,a5,80004744 <piperead+0x5a>
    8000471e:	2244a783          	lw	a5,548(s1)
    80004722:	cb85                	beqz	a5,80004752 <piperead+0x68>
    if(killed(pr)){
    80004724:	8552                	mv	a0,s4
    80004726:	cfdfd0ef          	jal	80002422 <killed>
    8000472a:	ed19                	bnez	a0,80004748 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000472c:	85a6                	mv	a1,s1
    8000472e:	854e                	mv	a0,s3
    80004730:	abbfd0ef          	jal	800021ea <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004734:	2184a703          	lw	a4,536(s1)
    80004738:	21c4a783          	lw	a5,540(s1)
    8000473c:	fef701e3          	beq	a4,a5,8000471e <piperead+0x34>
    80004740:	e85a                	sd	s6,16(sp)
    80004742:	a809                	j	80004754 <piperead+0x6a>
    80004744:	e85a                	sd	s6,16(sp)
    80004746:	a039                	j	80004754 <piperead+0x6a>
      release(&pi->lock);
    80004748:	8526                	mv	a0,s1
    8000474a:	d42fc0ef          	jal	80000c8c <release>
      return -1;
    8000474e:	59fd                	li	s3,-1
    80004750:	a8b1                	j	800047ac <piperead+0xc2>
    80004752:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004754:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004756:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004758:	05505263          	blez	s5,8000479c <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000475c:	2184a783          	lw	a5,536(s1)
    80004760:	21c4a703          	lw	a4,540(s1)
    80004764:	02f70c63          	beq	a4,a5,8000479c <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004768:	0017871b          	addiw	a4,a5,1
    8000476c:	20e4ac23          	sw	a4,536(s1)
    80004770:	1ff7f793          	andi	a5,a5,511
    80004774:	97a6                	add	a5,a5,s1
    80004776:	0187c783          	lbu	a5,24(a5)
    8000477a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000477e:	4685                	li	a3,1
    80004780:	fbf40613          	addi	a2,s0,-65
    80004784:	85ca                	mv	a1,s2
    80004786:	060a3503          	ld	a0,96(s4)
    8000478a:	dc9fc0ef          	jal	80001552 <copyout>
    8000478e:	01650763          	beq	a0,s6,8000479c <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004792:	2985                	addiw	s3,s3,1
    80004794:	0905                	addi	s2,s2,1
    80004796:	fd3a93e3          	bne	s5,s3,8000475c <piperead+0x72>
    8000479a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000479c:	21c48513          	addi	a0,s1,540
    800047a0:	a97fd0ef          	jal	80002236 <wakeup>
  release(&pi->lock);
    800047a4:	8526                	mv	a0,s1
    800047a6:	ce6fc0ef          	jal	80000c8c <release>
    800047aa:	6b42                	ld	s6,16(sp)
  return i;
}
    800047ac:	854e                	mv	a0,s3
    800047ae:	60a6                	ld	ra,72(sp)
    800047b0:	6406                	ld	s0,64(sp)
    800047b2:	74e2                	ld	s1,56(sp)
    800047b4:	7942                	ld	s2,48(sp)
    800047b6:	79a2                	ld	s3,40(sp)
    800047b8:	7a02                	ld	s4,32(sp)
    800047ba:	6ae2                	ld	s5,24(sp)
    800047bc:	6161                	addi	sp,sp,80
    800047be:	8082                	ret

00000000800047c0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800047c0:	1141                	addi	sp,sp,-16
    800047c2:	e422                	sd	s0,8(sp)
    800047c4:	0800                	addi	s0,sp,16
    800047c6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800047c8:	8905                	andi	a0,a0,1
    800047ca:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800047cc:	8b89                	andi	a5,a5,2
    800047ce:	c399                	beqz	a5,800047d4 <flags2perm+0x14>
      perm |= PTE_W;
    800047d0:	00456513          	ori	a0,a0,4
    return perm;
}
    800047d4:	6422                	ld	s0,8(sp)
    800047d6:	0141                	addi	sp,sp,16
    800047d8:	8082                	ret

00000000800047da <exec>:

int
exec(char *path, char **argv)
{
    800047da:	df010113          	addi	sp,sp,-528
    800047de:	20113423          	sd	ra,520(sp)
    800047e2:	20813023          	sd	s0,512(sp)
    800047e6:	ffa6                	sd	s1,504(sp)
    800047e8:	fbca                	sd	s2,496(sp)
    800047ea:	0c00                	addi	s0,sp,528
    800047ec:	892a                	mv	s2,a0
    800047ee:	dea43c23          	sd	a0,-520(s0)
    800047f2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800047f6:	b84fd0ef          	jal	80001b7a <myproc>
    800047fa:	84aa                	mv	s1,a0

  begin_op();
    800047fc:	dc6ff0ef          	jal	80003dc2 <begin_op>

  if((ip = namei(path)) == 0){
    80004800:	854a                	mv	a0,s2
    80004802:	c04ff0ef          	jal	80003c06 <namei>
    80004806:	c931                	beqz	a0,8000485a <exec+0x80>
    80004808:	f3d2                	sd	s4,480(sp)
    8000480a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000480c:	d21fe0ef          	jal	8000352c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004810:	04000713          	li	a4,64
    80004814:	4681                	li	a3,0
    80004816:	e5040613          	addi	a2,s0,-432
    8000481a:	4581                	li	a1,0
    8000481c:	8552                	mv	a0,s4
    8000481e:	f63fe0ef          	jal	80003780 <readi>
    80004822:	04000793          	li	a5,64
    80004826:	00f51a63          	bne	a0,a5,8000483a <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000482a:	e5042703          	lw	a4,-432(s0)
    8000482e:	464c47b7          	lui	a5,0x464c4
    80004832:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004836:	02f70663          	beq	a4,a5,80004862 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000483a:	8552                	mv	a0,s4
    8000483c:	efbfe0ef          	jal	80003736 <iunlockput>
    end_op();
    80004840:	decff0ef          	jal	80003e2c <end_op>
  }
  return -1;
    80004844:	557d                	li	a0,-1
    80004846:	7a1e                	ld	s4,480(sp)
}
    80004848:	20813083          	ld	ra,520(sp)
    8000484c:	20013403          	ld	s0,512(sp)
    80004850:	74fe                	ld	s1,504(sp)
    80004852:	795e                	ld	s2,496(sp)
    80004854:	21010113          	addi	sp,sp,528
    80004858:	8082                	ret
    end_op();
    8000485a:	dd2ff0ef          	jal	80003e2c <end_op>
    return -1;
    8000485e:	557d                	li	a0,-1
    80004860:	b7e5                	j	80004848 <exec+0x6e>
    80004862:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004864:	8526                	mv	a0,s1
    80004866:	bbcfd0ef          	jal	80001c22 <proc_pagetable>
    8000486a:	8b2a                	mv	s6,a0
    8000486c:	2c050b63          	beqz	a0,80004b42 <exec+0x368>
    80004870:	f7ce                	sd	s3,488(sp)
    80004872:	efd6                	sd	s5,472(sp)
    80004874:	e7de                	sd	s7,456(sp)
    80004876:	e3e2                	sd	s8,448(sp)
    80004878:	ff66                	sd	s9,440(sp)
    8000487a:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000487c:	e7042d03          	lw	s10,-400(s0)
    80004880:	e8845783          	lhu	a5,-376(s0)
    80004884:	12078963          	beqz	a5,800049b6 <exec+0x1dc>
    80004888:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000488a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000488c:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000488e:	6c85                	lui	s9,0x1
    80004890:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004894:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004898:	6a85                	lui	s5,0x1
    8000489a:	a085                	j	800048fa <exec+0x120>
      panic("loadseg: address should exist");
    8000489c:	00003517          	auipc	a0,0x3
    800048a0:	d9450513          	addi	a0,a0,-620 # 80007630 <etext+0x630>
    800048a4:	ef1fb0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    800048a8:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800048aa:	8726                	mv	a4,s1
    800048ac:	012c06bb          	addw	a3,s8,s2
    800048b0:	4581                	li	a1,0
    800048b2:	8552                	mv	a0,s4
    800048b4:	ecdfe0ef          	jal	80003780 <readi>
    800048b8:	2501                	sext.w	a0,a0
    800048ba:	24a49a63          	bne	s1,a0,80004b0e <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800048be:	012a893b          	addw	s2,s5,s2
    800048c2:	03397363          	bgeu	s2,s3,800048e8 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800048c6:	02091593          	slli	a1,s2,0x20
    800048ca:	9181                	srli	a1,a1,0x20
    800048cc:	95de                	add	a1,a1,s7
    800048ce:	855a                	mv	a0,s6
    800048d0:	f06fc0ef          	jal	80000fd6 <walkaddr>
    800048d4:	862a                	mv	a2,a0
    if(pa == 0)
    800048d6:	d179                	beqz	a0,8000489c <exec+0xc2>
    if(sz - i < PGSIZE)
    800048d8:	412984bb          	subw	s1,s3,s2
    800048dc:	0004879b          	sext.w	a5,s1
    800048e0:	fcfcf4e3          	bgeu	s9,a5,800048a8 <exec+0xce>
    800048e4:	84d6                	mv	s1,s5
    800048e6:	b7c9                	j	800048a8 <exec+0xce>
    sz = sz1;
    800048e8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800048ec:	2d85                	addiw	s11,s11,1
    800048ee:	038d0d1b          	addiw	s10,s10,56
    800048f2:	e8845783          	lhu	a5,-376(s0)
    800048f6:	08fdd063          	bge	s11,a5,80004976 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800048fa:	2d01                	sext.w	s10,s10
    800048fc:	03800713          	li	a4,56
    80004900:	86ea                	mv	a3,s10
    80004902:	e1840613          	addi	a2,s0,-488
    80004906:	4581                	li	a1,0
    80004908:	8552                	mv	a0,s4
    8000490a:	e77fe0ef          	jal	80003780 <readi>
    8000490e:	03800793          	li	a5,56
    80004912:	1cf51663          	bne	a0,a5,80004ade <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004916:	e1842783          	lw	a5,-488(s0)
    8000491a:	4705                	li	a4,1
    8000491c:	fce798e3          	bne	a5,a4,800048ec <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004920:	e4043483          	ld	s1,-448(s0)
    80004924:	e3843783          	ld	a5,-456(s0)
    80004928:	1af4ef63          	bltu	s1,a5,80004ae6 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000492c:	e2843783          	ld	a5,-472(s0)
    80004930:	94be                	add	s1,s1,a5
    80004932:	1af4ee63          	bltu	s1,a5,80004aee <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004936:	df043703          	ld	a4,-528(s0)
    8000493a:	8ff9                	and	a5,a5,a4
    8000493c:	1a079d63          	bnez	a5,80004af6 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004940:	e1c42503          	lw	a0,-484(s0)
    80004944:	e7dff0ef          	jal	800047c0 <flags2perm>
    80004948:	86aa                	mv	a3,a0
    8000494a:	8626                	mv	a2,s1
    8000494c:	85ca                	mv	a1,s2
    8000494e:	855a                	mv	a0,s6
    80004950:	9effc0ef          	jal	8000133e <uvmalloc>
    80004954:	e0a43423          	sd	a0,-504(s0)
    80004958:	1a050363          	beqz	a0,80004afe <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000495c:	e2843b83          	ld	s7,-472(s0)
    80004960:	e2042c03          	lw	s8,-480(s0)
    80004964:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004968:	00098463          	beqz	s3,80004970 <exec+0x196>
    8000496c:	4901                	li	s2,0
    8000496e:	bfa1                	j	800048c6 <exec+0xec>
    sz = sz1;
    80004970:	e0843903          	ld	s2,-504(s0)
    80004974:	bfa5                	j	800048ec <exec+0x112>
    80004976:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004978:	8552                	mv	a0,s4
    8000497a:	dbdfe0ef          	jal	80003736 <iunlockput>
  end_op();
    8000497e:	caeff0ef          	jal	80003e2c <end_op>
  p = myproc();
    80004982:	9f8fd0ef          	jal	80001b7a <myproc>
    80004986:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004988:	05853c83          	ld	s9,88(a0)
  sz = PGROUNDUP(sz);
    8000498c:	6985                	lui	s3,0x1
    8000498e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004990:	99ca                	add	s3,s3,s2
    80004992:	77fd                	lui	a5,0xfffff
    80004994:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004998:	4691                	li	a3,4
    8000499a:	6609                	lui	a2,0x2
    8000499c:	964e                	add	a2,a2,s3
    8000499e:	85ce                	mv	a1,s3
    800049a0:	855a                	mv	a0,s6
    800049a2:	99dfc0ef          	jal	8000133e <uvmalloc>
    800049a6:	892a                	mv	s2,a0
    800049a8:	e0a43423          	sd	a0,-504(s0)
    800049ac:	e519                	bnez	a0,800049ba <exec+0x1e0>
  if(pagetable)
    800049ae:	e1343423          	sd	s3,-504(s0)
    800049b2:	4a01                	li	s4,0
    800049b4:	aab1                	j	80004b10 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800049b6:	4901                	li	s2,0
    800049b8:	b7c1                	j	80004978 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800049ba:	75f9                	lui	a1,0xffffe
    800049bc:	95aa                	add	a1,a1,a0
    800049be:	855a                	mv	a0,s6
    800049c0:	b69fc0ef          	jal	80001528 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800049c4:	7bfd                	lui	s7,0xfffff
    800049c6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800049c8:	e0043783          	ld	a5,-512(s0)
    800049cc:	6388                	ld	a0,0(a5)
    800049ce:	cd39                	beqz	a0,80004a2c <exec+0x252>
    800049d0:	e9040993          	addi	s3,s0,-368
    800049d4:	f9040c13          	addi	s8,s0,-112
    800049d8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800049da:	c5efc0ef          	jal	80000e38 <strlen>
    800049de:	0015079b          	addiw	a5,a0,1
    800049e2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800049e6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800049ea:	11796e63          	bltu	s2,s7,80004b06 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800049ee:	e0043d03          	ld	s10,-512(s0)
    800049f2:	000d3a03          	ld	s4,0(s10)
    800049f6:	8552                	mv	a0,s4
    800049f8:	c40fc0ef          	jal	80000e38 <strlen>
    800049fc:	0015069b          	addiw	a3,a0,1
    80004a00:	8652                	mv	a2,s4
    80004a02:	85ca                	mv	a1,s2
    80004a04:	855a                	mv	a0,s6
    80004a06:	b4dfc0ef          	jal	80001552 <copyout>
    80004a0a:	10054063          	bltz	a0,80004b0a <exec+0x330>
    ustack[argc] = sp;
    80004a0e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004a12:	0485                	addi	s1,s1,1
    80004a14:	008d0793          	addi	a5,s10,8
    80004a18:	e0f43023          	sd	a5,-512(s0)
    80004a1c:	008d3503          	ld	a0,8(s10)
    80004a20:	c909                	beqz	a0,80004a32 <exec+0x258>
    if(argc >= MAXARG)
    80004a22:	09a1                	addi	s3,s3,8
    80004a24:	fb899be3          	bne	s3,s8,800049da <exec+0x200>
  ip = 0;
    80004a28:	4a01                	li	s4,0
    80004a2a:	a0dd                	j	80004b10 <exec+0x336>
  sp = sz;
    80004a2c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004a30:	4481                	li	s1,0
  ustack[argc] = 0;
    80004a32:	00349793          	slli	a5,s1,0x3
    80004a36:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb4d0>
    80004a3a:	97a2                	add	a5,a5,s0
    80004a3c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004a40:	00148693          	addi	a3,s1,1
    80004a44:	068e                	slli	a3,a3,0x3
    80004a46:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004a4a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004a4e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004a52:	f5796ee3          	bltu	s2,s7,800049ae <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004a56:	e9040613          	addi	a2,s0,-368
    80004a5a:	85ca                	mv	a1,s2
    80004a5c:	855a                	mv	a0,s6
    80004a5e:	af5fc0ef          	jal	80001552 <copyout>
    80004a62:	0e054263          	bltz	a0,80004b46 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004a66:	068ab783          	ld	a5,104(s5) # 1068 <_entry-0x7fffef98>
    80004a6a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004a6e:	df843783          	ld	a5,-520(s0)
    80004a72:	0007c703          	lbu	a4,0(a5)
    80004a76:	cf11                	beqz	a4,80004a92 <exec+0x2b8>
    80004a78:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004a7a:	02f00693          	li	a3,47
    80004a7e:	a039                	j	80004a8c <exec+0x2b2>
      last = s+1;
    80004a80:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004a84:	0785                	addi	a5,a5,1
    80004a86:	fff7c703          	lbu	a4,-1(a5)
    80004a8a:	c701                	beqz	a4,80004a92 <exec+0x2b8>
    if(*s == '/')
    80004a8c:	fed71ce3          	bne	a4,a3,80004a84 <exec+0x2aa>
    80004a90:	bfc5                	j	80004a80 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004a92:	4641                	li	a2,16
    80004a94:	df843583          	ld	a1,-520(s0)
    80004a98:	168a8513          	addi	a0,s5,360
    80004a9c:	b6afc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004aa0:	060ab503          	ld	a0,96(s5)
  p->pagetable = pagetable;
    80004aa4:	076ab023          	sd	s6,96(s5)
  p->sz = sz;
    80004aa8:	e0843783          	ld	a5,-504(s0)
    80004aac:	04fabc23          	sd	a5,88(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004ab0:	068ab783          	ld	a5,104(s5)
    80004ab4:	e6843703          	ld	a4,-408(s0)
    80004ab8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004aba:	068ab783          	ld	a5,104(s5)
    80004abe:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004ac2:	85e6                	mv	a1,s9
    80004ac4:	9e2fd0ef          	jal	80001ca6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004ac8:	0004851b          	sext.w	a0,s1
    80004acc:	79be                	ld	s3,488(sp)
    80004ace:	7a1e                	ld	s4,480(sp)
    80004ad0:	6afe                	ld	s5,472(sp)
    80004ad2:	6b5e                	ld	s6,464(sp)
    80004ad4:	6bbe                	ld	s7,456(sp)
    80004ad6:	6c1e                	ld	s8,448(sp)
    80004ad8:	7cfa                	ld	s9,440(sp)
    80004ada:	7d5a                	ld	s10,432(sp)
    80004adc:	b3b5                	j	80004848 <exec+0x6e>
    80004ade:	e1243423          	sd	s2,-504(s0)
    80004ae2:	7dba                	ld	s11,424(sp)
    80004ae4:	a035                	j	80004b10 <exec+0x336>
    80004ae6:	e1243423          	sd	s2,-504(s0)
    80004aea:	7dba                	ld	s11,424(sp)
    80004aec:	a015                	j	80004b10 <exec+0x336>
    80004aee:	e1243423          	sd	s2,-504(s0)
    80004af2:	7dba                	ld	s11,424(sp)
    80004af4:	a831                	j	80004b10 <exec+0x336>
    80004af6:	e1243423          	sd	s2,-504(s0)
    80004afa:	7dba                	ld	s11,424(sp)
    80004afc:	a811                	j	80004b10 <exec+0x336>
    80004afe:	e1243423          	sd	s2,-504(s0)
    80004b02:	7dba                	ld	s11,424(sp)
    80004b04:	a031                	j	80004b10 <exec+0x336>
  ip = 0;
    80004b06:	4a01                	li	s4,0
    80004b08:	a021                	j	80004b10 <exec+0x336>
    80004b0a:	4a01                	li	s4,0
  if(pagetable)
    80004b0c:	a011                	j	80004b10 <exec+0x336>
    80004b0e:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004b10:	e0843583          	ld	a1,-504(s0)
    80004b14:	855a                	mv	a0,s6
    80004b16:	990fd0ef          	jal	80001ca6 <proc_freepagetable>
  return -1;
    80004b1a:	557d                	li	a0,-1
  if(ip){
    80004b1c:	000a1b63          	bnez	s4,80004b32 <exec+0x358>
    80004b20:	79be                	ld	s3,488(sp)
    80004b22:	7a1e                	ld	s4,480(sp)
    80004b24:	6afe                	ld	s5,472(sp)
    80004b26:	6b5e                	ld	s6,464(sp)
    80004b28:	6bbe                	ld	s7,456(sp)
    80004b2a:	6c1e                	ld	s8,448(sp)
    80004b2c:	7cfa                	ld	s9,440(sp)
    80004b2e:	7d5a                	ld	s10,432(sp)
    80004b30:	bb21                	j	80004848 <exec+0x6e>
    80004b32:	79be                	ld	s3,488(sp)
    80004b34:	6afe                	ld	s5,472(sp)
    80004b36:	6b5e                	ld	s6,464(sp)
    80004b38:	6bbe                	ld	s7,456(sp)
    80004b3a:	6c1e                	ld	s8,448(sp)
    80004b3c:	7cfa                	ld	s9,440(sp)
    80004b3e:	7d5a                	ld	s10,432(sp)
    80004b40:	b9ed                	j	8000483a <exec+0x60>
    80004b42:	6b5e                	ld	s6,464(sp)
    80004b44:	b9dd                	j	8000483a <exec+0x60>
  sz = sz1;
    80004b46:	e0843983          	ld	s3,-504(s0)
    80004b4a:	b595                	j	800049ae <exec+0x1d4>

0000000080004b4c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004b4c:	7179                	addi	sp,sp,-48
    80004b4e:	f406                	sd	ra,40(sp)
    80004b50:	f022                	sd	s0,32(sp)
    80004b52:	ec26                	sd	s1,24(sp)
    80004b54:	e84a                	sd	s2,16(sp)
    80004b56:	1800                	addi	s0,sp,48
    80004b58:	892e                	mv	s2,a1
    80004b5a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004b5c:	fdc40593          	addi	a1,s0,-36
    80004b60:	f71fd0ef          	jal	80002ad0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004b64:	fdc42703          	lw	a4,-36(s0)
    80004b68:	47bd                	li	a5,15
    80004b6a:	02e7e963          	bltu	a5,a4,80004b9c <argfd+0x50>
    80004b6e:	80cfd0ef          	jal	80001b7a <myproc>
    80004b72:	fdc42703          	lw	a4,-36(s0)
    80004b76:	01c70793          	addi	a5,a4,28
    80004b7a:	078e                	slli	a5,a5,0x3
    80004b7c:	953e                	add	a0,a0,a5
    80004b7e:	611c                	ld	a5,0(a0)
    80004b80:	c385                	beqz	a5,80004ba0 <argfd+0x54>
    return -1;
  if(pfd)
    80004b82:	00090463          	beqz	s2,80004b8a <argfd+0x3e>
    *pfd = fd;
    80004b86:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004b8a:	4501                	li	a0,0
  if(pf)
    80004b8c:	c091                	beqz	s1,80004b90 <argfd+0x44>
    *pf = f;
    80004b8e:	e09c                	sd	a5,0(s1)
}
    80004b90:	70a2                	ld	ra,40(sp)
    80004b92:	7402                	ld	s0,32(sp)
    80004b94:	64e2                	ld	s1,24(sp)
    80004b96:	6942                	ld	s2,16(sp)
    80004b98:	6145                	addi	sp,sp,48
    80004b9a:	8082                	ret
    return -1;
    80004b9c:	557d                	li	a0,-1
    80004b9e:	bfcd                	j	80004b90 <argfd+0x44>
    80004ba0:	557d                	li	a0,-1
    80004ba2:	b7fd                	j	80004b90 <argfd+0x44>

0000000080004ba4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004ba4:	1101                	addi	sp,sp,-32
    80004ba6:	ec06                	sd	ra,24(sp)
    80004ba8:	e822                	sd	s0,16(sp)
    80004baa:	e426                	sd	s1,8(sp)
    80004bac:	1000                	addi	s0,sp,32
    80004bae:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004bb0:	fcbfc0ef          	jal	80001b7a <myproc>
    80004bb4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004bb6:	0e050793          	addi	a5,a0,224
    80004bba:	4501                	li	a0,0
    80004bbc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004bbe:	6398                	ld	a4,0(a5)
    80004bc0:	cb19                	beqz	a4,80004bd6 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004bc2:	2505                	addiw	a0,a0,1
    80004bc4:	07a1                	addi	a5,a5,8
    80004bc6:	fed51ce3          	bne	a0,a3,80004bbe <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004bca:	557d                	li	a0,-1
}
    80004bcc:	60e2                	ld	ra,24(sp)
    80004bce:	6442                	ld	s0,16(sp)
    80004bd0:	64a2                	ld	s1,8(sp)
    80004bd2:	6105                	addi	sp,sp,32
    80004bd4:	8082                	ret
      p->ofile[fd] = f;
    80004bd6:	01c50793          	addi	a5,a0,28
    80004bda:	078e                	slli	a5,a5,0x3
    80004bdc:	963e                	add	a2,a2,a5
    80004bde:	e204                	sd	s1,0(a2)
      return fd;
    80004be0:	b7f5                	j	80004bcc <fdalloc+0x28>

0000000080004be2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004be2:	715d                	addi	sp,sp,-80
    80004be4:	e486                	sd	ra,72(sp)
    80004be6:	e0a2                	sd	s0,64(sp)
    80004be8:	fc26                	sd	s1,56(sp)
    80004bea:	f84a                	sd	s2,48(sp)
    80004bec:	f44e                	sd	s3,40(sp)
    80004bee:	ec56                	sd	s5,24(sp)
    80004bf0:	e85a                	sd	s6,16(sp)
    80004bf2:	0880                	addi	s0,sp,80
    80004bf4:	8b2e                	mv	s6,a1
    80004bf6:	89b2                	mv	s3,a2
    80004bf8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004bfa:	fb040593          	addi	a1,s0,-80
    80004bfe:	822ff0ef          	jal	80003c20 <nameiparent>
    80004c02:	84aa                	mv	s1,a0
    80004c04:	10050a63          	beqz	a0,80004d18 <create+0x136>
    return 0;

  ilock(dp);
    80004c08:	925fe0ef          	jal	8000352c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004c0c:	4601                	li	a2,0
    80004c0e:	fb040593          	addi	a1,s0,-80
    80004c12:	8526                	mv	a0,s1
    80004c14:	d8dfe0ef          	jal	800039a0 <dirlookup>
    80004c18:	8aaa                	mv	s5,a0
    80004c1a:	c129                	beqz	a0,80004c5c <create+0x7a>
    iunlockput(dp);
    80004c1c:	8526                	mv	a0,s1
    80004c1e:	b19fe0ef          	jal	80003736 <iunlockput>
    ilock(ip);
    80004c22:	8556                	mv	a0,s5
    80004c24:	909fe0ef          	jal	8000352c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004c28:	4789                	li	a5,2
    80004c2a:	02fb1463          	bne	s6,a5,80004c52 <create+0x70>
    80004c2e:	044ad783          	lhu	a5,68(s5)
    80004c32:	37f9                	addiw	a5,a5,-2
    80004c34:	17c2                	slli	a5,a5,0x30
    80004c36:	93c1                	srli	a5,a5,0x30
    80004c38:	4705                	li	a4,1
    80004c3a:	00f76c63          	bltu	a4,a5,80004c52 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004c3e:	8556                	mv	a0,s5
    80004c40:	60a6                	ld	ra,72(sp)
    80004c42:	6406                	ld	s0,64(sp)
    80004c44:	74e2                	ld	s1,56(sp)
    80004c46:	7942                	ld	s2,48(sp)
    80004c48:	79a2                	ld	s3,40(sp)
    80004c4a:	6ae2                	ld	s5,24(sp)
    80004c4c:	6b42                	ld	s6,16(sp)
    80004c4e:	6161                	addi	sp,sp,80
    80004c50:	8082                	ret
    iunlockput(ip);
    80004c52:	8556                	mv	a0,s5
    80004c54:	ae3fe0ef          	jal	80003736 <iunlockput>
    return 0;
    80004c58:	4a81                	li	s5,0
    80004c5a:	b7d5                	j	80004c3e <create+0x5c>
    80004c5c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004c5e:	85da                	mv	a1,s6
    80004c60:	4088                	lw	a0,0(s1)
    80004c62:	f5afe0ef          	jal	800033bc <ialloc>
    80004c66:	8a2a                	mv	s4,a0
    80004c68:	cd15                	beqz	a0,80004ca4 <create+0xc2>
  ilock(ip);
    80004c6a:	8c3fe0ef          	jal	8000352c <ilock>
  ip->major = major;
    80004c6e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004c72:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004c76:	4905                	li	s2,1
    80004c78:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004c7c:	8552                	mv	a0,s4
    80004c7e:	ffafe0ef          	jal	80003478 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004c82:	032b0763          	beq	s6,s2,80004cb0 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004c86:	004a2603          	lw	a2,4(s4)
    80004c8a:	fb040593          	addi	a1,s0,-80
    80004c8e:	8526                	mv	a0,s1
    80004c90:	eddfe0ef          	jal	80003b6c <dirlink>
    80004c94:	06054563          	bltz	a0,80004cfe <create+0x11c>
  iunlockput(dp);
    80004c98:	8526                	mv	a0,s1
    80004c9a:	a9dfe0ef          	jal	80003736 <iunlockput>
  return ip;
    80004c9e:	8ad2                	mv	s5,s4
    80004ca0:	7a02                	ld	s4,32(sp)
    80004ca2:	bf71                	j	80004c3e <create+0x5c>
    iunlockput(dp);
    80004ca4:	8526                	mv	a0,s1
    80004ca6:	a91fe0ef          	jal	80003736 <iunlockput>
    return 0;
    80004caa:	8ad2                	mv	s5,s4
    80004cac:	7a02                	ld	s4,32(sp)
    80004cae:	bf41                	j	80004c3e <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004cb0:	004a2603          	lw	a2,4(s4)
    80004cb4:	00003597          	auipc	a1,0x3
    80004cb8:	99c58593          	addi	a1,a1,-1636 # 80007650 <etext+0x650>
    80004cbc:	8552                	mv	a0,s4
    80004cbe:	eaffe0ef          	jal	80003b6c <dirlink>
    80004cc2:	02054e63          	bltz	a0,80004cfe <create+0x11c>
    80004cc6:	40d0                	lw	a2,4(s1)
    80004cc8:	00003597          	auipc	a1,0x3
    80004ccc:	99058593          	addi	a1,a1,-1648 # 80007658 <etext+0x658>
    80004cd0:	8552                	mv	a0,s4
    80004cd2:	e9bfe0ef          	jal	80003b6c <dirlink>
    80004cd6:	02054463          	bltz	a0,80004cfe <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004cda:	004a2603          	lw	a2,4(s4)
    80004cde:	fb040593          	addi	a1,s0,-80
    80004ce2:	8526                	mv	a0,s1
    80004ce4:	e89fe0ef          	jal	80003b6c <dirlink>
    80004ce8:	00054b63          	bltz	a0,80004cfe <create+0x11c>
    dp->nlink++;  // for ".."
    80004cec:	04a4d783          	lhu	a5,74(s1)
    80004cf0:	2785                	addiw	a5,a5,1
    80004cf2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	f80fe0ef          	jal	80003478 <iupdate>
    80004cfc:	bf71                	j	80004c98 <create+0xb6>
  ip->nlink = 0;
    80004cfe:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004d02:	8552                	mv	a0,s4
    80004d04:	f74fe0ef          	jal	80003478 <iupdate>
  iunlockput(ip);
    80004d08:	8552                	mv	a0,s4
    80004d0a:	a2dfe0ef          	jal	80003736 <iunlockput>
  iunlockput(dp);
    80004d0e:	8526                	mv	a0,s1
    80004d10:	a27fe0ef          	jal	80003736 <iunlockput>
  return 0;
    80004d14:	7a02                	ld	s4,32(sp)
    80004d16:	b725                	j	80004c3e <create+0x5c>
    return 0;
    80004d18:	8aaa                	mv	s5,a0
    80004d1a:	b715                	j	80004c3e <create+0x5c>

0000000080004d1c <sys_dup>:
{
    80004d1c:	7179                	addi	sp,sp,-48
    80004d1e:	f406                	sd	ra,40(sp)
    80004d20:	f022                	sd	s0,32(sp)
    80004d22:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004d24:	fd840613          	addi	a2,s0,-40
    80004d28:	4581                	li	a1,0
    80004d2a:	4501                	li	a0,0
    80004d2c:	e21ff0ef          	jal	80004b4c <argfd>
    return -1;
    80004d30:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004d32:	02054363          	bltz	a0,80004d58 <sys_dup+0x3c>
    80004d36:	ec26                	sd	s1,24(sp)
    80004d38:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004d3a:	fd843903          	ld	s2,-40(s0)
    80004d3e:	854a                	mv	a0,s2
    80004d40:	e65ff0ef          	jal	80004ba4 <fdalloc>
    80004d44:	84aa                	mv	s1,a0
    return -1;
    80004d46:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004d48:	00054d63          	bltz	a0,80004d62 <sys_dup+0x46>
  filedup(f);
    80004d4c:	854a                	mv	a0,s2
    80004d4e:	c48ff0ef          	jal	80004196 <filedup>
  return fd;
    80004d52:	87a6                	mv	a5,s1
    80004d54:	64e2                	ld	s1,24(sp)
    80004d56:	6942                	ld	s2,16(sp)
}
    80004d58:	853e                	mv	a0,a5
    80004d5a:	70a2                	ld	ra,40(sp)
    80004d5c:	7402                	ld	s0,32(sp)
    80004d5e:	6145                	addi	sp,sp,48
    80004d60:	8082                	ret
    80004d62:	64e2                	ld	s1,24(sp)
    80004d64:	6942                	ld	s2,16(sp)
    80004d66:	bfcd                	j	80004d58 <sys_dup+0x3c>

0000000080004d68 <sys_read>:
{
    80004d68:	7179                	addi	sp,sp,-48
    80004d6a:	f406                	sd	ra,40(sp)
    80004d6c:	f022                	sd	s0,32(sp)
    80004d6e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d70:	fd840593          	addi	a1,s0,-40
    80004d74:	4505                	li	a0,1
    80004d76:	d77fd0ef          	jal	80002aec <argaddr>
  argint(2, &n);
    80004d7a:	fe440593          	addi	a1,s0,-28
    80004d7e:	4509                	li	a0,2
    80004d80:	d51fd0ef          	jal	80002ad0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004d84:	fe840613          	addi	a2,s0,-24
    80004d88:	4581                	li	a1,0
    80004d8a:	4501                	li	a0,0
    80004d8c:	dc1ff0ef          	jal	80004b4c <argfd>
    80004d90:	87aa                	mv	a5,a0
    return -1;
    80004d92:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d94:	0007ca63          	bltz	a5,80004da8 <sys_read+0x40>
  return fileread(f, p, n);
    80004d98:	fe442603          	lw	a2,-28(s0)
    80004d9c:	fd843583          	ld	a1,-40(s0)
    80004da0:	fe843503          	ld	a0,-24(s0)
    80004da4:	d58ff0ef          	jal	800042fc <fileread>
}
    80004da8:	70a2                	ld	ra,40(sp)
    80004daa:	7402                	ld	s0,32(sp)
    80004dac:	6145                	addi	sp,sp,48
    80004dae:	8082                	ret

0000000080004db0 <sys_write>:
{
    80004db0:	7179                	addi	sp,sp,-48
    80004db2:	f406                	sd	ra,40(sp)
    80004db4:	f022                	sd	s0,32(sp)
    80004db6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004db8:	fd840593          	addi	a1,s0,-40
    80004dbc:	4505                	li	a0,1
    80004dbe:	d2ffd0ef          	jal	80002aec <argaddr>
  argint(2, &n);
    80004dc2:	fe440593          	addi	a1,s0,-28
    80004dc6:	4509                	li	a0,2
    80004dc8:	d09fd0ef          	jal	80002ad0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004dcc:	fe840613          	addi	a2,s0,-24
    80004dd0:	4581                	li	a1,0
    80004dd2:	4501                	li	a0,0
    80004dd4:	d79ff0ef          	jal	80004b4c <argfd>
    80004dd8:	87aa                	mv	a5,a0
    return -1;
    80004dda:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ddc:	0007ca63          	bltz	a5,80004df0 <sys_write+0x40>
  return filewrite(f, p, n);
    80004de0:	fe442603          	lw	a2,-28(s0)
    80004de4:	fd843583          	ld	a1,-40(s0)
    80004de8:	fe843503          	ld	a0,-24(s0)
    80004dec:	dceff0ef          	jal	800043ba <filewrite>
}
    80004df0:	70a2                	ld	ra,40(sp)
    80004df2:	7402                	ld	s0,32(sp)
    80004df4:	6145                	addi	sp,sp,48
    80004df6:	8082                	ret

0000000080004df8 <sys_close>:
{
    80004df8:	1101                	addi	sp,sp,-32
    80004dfa:	ec06                	sd	ra,24(sp)
    80004dfc:	e822                	sd	s0,16(sp)
    80004dfe:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004e00:	fe040613          	addi	a2,s0,-32
    80004e04:	fec40593          	addi	a1,s0,-20
    80004e08:	4501                	li	a0,0
    80004e0a:	d43ff0ef          	jal	80004b4c <argfd>
    return -1;
    80004e0e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004e10:	02054063          	bltz	a0,80004e30 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004e14:	d67fc0ef          	jal	80001b7a <myproc>
    80004e18:	fec42783          	lw	a5,-20(s0)
    80004e1c:	07f1                	addi	a5,a5,28
    80004e1e:	078e                	slli	a5,a5,0x3
    80004e20:	953e                	add	a0,a0,a5
    80004e22:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004e26:	fe043503          	ld	a0,-32(s0)
    80004e2a:	bb2ff0ef          	jal	800041dc <fileclose>
  return 0;
    80004e2e:	4781                	li	a5,0
}
    80004e30:	853e                	mv	a0,a5
    80004e32:	60e2                	ld	ra,24(sp)
    80004e34:	6442                	ld	s0,16(sp)
    80004e36:	6105                	addi	sp,sp,32
    80004e38:	8082                	ret

0000000080004e3a <sys_fstat>:
{
    80004e3a:	1101                	addi	sp,sp,-32
    80004e3c:	ec06                	sd	ra,24(sp)
    80004e3e:	e822                	sd	s0,16(sp)
    80004e40:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004e42:	fe040593          	addi	a1,s0,-32
    80004e46:	4505                	li	a0,1
    80004e48:	ca5fd0ef          	jal	80002aec <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004e4c:	fe840613          	addi	a2,s0,-24
    80004e50:	4581                	li	a1,0
    80004e52:	4501                	li	a0,0
    80004e54:	cf9ff0ef          	jal	80004b4c <argfd>
    80004e58:	87aa                	mv	a5,a0
    return -1;
    80004e5a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e5c:	0007c863          	bltz	a5,80004e6c <sys_fstat+0x32>
  return filestat(f, st);
    80004e60:	fe043583          	ld	a1,-32(s0)
    80004e64:	fe843503          	ld	a0,-24(s0)
    80004e68:	c36ff0ef          	jal	8000429e <filestat>
}
    80004e6c:	60e2                	ld	ra,24(sp)
    80004e6e:	6442                	ld	s0,16(sp)
    80004e70:	6105                	addi	sp,sp,32
    80004e72:	8082                	ret

0000000080004e74 <sys_link>:
{
    80004e74:	7169                	addi	sp,sp,-304
    80004e76:	f606                	sd	ra,296(sp)
    80004e78:	f222                	sd	s0,288(sp)
    80004e7a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e7c:	08000613          	li	a2,128
    80004e80:	ed040593          	addi	a1,s0,-304
    80004e84:	4501                	li	a0,0
    80004e86:	c83fd0ef          	jal	80002b08 <argstr>
    return -1;
    80004e8a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e8c:	0c054e63          	bltz	a0,80004f68 <sys_link+0xf4>
    80004e90:	08000613          	li	a2,128
    80004e94:	f5040593          	addi	a1,s0,-176
    80004e98:	4505                	li	a0,1
    80004e9a:	c6ffd0ef          	jal	80002b08 <argstr>
    return -1;
    80004e9e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ea0:	0c054463          	bltz	a0,80004f68 <sys_link+0xf4>
    80004ea4:	ee26                	sd	s1,280(sp)
  begin_op();
    80004ea6:	f1dfe0ef          	jal	80003dc2 <begin_op>
  if((ip = namei(old)) == 0){
    80004eaa:	ed040513          	addi	a0,s0,-304
    80004eae:	d59fe0ef          	jal	80003c06 <namei>
    80004eb2:	84aa                	mv	s1,a0
    80004eb4:	c53d                	beqz	a0,80004f22 <sys_link+0xae>
  ilock(ip);
    80004eb6:	e76fe0ef          	jal	8000352c <ilock>
  if(ip->type == T_DIR){
    80004eba:	04449703          	lh	a4,68(s1)
    80004ebe:	4785                	li	a5,1
    80004ec0:	06f70663          	beq	a4,a5,80004f2c <sys_link+0xb8>
    80004ec4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004ec6:	04a4d783          	lhu	a5,74(s1)
    80004eca:	2785                	addiw	a5,a5,1
    80004ecc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ed0:	8526                	mv	a0,s1
    80004ed2:	da6fe0ef          	jal	80003478 <iupdate>
  iunlock(ip);
    80004ed6:	8526                	mv	a0,s1
    80004ed8:	f02fe0ef          	jal	800035da <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004edc:	fd040593          	addi	a1,s0,-48
    80004ee0:	f5040513          	addi	a0,s0,-176
    80004ee4:	d3dfe0ef          	jal	80003c20 <nameiparent>
    80004ee8:	892a                	mv	s2,a0
    80004eea:	cd21                	beqz	a0,80004f42 <sys_link+0xce>
  ilock(dp);
    80004eec:	e40fe0ef          	jal	8000352c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ef0:	00092703          	lw	a4,0(s2)
    80004ef4:	409c                	lw	a5,0(s1)
    80004ef6:	04f71363          	bne	a4,a5,80004f3c <sys_link+0xc8>
    80004efa:	40d0                	lw	a2,4(s1)
    80004efc:	fd040593          	addi	a1,s0,-48
    80004f00:	854a                	mv	a0,s2
    80004f02:	c6bfe0ef          	jal	80003b6c <dirlink>
    80004f06:	02054b63          	bltz	a0,80004f3c <sys_link+0xc8>
  iunlockput(dp);
    80004f0a:	854a                	mv	a0,s2
    80004f0c:	82bfe0ef          	jal	80003736 <iunlockput>
  iput(ip);
    80004f10:	8526                	mv	a0,s1
    80004f12:	f9cfe0ef          	jal	800036ae <iput>
  end_op();
    80004f16:	f17fe0ef          	jal	80003e2c <end_op>
  return 0;
    80004f1a:	4781                	li	a5,0
    80004f1c:	64f2                	ld	s1,280(sp)
    80004f1e:	6952                	ld	s2,272(sp)
    80004f20:	a0a1                	j	80004f68 <sys_link+0xf4>
    end_op();
    80004f22:	f0bfe0ef          	jal	80003e2c <end_op>
    return -1;
    80004f26:	57fd                	li	a5,-1
    80004f28:	64f2                	ld	s1,280(sp)
    80004f2a:	a83d                	j	80004f68 <sys_link+0xf4>
    iunlockput(ip);
    80004f2c:	8526                	mv	a0,s1
    80004f2e:	809fe0ef          	jal	80003736 <iunlockput>
    end_op();
    80004f32:	efbfe0ef          	jal	80003e2c <end_op>
    return -1;
    80004f36:	57fd                	li	a5,-1
    80004f38:	64f2                	ld	s1,280(sp)
    80004f3a:	a03d                	j	80004f68 <sys_link+0xf4>
    iunlockput(dp);
    80004f3c:	854a                	mv	a0,s2
    80004f3e:	ff8fe0ef          	jal	80003736 <iunlockput>
  ilock(ip);
    80004f42:	8526                	mv	a0,s1
    80004f44:	de8fe0ef          	jal	8000352c <ilock>
  ip->nlink--;
    80004f48:	04a4d783          	lhu	a5,74(s1)
    80004f4c:	37fd                	addiw	a5,a5,-1
    80004f4e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f52:	8526                	mv	a0,s1
    80004f54:	d24fe0ef          	jal	80003478 <iupdate>
  iunlockput(ip);
    80004f58:	8526                	mv	a0,s1
    80004f5a:	fdcfe0ef          	jal	80003736 <iunlockput>
  end_op();
    80004f5e:	ecffe0ef          	jal	80003e2c <end_op>
  return -1;
    80004f62:	57fd                	li	a5,-1
    80004f64:	64f2                	ld	s1,280(sp)
    80004f66:	6952                	ld	s2,272(sp)
}
    80004f68:	853e                	mv	a0,a5
    80004f6a:	70b2                	ld	ra,296(sp)
    80004f6c:	7412                	ld	s0,288(sp)
    80004f6e:	6155                	addi	sp,sp,304
    80004f70:	8082                	ret

0000000080004f72 <sys_unlink>:
{
    80004f72:	7151                	addi	sp,sp,-240
    80004f74:	f586                	sd	ra,232(sp)
    80004f76:	f1a2                	sd	s0,224(sp)
    80004f78:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004f7a:	08000613          	li	a2,128
    80004f7e:	f3040593          	addi	a1,s0,-208
    80004f82:	4501                	li	a0,0
    80004f84:	b85fd0ef          	jal	80002b08 <argstr>
    80004f88:	16054063          	bltz	a0,800050e8 <sys_unlink+0x176>
    80004f8c:	eda6                	sd	s1,216(sp)
  begin_op();
    80004f8e:	e35fe0ef          	jal	80003dc2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004f92:	fb040593          	addi	a1,s0,-80
    80004f96:	f3040513          	addi	a0,s0,-208
    80004f9a:	c87fe0ef          	jal	80003c20 <nameiparent>
    80004f9e:	84aa                	mv	s1,a0
    80004fa0:	c945                	beqz	a0,80005050 <sys_unlink+0xde>
  ilock(dp);
    80004fa2:	d8afe0ef          	jal	8000352c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004fa6:	00002597          	auipc	a1,0x2
    80004faa:	6aa58593          	addi	a1,a1,1706 # 80007650 <etext+0x650>
    80004fae:	fb040513          	addi	a0,s0,-80
    80004fb2:	9d9fe0ef          	jal	8000398a <namecmp>
    80004fb6:	10050e63          	beqz	a0,800050d2 <sys_unlink+0x160>
    80004fba:	00002597          	auipc	a1,0x2
    80004fbe:	69e58593          	addi	a1,a1,1694 # 80007658 <etext+0x658>
    80004fc2:	fb040513          	addi	a0,s0,-80
    80004fc6:	9c5fe0ef          	jal	8000398a <namecmp>
    80004fca:	10050463          	beqz	a0,800050d2 <sys_unlink+0x160>
    80004fce:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004fd0:	f2c40613          	addi	a2,s0,-212
    80004fd4:	fb040593          	addi	a1,s0,-80
    80004fd8:	8526                	mv	a0,s1
    80004fda:	9c7fe0ef          	jal	800039a0 <dirlookup>
    80004fde:	892a                	mv	s2,a0
    80004fe0:	0e050863          	beqz	a0,800050d0 <sys_unlink+0x15e>
  ilock(ip);
    80004fe4:	d48fe0ef          	jal	8000352c <ilock>
  if(ip->nlink < 1)
    80004fe8:	04a91783          	lh	a5,74(s2)
    80004fec:	06f05763          	blez	a5,8000505a <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ff0:	04491703          	lh	a4,68(s2)
    80004ff4:	4785                	li	a5,1
    80004ff6:	06f70963          	beq	a4,a5,80005068 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004ffa:	4641                	li	a2,16
    80004ffc:	4581                	li	a1,0
    80004ffe:	fc040513          	addi	a0,s0,-64
    80005002:	cc7fb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005006:	4741                	li	a4,16
    80005008:	f2c42683          	lw	a3,-212(s0)
    8000500c:	fc040613          	addi	a2,s0,-64
    80005010:	4581                	li	a1,0
    80005012:	8526                	mv	a0,s1
    80005014:	869fe0ef          	jal	8000387c <writei>
    80005018:	47c1                	li	a5,16
    8000501a:	08f51b63          	bne	a0,a5,800050b0 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000501e:	04491703          	lh	a4,68(s2)
    80005022:	4785                	li	a5,1
    80005024:	08f70d63          	beq	a4,a5,800050be <sys_unlink+0x14c>
  iunlockput(dp);
    80005028:	8526                	mv	a0,s1
    8000502a:	f0cfe0ef          	jal	80003736 <iunlockput>
  ip->nlink--;
    8000502e:	04a95783          	lhu	a5,74(s2)
    80005032:	37fd                	addiw	a5,a5,-1
    80005034:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005038:	854a                	mv	a0,s2
    8000503a:	c3efe0ef          	jal	80003478 <iupdate>
  iunlockput(ip);
    8000503e:	854a                	mv	a0,s2
    80005040:	ef6fe0ef          	jal	80003736 <iunlockput>
  end_op();
    80005044:	de9fe0ef          	jal	80003e2c <end_op>
  return 0;
    80005048:	4501                	li	a0,0
    8000504a:	64ee                	ld	s1,216(sp)
    8000504c:	694e                	ld	s2,208(sp)
    8000504e:	a849                	j	800050e0 <sys_unlink+0x16e>
    end_op();
    80005050:	dddfe0ef          	jal	80003e2c <end_op>
    return -1;
    80005054:	557d                	li	a0,-1
    80005056:	64ee                	ld	s1,216(sp)
    80005058:	a061                	j	800050e0 <sys_unlink+0x16e>
    8000505a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000505c:	00002517          	auipc	a0,0x2
    80005060:	60450513          	addi	a0,a0,1540 # 80007660 <etext+0x660>
    80005064:	f30fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005068:	04c92703          	lw	a4,76(s2)
    8000506c:	02000793          	li	a5,32
    80005070:	f8e7f5e3          	bgeu	a5,a4,80004ffa <sys_unlink+0x88>
    80005074:	e5ce                	sd	s3,200(sp)
    80005076:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000507a:	4741                	li	a4,16
    8000507c:	86ce                	mv	a3,s3
    8000507e:	f1840613          	addi	a2,s0,-232
    80005082:	4581                	li	a1,0
    80005084:	854a                	mv	a0,s2
    80005086:	efafe0ef          	jal	80003780 <readi>
    8000508a:	47c1                	li	a5,16
    8000508c:	00f51c63          	bne	a0,a5,800050a4 <sys_unlink+0x132>
    if(de.inum != 0)
    80005090:	f1845783          	lhu	a5,-232(s0)
    80005094:	efa1                	bnez	a5,800050ec <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005096:	29c1                	addiw	s3,s3,16
    80005098:	04c92783          	lw	a5,76(s2)
    8000509c:	fcf9efe3          	bltu	s3,a5,8000507a <sys_unlink+0x108>
    800050a0:	69ae                	ld	s3,200(sp)
    800050a2:	bfa1                	j	80004ffa <sys_unlink+0x88>
      panic("isdirempty: readi");
    800050a4:	00002517          	auipc	a0,0x2
    800050a8:	5d450513          	addi	a0,a0,1492 # 80007678 <etext+0x678>
    800050ac:	ee8fb0ef          	jal	80000794 <panic>
    800050b0:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800050b2:	00002517          	auipc	a0,0x2
    800050b6:	5de50513          	addi	a0,a0,1502 # 80007690 <etext+0x690>
    800050ba:	edafb0ef          	jal	80000794 <panic>
    dp->nlink--;
    800050be:	04a4d783          	lhu	a5,74(s1)
    800050c2:	37fd                	addiw	a5,a5,-1
    800050c4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800050c8:	8526                	mv	a0,s1
    800050ca:	baefe0ef          	jal	80003478 <iupdate>
    800050ce:	bfa9                	j	80005028 <sys_unlink+0xb6>
    800050d0:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800050d2:	8526                	mv	a0,s1
    800050d4:	e62fe0ef          	jal	80003736 <iunlockput>
  end_op();
    800050d8:	d55fe0ef          	jal	80003e2c <end_op>
  return -1;
    800050dc:	557d                	li	a0,-1
    800050de:	64ee                	ld	s1,216(sp)
}
    800050e0:	70ae                	ld	ra,232(sp)
    800050e2:	740e                	ld	s0,224(sp)
    800050e4:	616d                	addi	sp,sp,240
    800050e6:	8082                	ret
    return -1;
    800050e8:	557d                	li	a0,-1
    800050ea:	bfdd                	j	800050e0 <sys_unlink+0x16e>
    iunlockput(ip);
    800050ec:	854a                	mv	a0,s2
    800050ee:	e48fe0ef          	jal	80003736 <iunlockput>
    goto bad;
    800050f2:	694e                	ld	s2,208(sp)
    800050f4:	69ae                	ld	s3,200(sp)
    800050f6:	bff1                	j	800050d2 <sys_unlink+0x160>

00000000800050f8 <sys_open>:

uint64
sys_open(void)
{
    800050f8:	7131                	addi	sp,sp,-192
    800050fa:	fd06                	sd	ra,184(sp)
    800050fc:	f922                	sd	s0,176(sp)
    800050fe:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005100:	f4c40593          	addi	a1,s0,-180
    80005104:	4505                	li	a0,1
    80005106:	9cbfd0ef          	jal	80002ad0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000510a:	08000613          	li	a2,128
    8000510e:	f5040593          	addi	a1,s0,-176
    80005112:	4501                	li	a0,0
    80005114:	9f5fd0ef          	jal	80002b08 <argstr>
    80005118:	87aa                	mv	a5,a0
    return -1;
    8000511a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000511c:	0a07c263          	bltz	a5,800051c0 <sys_open+0xc8>
    80005120:	f526                	sd	s1,168(sp)

  begin_op();
    80005122:	ca1fe0ef          	jal	80003dc2 <begin_op>

  if(omode & O_CREATE){
    80005126:	f4c42783          	lw	a5,-180(s0)
    8000512a:	2007f793          	andi	a5,a5,512
    8000512e:	c3d5                	beqz	a5,800051d2 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80005130:	4681                	li	a3,0
    80005132:	4601                	li	a2,0
    80005134:	4589                	li	a1,2
    80005136:	f5040513          	addi	a0,s0,-176
    8000513a:	aa9ff0ef          	jal	80004be2 <create>
    8000513e:	84aa                	mv	s1,a0
    if(ip == 0){
    80005140:	c541                	beqz	a0,800051c8 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005142:	04449703          	lh	a4,68(s1)
    80005146:	478d                	li	a5,3
    80005148:	00f71763          	bne	a4,a5,80005156 <sys_open+0x5e>
    8000514c:	0464d703          	lhu	a4,70(s1)
    80005150:	47a5                	li	a5,9
    80005152:	0ae7ed63          	bltu	a5,a4,8000520c <sys_open+0x114>
    80005156:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005158:	fe1fe0ef          	jal	80004138 <filealloc>
    8000515c:	892a                	mv	s2,a0
    8000515e:	c179                	beqz	a0,80005224 <sys_open+0x12c>
    80005160:	ed4e                	sd	s3,152(sp)
    80005162:	a43ff0ef          	jal	80004ba4 <fdalloc>
    80005166:	89aa                	mv	s3,a0
    80005168:	0a054a63          	bltz	a0,8000521c <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000516c:	04449703          	lh	a4,68(s1)
    80005170:	478d                	li	a5,3
    80005172:	0cf70263          	beq	a4,a5,80005236 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005176:	4789                	li	a5,2
    80005178:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000517c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005180:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005184:	f4c42783          	lw	a5,-180(s0)
    80005188:	0017c713          	xori	a4,a5,1
    8000518c:	8b05                	andi	a4,a4,1
    8000518e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005192:	0037f713          	andi	a4,a5,3
    80005196:	00e03733          	snez	a4,a4
    8000519a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000519e:	4007f793          	andi	a5,a5,1024
    800051a2:	c791                	beqz	a5,800051ae <sys_open+0xb6>
    800051a4:	04449703          	lh	a4,68(s1)
    800051a8:	4789                	li	a5,2
    800051aa:	08f70d63          	beq	a4,a5,80005244 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800051ae:	8526                	mv	a0,s1
    800051b0:	c2afe0ef          	jal	800035da <iunlock>
  end_op();
    800051b4:	c79fe0ef          	jal	80003e2c <end_op>

  return fd;
    800051b8:	854e                	mv	a0,s3
    800051ba:	74aa                	ld	s1,168(sp)
    800051bc:	790a                	ld	s2,160(sp)
    800051be:	69ea                	ld	s3,152(sp)
}
    800051c0:	70ea                	ld	ra,184(sp)
    800051c2:	744a                	ld	s0,176(sp)
    800051c4:	6129                	addi	sp,sp,192
    800051c6:	8082                	ret
      end_op();
    800051c8:	c65fe0ef          	jal	80003e2c <end_op>
      return -1;
    800051cc:	557d                	li	a0,-1
    800051ce:	74aa                	ld	s1,168(sp)
    800051d0:	bfc5                	j	800051c0 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800051d2:	f5040513          	addi	a0,s0,-176
    800051d6:	a31fe0ef          	jal	80003c06 <namei>
    800051da:	84aa                	mv	s1,a0
    800051dc:	c11d                	beqz	a0,80005202 <sys_open+0x10a>
    ilock(ip);
    800051de:	b4efe0ef          	jal	8000352c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800051e2:	04449703          	lh	a4,68(s1)
    800051e6:	4785                	li	a5,1
    800051e8:	f4f71de3          	bne	a4,a5,80005142 <sys_open+0x4a>
    800051ec:	f4c42783          	lw	a5,-180(s0)
    800051f0:	d3bd                	beqz	a5,80005156 <sys_open+0x5e>
      iunlockput(ip);
    800051f2:	8526                	mv	a0,s1
    800051f4:	d42fe0ef          	jal	80003736 <iunlockput>
      end_op();
    800051f8:	c35fe0ef          	jal	80003e2c <end_op>
      return -1;
    800051fc:	557d                	li	a0,-1
    800051fe:	74aa                	ld	s1,168(sp)
    80005200:	b7c1                	j	800051c0 <sys_open+0xc8>
      end_op();
    80005202:	c2bfe0ef          	jal	80003e2c <end_op>
      return -1;
    80005206:	557d                	li	a0,-1
    80005208:	74aa                	ld	s1,168(sp)
    8000520a:	bf5d                	j	800051c0 <sys_open+0xc8>
    iunlockput(ip);
    8000520c:	8526                	mv	a0,s1
    8000520e:	d28fe0ef          	jal	80003736 <iunlockput>
    end_op();
    80005212:	c1bfe0ef          	jal	80003e2c <end_op>
    return -1;
    80005216:	557d                	li	a0,-1
    80005218:	74aa                	ld	s1,168(sp)
    8000521a:	b75d                	j	800051c0 <sys_open+0xc8>
      fileclose(f);
    8000521c:	854a                	mv	a0,s2
    8000521e:	fbffe0ef          	jal	800041dc <fileclose>
    80005222:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005224:	8526                	mv	a0,s1
    80005226:	d10fe0ef          	jal	80003736 <iunlockput>
    end_op();
    8000522a:	c03fe0ef          	jal	80003e2c <end_op>
    return -1;
    8000522e:	557d                	li	a0,-1
    80005230:	74aa                	ld	s1,168(sp)
    80005232:	790a                	ld	s2,160(sp)
    80005234:	b771                	j	800051c0 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005236:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000523a:	04649783          	lh	a5,70(s1)
    8000523e:	02f91223          	sh	a5,36(s2)
    80005242:	bf3d                	j	80005180 <sys_open+0x88>
    itrunc(ip);
    80005244:	8526                	mv	a0,s1
    80005246:	bd4fe0ef          	jal	8000361a <itrunc>
    8000524a:	b795                	j	800051ae <sys_open+0xb6>

000000008000524c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000524c:	7175                	addi	sp,sp,-144
    8000524e:	e506                	sd	ra,136(sp)
    80005250:	e122                	sd	s0,128(sp)
    80005252:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005254:	b6ffe0ef          	jal	80003dc2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005258:	08000613          	li	a2,128
    8000525c:	f7040593          	addi	a1,s0,-144
    80005260:	4501                	li	a0,0
    80005262:	8a7fd0ef          	jal	80002b08 <argstr>
    80005266:	02054363          	bltz	a0,8000528c <sys_mkdir+0x40>
    8000526a:	4681                	li	a3,0
    8000526c:	4601                	li	a2,0
    8000526e:	4585                	li	a1,1
    80005270:	f7040513          	addi	a0,s0,-144
    80005274:	96fff0ef          	jal	80004be2 <create>
    80005278:	c911                	beqz	a0,8000528c <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000527a:	cbcfe0ef          	jal	80003736 <iunlockput>
  end_op();
    8000527e:	baffe0ef          	jal	80003e2c <end_op>
  return 0;
    80005282:	4501                	li	a0,0
}
    80005284:	60aa                	ld	ra,136(sp)
    80005286:	640a                	ld	s0,128(sp)
    80005288:	6149                	addi	sp,sp,144
    8000528a:	8082                	ret
    end_op();
    8000528c:	ba1fe0ef          	jal	80003e2c <end_op>
    return -1;
    80005290:	557d                	li	a0,-1
    80005292:	bfcd                	j	80005284 <sys_mkdir+0x38>

0000000080005294 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005294:	7135                	addi	sp,sp,-160
    80005296:	ed06                	sd	ra,152(sp)
    80005298:	e922                	sd	s0,144(sp)
    8000529a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000529c:	b27fe0ef          	jal	80003dc2 <begin_op>
  argint(1, &major);
    800052a0:	f6c40593          	addi	a1,s0,-148
    800052a4:	4505                	li	a0,1
    800052a6:	82bfd0ef          	jal	80002ad0 <argint>
  argint(2, &minor);
    800052aa:	f6840593          	addi	a1,s0,-152
    800052ae:	4509                	li	a0,2
    800052b0:	821fd0ef          	jal	80002ad0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800052b4:	08000613          	li	a2,128
    800052b8:	f7040593          	addi	a1,s0,-144
    800052bc:	4501                	li	a0,0
    800052be:	84bfd0ef          	jal	80002b08 <argstr>
    800052c2:	02054563          	bltz	a0,800052ec <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800052c6:	f6841683          	lh	a3,-152(s0)
    800052ca:	f6c41603          	lh	a2,-148(s0)
    800052ce:	458d                	li	a1,3
    800052d0:	f7040513          	addi	a0,s0,-144
    800052d4:	90fff0ef          	jal	80004be2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800052d8:	c911                	beqz	a0,800052ec <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800052da:	c5cfe0ef          	jal	80003736 <iunlockput>
  end_op();
    800052de:	b4ffe0ef          	jal	80003e2c <end_op>
  return 0;
    800052e2:	4501                	li	a0,0
}
    800052e4:	60ea                	ld	ra,152(sp)
    800052e6:	644a                	ld	s0,144(sp)
    800052e8:	610d                	addi	sp,sp,160
    800052ea:	8082                	ret
    end_op();
    800052ec:	b41fe0ef          	jal	80003e2c <end_op>
    return -1;
    800052f0:	557d                	li	a0,-1
    800052f2:	bfcd                	j	800052e4 <sys_mknod+0x50>

00000000800052f4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800052f4:	7135                	addi	sp,sp,-160
    800052f6:	ed06                	sd	ra,152(sp)
    800052f8:	e922                	sd	s0,144(sp)
    800052fa:	e14a                	sd	s2,128(sp)
    800052fc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800052fe:	87dfc0ef          	jal	80001b7a <myproc>
    80005302:	892a                	mv	s2,a0
  
  begin_op();
    80005304:	abffe0ef          	jal	80003dc2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005308:	08000613          	li	a2,128
    8000530c:	f6040593          	addi	a1,s0,-160
    80005310:	4501                	li	a0,0
    80005312:	ff6fd0ef          	jal	80002b08 <argstr>
    80005316:	04054363          	bltz	a0,8000535c <sys_chdir+0x68>
    8000531a:	e526                	sd	s1,136(sp)
    8000531c:	f6040513          	addi	a0,s0,-160
    80005320:	8e7fe0ef          	jal	80003c06 <namei>
    80005324:	84aa                	mv	s1,a0
    80005326:	c915                	beqz	a0,8000535a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005328:	a04fe0ef          	jal	8000352c <ilock>
  if(ip->type != T_DIR){
    8000532c:	04449703          	lh	a4,68(s1)
    80005330:	4785                	li	a5,1
    80005332:	02f71963          	bne	a4,a5,80005364 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005336:	8526                	mv	a0,s1
    80005338:	aa2fe0ef          	jal	800035da <iunlock>
  iput(p->cwd);
    8000533c:	16093503          	ld	a0,352(s2)
    80005340:	b6efe0ef          	jal	800036ae <iput>
  end_op();
    80005344:	ae9fe0ef          	jal	80003e2c <end_op>
  p->cwd = ip;
    80005348:	16993023          	sd	s1,352(s2)
  return 0;
    8000534c:	4501                	li	a0,0
    8000534e:	64aa                	ld	s1,136(sp)
}
    80005350:	60ea                	ld	ra,152(sp)
    80005352:	644a                	ld	s0,144(sp)
    80005354:	690a                	ld	s2,128(sp)
    80005356:	610d                	addi	sp,sp,160
    80005358:	8082                	ret
    8000535a:	64aa                	ld	s1,136(sp)
    end_op();
    8000535c:	ad1fe0ef          	jal	80003e2c <end_op>
    return -1;
    80005360:	557d                	li	a0,-1
    80005362:	b7fd                	j	80005350 <sys_chdir+0x5c>
    iunlockput(ip);
    80005364:	8526                	mv	a0,s1
    80005366:	bd0fe0ef          	jal	80003736 <iunlockput>
    end_op();
    8000536a:	ac3fe0ef          	jal	80003e2c <end_op>
    return -1;
    8000536e:	557d                	li	a0,-1
    80005370:	64aa                	ld	s1,136(sp)
    80005372:	bff9                	j	80005350 <sys_chdir+0x5c>

0000000080005374 <sys_exec>:

uint64
sys_exec(void)
{
    80005374:	7121                	addi	sp,sp,-448
    80005376:	ff06                	sd	ra,440(sp)
    80005378:	fb22                	sd	s0,432(sp)
    8000537a:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000537c:	e4840593          	addi	a1,s0,-440
    80005380:	4505                	li	a0,1
    80005382:	f6afd0ef          	jal	80002aec <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005386:	08000613          	li	a2,128
    8000538a:	f5040593          	addi	a1,s0,-176
    8000538e:	4501                	li	a0,0
    80005390:	f78fd0ef          	jal	80002b08 <argstr>
    80005394:	87aa                	mv	a5,a0
    return -1;
    80005396:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005398:	0c07c463          	bltz	a5,80005460 <sys_exec+0xec>
    8000539c:	f726                	sd	s1,424(sp)
    8000539e:	f34a                	sd	s2,416(sp)
    800053a0:	ef4e                	sd	s3,408(sp)
    800053a2:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800053a4:	10000613          	li	a2,256
    800053a8:	4581                	li	a1,0
    800053aa:	e5040513          	addi	a0,s0,-432
    800053ae:	91bfb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800053b2:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800053b6:	89a6                	mv	s3,s1
    800053b8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800053ba:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800053be:	00391513          	slli	a0,s2,0x3
    800053c2:	e4040593          	addi	a1,s0,-448
    800053c6:	e4843783          	ld	a5,-440(s0)
    800053ca:	953e                	add	a0,a0,a5
    800053cc:	e7afd0ef          	jal	80002a46 <fetchaddr>
    800053d0:	02054663          	bltz	a0,800053fc <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800053d4:	e4043783          	ld	a5,-448(s0)
    800053d8:	c3a9                	beqz	a5,8000541a <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800053da:	f4afb0ef          	jal	80000b24 <kalloc>
    800053de:	85aa                	mv	a1,a0
    800053e0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800053e4:	cd01                	beqz	a0,800053fc <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800053e6:	6605                	lui	a2,0x1
    800053e8:	e4043503          	ld	a0,-448(s0)
    800053ec:	ea4fd0ef          	jal	80002a90 <fetchstr>
    800053f0:	00054663          	bltz	a0,800053fc <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800053f4:	0905                	addi	s2,s2,1
    800053f6:	09a1                	addi	s3,s3,8
    800053f8:	fd4913e3          	bne	s2,s4,800053be <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053fc:	f5040913          	addi	s2,s0,-176
    80005400:	6088                	ld	a0,0(s1)
    80005402:	c931                	beqz	a0,80005456 <sys_exec+0xe2>
    kfree(argv[i]);
    80005404:	e3efb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005408:	04a1                	addi	s1,s1,8
    8000540a:	ff249be3          	bne	s1,s2,80005400 <sys_exec+0x8c>
  return -1;
    8000540e:	557d                	li	a0,-1
    80005410:	74ba                	ld	s1,424(sp)
    80005412:	791a                	ld	s2,416(sp)
    80005414:	69fa                	ld	s3,408(sp)
    80005416:	6a5a                	ld	s4,400(sp)
    80005418:	a0a1                	j	80005460 <sys_exec+0xec>
      argv[i] = 0;
    8000541a:	0009079b          	sext.w	a5,s2
    8000541e:	078e                	slli	a5,a5,0x3
    80005420:	fd078793          	addi	a5,a5,-48
    80005424:	97a2                	add	a5,a5,s0
    80005426:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000542a:	e5040593          	addi	a1,s0,-432
    8000542e:	f5040513          	addi	a0,s0,-176
    80005432:	ba8ff0ef          	jal	800047da <exec>
    80005436:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005438:	f5040993          	addi	s3,s0,-176
    8000543c:	6088                	ld	a0,0(s1)
    8000543e:	c511                	beqz	a0,8000544a <sys_exec+0xd6>
    kfree(argv[i]);
    80005440:	e02fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005444:	04a1                	addi	s1,s1,8
    80005446:	ff349be3          	bne	s1,s3,8000543c <sys_exec+0xc8>
  return ret;
    8000544a:	854a                	mv	a0,s2
    8000544c:	74ba                	ld	s1,424(sp)
    8000544e:	791a                	ld	s2,416(sp)
    80005450:	69fa                	ld	s3,408(sp)
    80005452:	6a5a                	ld	s4,400(sp)
    80005454:	a031                	j	80005460 <sys_exec+0xec>
  return -1;
    80005456:	557d                	li	a0,-1
    80005458:	74ba                	ld	s1,424(sp)
    8000545a:	791a                	ld	s2,416(sp)
    8000545c:	69fa                	ld	s3,408(sp)
    8000545e:	6a5a                	ld	s4,400(sp)
}
    80005460:	70fa                	ld	ra,440(sp)
    80005462:	745a                	ld	s0,432(sp)
    80005464:	6139                	addi	sp,sp,448
    80005466:	8082                	ret

0000000080005468 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005468:	7139                	addi	sp,sp,-64
    8000546a:	fc06                	sd	ra,56(sp)
    8000546c:	f822                	sd	s0,48(sp)
    8000546e:	f426                	sd	s1,40(sp)
    80005470:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005472:	f08fc0ef          	jal	80001b7a <myproc>
    80005476:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005478:	fd840593          	addi	a1,s0,-40
    8000547c:	4501                	li	a0,0
    8000547e:	e6efd0ef          	jal	80002aec <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005482:	fc840593          	addi	a1,s0,-56
    80005486:	fd040513          	addi	a0,s0,-48
    8000548a:	85cff0ef          	jal	800044e6 <pipealloc>
    return -1;
    8000548e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005490:	0a054463          	bltz	a0,80005538 <sys_pipe+0xd0>
  fd0 = -1;
    80005494:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005498:	fd043503          	ld	a0,-48(s0)
    8000549c:	f08ff0ef          	jal	80004ba4 <fdalloc>
    800054a0:	fca42223          	sw	a0,-60(s0)
    800054a4:	08054163          	bltz	a0,80005526 <sys_pipe+0xbe>
    800054a8:	fc843503          	ld	a0,-56(s0)
    800054ac:	ef8ff0ef          	jal	80004ba4 <fdalloc>
    800054b0:	fca42023          	sw	a0,-64(s0)
    800054b4:	06054063          	bltz	a0,80005514 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800054b8:	4691                	li	a3,4
    800054ba:	fc440613          	addi	a2,s0,-60
    800054be:	fd843583          	ld	a1,-40(s0)
    800054c2:	70a8                	ld	a0,96(s1)
    800054c4:	88efc0ef          	jal	80001552 <copyout>
    800054c8:	00054e63          	bltz	a0,800054e4 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800054cc:	4691                	li	a3,4
    800054ce:	fc040613          	addi	a2,s0,-64
    800054d2:	fd843583          	ld	a1,-40(s0)
    800054d6:	0591                	addi	a1,a1,4
    800054d8:	70a8                	ld	a0,96(s1)
    800054da:	878fc0ef          	jal	80001552 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800054de:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800054e0:	04055c63          	bgez	a0,80005538 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800054e4:	fc442783          	lw	a5,-60(s0)
    800054e8:	07f1                	addi	a5,a5,28
    800054ea:	078e                	slli	a5,a5,0x3
    800054ec:	97a6                	add	a5,a5,s1
    800054ee:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800054f2:	fc042783          	lw	a5,-64(s0)
    800054f6:	07f1                	addi	a5,a5,28
    800054f8:	078e                	slli	a5,a5,0x3
    800054fa:	94be                	add	s1,s1,a5
    800054fc:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005500:	fd043503          	ld	a0,-48(s0)
    80005504:	cd9fe0ef          	jal	800041dc <fileclose>
    fileclose(wf);
    80005508:	fc843503          	ld	a0,-56(s0)
    8000550c:	cd1fe0ef          	jal	800041dc <fileclose>
    return -1;
    80005510:	57fd                	li	a5,-1
    80005512:	a01d                	j	80005538 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005514:	fc442783          	lw	a5,-60(s0)
    80005518:	0007c763          	bltz	a5,80005526 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000551c:	07f1                	addi	a5,a5,28
    8000551e:	078e                	slli	a5,a5,0x3
    80005520:	97a6                	add	a5,a5,s1
    80005522:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005526:	fd043503          	ld	a0,-48(s0)
    8000552a:	cb3fe0ef          	jal	800041dc <fileclose>
    fileclose(wf);
    8000552e:	fc843503          	ld	a0,-56(s0)
    80005532:	cabfe0ef          	jal	800041dc <fileclose>
    return -1;
    80005536:	57fd                	li	a5,-1
}
    80005538:	853e                	mv	a0,a5
    8000553a:	70e2                	ld	ra,56(sp)
    8000553c:	7442                	ld	s0,48(sp)
    8000553e:	74a2                	ld	s1,40(sp)
    80005540:	6121                	addi	sp,sp,64
    80005542:	8082                	ret
	...

0000000080005550 <kernelvec>:
    80005550:	7111                	addi	sp,sp,-256
    80005552:	e006                	sd	ra,0(sp)
    80005554:	e40a                	sd	sp,8(sp)
    80005556:	e80e                	sd	gp,16(sp)
    80005558:	ec12                	sd	tp,24(sp)
    8000555a:	f016                	sd	t0,32(sp)
    8000555c:	f41a                	sd	t1,40(sp)
    8000555e:	f81e                	sd	t2,48(sp)
    80005560:	e4aa                	sd	a0,72(sp)
    80005562:	e8ae                	sd	a1,80(sp)
    80005564:	ecb2                	sd	a2,88(sp)
    80005566:	f0b6                	sd	a3,96(sp)
    80005568:	f4ba                	sd	a4,104(sp)
    8000556a:	f8be                	sd	a5,112(sp)
    8000556c:	fcc2                	sd	a6,120(sp)
    8000556e:	e146                	sd	a7,128(sp)
    80005570:	edf2                	sd	t3,216(sp)
    80005572:	f1f6                	sd	t4,224(sp)
    80005574:	f5fa                	sd	t5,232(sp)
    80005576:	f9fe                	sd	t6,240(sp)
    80005578:	bdefd0ef          	jal	80002956 <kerneltrap>
    8000557c:	6082                	ld	ra,0(sp)
    8000557e:	6122                	ld	sp,8(sp)
    80005580:	61c2                	ld	gp,16(sp)
    80005582:	7282                	ld	t0,32(sp)
    80005584:	7322                	ld	t1,40(sp)
    80005586:	73c2                	ld	t2,48(sp)
    80005588:	6526                	ld	a0,72(sp)
    8000558a:	65c6                	ld	a1,80(sp)
    8000558c:	6666                	ld	a2,88(sp)
    8000558e:	7686                	ld	a3,96(sp)
    80005590:	7726                	ld	a4,104(sp)
    80005592:	77c6                	ld	a5,112(sp)
    80005594:	7866                	ld	a6,120(sp)
    80005596:	688a                	ld	a7,128(sp)
    80005598:	6e6e                	ld	t3,216(sp)
    8000559a:	7e8e                	ld	t4,224(sp)
    8000559c:	7f2e                	ld	t5,232(sp)
    8000559e:	7fce                	ld	t6,240(sp)
    800055a0:	6111                	addi	sp,sp,256
    800055a2:	10200073          	sret
	...

00000000800055ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800055ae:	1141                	addi	sp,sp,-16
    800055b0:	e422                	sd	s0,8(sp)
    800055b2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800055b4:	0c0007b7          	lui	a5,0xc000
    800055b8:	4705                	li	a4,1
    800055ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800055bc:	0c0007b7          	lui	a5,0xc000
    800055c0:	c3d8                	sw	a4,4(a5)
}
    800055c2:	6422                	ld	s0,8(sp)
    800055c4:	0141                	addi	sp,sp,16
    800055c6:	8082                	ret

00000000800055c8 <plicinithart>:

void
plicinithart(void)
{
    800055c8:	1141                	addi	sp,sp,-16
    800055ca:	e406                	sd	ra,8(sp)
    800055cc:	e022                	sd	s0,0(sp)
    800055ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055d0:	d7efc0ef          	jal	80001b4e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800055d4:	0085171b          	slliw	a4,a0,0x8
    800055d8:	0c0027b7          	lui	a5,0xc002
    800055dc:	97ba                	add	a5,a5,a4
    800055de:	40200713          	li	a4,1026
    800055e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800055e6:	00d5151b          	slliw	a0,a0,0xd
    800055ea:	0c2017b7          	lui	a5,0xc201
    800055ee:	97aa                	add	a5,a5,a0
    800055f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800055f4:	60a2                	ld	ra,8(sp)
    800055f6:	6402                	ld	s0,0(sp)
    800055f8:	0141                	addi	sp,sp,16
    800055fa:	8082                	ret

00000000800055fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800055fc:	1141                	addi	sp,sp,-16
    800055fe:	e406                	sd	ra,8(sp)
    80005600:	e022                	sd	s0,0(sp)
    80005602:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005604:	d4afc0ef          	jal	80001b4e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005608:	00d5151b          	slliw	a0,a0,0xd
    8000560c:	0c2017b7          	lui	a5,0xc201
    80005610:	97aa                	add	a5,a5,a0
  return irq;
}
    80005612:	43c8                	lw	a0,4(a5)
    80005614:	60a2                	ld	ra,8(sp)
    80005616:	6402                	ld	s0,0(sp)
    80005618:	0141                	addi	sp,sp,16
    8000561a:	8082                	ret

000000008000561c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000561c:	1101                	addi	sp,sp,-32
    8000561e:	ec06                	sd	ra,24(sp)
    80005620:	e822                	sd	s0,16(sp)
    80005622:	e426                	sd	s1,8(sp)
    80005624:	1000                	addi	s0,sp,32
    80005626:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005628:	d26fc0ef          	jal	80001b4e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000562c:	00d5151b          	slliw	a0,a0,0xd
    80005630:	0c2017b7          	lui	a5,0xc201
    80005634:	97aa                	add	a5,a5,a0
    80005636:	c3c4                	sw	s1,4(a5)
}
    80005638:	60e2                	ld	ra,24(sp)
    8000563a:	6442                	ld	s0,16(sp)
    8000563c:	64a2                	ld	s1,8(sp)
    8000563e:	6105                	addi	sp,sp,32
    80005640:	8082                	ret

0000000080005642 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005642:	1141                	addi	sp,sp,-16
    80005644:	e406                	sd	ra,8(sp)
    80005646:	e022                	sd	s0,0(sp)
    80005648:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000564a:	479d                	li	a5,7
    8000564c:	04a7ca63          	blt	a5,a0,800056a0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005650:	0001e797          	auipc	a5,0x1e
    80005654:	33078793          	addi	a5,a5,816 # 80023980 <disk>
    80005658:	97aa                	add	a5,a5,a0
    8000565a:	0187c783          	lbu	a5,24(a5)
    8000565e:	e7b9                	bnez	a5,800056ac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005660:	00451693          	slli	a3,a0,0x4
    80005664:	0001e797          	auipc	a5,0x1e
    80005668:	31c78793          	addi	a5,a5,796 # 80023980 <disk>
    8000566c:	6398                	ld	a4,0(a5)
    8000566e:	9736                	add	a4,a4,a3
    80005670:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005674:	6398                	ld	a4,0(a5)
    80005676:	9736                	add	a4,a4,a3
    80005678:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000567c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005680:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005684:	97aa                	add	a5,a5,a0
    80005686:	4705                	li	a4,1
    80005688:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000568c:	0001e517          	auipc	a0,0x1e
    80005690:	30c50513          	addi	a0,a0,780 # 80023998 <disk+0x18>
    80005694:	ba3fc0ef          	jal	80002236 <wakeup>
}
    80005698:	60a2                	ld	ra,8(sp)
    8000569a:	6402                	ld	s0,0(sp)
    8000569c:	0141                	addi	sp,sp,16
    8000569e:	8082                	ret
    panic("free_desc 1");
    800056a0:	00002517          	auipc	a0,0x2
    800056a4:	00050513          	mv	a0,a0
    800056a8:	8ecfb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    800056ac:	00002517          	auipc	a0,0x2
    800056b0:	00450513          	addi	a0,a0,4 # 800076b0 <etext+0x6b0>
    800056b4:	8e0fb0ef          	jal	80000794 <panic>

00000000800056b8 <virtio_disk_init>:
{
    800056b8:	1101                	addi	sp,sp,-32
    800056ba:	ec06                	sd	ra,24(sp)
    800056bc:	e822                	sd	s0,16(sp)
    800056be:	e426                	sd	s1,8(sp)
    800056c0:	e04a                	sd	s2,0(sp)
    800056c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800056c4:	00002597          	auipc	a1,0x2
    800056c8:	ffc58593          	addi	a1,a1,-4 # 800076c0 <etext+0x6c0>
    800056cc:	0001e517          	auipc	a0,0x1e
    800056d0:	3dc50513          	addi	a0,a0,988 # 80023aa8 <disk+0x128>
    800056d4:	ca0fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056d8:	100017b7          	lui	a5,0x10001
    800056dc:	4398                	lw	a4,0(a5)
    800056de:	2701                	sext.w	a4,a4
    800056e0:	747277b7          	lui	a5,0x74727
    800056e4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800056e8:	18f71063          	bne	a4,a5,80005868 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800056ec:	100017b7          	lui	a5,0x10001
    800056f0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800056f2:	439c                	lw	a5,0(a5)
    800056f4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056f6:	4709                	li	a4,2
    800056f8:	16e79863          	bne	a5,a4,80005868 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056fc:	100017b7          	lui	a5,0x10001
    80005700:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005702:	439c                	lw	a5,0(a5)
    80005704:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005706:	16e79163          	bne	a5,a4,80005868 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000570a:	100017b7          	lui	a5,0x10001
    8000570e:	47d8                	lw	a4,12(a5)
    80005710:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005712:	554d47b7          	lui	a5,0x554d4
    80005716:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000571a:	14f71763          	bne	a4,a5,80005868 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000571e:	100017b7          	lui	a5,0x10001
    80005722:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005726:	4705                	li	a4,1
    80005728:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000572a:	470d                	li	a4,3
    8000572c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000572e:	10001737          	lui	a4,0x10001
    80005732:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005734:	c7ffe737          	lui	a4,0xc7ffe
    80005738:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdac9f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000573c:	8ef9                	and	a3,a3,a4
    8000573e:	10001737          	lui	a4,0x10001
    80005742:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005744:	472d                	li	a4,11
    80005746:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005748:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000574c:	439c                	lw	a5,0(a5)
    8000574e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005752:	8ba1                	andi	a5,a5,8
    80005754:	12078063          	beqz	a5,80005874 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005758:	100017b7          	lui	a5,0x10001
    8000575c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005760:	100017b7          	lui	a5,0x10001
    80005764:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005768:	439c                	lw	a5,0(a5)
    8000576a:	2781                	sext.w	a5,a5
    8000576c:	10079a63          	bnez	a5,80005880 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005770:	100017b7          	lui	a5,0x10001
    80005774:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005778:	439c                	lw	a5,0(a5)
    8000577a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000577c:	10078863          	beqz	a5,8000588c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005780:	471d                	li	a4,7
    80005782:	10f77b63          	bgeu	a4,a5,80005898 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005786:	b9efb0ef          	jal	80000b24 <kalloc>
    8000578a:	0001e497          	auipc	s1,0x1e
    8000578e:	1f648493          	addi	s1,s1,502 # 80023980 <disk>
    80005792:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005794:	b90fb0ef          	jal	80000b24 <kalloc>
    80005798:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000579a:	b8afb0ef          	jal	80000b24 <kalloc>
    8000579e:	87aa                	mv	a5,a0
    800057a0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800057a2:	6088                	ld	a0,0(s1)
    800057a4:	10050063          	beqz	a0,800058a4 <virtio_disk_init+0x1ec>
    800057a8:	0001e717          	auipc	a4,0x1e
    800057ac:	1e073703          	ld	a4,480(a4) # 80023988 <disk+0x8>
    800057b0:	0e070a63          	beqz	a4,800058a4 <virtio_disk_init+0x1ec>
    800057b4:	0e078863          	beqz	a5,800058a4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800057b8:	6605                	lui	a2,0x1
    800057ba:	4581                	li	a1,0
    800057bc:	d0cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    800057c0:	0001e497          	auipc	s1,0x1e
    800057c4:	1c048493          	addi	s1,s1,448 # 80023980 <disk>
    800057c8:	6605                	lui	a2,0x1
    800057ca:	4581                	li	a1,0
    800057cc:	6488                	ld	a0,8(s1)
    800057ce:	cfafb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    800057d2:	6605                	lui	a2,0x1
    800057d4:	4581                	li	a1,0
    800057d6:	6888                	ld	a0,16(s1)
    800057d8:	cf0fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800057dc:	100017b7          	lui	a5,0x10001
    800057e0:	4721                	li	a4,8
    800057e2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800057e4:	4098                	lw	a4,0(s1)
    800057e6:	100017b7          	lui	a5,0x10001
    800057ea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800057ee:	40d8                	lw	a4,4(s1)
    800057f0:	100017b7          	lui	a5,0x10001
    800057f4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800057f8:	649c                	ld	a5,8(s1)
    800057fa:	0007869b          	sext.w	a3,a5
    800057fe:	10001737          	lui	a4,0x10001
    80005802:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005806:	9781                	srai	a5,a5,0x20
    80005808:	10001737          	lui	a4,0x10001
    8000580c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005810:	689c                	ld	a5,16(s1)
    80005812:	0007869b          	sext.w	a3,a5
    80005816:	10001737          	lui	a4,0x10001
    8000581a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000581e:	9781                	srai	a5,a5,0x20
    80005820:	10001737          	lui	a4,0x10001
    80005824:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005828:	10001737          	lui	a4,0x10001
    8000582c:	4785                	li	a5,1
    8000582e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005830:	00f48c23          	sb	a5,24(s1)
    80005834:	00f48ca3          	sb	a5,25(s1)
    80005838:	00f48d23          	sb	a5,26(s1)
    8000583c:	00f48da3          	sb	a5,27(s1)
    80005840:	00f48e23          	sb	a5,28(s1)
    80005844:	00f48ea3          	sb	a5,29(s1)
    80005848:	00f48f23          	sb	a5,30(s1)
    8000584c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005850:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005854:	100017b7          	lui	a5,0x10001
    80005858:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000585c:	60e2                	ld	ra,24(sp)
    8000585e:	6442                	ld	s0,16(sp)
    80005860:	64a2                	ld	s1,8(sp)
    80005862:	6902                	ld	s2,0(sp)
    80005864:	6105                	addi	sp,sp,32
    80005866:	8082                	ret
    panic("could not find virtio disk");
    80005868:	00002517          	auipc	a0,0x2
    8000586c:	e6850513          	addi	a0,a0,-408 # 800076d0 <etext+0x6d0>
    80005870:	f25fa0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005874:	00002517          	auipc	a0,0x2
    80005878:	e7c50513          	addi	a0,a0,-388 # 800076f0 <etext+0x6f0>
    8000587c:	f19fa0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005880:	00002517          	auipc	a0,0x2
    80005884:	e9050513          	addi	a0,a0,-368 # 80007710 <etext+0x710>
    80005888:	f0dfa0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    8000588c:	00002517          	auipc	a0,0x2
    80005890:	ea450513          	addi	a0,a0,-348 # 80007730 <etext+0x730>
    80005894:	f01fa0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005898:	00002517          	auipc	a0,0x2
    8000589c:	eb850513          	addi	a0,a0,-328 # 80007750 <etext+0x750>
    800058a0:	ef5fa0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    800058a4:	00002517          	auipc	a0,0x2
    800058a8:	ecc50513          	addi	a0,a0,-308 # 80007770 <etext+0x770>
    800058ac:	ee9fa0ef          	jal	80000794 <panic>

00000000800058b0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800058b0:	7159                	addi	sp,sp,-112
    800058b2:	f486                	sd	ra,104(sp)
    800058b4:	f0a2                	sd	s0,96(sp)
    800058b6:	eca6                	sd	s1,88(sp)
    800058b8:	e8ca                	sd	s2,80(sp)
    800058ba:	e4ce                	sd	s3,72(sp)
    800058bc:	e0d2                	sd	s4,64(sp)
    800058be:	fc56                	sd	s5,56(sp)
    800058c0:	f85a                	sd	s6,48(sp)
    800058c2:	f45e                	sd	s7,40(sp)
    800058c4:	f062                	sd	s8,32(sp)
    800058c6:	ec66                	sd	s9,24(sp)
    800058c8:	1880                	addi	s0,sp,112
    800058ca:	8a2a                	mv	s4,a0
    800058cc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800058ce:	00c52c83          	lw	s9,12(a0)
    800058d2:	001c9c9b          	slliw	s9,s9,0x1
    800058d6:	1c82                	slli	s9,s9,0x20
    800058d8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800058dc:	0001e517          	auipc	a0,0x1e
    800058e0:	1cc50513          	addi	a0,a0,460 # 80023aa8 <disk+0x128>
    800058e4:	b10fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    800058e8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800058ea:	44a1                	li	s1,8
      disk.free[i] = 0;
    800058ec:	0001eb17          	auipc	s6,0x1e
    800058f0:	094b0b13          	addi	s6,s6,148 # 80023980 <disk>
  for(int i = 0; i < 3; i++){
    800058f4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058f6:	0001ec17          	auipc	s8,0x1e
    800058fa:	1b2c0c13          	addi	s8,s8,434 # 80023aa8 <disk+0x128>
    800058fe:	a8b9                	j	8000595c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005900:	00fb0733          	add	a4,s6,a5
    80005904:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005908:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000590a:	0207c563          	bltz	a5,80005934 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000590e:	2905                	addiw	s2,s2,1
    80005910:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005912:	05590963          	beq	s2,s5,80005964 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005916:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005918:	0001e717          	auipc	a4,0x1e
    8000591c:	06870713          	addi	a4,a4,104 # 80023980 <disk>
    80005920:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005922:	01874683          	lbu	a3,24(a4)
    80005926:	fee9                	bnez	a3,80005900 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005928:	2785                	addiw	a5,a5,1
    8000592a:	0705                	addi	a4,a4,1
    8000592c:	fe979be3          	bne	a5,s1,80005922 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005930:	57fd                	li	a5,-1
    80005932:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005934:	01205d63          	blez	s2,8000594e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005938:	f9042503          	lw	a0,-112(s0)
    8000593c:	d07ff0ef          	jal	80005642 <free_desc>
      for(int j = 0; j < i; j++)
    80005940:	4785                	li	a5,1
    80005942:	0127d663          	bge	a5,s2,8000594e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005946:	f9442503          	lw	a0,-108(s0)
    8000594a:	cf9ff0ef          	jal	80005642 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000594e:	85e2                	mv	a1,s8
    80005950:	0001e517          	auipc	a0,0x1e
    80005954:	04850513          	addi	a0,a0,72 # 80023998 <disk+0x18>
    80005958:	893fc0ef          	jal	800021ea <sleep>
  for(int i = 0; i < 3; i++){
    8000595c:	f9040613          	addi	a2,s0,-112
    80005960:	894e                	mv	s2,s3
    80005962:	bf55                	j	80005916 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005964:	f9042503          	lw	a0,-112(s0)
    80005968:	00451693          	slli	a3,a0,0x4

  if(write)
    8000596c:	0001e797          	auipc	a5,0x1e
    80005970:	01478793          	addi	a5,a5,20 # 80023980 <disk>
    80005974:	00a50713          	addi	a4,a0,10
    80005978:	0712                	slli	a4,a4,0x4
    8000597a:	973e                	add	a4,a4,a5
    8000597c:	01703633          	snez	a2,s7
    80005980:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005982:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005986:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000598a:	6398                	ld	a4,0(a5)
    8000598c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000598e:	0a868613          	addi	a2,a3,168
    80005992:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005994:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005996:	6390                	ld	a2,0(a5)
    80005998:	00d605b3          	add	a1,a2,a3
    8000599c:	4741                	li	a4,16
    8000599e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800059a0:	4805                	li	a6,1
    800059a2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800059a6:	f9442703          	lw	a4,-108(s0)
    800059aa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800059ae:	0712                	slli	a4,a4,0x4
    800059b0:	963a                	add	a2,a2,a4
    800059b2:	058a0593          	addi	a1,s4,88
    800059b6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800059b8:	0007b883          	ld	a7,0(a5)
    800059bc:	9746                	add	a4,a4,a7
    800059be:	40000613          	li	a2,1024
    800059c2:	c710                	sw	a2,8(a4)
  if(write)
    800059c4:	001bb613          	seqz	a2,s7
    800059c8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800059cc:	00166613          	ori	a2,a2,1
    800059d0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800059d4:	f9842583          	lw	a1,-104(s0)
    800059d8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800059dc:	00250613          	addi	a2,a0,2
    800059e0:	0612                	slli	a2,a2,0x4
    800059e2:	963e                	add	a2,a2,a5
    800059e4:	577d                	li	a4,-1
    800059e6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800059ea:	0592                	slli	a1,a1,0x4
    800059ec:	98ae                	add	a7,a7,a1
    800059ee:	03068713          	addi	a4,a3,48
    800059f2:	973e                	add	a4,a4,a5
    800059f4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800059f8:	6398                	ld	a4,0(a5)
    800059fa:	972e                	add	a4,a4,a1
    800059fc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005a00:	4689                	li	a3,2
    80005a02:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005a06:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005a0a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005a0e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005a12:	6794                	ld	a3,8(a5)
    80005a14:	0026d703          	lhu	a4,2(a3)
    80005a18:	8b1d                	andi	a4,a4,7
    80005a1a:	0706                	slli	a4,a4,0x1
    80005a1c:	96ba                	add	a3,a3,a4
    80005a1e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005a22:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005a26:	6798                	ld	a4,8(a5)
    80005a28:	00275783          	lhu	a5,2(a4)
    80005a2c:	2785                	addiw	a5,a5,1
    80005a2e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005a32:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005a36:	100017b7          	lui	a5,0x10001
    80005a3a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005a3e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005a42:	0001e917          	auipc	s2,0x1e
    80005a46:	06690913          	addi	s2,s2,102 # 80023aa8 <disk+0x128>
  while(b->disk == 1) {
    80005a4a:	4485                	li	s1,1
    80005a4c:	01079a63          	bne	a5,a6,80005a60 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005a50:	85ca                	mv	a1,s2
    80005a52:	8552                	mv	a0,s4
    80005a54:	f96fc0ef          	jal	800021ea <sleep>
  while(b->disk == 1) {
    80005a58:	004a2783          	lw	a5,4(s4)
    80005a5c:	fe978ae3          	beq	a5,s1,80005a50 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005a60:	f9042903          	lw	s2,-112(s0)
    80005a64:	00290713          	addi	a4,s2,2
    80005a68:	0712                	slli	a4,a4,0x4
    80005a6a:	0001e797          	auipc	a5,0x1e
    80005a6e:	f1678793          	addi	a5,a5,-234 # 80023980 <disk>
    80005a72:	97ba                	add	a5,a5,a4
    80005a74:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a78:	0001e997          	auipc	s3,0x1e
    80005a7c:	f0898993          	addi	s3,s3,-248 # 80023980 <disk>
    80005a80:	00491713          	slli	a4,s2,0x4
    80005a84:	0009b783          	ld	a5,0(s3)
    80005a88:	97ba                	add	a5,a5,a4
    80005a8a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a8e:	854a                	mv	a0,s2
    80005a90:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a94:	bafff0ef          	jal	80005642 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005a98:	8885                	andi	s1,s1,1
    80005a9a:	f0fd                	bnez	s1,80005a80 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a9c:	0001e517          	auipc	a0,0x1e
    80005aa0:	00c50513          	addi	a0,a0,12 # 80023aa8 <disk+0x128>
    80005aa4:	9e8fb0ef          	jal	80000c8c <release>
}
    80005aa8:	70a6                	ld	ra,104(sp)
    80005aaa:	7406                	ld	s0,96(sp)
    80005aac:	64e6                	ld	s1,88(sp)
    80005aae:	6946                	ld	s2,80(sp)
    80005ab0:	69a6                	ld	s3,72(sp)
    80005ab2:	6a06                	ld	s4,64(sp)
    80005ab4:	7ae2                	ld	s5,56(sp)
    80005ab6:	7b42                	ld	s6,48(sp)
    80005ab8:	7ba2                	ld	s7,40(sp)
    80005aba:	7c02                	ld	s8,32(sp)
    80005abc:	6ce2                	ld	s9,24(sp)
    80005abe:	6165                	addi	sp,sp,112
    80005ac0:	8082                	ret

0000000080005ac2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005ac2:	1101                	addi	sp,sp,-32
    80005ac4:	ec06                	sd	ra,24(sp)
    80005ac6:	e822                	sd	s0,16(sp)
    80005ac8:	e426                	sd	s1,8(sp)
    80005aca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005acc:	0001e497          	auipc	s1,0x1e
    80005ad0:	eb448493          	addi	s1,s1,-332 # 80023980 <disk>
    80005ad4:	0001e517          	auipc	a0,0x1e
    80005ad8:	fd450513          	addi	a0,a0,-44 # 80023aa8 <disk+0x128>
    80005adc:	918fb0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005ae0:	100017b7          	lui	a5,0x10001
    80005ae4:	53b8                	lw	a4,96(a5)
    80005ae6:	8b0d                	andi	a4,a4,3
    80005ae8:	100017b7          	lui	a5,0x10001
    80005aec:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005aee:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005af2:	689c                	ld	a5,16(s1)
    80005af4:	0204d703          	lhu	a4,32(s1)
    80005af8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005afc:	04f70663          	beq	a4,a5,80005b48 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005b00:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b04:	6898                	ld	a4,16(s1)
    80005b06:	0204d783          	lhu	a5,32(s1)
    80005b0a:	8b9d                	andi	a5,a5,7
    80005b0c:	078e                	slli	a5,a5,0x3
    80005b0e:	97ba                	add	a5,a5,a4
    80005b10:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005b12:	00278713          	addi	a4,a5,2
    80005b16:	0712                	slli	a4,a4,0x4
    80005b18:	9726                	add	a4,a4,s1
    80005b1a:	01074703          	lbu	a4,16(a4)
    80005b1e:	e321                	bnez	a4,80005b5e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b20:	0789                	addi	a5,a5,2
    80005b22:	0792                	slli	a5,a5,0x4
    80005b24:	97a6                	add	a5,a5,s1
    80005b26:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005b28:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b2c:	f0afc0ef          	jal	80002236 <wakeup>

    disk.used_idx += 1;
    80005b30:	0204d783          	lhu	a5,32(s1)
    80005b34:	2785                	addiw	a5,a5,1
    80005b36:	17c2                	slli	a5,a5,0x30
    80005b38:	93c1                	srli	a5,a5,0x30
    80005b3a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005b3e:	6898                	ld	a4,16(s1)
    80005b40:	00275703          	lhu	a4,2(a4)
    80005b44:	faf71ee3          	bne	a4,a5,80005b00 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005b48:	0001e517          	auipc	a0,0x1e
    80005b4c:	f6050513          	addi	a0,a0,-160 # 80023aa8 <disk+0x128>
    80005b50:	93cfb0ef          	jal	80000c8c <release>
}
    80005b54:	60e2                	ld	ra,24(sp)
    80005b56:	6442                	ld	s0,16(sp)
    80005b58:	64a2                	ld	s1,8(sp)
    80005b5a:	6105                	addi	sp,sp,32
    80005b5c:	8082                	ret
      panic("virtio_disk_intr status");
    80005b5e:	00002517          	auipc	a0,0x2
    80005b62:	c2a50513          	addi	a0,a0,-982 # 80007788 <etext+0x788>
    80005b66:	c2ffa0ef          	jal	80000794 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
