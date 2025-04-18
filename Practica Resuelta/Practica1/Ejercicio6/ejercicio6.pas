program ejercicio6;
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


procedure leer(var cel: registroCelulares);
begin
    write('Ingrese codigo: '); readln(cel.cod);
    if (cel.cod <> 0) then begin
        write('Ingrese nombre: '); readln(cel.nombre);
        write('Ingrese descripción: '); readln(cel.descripcion);
        write('Ingrese marca: '); readln(cel.marca);
        write('Ingrese precio: '); readln(cel.precio);
        write('Ingrese stock mínimo: '); readln(cel.stockMin);
        write('Ingrese stock disponible: '); readln(cel.stock);
    end;
    
end;

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
            writeln(carga, cod, precio:0:1, marca);
            writeln(carga, stock, stockMin, descripcion);
            writeln(carga, nombre);
        end;
    end;
    close(celulares);
    close(carga);
end;

// -----------------EJ6----------------------
//A
procedure agregarCelular (var celulares: archivo_celulares) ;
var
    cel: registroCelulares;
begin
    reset(celulares);
    writeln('Ingrese los datos de los celulares a agregar (0 en codigos para finalizar): ');
    leer(cel);
    //me posiciono al final del archivo
    seek(celulares, FilePos(celulares));
    while (cel.cod <> 0) do begin
        write(celulares, cel);
        leer(cel);
    end;
    close(celulares);
end;

//B
procedure modificarStock(var celulares: archivo_celulares);
var
    cel: registroCelulares;
    nombre: String;
    existe: boolean;
    stock: integer;
begin
    reset(celulares);
    writeln('Ingrese nombre del celular a modificar el stock: ');
    readln(nombre);
    existe:= false;
    while (not EOF(celulares)) and (not existe) do begin
        read(celulares, cel);
        if (cel.nombre = nombre) then begin
            writeln('Ingrese el nuevo stock: '); readln(stock);
            seek(celulares, FilePos(celulares) - 1);
            cel.stock:= stock;
            write(celulares, cel);
            existe:= true;
        end;
    end;      
    close(celulares);
end;

//C
procedure exportarArchivoCeluSinStock(var celulares: archivo_celulares);
var
    arch_texto: Text;
    cel: registroCelulares;
begin
    reset(celulares);
    assign(arch_texto, 'SinStock.txt');
    rewrite(arch_texto);
    while (not EOF(celulares)) do begin
        read(celulares, cel);
        if (cel.stock = 0) then
           with cel do begin
                 writeln(arch_texto, cod, ' ', precio:0:1, ' ', marca);
                 writeln(arch_texto, stock, ' ', stockMin, ' ', descripcion);
                 writeln(arch_texto, nombre);
             end;
    end;
    close(arch_texto);
    close(celulares);
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
         writeln('5: Agregar celular.');
         writeln('6: Modificar el stock de un celular.');
         writeln('7: Exportar el contenido del archivo binario a un archivo de texto con aquellos celulares que tengan stock 0.');
         writeln('Ingrese el numero de opcion: ');
         readln(opcion);

        case opcion of 
             0: writeln('Adios!');
             1: crearArchivo(celulares, carga);
             2: listarCelularesMenosStock(celulares);
             3: listarCelularesMismaDescripcion(celulares);
             4: exportarArchivo(celulares, carga);
             5: agregarCelular(celulares);
             6: modificarStock(celulares);
             7: exportarArchivoCeluSinStock(celulares);
        end;
    until (opcion = 0);
end.