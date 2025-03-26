program ejercicio5;
type
    registroCelulares = record
         cod: integer;
         nombre: String;
         descripcion: String;
         marca: String;
         precio: real;
         stockMin: integer;
         stock: integer;
        end;
    archivo_celulares = file of registroCelulares;


procedure imprimirCelular(cel: registroCelulares);
begin
    writeln('Codigo: ', cel.cod);
    writeln('Nombre: ', cel.nombre);
    writeln('Descripcion: ', cel.descripcion);
    writeln('Marca: ', cel.marca);
    writeln('Precio: ', cel.precio:0:2);
    writeln('Stock minimo: ', cel.stockMin);
    writeln('Stock disponible: ', cel.stock);
    writeln('------------------------');
end;

// A
procedure crearArchivo (var celulares: archivo_celulares; var carga: Text);
var 
    cel: registroCelulares;
    nombreFisico: String;
begin
    writeln('Ingrese nombre del archivo: ');
    readln(nombreFisico);
    assign(celulares, nombreFisico);
    rewrite(celulares);

    reset(carga);
    while (not EOF(carga)) do begin
       with cel do begin
             readln(cod, precio, marca);
             readln(stock, stockMin, descripcion);
             readln(nombre);
       end;
       write(celulares, cel);
    end;
    close(celulares);
    close(carga);
end;

//B
procedure listarCelularesMenosStock(var celulares: archivo_celulares);
var
     cel: registroCelulares;
begin
     reset(celulares);
     writeln('Los celulares con stock menor al stock minimo son: ');
     while(not EOF(celulares)) do begin
          read(celulares, cel);
          if (cel.stock < cel.stockMin) then 
             imprimirCelular(cel);
     end;
     close(celulares);
end;

//C
procedure listarCelularesMismaDescripcion (var celulares: archivo_celulares);
var
     cel: registroCelulares;
     cadena: String;
begin
     reset(celulares);
     writeln('Ingrese una descripcion');
     readln(cadena);
     writeln('Los celulares cuya descripcion es ', cadena, ' son:');
     while(not EOF(celulares)) do begin
        read(celulares, cel);
        if (cel.descripcion = cadena) then
            imprimirCelular(cel);        
     end;
     close(celulares);
end;

//D
procedure exportarArchivo(var celulares: archivo_celulares; var carga: Text);
var
    cel: registroCelulares;

begin
    reset (celulares);
    rewrite(carga);
    while (not EOF(celulares)) do begin
        read(celulares, cel);
        with cel do begin
            writeln(carga, cod, precio, marca);
            writeln(carga, stock, stockMin, descripcion);
            writeln(carga, nombre);
        end;
    end;
    close(celulares);
    close(carga);
end;

var
    carga: Text;
    celulares: archivo_celulares;
    opcion: Byte;
begin
    assign(carga, 'celulares.text');
    rewrite(carga);
    repeat 
         writeln('Opciones: ');
         writeln('0: Salir.');
         writeln('1: Crear archivo de celulares.');
         writeln('2: Ver los celulares con un stock menor al minimo.');
         writeln('3: Ver los celulares que coincidan con determinada cadena.');
         writeln('4: Exportar el archivo binario creado en 1 a archivo de texto.');
         writeln('Ingrese el numero de opcion: ');
         readln(opcion);

        case opcion of 
             0: writeln('Adios!');
             1: crearArchivo(celulares, carga);
             2: listarCelularesMenosStock(celulares);
             3: listarCelularesMismaDescripcion(celulares);
             4: exportarArchivo(celulares, carga);
        end;
    until (opcion = 0);
   
end.