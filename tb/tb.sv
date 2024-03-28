`ifndef ZYNQ
`define ZYNQ tb.I2C_Uart_wrapper_0.I2C_Uart_i.zynq_ultra_ps_e_0
`endif

`define ZYNQ_AXI_MASTER `ZYNQ.inst

`timescale 1ns/10ps

module tb;

	wire iic_rtl_0_scl_io;
	wire iic_rtl_0_sda_io;
	wire iic_rtl_scl_io;
	wire iic_rtl_sda_io;

	logic uart_rtl_0_baudoutn;
	logic uart_rtl_0_ctsn;
	logic uart_rtl_0_dcdn;
	logic uart_rtl_0_ddis;
	logic uart_rtl_0_dsrn;
	logic uart_rtl_0_dtrn;
	logic uart_rtl_0_out1n;
	logic uart_rtl_0_out2n;
	logic uart_rtl_0_ri;
	logic uart_rtl_0_rtsn;
	logic uart_rtl_0_rxd;
	logic uart_rtl_0_rxrdyn;
	logic uart_rtl_0_txd;
	logic uart_rtl_0_txrdyn;
	logic uart_rtl_baudoutn;
	logic uart_rtl_ctsn;
	logic uart_rtl_dcdn;
	logic uart_rtl_ddis;
	logic uart_rtl_dsrn;
	logic uart_rtl_dtrn;
	logic uart_rtl_out1n;
	logic uart_rtl_out2n;
	logic uart_rtl_ri;
	logic uart_rtl_rtsn;
	logic uart_rtl_rxd;
	logic uart_rtl_rxrdyn;
	logic uart_rtl_txd;
	logic uart_rtl_txrdyn;
	
	import i2c_pkg::*;
	import uart_16550_pkg::*;
	
	parameter AXI_CLK_FREQUENCY = 100e6;
	
	parameter IIC_0_BASE_ADDR 	= 32'h8000_0000;
	parameter IIC_1_BASE_ADDR 	= 32'h8001_0000;
	parameter UART_0_BASE_ADDR 	= 32'h8002_0000;
	parameter UART_1_BASE_ADDR 	= 32'h8003_0000;
	
	parameter int BAUD_RATE		= 921600;
	
	parameter IIC_EEPROM_ADDR  	= 7'h_51;// 32'h_68; 1010001
	parameter IIC_SLAVE_ADDR  	= 7'h_68;// 32'h_68; 1010001
		
	parameter N_SENT_BYTES 		= 'h_04; // 128 bytes

	logic [7:0] uart_received_data [$];
	logic [7:0] uart_data_to_send  [$];
	
	logic [7:0] iic_received_data [$];
	logic [7:0] iic_data_to_send  [$];
	
	int error = 0;
	int mismatch = 0;
	I2C_Uart_wrapper I2C_Uart_wrapper_0(
		.iic_rtl_0_scl_io       (iic_rtl_0_scl_io)      ,
		.iic_rtl_0_sda_io       (iic_rtl_0_sda_io)      ,
		.iic_rtl_scl_io         (iic_rtl_scl_io)        ,
		.iic_rtl_sda_io         (iic_rtl_sda_io)        ,
		
		.uart_rtl_0_baudoutn    (uart_rtl_0_baudoutn)   ,
		.uart_rtl_0_ctsn        (uart_rtl_0_ctsn)       ,
		.uart_rtl_0_dcdn        (uart_rtl_0_dcdn)       ,
		.uart_rtl_0_ddis        (uart_rtl_0_ddis)       ,
		.uart_rtl_0_dsrn        (uart_rtl_0_dsrn)       ,
		.uart_rtl_0_dtrn        (uart_rtl_0_dtrn)       ,
		.uart_rtl_0_out1n       (uart_rtl_0_out1n)      ,
		.uart_rtl_0_out2n       (uart_rtl_0_out2n)      ,
		.uart_rtl_0_ri          (uart_rtl_0_ri)         ,
		.uart_rtl_0_rtsn        (uart_rtl_0_rtsn)       ,
		.uart_rtl_0_rxd         (uart_rtl_0_rxd)        ,
		.uart_rtl_0_rxrdyn      (uart_rtl_0_rxrdyn)     ,
		.uart_rtl_0_txd         (uart_rtl_0_txd)        ,
		.uart_rtl_0_txrdyn      (uart_rtl_0_txrdyn)     ,
		
		.uart_rtl_baudoutn      (uart_rtl_baudoutn)     ,
		.uart_rtl_ctsn          (uart_rtl_ctsn)         ,
		.uart_rtl_dcdn          (uart_rtl_dcdn)         ,
		.uart_rtl_ddis          (uart_rtl_ddis)         ,
		.uart_rtl_dsrn          (uart_rtl_dsrn)         ,
		.uart_rtl_dtrn          (uart_rtl_dtrn)         ,
		.uart_rtl_out1n         (uart_rtl_out1n)        ,
		.uart_rtl_out2n         (uart_rtl_out2n)        ,
		.uart_rtl_ri            (uart_rtl_ri)           ,
		.uart_rtl_rtsn          (uart_rtl_rtsn)         ,
		.uart_rtl_rxd           (uart_rtl_rxd)          ,
		.uart_rtl_rxrdyn        (uart_rtl_rxrdyn)       ,
		.uart_rtl_txd           (uart_rtl_txd)          ,
		.uart_rtl_txrdyn        (uart_rtl_txrdyn)
		);
	
	M24FC512 M24FC512_0(
		.A0		(IIC_EEPROM_ADDR[0]), 
		.A1		(IIC_EEPROM_ADDR[1]), 
		.A2		(IIC_EEPROM_ADDR[2]), 
		.WP		(1'b0), 
		.SDA	(iic_rtl_sda_io), 
		.SCL	(iic_rtl_scl_io), 
		.RESET	(`ZYNQ.pl_resetn0)//`ZYNQ.pl_resetn0
		);
	
	pullup(iic_rtl_0_scl_io);
	pullup(iic_rtl_0_sda_io);

	pullup(iic_rtl_scl_io);
	pullup(iic_rtl_sda_io);

	tran(iic_rtl_0_scl_io, iic_rtl_scl_io);
	tran(iic_rtl_0_sda_io, iic_rtl_sda_io);
	
	assign uart_rtl_rxd = uart_rtl_0_txd;
	assign uart_rtl_0_rxd = uart_rtl_txd;
	
	enum logic {
		READ = 1'b1,
		WRITE= 1'b0
	} op_code_e;
	
	initial test;
	
	task test;
		realtime timestamp;

		logic [7:0] rd_data;		
		automatic logic [31: 0] mem_address = 0;
		`ZYNQ_AXI_MASTER.set_debug_level_info(0);
		
		timestamp = $realtime;
		wait (`ZYNQ.pl_resetn0);
		$display("\n[%t]\t ============ TEST > RUN (reset released)\n", timestamp);
//------------------------------------UART----------------------------------------------------		
//		fillup_random_data(uart_data_to_send);
//
//		UART_CONFIG(UART_0_BASE_ADDR, BAUD_RATE);
//		UART_CONFIG(UART_1_BASE_ADDR, BAUD_RATE);
//				
//		fork
//			UART_RECEIVE(UART_1_BASE_ADDR, rd_data);
//			for (int i=0; i<N_SENT_BYTES;i++)
//				UART_SEND_DATA   (UART_0_BASE_ADDR,  uart_data_to_send[i]);
//			
//		join
//		compare_results(uart_data_to_send, uart_received_data);	
//		uart_data_to_send.delete();
//		uart_received_data.delete();
//		fillup_random_data(uart_data_to_send);
//		
//		fork
//			UART_RECEIVE(UART_0_BASE_ADDR, rd_data);
//			for (int i=0; i<N_SENT_BYTES;i++)
//				UART_SEND_DATA   (UART_1_BASE_ADDR,  uart_data_to_send[i]);
//		join
//		compare_results(uart_data_to_send, uart_received_data);	
//------------------------------------IIC MEMORY----------------------------------------------	
		iic_received_data.delete();
		fillup_random_data(iic_data_to_send);

		IIC_INIT(IIC_0_BASE_ADDR);

		IIC_WRITE_DATA(IIC_0_BASE_ADDR, IIC_EEPROM_ADDR, mem_address, iic_data_to_send);

		IIC_READ_DATA(IIC_0_BASE_ADDR, IIC_EEPROM_ADDR, mem_address, N_SENT_BYTES, iic_received_data);

        compare_results(iic_data_to_send, iic_received_data); 
//------------------------------------IIC-----------------------------------------------------	
//		iic_received_data.delete();
//		#100_000;
//		fillup_random_data(iic_data_to_send);
//		
//		IIC_INIT(IIC_0_BASE_ADDR);
//		IIC_INIT(IIC_1_BASE_ADDR, IIC_SLAVE_ADDR);
//		fork
//			IIC_SLAVE_WAIT_RECIEVED_DATA(IIC_1_BASE_ADDR, rd_data);	
//			IIC_SEND_DATA(IIC_0_BASE_ADDR, IIC_SLAVE_ADDR, iic_data_to_send);
//		join
//		
//        compare_results(iic_data_to_send, iic_received_data);
//--------------------------------------------------------------------------------------------
		#100_000 $display("\n[%t]\t ============ TEST > DONE (errors %d mismatch %d duration %t [ns])\n", $time, error, mismatch,  real'($realtime - timestamp));
		`include "__stop.vi"
	endtask



	task AXI_READ(input logic [31: 0] ADDR, output logic [31: 0] READ_DATA);
		logic resp;
		`ZYNQ_AXI_MASTER.read_data (ADDR,4, READ_DATA, resp);
	endtask

	task AXI_WRITE(input logic [31: 0] ADDR, input logic [31: 0] WRITE_DATA);
		logic resp;
		`ZYNQ_AXI_MASTER.write_data(ADDR,4, WRITE_DATA, resp);
	endtask
	
	
	
	task UART_CONFIG(input logic [31:0] BASE_ADDR, input logic [31:0] baud_rate); 
		int dll_value; // Least significant byte of the divisor
		int dlm_value; // Most significant byte of the divisor
	    integer 	divisor	;
		
		FCR_t FCR_r;
		IER_t IER_r;
		LCR_t LCR_r;
		
		FCR_r =  '0;
		IER_r =  '0;
		LCR_r =  '0;
		
		FCR_r.FIFOEN 	= 1'b1	; 	// FIFO Enable
		IER_r.ERBFI 	= 1'b1	; 	// 1 = Enables Received Data Available Interrupts
		LCR_r.WLS 		= 2'b11	; 	// 2'b11 = 8 bits/character.
		LCR_r.DLAB		= 1'b1	;   // Set DLAB bit to 1 to have access to Divisor Latch
		
		AXI_WRITE(BASE_ADDR + UART_FCR_ADDR, FCR_r);
		AXI_WRITE(BASE_ADDR + UART_IER_ADDR, IER_r);
		AXI_WRITE(BASE_ADDR + UART_LCR_ADDR, LCR_r);
		
	    // Calculate divisor value with formula 
	    // divisor = (AXI CLK frequency/(16 × Baud Rate))
	    divisor = AXI_CLK_FREQUENCY / (16 * baud_rate);
		
	    dll_value = divisor & 8'hFF;
	    dlm_value = (divisor >> 8) & 8'hFF;
		
//	    dll_value = divisor [7:0] ;
//	    dlm_value = divisor [15:8];
	    // Write to DLL and DLM
	    AXI_WRITE(BASE_ADDR + UART_DLL_ADDR, dll_value);
	    AXI_WRITE(BASE_ADDR + UART_DLM_ADDR, dlm_value);
	    
	    LCR_r.DLAB		= 1'b0	; 
	    // Clear divisor latch
	    AXI_WRITE(BASE_ADDR + UART_LCR_ADDR, LCR_r); // Set DLAB bit to 0
	endtask
	
	task UART_SEND_DATA(input logic [31:0] BASE_ADDR, input logic [7:0] data);
		$display("\n[%t]\t ============ UART SENT DATA %h", $time, data);
		AXI_WRITE(BASE_ADDR + UART_THR_ADDR, 32'(data));
		endtask	
		
	task UART_RECEIVE(input logic [31:0] BASE_ADDR, output logic [7:0] data);
		IIR_t receiver_irq;
		int count;
		count = 0;
		while (count < N_SENT_BYTES) begin
			receiver_irq = '0;
			while (receiver_irq.INTID2 != 3'b010) begin
				#5_000 AXI_READ(BASE_ADDR + UART_IIR_ADDR, receiver_irq);
//				$display("\n[%t]\t ============ UART WAITING DATA", $time);
			end
			AXI_READ(BASE_ADDR + UART_RBR_ADDR, data);
			$display("\n[%t]\t ============ UART RECEIVED DATA %h", $time, data);
			uart_received_data.push_back(8'(data));
			count ++;
		end
	endtask	
	


	task IIC_INIT(logic [31 : 0] BASE_ADDR, logic [31: 0] iic_slave_addr = 0);
		control_register_t 	iic_control_register;
		rx_fifo_pirq_t 		iic_rx_fifo_pirq;
		
		iic_control_register 		= '0;
		iic_rx_fifo_pirq 			= '0;
		
		// Writing Addr to slave address
		AXI_WRITE(BASE_ADDR + IIC_ADR_ADDR, iic_slave_addr);
	
		iic_rx_fifo_pirq.Compare_Value		= 4'h_0;
		AXI_WRITE(BASE_ADDR + IIC_RXFIFO_PIRQ_ADDR, iic_rx_fifo_pirq);
		
		// Reset TX_FIFO
		iic_control_register.TX_FIFO_Reset 	= 1'b1;
		AXI_WRITE(BASE_ADDR + IIC_CR_ADDR, 	iic_control_register);
		
		// Enable AXI IIC, remove TX_FIFO reset, disable general call
		iic_control_register.EN 			= 1'b1;
		iic_control_register.TX_FIFO_Reset 	= 1'b0;
		iic_control_register.GC_EN			= 1'b0;	
		AXI_WRITE(BASE_ADDR + IIC_CR_ADDR, 	iic_control_register);
	endtask

	task IIC_WRITE_DATA(logic [31 : 0] BASE_ADDR, logic [6: 0] iic_slave_addr, logic [31: 0] start_addr, logic [7: 0] data [$]);
		
		isr_t				iic_isr;
		tx_fifo_t			iic_txfifo;
		status_register_t   iic_status_register;
		
		iic_status_register		= '0;
		iic_txfifo				= '0;
		iic_isr					= '0;
		
		iic_isr.bus_busy					=  1'b1;
		iic_isr.not_addressed_as_slave 		=  1'b1;
		iic_isr.transmit_FIFO_half_empty 	=  1'b1;
		
		iic_txfifo.Txd						=  {iic_slave_addr, WRITE};
		iic_txfifo.Start					=  1'b1;

		AXI_WRITE(BASE_ADDR + IIC_ISR_ADDR, 		iic_isr);
		AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, 		iic_txfifo);
		
		iic_txfifo.Start					= 1'b0;
		iic_txfifo.Txd						=  start_addr[15:8];
		AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, iic_txfifo);
		
		iic_txfifo.Txd						=  start_addr[7:0];
		AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, iic_txfifo);

		foreach(data[i]) begin
			iic_txfifo.Txd = data[i];
			if (i==(data.size()-1)) iic_txfifo.Stop = 1'b1;
			AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, 		iic_txfifo);
			$display("\n[%t]\t ============ IIC WRITE %h to ADDR %h", $time, data[i], (start_addr+i));
			
			AXI_READ(BASE_ADDR + IIC_SR_ADDR, 			iic_status_register);
			while(iic_status_register.TX_FIFO_Full != 1'b0) begin
				#10_000 AXI_READ(BASE_ADDR + IIC_SR_ADDR, 			iic_status_register);
			end
		end
		
		AXI_READ(BASE_ADDR + IIC_SR_ADDR, 			iic_status_register);
		while(iic_status_register.BB != 1'b0) begin
			#10_000 AXI_READ(BASE_ADDR + IIC_SR_ADDR, 			iic_status_register);
		end
		#500; //delay to allow memory to finish writing
	endtask

	task IIC_READ_DATA(logic [31 : 0] BASE_ADDR, logic [6: 0] iic_slave_addr, logic [31: 0] start_addr, logic [31: 0] n_bytes_to_read, output logic [7: 0] data [$]);
			
			isr_t				iic_isr;
			tx_fifo_t			iic_txfifo;
			status_register_t   iic_status_register;
			
			logic [31:0] tmp_data;
		
			iic_status_register		= '0;
			iic_txfifo				= '0;
			iic_isr					= '0;

		
			// dummy writing with memory address
			iic_txfifo.Start		= 1'b1; // Start and Address
			iic_txfifo.Txd			=  {iic_slave_addr, WRITE};
			AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, 		iic_txfifo);
		
			iic_txfifo.Start		= 1'b0;	
			iic_txfifo.Txd 			= start_addr[15:8]; 
			AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, 		iic_txfifo); // Mem address MSB

			iic_txfifo.Txd 			= start_addr[7:0];
			AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, 		iic_txfifo); // Mem address LSB
		
			// reading 1 byte
			iic_txfifo.Start		= 1'b1; 
			iic_txfifo.Txd			=  {iic_slave_addr, READ};
			AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, 		iic_txfifo);
			
			iic_txfifo.Start		= 1'b0; 
			iic_txfifo.Stop			= 1'b1;
			iic_txfifo.Txd			= n_bytes_to_read[7:0]; // number of bytes to receive

			AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, 		iic_txfifo);
			
			repeat(n_bytes_to_read) begin
				AXI_READ(BASE_ADDR + IIC_SR_ADDR, 		iic_status_register);
				
				while(iic_status_register.RX_FIFO_Empty == 1'b1) begin
					#10_000 AXI_READ(BASE_ADDR + IIC_SR_ADDR, 			iic_status_register);
				end
				
				AXI_READ(BASE_ADDR + IIC_RXFIFO_ADDR, 			tmp_data);
				data.push_back(tmp_data);
				$display("\n[%t]\t ============ IIC READ %h from ADDR %h", $time, tmp_data, ++start_addr);	
			end
			
			while(iic_status_register.BB != 1'b0) begin
				#1_000 AXI_READ(BASE_ADDR + IIC_SR_ADDR, 			iic_status_register);
			end
		endtask

	task IIC_SLAVE_WAIT_RECIEVED_DATA(logic [31 : 0] BASE_ADDR, output logic [7:0] rd_data);

		rx_fifo_pirq_t 		iic_rx_fifo_pirq;
		isr_t				iic_isr;
		tx_fifo_t			iic_txfifo;
		status_register_t   iic_status_register;
		
		logic Stop;
		int count;
		logic [31:0] iic_rd_data;
		
		
		iic_rx_fifo_pirq 		= '0;
		iic_status_register		= '0;
		iic_txfifo				= '0;
		iic_isr					= '0;
		
		iic_received_data.delete();

		count = 0;
		Stop = 0;
		while(!Stop)
			begin
				AXI_READ(BASE_ADDR + IIC_ISR_ADDR,  iic_isr);
				// Read interrupt status register and waiting for addressed_as_slave
				while(iic_isr.addressed_as_slave != 1) begin
					AXI_READ(BASE_ADDR + IIC_ISR_ADDR,  iic_isr);
					#500_000;
				end

				iic_isr                           = '0;
				iic_isr.not_addressed_as_slave    =  1'b1;
				AXI_WRITE(BASE_ADDR + IIC_ISR_ADDR,  iic_isr);
	
				// RX_FIFO_PIRQ
				iic_rx_fifo_pirq                  = 'h_00;
				AXI_WRITE(BASE_ADDR + IIC_RXFIFO_PIRQ_ADDR,  iic_rx_fifo_pirq);
	
				iic_isr                            = '0;
				iic_isr.transmit_FIFO_empty        =  1'b1;
				AXI_WRITE(BASE_ADDR + IIC_ISR_ADDR,  iic_isr);
	
				while(count < N_SENT_BYTES) begin
					AXI_READ(BASE_ADDR + IIC_ISR_ADDR,  iic_isr );
//					$display("iic_isr.receive_FIFO_full %b", iic_isr.receive_FIFO_full);
					if (iic_isr.receive_FIFO_full == 1) begin
						AXI_READ(BASE_ADDR + IIC_RXFIFO_ADDR, iic_rd_data);
						$display("\n[%t]\t ============ IIC DATA RECEIVED 0x%0h", $time, iic_rd_data);
						iic_received_data.push_back(8'(iic_rd_data));
						iic_isr                   = '0;
						iic_isr.receive_FIFO_full =  1'b1;
						AXI_WRITE(BASE_ADDR + IIC_ISR_ADDR,  iic_isr);
						count++;
						Stop = 1;
					#10_000;
				end
				if (iic_isr.not_addressed_as_slave == 1) begin
					// Clear Interrupts
					iic_isr                             = '0;
					iic_isr.addressed_as_slave          = 1;
					iic_isr.transmit_FIFO_empty         = 1;
					AXI_WRITE(BASE_ADDR + IIC_ISR_ADDR,  iic_isr);
				end
				#10_000;
			end
		end
	endtask

	task IIC_SEND_DATA(logic [31 : 0] BASE_ADDR, logic [31: 0] iic_slave_addr, logic [7: 0] data [$]);
		
		control_register_t 	iic_control_register;
		rx_fifo_pirq_t 		iic_rx_fifo_pirq;
		isr_t				iic_isr;
		tx_fifo_t			iic_txfifo;
		status_register_t   iic_status_register;
		
		iic_control_register 	= '0;
		iic_rx_fifo_pirq 		= '0;
		iic_status_register		= '0;
		iic_txfifo				= '0;
		iic_isr					= '0;
		
//		iic_isr 			= 32'h000000D0;
		iic_isr.bus_busy					=  1'b1;
		iic_isr.not_addressed_as_slave 		=  1'b1;
		iic_isr.transmit_FIFO_half_empty 	=  1'b1;
		
//		iic_txfifo 			= 32'h00000068;
		iic_txfifo							=  {iic_slave_addr[31:1], WRITE};
//		iic_rx_fifo_pirq 	= 32'h00000001;
		iic_rx_fifo_pirq.Compare_Value		=  4'b1111;

//		iic_control_register= 32'h0000000D;
		iic_control_register.MSMS			=  1'b1;
		iic_control_register.TX				=  1'b1;
		iic_control_register.EN				=  1'b1;
		iic_control_register.RSTA			=  1'b1;
		AXI_WRITE(BASE_ADDR + IIC_ISR_ADDR, 		iic_isr);
		AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, 		iic_txfifo);
		
		for (int i = 0; i<N_SENT_BYTES; i++) begin
			iic_txfifo.Txd = data[i];
			AXI_WRITE(BASE_ADDR + IIC_TXFIFO_ADDR, 		iic_txfifo);
			$display("\n[%t]\t ============ IIC SENT DATA %h", $time, data[i]);
		end
		
		AXI_WRITE(BASE_ADDR + IIC_RXFIFO_PIRQ_ADDR, iic_rx_fifo_pirq);
		AXI_WRITE(BASE_ADDR + IIC_CR_ADDR, 			iic_control_register);
	endtask
	
	function automatic void fillup_random_data(ref logic [7:0] orig_data[$]);
	    orig_data.delete();
	    repeat(N_SENT_BYTES) begin
	        logic [7:0] rand_data = $urandom_range(0, 255); // Generate random byte data
	        orig_data.push_back(rand_data); // Add the random data to the queue
	    end
	endfunction
	
	function automatic void compare_results(input logic [7:0] sent_data[$], input logic [7:0] received_data[$]);
    int i;
    int diff_count = 0;
    
    if (sent_data.size() != received_data.size()) begin
        $display("\n[%t]\t ============ DATA DOES MATCHED  some transfers are missed", $time);
	    mismatch++;
        return;
    end
    
    for (i = 0; i < sent_data.size(); i++) begin
        if (sent_data[i] !== received_data[i]) begin
            $display("\n[%t]\t ============ DATA NOT MATCHED Element %0d is different: sent_data[%0d] = %h, received_data[%0d] = %h", $time, i, i, sent_data[i], i, received_data[i]);
            diff_count++;
	        mismatch++;
        end
    end
    
    if (diff_count == 0)
        $display("\n[%t]\t ============ DATA MATCHED", $time);
	endfunction
	
endmodule: tb