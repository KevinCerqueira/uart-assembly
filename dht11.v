module DHT11 (
    input CLK,
    input EN,
    input RST,
    inout DHT_DATA, //pino Tristate
    output [7:0] HUM_INT,
    output [7:0] HUM_FLOAT,
    output [7:0] TEMP_INT,
    output [7:0] TEMP_FLOAT,
    output [7:0] CRC,
    output WAIT, // avisa quando o circuito está operando esperando um retorno
    output DEBUG //realização de testes osciloscopio
   // output error
);

reg DHT_OUT, DIR, WAIT_REG, DEBUG_REG; //Registrador de saída (dir altera o estado de saida ou entrada)
reg [25:0] COUNTER; //contador de ciclos de clock pra delay (18ms de resposta)
reg [5:0] INDEX;
reg [39:0] INTDATA; //registrador pra armzazenar dados do dht internamente
reg error;
wire DHT_IN;

assign WAIT = WAIT_REG;
assign DEBUG = DEBUG_REG;

//TRIS TRIS_DATA(
//    .PORT(DMT_DATA),
//    .DIR(DIR),
//    .SEND(DHT_OUT),
//    .READ(DHT_IN)
//);

assign HUM_INT[7] = INTDATA[0];
assign HUM_INT[6] = INTDATA[1];
assign HUM_INT[5] = INTDATA[2];
assign HUM_INT[4] = INTDATA[3];
assign HUM_INT[3] = INTDATA[4];
assign HUM_INT[2] = INTDATA[5];
assign HUM_INT[1] = INTDATA[6];
assign HUM_INT[0] = INTDATA[7];

assign HUM_FLOAT[7] = INTDATA[8];
assign HUM_FLOAT[6] = INTDATA[9];
assign HUM_FLOAT[5] = INTDATA[10];
assign HUM_FLOAT[4] = INTDATA[11];
assign HUM_FLOAT[3] = INTDATA[12];
assign HUM_FLOAT[2] = INTDATA[13];
assign HUM_FLOAT[1] = INTDATA[14];
assign HUM_FLOAT[0] = INTDATA[15];

assign TEMP_INT[7] = INTDATA[16];
assign TEMP_INT[6] = INTDATA[17];
assign TEMP_INT[5] = INTDATA[18];
assign TEMP_INT[4] = INTDATA[19];
assign TEMP_INT[3] = INTDATA[20];
assign TEMP_INT[2] = INTDATA[21];
assign TEMP_INT[1] = INTDATA[22];
assign TEMP_INT[0] = INTDATA[23];

assign TEMP_FLOAT[7] = INTDATA[24];
assign TEMP_FLOAT[6] = INTDATA[25];
assign TEMP_FLOAT[5] = INTDATA[26];
assign TEMP_FLOAT[4] = INTDATA[27];
assign TEMP_FLOAT[3] = INTDATA[28];
assign TEMP_FLOAT[2] = INTDATA[29];
assign TEMP_FLOAT[1] = INTDATA[30];
assign TEMP_FLOAT[0] = INTDATA[31];

assign CRC[7] = INTDATA[32];
assign CRC[6] = INTDATA[33];
assign CRC[5] = INTDATA[34];
assign CRC[4] = INTDATA[35];
assign CRC[3] = INTDATA[36];
assign CRC[2] = INTDATA[37];
assign CRC[1] = INTDATA[38];
assign CRC[0] = INTDATA[39];

reg [3:0] STATE; // Máquina de estados

//Definição de estados
parameter S0=1,S1=2,S2=3,S3=4,S4=5,S5=6,S6=7, S7=8, S8=9, S9=10, STOP=0, START=11;

