package i2c_pkg;
	
	// Define register addresses
	parameter IIC_GIE_ADDR			= 32'h01C;  // GIE: Global Interrupt Enable Register
	parameter IIC_ISR_ADDR			= 32'h020;  // ISR: Interrupt Status Register
	parameter IIC_IER_ADDR			= 32'h028;  // IER: Interrupt Enable Register
	parameter IIC_SOFTR_ADDR		= 32'h040;  // SOFTR: Soft Reset Register
	parameter IIC_CR_ADDR			= 32'h100;  // CR: Control Register
	parameter IIC_SR_ADDR			= 32'h104;  // SR: Status Register
	parameter IIC_TXFIFO_ADDR		= 32'h108;  // TX_FIFO: Transmit FIFO Register
	parameter IIC_RXFIFO_ADDR		= 32'h10C;  // RX_FIFO: Receive FIFO Register
	parameter IIC_ADR_ADDR			= 32'h110;  // ADR: Slave Address Register
	parameter IIC_TXFIFO_OCY_ADDR	= 32'h114;  // TX_FIFO_OCY: Transmit FIFO Occupancy Register
	parameter IIC_RXFIFO_OCY_ADDR	= 32'h118;  // RX_FIFO_OCY: Receive FIFO Occupancy Register
	parameter IIC_TEN_ADR_ADDR		= 32'h11C;  // TEN_ADR: Slave Ten Bit Address Register
	parameter IIC_RXFIFO_PIRQ_ADDR	= 32'h120;  // RX_FIFO_PIRQ: Receive FIFO Programmable Depth Interrupt Register
	parameter IIC_GPO_ADDR			= 32'h124;  // GPO: General Purpose Output Register
	parameter IIC_TSUSTA_ADDR      	= 32'h128;  // TSUSTA: Timing Parameter Register
	parameter IIC_TSUSTO_ADDR      	= 32'h12C;  // TSUSTO: Timing Parameter Register
	parameter IIC_THDSTA_ADDR      	= 32'h130;  // THDSTA: Timing Parameter Register
	parameter IIC_TSUDAT_ADDR      	= 32'h134;  // TSUDAT: Timing Parameter Register
	parameter IIC_TBUF_ADDR        	= 32'h138;  // TBUF:   Timing Parameter Register
	parameter IIC_THIGH_ADDR       	= 32'h13C;  // THIGH:  Timing Parameter Register
	parameter IIC_TLOW_ADDR        	= 32'h140;  // TLOW:   Timing Parameter Register
	parameter IIC_THDDAT_ADDR      	= 32'h144;  // THDDAT: Timing Parameter Register

	typedef struct packed {
		logic           GIE     ;           // Bit 31: Global Interrupt Enable
		logic [30:0]    Reserved;           // Bits 30 to 0: Reserved (not used)
	} gie_t;

	typedef struct packed {
		logic [23:0]    Reserved;           // Bits 31 to 8: Reserved (not used)
		logic           transmit_FIFO_half_empty;           // Bit 7: Interrupt(7) — Transmit FIFO Half Empty
		logic           not_addressed_as_slave  ;           // Bit 6: Interrupt(6) — Not Addressed As Slave
		logic           addressed_as_slave    	;           // Bit 5: Interrupt(5) — Addressed As Slave
		logic           bus_busy    			;           // Bit 4: Interrupt(4) — IIC Bus is Not Busy
		logic           receive_FIFO_full    	;           // Bit 3: Interrupt(3) — Receive FIFO Full
		logic           transmit_FIFO_empty    	;           // Bit 2: Interrupt(2) — Transmit FIFO Empty
		logic           transmit_errort1    	;           // Bit 1: Interrupt(1) — Transmit Error/Slave Transmit Complete
		logic           arbitration_lost    	;           // Bit 0: Interrupt(0) — Arbitration Lost
	} isr_t;

	typedef struct packed {
		logic [23:0]    Reserved;           // Bits 31 to 8: Reserved (not used)
		logic           transmit_FIFO_half_empty;           // Bit 7: Interrupt(7) — Transmit FIFO Half Empty
		logic           not_addressed_as_slave  ;           // Bit 6: Interrupt(6) — Not Addressed As Slave
		logic           addressed_as_slave    	;           // Bit 5: Interrupt(5) — Addressed As Slave
		logic           bus_busy    			;           // Bit 4: Interrupt(4) — IIC Bus is Not Busy
		logic           receive_FIFO_full    	;           // Bit 3: Interrupt(3) — Receive FIFO Full
		logic           transmit_FIFO_empty    	;           // Bit 2: Interrupt(2) — Transmit FIFO Empty
		logic           transmit_errort1    	;           // Bit 1: Interrupt(1) — Transmit Error/Slave Transmit Complete
		logic           arbitration_lost    	;           // Bit 0: Interrupt(0) — Arbitration Lost
	} ier_t;

	typedef struct packed {
		logic [27:0]    Reserved;           // Bits 31 to 4: Reserved (not used)
		logic [3:0]     RKEY    ;           // Bits 3 to 0: Reset Key
	} softr_t;

	typedef struct packed {
		logic [24:0]    Reserved;              // Bits 31 to 7: Reserved (not used)
		logic           GC_EN   ;              // Bit 6: General Call Enable
		logic           RSTA    ;              // Bit 5: Repeated Start
		logic           TXAK    ;              // Bit 4: Transmit Acknowledge Enable
		logic           TX      ;              // Bit 3: Transmit/Receive Mode Select
		logic           MSMS    ;              // Bit 2: Master/Slave Mode Select
		logic           TX_FIFO_Reset;         // Bit 1: Transmit FIFO Reset
		logic           EN      ;              // Bit 0: AXI IIC Enable
	} control_register_t;

	typedef struct packed {
		logic [23:0]    Reserved        ;      // Bits 31 to 8: Reserved (not used)
		logic           TX_FIFO_Empty   ;      // Bit 7: Transmit FIFO empty
		logic           RX_FIFO_Empty   ;      // Bit 6: Receive FIFO empty
		logic           RX_FIFO_Full    ;      // Bit 5: Receive FIFO full
		logic           TX_FIFO_Full    ;      // Bit 4: Transmit FIFO full
		logic           SRW             ;      // Bit 3: Slave Read/Write
		logic           BB              ;      // Bit 2: Bus Busy
		logic           AAS             ;      // Bit 1: Addressed as Slave
		logic           ABGC            ;      // Bit 0: Addressed By a General Call
	} status_register_t;

	typedef struct packed {
		logic [21:0]    Reserved        ;      // Bits 31 to 10: Reserved (not used)
		logic           Stop            ;      // Bit 9: Stop
		logic           Start           ;      // Bit 8: Start
		logic [7:0]     Txd	        	;      // Bits 7 to 0: AXI IIC Transmit Data
	} tx_fifo_t;

	typedef struct packed {
		logic [23:0]    Reserved        ;      // Bits 31 to 8: Reserved (not used)
		logic [7:0]     Rxd        		;      // Bits 7 to 0: IIC Receive Data
	} rx_fifo_t;

	typedef struct packed {
		logic [23:0]    Reserved_1      ;      // Bits 31 to 8: Reserved (not used)
		logic [6:0]     Slave_Address   ;      // Bits 7 to 1: Slave Address
		logic [0:0]     Reserved_0      ;      // Bit 0: Reserved (not used)
	} adr_t;

	typedef struct packed {
		logic [29:0]    Reserved            ;  // Bits 31 to 3: Reserved (not used)
		logic [2:0]     MSB_Slave_Address   ;  // Bits 2 to 0: MSB of Slave Address
	} ten_adr_t;

	typedef struct packed {
		logic [27:0]    Reserved            ;  // Bits 31 to 4: Reserved (not used)
		logic [3:0]     Occupancy_Value     ;  // Bits 3 to 0: Occupancy Value (Bit[3] is the MSB)
	} tx_fifo_ocy_t;

	typedef struct packed {
		logic [27:0]    Reserved            ;  // Bits 31 to 4: Reserved (not used)
		logic [3:0]     Occupancy_Value     ;  // Bits 3 to 0: Occupancy Value (Bit[3] is the MSB)
	} rx_fifo_ocy_t;

	typedef struct packed {
		logic [27:0]    Reserved            ;  // Bits 31 to 4: Reserved (not used)
		logic [3:0]     Compare_Value       ;  // Bits 3 to 0: Compare Value (Bit[3] is the MSB)
	} rx_fifo_pirq_t;

	typedef struct packed {
		logic [19:0]    Reserved            ;  // Bits 31 to 12: Reserved (not used)
		logic [11:0]    GPO_Outputs         ;  // Bits 11 to 0: General Purpose Outputs (Bit[0] is the LSB)
	} gpo_t;

	typedef struct packed {
		logic [31:0]    TSUSTA_Value        ;  // Bits 31 to 0: TSUSTA (Setup time for a repeated START condition)
	} tsusta_t;

	typedef struct packed {
		logic [31:0]    TSUSTO_Value        ;  // Bits 31 to 0: TSUSTO (Setup time for a repeated STOP condition)
	} tsusto_t;

	typedef struct packed {
		logic [31:0]    THDSTA_Value        ;  // Bits 31 to 0: THDSTA (Hold time for a repeated START condition)
	} thdsta_t;

	typedef struct packed {
		logic [31:0]    TSUDAT_Value        ;  // Bits 31 to 0: TSUDAT (Data setup time)
	} tsudat_t;

	typedef struct packed {
		logic [31:0]    TBUF_Value          ;  // Bits 31 to 0: TBUF (Bus free time between a STOP and START condition)
	} tbuf_t;

	typedef struct packed {
		logic [31:0]    THIGH_Value         ;  // Bits 31 to 0: THIGH (High period of the SCL clock)
	} thigh_t;

	typedef struct packed {
		logic [31:0]    TLOW_Value          ;  // Bits 31 to 0: TLOW (Low period of the SCL clock)
	} tlow_t;

	typedef struct packed {
		logic [31:0]    THDDAT_Value        ;  // Bits 31 to 0: THDDAT (Data hold time)
	} thddat_t;
	
	typedef struct {

		gie_t                   global_intr_enable          ;
		isr_t                   intr_status_register        ;
		ier_t                   intr_enable_register        ;
		softr_t                 soft_reset_register         ;
		control_register_t      control_register            ;
		status_register_t       status_register             ;
		tx_fifo_t               TX_FIFO                     ;
		rx_fifo_t               RX_FIFO                     ;
		adr_t                   slave_7bit_addr             ;
		tx_fifo_ocy_t           TX_FIFO_OCY                 ;
		rx_fifo_ocy_t           RX_FIFO_OCY                 ;
		ten_adr_t               slave_10bit_addr            ;
		rx_fifo_pirq_t          RX_FIFO_PIRQ                ;
		gpo_t                   gpo                         ;
		tsusta_t                tsusta                      ;
		tsusto_t                tsusto                      ;
		thdsta_t                thdsta                      ;
		tsudat_t                tsudat                      ;
		tbuf_t                  tbuf                        ;
		thigh_t                 thigh                       ;
		tlow_t                  tlow                        ;
		thddat_t                thddat                      ;

	} i2c_register_space_t;
	
