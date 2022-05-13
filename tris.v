module TRIS (
    inout PORT,
    input DIR,
    input SEND,
    output READ
);
    
assign PORT = DIR ? SEND : 1'bZ; // Se DIR 1 -- copia DHT_OUT PARA SAIDA 
assign READ = DIR ? 1'bz : PORT;
endmodule