always @(posedge CLK) 
begin: FSM
    if (EN == 1'b1) 
    begin
        if(RST == 1'b1)
        begin
            DHT_OUT <= 1'b1;
            WAIT_REG <= 1'b0;
            COUNTER <= 26'b00000000000000000000000000;
            INTDATA <= 40'b0000000000000000000000000000000000000000;
            DIR <= 1'b1;
            error <= 1'b0;
            STATE <= START;
        end else begin

            case (STATE)
                START: 
                    begin
                        WAIT_REG <= 1'b1;
                        DIR <= 1'b1;
                        DHT_OUT <= 1'b1;
                        STATE <= S0;
                    end
                
                S0:
                    begin
                        DIR <= 1'b1;
                        DHT_OUT <= 1'b1; 
                        WAIT_REG <= 1'b1; 
                        error <= 1'b0;
                        if (COUNTER < 1800000) 
                        begin
                            COUNTER <= COUNTER +1'b1;    
                        end else begin
                            COUNTER<=26'b00000000000000000000000000;
                            STATE <= S1;
                        end
                    end
                S1:
                    begin
                        DHT_OUT <= 1'b0; 
                        WAIT_REG <= 1'b1; 
        
                        if (COUNTER < 1800000) 
                        begin
                            COUNTER <= COUNTER +1'b1;    
                        end else begin
                            COUNTER<=26'b00000000000000000000000000;
                            STATE <= S2;
                        end
                    end

                S2:
                    begin
                        DHT_OUT <= 1'b1; 
                
        
                        if (COUNTER < 20000) 
                        begin
                            COUNTER <= COUNTER +1'b1;    
                        end else begin
                            DIR <= 1'b0;
                            STATE <= S3;
                        end
                    end

                S3:
                    begin
                        if (COUNTER < 6000 && DHT_IN == 1'b1)
                        begin
                            COUNTER <= COUNTER +1'b1;
                            STATE<=S3;    
                        end else begin
                            if (DHT_IN == 1'b1) 
                            begin
                                error <= 1'b1;
                                COUNTER<= 26'b00000000000000000000000000;
                                STATE<=S4;
                            end
                        end
                    end

                S4:
                    begin
                        if (COUNTER < 8800 && DHT_IN == 1'b0)
                        begin
                            COUNTER <= COUNTER +1'b1;
                            STATE<=S4;    
                        end else begin
                            if (DHT_IN == 1'b0) 
                            begin
                                error <= 1'b1;
                                COUNTER<= 26'b00000000000000000000000000;
                                STATE<=S5;
                            end else begin
                                STATE<=S5;
                                COUNTER<= 26'b00000000000000000000000000;
                            end
                        end
                    end

                S5:
                    begin
                        if (COUNTER < 8800 && DHT_IN == 1'b1)
                        begin
                            COUNTER <= COUNTER +1'b1;
                            STATE<=S5;    
                        end else begin
                            if (DHT_IN == 1'b1) 
                            begin
                                error <= 1'b1;
                                COUNTER<= 26'b00000000000000000000000000;
                                STATE<=STOP;
                            end else begin
                                STATE<=S6;
                                COUNTER<= 26'b00000000000000000000000000;
                            end
                        end
                    end

                S6:
                    begin
                        if (DHT_IN == 1'b0)
                        begin

                            STATE<=S7;    
                        end else begin
                                error <= 1'b1;
                                COUNTER<= 26'b00000000000000000000000000;
                                STATE<=STOP;
                            end
                    end

                S7:
                    begin
                        if (DHT_IN == 1'b1)
                        begin
                            COUNTER<= 26'b00000000000000000000000000;
                            STATE<=S8;    
                        end else begin
                                if (COUNTER<3200000)
                                begin
                                    COUNTER<=COUNTER+1'b1;
                                    STATE<=S7;    
                                end else begin
                                    COUNTER<= 26'b00000000000000000000000000;
                                    error <= 1'b1;
                                    STATE<=STOP;    
                                end 
                            end
                    end

                S8:
                    begin
                        if (DHT_IN == 1'b0)
                        begin
                            if (COUNTER>5000)
                            begin
                              INTDATA[INDEX]<=1'b1;
                              DEBUG_REG<=1'b1;  
                            end else begin
                              INTDATA[INDEX]<=1'b0;
                              DEBUG_REG<=1'b0;  
                            end
                            if (INDEX<39) 
                            begin
                                COUNTER<= 26'b00000000000000000000000000;
                                STATE<=S9;
                            end else begin
                                error <= 1'b0;
                                STATE<=STOP;  
                            end  
                        end else begin
                            COUNTER<=COUNTER+1'b1;
                            if (COUNTER>3200000) 
                            begin
                               error <= 1'b0;
                               STATE<=STOP; 
                            end
                                   
                            end
                    end

                S9:
                    begin
                        INDEX<=INDEX+1'b1;
                        STATE <= S6;
                    end

                STOP: 
                    begin
                        STATE<=STOP;
                        if (error == 1'b0)
                        begin
                            DHT_OUT<=1'b1;
                            WAIT_REG<=1'b0;
                            COUNTER<= 26'b00000000000000000000000000;
                            DIR<=1'b1;
                            error<= 1'b0;
                            INDEX<= 6'b000000;  
                            end else begin
                                if (COUNTER<3200000) 
                                begin
                                    INTDATA<=40'b0000000000000000000000000000000000000000;
                                    COUNTER<=COUNTER+1'b1;
                                    error<=1'b1;
                                    WAIT_REG<=1'b1;
                                    DIR<=1'b0;
                                end else begin
                                    error<=1'b0;
                                end    
                            end  
                        end 

            endcase
    end
    
end
end

endmodule
