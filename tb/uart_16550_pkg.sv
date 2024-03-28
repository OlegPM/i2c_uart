package uart_16550_pkg;
	
     // Define register addresses
    parameter UART_RBR_ADDR = 32'h1000;
    parameter UART_THR_ADDR = 32'h1000;
    parameter UART_IER_ADDR = 32'h1004;
    parameter UART_IIR_ADDR = 32'h1008;
    parameter UART_FCR_ADDR = 32'h1008;
    parameter UART_LCR_ADDR = 32'h100C;
    parameter UART_MCR_ADDR = 32'h1010;
    parameter UART_LSR_ADDR = 32'h1014;
    parameter UART_MSR_ADDR = 32'h1018;
    parameter UART_SCR_ADDR = 32'h101C;
    parameter UART_DLL_ADDR = 32'h1000;
    parameter UART_DLM_ADDR = 32'h1004;
	
    // Receiver Buffer Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved	;
        logic [7:0] 	RBR			; // Last received character
    } RBR_t;

    // Transmitter Holding Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved	;
        logic [7:0] 	THR			; // Holds the character to be transmitted next
    } THR_t;
	
	// Interrupt Enable Register bit definitions
	typedef struct packed {
        logic [31:4] 	Reserved	;
        logic 			EDSSI		; // Enable Modem Status Interrupt
        logic 			ELSI		; // Enable Receiver Line Status Interrupt
        logic 			ETBEI		; // Enable Transmitter Holding Register Empty Interrupt
        logic 			ERBFI		; // Enable Received Data Available Interrupt
    } IER_t;
	
	// Interrupt Identification Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved	;
        logic [7:6] 	FIFOEN		; // FIFOs Enabled
        logic [5:4] 	Reserved2	;
        logic [3:1] 	INTID2		; // Interrupt ID
        logic 			INTPEND		; // Interrupt Pending
    } IIR_t;
	
	// FIFO Control Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved				;
        logic [7:6] 	RCVR_FIFO_Trigger_Level	; // Receiver FIFO Trigger Level
        logic [5:4] 	Reserved2				;
        logic [3:3] 	DMA_Mode_Select			; // DMA Mode Select
        logic [2:2] 	XMIT_FIFO_Reset			; // Transmitter FIFO Reset
        logic [1:1] 	RCVR_FIFO_Reset			; // Receiver FIFO Reset
        logic 			FIFOEN					; // FIFO Enable
    } FCR_t;

    // Line Control Register bit definitions
	typedef struct packed {
        logic [31:8] 	Reserved	;
        logic 			DLAB		; // Divisor Latch Access Bit
        logic 			Set_Break	; // Set Break
        logic 			Stick_Parity; // Stick Parity
        logic 			EPS			; // Even Parity Select
        logic 			PEN			; // Parity Enable
        logic 			STB			; // Number of Stop Bits
        logic [1:0] 	WLS			; // Word Length Select
	} LCR_t;
	
	// Modem Control Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved;
        logic [2:0] 	N_A		; // Not applicable
        logic 			Loop	; // Loop Back
        logic 			Out2	; // User Output 2
        logic 			Out1	; // User Output 1
        logic 			RTS		; // Request To Send
        logic 			DTR		; // Data Terminal Ready
    } MCR_t;
	
	// Line Status Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved			;
        logic 			Error_in_RCVR_FIFO	; // Error in Receiver FIFO
        logic 			TEMT				; // Transmitter Empty
        logic 			THRE				; // Transmitter Holding Register Empty
        logic 			BI					; // Break Interrupt
        logic 			FE					; // Framing Error
        logic 			PE					; // Parity Error
        logic 			OE					; // Overrun Error
        logic 			DR					; // Data Ready
    } LSR_t;
	
	// Modem Status Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved	;
        logic 			DCD			; // Data Carrier Detect
        logic 			RI			; // Ring Indicator
        logic 			DSR			; // Data Set Ready
        logic 			CTS			; // Clear To Send
        logic 			DDCD		; // Delta Data Carrier Detect
        logic 			TERI		; // Trailing Edge Ring Indicator
        logic 			DDSR		; // Delta Data Set Ready
        logic 			DCTS		; // Delta Clear To Send
    } MSR_t;
	
	// Scratch Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved	;
        logic [7:0] 	Scratch		; // Hold user data
    } ScratchRegister_t;
	
	// Divisor Latch (Least Significant Byte) Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved	;
        logic [7:0] 	DLL			; // Divisor Latch Least Significant Byte
    } DLL_Register_t;
	
	// Divisor Latch (Most Significant Byte) Register bit definitions
    typedef struct packed {
        logic [31:8] 	Reserved	;
        logic [7:0] 	DLM			; // Divisor Latch Most Significant Byte
    } DLM_Register_t;
	
	
endpackage: uart_16550_pkg


//    // Register offsets
//    parameter RBR_OFFSET = 4'h0;
//    parameter THR_OFFSET = 4'h0;
//    parameter IER_OFFSET = 4'h4;
//    parameter IIR_OFFSET = 4'h8;
//    parameter FCR_OFFSET = 4'h8;
//    parameter LCR_OFFSET = 4'hC;
//    parameter MCR_OFFSET = 4'h10;
//    parameter LSR_OFFSET = 4'h14;
//    parameter MSR_OFFSET = 4'h18;
//    parameter SCR_OFFSET = 4'h1C;
//    parameter DLL_OFFSET = 4'h0;
//    parameter DLM_OFFSET = 4'h4;