//	typedef struct {
//
//		gie_t                   global_intr_enable          ;
//		isr_t                   intr_status_register        ;
//		ier_t                   intr_enable_register        ;
//		status_register_t       status_register             ;
//		adr_t                   adr                         ;
//		tx_fifo_ocy_t           TX_FIFO_OCY                 ;
//		rx_fifo_ocy_t           RX_FIFO_OCY                 ;
//		ten_adr_t               ten_adr                     ;
//		rx_fifo_pirq_t          RX_FIFO_PIRQ                ;
//		gpo_t                   gpo                         ;
//		tsusta_t                tsusta                      ;
//		tsusto_t                tsusto                      ;
//		thdsta_t                thdsta                      ;
//		tsudat_t                tsudat                      ;
//		tbuf_t                  tbuf                        ;
//		thigh_t                 thigh                       ;
//		tlow_t                  tlow                        ;
//		thddat_t                thddat                      ;
//
//	} status_registers_t;
//
//	typedef struct {
//
//		gie_t                   global_intr_enable          ;
//		isr_t                   intr_status_register        ;
//		ier_t                   intr_enable_register        ;
//		softr_t                 softr                       ;
//		control_register_t      control_register            ;
//		adr_t                   adr                         ;
//		tx_fifo_ocy_t           TX_FIFO_OCY                 ;
//		rx_fifo_ocy_t           RX_FIFO_OCY                 ;
//		ten_adr_t               ten_adr                     ;
//		rx_fifo_pirq_t          RX_FIFO_PIRQ                ;
//		gpo_t                   gpo                         ;
//		tsusta_t                tsusta                      ;
//		tsusto_t                tsusto                      ;
//		thdsta_t                thdsta                      ;
//		tsudat_t                tsudat                      ;
//		tbuf_t                  tbuf                        ;
//		thigh_t                 thigh                       ;
//		tlow_t                  tlow                        ;
//		thddat_t                thddat                      ;
//
//	} control_registers_t;


endpackage : i2c_pkg
