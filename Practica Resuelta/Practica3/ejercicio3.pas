program ejercicio3;
const
    valorAlto= '9999';
type
    str20 = String[20];

    novela = record
        cod: integer;
        genero: str20;
        nombre: str20;
        duracion: integer;
        director: str20;
        precio: real;
    end;

    archivo_novelas = file of novela;

    procedure leer(var arch: archivo_novelas; var dato: novela);
    begin
        if (not eof(arch)) then
            read(arch, dato)
        else
            dato.nombre := valorAlto;
    end;

    procedure leerNovela (var n: novela);
    begin
        writeln('Ingrese codigo (-1 para terminar)'); readln(n.cod);
        if (n.cod <> -1) then begin
            writeln('Ingrese genero'); readln(n.genero);
            writeln('Ingrese nombre'); readln(n.nombre);
            writeln('Ingrese duracion'); readln(n.duracion);
            writeln('Ingrese director'); readln(n.director);
            writeln('Ingrese precio'); readln(n.precio);
        end;
    end;
    
    //A
    procedure cargarArchivo(var arch: archivo_novelas);
    var
        reg: novela;
    begin
        rewrite(arch);
        reg.cod:= 0; //no se si debo cargar los otros campos o es correcto q queden en valores nulos
        write(arch, reg);

        leerNovela(reg);
        while(reg.cod <> -1) do begin
            write(arch, reg);
            leerNovela(reg);
        end;

        close(arch);
    end;

    // B) i
    procedure agregarNovela(var arch: archivo_novelas);
    var
        regNuevo, reg: novela;
        posBorrada: integer;
    begin
        reset(arch);
        read(arch, reg);  // Leo la cabecera

        leerNovela(regNuevo);

        if (reg.cod < 0) then begin
            posBorrada := -reg.cod;

            // Leo el registro borrado que será el nuevo cabecera
            seek(arch, posBorrada);
            read(arch, reg);

            // Escribo el nuevo registro en la posición libre
            seek(arch, posBorrada);
            write(arch, regNuevo);

            // Actualizo la cabecera
            seek(arch, 0);
            write(arch, reg);
        end
        else begin
            seek(arch, FileSize(arch));
            write(arch, regNuevo);
        end;

        close(arch);
    end;
    
    // B) ii
    procedure modificarNovela(var arch: archivo_novelas);
    var
        reg: novela;
        opcion: byte;
        encontre: boolean;
        nuevoStr: str20;
        nuevaDuracion: integer;
        nuevoPrecio: real;
        cod: integer;
    begin
        reset(arch);

        writeln('Ingrese codigo de la novela a modificar');
        read(cod);

        encontre := false;
        while not eof(arch) and not(encontre) do begin
            read(arch, reg);
            if (reg.cod > 0) and (reg.cod = cod) then begin
                encontre:= true;
            end;
        end;
        
        if (encontre) then begin
            writeln('Ingrese la opcion de que campo de la novela quiere modificar:');
            writeln('1. Genero (String)');
            writeln('2. nombre (String)');
            writeln('3. duracion (real)');
            writeln('4. director (String)');
            writeln('5. Precio (Real)');
            readln(opcion);

            seek(arch, FilePos(arch) - 1);
            case opcion of
                1: begin writeln('Nuevo genero:'); readln(nuevoStr); reg.genero := nuevoStr; end;
                2: begin writeln('Nuevo nombre:'); readln(nuevoStr); reg.nombre := nuevoStr; end;
                3: begin writeln('Nueva duracion:'); readln(nuevaDuracion); reg.duracion := nuevaDuracion; end;
                4: begin writeln('Nuevo director:'); readln(nuevoStr); reg.director := nuevoStr; end;
                5: begin writeln('Nuevo precio:'); readln(nuevoPrecio); reg.precio := nuevoPrecio; end;
           end;
           write(arch, reg);
        end
        else
            writeln('No se encontro la novela con ese codigo.');

        close(arch);
    end;

    // B) iii
    procedure eliminarNovela(var arch: archivo_novelas);
    var
        reg, regCabezera: novela;
        cod, posEliminar: integer;
        encontre: boolean;
    begin
        reset(arch);
        writeln('Ingrese el codigo de novela a eliminar');
        read(cod);
        encontre:= false;

        while not eof(arch) and not(encontre) do begin
            read(arch, reg);
            if (reg.cod > 0) and (reg.cod = cod) then begin
                encontre:= true;
            end;
        end;

        if (encontre) then begin
            // me guardo la posicion a eliminar
            posEliminar := (FilePos(arch) - 1);

            //modifico el codigo del registro a eliminar con su posicion negativa
            reg.cod := -posEliminar;

            // me posiciono en el registro cabezera y lo guardo 
            seek(arch, 0);
            read(arch, regCabezera);
            
            //me posiciono en el registro a eliminar para colocar el registro antiguo del cabezera
            seek(arch, posEliminar);
            write(arch, regCabezera);

            //guardo el registro a eliminar en el registro cabezera
            seek(arch, 0);
            write(arch, reg);

            writeln('Se ha eliminado con exito la novela con codigo: ', cod);
        end
        else 
            writeln('No se encontro el codigo de novela');

        close(arch);
    end;

    // C
    procedure listarNovelas(var arch: archivo_novelas);
    var
        txt: Text;
        reg: novela;
    begin
        reset(arch);
        assign(txt, 'novelas.txt');
        rewrite(txt);

        writeln(txt, '|   Cod   |      Genero      |       Nombre       | Duracion |     Director      | Precio |');
        writeln(txt, '--------------------------------------------------------------------------------------------');

        while not eof(arch) do begin
            read(arch, reg);
            writeln(txt, '| ', reg.cod, ' | ', 
                        reg.genero, ' | ', 
                        reg.nombre, ' | ',
                        reg.duracion, ' | ',
                        reg.director, ' | ',
                        reg.precio, ' |');
        end;

        close(arch);
        close(txt);
    end;  

    procedure opcionesMantenimiento(var arch: archivo_novelas);
    var
        opcion: byte;
    begin
        repeat
            writeln('Ingrese el numero de operacion de mantenimiento que desea realizar');
            writeln('1. Agregar novela');
            writeln('2. Modificar novela');
            writeln('3. Eliminar novela');
            writeln('4. Volver');

            read(opcion);
            case opcion of 
                1: agregarNovela(arch);
                2: modificarNovela(arch);
                3: eliminarNovela(arch);
            end;
        until (opcion = 4);
        
    end;

    procedure opcionesGeneral(var arch: archivo_novelas);
    var
        opcion: byte;
    begin
         repeat
            writeln('Ingrese el numero de operacion que desea realizar');
            writeln('1. Cargar archivo');
            writeln('2. Opciones de mantenimiento');
            writeln('3. Listar todas las novelas');
            writeln('4. Finalizar');

            read(opcion);
            case opcion of 
                1: cargarArchivo(arch);
                2: opcionesMantenimiento(arch);
                3: listarNovelas(arch);
                4: writeln('adios!');
            end;
        until (opcion = 4);
    end;

var
    arch: archivo_novelas;
    nombre_fisico: String;
    opcion: byte;
begin
    writeln('ingrese el nombre que desea ponerle al archivo');
    read(nombre_fisico);
    assign(arch, nombre_fisico);
    opcionesGeneral(arch);   
end.